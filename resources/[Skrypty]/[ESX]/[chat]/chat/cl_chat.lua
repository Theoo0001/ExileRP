local chatInputActive = false

local chatInputActivating = false

local chatVisibilityToggle = false

local chatHidden = true

local chatLoaded = false



RegisterNetEvent('chatMessage')

RegisterNetEvent('chat:addTemplate')

RegisterNetEvent('chat:addMessage')

RegisterNetEvent('chat:addSuggestion')

RegisterNetEvent('chat:addSuggestions')

RegisterNetEvent('chat:removeSuggestion')

RegisterNetEvent('chat:clear')

RegisterNetEvent('chat:toggleChat')

RegisterNetEvent("chat:addMessage1")

-- internal events

RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEnttesteredd')



--deprecated, use chat:addMessage

AddEventHandler('chatMessage', function(author, color, text)

  local args = { text }

  if author ~= "" then

    table.insert(args, 1, author)

  end
  if(not chatVisibilityToggle)then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = color,
        multiline = true,
        args = args
      }
    })
  end

end)



AddEventHandler('__cfx_internal:serverPrint', function(msg)
  if(not chatVisibilityToggle)then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = { 0, 0, 0 },
        multiline = true,
        args = { msg }
      }
    })
  end

end)



AddEventHandler('chat:addMessage', function(message)
  if(not chatVisibilityToggle)then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = message,
      --templateId = "print"
    })
  end

end)

AddEventHandler("chat:addMessage1", function(title, color, message, icon, color1) 
  if(not chatVisibilityToggle)then
    if color1 == nil then color1 = {255,255,255} end
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = color1,
        args = {title, message, color[1], color[2], color[3], icon, color1[1], color1[2], color1[3]},
        templateId = "default"
      }
    })
  end
end)



AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({

    type = 'ON_SUGGESTION_ADD',

    suggestion = {

      name = name,

      help = help,

      params = params or nil

    }

  })

end)

AddEventHandler('chat:toggleChat',function(state)
  chatVisibilityToggle = state

  local state = (chatVisibilityToggle == true) and "^1disabled" or "^2enabled"
  
  TriggerEvent('chat:clear')

  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
        color = {255,255,255},
        multiline = true,
        args = {""}
      }
    })
end)




AddEventHandler('chat:addSuggestions', function(suggestions)

  for _, suggestion in ipairs(suggestions) do

    SendNUIMessage({

      type = 'ON_SUGGESTION_ADD',

      suggestion = suggestion

    })

  end

end)

CreateThread(function() 
  while true do
    Wait(5000)
    local screenW, screenH = GetScreenResolution()
    SendNUIMessage({
      type="CHATSCALE",
      width=(screenW/2.5).."px"
    })
  end  
end)



AddEventHandler('chat:removeSuggestion', function(name)

  SendNUIMessage({

    type = 'ON_SUGGESTION_REMOVE',

    name = name

  })

end)



AddEventHandler('chat:addTemplate', function(id, html)

  SendNUIMessage({

    type = 'ON_TEMPLATE_ADD',

    template = {

      id = id,

      html = html

    }

  })

end)



AddEventHandler('chat:clear', function(name)

  SendNUIMessage({

    type = 'ON_CLEAR'

  })

end)



RegisterNUICallback('chatResult', function(data, cb)

  chatInputActive = false

  SetNuiFocus(false)



  if not data.canceled then

    local id = PlayerId()



    --deprecated

    local r, g, b = 0, 0x99, 255



    if data.message:sub(1, 1) == '/' then

      ExecuteCommand(data.message:sub(2))

    else

      TriggerServerEvent('_chat:messageEnttesteredd', GetPlayerName(id), { r, g, b }, data.message)

    end

  end

  TriggerServerEvent('chat:setPlayerTyping', nil)

  cb('ok')

end)



local function refreshCommands()

  if GetRegisteredCommands then

    local registeredCommands = GetRegisteredCommands()



    local suggestions = {}



    for _, command in ipairs(registeredCommands) do

        if IsAceAllowed(('command.%s'):format(command.name)) then

            table.insert(suggestions, {

                name = '/' .. command.name,

                help = ''

            })

        end

    end



    TriggerEvent('chat:addSuggestions', suggestions)

  end

