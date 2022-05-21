--[[local Objects_Hash_Table = {}

function Objects_HashTable()
	for i=1, #EXILE.Config.BObjects, 1 do
        Objects_Hash_Table[EXILE.Config.BObjects[i]:upper()] = GetHashKey(EXILE.Config.BObjects[i]:upper())
    end
end

local function ModuleTick()
    local handle, _objHandle = FindFirstObject()
	local success
	repeat
        success, _objHandle = FindNextObject(handle) 
        local _objHandle_model = GetEntityModel(_objHandle)

		for hashName,hash in pairs(Objects_Hash_Table) do
            if (_objHandle_model == hash) then
                EXILE.RemoveObject(_objHandle, "BLACKLISTED_OBJECT", true, hashName) 
                break
            end
        end 
    until not success
    EndFindObject(handle)
end

CreateThread(function()
	while #EXILE.Config.BObjects == 0 do
		Citizen.Wait(10)
	end

	--print('[EXILE-HANDLER] - Module [OBJECTS] has been started.')

	Objects_HashTable()

	while true do
		ModuleTick()
		Citizen.Wait(1000)
	end
end)]]

local Objects_Hash_Table = {}

function Objects_HashTable()
	for i=1, #Config.Values.BObjects, 1 do
        Objects_Hash_Table[Config.Values.BObjects[i]:upper()] = GetHashKey(Config.Values.BObjects[i]:upper())
    end
end

local function ModuleTick()
    local handle, _objHandle = FindFirstObject()
	local success
	repeat
        success, _objHandle = FindNextObject(handle) 
        local _objHandle_model = GetEntityModel(_objHandle)

		for hashName,hash in pairs(Objects_Hash_Table) do
            if (_objHandle_model == hash) then
                EXILE.RemoveObject(_objHandle, "BLACKLISTED_OBJECT", true, hashName) 
                break
            end
        end 
    until not success
    EndFindObject(handle)
end

CreateThread(function()
	while #Config.Values.BObjects == 0 do
		Citizen.Wait(10)
	end

	print('[EXILE-HANDLER] - Module [OBJECTS] has been started.')

	Objects_HashTable()

	while true do
		ModuleTick()
		Citizen.Wait(1000)
	end
end)

