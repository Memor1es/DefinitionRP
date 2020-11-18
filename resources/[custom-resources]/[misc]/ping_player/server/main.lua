ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)
	end
end)

RegisterServerEvent('ping')
AddEventHandler('ping', function(target)
	local _src = source
	if target ~= nil then
		if target:lower() == 'accept' then
			TriggerClientEvent('mythic_ping:client:AcceptPing', _src)
		elseif target:lower() == 'reject' then
			TriggerClientEvent('mythic_ping:client:RejectPing', _src)
		elseif target:lower() == 'remove' then
			TriggerClientEvent('mythic_ping:client:RemovePing', _src)
		else
			local tSrc = tonumber(target)
			if tSrc ~= nil then
				if _src ~= tSrc then
					GetRPName(_src, function(name)
						TriggerClientEvent('mythic_ping:client:SendPing', tSrc, name, _src)
					end)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _src, { type = 'inform', text = 'Can\'t Ping Yourself' })
				end
			end
		end
	end
end) 

function GetRPName(playerId, cb)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		cb(result[1].firstname.." "..result[1].lastname)
	end)
end

RegisterServerEvent('mythic_ping:server:SendPingResult')
AddEventHandler('mythic_ping:server:SendPingResult', function(id, result)
	local _src = source
	GetRPName(_src, function(name)
		if result == 'accept' then
			TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = name .. ' Accepted Your Ping' })
		elseif result == 'reject' then
			TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = name .. ' Rejected Your Ping' })
		elseif result == 'timeout' then
			TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = name .. ' Did Not Accept Your Ping' })
		elseif result == 'unable' then
			TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = name .. ' Was Unable To Receive Your Ping' })
		elseif result == 'received' then
			TriggerClientEvent('mythic_notify:client:SendAlert', id, { type = 'inform', text = 'You Sent A Ping To ' .. name })
		end
	end)
end)
