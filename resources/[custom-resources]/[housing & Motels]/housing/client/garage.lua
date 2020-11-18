fetchedVehicles = {}

function OpenGarageMenu(garage, coords, heading)
    ESX.TriggerServerCallback('betrayed_garage:obtenerVehiculos', function(vehicles)
        EnvioVehLocal(garage, vehicles[1], coords, heading)

    end, garage)
end

function EnvioVehLocal(garage, veh, coords, heading)
    local slots = {}
    for c,v in pairs(veh) do
        table.insert(slots,{["garage"] = v.garage, ["vehicle"] = json.decode(v.vehicle)})
    end
    fetchedVehicles = slots

    for k,v in pairs(fetchedVehicles)  do
        fetchedVehicles[k].plate = fetchedVehicles[k]["vehicle"]["plate"]
        fetchedVehicles[k].label = fetchedVehicles[k].plate .. " - " ..GetLabelText(GetDisplayNameFromVehicleModel(fetchedVehicles[k]["vehicle"]["model"]))
    end

    if #fetchedVehicles == 0 then
        table.insert(fetchedVehicles,{["label"] = "Garage Empty", ["action"] = "none"})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'house-garage',
    {
        title = "House Garage " ..garage,
        align = "bottom-right",
        elements = fetchedVehicles
    },
    function(data, menu)
        if data.current["action"] == "none" then
            menu.close()
        else
            SpawnVehicle(data.current["vehicle"], data.current.plate, coords, heading)
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end, function(data, menu)
    end)
end


function SpawnVehicle(vehicle, plate, coords, heading)
    PrintTableOrString(coords)
    vehicleProps = vehicle
    WaitForModel(vehicleProps["model"])
    if not ESX.Game.IsSpawnPointClear(coords, 3.0) then 
		exports['mythic_notify']:DoHudText('inform', 'Please move the vehicle off the road')
		return
    end

    heading = math.ceil(heading * 100) / 100

    ESX.Game.SpawnVehicle(vehicleProps["model"], coords, heading, function(yourVehicle)
        SetVehicleProperties(yourVehicle, vehicleProps)
		SetModelAsNoLongerNeeded(vehicleProps["model"])
		TaskWarpPedIntoVehicle(PlayerPedId(), yourVehicle, -1)

        SetEntityAsMissionEntity(yourVehicle, true, true)
        
        local plate = GetVehicleNumberPlateText(yourVehicle)
        TriggerServerEvent('garage:addKeys', plate)
        Citizen.Wait(100)
        local vehName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps["model"]))
        TriggerServerEvent('betrayed_garage:modifystate', vehicleProps, 0, nil,vehName)
    end)
end


WaitForModel = function(model)
    local DrawScreenText = function(text, red, green, blue, alpha)
        SetTextFont(4)
        SetTextScale(0.0, 0.5)
        SetTextColour(red, green, blue, alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
    
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(0.5, 0.5)
    end

    if not IsModelValid(model) then
        return exports['mythic_notify']:DoHudText('inform', 'This model does not exist in the game, send a report!')
    end

	if not HasModelLoaded(model) then
		RequestModel(model)
	end
	
	while not HasModelLoaded(model) do
		Citizen.Wait(0)

		DrawScreenText("Looking for you " .. GetDisplayNameFromVehicleModel(model) .. "...", 255, 255, 255, 150)
	end
end


SetVehicleProperties = function(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

    SetVehicleEngineHealth(vehicle, vehicleProps["engineHealth"] and vehicleProps["engineHealth"] + 0.0 or 1000.0)
    SetVehicleBodyHealth(vehicle, vehicleProps["bodyHealth"] and vehicleProps["bodyHealth"] + 0.0 or 1000.0)
    SetVehicleFuelLevel(vehicle, vehicleProps["fuelLevel"] and vehicleProps["fuelLevel"] + 0.0 or 1000.0)

    --[[ if vehicleProps["windows"] then
        for windowId = 1, 13, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end ]]

    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end

    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
end

GetVehicleProperties = function(vehicle)
    if DoesEntityExist(vehicle) then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

        vehicleProps["tyres"] = {}
        vehicleProps["windows"] = {}
        vehicleProps["doors"] = {}

        for id = 1, 7 do
            local tyreId = IsVehicleTyreBurst(vehicle, id, false)
        
            if tyreId then
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = tyreId
        
                if tyreId == false then
                    tyreId = IsVehicleTyreBurst(vehicle, id, true)
                    vehicleProps["tyres"][ #vehicleProps["tyres"]] = tyreId
                end
            else
                vehicleProps["tyres"][#vehicleProps["tyres"] + 1] = false
            end
        end

        --[[ for id = 1, 13 do
            local windowId = IsVehicleWindowIntact(vehicle, id)

            if windowId ~= nil then
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = windowId
            else
                vehicleProps["windows"][#vehicleProps["windows"] + 1] = true
            end
        end ]]
        
        for id = 0, 5 do
            local doorId = IsVehicleDoorDamaged(vehicle, id)
        
            if doorId then
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = doorId
            else
                vehicleProps["doors"][#vehicleProps["doors"] + 1] = false
            end
        end

        vehicleProps["engineHealth"] = GetVehicleEngineHealth(vehicle)
        vehicleProps["bodyHealth"] = GetVehicleBodyHealth(vehicle)
        vehicleProps["fuelLevel"] = GetVehicleFuelLevel(vehicle)

        return vehicleProps
    end
end



function PrintTableOrString(t, s)
    if t then
        if type(t) ~= 'table' then 
            print("^1 [^3debug^1] ["..type(t).."] ^7", t)
            return
        else
            for k, v in pairs(t) do
                local kfmt = '["' .. tostring(k) ..'"]'
                if type(k) ~= 'string' then
                    kfmt = '[' .. k .. ']'
                end
                local vfmt = '"'.. tostring(v) ..'"'
                if type(v) == 'table' then
                    PrintTableOrString(v, (s or '')..kfmt)
                else
                    if type(v) ~= 'string' then
                        vfmt = tostring(v)
                    end
                    print(" ^1[^3debug^1] ["..type(t).."]^7", (s or '')..kfmt, '=', vfmt)
                end
            end
        end
    else
        print("^1Error Printing Request - The Passed through variable seems to be nil^7")
    end
end




RegisterNetEvent('housing:storeCar')
AddEventHandler('housing:storeCar', function(house)
    PrintTableOrString(house)

    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    local vehicleProps = GetVehicleProperties(vehicle)
    TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
	
    while IsPedInVehicle(PlayerPedId(), vehicle, true) do
        Citizen.Wait(0)
    end
    Citizen.Wait(300)

    --NetworkFadeOutEntity(vehicle, true, true)
    exports['mythic_notify']:DoHudText('success', 'You saved your vehicle in your house garage ')
    Citizen.Wait(500)

    deleteCar(vehicle)
    local vehName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps["model"]))
    TriggerServerEvent('betrayed_garage:modifystate', vehicleProps, 1, house,vehName)
end)

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end