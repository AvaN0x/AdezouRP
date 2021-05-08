ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local deadPeds = {}

RegisterServerEvent('loffe_robbery:pedDead')
AddEventHandler('loffe_robbery:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('loffe_robbery:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
            TriggerClientEvent('loffe_robbery:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('loffe_robbery:handsUp')
AddEventHandler('loffe_robbery:handsUp', function(store)
    TriggerClientEvent('loffe_robbery:handsUp', -1, store)
end)

RegisterServerEvent('loffe_robbery:pickUp')
AddEventHandler('loffe_robbery:pickUp', function(store)
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
    xPlayer.addAccountMoney('black_money', randomAmount)
    TriggerClientEvent('esx:showNotification', source, Translation[Config.Locale]['cashrecieved'] .. ' ~g~' .. randomAmount .. ' ' .. Translation[Config.Locale]['currency'])
    TriggerClientEvent('loffe_robbery:removePickup', -1, store) 
end)

ESX.RegisterServerCallback('loffe_robbery:canRob', function(source, cb, store)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_dev", "id `" .. source .. "` [loffe_robbery]", "cops value : `" .. cops .. "`\nConfig.Shops[store].cops value : `" .. Config.Shops[store].cops .. "`\ncops >= Config.Shops[store].cops value : " .. (cops >= Config.Shops[store].cops and "`true`" or "`false`"), 15902015)
    if tonumber(cops) >= tonumber(Config.Shops[store].cops) then
        if Config.Shops[store].robbed == 'wait' then
            cb('wait')
        elseif not Config.Shops[store].robbed and not deadPeds[store] then
            Config.Shops[store].robbed = true
            exports.esx_avan0x:SendWebhookMessage("avan0x_wh_dev", "Le braquage peut se lancer")

            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('loffe_robbery:setRobbed')
AddEventHandler('loffe_robbery:setRobbed', function(store, boolean)
    Config.Shops[store].robbed = boolean
end)


RegisterServerEvent('loffe_robbery:rob')
AddEventHandler('loffe_robbery:rob', function(store)
    local src = source
    Config.Shops[store].robbed = true
    local xPlayers = ESX.GetPlayers()

    TriggerClientEvent('loffe_robbery:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('loffe_robbery:robberyOver', src)
    TriggerClientEvent('loffe_robbery:waitBeforeRobbery', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute

    Citizen.CreateThread(function()
        for k,v in pairs(Config.Shops) do
            if k ~= store then
                Config.Shops[k].robbed = 'wait'
            end
        end
        Wait(minute * Config.TimeBeforeEachRobbery)
        for k,v in pairs(Config.Shops) do
            if k ~= store then
                Config.Shops[k].robbed = false

                TriggerClientEvent('loffe_robbery:resetStore', -1, store)
            end
        end
    end)

    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do
        if k == store then table.remove(deadPeds, k) end
    end
    TriggerClientEvent('loffe_robbery:resetStore', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do TriggerClientEvent('loffe_robbery:pedDead', -1, i) end -- update dead peds
        Citizen.Wait(500)
    end
end)
