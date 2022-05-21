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
ESX = nil
local PlayerData = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
            ESX = obj 
        end)
        
        Citizen.Wait(250)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
    PlayerData.hiddenjob = hiddenjob
end)

--[[local blips = {}

function createOrgBlips() 
    print("[csskrouble] adding blips")
    local orgTps1 = exports["exile_teleports"]:FetchOrgTeleports()
    local orgTps = orgTps1.Orgs
    for k,v in pairs(orgTps) do
        local blip = AddBlipForCoord(table.unpack(v.From))
        SetBlipSprite(blip, 84)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.65)
        SetBlipCategory(blip, 11)
        SetBlipColour(blip, 49)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Organizacja #"..string.gsub(v.Visible, "org", ""))
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end
end

CreateThread(function() 
    while PlayerData == nil do
        Citizen.Wait(100)
    end
    while true do
        if PlayerData and PlayerData.job.name == "police" and #blips == 0 then
            ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                if hasWeaponLicense or (PlayerData.job and PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob and PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
                    createOrgBlips()
                else
                    ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                        if hasWeaponLicense then
                            createOrgBlips()
                        end
                    end, GetPlayerServerId(PlayerId()), 'sert')
                end
            end, GetPlayerServerId(PlayerId()), 'swat')
        elseif PlayerData and PlayerData.job.name ~= "police" then
            if #blips > 0 then
                print("[csskrouble] cleaning blips")
                for k,v in pairs(blips) do
                    if DoesBlipExist(v) then
                        RemoveBlip(v)
                    end
                end
            end
        end
        Citizen.Wait(10000)
    end
end)]]