Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 5
Config.SpeedMultiplier = 3.6
Config.Locale = 'en'

Config.Prices = {
  dmv         = 1200,
  drive       = 500,
  drive_bike  = 500,
  drive_truck = 500
}

Config.VehicleModels = {
  drive       = 'blista',
  drive_bike  = 'pcj',
  drive_truck = 'mule3'
}

Config.SpeedLimits = {
  residence = 50,
  town      = 80,
  freeway   = 120
}

Config.Zones = {

  DMVSchool = {
    Pos   = {x = -926.33, y = -2037.67, z = 8.4},
    Size  = {x = 1.2, y = 1.2, z = 1.0},
    Color = {r = 204, g = 204, b = 0},
    Type  = 1
  },

  VehicleSpawnPoint = {
    Pos   = {x = -923.55, y = -2074.36, z = 8.8},  
    Size  = {x = 1.3, y = 1.3, z = 1.0}, 
    Color = {r = 204, g = 204, b = 0},
    Type  = -1
  },

}

Config.CheckPoints = {

  {
    Pos = {x = -900.65, y = -2048.58, z = 8.12}, -- start
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('next_point_speed') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
    end
  },

  {
    Pos = {x = -937.38, y = -2097.24, z = 8.12},
    Action = function(playerPed, vehicle, setCurrentZoneType) -- udaj sie do nastepnego punktu
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -942.8, y = -2122.57, z = 8.15}, -- skrec w lewo
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      CreateThread(function()
        DrawMissionText(_U('stop_look_right') .. Config.SpeedLimits['town'] .. 'km/h', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(6000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_turn_right'), 5000)
      end)
    end
  },

  {
    Pos = {x = -909.23, y = -2107.73, z = 7.85}, -- udaj sie do nastepnego punktu 
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -794.92, y = -1993.47, z = 7.86}, 
    Action = function(playerPed, vehicle, setCurrentZoneType) -- udaj sie do nastepnego punktu
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -678.71, y = -1956.22, z = 5.45}, -- udaj sie do nastepnego punktu
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -545.59, y = -2094.36, z = 7.16}, 
    Action = function(playerPed, vehicle, setCurrentZoneType) -- udaj sie do nastepnego punktu
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },
  

  {
    Pos = {x = -457.29, y = -2157.23, z = 9.6}, -- udaj sie do nastepnego punktu  ------ 
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -335.5, y = -2154.05, z = 9.77}, -- udaj sie do nastepnego punktu  ------  
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -293.88, y = -2172.8, z = 9.84}, -- zatrzymaj sie i skrec w lewo 
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('residence')

      CreateThread(function()
        DrawMissionText(_U('stop_go_left') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(6000)
        FreezeEntityPosition(vehicle, false)
      end)
    end
  },

  {
    Pos = {x = -162.87, y = -2153.9 , z = 16.21}, -- udaj sie do nastepnego punktu  ------ 
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -94.53, y = -2130.01, z = 16.21}, -- zatrzymaj sie i skrec w lewo x = 
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('residence')

      CreateThread(function()
        DrawMissionText(_U('stop_go_left') .. Config.SpeedLimits['residence'] .. 'km/h', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(6000)
        FreezeEntityPosition(vehicle, false)
      end)
    end
  },

  {
    Pos = {x = -108.53, y = -2031.46, z = 17.53}, -- udaj sie do nastepnego punktu  ------ 
    Action = function(playerPed, vehicle, setCurrentZoneType) 
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -143.11, y = -2009.01, z = 21.77}, -- skrec w lewo 
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      CreateThread(function()
        DrawMissionText(_U('stop_look_right') .. Config.SpeedLimits['town'] .. 'km/h', 5000) 
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(6000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText(_U('good_turn_right'), 5000)
      end)
    end
  },

  {
    Pos = {x = -165.9, y = -2074.56, z = 25.18}, -- teraz czas na autostrade 
    Action = function(playerPed, vehicle, setCurrentZoneType) 

      setCurrentZoneType('freeway')

      DrawMissionText(_U('hway_time') .. Config.SpeedLimits['freeway'] .. 'km/h', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = -367.08, y = -2081.33, z = 24.84},
    Action = function(playerPed, vehicle, setCurrentZoneType) -- udaj sie do nastepnego punktu
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },


  {
    Pos = {x = -748.73, y = -1772.45, z = 28.87},  
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      DrawMissionText(_U('in_town_speed') .. Config.SpeedLimits['town'] .. 'km/h', 5000) -- wjazd do miasta
    end
  },

  {
    Pos = {x = -753.83, y = -1722.22, z = 28.86}, -- jedz prosto
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      CreateThread(function()
        DrawMissionText(_U('stop_go_straight') .. Config.SpeedLimits['town'] .. 'km/h', 5000) 
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(6000)
        FreezeEntityPosition(vehicle, false)
      end)
    end
  },

  {
    Pos = {x = -789.95, y = -1630.26, z = 14.84},
    Action = function(playerPed, vehicle, setCurrentZoneType) -- udaj sie do nastepnego punktu   
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -924.3 , y = -1782.65, z = 18.51 },
    Action = function(playerPed, vehicle, setCurrentZoneType) -- udaj sie do nastepnego punktu      
      DrawMissionText(_U('go_next_point'), 5000)
    end
  },

  {
    Pos = {x = -1083.94  , y = -2030.43, z = 11.95 },
    Action = function(playerPed, vehicle, setCurrentZoneType) -- udaj sie do ostatniego punktu    
      DrawMissionText(_U('go_last_point'), 5000)
    end
  },

  {
    Pos = {x = -992.59  , y = -2093.46, z = 10.6 },
    Action = function(playerPed, vehicle, setCurrentZoneType) -- wjedz do garazu     
      DrawMissionText(_U('go_garage_last_point'), 5000)
    end
  },


  {
    Pos = {x = -957.59, y = -2059.98, z =  8.23},
    Action = function(playerPed, vehicle, setCurrentZoneType) -- koniec praktyki
      ESX.Game.DeleteVehicle(vehicle)
    end
  },

}
