ESX = nil
ESXLoaded = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end)

local jumptoggle = false
local ragdoll_chance = 0.8
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 22) then
			local ped = PlayerPedId()
			if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) and jumptoggle then
				local chance_result = math.random()
				if chance_result < ragdoll_chance then 
					Citizen.Wait(600)
					ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
					SetPedToRagdoll(ped, 5000, 1, 2)
				end
			else
				jumptoggle = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		while jumptoggle do
			Citizen.Wait(5000)
			jumptoggle = false
		end
	end
end)
