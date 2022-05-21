local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local AmbulanceGUI = false
local PlayerData = {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

-- Get player data
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = ESX.GetPlayerData()
end)
-- Get player job
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterCommand("close", function(source, args, raw) --change command here
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	AmbulanceGUI = false
	stopAnim()
end, false) --False, allow everyone to run it

RegisterNetEvent('tabletmed')
AddEventHandler('tabletmed', function()
	if not AmbulanceGUI then
		if PlayerData.job.name == 'ambulance' then
			startAnim()
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'open'})
			loadDefaultData()
			AmbulanceGUI = true
		end
	end
end)

-- Hide tablet NUI callback
RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
	AmbulanceGUI = false
	stopAnim()
end)

-- Animations
function startAnim()
	CreateThread(function()
	  RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
	  while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
		Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(PlayerPedId(), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end
function attachObject()
	tab = Citizen.InvokeNative(0x509D5878EB39E842, `prop_cs_tablet`, 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.17, 0.10, -0.13, 20.0, 180.0, 180.0, true, true, false, true, 1, true)
end
function stopAnim()
	StopAnimTask(PlayerPedId(), "amb@world_human_seat_wall_tablet@female@base", "base" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteEntity(tab)
end

-- Load default data
function loadDefaultData()
	ESX.TriggerServerCallback('emstablet:getDefaultData', function(result)
		SendNUIMessage({
			type = 'loadDefaultData',
			name = result.firstname .. ' ' .. result.lastname,
			jobgrade = PlayerData.job.label .. ' - ' .. PlayerData.job.grade_label,
			emsonline = result.ambulance,
			invoices = result.invoices
		})
	end)
end

-- Load history
RegisterNUICallback('getHistory', function()
	loadHistory()
end)

function sortowanie(s)

	local t = {}
	for k,v in pairs(s) do
		table.insert(t, v)
	end
	
	table.sort(t, function(a, b)
		if a.id ~= b.id then
			return a.id > b.id
		end
	end)
	
	return t
end

function loadHistory()
	ESX.TriggerServerCallback('emstablet:getHistory', function(result)
		if result ~= nil then		
			local wynik = sortowanie(result)
			for k,v in ipairs(wynik) do
				if k == 256 then break end
				local data = {identifier = v.doctor}
				ESX.TriggerServerCallback('emstablet:parseDoctor', function(_doctor)
					SendNUIMessage({
						type = 'loadHistory',
						name = v.name,
						surname = v.surname,
						treatment = v.treatment,
						price = v.price,
						date = v.date,
						doctor = _doctor,
					})
				end, data)
			end
		else
			SendNUIMessage({
				type = 'loadHistory',
				name = '',
				surname = '',
				treatment = '',
				price = '',
				date = '',
				doctor = '',
				assistance = ''
			})
		end
	end)	
end

-- Load user assistance
RegisterNUICallback('loadUserAssistance', function(data)
	loadUserAssistance(data)
end)

function loadUserAssistance(data)
	ESX.TriggerServerCallback('emstablet:getUserAssistance', function(result)
		if result ~= false then
			for i = 1, #result, 1 do
				local _data = { identifier = result[i].identifier }
				ESX.TriggerServerCallback('emstablet:getAssistance', function(_assistance)
					SendNUIMessage({
						type = 'loadUserAssistance',
						name = result[i].firstname,
						surname = result[i].lastname,
						assistance = _assistance
					})
				end, _data)
			end
		else
			SendNUIMessage({
				type = 'loadUserAssistance',
				name = '',
				surname = '',
				assistance = ''
			})
		end
	end, data)
end

-- Create invoice
RegisterNUICallback('getInvoiceTarget', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		ESX.TriggerServerCallback('emstablet:parseName', function(result)
			SendNUIMessage({
				type = 'loadInvoiceTarget',
				name = result.firstname,
				surname = result.lastname,
				id = GetPlayerServerId(closestPlayer),
				target = true
			})
		end, GetPlayerServerId(closestPlayer))
	else 
		SendNUIMessage({
			type = 'loadInvoiceTarget',
			name = '',
			surname = '',
			id = '',
			target = false
		})
	end
end)

RegisterNUICallback('createInvoice', function(data)
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		createInvoice(GetPlayerServerId(closestPlayer), data)
		ESX.ShowNotification('Dodano obywatela do faktur')
	end	
end)

function createInvoice(target, data)
	local _data = {
		source = GetPlayerServerId(PlayerId()),
		target = target,
		data = data,
	}
	ESX.TriggerServerCallback('emstablet:addHistory', function()
	
	end, _data)
end