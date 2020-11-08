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
			table.insert(vehicules, {vehicle = vehicle, state = v.state, fuel = v.fuel})
			print(v.plate)
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


ESX.RegisterServerCallback('esx_ava_garage:stockv',function(source,cb, vehicleProps, fuel, type, target)
	local isFound = false
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
	print(plate)
	
		for _,v in pairs(vehicules) do
			if plate == v.plate and type == v.type then
				local vehprop = json.encode(vehicleProps)
				MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle =@vehprop, fuel = @fuel WHERE plate=@plate",{['@vehprop'] = vehprop, ['@fuel'] = fuel, ['@plate'] = plate})
				isFound = true
				break
			end
		end
		cb(isFound)
end)





-- TODO faire une nouvelle table avec les places de parking terrestre, marrins et aériens
-- TODO ajouter joueur dans cette table que lorsqu'il a passé le permis pour la 1ere fois
-- TODO donner la asbo au joueur gratos
ESX.RegisterServerCallback('esx_ava_garage:getParkingSlots', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT parking_slots FROM users WHERE identifier=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
		cb(data[1].parking_slots)
	end)
end)

ESX.RegisterServerCallback('esx_ava_garage:getParkingInfos', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT parking_slots, (SELECT COUNT(plate) FROM owned_vehicles WHERE owner = @id) as owned_count, (SELECT COUNT(plate) FROM owned_vehicles WHERE owner = @id	AND state = 1) as parked_count FROM users WHERE users.identifier = @id",
	{['@id'] = xPlayer.getIdentifier()}, function(data) 
		cb(data[1])
	end)
end)



-- ESX.RegisterServerCallback('esx_ava_garage:getSocietyVehicles', function(source, cb, societyname)
-- 	local vehicules = {}

-- 	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = societyname}, function(data) 
-- 		for _,v in pairs(data) do
-- 			local vehicle = json.decode(v.vehicle)
-- 			table.insert(vehicules, {vehicle = vehicle, state = v.state, fuel = v.fuel})
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
AddEventHandler('esx_ava_garage:modifystate', function(vehicleProps, state, target)
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
	local state = state

	for _,v in pairs(vehicules) do
		if(plate == v.plate)then
			MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
			break
		end		
	end
end)	

-- AddEventHandler('esx_ava_garage:modifySocietystate', function(vehicleProps, state, societyname)
-- 	-- local _source = source
-- 	-- local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local vehicules = getPlayerVehicles(societyname)
-- 	local plate = vehicleProps.plate
-- 	local state = state

-- 	for _,v in pairs(vehicules) do
-- 		if(tostring(plate) == tostring(v.plate))then
-- 			-- local idveh = v.id
-- 			MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
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
	print(identifier)
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=false",
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

	print(tonumber(exitPrice))
	if xPlayer.get('money') >= tonumber(exitPrice) then
		cb(true)
	else
		cb(false)
	end

end)


RegisterServerEvent('esx_ava_garage:pay')
AddEventHandler('esx_ava_garage:pay', function(exitPrice)
	print(exitPrice)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(exitPrice)
	
	local toState  = math.ceil(exitPrice * 0.4)
	local toLSPD = math.floor(exitPrice * 0.35)
	local toMecano = math.floor(exitPrice * 0.25)
	
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_state', function(account)
		if account ~= nil then
			account.addMoney(toState)
		end
    end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		if account ~= nil then
			account.addMoney(toLSPD)
		end
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		if account ~= nil then
			account.addMoney(toMecano)
		end
    end)
	
	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ' .. exitPrice .. '$')
	
end)


RegisterServerEvent('esx_ava_garage:payByState')
AddEventHandler('esx_ava_garage:payByState', function(society, exitPrice)
	print(exitPrice)
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
			account.addMoney(toState)
		end
    end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
		if account ~= nil then
			account.addMoney(toLSPD)
		end
	end)
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mecano', function(account)
		if account ~= nil then
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



