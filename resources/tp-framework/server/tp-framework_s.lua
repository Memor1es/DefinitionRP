--[[
	Developed by Damien, Frag and British <3

    NOTES:
    1: Licence System (Active Reloading of licences when getting new one + Licence checks for shops)
    2: 
    3: 

    --Todo's
    These are all spmamming to get the player:
    
    [x] Safebreach/ser/main - Line 44-72 = Seems to be spamming to get the player.
    [x] Mugging - Spamming grabbing the xPlayer/GetPlayer()
    [ ] EasyAdmin - When refreshing to check blacklist (remove this code not really needed)
]]

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ActiveJobs = {
    ['unemployed'] = {      Players = {}, Count=0 },
	['ambulance'] = {     Players = {}, Count=0 },
	['busdriver'] = {     Players = {}, Count=0 },
	['cardealer'] = {     Players = {}, Count=0 },
	['diamondcasino'] = {     Players = {}, Count=0 },
	['fisherman'] = {     Players = {}, Count=0 },
	['flywheels'] = {     Players = {}, Count=0 },
	['fueler'] = {     Players = {}, Count=0 },
	['garbage'] = {     Players = {}, Count=0 },
	['gopostal'] = {     Players = {}, Count=0 },
	['hellscustoms'] = {     Players = {}, Count=0 },
	['importdealer'] = {     Players = {}, Count=0 },
	['lawyer'] = {     Players = {}, Count=0 },
	['lswc'] = {     Players = {}, Count=0 },
	['lumberjack'] = {     Players = {}, Count=0 },
	['mechanic'] = {     Players = {}, Count=0 },
	['merryweather'] = {     Players = {}, Count=0 },
	['miner'] = {     Players = {}, Count=0 },
	['offambulance'] = {     Players = {}, Count=0 },
	['offdiamondcasino'] = {     Players = {}, Count=0 },
	['offflywheels'] = {     Players = {}, Count=0 },
	['offhellscustoms'] = {     Players = {}, Count=0 },
	['offlswc'] = {     Players = {}, Count=0 },
	['offmechanic'] = {     Players = {}, Count=0 },
	['offmerryweather'] = {     Players = {}, Count=0 },
	['offpolice'] = {     Players = {}, Count=0 },
	['offracersedge'] = {     Players = {}, Count=0 },
	['offreporter'] = {     Players = {}, Count=0 },
	['offvagos'] = {     Players = {}, Count=0 },
	['offvanillaunicorn'] = {     Players = {}, Count=0 },
	['police'] = {     Players = {}, Count=0 },
	['racersedge'] = {     Players = {}, Count=0 },
	['reporter'] = {     Players = {}, Count=0 },
	['slaughterer'] = {     Players = {}, Count=0 },
	['tailor'] = {     Players = {}, Count=0 },
	['taxi'] = {     Players = {}, Count=0 },
	['tailor'] = {     Players = {}, Count=0 },
	['vagos'] = {     Players = {}, Count=0 },
	['vanillaunicorn'] = {     Players = {}, Count=0 },
	['secondchance'] = {     Players = {}, Count=0 },
	['offsecondchance'] = {     Players = {}, Count=0 },
}

FleecaCooldown = {
	StartTime = 0,
}

RegisterServerEvent('DRP:Server:Global:DisplayNotification')
AddEventHandler('DRP:Server:Global:DisplayNotification', function(src, mtype, message, time)
	if src and mtype and message then
		TriggerClientEvent('DRP:Client:ShowMythicNotification', src, mtype, message, (time or 5000))
	end
end)

ESX.RegisterServerCallback('drp-framework:checkFleecaCooldown', function(source, cb)
	local now = tonumber(os.time())
	if (now - FleecaCooldown.StartTime) <= 600 then
		cb(false)
	else
		cb(true)
	end
end)

RegisterServerEvent('drp-framework:updateFleecaCooldown')
AddEventHandler('drp-framework:updateFleecaCooldown', function()
	local time = tonumber(os.time())
	FleecaCooldown.StartTime = time
end)

RegisterServerEvent('drp-framework:updateFleecaCooldownRemove')
AddEventHandler('drp-framework:updateFleecaCooldownRemove', function()
	FleecaCooldown.StartTime = 0
end)


Config = {}
Config.RestartTimes = {03, 11, 19}

RegisterCommand("timecheck", function(source, args, raw)
	local itsTime = timecheck()
    exports['tp-framework']:Print(tostring(itsTime))
end, false)

ESX.RegisterServerCallback('tp:isRestartComing', function(source, cb)
	local isRestartComing = timecheck()
	if isRestartComing then
		cb(true)
	else
		cb(false)
	end
end)

