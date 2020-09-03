local playersProcessingCocaLeaf = {}
local playersProcessingCoca = {}


RegisterServerEvent('esx_illegal:pickedUpCocaLeaf')
AddEventHandler('esx_illegal:pickedUpCocaLeaf', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('cokeleaf')

	if xItem.limit ~= -1 and (xItem.count + 5) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, _U('coke_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 5)
	end
end)

RegisterServerEvent('esx_illegal:processCocaLeaf')
AddEventHandler('esx_illegal:processCocaLeaf', function()
    if not playersProcessingCocaLeaf[source] then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        local xKeycoke = xPlayer.getInventoryItem('keycoke')
        if xKeycoke.count < 1 then
            TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas la clé')
            return
        end
        TriggerClientEvent('esx:showNotification', _source, _U('coke_processingstarted'))
        playersProcessingCocaLeaf[_source] = ESX.SetTimeout(Config.Delays.CokeProcessing, function()
            local xCokeLeaf, xCoke = xPlayer.getInventoryItem('cokeleaf'), xPlayer.getInventoryItem('coke')

            if xCoke.limit ~= -1 and (xCoke.count + 1) > xCoke.limit then
                TriggerClientEvent('esx:showNotification', _source, _U('coke_processingfull'))
            elseif xCokeLeaf.count < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('coke_processingenough'))
            else
                xPlayer.removeInventoryItem('cokeleaf', 2)
                xPlayer.addInventoryItem('coke', 2)

                TriggerClientEvent('esx:showNotification', _source, _U('coke_processed'))
            end

            playersProcessingCocaLeaf[_source] = nil
        end)
    else
        print(('esx_illegal: %s attempted to exploit coke processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

function CancelProcessing(playerID)
	if playersProcessingCocaLeaf[playerID] then
		ESX.ClearTimeout(playersProcessingCocaLeaf[playerID])
		playersProcessingCocaLeaf[playerID] = nil
	elseif playersProcessingCoca[playerID] then
		ESX.ClearTimeout(playersProcessingCoca[playerID])
		playersProcessingCoca[playerID] = nil
	end
end

RegisterServerEvent('esx_illegal:cancelProcessing')
AddEventHandler('esx_illegal:cancelProcessing', function()
	CancelProcessing(source)
end)

RegisterServerEvent('esx_illegal:processCoca')
AddEventHandler('esx_illegal:processCoca', function()
    if not playersProcessingCoca[source] then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        local xKeycoke, xDopebag = xPlayer.getInventoryItem('keycoke'), xPlayer.getInventoryItem('dopebag')
        if xKeycoke.count < 1 then
            TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas la clé')
        elseif xDopebag.count < 1 then
            TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas de pochon')
            return
        end
        TriggerClientEvent('esx:showNotification', _source, _U('coke_processingstarted2'))
        playersProcessingCoca[_source] = ESX.SetTimeout(Config.Delays.CokeProcessing, function()
            local xCoke, xBagcoke, xDopebag = xPlayer.getInventoryItem('coke'), xPlayer.getInventoryItem('bagcoke'), xPlayer.getInventoryItem('dopebag')

            if xBagcoke.limit ~= -1 and (xBagcoke.count + 1) > xBagcoke.limit then
                TriggerClientEvent('esx:showNotification', _source, _U('coke_processingfull2'))
            elseif xCoke.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('coke_processingenough2'))
			elseif xDopebag.count < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('coke_processingenough2'))
			else
				xPlayer.removeInventoryItem('dopebag', 1)
                xPlayer.removeInventoryItem('coke', 5)
                xPlayer.addInventoryItem('bagcoke', 1)

                TriggerClientEvent('esx:showNotification', _source, _U('coke_processed2'))
            end

            playersProcessingCoca[_source] = nil
        end)
    else
         print(('esx_illegal: %s attempted to exploit coke processing!'):format(GetPlayerIdentifiers(source)[1]))
     end
 end)


AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
