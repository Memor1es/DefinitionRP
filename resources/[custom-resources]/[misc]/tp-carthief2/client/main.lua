ESX = nil
local PlayerData              	= {}
local currentZone               = ''
local LastZone                  = ''
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

local alldeliveries             = {}
local randomdelivery            = 1
local isTaken                   = 0
local isDelivered               = 0
local waitingForJob             = 0
local StillTracking             = 0
local car						= 0
local copblip
local deliveryblip


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function SpawnCar(carModel, location)
    TriggerServerEvent('tp-carthief:sendCarMsg', carModel, location.info)
    randomspawn = location
    randomdelivery = math.random(1,#Config.DeliveryLocations)
    ClearAreaOfVehicles(location.x, location.y, location.z, 10.0, false, false, false, false, false)
    SetEntityAsNoLongerNeeded(car)
    DeleteVehicle(car)
    RemoveBlip(deliveryblip)
    randomcar = carModel
    local vehiclehash = GetHashKey(carModel)
    RequestModel(vehiclehash)
    while not HasModelLoaded(vehiclehash) do
        RequestModel(vehiclehash)
        Citizen.Wait(1)
    end
    car = CreateVehicle(vehiclehash, location.x, location.y, location.z, 0.0, true, false)
    SetEntityAsMissionEntity(car, true, true)
    local plate = GetVehicleNumberPlateText(car)
    TriggerServerEvent('garage:addKeys', plate)
    posUpdate(location)
    carDespawnTimer()
    TriggerServerEvent('tp-carthief:registerActivity', 1)
    isTaken = 1
    isDelivered = 0
end

RegisterNetEvent('tp-carthief:showDeliveryLocation')
AddEventHandler('tp-carthief:showDeliveryLocation', function()
    deliveryblip = AddBlipForCoord(Config.DeliveryLocations[randomdelivery].x, Config.DeliveryLocations[randomdelivery].y, Config.DeliveryLocations[randomdelivery].z)
    SetBlipSprite(deliveryblip, 1)
    SetBlipDisplay(deliveryblip, 4)
    SetBlipScale(deliveryblip, 1.0)
    SetBlipColour(deliveryblip, 5)
    SetBlipAsShortRange(deliveryblip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Delivery point")
    EndTextCommandSetBlipName(deliveryblip)
    SetBlipRoute(deliveryblip, true)
end)

function posUpdate(location)
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            local playerPos = GetEntityCoords(PlayerPedId())
            local dist = #(playerPos - vector3(location.x, location.y, location.z))
            if (dist < 1.0) then
                exports['mythic_notify']:SendAlert('error', 'This looks like the right car!', 10000)
                Citizen.Wait(3000)
                exports['mythic_notify']:SendAlert('error', 'The car is beeping, it sounds like a tracker has been activated!', 10000)
                trackerUpdate()
                break
            end
        end
    end)
end

function trackerUpdate()
    StillTracking = 1
    startTime = GetGameTimer()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(100)
            currentTime = GetGameTimer()
            if ((currentTime - startTime) > (Config.TrackerTimeMinutes * 60000)) then
                StillTracking = 0
                TriggerServerEvent('tp-carthief:stopalertcops')
                TriggerServerEvent('tp-carthief:stoppedTrackingMsg')
                exports['mythic_notify']:SendAlert('error', 'The beeping has stopped!', 10000)
                break
            end
        end
    end)
end

function FinishDelivery()
    if(GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) and GetEntitySpeed(car) < 3 then
        local bodydamage = GetVehicleBodyHealth(GetVehiclePedIsUsing(GetPlayerPed(-1)))
        local engdamage = GetVehicleEngineHealth(GetVehiclePedIsUsing(GetPlayerPed(-1)))

        TriggerServerEvent('tp-carthief:pay', bodydamage, engdamage)
        SetEntityAsNoLongerNeeded(car)
        DeleteEntity(car)
        RemoveBlip(deliveryblip)
        TriggerServerEvent('tp-carthief:registerActivity', 0)
        isTaken = 0
        isDelivered = 1
        waitingForJob = 0
        StillTracking = 0
        TriggerServerEvent('tp-carthief:stopalertcops')
    else
        exports['mythic_notify']:SendAlert('error', 'This is not the correct car!', 10000)
    end
end

function AbortDelivery()
	SetEntityAsNoLongerNeeded(car)
	DeleteEntity(car)
	RemoveBlip(deliveryblip)
	TriggerServerEvent('tp-carthief:registerActivity', 0)
	isTaken = 0
    isDelivered = 1
    waitingForJob = 0
    StillTracking = 0
	TriggerServerEvent('tp-carthief:stopalertcops')
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(Config.BlipUpdateTime)
        if isTaken == 1 and IsPedInAnyVehicle(GetPlayerPed(-1)) and StillTracking == 1 then
                local coords = GetEntityCoords(GetPlayerPed(-1))
                TriggerServerEvent('tp-carthief:alertcops', coords.x, coords.y, coords.z)
        elseif isTaken == 1 and not IsPedInAnyVehicle(GetPlayerPed(-1)) and StillTracking == 1 then
                TriggerServerEvent('tp-carthief:stopalertcops')
        end
    end