function timecheck()
	local itsTime = false
	-- print(tostring(os.date('%H')) .. ":" .. tostring(os.date('%M')))
	for k, v in pairs(Config.RestartTimes) do
		local hour = tonumber(os.date('%H'))
		local minutes = tonumber(os.date('%M'))
		if (v == (hour + 1)) then
			if (minutes >= 30) then
				itsTime = true
				break
			else
				itsTime = false
			end
        elseif (v == (hour)) then
            if (minutes <= 30) then
                itsTime = true
                break
            end
        else
            itsTime = false
        end
	end
	return itsTime
end

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		GetInitialPlayerData()
	end
end)

function GetInitialPlayerData()
	local players = ESX.GetPlayers()

		for i=1, #players, 1 do
			-- print(players[i])
			local xPlayer = ESX.GetPlayerFromId(players[i])
			if (xPlayer ~= nil) then
				table.insert(ActiveJobs[xPlayer.job.name].Players, players[i])
				ActiveJobs[xPlayer.job.name].Count = ActiveJobs[xPlayer.job.name].Count + 1
			end
		end
		-- print(#players)
end

AddEventHandler('tprp:PlayerLoaded', function(xPlayer, source)
	table.insert(ActiveJobs[xPlayer.job.name].Players, source) -- changed from source
	ActiveJobs[xPlayer.job.name].Count = ActiveJobs[xPlayer.job.name].Count + 1
end)

AddEventHandler('tprp:PlayerDropped', function(xPlayer, source)
	for i=1, #ActiveJobs[xPlayer.job.name].Players, 1 do
		if (ActiveJobs[xPlayer.job.name].Players[i] == source) then
			table.remove(ActiveJobs[xPlayer.job.name].Players, i)
			ActiveJobs[xPlayer.job.name].Count = ActiveJobs[xPlayer.job.name].Count - 1
			break
		end
	end

	--[[ ActiveJobs[xPlayer.job.name].Players[source] = nil -- changed from source
	ActiveJobs[xPlayer.job.name].Count = ActiveJobs[xPlayer.job.name].Count - 1 ]]
end)

ESX.RegisterServerCallback('tprp:GetJobCountCallBack', function(source, cb, jobId)
	cb(ActiveJobs[jobId].Count)
end)

AddEventHandler('tprp:GetJobCount', function(jobId, cb)
	cb(ActiveJobs[jobId].Count)
end)

AddEventHandler('tprp:GetJobPlayers', function(jobId, cb)
	cb(ActiveJobs[jobId].Players)
end)


--[[ Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        local copsonline = tostring(ActiveJobs["police"].Count)
        print(copsonline)
    end
end) ]]

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	-- remove from last job
	-- print(tostring(playerId) .. " switching roles")

	for i=1, #ActiveJobs[lastJob.name].Players, 1 do
		if (ActiveJobs[lastJob.name].Players[i] == playerId) then
			table.remove(ActiveJobs[lastJob.name].Players, i)
			ActiveJobs[lastJob.name].Count = ActiveJobs[lastJob.name].Count - 1
			break
		end
	end

	local alreadyInserted = false

	for i=1, #ActiveJobs[job.name].Players, 1 do
		if(ActiveJobs[job.name].Players[i] == playerId) then
			alreadyInserted = true
			break
		end
	end

	if not alreadyInserted then
		table.insert(ActiveJobs[job.name].Players, playerId)
		ActiveJobs[job.name].Count = ActiveJobs[job.name].Count + 1
	end
end)

function GetJobCount(job)
    return ActiveJobs[job].Count
end
exports('GetJobCount', GetJobCount)

function IsRestartComing()
    restartComing = timecheck()
    return restartComing
end
exports('isRestartComing', IsRestartComing)


--[[ 
	-- this is used elsewhere in other resources 
		local count = exports['tp-framework'].GetJobCount(job)
 ]]

local currentArmour = {}

RegisterNetEvent('drp-framework:updateArmour')
AddEventHandler('drp-framework:updateArmour', function(updateArmour)
	local src = source
	currentArmour[src] = updateArmour
end)

AddEventHandler('esx:playerLoaded', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    MySQL.Async.fetchScalar("SELECT armour FROM users WHERE identifier = @identifier", { 
        ['@identifier'] = tostring(xPlayer.getIdentifier())
        }, function(data)
        if (data ~= nil) then
            TriggerClientEvent('drp-framework:setArmour', playerId, data)
		end
    end)
end)

AddEventHandler('esx:playerDropped', function(playerId)
	local src = playerId
	local xPlayer = ESX.GetPlayerFromId(src)
	if currentArmour[src] > 0 then
		MySQL.Async.execute("UPDATE users SET armour = @armour WHERE identifier = @identifier", { 
		['@identifier'] = xPlayer.getIdentifier(),
		['@armour'] = currentArmour[src]
		})
	end
end)

