-- RegisterServerEvent('esx_ava_garage:debug')
RegisterServerEvent('esx_ava_garage:modifySocietystate')
RegisterServerEvent('esx_ava_garage:modifySocietyStateByState')
RegisterServerEvent('esx_ava_garage:payhealth1')
-- RegisterServerEvent('esx_ava_garage:logging')


ESX = nil
local Vehicles = nil -- vehicles prices from the carshoop

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


-- price
ESX.RegisterServerCallback('esx_ava_garage:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		MySQL.Async.fetchAll('SELECT model, price FROM vehicles UNION SELECT model, price FROM vehicles_society', {}, function(result)
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
				-- todo stocker le fuel avec getvehicleproperties
				MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle =@vehprop, fuel = @fuel WHERE plate=@plate",{['@vehprop'] = vehprop, ['@fuel'] = fuel, ['@plate'] = plate})
				isFound = true
				break
			end		
		end
		cb(isFound)
end)















--Recupere les véhicules
-- ESX.RegisterServerCallback('esx_ava_garage:getVehicles', function(source, cb)
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local vehicules = {}

-- 	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
-- 		for _,v in pairs(data) do
-- 			local vehicle = json.decode(v.vehicle)
-- 			table.insert(vehicules, {vehicle = vehicle, state = v.state, fuel = v.fuel})
-- 		end
-- 		cb(vehicules)
-- 	end)
-- end)


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



ESX.RegisterServerCallback('esx_ava_garage:getSocietyVehicles', function(source, cb, societyname)
	-- local _source = source
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = societyname}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, state = v.state, fuel = v.fuel})
		end
		cb(vehicules)
	end)
end)


-- Fin --Recupere les véhicules

--Stock les véhicules

ESX.RegisterServerCallback('esx_ava_garage:stockSocietyv', function(source,cb, vehicleProps, societyname, fuel)
	local isFound = false
	-- local _source = source
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(societyname)
	local plate = vehicleProps.plate
	print(plate)
	
		for _,v in pairs(vehicules) do
			if(plate == v.plate)then
				local vehprop = json.encode(vehicleProps)
				MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle =@vehprop, fuel = @fuel WHERE plate=@plate",{['@vehprop'] = vehprop, ['@fuel'] = fuel, ['@plate'] = plate})
				isFound = true
				break
			end		
		end
		cb(isFound)
end)


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

AddEventHandler('esx_ava_garage:modifySocietystate', function(vehicleProps, state, societyname)
	-- local _source = source
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(societyname)
	local plate = vehicleProps.plate
	local state = state

	for _,v in pairs(vehicules) do
		if(tostring(plate) == tostring(v.plate))then
			-- local idveh = v.id
			MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
			break
		end		
	end
end)	

-- AddEventHandler('esx_ava_garage:modifySocietyStateByState', function(vehicleProps, state, societyname)
-- 	local vehicules = getPlayerVehicles(societyname)
-- 	local plate = plate
-- 	local state = state

-- 	for _,v in pairs(vehicules) do
-- 		if(tostring(plate) == tostring(v.plate))then
-- 			-- local idveh = v.id
-- 			MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
-- 			break
-- 		end		
-- 	end
-- end)	

--Fin change le state du véhicule

--Fonction qui récupere les plates

-- Fin Fonction qui récupere les plates

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
-- ESX.RegisterServerCallback('esx_ava_garage:getOutSocietyVehicles',function(source, cb, societyName)	
-- 	-- local _source = source
-- 	-- local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local vehicules = {}
-- 	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=false",{['@identifier'] = societyName}, function(data) 
-- 		for _,v in pairs(data) do
-- 			local vehicle = json.decode(v.vehicle)
-- 			table.insert(vehicules, vehicle)
-- 		end
-- 		cb(vehicules)
-- 	end)
-- end)


--Foonction qui check l'argent
ESX.RegisterServerCallback('esx_ava_garage:checkMoney', function(source, cb, exitPrice)

	local xPlayer = ESX.GetPlayerFromId(source)

	print(tonumber(exitPrice))
	if xPlayer.get('money') >= tonumber(exitPrice) then
		cb(true)
	else
		cb(false)
	end

end)
--Fin Foonction qui check l'argent

--fonction qui retire argent
RegisterServerEvent('esx_ava_garage:pay')
AddEventHandler('esx_ava_garage:pay', function(exitPrice)
	print(exitPrice)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(exitPrice)
	
	local toState  = math.ceil(exitPrice * 0.6)
	local toLSPD = math.floor(exitPrice * 0.4)
	
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

	local toState  = math.ceil(exitPrice * 0.6)
	local toLSPD = math.floor(exitPrice * 0.4)

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
end)
--Fin fonction qui retire argent


--Recupere les vehicules
--Fin Recupere les vehicules

--Debug
-- AddEventHandler('esx_ava_garage:debug', function(var)
-- 	print(to_string(var))
-- end)

-- function table_print (tt, indent, done)
--   done = done or {}
--   indent = indent or 0
--   if type(tt) == "table" then
--     local sb = {}
--     for key, value in pairs (tt) do
--       table.insert(sb, string.rep (" ", indent)) -- indent it
--       if type (value) == "table" and not done [value] then
--         done [value] = true
--         table.insert(sb, "{\n");
--         table.insert(sb, table_print (value, indent + 2, done))
--         table.insert(sb, string.rep (" ", indent)) -- indent it
--         table.insert(sb, "}\n");
--       elseif "number" == type(key) then
--         table.insert(sb, string.format("\"%s\"\n", tostring(value)))
--       else
--         table.insert(sb, string.format(
--             "%s = \"%s\"\n", tostring (key), tostring(value)))
--        end
--     end
--     return table.concat(sb)
--   else
--     return tt .. "\n"
--   end
-- end

-- function to_string( tbl )
--     if  "nil"       == type( tbl ) then
--         return tostring(nil)
--     elseif  "table" == type( tbl ) then
--         return table_print(tbl)
--     elseif  "string" == type( tbl ) then
--         return tbl
--     else
--         return tostring(tbl)
--     end
-- end
--Fin Debug


-- Fonction qui change les etats sorti en rentré lors d'un restart
-- AddEventHandler('onMySQLReady', function()

-- 	MySQL.Sync.execute("UPDATE owned_vehicles SET state=true WHERE state=false", {})

-- end)
-- Fin Fonction qui change les etats sorti en rentré lors d'un restart


--debut de payement pour la santé vehicule
AddEventHandler('esx_ava_garage:payhealth1', function(price)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_statejob:getTaxed', 'GARAGE', price, function(toSociety)
	end)    		
	xPlayer.removeMoney(price)

	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ' .. price)

end)
--fin de payement pour la santé vehicule


--logger dans la console
-- AddEventHandler('esx_ava_garage:logging', function(logging)
-- 	RconPrint(logging)
-- end)

--fin de logger dans la console


-- society garage
-- AddEventHandler('esx_ava_garage:ListSocietyVehiclesMenu', function(societyName, garage)
-- 	TriggerClientEvent("esx_ava_garage:ListSocietyVehiclesMenu", societyName, garage)
-- end)


-- AddEventHandler('esx_ava_garage:StockSocietyVehicleMenu', function(societyName)
-- 	TriggerClientEvent("esx_ava_garage:StockSocietyVehicleMenu", societyName)
-- end)


