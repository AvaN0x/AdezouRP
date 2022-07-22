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

        if not inventory.canAddItem(item, count) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_carry"))
        else
            local price = nil
            local isDirtyMoney = nil
            for k, v in ipairs(store.Items) do
                if v.name == item then
                    price = v.price
                    isDirtyMoney = v.isDirtyMoney
                    break
                end
            end
            if price == nil then
                return
            end

            local totalprice = tonumber(count) * tonumber(price)

            if isDirtyMoney then
                if inventory.canRemoveItem("dirtycash", totalprice) then
                    inventory.removeItem("dirtycash", totalprice)
                    inventory.addItem(item, count)
                    TriggerEvent("ava_logs:server:log",
                        { "citizenid:" .. aPlayer.citizenId, "buy_item", "item:" .. item, "count:" .. count,
                            "price:" .. price, "(dirtycash)" })
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford_dirty"))
                end
            else
                if inventory.canRemoveItem("cash", totalprice) then
                    inventory.removeItem("cash", totalprice)
                    inventory.addItem(item, count)
                    exports.ava_jobs:applyTaxes(totalPrice, storeName .. ":citizenid:" .. aPlayer.citizenId)
                    TriggerEvent("ava_logs:server:log",
                        { "citizenid:" .. aPlayer.citizenId, "buy_item", "item:" .. item, "count:" .. count,
                            "price:" .. price })
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford"))
                end

            end
        end
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

exports.ava_core:RegisterServerCallback("ava_stores:getStoreItems", function(source, storeType, storeName)
    -- Store type is:
    -- 0 for stores
    -- 1 for prop stores
    local src = source
    local store = nil
    if storeType == 0 then
        store = Config.Stores[storeName]
    elseif storeType == 1 then
        store = Config.PropStores[storeName]
    end

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
            if inventory.canRemoveItem("cash", price) then
                inventory.removeItem("cash", price)
                exports.ava_jobs:applyTaxes(price, storeName .. ":citizenid:" .. aPlayer.citizenId)
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "carwash", "price:" .. price })
                return true
            end
        end
    end
    return false
end)

exports.ava_core:RegisterServerCallback("ava_stores:server:clothesStore:checkMoney", function(source, storeName)
    local src = source
    local store = Config.Stores[storeName]

    if store and store.ClothesStore then
        local aPlayer = exports.ava_core:GetPlayer(src)
        if aPlayer then
            local inventory = aPlayer.getInventory()
            local price <const> = store.Price
            if price and inventory.canRemoveItem("cash", price) then
                return true
            end
        end
    end
    return false
end)

exports.ava_core:RegisterCommand({ "clothesmenu", "cm" }, "admin", function(source, args)
    TriggerClientEvent("ava_stores:client:OpenClothesMenu", source)
end, GetString("clothesmenu_help"))

exports.ava_core:RegisterCommand({ "outfitsmenu", "om" }, "admin", function(source, args)
    TriggerClientEvent("ava_stores:client:OpenPlayerOutfitsMenu", source)
end, GetString("outfitsmenu_help"))

exports.ava_core:RegisterServerCallback("ava_stores:server:clothesStore:payClothes",
    function(source, storeName, playerSkin)
        local src = source

        local aPlayer = exports.ava_core:GetPlayer(src)
        if aPlayer then
            if storeName == nil and IsPlayerAceAllowed(source, "command.clothesmenu") then
                aPlayer.setSkin(playerSkin)
                return true
            else
                local store = Config.Stores[storeName]
                if store and store.ClothesStore then
                    local inventory = aPlayer.getInventory()
                    local price <const> = store.Price

                    if inventory.canRemoveItem("cash", price) then
                        inventory.removeItem("cash", price)
                        aPlayer.setSkin(playerSkin)
                        exports.ava_jobs:applyTaxes(price, storeName .. ":citizenid:" .. aPlayer.citizenId)
                        TriggerEvent("ava_logs:server:log",
                            { "citizenid:" .. aPlayer.citizenId, "payClothes", "price:" .. price })
                        return true
                    end
                end
            end
        end
        return false
    end)
