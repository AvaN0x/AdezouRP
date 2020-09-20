-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(identifier)
    local result = MySQL.Sync.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] then
        return result[1]
    else
        return {
            firstname = "FIRSTNAME",
            lastname = "LASTNAME"
        }
    end
end



-- RegisterCommand('twt', function(source, args, rawCommand)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local msg = rawCommand:sub(5)
--     local name = getIdentity(xPlayer.identifier)
--     fal = name.firstname .. " " .. name.lastname
--     TriggerClientEvent('chat:addMessage', -1, {
--         template = '<div class="chat-message"><b>Twitter @{0}:</b> {1}</div>',
--         args = { fal, msg }
--     })
-- end, false, {
-- 	help = "Poste un twt dans le chat", 
-- 	params = {
-- 		{
-- 			name = "message", 
-- 			help = "Le message à envoyer"
-- 		}
-- 	}
-- })

TriggerEvent('es:addGroupCommand', 'twt', 'user', function(source, args)
    if args[1] then
        local xPlayer = ESX.GetPlayerFromId(source)
        local msg = table.concat(args, " ") or ""
        local name = getIdentity(xPlayer.identifier)
        fal = name.firstname .. " " .. name.lastname
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message"><b>Twitter @{0}:</b> {1}</div>',
            args = { fal, msg }
        })
    end
end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient Permissions.'}})
end, {
	help = "Poste un tweet dans le chat", 
	params = {
		{
			name = "message", 
			help = "Le message à envoyer"
		}
	}
})


-- TODO faire /news2 pour second job
TriggerEvent('es:addGroupCommand', 'news', 'user', function(source, args)
    if args[1] then
        local xPlayer = ESX.GetPlayerFromId(source)
        local msg = table.concat(args, " ") or ""
        local name = getIdentity(xPlayer.identifier)
        if xPlayer.job.name == 'mecano' 
        or xPlayer.job.name == 'ambulance' 
        or xPlayer.job.name == 'police' 
        or xPlayer.job.name == 'cardealer' 
        or xPlayer.job.name == 'ammu' 
        or xPlayer.job.name == 'ammunation' 
        or xPlayer.job.name == 'journaliste' 
        or xPlayer.job.name == 'unicorn' 
        or xPlayer.job.name == 'bahama' 
        or xPlayer.job.name == 'taxi' 
        or xPlayer.job.name == 'realestateagent' then
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-ad"><b>Annonce {0} :</b> {1}</div>',
                args = { xPlayer.job.label, msg }
            })
        elseif xPlayer.job.name == 'state' then
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message-ad-state"><b>Annonce {0} :</b> {1}</div>',
                args = { xPlayer.job.label, msg }
            })
        end
    end
end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient Permissions.'}})
end, {
    help = "Fait une annonce pour ton métier", 
    params = {
        {
            name = "message", 
            help = "Le message à envoyer"
        }
    }
})

-- RegisterCommand('news', function(source, args, rawCommand)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local msg = rawCommand:sub(6)
--     local name = getIdentity(xPlayer.identifier)
--     if xPlayer.job.name == 'mecano' 
--         or xPlayer.job.name == 'ambulance' 
--         or xPlayer.job.name == 'police' 
--         or xPlayer.job.name == 'cardealer' 
--         or xPlayer.job.name == 'ammu' 
--         or xPlayer.job.name == 'ammunation' 
--         or xPlayer.job.name == 'journaliste' 
--         or xPlayer.job.name == 'unicorn' 
--         or xPlayer.job.name == 'bahama' 
--         or xPlayer.job.name == 'taxi' 
--         or xPlayer.job.name == 'realestateagent' then
--         fal = xPlayer.job.label
--         TriggerClientEvent('chat:addMessage', -1, {
--             template = '<div class="chat-message-ad"><b>Annonce {0} :</b> {1}</div>',
--             args = { fal, msg }
--         })
--     elseif xPlayer.job.name == 'state' then
--         fal = xPlayer.job.label
--         TriggerClientEvent('chat:addMessage', -1, {
--             template = '<div class="chat-message-ad-state"><b>Annonce {0} :</b> {1}</div>',
--             args = { fal, msg }
--         })

--     end
-- end, false, {
-- 	help = "Fait une annonce pour ton métier", 
-- 	params = {
-- 		{
-- 			name = "message", 
-- 			help = "Le message à envoyer"
-- 		}
-- 	}
-- })

