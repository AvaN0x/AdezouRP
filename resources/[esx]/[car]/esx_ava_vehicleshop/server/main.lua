-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
---------- FROM esx_vehicleshop -----------
-------------------------------------------

ESX              = nil
local Categories = {}
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
	MySQL.Async.execute('DELETE FROM open_car WHERE value = @plate', {
		['@plate'] = plate
	})

end

MySQL.ready(function()
	Categories = MySQL.Sync.fetchAll('SELECT vehicle_categories.name, vehicle_categories.label FROM vehicleshop JOIN vehicle_categories ON vehicleshop.category = vehicle_categories.name UNION SELECT addon_account.name, addon_account.label FROM vehicleshop JOIN addon_account ON vehicleshop.category = addon_account.name')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM `vehicleshop` WHERE !ISNULL(price) UNION SELECT v1.name, v1.model, v2.price, v1.category FROM `vehicleshop` AS v1 JOIN `vehicleshop` AS v2 ON v1.model = v2.model WHERE ISNULL(v1.price) AND !ISNULL(v2.price)')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end
	-- send information after db has loaded, making sure everyone gets vehicle information
	TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Categories)
	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwned')
AddEventHandler('esx_vehicleshop:setVehicleOwned', function (vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local found = false

	for i = 1, #Vehicles, 1 do
        if GetHashKey(Vehicles[i].model) == vehicleProps.model then
            vehicleData = Vehicles[i]
			found = true
            break
        end
    end

	if found and xPlayer.getMoney() >= vehicleData.price then
		TriggerEvent('esx_statejob:getTaxed', 'CONCESSIONNAIRE', vehicleData.price, function(toSociety)
		end)

		xPlayer.removeMoney(vehicleData.price)
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
		{
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps)
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', vehicleProps.plate))
		end)
	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		print(('esx_vehicleshop: %s attempted to inject vehicle!'):format(xPlayer.identifier))
	end
end)


RegisterServerEvent('esx_vehicleshop:setVehicleOwnedSociety')
AddEventHandler('esx_vehicleshop:setVehicleOwnedSociety', function (society, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local found = false

	for i = 1, #Vehicles, 1 do
        if GetHashKey(Vehicles[i].model) == vehicleProps.model then
            vehicleData = Vehicles[i]
			found = true
            break
        end
    end

	if found and xPlayer.getMoney() >= vehicleData.price then
		TriggerEvent('esx_statejob:getTaxed', 'CONCESSIONNAIRE', vehicleData.price, function(toSociety)
		end)

		xPlayer.removeMoney(vehicleData.price)
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
		{
			['@owner']   = society,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps)
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs_society', vehicleProps.plate))
		end)
	else
		TriggerClientEvent('esx:deleteVehicle', _source)
		print(('esx_vehicleshop: %s attempted to inject vehicle!'):format(xPlayer.identifier))
	end

end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function (source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function (source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if xPlayer.getMoney() >= vehicleData.price then
		cb(true)
	else
		cb(false)
	end
end)



ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function (source, cb, plate, model)
	local resellPrice = 0

	-- calculate the resell price
	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		print(('esx_vehicleshop: %s attempted to sell an unknown vehicle!'):format(GetPlayerIdentifiers(source)[1]))
		cb(false)
	else
		local xPlayer = ESX.GetPlayerFromId(source)

		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = plate
		}, function (result)
			if result[1] then -- does the owner match?
				local vehicle = json.decode(result[1].vehicle)

				if vehicle.model == model then
					if vehicle.plate == plate then
						xPlayer.addMoney(resellPrice)
						RemoveOwnedVehicle(plate)
						cb(true)
					else
						print(('esx_vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
						cb(false)
					end
				else
					print(('esx_vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
					cb(false)
				end
			else
				if xPlayer.job.grade_name == 'boss' then
					MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
						['@owner'] = 'society_' .. xPlayer.job.name,
						['@plate'] = plate
					}, function (result)
						if result[1] then
							local vehicle = json.decode(result[1].vehicle)

							if vehicle.model == model then
								if vehicle.plate == plate then
									xPlayer.addMoney(resellPrice)
									RemoveOwnedVehicle(plate)
									cb(true)
								else
									print(('esx_vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
									cb(false)
								end
							else
								print(('esx_vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
								cb(false)
							end
						else
							cb(false)
						end
					end)
				elseif xPlayer.job2.grade_name == 'boss' then
					MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
						['@owner'] = 'society_' .. xPlayer.job2.name,
						['@plate'] = plate
					}, function (result)
						if result[1] then
							local vehicle = json.decode(result[1].vehicle)

							if vehicle.model == model then
								if vehicle.plate == plate then
									xPlayer.addMoney(resellPrice)
									RemoveOwnedVehicle(plate)
									cb(true)
								else
									print(('esx_vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
									cb(false)
								end
							else
								print(('esx_vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
								cb(false)
							end
						else
							cb(false)
						end
					end)
				else
					cb(false)
				end
			end
		end)
	end
end)


ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

