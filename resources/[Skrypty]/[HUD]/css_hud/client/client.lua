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
CreateThread(function()
	local breakMe = 0
    while ESX == nil do
        Citizen.Wait(100)
		breakMe = breakMe + 1
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		if breakMe > 10 then
			break
		end
    end
end)
local oldhud = false
local directions = {
    N = 360, 0,
    NE = 315,
    E = 270,
    SE = 225,
    S = 180,
    SW = 135,
    W = 90,
    NW = 45
}

function round(value, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        if not oldhud then
            BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
            ScaleformMovieMethodAddParamInt(3)
            EndScaleformMovieMethod()
            Citizen.Wait(255)
        else
            Citizen.Wait(1000)
        end    
    end
end)

CreateThread(function() 
    while true do
        Citizen.Wait(5000)
        local expanded = IsBigmapActive()
        local fullMap = IsBigmapFull()
        if expanded or fullMap then
            SetRadarBigmapEnabled(true, false)
            Citizen.Wait(0)
            SetRadarBigmapEnabled(false, false)
        end    
    end
end)

-- Car Hud

function _DrawRect(X, Y, W, H, R, G, B, A, L)
	SetUiLayer(L)
	DrawRect(X, Y, W, H, R, G, B, A)
end

CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedInAnyVehicle(PlayerPedId()) and not IsPauseMenuActive() then
            Citizen.Wait(66)
            local PedCar = GetVehiclePedIsUsing(PlayerPedId(), false)
            carSpeed = math.floor(GetEntitySpeed(PedCar) * 3.6 + 0.5)
            carMaxSpeed = math.ceil(GetVehicleEstimatedMaxSpeed(PedCar) * 3.6 + 0.5)
            carSpeedPercent = carSpeed / carMaxSpeed * 100
            rpm = GetVehicleCurrentRpm(PedCar) * 100

            local eHealth = GetVehicleEngineHealth(PedCar)
            SendNUIMessage({
                speedometer = true,
                speed = carSpeed,
                percent = carSpeedPercent,
                tachometer = true,
                rpmx = rpm,
                gear = GetVehicleCurrentGear(PedCar),
                eHealth = eHealth
            })
        else
            Citizen.Wait(500)
        end 
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(410)
        if IsPedInAnyVehicle(PlayerPedId()) and not IsPauseMenuActive() then
            local PedCar = GetVehiclePedIsUsing(PlayerPedId(), false)
            local coords = GetEntityCoords(PlayerPedId())

            local _,b,c = GetVehicleLightsState(PedCar)

            SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
            SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
            SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
            SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
            SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0) -- Level 4

            --  Show hud
            SendNUIMessage({
                showhud = true,
                stylex = 'classic',
                showCompass = 'on',
                lights = 1+b+c,
                seatbelt = exports['exile_blackout']:pasyState()
            })
        else
            SendNUIMessage({
                showhud = false
            })
            Citizen.Wait(2000)
        end   
    end
end)

local hash1, hash2;
CreateThread(function() 
    while true do
        Citizen.Wait(370)
        local ped, direction = PlayerPedId(), nil
        for k, v in pairs(Config.Directions) do
            direction = GetEntityHeading(ped)
            if math.abs(direction - k) < 22.5 then
                direction = v
                break
            end
        end

        local coords = GetEntityCoords(ped, true)
        local zone = GetNameOfZone(coords.x, coords.y, coords.z)
        local zoneLabel = GetLabelText(zone)
        local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
        hash1 = GetStreetNameFromHashKey(var1);
        hash2 = GetStreetNameFromHashKey(var2);

        local street2;
        if (hash2 == '') then
            street2 = zoneLabel;
        else
            street2 = hash2..', '..zoneLabel;
        end

        SendNUIMessage({
            street = street2,
            direction = (direction or 'N')
        })   
    end    
end)

-- Radio jebane
--[[CreateThread(function() 
    while true do
            Wait(2000)
            local data = exports['rp-radio']:GetRadioData()
            if tostring(data[3]) == "0" then
                SendNUIMessage({
                    hideradio = true
                })    
            else
                SendNUIMessage({
                    showradio = true
                })  
            end    
            SendNUIMessage({
                radionumber = data[2],
                radiocount = data[3],
            }) 
    end
end)]]

