local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local stress = 0
local didIshoot = false
ESX	= nil

RegisterNetEvent("esx_stress:reduceStress")
AddEventHandler("esx_stress:reduceStress",function(toReduce)
	stress = stress - toReduce
	--TriggerEvent('esx:showNotification', "Stress relieved")
	if stress < 0 then stress = 0 end
end)

RegisterNetEvent("esx_stress:addStress")
AddEventHandler("esx_stress:addStress",function(toAdd)
	stress = stress + toAdd
	--TriggerEvent('esx:showNotification', "Stress increased!")
	if stress > 10 then stress = 10 end
end)

AddEventHandler("esx_stress:getStress",function(cb)
	cb(stress)
end)

local statusChecks = {}

Citizen.CreateThread(function()
	while true do
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end		
		while not ESX.IsPlayerLoaded() do
			Citizen.Wait(1000)
		end
		local toWait = nil
		if IsPedShooting(PlayerPedId()) and not statusChecks["isShooting"] then
			statusChecks["isShooting"] = true
			--TriggerEvent("esx_stress:addStress",1)
			toWait = 6000
		end
		if not statusChecks["shootingInArea"] then
			if checkNearbyShooter() then
				statusChecks["shootingInArea"] = true
				--TriggerEvent("esx_stress:addStress",1)
				toWait = 6000
			end
		end
		if IsPedInMeleeCombat(PlayerPedId()) and not statusChecks["meleeCombat"] and not statusChecks["isShooting"] then
			Citizen.Wait(2500)
			if IsPedInMeleeCombat(PlayerPedId()) then
				statusChecks["meleeCombat"] = true
				--TriggerEvent("esx_stress:addStress",1)
				toWait = 6000
			end
		end
		if toWait == nil then	
			statusChecks["meleeCombat"] = nil
			statusChecks["shootingInArea"] = nil
			statusChecks["isShooting"] = nil
			statusChecks["hasDamage"] = nil
		end
		
		SendNUIMessage({
     		heal = stress * 10
     	})
		
		Citizen.Wait(toWait or 200)
	end
end)

Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(0)
		    if IsPedShooting(PlayerPedId()) then
			   --TriggerEvent("esx_stress:addStress",1)
			   Citizen.Wait(1100)
		end
	end
end)

function checkNearbyShooter()
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
	for k,v in pairs(players) do
		if IsPedShooting(GetPlayerPed(v)) and v ~= PlayerId() then
			return true
		end
	end
	return false
end

function getChecks()
	for k,v in ipairs(statusChecks) do
		if v == true then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
		if stress > 0 and getChecks() == false then
			stress = stress - 1
			--TriggerEvent('esx:showNotification', "Stress relieved")
		end
		for k,v in ipairs(statusChecks) do
			v = false
		end
		Citizen.Wait(90000)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4000)
		if stress == 1 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.05)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.2)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 2 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.10)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.2)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 3 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.15)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.2)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 4 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.2)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.3)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 5 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.25)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.3)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 6 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.30)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.3)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 7 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.35)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.4)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 8 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.40)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.5)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 9 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.45)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.5)
			Citizen.Wait(100)
			ClearFocus()
	        ClearTimecycleModifier()
		elseif stress == 10 then
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.50)
			SetTimecycleModifier("BlackOut")
			SetTimecycleModifierStrength(0.7)
			Citizen.Wait(500)
			ClearFocus()
	        ClearTimecycleModifier()			
		else
			if IsGameplayCamShaking() then
				StopGameplayCamShaking(true)
			end
		end
		SetPedAccuracy(PlayerPedId(),(5-stress)*20)
	end
end)
