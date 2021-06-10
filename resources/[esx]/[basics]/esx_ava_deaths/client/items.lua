-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-------------
-- bandage --
-------------

RegisterNetEvent('esx_ava_deaths:bandage:heal')
AddEventHandler('esx_ava_deaths:bandage:heal', function()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
	local maxHealth = GetEntityMaxHealth(playerPed)

    if health > 0 then
        if health < maxHealth then
            TriggerServerEvent("esx_ava_deaths:bandage:remove")
            TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            Citizen.Wait(5000)
            ClearPedTasks(playerPed)

            local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
            SetEntityHealth(playerPed, newHealth)

            ESX.ShowNotification(_('got_healed'))
        end
    else
        ESX.ShowNotification(_('you_re_not_conscious'))
    end
end)



-------------
-- medikit --
-------------

RegisterNetEvent('esx_ava_deaths:medikit')
AddEventHandler('esx_ava_deaths:medikit', function()
    exports.esx_avan0x:ChooseClosestPlayer(function(targetId, localId)
        local targetPed = GetPlayerPed(localId)
        local health = GetEntityHealth(targetPed)
        local maxHealth = GetEntityMaxHealth(playerPed)

        if health > 0 then
            if health < maxHealth then
                local playerPed = PlayerPedId()

                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                Citizen.Wait(10000)
                ClearPedTasks(playerPed)

                TriggerServerEvent('esx_ava_deaths:medikit:heal', targetId)
            else
                ESX.ShowNotification(_('player_is_fine'))
            end
        else
            ESX.ShowNotification(_('player_not_conscious'))
        end
    end, "", nil, true)
end)

RegisterNetEvent('esx_ava_deaths:medikit:heal')
AddEventHandler('esx_ava_deaths:medikit:heal', function()
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

    SetEntityHealth(playerPed, maxHealth)

    ESX.ShowNotification(_('got_healed'))
end)


-------------------
-- defibrillator --
-------------------

RegisterNetEvent('esx_ava_deaths:defibrillator')
AddEventHandler('esx_ava_deaths:defibrillator', function()
    exports.esx_avan0x:ChooseClosestPlayer(function(targetId, localId)
        local targetPed = GetPlayerPed(localId)

        if IsPedDeadOrDying(targetPed, 1) then

            local playerPed = PlayerPedId()
            local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

            for i=1, 15, 1 do
                Citizen.Wait(900)
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                end)
            end

            TriggerServerEvent('esx_ava_deaths:defibrillator:revive', targetId)

            RemoveAnimDict('mini@cpr@char_a@cpr_str')
            RemoveAnimDict('cpr_pumpchest')


        else
            ESX.ShowNotification(_('player_not_unconscious'))
        end

    end)
end)

