-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


local function GetGang(xPlayer)
	if not xPlayer then
		return nil
	end
	local result = MySQL.Sync.fetchAll('SELECT name, grade FROM user_gang WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	})
	if result[1] and Config.Jobs[result[1].name] and Config.Jobs[result[1].name].isGang then
		return {name = result[1].name, label = Config.Jobs[result[1].name].LabelName, grade = result[1].grade}
	else
		return {}
	end
end

RegisterServerEvent('esx_ava_jobs:requestGang')
AddEventHandler('esx_ava_jobs:requestGang', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_ava_jobs:setGang', _source, GetGang(xPlayer))
end)

RegisterServerEvent('esx_ava_jobs:gang_hire')
AddEventHandler('esx_ava_jobs:gang_hire', function(target, gangName)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetGang = GetGang(targetXPlayer)
	if not targetGang.name then
		MySQL.Sync.execute("INSERT INTO `user_gang`(`identifier`, `name`, `grade`) VALUES (@identifier, @name, 0)", {
			['@identifier'] = targetXPlayer.identifier,
			['@name'] = gangName
		})

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. target .. "~w~.")

		TriggerClientEvent('esx_ava_jobs:setGang', target, {name = gangName, label = Config.Jobs[gangName].LabelName, grade = 0})
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~recruté par " .. _source .. "~w~.")
	end
end)

RegisterServerEvent('esx_ava_jobs:gang_fire')
AddEventHandler('esx_ava_jobs:gang_fire', function(target, gangName)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetGang = GetGang(targetXPlayer)
	if targetGang and targetGang.name == gangName then
		MySQL.Sync.execute("DELETE FROM `user_gang` WHERE identifier = @identifier", {
			['@identifier'] = targetXPlayer.identifier
		})

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. target .. "~w~.")
		TriggerClientEvent('esx_ava_jobs:setGang', target, {})
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. _source .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)


RegisterServerEvent('esx_ava_jobs:gang_set_manage')
AddEventHandler('esx_ava_jobs:gang_set_manage', function(target, gangName, grade)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetGang = GetGang(targetXPlayer)
	if targetGang and targetGang.name == gangName then
		MySQL.Sync.execute("UPDATE `user_gang` SET `grade` = @grade WHERE `identifier` = @identifier", {
			['@identifier'] = targetXPlayer.identifier,
			['@grade'] = grade
		})

		TriggerClientEvent('esx_ava_jobs:setGang', target, GetGang(targetXPlayer))
		if grade == 1 then
			TriggerClientEvent('esx:showNotification', _source,  target .. " peut maintenant gérer les membres")
			TriggerClientEvent('esx:showNotification', target, "Vous pouvez maintenant gérer les membres de votre gang")
		else
			TriggerClientEvent('esx:showNotification', _source,  target .. " ne peut plus gérer les membres")
			TriggerClientEvent('esx:showNotification', target, "Vous ne pouvez plus gérer les membres de votre gang")
		end
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)


TriggerEvent('es:addGroupCommand', 'setgang', 'admin', function(source, args, user)
	if tonumber(args[1]) and args[2] and tonumber(args[3]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if Config.Jobs[args[2]] ~= nil and Config.Jobs[args[2]].isGang then
				if tonumber(args[3]) >= 0 and tonumber(args[3]) <=1 then
					if GetGang(xPlayer).name then
						MySQL.Sync.execute("UPDATE `user_gang` SET `name` = @name, `grade` = @grade WHERE `identifier` = @identifier", {
							['@identifier'] = xPlayer.identifier,
							['@name'] = args[2],
							['@grade'] = tonumber(args[3])
						})
					else
						MySQL.Sync.execute("INSERT INTO `user_gang`(`identifier`, `name`, `grade`) VALUES (@identifier, @name, @grade)", {
							['@identifier'] = xPlayer.identifier,
							['@name'] = args[2],
							['@grade'] = tonumber(args[3])
						})
					end
					TriggerClientEvent('esx_ava_jobs:setGang', args[1], {name = args[2], label = Config.Jobs[args[2]].LabelName, grade = tonumber(args[3])})
				else
					TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That gang grade does not exist.' } })
				end
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That gang does not exist.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Set player gang", params = {{name = "id", help = "player id"}, {name = "gang", help = "gang name"}, {name = "grade_id", help = "grade ID"}}})


TriggerEvent('es:addGroupCommand', 'remgang', 'admin', function(source, args, user)
	if tonumber(args[1]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			if GetGang(xPlayer).name then
				MySQL.Sync.execute("DELETE FROM `user_gang` WHERE identifier = @identifier", {
					['@identifier'] = xPlayer.identifier
				})
				TriggerClientEvent('esx_ava_jobs:setGang', args[1], {})
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That player doesn\'t belong to any gang' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Remove player gang", params = {{name = "id", help = "player id"}}})
