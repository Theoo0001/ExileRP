local mutedPlayers = {}

-- we can't use GetConvarInt because its not a integer, and theres no way to get a float... so use a hacky way it is!
local volumes = {
	-- people are setting this to 1 instead of 1.0 and expecting it to work.
	['radio'] = GetConvarInt('voice_defaultRadioVolume', 30) / 100,
	['phone'] = GetConvarInt('voice_defaultPhoneVolume', 60) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}
local barVisible = true
local oldhud = false
RegisterNetEvent("csskrouble:oldHud", function(m) 
	oldhud = m
end)
CreateThread(function()
	while true do
		Citizen.Wait(1)

		if barVisible and oldhud then
			local playerCallSpeaker = false
			local color = { 255, 255, 255 }
			local size = 0.069

			if IsControlPressed(0, 249) then
				color = {255, 0, 0}
			end

			if Cfg.voiceModes[mode][2] == 'Whisper' then
				size = size / 4
			elseif Cfg.voiceModes[mode][2] == 'Normal' then
				size = size / 2
			end

			DrawRct(0.085, 0.985, 0.0705, 0.0125, 0, 0, 0, 120)
			DrawRct(0.0865, 0.985, size, 0.01, color[1], color[2], color[3], 70)

			if callChannel ~= 0 then
				DrawSprite('mpleaderboard', 'leaderboard_friends_icon', 0.15, 0.991, 0.012, 0.022, 0.0, 255, 255, 255, 255)

				if playerCallSpeaker then
					DrawSprite('mpleaderboard', 'leaderboard_plus_icon', 0.14, 0.991, 0.012, 0.022, 0.0, 255, 255, 255, 255)
				end
			elseif playerRadioActive then
				DrawSprite('mpleaderboard', 'leaderboard_audio_3', 0.15, 0.991, 0.012, 0.022, 0.0, 255, 255, 255, 255)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_status:setDisplay', function(val)
	barVisible = tonumber(val) ~= 0.0
end)

function DrawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

--- function setVolume
--- Toggles the players volume
---@param volume number between 0 and 100
---@param volumeType string the volume type (currently radio & call) to set the volume of (opt)
function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume / 100
	
	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		-- _ is here to not mess with global 'type' function
		for _type, vol in pairs(volumes) do
			volumes[_type] = volume
			LocalPlayer.state:set(_type, volume, true)
		end
	end
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'phone')
end)
exports('getCallVolume', function()
	return volumes['phone']
end)


-- default submix incase people want to fiddle with it.
-- freq_low = 389.0
-- freq_hi = 3248.0
-- fudge = 0.0
-- rm_mod_freq = 0.0
-- rm_mix = 0.16
-- o_freq_lo = 348.0
-- 0_freq_hi = 4900.0

if gameVersion == 'fivem' then
	radioEffectId = CreateAudioSubmix('Radio')
	SetAudioSubmixEffectRadioFx(radioEffectId, 0)
	SetAudioSubmixEffectParamInt(radioEffectId, 0, `default`, 1)
	AddAudioSubmixOutput(radioEffectId, 0)

	phoneEffectId = CreateAudioSubmix('Phone')
	SetAudioSubmixEffectRadioFx(phoneEffectId, 1)
	SetAudioSubmixEffectParamInt(phoneEffectId, 1, `default`, 1)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, `freq_low`, 300.0)
	SetAudioSubmixEffectParamFloat(phoneEffectId, 1, `freq_hi`, 6000.0)
	AddAudioSubmixOutput(phoneEffectId, 1)
end

local submixFunctions = {
	['radio'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, radioEffectId)
	end,
	['phone'] = function(plySource)
		MumbleSetSubmixForServerId(plySource, phoneEffectId)
	end
}

local tglRadioEffect = true
RegisterCommand('vol', function(_, args)
	if not args[1] then
		TriggerEvent("esx:showNotification", '~r~Podaj docelową głośność')
		return
	end	
	if not args[2] then
		TriggerEvent("esx:showNotification", '~r~Podaj typ voice w którym chcesz zmienić głośność, prawidłowe: ~w~radio, phone')
		return
	end	
	local volume = tonumber(args[1])
	local typee = args[2]
	if typee == "radio" or typee == "phone" then
		TriggerEvent("esx:showNotification", '~r~Zły typ voice! Prawidłowe: ~w~radio, phone')
		return
	end	
	if volume then
		setVolume(volume / 100, typee)
	end
end)

RegisterCommand('radioeffect', function(_, args)
	tglRadioEffect = not tglRadioEffect
	if tglRadioEffect then
		TriggerEvent("esx:showNotification", '~g~Włączyłeś efekt radia')
	else
		TriggerEvent("esx:showNotification", '~r~Wyłączyłeś efekt radia')
	end
end)

-- used to prevent a race condition if they talk again afterwards, which would lead to their voice going to default.
local disableSubmixReset = {}
--- function toggleVoice
--- Toggles the players voice
---@param plySource number the players server id to override the volume for
---@param enabled boolean if the players voice is getting activated or deactivated
---@param moduleType string the volume & submix to use for the voice.
function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	if enabled then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if tglRadioEffect then
			if moduleType then
				disableSubmixReset[plySource] = true
				submixFunctions[moduleType](plySource)
			else
				MumbleSetSubmixForServerId(plySource, -1)
			end
		end
	else
		if tglRadioEffect then
			-- garbage collect it
			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					MumbleSetSubmixForServerId(plySource, -1)
				end
			end)
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

--- function playerTargets
---Adds players voices to the local players listen channels allowing
---Them to communicate at long range, ignoring proximity range.
---@diagnostic disable-next-line: undefined-doc-param
---@param targets table expects multiple tables to be sent over
function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			-- we don't want to log ourself, or listen to ourself
			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

--- function playMicClicks
---plays the mic click if the player has them enabled.
---@param clickType boolean whether to play the 'on' or 'off' click. 
function playMicClicks(clickType)
	if micClicks ~= 'true' then return logger.verbose("Not playing mic clicks because client has them disabled") end
	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and volumes["radio"] or 0.05)
	})
end

--- toggles the targeted player muted
---@param source number the player to mute
function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end
exports('toggleMutePlayer', toggleMutePlayer)

--- function setVoiceProperty
--- sets the specified voice property
---@param type string what voice property you want to change (only takes 'radioEnabled' and 'micClicks')
---@param value any the value to set the type to.
function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
-- compatibility
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)


-- cache their external servers so if it changes in runtime we can reconnect the client.
local externalAddress = ''
local externalPort = 0
CreateThread(function()
	while true do
		Wait(500)
		-- only change if what we have doesn't match the cache
		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)


if gameVersion == 'redm' then
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, 0xA5BDCD3C --[[ Right Bracket ]]) then
				ExecuteCommand('cycleproximity')
			end
			if IsControlJustPressed(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('+radiotalk')
			elseif IsControlJustReleased(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('-radiotalk')
			end

			Wait(0)
		end
	end)
end