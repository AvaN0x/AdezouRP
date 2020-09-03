ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('balisegps', function(source)

	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)


	TriggerClientEvent('esx_cichygps:balisegps', source)

end)




  RegisterServerEvent('esx_cichygps:zabierz')
  AddEventHandler('esx_cichygps:zabierz', function()
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('balisegps', 1)

end)

