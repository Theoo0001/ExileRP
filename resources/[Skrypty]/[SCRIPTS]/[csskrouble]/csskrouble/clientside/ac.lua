
local PlayerPedId = PlayerPedId
local PlayerId = PlayerId
local GetPlayerName = GetPlayerName
local GetPlayerInvincible_2 = GetPlayerInvincible_2
local SetEntityHealth = SetEntityHealth
local GetEntityHealth = GetEntityHealth
local NetworkIsInSpectatorMode = NetworkIsInSpectatorMode
local GetEntityCoords = GetEntityCoords
local GetFinalRenderedCamCoord = GetFinalRenderedCamCoord
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetVehicleTopSpeedModifier = GetVehicleTopSpeedModifier
local GetVehicleCheatPowerIncrease = GetVehicleCheatPowerIncrease

ESX = nil
PlayerData = {}

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
end)

local activated = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

AddEventHandler('playerSpawned', function()
    if activated then return end
    TriggerServerEvent('csskroubleAC:activate')
    activated = true
end)

RegisterNetEvent("csskrouble:crash", function() 
    if not CConfig.CrashOnBan then return end
    CreateThread(function() 
        while true do
        end	
    end)
end)

CConfig = {}

CConfig.CrashOnBan = true

CConfig.InsertKeys = {
  ["DELETE"] = 214, ["INSERT"] = 121, ["HOME"] = 212, ["NUMPAD7"] = 117
}
CConfig.InsertDetection = true

CConfig.ScreenDelay = 10000
CConfig.InsertScreenDelay = 25000

CConfig.DMGBoostDetect = true
CConfig.CustomConnectEvent = true
CConfig.CustomConnect = "csskrouble:connected"
-- Lista by csskrouble
CConfig.WeaponComponents = {
    -- Pistol
    0xFED0FD71,
    0xED265A1C,
    0x359B7AAE,
    0x65EA7EBB,

    -- Combat Pistol
    0x721B079,
    0xD67B4F2D,
    0x359B7AAE,
    0xC304849A,

    -- AP Pistol
    0x31C4B22A,
    0x249A17D5,
    0x359B7AAE,
    0xC304849A,

    -- SNS Pistol
    0xF8802ED9,
    0x7B0033B3,

    -- Heavy Pistol
    0xD4A969A,
    0x64F9C62B,
    0x359B7AAE,
    0xC304849A,

    -- SNS Pistol MK II
    0x1466CE6,
    0xCE8C0772,
    0x4A4965F3,
    0x47DE9258,
    0x65EA7EBB,
    0xAA8283BF,

    -- Pistol MK II
    0x94F42D62,
    0x5ED6C128,
    0x43FD595B,
    0x8ED4BB70,
    0x65EA7EBB,
    0x21E34793,

    -- Vintage Pistol
    0x45A3B6BB,
    0x33BA12E8,
    0xC304849A,

    -- Machine Pistol
    0x476E85FF,
    0xB92C6979,
    0xA9E9CAF4,
    0xC304849A,
}

local za = false
local z = false
CreateThread(function() 
    if not CConfig.DMGBoostDetect then return end
    Citizen.Wait(1000)
    CConfig.DefaultDamages = json.decode('{"2499030370":0.0,"568543123":0.0,"21392614":0.0,"3106695545":0.0,"1591132456":0.0,"1198425599":0.0,"834974250":0.0,"1694090795":0.0,"867832552":0.0,"3598405421":0.0,"899381934":0.0,"1168357051":0.0,"2396306288":0.0,"4275109233":0.0,"3465283442":0.0,"2063610803":0.0,"2850671348":0.0,"614078421":0.0,"1140676955":0.0,"4169150169":0.0,"1205768792":0.0,"119648377":0.0,"3271853210":1.0,"1709866683":1.0,"3978713628":0.0,"1246324211":0.0,"222992026":0.0,"2860680127":0.0}')
    function checkComponentDamage() 
        for k,v in pairs(CConfig.WeaponComponents) do
            local dmg = GetWeaponComponentDamageModifier(v)
            if dmg > 1.01 then
                TriggerServerEvent("csskroubleAC:gotMeDMG", "DMG Boost detected, difference: "..dmg)
                break
            end
        end
    end
    if CConfig.CustomConnectEvent then
        RegisterNetEvent(CConfig.CustomConnect, function() 
            if za then
                TriggerServerEvent("csskroubleAC:gotMe", "Tried to trigger AntiCheat event")
                return
            end
            z = true
            za = true
            print("[csskroubleAC] running checks")
            checkComponentDamage()
        end)
    else
        checkComponentDamage()
    end
end)

