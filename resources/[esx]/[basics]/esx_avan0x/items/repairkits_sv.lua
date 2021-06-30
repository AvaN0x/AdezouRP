-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local MechanicJobName = "mechanic"

---------------
-- repairkit --
---------------

ESX.RegisterUsableItem('repairkit', function(source)
    if exports.esx_ava_jobs:getCountInService(MechanicJobName) == 0 or exports.esx_ava_jobs:isInServiceOrHasJob(source, MechanicJobName) then
        TriggerClientEvent('esx_avan0x:repairkit', source)
    else
        TriggerClientEvent('esx:showNotification', source, _('repairkits_cant_use_now'))
    end
end)

RegisterServerEvent('esx_avan0x:repairkit:remove')
AddEventHandler('esx_avan0x:repairkit:remove', function()
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('repairkit', 1)
end)


-------------
-- bodykit --
-------------

ESX.RegisterUsableItem('bodykit', function(source)
    if exports.esx_ava_jobs:hasJob(source, MechanicJobName) then
        TriggerClientEvent('esx_avan0x:bodykit', source)
    else
        TriggerClientEvent('esx:showNotification', source, _('repairkits_need_to_be_mechanic'))
    end
end)

RegisterServerEvent('esx_avan0x:bodykit:remove')
AddEventHandler('esx_avan0x:bodykit:remove', function()
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bodykit', 1)
end)


-----------
-- cloth --
-----------

ESX.RegisterUsableItem('cloth', function(source)
	TriggerClientEvent('esx_avan0x:cloth', source)
end)

RegisterServerEvent('esx_avan0x:cloth:remove')
AddEventHandler('esx_avan0x:cloth:remove', function()
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cloth', 1)
end)
