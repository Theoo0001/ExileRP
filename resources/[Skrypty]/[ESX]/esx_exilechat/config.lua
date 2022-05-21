Config        = {}
Config.Locale = 'pl'

Config.group = {
	['best'] = {0, 0, 0},
	['dev'] = {0, 0, 128},
	['superadmin'] = {255, 0, 0},
	['admin'] = {0, 191, 255},
	['mod'] = {132, 112, 255},
	['support'] = {255, 165, 0},
	['trialsupport'] = {255, 255, 0},
}

Config.EnableESXIdentity = true -- only turn this on if you are using esx_identity and want to use RP names
Config.OnlyFirstname     = false