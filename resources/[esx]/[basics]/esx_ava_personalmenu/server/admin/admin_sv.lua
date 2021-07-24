-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterServerCallback('esx_ava_personalmenu:getPlayers', function(source, cb)
	local players = {}
	for _, playerId in ipairs(GetPlayers()) do
		table.insert(players, {name = GetPlayerName(playerId), id = tonumber(playerId)})
	end
	cb(players)
end)

ESX.RegisterServerCallback('esx_ava_personalmenu:getPlayerCoords', function(source, cb, targetId)
    if type(targetId) ~= 'string' and type(targetId) ~= 'number' then
        return
    end

    local targetPed = GetPlayerPed(tonumber(targetId))

    if not targetPed then
        return
    end

    cb(GetEntityCoords(targetPed))
end)

RegisterServerEvent("esx_ava_personalmenu:kick")
AddEventHandler("esx_ava_personalmenu:kick", function(targetId, label)
    local _source = source
    local author = GetPlayerName(_source)
	DropPlayer(targetId, "Tu as été kick par ".. author .." : ".. label)
end)

RegisterServerEvent("esx_ava_personalmenu:goto_sv")
AddEventHandler("esx_ava_personalmenu:goto_sv", function(targetId)
    local _source = source
    local coords = GetEntityCoords(GetPlayerPed(targetId))
	TriggerClientEvent("esx_ava_personalmenu:teleport", _source, coords)
end)

RegisterServerEvent("esx_ava_personalmenu:bring_sv")
AddEventHandler("esx_ava_personalmenu:bring_sv", function(targetId, coords)
	TriggerClientEvent("esx_ava_personalmenu:teleport", targetId, coords)
end)

RegisterServerEvent("esx_ava_personalmenu:kill_sv")
AddEventHandler("esx_ava_personalmenu:kill_sv", function(targetId)
	TriggerClientEvent("esx_ava_personalmenu:kill_cl", targetId)
end)

RegisterServerEvent("esx_ava_personalmenu:notifStaff")
AddEventHandler("esx_ava_personalmenu:notifStaff", function(type, content)
	TriggerClientEvent("esx_ava_personalmenu:notifStaff", -1, type, content)
end)

RegisterServerEvent("esx_ava_personalmenu:privateMessage")
AddEventHandler("esx_ava_personalmenu:privateMessage", function(targetId, content)
	TriggerClientEvent("esx_ava_personalmenu:privateMessage", targetId, GetPlayerName(source) or "", content)
end)

TriggerEvent('es:addGroupCommand', 'a', 'admin', function(source, args, user)
	TriggerClientEvent('esx_ava_personalmenu:toggle_admin_mode', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Toggle admin mode", params = {}})

TriggerEvent('es:addGroupCommand', 'r', 'admin', function(source, args, user)
	TriggerClientEvent('esx_ava_personalmenu:admin_vehicle_repair', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Repair vehicle", params = {}})