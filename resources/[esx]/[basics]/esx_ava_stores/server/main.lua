-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx_ava_stores:BuyItem')
AddEventHandler('esx_ava_stores:BuyItem', function(storeName, item, count)
    local store = Config.Stores[storeName]

    if store and store.Items then
        local xPlayer = ESX.GetPlayerFromId(source)
        local inventory = xPlayer.getInventory()
    
        local price = nil
        local isIllegal = nil
        for k,v in ipairs(store.Items) do
            if v.name == item then
                price = v.price
                isIllegal = v.isDirtyMoney
                break
            end
        end
        if price == nil then
            return
        end

        local totalprice = tonumber(count) * tonumber(price)
        
        if not inventory.canAddItem(item, count) then
            TriggerClientEvent('esx:showNotification', source, _('cant_carry'))
        else
            if isIllegal == true then
                if xPlayer.getAccount('black_money').money < totalprice then
                    TriggerClientEvent('esx:showNotification', source, _('cant_afford_dirty'))
                else
                    xPlayer.removeAccountMoney('black_money', totalprice)
                    inventory.addItem(item, count)
                    TriggerClientEvent('esx:showNotification', source, _('you_paid_dirty', totalprice))
                end
            else
                if xPlayer.getMoney() < totalprice then
                    TriggerClientEvent('esx:showNotification', source, _('cant_afford'))
                else
                    TriggerEvent('esx_statejob:getTaxed', store.Name, totalprice, function(toSociety)
                    end)

                    xPlayer.removeMoney(totalprice)
                    inventory.addItem(item, count)
                    TriggerClientEvent('esx:showNotification', source, _('you_paid', totalprice))
                end

            end
        end
    else
        print(('%s attempted to exploit buying!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

ESX.RegisterServerCallback('esx_ava_stores:GetBuyItems', function(source, cb, storeName)
    local store = Config.Stores[storeName]

    if store and store.Items then
        local xPlayer = ESX.GetPlayerFromId(source)
        local inventory = xPlayer.getInventory()
    
        local items = {}
        for k,v in pairs(store.Items) do
            local item = inventory.getItem(v.name)
            table.insert(items, {
                label = item.label,
                price = v.price,
                name = v.name,
                maxCanTake = inventory.canTake(v.name),
                isDirtyMoney = v.isDirtyMoney
            })
        end
        cb(items)
    end
end)


