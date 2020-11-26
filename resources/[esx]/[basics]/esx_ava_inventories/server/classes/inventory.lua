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
	end


	self.addItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count + count

		self.updateWeight()
	end

	self.removeItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count - count

		self.updateWeight()
	end

	self.setItem = function(name, count)
		local item = self.getItem(name)
		item.count = count

		self.updateWeight()
	end


	return self
end
