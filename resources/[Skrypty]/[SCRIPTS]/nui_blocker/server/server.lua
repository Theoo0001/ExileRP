function ExtractIdentifiers(src)
    
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

local logs = "https://canary.discord.com/api/webhooks/901069031723896872/vI9sMwX44afDuxpJzaiVB3ySGCN-MsxzfMJ1QEBrdswgPMrjoXGIM5HLi9OLorlYlUhM"

local kick_msg = "Hmm, czego tam szukasz?"
local discord_msg = 'Gracz próbował użyć nui devtools i został wyrzucony'
local color_msg = 16767235

function sendToDiscord (source,message,color,identifier)
    
    local name = GetPlayerName(source)
    if not color then
        color = color_msg
    end
    local sendD = {
        {
            ["color"] = color,
            ["title"] = message,
            ["description"] = "`Gracz`: **"..name.."**\nSteam: **"..identifier.steam.."**\nDiscord: **"..identifier.discord.."**",
            ["footer"] = {
                ["text"] = "Exile-Handler - "..os.date("%x %X %p")
            },
        }
    }

    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Exile-Handler", embeds = sendD}), { ['Content-Type'] = 'application/json' })
end


RegisterServerEvent(GetCurrentResourceName())
AddEventHandler(GetCurrentResourceName(), function()
    local _source = source
    local identifier = ExtractIdentifiers(_source)
    local identifierDb
    identifierDb = identifier.license
    MySQL.Async.fetchAll("SELECT group FROM users WHERE identifier = @identifier",{['@identifier'] = identifierDb }, function(results) 
        if results[1].group ~= 'superadmin' or 'best' then
            sendToDiscord (source, discord_msg, color_msg,identifier)
            DropPlayer(source, kick_msg)
        end
    end)
end)
