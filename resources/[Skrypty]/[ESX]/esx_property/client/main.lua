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
  
  ESX                           = nil
  local OwnedProperties         = {}
  local Blips                   = {}
  local CurrentProperty         = nil
  local CurrentPropertyOwner    = nil
  local LastProperty            = nil
  local LastPart                = nil
  local HasAlreadyEnteredMarker = false
  local CurrentAction           = nil
  local CurrentActionMsg        = ''
  local CurrentActionData       = {}
  local FirstSpawn              = true
  local HasChest                = false
  local BlipsProperties 		  = {}
  local isUsing				  = false
  local isHandcuffed = false
  
  function isProperty()
      return CurrentProperty ~= nil 
  end
  
  CreateThread(function()
      while ESX == nil do
          TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
              ESX = obj 
          end)
          
          Citizen.Wait(250)
      end
  end)
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
      ESX.TriggerServerCallback('esx_property:getProperties', function(properties)
          Config.Properties = properties
          CreateBlips()
      end)
  
      ESX.TriggerServerCallback('esx_property:getOwnedProperties', function(ownedProperties)
          for i=1, #ownedProperties, 1 do
              SetPropertyOwned(ownedProperties[i], true)
          end
      end)
  end)
  
  -- only used when script is restarting mid-session
  RegisterNetEvent('esx_property:sendProperties')
  AddEventHandler('esx_property:sendProperties', function(properties)
      Config.Properties = properties
      CreateBlips()
  
      ESX.TriggerServerCallback('esx_property:getOwnedProperties', function(ownedProperties)
          for i=1, #ownedProperties, 1 do
              SetPropertyOwned(ownedProperties[i], true)
          end
      end)
  end)
  
  function DrawSub(text, time)
      ClearPrints()
      SetTextEntry_2('STRING')
      AddTextComponentString(text)
      DrawSubtitleTimed(time, 1)
  end
  
  RegisterNetEvent('esx_property:reloadProperties')
  AddEventHandler('esx_property:reloadProperties', function()
      RemoveBlips()
      Citizen.Wait(100)
      ESX.TriggerServerCallback('esx_property:getProperties', function(properties)
          Config.Properties = properties
          CreateBlips()
      end)
  
      ESX.TriggerServerCallback('esx_property:getOwnedProperties', function(ownedProperties)
          for i=1, #ownedProperties, 1 do
              SetPropertyOwned(ownedProperties[i], true)
          end
      end)
  end)
  
  RegisterNetEvent('esx_property:changestate')
  AddEventHandler('esx_property:changestate', function(name, state)
      for i = 1, #Config.Properties, 1 do
          if Config.Properties[i].name == name then
              Config.Properties[i].isAvailable = state
              if state then
                  if Blips[name] then
                      RemoveBlip(Blips[name])
                      Blips[name] = nil
                  end
              
                  local property = Config.Properties[i]
                  Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)
                  
                  SetBlipSprite (Blips[property.name], Config.BlipSpriteNotOwned)
                  SetBlipDisplay(Blips[property.name], Config.BlipDisplay)
                  SetBlipScale  (Blips[property.name], Config.BlipScale)
                  SetBlipAsShortRange(Blips[property.name], true)
                  SetBlipCategory(Blips[property.name], 10)
                  BeginTextCommandSetBlipName("STRING")
                  AddTextComponentString(_U('free_prop'))
                  EndTextCommandSetBlipName(Blips[property.name])
              end
              break
          end
      end
  end)
  
  function RemoveBlips()
      for i=1, #Config.Properties, 1 do
          local property = Config.Properties[i]
          if property.entering then
              RemoveBlip(Blips[property.name])
          end
      end
      Blips = {}
  end
  
  function CreateBlips()	
      for i = 1, #Config.Properties, 1 do
          local property = Config.Properties[i]
          if property.isAvailable and property.entering then
              Blips[property.name] = AddBlipForCoord(property.entering.x, property.entering.y, property.entering.z)
  
              SetBlipSprite (Blips[property.name], Config.BlipSpriteNotOwned)
              SetBlipDisplay(Blips[property.name], Config.BlipDisplay)
              SetBlipScale  (Blips[property.name], Config.BlipScale)
              SetBlipAsShortRange(Blips[property.name], true)
              SetBlipCategory(Blips[property.name], 10)
  
              BeginTextCommandSetBlipName("STRING")
              AddTextComponentString(_U('free_prop'))
              EndTextCommandSetBlipName(Blips[property.name])		
          end
      end
  end
  
  function GetProperties()
      return Config.Properties
  end
  
  function GetProperty(name)
      for i=1, #Config.Properties, 1 do
          if Config.Properties[i].name == name then
              return Config.Properties[i]
          end
      end
  end
  
  function GetGateway(property)
      for i=1, #Config.Properties, 1 do
          local property2 = Config.Properties[i]
  
          if property2.isGateway and property2.name == property.gateway then
              return property2
          end
      end
  end
  
  function GetGatewayProperties(property)
      local properties = {}
  
      for i=1, #Config.Properties, 1 do
          if Config.Properties[i].gateway == property.name then
              table.insert(properties, Config.Properties[i])
          end
      end
  
      return properties
  end
  
  function EnterProperty(name, owner)
      local property       = GetProperty(name)
      local playerPed      = PlayerPedId()
      CurrentProperty      = property
      CurrentPropertyOwner = owner
  
      for i=1, #Config.Properties, 1 do
          if Config.Properties[i].name ~= name then
              Config.Properties[i].disabled = true
          end
      end
  
      TriggerServerEvent('esx_property:saveLastProperty', name)
      TriggerEvent("csskrouble:save")
  
      CreateThread(function()
          DoScreenFadeOut(800)
  
          while not IsScreenFadedOut() do
              Citizen.Wait(0)
          end
  
          for i=1, #property.ipls, 1 do
              RequestIpl(property.ipls[i])
  
              while not IsIplActive(property.ipls[i]) do
                  Citizen.Wait(0)
              end
          end
  
          SetEntityCoords(playerPed, property.inside.x, property.inside.y, property.inside.z)
          DoScreenFadeIn(800)
          DrawSub(property.label, 5000)
      end)
  
  end
  
  function ExitProperty(name)
      local property  = GetProperty(name)
      local playerPed = PlayerPedId()
      local outside   = nil
      CurrentProperty = nil
  
      if property.isSingle then
          outside = property.outside
      else
          outside = GetGateway(property).outside
      end
  
      TriggerServerEvent('esx_property:deleteLastProperty')
      TriggerEvent("csskrouble:save")
  
      CreateThread(function()
          DoScreenFadeOut(800)
  
          while not IsScreenFadedOut() do
              Citizen.Wait(0)
          end
  
          SetEntityCoords(playerPed, outside.x, outside.y, outside.z)
  
          for i=1, #property.ipls, 1 do
              RemoveIpl(property.ipls[i])
          end
  
          for i=1, #Config.Properties, 1 do
              Config.Properties[i].disabled = false
          end
  
          DoScreenFadeIn(800)
      end)
  end
  
  function SetPropertyBuyable(prop, value)
      local property = GetProperty(prop.name)
      property.isOwner = prop.owned
      property.isSubowner = prop.subowned
      property.owner = prop.owner
  end
  
  function SetPropertyOwned(prop, owned)
      local property     = GetProperty(prop.name)
      local entering     = nil
      local enteringName = nil
  
      if property.isSingle then
          entering     = property.entering
          enteringName = property.name
      else
          local gateway = GetGateway(property)
          entering      = gateway.entering
          enteringName  = gateway.name
      end
      
      property.isOwner = prop.owned
      property.isSubowner = prop.subowned
      property.owner = prop.owner
      if owned then
          property.owned = true
          OwnedProperties[prop.name] = true
          if Blips[enteringName] then
              RemoveBlip(Blips[enteringName])
          end
          
          if property.garage ~= nil then
              if property.isOwner or property.isSubowner then
                  TriggerEvent('flux_garages:addNewGarage', property.garage.x,property.garage.y, property.garage.z)
              else
                  TriggerEvent('flux_garages:removeGarage', property.garage.x,property.garage.y, property.garage.z)
              end
          end
              
          Blips[enteringName] = AddBlipForCoord(entering.x, entering.y, entering.z)
          
          SetBlipSprite (Blips[enteringName], Config.BlipSpriteOwned)
          SetBlipDisplay(Blips[enteringName], Config.BlipDisplay)
          SetBlipScale  (Blips[enteringName], Config.BlipScale)
          SetBlipAsShortRange(Blips[enteringName], true)
          SetBlipCategory(Blips[enteringName], 11)
  
          BeginTextCommandSetBlipName("STRING")
          AddTextComponentString(property.label)
          EndTextCommandSetBlipName(Blips[enteringName])
      else
          local found = false
  
          for k,v in pairs(OwnedProperties) do
              local _property = GetProperty(k)
              local _gateway  = GetGateway(_property)
  
              if _gateway then
                  if _gateway.name == enteringName then
                      found = true
                      break
                  end			
              elseif _property then
                  if _property.name == enteringName then
                      found = true
                      break
                  end
              end
          end
          
          if found then
              OwnedProperties[prop.name] = nil
              
              if property.garage ~= nil then
                  TriggerEvent('flux_garages:removeGarage', property.garage.x,property.garage.y, property.garage.z)
              end
          end
      end
  
  end
  
  function PropertyIsOwned(property)
      return OwnedProperties[property.name] == true
  end
  
  function OpenPropertyMenu(property)
      local elements = {}
  
      if PropertyIsOwned(property) then
          if not property.isOpen then
              table.insert(elements, {label = _U('enter'), value = 'enter'})
          end
          if not Config.EnablePlayerManagement and property.isOwner then
              table.insert(elements, {
                  label = ('%s <span style="color:green;">$%s</span>'):format(_U('leave'), ESX.Math.GroupDigits(math.floor(property.price * 0.6))),
                  value = 'leave'
              })
              
              table.insert(elements, {label = _U('sell'), value = 'sell'})
          end
      else
          if not Config.EnablePlayerManagement then
              table.insert(elements, 
              {
                  label = ('%s <span style="color:green;">$%s</span>'):format(_U('buy'), ESX.Math.GroupDigits(property.price)),
                  value = 'buy'
              })
          end
          if not property.isOpen then
              table.insert(elements, {label = _U('visit'), value = 'visit'})
          end
      end
  
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property',
      {
          title    = property.label,
          align    = 'center',
          elements = elements
      }, function(data, menu)
          if data.current.value == 'enter' then
              menu.close()
              TriggerEvent('instance:create', 'property', {property = property.name, owner = property.owner})
          elseif data.current.value == 'leave' then
              ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'propertyleave',
              {
                  title    = "Czy na pewno chcesz sprzedać mieszkanie?",
                  align    = 'center',
                  elements = {
                      {label = "Nie", value = 'no'},
                      {label = "Tak", value = 'yes'}
                  }
              }, function(data2, menu2)
                  if data2.current.value == 'yes' then
                      menu.close()
                      menu2.close()
                      TriggerServerEvent('esx_property:removeOwnedProperty', property)
                  else
                      menu2.close()
                  end
              end, function(data2, menu2)
                  menu2.close()
              end)
          elseif data.current.value == 'sell' then
              ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell', {
                  title = "Kwota"
              }, function(data2, menu2)
  
                  local quantity = tonumber(data2.value)
                  if quantity == nil then
                      ESX.ShowNotification(_U('amount_invalid'))
                  else
                      menu2.close()
                      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                      if closestPlayer ~= -1 and closestDistance <= 3.0 then
                          TriggerServerEvent('esx_property:sellForPlayer', property.name, quantity, GetPlayerServerId(closestPlayer))
                      else
                          ESX.ShowNotification("~r~Brak osób w pobliżu")
                      end
                  end
  
              end, function(data2,menu)
                  menu2.close()
              end)
          elseif data.current.value == 'buy' then
              menu.close()
              TriggerServerEvent('esx_property:buyProperty', property.name)
          elseif data.current.value == 'rent' then
              menu.close()
              TriggerServerEvent('esx_property:rentProperty', property.name)
          elseif data.current.value == 'visit' then
              menu.close()
              TriggerEvent('instance:create', 'property', {property = property.name, owner = ESX.GetPlayerData().identifier})
          end
      end, function(data, menu)
          menu.close()
  
          CurrentAction     = 'property_menu'
          CurrentActionMsg  = _U('press_to_menu')
          CurrentActionData = {property = property}
      end)
  end
  
  function OpenGatewayMenu(property)
      if Config.EnablePlayerManagement then
          OpenGatewayOwnedPropertiesMenu(gatewayProperties)
      else
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway',
          {
              title    = property.name,
              align    = 'center',
              elements = {
                  {label = _U('owned_properties'),    value = 'owned_properties'},
                  {label = _U('available_properties'), value = 'available_properties'}
              }
          }, function(data, menu)
              if data.current.value == 'owned_properties' then
                  OpenGatewayOwnedPropertiesMenu(property)
              elseif data.current.value == 'available_properties' then
                  OpenGatewayAvailablePropertiesMenu(property)
              end
          end, function(data, menu)
              menu.close()
  
              CurrentAction     = 'gateway_menu'
              CurrentActionMsg  = _U('press_to_menu')
              CurrentActionData = {property = property}
          end)
  
      end
  end
  
  function OpenGatewayOwnedPropertiesMenu(property)
      local gatewayProperties = GetGatewayProperties(property)
      local elements          = {}
  
      for i=1, #gatewayProperties, 1 do
          if PropertyIsOwned(gatewayProperties[i]) then
              table.insert(elements, {
                  label = gatewayProperties[i].label,
                  value = gatewayProperties[i].name,
                  prop  = gatewayProperties[i]
              })
          end
      end
      
      if #elements == 0 then
          ESX.ShowNotification("~r~Nie posiadasz żadnych mieszkań w tym apartamentowcu")
      elseif #elements > 0 then
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties',
          {
              title    = property.name .. ' - ' .. _U('owned_properties'),
              align    = 'center',
              elements = elements
          }, function(data, menu)
              menu.close()
  
              local elements = {
                  {label = _U('enter'), value = 'enter'}
              }
  
              if not Config.EnablePlayerManagement and (data.current.prop).isOwner then
                  table.insert(elements, {
                      label = ('%s <span style="color:green;">$%s</span>'):format(_U('leave'), ESX.Math.GroupDigits(math.floor((data.current.prop).price * 0.6))),
                      value = 'leave'
                  })
                  
                  table.insert(elements, {label = _U('sell'), value = 'sell'})
              end
  
              ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_owned_properties_actions',
              {
                  title    = data.current.label,
                  align    = 'top-left',
                  elements = elements
              }, function(data2, menu2)
                  menu2.close()
  
                  if data2.current.value == 'enter' then
                      TriggerEvent('instance:create', 'property', {property = data.current.value, owner = (data.current.prop).owner})
                      ESX.UI.Menu.CloseAll()
                  elseif data2.current.value == 'leave' then
                      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'propertyleave',
                      {
                          title    = "Czy na pewno chcesz sprzedać mieszkanie?",
                          align    = 'center',
                          elements = {
                              {label = "Nie", value = 'no'},
                              {label = "Tak", value = 'yes'}
                          }
                      }, function(data2, menu2)
                          if data2.current.value == 'yes' then
                              menu.close()
                              menu2.close()
                              TriggerServerEvent('esx_property:removeOwnedProperty', data.current.prop)
                          else
                              menu2.close()
                          end
                      end, function(data2, menu2)
                          menu2.close()
                      end)
                  elseif data2.current.value == 'sell' then
                      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell', {
                          title = "Kwota"
                      }, function(data3, menu3)
                          local quantity = tonumber(data3.value)
                          if quantity == nil then
                              ESX.ShowNotification(_U('amount_invalid'))
                          else
                              menu3.close()
                              local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                              if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                  TriggerServerEvent('esx_property:sellForPlayer', data.current.value, quantity, GetPlayerServerId(closestPlayer))
                              else
                                  ESX.ShowNotification("~r~Brak osób w pobliżu")
                              end
                          end
  
                      end, function(data3,menu3)
                          menu3.close()
                      end)
                  end
              end, function(data2, menu2)
                  menu2.close()
              end)
  
          end, function(data, menu)
              menu.close()
          end)
      end
  end
  
  function OpenGatewayAvailablePropertiesMenu(property)
      local gatewayProperties = GetGatewayProperties(property)
      local elements          = {}
      ESX.TriggerServerCallback('esx_property:getAllOwnedProperties', function(props)
          for i=1, #gatewayProperties, 1 do
              local found = false
              for j=1, #props, 1 do
                  if gatewayProperties[i].name == props[j].name then
                      found = true
                      break
                  end
              end
              if not found then
                  table.insert(elements, {
                      label = ('%s <span style="color:green;">$%s</span>'):format(gatewayProperties[i].label, ESX.Math.GroupDigits(gatewayProperties[i].price)),
                      value = gatewayProperties[i].name,
                      price = gatewayProperties[i].price
                  })
              end
          end
          
          if #elements == 0 then
              ESX.ShowNotification("~r~Brak wolnych mieszkań w tym apartamentowcu")
          elseif #elements > 0 then
              ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties',
              {
                  title    = property.name .. ' - ' .. _U('available_properties'),
                  align    = 'center',
                  elements = elements
              }, function(data, menu)
  
                  menu.close()
                  if data.current.value ~= 'nothing' then
                      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gateway_available_properties_actions',
                      {
                          title    = property.label .. ' - ' .. _U('available_properties'),
                          align    = 'center',
                          elements = {
                              {label = _U('buy'), value = 'buy'},
                              --{label = _U('rent'), value = 'rent'},
                              {label = _U('visit'), value = 'visit'}
                          }
                      }, function(data2, menu2)
                          menu2.close()
  
                          if data2.current.value == 'buy' then
                              TriggerServerEvent('esx_property:buyProperty', data.current.value)
                          elseif data2.current.value == 'rent' then
                              TriggerServerEvent('esx_property:rentProperty', data.current.value)
                          elseif data2.current.value == 'visit' then
                              TriggerEvent('instance:create', 'property', {property = data.current.value, owner = ESX.GetPlayerData().identifier})
                          end
                      end, function(data2, menu2)
                          menu2.close()
                      end)
                  end
              end, function(data, menu)
                  menu.close()
              end)
          end
      end)
  end
  
  function OpenRoomMenu(property, owner)
      ESX.TriggerServerCallback('esx_property:checkStock', function(isUsed)
          if not isUsed then
              isUsing = true
              TriggerServerEvent('esx_property:setStockUsed', property.name, true)
              
              local entering = nil
              local elements = {}
  
              if property.isSingle then
                  entering = property.entering
              else
                  entering = GetGateway(property).entering
              end
              if not property.isOpen then
                  table.insert(elements, {label = _U('invite_player'),  value = 'invite_player'})
              end
  
              if property.isOwner or property.isSubowner then
                  table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
              end
  
              table.insert(elements, {label = _U('remove_object'),  value = 'room_inventory'})
              table.insert(elements, {label = _U('deposit_object'), value = 'player_inventory'})
  
              ESX.UI.Menu.CloseAll()
  
              ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room',
              {
                  title    = property.label,
                  align    = 'center',
                  elements = elements
              }, function(data, menu)
  
                  if data.current.value == 'invite_player' then
  
                      local playersInArea = ESX.Game.GetPlayersInArea(entering, 10.0)
                      local elements      = {}
  
                      for i=1, #playersInArea, 1 do
                          if playersInArea[i] ~= PlayerId() then
                              table.insert(elements, {label = GetPlayerName(playersInArea[i]), value = playersInArea[i]})
                          end
                      end
  
                      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_invite',
                      {
                          title    = property.label .. ' - ' .. _U('invite'),
                          align    = 'center',
                          elements = elements,
                      }, function(data2, menu2)
                          TriggerEvent('instance:invite', 'property', GetPlayerServerId(data2.current.value), {property = property.name, owner = owner})
                          ESX.ShowNotification(_U('you_invited', GetPlayerName(data2.current.value)))
                      end, function(data2, menu2)
                          menu2.close()
                      end)
  
                  elseif data.current.value == 'player_dressing' then
                  
                      ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
                          local elements2 = {}
                          for k,v in pairs(dressing) do
                              table.insert(elements2, {label = v, value = k})
                          end
                          
                          menu.close()
                          
                          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
                              title    = 'Garderoba',
                              align    = 'left',
                              elements = elements2
                          }, function(data2, menu2)	
                              menu2.close()
                              ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing_opts', {
                                  title = 'Wybierz ubranie - ' .. data2.current.label,
                                  align = 'center',
                                  elements = {
                                      {label = 'Ubierz', value = 'wear'},
                                      {label = 'Zmień nazwę', value = 'rename'},
                                      {label = 'Usuń ubranie', value = 'remove'}
                                  }
                              }, function(data3, menu3)
                                  menu3.close()
                                  if data3.current.value == 'wear' then
                                      TriggerEvent('skinchanger:getSkin', function(skin)
                                          ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
                                              TriggerEvent('skinchanger:loadClothes', skin, clothes)
                                              TriggerEvent('esx_skin:setLastSkin', skin)
  
                                              TriggerEvent('skinchanger:getSkin', function(skin)
                                                  TriggerServerEvent('esx_skin:save', skin)
                                              end)
                                          end, data2.current.value)
                                      end)
                                      
                                      menu2.open()
                                  elseif data3.current.value == 'rename' then
                                      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_dressing_rename', {
                                          title = 'Zmień nazwę - ' .. data2.current.label
                                      }, function(data4, menu4)
                                          menu4.close()
                                          menu.open()
                                          TriggerServerEvent('esx_property:renameOutfit', data2.current.value, data4.value)
                                          ESX.ShowNotification('Zmieniono nazwę ubrania!')
                                      end, function(data4, menu4)
                                          menu4.close()
                                          menu3.open()
                                      end)
                                  elseif data3.current.value == 'remove' then
                                      TriggerServerEvent('esx_property:removeOutfit', data2.current.value)
                                      ESX.ShowNotification('Ubranie usunięte z Twojej garderoby: ' .. data2.current.label)
                                      menu.open()
                                  end
                              end, function(data3, menu3)
                                  menu3.close()
                                  menu2.open()
                              end)		
                          end, function(data2, menu2)
                              menu2.close()
                              menu.open()
                          end)
                      end)
  
                  elseif data.current.value == 'room_inventory' then
                      OpenRoomInventoryMenu(property, owner)
                  elseif data.current.value == 'player_inventory' then
                      OpenPlayerInventoryMenu(property, owner)
                  end
  
              end, function(data, menu)
                  menu.close()
  
                  CurrentAction     = 'room_menu'
                  CurrentActionMsg  = _U('press_to_menu')
                  CurrentActionData = {property = property, owner = owner}
                  
                  isUsing = false
                  TriggerServerEvent('esx_property:setStockUsed', property.name, false)
              end)
          else
              ESX.ShowNotification("~r~Ktoś właśnie używa tej szafki!")
          end
      end, property.name)
  end
  
  function OpenRoomInventoryMenu(property, owner)
  
      ESX.UI.Menu.CloseAll()
      
      if not exports['esx_policejob']:IsCuffed() then
          ESX.TriggerServerCallback('esx_property:getPropertyInventory', function(inventory)
  
            local elements = {}

            if inventory.blackMoney > 0 then
                table.insert(elements, {
                    label = 'Brudne pieniądze: <span style="color: red;"> ' .. ESX.Math.GroupDigits(inventory.blackMoney) .. '$</span>',
                    type = 'item_account',
                    value = 'black_money'
                })
            end
    
            local weapons = {}
            for i=1, #inventory.items, 1 do
                local item = inventory.items[i]
    
                if item.count > 0 then
                    print(item.type)
                    if type(item.label) == 'table' and item.label.label then
                        item.label = item.label.label
                        item.type = 'item_weapon'
                    end
    
                    if item.type == 'item_weapon' then
                        if not weapons[item.label] then
                            weapons[item.label] = {
                                label = item.label,
                                list = {}
                            }
                        end
    
                        table.insert(weapons[item.label].list, item.name)
                    else
                        table.insert(elements, {
                            label = (item.count > 1 and 'x' .. item.count .. ' ' or '') .. item.label,
                            type = 'item_standard',
                            value = item.name
                        })
                    end
                end
            end
    
            for weaponLabel, weaponData in pairs(weapons) do
                if #weaponData.list > 0 then
                    if #weaponData.list > 1 then
                        if not IsSubMenuInElements(elements, weaponLabel) then
                            table.insert(elements, {
                                label = ('>> %s x%i <<'):format(weaponLabel, #weaponData.list),
                                type = 'sub',
    
                                value = weaponData
                            })
                        end
                    else
                        table.insert(elements, {
                            label = weaponLabel,
                            type = 'item_standard',
                            value = weaponData.list[1]
                        })
                    end
                end
            end
  
              ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'room_inventory',
              {
                  title    = property.label .. ' - ' .. _U('inventory'),
                  align    = 'center',
                  elements = elements
              }, function(data, menu)
                  if data.current.type == 'item_sim' then
                      TriggerServerEvent('gcphone:getSimFromStock', data.current.number, 'property'..property.name)
                      ESX.SetTimeout(300, function()
                          OpenRoomInventoryMenu(property, owner)
                      end)
                  elseif data.current.type == 'item_weapon' then
  
                      menu.close()
  
                      TriggerServerEvent('esx_property:getItem', owner, data.current.type, data.current.value, data.current.ammo, property)
                      ESX.SetTimeout(300, function()
                          OpenRoomInventoryMenu(property, owner)
                      end)
  
                  else
  
                      ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'get_item_count', {
                          title = _U('amount')
                      }, function(data2, menu)
  
                          local quantity = tonumber(data2.value)
                          if quantity == nil then
                              ESX.ShowNotification(_U('amount_invalid'))
                          else
                              menu.close()
  
                              TriggerServerEvent('esx_property:getItem', owner, data.current.type, data.current.value, quantity, property)
                              ESX.SetTimeout(300, function()
                                  OpenRoomInventoryMenu(property, owner)
                              end)
                          end
  
                      end, function(data2,menu)
                          menu.close()
                      end)
  
                  end
  
              end, function(data, menu)
                  menu.close()
                  
                  OpenRoomMenu(property, owner)
              end)
  
          end, owner, property)
      end
  end
  
  function IsSubMenuInElements(elements, name)
      for i=1, #elements do
          if elements[i].type == 'sub' and elements[i].value == name then
              return true
          end
      end
  
      return false
  end
  
  
  function OpenPlayerInventoryMenu(property, owner)
      
      ESX.UI.Menu.CloseAll()
  
      ESX.TriggerServerCallback('esx_property:getPlayerInventory', function(inventory)
          local elements = {}
  
          if inventory.blackMoney > 0 then
              table.insert(elements, {
                  label = _U('dirty_money', ESX.Math.GroupDigits(inventory.blackMoney)),
                  type  = 'item_account',
                  value = 'black_money'
              })
          end
  
          for i=1, #inventory.items, 1 do
              local item = inventory.items[i]
  
              if item.count > 0 then
                  if item.label ~= nil then
                      table.insert(elements, {
                          label = item.label .. ' x' .. item.count,
                          type  = 'item_standard',
                          value = item.name
                      })
                  end
              end
          end
  
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory', {
              title    = property.label .. ' - ' .. _U('inventory'),
              align    = 'center',
              elements = elements
          }, function(data, menu)
              ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'put_item_count', {
                  title = _U('amount')
              }, function(data2, menu2)
                  local quantity = tonumber(data2.value)
                  if quantity == nil then
                      ESX.ShowNotification(_U('amount_invalid'))
                  else
                      menu2.close()
                      TriggerServerEvent('esx_property:putItem', owner, data.current.type, data.current.value, tonumber(data2.value), property)
                      ESX.SetTimeout(300, function()
                          OpenPlayerInventoryMenu(property, owner)
                      end)
                  end
              end, function(data2, menu2)
                  menu2.close()
              end)
          end, function(data, menu)
              menu.close()
              
              OpenRoomMenu(property, owner)
          end)
      end)
  end
  
  AddEventHandler('instance:loaded', function()
      TriggerEvent('instance:registerType', 'property', function(instance)
          EnterProperty(instance.data.property, instance.data.owner)
      end, function(instance)
          ExitProperty(instance.data.property)
      end)
  end)
  
  AddEventHandler('esx:onPlayerSpawn', function()
      if FirstSpawn then
          FirstSpawn = false
          CreateThread(function()
              while not ESX.IsPlayerLoaded() or #Config.Properties == 0 do
                  Citizen.Wait(0)
              end
              
              local status = 0
              while true do
                  if status == 0 then
                      status = 1
                      TriggerEvent('misiaczek:load', function(result)
                          if result == 3 then
                              status = 2
                          else
                              status = 0
                          end
                      end)
                  end
                  
                  Citizen.Wait(200)
                  if status == 2 then
                      break
                  end
              end
  
              ESX.TriggerServerCallback('esx_property:getLastProperty', function(propertyName)
                  if propertyName then
                      if propertyName ~= '' then
                          local property = GetProperty(propertyName)
  
                          for i=1, #property.ipls, 1 do
                              RequestIpl(property.ipls[i])
                  
                              while not IsIplActive(property.ipls[i]) do
                                  Citizen.Wait(0)
                              end
                          end
  
                          TriggerEvent('instance:create', 'property', {property = propertyName, owner = property.owner})
                      end
                  end
              end)
          end)
      end
  end)
  
  AddEventHandler('esx_property:getProperties', function(cb)
      cb(GetProperties())
  end)
  
  AddEventHandler('esx_property:getProperty', function(name, cb)
      cb(GetProperty(name))
  end)
  
  AddEventHandler('esx_property:getGateway', function(property, cb)
      cb(GetGateway(property))
  end)
  
  RegisterNetEvent('esx_property:setPropertyBuyable')
  AddEventHandler('esx_property:setPropertyBuyable', function(name, value)
      SetPropertyBuyable(name, value)
  end)
  
  RegisterNetEvent('esx_property:setPropertyOwned')
  AddEventHandler('esx_property:setPropertyOwned', function(name, owned)
      SetPropertyOwned(name, owned)
  end)
  
  RegisterNetEvent('instance:onCreate')
  AddEventHandler('instance:onCreate', function(instance)
      if instance.type == 'property' then
          TriggerEvent('instance:enter', instance)
      end
  end)
  
  RegisterNetEvent('instance:onEnter')
  AddEventHandler('instance:onEnter', function(instance)
      if instance.type == 'property' then
          local property = GetProperty(instance.data.property)
          local isHost   = GetPlayerFromServerId(instance.host) == PlayerId()
          local isOwned  = false
  
          if PropertyIsOwned(property) == true then
              isOwned = true
          end
  
          if isOwned or not isHost then
              HasChest = true
          else
              HasChest = false
          end
      end
  end)
  
  RegisterNetEvent('instance:onPlayerLeft')
  AddEventHandler('instance:onPlayerLeft', function(instance, player)
      if player == instance.host then
          TriggerEvent('instance:leave')
      end
  end)
  
  AddEventHandler('esx_property:hasEnteredMarker', function(name, part)
      local property = GetProperty(name)
  
      if part == 'entering' then
          if property.isSingle then
              CurrentAction     = 'property_menu'
              CurrentActionMsg  = _U('press_to_menu')
              CurrentActionData = {property = property}
          else
              CurrentAction     = 'gateway_menu'
              CurrentActionMsg  = _U('press_to_menu')
              CurrentActionData = {property = property}
          end
      elseif part == 'entering_open' then
          CurrentAction = 'property_open_menu'
          CurrentActionMsg = _U('press_to_menu')
          CurrentActionData = {property = property}
      elseif part == 'exit' then
          CurrentAction     = 'room_exit'
          CurrentActionMsg  = _U('press_to_exit')
          CurrentActionData = {propertyName = name}
      elseif part == 'roomMenu' then
          CurrentAction     = 'room_menu'
          CurrentActionMsg  = _U('press_to_menu')
          CurrentActionData = {property = property, owner = property.owner}
      end
  end)
  
  AddEventHandler('esx_property:hasExitedMarker', function(name, part)
      if isUsing then
          isUsing = false
          TriggerServerEvent('esx_property:setStockUsed', name, false)
      end
      ESX.UI.Menu.CloseAll()
      CurrentAction = nil
  end)
  
  -- Enter / Exit marker events & Draw markers
  CreateThread(function()
      while true do
          Citizen.Wait(0)
  
          local coords = GetEntityCoords(PlayerPedId())
          local isInMarker, letSleep = false, true
          local currentProperty, currentPart
  
          for i=1, #Config.Properties, 1 do
              local property = Config.Properties[i]
  
              -- Entering
              if property.entering and not property.disabled then
                  if property.isAvailable or (property.isOwner or property.isSubowner) then 
                      local distance = #(coords - vec3(property.entering.x, property.entering.y, property.entering.z))
                      
                      if distance < Config.DrawDistance then
                          letSleep = false
                          ESX.DrawMarker(vec3(property.entering.x, property.entering.y, property.entering.z))
                      end
  
                      if distance < Config.MarkerSize.x then
                          isInMarker      = true
                          currentProperty = property.name
                          currentPart     = 'entering'
                      end
                  end
              end
              
              if property.entering and property.isOpen then
                  if property.isAvailable or (property.isOwner or property.isSubowner) then
                      local distance = #(coords - vec3(property.entering.x, property.entering.y, property.entering.z))
                      if distance < Config.DrawDistance then
                          letSleep = false
                          ESX.DrawMarker(vec3(property.entering.x, property.entering.y, property.entering.z))
                      end
  
                      if distance < Config.MarkerSize.x then
                          isInMarker      = true
                          currentProperty = property.name
                          currentPart     = 'entering_open'
                      end
                  end
              end
  
              -- Exit
              if property.exit and not property.disabled then
                  local distance = #(coords - vec3(property.exit.x, property.exit.y, property.exit.z))
  
                  if distance < Config.DrawDistance then
                      letSleep = false
                      ESX.DrawMarker(vec3(property.exit.x, property.exit.y, property.exit.z))
                  end
  
                  if distance < Config.MarkerSize.x then
                      isInMarker      = true
                      currentProperty = property.name
                      currentPart     = 'exit'
                  end
              end
  
              -- Room menu
              if property.roomMenu and PropertyIsOwned(property) and not property.disabled then
                  local distance = #(coords - vec3(property.roomMenu.x, property.roomMenu.y, property.roomMenu.z))
  
                  if distance < Config.DrawDistance then
                      letSleep = false
                      ESX.DrawMarker(vec3(property.roomMenu.x, property.roomMenu.y, property.roomMenu.z))
                  end
  
                  if distance < Config.MarkerSize.x then
                      isInMarker      = true
                      currentProperty = property.name
                      currentPart     = 'roomMenu'
                  end
              end
              
              if property.roomMenu and (property.isOwner or property.isSubowner) and property.isOpen then
                  local distance = #(coords - vec3(property.roomMenu.x, property.roomMenu.y, property.roomMenu.z))
  
                  if distance < Config.DrawDistance then
                      letSleep = false
                      ESX.DrawMarker(vec3(property.roomMenu.x, property.roomMenu.y, property.roomMenu.z))
                  end
  
                  if distance < Config.MarkerSize.x then
                      isInMarker      = true
                      currentProperty = property.name
                      currentPart     = 'roomMenu'
                  end
              end
          end
  
          if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastProperty ~= currentProperty or LastPart ~= currentPart) ) then
              HasAlreadyEnteredMarker = true
              LastProperty            = currentProperty
              LastPart                = currentPart
  
              TriggerEvent('esx_property:hasEnteredMarker', currentProperty, currentPart)
          end
  
          if not isInMarker and HasAlreadyEnteredMarker then
              HasAlreadyEnteredMarker = false
              TriggerEvent('esx_property:hasExitedMarker', LastProperty, LastPart)
          end
  
          if letSleep then
              Citizen.Wait(800)
          end
      end
  end)
  
  -- Key controls
  CreateThread(function()
      while true do
          Citizen.Wait(0)
  
          if CurrentAction then
              ESX.ShowHelpNotification(CurrentActionMsg)
  
              if IsControlJustReleased(0, Keys['E']) then
  
                  if CurrentAction == 'property_menu' then
                      OpenPropertyMenu(CurrentActionData.property)
                  elseif CurrentAction == 'gateway_menu' then
                      if Config.EnablePlayerManagement then
                          OpenGatewayOwnedPropertiesMenu(CurrentActionData.property)
                      else
                          OpenGatewayMenu(CurrentActionData.property)
                      end
                  elseif CurrentAction == 'property_open_menu' then
                      OpenPropertyMenu(CurrentActionData.property)
                  elseif CurrentAction == 'room_menu' then
                      if (CurrentActionData.property).isOwner or (CurrentActionData.property).isSubowner then
                          OpenRoomMenu(CurrentActionData.property, CurrentActionData.owner)
                      else
                          ESX.ShowNotification("~r~Nie możesz korzystać z tej szafki")
                      end
                  elseif CurrentAction == 'room_exit' then
                      TriggerEvent('instance:leave')
                  end
  
                  CurrentAction = nil
  
              end
          else
              Citizen.Wait(500)
          end
      end
  end)
  
  ----
  
  CreateThread(function()
      while true do
          UpdatePedCoords()
          Citizen.Wait(1000)
      end
  end)
  
  local playerPedCoords = vector3(0.0, 0.0, 0.0)
  
  UpdatePedCoords = function()
      playerPedCoords = GetEntityCoords(PlayerPedId())
  end
  
  CreateThread(function()
      while true do
          local subowner = GetVDistToSubowner()
          if (subowner < 10.0) then
              if subowner < 1.5 then
                  if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                      ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby zarządzać swoimi mieszkaniami')
                      if IsControlJustPressed(0, 38) then
                          OpenSubownerMenu()
                          Citizen.Wait(500)
                      end
                  end
              end
  
              ESX.DrawMarker(vec3(Subowner.Location.coords.x, Subowner.Location.coords.y, Subowner.Location.coords.z-0.95))
          else
              Citizen.Wait(1000)
          end
          Citizen.Wait(3)
      end
  end)
  
  GetVDistToSubowner = function()
      return #(playerPedCoords - vec3(Subowner.Location.coords.x, Subowner.Location.coords.y, Subowner.Location.coords.z))
  end
  
  function OpenSubownerMenu()
      ESX.TriggerServerCallback('flux_properties:getOwnedProperties', function(properties)
          if properties ~= nil and (json.encode(properties) ~= '{}') then
              local elements = {}
              for i=1, #properties, 1 do
                  local property = GetProperty(properties[i].name)
                  while not property do
                      Citizen.Wait(20)
                  end
                  table.insert(elements, {label = property.label, name = property.name})
              end
              ESX.UI.Menu.Open(
                  'default', GetCurrentResourceName(), 'subowner_menu',
                  {
                      title = "Zarządzanie mieszkaniami",
                      align = 'center',
                      elements = elements
                  },
                  function(data, menu)
                      ESX.UI.Menu.Open(
                          'default', GetCurrentResourceName(), 'subowner_menu2',
                          {
                              title = data.current.label .. " - Zarządzanie",
                              align = 'center',
                              elements = {
                                  {label = "Nadaj współwłaściciela (30 000$)", value = 'give_sub'},
                                  {label = "Zmień zamki", value = 'manage_sub'},
                              }
                          },
                          function(data2, menu2)
                              if data2.current.value == 'give_sub' then
                                  menu2.close()
                                  menu.close()
                                  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                  if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                      TriggerServerEvent('esx_property:setSubowner', data.current.name, GetPlayerServerId(closestPlayer))
                                  else
                                      ESX.ShowNotification("~r~Brak osób w pobliżu")
                                  end
                              elseif data2.current.value == 'manage_sub' then
                                  ESX.UI.Menu.Open(
                                      'default', GetCurrentResourceName(), 'yesorno',
                                      {
                                          title = "Czy na pewno chcesz zmienić zamki w drzwiach?",
                                          align = 'center',
                                          elements = {
                                              {label = "Nie", value = 'no'},
                                              {label = "Tak", value = 'yes'}
                                          }
                                      },
                                      function(data3, menu3)
                                          if data3.current.value == 'yes' then
                                              TriggerServerEvent('flux_properties:deleteSubowners', data.current.name)
                                              menu3.close()
                                              menu2.close()
                                              menu.close()
                                          elseif data3.current.value == 'no' then
                                              menu3.close()
                                          end
                                      end,
                                      function(data3, menu3)
                                          menu3.close()
                                      end
                                  )	
                              end
                          end,
                          function(data2,menu2)
                              menu2.close()
                          end
                      )
                  end,
                  function(data,menu)
                      menu.close()
                  end
              )
          else
              ESX.ShowNotification("~r~Nie posiadasz żadnych mieszkań na własność!")
          end
      end)
  end
  
  --
  RegisterNetEvent('esx_property:acceptBuy')
  AddEventHandler('esx_property:acceptBuy', function(owner, name, price)
      local pOwner, pName, pPrice = owner, name, price
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'yes_or_no',
      {
          title    = 'Czy chcesz zakupić ' .. pName .. ' za ' .. pPrice .. '$?',
          align    = 'center',
          elements = {
              {label = "Nie",	value = 'no'},
              {label = "Tak",	value = 'yes'},
          }
      }, 	function(data, menu)
              if data.current.value == 'yes' then
                  menu.close()
                  TriggerServerEvent('esx_property:changeOwner', pOwner, pName, pPrice)
              elseif data.current.value == 'no' then
                  menu.close()
                  ESX.ShowNotification("Odrzuciłeś ofertę kupna")
              end
          end,
          function(data, menu)
              menu.close()
          end
      )
  end)