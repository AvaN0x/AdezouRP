-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
StatusFunctions["hunger"] = function(value, percent, playerHealth, newHealth)
    if percent == 0 then
        newHealth = playerHealth > 150 and (newHealth - 2) or (newHealth - 4)

    elseif percent > 100 then
        TriggerEvent("ava_status:client:add", "injured", 30)
    end

    return newHealth
end

StatusFunctions["thirst"] = StatusFunctions["hunger"]

RegisterNetEvent("ava_status:client:eat", function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or "prop_cs_burger_01"
        IsAnimated = true
        StopLongAnimatedIfNeeded()

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.052, 0.031, -70.0, 175.0, 90.0, true, true, false, true, 1, true)

            exports.ava_core:RequestAnimDict("mp_player_inteat@burger")
            TaskPlayAnim(playerPed, "mp_player_inteat@burger", "mp_player_int_eat_burger_fp", 8.0, -8, -1, 49, 0, 0, 0, 0)

            Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(playerPed)
            exports.ava_core:DeleteObject(prop)
        end)
    end
end)

RegisterNetEvent("ava_status:client:drink", function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or "prop_ld_flow_bottle"
        IsAnimated = true
        StopLongAnimatedIfNeeded()

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.15, 0.018, 0.031, -100.0, 55.0, 350.0, true, true, false, true, 1, true)

            exports.ava_core:RequestAnimDict("mp_player_intdrink")
            TaskPlayAnim(playerPed, "mp_player_intdrink", "loop_bottle", 8.0, -8, -1, 49, 0, 0, 0, 0)

            Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(playerPed)
            exports.ava_core:DeleteObject(prop)
        end)
    end
end)
