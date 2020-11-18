local ESX      	 = nil
local holstered  = true
local blocked	 = false
local PlayerData = {}
------------------------

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  	PlayerData.job = job
end)
	
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if not IsPedInParachuteFreeFall (ped) then
			if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
				if CheckWeapon(ped) then
					if holstered then
						blocked   = true
						SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
						loadAnimDict("reaction@intimidation@cop@unarmed")
						TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 10.0, 2.3, -1, 49, 1, 0, 0, 0 ) -- Change 50 to 30 if you want to stand still when removing weapon
						Citizen.Wait(125)
						SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
						--AttachmentCheck(weaponhash)
						--AttachmentCheckCop(weaponHash)
						Citizen.Wait(600)
						ClearPedTasks(ped)
						holstered = false
					else
						blocked = false
					end
				else
					if not holstered then
						loadAnimDict("reaction@intimidation@cop@unarmed")
						TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 10.0, 2.3, -1, 49, 1, 0, 0, 0) -- Change 50 to 30 if you want to stand still when holstering weapon
						Citizen.Wait(600)
						ClearPedTasks(ped)
						holstered = true
					end
				end
			end
		else
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		end
		if not IsPedInParachuteFreeFall (ped) then
			if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' then
				if CheckWeapon(ped) then
					if holstered then
						blocked   = true
						SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
						loadAnimDict("reaction@intimidation@1h")
						TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )
						Citizen.Wait(1250)
						--AttachmentCheck(weaponHash)
						SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
						Citizen.Wait(Config.cooldown)
						ClearPedTasks(ped)
						holstered = false
					else
						blocked = false
					end
				else
					if not holstered then
						loadAnimDict("reaction@intimidation@1h")
						TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0 ) -- Change 50 to 30 if you want to stand still when holstering weapon
						-- local weaponHash = GetHashKey()
						--AttachmentCheck(weaponHash)
						Citizen.Wait(1700)
						ClearPedTasks(ped)
						holstered = true
					end
				end
			end
		else
			SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)

		if blocked then
			DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
			DisablePlayerFiring(ped, true) -- Disable weapon firing
		end
	end
end)

function CheckWeapon(ped)
	if IsEntityDead(ped) then
		blocked = false
			return false
		else
			for i = 1, #Config.Weapons do
				if GetHashKey(Config.Weapons[i]) == GetSelectedPedWeapon(ped) then
					return true
				end
			end
		return false
	end
end

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end