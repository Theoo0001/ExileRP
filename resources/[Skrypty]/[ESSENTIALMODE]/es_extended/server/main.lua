local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function string.random(length)
	math.randomseed(os.time())

	if length > 0 then
		return string.random(length - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end

ESX.RegisterUsableItem('clip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'clip')
end)

ESX.RegisterUsableItem('extendedclip', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'extendedclip')
end)

ESX.RegisterUsableItem('clipsmg', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'clipsmg')
end)

ESX.RegisterUsableItem('clipaddons', function(source)	
	TriggerClientEvent('esx_weashop:clipcli', source, 'clipaddons')
end)

RegisterServerEvent('esx_weashop:remove')
AddEventHandler('esx_weashop:remove', function(extended)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local item = xPlayer.getInventoryItem(extended).count 
	if item >= 1 then
		xPlayer.removeInventoryItem(extended, 1)
	end
end)



RegisterNetEvent('es_extneded:giveclip')
AddEventHandler('es_extneded:giveclip', function(extended)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		if extended then
			if xPlayer.canCarryItem(extended, 1) then
				xPlayer.addInventoryItem(extended, 1)
			else	
				xPlayer.showNotification('~s~Nie możesz mieć więcej magazynków')
			end
		end
	end
end)

RegisterNetEvent('es_extended:componentMenu')
AddEventHandler('es_extended:componentMenu', function(state, comp)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if state then
		xPlayer.removeInventoryItem(comp, 1)
	else
		xPlayer.addInventoryItem(comp, 1)
	end
end)

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
	if not ESX.Players[source] then
		onPlayerJoined(source)
	end
end)

