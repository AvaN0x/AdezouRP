ESX = nil

if Config.UseESX then
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)
		TriggerEvent('esx_statejob:getTaxed', 'FUEL', amount, function(total)
		end)
	
		if price > 0 then
			if (price > xPlayer.getMoney()) then
				xPlayer.removeMoney(xPlayer.getMoney())
			else
				xPlayer.removeMoney(amount)
			end
		end
	end)
end

AddEventHandler('esx_legacyfuel:GetFuel', function(vehicle, cb)
	TriggerClientEvent("esx_legacyfuel:GetFuel", vehicle, function(fuel)
		cb(fuel)
	end)
end)


AddEventHandler('esx_legacyfuel:SetFuel', function(vehicle, fuel)
	TriggerClientEvent("esx_legacyfuel:SetFuel", vehicle, fuel)
end)
