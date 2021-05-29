ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_radars:notifPolice')
AddEventHandler('esx_radars:notifPolice', function(plate, speed, radarName, stolen)
    local stolenText = ''
    if stolen then
        stolenText = ' ~r~volé~s~'
    end
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if (xPlayer.job ~= nil and xPlayer.job.name == 'lspd') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'lspd') then
            TriggerClientEvent("esx:showAdvancedNotification", xPlayers[i],
                'LSPD RADARS', 
                radarName, 
                'Véhicule'..stolenText..' immatriculé ~y~'..plate..'~s~ flashé à ~r~'..speed..' km/h', 'CHAR_CHAT_CALL', 8)
        end
    end
end)

ESX.RegisterServerCallback('esx_radars:getVehicleOwner', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', 
		{
			['@plate'] = plate
        }, function(result)
            if result[1] then
                cb(tostring(result[1].owner))
            else
                cb(nil)
            end
	end)
end)
