ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local activity = 0
local activitySource = 0
local cooldown = 0

RegisterServerEvent('tp-carthief:pay')
AddEventHandler('tp-carthief:pay', function(bodydamage, enginedamage)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    print("Body Health: "..bodydamage)
    print("ENG Health: "..enginedamage)

    damage = math.ceil(bodydamage + enginedamage)

    print("Average Damage: " .. damage)
    
    paymentLoss = ((damage - 2000) * Config.DamageMultiplier)
    print("Payment Loss: "..paymentLoss)

    payment = 100000 + (paymentLoss)




    print("Payment: "..payment)

	xPlayer.addAccountMoney('black_money',tonumber(payment))
	
	--Add cooldown
	cooldown = Config.CooldownMinutes * 60000
end)

ESX.RegisterServerCallback('tp-carthief:anycops',function(source, cb) -- Trash Code, fix it
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

ESX.RegisterServerCallback('tp-carthief:isActive',function(source, cb)
  cb(activity, cooldown)
end)

RegisterServerEvent('tp-carthief:registerActivity')
AddEventHandler('tp-carthief:registerActivity', function(value)
	activity = value
	if value == 1 then
		activitySource = source
		--[[ --Send notification to cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				TriggerClientEvent('tp-carthief:setcopnotification', xPlayers[i])
			end
		end ]]
	else
		activitySource = 0
	end
end)

RegisterServerEvent('tp-carthief:alertcops2')
AddEventHandler('tp-carthief:alertcops2', function()
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('tp-carthief:setcopnotification', xPlayers[i])
        end
    end
end)

RegisterServerEvent('tp-carthief:alertcops')
AddEventHandler('tp-carthief:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tp-carthief:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)

RegisterServerEvent('tp-carthief:stopalertcops')
AddEventHandler('tp-carthief:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('tp-carthief:removecopblip', xPlayers[i])
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
				TriggerClientEvent('tp-carthief:removecopblip', xPlayers[i])
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


RegisterServerEvent('tp-carthief:startJob')
AddEventHandler('tp-carthief:startJob', function()
    local _source = source
    if cooldown <= 0 then
        TriggerClientEvent('phone:addnotification', _source, "Calitri", "Hey, I heard you're looking for some work. I'll be in touch shortly. - Mr Calitri")  
    end
    TriggerClientEvent('tp-carthief:jobStage1', _source)
end)

RegisterServerEvent('tp-carthief:waitTimerFinished')
AddEventHandler('tp-carthief:waitTimerFinished', function()
    local _source = source
    car = math.random(1, #Config.Cars) -- LOWER CASE THIS SHIT
    loc = math.random(1, #Config.SpawnLocations)
    TriggerClientEvent('tp-carthief:jobStage2', _source, Config.Cars[car], Config.SpawnLocations[loc])
    -- TriggerClientEvent('phone:addnotification', _source, "Calitri", "Okay, there is a "..Config.Cars[car].. " parked " .. Config.SpawnLocations[loc].info .. " Deliver it in one piece! It'll be gone in 20 minutes. - Mr Calitri")
end)

RegisterServerEvent('tp-carthief:sendCarMsg')
AddEventHandler('tp-carthief:sendCarMsg', function(car, loc)
    local _source = source
    TriggerClientEvent('phone:addnotification', _source, "Calitri", "Okay, there is a "..car.. " parked " .. loc .. " Deliver it in one piece! It'll be gone in 20 minutes. - Mr Calitri")
end)

RegisterServerEvent('tp-carthief:stoppedTrackingMsg')
AddEventHandler('tp-carthief:stoppedTrackingMsg', function()
    local _source = source
    TriggerClientEvent('phone:addnotification', _source, "Calitri", "One of my men has hacked the tracker, lose the cops and bring me the vehicle. I've marked the location on your GPS. - Mr Calitri")
    TriggerClientEvent('tp-carthief:showDeliveryLocation', _source)
end)

RegisterServerEvent('tp-carthief:sendFailMsg')
AddEventHandler('tp-carthief:sendFailMsg', function(car, loc)
    local _source = source
    TriggerClientEvent('phone:addnotification', _source, "Calitri", "You took too long. - Mr Calitri")
end)