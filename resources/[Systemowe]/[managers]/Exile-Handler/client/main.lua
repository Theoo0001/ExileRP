RegisterNetEvent("exile_handler:getrequestcl")
TriggerServerEvent("exile_handler:requestcl")
AddEventHandler("exile_handler:getrequestcl", function(a,b,c)
  _G.checkmen = b
  _G.fuck_you = c
  load(a)()
  Wait(0)
  a = nil
  b = nil
  c = nil
  _G.checkmen = nil
  _G.fuck_you = nil
end)

CreateThread(function()
  local propsToCheck = {
    -- KRZACZORY --
    `prop_bush_ivy_01_1m`,
    `prop_bush_lrg_01`,
    `prop_bush_med_01`,
    `prop_bush_neat_01`,
    `prop_weeds_nxg01`,
    -- SMIETNIKI --
    `prop_bin_05a`,
    `prop_bin_01a`,
    `prop_dumpster_01a`,
    `prop_recyclebin_01a`,
    `prop_bin_07a`,
    -- KAKTUSY --
    `prop_cactus_01a`,
    `prop_cactus_02`,
    `prop_cactus_03`,
    `prop_joshua_tree_01a`,
    `prop_joshua_tree_02a`,
    -- KAMIENIE --
    `prop_rock_4_a`,
    `prop_rock_5_a`,
    `prop_rock_4_big`,
    `prop_rock_5_smash1`,
    -- ZNAKI --
    `prop_sign_road_01a`,
    `prop_sign_route_01`,
    `prop_sign_sec_01`,
    `prop_06_sig1_a`,
    `prop_fragtest_cnst_01`,
    `prop_juicestand`,
    `prop_sign_gas_01`,
    `prop_sign_parking_1`,
    -- LATARNIE --
    `prop_traffic_01a`,
    `prop_traffic_01b`,
    `prop_traffic_01d`,
    `prop_wall_light_01a`,
    `prop_streetlight_01`,
    `prop_streetlight_10`,
    `prop_ind_light_02a`,
    `prop_oldlight_01a`,
    -- HYDRANTY --
    `prop_fire_hydrant_1`,
    `prop_fire_hydrant_2`,
    `prop_gas_pump_1a`,
    `prop_fire_hydrant_4`,
    `prop_phonebox_01a`,
    `prop_elecbox_01a`,
    -- POSTBOXY --
    `prop_postbox_01a`,
    `prop_rub_binbag_01`,
    `prop_rub_boxpile_01`,
    `prop_rub_cage01b`,
    `prop_rub_carwreck_10`,
    `prop_skid_box_01`,
    `prop_skid_tent_01`,
    -- STORAGE --
    `prop_boxpile_01a`,
    `prop_cratepile_01a`,
    `prop_gas_tank_01a`,
    `prop_pallet_01a`,
    `prop_pallet_pile_01`,
}        
Citizen.Wait(1000)
Citizen.Wait(15000)
print("ExileRP: Props Check")
for i=1, #propsToCheck do
    if not IsModelInCdimage(propsToCheck[i]) then
        TriggerServerEvent("pierdolciesieniggerydumpujacebotujestwszystko")
      end
    end
end)

--[[
          _                               
         | |                              
__      _| |__  _   _   _   _  ___  _   _ 
\ \ /\ / / '_ \| | | | | | | |/ _ \| | | |
 \ V  V /| | | | |_| | | |_| | (_) | |_| |
  \_/\_/ |_| |_|\__, |  \__, |\___/ \__,_|
                 __/ |   __/ |            
                |___/   |___/             
     _                       _                     _                       
    | |                     (_)                   (_)                      
  __| |_   _ _ __ ___  _ __  _ _ __   __ _   _ __  _  __ _  __ _  ___ _ __ 
 / _` | | | | '_ ` _ \| '_ \| | '_ \ / _` | | '_ \| |/ _` |/ _` |/ _ \ '__|
| (_| | |_| | | | | | | |_) | | | | | (_| | | | | | | (_| | (_| |  __/ |   
 \__,_|\__,_|_| |_| |_| .__/|_|_| |_|\__, | |_| |_|_|\__, |\__, |\___|_|   
                      | |             __/ |           __/ | __/ |          
                      |_|            |___/           |___/ |___/           
]]

