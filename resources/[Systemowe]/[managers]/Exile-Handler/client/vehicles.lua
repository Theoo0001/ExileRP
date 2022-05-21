local ModuleVariables = {
    oldVehicle = nil,
    oldVehicleModel = nil
}


local function CheckForModelManipulation()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    local model = GetEntityModel(vehicle)

    if (IsPedSittingInAnyVehicle(PlayerPedId())) then
        if (vehicle == ModuleVariables.oldVehicle and model ~= ModuleVariables.oldVehicleModel and ModuleVariables.oldVehicleModel ~= nil and ModuleVariables.oldVehicleModel ~= 0) then
            --TriggerServerEvent('exile_logs:triggerLog', vehicle..' Probowal zmienic hash', 'anticheat')
            TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to change car hash (Exile-Handler)")
            EXILE.RemoveVehicle(PlayerPedId(), vehicle, "MANIPULATED_MODEL", true)   
            return
        end
    end

    ModuleVariables.oldVehicle = vehicle
    ModuleVariables.oldVehicleModel = model
end

CreateThread(function()
	while true do
		CheckForModelManipulation()
		Citizen.Wait(1000)
	end
end)

--[[local ModuleVariables = {
    oldVehicle = nil,
    oldVehicleModel = nil
}
local Vehicles_Hash_Table = {}

function Vehicles_HashTable()
    for i=1, #Config.Values.BVehicles, 1 do
        Vehicles_Hash_Table[Config.Values.BVehicles[i]:upper()] = GetHashKey(Config.Values.BVehicles[i]:upper())
    end
end

local function ModuleTick()
    local handle, _carHandle = FindFirstVehicle()
	local success
	repeat
        success, _carHandle = FindNextVehicle(handle)
        
        local _carHandle_model = GetEntityModel(_carHandle)
        local isPedInFoundVehicle = IsPedSittingInVehicle(PlayerPedId(), _carHandle)

        for hashName,hash in pairs(Vehicles_Hash_Table) do
            if (_carHandle_model == hash) then
                if isPedInFoundVehicle then
                    EXILE.RemoveVehicle(PlayerPedId(), _carHandle, "BLACKLISTED_VEHICLE", true, hashName) 
                else
                    EXILE.RemoveVehicle(PlayerPedId(), _carHandle, "BLACKLISTED_VEHICLE", false, hashName) 
                end
                break
            end
        end  
    until not success
    EndFindVehicle(handle)
end

local function CheckForModelManipulation()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    local model = GetEntityModel(vehicle)

    if (IsPedSittingInAnyVehicle(PlayerPedId())) then
        if (vehicle == ModuleVariables.oldVehicle and model ~= ModuleVariables.oldVehicleModel and ModuleVariables.oldVehicleModel ~= nil and ModuleVariables.oldVehicleModel ~= 0) then
           -- TriggerServerEvent('exile_logs:triggerLog', vehicle..' Probowal zmienic hash', 'anticheat')
            TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to change car hash (Exile-Handler)")
            EXILE.RemoveVehicle(PlayerPedId(), vehicle, "MANIPULATED_MODEL", true)   
            return
        end
    end

    ModuleVariables.oldVehicle = vehicle
    ModuleVariables.oldVehicleModel = model
end

CreateThread(function()
	while #Config.Values.BVehicles == 0 do
		Citizen.Wait(10)
	end

	print('[EXILE-HANDLER] - Module [VEHICLES] has been started.')

	Vehicles_HashTable()

	while true do
		ModuleTick()
		CheckForModelManipulation()
		Citizen.Wait(1000)
	end
end)]]
