ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('ExileRP:kickPlayer')
AddEventHandler('ExileRP:kickPlayer', function(text)
    local _source = source
    local _text = text
    DropPlayer(_source, _text)
end)

RegisterCommand('cam', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.triggerEvent('route68:kino')
end, false)

RegisterCommand('offhud', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.triggerEvent('route68:kino2')
end, false)

AvailableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'THUNDER',
    'RAIN',
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

admins = {
    'steam:110000112dba8e2', -- LeM0n
    'steam:11000011a304f96', -- Water
    'steam:110000132913455', -- Falsz
    'steam:11000011082c3ac', -- skrouble
    'steam:11000011a469cf2', -- EcKo
    'steam:110000108303045', --Krzychu
}

CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 25

RegisterServerEvent('misiaczek:playerConnected')
AddEventHandler('misiaczek:playerConnected', function()
    TriggerClientEvent('misiaczek:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('misiaczek:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(10000)
        TriggerClientEvent('misiaczek:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('misiaczek:updateWeather', -1, CurrentWeather, blackout)
    end
end)

DynamicWeather = false

CreateThread(function()
    while true do
        Citizen.Wait(15 * 60000)
        if DynamicWeather then
        NextWeatherStage()
        end
    end
end)

 CreateThread(function()
     while true do
         newWeatherTimer = newWeatherTimer - 1
         Citizen.Wait(60000)
         if newWeatherTimer == 0 then
             if DynamicWeather then
                 NextWeatherStage()
                 newWeatherTimer = 25
             end
         end
     end
 end)

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "OVERCAST"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
			CurrentWeather = "RAIN"
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerClientEvent('misiaczek:updateWeather', -1, CurrentWeather, blackout)
end

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand('weather', function(source, args)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 10
                TriggerEvent('misiaczek:playerConnected')
            else
            end
        end
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Błędne zastosowanie komendy, użyj ^0/weather <weatherType> ')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent('esx:showNotification', source, 'Zmieniono pogode na: ~b~' .. string.lower(args[1]) .. "~s~.")
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 10
                    TriggerEvent('misiaczek:playerConnected')
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Niepoprawna pogoda, poprawne to: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING RAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS HALLOWEEN ')
                end
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Nie masz dostępu do tej komendy!')
        end
    end
end, false)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

RegisterCommand('time', function(source, args, rawCommand)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            TriggerEvent('misiaczek:playerConnected')
        else

        end
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    ShiftToHour(argh)
                else
                    ShiftToHour(0)
                end
                if argm < 60 then
                    ShiftToMinute(argm)
                else
                    ShiftToMinute(0)
                end
                local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
				local minute = math.floor((baseTime+timeOffset)%60)
                if minute < 10 then
                    newtime = newtime .. "0" .. minute
                else
                    newtime = newtime .. minute
                end
                TriggerClientEvent('esx:showNotification', source, 'Zmieniono czas na: ~b~' .. newtime .. "~s~!")
                TriggerEvent('misiaczek:playerConnected')
            else
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Błędne zastosowanie komendy, użyj ^0/time <hour> <minute>')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Nie masz dostępu do tej komendy!')
        end
    end
end)

RegisterServerEvent('esx_bron:komunikat')
AddEventHandler('esx_bron:komunikat', function(text)
	local _source = source
	TriggerClientEvent("sendProximityMessageMe", -1, _source, _source, text)
	
	color = {r = 0, g = 227, b = 243, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
end)

ESX.RegisterServerCallback('esx_misiaczek:getVehicleFromPlate', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner, digit FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
	
		if result[1] ~= nil then
			MySQL.Async.fetchAll('SELECT `firstname`, `lastname`, `height`, `sex`, `dateofbirth` FROM characters WHERE identifier = @identifier AND digit = @digit', {
				['@identifier'] = result[1].owner,
				['@digit']	= result[1].digit
			}, function(result2)
				local lspdTags = MySQL.Sync.fetchAll('SELECT value from user_properties WHERE userId = @owner and value=@value', {
					['@owner'] = result[1].owner,
					['@value'] = 'Poszukiwany'
				});
				
				local data = {
					owner = result2[1].firstname .. ' ' .. result2[1].lastname,
					sex = (result2[1].sex == 'm' and 'Mężczyzna' or 'Kobieta'),
					height = result2[1].height,
					dob = result2[1].dateofbirth,
					poszukiwany = lspdTags[1] ~= nil
				}
				cb(data)
			end)
		else
			cb('Nieznany')
		end
	end)
end)

AddEventHandler('rconCommand', function(commandName, args, source)
	if commandName == 'reebot' then
		if #args ~= 1 then
			RconPrint("Uzycie zacmienie: czas")
			CancelEvent()
			return
		end	
		
		if args[1] ~= nil then
			local czas = tonumber(args[1])
			TriggerClientEvent('flux_restart', -1, czas)
		end
	end
end)

RegisterNetEvent('ExileRP:saveCours')
AddEventHandler('ExileRP:saveCours', function(job, job_grade, source)
    local _source = source
	local identifier = ESX.GetPlayerFromId(_source).identifier
    local xPlayer = ESX.GetPlayerFromId(_source)
    local result = MySQL.Sync.fetchAll("SELECT courses_count, courses_count_secound FROM user_courses WHERE identifier = @identifier AND digit = @digit AND job = @job", {
		['@identifier'] = identifier,
        ['@digit'] = xPlayer.getDigit(),
        ['@job'] = job
    })
    if result[1] == nil then
        MySQL.Async.execute('INSERT INTO user_courses (identifier, firstname, lastname, digit, courses_count, courses_count_secound, job, job_grade) VALUES (@identifier, @firstname, @lastname, @digit, @courses_count, @courses_count_secound, @job, @job_grade)', 
        {
            ['@identifier'] = identifier,
            ['@firstname'] = xPlayer.character.firstname,
            ['@lastname'] = xPlayer.character.lastname,
            ['@digit'] = xPlayer.getDigit(),
            ['@courses_count'] = 1,
            ['@courses_count_secound'] = 1,
            ['@job'] = job,
            ['@job_grade'] = job_grade,
        })
    else
        local kursCount = result[1].courses_count
        local kursCount_secound = result[1].courses_count_secound
        MySQL.Async.execute('UPDATE user_courses SET courses_count=@courses_count, courses_count_secound=@courses_count_secound, job_grade = @job_grade WHERE identifier = @identifier AND digit = @digit and job = @job', 
        {
            ['@identifier'] = identifier,
            ['@digit'] = xPlayer.getDigit(),
            ['@courses_count'] = kursCount + 1,
            ['@courses_count_secound'] = kursCount_secound + 1,
            ['@job_grade'] = job_grade,
            ['@job'] = job,
        })
    end
	
    exports['esx_exilemenu']:KursyChange(_source, kursCount)
end)

ESX.RegisterServerCallback('ExileRP:getCourses', function(source, cb, job)
	MySQL.Async.fetchAll('SELECT job_grade, firstname, lastname, courses_count FROM user_courses WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = job,
	}, function (results)
		if results[1] ~= nil then
			cb(results)
		else
			cb(false)
		end
	end)
end)

