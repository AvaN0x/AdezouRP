-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
IsDead = false

local function RespawnPlayer(coords, heading)
    local playerPed = PlayerPedId()
    SetEntityCoordsNoOffset(playerPed, coords, false, false, false, true)
    NetworkResurrectLocalPlayer(coords, 0.0, true, false)
    SetPlayerInvincible(playerPed, false)
    ClearPedBloodDamage(playerPed)
    TriggerEvent("playerSpawned", {x = coords.x + 0.0, y = coords.y + 0.0, z = coords.z + 0.0, heading = heading + 0.0})
    TriggerEvent("ava_core:client:playerRevived")

    SetEntityHealth(playerPed, 105)
end

AddEventHandler("ava_core:client:playerRevived", function()
    IsDead = false
end)

AddEventHandler("ava_core:client:playerDeath", function()
    IsDead = true
    onDeath()
end)

-- DEBUG COMMAND
RegisterCommand("revive", function()
    DoScreenFadeOut(800)
    Wait(800)

    RenderScriptCams(false, false, 0, true, true)
    DestroyAllCams(true)

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    RespawnPlayer(coords, 0.0)
    StopScreenEffect("DeathFailOut")
    StopAudioScene("DEATH_SCENE")

    DoScreenFadeIn(800)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and IsDead then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        RespawnPlayer(coords, 0.0)
        StopScreenEffect("DeathFailOut")
        StopAudioScene("DEATH_SCENE")
    end
end)

local function getClosestHospital()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local closest, closestDistance = nil, nil

    for k, v in ipairs(AVAConfig.RespawnPoints) do
        local distance = #(coords - v.Coord)
        if not closestDistance or distance < closestDistance then
            closestDistance = distance
            closest = v
        end
    end
    return closest
end

local function setCamAbove()
    local playerPed = PlayerPedId()
    local coord = GetEntityCoords(playerPed)
    local rotation = GetEntityRotation(playerPed)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord.x, coord.y, coord.z + 7.5, -90.0, 0.0, rotation.z + 180.0, 25.0)
    AttachCamToEntity(cam, playerPed, 0.0, 0.0, 7.5, false)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 2000, true, true)
end

function onDeath()
    TriggerEvent("RageUI.CloseAll")

    local secondsLeft = AVAConfig.DeadScreenMaxDuration
    Citizen.CreateThread(function()
        while secondsLeft > 0 do
            Wait(1000)
            secondsLeft = secondsLeft - 1
        end
    end)

    -- Disable all sounds around
    StartAudioScene("DEATH_SCENE")

    -- PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds", 1)
    -- PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
    -- PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1) -- Does not seem to work
    PlaySoundFrontend(-1, "MP_Flash", "WastedSounds", 1)
    -- PlaySoundFrontend(-1, "MP_Impact", "WastedSounds", 1) -- Does not seem to work
    StartScreenEffect("DeathFailOut", AVAConfig.DeadScreenMaxDuration * 1000, false)

    SetTimeout(500, setCamAbove)

    Citizen.CreateThread(function()
        -- Freemode message
        local scaleform = exports.ava_core:ShowFreemodeMessage(GetString("dead_message_title"), GetString("dead_message_subtitle"), true)
        local instructionalButtons = exports.ava_core:GetScaleformInstructionalButtons({
            {control = "~INPUT_PICKUP~", label = GetString("button_respawn")},
            {control = "~INPUT_DETONATE~", label = GetString("button_call_ems")},
        })
        -- INPUT_PICKUP 38
        -- INPUT_DETONATE 47
        while secondsLeft > 0 and IsDead do
            Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)

            SetTextColour(255, 255, 255, 255)
            SetTextFont(0)
            SetTextScale(0.34, 0.34)
            SetTextRightJustify(true)
            SetTextWrap(0.80, 0.98)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(GetString("dead_time_left", math.floor(secondsLeft / 60), secondsLeft % 60))
            DrawText(0.80, 0.92)

            DisableAllControlActions(0)
            EnableControlAction(0, 245, true) -- T
            EnableControlAction(0, 213, true) -- HOME

            if IsDisabledControlJustPressed(0, 38)
                and exports.ava_core:ShowConfirmationMessage(GetString("confirm_respawn_title"), GetString("confirm_respawn_firstline"),
                    GetString("confirm_respawn_secondline")) then
                RevivePlayer(true)
                break
            elseif IsDisabledControlJustPressed(0, 47) then
                -- TODO call and set a timer for next call
            end
        end
        SetScaleformMovieAsNoLongerNeeded(scaleform)
        SetScaleformMovieAsNoLongerNeeded(GetScaleformInstructionalButtons)
        exports.ava_core:ForceHideConfirmationMessage()
        if IsDead then
            RevivePlayer(true)
        end
        secondsLeft = 0
    end)
end

function RevivePlayer(atHospital)
    -- Respawn player
    DoScreenFadeOut(800)
    Wait(800)

    -- Enable all sounds around
    StopAudioScene("DEATH_SCENE")
    -- Bring back normal camera
    RenderScriptCams(false, false, 0, true, true)
    DestroyAllCams(true)

    if atHospital then
        local hospital = getClosestHospital()
        RespawnPlayer(hospital.Coord, hospital.Heading)
    else
        RespawnPlayer(GetEntityCoords(PlayerPedId()), 0.0)
    end

    StopScreenEffect("DeathFailOut")
    DoScreenFadeIn(800)
end