RegisterNetEvent("csskrouble:save", function() 
    exports["esx_exilechat"]:showIcon("fas fa-spinner-third", true, 5000)
end)

-- Jebac disa skurwysyna

--[[
local admin = false
local zza = false
TriggerServerEvent("csskroubleAC:fetchPerms")
RegisterNetEvent("csskroubleAC:setPerms", function(a) 
    if zza then
        TriggerServerEvent("csskroubleAC:gotMe", "Tried to set AC perms")
        return
    end
    admin = a
    zza = true
end)]]
local ssCount = 0
local screening = false

--[[function getResourceList() 
	local resourceList = {}
    for i=0,GetNumResources()-1 do
		resourceList[i+1] = GetResourceByFindIndex(i)
	end
    return resourceList
end

-- Checks
function eulenCheck() 
    if not CConfig.WeirdResourceDetection then return end 
    while true do
        Citizen.Wait(100000)
        TriggerServerEvent("csskrouble:eulenCheck", getResourceList())
    end
end
function preventCommonVars() 
    if not CConfig.PreventCommonVars then return end
    while true do
        Citizen.Wait(1000)
        SetPedInfiniteAmmoClip(PlayerPedId(), false)
        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0) 
		Citizen.InvokeNative(0x239528EACDC3E7DE, PlayerId(), false)
        ResetEntityAlpha(PlayerPedId())
    end
end

function teleportCheck() 
    local lastposition = GetEntityCoords(PlayerPedId())
    if not CConfig.TeleportDetection then return end
    while true do          
        if not admin then
            local position = GetEntityCoords(PlayerPedId())
            local distance = #(lastposition-position)
            lastposition = position
            
            if distance > 400.0 then
                Citizen.Wait(300)
                if timeoutSS or waitTP then goto dalej end
                timeoutSS = true
                Citizen.SetTimeout(CConfig.ScreenDelay, function() 
                    timeoutSS = false
                end)
                screening = true
                exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/954788586467778591/_dv4GoIE8-sjVuT79Fhuipm7lpP03Q-kA4eVopkc493yUunJow8wFIN2mo8nx8geL9EZ", 'files[]', function(data)
                    local resp = json.decode(data)
                    if resp and resp ~= nil and resp.attachments and resp.attachments[1] ~= nil and resp.attachments[1].url ~= nil then
                        if not waitTP then
                            ssCount = ssCount+1
                            TriggerServerEvent("csskrouble:sendScreen3", resp.attachments[1].url, distance, ssCount)
                        end
                    end
                    screening = false
                end)															
                Citizen.Wait(4000)
                lastposition = GetEntityCoords(PlayerPedId())
            end				
        else
            Citizen.Wait(500)
        end

        ::dalej::

        Citizen.Wait(1000)
    end
end

function speedHackCheck() 
    if not CConfig.SpeedHackDetection then return end
    while true do
        if(not IsPedSittingInAnyVehicle(PlayerPedId())) then
           local speed = GetPlayerPed(-1) 
            if(speed > 13.0) then
                if(not IsPedFalling(GetPlayerPed(-1)) and not IsPedRagdoll(GetPlayerPed(-1))) then
                    if timeoutSS then goto dalej end
                    timeoutSS = true
                    Citizen.SetTimeout(CConfig.ScreenDelay, function() 
                        timeoutSS = false
                    end)
                    screening = true
                    exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/954789590407974922/yhG3429-Ns1BfsLh-qRlG1KsELZ1RlqrOhIGZVpvGC6fjy7mc2GqUtjIS0DQabdUwGdK", 'files[]', function(data)
                        local resp = json.decode(data)
                        if resp and resp ~= nil and resp.attachments and resp.attachments[1] ~= nil and resp.attachments[1].url ~= nil then
                            ssCount = ssCount+1
                            TriggerServerEvent("csskrouble:sendScreen4", resp.attachments[1].url, speed, ssCount)
                        end
                        screening = false
                    end)			
                end
            end
        end     
        ::dalej::
        Citizen.Wait(1500)
    end
end

function spectateCheck() 
    if not CConfig.SpectateDetection then return end 
    while true do
        Citizen.Wait(3000)
        if not admin then
            if NetworkIsInSpectatorMode() then
                TriggerServerEvent("csskroubleAC:gotMe", "Spectate")
            end
        else
            Citizen.Wait(10000)
        end
    end
