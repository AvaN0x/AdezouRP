ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(os.time())

local function getPlayerByName(playername)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer ~= nil
            and (
                xPlayer.getName() == playername
                or xPlayer.source == playername
                or xPlayer.identifier == playername
            )
        then
            return xPlayer
        end
    end
    return false
end

AddEventHandler('onPlayerVote', function (playername, ip, date)
    print(playername, ip, date)
    if playername ~= "" then
        local xPlayer = getPlayerByName(playername)
        if xPlayer then
            local bigLoot = math.random(0, 100) < 5
            local cashPrize = math.random(200, 400)
            if bigLoot then
                cashPrize = cashPrize + 400
            end
            print(xPlayer.identifier, bigLoot, cashPrize)

            xPlayer.addMoney(cashPrize)

            TriggerClientEvent("esx_ava_personalmenu:privateMessage", xPlayer.source, "Top Serveurs", "Pour te remercier de ton vote, nous venons de te donner ~y~" .. cashPrize .. " $~s~ en liquide." .. (bigLoot and " ~g~(JACKPOT)~s~" or ""))
            exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_vote", xPlayer.identifier .. " a gagné **" .. cashPrize .. "** en votant pour le serveur.", 15902015)
        end
    end
end)
