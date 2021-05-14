-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent('esx_ava_jobs:openGangMenu')
AddEventHandler('esx_ava_jobs:openGangMenu', function()
    -- actualGang is set in main.lua
	if actualGang and actualGang.name then
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_gang_recruitment_menu",
		{
			title    = actualGang.data.Name,
			align    = "left",
			elements = {
				{label = _U("gang_hire"), value = "gang_hire"},
				{label = _U("gang_fire"), value = "gang_fire"},
				{label = _U("gang_promote"), value = "gang_promote"},
				{label = _U("gang_demote"), value = "gang_demote"}
			}
		}, function(data, menu)
			closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification(_U("no_players_nearby"))

			elseif data.current.value == "gang_hire" then
				TriggerServerEvent("esx_ava_jobs:gang_hire", GetPlayerServerId(closestPlayer), actualGang.name)

			elseif data.current.value == "gang_fire" then
				TriggerServerEvent("esx_ava_jobs:gang_fire", GetPlayerServerId(closestPlayer), actualGang.name)


			elseif data.current.value == "gang_promote" then
				TriggerServerEvent("esx_ava_jobs:gang_set_manage", GetPlayerServerId(closestPlayer), actualGang.name, 1)

			elseif data.current.value == "gang_demote" then
				TriggerServerEvent("esx_ava_jobs:gang_set_manage", GetPlayerServerId(closestPlayer), actualGang.name, 0)

			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification(_U("not_in_a_gang"))
	end
end)