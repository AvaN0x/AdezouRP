ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('avan0x_dealer:Sold')
AddEventHandler('avan0x_dealer:Sold', function(item,price,count)
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do xPlayer = ESX.GetPlayerFromId(source); Citizen.Wait(0); end
	local iItem = xPlayer.getInventoryItem(item)
	local iCount = iItem.count
	if iCount and iCount >= count then
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez vendu " + tonumber(count) + " " + iItem.label + " pour $" + tonumber(count)*tonumber(price) + ".")
		xPlayer.removeInventoryItem(item, count)
		xPlayer.addAccountMoney('black_money', count * price)
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

