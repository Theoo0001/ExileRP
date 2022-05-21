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

local animation = { lib = 'random@mugging3' , base = 'handsup_standing_base', enter = 'handsup_standing_enter', exit = 'handsup_standing_exit', fade = 1 }

CreateThread(function() 
    while true do
        Citizen.Wait(5000)
        local a,ped = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if a then
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) and not IsPedInAnyVehicle(ped, true) and not IsPedSwimming(ped) and not IsPedClimbing(ped) and not IsPedDeadOrDying(ped, 1) and not IsPedRagdoll(ped) and not IsEntityPlayingAnim(ped, animation.lib, animation.base, 3) and not IsEntityPlayingAnim(ped, animation.lib, animation.enter, 3) and not IsEntityPlayingAnim(ped, animation.lib, animation.exit, 3) and not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
                if not exports['exile_trunk']:checkInTrunk() and not exports["esx_ambulancejob"]:isDead() then
                    local crds = GetEntityCoords(ped)
                    if #(GetEntityCoords(PlayerPedId()) - crds) > 11.5 then
                        goto powrot
                    end
                    NetworkRequestControlOfEntity(ped)
                    TaskSetBlockingOfNonTemporaryEvents(ped, true)
                    TaskStandStill(ped, 500 * 1000)
                    RequestAnimDict(animation.lib)
                    while not HasAnimDictLoaded(animation.lib) do
                        Citizen.Wait(10)
                    end
                    ClearPedTasksImmediately(ped)
                    TaskSetBlockingOfNonTemporaryEvents(ped, true)
                    TaskStandStill(ped, 500 * 1000)
                    SetEntityCollision(ped, true)
                    SetPedCombatAttributes(ped, 292, true)
                    TaskPlayAnim(ped, animation.lib, animation.enter, 8.0, 8.0, 1.0, 50, 0, 0, 0, 0)
                    CreateThread(function() 
                        while true do
                            Citizen.Wait(5000)
                            if DoesEntityExist(ped) and IsEntityPlayingAnim(ped, animation.lib, animation.base, 3) or IsEntityPlayingAnim(ped, animation.lib, animation.enter, 3) or IsEntityPlayingAnim(ped, animation.lib, animation.exit, 3) then
                                if not IsPlayerFreeAimingAtEntity(PlayerId(), ped) and not IsEntityPlayingAnim(entity, 'mp_arresting', 'idle', 3) then
                                    TaskSetBlockingOfNonTemporaryEvents(ped, false)
                                    SetPedCombatAttributes(ped, 292, false)
                                    SetEntityCollision(ped, false)
                                    ClearPedTasksImmediately(ped)
                                    Citizen.Wait(100)
                                    TaskReactAndFleePed(ped, PlayerPedId())
                                end    
                            else
                                break
                            end    
                        end
                    end)
                end    
            end    
        end  
        ::powrot::  
    end    
end)   