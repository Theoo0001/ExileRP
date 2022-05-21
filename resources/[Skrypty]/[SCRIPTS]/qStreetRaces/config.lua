-- CLIENT CONFIGURATION
config_cl = {
    joinProximity = 25,                 -- Proximity to draw 3D text and join race
    joinKeybind = 51,                   -- Keybind to join race ("E" by default)
    joinDuration = 30000,               -- Duration in ms to allow players to join the race
    freezeDuration = 5000,              -- Duration in ms to freeze players and countdown start (set to 0 to disable)
    checkpointProximity = 25.0,         -- Proximity to trigger checkpoint in meters
    checkpointRadius = 25.0,            -- Radius of 3D checkpoints in meters (set to 0 to disable cylinder checkpoints)
    checkpointHeight = 10.0,            -- Height of 3D checkpoints in meters
    checkpointBlipColor = 5,            -- Color of checkpoint map blips and navigation (see SetBlipColour native reference)
    hudEnabled = true,                  -- Enable racing HUD with time and checkpoints
    hudPosition = vec(0.015, 0.725),    -- Screen position to draw racing HUD
}

-- SERVER CONFIGURATION
config_sv = {
    finishTimeout = 180000,             -- Timeout in ms for removing a race after winner finishes
    notifyOfWinner = true               -- Notify all players of the winner (false will only notify the winner)
}

config_stations = {
    vector3(162.249, -1009.3163, 28.5716),
    vector3(160.4132, -3051.1475, 5.0381),
    vector3(-892.67, -2180.2881, 7.6552),
    vector3(214.0909, -2244.2847, 4.996),
    vector3(-755.6597, -1059.5514, 11.0),
    vector3(1158.4995, -776.0753, 56.6487),
    vector3(-52.431, -66.5141, 58.2714),
    vector3(-1290.6007, -625.4313, 25.8068),
    vector3(-1242.2543, 251.0247, 63.8693),
    vector3(-1970.4135, 470.5082, 102.1013),
    vector3(1006.5604, 180.566, 80.0404),
    vector3(457.341, 3496.8442, 33.3429),
    vector3(2998.2959, 3506.553, 70.4686),
    vector3(206.6307, 6575.5249, 30.8921),
    vector3(-2496.0828, 3660.7964, 12.6398),
    vector3(1744.1467, 4983.0708, 46.8024)
}