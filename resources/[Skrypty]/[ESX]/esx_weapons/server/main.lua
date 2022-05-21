ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_newweaponshop:buyWeapon', function(source, cb, weaponName, type, zone)
	local xPlayer = ESX.GetPlayerFromId(source)	
	local authorizedWeapons, selectedWeapon = Config.Zones[zone].Items
	
	for k,v in ipairs(Config.Zones[zone].Items) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		cb(false)
	end

	if zone == 'GunShop' then
		if type == 1 then
			if xPlayer.getMoney() >= selectedWeapon.price then
				xPlayer.removeMoney(selectedWeapon.price)
				xPlayer.addInventoryWeapon(weaponName, 1, 100, true)
				exports['exile_logs']:SendLog(source, "Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
			end
		elseif type == 2 then			
			if xPlayer.getMoney() >= selectedWeapon.price then
				if xPlayer.canCarryItem(weaponName, 1) then
					xPlayer.removeMoney(selectedWeapon.price)
					xPlayer.addInventoryItem(weaponName, 1)
				else
					xPlayer.showNotification('~r~Nie możesz więcej unieść')
				end
			else	
				cb(false)
			end
		end
	elseif zone == 'GunShopDS' then
			if type == 1 then
				if xPlayer.getMoney() >= selectedWeapon.price then
					xPlayer.removeMoney(selectedWeapon.price)
					xPlayer.addInventoryWeapon(weaponName, 1, 100, true)
					exports['exile_logs']:SendLog(source, "MAFIA: Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
				end
			elseif type == 2 then			
				if xPlayer.getMoney() >= selectedWeapon.price then
					if xPlayer.canCarryItem(weaponName, 1) then
						xPlayer.removeMoney(selectedWeapon.price)
						xPlayer.addInventoryItem(weaponName, 1)
					else
						xPlayer.showNotification('~r~Nie możesz więcej unieść')
					end
				else	
					cb(false)
				end
			end
	else
		if type == 1 then
			if xPlayer.getAccount('black_money').money >= selectedWeapon.price then
				xPlayer.removeAccountMoney('black_money', selectedWeapon.price)
				
				xPlayer.addInventoryWeapon(weaponName, 1, 100, false)
				
				exports['exile_logs']:SendLog(source, "Zakupił broń w sklepie: "..weaponName, 'sklepzbronia')
				cb(true)
			else
				TriggerClientEvent('esx:showNotification', source, _U('not_enough_black'))
				cb(false)
			end
		elseif type == 2 then			
			if xPlayer.getAccount('black_money').money >= selectedWeapon.price then
				if xPlayer.canCarryItem(extended, 1) then
					xPlayer.removeAccountMoney('black_money', selectedWeapon.price)
					xPlayer.addInventoryItem(weaponName, 1)
				else
					xPlayer.showNotification('~r~Nie możesz więcej unieść')
				end
			else	
				cb(false)
			end
		end
	end
end)