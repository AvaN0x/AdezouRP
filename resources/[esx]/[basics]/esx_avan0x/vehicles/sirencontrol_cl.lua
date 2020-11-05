-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local vehicle = 0
local state = 1

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = GetPlayerPed(-1)

		local veh = GetVehiclePedIsIn(playerPed, false)
		if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == playerPed and GetVehicleClass(veh) == 18 then
			vehicle = NetworkGetNetworkIdFromEntity(veh)
		else
			vehicle = nil
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if vehicle then
			if IsDisabledControlJustReleased(0, 58) then -- G
				if state == 0 then
					state = 1 -- true
				else
					state = 0 -- false
				end
				TriggerServerEvent("esx_ava_siren:sync", state, vehicle)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)


-- Server side sync
RegisterNetEvent("esx_ava_siren:sync")
AddEventHandler("esx_ava_siren:sync", function(netID, value)
	if value == 0 or value == 1 then
		DisableVehicleImpactExplosionActivation(NetworkGetEntityFromNetworkId(netID), value) -- SetVehicleHasMutedSirens(vehicle, toggle)
	end
end)
