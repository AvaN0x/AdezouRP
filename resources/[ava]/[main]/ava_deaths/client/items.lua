-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-------------
-- bandage --
-------------

RegisterNetEvent("ava_deaths:clientbandage:heal", function()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    local maxHealth = GetEntityMaxHealth(playerPed)

    if health > 0 then
        if health < maxHealth then
            TriggerServerEvent("ava_deaths:server:bandage:remove")
            TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
            Wait(5000)
            ClearPedTasks(playerPed)

            local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
            SetEntityHealth(playerPed, newHealth)

            exports.ava_core:ShowNotification(GetString("got_healed"))
        else
            exports.ava_core:ShowNotification(GetString("you_re_fine"))
        end
    else
        exports.ava_core:ShowNotification(GetString("you_re_not_conscious"))
    end
end)



-------------
-- medikit --
-------------

RegisterNetEvent("ava_deaths:client:medikit", function()
    local targetId, localId = exports.ava_core:ChooseClosestPlayer("", nil, true)
    if not targetId then return end

    local targetPed = GetPlayerPed(localId)
    local health = GetEntityHealth(targetPed)
    local maxHealth = GetEntityMaxHealth(targetPed)

    if health > 0 then
        if health < maxHealth then
            local playerPed = PlayerPedId()

            TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
            Wait(10000)
            ClearPedTasks(playerPed)

            TriggerServerEvent("ava_deaths:server:medikit:heal", targetId)
        else
            exports.ava_core:ShowNotification(GetString("player_is_fine"))
        end
    else
        exports.ava_core:ShowNotification(GetString("player_not_conscious"))
    end
end)

RegisterNetEvent("ava_deaths:client:medikit:heal", function()
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    SetEntityHealth(playerPed, maxHealth)

    exports.ava_core:ShowNotification(GetString("got_healed"))
end)


-------------------
-- defibrillator --
-------------------

RegisterNetEvent("ava_deaths:client:defibrillator", function()
    local targetId, localId = exports.ava_core:ChooseClosestPlayer()
    if not targetId then return end

    local targetPed = GetPlayerPed(localId)

    if IsPedDeadOrDying(targetPed, 1) then
        local playerPed = PlayerPedId()
        local lib, anim = "mini@cpr@char_a@cpr_str", "cpr_pumpchest"

        exports.ava_core:RequestAnimDict("mini@cpr@char_a@cpr_str")
        for i = 1, 15, 1 do
            Wait(900)
            TaskPlayAnim(playerPed, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, -8.0, -1, 0, 0, false, false, false)
        end
        RemoveAnimDict("mini@cpr@char_a@cpr_str")

        TriggerServerEvent("ava_deaths:server:defibrillator:revive", targetId)
    else
        exports.ava_core:ShowNotification(GetString("player_not_unconscious"))
    end
end)