function onPlayerJoined(playerId)
	local identifier

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end

	if identifier then
		if ESX.GetPlayerFromIdentifier(identifier) then
			DropPlayer(playerId, ('there was an error loading your character!\nError code: identifier-active-ingame\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(identifier))
		else
			MySQL.Async.fetchScalar('SELECT 1 FROM users WHERE identifier = @identifier', {
				['@identifier'] = identifier
			}, function(result)
				if result then
					loadESXPlayer(identifier, playerId)
				else
					local accounts = {}

					for account,money in pairs(Config.StartingAccountMoney) do
						accounts[account] = money
					end

					MySQL.Async.execute('INSERT INTO users (accounts, identifier) VALUES (@accounts, @identifier)', {
						['@accounts'] = json.encode(accounts),
						['@identifier'] = identifier
					}, function(rowsChanged)
						loadESXPlayer(identifier, playerId)
					end)
				end
			end)
		end
	else
		DropPlayer(playerId, 'there was an error loading your character!\nError code: identifier-missing-ingame\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
	end
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	local playerId, identifier = source
	Citizen.Wait(100)
	
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
	
	if identifier then
		if ESX.GetPlayerFromIdentifier(identifier) then
			deferrals.done(('There was an error loading your character!\nError code: identifier-active\n\nThis error is caused by a player on this server who has the same identifier as you have. Make sure you are not playing on the same Rockstar account.\n\nYour Rockstar identifier: %s'):format(identifier))
		else
			deferrals.done()
		end	
	else
		deferrals.done('There was an error loading your character!\nError code: identifier-missing\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
	end
end)

function loadESXPlayer(identifier, playerId)
	local tasks = {}
	local userData = {
		accounts = {},
		inventory = {},
		job = {},
		character    = {},
		playerName = GetPlayerName(playerId),
		hiddenjob    = {},
		dealerLevel  = {},
		digit        = 0,
		--skills 		 = {},
		slot = {},
		opaska 		 = 0
	}

	table.insert(tasks, function(cb)
		MySQL.Async.fetchAll('SELECT accounts, job, job_grade, hiddenjob, hiddenjob_grade, dealerLevel, `group`, slot, position, inventory, firstname, lastname, dateofbirth, account_number, height, sex, status, phone_number, opaska, job_id, digit FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			local job, grade, jobObject, gradeObject = result[1].job, tostring(result[1].job_grade)
			local hiddenjob, hiddenjobgrade = result[1].hiddenjob, tostring(result[1].hiddenjob_grade)
			local foundAccounts = {}
		
			if result[1].firstname and result[1].lastname ~= '' then
			    userData.character.firstname 		= result[1].firstname
                userData.character.lastname 		= result[1].lastname
                userData.character.dateofbirth  	= result[1].dateofbirth
                userData.character.sex				= result[1].sex
                userData.character.height			= result[1].height
                userData.character.status 			= result[1].status
                userData.character.phone_number 	= result[1].phone_number
                userData.character.account_number 	= result[1].account_number
                userData.character.job_id 			= result[1].job_id
				userData.character.opaska			= result[1].opaska
			end

			if result[1].accounts and result[1].accounts ~= '' then
				local accounts = json.decode(result[1].accounts)

				for account,money in pairs(accounts) do
					foundAccounts[account] = money
				end
			end
			for account,label in pairs(Config.Accounts) do
				table.insert(userData.accounts, {
					name = account,
					money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
					label = label
				})
			end

			--Flux ty kurwo
			if ESX.DoesJobExist(hiddenjob, hiddenjobgrade) then
				local jobObject, gradeObject = ESX.Jobs[hiddenjob], ESX.Jobs[hiddenjob].grades[hiddenjobgrade]

				userData.hiddenjob = {}

				userData.hiddenjob.id    = jobObject.id
				userData.hiddenjob.name  = jobObject.name
				userData.hiddenjob.label = jobObject.label

				userData.hiddenjob.grade        = tonumber(hiddenjobgrade)
				userData.hiddenjob.grade_name   = gradeObject.name
				userData.hiddenjob.grade_label  = gradeObject.label
				userData.hiddenjob.grade_salary = gradeObject.salary

				userData.hiddenjob.skin_male    = {}
				userData.hiddenjob.skin_female  = {}

				if gradeObject.skin_male ~= nil then
					userData.hiddenjob.skin_male = json.decode(gradeObject.skin_male)
				end
	
				if gradeObject.skin_female ~= nil then
					userData.hiddenjob.skin_female = json.decode(gradeObject.skin_female)
				end

			else
				local hiddenjob, hiddenjobgrade = 'unemployed', '0'
				local jobObject, gradeObject = ESX.Jobs[hiddenjob], ESX.Jobs[hiddenjob].grades[hiddenjobgrade]

				userData.hiddenjob = {}

				userData.hiddenjob.id    = jobObject.id
				userData.hiddenjob.name  = jobObject.name
				userData.hiddenjob.label = jobObject.label
	
				userData.hiddenjob.grade        = tonumber(hiddenjobgrade)
				userData.hiddenjob.grade_name   = gradeObject.name
				userData.hiddenjob.grade_label  = gradeObject.label
				userData.hiddenjob.grade_salary = gradeObject.salary
	
				userData.hiddenjob.skin_male    = {}
				userData.hiddenjob.skin_female  = {}
			end
			
			-- Job
			if ESX.DoesJobExist(job, grade) then
				jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
			else
				job, grade = 'unemployed', '0'
				jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
			end

			userData.job.id = jobObject.id
			userData.job.name = jobObject.name
			userData.job.label = jobObject.label

			userData.job.grade = tonumber(grade)
			userData.job.grade_name = gradeObject.name
			userData.job.grade_label = gradeObject.label
			userData.job.grade_salary = gradeObject.salary

			userData.job.skin_male = {}
			userData.job.skin_female = {}

			if gradeObject.skin_male then userData.job.skin_male = json.decode(gradeObject.skin_male) end
			if gradeObject.skin_female then userData.job.skin_female = json.decode(gradeObject.skin_female) end

			-- Inventory
			if result[1].inventory and result[1].inventory ~= '' then
				local inventory = json.decode(result[1].inventory)

				for name,count in pairs(inventory) do
					local item = ESX.Items[name]
					
					if item then						
						if type(item.data) =='string' then
							item.data = json.decode(item.data)
						end
				
						table.insert(userData.inventory, {
							name = name,
							count = count,
							label = item.label,
							limit = item.limit,
							usable = ESX.UsableItemsCallbacks[name] ~= nil,
							rare = item.rare,
							canRemove = item.canRemove,
							type = item.type,
							data = item.data
						})
					end
				end
			end

			table.sort(userData.inventory, function(a, b)
				return a.label < b.label
			end)

			if result[1].slot then
				userData.slot = json.decode(result[1].slot)
			end
			
			-- Group
			if result[1].group then
				userData.group = result[1].group
			else
				userData.group = 'user'
			end

			-- Position
			if result[1].position and result[1].position ~= '' then
				userData.coords = json.decode(result[1].position)
			else
				userData.coords = {x = -269.4, y = -955.3, z = 31.2, heading = 205.8}
			end
			
			if result[1].dealerLevel then
				userData.dealerLevel = json.decode(result[1].dealerLevel)
			end
			
			if result[1].digit ~= nil then
				userData.digit = result[1].digit
			end
			
		--[[	if result[1].skills or result[1].skills ~= ''  or result[1].skills ~= nil then
				userData.skills = json.decode(result[1].skills)
			else
				userData.skills = json.decode('{"dealer":0,"pracz":0,"pracocholik":0,"narkos":0,"zlodziej":0,"stamina":0,"sila":0,"kierowca":0,"nurek":0}')
			end]]
			
			cb()
		end)
	end)

	Async.parallel(tasks, function(results)
		local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.inventory, userData.job, userData.playerName, userData.coords, userData.character, userData.hiddenjob, userData.dealerLevel, userData.digit, userData.slot)
		ESX.Players[playerId] = xPlayer
		TriggerEvent('esx:playerLoaded', playerId, xPlayer)

		xPlayer.triggerEvent('esx:playerLoaded', {
			accounts = xPlayer.getAccounts(),
			coords = xPlayer.getCoords(),
			identifier = xPlayer.getIdentifier(),
			inventory = xPlayer.getInventory(),
			job = xPlayer.getJob(),
			money = xPlayer.getMoney(),
			character	 = xPlayer.getCharacter(),
			hiddenjob	 = xPlayer.getHiddenJob(),
			dealerLevel  = xPlayer.getDealerLevel(),
			digit 		 = xPlayer.getDigit(),
		--	skill        = xPlayer.getSkill(),
			slots 		 = xPlayer.getSlots(),
			group 		 = xPlayer.getGroup()
		})

	--	xPlayer.triggerEvent('esx:setSkills', userData.skills)
		xPlayer.triggerEvent('esx:registerSuggestions', ESX.RegisteredCommands)
		xPlayer.triggerEvent('EasyAdmin:refreshPermission')
	end)
end

AddEventHandler('chatMessage', function(playerId, author, message)
	if message:sub(1, 1) == '/' and playerId > 0 then
		CancelEvent()
		local commandName = message:sub(1):gmatch("%w+")()
	end
end)
--[[RegisterServerEvent('exile_skills:update')
AddEventHandler('exile_skills:update', function(a,b)
	local _source = source 
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addSkill(a, b)
end)
ESX.RegisterServerCallback('exile_skills:load', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tocb = xPlayer.getSkill()
	cb(tocb)
end)]]
AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId, reason)

		ESX.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
		end)
	end
