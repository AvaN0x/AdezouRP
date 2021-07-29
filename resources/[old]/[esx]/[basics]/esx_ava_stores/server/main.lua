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
    local _source = source
    local store = Config.Stores[storeName]

    if store and store.Items then
        local xPlayer = ESX.GetPlayerFromId(source)
        local inventory = xPlayer.getInventory()
        local playerLicenses = nil


        local items = {}
        for i = 1, #store.Items, 1 do
            local item = inventory.getItem(store.Items[i].name)

            if store.Items[i].license and not playerLicenses then
                playerLicenses = exports.esx_license:GetUserLicenses(_source)
            end

            if not store.Items[i].license or has_value(playerLicenses, store.Items[i].license) then
                table.insert(items, {
                    label = item.label,
                    price = store.Items[i].price,
                    name = store.Items[i].name,
                    maxCanTake = inventory.canTake(store.Items[i].name),
                    isDirtyMoney = store.Items[i].isDirtyMoney
                })
            end
        end
        cb(items)
    end
end)




ESX.RegisterServerCallback('esx_ava_stores:carwash:checkMoney', function(source, cb, storeName)
    local _source = source
    local store = Config.Stores[storeName]

    if store and store.Carwash then
        local price = store.Carwash.Price or 80
        local xPlayer = ESX.GetPlayerFromId(_source)
        print(price)
        if xPlayer.get('money') >= price then
            xPlayer.removeMoney(price)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)



function has_value(table, val)
	if table then
		for k, v in ipairs(table) do
			if v == val then
				return true
			end
		end
	end
	return false
end

