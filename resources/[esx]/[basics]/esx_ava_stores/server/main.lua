-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('esx_ava_stores:BuyItem')
AddEventHandler('esx_ava_stores:BuyItem', function(jobName, zoneName, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    local job = Config.Jobs[jobName]
    local zone = job.BuyZones[zoneName]

    if zone then
        local price = nil
        local isIllegal = nil
        for k,v in ipairs(zone.Items) do
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
            TriggerClientEvent('esx:showNotification', source, _('buy_cant_carry'))
        else
            if isIllegal == true then
                if xPlayer.getAccount('black_money').money < totalprice then
                    TriggerClientEvent('esx:showNotification', source, _('buy_cant_afford'))
                else
                    xPlayer.removeAccountMoney('black_money', totalprice)
                    inventory.addItem(item, count)
                    TriggerClientEvent('esx:showNotification', source, _('buy_you_paid_dirty', totalprice))
                end
            else
                if xPlayer.getMoney() < totalprice then
                    TriggerClientEvent('esx:showNotification', source, _('buy_cant_afford_dirty'))
                else
                    if job.SocietyName then
                        TriggerEvent('esx_statejob:getTaxed', job.SocietyName, totalprice, function(toSociety)
                        end)
                    end

                    xPlayer.removeMoney(totalprice)
                    inventory.addItem(item, count)
                    TriggerClientEvent('esx:showNotification', source, _('buy_you_paid', totalprice))
                end

            end
        end
    else
        print(('%s attempted to exploit buying!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

ESX.RegisterServerCallback('esx_ava_stores:GetBuyElements', function(source, cb, jobName, zoneName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    local job = Config.Jobs[jobName]
    local zone = job.BuyZones[zoneName]

    if zone then
        local elements = {}
        for k,v in pairs(zone.Items) do
            local item = inventory.getItem(v.name)
            table.insert(elements, {itemLabel = item.label, label = _('buy_label', item.label, v.price), price = v.price, name = v.name})
        end
        cb(elements)
    end
end)


