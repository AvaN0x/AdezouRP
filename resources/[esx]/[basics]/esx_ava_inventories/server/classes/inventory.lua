-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function CreateInventory(name, label, max_weight, identifier, items, money, dirtyMoney, playerSource)
	local self = {}

	self.identifier = identifier
	self.name = name
	self.label = label
	self.items = items
	self.max_weight = max_weight
	self.actual_weight = 0
	self.modified = false
    self.playerSource = playerSource

	self.money = money
    self.dirtyMoney = dirtyMoney
    self.modifiedMoney = false

    
    -----------
    -- Items --
    -----------
	self.updateWeight = function()
		self.actual_weight = 0
		for k, v in ipairs(items) do
			self.actual_weight = self.actual_weight + v.count * v.weight
		end
	end

	self.updateWeight() --? init weight value

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end

		if Items[name] then
			item = {
				name  = name,
				count = 0,
				label = Items[name].label,
				limit = Items[name].limit,
				weight = Items[name].weight
			}

			table.insert(self.items, item)
			return item
		else
			return nil
		end
	end

	self.addItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count + count

        if self.playerSource then
            TriggerClientEvent('avan0x_hud:inventoryItemNotification', self.playerSource, true, item.label, count)
        end

		self.updateWeight()
		self.modified = true
	end

	-- todo return count left
	-- todo self.addMaxItem = function(name, count)
	-- todo end)

	self.removeItem = function(name, count)
		local item = self.getItem(name)
		local new_count = item.count - count
		item.count = new_count >= 0 and new_count or 0

        if self.playerSource then
            TriggerClientEvent('avan0x_hud:inventoryItemNotification', self.playerSource, false, item.label, count)
        end

		self.updateWeight()
		self.modified = true
	end

	self.setItem = function(name, count)
		local item = self.getItem(name)
		item.count = count

		self.updateWeight()
		self.modified = true
	end

    -- TODO second arg for items to check without (ex for treatment)
	self.canAddItem = function(name, count)
		local item = self.getItem(name)
		if self.identifier ~= nil and item.limit ~= -1 and item.count + count > item.limit then -- only check limit if not shared inventory
			return false
		else
			if self.actual_weight + count * item.weight > self.max_weight then
				return false
			else
				return true
			end
		end
	end

    -- TODO second arg for items to check without (ex for treatment)
	self.canAddAllItem = function(items) -- {name, count}
		local total_weight = 0
		for k, v in ipairs(items) do
			local item = self.getItem(v.name)
			if self.identifier ~= nil and item.limit ~= -1 and item.count + v.count > item.limit then -- only check limit if not shared inventory
				return false
			end
			total_weight = total_weight + v.count * item.weight
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

		local fromWeight = math.floor((self.max_weight - self.actual_weight) / item.weight)
		if self.identifier ~= nil and item.limit ~= -1 then -- only check limit if not shared inventory
			local fromLimit = item.limit - item.count
			if fromLimit < 0 then
				fromLimit = 0
			end
			return fromLimit < fromWeight and fromLimit or fromWeight
		else
			return fromWeight
		end
	end

	self.canRemoveItem = function(name, count)
		local item = self.getItem(name)
		if item.count >= count then
			return true
		else
			return false
		end
	end

	self.clearInventory = function()
		for k, item in ipairs(self.items) do
            if self.playerSource and item.count > 0 then
                TriggerClientEvent('avan0x_hud:inventoryItemNotification', self.playerSource, false, item.label, item.count)
            end
			item.count = 0
		end
		self.actual_weight = 0
		self.modified = true
	end



    -----------
    -- Money --
    -----------
    self.addMoney = function(amount)
        if self.identifier ~= nil then
            print(self.identifier .. " tried to add money to its account (" .. amount .. ")")
            return
        end

        self.money = self.money + amount
        
        self.modifiedMoney = true
    end

    self.removeMoney = function(amount)
        if self.identifier ~= nil then
            print(self.identifier .. " tried to add money to its account (" .. amount .. ")")
            return
        end

        self.money = self.money - amount

        self.modifiedMoney = true
    end

    self.setMoney = function(amount)
        if self.identifier ~= nil then
            print(self.identifier .. " tried to add money to its account (" .. amount .. ")")
            return
        end

        self.money = amount

        self.modifiedMoney = true
    end


    -----------
    -- DirtyMoney --
    -----------
    self.addDirtyMoney = function(amount)
        if self.identifier ~= nil then
            print(self.identifier .. " tried to add money to its account (" .. amount .. ")")
            return
        end

        self.dirtyMoney = self.dirtyMoney + amount

        self.modifiedMoney = true
    end

    self.removeDirtyMoney = function(amount)
        if self.identifier ~= nil then
            print(self.identifier .. " tried to add money to its account (" .. amount .. ")")
            return
        end

        self.dirtyMoney = self.dirtyMoney - amount

        self.modifiedMoney = true
    end

    self.setDirtyMoney = function(amount)
        if self.identifier ~= nil then
            print(self.identifier .. " tried to add money to its account (" .. amount .. ")")
            return
        end

        self.dirtyMoney = amount

        self.modifiedMoney = true
    end


    ----------
    -- SAVE --
    ----------

	self.saveInventory = function()
		if self.modified == true then
			if self.identifier == nil then
				print("Save inventory for ".. self.name)
				for k, item in ipairs(items) do
					MySQL.Async.execute('INSERT INTO inventories_items (name, item, count) VALUES (@name, @item, @count) ON DUPLICATE KEY UPDATE count = @count', {
						['@name'] = self.name,
						['@item'] = item.name,
						['@count'] = item.count
					})
				end
			else
				print("Save inventory for ".. self.name .. " of " .. self.identifier)
				for k, item in ipairs(items) do
					MySQL.Async.execute('INSERT INTO inventories_items (name, item, count, identifier) VALUES (@name, @item, @count, @identifier) ON DUPLICATE KEY UPDATE count = @count', {
						['@name'] = self.name,
						['@item'] = item.name,
						['@count'] = item.count,
						['@identifier'] = self.identifier
					})
				end
			end
			self.modified = false
		end

        if self.modifiedMoney == true and self.identifier == nil then
            print("Save money inventory for ".. self.name)
            MySQL.Async.execute('UPDATE inventories SET money = @money, dirty_money= @dirtyMoney WHERE name = @name', {
                ['@name'] = self.name,
                ['@money'] = self.money,
                ['@dirtyMoney'] = self.dirtyMoney
            })
            self.modifiedMoney = false
        end
	end


	return self
end

