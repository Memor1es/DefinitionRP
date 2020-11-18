ESX = nil
waitingForJob = false
onJob = false
carSpawned = false
tracking = false
polTracking = false
trackingBlip = nil
carLocation = {}

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

                                                            Citizen.CreateThread(function() -- debug print
                                                                while true do
                                                                    Citizen.Wait(1000)
                                                                    --[[ print("Waiting: " .. tostring(waitingForJob))
                                                                    print("On Job: " .. tostring(onJob))
                                                                    print("Car Spawned: " .. tostring(carSpawned)) ]]
                                                                end
                                                            end)


----------------- Start of Code -----------------
-------------------------------------------------

Citizen.CreateThread(function()
    while true do
        if not waitingForJob and not onJob then
            sleepTime = 500
            local playerPos = GetEntityCoords(PlayerPedId())
            local dist = #(playerPos - vector3(Config.RaymondLoc['x'], Config.RaymondLoc['y'], Config.RaymondLoc['z']))
            if (dist < 2.0) then
                sleepTime = 0
                Draw3DText(Config.RaymondLoc['x'], Config.RaymondLoc['y'], Config.RaymondLoc['z'], "Press [E] for a job")
                if IsControlJustReleased(0, 38) then -- Accept The Job
                    TriggerServerEvent('tp-carthief:startJob')
                end
            end
        end

        if waitingForJob and not onJob then
            sleepTime = 0
            timer = GetGameTimer()
            if ((timer - currTime) > Config.WaitTime) then
                -- print("time up")
                TriggerServerEvent('tp-carthief:waitTimerFinished')
                onJob = true
            end
        end
        Citizen.Wait(sleepTime)
    end
end)

RegisterNetEvent('tp-carthief:jobStage1')
AddEventHandler('tp-carthief:jobStage1', function()
    currTime = GetGameTimer()
    waitingForJob = true
end)

RegisterNetEvent('tp-carthief:jobStage2')
AddEventHandler('tp-carthief:jobStage2', function(car, location)
    print(car)
    print(location.x)
    print(location.y)
    print(location.z)
    print(location.info)
    carSpawned = true
    carLocation = {x = location.x, y = location.y, z = location.z}
    spawnCar(car, location.x, location.y, location.z)
    tracker(car, location.x, location.y, location.z)
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

--[[ RegisterNetEvent('tp-carthief:CreateBlip')
AddEventHandler('tp-carthief:CreateBlip', function(veh)
    blip = AddBlipForEntity(veh)
    SetBlipAsShortRange(blip, true)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 5)
    ShowHeadingIndicatorOnBlip(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Stolen Car")
    EndTextCommandSetBlipName(blip)
end) ]]