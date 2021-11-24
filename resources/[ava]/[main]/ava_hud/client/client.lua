-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local PlayerData = nil
local isBigmapOn = false

local vehiclesCars = {0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 17, 18, 20};
-- 0 is on foot
-- 7 is super
-- 8 is motorcycle
-- 19 is tank

local DiffTrigger = 0.355
local MinSpeed = 60.0 -- kmh
local speedBuffer = {}
local velBuffer = {}
local beltOn = false
local wasInCar = false

Citizen.CreateThread(function()
    PlayerData = exports.ava_core:getPlayerData()

    InitHUD()
    SendNUIMessage({action = "toggleMainStats", show = true})
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        PlayerData[k] = v
        if k == "jobs" then
            SendNUIMessage({action = "setJobs", jobs = PlayerData.jobs})
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
    InitHUD()
end)

function InitHUD()
    SendNUIMessage({action = "setJobs", jobs = PlayerData.jobs})
end

AddEventHandler("ava_hud:client:updateStatus", function(name, percent)
    SendNUIMessage({action = "updateStatus", name = name, percent = percent})
end)

RegisterNetEvent("ava_hud:client:toggle", function(show)
    SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent("ava_hud:client:togglePlayerStats", function(show)
    SendNUIMessage({action = "togglePlayerStats", show = show})
end)

RegisterNetEvent("ava_core:client:editItemInventoryCount", function(itemName, itemLabel, isAddition, editedQuantity, newQuantity)
    SendNUIMessage({action = "itemNotification", add = isAddition, label = itemLabel, count = editedQuantity})
end)

function copyToClipboard(content)
    SendNUIMessage({action = "copyToClipboard", content = content})
end

local lastToggleMainStats = 0
local toggleMainStatsKeyPressed = false
RegisterCommand("+keyToggleMainStats", function()
    toggleMainStatsKeyPressed = true
    Wait(100)
    -- only show if the key has been pressed for more than 150ms
    if toggleMainStatsKeyPressed then
        SendNUIMessage({action = "toggleMainStats", show = true})
    end
end, false)

RegisterCommand("-keyToggleMainStats", function()
    toggleMainStatsKeyPressed = false
    local timer = GetGameTimer()
    if math.abs(timer - lastToggleMainStats) < 250 then
        isBigmapOn = not isBigmapOn
        SetBigmapActive(isBigmapOn, false)
        SendNUIMessage({action = "isBigmapOn", toggle = isBigmapOn})
    end
    lastToggleMainStats = timer
    Wait(300)
    SendNUIMessage({action = "toggleMainStats", show = false})
end, false)

RegisterKeyMapping("+keyToggleMainStats", GetString("hud_details_key"), "keyboard", "Z")

----------------------------------------------------------
------------ Change some hud colors and texts ------------
----------------------------------------------------------
Citizen.CreateThread(function()
    ReplaceHudColour(116, 15)

    AddTextEntry("PM_PANE_LEAVE", GetString("PM_PANE_LEAVE"))
    AddTextEntry("PM_PANE_QUIT", GetString("PM_PANE_QUIT"))

    -- AddTextEntry('FE_THDR_GTAO', "~o~Adezou RôlePlay~s~ | ID: ~o~".. GetPlayerServerId(PlayerId()) .."~s~")
end)

----------------------------------------------------
------------ Edit some pause menu texts ------------
----------------------------------------------------
local function SetPauseMenuTitle()
    -- mandatory wait!
    Wait(0)
    -- Ask for subtitle
    BeginScaleformMovieMethodOnFrontendHeader("SHIFT_CORONA_DESC")
    PushScaleformMovieFunctionParameterBool(true)
    PushScaleformMovieFunctionParameterBool(true)
    PopScaleformMovieFunction()

    -- title
    BeginScaleformMovieMethodOnFrontendHeader("SET_HEADER_TITLE")
    PushScaleformMovieFunctionParameterString(GetString("pausemenu_title", tostring(GetPlayerServerId(PlayerId()))))
    PushScaleformMovieFunctionParameterBool(true)

    -- subtitle
    PushScaleformMovieFunctionParameterString(GetString("pausemenu_subtitle"))
    PushScaleformMovieFunctionParameterBool(true)
    PopScaleformMovieFunctionVoid()

    EndScaleformMovieMethod()
end

-- clause menu when active
Citizen.CreateThread(function()
    local isPauseMenu = false
    while true do
        Wait(0)

        if IsPauseMenuActive() then
            if not isPauseMenu then
                isPauseMenu = true
                SetPauseMenuTitle()
                SendNUIMessage({action = "toggle", show = false})
            end
        else
            if isPauseMenu then
                isPauseMenu = false
                SendNUIMessage({action = "toggle", show = true})
            end

            HideHudComponentThisFrame(1) -- Wanted Stars
            HideHudComponentThisFrame(2) -- Weapon Icon
            HideHudComponentThisFrame(3) -- Cash
            HideHudComponentThisFrame(4) -- MP Cash
            -- HideHudComponentThisFrame(6)  -- Vehicle Name
            HideHudComponentThisFrame(7) -- Area Name
            HideHudComponentThisFrame(8) -- Vehicle Class
            -- HideHudComponentThisFrame(9)  -- Street Name
            HideHudComponentThisFrame(13) -- Cash Change
            HideHudComponentThisFrame(17) -- Save Game
            HideHudComponentThisFrame(20) -- Weapon Stats

            if beltOn then
                DisableControlAction(0, 75, true) -- Disable exit vehicle when stop
                DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
            end
        end
    end
end)

------------------------
------ Car things ------
------------------------
local shockScreenTimer = 0
local function SetShockScreen(duration)
    local gameTimer = GetGameTimer()
    -- GetGameTimer() + 10 because the while loop uses 10ms
    if shockScreenTimer > (gameTimer + 10) then
        shockScreenTimer = shockScreenTimer + duration
        return
    end
    shockScreenTimer = gameTimer + duration

    Citizen.CreateThread(function()
        AnimpostfxPlay("MP_Celeb_Lose", duration, true)
        ShakeGameplayCam("DRUNK_SHAKE", 3.0)
        while shockScreenTimer > GetGameTimer() do
            Wait(10)
        end
        StopGameplayCamShaking(true)
        AnimpostfxStop("MP_Celeb_Lose")
    end)
end

local vehiclePlayerIsIn = 0
Citizen.CreateThread(function()
    while true do
        Wait(100)
        vehiclePlayerIsIn = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehiclePlayerIsIn ~= 0 then
            -- Speed
            carSpeed = math.ceil(GetEntitySpeed(vehiclePlayerIsIn) * 3.6)
            fuel = GetVehicleFuelLevel(vehiclePlayerIsIn)
            SendNUIMessage({action = "showcarhud", showhud = true, speed = carSpeed, fuel = fuel})

            SendNUIMessage({action = "setbelt", isAccepted = has_value(vehiclesCars, GetVehicleClass(vehiclePlayerIsIn)), belt = beltOn})
        else
            SendNUIMessage({action = "showcarhud", showhud = false})
            beltOn = false
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    Wait(500)
    while true do
        if vehiclePlayerIsIn ~= 0 and (wasInCar or has_value(vehiclesCars, GetVehicleClass(vehiclePlayerIsIn))) then
            local ped = PlayerPedId()

            wasInCar = true

            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(vehiclePlayerIsIn)

            if speedBuffer[2] ~= nil and speedBuffer[2] > (MinSpeed / 3.5) and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * DiffTrigger) then
                if not beltOn and GetEntitySpeedVector(vehiclePlayerIsIn, true).y > 1.0 and not IsScreenFadingOut() and not IsScreenFadedOut() then
                    local co = GetEntityCoords(ped)
                    SetEntityCoords(ped, co.x, co.y, co.z - 0.47, true, true, true)
                    SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    Wait(1)
                    SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                    -- TODO break windshield
                elseif GetPedInVehicleSeat(vehiclePlayerIsIn, -1) == ped then
                    SetShockScreen(5000)
                end
            end

            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(vehiclePlayerIsIn)
        elseif wasInCar then
            wasInCar = false
            beltOn = false
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
        end
        Wait(100)
    end
end)

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- KEYMAPPING
RegisterCommand("keyToggleBelt", function()
    local ped = PlayerPedId()
    if (IsPedInAnyVehicle(ped)) then
        local car = GetVehiclePedIsIn(ped, false)
        local isAccepted = has_value(vehiclesCars, GetVehicleClass(car))
        if car and isAccepted then
            beltOn = not beltOn
            SendNUIMessage({action = "setbelt", isAccepted = isAccepted, belt = beltOn})
        end
    end
end, false)

RegisterKeyMapping("keyToggleBelt", GetString("seatbelt"), "keyboard", "X")