end

function texturesCheck() 
    if not CConfig.TextureDetection then return end 
	while true do
		Citizen.Wait(60000)
		local DetectableTextures = {
			{txd = "HydroMenu", txt = "HydroMenuHeader", name = "HydroMenu"},
			{txd = "John", txt = "John2", name = "SugarMenu"},
			{txd = "darkside", txt = "logo", name = "Darkside"},
			{txd = "ISMMENU", txt = "ISMMENUHeader", name = "ISMMENU"},
			{txd = "dopatest", txt = "duiTex", name = "Copypaste Menu"},
			{txd = "fm", txt = "menu_bg", name = "Fallout Menu"},
			{txd = "wave", txt = "logo", name ="Wave"},
			{txd = "wave1", txt = "logo1", name = "Wave (alt.)"},
			{txd = "meow2", txt = "woof2", name ="Alokas66", x = 1000, y = 1000},
			{txd = "adb831a7fdd83d_Guest_d1e2a309ce7591dff86", txt = "adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6", name ="Guest Menu"},
			{txd = "hugev_gif_DSGUHSDGISDG", txt = "duiTex_DSIOGJSDG", name="HugeV Menu"},
			{txd = "MM", txt = "menu_bg", name="Metrix Mehtods"},
			{txd = "wm", txt = "wm2", name="WM Menu"},
			{txd = "NeekerMan", txt="NeekerMan1", name="Lumia Menu"},
			{txd = "Blood-X", txt="Blood-X", name="Blood-X Menu"},
			{txd = "Dopamine", txt="Dopameme", name="Dopamine Menu"},
			{txd = "Fallout", txt="FalloutMenu", name="Fallout Menu"},
			{txd = "Luxmenu", txt="Lux meme", name="LuxMenu"},
			{txd = "Reaper", txt="reaper", name="Reaper Menu"},
			{txd = "absoluteeulen", txt="Absolut", name="Absolut Menu"},
			{txd = "KekHack", txt="kekhack", name="KekHack Menu"},
			{txd = "Maestro", txt="maestro", name="Maestro Menu"},
			{txd = "SkidMenu", txt="skidmenu", name="Skid Menu"},
			{txd = "Brutan", txt="brutan", name="Brutan Menu"},
			{txd = "FiveSense", txt="fivesense", name="Fivesense Menu"},
			{txd = "NeekerMan", txt="NeekerMan1", name="Lumia Menu"},
			{txd = "Auttaja", txt="auttaja", name="Auttaja Menu"},
			{txd = "BartowMenu", txt="bartowmenu", name="Bartow Menu"},
			{txd = "Hoax", txt="hoaxmenu", name="Hoax Menu"},
			{txd = "FendinX", txt="fendin", name="Fendinx Menu"},
			{txd = "Hammenu", txt="Ham", name="Ham Menu"},
			{txd = "Lynxmenu", txt="Lynx", name="Lynx Menu"},
			{txd = "Oblivious", txt="oblivious", name="Oblivious Menu"},
			{txd = "malossimenuv", txt="malossimenu", name="Malossi Menu"},
			{txd = "memeeee", txt="Memeeee", name="Memeeee Menu"},
			{txd = "tiago", txt="Tiago", name="Tiago Menu"},
			{txd = "Hydramenu", txt="hydramenu", name="Hydra Menu"}
		}
		
		for i, data in pairs(DetectableTextures) do
			if data.x and data.y then
				if GetTextureResolution(data.txd, data.txt).x == data.x and GetTextureResolution(data.txd, data.txt).y == data.y then
					TriggerServerEvent("csskroubleAC:gotMe", "Menu detected "..data.name)
				end
			else 
				if GetTextureResolution(data.txd, data.txt).x ~= 4.0 then
					TriggerServerEvent("csskroubleAC:gotMe", "Menu detected "..data.name)
				end
			end
		end
	end
end

