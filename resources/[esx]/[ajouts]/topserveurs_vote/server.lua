ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(os.time())

local function getPlayerByName(playername)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer ~= nil and xPlayer.getName() == playername then
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
            print(xPlayer.identifier, bigLoot, cashPrize)

            xPlayer.addMoney(bigLoot and (600 + cashPrize) or cashPrize)
        end
    end
end)
