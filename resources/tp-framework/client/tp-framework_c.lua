ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(r)
	print('Successfully restarted '..r)
end)

RegisterNetEvent('drp-framework:setArmour')
AddEventHandler('drp-framework:setArmour', function(armour)
    Citizen.Wait(6000)  -- Give ESX time to load their stuff. Because some how ESX remove the armour when load the ped.
                        -- If there is a better way to do this, make an pull request with 'Tu eres una papa' (you are a potato) as a subject
    SetPedArmour(PlayerPedId(), tonumber(armour))
end)

local TimeFreshCurrentArmour = 1000  -- 1s

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        TriggerServerEvent('drp-framework:updateArmour', GetPedArmour(PlayerPedId()))
        Citizen.Wait(TimeFreshCurrentArmour)
    end
end)


--[[ RegisterCommand('veh1', function(source, args)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	local modelHash = GetEntityModel(vehicle)
	local modelName = GetDisplayNameFromVehicleModel(modelHash)
	print(GetDisplayNameFromVehicleModel(modelHash))
	local fuelLevel = GetVehicleFuelLevel(vehicle)
	print(tonumber(fuelLevel))
end) ]]


local oxyusing = false

RegisterNetEvent('DRP:Client:ShowMythicNotification')
AddEventHandler('DRP:Client:ShowMythicNotification', function(mtype, message, time)
	exports['mythic_notify']:SendAlert(mtype, message, time)
end)

RegisterNetEvent("tp:useOxy")
AddEventHandler("tp:useOxy", function(source)

	if not oxyusing then
		oxyusing = true
		TriggerServerEvent('useableitem:remove', "oxy")
	exports['mythic_progbar']:Progress({
        name = "firstaid_action",
        duration = 3000,
        label = "Taking Oxy",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mp_suicide",
            anim = "pill",
            flags = 49,
        },
        prop = {
            model = "prop_cs_pills",
            bone = 58866,
            coords = { x = 0.1, y = 0.0, z = 0.001 },
            rotation = { x = -60.0, y = 0.0, z = 0.0 },
        },
    }, function(status)
        if not status then
            local count = 30
			while count > 0 do
				Citizen.Wait(1000)
				count = count - 1
				SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 1)
				used = true
			end
			exports['mythic_notify']:SendAlert('Success', 'Pill effects worn off', 7000)
			oxyusing = false
			if math.random(100) > 80 then
				TriggerEvent('mythic_hospital:client:RemoveBleed')
			end
		end
	end)
else
	exports['mythic_notify']:SendAlert('error', 'Still under effects of pill', 7000)
end
end)

-- AFK Kick Time Limit (in seconds)
local minute = 60000
local secondsUntilKick = 35
local time = secondsUntilKick
local afkMessage = false
local afkcode = "zzzzzzzzzzzz"

Citizen.CreateThread(function()
    while true do
        playerPed = GetPlayerPed(-1)
        if playerPed then
			currentPos = GetEntityCoords(playerPed, true)
			if prevPos ~= nil then
				if #(vector3(currentPos) - vector3(prevPos)) < 3.0 then
					-- Warns the player when there's 25% left of the afk timer
					if time == 5 then
						-- TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
						generatecode()
						time = time - 1
					else
						time = time - 1
					end
				else
					time = secondsUntilKick
					prevPos = currentPos
				end
			else
				prevPos = currentPos
			end
		end
		Wait(minute)
	end
end)

Citizen.CreateThread(function()
	local source = source
	while true do
		sleepTime = 1000
		if afkMessage then
			sleepTime = 0
			afktext("AFK CHECK: Type /afk "..afkcode)
			if afkMessage and time < 0 then
				source = GetPlayerServerId(PlayerId())
				TriggerServerEvent("kickForAFKing", source)
				afkMessage = false
			end
		end
		Citizen.Wait(sleepTime)
	end
end)

function generatecode()
	local upperCase = "ABCDEFGHIJKLMNPQRSTUVWXYZ"
    local numbers = "123456789"
    local characterSet = numbers .. upperCase
    local keyLength = 6
    local output = ""
    for	i = 1, keyLength do
        local rand = math.random(#characterSet)
        output = output .. string.sub(characterSet, rand, rand)
    end
	afkcode = output
	afkcheck()
end

function afkcheck()
	if afkMessage == false then
		afkMessage = true
		source = GetPlayerServerId(PlayerId())
		TriggerServerEvent("AFKcheck", source)
	else
		afkMessage = false
		time = secondsUntilKick
	end
end

RegisterCommand('afk', function(source, args)
	-- [[ print (GetPlayerPed(-1)) ]]
	local source = source
	if args[1] == afkcode then
		afkcheck()
		source = GetPlayerServerId(PlayerId())
		TriggerServerEvent("passAFKcheck", source)
	end
end)

function afktext(text)
	SetTextColour(139, 0, 0, 180)
	SetTextFont(8)
	SetTextScale(1.2, 1.2)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(true)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(0, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.5, 0.5)
	DrawRect(
		0.5, --X
		0.5, --Y
		0.8, --Width
		0.5, --Height
		0, --r
		0, --g
		0, --b
		150 --a
		)
end





--[[
	ESX.TriggerServerCallback('tprp:GetJobCountCallBack', function(jobCount)
		if jobCount >= MINCOPS then
			TriggerClientEvent('safecrack:start')
		else
			exports['mythic_notify']:SendAlert('error', 'Security is too high in this area right now.', 7000)
		end
	end, "police")


	exports['tp-framework']:Print(tableValue)

]]


-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local hydrant = 200846641
-- 		local object = GetClosestObjectOfType(GetEntityCoords(GetPlayerPed(-1)), 5.0, hydrant, false)
-- 		local obj = GetEntityCoords(object)
-- 		if object ~= 0 then
-- 			DrawText3D(obj.x,obj.y,obj.z, "fire hydrant")
-- 		end
-- 	end
-- end)




-- function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
--     local onScreen,_x,_y= World3dToScreen2d(x,y,z)

--     if onScreen then
--         BeginTextCommandDisplayText("STRING")

--         SetTextScale(0.0, 0.55)
--         SetTextFont(0)
--         SetTextProportional(1)
--         -- SetTextScale(0.0, 0.55)
--         SetTextColour(255, 255, 255, 255)
--         SetTextDropshadow(0, 0, 0, 0, 255)
--         SetTextEdge(2, 0, 0, 0, 150)
--         SetTextDropShadow()
--         SetTextOutline()

--         SetTextCentre(1)
--         AddTextComponentString(text)
--         EndTextCommandDisplayText(_x,_y)
--     end
-- end