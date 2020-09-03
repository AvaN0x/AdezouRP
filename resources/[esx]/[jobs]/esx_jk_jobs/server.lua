ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_jk_jobs:setJob')
AddEventHandler('esx_jk_jobs:setJob', function(job)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob(job, 0)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez été engagé en premier métier')	
end)

RegisterServerEvent('esx_jk_jobs:setJob2')
AddEventHandler('esx_jk_jobs:setJob2', function(job2)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob2(job2, 0)
	TriggerClientEvent('esx:showNotification', source, 'Vous avez été engagé en second métier')	
end)
