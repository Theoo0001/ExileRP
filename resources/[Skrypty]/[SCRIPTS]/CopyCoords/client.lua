
RegisterCommand('copycoords', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = ""..((math.floor(coords.x*100))/100)..", "..((math.floor(coords.y*100))/100)..", "..((math.floor(coords.z*100))/100)..""
	})
end)


RegisterCommand('copycoords2', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = "x = "..((math.floor(coords.x*100))/100)..", y = "..((math.floor(coords.y*100))/100)..", z = "..((math.floor(coords.z*100))/100)..""
	})
end)