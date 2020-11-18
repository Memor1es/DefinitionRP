ESX = nil
local blips = {}
local civjob = "unemployed"

cachedData = {}

Citizen.CreateThread(function()
	while not ESX do
		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)
		while ESX.GetPlayerData().job == nil do Wait(0) end
		civjob = ESX.PlayerData.job.name
		Citizen.Wait(0)
	end
end)

function makeBlips()
	for k, v in pairs(blips) do
		RemoveBlip(v)
		blips[k] = nil
	end

	for garage, garageData in pairs(Config.Garages) do
		local garagejob = (garageData["job"] or "all")
		local showGarage = false

		if type(garagejob) == "table" then
			for k, v in pairs(garagejob) do
				if v == civjob then
					showGarage = true
				end
			end
		end

		if not showGarage and garagejob == "all" then
			showGarage = true
		end

		if showGarage then
			blips[garage] = AddBlipForCoord(garageData["positions"]["menu"]["position"])
			SetBlipSprite(blips[garage], 357)
			SetBlipDisplay(blips[garage], 4)
			SetBlipScale (blips[garage], 0.65)
			SetBlipColour(blips[garage], 67)
			SetBlipAsShortRange(blips[garage], true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Garage: " .. garage)
			EndTextCommandSetBlipName(blips[garage])
		end
	end
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
	while ESX.GetPlayerData().job == nil do Wait(0) end
	civjob = ESX.PlayerData.job.name
	makeBlips()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	civjob = newJob.name
	makeBlips()
end)

Citizen.CreateThread(function()
	local CanDraw = function(action)
		if action == "vehicle" then
			if IsPedInAnyVehicle(PlayerPedId()) then
				local vehicle = GetVehiclePedIsIn(PlayerPedId())

				if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
					return true
				else
					return false
				end
			else
				return false
			end
		end

		return true
	end

	while true do
		local sleepThread = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		for garage, garageData in pairs(Config.Garages) do
			for action, actionData in pairs(garageData["positions"]) do
				local dstCheck = #(pedCoords - actionData["position"])
				local garagejob = (garageData["job"] or "all")
				if dstCheck <= 10.0 then
					local showGarage = false
					if type(garagejob) == "table" then
						for k, v in pairs(garagejob) do
							if v == civjob then
								showGarage = true
							end
						end
					end

					if not showGarage and garagejob == "all" then
						showGarage = true
					end

					local draw = CanDraw(action)
					sleepThread = 5
					if draw and showGarage then
						local markerSize = action == "vehicle" and 4.0 or 1.5
						if dstCheck <= markerSize - 0.1 then
							local usable = not DoesCamExist(cachedData["cam"])
							if Menu.hidden then
								--DrawText3Ds(actionData["position"].x,actionData["position"].y,actionData["position"].z, actionData["text"])
							end
							if IsControlJustPressed(1, 177) and not Menu.hidden then
								CloseMenu()
								PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
							end
							if usable then
								if IsControlJustPressed(0, 38) and Menu.hidden then
									cachedData["currentGarage"] = garage
									ESX.TriggerServerCallback("betrayed_garage:obtenerVehiculos", function(fetchedVehicles)
										EnvioVehLocal(fetchedVehicles[1])
										if fetchedVehicles[2] then
											EnvioVehFuera(fetchedVehicles[2])
										end
									end,garage)
									Menu.hidden = not Menu.hidden
									MenuGarage(action)
									TriggerEvent("inmenu",true)
								end
								
							end
						end
						DrawScriptMarker({
							["type"] = 27,
							["pos"] = actionData["position"] - vector3(0.0, 0.0, 0.0),
							["sizeX"] = markerSize,
							["sizeY"] = markerSize,
							["sizeZ"] = markerSize,
							["r"] = 0,
							["g"] = 0,
							["b"] = 0
						})
					end
				elseif (dstCheck > 10.0 and dentro == garage) then
					dentro = nil
				end
			end
		end
		Menu.renderGUI()
		Citizen.Wait(sleepThread)
	end
end)
-------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z, text)
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
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0, 100)
end

RegisterNetEvent('drp-garages:updateVehName')
AddEventHandler('drp-garages:updateVehName', function(model,plate)
	local vehName = GetLabelText(GetDisplayNameFromVehicleModel(model))
	if vehName == "NULL" then vehName = "Unnamed dono car" end
    TriggerServerEvent('drp-garages:updateVehName', vehName,plate)
end)