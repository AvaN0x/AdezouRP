ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('buyLockpick')
AddEventHandler('buyLockpick', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.PriceLockpick
    -- if (xPlayer.getMoney() >= price) then
    --     xPlayer.removeMoney(price)
    if (xPlayer.getAccount('black_money').money >= price) then
        xPlayer.removeAccountMoney('black_money', price)
        xPlayer.addInventoryItem('lockpick', 1)
        TriggerClientEvent('esx:showAdvancedNotification', source,"Vendeur","Vous avez acheté un ~b~Lockpick","", "CHAR_LAZLOW2", 1)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source,"Vendeur", "~r~Vous n\'avez pas assez d\'argent sale !","", "CHAR_LAZLOW2", 1)
    end
end)

RegisterNetEvent('buyHeadBag')
AddEventHandler('buyHeadBag', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.PriceHeadBag
    -- if (xPlayer.getMoney() >= price) then
    --     xPlayer.removeMoney(price)
    if (xPlayer.getAccount('black_money').money >= price) then
        xPlayer.removeAccountMoney('black_money', price)
        xPlayer.addInventoryItem('headbag', 1)
        TriggerClientEvent('esx:showAdvancedNotification', source,"Vendeur","Vous avez acheté un ~b~Sac-tête","", "CHAR_LAZLOW2", 1)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source,"Vendeur", "~r~Vous n\'avez pas assez d\'argent sale !","", "CHAR_LAZLOW2", 1)
    end
end)

RegisterNetEvent('buyTenueCasa')
AddEventHandler('buyTenueCasa', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Config.PriceTenueCasa
    -- if (xPlayer.getMoney() >= price) then
    --     xPlayer.removeMoney(price)
    if (xPlayer.getAccount('black_money').money >= price) then
        xPlayer.removeAccountMoney('black_money', price)
        xPlayer.addInventoryItem('tenuecasa', 1)
        TriggerClientEvent('esx:showAdvancedNotification', source,"Vendeur","Vous avez acheté une ~b~Tenue Casa de Papel","", "CHAR_LAZLOW2", 1)
    else
        TriggerClientEvent('esx:showAdvancedNotification', source,"Vendeur", "~r~Vous n\'avez pas assez d\'argent sale !","", "CHAR_LAZLOW2", 1)
    end
end)