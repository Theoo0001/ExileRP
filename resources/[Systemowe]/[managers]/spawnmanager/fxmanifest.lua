fx_version "bodacious"
games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

client_script 'spawnmanager.lua'

export 'getRandomSpawnPoint'
export 'spawnPlayer'
export 'addSpawnPoint'
export 'removeSpawnPoint'
export 'loadSpawns'
export 'setAutoSpawn'
export 'setAutoSpawnCallback'
export 'forceRespawn'
