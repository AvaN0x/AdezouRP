local PlayerData = {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		DrawMarker(Config.Marker.type, Config.Marker.x, Config.Marker.y, Config.Marker.z, 0, 0, 0, 0, 0, 0, 2.0001,2.0001,2.0001, 0, Config.Color.r, Config.Color.g, Config.Color.b, 0, 0, 0, 0, 0, 0, 0)
		-- if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),  -267.92422485352,-957.95263671875,31.22313117981, true) < 1 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.Marker.x, Config.Marker.y, Config.Marker.z, true) < 1.2 then
			DisplayHelpText("Appuyez sur ~g~E~s~ pour ouvrir l'agence")
		 if (IsControlJustReleased(1, 51)) then
			SetNuiFocus( true, true )
			SendNUIMessage({
				ativa = true
			})
		 end
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Marker.x, Config.Marker.y, Config.Marker.z)
	-- SetBlipSprite (blip, 407)
	SetBlipSprite (blip, 682)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, 27)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Pole Emploi')
	EndTextCommandSetBlipName(blip)
end)

RegisterNUICallback('setJob', function(data, cb)
	TriggerServerEvent('esx_jk_jobs:setJob', data.job)
  	cb('ok')
end)

RegisterNUICallback('setJob2', function(data, cb)
	TriggerServerEvent('esx_jk_jobs:setJob2', data.job2)
  	cb('ok')
end)


RegisterNUICallback('fechar', function(data, cb)
	SetNuiFocus( false )
	SendNUIMessage({
	ativa = false
	})
  	cb('ok')
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
