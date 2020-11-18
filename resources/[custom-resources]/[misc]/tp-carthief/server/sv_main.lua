RegisterServerEvent('tp-carthief:startJob')
AddEventHandler('tp-carthief:startJob', function()
    local _source = source
    TriggerClientEvent('phone:addnotification', _source, "Raymond", "Hey it's Raymond, I heard you're looking for some work. I'll be in touch shortly.")
    TriggerClientEvent('tp-carthief:jobStage1', _source)
end)

RegisterServerEvent('tp-carthief:waitTimerFinished')
AddEventHandler('tp-carthief:waitTimerFinished', function()
    local _source = source
    car = math.random(1, #Config.Cars) -- LOWER CASE THIS SHIT
    loc = math.random(1, #Config.Locations)
    print(Config.Cars[car])
    TriggerClientEvent('tp-carthief:jobStage2', _source, Config.Cars[car], Config.Locations[loc])
    TriggerClientEvent('phone:addnotification', _source, "Raymond", "Okay, there is a "..Config.Cars[car].. " parked " .. Config.Locations[loc].info .. " Bring it back in one piece!")
end)

--[[ RegisterServerEvent('tp-carthief:polTrackingStart')
AddEventHandler('tp-carthief:polTrackingStart', function(car, coords)
    local _source = source
    print(car)
    print(json.encode(coords))
    TriggerClientEvent('tp-carthief:trackingBlip', -1, car, coords)
    TriggerClientEvent('tp-carthief:notifyCops', -1, car, coords)
end)

RegisterServerEvent('tp-carthief:polTrackingInfo')
AddEventHandler('tp-carthief:polTrackingInfo', function(car, coords)
    local _source = source
    TriggerClientEvent('tp-carthief:trackingBlip', -1, car, coords)
end) ]]

RegisterServerEvent('tp-carthief:CreateBlip')
AddEventHandler('tp-carthief:CreateBlip', function(veh)
    local _source = source
    TriggerClientEvent('tp-carthief:CreateBlip', 01, veh)
end)




ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local activity = 0
local activitySource = 0
local cooldown = 0

RegisterServerEvent('esx_carthief:pay')
AddEventHandler('esx_carthief:pay', function(payment)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addAccountMoney('black_money',tonumber(payment))
	
	--Add cooldown
	cooldown = Config.CooldownMinutes * 60000
end)

ESX.RegisterServerCallback('esx_carthief:anycops',function(source, cb)
  local anycops = 0
  local playerList = ESX.GetPlayers()
  for i=1, #playerList, 1 do
    local _source = playerList[i]
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerjob = xPlayer.job.name
    if playerjob == 'police' then
      anycops = anycops + 1
    end
  end
  cb(anycops)
end)

ESX.RegisterServerCallback('esx_carthief:isActive',function(source, cb)
  cb(activity, cooldown)
end)

RegisterServerEvent('esx_carthief:registerActivity')
AddEventHandler('esx_carthief:registerActivity', function(value)
	activity = value
	if value == 1 then
		activitySource = source
		--Send notification to cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('esx_carthief:setcopnotification', xPlayers[i])
			end
		end
	else
		activitySource = 0
	end
end)

RegisterServerEvent('esx_carthief:alertcops')
AddEventHandler('esx_carthief:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_carthief:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)

RegisterServerEvent('esx_carthief:stopalertcops')
AddEventHandler('esx_carthief:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx_carthief:removecopblip', xPlayers[i])
		end
	end
end)

AddEventHandler('playerDropped', function ()
	local _source = source
	if _source == activitySource then
		--Remove blip for all cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('esx_carthief:removecopblip', xPlayers[i])
			end
		end
		--Set activity to 0
		activity = 0
		activitySource = 0
	end
end)

--Cooldown manager
AddEventHandler('onResourceStart', function(resource)
	while true do
		Wait(5000)
		if cooldown > 0 then
			cooldown = cooldown - 5000
		end
	end
end)
