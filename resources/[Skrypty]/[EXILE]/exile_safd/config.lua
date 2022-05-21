Config = {}
Config.DrawDistance = 34.0
Config.MarkerSize = { x = 1.5, y = 1.5, z = 1.0 }
Config.PozarCooldown = 30 -- w minutach
Config.Heli = {
	spawn =  vec3(1218.40,-1519.13,33.74),
	heading = 240.3
}
Config.Blips = {
    {
    Pos = { x = 1198.41, y = -1473.88, z = 33.03 },
    Sprite  = 436,
    Display = 4,
    Scale   = 1.2,
    Colour  = 1,
    },

	{
		Pos = { x = -368.23, y = 6109.24, z = 33.03 },
		Sprite  = 436,
		Display = 4,
		Scale   = 1.2,
		Colour  = 1,
		},

    {
        Pos = { x = 204.55, y = -1651.97, z = 28.89 },
        Sprite  = 436,
        Display = 4,
        Scale   = 1.2,
        Colour  = 1,
    },

}
Config.FireStations = {


  SAFD = {

    AuthorizedVehicles = {
		{ name = '16gmcbrush', label = 'GMC', grade = 1 },
		{ name = '19ranger', label = 'Ford Ranger 19', grade = 1 },
		{ name = 'arroweng', label = 'Wóz strażacki', grade = 1 },
		{ name = 'arrowladder', label = 'Wóz strażacki z drabiną', grade = 5 },
		{ name = 'arrowrescue', label = 'Wóz strażacki Rescuce', grade = 3 },
		{ name = 'brush1', label = 'Chevrolet Bush', grade = 3 },
		{ name = 'bulldog', label = 'M0nstur Truck', grade = 3 },
		{ name = 'fd_explorer', label = 'Ford Explorer', grade = 9 },
		{ name = 'fd4', label = 'Ford do wsparcia', grade = 1 },
		{ name = 'fdatv', label = 'Quad', grade = 1 },
		{ name = 'fdhart', label = 'Ford 4x4', grade = 2 }
	  },
	SpecialVehicles = {

		{ name = 'fura', label = 'd', special = 'pilot'},
		{ name = 'test', label = 'test drive', special = 'drive'},

	  },
	  Cloakrooms = {
		{x = 1172.67, y = -1469.0286, z = 34.12 },
		{x = 205.70, y = -1650.64, z = 33.25 },
		{x = -366.58, y = 6103.44, z = 30.25 },
	  },

    Armories = {
      { x = 177.87, y = -832.62, z = 30.68 },
	  { x = -365.94, y = 6110.05, z = 30.49 },
	  { x = 1215.48, y = -1474.49, z = 34.1 },
    },

    Vehicles = {
		{
		  Spawner    = { x = 1194.81, y = -1475.94, z = 33.90 },
		  SpawnPoint = { x = 1196.83, y = -1468.79, z = 33.90 },
		  Heading    = 358.73
		},
		{
			Spawner    = { x = -365.53, y = 6114.37, z = 30.49 },
			SpawnPoint = { x = -366.40, y = 6116.51, z = 30.49 },
			Heading    = 39.88
		},
		{
		  Spawner    = { x = 201.76, y = -1645.96, z = 28.89 },
		  SpawnPoint = { x = 205.81, y = -1644.61, z = 28.89 },
		  Heading    = 309.12
		}
	  },

    Helicopters = {
      {
        Spawner  = {x = 1218.40, y = -1519.13, z = 33.74},
      },
	  {
        Spawner  = {x = 1712.75, y = 3594.6, z = 34.4},
      },
	  {
        Spawner  = {x = -368.59, y = 6089.07, z = 30.5},
      },
    },

    VehicleDeleters = {
      { x = -368.18, y = 6126.02, z = 30.49 },
	  { x = 1204.93, y = -1468.38, z = 33.90 },
	  { x = 212.46, y = -1649.46, z = 28.89 },
    },

    BossActions = {
	{ x = 1177.30, y = -1477.43, z = 34.16 },
	{ x = -369.93, y = 6110.21, z = 35.57 },
    }
  }
}



