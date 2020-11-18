ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("jail", function(src, args, raw)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]
		local jailTime = tonumber(args[2])
		local jailReason = args[3]

		if GetPlayerName(jailPlayer) ~= nil then
			GetRPName(jailPlayer, function(Firstname, Lastname)
				if jailTime ~= nil then
					JailPlayer(jailPlayer, jailTime)
				
					if args[3] ~= nil then
						TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "SUCCESS", text = Firstname.." "..Lastname.." has been jailed for "..jailTime.." months", length = 5000})
						--TriggerClientEvent('chat:addMessage', -1, { args = { "JUDGE",  Firstname .. " " .. Lastname .. " Is now in jail for the reason: " .. args[3] }, color = { 249, 166, 0 } })
					end
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "error", text = "Time is invalid", length = 5000})
				end
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "error", text = "PlayerID is not online", length = 5000})
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "error", text = "You are not a Law Enforcement Officer", length = 5000})
	end
end)

RegisterCommand("unjail", function(src, args)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]

		if GetPlayerName(jailPlayer) ~= nil then
			UnJail(jailPlayer)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "error", text = "PlayerID is not online", length = 5000})
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "error", text = "You are not a Law Enforcement Officer", length = 5000})
	end
end)

RegisterServerEvent("tp-qalle-jail:jailPlayer")
AddEventHandler("tp-qalle-jail:jailPlayer", function(targetSrc, jailTime, jailReason)
	local src = source
	local targetSrc = tonumber(targetSrc)
	local xPlayer = ESX.GetPlayerFromId(src)

	--JailPlayer(targetSrc, jailTime)
	if xPlayer["job"]["name"] == "police" then
		JailPlayer(targetSrc, jailTime)

	GetRPName(targetSrc, function(Firstname, Lastname)
		TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "SUCCESS", text = Firstname.." "..Lastname.." has been jailed for "..jailTime.." months", length = 5000})
		--TriggerClientEvent('chat:addMessage', -1, { args = { "JUDGE",  Firstname .. " " .. Lastname .. " Is now in jail for the reason: " .. jailReason }, color = { 249, 166, 0 } })
	end)

	else
		return TriggerEvent('banCheater', src, "Well what a fuckwit you are..... 😈") --xPlayer.kick("😈 Bad!")
	end
end)

RegisterServerEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function(targetIdentifier)
	local src = source
	local xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)

	if xPlayer ~= nil then
		UnJail(xPlayer.source)
	else
		MySQL.Async.execute(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
	end
	GetRPName(targetSrc, function(Firstname, Lastname)
		TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "success", text = Firstname.." "..Lastname.." has been unjailed", length = 5000})
	end)
end)

RegisterServerEvent("esx-qalle-jail:updateJailTime")
AddEventHandler("esx-qalle-jail:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

RegisterServerEvent("esx-qalle-jail:prisonWorkReward")
AddEventHandler("esx-qalle-jail:prisonWorkReward", function()
	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local earned = math.random(13,21)
	xPlayer.addMoney(earned)
	TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = "success", text = "You have earned $"..earned.." for your work", length = 5000})
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("tp-qalle-jail:jailPlayer", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("esx-qalle-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier

	MySQL.Async.execute(
       "UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(source, cb)
	
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailTime", function(source, cb)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		local JailTime = tonumber(result[1].jail)

		if JailTime > 0 then

			cb(true, JailTime)
		else
			cb(false, 0)
		end

	end)
end)