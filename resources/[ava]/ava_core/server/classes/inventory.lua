-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local Items = AVAConfig.Items

function CreateInventory(playerSrc, items, max_weight, identifier, label)
	local self = {}

    self.playerSrc = playerSrc
	self.items = items
	self.max_weight = max_weight

    -- identifier and label are not used in case of a player inventory
	self.identifier = identifier
	self.label = label or "Inventaire"

	self.actual_weight = 0
	self.modified = false


    -----------
    -- Items --
    -----------
	self.updateWeight = function()
		self.actual_weight = 0
		for i=1, #self.items, 1 do
			self.actual_weight = self.actual_weight + self.items[i].quantity * Items[self.items[i].name].weight
		end
	end

	self.updateWeight() --* init weight value

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end

		if Items[name] then
			item = {
				name  = name,
				quantity = 0
			}

			table.insert(self.items, item)
			return item
		else
			return nil
		end
	end

	self.addItem = function(name, quantity)
        if quantity <= 0 then
            return
        end

		local item = self.getItem(name)
        if item then
            item.quantity = item.quantity + quantity

            if self.playerSrc then
                TriggerClientEvent("ava_core:client:editItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, quantity, item.quantity)
            end

            self.updateWeight()
            self.modified = true
        end
	end

	self.removeItem = function(name, quantity)
        if quantity <= 0 then
            return
        end

		local item = self.getItem(name)
        if item then
            local new_quantity = item.quantity - quantity
            item.quantity = new_quantity >= 0 and new_quantity or 0

            if self.playerSrc then
                TriggerClientEvent("ava_core:client:editItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, 0 - quantity, item.quantity)
            end
            -- TODO remove totally element from inventory if 0?
            self.updateWeight()
            self.modified = true
        end
	end

	self.setItem = function(name, quantity)
        if quantity < 0 then
            return
        end

		local item = self.getItem(name)
        if item then
            item.quantity = quantity

            self.updateWeight()
            self.modified = true
        end
	end

    -- TODO second arg for items to check without other items (ex for treatment)
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

    -- TODO second arg for items to check without other items (ex for treatment)
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
            if self.playerSrc == nil and Items[item.name].limit then -- only check limit if player inventory
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
		for k, item in ipairs(self.items) do
            if self.playerSrc and item.quantity > 0 then
                TriggerClientEvent("ava_core:client:editItemInventoryCount", self.playerSrc, item.name, Items[item.name].label, 0 - item.quantity, 0)
            end
            -- TODO remove totally element from inventory ?
			item.quantity = 0
		end
		self.actual_weight = 0
		self.modified = true
	end





    ----------
    -- SAVE --
    ----------

	self.saveInventory = function()
		if self.modified == true then


			self.modified = false
		end
	end


	return self
end