Config.Uniforms = {
	koszarowka1 = { -- od grade 1
	male = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 0,
		['shoes_1'] = 25,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	},
	female = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 0,
		['shoes_1'] = 24,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	}
},
koszarowka2 = { -- od grade 12
	male = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 1,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 0,
		['shoes_1'] = 25,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	},
	female = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 0,
		['shoes_1'] = 25,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	}
},
  koszarowka3 = { --od grade 4
	male = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 2,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 0,
		['shoes_1'] = 24,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	},
	female = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 0,
		['shoes_1'] = 24,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	}
},


rwoddne = { -- od grade 1
male = {
	['tshirt_1'] = 87,  ['tshirt_2'] = 0,
	['torso_1'] = 45,   ['torso_2'] = 2,
	['arms'] = 0,
	['pants_1'] = 46,   ['pants_2'] = 0,
	['shoes_1'] = 24,   ['shoes_2'] = 0,
	['helmet_1'] = 60,  ['helmet_2'] = 0,
	['chain_1'] = 18,    ['chain_2'] = 0
},
female = {
	['tshirt_1'] = 87,  ['tshirt_2'] = 0,
	['torso_1'] = 72,   ['torso_2'] = 0,
	['arms'] = 0,
	['pants_1'] = 46,   ['pants_2'] = 0,
	['shoes_1'] = 24,   ['shoes_2'] = 0,
	['helmet_1'] = 60,  ['helmet_2'] = 0,
	['chain_1'] = 18,    ['chain_2'] = 0
	  }
  },

nurek = { -- od grade 1
  male = {
	  ['tshirt_1'] = 123,  ['tshirt_2'] = 0,
	  ['torso_1'] = 71,   ['torso_2'] = 0,
	  ['arms'] = 0,
	  ['pants_1'] = 44,   ['pants_2'] = 0,
	  ['shoes_1'] = 67,   ['shoes_2'] = 0,
	  ['helmet_1'] = -1,  ['helmet_2'] = 0,
	  ['chain_1'] = 0,    ['chain_2'] = 0
  },
  female = {
	['tshirt_1'] = 123,  ['tshirt_2'] = 0,
	['torso_1'] = 71,   ['torso_2'] = 0,
	['arms'] = 0,
	['pants_1'] = 44,   ['pants_2'] = 0,
	['shoes_1'] = 67,   ['shoes_2'] = 0,
	['helmet_1'] = -1,  ['helmet_2'] = 0,
	['chain_1'] = 0,    ['chain_2'] = 0
		}
	},

