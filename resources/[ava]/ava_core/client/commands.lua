-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
----------------------------------------
--------------- Vehicles ---------------
----------------------------------------
RegisterNetEvent("ava_core:client:spawnVehicle", function(vehName)
    local playerPed = PlayerPedId()
    local vehicle = AVA.SpawnVehicle(vehName, GetEntityCoords(playerPed), GetEntityHeading(playerPed))

    ClearPedTasksImmediately(playerPed)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end)

RegisterNetEvent("ava_core:client:deleteVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true) and GetVehiclePedIsIn(playerPed, false) or AVA.GetVehicleInFront(5)

    if vehicle ~= 0 then
        AVA.DeleteVehicle(vehicle)
    end
end)

RegisterNetEvent("ava_core:client:repairVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true) and GetVehiclePedIsIn(playerPed, false) or AVA.GetVehicleInFront(5)

    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDirtLevel(vehicle, 0.0)
    end
end)

RegisterNetEvent("ava_core:client:flipVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true) and GetVehiclePedIsIn(playerPed, false) or AVA.GetVehicleInFront(5)

    if vehicle ~= 0 then
        SetEntityCoords(vehicle, GetEntityCoords(vehicle, true))
    end
end)

RegisterNetEvent("ava_core:client:tpNearestVehicle", function()
    local playerPed = PlayerPedId()

    local vehicle = AVA.GetClosestVehicle(nil, true)
    if vehicle ~= 0 then
        local wantedSeat = -1
        local driverPed = GetPedInVehicleSeat(vehicle, -1)
        if driverPed ~= 0 then
            if not IsPedAPlayer(driverPed) then
                DeletePed(driverPed)
            elseif driverPed == playerPed then
                -- we wont teleport the player if it is already the driver
                return
            else
                -- if the driver is a player, we try to teleport the player to the first available seat
                wantedSeat = -2
            end
        end
        ClearPedTasksImmediately(playerPed)
        TaskWarpPedIntoVehicle(playerPed, vehicle, wantedSeat)
    end
end)

RegisterNetEvent("ava_core:client:tuneVehiclePink", function(vehicleName)
    local playerPed = PlayerPedId()
    local vehicle

    if type(vehicleName) == "string" then
        vehicle = AVA.SpawnVehicle(vehicleName, GetEntityCoords(playerPed), GetEntityHeading(playerPed))

        ClearPedTasksImmediately(playerPed)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    else
        vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
            return
        end
    end

    SetVehicleModKit(vehicle, 0)

    SetVehicleColours(vehicle, 135, 135)

    -- print(Citizen.InvokeNative(0x2F5A72430E78C8D3, vehicle)) -- _GET_DRIFT_TYRES_ENABLED
    -- Citizen.InvokeNative(0x5AC79C98C5C17F05, vehicle, true) -- _SET_DRIFT_TYRES_ENABLED
    -- Citizen.InvokeNative(0x3A375167F5782A65, vehicle, true) -- _SET_REDUCE_DRIFT_VEHICLE_SUSPENSION

    local maxMod = {
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        15,
        16,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
        46,
    }
    for i = 1, #maxMod, 1 do
        SetVehicleMod(vehicle, maxMod[i], GetNumVehicleMods(vehicle, maxMod[i]) - 1, false)
    end

    SetVehicleMod(vehicle, 14, 27, false) -- horn

    ToggleVehicleMod(vehicle, 17, true) -- turbo
    ToggleVehicleMod(vehicle, 18, true)
    ToggleVehicleMod(vehicle, 19, true)
    ToggleVehicleMod(vehicle, 20, true)
    ToggleVehicleMod(vehicle, 21, true)
    ToggleVehicleMod(vehicle, 22, true)

    SetVehicleNeonLightEnabled(vehicle, 0, true)
    SetVehicleNeonLightEnabled(vehicle, 1, true)
    SetVehicleNeonLightEnabled(vehicle, 2, true)
    SetVehicleNeonLightEnabled(vehicle, 3, true)

    SetVehicleTyreSmokeColor(vehicle, 177, 18, 89)
    SetVehicleDashboardColor(vehicle, 135)
    SetVehicleInteriorColor(vehicle, 135)
    -- SetVehicleNeonLightsColour(vehicle, 177, 18, 89)

    SetVehicleHeadlightsColour(vehicle, 9)

    SetVehicleExtraColours(vehicle, 135, 135) -- pearlescent, wheel color

    Citizen.CreateThread(function()
        local r, g, b = 255, 0, 0
        while GetVehiclePedIsIn(playerPed) == vehicle do
            Wait(10)
            if r > 0 and b == 0 then
                r = r - 1
                g = g + 1
            end
            if g > 0 and r == 0 then
                g = g - 1
                b = b + 1
            end
            if b > 0 and g == 0 then
                r = r + 1
                b = b - 1
            end

            SetVehicleNeonLightsColour(vehicle, r, g, b)
        end
        SetVehicleNeonLightsColour(vehicle, 177, 18, 89)
    end)
end)

