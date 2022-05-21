ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)


TriggerEvent('esx_society:registerSociety', 'fire', 'fire', 'society_fire', 'society_fire', 'society_fire', {type = 'public'})

RegisterServerEvent(GetCurrentResourceName()..':giveItem')
AddEventHandler(GetCurrentResourceName()..':giveItem', function(item, amount, resourceName)
  if item == 'medikit' or item == 'bandage' or item == 'gps' or item == 'bodycam' or item == 'radio' then
      if resourceName == GetCurrentResourceName() then
      local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'fire' then
          if xPlayer.getInventoryItem(item).count < amount then
            if item == 'medikit' or item == 'bandage' then
            xPlayer.addInventoryItem(item, 20)
            else
              xPlayer.addInventoryItem(item, 1)
            end
            else
            TriggerClientEvent('esx:showNotification', source, 'Posiadasz już limit ')
          end
        else 
          exports['exile_logs']:SendLog(source, "SAFD: Próba dodania itemu bez pracy safdu : giveitem", 'anticheat', '15844367')
        end
      else
      exports['exile_logs']:SendLog(source, "SAFD: Próba obejścia eventu: giveitem", 'anticheat', '15844367')
      end
    else
      exports['exile_logs']:SendLog(source, "SAFD: próba zrespienia innego itemu niż w skrypcie dla itemu: "..item..'', 'anticheat', '15844367')
    end
end)
RegisterServerEvent(GetCurrentResourceName()..':giveWeapon')
AddEventHandler(GetCurrentResourceName()..':giveWeapon', function(item, amount, resourceName)
  if item == 'WEAPON_HATCHET' or item == 'WEAPON_FIREEXTINGUISHER' or item == 'WEAPON_CROWBAR' then
    if resourceName == GetCurrentResourceName() then
      local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer.job.name == 'fire' then
          if amount <= 1 then
                  xPlayer.addInventoryItem(item,1)
            else
              exports['exile_logs']:SendLog(source, "SAFD: Próba dodania więcej niż 1 broni", 'anticheat', '15844367')
            end
        else 
          exports['exile_logs']:SendLog(source, "SAFD: Próba dodania itemu bez pracy safdu : giveitem", 'anticheat', '15844367')
        end
      else
      exports['exile_logs']:SendLog(source, "SAFD: Próba obejścia eventu: giveitem", 'anticheat', '15844367')
      end
    else
      exports['exile_logs']:SendLog(source, "SAFD: próba zrespienia innego itemu niż w skrypcie dla itemu: "..item..'', 'anticheat', '15844367')
    end
end)


RegisterServerEvent('exile_safd:getStockItem')
AddEventHandler('exile_safd:getStockItem', function(itemName, count, resourceName)
if resourceName == GetCurrentResourceName() then
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == 'fire' then
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fire', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Niepoprawna ~s~ilość')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Zabrałeś ~y~x' .. count .. ' ' .. item.label)

  end)
else
  exports['exile_logs']:SendLog(source, "SAFD: Próba dodania itemu bez pracy safdu : stocks", 'anticheat', '15844367')
end
else
  exports['exile_logs']:SendLog(source, "SAFD: Próba obejśćia eventu : stocks", 'anticheat', '15844367')
end

end)

RegisterServerEvent('exile_safd:putStockItems')
AddEventHandler('exile_safd:putStockItems', function(itemName, count, resourceName)
if resourceName == GetCurrentResourceName() then
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == 'fire' then
  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fire', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, '~r~Niepoprawna ilość')
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Oddałeś ~y~x' .. count .. ' ' .. item.label)

  end)
  else
    exports['exile_logs']:SendLog(source, "SAFD: Próba dodania itemu bez pracy safdu : stocks", 'anticheat', '15844367')
  end
else 
  exports['exile_logs']:SendLog(source, "SAFD: Próba obejścia eventu : stocks", 'anticheat', '15844367')
