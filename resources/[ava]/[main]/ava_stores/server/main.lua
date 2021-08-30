-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Items = exports.ava_core:GetItemsData()

RegisterNetEvent("ava_stores:server:buyItem", function(storeName, item, count)
    local src = source
    local store = Config.Stores[storeName]

    if store and store.Items then
        local aPlayer = exports.ava_core:GetPlayer(src)
        local inventory = aPlayer.getInventory()

        local price = nil
        local isIllegal = nil
        for k, v in ipairs(store.Items) do
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
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_carry"))
        else
            if isIllegal == true then
                if inventory.canRemoveItem("dirtycash", totalprice) then
                    inventory.removeItem("dirtycash", totalprice)
                    inventory.addItem(item, count)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford_dirty"))
                end
            else
                if inventory.canRemoveItem("cash", totalprice) then
                    -- TriggerEvent('esx_statejob:getTaxed', store.Name, totalprice, function(toSociety)
                    -- end)

                    inventory.removeItem("cash", totalprice)
                    inventory.addItem(item, count)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford"))
                end

            end
        end
    else
        print(("%s attempted to exploit buying!"):format(GetPlayerIdentifiers(src)[1]))
    end
end)

local function has_license(table, licenseName)
    if table then
        for k, v in ipairs(table) do
            if v.name == licenseName then
                return true
            end
        end
    end
    return false
end

exports.ava_core:RegisterServerCallback("ava_stores:getStoreItems", function(source, storeName)
    local src = source
    local store = Config.Stores[storeName]

    if store and store.Items then
        local aPlayer = exports.ava_core:GetPlayer(src)
        if aPlayer then
            local inventory = aPlayer.getInventory()
            local playerLicenses = nil

            local items = {}
            local count = 0
            for i = 1, #store.Items, 1 do
                local storeItem = store.Items[i]
                local configItem = Items[storeItem.name]
                if configItem then
                    if storeItem.license and not playerLicenses then
                        playerLicenses = aPlayer.getLicenses()
                    end

                    if not storeItem.license or has_license(playerLicenses, storeItem.license) then
                        count = count + 1
                        items[count] = {
                            label = configItem.label,
                            desc = configItem.description,
                            noIcon = configItem.noIcon,
                            price = storeItem.price,
                            name = storeItem.name,
                            maxCanTake = inventory.canTake(storeItem.name),
                            isDirtyMoney = storeItem.isDirtyMoney,
                        }
                    end
                end
            end
            return items
        end
    end
    return {}
end)

exports.ava_core:RegisterServerCallback("ava_stores:carwash:checkMoney", function(source, storeName)
    local src = source
    local store = Config.Stores[storeName]

    if store and store.Carwash then
        local aPlayer = exports.ava_core:GetPlayer(src)
        if aPlayer then
            local inventory = aPlayer.getInventory()
            local price = store.Carwash.Price or 80
            print(inventory.getItem("cash").quantity)
            if inventory.canRemoveItem("cash", price) then
                inventory.removeItem("cash", price)
                return true
            end
        end
    end
    return false
end)
