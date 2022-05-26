-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Items = AVAConfig.Items

function CreateInventory(invType, invIdentifier, items, max_weight, label)
    ---@class inventory
    local self = {}

    invType = tonumber(invType)
    if invType == 0 then
        -- Player inventory
        self.playerSrc = invIdentifier
    elseif invType == 1 then
        -- Named inventory
        self.namedInventory = invIdentifier
    elseif invType == 2 then
        -- Vehicle inventory
        self.vehicleIdentifier = invIdentifier
    else
        -- Else
        self.identifier = invIdentifier
    end
    self.items = items
    self.max_weight = max_weight

    -- identifier and label are not used in case of a player inventory
    self.identifier = identifier
    self.label = label or GetString("inventory")

    self.actual_weight = 0
    self.modified = false

    -----------
    -- Items --
    -----------
    self.updateWeight = function()
        self.actual_weight = 0
        for i = 1, #self.items, 1 do
            if Items[self.items[i].name] then
                self.actual_weight = self.actual_weight + self.items[i].quantity * Items[self.items[i].name].weight
            end
        end
    end

    self.updateWeight() -- * init weight value

    ---Get an item from the inventory, warning: it'll add the item when not found
    ---@param name string item name
    ---@return any item
    ---@return integer index
    self.getItem = function(name)
        if Items[name] then
            for i = 1, #self.items, 1 do
                if self.items[i].name == name then
                    return self.items[i], i
                end
            end

            local index = #self.items + 1
            self.items[index] = { name = name, quantity = 0 }

            return self.items[index], index
        else
            return nil
        end
    end

    self.getItemQuantity = function(name)
        if Items[name] then
            for i = 1, #self.items, 1 do
                if self.items[i].name == name then
                    return self.items[i].quantity
                end
            end
            return 0
        end
        return nil
    end

    ---@return boolean success
    self.addItem = function(name, quantity)
        if quantity <= 0 then
            return false
        end

        local item = self.getItem(name)
        if item then
            quantity = math.floor(quantity)
            item.quantity = item.quantity + quantity

            self.updateWeight()
            self.modified = true

            if self.playerSrc then
                TriggerClientEvent("ava_core:client:editItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, true, quantity, item.quantity)
                TriggerEvent("ava_core:server:editPlayerItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, true, quantity, item.quantity)
            end
            return true
        end
        return false
    end

    --- Automatically check how much the inventory can carry, and drop the item when it's too heavy
    --- Only works with player inventories
    ---@param name string
    ---@param quantity number
    ---@return boolean|nil "wether item was dropped or not"
    self.addOrDropItem = function(name, quantity)
        if quantity <= 0 or not self.playerSrc or not Items[name] then
            return nil
        end

        local canTake = self.canTake(name)
        if canTake >= quantity then
            self.addItem(name, quantity)
            return false
        else
            self.addItem(name, canTake)

            -- Drop pickup
            local playerPed = GetPlayerPed(self.playerSrc)
            if playerPed then
                local playerCoords = GetEntityCoords(playerPed)

                AVA.CreatePickup(vector3(playerCoords.x, playerCoords.y, playerCoords.z - 1.0), name, quantity - canTake)
            end
            return true
        end
    end

    ---@return boolean success
    self.removeItem = function(name, quantity)
        if quantity <= 0 then
            return false
        end

        local item, index = self.getItem(name)
        if item then
            quantity = math.floor(quantity)
            local new_quantity = item.quantity - quantity
            -- TODO remove totally element from inventory if 0?
            item.quantity = new_quantity

            if item.quantity <= 0 then
                table.remove(self.items, index)
            end

            self.updateWeight()
            self.modified = true

            if self.playerSrc then
                TriggerClientEvent("ava_core:client:editItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, false, quantity, item.quantity)
                TriggerEvent("ava_core:server:editPlayerItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, false, quantity, item.quantity)
            end
            return true
        end
        return false
    end

    self.setItem = function(name, quantity)
        if quantity < 0 then
            return
        end

        local item = self.getItem(name)
        if item then
            quantity = math.floor(quantity)
            item.quantity = quantity

            -- TODO: remove if 0, trigger events

            self.updateWeight()
            self.modified = true
        end
    end

    self.canAddItem = function(name, quantity)
        if quantity < 0 then
            return false
        end

        local item = self.getItem(name)
        if item then
            if self.identifier ~= nil and Items[item.name].limit and item.quantity + quantity > Items[item.name].limit then -- only check limit if player inventory
                return false
            else
                if self.actual_weight + quantity * Items[item.name].weight > self.max_weight then
                    return false
                else
                    return true
                end
            end
        end
    end

    self.canAddAllItems = function(items) -- {name: string, quantity: number}
        local total_weight = 0
        for k, v in ipairs(items) do
            if not v.name or v.quantity == nil or v.quantity < 0 then
                return false
            end

            local item = self.getItem(v.name)
            if item then
                if self.playerSrc == nil and Items[item.name].limit and item.quantity + v.quantity > Items[item.name].limit then -- only check limit if player inventory
                    return false
                end
                total_weight = total_weight + v.quantity * Items[item.name].weight
            end
        end
        if self.actual_weight + total_weight > self.max_weight then
            return false
        else
            return true
        end
    end

    self.canTake = function(name)
        if self.actual_weight > self.max_weight then
            return 0
        end
        local item = self.getItem(name)
        if item then
            local fromWeight = math.floor((self.max_weight - self.actual_weight) / Items[item.name].weight)
            if self.playerSrc ~= nil and Items[item.name].limit then -- only check limit if player inventory
                local fromLimit = Items[item.name].limit - item.quantity
                if fromLimit < 0 then
                    fromLimit = 0
                end
                return fromLimit < fromWeight and fromLimit or fromWeight
            else
                return fromWeight
            end
        end
        return 0
    end

    self.canRemoveItem = function(name, quantity)
        if quantity < 0 then
            return false
        end

        local item = self.getItem(name)
        if item then
            if item.quantity >= quantity then
                return true
            else
                return false
            end
        end
        return false
    end

    self.clearInventory = function()
        for i = #self.items, 1, -1 do
            local item = self.items[i]
            if item then
                local oldQuantity = item.quantity
                item.quantity = 0

                if self.playerSrc and oldQuantity > 0 and Items[item.name] then
                    TriggerClientEvent("ava_core:client:editItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, false, oldQuantity, 0)
                    TriggerEvent("ava_core:server:editPlayerItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, false, oldQuantity, 0)
                end
            end

            -- Remove from inventory
            self.items[i] = nil
        end
        self.actual_weight = 0
        self.modified = true
    end

    ----------
    -- SAVE --
    ----------

    self.save = function()
        return AVA.SaveNamedInventory(self)
    end

    return self
end
