local playersProcessingExtap = {}
local playersProcessingExta = {}

RegisterServerEvent('esx_illegal:pickedUpMdma')
AddEventHandler('esx_illegal:pickedUpMdma', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('extamdma')

	if xItem.limit ~= -1 and (xItem.count + 10) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, 'vous n\'avez plus assez de place pour stocker la ~r~MDMA~s~.')
	else
		xPlayer.addInventoryItem(xItem.name, 10)
	end
end)

RegisterServerEvent('esx_illegal:pickedUpAmphet')
AddEventHandler('esx_illegal:pickedUpAmphet', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('extaamphetamine')

	if xItem.limit ~= -1 and (xItem.count + 10) > xItem.limit then
		TriggerClientEvent('esx:showNotification', _source, 'vous n\'avez plus assez de place pour stocker des ~r~Amphétamines~s~.')
	else
		xPlayer.addInventoryItem(xItem.name, 10)
	end
end)

-- RegisterServerEvent('esx_illegal:processExtap')
-- AddEventHandler('esx_illegal:processExtap', function()
--     if not playersProcessingExtap[source] then
--         local _source = source
--         local xPlayer = ESX.GetPlayerFromId(_source)
        
--         local xKeyexta = xPlayer.getInventoryItem('keyexta')
--         if xKeyexta.count < 1 then
--             TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas la clé')
--             return
--         end
--         TriggerClientEvent('esx:showNotification', _source, _U('extap_processingstarted'))
--         playersProcessingExtap[_source] = ESX.SetTimeout(Config.Delays.ExtapProcessing, function()
--             local xExtamdma, xExtaamphetamine, xExtazyp = xPlayer.getInventoryItem('extamdma'), xPlayer.getInventoryItem('extaamphetamine'), xPlayer.getInventoryItem('extazyp') 

--             if xExtazyp.limit ~= -1 and (xExtazyp.count + 1) > xExtazyp.limit then
--                 TriggerClientEvent('esx:showNotification', _source, _U('extap_processingfull'))
--             elseif xExtamdma.count < 1 then
--                 TriggerClientEvent('esx:showNotification', _source, _U('extap_processingenough'))
--             elseif xExtaamphetamine.count < 2 then
--                 TriggerClientEvent('esx:showNotification', _source, _U('extap_processingenough'))
--             else
--                 xPlayer.removeInventoryItem('extamdma', 2)
--                 xPlayer.removeInventoryItem('extaamphetamine', 2)
--                 xPlayer.addInventoryItem('extazyp', 10)

--                 TriggerClientEvent('esx:showNotification', _source, _U('extap_processed'))
--             end

--             playersProcessingExtap[_source] = nil
--         end)
--     else
--         print(('esx_illegal: %s attempted to exploit extap processing!'):format(GetPlayerIdentifiers(source)[1]))
--     end
-- end)

RegisterServerEvent('esx_illegal:processExtap')
AddEventHandler('esx_illegal:processExtap', function()
    if not playersProcessingExtap[source] then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
              
        playersProcessingExtap[_source] = true
        -- playersProcessingExtap[_source] = ESX.SetTimeout(Config.Delays.ExtapProcessing, function()
            local xKeyexta, xExtamdma, xExtaamphetamine, xExtazyp = xPlayer.getInventoryItem('keyexta'), xPlayer.getInventoryItem('extamdma'), xPlayer.getInventoryItem('extaamphetamine'), xPlayer.getInventoryItem('extazyp') 

            if xKeyexta.count < 1 then
                TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas la clé')    
            elseif xExtazyp.limit ~= -1 and (xExtazyp.count + 1) > xExtazyp.limit then
                TriggerClientEvent('esx:showNotification', _source, _U('extap_processingfull'))
            elseif xExtamdma.count < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('extap_processingenough'))
            elseif xExtaamphetamine.count < 2 then
                TriggerClientEvent('esx:showNotification', _source, _U('extap_processingenough'))
            else
                TriggerClientEvent('esx:showNotification', _source, _U('extap_processingstarted'))
                Citizen.Wait(Config.Delays.ExtapProcessing)
                xPlayer.removeInventoryItem('extamdma', 2)
                xPlayer.removeInventoryItem('extaamphetamine', 2)
                xPlayer.addInventoryItem('extazyp', 10)

                TriggerClientEvent('esx:showNotification', _source, _U('extap_processed'))
            end

            playersProcessingExtap[_source] = nil
        -- end)
    else
        print(('esx_illegal: %s attempted to exploit extap processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)


function CancelProcessing(playerID)
	if playersProcessingExtap[playerID] then
		ESX.ClearTimeout(playersProcessingExtap[playerID])
		playersProcessingExtap[playerID] = nil
	elseif playersProcessingExta[playerID] then
		ESX.ClearTimeout(playersProcessingExta[playerID])
		playersProcessingExta[playerID] = nil
	end
end

RegisterServerEvent('esx_illegal:cancelProcessing')
AddEventHandler('esx_illegal:cancelProcessing', function()
	CancelProcessing(source)
end)

RegisterServerEvent('esx_illegal:processExta')
AddEventHandler('esx_illegal:processExta', function()
    if not playersProcessingExta [source] then
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        
        local xKeyexta = xPlayer.getInventoryItem('keyexta')
        if xKeyexta.count < 1 then
            TriggerClientEvent('esx:showNotification', _source, 'Vous n\'avez pas la clé')
            return
        end
        TriggerClientEvent('esx:showNotification', _source, _U('exta_processingstarted'))
        playersProcessingExta[_source] = ESX.SetTimeout(Config.Delays.ExtaProcessing, function()
            local xExtazyp, xBagexta, xDopebag = xPlayer.getInventoryItem('extazyp'), xPlayer.getInventoryItem('bagexta'), xPlayer.getInventoryItem('dopebag')

            if xBagexta.limit ~= -1 and (xBagexta.count + 1) > xBagexta.limit then
                TriggerClientEvent('esx:showNotification', _source, _U('exta_processingfull'))
            elseif xExtazyp.count < 5 then
				TriggerClientEvent('esx:showNotification', _source, _U('exta_processingenough'))
			elseif xDopebag.count < 1 then
                TriggerClientEvent('esx:showNotification', _source, _U('exta_processingenough'))
			else
				xPlayer.removeInventoryItem('dopebag', 1)
                xPlayer.removeInventoryItem('extazyp', 5)
                xPlayer.addInventoryItem('bagexta', 1)

                TriggerClientEvent('esx:showNotification', _source, _U('exta_processed'))
            end

            playersProcessingExta[_source] = nil
        end)
    else
         print(('esx_illegal: %s attempted to exploit exta processing!'):format(GetPlayerIdentifiers(source)[1]))
     end
 end)


AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