RegisterNetEvent("csskrouble:toggleSpeedo", function(b) 
    SendNUIMessage({
        type = "SWITCH_SPEEDO",
        bool = b
    })
end)

-- Show/Hide Radar
radardisplayed = true
CreateThread(function()
    while true do
        Citizen.Wait(400)
        if hudhidden then
            radardisplayed = false
            TriggerEvent("csskrouble:hideHud", false)
            DisplayRadar(0)
        else 
            if IsPedInAnyVehicle(PlayerPedId()) or exports["gcphone"]:getMenuIsOpen() then
                radardisplayed = true
                TriggerEvent("csskrouble:hideHud", true)
                DisplayRadar(1)
            else
                radardisplayed = false
                TriggerEvent("csskrouble:hideHud", false)
                DisplayRadar(0)
            end  
        end     
    end
end)
--true stary false nowy
RegisterNUICallback("sethud", function(data, cb)
    if data.mode then
        oldhud = true
        CreateThread(function() 
            Citizen.Wait(200)
            SetBigmapActive(true, true)
            Citizen.Wait(10)
            SetBigmapActive(false, false)
        end)
        TriggerEvent('esx_status:setDisplay', 0.5)
    else
        oldhud = false
        TriggerEvent('esx_status:setDisplay', 0.0)
    end      
    TriggerEvent("csskrouble:oldHud", oldhud)
    cb({})
end)

function RadarShown()
    return radardisplayed
end

function toboolean(str)
    local bool = false
    if str == "true" then
        bool = true
    end
    return bool
end


-- MiniMap
RegisterNetEvent("route68:kino", function() 
    handleCam()
end)
RegisterNetEvent("route68:kino2", function() 
    handleCam()
end)

hudhidden = false
function handleCam() 
    hudhidden = not hudhidden
    if not oldhud then
        SendNUIMessage({type="SWITCH_DISPLAY"})
    end
end
-- Status hud update

CreateThread(function() 
    while true do
        if not oldhud then
            Citizen.Wait(435)
            local armor = GetPedArmour(PlayerPedId())
            local hp = GetEntityHealth(PlayerPedId()) - 100
            SendNUIMessage({
                type = 'UPDATE_HUD',
                armor = armor,
                nurkowanie = GetPlayerUnderwaterTimeRemaining(PlayerId())*10,
                inwater = IsPedSwimmingUnderWater(PlayerPedId()),
                zycie = hp,
                isdead = hp <= 0
            })     
        else
            Wait(1000)    
        end    
    end
end)

RegisterCommand("hudsettings", function(src, args, raw)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "OPEN_SETTINGS"
        })
end, false)

RegisterCommand("fixcursor", function(src,args,raw) 
    SetNuiFocus(false, false)
end)

RegisterNUICallback("NUIFocusOff", function(data,cb) 
    SetNuiFocus(false, false)
    cb({})
end)

CreateThread(function()
    while true do
        if not oldhud then
            Citizen.Wait(850)

            TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                hunger = status.getPercent()
            end)
            TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                thirst = status.getPercent()
            end)

            SendNUIMessage({
                type = 'UPDATE_HUD',
                hunger = hunger,
                thirst = thirst,
            }) 
        else
            Wait(1000)    
        end     
    end
end)

CreateThread(function() 
    while true do
        Citizen.Wait(180000)
        TriggerEvent('esx_status:getStatus', 'hunger', function(status)
            hunger = status.getPercent()
        end)
        TriggerEvent('esx_status:getStatus', 'thirst', function(status)
            thirst = status.getPercent()
        end)
        if hunger < 10 and thirst < 10 then
            ESX.ShowNotification("~r~Zostało Ci poniżej 10% jedzenia i picia!")
        elseif hunger < 10 then
            ESX.ShowNotification("~r~Zostało Ci poniżej 10% jedzenia!")
        elseif thirst < 10 then
            ESX.ShowNotification("~r~Zostało Ci poniżej 10% picia!")
        end    
    end    
end)




-- voice

function GetProximity(proximity)
    for k,v in pairs(Config.proximityModes) do
        if v[1] == proximity then
            return v[2]
        end
    end
    return 0
end