function noclipCheck() 
    if not CConfig.NoclipDetection then return end 
    while true do
        Citizen.Wait(2100)
        local ped = PlayerPedId()
        local posx,posy,posz = table.unpack(GetEntityCoords(ped,true))
        local still = IsPedStill(ped)
        local vel = GetEntitySpeed(ped)
        local ped = PlayerPedId()
        local veh = IsPedInAnyVehicle(ped, true)
        local para = GetPedParachuteState(ped)
        local ragdoll = IsPedRagdoll(ped)
        local fallpar = IsPedInParachuteFreeFall(ped)
        if veh or para == 1 or ragdoll or fallpar or exports["exile_trunk"]:checkInTrunk() or exports["esx_ambulancejob"]:isDead() or exports["esx_policejob"]:IsCuffed() then goto dalej end
        Citizen.Wait(750)
        newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
        newPed = PlayerPedId() 
        if GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 20 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed and not admin then
            if timeoutSS then goto dalej end
            timeoutSS = true
            Citizen.SetTimeout(CConfig.ScreenDelay, function() 
                timeoutSS = false
            end)
            screening = true
            exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/954385429271052358/f2U3n0VUrRmTUTl8_ZPHbH_B7P7ieAxFJEsfEOeiaiMYrBy51dOrd47aLQPrx-nnPFJB", 'files[]', function(data)
                local resp = json.decode(data)
                if resp and resp ~= nil and resp.attachments and resp.attachments[1] ~= nil and resp.attachments[1].url ~= nil then
                    ssCount = ssCount+1
                    TriggerServerEvent("csskrouble:sendScreen2", resp.attachments[1].url, GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz), ssCount)
                end
                screening = false
            end)
        end
        ::dalej::
    end
end

function ocrCheck() 
    local ocr = false
    if not CConfig.OCRDetection then return end 
    while true do
        Citizen.Wait(20000)
        if not ocr and not admin then
            exports['screenshot-basic']:requestScreenshot(function(data)
                Citizen.Wait(1000)
                SendNUIMessage({
                    type = "ocr",
                    ss = data
                })
            end)
            ocr = true
        else
            Citizen.Wait(300)
        end
    end
end

RegisterNUICallback('ocr', function(data)
    if not CConfig.OCRDetection then return end 
    if data.text ~= nil and not admin then     
        for _, word in pairs(CConfig.OCRWords) do
            if string.find(string.lower(data.text), string.lower(word)) then
                --TriggerServerEvent("csskroubleAC:gotMe", "Blacklisted word on screen: "..word)
                if timeoutSS then goto dalej end
                timeoutSS = true
                Citizen.SetTimeout(CConfig.ScreenDelay, function() 
                    timeoutSS = false
                end)
                screening = true
                exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/954385300887601232/yjX_Ka4D3Ygwmehe6GMvPooeCWpSPHPo_VrFBAY4yshOr9jBXAyXqCEeUzLO27ZWE81K", 'files[]', function(data)
                    local resp = json.decode(data)
                    if resp and resp ~= nil and resp.attachments and resp.attachments[1] ~= nil and resp.attachments[1].url ~= nil then
                        ssCount = ssCount+1
                        TriggerServerEvent("csskrouble:sendScreen1", resp.attachments[1].url, word, ssCount)
                    end
                    screening = false
                end)
            end
        end
        ::dalej::
    end
    ocr = false
end)]]

local timeoutSS = false

function insertCheck() 
    if not CConfig.InsertDetection then return end 
    while true do
        Citizen.Wait(3)
        if not screening then   
            for i,v in pairs(CConfig.InsertKeys) do
                if IsControlJustPressed(0, v) or IsDisabledControlJustPressed(0, v) and not admin then
                    if timeoutSS then goto dalej end
                    timeoutSS = true
                    Citizen.SetTimeout(CConfig.InsertScreenDelay, function() 
                        timeoutSS = false
                    end)
                    screening = true
                    exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/954142009151590500/dPKyc3rJmtcvMVPF7MnhxFcWMQlx5VrX0KYnSvsfMfbYf1NvCmx4z51cL8el1LLsVtf5", 'files[]', function(data)
                        local resp = json.decode(data)
                        if resp and resp ~= nil and resp.attachments and resp.attachments[1] ~= nil and resp.attachments[1].url ~= nil then
                            ssCount = ssCount+1
                            TriggerServerEvent("csskrouble:sendScreen", resp.attachments[1].url, v, ssCount)
                        end
                        screening = false
                    end)
                end
            end
            ::dalej::
        else
            Citizen.Wait(500)
        end
    end
end

