ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('avan0x_dealer:Sold')
AddEventHandler('avan0x_dealer:Sold', function(item,price,count)
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do xPlayer = ESX.GetPlayerFromId(source); Citizen.Wait(0); end
	local iItem = xPlayer.getInventoryItem(item)
	local iCount = iItem.count
	if iCount and iCount >= count and count > 0 then
		xPlayer.removeInventoryItem(item, count)
		xPlayer.addAccountMoney('black_money', count * price)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez vendu " .. count .. " " .. iItem.label .. " pour $" .. (count * price) .. ".")
	end
end)

ESX.RegisterServerCallback('avan0x_dealer:GetDrugCount', function(source,cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do
		xPlayer = ESX.GetPlayerFromId(source);
		Citizen.Wait(0);
	end
	local drugs = {}
	for k,v in pairs(Config.DrugItems) do
		local drug = xPlayer.getInventoryItem(v)
		if drug and drug.count then
			drug = drug.count;
		else
			drug = 0;
		end
		drugs[v] = drug
	end
	cb(drugs)
end)


ESX.RegisterServerCallback('avan0x_dealer:askCanStart', function(source, cb)
    -- local cops = exports.esx_ava_jobs:getCountInService("lspd")
    -- cb(cops > 0)
    cb(true)
end)

