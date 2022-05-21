ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_exilemenu:getUserInfo')
AddEventHandler('esx_exilemenu:getUserInfo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local getCount = CheckCourses(_source)
	local coursesCount = getCount and '('..getCount..')' or ''

	if xPlayer ~= nil then
		TriggerClientEvent('esx_exilemenu:getUserInfo', _source, xPlayer.character.firstname, xPlayer.character.lastname, coursesCount)
	end
end)

function KursyChange(id, number)
	local _id = id
	local xPlayer = ESX.GetPlayerFromId(_id)
	
	local getCount = nil
	if number then
		getCount = number
	else
		getCount = CheckCourses(_id)
	end
	
	local coursesCount = getCount and '('..getCount..')' or ''

	if xPlayer ~= nil then
		TriggerClientEvent('esx_exilemenu:getUserInfo', _id, xPlayer.character.firstname, xPlayer.character.lastname, coursesCount)
	end
end

function CheckCourses(_source)
	local xPlayer = ESX.GetPlayerFromId(_source)
	local results = MySQL.Sync.fetchAll('SELECT courses_count FROM user_courses WHERE identifier = @identifier AND digit = @digit AND job = @job', {
		['@identifier'] = xPlayer.identifier,
		['@digit'] = xPlayer.getDigit(),
		['@job'] = xPlayer.job.name
	})
	if results[1] ~= nil and results[1].courses_count ~= nil then
		return results[1].courses_count
	else
		return nil
	end
end

function getLicense(steamid, callback)
	local xPlayer = ESX.GetPlayerFromIdentifier(steamid)

	local data = {
		weapon = "no",
		drive = "no",
		drive_bike = "no",
		drive_truck = "no",
		ems_insurance = "no",
		oc_insurance = "no"
	}
		
	if xPlayer ~= nil then
		TriggerEvent('esx_license:getLicenses', xPlayer.source, function(result)
			if result ~= nil then
				for i=1, #result, 1 do	
					if result[i].type == "weapon" then
						data.weapon = "yes"
					end
					if result[i].type == "drive" then
						data.drive = "yes"
					end
					if result[i].type == "drive_bike" then
						data.drive_bike = "yes"
					end
					if result[i].type == "drive_truck" then
						data.drive_truck = "yes"
					end
					if result[i].type == "ems_insurance" then
						data.ems_insurance = "yes"
					end
					if result[i].type == "oc_insurance" then
						data.oc_insurance = "yes"
					end
				end
			end
		end)
	end
	
	callback(data)
end

function CheckInsuranceEMS(job)
	local NNW = false
	if job == nil then
		return false
	end
	local results = MySQL.Sync.fetchAll('SELECT nnw FROM jobs_insurance WHERE name = @name', {
		['@name'] = job
	})
	if results[1] == nil then
		NNW = false
	else
		if results[1].nnw == 1 then
			NNW = true
		end
	end
	return NNW
end

function CheckInsuranceLSC(job)
	local OC = false
	if job == nil then
		return false
	end

	local results = MySQL.Sync.fetchAll('SELECT oc FROM jobs_insurance WHERE name = @name', {
		['@name'] = job
	})
	if results[1] == nil then
		OC = false
	else
		if results[1].oc == 1 then
			OC = true
		end
	end
	return OC
end


