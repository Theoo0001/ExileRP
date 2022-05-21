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
  
  local isDead = false
  local inAnim = false
  local timer = nil
  ESX = nil
  
  CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		  Citizen.Wait(250)
	  end
  end)
  
  Ped = {
	Active = false,
	Locked = false,
	Id = 0,
	Alive = false,
	Available = false,
	Visible = false,
	InVehicle = false,
	OnFoot = false,
	Collection = false,
	Slots = false,
}

CreateThread(function()
	while true do
		Citizen.Wait(400)

		Ped.Active = not IsPauseMenuActive()
		if Ped.Active then
			Ped.Id = PlayerPedId()
			if not IsEntityDead(Ped.Id) then
				Ped.Locked = (exports['exile_trunk']:checkInTrunk() or exports['esx_policejob']:IsCuffed() or exports["esx_ambulancejob"]:isDead())
				Ped.Alive = true
				Ped.Available = (Ped.Alive and not Ped.Locked)
				Ped.Visible = IsEntityVisible(Ped.Id)
				Ped.InVehicle = IsPedInAnyVehicle(Ped.Id, false)
				Ped.OnFoot = IsPedOnFoot(Ped.Id)

				if Ped.Available and not Ped.InVehicle and Ped.Visible then
					Ped.Collection = not IsPedFalling(Ped.Id) and not IsPedDiving(Ped.Id) and not IsPedSwimming(Ped.Id) and not IsPedSwimmingUnderWater(Ped.Id) and not IsPedInCover(Ped.Id, false) and not IsPedInParachuteFreeFall(Ped.Id) and (GetPedParachuteState(Ped.Id) == 0 or GetPedParachuteState(Ped.Id) == -1) and not IsPedBeingStunned(Ped.Id)
				else
					Ped.Collection = false
				end
				
				if Ped.Available then
					Ped.Slots = not IsPedFalling(Ped.Id) and not IsPedDiving(Ped.Id) and not IsPedSwimming(Ped.Id) and not IsPedSwimmingUnderWater(Ped.Id) and not IsPedInCover(Ped.Id, false) and not IsPedInParachuteFreeFall(Ped.Id) and (GetPedParachuteState(Ped.Id) == 0 or GetPedParachuteState(Ped.Id) == -1) and not IsPedBeingStunned(Ped.Id)
				else
					Ped.Slots = false
				end
			else
				Ped.Alive = false
				Ped.Available = false
				Ped.Visible = IsEntityVisible(Ped.Id)
				Ped.InVehicle = false
				Ped.OnFoot = true
				Ped.Collection = false
				Ped.Slots = false
			end
		end
	end
end)

function PedStatus()
	return Ped.Slots
