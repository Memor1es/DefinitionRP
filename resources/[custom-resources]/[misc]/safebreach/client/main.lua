ESX = nil

cachedSafes = {}
safeLocks = {}

currentSafeCorrectPosition = 0.0
dialRotation = 0.0

isCracking = false

local isRobbable = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) 
			ESX = obj 
		end)

		Citizen.Wait(0)
	end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
	Citizen.Wait(5000)

	ESX.TriggerServerCallback("safebreach:checkSafeBreaches", function(successfull)
		if successfull then
			-- print("There is a robbery ongoing, reloading props.")
		end
	end)
end)

RegisterNetEvent("safebreach:eventHandler")
AddEventHandler("safebreach:eventHandler", function(event, eventData)
	if event == "open_door" then
		local doorCoords = vector3(eventData["doorCoords"]["x"], eventData["doorCoords"]["y"], eventData["doorCoords"]["z"])

		cachedSafes[eventData["store"]] = {}
		cachedSafes[eventData["store"]]["breach"] = true

		Citizen.CreateThread(function()
			while cachedSafes[eventData["store"]] do
				local sleepThread = 500

				local pedCoords = GetEntityCoords(PlayerPedId())

				local dstCheck = GetDistanceBetweenCoords(pedCoords, doorCoords, true)

				if dstCheck <= 10.0 then
					local safeDoor = GetClosestObjectOfType(doorCoords, 5.0, GetHashKey("v_ilev_gangsafedoor"), 0, 0, 0)

					ControlDoor(false, safeDoor)

					break
				end

				Citizen.Wait(sleepThread)
			end
		end)

		Citizen.CreateThread(function()
			while cachedSafes[eventData["store"]] do
				local sleepThread = 500

				local pedCoords = GetEntityCoords(PlayerPedId())

				for objectIndex = 1, #eventData["objects"] do
					if NetworkDoesEntityExistWithNetworkId(eventData["objects"][objectIndex]) then
						local breachObject = NetToObj(eventData["objects"][objectIndex])

						local dstCheck = GetDistanceBetweenCoords(pedCoords, GetEntityCoords(breachObject), true)

						if dstCheck <= 2.0 then
							sleepThread = 5

							if IsControlJustPressed(0, 47) then
								TakeSafeItem(breachObject, eventData)

								Citizen.Wait(5)
							end

							ESX.Game.Utils.DrawText3D(GetEntityCoords(breachObject), "[G]", 0.4)
						end
					end
				end

				Citizen.Wait(sleepThread)
			end

			for objectIndex = 1, #eventData["objects"] do
				if NetworkDoesEntityExistWithNetworkId(eventData["objects"][objectIndex]) then
					local breachObject = NetToObj(eventData["objects"][objectIndex])

					while not NetworkHasControlOfEntity(breachObject) do
						Citizen.Wait(0)
				
						NetworkRequestControlOfEntity(breachObject)
					end

					if DoesEntityExist(breachObject) then
						DeleteEntity(breachObject)
					end
				end
			end
		end)
	elseif event == "close_door" then
		if cachedSafes[eventData["store"]] then
			cachedSafes[eventData["store"]] = nil
		end

		local safeCoords = vector3(eventData["safeCoords"]["x"], eventData["safeCoords"]["y"], eventData["safeCoords"]["z"])
		local pedCoords = GetEntityCoords(PlayerPedId())

		local dstCheck = GetDistanceBetweenCoords(pedCoords, safeCoords, true)

		if dstCheck <= 30.0 then
			local safeDoor = GetClosestObjectOfType(safeCoords, 5.0, GetHashKey("v_ilev_gangsafedoor"), 0, 0, 0)

			if math.ceil(GetEntityRotation(safeDoor)) ~= math.ceil(eventData["doorRotation"]) then
				ControlDoor(true, safeDoor)
			end
		end
	else
		-- print("Wrong event handler.")
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		local sleepThread = 500
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local closestSafe = GetClosestObjectOfType(coords, 5.0, -1375589668, false, false, false)

		if DoesEntityExist(closestSafe) then
			local closestSafeaAtCoords = GetEntityCoords(closestSafe)

			local dstCheck = GetDistanceBetweenCoords(coords, closestSafeaAtCoords, true)

			local currentStreetName = GetCurrentStreetName()

			if dstCheck <= 2.5 then 
				local display = cachedSafes[currentStreetName] == nil

				if display then
					sleepThread = 5
						if dstCheck <= 1.0 then
							if isRobbable then
								Draw3DText(coords.x, coords.y, coords.z + 0.5, '[E] - To attempt to crack the safe')
								if IsControlJustReleased(0, 38) then
									checkSafe(closestSafe)
								end
							else
								Draw3DText(coords.x, coords.y, coords.z + 0.5, 'Rob the store to gain access to try and crack the safe.')
							end
						end
					local markerCoords = GetOffsetFromEntityInWorldCoords(closestSafe, -0.35, -0.3, -1.2 + 0.5)

					DrawScriptMarker({
						["type"] = 27,
						["pos"] = markerCoords
					})
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

function checkSafe(closestSafe)
	Citizen.Wait(100)
	ESX.TriggerServerCallback('tprp:GetJobCountCallBack', function(jobCount)
		if jobCount >= 2 then
			TryToCrack(closestSafe)
		else
			exports['mythic_notify']:SendAlert('error', 'Something doesn\'t feel right.', 7000)	
		end
	end, "police")
end


RegisterNetEvent("tp:storeRobbed")
AddEventHandler("tp:storeRobbed", function()
	isRobbable = true
end)

RegisterNetEvent("tp:setToFalse")
AddEventHandler("tp:setToFalse", function()
	isRobbable = false
end)

function Draw3DText(x,y,z, text)
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
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