trening = { -- od grade 0
  male = {
	  ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
	  ['torso_1'] = 172,   ['torso_2'] = 0,
	  ['arms'] = 1,
	  ['pants_1'] = 164,   ['pants_2'] = 2,
	  ['shoes_1'] = 59,   ['shoes_2'] = 3,
	  ['helmet_1'] = 7,  ['helmet_2'] = 0,
	  ['chain_1'] = 0,    ['chain_2'] = 0
  },
  female = {
	['tshirt_1'] = 123,  ['tshirt_2'] = 0,
	['torso_1'] = 71,   ['torso_2'] = 0,
	['arms'] = 0,
	['pants_1'] = 44,   ['pants_2'] = 0,
	['shoes_1'] = 67,   ['shoes_2'] = 0,
	['helmet_1'] = -1,  ['helmet_2'] = 0,
	['chain_1'] = 0,    ['chain_2'] = 0
		}
	},

  pilot = { -- od licencji pilota
	male = {
		['tshirt_1'] = 129,  ['tshirt_2'] = 0,
		['torso_1'] = 154,   ['torso_2'] = 2,
		['arms'] = 17,
		['pants_1'] = 92,   ['pants_2'] = 0,
		['shoes_1'] = 25,   ['shoes_2'] = 0,
		['helmet_1'] = 87,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 0
	},
	female = {
	  ['tshirt_1'] = 123,  ['tshirt_2'] = 0,
	  ['torso_1'] = 71,   ['torso_2'] = 0,
	  ['arms'] = 0,
	  ['pants_1'] = 44,   ['pants_2'] = 0,
	  ['shoes_1'] = 67,   ['shoes_2'] = 0,
	  ['helmet_1'] = -1,  ['helmet_2'] = 0,
	  ['chain_1'] = 0,    ['chain_2'] = 0
		}
	},

	hazmat = { -- od licencji hazmat
	  male = {
		  ['tshirt_1'] = 91,  ['tshirt_2'] = 0,
		  ['torso_1'] = 104,   ['torso_2'] = 0,
		  ['arms'] = 166,
		  ['pants_1'] = 40,   ['pants_2'] = 0,
		  ['shoes_1'] = 87,   ['shoes_2'] = 14,
		  ['helmet_1'] = 46,  ['helmet_2'] = 0,
		  ['chain_1'] = 0,    ['chain_2'] = 0,
		  ['mask_1'] = 46, ['mask_2'] = 0
	  },
	  female = {
		['tshirt_1'] = 123,  ['tshirt_2'] = 0,
		['torso_1'] = 71,   ['torso_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 44,   ['pants_2'] = 0,
		['shoes_1'] = 67,   ['shoes_2'] = 0,
		['helmet_1'] = -1,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0
			}
		},


nomex1 = { -- od grade 0
	male = {
		['tshirt_1'] = 91,  ['tshirt_2'] = 0,
		['torso_1'] = 80,   ['torso_2'] = 0,
		['arms'] = 96,
		['pants_1'] = 43,   ['pants_2'] = 0,
		['shoes_1'] = 33,   ['shoes_2'] = 0,
		['helmet_1'] = 45,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 0
	},
	female = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 0,
		['shoes_1'] = 24,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	}
},

