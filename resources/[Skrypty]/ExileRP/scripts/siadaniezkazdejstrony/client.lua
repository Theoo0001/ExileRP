local TimeElapsed = 0

local Pedryl = {
	Exists = false,
	Id = nil,
	InVehicle = false,
	VehicleInFront = nil,
	VehicleInFrontLock = nil
}

CreateThread(function()
	while true do
		Citizen.Wait(200)
		TimeElapsed = TimeElapsed + 200
		if not IsPauseMenuActive() then
			if not IsEntityDead(playerPed) then
				Pedryl.Exists = true
				Pedryl.Id = playerPed

				Pedryl.InVehicle = IsPedInAnyVehicle(Pedryl.Id, false)
				if not Pedryl.InVehicle then
					Pedryl.VehicleInFront = ESX.Game.GetVehicleInDirection()
					if Pedryl.VehicleInFront then
						Pedryl.VehicleInFrontLock = GetVehicleDoorLockStatus(Pedryl.VehicleInFront)
					else
						Pedryl.VehicleInFrontLock = nil
					end
				else
					Pedryl.VehicleInFront = nil
					Pedryl.VehicleInFrontLock = nil
				end
			else
				Pedryl.Exists = false
			end
		else
			Pedryl.Exists = false
		end
	end
end)

local doors = {
	--["seat_dside_f"] = -1,
	["seat_pside_f"] = 0,
	["seat_dside_r"] = 1,
	["seat_pside_r"] = 2
}
CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Pedryl.Exists then
			if Pedryl.VehicleInFront then
				DisableControlAction(0, Keys['G'], true)
				if IsDisabledControlJustPressed(0, Keys['G']) then
					local doorDistances = {}
					for bone, seat in pairs(doors) do
						local doorBone = GetEntityBoneIndexByName(Pedryl.VehicleInFront, bone)
						if doorBone ~= -1 then
							local coords = GetEntityCoords(Pedryl.Id, true)
							local doorCoords = GetWorldPositionOfEntityBone(Pedryl.VehicleInFront, doorBone)
							table.insert(doorDistances, {seat = seat, distance = #(coords - doorCoords)})
						end
					end
					local seat, distance
					if #doorDistances > 0 then
						seat = doorDistances[1].seat
						distance = doorDistances[1].distance

						table.remove(doorDistances, 1)
						for _, data in ipairs(doorDistances) do
							if data.distance < distance then
								seat, distance = data.seat, data.distance
							end
						end
					end
					if seat then
						TaskEnterVehicle(Pedryl.Id, Pedryl.VehicleInFront, -1, seat, 1.0, 1, 0)
					end
				end
			else
				Citizen.Wait(200)
			end
		else
			Citizen.Wait(500)
		end
	end
end)