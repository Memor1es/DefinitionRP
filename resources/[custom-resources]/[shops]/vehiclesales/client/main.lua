ESX = nil
PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent("esx:getSharedObject", function(response)
            ESX = response
        end)
    end

    if ESX.IsPlayerLoaded() then
		PlayerData = ESX.GetPlayerData()
		RemoveVehicles()
		Citizen.Wait(500)
		LoadSellPlace()
		SpawnVehicles()
    end
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(response)
	PlayerData = response
	LoadSellPlace()
	SpawnVehicles()
end)

RegisterNetEvent("LG_CLBan")
AddEventHandler("LG_CLBan", function()
	TriggerServerEvent('LG:BannedModdaFukka')
end)

RegisterNetEvent("esx_lg_vehiclesale:refreshVehicles")
AddEventHandler("esx_lg_vehiclesale:refreshVehicles", function()
	RemoveVehicles()
	Citizen.Wait(500)
	SpawnVehicles()
end)

RegisterNetEvent("tp:financeChecked")
AddEventHandler("tp:financeChecked", function()
	local ped = PlayerPedId()
	OpenSellMenu(GetVehiclePedIsUsing(ped))
end)

function LoadSellPlace()
	Citizen.CreateThread(function()
		local SellPos = Config.SellPosition
		local Blip = AddBlipForCoord(SellPos["x"], SellPos["y"], SellPos["z"])
		SetBlipSprite (Blip, 147)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 0.8)
		SetBlipColour (Blip, 50)
		SetBlipAsShortRange(Blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Secondhand Vehicles")
		EndTextCommandSetBlipName(Blip)

		while true do
			local sleepThread = 500
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			local dstCheck = GetDistanceBetweenCoords(pedCoords, SellPos["x"], SellPos["y"], SellPos["z"], true)

			if dstCheck <= 10.0 then
				sleepThread = 5
				if dstCheck <= 4.2 then
					DrawText3Ds(SellPos.x, SellPos.y, SellPos.z + 1.5, "[~g~E~w~] Open menu")
					if IsControlJustPressed(0, 38) then
						if IsPedInAnyVehicle(ped, false) then
							local vehicle = GetVehiclePedIsIn(PlayerPedId())

                            TriggerServerEvent("tp:checkFinance", GetVehicleNumberPlateText(vehicle))
							--OpenSellMenu(GetVehiclePedIsUsing(ped))
						else
							exports['mythic_notify']:SendAlert('error', 'You must sit in/on the vehicle!')
							--TriggerEvent("pNotify:SendNotification", {text = 'You must sit in/on the vehicle!', layout = "bottomCenter", timeout = 5000, type = 'error', progressBar = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
						end
					end
				end
			end

			--[[ for i = 1, #Config.VehiclePositions, 1 do
				if Config.VehiclePositions[i]["entityId"] ~= nil then
					local pedCoords = GetEntityCoords(ped)
					local vehCoords = GetEntityCoords(Config.VehiclePositions[i]["entityId"])
					local dstCheck = GetDistanceBetweenCoords(pedCoords, vehCoords, true)
					if dstCheck <= 2.0 then
						sleepThread = 5
						DrawText3Ds(vehCoords.x, vehCoords.y, vehCoords.z + 1.0, "[~g~E~w~] ".. Config.VehiclePositions[i]["price"] .." - Sit in the car and Press [E]")
						if IsControlJustPressed(0, 38) then
							if IsPedInVehicle(ped, Config.VehiclePositions[i]["entityId"], false) then
								OpenSellMenu(Config.VehiclePositions[i]["entityId"], Config.VehiclePositions[i]["price"], true, Config.VehiclePositions[i]["owner"])
							else
								exports['mythic_notify']:SendAlert('error', 'You must sit in/on the vehicle!')
								--TriggerEvent("pNotify:SendNotification", {text = 'You must sit in/on the vehicle!', layout = "bottomCenter", timeout = 5000, type = 'error', progressBar = true, animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
							end
						end
					end
				end
            end ]]
            

            for i = 1, #Config.VehiclePositions, 1 do
				if Config.VehiclePositions[i]["entityId"] ~= nil then
					local pedCoords = GetEntityCoords(ped)
					local vehCoords = GetEntityCoords(Config.VehiclePositions[i]["entityId"])					
					local vehProps = ESX.Game.GetVehicleProperties(Config.VehiclePositions[i]["entityId"])
					local vehName1 = GetEntityModel(Config.VehiclePositions[i]["entityId"])
					local vehName2 = GetLabelText(GetDisplayNameFromVehicleModel(vehName1))
					local turbs = 'No'
					local engine = 'Stock'
					local gearbox = 'Stock'
					local suspension = 'Stock'
					local randombool, Ground = GetGroundZFor_3dCoord(vehCoords.x, vehCoords.y, vehCoords.z)
					
					if vehProps.modTurbo and vehProps.modTurbo > 0 then 
						turbs = 'Yes'
					end
					if vehProps.modEngine >= 0 then
						engine = ("Level " .. tostring(vehProps.modEngine + 1))
					end
					if vehProps.modTransmission >= 0 then
						gearbox = ("Level " .. tostring(vehProps.modTransmission + 1))
					end
					if vehProps.modSuspension >= 0 then
						suspension = ("Level " .. tostring(vehProps.modSuspension + 1))
					end
					

					local dstCheck = GetDistanceBetweenCoords(pedCoords, vehCoords, true)
					if dstCheck <= 2.0 then
						sleepThread = 5
						drawTextA = "[" .. vehName2 .. " - $" .. Config.VehiclePositions[i]["price"] .. "]"
						drawTextB = "[Turbo: ~r~" .. turbs .. "~s~] [Engine: ~r~" .. engine .. "~s~]"
						drawTextC = "[Gearbox: ~r~" .. gearbox .. "~s~] [Suspension: ~r~" .. suspension .. "~s~]"
						DrawText3Ds(vehCoords.x, vehCoords.y, Ground + 1.81, drawTextA)
						DrawText3Ds(vehCoords.x, vehCoords.y, Ground + 1.7, drawTextB)
                        DrawText3Ds(vehCoords.x, vehCoords.y, Ground + 1.59, drawTextC)
                        DrawText3Ds(vehCoords.x, vehCoords.y, Ground + 1.48, "Sit in/on and press [~g~E~w~]")
                        

						if IsControlJustPressed(0, 38) then
							if IsPedInVehicle(ped, Config.VehiclePositions[i]["entityId"], false) then
								OpenSellMenu(Config.VehiclePositions[i]["entityId"], Config.VehiclePositions[i]["price"], true, Config.VehiclePositions[i]["owner"])
							else
								exports['mythic_notify']:SendAlert('error', 'You must sit in/on the vehicle!')
							end
						end
					end
                end
            end
			Citizen.Wait(sleepThread)
		end
	end)
end

function OpenSellMenu(veh, price, buyVehicle, owner)
	local elements = {}
	if not buyVehicle then
		if price ~= nil then
			table.insert(elements, { ["label"] = "Change price - " .. price .. " :-", ["value"] = "price" })
			table.insert(elements, { ["label"] = "Show for sale", ["value"] = "sell" })
		else
			table.insert(elements, { ["label"] = "Set price - :-", ["value"] = "price" })
		end
	else
		table.insert(elements, { ["label"] = "Buy using bank card " .. price .. " - Money has to be in bank", ["value"] = "buy" })
		if owner then
			table.insert(elements, { ["label"] = "Remove vehicle", ["value"] = "remove" })
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Used Car Sales",
			align    = 'bottom-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value
		if action == "price" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_veh_price',
				{
					title = "Vehicle Price"
				},
			function(data2, menu2)
				local vehPrice = tonumber(data2.value)
				menu2.close()
				menu.close()
				OpenSellMenu(veh, vehPrice)
            end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "sell" then
			local vehProps = ESX.Game.GetVehicleProperties(veh)
			local model = GetEntityModel(veh)
			local displaytext = GetDisplayNameFromVehicleModel(model)
			local name = GetLabelText(displaytext)
			local carDetails = { name = name, displayText = displaytext:lower(), model = model}
			ESX.TriggerServerCallback("esx_lg_vehiclesale:isVehicleValid", function(valid, maxprice)
				if valid == 'yes' then
					DeleteVehicle(veh)
					exports['mythic_notify']:SendAlert('inform', 'You put the vehicle up for sale: '.. price ..'')
					menu.close()
				elseif valid == 'no' then
					exports['mythic_notify']:SendAlert('error', 'You have to own the vehicle, Either that or you vehicle is allready for sale.')
				elseif valid == 'full' then 
					exports['mythic_notify']:SendAlert('error', 'The used car lot is full.')
				elseif valid == 'tomuch' then
					exports['mythic_notify']:SendAlert('error', 'Vehicles can be sold for a maximum of 50% profit from the original purchase price, (Max: $'..maxprice..')')
				end
			end, vehProps, price, carDetails)
		elseif action == "buy" then
			ESX.TriggerServerCallback("esx_lg_vehiclesale:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					menu.close()
				else
					exports['mythic_notify']:SendAlert('error', 'You do not have enough money, it is missing' .. price - totalMoney ..':-')
				end
			end, ESX.Game.GetVehicleProperties(veh), price)
		elseif action == "remove" then
			ESX.TriggerServerCallback("esx_lg_vehiclesale:removeVehicleLG", function(isPurchasable, totalMoney)
				if isPurchasable then
					DeleteVehicle(veh)
					exports['mythic_notify']:SendAlert('success', 'You took away the vehicle!')
					menu.close()
				end
			end, ESX.Game.GetVehicleProperties(veh), 0)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent("LG_DeleteVehicle")
AddEventHandler("LG_DeleteVehicle", function(price)
	DeleteVehicle(GetVehiclePedIsUsing(PlayerPedId()))
	exports['mythic_notify']:SendAlert('success', 'You bought the vehicle for $' .. price ..' and has been transported to Garage A', 5000)
end)

function RemoveVehicles()
	local VehPos = Config.VehiclePositions
	for i = 1, #VehPos, 1 do
		local veh, distance = ESX.Game.GetClosestVehicle(VehPos[i])
		if DoesEntityExist(veh) and distance <= 1.0 then
			DeleteEntity(veh)
		end
	end
end

function SpawnVehicles()
	local VehPos = Config.VehiclePositions
	ESX.TriggerServerCallback("esx_lg_vehiclesale:retrieveVehicles", function(vehicles)
		for i = 1, #vehicles, 1 do
			local vehicleProps = vehicles[i]["vehProps"]
			LoadModel(vehicleProps["model"])
			VehPos[i]["entityId"] = CreateVehicle(vehicleProps["model"], VehPos[i]["x"], VehPos[i]["y"], VehPos[i]["z"] - 0.975, VehPos[i]["h"], false)
			VehPos[i]["price"] = vehicles[i]["price"]
			VehPos[i]["owner"] = vehicles[i]["owner"]
			ESX.Game.SetVehicleProperties(VehPos[i]["entityId"], vehicleProps)
			SetVehicleOnGroundProperly(VehPos[i]["entityId"])
			FreezeEntityPosition(VehPos[i]["entityId"], true)
			SetEntityAsMissionEntity(VehPos[i]["entityId"], true, true)
			SetModelAsNoLongerNeeded(vehicleProps["model"])
		end
	end)
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(1)
	end
end



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
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end