CreateThread(function()
    while true do
        if not oldhud then
            Citizen.Wait(210)
            local state = NetworkIsPlayerTalking(PlayerId())
            local mode = Player(GetPlayerServerId(PlayerId())).state.proximity.mode
            SendNUIMessage({
                type = 'UPDATE_VOICE',
                isTalking = state,
                mode = mode
            })
        else
            Wait(1000)    
        end     
    end
end)

-- toggle hud

RegisterNetEvent("csskrouble:changeHud", function(mode) 
    newhud = mode
    SendNUIMessage({type="SWITCH_VISIBILITY", bool=mode})
    if not mode then
        CreateThread(function()
            Citizen.Wait(1500)
            SetRadarBigmapEnabled(true, false)
            Citizen.Wait(0)
            SetRadarBigmapEnabled(false, false)
        end)
    end    
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    SendNUIMessage({
        type = 'TOGGLE_HUD'
    })
end)

RegisterCommand('togglehud', function()
    SendNUIMessage({
        type = 'TOGGLE_HUD'
    })
end, false)

RegisterKeyMapping('togglehud', 'Toggle Hud', 'mouse_button', 'MOUSE_MIDDLE')

RegisterCommand("minimapfix", function(src, args, raw) 
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
end)



-- hud settings



--[[ Stary HUD ]]
local RPM = 0
local RPMTime = GetGameTimer()
local Status = true

AddEventHandler('carhud:display', function(status)
	Status = status
end)

RegisterCommand("switchhud", function(src,args,raw) 
    oldhud = not oldhud
    SendNUIMessage({type="SWITCH_HUD",mode=oldhud})
    ESX.ShowNotification("~w~Zmieniono tryb hudu")
    CreateThread(function() 
        Citizen.Wait(200)
        SetBigmapActive(true, true)
        Citizen.Wait(10)
        SetBigmapActive(false, false)
    end)
    if oldhud then
        TriggerEvent('esx_status:setDisplay', 0.5)
    else
        TriggerEvent('esx_status:setDisplay', 0.0)
    end    
    TriggerEvent("csskrouble:oldHud", oldhud)
end)

local Ped = {
	Vehicle = nil,
	VehicleClass = nil,
	VehicleStopped = true,
	VehicleEngine = false,
	VehicleGear = nil
}

local CruiseControl = false
CreateThread(function()
	while true do
        if oldhud then
            Citizen.Wait(155)

            if Status and not exports['esx_policejob']:IsCuffed() then
                local ped = PlayerPedId()
                if IsPedInAnyVehicle(ped, false) then
                    Ped.Vehicle = GetVehiclePedIsIn(ped, false)
                    Ped.VehicleClass = GetVehicleClass(Ped.Vehicle)
                    Ped.VehicleStopped = IsVehicleStopped(Ped.Vehicle)
                    Ped.VehicleEngine = GetIsVehicleEngineRunning(Ped.Vehicle)
                    Ped.VehicleGear = GetVehicleCurrentGear(Ped.Vehicle)	
                else
                    Ped.Vehicle = nil
                end
            else
                Ped.Vehicle = nil
            end
        else
            Wait(1000)
        end   
	end
end)

