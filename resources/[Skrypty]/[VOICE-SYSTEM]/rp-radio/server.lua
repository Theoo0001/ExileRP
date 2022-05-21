ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

OrgJobs = {}
MySQL.ready(function() 
    MySQL.Async.fetchAll("SELECT * FROM jobs WHERE name LIKE @job", {
        ['@job'] = "%org%"
    }, function(results) 
        for i,v in ipairs(results) do
            local final = (v.name):gsub("org", "")
            local number = tonumber(final)
            table.insert(OrgJobs, {
                name = tostring(number+100),
                label = v.label
            })
        end   
    end)
end)

local PlayerChannels = {}

function RegisterInChannel(id, channel, label) 
    TriggerClientEvent("csskroubleC:stopTalking", -1, id)
    for i,v in ipairs(PlayerChannels) do
        if v.id == id then
            table.remove(PlayerChannels, i)
        end    
    end    
    table.insert(PlayerChannels, {
        id = id,
        channel = channel,
        label = label,
        nick = GetPlayerName(id)
    })
    for ii,vv in ipairs(PlayerChannels) do
        if not (vv.id == id) then
            if tonumber(vv.channel) < 6 then
                TriggerClientEvent("csskroubleC:addTalking1", id, vv.id, vv.label, vv.channel)
            end
        end    
    end   
    if tonumber(channel) < 6 then
        TriggerClientEvent("csskroubleC:addTalking1", -1, id, label, channel)
    end
end
function UnregisterInChannel(id) 
    TriggerClientEvent("csskroubleC:stopTalking", -1, id)
    TriggerClientEvent("csskroubleC:stopTalking1", -1, id)   
    for i,v in ipairs(PlayerChannels) do
        if v.id == id then
            table.remove(PlayerChannels, i)
        end    
    end    
end
AddEventHandler('playerDropped', function (reason)
    local src = source
    UnregisterInChannel(src)
end)
  
function GetChannel(id) 
    for i,v in ipairs(PlayerChannels) do
        if v.id == id then
            return v.channel
        end    
    end   
end
function SendStartTalking(label, id, channel) 
    for i,v in ipairs(PlayerChannels) do
        if v.channel == channel then
            TriggerClientEvent("csskroubleC:addTalking", v.id, label, id)
        end    
    end  
end
function SendStopTalking(id, channel) 
    for i,v in ipairs(PlayerChannels) do
        if v.channel == channel then
            TriggerClientEvent("csskroubleC:stopTalking", v.id, id)
        end    
    end  
end
function GetPlrsInChannel(channel) 
    local plrs = {}
    for i,v in ipairs(PlayerChannels) do
        if v.channel == channel then
            table.insert(plrs, v)
        end    
    end  
    return plrs
end
RegisterServerEvent("csskrouble:moveInRadio", function(id,channel) 
    local src = source
    TriggerClientEvent("csskrouble:moveTo", id, channel)
end)
RegisterServerEvent("csskrouble:kickFromRadio", function(id) 
    local src = source
    TriggerClientEvent("csskroubleC:kickedFromRadio", id)
end)
RegisterServerEvent("csskrouble:registerChannel", function(chnl) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.source ~= 0 then
        if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "mechanik2" then
            local badge = json.decode(xPlayer.character.job_id).id
            if not badge then
                badge = ""
            else
                badge = "["..badge.."]"
            end   
            local str = badge.." "..xPlayer.character.firstname.." "..xPlayer.character.lastname
            RegisterInChannel(src, chnl, str)   
        else
            RegisterInChannel(src, chnl, tostring(src))
        end    
    end 
end)
RegisterServerEvent("csskrouble:unregisterChannel", function() 
    local src = source
    UnregisterInChannel(src)
end)
RegisterServerEvent("csskrouble:openRadioListS", function(r) 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer and xPlayer.source ~= nil and xPlayer.source ~= 0 then
        if xPlayer.getGroup() ~= "user" then
            if r == "all" then
                TriggerClientEvent("csskrouble:openCrimeRadio", src, PlayerChannels)
            else
                TriggerClientEvent("csskrouble:openCrimeRadio", src, GetPlrsInChannel(r))
            end    
        end
    end    
end)
RegisterServerEvent("csskrouble:addTalking", function() 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.source ~= 0 then
        local channel = tonumber(GetChannel(src))
        if not channel then return end
        if channel < 9 then
            if xPlayer.job.name == "police" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "mechanik2" then
                local badge = json.decode(xPlayer.character.job_id).id
                if not badge then
                    badge = ""
                else
                    badge = "["..badge.."]"
                end   
                local str = badge.." ~w~"..xPlayer.character.firstname.." "..xPlayer.character.lastname
                if xPlayer.hiddenjob.name == "sheriff" then
                    str = "~o~"..str
                elseif xPlayer.job.name == "police" then
                    str = "~b~"..str          
                elseif xPlayer.job.name == "ambulance" then
                    str = "~r~"..str
                elseif xPlayer.job.name == "mechanik2" then
                    str = "~p~"..str
                end    
                SendStartTalking(str, src, channel)
            end    
        else
            SendStartTalking(tostring(src), src, channel)
        end    
    end    
end)
RegisterServerEvent("csskrouble:stopTalking", function() 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.source ~= 0 then
        local nigger = GetChannel(src)
        if nigger then
            local channel = tonumber(nigger)
            if not channel then return end
            SendStopTalking(src, channel)  
        end
    end    
end)

RegisterServerEvent("csskrouble:fetchOrganizations", function() 
    local src = source
    if #OrgJobs > 0 then
        TriggerClientEvent("csskrouble:returnOrg", src, OrgJobs)
    else
        CreateThread(function() 
            while #OrgJobs < 1 do
                Citizen.Wait(100)
            end     
            TriggerClientEvent("csskrouble:returnOrg", src, OrgJobs)
        end)
    end    
end)