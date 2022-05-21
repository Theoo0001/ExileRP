local keyboardCallback = nil
AddEventHandler('misiaczek:keyboard', function(cbk, params)
	local data = {
		title = 'Wpisz tekst:',
		type = 'text',
		limit = 255,
		value = '',
		show = true
	}
	for k, v in pairs(params) do
		data[k] = v
	end

	local tmp = keyboardCallback
	keyboardCallback = cbk

	SendNUIMessage(data)
	if not tmp then
		SetNuiFocus(true, true)
	end
end)

RegisterNUICallback('keyboardSubmit', function(data, cbn)
	local tmp = keyboardCallback

	keyboardCallback(data.value)
	if tmp == keyboardCallback then
		keyboardCallback = nil
		SetNuiFocus(false, false)
	end

	cbn('ok')
end)

RegisterNUICallback('keyboardCancel', function(data, cbn)
	local tmp = keyboardCallback

	keyboardCallback(nil)
	if tmp == keyboardCallback then
		keyboardCallback = nil
		SetNuiFocus(false, false)
	end

	cbn('ok')
end)

CreateThread(function()
	SetNuiFocus(false, false)
end)

AddEventHandler('onClientResourceStart', function (resourceName)
	if GetCurrentResourceName() == resourceName then
		SetNuiFocus(false, false)
	end
end)