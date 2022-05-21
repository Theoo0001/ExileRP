function DrawTxt(text, x, y)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.0, 0.4)
	SetTextDropshadow(1, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

CreateThread(function()
    while true do
    	Citizen.Wait(0)
		x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
		
    	roundx = tonumber(string.format("%.2f", x))
    	roundy = tonumber(string.format("%.2f", y))
		roundz = tonumber(string.format("%.2f", z))
		
		DrawTxt("~g~X:~r~ "..roundx, 0.35, 0.00)
		DrawTxt("~g~Y:~r~ "..roundy, 0.41, 0.00)
		DrawTxt("~g~Z:~r~ "..roundz, 0.475, 0.00)

		heading = GetEntityHeading(PlayerPedId())
		roundh = tonumber(string.format("%.2f", heading))
		DrawTxt("~g~H:~r~ "..roundh, 0.53, 0.00)
    end
end)