end
end)



ESX.RegisterServerCallback('exile_safd:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fire', function(inventory)
    cb(inventory.items)
  end)

end)

ESX.RegisterServerCallback('exile_safd:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)


ESX.RegisterServerCallback('esx_society:getEmployeeslic', function(source, cb, job, society)
	MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job OR job = @job2 ORDER BY job_grade DESC', {
		['@job'] = society,
		['@job2'] = 'off'..society,			
	}, function (results)
		local employees = {}
		local count = 0		
		for i=1,99 do 
      if results[i] ~= nil then
         count = i 
        else 
          break 
        end 
      end
			
			
			
			for i=1, #results, 1 do
	
				local nurek = false
        local drive = false
        local fto = false
        local pilot = false
        local hazmat = false
				MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
					['@owner'] = results[i].identifier,	
				}, function (results2)
					for k,v in pairs (results2) do
						
						if v.type == 'safd_nurek' then
							nurek = true
						elseif v.type == 'safd_drive' then
							drive = true
						elseif v.type == 'safd_fto' then
							fto = true
						elseif v.type == 'safd_pilot' then
							pilot = true
						elseif v.type == 'safd_hazmat' then
							hazmat = true
      
						end
					end	
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					licensess = {
					nurek = nurek,
					drive = drive,
					fto = fto,
					pilot = pilot,
					hazmat = hazmat,
					
					}
				})	
				if count == i then
					cb(employees)
				end				
				end)

								

			end

		

	end)
end)

RegisterServerEvent('exile_safd:addlicense')
AddEventHandler('exile_safd:addlicense', function (identifier, licka)
    local _source = source

  MySQL.Async.execute(
    'INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)',
    {
      ['@type'] = licka,
      ['@owner']   = identifier
    },
    function (rowsChanged)
return
end)
xPlayers = ESX.GetExtendedPlayers() 
for i=1, #xPlayers, 1 do
  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
  if xPlayer.job.name == 'fire' then
    TriggerClientEvent('exile_safd:dLic', xPlayers[i])
  end
end
end)

RegisterServerEvent('exile_safd:removelicense')
AddEventHandler('exile_safd:removelicense', function (identifier, licka)
    local _source = source

  MySQL.Async.execute(
    'DELETE FROM user_licenses WHERE owner = @owner AND type = @type',
    {
      ['@type'] = licka,
      ['@owner']   = identifier
    },
    function (rowsChanged)
return
end)
xPlayers = ESX.GetExtendedPlayers() 
for i=1, #xPlayers, 1 do
  local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
  if xPlayer.job.name == 'fire' then
    TriggerClientEvent('exile_safd:dLic', xPlayers[i])
  end
end

end)
TriggerEvent('esx_phone:registerNumber', 'fire', 'Wezwij SAFD', true, true)

CreateThread(function()
  while true do
  Citizen.Wait(60000 * Config.PozarCooldown)
    TriggerEvent('exile_safd:alert', 'fire')
  end 
end)

RegisterServerEvent('exile_safd:alert')
AddEventHandler('exile_safd:alert', function(what)
  xPlayers = ESX.GetExtendedPlayers() 
  local pozar = {
    'Vanilla', 'Grapeseed'
  }
  for i=1, #xPlayers, 1 do
    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    if xPlayer.job.name == 'fire' then
      TriggerClientEvent('exile_safd:paliSieKurwa', xPlayers[i], pozar[math.random(1, #pozar)])
    end
  end
end)

ESX.RegisterServerCallback('exile_safd:pp', function(source) 
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == 'fire' then
    xPlayer.addMoney(20000)
    TriggerClientEvent('esx:showNotification', source, 'Otrzymujesz ~g~20.000$~s~ za wykonanie zlecenia')
  else
    exports['exile_logs']:SendLog(source, "SAFD: próba dodania pieniędzy", 'anticheat', '15844367')
  end
end)