------------------------------------
--------------- Anim ---------------
------------------------------------

RegisterNetEvent("ava_core:client:anim", function(animDict, animName)
    exports.ava_core:RequestAnimDict(animDict)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    RemoveAnimDict(animDict)
end)

-----------------------------------
--------------- Ped ---------------
-----------------------------------

RegisterNetEvent("ava_core:client:setped", function(model)
    local modelHash<const> = GetHashKey(model)

    if IsModelValid(modelHash) and IsModelInCdimage(modelHash) then
        AVA.Player.playerPed = PlayerPedId() -- safety
        if GetEntityModel(AVA.Player.playerPed) ~= modelHash then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
            end
            SetPlayerModel(PlayerId(), modelHash)
            SetModelAsNoLongerNeeded(modelHash)

            AVA.Player.playerPed = PlayerPedId() -- reload playerPed as it have changed
            TriggerServerEvent("ava_core:server:reloadLoadout")

            SetPedDefaultComponentVariation(AVA.Player.playerPed)
            ClearAllPedProps(AVA.Player.playerPed)
            ClearPedDecorations(AVA.Player.playerPed)
            ClearPedFacialDecorations(AVA.Player.playerPed)
        end
    else
        print("[AVA] Invalid model: " .. model .. " (modelHash: " .. modelHash .. ")")
    end
end)
RegisterNetEvent("ava_core:client:resetped", function()
    Citizen.CreateThread(function()
        exports.ava_mp_peds:setPedSkin(AVA.Player.playerPed, AVA.Player.Data.skin)
        AVA.Player.playerPed = PlayerPedId()
        TriggerServerEvent("ava_core:server:reloadLoadout")
    end)
end)

-----------------------------------------
--------------- Teleports ---------------
-----------------------------------------

RegisterNetEvent("ava_core:client:teleportToCoords", function(x, y, z)
    AVA.TeleportPlayerToCoords(x, y, z, true)
end)

RegisterNetEvent("ava_core:client:teleportToWaypoint", function()
    local waypoint = GetFirstBlipInfoId(GetWaypointBlipEnumId())
    if waypoint and waypoint > 0 then
        local blipCoords = GetBlipInfoIdCoord(waypoint)
        AVA.TeleportPlayerToCoords(blipCoords.x, blipCoords.y, 0, true)
    else
        AVA.ShowNotification(nil, nil, "ava_core_logo", GetString("tpwaypoint_no_waypoint_found"), nil, nil, "ava_core_logo")
    end
end)

------------------------------------
--------------- SKIN ---------------
------------------------------------

RegisterNetEvent("ava_core:client:getskin", function()
    local playerSkin<const> = json.encode(exports.ava_mp_peds:getPlayerCurrentSkin())
    print(playerSkin)
    TriggerEvent("ava_hud:client:copyToClipboard", playerSkin)
end)

RegisterNetEvent("ava_core:client:getclothes", function()
    local playerClothes<const> = json.encode(exports.ava_mp_peds:getPlayerClothes())
    print(playerClothes)
    TriggerEvent("ava_hud:client:copyToClipboard", playerClothes)
end)

--------------------------------------
--------------- Others ---------------
--------------------------------------

RegisterNetEvent("ava_core:client:kill", function()
    SetEntityHealth(PlayerPedId(), 0)
    AVA.ShowNotification(nil, nil, "ava_core_logo", GetString("killed_by_staff"), nil, nil, "ava_core_logo")
end)

RegisterNetEvent("ava_core:client:announce", function(message)
    TriggerEvent("chat:addMessage", {color = {255, 60, 60}, multiline = false, args = {GetString("announce_chat_prefix"), message}})
    PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Biker_FM_Soundset", false)
    AVA.ShowFreemodeMessage(GetString("announce_freemode_message_title"), message, false, 10000)
end)

RegisterNetEvent("ava_core:client:staff_report", function(playerName, playerId, message)
    TriggerEvent("chat:addMessage", {color = {255, 60, 60}, multiline = false, args = {GetString("report_staff_chat_prefix", playerName, playerId), message}})
end)