function _DrawText(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(4)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end

function _DrawRect(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function GetStreetsCustom(coords)
	local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
	local street1, street2 = GetStreetNameFromHashKey(s1), GetStreetNameFromHashKey(s2)
	return "~y~" .. street1 .. (street2 ~= "" and "~s~ / " .. street2 or "")
end
local streetLabel = {}
--local hour, minute = 0, 0
--local baseTime = 0
--local timeOffset = 0
--local timer = 0
--local freezeTime = false
CreateThread(function() 
    while true do
        if oldhud then
            Citizen.Wait(500)
            local ped, direction = PlayerPedId(), nil
            for k, v in pairs(Config.Directions) do
                direction = GetEntityHeading(ped)
                if math.abs(direction - k) < 22.5 then
                    direction = v
                    break
                end
            end
    
            local coords = GetEntityCoords(ped, true)
            local zone = GetNameOfZone(coords.x, coords.y, coords.z)
    
            streetLabel.zone = (Config.Zones[zone:upper()] or zone:upper())
            streetLabel.street = GetStreetsCustom(coords)
            streetLabel.direction = (direction or 'N')
        else
           Wait(1000) 
        end    
    end    
end)

CreateThread(function() 
    while true do
        if oldhud then
            Citizen.Wait(3)
            if streetLabel and streetLabel.direction and IsRadarEnabled() then
                _DrawText(0.515, 1.26, 1.0, 1.0, 0.4, streetLabel.zone, 66, 165, 245, 200)
                --_DrawText(0.635, 1.26, 1.0, 1.0, 0.4, (hour < 10 and '0' or '') .. hour .. ':' .. (minute < 10 and '0' or '') .. minute, 107, 131, 22, 200)
                _DrawText(0.515, 1.28, 1.0, 1.0, 0.33, streetLabel.street, 165, 165, 165, 200)
                _DrawText((streetLabel.direction:len() > 1 and 0.644 or 0.648), 1.28, 1.0, 1.0, 0.33, streetLabel.direction, 255, 255, 255, 200)
            else
                Wait(200)
            end
        else
            Wait(1000)     
        end    
    end    
end)

CreateThread(function()
	while true do
        if oldhud then
            Citizen.Wait(3)
            if Ped.Vehicle then
                local Gear = Ped.VehicleGear
                if not Ped.VehicleEngine then
                    Gear = 'P'
                elseif Ped.VehicleStopped then
                    Gear = 'N'
                elseif Ped.VehicleClass == 15 or Ped.VehicleClass == 16 then
                    Gear = 'F'
                elseif Ped.VehicleClass == 14 then
                    Gear = 'S'
                elseif Gear == 0 then
                    Gear = 'R'
                end

                local RPMScale = 0
                if (Ped.VehicleClass >= 0 and Ped.VehicleClass <= 5) or (Ped.VehicleClass >= 9 and Ped.VehicleClass <= 12) or Ped.VehicleClass == 17 or Ped.VehicleClass == 18 or Ped.VehicleClass == 20 then
                    RPMScale = 7000
                elseif Ped.VehicleClass == 6 then
                    RPMScale = 7500
                elseif Ped.VehicleClass == 7 then
                    RPMScale = 8000
                elseif Ped.VehicleClass == 8 then
                    RPMScale = 11000
                elseif Ped.VehicleClass == 15 or Ped.VehicleClass == 16 then
                    RPMScale = -1
                end

                local Speed = math.floor(GetEntitySpeed(Ped.Vehicle) * 3.6 + 0.5)
                if RPMTime <= GetGameTimer() then
                    local r = GetVehicleCurrentRpm(Ped.Vehicle)
                    if not Ped.VehicleEngine then
                        r = 0
                    elseif r > 0.99 then
                        r = r * 100
                        r = r + math.random(-2,2)

                        r = r / 100
                        if r < 0.12 then
                            r = 0.12
                        end
                    else
                        r = r - 0.1
                    end

                    RPM = math.floor(RPMScale * r + 0.5)
                    if RPM < 0 then
                        RPM = 0
                    elseif Speed == 0.0 and r ~= 0 then
                        RPM = math.random(RPM, (RPM + 50))
                    end

                    RPM = math.floor(RPM / 10) * 10
                    RPMTime = GetGameTimer() + 50
                end

                local UI = { x = 0.0, y = 0.0 }
                if RPMScale > 0 then
                    drawRct(UI.x + 0.1135, 	UI.y + 0.804, 0.042,0.026,0,0,0,100)
                    drawTxt(UI.x + 0.6137, 	UI.y + 1.296, 1.0,1.0,0.45 , "~" .. (RPM > (RPMScale - 1000) and "r" or "w") .. "~" .. RPM, 255, 255, 255, 255)
                    drawTxt(UI.x + 0.635, 	UI.y + 1.3, 1.0,1.0,0.35, "~w~rpm/~y~" .. Gear, 255, 255, 255, 255)
                else
                    drawRct(UI.x + 0.1135, 	UI.y + 0.804, 0.042,0.026,0,0,0,100)
                    local coords = GetEntityCoords(Ped.Vehicle, false)
                    drawTxt(UI.x + 0.6137, 	UI.y + 1.296, 1.0,1.0,0.45, math.floor(coords.z), 255, 255, 255, 255)
                    drawTxt(UI.x + 0.635, 	UI.y + 1.3, 1.0,1.0,0.35, "mnpm", 255, 255, 255, 255)
                end

                drawRct(UI.x + 0.1195, 	UI.y + 0.938, 0.036,0.03,0,0,0,100)
                drawTxt(UI.x + 0.62, 	UI.y + 1.431, 1.0,1.0,0.5 , "~" .. (CruiseControl and "b" or "w") .. "~" .. Speed, 255, 255, 255, 255)
                drawTxt(UI.x + 0.637, 	UI.y + 1.438, 1.0,1.0,0.35, "~" .. (Speed > 85 and (Speed > 155 and "r" or "y") or "w") .. "~km/h", 255, 255, 255, 255)
            else
                Citizen.Wait(500)
            end
        else
            Wait(1000)        
        end    
	end
end)

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2, y - height / 2 + 0.005)
end

function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

local Ped = {
	Health = 0,
	Armor = 0,
	Stamina = 0,
	Underwater = false,
	UnderwaterTime = 0,
	Driver = false,
	PhoneVisible = false,
	DisplayStreet = false
}

local cam = false

RegisterNetEvent('route68:kino2')
AddEventHandler('route68:kino2', function()
    cam = not cam
end)

CreateThread(function()
	while true do
        if oldhud then
            Citizen.Wait(245)

            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                Ped.InVehicle = true
                Ped.Driver = GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped
            else
                Ped.InVehicle = false
                Ped.Health = GetEntityHealth(ped)
                Ped.Armor = GetPedArmour(ped)
                Ped.Underwater = IsPedSwimmingUnderWater(ped)

                local pid = PlayerId()
                Ped.Stamina = GetPlayerSprintStaminaRemaining(pid)

                Ped.UnderwaterTime = GetPlayerUnderwaterTimeRemaining(pid)
                if Ped.UnderwaterTime < 0.0 then
                    Ped.UnderwaterTime = 0.0
                end
            end

            Ped.PhoneVisible = exports['gcphone']:getMenuIsOpen()
            Ped.DisplayStreet = exports['ExileRP']:DisplayingStreet()
        else
            Wait(1000)
        end
	end
end)

local OnlyDriver = false
CreateThread(function()
    while true do
        if oldhud then
            if cam then
                sleep = 500
                DisplayRadar(false)
                TriggerEvent('ExileRP:setDisplayStreet', false)
            else
                sleep = 3
                if Ped.InVehicle then
                    if not OnlyDriver or Ped.Driver then
                        DisplayRadar(true)
                        if not Ped.DisplayStreet then
                            TriggerEvent('ExileRP:setDisplayStreet', true)
                        end
                    end
                elseif Ped.PhoneVisible then
                    DisplayRadar(true)
                    if not Ped.DisplayStreet then
                        TriggerEvent('ExileRP:setDisplayStreet', true)
                    end
                else
                    DisplayRadar(false)
                    if Ped.DisplayStreet then
                        TriggerEvent('ExileRP:setDisplayStreet', false)
                    end
                    local MM = GetMinimapAnchor()
                    local BarY = MM.bottom_y - ((MM.yunit * 18.0) * 0.55)
                    local BackgroundBarH = MM.yunit * 18.0
                    local BarH = BackgroundBarH / 2
                    local BarSpacer = MM.xunit * 3.0
                    local BackgroundBar = {['R'] = 0, ['G'] = 0, ['B'] = 0, ['A'] = 125, ['L'] = 0}
                    
                    local HealthBaseBar = {['R'] = 57, ['G'] = 102, ['B'] = 57, ['A'] = 175, ['L'] = 1}
                    local HealthBar = {['R'] = 114, ['G'] = 204, ['B'] = 114, ['A'] = 175, ['L'] = 2}
                    
                    local HealthHitBaseBar = {['R'] = 112, ['G'] = 25, ['B'] = 25, ['A'] = 175}
                    local HealthHitBar = {['R'] = 224, ['G'] = 50, ['B'] = 50, ['A'] = 175}
                    
                    local ArmourBaseBar = {['R'] = 47, ['G'] = 92, ['B'] = 115, ['A'] = 175, ['L'] = 1}
                    local ArmourBar = {['R'] = 93, ['G'] = 182, ['B'] = 229, ['A'] = 175, ['L'] = 2}
                    
                    local AirBaseBar = {['R'] = 67, ['G'] = 106, ['B'] = 130, ['A'] = 175, ['L'] = 1}
                    local AirBar = {['R'] = 174, ['G'] = 219, ['B'] = 242, ['A'] = 175, ['L'] = 2}
                    
                    local BackgroundBarW = MM.width
                    local BackgroundBarX = MM.x + (MM.width / 2)
                    _DrawRect(BackgroundBarX, BarY, BackgroundBarW, BackgroundBarH, BackgroundBar.R, BackgroundBar.G, BackgroundBar.B, BackgroundBar.A, BackgroundBar.L)

                    local HealthBaseBarW = (MM.width / 2) - (BarSpacer / 2)
                    local HealthBaseBarX = MM.x + (HealthBaseBarW / 2)
                    local HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthBaseBar.R, HealthBaseBar.G, HealthBaseBar.B, HealthBaseBar.A
                    local HealthBarW = (MM.width / 2) - (BarSpacer / 2)
                    if Ped.Health < 200 and Ped.Health > 100 then
                        HealthBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * (Ped.Health - 100)
                    elseif Ped.Health < 100 then
                        HealthBarW = 0
                    end

                    local HealthBarX = MM.x + (HealthBarW / 2)
                    local HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthBar.R, HealthBar.G, HealthBar.B, HealthBar.A
                    if Ped.Health <= 130 or (Ped.Stamina >= 90.0 and (IsPedRunning(ped) or IsPedSprinting(ped))) then
                        HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA = HealthHitBaseBar.R, HealthHitBaseBar.G, HealthHitBaseBar.B, HealthHitBaseBar.A
                        HealthBarR, HealthBarG, HealthBarB, HealthBarA = HealthHitBar.R, HealthHitBar.G, HealthHitBar.B, HealthHitBar.A
                    end
                    
                    _DrawRect(HealthBaseBarX, BarY, HealthBaseBarW, BarH, HealthBaseBarR, HealthBaseBarG, HealthBaseBarB, HealthBaseBarA, HealthBaseBar.L)
                    _DrawRect(HealthBarX, BarY, HealthBarW, BarH, HealthBarR, HealthBarG, HealthBarB, HealthBarA, HealthBar.L)
                    if not Ped.Underwater then
                        local ArmourBaseBarW = (MM.width / 2) - (BarSpacer / 2)
                        local ArmourBaseBarX = MM.right_x - (ArmourBaseBarW / 2)
                        local ArmourBarW = ((MM.width / 2) - (BarSpacer / 2)) / 100 * Ped.Armor
                        local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

                        _DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
                        _DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
                    else
                        local ArmourBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                        local ArmourBaseBarX = MM.right_x - (((MM.width / 2) - (BarSpacer / 2)) / 2) - (ArmourBaseBarW / 2) - (BarSpacer / 2)
                        local ArmourBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 100 * Ped.Armor
                        local ArmourBarX = MM.right_x - ((MM.width / 2) - (BarSpacer / 2)) + (ArmourBarW / 2)

                        _DrawRect(ArmourBaseBarX, BarY, ArmourBaseBarW, BarH, ArmourBaseBar.R, ArmourBaseBar.G, ArmourBaseBar.B, ArmourBaseBar.A, ArmourBaseBar.L)
                        _DrawRect(ArmourBarX, BarY, ArmourBarW, BarH, ArmourBar.R, ArmourBar.G, ArmourBar.B, ArmourBar.A, ArmourBar.L)
                        
                        local AirBaseBarW = (((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)
                        local AirBaseBarX = MM.right_x - (AirBaseBarW / 2)
                        local AirBarW = ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) / 10.0 * Ped.UnderwaterTime
                        local AirBarX = MM.right_x - ((((MM.width / 2) - (BarSpacer / 2)) / 2) - (BarSpacer / 2)) + (AirBarW / 2)

                        _DrawRect(AirBaseBarX, BarY, AirBaseBarW, BarH, AirBaseBar.R, AirBaseBar.G, AirBaseBar.B, AirBaseBar.A, AirBaseBar.L)
                        _DrawRect(AirBarX, BarY, AirBarW, BarH, AirBar.R, AirBar.G, AirBar.B, AirBar.A, AirBar.L)
                    end
                end 
            end   
            Citizen.Wait(sleep) 
        else
            Citizen.Wait(1000)
        end
	end
end)

function _DrawRect(X, Y, W, H, R, G, B, A, L)
	SetUiLayer(L)
	DrawRect(X, Y, W, H, R, G, B, A)
end
