ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local date = os.date('*t')
if date.month < 10 then date.month = '0' .. tostring(date.month) end
if date.day < 10 then date.day = '0' .. tostring(date.day) end
if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
if date.min < 10 then date.min = '0' .. tostring(date.min) end
if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' o godz: ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')

RegisterCommand("win", function(src, args, raw) 
  if src > 0 then
    if tonumber(args[1]) then
      local xPlayer = ESX.GetPlayerFromId(src)
      local tPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
      local xOrg = nil
      local tOrg = nil
      if string.sub(xPlayer.hiddenjob.name, 1, 3) == "org" or string.sub(xPlayer.hiddenjob.label, 1, 3) == "org" then
        if xPlayer.hiddenjob.grade >= 2 then
           if string.sub(xPlayer.hiddenjob.name, 1, 3) == "org" then xOrg = xPlayer.hiddenjob.label else xOrg = xPlayer.hiddenjob.label end
             if tPlayer.hiddenjob.grade >= 2 then
              if string.sub(tPlayer.hiddenjob.name, 1, 3) == "org" or string.sub(tPlayer.hiddenjob.label, 1, 3) == "org" then
               if string.sub(tPlayer.hiddenjob.name, 1, 3) == "org" then tOrg = tPlayer.hiddenjob.label else tOrg = tPlayer.hiddenjob.label end
                 TriggerClientEvent("bitkiC:acceptLose", tPlayer.source, xOrg, xPlayer.hiddenjob.name, xPlayer.name, tPlayer.name, src)
          else
            xPlayer.showNotification("Osoba której próbujesz wysłać prośbę nie jest w żadnej organizacji!")
          end  
        else
          xPlayer.showNotification("Tylko Kapitan+ może wysłać prośbę o zaakceptowanie bitki!")
        end
      else
        xPlayer.showNotification("Tylko Kapitan+ może zaakceptować bitki!")
      end
      else
        xPlayer.showNotification("Nie masz dostępu do tej komendy!")
      end
    end
  end  
end, false)

RegisterNetEvent("bitkiS:winResult")
AddEventHandler("bitkiS:winResult", function(org, orgName, sender, recipient, screenshot, result, targetId) 
  local xPlayer = ESX.GetPlayerFromId(source)
  local tPlayer = ESX.GetPlayerFromId(tonumber(targetId))
  local xOrg = nil
  local xOrgName = nil
  if string.sub(xPlayer.hiddenjob.name, 1, 3) == "org" then 
    xOrg = xPlayer.hiddenjob.label 
    xOrgName = xPlayer.hiddenjob.name
  else 
    xOrg = xPlayer.hiddenjob.label
    xOrgName = xPlayer.hiddenjob.name
  end
  if result == "accept" then
    tPlayer.showNotification('Bitka została ~g~zaakceptowana')
    MySQL.Async.fetchAll("SELECT * FROM bitki WHERE org_name = @org_name", {
      ['@org_name'] = orgName,
    }, function (result)
      local wins = tonumber(result[1].wins)
      local loses = tonumber(result[1].loses)
      MySQL.Async.execute("UPDATE bitki SET wins = @wins WHERE org_name = @org_name", { 
        ['@org_name'] = orgName,
        ['@wins'] = tonumber(wins)+1
      })
      MySQL.Async.fetchAll("SELECT * FROM bitki WHERE org_name = @org_name", {
        ['@org_name'] = xOrgName,
        }, function (resulttwo)
          local winstwo = tonumber(resulttwo[1].wins)
          local losestwo = tonumber(resulttwo[1].loses)
          MySQL.Sync.execute("UPDATE bitki SET loses = @loses WHERE org_name = @org_name", { 
            ['@org_name'] = xOrgName,
            ['@loses'] = tonumber(losestwo)+1
          })
          sendToDiscord(0x03dbfc, ""..org.." (W:"..(tonumber(wins)+1).." L:"..loses..", Razem: "..((tonumber(wins)+1)+loses)..")\n** WYGRAŁA BITKE Z** \n"..xOrg.." (W:"..winstwo.." L:"..(tonumber(losestwo)+1)..", Razem: "..((tonumber(winstwo)+1)+losestwo)..") \n**Wysylajacy:** "..sender.."\n**Przyjmujacy:** "..recipient, screenshot, "Bitki")
      end)
    end)
  elseif result == "deny" then
    tPlayer.showNotification('Bitka została ~r~odrzucona')
  elseif result == "timeout" then
    tPlayer.showNotification('Czas na akceptacje bitki minął')
  end  
end)

function sendToDiscord(color, message, img, footer)
  local embed = {
        {
            ["color"] = "15844367",
            ["title"] = "ExileRP",
            ["description"] = message,
            ["image"] = {
              ["url"] = img,
            },
            ["footer"] = {
              ["text"] = "Wysłano: "..date.."",
              ["icon_url"] = 'https://media.discordapp.net/attachments/793387307825889311/908379177449820190/logo.png',
            }
        }
    }

  PerformHttpRequest('https://discordproxy.neonrp.solutions/api/webhooks/928709064303706112/sAqCQugiZN2VBthwvAHIzUl_i9JHJ0C3gEbFQhoCUjZ_Cztqfma1ncHt-n1fTZs9Ce4O', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end