local weapons = {
	['WEAPON_BALL'] = true,
	['WEAPON_SNOWBALL'] = true,

	['WEAPON_FLARE'] = true,
	['WEAPON_FLASHLIGHT'] = true,
	['WEAPON_KNUCKLE'] = true,
	['WEAPON_BAT'] = true,
	['WEAPON_PISTOL_MK2'] = true,
    ['WEAPON_GADGETPISTOL'] = true,
    ['GADGET_NIGHTVISION'] = true,

	['WEAPON_SWITCHBLADE'] = true,
	['WEAPON_DAGGER'] = true,
	['WEAPON_MACHETE'] = true,
	['WEAPON_BATTLEAXE'] = true,
	['WEAPON_MILITARYRIFLE'] = true,
	['WEAPON_SNSPISTOL'] = true,
	['WEAPON_SNSPISTOL_MK2'] = true,
	['WEAPON_VINTAGEPISTOL'] = true,
	['WEAPON_PISTOL'] = true,
	['WEAPON_DOUBLEACTION'] = true,
	['WEAPON_DBSHOTGUN'] = true,
	['WEAPON_SAWNOFFSHOTGUN'] = true,
	['WEAPON_PUMPSHOTGUN'] = true,
	['WEAPON_PUMPSHOTGUN_MK2'] = true,
	['WEAPON_MICROSMG'] = true,
	['WEAPON_SMG'] = true,
	['WEAPON_MINISMG'] = true,
	['WEAPON_SMG_MK2'] = true,
	['WEAPON_GUSENBERG'] = true,
	['WEAPON_CARBINERIFLE_MK2'] = true,
	['WEAPON_COMPACTRIFLE'] = true,
	['WEAPON_ASSAULTRIFLE'] = true,
    ['WEAPON_ASSAULTRIFLE_MK2'] = true,
    ['WEAPON_STUNGUN_MP'] = true,
    ['WEAPON_PROXMINE'] = true,
    ['WEAPON_PIPEBOMB'] = true,
    ['WEAPON_EMPLAUNCHER'] = true,
    ['WEAPON_HEAVYRIFLE'] = true,
    ['WEAPON_FERTILIZERCAN'] = true,
	['WEAPON_MARKSMANRIFLE'] = true,
	['WEAPON_MOLOTOV'] = true,
	['WEAPON_STICKYBOMB'] = true,
	['WEAPON_CERAMICPISTOL'] = true,
    ['WEAPON_RPG'] = true,

	['WEAPON_STUNGUN'] = true,
	['WEAPON_NIGHTSTICK'] = true,
	['WEAPON_KNIFE'] = true,
	['WEAPON_FLAREGUN'] = true,
	['WEAPON_COMBATPISTOL'] = true,
    ['WEAPON_APPISTOL'] = true,
	['WEAPON_HEAVYPISTOL'] = true,
	['WEAPON_COMBATPDW'] = true,
	['WEAPON_ASSAULTSMG'] = true,
	['WEAPON_BULLPUPSHOTGUN'] = true,
	['WEAPON_CARBINERIFLE'] = true,
	['WEAPON_SNIPERRIFLE'] = true,
	['WEAPON_FLASHBANG'] = true,
    ['weapon_bullpuprifle'] = true,

	['WEAPON_FIREEXTINGUISHER'] = true,
	['WEAPON_CROWBAR'] = true,
	['WEAPON_HATCHET'] = true,

	['WEAPON_HAMMER'] = true,
	['WEAPON_WRENCH'] = true,

	['WEAPON_PETROLCAN'] = true,
	['WEAPON_STONE_HATCHET'] = true,
	['WEAPON_GOLFCLUB'] = true,
	['WEAPON_FIREWORK'] = true,
	['WEAPON_MUSKET'] = true,
	['WEAPON_PISTOL50'] = true,

	['WEAPON_NAVYREVOLVER'] = true
}