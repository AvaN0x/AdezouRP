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

RegisterServerEvent('esx_avan0x:lifeInvader')
AddEventHandler('esx_avan0x:lifeInvader', function(msg, jobLabel)
    local msg = trim(msg)

    if msg and msg ~= "" then
        local xPlayer = ESX.GetPlayerFromId(source)
        local account

        if jobLabel then
            account = jobLabel
            SendWebhookEmbedMessage("avan0x_wh_lifeinvader", jobLabel, msg, 15459370) -- #ebe42a
        else
            local name = getIdentity(xPlayer.identifier)
            account = name.firstname .. " " .. name.lastname
            SendWebhookEmbedMessage("avan0x_wh_lifeinvader", account, msg, 16733269) -- #ff5455
        end
        TriggerClientEvent('esx:showAdvancedNotification', -1, 'LIFEINVADER', account, msg, "CHAR_LIFEINVADER", 1)
    end
end)
