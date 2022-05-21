ESX                     = nil
Items                   = {}
local InventoriesIndex  = {}
local Inventories       = {}
local SharedInventories = {}


TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_addoninventory:DynamicItem')
AddEventHandler('esx_addoninventory:DynamicItem', function(state, item)
	if state then
		if item ~= nil then
			if not Items[item.name] then
				Items[item.name] = {
					label = item.label,
					type = item.type
				}
			end
		end	
	else		
		if item ~= nil then
			if Items[item.name] then
				Items[item.name] = nil
			end
		end
	end
end)

MySQL.ready(function()
	local items = MySQL.Sync.fetchAll('SELECT * FROM items')

	for i=1, #items, 1 do
		Items[items[i].name] = {
			label = items[i].label,
			type = items[i].type
		}
	end

	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory')
	local mieszkania = MySQL.Sync.fetchAll('SELECT * FROM properties WHERE is_gateway = 0')
	
	for k=1, #mieszkania, 1 do
		table.insert(result, {name = 'property' .. mieszkania[k].name, label = "Mieszkanie", shared = 1})
	end
	
	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
			['@inventory_name'] = name
		})

		if shared == 0 then

			table.insert(InventoriesIndex, name)

			Inventories[name] = {}
			local items       = {}

			for j=1, #result2, 1 do
				local itemName  = result2[j].name
				local itemCount = result2[j].count
				local itemOwner = result2[j].owner

				if Items[itemName] then
					if items[itemOwner] == nil then
						items[itemOwner] = {}
					end

					table.insert(items[itemOwner], {
						name  = itemName,
						count = itemCount,
						label = Items[itemName].label,
						type = Items[itemName].type
					})
				else
					--print(('esx_addon_inventory_2: invalid item %s (type: %s)'):format(itemName, type(itemName)))
				end
			end

			for k,v in pairs(items) do
				local addonInventory = CreateAddonInventory(name, k, v)
				table.insert(Inventories[name], addonInventory)
			end

		else

			local items = {}

			for j=1, #result2, 1 do
				if Items[result2[j].name] then
					table.insert(items, {
						name  = result2[j].name,
						count = result2[j].count,
						label = Items[result2[j].name].label,
						type = Items[result2[j].name].type
					})
				else
					--print(('esx_addon_inventory_1: invalid item %s (type: %s)'):format(result2[j].name, type(result2[j].name)))
				end
			end

			local addonInventory    = CreateAddonInventory(name, nil, items)
			SharedInventories[name] = addonInventory

		end
	end
end)

function GetInventory(name, owner)
	for i=1, #Inventories[name], 1 do
		if Inventories[name][i].owner == owner then
			return Inventories[name][i]
		end
	end
end

function GetSharedInventory(name)
	return SharedInventories[name]
end

AddEventHandler('esx_addoninventory:getInventory', function(name, owner, cb)
	cb(GetInventory(name, owner))
end)

AddEventHandler('esx_addoninventory:getSharedInventory', function(name, cb)
	cb(GetSharedInventory(name))
end)

AddEventHandler('esx:playerLoaded', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local addonInventories = {}

	for i=1, #InventoriesIndex, 1 do
		local name      = InventoriesIndex[i]
		local inventory = GetInventory(name, xPlayer.identifier)
		
		if inventory == nil then
			inventory = CreateAddonInventory(name, xPlayer.identifier, {})
			table.insert(Inventories[name], inventory)
		end

		table.insert(addonInventories, inventory)
	end

	xPlayer.set('addonInventories', addonInventories)
end)
