ESX = nil
local hasShot = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('Police:Client:DoGSRAnimation')
AddEventHandler('Police:Client:DoGSRAnimation', function(playerid)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "washing_gsr",
        duration = 9500,
        label = "Completing GSR Test",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        },
        animation = {
            task = 'WORLD_HUMAN_STAND_MOBILE'
        }
    }, function(status)
        
    end)
end)

RegisterNetEvent('Police:Client:FreezePed')
AddEventHandler('Police:Client:FreezePed', function(time)
    local playerPed = GetPlayerPed(-1)
    FreezeEntityPosition(playerPed, true)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "washing_gsr",
        duration = time,
        label = "Waiting for GSR Test",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        },
    }, function(status)
        FreezeEntityPosition(playerPed, false)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        ped = PlayerPedId()
        local weaponHash = GetSelectedPedWeapon(ped)
        if IsPedShooting(ped) then
            print(weaponHash)
            if alertForTaser(weaponHash) then
                TriggerServerEvent('GSR:SetGSR', timer)
                hasShot = true
                Citizen.Wait(Config.gsrUpdate)
            end
        end
    end
end)

function alertForTaser(hash)
	if (hash == GetHashKey('WEAPON_PISTOL50')) or (hash == GetHashKey('WEAPON_STUNGUN')) then
		return false
	else
		return true
	end
end

Citizen.CreateThread(function()
    while true do
        Wait(2000)
        if Config.waterClean and hasShot then
            ped = PlayerPedId()
            if IsEntityInWater(ped) then
				exports['mythic_notify']:DoCustomHudText('inform', 'You begin cleaning off the Gunshot Residue... stay in the water', 5000)
				Wait(100)
				TriggerEvent("mythic_progbar:client:progress", {
        			name = "washing_gsr",
        			duration = Config.waterCleanTime,
        			label = "Washing Off GSR",
        			useWhileDead = false,
        			canCancel = true,
        			controlDisables = {
            			disableMovement = false,
            			disableCarMovement = false,
            			disableMouse = false,
            			disableCombat = false,
        			},
    			}, function(status)
        			if not status then
            			if IsEntityInWater(ped) then
                    		hasShot = false
                    		TriggerServerEvent('GSR:Remove')
							exports['mythic_notify']:DoCustomHudText('success', 'You washed off all the Gunshot Residue in the water', 5000)
                		else
							exports['mythic_notify']:DoCustomHudText('error', 'You left the water too early and did not wash off the gunshot residue.', 5000)
                		end
        			end
    			end)
				Citizen.Wait(Config.waterCleanTime)
            end
        end
    end
end)

function status()
    if hasShot then
        ESX.TriggerServerCallback('GSR:Status', function(cb)
            if not cb then
                hasShot = false
            end
        end)
    end
end

function updateStatus()
    status()
    SetTimeout(Config.gsrUpdateStatus, updateStatus)
end

updateStatus()
