local football = false

RegisterNetEvent('pilka')
AddEventHandler('pilka', function()
	LoadModel('p_ld_soc_ball_01')
  local ball = Citizen.InvokeNative(0x509D5878EB39E842, `p_ld_soc_ball_01`, GetEntityCoords(PlayerPedId()), true)
  NetworkRequestControlOfEntity(ball)
  football = true
end)

CreateThread(function()
  while true do
    local sleep = 1000
    if football == true then
      local ped = PlayerPedId()
      local pedCoords = GetEntityCoords(ped)
      local closestObject = GetClosestObjectOfType(pedCoords, 10.0, `p_ld_soc_ball_01`, false)
      local ballCoords = GetEntityCoords(closestObject)

      if DoesEntityExist(closestObject) then
        sleep = 5

        if #(pedCoords - ballCoords) <= 10.0 then
          ESX.DrawMarker(vec3(ballCoords.x,ballCoords.y,ballCoords.z-0.10)) 
          if #(pedCoords - ballCoords) <= 5.0 then
            DisplayHelpText('~INPUT_PICKUP~ aby ~g~kopnąć\n~INPUT_ENTER~ ~s~aby ~g~wybić\n~INPUT_DETONATE~ ~s~aby ~g~podnieść')
          end
        end

        if #(pedCoords - ballCoords) <= 1.2 then

          if IsControlJustPressed(0, 38) then
              NetworkRequestControlOfEntity(closestObject)
              dupa = GetEntityVelocity(PlayerPedId())
              power = 3.0 
              SetEntityVelocity(closestObject, dupa.x*power, dupa.y*power, dupa.z)
          end

          if IsControlJustPressed(0, 23) then
              NetworkRequestControlOfEntity(closestObject)
              dupa = GetEntityVelocity(PlayerPedId())
              power = math.random(3,5)
              zPower = math.random(15,25) 
              SetEntityVelocity(closestObject, dupa.x*power, dupa.y*power, 0.6*zPower)
          end

          if IsControlJustPressed(0, 47) then
              PickUpBall(closestObject)
          end

        end
      end
    end
    Citizen.Wait(sleep)
  end
end)

PickUpBall = function(ballObject)
  NetworkRequestControlOfEntity(ballObject)

  LoadAnim("anim@sports@ballgame@handball@")

  AttachEntityToEntity(ballObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 36029), 0.03, 0.05, 0.05, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

  while IsEntityAttachedToEntity(ballObject, PlayerPedId()) do
    Citizen.Wait(5)
    DisplayHelpText('~INPUT_PICKUP~ aby ~g~wybić\n~INPUT_VEH_DUCK~ ~s~aby ~g~położyć na ziemi\n~INPUT_ENTER~ ~s~aby ~g~schować piłkę')

    if not IsEntityPlayingAnim(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 3) then
      TaskPlayAnim(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 8.0, 8.0, -1, 50, 0, false, false, false)
    end

    if IsPedDeadOrDying(PlayerPedId()) then
      DetachEntity(ballObject, true, true)
      if IsEntityPlayingAnim(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 3) then
        StopAnimTask(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 1.0)
      end
    end

    if IsPedInAnyVehicle(PlayerPedId(), true) then
      DetachEntity(ballObject, true, true)
      if IsEntityPlayingAnim(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 3) then
        StopAnimTask(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 1.0)
      end
    end

    if IsPedRagdoll(PlayerPedId()) then
      DetachEntity(ballObject, true, true)
      if IsEntityPlayingAnim(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 3) then
        StopAnimTask(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 1.0)
      end
    end

    if IsControlJustPressed(0, 73) then
      DetachEntity(ballObject, true, true)
      if IsEntityPlayingAnim(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 3) then
        StopAnimTask(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 1.0)
      end
    end

    if IsControlJustPressed(0, 38) then
        DetachEntity(ballObject, true, true)
        dupa = GetEntityVelocity(PlayerPedId())
        power = math.random(3,5)
        zPower = math.random(15,25) 
        SetEntityVelocity(ballObject, dupa.x*power, dupa.y*power, 0.6*zPower)
        StopAnimTask(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 1.0)
    end

    if IsControlJustPressed(0, 23) then
      DetachEntity(ballObject, true, true)
      StopAnimTask(PlayerPedId(), 'anim@sports@ballgame@handball@', 'ball_idle', 1.0)
      TriggerServerEvent('pilka:dodaj')
  end
  end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

LoadAnim = function(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    
    Citizen.Wait(1)
  end
end

LoadModel = function(model)
  while not HasModelLoaded(model) do
    RequestModel(model)
    
    Citizen.Wait(1)
  end
end
