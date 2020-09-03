RegisterServerEvent('eden_garage:debug')
RegisterServerEvent('eden_garage:modifystate')
RegisterServerEvent('eden_garage:modifySocietystate')
RegisterServerEvent('eden_garage:modifySocietyStateByState')
RegisterServerEvent('eden_garage:pay')
RegisterServerEvent('eden_garage:payByState')
RegisterServerEvent('eden_garage:payhealth1')
RegisterServerEvent('eden_garage:logging')


ESX                = nil
local Vehicles = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--Recupere les véhicules
ESX.RegisterServerCallback('eden_garage:getVehicles', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, {vehicle = vehicle, state = v.state, fuel = v.fuel})
		end
		cb(vehicules)
	end)
end)

ESX.RegisterServerCallback('eden_garage:getParkingSlots', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT parking_slots FROM users WHERE identifier=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
		cb(data[1].parking_slots)
	end)
end)

ESX.RegisterServerCallback('eden_garage:getParkingInfos', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll("SELECT parking_slots, (SELECT COUNT(plate)	FROM owned_vehicles	WHERE owner = @id) as owned_count, (SELECT COUNT(plate) FROM owned_vehicles WHERE owner = @id	AND state = 1) as parked_count FROM users WHERE users.identifier = @id",
	{['@id'] = xPlayer.getIdentifier()}, function(data) 
		cb(data[1])
	end)
end)



ESX.RegisterServerCallback('eden_garage:getSocietyVehicles', function(source, cb, societyname)
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
ESX.RegisterServerCallback('eden_garage:stockv',function(source,cb, vehicleProps, fuel)
	local isFound = false
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(xPlayer.getIdentifier())
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

ESX.RegisterServerCallback('eden_garage:stockSocietyv', function(source,cb, vehicleProps, societyname, fuel)
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
--Fin stock les vehicules

--Change le state du véhicule

-- TODO faire par la plaque
AddEventHandler('eden_garage:modifystate', function(vehicleProps, state)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = getPlayerVehicles(xPlayer.getIdentifier())
	local plate = vehicleProps.plate
	local state = state

	for _,v in pairs(vehicules) do
		if(plate == v.plate)then
			-- local idveh = v.id
			MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
			break
		end		
	end
end)	

AddEventHandler('eden_garage:modifySocietystate', function(vehicleProps, state, societyname)
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

-- AddEventHandler('eden_garage:modifySocietyStateByState', function(vehicleProps, state, societyname)
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

ESX.RegisterServerCallback('eden_garage:getOutVehicles',function(source, cb)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=false",{['@identifier'] = xPlayer.getIdentifier()}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, vehicle)
		end
		cb(vehicules)
	end)
end)
ESX.RegisterServerCallback('eden_garage:getOutSocietyVehicles',function(source, cb, societyName)	
	-- local _source = source
	-- local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND state=false",{['@identifier'] = societyName}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicules, vehicle)
		end
		cb(vehicules)
	end)
end)


--Foonction qui check l'argent
ESX.RegisterServerCallback('eden_garage:checkMoney', function(source, cb, exitPrice)

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
AddEventHandler('eden_garage:pay', function(exitPrice)

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
AddEventHandler('eden_garage:payByState', function(society, exitPrice)

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
	
	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ' .. exitPrice .. '$')

end)
--Fin fonction qui retire argent


--Recupere les vehicules
function getPlayerVehicles(identifier)
	
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	for _,v in pairs(data) do
		local vehicle = json.decode(v.vehicle)
		table.insert(vehicles, {id = v.id, plate = vehicle.plate})
	end
	return vehicles
end
--Fin Recupere les vehicules

--Debug
AddEventHandler('eden_garage:debug', function(var)
	print(to_string(var))
end)

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end
--Fin Debug


-- Fonction qui change les etats sorti en rentré lors d'un restart
-- AddEventHandler('onMySQLReady', function()

-- 	MySQL.Sync.execute("UPDATE owned_vehicles SET state=true WHERE state=false", {})

-- end)
-- Fin Fonction qui change les etats sorti en rentré lors d'un restart


--debut de payement pour la santé vehicule
AddEventHandler('eden_garage:payhealth1', function(price)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_statejob:getTaxed', 'GARAGE', price, function(toSociety)
	end)    		
	xPlayer.removeMoney(price)

	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ' .. price)

end)
--fin de payement pour la santé vehicule


--logger dans la console
AddEventHandler('eden_garage:logging', function(logging)
	RconPrint(logging)
end)

--fin de logger dans la console


-- society garage
AddEventHandler('eden_garage:ListSocietyVehiclesMenu', function(societyName, garage)
	TriggerClientEvent("eden_garage:ListSocietyVehiclesMenu", societyName, garage)
end)


AddEventHandler('eden_garage:StockSocietyVehicleMenu', function(societyName)
	TriggerClientEvent("eden_garage:StockSocietyVehicleMenu", societyName)
end)

-- price
ESX.RegisterServerCallback('eden_garage:getVehiclesPrices', function(source, cb)
	if Vehicles == nil then
		-- MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
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
