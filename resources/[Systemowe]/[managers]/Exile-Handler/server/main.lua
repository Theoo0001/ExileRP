local lastban


function doesPlayerHavePerms(player, type)
    if IsPlayerAceAllowed(player, 'easyadmin.'..type) then
		return true
	end
    return false
end


AddEventHandler('playerConnecting', function (playerName,setKickReason, deferrals)
	local identifier    = nil
	local license       = nil
	local playerip      = nil
	local playerdiscord = nil
	local liveid        = nil
	local xbl 			= nil
	local nazwa         = GetPlayerName(source)
	local hwid = {}
	for i=0,GetNumPlayerTokens(source) do
		table.insert(hwid, GetPlayerToken(source, i))
	end

	for k,v in pairs(GetPlayerIdentifiers(source))do   
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			playerdiscord = v
		end
	end
	
	if playerip == nil then
		playerip = GetPlayerEndpoint(source)
		if playerip == nil then
			playerip = 'nie ma'
		end
	end
	if playerdiscord == nil then
		playerdiscord = 'nie ma'
	end
	if liveid == nil then
		liveid = 'nie ma'
	end
	if xbl == nil then
		xbl = 'nie ma'
	end

    if identifier == false then
		setKickReason('Aby zagrać na naszej wyspie, musisz posiadać włączonego steama!')
		CancelEvent()
    end
end)