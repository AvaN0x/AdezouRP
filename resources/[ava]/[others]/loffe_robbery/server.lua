local deadPeds = {}

RegisterServerEvent("loffe_robbery:pedDead")
AddEventHandler("loffe_robbery:pedDead", function(store)
    if not deadPeds[store] then
        deadPeds[store] = "deadlol"
        TriggerClientEvent("loffe_robbery:onPedDeath", -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do
                if k == store then
                    table.remove(deadPeds, k)
                end
            end
            TriggerClientEvent("loffe_robbery:resetStore", -1, store)
        end
    end
end)

RegisterServerEvent("loffe_robbery:handsUp")
AddEventHandler("loffe_robbery:handsUp", function(store)
    TriggerClientEvent("loffe_robbery:handsUp", -1, store)
end)

RegisterServerEvent("loffe_robbery:pickUp")
AddEventHandler("loffe_robbery:pickUp", function(store)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer and Config.Shops[store] then
        local inventory = aPlayer.getInventory()
        local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
        if inventory.canAddItem("dirtycash", randomAmount) then
            inventory.addItem("dirtycash", randomAmount)
            TriggerClientEvent("ava_core:client:ShowNotification", source,
                Translation[Config.Locale]["cashrecieved"] .. " ~g~" .. randomAmount .. " " .. Translation[Config.Locale]["currency"])
            TriggerClientEvent("loffe_robbery:removePickup", -1, store)
        end
    end
end)

exports.ava_core:RegisterServerCallback("loffe_robbery:canRob", function(source, store)
    local cops = exports.ava_jobs:getCountInService("lspd")
    if cops >= tonumber(Config.Shops[store].cops) then
        if Config.Shops[store].robbed == "wait" then
            return "wait"
        elseif not Config.Shops[store].robbed and not deadPeds[store] then
            Config.Shops[store].robbed = true
            exports.ava_core:SendWebhookMessage("avan0x_wh_dev", "Le braquage de superettes peut se lancer")
            Citizen.CreateThread(function()
                -- Phone alert
                Wait(2000)
                exports.ava_jobs:sendMessageToJob("lspd", {
                    message = "Braquage de superette en cours !",
                    location = Config.Shops[store].coords.xyz
                })
            end)

            return true
        end
        return false
    end
    return "no_cops"
end)

RegisterServerEvent("loffe_robbery:setRobbed")
AddEventHandler("loffe_robbery:setRobbed", function(store, boolean)
    Config.Shops[store].robbed = boolean
end)

RegisterServerEvent("loffe_robbery:rob")
AddEventHandler("loffe_robbery:rob", function(store)
    local src = source
    Config.Shops[store].robbed = true

    TriggerClientEvent("loffe_robbery:rob", -1, store)
    Wait(30000)
    TriggerClientEvent("loffe_robbery:robberyOver", src)
    TriggerClientEvent("loffe_robbery:waitBeforeRobbery", src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute

    Citizen.CreateThread(function()
        for k, v in pairs(Config.Shops) do
            if k ~= store then
                Config.Shops[k].robbed = "wait"
            end
        end
        Wait(minute * Config.TimeBeforeEachRobbery)
        for k, v in pairs(Config.Shops) do
            if k ~= store then
                Config.Shops[k].robbed = false
            end
        end
    end)

    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do
        if k == store then
            table.remove(deadPeds, k)
        end
    end
    TriggerClientEvent("loffe_robbery:resetStore", -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do
            TriggerClientEvent("loffe_robbery:pedDead", -1, i)
        end -- update dead peds
        Citizen.Wait(500)
    end
end)
