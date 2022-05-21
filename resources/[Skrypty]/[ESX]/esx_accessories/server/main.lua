ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_accessories:pay')
AddEventHandler('esx_accessories:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid') .. '$' .. Config.Price)

end)

ESX.RegisterServerCallback('esx_accessories:checkMoney', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= Config.Price then
		cb(true)
	else
		cb(false)
	end

end)


--CLOTHES

local clothes = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM db_clothes', 
	
	{}, function(result)
		for k,v in ipairs(result) do
			clothes[v.identifier] = {
				bags_1 = v.bag,
				bags_2 = v.bag2,
				tshirt_1 = v.tshirt,
				tshirt_2 = v.tshirt2,
				torso_1 = v.torso,
				torso_2 = v.torso2,
				pants_1 = v.legs,
				pants_2 = v.legs2,
				shoes_1 = v.shoes,
				shoes_2 = v.shoes2,
				arms = v.arms,
				arms_2 = v.arms2,
				chain_1 = v.chain,
				chain_2 = v.chain2,
				mask_1 = v.mask,
				mask_2 = v.mask2,
				decals_1 = v.decals,
				decals_2 = v.decals2,
				helmet_1 = v.hat,
				helmet_2 = v.hat2,
				glasses_1 = v.glasses,
				glasses_2 = v.glasses2,
				watches_1 = v.watches,
				watches_2 = v.watches2,
				bracelets_1 = v.bracelets,
				bracelets_2 = v.bracelets2,
				bproof_1 = v.bproof1,
				bproof_2 = v.bproof2,
				face_1 = v.face,
				hair_1 = v.hair,
			}	
		end
	end)	
end)

