-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local rebootHours = {'02', '08', '14', '20'}

function checkreboot()
	local date_local = os.date('%H:%M:%S', os.time())

	for _, hour in ipairs(rebootHours) do
		print(hour)
		if date_local == hour .. ':30:00' then
			TriggerClientEvent('esx:showNotification', -1, "~r~Le serveur reboot automatiquement dans 30 minutes !")
			ExecuteCommand('weather thunder')
			ExecuteCommand('freezeweather')
			break
		elseif date_local == hour .. ':45:00' then
			TriggerClientEvent('esx:showNotification', -1, "~r~Le serveur reboot automatiquement dans 15 minutes !")
			ExecuteCommand('time 23 0')
			-- GetClockHours() is client sided
			ExecuteCommand('freezetime')
			break
		elseif date_local == hour .. ':55:00' then
			TriggerClientEvent('esx:showNotification', -1, "~r~Le serveur reboot automatiquement dans 5 minutes ! Pensez à vous déconnecter !")
			ExecuteCommand('blackout')
			ExecuteCommand('weather halloween')
			break
		elseif date_local == hour .. ':59:40' then
			ESX.SavePlayers()
			break
		end
	end
end

function restart_server()
	SetTimeout(1000, function()
		checkreboot()
		restart_server()
	end)
end
restart_server()
