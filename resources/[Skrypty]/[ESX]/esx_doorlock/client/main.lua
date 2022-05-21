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

ESX					= nil
local DoorList 		= {}
local Properties    = {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)
	
	ESX.TriggerServerCallback('esx_doorlock:getDoorList', function(doors)
		DoorList = doors
	end)
	
	ESX.TriggerServerCallback('esx_property:getOwnedProperties', function(ownedProperties)
		for i=1, #ownedProperties, 1 do
			Properties[ownedProperties[i].name] = true
		end
	end)
	
	while DoorList[1] == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	
	ESX.TriggerServerCallback('esx_doorlock:getDoorInfo', function(doorInfo, count)
		for localID = 1, count, 1 do
			if doorInfo[localID] ~= nil then
				if DoorList[doorInfo[localID].doorID] ~= nil then 
					DoorList[doorInfo[localID].doorID].locked = doorInfo[localID].state
				end
			end
		end
		
		for i = 1, #DoorList do
			local doorID = DoorList[i]
			if doorID.doors then
				for k,v in pairs(doorID.doors) do
					local closeDoor
					if v.objModel ~= nil then
						closeDoor = GetClosestObjectOfType(v.objCoords.x, v.objCoords.y, v.objCoords.z, 1.0, v.objModel, false, false, false)
					else
						closeDoor = GetClosestObjectOfType(v.objCoords.x, v.objCoords.y, v.objCoords.z, 1.0, GetHashKey(v.objName), false, false, false)
					end
					
					if DoesEntityExist(closeDoor) then
						v.startRotation = GetEntityRotation(closeDoor)
					end
				end
			else
				local closeDoor

				if doorID.objModel ~= nil then
					closeDoor = GetClosestObjectOfType(doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, 1.0, doorID.objModel, false, false, false)
				else
					closeDoor = GetClosestObjectOfType(doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, 1.0,	GetHashKey(doorID.objName), false, false, false)
				end

				if DoesEntityExist(closeDoor) then
					DoorList[i].startRotation = GetEntityRotation(closeDoor)
				end
			end
		end
	end)
end)

RegisterNetEvent('esx_property:setPropertyOwned')
AddEventHandler('esx_property:setPropertyOwned', function(name, owned)
	if owned then
		Properties[name] = true
	else
		if Properties[name] then
			Properties[name] = nil
		end
	end
end)

RegisterNetEvent('esx_doorlock:sendDoorList')
AddEventHandler('esx_doorlock:sendDoorList', function(doors)
	DoorList = doors
end)

RegisterNetEvent('esx_doorlock:updateUserDoors')
AddEventHandler('esx_doorlock:updateUserDoors', function(doors)
	DoorList = doors
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	ESX.PlayerData.hiddenjob = hiddenjob
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

CreateThread(function()
	while DoorList[1] == nil do
		Citizen.Wait(300)
	end
	
	while true do
		Citizen.Wait(3)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local sleep = true

		for i=1, #DoorList do
			local doorID   = DoorList[i]
			local isAuthorized = IsAuthorized(doorID)
			local distance = #(playerCoords - vec3(doorID.textCoords.x, doorID.textCoords.y, doorID.textCoords.z))
			local maxDistance = 1.25
			if doorID.distance then
				maxDistance = doorID.distance
			end

			if distance < maxDistance then
				sleep = false
				ApplyDoorState(doorID)

				local displayText = _U('unlocked')
				if doorID.locked then
					--displayText = _U('locked')
				end

				if isAuthorized then
					--displayText = _U('press_button', displayText)
				end

				if isAuthorized then
					--DrawText3Ds(doorID.textCoords.x, doorID.textCoords.y, doorID.textCoords.z, displayText)
				end
				
				
				if IsControlJustReleased(0, Keys['E']) then
					if isAuthorized then
						if doorID.soundLib then
							if doorID.locked then
								TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'openKeypad', 0.12)
								ESX.ShowNotification('~y~Drzwi ~g~otwarte')
								Wait(1000)
							else
								TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.0, 'lockKeypad', 0.12)
								ESX.ShowNotification('~y~Drzwi ~r~zamknięte')
							end
						else
							if doorID.locked then
								TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'lockDoor', 0.8)
								ESX.ShowNotification('~y~Drzwi ~g~otwarte')
							else
								TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'unlockDoor', 0.8)
								ESX.ShowNotification('~y~Drzwi ~r~zamknięte')
							end
						end
						TriggerServerEvent('esx_doorlock:updateState', i, not doorID.locked) -- Broadcast new state of the door to everyone
					end
				end
			end
		end
		
		if sleep then
			Wait(500)
		end
	end
end)

function ApplyDoorState(doorID)
	if doorID.doors then
		for k,v in pairs(doorID.doors) do
			local closeDoor
			if v.objModel ~= nil then
				closeDoor = GetClosestObjectOfType(v.objCoords.x, v.objCoords.y, v.objCoords.z, 1.0, v.objModel, false, false, false)
			else
				closeDoor = GetClosestObjectOfType(v.objCoords.x, v.objCoords.y, v.objCoords.z, 1.0, GetHashKey(v.objName), false, false, false)
			end
			
			if v.startRotation == nil then
				v.startRotation = GetEntityRotation(closeDoor)
			end
			
			if doorID.locked == true and GetEntityRotation(closeDoor) ~= v.startRotation then
				SetEntityRotation(closeDoor, v.startRotation)
			end

			FreezeEntityPosition(closeDoor, doorID.locked)
		end
	else
		local closeDoor
		if doorID.objModel ~= nil then
			closeDoor = GetClosestObjectOfType(doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, 1.0, doorID.objModel, false, false, false)
		else
			closeDoor = GetClosestObjectOfType(doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, 1.0, GetHashKey(doorID.objName), false, false, false)
		end

		if doorID.startRotation == nil then
			doorID.startRotation = GetEntityRotation(closeDoor)
		end

		if doorID.locked == true and GetEntityRotation(closeDoor) ~= doorID.startRotation then
			SetEntityRotation(closeDoor, doorID.startRotation)
		end

		FreezeEntityPosition(closeDoor, doorID.locked)
	end
end

function IsAuthorized(doorID)
	if ESX.PlayerData.job == nil then
		return false
	end

	if ESX.PlayerData.hiddenjob == nil then
		return false
	end
	
	if doorID.authorizedJobs then
		for i=1, #doorID.authorizedJobs, 1 do 
			if ESX.PlayerData.job.name == doorID.authorizedJobs[i] or string.sub(ESX.PlayerData.job.name, 4) == doorID.authorizedJobs[i] or ESX.PlayerData.hiddenjob.name == doorID.authorizedJobs[i] or Properties[doorID.authorizedJobs[i]] then
				return true
			end
		end
	end
	
	if doorID.authorizedUser then
		for i=1, #doorID.authorizedUser, 1 do
			if ESX.PlayerData.identifier == doorID.authorizedUser[i] then
				return true
			end
		end
	end

	return false
end

-- Set state for a door
RegisterNetEvent('esx_doorlock:setState')
AddEventHandler('esx_doorlock:setState', function(doorID, state)
	if doorID == nil then
		return
	end
	if state == true then
		Citizen.Wait(2000)
	end
	
	if DoorList[doorID] then
    	DoorList[doorID].locked = state
	end
    
end)