end)

RegisterNetEvent('esx:updateSlots')
AddEventHandler('esx:updateSlots', function(slots)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.setSlots(slots)
	end
end)

RegisterNetEvent('esx:updateCoords')
AddEventHandler('esx:updateCoords', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateCoords(coords)
	end
end)

RegisterNetEvent('esx:updateWeaponAmmo')
AddEventHandler('esx:updateWeaponAmmo', function(weaponName, ammoCount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateWeaponAmmo(weaponName, ammoCount)
	end
end)

RegisterNetEvent('esx:gitestveInventoryItem')
AddEventHandler('esx:gitestveInventoryItem', function(target, type, itemName, itemCount)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == 'item_standard' or type == 'item_weapon' or type == 'item_sim' then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
				sourceXPlayer.showNotification(_U('ex_inv_lim', targetXPlayer.source))
			else				
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)

				if sourceItem.type == 'sim' then
					if sourceXPlayer.character.phone_number == sourceItem.data.number then
						sourceXPlayer.triggerEvent('gcPhone:myPhoneNumber', nil)
						sourceXPlayer.setCharacter('phone_number', '')			
					end
				end
			
				sourceXPlayer.showNotification(_U('gave_item', itemCount, sourceItem.label, targetXPlayer.source))
				targetXPlayer.showNotification(_U('received_item', itemCount, sourceItem.label, sourceXPlayer.source))
				TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Przekazuje przedmiot")
				exports['exile_logs']:SendLog(playerId, "Przekazano przedmiot: " .. sourceItem.label .. " x" .. itemCount .. " dla [" .. target .. "] " .. GetPlayerName(target), 'item_give', '2123412')			
			end
		else
			sourceXPlayer.showNotification(_U('imp_invalid_quantity'))
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney   (itemName, itemCount)

			sourceXPlayer.showNotification(_U('gave_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], targetXPlayer.source))
			targetXPlayer.showNotification(_U('received_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], sourceXPlayer.source))
			TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Przekazuje pieniądze")
			exports['exile_logs']:SendLog(playerId, "Przekazano pieniądze: " .. ESX.Math.GroupDigits(itemCount) .. "$ dla [" .. target .. "] " .. GetPlayerName(target), 'item_give', '15844367')
		else
			sourceXPlayer.showNotification(_U('imp_invalid_amount'))
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' or type == 'item_weapon' or type == 'item_sim' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_quantity'))
		else
			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				xPlayer.showNotification(_U('imp_invalid_quantity'))
			else
				xPlayer.removeInventoryItem(itemName, itemCount)
				xPlayer.showNotification(_U('threw_standard', itemCount, xItem.label))
				TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Upuścił przedmiot")
				exports['exile_logs']:SendLog(playerId, "Wyrzucono przedmiot: " .. xItem.label .. " x" .. itemCount, 'item_drop', '2123412')
				
				if type == 'item_weapon' then
					ESX.DeleteDynamicItem(itemName)
				end
			end
		end
	elseif type == 'item_account' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local account = xPlayer.getAccount(itemName)

			if (itemCount > account.money or account.money < 1) then
				xPlayer.showNotification(_U('imp_invalid_amount'))
			else
				xPlayer.removeAccountMoney(itemName, itemCount)
				xPlayer.showNotification(_U('threw_account', ESX.Math.GroupDigits(itemCount), string.lower(account.label)))
				TriggerClientEvent('sendProximityMessageDo', -1, playerId, playerId, "Upuścił pieniądze")
				exports['exile_logs']:SendLog(playerId, "Wyrzucono pieniądze: " .. ESX.Math.GroupDigits(itemCount) .. "$", 'item_drop', '15844367')
			end
		end
	end
end)

RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(itemName)

	if item.count > 0 then
		if item.type == 'sim' then
			if xPlayer.character.phone_number == item.data.number then
				MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
					['@identifier']   = xPlayer.identifier,
					['@phone_number'] = ''
				}, function(pass)
					if pass then
						xPlayer.showNotification('Odłączono kartę SIM #'..tostring(item.data.number)) 
						xPlayer.triggerEvent('gcPhone:myPhoneNumber', nil)
						xPlayer.setCharacter('phone_number', '')
					end
				end)
			else
				MySQL.Async.execute('UPDATE users SET phone_number = @phone_number WHERE identifier = @identifier', {
					['@identifier']   = xPlayer.identifier,
					['@phone_number'] = item.data.number
				}, function(pass)
					if pass then
						xPlayer.showNotification('Podłączono kartę SIM #'..item.data.number)
						xPlayer.triggerEvent('gcPhone:myPhoneNumber', item.data.number)
						xPlayer.setCharacter('phone_number', item.data.number)
					end
				end)
			end		
		else
			ESX.UseItem(source, itemName)
		end
	else
		xPlayer.showNotification(_U('act_imp'))
	end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		hiddenjob 	 = xPlayer.getHiddenJob(),
		dealerLevel  = xPlayer.getDealerLevel(),
		money        = xPlayer.getMoney(),
		--skill        = xPlayer.getSkill()
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		hiddenjob 	 = xPlayer.getHiddenJob(),
		dealerLevel  = xPlayer.getDealerLevel(),
		money        = xPlayer.getMoney(),
		--skill        = xPlayer.getSkill()
	})
end)

ESX.RegisterServerCallback('esx:getPlayerNames', function(source, cb, players)
	players[source] = nil

	for playerId,v in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			players[playerId] = xPlayer.getName()
		else
			players[playerId] = nil
		end
	end

	cb(players)
end)

ESX.RegisterServerCallback('esx:isValidItem', function(source, cb, item)
	if ESX.Items[item] then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx:updateDecor')
AddEventHandler('esx:updateDecor', function(what, entity, key, value)
	TriggerClientEvent('esx:updateDecor', -1, what, entity, key, value)
end)