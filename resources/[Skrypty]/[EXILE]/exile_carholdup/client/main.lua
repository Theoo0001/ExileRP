local startingPoint = {x = -306.67266845703, y = -1068.6010742188, z = 29.38495826} ---> Punkt w ktorym zaczynamy kazda misje
local etap1dziupla = {x = 1690.8901367188, y = 3287.0766601563, z = 40.54048} ---> Koordynaty do dziupli
local lakierCoords = {x = -199.69110107422, y = -1315.2894287109, z = 31.0893} ---> Koordynaty gdzie mozna krasc farbe
local nadajnikCoords = {x = 113.33502960205, y = 6618.775390625, z = 31.8576} ---> Koordynaty gdzie npc sprze nam nowy nadajnik
local respSelleraNadajnikow = {x = 112.15065002441, y = 6619.50390625, z = 31.81} --> Koordy gdzie stoi NPC co sprzedaj nadajnik
local ziomekCoord = {x = 1686.6502685547, y = 3287.8918457031, z = 41.1465} --> Koordy gdzie respi sie NPC ktory przejmuje pojazd z fałszywymi dokumentami
local noweAutoCoords = { x = 1099.2830810547, y = -2287.4916992188, z = 30.141} --> Gdzie sie respi kradzione auto
local gang1Coords = {x = 1104.0988769531, y = -2291.9140625, z = 30.242} --> Koordy gangstera ochroniarza
local gang2Coords = {x = 1099.1599121094, y = -2296.3583984375, z = 30.151} --> Koordy gangstera ochroniarza
local gang3Coords = {x = 1087.4764404297, y = -2307.03125, z = 35.719009} --> Koordy gangstera ochroniarza
local gang4Coords = {x = 1089.7485351563, y = -2289.5490722656, z = 30.1582} --> Koordy gangstera ochroniarza
local gang5Coords = {x = 1093.6882324219, y = -2268.826171875, z = 30.286} --> Koordy gangstera ochroniarza
local koncowyGaraz = {x = -721.30834960938, y = -60.431156158447, z = 36.891} --> Miejsce gdzie konczymy misje, wjezdamy do garazu i pojazd jest nasz
local CenaNadajnika = 2500 --> Cena za nowy nadajnik (zmien tez cene po stronie serwera)
local randomCar = {'MESA', "SULTANRS", "BANSHEE2", "FMJ"}
local potrzebniPolicjanci = 7 

----------------nizej lepiej nie tykaj------------------
local modelcar = nil					
local tablicastara = 0					
local nadajnikstary = 0
local kolorstary = 0
local misjaBlip
local carName
local AktywnyEtap1 = 0
local zrobiony1 = false
local AktywnyEtap23 = 0
local carShow = 0
local prcn = 0
local AutoKradzione
--------------------------------------------------------
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

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)
	
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)
CreateThread(function()
	local blip = AddBlipForCoord(startingPoint.x, startingPoint.y, startingPoint.z)
	SetBlipSprite (blip, 533)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, 1)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Napad na auto")
	EndTextCommandSetBlipName(blip)
end)

function PowiadomPsy(a)
    if a == "1" then
        x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        playerX = tonumber(string.format("%.2f", x))
        playerY = tonumber(string.format("%.2f", y))
        playerZ = tonumber(string.format("%.2f", z))
        TriggerServerEvent("tostauto:zawiadompsy", playerX, playerY, playerZ)
        Citizen.Wait(500)
    elseif a == "2" then
        local b = GetVehiclePedIsIn(PlayerPedId(), false)
        local c = GetVehicleNumberPlateText(b)
        local d = GetVehicleClass(b)
        if d == 0 then
            d = "Kompakt"
        elseif d == 1 then
            d = "Sedan"
        elseif d == 2 then
            d = "SUV"
        elseif d == 3 then
            d = "Coupe"
        elseif d == 4 then
            d = "Muscle"
        elseif d == 6 or d == 5 then
            d = "Sportowy"
        elseif d == 7 then
            d = "Super"
        elseif d == 9 then
            d = "Offroad"
        elseif d == 12 then
            d = "VAN"
        end
        x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        playerX = tonumber(string.format("%.2f", x))
        playerY = tonumber(string.format("%.2f", y))
        playerZ = tonumber(string.format("%.2f", z))
        TriggerServerEvent("tostauto:zawiadompsy2", playerX, playerY, playerZ, c, d, modelcar)
        Citizen.Wait(500)
    elseif a == "3" then
        x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        playerX = tonumber(string.format("%.2f", x))
        playerY = tonumber(string.format("%.2f", y))
        playerZ = tonumber(string.format("%.2f", z))
        TriggerServerEvent("tostauto:zawiadompsy3", playerX, playerY, playerZ)
        Citizen.Wait(500)
    end
