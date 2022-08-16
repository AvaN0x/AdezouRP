-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
----------------------------------------
--------------- SPECTATE ---------------
----------------------------------------
local spectatedPed = nil
local lastPlayerCoords = nil
local isSpectating = false
local isTryingToSpectating = false

---@type function
local setSpectateThread

RegisterNetEvent("ava_personalmenu:client:cancelSpectate", function()
    if isSpectating or isTryingToSpectating then
        local playerPed = PlayerPedId()

        -- Fade out
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Wait(0)
        end
        -- Set player coords
        if lastPlayerCoords then
            SetEntityCoords(playerPed, lastPlayerCoords.x, lastPlayerCoords.y, lastPlayerCoords.z)
        end
        if spectatedPed then
            NetworkSetInSpectatorMode(false, spectatedPed)
        end

        FreezeEntityPosition(playerPed, false)
        SetEntityVisible(playerPed, true, 0)

        -- fade in
        DoScreenFadeIn(500)

        -- Reset vars
        spectatedPed = nil
        isSpectating = false
        lastPlayerCoords = nil
        isTryingToSpectating = false
    end
end)

RegisterNetEvent("ava_personalmenu:client:spectate", function(targetServerId, targetCoords)
    if isTryingToSpectating then
        return
    end
    isTryingToSpectating = true
    local playerPed = PlayerPedId()

    targetServerId = tonumber(targetServerId)

    -- Fade out
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    -- Init if was not already spectating
    if not isSpectating then
        lastPlayerCoords = GetEntityCoords(playerPed)
        FreezeEntityPosition(playerPed, true)
        SetEntityVisible(playerPed, false, 0)
        spectatedPed = nil
    end

    SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z - 15.0)

    -- #region Get target ped or abort
    local targetLocalId

    -- Prevent infinite loop
    local tryToGetPlayerCount = 0
    repeat
        tryToGetPlayerCount = tryToGetPlayerCount + 1

        Wait(50)
        print("Waiting ped")
        targetLocalId = GetPlayerFromServerId(targetServerId)
        print(targetLocalId, targetServerId)
    until tryToGetPlayerCount > 100 or GetPlayerPed(targetLocalId) > 0 and targetLocalId ~= -1

    if tryToGetPlayerCount > 100 then
        print("Failed to get ped")
        TriggerEvent("ava_personalmenu:client:cancelSpectate")
        return
    end

    local targetPed <const> = GetPlayerPed(targetLocalId)
    -- #endregion Get target ped or abort

    print("targetPed", targetPed)
    -- #region Load collisions around target player
    local tryToLoadCollisionsCount = 0
    RequestCollisionAtCoord(targetCoords.x, targetCoords.y, targetCoords.z)
    -- Prevent infinite loop
    while not HasCollisionLoadedAroundEntity(targetPed) and tryToLoadCollisionsCount <= 100 do
        tryToLoadCollisionsCount = tryToLoadCollisionsCount + 1

        Wait(10)
        print("Waiting collisions")
    end
    if tryToLoadCollisionsCount > 100 then
        print("Failed to load collisions ped")
    end
    -- #endregion Load collisions around target player

    NetworkSetInSpectatorMode(true, targetPed)
    spectatedPed = targetPed

    DoScreenFadeIn(500)

    isTryingToSpectating = false
    if not isSpectating then
        isSpectating = true
        setSpectateThread()
    end
end)

setSpectateThread = function()
    print("start spectate thread")
    local instructionalButtons = exports.ava_core:GetScaleformInstructionalButtons({
        { control = "~INPUT_CELLPHONE_CANCEL~", label = GetString("player_spectate_cancel") },
    })

    while isSpectating do
        Wait(0)
        DisableControlAction(0, 24, true) -- INPUT_ATTACK
        DisableControlAction(0, 25, true) -- INPUT_AIM
        DisableControlAction(0, 257, true) -- INPUT_ATTACK2
        DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
        DisableControlAction(0, 177, true) -- INPUT_CELLPHONE_CANCEL

        DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)

        if IsDisabledControlJustPressed(0, 177) then -- INPUT_CELLPHONE_CANCEL
            TriggerEvent("ava_personalmenu:client:cancelSpectate")
        end
    end
end
