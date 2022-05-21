function CreateAddonInventory(name, owner, items)
	local self = {}

	self.name  = name
	self.owner = owner
	self.items = items

	self.addItem = function(name, count)
		local item = self.getItem(name)
		item.count = item.count + count

		Citizen.Wait(100)
		self.saveItem(name, item.count)
	end

	self.removeItem = function(name, count)
		local item = self.getItem(name)

		if (item.count - count) >= 0 then
			item.count = item.count - count
			self.saveItem(name, item.count)
	
			return true
		end

		return false
	end

	self.setItem = function(name, count)
		local item = self.getItem(name)
		item.count = count

		self.saveItem(name, item.count)
	end

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end
		
		local tires = 0
		while not Items[name] and tires < 2000 do
			Citizen.Wait(100)
			tires = tires + 1
		end

		local item = {
			name  = name,
			count = 0,
			label = Items[name].label,
			type = Items[name].type
		}

		table.insert(self.items, item)

		if self.owner == nil then
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count) VALUES (@inventory_name, @item_name, @count)',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = 0
			})
		else
			MySQL.Async.execute('INSERT INTO addon_inventory_items (inventory_name, name, count, owner) VALUES (@inventory_name, @item_name, @count, @owner)',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = 0,
				['@owner']          = self.owner
			})
		end
		
		return item
	end

	self.saveItem = function(name, count)
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = count
			})
		else
			MySQL.Async.execute('UPDATE addon_inventory_items SET count = @count WHERE inventory_name = @inventory_name AND name = @item_name AND owner = @owner',
			{
				['@inventory_name'] = self.name,
				['@item_name']      = name,
				['@count']          = count,
				['@owner']          = self.owner
			})
		end
	end

	return self
end

