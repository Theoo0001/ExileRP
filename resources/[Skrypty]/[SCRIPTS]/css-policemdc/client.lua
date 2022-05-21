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

ESX	= nil
local PlayerData = {}
local mdcOpened = false

-- load jobData
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(250)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end	
	PlayerData = ESX.GetPlayerData()
	SetNuiFocus(false, false)
	TriggerEvent("csskroubleMdc:refetch")
end)

RegisterNetEvent('esx_mdc_client:runMdcTablet')
AddEventHandler('esx_mdc_client:runMdcTablet', function()
    PlayerData = ESX.GetPlayerData()
    if mdcOpened == false then
        if PlayerData.job ~= nil then
            local jobName = PlayerData.job.name
            if jobName == 'police' or jobName == 'sheriff' or jobName == 'statepolice' then
                SetNuiFocus(true, true)
								SendNUIMessage({type = 'openT'})
                mdcOpened = true
            end
        end
    end
end)
RegisterNUICallback('closePoliceMdc', function()
	SetNuiFocus(false, false)
	mdcOpened = false
end)
RegisterNUICallback("openMainTablet", function() 
  SetNuiFocus(false, false)
  TriggerEvent("esx_mdc:openMain")
  mdcOpened = false
end)

RegisterNetEvent("csskroubleMdc:refetch", function() 
	TriggerServerEvent("csskroubleMdc:fetchLinks")
end)
RegisterNetEvent("csskroubleMdc:setLinks", function(links) 
	if links and links.dispatch and links.hours then
		SendNUIMessage({type = "setLinks", dispatch = dispatch, hours = hours})
	end
end)

RegisterNetEvent('tabletpol')
AddEventHandler('tabletpol', function()
    PlayerData = ESX.GetPlayerData()
    if mdcOpened == false then
        if PlayerData.job ~= nil then
            local jobName = PlayerData.job.name
            if jobName == 'police' or jobName == 'sheriff' or jobName == 'statepolice' then
                SetNuiFocus(true, true)
								SendNUIMessage({type = 'openT'})
                mdcOpened = true
            end
        end
    end
end)
RegisterCommand('tabletpol66', function()
	TriggerEvent('tabletpol')
end)

RegisterKeyMapping('tabletpol66', 'Tablet policyjny', 'keyboard', 'DELETE')