end



local function refreshThemes()

  local themes = {}



  for resIdx = 0, GetNumResources() - 1 do

    local resource = GetResourceByFindIndex(resIdx)



    if GetResourceState(resource) == 'started' then

      local numThemes = GetNumResourceMetadata(resource, 'chat_theme')



      if numThemes > 0 then

        local themeName = GetResourceMetadata(resource, 'chat_theme')

        local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')



        if themeName and themeData then

          themeData.baseUrl = 'nui://' .. resource .. '/'

          themes[themeName] = themeData

        end

      end

    end

  end



  SendNUIMessage({

    type = 'ON_UPDATE_THEMES',

    themes = themes

  })

end



AddEventHandler('onClientResourceStart', function(resName)

  Wait(500)



  refreshCommands()

  refreshThemes()

end)



AddEventHandler('onClientResourceStop', function(resName)

  Wait(500)



  refreshCommands()

  refreshThemes()

end)



RegisterNUICallback('loaded', function(data, cb)

  TriggerServerEvent('chat:init');



  refreshCommands()

  refreshThemes()



  chatLoaded = true



  cb('ok')

end)


local wyslano = false



CreateThread(function()

  SetTextChatEnabled(false)

  SetNuiFocus(false)



  while true do

    Wait(0)



    if not chatInputActive then

      if wyslano == false then

        TriggerEvent('chatfocus', false)

        wyslano = true

      end

      if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        chatInputActive = true
        chatInputActivating = true
        wyslano = false

        SendNUIMessage({ type = 'ON_OPEN' })

        TriggerServerEvent('chat:setPlayerTyping', true)
        TriggerEvent('chatfocus', true)
      end
    end



    if chatInputActivating then
      if not IsControlPressed(0, 245) then
        SetNuiFocus(true)

        SendNUIMessage({ type = 'ON_CLOSE' })

        chatInputActivating = false
      end
    end



    if chatLoaded then

      local shouldBeHidden = false



      if IsScreenFadedOut() or IsPauseMenuActive() then

        shouldBeHidden = true

      end



      if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then

        chatHidden = shouldBeHidden



        SendNUIMessage({

          type = 'ON_SCREEN_STATE_CHANGE',

          shouldHide = shouldBeHidden

        })

      end
    else
        Wait(200)

    end

  end

end)


--[[ Typing dots ]]--
local playersTyping = {}

CreateThread(function()
  while true do
    local localPlayer = PlayerId()
    local localCoords = GetEntityCoords(PlayerPedId())

    local playerFound = false
    for playerId in pairs(playersTyping) do
      local player = GetPlayerFromServerId(playerId)

      if NetworkIsPlayerActive(player) and (player ~= localPlayer) then
        local playerPed = GetPlayerPed(player)
        local playerCoords = GetEntityCoords(playerPed)

        if #(localCoords - playerCoords) <= 10.0 then
          local textCoords = GetWorldPositionOfEntityBone(playerPed, GetPedBoneIndex(playerPed, 0x796E))
          DrawText3D(textCoords.x, textCoords.y, textCoords.z+0.5, '...', { 255, 255, 255 }, 0.8, {0.003, 0.02, 325})

          playerFound = true
        end
      end
    end

    if not playerFound then
      Citizen.Wait(250)
    end

    Citizen.Wait(0)
  end
end)

RegisterNetEvent('chat:setPlayerTyping')
AddEventHandler('chat:setPlayerTyping', function(playerId, isTyping)
  playersTyping[playerId] = isTyping
end)

DrawText3D = function (x, y, z, text, color, size, rect)
	size = size or 0.4
	rect = rect or {0.005, 0.03, 250}

	SetTextScale(size, size)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(color[1], color[2], color[3], 215)
	SetTextCentre(1)

  SetTextEntry("STRING")
  AddTextComponentString(text)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  DrawText(_x,_y)
end