nomex2 = { -- od grade 8
	male = {
		['tshirt_1'] = 91,  ['tshirt_2'] = 0,
		['torso_1'] = 80,   ['torso_2'] = 0,
		['arms'] = 96,
		['pants_1'] = 43,   ['pants_2'] = 0,
		['shoes_1'] = 33,   ['shoes_2'] = 0,
		['helmet_1'] = 45,  ['helmet_2'] = 1,
		['chain_1'] = 0,    ['chain_2'] = 0
	},
	female = {
		['tshirt_1'] = 87,  ['tshirt_2'] = 0,
		['torso_1'] = 72,   ['torso_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 46,   ['pants_2'] = 1,
		['shoes_1'] = 24,   ['shoes_2'] = 0,
		['helmet_1'] = 60,  ['helmet_2'] = 0,
		['chain_1'] = 18,    ['chain_2'] = 0
	}
},

nomexzbutla = { -- od grade 0
  male = {
		['tshirt_1'] = 68,  ['tshirt_2'] = 0,
		['torso_1'] = 80,   ['torso_2'] = 0,
		['arms'] = 96,
		['pants_1'] = 43,   ['pants_2'] = 0,
		['shoes_1'] = 33,   ['shoes_2'] = 0,
		['helmet_1'] = 45,  ['helmet_2'] = 0,
		['chain_1'] = 0,    ['chain_2'] = 0
  },
  female = {
	  ['tshirt_1'] = 87,  ['tshirt_2'] = 0,
	  ['torso_1'] = 72,   ['torso_2'] = 0,
	  ['arms'] = 0,
	  ['pants_1'] = 46,   ['pants_2'] = 0,
	  ['shoes_1'] = 24,   ['shoes_2'] = 0,
	  ['helmet_1'] = 60,  ['helmet_2'] = 0,
	  ['chain_1'] = 18,    ['chain_2'] = 0
	}
},


nomexzbutla2 = { -- od grade 8
  male = {
		['tshirt_1'] = 68,  ['tshirt_2'] = 0,
		['torso_1'] = 80,   ['torso_2'] = 0,
		['arms'] = 96,
		['pants_1'] = 43,   ['pants_2'] = 0,
		['shoes_1'] = 33,   ['shoes_2'] = 0,
		['helmet_1'] = 45,  ['helmet_2'] = 1,
		['chain_1'] = 0,    ['chain_2'] = 0
  },
  female = {
	  ['tshirt_1'] = 87,  ['tshirt_2'] = 0,
	  ['torso_1'] = 72,   ['torso_2'] = 0,
	  ['arms'] = 0,
	  ['pants_1'] = 46,   ['pants_2'] = 0,
	  ['shoes_1'] = 24,   ['shoes_2'] = 0,
	  ['helmet_1'] = 60,  ['helmet_2'] = 0,
	  ['chain_1'] = 18,    ['chain_2'] = 0
	}
},

galowy = { -- od grade 0
male = {
	  ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
	  ['torso_1'] = 41,   ['torso_2'] = 1,
	  ['arms'] = 1,
	  ['pants_1'] = 28,   ['pants_2'] = 0,
	  ['shoes_1'] = 10,   ['shoes_2'] = 0,
	  ['helmet_1'] = -1,  ['helmet_2'] = 0,
	  ['chain_1'] = 0,    ['chain_2'] = 0
},
female = {
	['tshirt_1'] = 87,  ['tshirt_2'] = 0,
	['torso_1'] = 72,   ['torso_2'] = 0,
	['arms'] = 0,
	['pants_1'] = 46,   ['pants_2'] = 0,
	['shoes_1'] = 24,   ['shoes_2'] = 0,
	['helmet_1'] = 60,  ['helmet_2'] = 0,
	['chain_1'] = 18,    ['chain_2'] = 0
  }
},
 
galowy = { -- od grade 8
male = {
	  ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
	  ['torso_1'] = 41,   ['torso_2'] = 0,
	  ['arms'] = 1,
	  ['pants_1'] = 28,   ['pants_2'] = 0,
	  ['shoes_1'] = 10,   ['shoes_2'] = 0,
	  ['helmet_1'] = -1,  ['helmet_2'] = 0,
	  ['chain_1'] = 0,    ['chain_2'] = 0
},
female = {
	['tshirt_1'] = 87,  ['tshirt_2'] = 0,
	['torso_1'] = 72,   ['torso_2'] = 0,
	['arms'] = 0,
	['pants_1'] = 46,   ['pants_2'] = 0,
	['shoes_1'] = 24,   ['shoes_2'] = 0,
	['helmet_1'] = 60,  ['helmet_2'] = 0,
	['chain_1'] = 18,    ['chain_2'] = 0
  }
},
wysokosciowy = { -- od grade 1
male = {
	  ['tshirt_1'] = 43,  ['tshirt_2'] = 0,
	  ['torso_1'] = 154,   ['torso_2'] = 0,
	  ['arms'] = 17,
	  ['pants_1'] = 92,   ['pants_2'] = 10,
	  ['shoes_1'] = 25,   ['shoes_2'] = 0,
	  ['helmet_1'] = 41,  ['helmet_2'] = 0,
	  ['chain_1'] = 0,    ['chain_2'] = 0
},
female = {
	['tshirt_1'] = 87,  ['tshirt_2'] = 0,
	['torso_1'] = 72,   ['torso_2'] = 0,
	['arms'] = 0,
	['pants_1'] = 46,   ['pants_2'] = 0,
	['shoes_1'] = 24,   ['shoes_2'] = 0,
	['helmet_1'] = 60,  ['helmet_2'] = 0,
	['chain_1'] = 18,    ['chain_2'] = 0
		}
},

	
} 