end

  RegisterNetEvent('esx_animations:play')
  AddEventHandler('esx_animations:play', function(anim)
	if exports["esx_ambulancejob"]:isDead() then return end
	if animsblocked then
		return
	end
  		for i=1, #Config.Animations, 1 do
			for j=1, #Config.Animations[i].items, 1 do			  
				if tostring(anim) == tostring(Config.Animations[i].items[j].data.e) then
				  local cat = not IsPedCuffed(PlayerPedId()) and Config.Animations[i].items[j].type
				  local cat2 = Config.Animations[i].items[j].type
				  if cat == "anim" then
					  startAnim(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop, Config.Animations[i].items[j].data.car)
					  break
				  elseif cat2 == "faceexpression" then
					  startFaceExpression(Config.Animations[i].items[j].data.anim)
					  break
				  elseif cat == "anim2" then
					  startAnim2(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animangle" then
					  startAnimAngle(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animangle2" then
					  startAnimAngle(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animangle3" then
					  startAnimAngle(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animrozmowa" then
					  startAnimRozmowa(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animtabletka" then
					  startAnimTabletka(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animschowek" then
					  startAnimSchowek(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animochroniarz" then
					  startAnimOchroniarz(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animockniecie" then
					  startAnimOckniecie(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop" then
					  startAnimProp(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop2" then
					  startAnimProp2(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop3" then
					  startAnimProp3(Config.Animations[i].items[j].data.lib)
					  break
				  elseif cat == "animprop5" then
					  startAnimProp5(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop6" then
					  startAnimProp6(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop8" then
					  startAnimProp8(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop10" then
					  startAnimProp10(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop11" then
					  startAnimProp11(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop12" then
					  startAnimProp12(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop15" then
					  startAnimProp15(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
					elseif cat == "animprop16" then
						startAnimProp16(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
				  elseif cat == "animprop17" then
					  startAnimProp17(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop18" then
					  startAnimProp18(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop19" then
					  startAnimProp19(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop20" then
					  startAnimProp20(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop21" then
					  startAnimProp21(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop22" then
					  startAnimProp22(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop23" then
					  startAnimProp23(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "animprop24" then
					  startAnimProp24(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
					elseif cat == "animprop33" then
						startAnimProp33(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop34" then
						startAnimProp34(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop35" then
						startAnimProp35(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop36" then
						startAnimProp36(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop37" then
						startAnimProp37(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop38" then
						startAnimProp38(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
					elseif cat == "animprop39" then
						startAnimProp39(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
						break
				--elseif cat == "animprop25" then
					  --startAnimProp25(Config.Animations[i].items[j].data.lib, Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  --break
				  elseif cat == "scenario" then
					  startScenario(Config.Animations[i].items[j].data.anim, Config.Animations[i].items[j].data.loop)
					  break
				  elseif cat == "scenariosit" then
					  startScenario2(Config.Animations[i].items[j].data.anim)
					  break				
				  end
			  end
		  end
	  end
  end)
  
  AddEventHandler('esx:onPlayerDeath', function(data)
	  isDead = true
  end)
  
  RegisterNetEvent('esx_animations:playscenario')
  AddEventHandler('esx_animations:playscenario', function(anim, loop)
	  startScenario(anim, loop)
  end)
  
  RegisterNetEvent('esx_animations:playscenario2')
  AddEventHandler('esx_animations:playscenario2', function(anim)
	  startScenario2(anim)
  end)
  
  AddEventHandler('playerSpawned', function(spawn)
	  isDead = false
  end)
  
  function startWalkStyle(lib, anim)
	  ESX.Streaming.RequestAnimSet(lib, function()
		  SetPedMovementClipset(PlayerPedId(), anim, true)
	  end)
  end
  
  function startFaceExpression(anim)
		  SetFacialIdleAnimOverride(PlayerPedId(), anim)
  end
  
  function startAnim(lib, anim, loop, car)
	  if IsPedInAnyVehicle(PlayerPedId(), true) and car == 1 then
		SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
		Citizen.Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		end)
	elseif not IsPedInAnyVehicle(PlayerPedId(), true) and car <= 1 then
		if anim ~= "biker_02_stickup_loop" and anim ~= "b_atm_mugging" then
			SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
		end
		Citizen.Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		end)
	elseif IsPedInAnyVehicle(PlayerPedId(), true) and car == 2 then
		SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
		Citizen.Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		end)
	end
  end
  
  function startAnim2(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimAngle(lib, anim, loop)
	  local co = GetEntityCoords(PlayerPedId())
	  local he = GetEntityHeading(PlayerPedId())
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnimAdvanced(PlayerPedId(), lib, anim, co.x, co.y, co.z, 0, 0, he-180, 8.0, 3.0, -1, loop, 0.0, 0, 0)
	  end)
  end
  end
  
  function startAnimAngle2(lib, anim, loop)
	  local co = GetEntityCoords(PlayerPedId())
	  local he = GetEntityHeading(PlayerPedId())
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnimAdvanced(PlayerPedId(), lib, anim, co.x, co.y, co.z, 0, 0, he-90, 8.0, 3.0, -1, loop, 0.0, 0, 0)
	  end)
  end
  end
  
  function startAnimRozmowa(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, 33000, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimTabletka(lib, anim, loop)
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, 3200, loop, -1, false, false, false)
	  end)
  end
  
  function startAnimSchowek(lib, anim, loop)
	  if IsPedInAnyVehicle(PlayerPedId(), true) then
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, 5000, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimOchroniarz(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  Citizen.Wait(1500)
		  RequestAnimDict("amb@world_human_stand_guard@male@base")
		  while (not HasAnimDictLoaded("amb@world_human_stand_guard@male@base")) do Citizen.Wait(0) end
		  TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_guard@male@base", "base", 8.0, 3.0, -1, 51, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimOckniecie(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, 12000, loop, 1, false, false, false)
	  end)
  end
  end
  
  function startAnimProp(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  kierowanieruchemprop()
		  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  end)
  end
  end
  
  function startAnimProp2(lib, anim, loop)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  notesprop()
	  end)
  end
  
  function startAnimProp3(lib)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
	  TaskPlayAnim(PlayerPedId(), "random@burial", "a_burial", 8.0, -4.0, -1, 1, 0, 0, 0, 0)
		  lopataprop()
	  end)
  end
  end

  function startAnimProp5(lib, anim, loop)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  aparatprop()
	  end)
  end
  
  function startAnimProp6(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, 2000, loop, 1, false, false, false)
		  portfeldowodprop()
	  end)
  end
  end
  
  
  function startAnimProp8(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  clipboardprop()
	  end)
  end
  end

  
  function startAnimProp10(lib, anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  scierkaprop()
	  end)
  end
  end
  
  function startAnimProp11(lib, anim, loop, car)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  telefonprop()
	  end)
  end
  
  function startAnimProp12(lib, anim, loop, car)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  telefonprop2()
	  end)
  end
  
  function startAnimProp15(lib, anim, loop, car)
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  kawaprop()
	  end)
  end

  function startAnimProp16(lib, anim, loop, car)
	usuwanieanimprop()
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		teddyprop()
	end)
end
  
  
  function startAnimProp17(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  kartonprop()
	  end)
  end
  end
  
  function startAnimProp18(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop()
	  end)
  end
  end
  
  function startAnimProp19(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop2()
	  end)
  end
  end
  
  function startAnimProp20(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop3()
	  end)
  end
  end
  
  function startAnimProp21(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  walizkaprop4()
	  end)
  end
  end
  
  function startAnimProp22(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  wiertarkaprop()
	  end)
  end
  end
  
  function startAnimProp23(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  toolboxprop()
	  end)
  end
  end
  
  function startAnimProp24(lib, anim, loop, car)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
	  usuwanieanimprop()
	  SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	  Citizen.Wait(1)
	  ESX.Streaming.RequestAnimDict(lib, function()
		  TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		  bouquetprop()
	  end)
  end
  end

  function startAnimProp33(lib, anim, loop, car)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		bouquetprop()
	end)
end
end
function startAnimProp34(lib, anim, loop, car)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		guitarprop()
	end)
end
end
function startAnimProp35(lib, anim, loop, car)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		usuwanieanimprop()
		SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
		Citizen.Wait(1)
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
			bookprop()
		end)
	end
	end
function startAnimProp36(lib, anim, loop, car)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		szampanprop()
	end)
end
end
function startAnimProp37(lib, anim, loop, car)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		wineprop()
	end)
end
end

function startAnimProp38(lib, anim, loop, car)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		stickprop()
		stickprop2()
	end)
end
end

function startAnimProp39(lib, anim, loop, car)
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
	usuwanieanimprop()
	SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	Citizen.Wait(1)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		plecakdokurwyy()
	end)
end
end

  --function startAnimProp25(lib, anim, loop, car)
	--if not IsPedInAnyVehicle(PlayerPedId(), true) then
	--usuwanieanimprop()
	--SetCurrentPedWeapon(PlayerPedId(), -1569615261,true)
	--Citizen.Wait(1)
	--ESX.Streaming.RequestAnimDict(lib, function()
		--TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, 3.0, -1, loop, 1, false, false, false)
		--konkurwa()
	--end)
--end
--end

  function startScenario(anim, loop)
	  if not IsPedInAnyVehicle(PlayerPedId(), true) and loop == 1 then
		  TaskStartScenarioInPlace(PlayerPedId(), anim, 0, true)
	  elseif not IsPedInAnyVehicle(PlayerPedId(), true) and loop == 0 then
		  TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
	  end
  end
  
  function startScenario2(anim)
	  local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -0.6, -0.5)
	  local heading = GetEntityHeading(PlayerPedId())
	  if not IsPedInAnyVehicle(PlayerPedId(), true) then
		  ClearPedTasksImmediately(PlayerPedId())
		  TaskStartScenarioAtPosition(PlayerPedId(), anim, pos['x'], pos['y'], pos['z'], heading, 0, 1, 0)
	  end
  end
  
function OpenAnimationsMenu(useBinding)
	if animsblocked then return end
	local elements = {}

	if not useBinding then
		table.insert(elements, { label = "Przypisz animacje", value = "bind" })
	else
		table.insert(elements, { label = "Lista przypisanych animacji", value = "binds" })
	end

	if not useBinding then
		table.insert(elements, { label = "Interakcje - Obywatel", value = "synced" })
	end
  
	for i=1, #Config.Animations, 1 do
		table.insert(elements, {label = Config.Animations[i].label, value = Config.Animations[i].name})
	end
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_2") or 'animations', {
		title    = (useBinding and "Bindy") or 'Animacje',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			if data.current.value == "bind" then
				OpenAnimationsMenu(true)
			elseif data.current.value == "synced" then
				OpenSyncedMenu()
			elseif data.current.value == "binds" then
				OpenBindsMenu()
			else		
				OpenAnimationsSubMenu(data.current.value, useBinding)			
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

local markerplayer = nil

function OpenSyncedMenu()
	local elements2 = {}

	for k, v in pairs(Config['Synced']) do
		table.insert(elements2, {['label'] = v['Label'], ['id'] = k})
	end
            
	ESX['UI']['Menu']['Open']('default', GetCurrentResourceName(), 'play_synced',
	{
		title = 'Wspólne animacje',
		align = 'bottom-right',
		elements = elements2
	}, function(data2, menu2)
		current = data2['current']
		local allowed = false
		if Config['Synced'][current['id']]['Car'] then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				allowed = true
			else
				ESX.ShowNotification('~r~Nie jesteś w pojeździe!')
			end
		else
			allowed = true
		end
		if allowed then
			local allowed = false
			local ped = PlayerPedId()
			local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(ped, true), 2.0)
			local firstplayer = nil
			if #playersInArea >= 1 then
				local elements = {}
				for _, player in ipairs(playersInArea) do
					if player ~= PlayerId() then
						local sid = GetPlayerServerId(player)
	
						table.insert(elements, {label = sid, value = sid})
					end
				end
				for k,v in pairs(elements) do
					if k == 1 then
						firstplayer = GetPlayerFromServerId(v.value)
					end
				end
				markerplayer = firstplayer
				ESX.UI.Menu.Open("default", GetCurrentResourceName(), "exilerp_animacje_synced",
				{
					title = "Wybierz obywatela",
					align = "center",
					elements = elements
				},
				function(data, menu)
					menu.close()
					if timer < GetGameTimer() then
                        ESX.ShowNotification('~b~Wysłano propozycję animacji!')
						TriggerServerEvent('loffe_animations:requestSynced', data.current.value, current['id'])
						markerplayer = nil
						timer = GetGameTimer() + 10000
					else
						ESX.ShowNotification('~r~Poczekaj chwilę przed następną propozycją wspólnej animacji')
						markerplayer = nil
					end
				end, function(data, menu)
					menu.close()
					markerplayer = nil
				end, function(data, menu)
					markerplayer = GetPlayerFromServerId(data.current.value)
				end)
			else
				ESX.ShowNotification('~r~Nie ma nikogo w pobliżu')
			end
		end
	end, function(data2, menu2)
		menu2['close']()
	end)
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if markerplayer then
			local ped = GetPlayerPed(markerplayer)
			local coords1 = GetEntityCoords(PlayerPedId(), true)
			local coords2 = GetWorldPositionOfEntityBone(ped, GetPedBoneIndex(ped, 0x796E))
			if #(coords1 - coords2) < 40.0 then
				DrawMarker(0, coords2.x, coords2.y, coords2.z + 0.6, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.25, 64, 159, 247, 100, false, true, 2, false, false, false, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('loffe_animations:syncRequest')
AddEventHandler('loffe_animations:syncRequest', function(requester, id)
    local accepted = false

	local elements = {}

	table.insert(elements, { label = "Zaakceptuj", value = true })
	table.insert(elements, { label = "Odrzuć", value = false })

	CreateThread(function()
		local resetmenu = false
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'synced_animation_request', {
			title = 'Propozycja animacji '..Config['Synced'][id]['Label']..' od '..requester,
			align = 'center',
			elements = {
				{ label = '<span style="color: lightgreen">Zaakceptuj</span>', value = true },
				{ label = '<span style="color: lightcoral">Odrzuć</span>', value = false },
			}
		}, function(data, menu)
			menu.close()
			if data.current.value then
				resetmenu = true
				TriggerServerEvent('loffe_animations:syncAccepted', requester, id)
			else
				resetmenu = true
				TriggerServerEvent('loffe_animations:cancelSync', requester)
				ESX.ShowNotification('~r~Odrzuciłeś/aś propozycję wspólnej animacji')
			end
		end, function(data, menu)
			resetmenu = true
			menu.close()
			TriggerServerEvent('loffe_animations:cancelSync', requester)
			ESX.ShowNotification('~r~Odrzuciłeś/aś propozycję wspólnej animacji')
		end)
		Wait(5000)
		if not resetmenu then
			menu.close()
			TriggerServerEvent('loffe_animations:cancelSync', requester)
			ESX.ShowNotification('~r~Propozycja wspólnej animacji wygasła')
		end
	end)
end)

RegisterNetEvent('loffe_animations:playSynced')
AddEventHandler('loffe_animations:playSynced', function(serverid, id, type)
    local anim = Config['Synced'][id][type]

    local target = GetPlayerPed(GetPlayerFromServerId(serverid))
    if anim['Attach'] then
        local attach = anim['Attach']
        AttachEntityToEntity(PlayerPedId(), target, attach['Bone'], attach['xP'], attach['yP'], attach['zP'], attach['xR'], attach['yR'], attach['zR'], 0, 0, 0, 0, 2, 1)
    end

    Wait(750)

    if anim['Type'] == 'animation' then
        PlayAnim(anim['Dict'], anim['Anim'], anim['Flags'])
    end

    if type == 'Requester' then
        anim = Config['Synced'][id]['Accepter']
    else
        anim = Config['Synced'][id]['Requester']
    end
    while not IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end
    DetachEntity(PlayerPedId())
    while IsEntityPlayingAnim(target, anim['Dict'], anim['Anim'], 3) do
        Wait(0)
        SetEntityNoCollisionEntity(PlayerPedId(), target, true)
    end

    ClearPedTasks(PlayerPedId())
end)

PlayAnim = function(Dict, Anim, Flag)
    LoadDict(Dict)
    TaskPlayAnim(PlayerPedId(), Dict, Anim, 8.0, -8.0, -1, Flag or 0, 0, false, false, false)
end

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(0)
        RequestAnimDict(Dict)
    end
end
  
function OpenAnimationsSubMenu(menu, binding)
	local elements, title = {}, ""

	for i=1, #Config.Animations, 1 do
		if Config.Animations[i].name == menu then
			title = Config.Animations[i].label
  
			for j=1, #Config.Animations[i].items, 1 do
				if Config.Animations[i].items[j].data.e ~= nil and tostring(Config.Animations[i].items[j].data.e) ~= "" then
					table.insert(elements, {
						label = Config.Animations[i].items[j].label .. ' ("<font color="#409ff7"><b>/e '..tostring(Config.Animations[i].items[j].data.e)..'</b></font>")',
						type  = Config.Animations[i].items[j].type,
						value = Config.Animations[i].items[j].data,
						bind = Config.Animations[i].items[j].data.e
					})
				else
					table.insert(elements, {
						label = Config.Animations[i].items[j].label,
						type  = Config.Animations[i].items[j].type,
						value = Config.Animations[i].items[j].data,
					})
				end
			end

			break
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), (useBinding and "animations_sub_2") or 'animations_sub', {
		title = title,
		align = 'right',
		elements = elements
	}, function(data, menu)
		if binding then
			ESX.ShowNotification("~o~Za chwilę rozpocznie się nasłuchiwanie klawisza (BACKSPACE/ESC = Anulowanie)")
			Citizen.Wait(1500)

			ESX.ShowNotification("~y~Trwa nasłuchiwanie klawisza...")
			while true do
				if IsControlJustPressed(0, 202) then
					ESX.ShowNotification("~r~Anulowano bindowanie!")
					break
				end

				for keyName,keyId in pairs(Keys) do
					if IsControlJustPressed(0, keyId) then		
						menu.close()							
						BindKey(keyName:upper(), data.current.bind)							
						return
					end
				end

				Citizen.Wait(5)
			end
		else
			local type = data.current.type
			local lib  = data.current.value.lib
			local anim = data.current.value.anim
			local loop = data.current.value.loop
			local car = data.current.value.car
	
			if type == 'scenario' then
				startScenario(anim, loop)
			elseif type == 'scenariosit' then
				startScenario2(anim)
			elseif type == 'walkstyle' then
				startWalkStyle(lib, anim)
			elseif type == 'faceexpression' then
				startFaceExpression(anim)
			elseif type == 'anim' then
				startAnim(lib, anim, loop, car)
			elseif type == 'anim2' then
				startAnim2(lib, anim, loop)
			elseif type == 'animangle' then
				startAnimAngle(lib, anim, loop)
			elseif type == 'animangle2' then
				startAnimAngle2(lib, anim, loop)
			elseif type == 'animangle3' then
				startAnimAngle3(lib, anim, loop)
			elseif type == 'animrozmowa' then
				startAnimRozmowa(lib, anim, loop)
			elseif type == 'animtabletka' then
				startAnimTabletka(lib, anim, loop)
			elseif type == 'animschowek' then
				startAnimSchowek(lib, anim, loop)
			elseif type == 'animochroniarz' then
				startAnimOchroniarz(lib, anim, loop)
			elseif type == 'animockniecie' then
				startAnimOckniecie(lib, anim, loop)
			elseif type == 'animprop' then
				startAnimProp(lib, anim, loop)
			elseif type == 'animprop2' then
				startAnimProp2(lib, anim, loop)
			elseif type == 'animprop3' then
				startAnimProp3(lib)
			elseif type == 'animprop5' then
				startAnimProp5(lib, anim, loop)
			elseif type == 'animprop6' then
				startAnimProp6(lib, anim, loop)
			elseif type == 'animprop8' then
				startAnimProp8(lib, anim, loop)
			elseif type == 'animprop10' then
				startAnimProp10(lib, anim, loop)
			elseif type == 'animprop11' then
				startAnimProp11(lib, anim, loop, car)
			elseif type == 'animprop12' then
				startAnimProp12(lib, anim, loop, car)
			elseif type == 'animprop15' then
				startAnimProp15(lib, anim, loop, car)
			elseif type == 'animprop16' then
				startAnimProp16(lib, anim, loop, car)
			elseif type == 'animprop17' then
				startAnimProp17(lib, anim, loop, car)
			elseif type == 'animprop18' then
				startAnimProp18(lib, anim, loop, car)
			elseif type == 'animprop19' then
				startAnimProp19(lib, anim, loop, car)
			elseif type == 'animprop20' then
				startAnimProp20(lib, anim, loop, car)
			elseif type == 'animprop21' then
				startAnimProp21(lib, anim, loop, car)
			elseif type == 'animprop22' then
				startAnimProp22(lib, anim, loop, car)
			elseif type == 'animprop23' then
				startAnimProp23(lib, anim, loop, car)
			elseif type == 'animprop24' then
				startAnimProp24(lib, anim, loop, car)
			elseif type == 'animprop33' then
				startAnimProp33(lib, anim, loop, car)
			elseif type == 'animprop34' then
				startAnimProp34(lib, anim, loop, car)
			elseif type == 'animprop35' then
				startAnimProp35(lib, anim, loop, car)
			elseif type == 'animprop36' then
				startAnimProp36(lib, anim, loop, car)
			elseif type == 'animprop37' then
				startAnimProp37(lib, anim, loop, car)
			elseif type == 'animprop38' then
				startAnimProp38(lib, anim, loop, car)
			elseif type == 'animprop39' then
				startAnimProp39(lib, anim, loop, car)
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Key Controls & Loops
  
CreateThread(function()
	timer = GetGameTimer()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if IsControlJustReleased(0, 170) and not isDead then
			OpenAnimationsMenu()
		end
		if IsControlJustReleased(0, 73) and not isDead then
			ClearPedTasks(PlayerPedId())
			usuwanieanimprop()
		end
	end
end)
  
CreateThread(function()
	while true do
		Citizen.Wait(500)
		local RemoveWeaponWhenAnim = CheckAnim()
		local RemoveWeaponWhenAnim2 = CheckAnim2()
		  
	  	if RemoveWeaponWhenAnim then
		  	SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)
		elseif RemoveWeaponWhenAnim2 then
			SetCurrentPedWeapon(PlayerPedId(), -1569615261, true)
		end 
	end
end)
  
  -- BlockActions
  
  local animsDict = {
	['mini@hookers_sp'] = 'idle_reject_loop_c',
	['amb@world_human_hang_out_street@female_arms_crossed@base'] = 'base',
	['anim@amb@nightclub@peds@'] = 'rcmme_amanda1_stand_loop_cop',
	['random@gang_intimidation@'] = '001445_01_gangintimidation_1_female_wave_loop',
	['amb@medic@standing@timeofdeath@base'] = 'base',
	['amb@world_human_paparazzi@male@idle_a'] = 'idle_c',
	['amb@world_human_clipboard@male@idle_a'] = 'idle_c',
	['anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity'] = 'hi_dance_facedj_09_v1_female^1',
	['Anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity'] = 'hi_dance_facedj_09_v1_female^3',
	['aNim@amb@nightclub@dancers@crowddance_facedj@hi_intensity'] = 'hi_dance_facedj_09_v1_female^6',
	['anim@amb@nightclub@dancers@crowddance_facedj@med_intensity'] = 'mi_dance_facedj_09_v1_female^1',
	['anim@amb@nightclub@dancers@crowddance_groups@hi_intensity'] = 'hi_dance_crowd_09_v1_female^1',
	['Anim@amb@nightclub@lazlow@hi_podium@'] = 'danceidle_hi_11_turnaround_laz',
	['aNim@amb@nightclub@lazlow@hi_podium@'] = 'danceidle_hi_17_smackthat_laz',
	['anIm@amb@nightclub@lazlow@hi_podium@'] = 'danceidle_mi_13_enticing_laz',
	['special_ped@mountain_dancer@monologue_3@monologue_3a'] = 'mnt_dnc_buttwag',
	['amb@world_human_cop_idles@male@base'] = 'base',
	['amb@world_human_cop_idles@female@base'] = 'base',
	['cellphone@'] = 'cellphone_text_to_call',
	['amb@world_human_stand_mobile@male@text@base'] = 'base',
	['amb@world_human_drinking@coffee@male@idle_a'] = 'idle_c',
	['mp_player_int_uppergang_sign_a'] = 'mp_player_int_gang_sign_a',
	['mp_player_int_upperv_sign'] = 'mp_player_int_v_sign',
	['rcmepsilonism8'] = 'bag_handler_idle_a',
	['anim@heists@narcotics@trash'] = 'walk',
	['anim@heists@fleeca_bank@drilling'] = 'drill_straight_start',
	['anim@heists@box_carry@'] = 'idle'
  }
  
  local animsDict2 = {
	['amb@world_human_stand_guard@male@base'] = 'base'
  }
  
  
  function CheckAnim()
	  for k,v in pairs(animsDict)do
		  if IsEntityPlayingAnim(PlayerPedId(), k, v, 3) then
			  return true;
		  end
	  end
	  return false;
  end
  
  function CheckAnim2()
	  for k,v in pairs(animsDict2)do
		  if IsEntityPlayingAnim(PlayerPedId(), k, v, 3) then
			  return true;
		  end
	  end
	  return false;
  end
  
  function BlockAttack()
	  DisableControlAction(0, 25,   true) -- Input Aim
	  DisableControlAction(0, 24,   true) -- Input Attack
	  DisableControlAction(0, 140,  true) -- Melee Attack Alternate
	  DisableControlAction(0, 141,  true) -- Melee Attack Alternate
	  DisableControlAction(0, 142,  true) -- Melee Attack Alternate
	  DisableControlAction(0, 257,  true) -- Input Attack 2
	  DisableControlAction(0, 263,  true) -- Input Melee Attack
	  DisableControlAction(0, 264,  true) -- Input Melee Attack 2
	  DisableControlAction(0, 44,  true) -- Q
	  DisableControlAction(0, 157,  true) -- 1
	  DisableControlAction(0, 158,  true) -- 2
	  DisableControlAction(0, 160,  true) -- 3
	  DisableControlAction(0, 164,  true) -- 4
	  DisableControlAction(0, 165,  true) -- 5
	  DisableControlAction(0, 159,  true) -- 6
	  DisableControlAction(0, 161,  true) -- 7
	  DisableControlAction(0, 162,  true) -- 8
	  DisableControlAction(0, 163,  true) -- 9
	  DisableControlAction(0, 37,  true) -- TAB
	  DisableControlAction(0, 45,  true) -- R
  end
  
  
  -- Props
  
  function kierowanieruchemprop()
  parkingwand = CreateObject(GetHashKey('prop_parking_wand_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(parkingwand, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.1, 0.0, -0.03, 65.0, 100.0, 130.0, 1, 0, 0, 0, 0, 1)
  end
  
  function notesprop()
  notes = CreateObject(GetHashKey('prop_notepad_02'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(notes, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.15, 0.03, 0.0, -42.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  pen = CreateObject(GetHashKey('prop_pencil_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(pen, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xFA10), 0.04, -0.02, 0.01, 90.0, -125.0, -180.0, 1, 0, 0, 0, 0, 1)
  end
  
  function lopataprop()
  lopata = CreateObject(GetHashKey('prop_ld_shovel'), GetEntityCoords(PlayerPedId()), true, false, false)
  AttachEntityToEntity(lopata, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
  end
  
  function blachaprop()
  blacha = CreateObject(GetHashKey('prop_fib_badge'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(blacha, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.03, 0.003, -0.045, 90.0, 0.0, 75.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(1000)
  usuwanieanimprop()
  end
  
  function aparatprop()
  aparat = CreateObject(GetHashKey('prop_pap_camera_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(aparat, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xE5F2), 0.1, -0.05, 0.0, -10.0, 50.0, 5.0, 1, 0, 0, 0, 0, 1)
  end
  
  function portfeldowodprop()
  portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(portfel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(500)
  dowod = CreateObject(GetHashKey('prop_michael_sec_id'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(dowod, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.150, 0.045, -0.015, 0.0, 0.0, 180.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(1300)
  usuwanieportfelanimprop()
  end
  
  function portfelkasaprop()
  portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(portfel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(500)
  kasa = CreateObject(GetHashKey('prop_anim_cash_note'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(kasa, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.175, 0.045, -0.015, 90.0, 90.0, 180.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(1300)
  usuwanieportfelanimprop()
  end
  
  function portfelkasaprop2()
  portfel = CreateObject(GetHashKey('prop_ld_wallet_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(portfel, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(500)
  kasa2 = CreateObject(GetHashKey('prop_anim_cash_pile_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(kasa2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.175, 0.045, -0.015, 90.0, 90.0, 180.0, 1, 0, 0, 0, 0, 1)
  Citizen.Wait(1300)
  usuwanieportfelanimprop()
  end
  
  function clipboardprop()
  clipboard = CreateObject(GetHashKey('p_amb_clipboard_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(clipboard, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x8CBD), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, 1, 0, 0, 0, 0, 1)
  end
  
  function scierkaprop()
  scierka = CreateObject(GetHashKey('prop_huf_rag_01'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(scierka, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.16, 0.0, -0.040, 10.0, 0.0, -45.0, 1, 0, 0, 0, 0, 1)
  end
  
  function telefonprop()
  telefon = CreateObject(GetHashKey('prop_amb_phone'), GetEntityCoords(PlayerPedId()), true)-- creates object
  AttachEntityToEntity(telefon, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.01, -0.005, 0.0, -10.0, 8.0, 0.0, 1, 0, 0, 0, 0, 1)
  end
  
  function telefonprop2()
  telefon2 = CreateObject(GetHashKey('prop_amb_phone'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(telefon2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
  end
  
  function burgerprop()
  burger = CreateObject(GetHashKey('prop_sandwich_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(burger, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.135, 0.02, 0.05, -30.0, -120.0, -60.0, 1, 1, 0, 1, 1, 1)
  end
  
  function wodaprop()
  woda = CreateObject(GetHashKey('prop_ld_flow_bottle'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(woda, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.09, -0.065, 0.045, -100.0, 0.0, -25.0, 1, 1, 0, 1, 1, 1)
  end
  
  function kawaprop()
  kawa = CreateObject(GetHashKey('p_amb_coffeecup_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(kawa, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.015, -0.03, -80.0, 0.0, -20.0, 1, 1, 0, 1, 1, 1)
  end

  function bouquetprop()
  bouquet = CreateObject(GetHashKey('prop_snow_flower_02'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(bouquet, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24817), -0.29, 0.40, -0.02, -90.0, -90.0, 0.0, 1, 1, 0, 1, 1, 1)
  end

  function teddyprop()
  teddy = CreateObject(GetHashKey('v_ilev_mr_rasberryclean'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(teddy, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24817), -0.20, 0.46, -0.016, -180.0, -90.0, 0.0, 1, 1, 0, 1, 1, 1)
  end
  
  function torbaprop()
  torba = CreateObject(GetHashKey('hei_p_m_bag_var22_arm_s'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(torba, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xE0FD), 0.0, 0.0, 0.0, 0.0, 90.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function kartonprop()
  karton = CreateObject(GetHashKey('v_serv_abox_04'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(karton, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, -0.08, -0.17, 0, 0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop()
  walizka = CreateObject(GetHashKey('prop_ld_case_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop2()
  walizka2 = CreateObject(GetHashKey('hei_p_attache_case_shut'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.0, 0.0, 0.0, 0.0, -90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop3()
  walizka3 = CreateObject(GetHashKey('prop_ld_suitcase_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka3, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.36, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function walizkaprop4()
  walizka4 = CreateObject(GetHashKey('prop_suitcase_03'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(walizka4, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.36, -0.45, -0.05, -50.0, -60.0, 15.0, 1, 1, 0, 1, 1, 1)
  end
  
  function wiertarkaprop()
  wiertarka = CreateObject(GetHashKey('prop_tool_drill'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(wiertarka, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.1, 0.04, -0.03, -90.0, 180.0, 0.0, 1, 1, 0, 1, 1, 1)
  end
  
  function toolboxprop()
  toolbox = CreateObject(GetHashKey('prop_tool_box_04'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(toolbox, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.43, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function toolboxprop2()
  toolbox2 = CreateObject(GetHashKey('prop_tool_box_02'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(toolbox2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.53, 0.0, -0.02, -90.0, 0.0, 90.0, 1, 1, 0, 1, 1, 1)
  end
  
  function tabletprop()
  tablet = CreateObject(GetHashKey('hei_prop_dlc_tablet'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(tablet, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.05, -0.007, -0.04, 0.0, 0.0, 0.0, 1, 1, 0, 1, 1, 1)
  end

  function guitarprop()
  guitar = CreateObject(GetHashKey('prop_acc_guitar_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(guitar, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), -0.1, 0.31, 0.1, 0.0, 20.0, 150.0, 1, 1, 0, 1, 1, 1)
  end

  function bookprop()
  book = CreateObject(GetHashKey('prop_novel_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(book, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 6286), 0.15, 0.03, -0.065, 0.0, 180.0, 90.0, 1, 1, 0, 1, 1, 1)
  end

  function szampanprop()
  szampan = CreateObject(GetHashKey('prop_drink_champ'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(szampan, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.10, -0.03, 0.03, -100.0, 0.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function wineprop()
  win = CreateObject(GetHashKey('prop_drink_redwine'), 0.10, -0.03, 0.03, -100.0, 0.0, -10.0)
  AttachEntityToEntity(win, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 18905), 0.10, -0.03, 0.03, -100.0, 0.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function stickprop()
  stickpropss = CreateObject(GetHashKey('ba_prop_battle_glowstick_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(stickpropss, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0700,0.1400,0.0,-80.0,20.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function stickprop2()
  stickpropss2 = CreateObject(GetHashKey('ba_prop_battle_glowstick_01'), 1.0, 1.0, 1.0, 1, 1, 0)
  AttachEntityToEntity(stickpropss2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0700,0.1400,0.0,-80.0,20.0, -10.0, 1, 1, 0, 1, 1, 1)
  end

  function plecakdokurwyy()
  plecakdokurwy = CreateObject(GetHashKey('p_michael_backpack_s'), 0.07, -0.11, -0.05, 0.0, 90.0, 175.0)
  AttachEntityToEntity(plecakdokurwy, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24818), 0.07, -0.11, -0.05, 0.0, 90.0, 175.0, -10.0, 1, 1, 0, 1, 1, 1)
  end
			

  --function konkurwa()
  --konkurwa = CreateObject(GetHashKey('ba_prop_battle_hobby_horse'), 1.0, 1.0, 1.0, 1, 1, 0)
  --AttachEntityToEntity(konkurwa, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 1, 1)
  --end
  
  
  function usuwanieanimprop()
  DeleteEntity(parkingwand)
  DeleteEntity(notes)
  DeleteEntity(lopata)
  DeleteEntity(blacha)
  DeleteEntity(pen)
  DeleteEntity(aparat)
  DeleteEntity(dowod)
  DeleteEntity(kasa)
  DeleteEntity(kasa2)
  DeleteEntity(clipboard)
  DeleteEntity(scierka)
  DeleteEntity(telefonvvv)
  DeleteEntity(telefon2)
  DeleteEntity(portfel)
  DeleteEntity(burger)
  DeleteEntity(woda)
  DeleteEntity(kawa)
  DeleteEntity(torba)
  DeleteEntity(karton)
  DeleteEntity(walizka)
  DeleteEntity(walizka2)
  DeleteEntity(walizka3)
  DeleteEntity(walizka4)
  DeleteEntity(wiertarka)
  DeleteEntity(toolbox)
  DeleteEntity(toolbox2)
  DeleteEntity(tablet)
  DeleteEntity(teddy)
  DeleteEntity(bouquet)
  DeleteEntity(guitar)
  DeleteEntity(book)
  DeleteEntity(szampan)
  DeleteEntity(win)
  DeleteEntity(stickpropss)
  DeleteEntity(stickpropss2)
  DeleteEntity(plecakdokurwy)
  --DeleteEntity(konkurwa)
  end
  
  function usuwanieportfelanimprop()
  DeleteEntity(dowod)
  DeleteEntity(kasa)
  DeleteEntity(kasa2)
  Citizen.Wait(200)
  DeleteEntity(portfel)
  end
  
  
  ---------------------------------bongos------------------------------------------------------
  
  local holdingbong = false
  local bongmodel = "hei_heist_sh_bong_01"
  local bong_net = nil
  
  RegisterNetEvent('esx_animations:bongo')
  AddEventHandler('esx_animations:bongo', function(anim)
	  local ad1 = "anim@safehouse@bong"
	  local ad1a = "bong_stage1"
	  local player = PlayerPedId()
	  local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
	  local bongspawned = CreateObject(GetHashKey(bongmodel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
	  local netid = ObjToNet(bongspawned)
	  local plyCoords2 = GetEntityCoords(player, true)
	  local head = GetEntityHeading(player)
  
	  if (DoesEntityExist(player) and not LocalPlayer.state.dead) then 
		  loadAnimDict(ad1)
		  RequestModel(GetHashKey(bongmodel))
		  if holdingbong then
			  Wait(100)
			  ClearPedSecondaryTask(PlayerPedId())
			  DetachEntity(NetToObj(bong_net), 1, 1)
			  DeleteEntity(NetToObj(bong_net))
			  bong_net = nil
			  holdingbong = false
		  else
			  Wait(500)
			  SetNetworkIdExistsOnAllMachines(netid, true)
			  NetworkSetNetworkIdDynamic(netid, true)
			  SetNetworkIdCanMigrate(netid, false)
			  AttachEntityToEntity(bongspawned,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 18905),0.10,-0.25,0.0,95.0,190.0,180.0,1,1,0,1,0,1)
			  Wait(120)
			  bong_net = netid
			  holdingbong = true
			  Wait(1000)
			  TaskPlayAnimAdvanced(player, ad1, ad1a, plyCoords2.x, plyCoords2.y, plyCoords2.z, 0.0, 0.0, head, 8.0, 1.0, 4000, 49, 0.25, 0, 0)
			  Wait(100)
			  Wait(7250)
			  TaskPlayAnim(player, ad2, ad2a, 8.0, 1.0, -1, 49, 0, 0, 0, 0)
			  Wait(500)
			  ClearPedSecondaryTask(PlayerPedId())
			  DetachEntity(NetToObj(bong_net), 1, 1)
			  DeleteEntity(NetToObj(bong_net))
			  bong_net = nil
			  holdingbong = false
		  end
	  end
  end)
  
  function loadAnimDict(dict)
	  while (not HasAnimDictLoaded(dict)) do 
		  RequestAnimDict(dict)
		  Citizen.Wait(5)
	  end
  end
  
  function openAnimations()
	OpenAnimationsMenu()
end

local celuje = false

CreateThread( function()
	while true do
		Citizen.Wait(10)
		local ped = PlayerPedId()
		if celuje and IsControlJustPressed(0, 25) then
			ClearPedTasks(ped)
			celuje = false
		end
	end
end)

local animsblocked = false
function blockAnims(state)
	animsblocked = state
end

RegisterCommand("e",function(source, args)
	local player = PlayerPedId()
	if tostring(args[1]) == nil then
		return
	elseif animsblocked then
		return
	elseif tostring(args[1]) == 'bramkarz' then
		local ad = "rcmepsilonism8"
		if ( DoesEntityExist( player ) and not LocalPlayer.state.dead) then
			loadAnimDict( ad )
			if ( IsEntityPlayingAnim( player, ad, "base_carrier", 3 ) ) then
				TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			else
				TaskPlayAnim( player, ad, "base_carrier", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			end
		end
	elseif tostring(args[1]) == 'kabura' then
		local ad = "move_m@intimidation@cop@unarmed"
		if ( DoesEntityExist( player ) and not LocalPlayer.state.dead) then
			loadAnimDict( ad )
			if ( IsEntityPlayingAnim( player, ad, "idle", 3 ) ) then
				celuje = false
				TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			else
				TaskPlayAnim( player, ad, "idle", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
				celuje = true
			end
		end
	elseif tostring(args[1]) == 'aim' then
		local ad = "move_weapon@pistol@copa"
		if ( DoesEntityExist( player ) and not LocalPlayer.state.dead) then
			loadAnimDict( ad )
			if ( IsEntityPlayingAnim( player, ad, "idle", 3 ) ) then
				celuje = false
				TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			else
				TaskPlayAnim( player, ad, "idle", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
				DisableControlAction(0, true)
				celuje = true
			end
		end
	elseif tostring(args[1]) == 'aim2' then
		local ad = "move_weapon@pistol@cope"
		if ( DoesEntityExist( player ) and not LocalPlayer.state.dead) then
			loadAnimDict( ad )
			if ( IsEntityPlayingAnim( player, ad, "idle", 3 ) ) then
				celuje = false
				TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
			else
				TaskPlayAnim( player, ad, "idle", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
				celuje = true
			end
		end
	else
		if not LocalPlayer.state.dead then
			TriggerEvent('esx_animations:play', args[1])
		end
	end
end, false)

local liftedplayer = nil
local carried = false

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if liftedplayer then
			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				local coords = GetEntityCoords(PlayerPedId())
				ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
				if IsControlJustPressed(0, Keys['L']) then
					ClearPedTasks(PlayerPedId())
					DetachEntity(PlayerPedId(), true, false)
					TriggerServerEvent("cmg2_animations:stop", liftedplayer)
					liftedplayer = nil
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		local lPed = PlayerPedId()
		if carried then
			DisableControlAction(2, 24, true) -- Attack
			DisableControlAction(2, 257, true) -- Attack 2
			DisableControlAction(2, 25, true) -- Aim
			DisableControlAction(2, 263, true) -- Melee Attack 1
			DisableControlAction(2, Keys['R'], true) -- Reload
			DisableControlAction(2, Keys['SPACE'], true) -- Jump
			DisableControlAction(2, Keys['Q'], true) -- Cover
			DisableControlAction(2, Keys['~'], true) -- Hands up
			DisableControlAction(2, Keys['X'], true) -- Cancel Animation
			DisableControlAction(2, Keys['Y'], true) -- Turn off vehicle
			DisableControlAction(2, Keys['PAGEDOWN'], true) -- Crawling
			DisableControlAction(2, Keys['B'], true) -- Pointing
			DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(2, Keys['F1'], true) -- Disable phone
			DisableControlAction(2, Keys['F2'], true) -- Inventory
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F6'], true) -- Fraction actions
			DisableControlAction(2, Keys['V'], true) -- Disable changing view
			DisableControlAction(2, Keys['P'], true) -- Disable pause screen
			DisableControlAction(2, Keys['U'], true) -- Disable zamykanie auta
			DisableControlAction(2, 59, true) -- Disable steering in vehicle
			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			if not IsEntityPlayingAnim(lPed, "nm", "firemans_carry", 3) then
				TaskPlayAnim(lPed, "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false, false, false)
			end
		else
			Citizen.Wait(500)
	  	end
	end
end)

RegisterNetEvent('exilerp_animacje:requestlift')
AddEventHandler('exilerp_animacje:requestlift', function(sender)
	CreateThread(function()		
		local menu = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'request_lift', {
			title = '[' .. sender .. '] chce cie podnieść',
			align = 'center',
			elements = {
				{ label = '<span style="color: lightgreen">Tak</span>', value = true },
				{ label = '<span style="color: lightcoral">Nie</span>', value = false },
			}
		}, function(data, menu)
			menu.close()
			local sender_ped = GetPlayerPed(GetPlayerFromServerId(sender))
			local playerBag = Player(GetPlayerServerId(sender))
			if playerBag.state.dead or IsPedCuffed(sender_ped) or IsPedBeingStunned(sender_ped) or IsPedDiving(sender_ped) or IsPedFalling(sender_ped) or IsPedJumping(sender_ped) or IsPedRunning(sender_ped) or IsPedSwimming(sender_ped) or exports['esx_vehicleshop']:isPlayerTestingVehicle() then
				ESX.ShowNotification('~r~Osoba nie zdołała cię podnieśc')
				return
			end
			TriggerServerEvent('exilerp_animacje:answerlift', sender, data.current.value)
		end)
		Wait(5000)
		menu.close()
	end)
end)

RegisterNetEvent('exilerp_animacje:answerlift')
AddEventHandler('exilerp_animacje:answerlift', function(answer, target)
	if answer then
		ESX.ShowNotification('~g~Podnosisz osobę')
		liftedplayer = target
		TriggerServerEvent('cmg2_animations:sync', target, 'missfinale_c2mcs_1', 'nm', 'fin_c2_mcs_1_camman', 'firemans_carry', 0.15, 0.27, 0.63, target, 100000, 0.0, 49, 33, 1)
	else
		ESX.ShowNotification('~r~Osoba nie pozwoliła się podnieść')
	end
end)

RegisterCommand('podnies', function(source, args, raw)
	local closest_player, closest_distance = ESX.Game.GetClosestPlayer()
    if not exports["esx_ambulancejob"]:isDead()then
        if not exports['esx_policejob']:IsCuffed() then
            if closest_distance < 2.0 and closest_player ~= -1 then
                TriggerServerEvent('route68_animacje:OdpalAnimacje4', GetPlayerServerId(closest_player))
            else
                ClearPedTasks(PlayerPedId())
                DetachEntity(PlayerPedId(), true, false)
                ESX.ShowNotification('~r~Brak osoby w pobliżu')
            end
        else
            ClearPedTasks(PlayerPedId())
            DetachEntity(PlayerPedId(), true, false)
            ESX.ShowNotification('~r~Nie możesz być zakutym!')
        end
    else
        ClearPedTasks(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)
        ESX.ShowNotification('~r~Nie możesz być obezwładnionym!')
    end
end)


local Oczekuje4 = false
local Czas4 = 7
local wysylajacy4 = nil

RegisterNetEvent('route68_animacje:przytulSynchroC2')
AddEventHandler('route68_animacje:przytulSynchroC2', function(target)
	Oczekuje4 = true
	wysylajacy4 = target
end)

CreateThread(function()
    while true do
		Citizen.Wait(1000)
		if Oczekuje4 then
			Czas4 = Czas4 - 1
		else
			Wait(500)
		end
    end
end)

CreateThread(function()
    while true do
		Citizen.Wait(250)
		if Czas4 < 1 then
			Oczekuje4 = false
			Czas4 = 7
			wysylajacy4 = nil
			ESX.ShowNotification('~r~Anulowano propozycję animacji')
		else
			Wait(500)
		end
    end
end)

CreateThread(function()
    while true do
		Citizen.Wait(0)
		if Oczekuje4 then
			if IsControlJustPressed(0, 246) or IsDisabledControlJustPressed(0, 246) then
				Oczekuje4 = false
				Czas4 = 7
				TriggerServerEvent('route68_animacje:OdpalAnimacje5', wysylajacy4)
			end
		else
			Citizen.Wait(500)
		end
    end
end)

local carryingBackInProgress = false
local niesie = false

function getCarry()
	return carryingBackInProgress
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if niesie == true then
			local coords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
			ESX.Game.Utils.DrawText3D(coords, "NACIŚNIJ [~g~L~s~] ABY PUŚCIĆ", 0.45)
			if IsControlJustPressed(0, Keys['L']) then
				local closestPlayer, distance = ESX.Game.GetClosestPlayer()
				local target = GetPlayerServerId(closestPlayer)
				carryingBackInProgress = false
				niesie = false
				ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
				DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
				TriggerServerEvent("cmg2_animations:stop", target)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length, spin, controlFlag)
	local playerPed = PlayerPedId()
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end

	if spin == nil then 
		spin = 180.0 
	end

	ClearPedTasksImmediately(playerPed)

	local coords = GetEntityCoords(playerPed, true)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	Citizen.Wait(100)

	AttachEntityToEntity(playerPed, targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)

	if controlFlag == nil then 
		controlFlag = 0 
	end
	
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	carried = true
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = PlayerPedId()
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end

	Wait(500)

	if controlFlag == nil then 
		controlFlag = 0 
	end

	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	Citizen.Wait(length)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	carried = false
	ClearPedTasksImmediately(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent('cmg2_animations:startMenu2')
AddEventHandler('cmg2_animations:startMenu2', function()  
  local Gracz = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
	if not IsPedInAnyVehicle(Gracz, false) then
		local closestPlayer, distance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= nil and distance <= 4 then
			TriggerEvent('cmg2_animations:startMenu', GetPlayerServerId(closestPlayer))
		end
	end
end)

RegisterNetEvent('cmg2_animations:startMenu')
AddEventHandler('cmg2_animations:startMenu', function(obiekt)
	if not carryingBackInProgress then
		niesie = true
		carryingBackInProgress = true
		local player = PlayerPedId()	
		lib = 'missfinale_c2mcs_1'
		anim1 = 'fin_c2_mcs_1_camman'
		lib2 = 'nm'
		anim2 = 'firemans_carry'
		distans = 0.15
		distans2 = 0.27
		height = 0.63
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 33
		animFlagTarget = 1
		local closestPlayer = Citizen.InvokeNative(0x43A66C31C68491C0, obiekt)
		target = obiekt
		if closestPlayer ~= nil then
			TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		end
	else
		carryingBackInProgress = false
		ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
		DetachEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true, false)
		local closestPlayer = obiekt
		target = GetPlayerServerId(closestPlayer)
		TriggerServerEvent("cmg2_animations:stop",target)
	end
end)

----------- [[
-- Binding
----------- ]]
Bindings = {}
CreateThread(function()
	while not ESX do Citizen.Wait(10) end
	while true do
		for key,anim in pairs(Bindings) do
			if Keys[key] then
				if IsControlJustReleased(0, Keys[key]) then
					TriggerEvent('esx_animations:play', anim)
				end
			end
		end
		Citizen.Wait(10)
	end
end)

OpenBindsMenu = function()
	local elements = {}

	table.insert(elements, { label = "<< Usuń wszystkie >>", value = "ALL" })
	for key,anim in pairs(Bindings) do
		table.insert(elements, { label = ("%s - /e %s"):format(key, anim), value = key })
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_delter', {
		title = 'Aktualne bindy',
		align = 'bottom-right',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value ~= "ALL" then
			ESX.ShowNotification(("~g~Pomyślnie usunięto powiązanie [%s] z /e %s"):format(data.current.value, Bindings[data.current.value]))
			UnBindKey(data.current.value)

			Citizen.Wait(200)
			OpenBindsMenu()
		else
			UnbindAll()
		end
	end, function(data, menu)
		menu.close()
	end)
end

BindKey = function(key, anim)
	if not Bindings[key:upper()] then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bind_check', {
			title = 'Potwierdź przypisanie '..key..' do /e '..anim..'.',
			align = 'bottom-right',
			elements = { { label = "Tak", check = true }, { label = "Nie" } }
		}, function(data, menu)
			menu.close()

			if data.current.check then
				Bindings[key:upper()] = anim:lower()
				SendNUIMessage({ action = "updateBinding", json = json.encode(Bindings) })
				ESX.ShowNotification(("~g~Pomyślnie powiązano [%s] z /e %s"):format(key:upper(), anim:lower()))
			end
		end, function(data, menu)
			menu.close()
		end)
	else ESX.ShowNotification("~r~Ten klawisz jest już zajęty!") end
end

UnBindKey = function(key)
	Bindings[key] = nil
	SendNUIMessage({ action = "updateBinding", json = json.encode(Bindings) })
end

UnbindAll = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unbindall', {
		title = 'Usunąć wszystkie powiązania?',
		align = 'bottom-right',
		elements = { { label = "Tak", check = true }, { label = "Nie" } }
	}, function(data, menu)
		if data.current.check then
			Bindings = {}
			SendNUIMessage({ action = "updateBinding", json = json.encode(Bindings) })

			ESX.ShowNotification("~g~Usunięto wszystkie powiązania!")
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNUICallback("setBinding", function(data)
	if data.binding then
		Bindings = data.binding
	end
end)

RegisterCommand("delbind",function(source, args)
	if Bindings[args[1]:upper()] then
		ESX.ShowNotification(("~g~Usunięto przypisanie [%s] do %s"):format(args[1]:upper(), Bindings[args[1]:upper()]:lower()))
		UnBindKey(args[1]:upper())	
	elseif args[1]:lower() == "all" then
		UnbindAll()
	else
		for key,anim in pairs(Bindings) do
			if anim:lower() == args[1] then
				UnBindKey(key)

				ESX.ShowNotification(("~g~Usunięto przypisanie [%s] do %s"):format(key, anim))
				return
			end
		end

		ESX.ShowNotification(("~r~Nie znaleziono powiązania z nazwą %s!"):format(args[1]))
	end
end, false)

CreateThread(function()
	for i=1, #Config.Animations, 1 do
		for j=1, #Config.Animations[i].items, 1 do
			if Config.Animations[i].items[j].data.e ~= "" then
				TriggerEvent('chat:addSuggestion', '/e '..Config.Animations[i].items[j].data.e)
			end
		end
	end
end)