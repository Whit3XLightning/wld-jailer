RegisterCommand('jail', function(source, args, rawCommand)
	if #args == 2 then
		local jailsource = tonumber(args[1])
		TriggerClientEvent("wld-jailer:jail", jailsource, tonumber(args[2])) --had to "tonumber()" to args
		TriggerClientEvent('chat:addMessage', -1, {color={255,102,0},multiline=true,args={"[JAIL]",GetPlayerName(args[1]).." was jailed for "..args[2].." seconds by "..GetPlayerName(source)}})
	else
		TriggerClientEvent('chat:addMessage', -1, {color={255,102,0},multiline=true,args={"[JAIL]","Please use the correct syntx"}})
	end
end, true)

RegisterCommand('unjail', function(source, args, rawCommand)
	if #args == 1 then
		local unjailsource = tonumber(args[1])
		TriggerClientEvent('wld-jailer:unjail', unjailsource)
		TriggerClientEvent('chat:addMessage', -1, {color={255,102,0},multiline=true,args={"[JAIL]",GetPlayerName(args[1]).." was unjailed by "..GetPlayerName(source)}})
	else
		TriggerClientEvent('chat:addMessage', -1, {color={255,102,0},multiline=true,args={"[JAIL]","Please use the correct syntx."}})
	end
end, true)

RegisterServerEvent('wld-jailer:unjailed')
AddEventHandler('wld-jailer:unjailed', function()
	TriggerClientEvent('chat:addMessage', -1, {color={255,102,0},multiline=true,args={"[JAIL]",GetPlayerName(source).." was released from jail!"}})
end)
