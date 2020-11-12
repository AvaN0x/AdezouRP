local playersProcessingMeth = {}

RegisterServerEvent('esx_illegal:pickedUpMethyla')
AddEventHandler('esx_illegal:pickedUpMethyla', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('methylamine')

	if xItem.limit ~= -1 and (xItem.count + 15) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, _U('methyla_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 15)
	end
end)

RegisterServerEvent('esx_illegal:pickedUpPseudo')
AddEventHandler('esx_illegal:pickedUpPseudo', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('methpseudophedrine')

	if xItem.limit ~= -1 and (xItem.count + 15) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('pseudo_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 15)
	end
end)

RegisterServerEvent('esx_illegal:pickedUpMetha')
AddEventHandler('esx_illegal:pickedUpMetha', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('methacide')

	if xItem.limit ~= -1 and (xItem.count + 15) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, _U('metha_inventoryfull'))
	else
		xPlayer.addInventoryItem(xItem.name, 15)
	end
end)

RegisterServerEvent('esx_illegal:processMeth')
AddEventHandler('esx_illegal:processMeth', function()
    if not playersProcessingMeth[source] then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        local xKeymeth = xPlayer.getInventoryItem('keymeth')
        if xKeymeth.count < 1 then
            TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas la clé')
            return
        end
        TriggerClientEvent('esx:showNotification', _source, _U('meth_processingstarted'))
        playersProcessingMeth[_source] = ESX.SetTimeout(Config.Delays.MethProcessing, function()
            local xMethylamine, xMethpseudophedrine, xMethacide, xMethamphetamine, xDopebag = xPlayer.getInventoryItem('methylamine'), xPlayer.getInventoryItem('methpseudophedrine'), xPlayer.getInventoryItem('methacide'), xPlayer.getInventoryItem('methamphetamine'), xPlayer.getInventoryItem('dopebag')

            if xMethamphetamine.limit ~= -1 and (xMethamphetamine.count + 1) > xMethamphetamine.limit then
                TriggerClientEvent('esx:showNotification', _source, _U('meth_processingfull'))
            elseif xMethpseudophedrine.count < 5 then
                TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
            elseif xMethylamine.count < 5 then
                TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
            elseif xMethacide.count < 5 then
                TriggerClientEvent('esx:showNotification', _source, _U('meth_processingenough'))
            elseif xDopebag.count < 1 then
                TriggerClientEvent('esx:showNotification', _source, 'Pas assez de sachets hermétiques')
            else
                xPlayer.removeInventoryItem('methpseudophedrine', 5)
                xPlayer.removeInventoryItem('methylamine', 5)
                xPlayer.removeInventoryItem('methacide', 5)
                xPlayer.removeInventoryItem('dopebag', 1)
                xPlayer.addInventoryItem('methamphetamine', 1)

                TriggerClientEvent('esx:showNotification', _source, _U('meth_processed'))
            end

            playersProcessingMeth[_source] = nil
        end)

    else
        print(('esx_illegal: %s attempted to exploit meth processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

function CancelProcessing(playerID)
	if playersProcessingMeth[playerID] then
		ESX.ClearTimeout(playersProcessingMeth[playerID])
		playersProcessingMeth[playerID] = nil
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
