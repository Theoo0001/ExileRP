
ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('exile_blackout:dzwon')
AddEventHandler('exile_blackout:dzwon', function(list, damage)	
	local _source = source
	for i,v in ipairs(list) do
		TriggerClientEvent('exile_blackoutC:dzwonCb', v, damage)
	end
	
	TriggerClientEvent('exile_blackoutC:dzwonCb', _source, damage)
end)

RegisterServerEvent('exile_blackout:dzwonCb')
AddEventHandler('exile_blackout:dzwonCb', function(isDzwon, dmg) 
	local src = source
	if isDzwon then
		TriggerClientEvent('exile_blackout:dzwon', src, dmg)
	end	
end)	

RegisterServerEvent('exile_blackout:impact')
AddEventHandler('exile_blackout:impact', function(list, speedBuffer, velocityBuffer)
	local _source = source
	for i,v in ipairs(list) do
		TriggerClientEvent('exile_blackout:impact', v, speedBuffer, velocityBuffer)
	end
	
	TriggerClientEvent('exile_blackout:impact', _source, speedBuffer, velocityBuffer)
end)