ESX	= nil
local PlayerData = {}
local mdcOpened = false

local tabletEntity = nil
local tabletModel = "prop_cs_tablet"
local tabletDict = "amb@world_human_seat_wall_tablet@female@base"
local tabletAnim = "base"

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
end)

RegisterNetEvent("esx_mdc:openMain")
AddEventHandler("esx_mdc:openMain", function() 
	SetNuiFocus(true, true)
	startTabletAnimation()
	SendNUIMessage({event = 'ShowPoliceTablet', isVisible = true})
	mdcOpened = true
end)

RegisterNUICallback('policeTryToLogin', function()
	ESX.TriggerServerCallback('esx_mdc:getPlayerName', function(name, departmentGrade)
		SendNUIMessage({
			event = 'LoadConfig',
			departments = Config.departments
		})
		SendNUIMessage({
			event = 'LoggedInPoliceTablet', 
			user = {
				name = name,
				jobName = PlayerData.job.name,
				departmentGrade = departmentGrade
			}
		})
	end, GetPlayerServerId(PlayerId()), PlayerData.job.name, PlayerData.job.grade)
end)

RegisterNUICallback('addNewCitizenNote', function(data, cb)
	local citizenId = data.citizenId
	if citizenId ~= nil then
		TriggerServerEvent('esx_mdc:addNewCitizenNote', citizenId, data)
	end
end)

RegisterNUICallback('changeCitizenData', function(data)
	TriggerServerEvent('esx_mdc:saveCitizen', data.citizen)
end) 

RegisterNUICallback('getCitizensWarrantsList', function(data)
	ESX.TriggerServerCallback('esx_mdc:getCitizensWarrantsList', function(warrantsData)
		SendNUIMessage({
			event = 'LoadCitizensWarrants',
			warrants = warrantsData
		})
	end)
end) 

RegisterNUICallback('addNewVehicleNote', function(data, cb)
	local vehicleId = data.vehicleId
	if vehicleId ~= nil then	
		TriggerServerEvent('esx_mdc:addNewVehicleNote', vehicleId, data)
	end
end)

RegisterNUICallback('changeVehicleData', function(data)
	TriggerServerEvent('esx_mdc:saveVehicle', data.vehicle)
end) 

RegisterNUICallback('getVehiclesWarrantsList', function(data)
	ESX.TriggerServerCallback('esx_mdc:getVehiclesWarrantsList', function(warrantsData)
		SendNUIMessage({
			event = 'LoadVehicleWarrants',
			warrants = warrantsData
		})
	end)
end) 

RegisterNUICallback('policeMdcSearchForVehicle', function(data)
	ESX.TriggerServerCallback('esx_mdc:getAllTags', function(tagsData)
		SendNUIMessage({
			event = 'LoadMdcAllTags', 
			tags = tagsData
		})
	end)
	ESX.TriggerServerCallback('esx_mdc:getVehicleByPlate', function(vehicleData)
		SendNUIMessage({
			event = 'FoundVehicle',
			vehicle = {
				id = vehicleData.id,
				owner = vehicleData.owner,
				ownerName = vehicleData.ownerName,
				plateText = vehicleData.plate,
				vehicleModel = vehicleData.modelname,
				lspdTags = vehicleData.lspdTags,
				notes = vehicleData.mdcNotes
			}
		})
	end, data.vehiclePlateText)
end) 

RegisterNUICallback('addNewCitizenConviction', function(data)
	local citizenId = data.id
    local playerJobName = PlayerData.job.name
    if citizenId ~= nil then
        local citizenServerId = getPlayerIdByHex(citizenId)
        TriggerServerEvent('esx_mdc:addNewCitizenConviction', playerJobName, citizenId, data)
    end
end)

