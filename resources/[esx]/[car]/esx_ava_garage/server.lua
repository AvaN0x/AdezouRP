-- RegisterServerEvent('esx_ava_garage:modifySocietystate')
-- RegisterServerEvent('esx_ava_garage:modifySocietyStateByState')
RegisterServerEvent('esx_ava_garage:payhealth1')


ESX = nil
local Vehicles = nil -- vehicles prices from the carshoop

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('esx_ava_garage:getVehiclesPrices', function(source, cb)
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

-- get vehicles from player or society
-- allowed types : car | plane | heli | boat
ESX.RegisterServerCallback('esx_ava_garage:getVehicles', function(source, cb, type, target)
	local identifier = nil
	local vehicules = {}
	if target then
		identifier = target
	else
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		identifier = xPlayer.getIdentifier()
	end

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier and type = @type",
	{
		['@identifier'] = identifier,
		['@type'] = type
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, fuel = v.fuel, location = v.location})
		end
		cb(vehicules)
	end)
end)

function getPlayerVehicles(identifier)
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier",{['@identifier'] = identifier})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = vehicle.plate, type = v.type})
	end
	return vehicles
end


ESX.RegisterServerCallback('esx_ava_garage:stockv',function(source,cb, vehicleProps, fuel, type, gIdentifier, target)
	local isFound = false
	local identifier = nil
	if target then
		identifier = target
	else
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		identifier = xPlayer.getIdentifier()
	end
	-- print(identifier)
	local vehicles = getPlayerVehicles(identifier)
	local plate = vehicleProps.plate
	for _,v in pairs(vehicles) do
		-- print(v.plate)
		if plate == v.plate and type == v.type then
			local vehprop = json.encode(vehicleProps)
			MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle =@vehprop, fuel = @fuel, location=@location WHERE plate=@plate",
			{
				['@vehprop'] = vehprop,
				['@fuel'] = fuel,
				['@plate'] = plate,
				['@location'] = gIdentifier
			})
			isFound = true
			break
		end
	end
	cb(isFound)
end)




ESX.RegisterServerCallback('esx_ava_garage:getParkingSlots', function(source, cb, slot)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local sql = "SELECT "..slot.." AS parking_slots FROM parking_slot WHERE identifier=@identifier"
	local attributes = {
		['@slot'] = slot,
		['@identifier'] = xPlayer.getIdentifier()
	}

	MySQL.Async.fetchAll(sql, attributes, function(data) 
		if data[1] ~= nil then
			cb(data[1].parking_slots)
		else
			MySQL.Async.execute('INSERT INTO user_parking (identifier) VALUES (@identifier)',
			{
				['@identifier'] = xPlayer.getIdentifier()
			}, function(rowsChanged)
				MySQL.Async.fetchAll(sql, attributes, function(data2)
					cb(data2[1].parking_slots)
				end)
			end)
		end
	end)
end)

ESX.RegisterServerCallback('esx_ava_garage:getParkingInfos', function(source, cb, slot)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT "..slot.." AS parking_slots, (SELECT COUNT(plate) FROM owned_vehicles WHERE owner = @id AND type = @slot) as owned_count, (SELECT COUNT(plate) FROM owned_vehicles JOIN user_parking ON user_parking.identifier=owned_vehicles.owner WHERE owner = @id AND location<>'garage_POUND' AND type = @slot) as parked_count FROM user_parking WHERE user_parking.identifier = @id",
	{
		['@slot'] = slot,
		['@id'] = xPlayer.getIdentifier()
	}, function(data)
		if data[1] ~= nil then
			cb(data[1])
		else
			MySQL.Async.execute('INSERT INTO user_parking (identifier) VALUES (@identifier)',
			{
				['@identifier'] = xPlayer.getIdentifier()
			}, function(rowsChanged)
				MySQL.Async.fetchAll("SELECT "..slot.." AS parking_slots, (SELECT COUNT(plate) FROM owned_vehicles WHERE owner = @id AND type = @slot) as owned_count, (SELECT COUNT(plate) FROM owned_vehicles JOIN user_parking ON user_parking.identifier=owned_vehicles.owner WHERE owner = @id AND location<>'garage_POUND' AND type = @slot) as parked_count FROM user_parking WHERE user_parking.identifier = @id",
				{
					['@slot'] = slot,
					['@id'] = xPlayer.getIdentifier()
				}, function(data2)
					cb(data2[1])
				end)
			end)
		end
	end)
end)



-- ESX.RegisterServerCallback('esx_ava_garage:getSocietyVehicles', function(source, cb, societyname)
-- 	local vehicules = {}

-- 	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = societyname}, function(data) 
-- 		for _,v in pairs(data) do
-- 			local vehicle = json.decode(v.vehicle)
-- 			table.insert(vehicules, {vehicle = vehicle, fuel = v.fuel, location = v.location})
-- 		end
-- 		cb(vehicules)
-- 	end)
-- end)