function item(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer ~= nil then
		local identifier = xPlayer.identifier
		
		if clothes[identifier] then
			return clothes[identifier]
		else
			return nil
		end
	else
		return nil
	end
end

RegisterServerEvent('esx_ciuchy:takeoff')
AddEventHandler('esx_ciuchy:takeoff', function(what, id)
	TriggerClientEvent('misiaczek_clothes:PutOff', id, what)
end)

ESX.RegisterServerCallback('misiaczek_clothes:getClothes', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		local identifier = xPlayer.identifier
		
		if clothes[identifier] then			
			cb(clothes[identifier])
		end
	end
end)

RegisterServerEvent('misiaczek_clothes:saveClothes')
AddEventHandler('misiaczek_clothes:saveClothes', function(tosave)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		local identifier = xPlayer.identifier
		
		if clothes[identifier] then
			for k,v in pairs(tosave) do				
				clothes[identifier][k] = v
			end
		end
	end
end)


RegisterServerEvent('misiaczek_clothes:addClothes')
AddEventHandler('misiaczek_clothes:addClothes', function(id, bag, bag2, tshirt, tshirt2, torso, torso2, legs, legs2, shoes, shoes2, arms, arms2, watches, watches2, bracelets, bracelets2, chain, chain2, mask, mask2, decals, decals2, hat, hat2, glasses, glasses2, bproof1, bproof2, face, hair)
	local _source = source
	local xPlayer = nil
	
	if id ~= false then
		xPlayer = ESX.GetPlayerFromId(id)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end
	
	if xPlayer ~= nil then
		clothes[xPlayer.identifier] = {
			bags_1 = bag,
			bags_2 = bag2,
			tshirt_1 = tshirt,
			tshirt_2 = tshirt2,
			torso_1 = torso,
			torso_2 = torso2,
			pants_1 = legs,
			pants_2 = legs2,
			shoes_1 = shoes,
			shoes_2 = shoes2,
			arms = arms,
			arms_2 = arms2,
			chain_1 = chain,
			chain_2 = chain2,
			mask_1 = mask,
			mask_2 = mask2,
			decals_1 = decals,
			decals_2 = decals2,
			helmet_1 = hat,
			helmet_2 = hat2,
			glasses_1 = glasses,
			glasses_2 = glasses2,
			watches_1 = watches,
			watches_2 = watches2,
			bracelets_1 = bracelets,
			bracelets_2 = bracelets2,
			bproof_1 = bproof1,
			bproof_2 = bproof2,
			face_1 = face,
			hair_1 = hair,			
		}		
	end
end)

AddEventHandler('playerDropped', function()
	local playerId = source
	local name = item(playerId)
		
	if name ~= nil then
		local xPlayer = ESX.GetPlayerFromId(playerId)
		if xPlayer ~= nil then
			local digit = xPlayer.getDigit()
			
			MySQL.Async.fetchAll('SELECT digit FROM db_clothes WHERE identifier = @identifier AND digit = @digit', {
				['@identifier'] = xPlayer.identifier,
				['@digit'] = digit
			}, function(result)
				if result[1] ~= nil then
					MySQL.Async.execute("UPDATE db_clothes SET bag=@bag, bag2=@bag2, tshirt=@tshirt , tshirt2=@tshirt2, torso=@torso, torso2=@torso2, legs=@legs, legs2=@legs2, shoes=@shoes, shoes2=@shoes2, arms=@arms, arms2=@arms2, chain=@chain, chain2=@chain2,mask=@mask,mask2=@mask2,decals=@decals,decals2=@decals2,hat=@hat,hat2=@hat2,watches=@watches,watches2=@watches2,bracelets=@bracelets,bracelets2=bracelets2,glasses=@glasses,glasses2=@glasses2,bproof1=@bproof1,bproof2=@bproof2, face=@face, hair=@hair WHERE identifier=@identifier AND digit = @digit", {
						['@identifier'] 	= xPlayer.identifier, 
						['@digit']		    = digit, 
						['@bag']		    = name.bags_1, 
						['@bag2'] 			= name.bags_2, 
						['@tshirt'] 		= name.tshirt_1, 
						['@tshirt2'] 		= name.tshirt_2, 
						['@torso'] 			= name.torso_1, 
						['@torso2'] 		= name.torso_2, 
						['@legs'] 			= name.pants_1, 
						['@legs2'] 			= name.pants_2, 
						['@shoes'] 			= name.shoes_1, 
						['@shoes2'] 		= name.shoes_2,
						['@arms'] 			= name.arms, 
						['@arms2'] 			= name.arms_2, 
						['@chain'] 			= name.chain_1, 
						['@chain2'] 		= name.chain_2, 
						['@mask'] 			= name.mask_1, 
						['@mask2'] 			= name.mask_2, 
						['@decals'] 		= name.decals_1, 
						['@decals2'] 		= name.decals_2, 
						['@hat'] 			= name.helmet_1, 
						['@hat2'] 			= name.helmet_2, 
						['@watches'] 		= name.watches_1, 
						['@watches2'] 		= name.watches_2,
						['@bracelets'] 		= name.bracelets_1,
						['@bracelets2'] 	= name.bracelets_2,
						['@glasses'] 		= name.glasses_1,
						['@glasses2'] 		= name.glasses_2,
						['@bproof1'] 		= name.bproof_1, 
						['@bproof2'] 		= name.bproof_2,
						['@face'] 			= name.face_1,
						['@hair'] 			= name.hair_1,
					})
				else
					MySQL.Async.execute("INSERT INTO db_clothes (identifier, digit, bag, bag2, tshirt , tshirt2, torso, torso2, legs, legs2, shoes, shoes2, arms, arms2, chain, chain2,mask,mask2,decals,decals2,hat,hat2,watches,watches2,bracelets,bracelets2,glasses,glasses2,bproof1,bproof2,face,hair) VALUES (@identifier, @digit, @bag,@bag2,@tshirt,@tshirt2,@torso,@torso2,@legs,@legs2,@shoes,@shoes2,@arms,@arms2,@chain,@chain2,@mask,@mask2,@decals,@decals2,@hat,@hat2,@watches,@watches2,@bracelets,@bracelets2,@glasses,@glasses2,@bproof1,@bproof2,@face,@hair)", {
						['@identifier'] 	= xPlayer.identifier, 
						['@digit']		    = digit, 
						['@bag']		    = name.bags_1, 
						['@bag2'] 			= name.bags_2, 
						['@tshirt'] 		= name.tshirt_1, 
						['@tshirt2'] 		= name.tshirt_2, 
						['@torso'] 			= name.torso_1, 
						['@torso2'] 		= name.torso_2, 
						['@legs'] 			= name.pants_1, 
						['@legs2'] 			= name.pants_2, 
						['@shoes'] 			= name.shoes_1, 
						['@shoes2'] 		= name.shoes_2,
						['@arms'] 			= name.arms, 
						['@arms2'] 			= name.arms_2, 
						['@chain'] 			= name.chain_1, 
						['@chain2'] 		= name.chain_2, 
						['@mask'] 			= name.mask_1, 
						['@mask2'] 			= name.mask_2, 
						['@decals'] 		= name.decals_1, 
						['@decals2'] 		= name.decals_2, 
						['@hat'] 			= name.helmet_1, 
						['@hat2'] 			= name.helmet_2, 
						['@watches'] 		= name.watches_1, 
						['@watches2'] 		= name.watches_2,
						['@bracelets'] 		= name.bracelets_1,
						['@bracelets2'] 	= name.bracelets_2,
						['@glasses'] 		= name.glasses_1,
						['@glasses2'] 		= name.glasses_2,
						['@bproof1'] 		= name.bproof_1, 
						['@bproof2'] 		= name.bproof_2,
						['@face'] 			= name.face_1,
						['@hair'] 			= name.hair_1,
					})
				end
			end)	
		end
	end
end)



ESX.RegisterUsableItem('suppressor', function(source)	
	TriggerClientEvent('es_extended:setComponent', source, true, 'suppressor')
end)

ESX.RegisterUsableItem('flashlight', function(source)	
    TriggerClientEvent('es_extended:setComponent', source, true, 'flashlight')
end)

ESX.RegisterUsableItem('ironsights', function(source)	
    TriggerClientEvent('es_extended:setComponent', source, true, 'ironsights')
end)

ESX.RegisterUsableItem('grip', function(source)	
	TriggerClientEvent('es_extended:setComponent', source, true, 'grip')
end)

ESX.RegisterUsableItem('clip_extended', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'clip_extended')
end)

ESX.RegisterUsableItem('scope_large', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_large')
end)

ESX.RegisterUsableItem('scope_medium', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_medium')
end)

ESX.RegisterUsableItem('scope_holo', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_holo')
end)

ESX.RegisterUsableItem('clip_drum', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'clip_drum')
end)

ESX.RegisterUsableItem('scope', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope')
end)

ESX.RegisterUsableItem('scope_advanced', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_advanced')
end)

ESX.RegisterUsableItem('scope_zoom', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_zoom')
end)

ESX.RegisterUsableItem('scope_nightvision', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_nightvision')
end)

ESX.RegisterUsableItem('scope_thermal', function(source)
	TriggerClientEvent('es_extended:setComponent', source, true, 'scope_thermal')
end)