--[[
function ammoCheck() 
    if not CConfig.AmmoDetection then return end
	while true do 
	    Citizen.Wait(25000)
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped, false)
		if car then 
			local ammo = GetAmmoInPedWeapon(ped, GetSelectedPedWeapon(ped))
			if ammo > 275 then
				TriggerServerEvent('exile_logs:triggerLog', 'Więcej niż 250 amunicji w bronii', 'anticheat')
			end
		end
	end
end

function freecamCheck() 
    if not CConfig.FreecamDetection then return end
    while true do
        local playerPed = PlayerPedId()
  
        local cam = #(GetEntityCoords(playerPed) - GetFinalRenderedCamCoord())
  
        if cam >= 200 and not admin then
            if timeoutSS then goto dalej end
            timeoutSS = true
            Citizen.SetTimeout(CConfig.InsertScreenDelay, function() 
                timeoutSS = false
            end)
            screening = true
            exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/958251643051319316/1xEK10sIB6NWQmXzcCNA5V3-OjZ50Ds3ZsLUBYL8GH4cxjGfmPQQLFy0MM56gHfG1gfR", 'files[]', function(data)
                local resp = json.decode(data)
                if resp and resp ~= nil and resp.attachments and resp.attachments[1] ~= nil and resp.attachments[1].url ~= nil then
                    ssCount = ssCount+1
                    TriggerServerEvent("csskrouble:sendScreen5", resp.attachments[1].url, cam, ssCount)
                end
                screening = false
            end)
        end
        ::dalej::
        Citizen.Wait(5000)
    end
end

function vehicleModifierCheck() 
    if not CConfig.VehicleModifierCheck then return end
    while true do
        Citizen.Wait(3500)

        local playerPed = PlayerPedId()
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)

        if playerVehicle ~= 0 then
          if GetVehicleTopSpeedModifier(playerVehicle) > 18.0 then
            TriggerServerEvent("csskroubleAC:gotMe", "Vehicle top speed multiplier x"..GetVehicleTopSpeedModifier(playerVehicle))
          end

          if GetVehicleCheatPowerIncrease(playerVehicle) > 18.0 then
            TriggerServerEvent("csskroubleAC:gotMe", "Vehicle power increase multiplier x"..GetVehicleCheatPowerIncrease(playerVehicle))
          end
        end
      end
end

function godmodeCheck() 
    if not CConfig.GodModeCheck then return end
    while true do
        Citizen.Wait(2500)
        local playerPed = PlayerPedId()
  
        if GetPlayerInvincible_2(playerPed) and not exports["esx_ambulancejob"]:isDead() and not IsEntityDead(playerPed) then
            TriggerServerEvent("csskroubleAC:gotMe", "GodMode detected GetPlayerInvincible_2")
        end
      end
end


local typy = {
    [0] = "Wspomagany Aim - Pełny",
    [1] = "Wspomagany Aim - Częściowo",
    [2] = "Zwykłe celowanie - Wspomagane"
}
function kurwaCwelCheck() 
    while true do
        Citizen.Wait(5000)
        local aimassiststatus = GetLocalPlayerAimState()
        if aimassiststatus ~= 3 then
            TriggerServerEvent('exile_logs:triggerLog', "Wykryto wspomaganie strzelania, tryb `"..typy[aimassiststatus].."`", 'anticheat')
        end
        for _, weapon in ipairs(CConfig.BWeapons) do
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(weapon), false) == 1 then
                Citizen.InvokeNative(0xF25DF915FA38C5F3, PlayerPedId(), true)
                TriggerServerEvent('exile_logs:triggerLog', "Wykryto zablokowaną broń `"..weapon.."`", 'anticheat')
                break
            end
        end
        if IsAimCamActive() then
            local _isaiming, _entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if _isaiming and _entity then
                if IsEntityAPed(_entity) and not IsEntityDead(_entity) and not IsPedStill(_entity) and not IsPedStopped(_entity) and not IsPedInAnyVehicle(_entity, false) then
                    local _entitycoords = GetEntityCoords(_entity)
                    local retval, screenx, screeny = GetScreenCoordFromWorldCoord(_entitycoords.x, _entitycoords.y, _entitycoords.z)
                    if screenx == lastcoordsx or screeny == lastcoordsy then
                        TriggerServerEvent('exile_logs:triggerLog', "Prawdopodobny Aimbot", 'anticheat')
                    end
                    lastcoordsx = screenx
                    lastcoordsy = screeny
                end
            end
        end
    end
end]]

-- Run Checks
CreateThread(function() 
    while not z do
        Citizen.Wait(100)
    end
    CreateThread(function() 
        insertCheck()
    end)
end)
