-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil
local houseInfos = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ava_burglary:updateState')
AddEventHandler('esx_ava_burglary:updateState', function(houseID, state)
	houseInfos[houseID] = state
	TriggerClientEvent('esx_ava_burglary:setState', -1, houseID, state)
end)

ESX.RegisterServerCallback('esx_ava_burglary:getHousesInfo', function(source, cb)
	cb(houseInfos)
end)

RegisterServerEvent('esx_ava_burglary:giveItem')
AddEventHandler('esx_ava_burglary:giveItem', function(item, quantity)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addInventoryItem(item, quantity)
end)

RegisterServerEvent('esx_ava_burglary:enterHouse')
AddEventHandler('esx_ava_burglary:enterHouse', function(houseID)
	houseInfos[houseID] = 1
	TriggerClientEvent('esx_ava_burglary:setState', -1, houseID, 1)

	Wait(30 * 60 * 1000)
	houseInfos[houseID] = 0
	TriggerClientEvent('esx_ava_burglary:setState', -1, houseID, 0)
end)