end)

RegisterNetEvent('tp-carthief:removecopblip')
AddEventHandler('tp-carthief:removecopblip', function()
		RemoveBlip(copblip)
end)

RegisterNetEvent('tp-carthief:setcopblip')
AddEventHandler('tp-carthief:setcopblip', function(cx,cy,cz)
		RemoveBlip(copblip)
        copblip = AddBlipForCoord(cx,cy,cz)
        SetBlipSprite(copblip , 161)
        SetBlipScale(copblipy , 2.0)
		SetBlipColour(copblip, 8)
		PulseBlip(copblip)
end)

RegisterNetEvent('tp-carthief:setcopnotification')
AddEventHandler('tp-carthief:setcopnotification', function()
	ESX.ShowNotification(_U('car_stealing_in_progress'))
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isTaken == 1 and isDelivered == 0 and StillTracking == 0 then
        local coords = GetEntityCoords(GetPlayerPed(-1))
            v = Config.DeliveryLocations[randomdelivery]
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) and (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
                local what, groundZ = GetGroundZFor_3dCoord(v.x, v.y, v.z)
                DrawMarker(1, v.x, v.y, groundZ, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 63, 191, 191, 100, false, false, 2, false, false, false, false)
            end
            if (GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 5.0) and (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
                Draw3DText(v.x, v.y, v.z, "Press [E] to deliver the car")
                if IsControlJustReleased(0, 38) then
                    StartFinishDelivery()
                end
            end
        end
    end
end)

function StartFinishDelivery()
    exports['mythic_progbar']:Progress({
        name = "carthief_delivery",
        duration = 6000,
        label = "Delivering Car",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        },
    }, function(status)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        if (GetDistanceBetweenCoords(coords, Config.DeliveryLocations[randomdelivery].x, Config.DeliveryLocations[randomdelivery].y, Config.DeliveryLocations[randomdelivery].z, true) > 5.0) then
            exports['mythic_notify']:SendAlert('error', 'You moved from the delivery area!', 10000)
            return
        end
        if not status then
            FinishDelivery()
        else
            print("you moved")
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        sleepTime = 500
        if waitingForJob == 0 and isTaken == 0 then
            local playerPos = GetEntityCoords(PlayerPedId())
            local dist = #(playerPos - vector3(Config.RaymondLoc['x'], Config.RaymondLoc['y'], Config.RaymondLoc['z']))
            if (dist < 2.0) then
                sleepTime = 0
                Draw3DText(Config.RaymondLoc['x'], Config.RaymondLoc['y'], Config.RaymondLoc['z'], "Press [E] for a job")
                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('tp-carthief:startJob')
                end
            end
        end
        Citizen.Wait(sleepTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        sleepTime = 500
        if waitingForJob == 1 and isTaken == 0 then
            sleepTime = 0
            timer = GetGameTimer()
            if ((timer - currTime) > Config.WaitTime) then
                TriggerServerEvent('tp-carthief:waitTimerFinished')
                isTaken = 1
            end
        end
        Citizen.Wait(sleepTime)
    end
end)

RegisterNetEvent('tp-carthief:jobStage1')
AddEventHandler('tp-carthief:jobStage1', function()
    ESX.TriggerServerCallback('tp-carthief:isActive', function(isActive, cooldown)
        ESX.TriggerServerCallback('tp-carthief:anycops', function(anycops)
            if anycops >= Config.CopsRequired then
                if cooldown <= 0 then
                    if isActive == 0 then
                        currTime = GetGameTimer()
                        waitingForJob = 1
                    else
                        exports['mythic_notify']:SendAlert('error', 'I\'ve already hired someone! Come back later, I\'ve got something in mind for you!', 10000)
                        AbortDelivery()
                    end
                else
                    exports['mythic_notify']:SendAlert('error', 'Do you hear that?! Sirens. Come back in ' .. math.ceil(cooldown/1000) .. " seconds.", 10000) -- Change to minutes
                    AbortDelivery()
                end
            else
                exports['mythic_notify']:SendAlert('error', 'We should wait for more cops... it\'ll be fun!', 10000)
            end
        end)
    end)
end)

RegisterNetEvent('tp-carthief:jobStage2')
AddEventHandler('tp-carthief:jobStage2', function(car, location)
    carSpawned = true
    carLocation = {x = location.x, y = location.y, z = location.z}
    SpawnCar(car, location)
end)

function carDespawnTimer()
    local startTime = GetGameTimer()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            currentTime = GetGameTimer()
            if (currentTime - startTime) > (Config.DespawnTimerMinutes * 60000) then
                if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
                    AbortDelivery()
                    -- Send Notification of shite
                    TriggerServerEvent('tp-carthief:sendFailMsg')
                    break
                end
                if (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
                    -- we have the car, let us continue
                end
            end
            if isTaken == 0 and isDelivered == 1 then
                -- we delivered the car, stop the timer
                break
            end
        end
    end)
end

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