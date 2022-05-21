phone = false
phoneId = 0

RegisterNetEvent('camera:open')
AddEventHandler('camera:open', function()
    CreateMobilePhone(1)
	CellCamActivate(true, true)
	phone = true
    PhonePlayOut()
	ESX.UI.HUD.SetDisplay(0.0)
	TriggerEvent('es:setMoneyDisplay', 0.0)
	TriggerEvent('esx_status:setDisplay', 0.0)
	TriggerEvent('esx_voice:setDisplay', 0.0)
	TriggerEvent('radar:setHidden', true)
	TriggerEvent('chat:display', false)
	TriggerEvent('carhud:display', false)
end)

function closeCamera()
	DestroyMobilePhone()
	PhonePlayOut()
	phone = false

	ESX.UI.HUD.SetDisplay(1.0)
	TriggerEvent('es:setMoneyDisplay', 1.0)
	TriggerEvent('esx_status:setDisplay', 1.0)
	TriggerEvent('esx_voice:setDisplay', 1.0)
	TriggerEvent('radar:setHidden', false)
	TriggerEvent('chat:display', true)
	TriggerEvent('carhud:display', true)

	CellCamActivate(false, false)
	Citizen.Wait(1000)
	TooglePhone(false)
	PhonePlayIn()
end

local frontCam = false

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

CreateThread(function()
	DestroyMobilePhone()
	while true do
		Citizen.Wait(0)
		if phone then
			if IsControlJustPressed(1, 177) then -- CLOSE PHONE
				closeCamera()
			end
			
			if IsControlJustPressed(1, 27) then -- SELFIE MODE
				frontCam = not frontCam
				CellFrontCamActivate(frontCam)
			end
				
			if phone == true then
				HideHudComponentThisFrame(7)
				HideHudComponentThisFrame(8)
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(19)
				HideHudAndRadarThisFrame()
			end
				
			ren = GetMobilePhoneRenderId()
			SetTextRenderId(ren)
			
			-- Everything rendered inside here will appear on your phone.
			
			SetTextRenderId(1) -- NOTE: 1 is default
		else
			Citizen.Wait(250)
		end
	end
end)