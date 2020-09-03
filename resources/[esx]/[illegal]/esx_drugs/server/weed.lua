local playersProcessingCannabis = {}

RegisterServerEvent('esx_illegal:pickedUpCannabis')
AddEventHandler('esx_illegal:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('cannabis')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, _U('weed_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 5)
	end
end)

RegisterServerEvent('esx_illegal:processCannabis')
AddEventHandler('esx_illegal:processCannabis', function()
    if not playersProcessingCannabis[source] then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        local xKeyweed = xPlayer.getInventoryItem('keyweed')
        if xKeyweed.count < 1 then
            TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas la clé')
            return
        end
        TriggerClientEvent('esx:showNotification', _source, _U('weed_processingstarted'))
        playersProcessingCannabis[_source] = ESX.SetTimeout(Config.Delays.WeedProcessing, function()
            local xCannabis, xBagweed, xDopebag = xPlayer.getInventoryItem('cannabis'), xPlayer.getInventoryItem('bagweed'), xPlayer.getInventoryItem('dopebag')

            if xBagweed.limit ~= -1 and (xBagweed.count + 1) > xBagweed.limit then
                TriggerClientEvent('esx:showNotification', _source, _U('weed_processingfull'))
            elseif xCannabis.count < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('weed_processingenough'))
            elseif xDopebag.count < 1 then
                TriggerClientEvent('esx:showNotification', _source, 'Pas assez de sachets hermétiques')
            else
                xPlayer.removeInventoryItem('cannabis', 5)
                xPlayer.removeInventoryItem('dopebag', 1)
                xPlayer.addInventoryItem('bagweed', 1)

                TriggerClientEvent('esx:showNotification', _source, _U('weed_processed'))
            end

            playersProcessingCannabis[_source] = nil
        end)
    else
        print(('esx_illegal: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

function CancelProcessing(playerID)
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end
end

RegisterServerEvent('esx_illegal:cancelProcessing')
AddEventHandler('esx_illegal:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
