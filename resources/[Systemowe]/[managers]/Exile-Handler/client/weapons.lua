local Weapons_Hash_Table = {}

function Weapons_HashTable()
	Weapons_Hash_Table = Config.Values.WWeapons
end

local function ModuleTick()
	local playerPed = PlayerPedId()
	local status, weapon = GetCurrentPedWeapon(playerPed, true)
	local found = false
	if status == 1 then
		for _, model in ipairs(Weapons_Hash_Table) do
			if weapon == GetHashKey(model) then
				found = true
				break
			end
		end

		if not found and GetWeapontypeModel(weapon) ~= 0 then
			EXILE.RemoveWeapon(weapon, true)
			Citizen.InvokeNative(0x4899CB088EDF59B8, playerPed, weapon)
		end
	end
end


CreateThread(function()
	while #Config.Values.WWeapons == 0 do
		Citizen.Wait(100)
	end

	Weapons_HashTable()
	while true do
		ModuleTick()
		Citizen.Wait(500)
	end
end)