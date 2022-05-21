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

  
ESX                         = nil
inMenu                      = true
local showblips = true
local atbank = false
local bankMenu = true
local jebacsarielova = false
local machineLoaded = false

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

local banks = {
    {name="Bank", id=277, location = vector3(150.266, -1040.203, 29.374), active = true},
    {name="Bank", id=277, location = vector3(-1212.980, -330.841, 37.787), active = true},
    {name="Bank", id=277, location = vector3(-2962.582, 482.627, 15.703), active = true},
    {name="Bank", id=277, location = vector3(-112.202, 6469.295, 31.626), active = true},
    {name="Bank", id=277, location = vector3(4477.035, -4464.510, 3.292), active = true},
    {name="Bank", id=277, location = vector3(314.187, -278.621, 54.170), active = true},
    {name="Bank", id=277, location = vector3(1653.1105, 4851.1523, 41.056), active = true},
    {name="Bank", id=277, location = vector3(-351.534, -49.529, 49.042), active = true},
    {name="Maze Bank", id=277, location = vector3(-1308.2561, -824.2117, 16.1983), active = true},
    {name="Pacific Bank", id=277, location = vector3(252.1911, 220.2385, 105.337), principal = true, active = true},
    {name="Bank", id=277, location = vector3(1175.064, 2706.643, 38.094), active = true},
}

local atms = {
    `prop_atm_01`, 
    `prop_atm_02`,
    `prop_atm_03`,
    `prop_fleeca_atm`,
}

local CFG = {
    Volume = 0.08
}

CreateThread(function()
    while ESX == nil do
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
        
		Citizen.Wait(250)
    end
end)
  
  
  local isDoingAnimation = false
  CreateThread(function()
    while true do
      Citizen.Wait(1)
      if isDoingAnimation then
              DisableControlAction(0, 24, true) -- Attack
              DisableControlAction(0, 257, true) -- Attack 2
              DisableControlAction(0, 25, true) -- Aim
              DisableControlAction(0, 263, true) -- Melee Attack 1
              DisableControlAction(0, Keys['W'], true) -- W
              DisableControlAction(0, Keys['A'], true) -- A
              DisableControlAction(0, 31, true) -- S (fault in Keys table!)
              DisableControlAction(0, 30, true) -- D (fault in Keys table!)
  
              DisableControlAction(0, Keys['R'], true) -- Reload
              DisableControlAction(0, Keys['SPACE'], true) -- Jump
              DisableControlAction(0, Keys['Q'], true) -- Cover
              DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
              DisableControlAction(0, Keys['F'], true) -- Also 'enter'?
  
              DisableControlAction(0, Keys['F1'], true) -- Disable phone
              DisableControlAction(0, Keys['F2'], true) -- Inventory
              DisableControlAction(0, Keys['F3'], true) -- Animations
              DisableControlAction(0, Keys['F6'], true) -- Job
  
              DisableControlAction(0, Keys['V'], true) -- Disable changing view
              DisableControlAction(0, Keys['C'], true) -- Disable looking behind
              DisableControlAction(0, Keys['X'], true) -- Disable clearing animation
              DisableControlAction(2, Keys['P'], true) -- Disable pause screen
  
              DisableControlAction(0, 59, true) -- Disable steering in vehicle
              DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
              DisableControlAction(0, 72, true) -- Disable reversing in vehicle
  
              DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
  
              DisableControlAction(0, 47, true)  -- Disable weapon
              DisableControlAction(0, 264, true) -- Disable melee
              DisableControlAction(0, 257, true) -- Disable melee
              DisableControlAction(0, 140, true) -- Disable melee
              DisableControlAction(0, 141, true) -- Disable melee
              DisableControlAction(0, 142, true) -- Disable melee
              DisableControlAction(0, 143, true) -- Disable melee
              DisableControlAction(0, 75, true)  -- Disable exit vehicle
              DisableControlAction(27, 75, true) -- Disable exit vehicle
      else
        Citizen.Wait(500)
      end
    end
  end)
  
  
  --===============================================
  --==             Core Threading                ==
  --===============================================