end


RegisterNetEvent('tostauto:kradziezLspd')
AddEventHandler('tostauto:kradziezLspd', function(x, y, z)	
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        ESX.ShowNotification('~r~Zgłoszono kradzież farby u mechanika Bennego!')
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 225)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Kradzież farby')
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(90000)
        RemoveBlip(blip)
	end
end)

RegisterNetEvent('tostauto:kradziezLspd3')
AddEventHandler('tostauto:kradziezLspd3', function(x, y, z)	
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
        ESX.ShowNotification('~r~Zauważony poszukiwany kradziony pojazd luksusowy!~n~Zaznaczono na GPS')
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 225)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Zauważono kradziony pojazd')
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(90000)
        RemoveBlip(blip)
	end
end)

RegisterNetEvent('tostauto:kradziezLspd2') 
AddEventHandler('tostauto:kradziezLspd2', function(x, y, z, plate, rodzaj,car)	

	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		local carShow = GetDisplayNameFromVehicleModel(GetHashKey(car))
        ESX.ShowNotification('~r~Zgłoszono kradzież luksusowego pojazdu ~n~Zaznaczono na GPS')
		ESX.ShowNotification('~b~Tablica skradzionego pojazdu:~r~ '..plate)
		ESX.ShowNotification('~b~Typ pojazdu: ~r~'..rodzaj)
		ESX.ShowNotification('~b~Model: ~r~'..carShow)
		
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
		
		local blip = AddBlipForCoord(x, y, z)
		SetBlipSprite(blip, 225)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Kradziony pojazd')
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(90000)
        RemoveBlip(blip)
	end
end)


function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.37, 0.37)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 33, 33, 33, 133)
end


CreateThread(function()
	while true do 
		Citizen.Wait(4)
		local a=GetEntityCoords(PlayerPedId(),false)
		local b=Vdist(a.x,a.y,a.z,startingPoint.x,startingPoint.y,startingPoint.z)
		local c=Vdist(a.x,a.y,a.z,etap1dziupla.x,etap1dziupla.y,etap1dziupla.z)
		if b<=25.0 or c<=25.0 then 
			if AktywnyEtap1==0 and AktywnyEtap23==0 then 
				ESX.DrawMarker(vec3(startingPoint.x,startingPoint.y,startingPoint.z-0.97))
			end 
		else 
			Citizen.Wait(1500)
		end;
		if b<=1.3 and AktywnyEtap1==0 and AktywnyEtap23==0 or zrobiony1 then 
			DrawText3D(startingPoint.x,startingPoint.y,startingPoint.z,"Wciśnij ~b~[E]~w~ aby wybrać etap")
			if IsControlJustPressed(0,Keys['E'])then
				menuEtap()
				Citizen.Wait(500)
			end 
		end;
		if AktywnyEtap1==1 then 
			if c<=25.0 then 
				ESX.DrawMarker(vec3(etap1dziupla.x,etap1dziupla.y,etap1dziupla.z-0.38))
			else 
				Citizen.Wait(1500)
			end;
		end
		if c<=2.3 then 
			DrawText3D(etap1dziupla.x,etap1dziupla.y,etap1dziupla.z,"Wciśnij ~b~[E]~w~ aby przekazać pojazd do garażu")
			if IsControlJustPressed(0,Keys['E'])then 
				DziuplaCheck()
				Citizen.Wait(500)
			end
		end
	end 
end)


