Config = {}
Config.Locale = 'pl'

Config.Price = 500

Config.DrawDistance = 10.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}

Config.Zones = {}

Config.RemoveList = {
    [1] = {['tshirt_1'] = 57},
    [2] = {['helmet_1'] = -1},
    [3] = {['torso_1'] = 53},
    [4] = {['ears_1'] = -1},
    [5] = {['mask_1'] = -1},
}

Config.Shops = {
	{x=72.254,    y=-1399.102, z=28.376},
	{x=-703.776,  y=-152.258,  z=36.415},
	{x=428.694,   y=-800.106,  z=28.491},
	{x=-829.413,  y=-1073.710, z=10.328},
	{x=-1447.797, y=-242.461,  z=48.820},
	{x=11.632,    y=6514.224,  z=30.877},
	{x=123.646,   y=-219.440,  z=53.557},
	{x=1696.291,  y=4829.312,  z=41.063},
	{x=618.093,   y=2759.629,  z=41.088},
	{x=1190.550,  y=2713.441,  z=37.222},
	{x=-1193.429, y=-772.262,  z=16.324},
	{x=-3172.496, y=1048.133,  z=19.863},
	{x=-1072.486, y=-2799.171,  z=28.923},
	{x= 4489.217, y=-4452.606,  z=3.41},
	{x=-724.120, y=-381.274,  z=33.873},
	{x=-1108.441, y=2708.923,  z=18.107},
	{x=921.98, y=28.24,  z=70.88}
}

for i=1, #Config.Shops, 1 do
	Config.Zones['Shop_' .. i] = {
		Pos   = Config.Shops[i],
		Size  = Config.MarkerSize,
		Color = Config.MarkerColor,
		Type  = Config.MarkerType
	}
end