CreateThread(function()
    while true do
        local isNearSomething = GetClosestBankOrATM()
        if isNearSomething ~= nil then
            if isNearSomething.type == "BANK" then
                DisplayHelpText("Naciśnij ~INPUT_PICKUP~ aby dostać się do konta bankowego ~b~")
            
                if IsControlJustPressed(1, 38) then
                    inMenu = true
                    SetNuiFocus(true, true)
                    SendNUIMessage({type = 'openGeneral', isATM = false})
                    TriggerServerEvent('xlem0n_bank:balance')
                end
            elseif isNearSomething.type == "ATM" then
                DisplayHelpText("Naciśnij ~INPUT_PICKUP~ aby skorzystać z bankomatu ~b~")
  
                if IsControlJustPressed(1, 38) then				
                    local heading = isNearSomething.heading
                    local newheading = 0
                    if(heading >= 180) then
                        newheading = heading + 360.0
                    else
                        newheading = heading - 360.0
                    end
                    SetEntityHeading(PlayerPedId(), newheading)

                    local ad = "mini@atmenter"
                    local anim = "enter"
          
                    ESX.Streaming.RequestAnimDict(ad, function()
                        isDoingAnimation = true
                        TaskPlayAnim(PlayerPedId(), ad, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                    end)

                    Citizen.Wait(700)					
                    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'cardinsert', 0.1)
                    Citizen.Wait(700)
                    Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
                    Citizen.Wait(1250)

                    isDoingAnimation = false
                    inMenu = true
                    SetNuiFocus(true, true)
                    SendNUIMessage({type = 'openGeneral', isATM = true})
                    TriggerServerEvent('xlem0n_bank:balance')
                end
            end

            if IsControlJustPressed(1, 322) then
                inMenu = false
                SetNuiFocus(false, false)
                SendNUIMessage({type = 'close'})
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(10)
    end
end)

RegisterNUICallback('falszywyZlodziej', function(data)
    inMenu = false
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'closeAll'})
    isDoingAnimation = false
	TriggerServerEvent("csskrouble_bank:showTransfers")
end)

RegisterNetEvent("csskrouble_bank:callbackTransfers")
AddEventHandler("csskrouble_bank:callbackTransfers", function(transfers) 
    ESX.UI.Menu.CloseAll()
    local elements = {
        head = {"Od", "Kwota", "Tytuł"},
        rows = {}
    }
    for i,v in ipairs(transfers) do
        local title = v['title']
        local from = v['from_label']
        if title == nil then
            title = "Brak tytułu"
        end    
        if from == 'Anonimowego nadawcy' then
            from = "Anonimowy nadawca"
        end    
        table.insert(elements.rows, {data=v, cols={from, tostring(v['money']).."$", title}})
    end    

    --[[ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'przelewy', {
        title    = "Lista przelewów",
        align    = 'center',
        elements = elements
    }, function(data, menu)

    end, function(data, menu)
        menu.close()
    end)]]

    ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'historia_przelewy', elements, function(data, menu)

    end, function(data, menu)
        menu.close()
    end)
end)

--===============================================
--==             Map Blips	                   ==
--===============================================
CreateThread(function()
    for k,v in ipairs(banks)do
        local blip = AddBlipForCoord(v.location)
        SetBlipSprite(blip, v.id)
        SetBlipScale(blip, 1.0)
        SetBlipAsShortRange(blip, true)
        if v.principal ~= nil and v.principal then
            SetBlipColour(blip, 77)
        elseif v.active == false then
            SetBlipColour(blip, 19)
        end
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(v.name))
        EndTextCommandSetBlipName(blip)
    end
end)

GetClosestBankOrATM = function()
    local playerlocation = GetEntityCoords(PlayerPedId())
    
    local nearObject = nil

    for i=1, #banks, 1 do
        if #(playerlocation - banks[i].location) < 3.0 and banks[i].active == true then
            nearObject = {type = 'BANK'}
            break
        end
    end
    
    if nearObject == nil then
        for x=1, #atms, 1 do
            local objHandle = GetClosestObjectOfType(playerlocation, 0.6, atms[x], false)
            if DoesEntityExist(objHandle) then
                nearObject = {type = 'ATM', heading = GetEntityHeading(objHandle)}
                break
            end
        end
    end

    return nearObject