function menuEtap()
ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'tostMenu',
	{
		title    = 'Wybierz etap',
		align    = 'center',
		elements = {
			{label = '<font color=lightblue>1 | <font color=white>Wyrób fałszywe dokumenty', value = 'tost1'},
			{label = '<font color=lightblue>2 | <font color=white>Lakier i nadajnik', value = 'tost2'},
			{label = '<font color=lightblue>3 | <font color=white>Kradzież i szybka podmiana', value = 'tost3'}
		}
	},
	function(data2, menu2)
		PlaySoundFrontend(-1, "Whoosh_1s_L_to_R", "MP_LOBBY_SOUNDS", 0,0,1)
		menu2.close()
		
		if data2.current.value == 'tost1' then
		
			if AktywnyEtap1 == 1 then
				ESX.ShowNotification('~r~Już masz aktywny ETAP 1.')
				return
			else
				AktywnyEtap1 = 1
				local carlosuj = math.random(1,4)
				if carlosuj == 1 then
					carName = 'emperor2'
				elseif carlosuj == 2 then
					carName = 'surfer2'
				elseif carlosuj == 3 then
					carName = 'issi2'
				elseif carlosuj == 4 then
					carName = 'primo'
				end
			
				carShow = GetDisplayNameFromVehicleModel(GetHashKey(carName))
				ESX.ShowAdvancedNotification('~b~~h~ROZPOCZYNASZ ETAP 1', 'Podrób dokumenty', 'Proponuje abyś ukradł z ulicy pojazd ~b~'..carShow.. '~w~ i dostarczył go do dziupli.')
		end
		
		elseif data2.current.value == 'tost2' then
			ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
				if MisiaczekPlayers then
					if MisiaczekPlayers['police'] >= potrzebniPolicjanci then
						AktywnyEtap23 = 1
						ESX.ShowAdvancedNotification('~b~~h~ROZPOCZYNASZ ETAP 2', "Akcja Benny's", 'Udaj się do mechanika ~b~Bennego ~w~aby ukraść puszkę farby.~b~Zaznaczono na GPS')
						misjaBlip = AddBlipForCoord(lakierCoords.x,lakierCoords.y, lakierCoords.z)
						SetBlipSprite(misjaBlip, 66)
						SetBlipDisplay(misjaBlip, 4)
						SetBlipScale(misjaBlip, 1.0)
						SetBlipColour(misjaBlip, 1)
						SetBlipAsShortRange(misjaBlip, true)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString('Ukradnij farbe')
						EndTextCommandSetBlipName(misjaBlip)
						KradziezLakieru()
					else
						ESX.ShowNotification('~r~Potrzeba ' .. potrzebniPolicjanci .. ' policjantów aby rozpocząć ETAP 2!')
					end
				end
			end)
				
		elseif data2.current.value == 'tost3' then
			TriggerServerEvent("tostauto:sprawdzLspdNaKoniec")
		end
	end, function(data2, menu2)
		menu2.close()
	end)
end



function KradziezLakieru()
	SetNewWaypoint(lakierCoords.x,lakierCoords.y)
	local a=true;
	while a do 
		Citizen.Wait(2)
		local b=GetEntityCoords(PlayerPedId(),false)
		local c=Vdist(b.x,b.y,b.z,lakierCoords.x,lakierCoords.y,lakierCoords.z)
		if c<=20.0 then 
			ESX.DrawMarker(vec3(lakierCoords.x,lakierCoords.y,lakierCoords.z-0.97))
		else Citizen.Wait(1000)
		end;
		if c<=1.5 then 
			DrawText3D(lakierCoords.x,lakierCoords.y,lakierCoords.z,"[E] ~b~Ukradnij lakier samochodowy")
			if IsControlJustPressed(0,Keys['E']) then 
				local d=0;
				local e=true;
				TaskStartScenarioInPlace(PlayerPedId(),"CODE_HUMAN_MEDIC_KNEEL",0,false)
				FreezeEntityPosition(PlayerPedId(),true)
				while e do 
					Citizen.Wait(2)
					d=d+0.05;
					DrawText3D(lakierCoords.x,lakierCoords.y,lakierCoords.z,"Trwa kradzież: ~b~"..math.floor(d)..'%')
					if d>=100 then 
						e=false;
						a=false 
					end 
				end;
				Citizen.Wait(500)
			end 
		end 
	end;
	FreezeEntityPosition(PlayerPedId(),false)
	ClearPedTasks(PlayerPedId())
	RemoveBlip(misjaBlip)
	TriggerServerEvent("tostukrad:ukonczonoetap",'etap2')
				
	TriggerEvent("tostauto:kradziezLspd")