-- ESX.RegisterServerCallback('esx_ava_garage:stockSocietyv', function(source,cb, vehicleProps, societyname, fuel)
-- 	local isFound = false
-- 	local vehicules = getPlayerVehicles(societyname)
-- 	local plate = vehicleProps.plate
-- 	print(plate)
-- 	for _,v in pairs(vehicules) do
-- 		if(plate == v.plate)then
-- 			local vehprop = json.encode(vehicleProps)
-- 			MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle =@vehprop, fuel = @fuel WHERE plate=@plate",{['@vehprop'] = vehprop, ['@fuel'] = fuel, ['@plate'] = plate})
-- 			isFound = true
-- 			break
-- 		end
-- 	end
-- 	cb(isFound)
-- end)


RegisterServerEvent('esx_ava_garage:modifystate')
AddEventHandler('esx_ava_garage:modifystate', function(vehicleProps, location, target)
	local identifier = nil
	if target then
		identifier = target
	else
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		identifier = xPlayer.getIdentifier()
	end

	local vehicules = getPlayerVehicles(identifier)
	local plate = vehicleProps.plate
	local location = location

	for _,v in pairs(vehicules) do
		if(plate == v.plate)then
			MySQL.Sync.execute("UPDATE owned_vehicles SET location=@location WHERE plate=@plate",{['@location'] = location , ['@plate'] = plate})
			break
		end
	end
end)

-- AddEventHandler('esx_ava_garage:modifySocietystate', function(vehicleProps, location, societyname)
-- 	-- local _source = source
-- 	-- local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local vehicules = getPlayerVehicles(societyname)
-- 	local plate = vehicleProps.plate
-- 	local location = location

-- 	for _,v in pairs(vehicules) do
-- 		if(tostring(plate) == tostring(v.plate))then
-- 			-- local idveh = v.id
-- 			MySQL.Sync.execute("UPDATE owned_vehicles SET location =@location WHERE plate=@plate",{['@location'] = location , ['@plate'] = plate})
-- 			break
-- 		end		
-- 	end
-- end)	


ESX.RegisterServerCallback('esx_ava_garage:getOutVehicles',function(source, cb, target)	
	local identifier = nil
	local vehicules = {}
	if target then
		identifier = target
	else
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		identifier = xPlayer.getIdentifier()
	end
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND location='garage_POUND'",
	{
		['@identifier'] = identifier
	}, function(data)
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, type = v.type})
		end
		cb(vehicules)
	end)
end)

ESX.RegisterServerCallback('esx_ava_garage:checkMoney', function(source, cb, exitPrice)

	local xPlayer = ESX.GetPlayerFromId(source)

	-- print(tonumber(exitPrice))
	if xPlayer.get('money') >= tonumber(exitPrice) then
		cb(true)
	else
		cb(false)
	end

end)


RegisterServerEvent('esx_ava_garage:pay')
AddEventHandler('esx_ava_garage:pay', function(exitPrice)
	-- print(exitPrice)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(exitPrice)
	
	local toState  = math.ceil(exitPrice * 0.4)
	local toLSPD = math.floor(exitPrice * 0.35)
	local toMecano = math.floor(exitPrice * 0.25)
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_state', function(account)
		if account ~= nil then
            TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, 'money', 'society_state', 'society_state', "pay_pound", toState)
			account.addMoney(toState)
		end
    end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		if account ~= nil then
            TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, 'money', 'society_police', 'society_police', "pay_pound", toLSPD)
			account.addMoney(toLSPD)
		end
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		if account ~= nil then
            TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, 'money', 'society_mecano', 'society_mecano', "pay_pound", toMecano)
			account.addMoney(toMecano)
		end
    end)
	
	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ' .. exitPrice .. '$')
end)


RegisterServerEvent('esx_ava_garage:payByState')
AddEventHandler('esx_ava_garage:payByState', function(society, exitPrice)
	-- print(exitPrice)
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		if account ~= nil then
			account.removeMoney(exitPrice)
		end
    end)

	local toState  = math.ceil(exitPrice * 0.4)
	local toLSPD = math.floor(exitPrice * 0.35)
	local toMecano = math.floor(exitPrice * 0.25)
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_state', function(account)
		if account ~= nil then
            TriggerEvent('esx_avan0x:logTransaction', society, society, 'society_state', 'society_state', "pay_pound", toState)
			account.addMoney(toState)
		end
    end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		if account ~= nil then
            TriggerEvent('esx_avan0x:logTransaction', society, society, 'society_police', 'society_police', "pay_pound", toLSPD)
			account.addMoney(toLSPD)
		end
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		if account ~= nil then
            TriggerEvent('esx_avan0x:logTransaction', society, society, 'society_mecano', 'society_mecano', "pay_pound", toMecano)
			account.addMoney(toMecano)
		end
    end)
	
	TriggerClientEvent('esx:showNotification', source, 'L\'entreprise a payé ' .. exitPrice .. '$')

end)

AddEventHandler('esx_ava_garage:payhealth1', function(price)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_statejob:getTaxed', 'GARAGE', price, function(toSociety)
	end)
	xPlayer.removeMoney(price)

	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ' .. price)

end)



