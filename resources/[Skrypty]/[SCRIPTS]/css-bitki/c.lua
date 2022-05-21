ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
  end
end)

local pendingAccept = nil
local organizationname = nil
local forwarder = nil
local accepter = nil
local ajdi = nil

RegisterNetEvent("bitkiC:acceptLose")
AddEventHandler("bitkiC:acceptLose", function(org, orgName, sender, recipient, tId)
  if pendingAccept ~= nil then return end
  pendingAccept = org
  organizationname = orgName
  forwarder = sender
  accepter = recipient
  ajdi = tId

  local elements = {
		{label = 'Czy '..org..' wygrało?'},
		{label = '<font color=green>Tak</font>', value = 'win'},
		{label = '<font color=red>Nie</font>', value = 'cancel'},
	}
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wonrequest', {
		title    = 'Bitki',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'win' then
			if pendingAccept then
        local screenshot = nil
        exports['screenshot-basic']:requestScreenshotUpload('https://sxcu.net/api/files/create', 'file', function(dataa)
          local resp = json.decode(dataa)
          screenshot = resp.url..".jpeg"
        end)
        ESX.ShowNotification("~w~Zaakceptowałeś ~r~przegraną ~w~bitki!")
        TriggerServerEvent("bitkiS:winResult", pendingAccept, organizationname, forwarder, accepter, screenshot, "accept", ajdi)
        pendingAccept = nil
      end
			menu.close()
		elseif data.current.value == 'cancel' then
      if pendingAccept then
        local screenshot = nil
        exports['screenshot-basic']:requestScreenshotUpload('https://sxcu.net/api/files/create', 'file', function(dataa)
          local resp = json.decode(dataa)
          screenshot = resp.url..".jpeg"
        end)
        ESX.ShowNotification("~w~Odrzuciłeś ~r~przegraną ~w~bitki!")
        TriggerServerEvent("bitkiS:winResult", pendingAccept, screenshot, "deny", ajdi)
        pendingAccept = nil
      end 
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)

  CreateThread(function() 
    Wait(15000)
    if pendingAccept ~= nil then
      ESX.ShowNotification("Czas na ~r~zaakceptowanie ~w~bitki z ~r~["..pendingAccept.."] ~w~minął!")
      local screenshot = nil
      exports['screenshot-basic']:requestScreenshotUpload('https://sxcu.net/api/files/create', 'file', function(dataa)
        local resp = json.decode(dataa)
        screenshot = resp.url..".jpeg"
      end)
      TriggerServerEvent("bitkiS:winResult", pendingAccept, organizationname, forwarder, accepter, screenshot, "timeout", ajdi)
      pendingAccept = nil
      ESX.UI.Menu.CloseAll()
    end  
  end)
end)