-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function CreateInventory(name, label, max_weight, identifier, items)
	local self = {}

	self.identifier = identifier
	self.name = name
	self.label = label
	self.items = items
	self.max_weight = max_weight
	self.actual_weight = 0
	self.modified = false

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
	end

	self.addItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count + count

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

		self.updateWeight()
		self.modified = true
	end

	self.setItem = function(name, count)
		local item = self.getItem(name)
		item.count = count

		self.updateWeight()
		self.modified = true
	end

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

		local fromWeight = (self.max_weight - self.actual_weight) % item.weight
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
			item.count = 0
		end
		self.actual_weight = 0
		self.modified = true
	end

	return self
end