end

function ZakupNadajnik()
	ESX.ShowNotification('~b~Teraz udaj się do Paleto aby zakupić nowy nadajnik do samochodu')
	SetNewWaypoint(nadajnikCoords.x,nadajnikCoords.y)
	misjaBlip=AddBlipForCoord(nadajnikCoords.x,nadajnikCoords.y,nadajnikCoords.z)
	SetBlipSprite(misjaBlip,66)
	SetBlipDisplay(misjaBlip,4)
	SetBlipScale(misjaBlip,1.0)
	SetBlipColour(misjaBlip,1)
	SetBlipAsShortRange(misjaBlip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Zakup nadajnik')
	EndTextCommandSetBlipName(misjaBlip)
	kupNadajnika=true;
	while kupNadajnika do 
		Citizen.Wait(2)
		local a=GetEntityCoords(PlayerPedId(),false)
		local b=Vdist(a.x,a.y,a.z,nadajnikCoords.x,nadajnikCoords.y,nadajnikCoords.z)
		if b<=80.0 then 
			if not DoesEntityExist(sprzedawczyk)then 
				RespSellera()
			end 
		end;
		if b<=20.0 then 
			ESX.DrawMarker(vec3(nadajnikCoords.x,nadajnikCoords.y,nadajnikCoords.z-0.97))
		else 
			Citizen.Wait(1000)
		end;
		if b<=1.5 then
			DrawText3D(nadajnikCoords.x,nadajnikCoords.y,nadajnikCoords.z,"[E] ~b~Zakup nowy nadajnik ~r~("..CenaNadajnika.."$)")
			if IsControlJustPressed(0,Keys['E'])then 
				RemoveBlip(misjaBlip)
				TriggerServerEvent("tostukrad:ukonczonoetap",'etap21')
				AktywnyEtap23=0;
				Citizen.Wait(500)
			end 
		end 
	end 
end


RegisterNetEvent('tostauto:udanyZakupNadajnika')
AddEventHandler('tostauto:udanyZakupNadajnika', function()	
	ClearPedTasks(sprzedawczyk)
	TaskWanderStandard(sprzedawczyk,10.0,10)
	SetEntityAsNoLongerNeeded(sprzedawczyk)
	kupNadajnika = false
end)

RegisterNetEvent('tostauto:doneEtap2')
AddEventHandler('tostauto:doneEtap2', function()	
	PowiadomPsy('1')
	ZakupNadajnik()
end)

function RespSellera()
	RequestModel("u_m_m_jewelsec_01")
	while not HasModelLoaded("u_m_m_jewelsec_01") do
		Wait(10)
	end
	sprzedawczyk = CreatePed(26, "u_m_m_jewelsec_01", respSelleraNadajnikow.x, respSelleraNadajnikow.y, respSelleraNadajnikow.z, 29.38, false, false)
    SetEntityHeading(sprzedawczyk, 241.0)
    TaskStartScenarioInPlace(sprzedawczyk, "WORLD_HUMAN_GUARD_STAND", 0, false)
    Citizen.Wait(5000)
end


CreateThread(function()
    while true do
        Citizen.Wait(1500)
		if AktywnyEtap1 == 1 then
			ESX.ShowNotification('~b~Ukradnij: ~b~'..carShow..'~n~~b~I dostarcz do dziupli')
			SetNewWaypoint(etap1dziupla.x,etap1dziupla.y)
		else
			Citizen.Wait(2500)
		end		
	end
end)

function DziuplaCheck()
	local a=GetVehiclePedIsIn(PlayerPedId(),false)
	local b=GetEntityModel(a)
	local c=GetDisplayNameFromVehicleModel(b)
	local d=GetEntityCoords(a)
	if IsPedInAnyVehicle(PlayerPedId())then 
		if c==carShow then 
			FreezeEntityPosition(a,true)
			SetVehicleDoorsLockedForAllPlayers(a,true)
			TaskLeaveAnyVehicle(PlayerPedId())
			SetEntityHeading(a,211.0)
			prcn=0;
			local e=1;
			while e==1 do 
				Citizen.Wait(5)
				prcn=prcn+0.05;
				DrawText3D(d.x,d.y,d.z+0.2,"Proces fałszowania: ~b~"..math.floor(prcn)..'%')
				if prcn>=100 then 
					e=0 
				end 
			end;
			ESX.ShowNotification('~g~Wszystko gotowe, otrzymujesz podrobiony dowód rejestracyjny i tablice.')
			TriggerServerEvent("tostukrad:ukonczonoetap",'etap1')
			AktywnyEtap1=0
			zrobiony1 = true
			RequestModel("g_m_m_armgoon_01")
			while not HasModelLoaded("g_m_m_armgoon_01")do 
				Wait(10)
			end;
			local f=CreatePed(26,"g_m_m_armgoon_01",ziomekCoord.x,ziomekCoord.y,ziomekCoord.z,268.9422,true,true)
			SetBlockingOfNonTemporaryEvents(f,true)
			SetEntityInvincible(f,true)
			FreezeEntityPosition(a,false)
			TaskEnterVehicle(f,a,10000,-1,1.0,1,false)
			while not IsPedInVehicle(f,a,false)do 
				Citizen.Wait(200)
			end;
			Citizen.Wait(500)
			TaskVehicleDriveWander(f,a,60.0,536871299)
			Citizen.Wait(35000)
			DeleteEntity(a)
			DeleteEntity(f)
			Citizen.Wait(15000)
		else 
			ESX.ShowNotification('~r~To nie ten pojazd!')
		end 
	else 
		ESX.ShowNotification('~r~Musisz być w pojeździe!')
	end 
end


RegisterNetEvent('tostauto:pozwolWykonacKradziezKoncowa')
AddEventHandler('tostauto:pozwolWykonacKradziezKoncowa', function()	
	local farbaQ = nil
	local nadajnikQ = nil
	local rejestracjaQ = nil
	local dokumentacjaQ = nil

	local inventory = ESX.GetPlayerData().inventory

	for i=1, #inventory, 1 do
		if inventory[i].name == 'carfarba' then
		farbaQ = inventory[i].count
		end
		if inventory[i].name == 'carnadajnik' then
		nadajnikQ = inventory[i].count
		end
		if inventory[i].name == 'carrej' then
		rejestracjaQ = inventory[i].count
		end
		if inventory[i].name == 'cardok' then
		dokumentacjaQ = inventory[i].count
		end
	end

	if farbaQ > 0 then
		if nadajnikQ > 0 then
			if rejestracjaQ > 0 then
				if dokumentacjaQ > 0 then
					AktywnyEtap23 = 1
					ESX.ShowNotification('~b~~h~ROZPOCZYNASZ ETAP 3')
					MisjaKradziezFury()
				else
					ESX.ShowNotification('~r~Nie masz podrobionej dokumentacji!')
				end
			else
				ESX.ShowNotification('~r~Nie masz podrobionej tablicy rejestracyjnej!')
			end
		else
			ESX.ShowNotification('~r~Nie masz nadajnika na podmiankę!')
		end
	else
		ESX.ShowNotification('~r~Nie masz farby aby przemalować kradziony pojazd!')
	end

end)

function MisjaKradziezFury()
    misjaBlip = AddBlipForCoord(noweAutoCoords.x, noweAutoCoords.y, noweAutoCoords.z)
    SetBlipSprite(misjaBlip, 66)
    SetBlipDisplay(misjaBlip, 4)
    SetBlipScale(misjaBlip, 1.0)
    SetBlipColour(misjaBlip, 1)
    SetBlipAsShortRange(misjaBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ukradnij pojazd")
    EndTextCommandSetBlipName(misjaBlip)
    ESX.ShowNotification("~g~Udaj się w zaznaczone miejsce, pozbądź się gangu i zawiń pojazd!")
    SetNewWaypoint(noweAutoCoords.x, noweAutoCoords.y)
    local a = true
    while a do
        Citizen.Wait(2)
        local b = GetEntityCoords(PlayerPedId(), false)
        local c = Vdist(b.x, b.y, b.z, noweAutoCoords.x, noweAutoCoords.y, noweAutoCoords.z)
        if c <= 130.0 then
            a = false
        else
            Citizen.Wait(1000)
        end
    end
    RequestModel(`g_m_y_mexgang_01`)
    while not HasModelLoaded(`g_m_y_mexgang_01`) do
        Wait(1)
    end
    local d = CreatePed(9, "g_m_y_mexgang_01", gang2Coords.x, gang2Coords.y, gang2Coords.z, 0.0, true, true)
    Citizen.InvokeNative(0xBF0FD6E56C964FCB, d, `WEAPON_PISTOL`, 250, false, true)
    TaskAimGunAtCoord(d, 0, 0, 0, 100, 0, 0)
    SetPedAsCop(d, true)
    Citizen.InvokeNative(0xCEA04D83135264CC, d, 100)
    SetPedSeeingRange(d, 50.0)
    SetPedHearingRange(d, 50.0)
    Citizen.Wait(500)
    local e = GetEntityCoords(d)
    TaskWanderInArea(d, e.x, e.y, e.z, 6.5, 1.0, 1.0)
    local f = CreatePed(9, "g_m_y_mexgang_01", gang3Coords.x, gang3Coords.y, gang3Coords.z, 0.0, true, true)
    Citizen.InvokeNative(0xBF0FD6E56C964FCB, f, `WEAPON_PISTOL`, 250, false, true)
    TaskAimGunAtCoord(f, 0, 0, 0, 100, 0, 0)
    SetPedAsCop(f, true)
    Citizen.InvokeNative(0xCEA04D83135264CC, f, 100)
    SetPedSeeingRange(f, 50.0)
    SetPedHearingRange(f, 50.0)
    Citizen.Wait(500)
    local e = GetEntityCoords(f)
    TaskWanderInArea(f, e.x, e.y, e.z, 6.5, 1.0, 1.0)
    local g = CreatePed(9, "g_m_y_mexgang_01", gang4Coords.x, gang4Coords.y, gang4Coords.z, 0.0, true, true)
    Citizen.InvokeNative(0xBF0FD6E56C964FCB, g, `WEAPON_PISTOL50`, 250, false, true)
    TaskAimGunAtCoord(g, 0, 0, 0, 100, 0, 0)
    SetPedAsCop(g, true)
    Citizen.InvokeNative(0xCEA04D83135264CC, g, 100)
    SetPedSeeingRange(g, 50.0)
    SetPedHearingRange(g, 50.0)
    Citizen.Wait(500)
    local e = GetEntityCoords(g)
    TaskWanderInArea(g, e.x, e.y, e.z, 6.5, 1.0, 1.0)
    local d = CreatePed(9, "g_m_y_mexgang_01", gang5Coords.x, gang5Coords.y, gang5Coords.z, 0.0, true, true)
    Citizen.InvokeNative(0xBF0FD6E56C964FCB, d, `WEAPON_APPISTOL`, 250, false, true)
    TaskAimGunAtCoord(d, 0, 0, 0, 100, 0, 0)
    SetPedAsCop(d, true)
    Citizen.InvokeNative(0xCEA04D83135264CC, d, 100)
    SetPedSeeingRange(d, 50.0)
    SetPedHearingRange(d, 50.0)
    Citizen.Wait(500)
    local e = GetEntityCoords(d)
    TaskWanderInArea(d, e.x, e.y, e.z, 6.5, 1.0, 1.0)
    local modelcar = randomCar[math.random(#randomCar)]
    RequestModel(GetHashKey(modelcar))
    while not HasModelLoaded(GetHashKey(modelcar)) do
        Wait(1)
    end
    AutoKradzione =
        CreateVehicle(
        GetHashKey(modelcar),
        noweAutoCoords.x,
        noweAutoCoords.y,
        noweAutoCoords.z,
        -2.436,
        996.786,
        25.1887,
        true,
        true
    )
    SetEntityAsMissionEntity(AutoKradzione)
    SetEntityHeading(AutoKradzione, 52.00)
    oznaczenie = AddBlipForEntity(AutoKradzione)
    SetBlipSprite(AutoKradzione, 57)
    SetBlipColour(AutoKradzione, 1)
    SetBlipFlashes(AutoKradzione, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Auto do kradziezy")
    EndTextCommandSetBlipName(AutoKradzione)
    local i = true
    RemoveBlip(misjaBlip)
    while i do
        Citizen.Wait(100)
        local b = GetEntityCoords(PlayerPedId(), false)
        local c = Vdist(b.x, b.y, b.z, noweAutoCoords.x, noweAutoCoords.y, noweAutoCoords.z)
        if c <= 20.0 then
            Citizen.InvokeNative(0xF166E48407BAC484, d, PlayerPedId(), 0, 16)
            Citizen.InvokeNative(0xF166E48407BAC484, g, PlayerPedId(), 0, 16)
            Citizen.InvokeNative(0xF166E48407BAC484, f, PlayerPedId(), 0, 16)
        end
        if IsPedInVehicle(PlayerPedId(), AutoKradzione, false) then
            i = false
        end
    end
    tablicastara = 0
    nadajnikstary = 0
    kolorstary = 0
    SetEntityAsNoLongerNeeded(f)
    SetEntityAsNoLongerNeeded(g)
    SetEntityAsNoLongerNeeded(d)
    PowiadomPsy("2")
    ESX.ShowNotification("~b~Policja juz wie o twojej kradzieży, udaj się w ustronne miejsce.")
    ESX.ShowNotification("~b~Aby przemalować pojazd, zmienić nadajnik i tablice.")
    local j = true
    while j do
        Citizen.Wait(2)
        if tablicastara == 1 and nadajnikstary == 1 and kolorstary == 1 then
            j = false
        end
        local k = GetEntityCoords(PlayerPedId())
        DrawText3D(k.x, k.y, k.z, "[E] ~b~Aby przerobić pojazd")
        if IsControlJustPressed(0, Keys["E"]) then
            if IsPedInAnyVehicle(PlayerPedId()) then
                ESX.ShowNotification("~b~Wyjdz z pojazdu aby to zrobić.")
            else
                local l = GetEntityCoords(AutoKradzione)
                local b = GetEntityCoords(PlayerPedId(), false)
                local c = Vdist(b.x, b.y, b.z, l.x, l.y, l.z)
                if c <= 2.0 then
                    PrzerobPojazdKradziony()
                else
                    ESX.ShowNotification("~b~Podejdz blizej do pojazdu.")
                end
            end
        end
    end
    ESX.ShowNotification("~b~Skutecznie przerobiles pojazd, udaj się do znacznika aby go sprzedać.")
    SetNewWaypoint(koncowyGaraz.x, koncowyGaraz.y)
    local m = true
    while m do
        Citizen.Wait(2)
        local b = GetEntityCoords(PlayerPedId(), false)
        local n = Vdist(b.x, b.y, b.z, koncowyGaraz.x, koncowyGaraz.y, koncowyGaraz.z)
        if n <= 25.0 then
            ESX.DrawBigMarker(vec3(koncowyGaraz.x,koncowyGaraz.y,koncowyGaraz.z-0.97))
        else
            Citizen.Wait(1000)
        end
        if n <= 2.0 then
            local o = GetVehiclePedIsIn(PlayerPedId(), false)
            if o == AutoKradzione then
                m = false
            else
                ESX.ShowNotification("~b~To nie ten pojazd.")
            end
        end
    end
    TriggerServerEvent("exile_carholdup:sellVehicle")
    Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
    DeleteEntity(AutoKradzione)
    Citizen.Wait(500)
end



function PrzerobPojazdKradziony()
	if tablicastara==0 then 
		tablicastara=1;
		ESX.ShowNotification('~b~Zakladasz kradzioną tablice')
		TaskStartScenarioInPlace(PlayerPedId(),"CODE_HUMAN_MEDIC_KNEEL",0,false)
		FreezeEntityPosition(PlayerPedId(),true)
		procenty=0;
		local a=true;
		local b=GetEntityCoords(PlayerPedId())
		local c=ESX.GetPlayerData().inventory;
		for d=1,#c,1 do 
			if c[d].name=='carrej'then 
				farbaQ=c[d].count 
			end;
			if c[d].name=='cardok'then 
				dokumentacjaQ=c[d].count 
			end 
		end;
		if farbaQ<1 then 
			ESX.ShowNotification('~r~Nie masz tablicy!!')
			tablicastara=0;
			FreezeEntityPosition(PlayerPedId(),false)
			return 
		end
		if dokumentacjaQ<1 then 
			ESX.ShowNotification('~r~Nie masz dokumentacji!!')
			tablicastara=0;
			FreezeEntityPosition(PlayerPedId(),false)
			return 
		end;
		TriggerServerEvent("tostauto:przerobilSkasujitem",'tablica')
		while a do 
			Citizen.Wait(2)
			procenty=procenty+0.15;
			DrawText3D(b.x,b.y,b.z,"Zakladasz tablice: ~b~"..math.floor(procenty)..'%')
			if procenty>=100 then 
				a=false 
			end 
		end;
		ClearPedTasks(PlayerPedId())
		FreezeEntityPosition(PlayerPedId(),false)
		ESX.ShowNotification('~b~Tablica zalozona, przechodzień zgłosił twoją aktywność na policje!')
		SetVehicleNumberPlateText(AutoKradzione,'SEX'..math.random(1111,8888))
		PowiadomPsy('3')
	elseif nadajnikstary==0 then 
		nadajnikstary=1;
		ESX.ShowNotification('~b~Zakladasz nowy nadajnik')
		TaskStartScenarioInPlace(PlayerPedId(),"CODE_HUMAN_MEDIC_KNEEL",0,false)
		FreezeEntityPosition(PlayerPedId(),true)
		procenty=0;
		local a=true;
		local b=GetEntityCoords(PlayerPedId())
		local c=ESX.GetPlayerData().inventory;
		for d=1,#c,1 do 
			if c[d].name=='carnadajnik'then 
				nadajnikQ=c[d].count 
			end 
		end;
		if nadajnikQ<1 then 
			ESX.ShowNotification('~r~Nie masz nadajnika!!')
			nadajnikstary=0;
			FreezeEntityPosition(PlayerPedId(),false)
			return 
		end;
		TriggerServerEvent("tostauto:przerobilSkasujitem",'tablica')
		TriggerServerEvent("tostauto:przerobilSkasujitem",'dok')
		while a do 
			Citizen.Wait(2)
			procenty=procenty+0.08;
			DrawText3D(b.x,b.y,b.z,"Zakladasz nadajnik: ~b~"..math.floor(procenty)..'%')
			if procenty>=100 then 
				a=false 
			end 
		end;
		ClearPedTasks(PlayerPedId())
		FreezeEntityPosition(PlayerPedId(),false)
		ESX.ShowNotification('~b~Nadajnik zalozony, przechodzień zgłosił twoją aktywność na policję!')
		PowiadomPsy('3')
	elseif kolorstary==0 then 
		kolorstary=1;
		ESX.ShowNotification('~b~Malujesz pojazd')
		TaskStartScenarioInPlace(PlayerPedId(),"CODE_HUMAN_MEDIC_KNEEL",0,false)
		FreezeEntityPosition(PlayerPedId(),true)
		procenty=0;
		local a=true;
		local b=GetEntityCoords(PlayerPedId())
		local c=ESX.GetPlayerData().inventory;
		for d=1,#c,1 do 
			if c[d].name=='carfarba'then 
				farbaQ=c[d].count 
			end 
		end;
		if farbaQ<1 then 
			ESX.ShowNotification('~r~Nie masz farby!!')
			kolorstary=0;
			FreezeEntityPosition(PlayerPedId(),false)
			return 
		end;
		TriggerServerEvent("tostauto:przerobilSkasujitem",'farba')
		while a do 
			Citizen.Wait(2)
			procenty=procenty+0.05;
			DrawText3D(b.x,b.y,b.z,"Lakierujesz pojazd: ~b~"..math.floor(procenty)..'%')
			if procenty>=100 then 
				a=false 
			end 
		end;
		ClearPedTasks(PlayerPedId())
		FreezeEntityPosition(PlayerPedId(),false)
		ESX.ShowNotification('~b~Pojazd pomalowany, przechodzień zgłosił twoją aktywność na policję!')
		SetVehicleColours(AutoKradzione,math.random(50,165),math.random(50,165))
		PowiadomPsy('3')
	end 
end