-- OXY
ESX.RegisterUsableItem('oxy', function(source)  
	TriggerClientEvent('tp:useOxy', source)
	local player = ESX.GetPlayerFromId(source)
end)

RegisterServerEvent('drp-framework:loadArmour')
AddEventHandler('drp-framework:loadArmour', function()
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchScalar("SELECT armour FROM users WHERE identifier = @identifier", { 
        ['@identifier'] = tostring(xPlayer.getIdentifier())
        }, function(data)
        if (data ~= nil) then
            TriggerClientEvent('drp-framework:setArmour', src, data)
		end
    end)
end)


RegisterServerEvent('JAM_Pillbox:CheckIn')
AddEventHandler('JAM_Pillbox:CheckIn', function(id)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    amount = 300
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_ambulance", function(account)
        Citizen.Wait(100)
        xPlayer.removeAccountMoney("bank", amount)
        account.addMoney(amount)
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'You paid your medical fee of $'.. amount..'.', length = 5000})
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_ambulance", function(account)
        end)
    end)
end)


--[[ RegisterServerEvent('parachute:equip')
AddEventHandler('parachute:equip',function()
    local player = ESX.GetPlayerFromId(source)
    player.removeInventoryItem('parachute', 1)
end) ]]


--- JOB CHECK DEBUG COMMAND
--[[ RegisterCommand("jobcheck", function(source, args, raw)
	local copsonline = tostring(ActiveJobs["police"].Count)
	local offcopsonline = tostring(ActiveJobs["offpolice"].Count)
	print("Police Onduty: " .. copsonline)
	print("Offduty: " .. offcopsonline)
	print("List of cops on duty:")
	for i=1, #ActiveJobs["police"].Players, 1 do
		playername = GetPlayerName(ActiveJobs["police"].Players[i])
		playerid = ActiveJobs["police"].Players[i]
		print("[" .. playerid .. "] " .. playername)
	end
	print("List of cops off duty:")
	for i=1, #ActiveJobs["offpolice"].Players, 1 do
		playername = GetPlayerName(ActiveJobs["offpolice"].Players[i])
		playerid = ActiveJobs["offpolice"].Players[i]
		print("[" .. playerid .. "] " .. playername)
	end


	local emsonline = tostring(ActiveJobs["ambulance"].Count)
	local offemsonline = tostring(ActiveJobs["offambulance"].Count)
	print("EMS Onduty: " .. emsonline)
	print("Offduty: " .. offemsonline)
	print("List of EMS on duty:")
	for i=1, #ActiveJobs["ambulance"].Players, 1 do
		playername = GetPlayerName(ActiveJobs["ambulance"].Players[i])
		playerid = ActiveJobs["ambulance"].Players[i]
		print("[" .. playerid .. "] " .. playername)
	end
	print("List of EMS off duty:")
	for i=1, #ActiveJobs["offambulance"].Players, 1 do
		playername = GetPlayerName(ActiveJobs["offambulance"].Players[i])
		playerid = ActiveJobs["offambulance"].Players[i]
		print("[" .. playerid .. "] " .. playername)
	end

	print(tostring(os.date('%H')) .. ":" .. tostring(os.date('%M')))
end, false) ]]

RegisterServerEvent("kickForAFKing")
AddEventHandler("kickForAFKing", function(source)
	local _source = source
	if _source ~= nil then
		GetRPName(_source, function(name)
			if name then
				TriggerEvent('discordbot:afklog', "```[AFK] "..name.." was kicked for being AFK```")
			end
			DropPlayer(_source, "Definition Roleplay\n\nYou have been automatically kicked for being idle too long,\nPlease reconnect to the server when you are ready.")
		end)
	end
end)

RegisterServerEvent("passAFKcheck")
AddEventHandler("passAFKcheck", function(source)
	local _source = source
	if _source ~= nil then
		GetRPName(_source, function(name)
			if name then
				TriggerEvent('discordbot:afklog', "```[AFK] "..name.." passed an AFK check```")
			end
		end)
	end
end)

RegisterServerEvent("AFKcheck")
AddEventHandler("AFKcheck", function(source)
	local _source = source
	if _source ~= nil then
		GetRPName(_source, function(name)
			if name then
				TriggerEvent('discordbot:afklog', "```[AFK] "..name.." has received an AFK check```")
			end
		end)
	end
end)

function GetRPName(playerId, cb)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier
	if Identifier == nil then
		return
	else
		MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
			if cb then
				if result[1] and result[1].firstname then
					cb("["..Identifier.."] ["..GetPlayerName(playerId).."] "..result[1].firstname.." "..result[1].lastname)
				else
					cb("["..Identifier.."] ["..GetPlayerName(playerId).."] (No Character Name Found) ")
				end
			end
		end)
	end
end
