local Status = {}

local loaded = false
local armored = true
local modelThread = nil

local isPaused = false
local display = false

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
			ESX = obj
		end)
		
		Citizen.Wait(250)
	end
	
	Citizen.Wait(5000)
	ESX.PlayerData = ESX.GetPlayerData()
end)

function GetStatusData(ped)
	local ghowno = {}
	for _, status in ipairs(Status) do
		table.insert(ghowno, {
			name	= status.name,
			val		= status.val,
			percent	= (status.val / Config.StatusMax) * 100
		})
	end

	return ghowno
end

RegisterNetEvent('esx_status:load')
AddEventHandler('esx_status:load', function(statuses)
	for _, status in ipairs(Status) do
		for _, _status in ipairs(statuses) do
			if status.name == _status.name then
				status.set(_status.val)
			end
		end
	end

	loaded = true
end)

RegisterNetEvent('esx_status:set')
AddEventHandler('esx_status:set', function(name, val)
	for _, status in ipairs(Status) do
		if status.name == name then
			status.set(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData())
end)


RegisterNetEvent('esx_status:add')
AddEventHandler('esx_status:add', function(name, val)
	for _, status in ipairs(Status) do
		if status.name == name then
			status.add(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData())
end)

RegisterNetEvent('esx_status:remove')
AddEventHandler('esx_status:remove', function(name, val)
	for _, status in ipairs(Status) do
		if status.name == name then
			status.remove(val)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData())
end)

RegisterNetEvent('esx_status:updateColor')
AddEventHandler('esx_status:updateColor', function(name, color)
	for _, status in ipairs(Status) do
		if status.name == name then
			status.updateColor(color)
			break
		end
	end

	TriggerServerEvent('esx_status:update', GetStatusData())
end)

AddEventHandler('esx_status:registerStatus', function(name, default, color, visible, tickCallback)
	local s = CreateStatus(name, default, color, visible, tickCallback)
	table.insert(Status, s)
end)

AddEventHandler('esx_status:getStatus', function(name, cb)
	for _, status in ipairs(Status) do
		if status.name == name then
			cb(status)
			return
		end
	end
end)

AddEventHandler('skinchanger:modelComplete', function()
	if not armored then
		armored = true
	elseif loaded == nil then
		loaded = false
	else
		local old = loaded
		if modelThread then
			TerminateThread(modelThread)
			modelThread = nil
		end

		loaded = false
		Citizen.CreateThreadNow(function()
			modelThread = GetIdOfThisThread()

			Citizen.Wait(1000)
			if loaded == false then
				loaded = old
			end
		end)
	end
end)
local oldhud = false
RegisterNetEvent("csskrouble:oldHud", function(m) 
	oldhud = m
end)

AddEventHandler('esx_status:setDisplay', function(val)
	display = tonumber(val) ~= 0
end)

function drwRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function drwTxt(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end

CreateThread(function()
	TriggerEvent('esx_status:loaded')

	RequestStreamedTextureDict('mpleaderboard')
	while not HasStreamedTextureDictLoaded('mpleaderboard') do
			Citizen.Wait(0)
	end

	local updateTimer, tickTimer, updateGlobal
	local sleep = 500
	while true do
		if IsPauseMenuActive() and not isPaused then
			isPaused = true
			TriggerEvent('esx_status:setDisplay', 0.0)
		elseif not IsPauseMenuActive() and isPaused then
			isPaused = false
			TriggerEvent('esx_status:setDisplay', 0.5)
		end

		if display and oldhud then
			sleep = 2
			local baseX = 0.015
			drwRct(0.015, 0.985, 0.0698, 0.0125, 0, 0, 0, 120)

			local statuses = {}
			for _, status in ipairs(Status) do
				if status.visible or status.val > 0 then
					table.insert(statuses, {
						color	= status.color,
						percent	= (status.val / Config.StatusMax)
					})
				end
			end

			local count = #statuses
			for i, status in ipairs(statuses) do
				local offset = 0.0015
				if i == count then
					offset = 0.0
				end

				local width = 0.0698 / count - offset
				drwRct(baseX, 0.985, (width * status.percent), 0.01, status.color[1], status.color[2], status.color[3], 70)
				baseX = baseX + width + offset
			end
		else
			sleep = 250
		end
		Wait(sleep)
	end
end)

CreateThread(function()
	while true do
		Wait(100)
		if loaded then
			local timer = GetGameTimer()
			if not tickTimer or tickTimer < timer then
				for _, status in ipairs(Status) do
					status.onTick()
				end

				tickTimer = timer + Config.TickTime
			end
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(Config.UpdateInterval)
		TriggerServerEvent('esx_status:update', GetStatusData(true))
	end
end)

-- go pro

function PlayAnim()
	local ped = PlayerPedId()
	TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, true)
	Wait(2000)
    Citizen.InvokeNative(0xAAA34F8A7CB32098, ped)
end

function StartGPS()
	PlayAnim()

	SendNuiMessage({
		action = "gopro",
		state = true
	})
end

function StopGPS()
	PlayAnim()

	SendNuiMessage({
		action = "gopro",
		state = false
	})
end

RegisterNetEvent('ls_gopro:goproMenu')
AddEventHandler('ls_gopro:goproMenu', function()
	local _elements = {
		{label = 'Włącz GoPro', value = 'start1'},
		{label = 'Zniszcz GoPro', value = 'destroy'},
		{label = 'Wyłącz GoPro', value = 'stop'},
	}
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gopro', {
		title    = 'Menu GoPro',
		align    = 'center',
		elements = _elements
	}, function(data, menu)
		if data.current.value == 'start1' then
			menu.close()
			StartGPS()
			TriggerEvent('esx:showNotification', '~h~~w~[GoPro] ~g~Nagrywanie zostało włączone.')
		elseif data.current.value == 'destroy' then
			menu.close()
			StopGPS()
			TriggerServerEvent("ls_gopro:destroyItem")
		elseif data.current.value == 'stop' then
			menu.close()
			StopGPS()
			TriggerEvent('esx:showNotification', '~h~~w~[GoPro] ~p~Nagrywanie zostało wyłączone.')
		end
	end, function(data, menu)
		menu.close()
	end)
end)