RegisterServerEvent('menu:id')
AddEventHandler('menu:id', function(type, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	getLicense(xPlayer.identifier, function(data2)
		if data2 ~= nil then
			local bron, kata, katb, katc, ubezmedtext, ubezmehtext
			if data2.weapon == "yes" then
				bron = true
			else
				bron = false
			end
			if data2.drive_bike == "yes" then
				kata = true
			else
				kata = false
			end
			if data2.drive == "yes" then
				katb = true
			else
				katb = false
			end
			if data2.drive_truck == "yes" then
				katc = true
			else
				katc = false
			end
			if data2.ems_insurance == "yes" then
				ubezmedtext = true
			else
				local HasInsurance = CheckInsuranceEMS(xPlayer.job.name)

				if HasInsurance then
					ubezmedtext = true
				else
					ubezmedtext = false
				end
			end
			if data2.oc_insurance == "yes" then
				ubezmehtext = true
			else
				local HasInsurance = CheckInsuranceLSC(xPlayer.job.name)

				if HasInsurance then
					ubezmehtext = true
				else
					ubezmehtext = false
				end
			end
			TriggerEvent('ReturnSkin', _source, function(data)
				local currentSkin = data
				local MainPlayerCoords = GetEntityCoords(GetPlayerPed(_source))
				if type == 1 then
					TriggerClientEvent('sendProximityMessageID', _source, _source, xPlayer.character, bron, kata, katb, katc, ubezmedtext, ubezmehtext, currentSkin)
				elseif type == 2 then
					if #(GetEntityCoords(GetPlayerPed(id)) - MainPlayerCoords) < 3 then
						TriggerClientEvent('sendProximityMessageID', _source, _source, xPlayer.character, bron, kata, katb, katc, ubezmedtext, ubezmehtext, currentSkin)
						TriggerClientEvent('sendProximityMessageID', id, _source, xPlayer.character, bron, kata, katb, katc, ubezmedtext, ubezmehtext, currentSkin)
					end
				end
			end)
		end
	end)
end)

RegisterNetEvent('menu:phone')
AddEventHandler('menu:phone', function(type, id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName     = xPlayer.job.grade_name
	local jobLabel   = xPlayer.job.label
	local gradeLabel = xPlayer.job.grade_label

	if xPlayer ~= nil then
		TriggerEvent('ReturnSkin', _source, function(data)
			local currentSkin = data
			local MainPlayerCoords = GetEntityCoords(GetPlayerPed(_source))
			if type == 1 then
				TriggerClientEvent("sendProximityMessagePhone", _source, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
			elseif type == 2 then
				if #(GetEntityCoords(GetPlayerPed(id)) - MainPlayerCoords) < 3 then
					TriggerClientEvent("sendProximityMessagePhone", _source, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
					TriggerClientEvent("sendProximityMessagePhone", id, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
				end
			elseif type == 3 then
				for k, v in pairs(ESX.GetExtendedPlayers()) do
					if #(GetEntityCoords(GetPlayerPed(v)) - MainPlayerCoords) < 3 then
						TriggerClientEvent("sendProximityMessagePhone", v, _source, xPlayer.character, jobName, jobLabel, gradeLabel, currentSkin)
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('menu:blacha1')
AddEventHandler('menu:blacha1', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha1", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha2')
AddEventHandler('menu:blacha2', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha2", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha3')
AddEventHandler('menu:blacha3', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha3", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha4')
AddEventHandler('menu:blacha4', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha4", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha5')
AddEventHandler('menu:blacha5', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha5", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)
RegisterNetEvent('menu:blacha6')
AddEventHandler('menu:blacha6', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha6", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha7')
AddEventHandler('menu:blacha7', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha7", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha8')
AddEventHandler('menu:blacha8', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha8", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)

RegisterNetEvent('menu:blacha9')
AddEventHandler('menu:blacha9', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local jobName, jobLabel, gradeLabel
	
	if data ~= nil then
		if string.match(xPlayer.job.label, data.badge) == data.badge then
			jobName = xPlayer.job.grade_name
			jobLabel = xPlayer.job.label
			gradeLabel = xPlayer.job.grade_label
		elseif string.match(xPlayer.hiddenjob.label, data.badge) == data.badge then
			jobName = xPlayer.hiddenjob.grade_name
			jobLabel = xPlayer.hiddenjob.label
			gradeLabel = xPlayer.hiddenjob.grade_label 
		end
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessageBlacha9", -1, _source, xPlayer.character, jobName, jobLabel, gradeLabel)
		end
	end
end)