RegisterNUICallback("policeMdcSearchID", function() 
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer == -1 or closestPlayerDistance > 12.5 then
		ESX.ShowNotification("~r~Nie ma żadnego gracza wokół ciebie!")
		return
	end
	closestPlayer = GetPlayerServerId(closestPlayer)
	ESX.TriggerServerCallback('esx_mdc:getAllTags', function(tagsData)
		SendNUIMessage({
			event = 'LoadMdcAllTags', 
			tags = tagsData
		})
	end)
	ESX.TriggerServerCallback('esx_mdc:getConvictionCategories', function(convictionData)
		SendNUIMessage({
			event = 'LoadConvictionCategories', 
			convictions = convictionData
		})
	end)
	ESX.TriggerServerCallback('esx_mdc:getCitizenByID', function(userData)
		if userData == {} then
			ESX.ShowNotification("~r~Nie znaleziono danych gracza")
			return
		end
		local fullname = userData.firstname.." "..userData.lastname
		SendNUIMessage({
			event = 'FoundCitizen', 
			citizen = {
				id = userData.identifier,
				name = fullname,
				birthdate = userData.dateofbirth,
				gender = userData.sex,
				driverLicense = userData.driverLicense,
				weaponLicense = userData.weaponLicense,
				lspdTags = userData.lspdTags,
				-- profileImage = nil,
				notes = userData.mdcNotes,
				businesses = userData.businesses,
				houses = userData.houses,
				convictions= userData.convictions,
			}
		})
		for i=1, #userData.lspdTags, 1 do
			if userData.lspdTags[i] == "Poszukiwany" then
				PlaySound(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
				break
			end
		end
	end, closestPlayer)
end)

RegisterNUICallback('policeMdcSearchForCitizen', function(data)
	ESX.TriggerServerCallback('esx_mdc:getAllTags', function(tagsData)
		SendNUIMessage({
			event = 'LoadMdcAllTags', 
			tags = tagsData
		})
	end)
	ESX.TriggerServerCallback('esx_mdc:getConvictionCategories', function(convictionData)
		SendNUIMessage({
			event = 'LoadConvictionCategories', 
			convictions = convictionData
		})
	end)
	ESX.TriggerServerCallback('esx_mdc:getCitizenByName', function(userData)
		if #userData > 1 then
			SendNUIMessage({
				event = 'FoundManyCitizens',
				citizens = userData
			});
		else
			SendNUIMessage({
				event = 'FoundCitizen', 
				citizen = {
					id = userData.identifier,
					name = userData.fullName,
					birthdate = userData.dateofbirth,
					gender = userData.sex,
					driverLicense = userData.driverLicense,
					weaponLicense = userData.weaponLicense,
					lspdTags = userData.lspdTags,
					-- profileImage = nil,
					notes = userData.mdcNotes,
					businesses = userData.businesses,
					houses = userData.houses,
					convictions= userData.convictions,
				}
			})
			for i=1, #userData.lspdTags, 1 do
				if userData.lspdTags[i] == "Poszukiwany" then
					PlaySound(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
					break
				end
			end
		end
	end, data.citizenName, data.citizenId)
end)

RegisterNUICallback('closePoliceMdc', function()
	SetNuiFocus(false, false)
	mdcOpened = false
	stopTabletAnimation()
end)

function startTabletAnimation()
	CreateThread(function()
	  RequestAnimDict(tabletDict)
	  while not HasAnimDictLoaded(tabletDict) do
	    Citizen.Wait(0)
	  end
		attachObject()
		TaskPlayAnim(PlayerPedId(), tabletDict, tabletAnim, 8.0, -8.0, -1, 50, 0, false, false, false)
	end)
end

function attachObject()
	if tabletEntity == nil then
		Citizen.Wait(380)
		RequestModel(tabletModel)
		while not HasModelLoaded(tabletModel) do
			Citizen.Wait(1)
		end
		tabletEntity = Citizen.InvokeNative(0x509D5878EB39E842, GetHashKey(tabletModel), 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(tabletEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.12, 0.10, -0.13, 25.0, 170.0, 160.0, true, true, false, true, 1, true)
	end
end

function stopTabletAnimation()
	if tabletEntity ~= nil then
		StopAnimTask(PlayerPedId(), tabletDict, tabletAnim ,8.0, -8.0, -1, 50, 0, false, false, false)
		DeleteEntity(tabletEntity)
		tabletEntity = nil
	end
end


function getPlayerIdByHex(playerHexToFind)
	for _,playerId in ipairs(GetActivePlayers()) do
		local userid = GetPlayerServerId(playerId)
		local playerData = ESX.GetPlayerData(userid)
		local playerHex = playerData.identifier
		if playerHex == playerHexToFind then
			return userid
		end
	end
	return nil
end

--to remove!!!
-- CreateThread(function()
-- 	while true do
-- 		Wait(2000)
-- 		SetNuiFocus(false, false)
-- 	end
-- end)