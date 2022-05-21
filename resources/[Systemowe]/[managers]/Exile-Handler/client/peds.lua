--[[local Peds_Hash_Table = { ["WEAPON_UNARMED"] = `WEAPON_UNARMED` }

local function ModuleTick()
    local handle, _pedHandle = FindFirstPed()
	local success
	repeat
        success, _pedHandle = FindNextPed(handle)
        
        if not IsPedAPlayer(_pedHandle) then
            local _pedHandle_model = GetEntityModel(_pedHandle)
            local _pedHandle_weapon = GetSelectedPedWeapon(_pedHandle)

            for hashName,hash in pairs(Peds_Hash_Table) do
                if (_pedHandle_model == hash) then
                    EXILE.RemovePed(_pedHandle, hashName, true)
                    break
                end
            end

            if IsEntityAttachedToEntity(_pedHandle, PlayerPedId()) then
                DetachEntity(_pedHandle, true, true)
            end   
        end
    until not success
    EndFindPed(handle)
end

CreateThread(function()
	while #EXILE.Config.BPeds == 0 do
		Citizen.Wait(6)
	end

	Peds_HashTable()

	while true do
		ModuleTick()
		Citizen.Wait(100)
	end
end)

function Peds_HashTable()
    for i=1, #EXILE.Config.BPeds, 1 do
        Peds_Hash_Table[EXILE.Config.BPeds[i]:upper()] = GetHashKey(EXILE.Config.BPeds[i])
        SetPedModelIsSuppressed(Peds_Hash_Table[EXILE.Config.BPeds[i]:upper()], true)
    end
end]]
local Peds_Hash_Table = { ["WEAPON_UNARMED"] = GetHashKey("WEAPON_UNARMED") }

local function ModuleTick()
    local handle, _pedHandle = FindFirstPed()
	local success
	repeat
        success, _pedHandle = FindNextPed(handle)
        
        if not IsPedAPlayer(_pedHandle) then
            local _pedHandle_model = GetEntityModel(_pedHandle)
            local _pedHandle_weapon = GetSelectedPedWeapon(_pedHandle)

            for hashName,hash in pairs(Peds_Hash_Table) do
                if (_pedHandle_model == hash) then
                    EXILE.RemovePed(_pedHandle, hashName, true)
                    break
                end
            end

            if IsEntityAttachedToEntity(_pedHandle, PlayerPedId()) then
                DetachEntity(_pedHandle, true, true)
            end   
        end
    until not success
    EndFindPed(handle)
end

CreateThread(function()
	while #Config.Values.BPeds == 0 do
		Citizen.Wait(10)
	end

	Peds_HashTable()

	while true do
		ModuleTick()
		Citizen.Wait(250)
	end
end)

function Peds_HashTable()
    for i=1, #Config.Values.BPeds, 1 do
        Peds_Hash_Table[Config.Values.BPeds[i]:upper()] = GetHashKey(Config.Values.BPeds[i])
        SetPedModelIsSuppressed(Peds_Hash_Table[Config.Values.BPeds[i]:upper()], true)
    end
end