end


  RegisterNetEvent('currentbalance1')
  AddEventHandler('currentbalance1', function(balance)
      ESX.TriggerServerCallback('xlem0n_bank:character', function(result)
          local playerName = result
  
          SendNUIMessage({
              type = "balanceHUD",
              balance = balance,
              player = playerName
          })
      end)
  end)
  RegisterNUICallback('deposit', function(data)
      TriggerServerEvent('xlem0n_bank:deposit', tonumber(data.amount))
      TriggerServerEvent('xlem0n_bank:balance')
  end)
  
  RegisterNUICallback('clicked', function(data)
      TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'press', 0.1)
  end)
  RegisterNUICallback('withdrawl', function(data)
      SendNUIMessage({type = 'input'})
  
      --[[if data.isATM then
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.2, 'press', CFG.Volume)
        Citizen.Wait(1000)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.2, 'spit-out', CFG.Volume)
        Citizen.Wait(6000)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.2, 'take-money', CFG.Volume)
        Citizen.Wait(1200)
      end]]

      TriggerServerEvent('xlem0n_bank:withdraw', tonumber(data.amountw))
      TriggerServerEvent('xlem0n_bank:balance')
  
      SendNUIMessage({type = 'input'})

      --[[if data.isATM then
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.2, 'beep', CFG.Volume)
        Citizen.Wait(1000)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.2, 'beep', CFG.Volume)
        Citizen.Wait(1000)
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.2, 'beep', CFG.Volume)
      end]]
  end)
  RegisterNUICallback('balance', function()
      TriggerServerEvent('xlem0n_bank:balance')
  end)
  
  RegisterNetEvent('balance:back')
  AddEventHandler('balance:back', function(balance)
      SendNUIMessage({type = 'balanceReturn', bal = balance})
  end)
  RegisterNUICallback('transfer', function(data)
      TriggerServerEvent('xlem0n_bank:transfer', data.to, data.amountt, data.anon, data.contestt)
      TriggerServerEvent('xlem0n_bank:balance')
  end)
  RegisterNetEvent('bank:result')
  AddEventHandler('bank:result', function(type, message)
      SendNUIMessage({type = 'result', m = message, t = type})
  end)
  RegisterNUICallback('NUIFocusOff', function(data)
      isDoingAnimation = true
      inMenu = false
      SetNuiFocus(false, false)
      SendNUIMessage({type = 'closeAll'})
  
      if data.isATM then
        local ad = "mini@atmenter" --- insert the animation dic here
        local anim = "enter" --- insert the animation name here
    
        ESX.Streaming.RequestAnimDict(ad, function()
            TaskPlayAnim(PlayerPedId(), ad, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
    
        Citizen.Wait(560)
        
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.2, 'cardinsert', CFG.Volume)
    
        Citizen.Wait(1460)
    
        local ads = "mini@atmexit" --- insert the animation dic here
        local anims = "exit" --- insert the animation name here
    
        ESX.Streaming.RequestAnimDict(ads, function()
            TaskPlayAnim(PlayerPedId(), ads, anims, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
      end

      isDoingAnimation = false
  end)
  function DisplayHelpText(str)
      SetTextComponentFormat("STRING")
      AddTextComponentString(str)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  end

function TargetInBank()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    local nokurwadrezsmiec = GetClosestBankOrATM()
    jebacsarielova = false
        if closestPlayer ~= -1 and closestDistance <= 10.0 then
            if nokurwadrezsmiec ~= nil then
                jebacsarielova = true
                if nokurwadrezsmiec.type == "BANK" then
                    ESX.ShowNotification('Jesteś za blisko Banku aby móc wykonyać tą akcję')
                end
                if nokurwadrezsmiec.type == "ATM" then
                    ESX.ShowNotification('Jesteś za blisko bankomatu aby móc wykonyać tą akcję')
                end
            end
        end
    return jebacsarielova
end