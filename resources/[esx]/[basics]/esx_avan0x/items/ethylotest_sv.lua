-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem('ethylotest', function(source)
    -- local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_avan0x:ethylotest', source)
end)

RegisterServerEvent('esx_avan0x:ethylotest:remove')
AddEventHandler('esx_avan0x:ethylotest:remove', function()
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('ethylotest', 1)
end)

ESX.RegisterServerCallback('esx_avan0x:ethylotest:getTargetData', function(source, cb, target)
    local data = {}

    TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
        data.drunk = math.floor(status.percent or 0)
    end)
    
    TriggerEvent('esx_status:getStatus', target, 'drugged', function(status)
        data.drugged = math.floor(status.percent or 0)
        cb(data)
    end)
end)