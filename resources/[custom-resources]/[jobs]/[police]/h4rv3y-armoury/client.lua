local PlayerData = {}
local hasItem
  
ESX = nil
  
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

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

local playerPed = PlayerPedId()
local playerVeh = GetVehiclePedIsIn(playerPed, false)
---------------------------------------------------------------------------
--- Main Loop
---------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(450)
		if PlayerData then
			hasItem = exports["disc-inventoryhud"]:hasEnoughOfItem(Config.Armoury.PoliceCarbine.Weapon, 1)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if PlayerData.job and PlayerData.job.name == Config.PoliceDatabaseName and PlayerData.job.grade >= Config.RankLocked then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local _, weapon = GetCurrentPedWeapon(playerPed, true)

			for k,v in pairs(Config.Armoury) do

				for i = 1, #v.Pos, 1 do
					local distance =  Vdist(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

					if (distance < 1) then
						if hasItem then
							DrawText3D(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, "[E] Rack "..v.Name)
							if IsControlJustReleased(0, Keys['E']) then
								TriggerServerEvent("h4rv3y-armoury:takeitem", v.Weapon, false)
								TriggerServerEvent('h4vr3y-armoury:sendToDiscord', v.Name, false)
								TriggerEvent("notification", "You racked 1x "..v.Name..". This has been documented")
								Citizen.Wait(500)
							end
						else
							DrawText3D(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, "[E] Take "..v.Name)
							if IsControlJustReleased(0, Keys['E']) then
								TriggerServerEvent("h4rv3y-armoury:takeitem", v.Weapon, true)
								TriggerServerEvent('h4vr3y-armoury:sendToDiscord', v.Name, true)
								TriggerEvent("notification", "You took 1x "..v.Name..". This has been documented")
								Citizen.Wait(500)
							end
						end
					end
				end
			end
		end
	end
end)
---------------------------------------------------------------------------
--- Draw Text
---------------------------------------------------------------------------
function DrawText3D(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	  
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.01+ factor, 0.03, 0, 0, 0, 50)
end