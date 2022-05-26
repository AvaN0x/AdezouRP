ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local Vehicles = nil

RegisterServerEvent('esx_lscustom:buyMod')
AddEventHandler('esx_lscustom:buyMod', function(price, zoneName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	price = tonumber(price)
    local isIllegal = Config.Zones[zoneName].IsIllegal

	if Config.IsMecanoJobOnly and not isIllegal and not Config.Zones[zoneName].IsOnlyCash then

		local societyAccount = nil
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			societyAccount = account
		end)
		if price <= societyAccount.money then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			local society = {name = "mechanic"}
			local mecanoPart = 0.18
			-- TriggerEvent('esx_society:saveData',xPlayer,"purchase",society,price,(societyAccount.money-price))
			TriggerEvent('esx_avan0x:logTransaction', 'society_mechanic', 'society_mechanic', 'LS_CUSTOM', 'LS_CUSTOM', "purchase_custom", tonumber(price * (1 - mecanoPart)))
			TriggerEvent('esx_statejob:getTaxed', 'LS_CUSTOM', price, function(toSociety)
			end)
			societyAccount.removeMoney(math.floor(tonumber(price * (1 - mecanoPart))))
		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end

	else
        if isIllegal and price <= xPlayer.getAccount('black_money').money then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			TriggerEvent('esx_statejob:getTaxed', 'LS_CUSTOM', price, function(toSociety)
			end)
            xPlayer.removeAccountMoney('black_money', price)
            
		elseif price <= xPlayer.getMoney() then
			TriggerClientEvent('esx_lscustom:installMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('purchased'))
			TriggerEvent('esx_statejob:getTaxed', 'LS_CUSTOM', price, function(toSociety)
			end)
            xPlayer.removeMoney(price)

		else
			TriggerClientEvent('esx_lscustom:cancelInstallMod', _source)
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
		end

	end
end)

RegisterServerEvent('esx_lscustom:refreshOwnedVehicle')
AddEventHandler('esx_lscustom:refreshOwnedVehicle', function(myCar)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE @plate = plate', {
        ['@plate'] = myCar.plate
    }, function(result)
        if result[1] then
            local vehicle = json.decode(result[1].vehicle)

            if vehicle.model == myCar.model then

                MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
                    {
                        ['@plate'] = myCar.plate,
                        ['@vehicle'] = json.encode(myCar)
                    })

            else
				print(('esx_lscustom: %s a tenté de mettre à niveau un véhicule dont le modèle n\'était pas assorti !'):format(xPlayer.identifier))
			end
        end
    end)
end)

ESX.RegisterServerCallback('esx_lscustom:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT model, price FROM vehicleshop', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)

---------------------------------
--- Copyright by ikNox#6088 ---
---------------------------------