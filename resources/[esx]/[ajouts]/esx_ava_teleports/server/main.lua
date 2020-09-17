ESX = nil
local doorInfo = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ava_doors:updateState')
AddEventHandler('esx_ava_doors:updateState', function(doorID, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(doorID) ~= 'number' then
		print(('esx_ava_doors: %s didn\'t send a number!'):format(xPlayer.identifier))
		return
	end

	if type(state) ~= 'boolean' then
		print(('esx_ava_doors: %s attempted to update invalid state!'):format(xPlayer.identifier))
		return
	end

	if not Config.DoorList[doorID] then
		print(('esx_ava_doors: %s attempted to update invalid door!'):format(xPlayer.identifier))
		return
	end

	-- if not IsAuthorized(xPlayer.job.name, xPlayer.job2.name, Config.DoorList[doorID]) then
	-- 	print(('esx_ava_doors: %s was not authorized to open a locked door!'):format(xPlayer.identifier))
	-- 	return
	-- end

	doorInfo[doorID] = state

	TriggerClientEvent('esx_ava_doors:setState', -1, doorID, state)
end)

ESX.RegisterServerCallback('esx_ava_doors:getDoorInfo', function(source, cb)
	cb(doorInfo)
end)

-- function IsAuthorized(jobName, job2Name, doorID)
-- 	for _,job in pairs(doorID.authorizedJobs) do
-- 		if job == jobName or job == job2Name then
-- 			return true
-- 		end
-- 	end

-- 	return false
-- end

-- function MFF:GetLockpickCount(source)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	while not xPlayer do Citizen.Wait(0); xPlayer = ESX.GetPlayerFromId(source); end
-- 	local item = xPlayer.getInventoryItem('lockpick')
-- 	return item.count or 0
--   end
  
-- ESX.RegisterServerCallback('MF_Fleeca:GetLockpickCount', function(source,cb) cb(MFF:GetLockpickCount(source) or 0); end)
  