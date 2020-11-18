Citizen.CreateThread(function()
    while true do
		Wait(4)	
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ped)
		if DoesEntityExist(veh) then
			disableAirControl(ped, veh)
			disableVehicleRoll(ped, veh)
		end
	end
end)

-- [[ FUNCTIONS ] --
function disableAirControl(ped, veh)
	if not IsThisModelBlacklisted(veh) then
		if IsPedSittingInAnyVehicle(ped) then
			if GetPedInVehicleSeat(veh, -1) == ped then
				if IsEntityInAir(veh) then
					DisableControlAction(0, 59)
					DisableControlAction(0, 60)
				end
			end
		end
	end
end

function disableVehicleRoll(ped, veh)
	local roll = GetEntityRoll(veh)
	if not IsThisModelBlacklisted(veh) then
		if GetPedInVehicleSeat(veh, -1) == ped then
			if (roll > 75.0 or roll < -75.0) then
				DisableControlAction(2,59,true)
				DisableControlAction(2,60,true)
			end
		end
	end
end

function IsThisModelBlacklisted(veh)
	local model = GetEntityModel(veh)

    if IsThisModelABike(model) or IsThisModelAQuadbike(model) or IsThisModelAJetski(model) then
        return true
    end
	return false
end