local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer) PlayerData = xPlayer end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.37, 0.37)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 33, 33, 33, 133)
end
---Hanger 1
local Cancelled = false
local RecieveVehicle = {x = 221.45880126953, y = -2967.1662597656, z = 5.8969}
local CarCoord = {x = 138.2465057373, y = -3089.1518554688, z = 5.89631}
local Car = {x = 145.67060852051, y = -3108.6743164063, z = 5.896}
local DistanceOrder = {x = 152.32009887695, y = -3101.5874023438, z = 5.8963}
local Completed = false
local EngineOn = false
local VehicleType = nil
local AutoSticker = 0
---pickups and bonuses
local PickUp1 = {x = 161.97207641602, y = -3142.4104003906, z = 5.959}
local PickUp2 = {x = 161.18479919434, y = -3041.7497558594, z = 5.974014}
local PickUp3 = {x = 166.7626953125, y = -3258.3393554688, z = 5.86072}
local PickUp4 = {x = 116.09323120117, y = -3164.1032714844, z = 6.0136}
local PickUp5 = {x = 117.36480712891, y = -2989.3310546875, z = 6.020}
local DeliveryTime = 0
local DeliveryTimer = false
local OwnedHanger = 0
local Bonus1 = 150
local Bonus2 = 100
local Bonus3 = 50
---Hanger 2
local RecieveVehicle2 = {x = 275.67260742188, y = -3166.150390625, z = 5.7902}
local CarCoord2 = {x = 158.15670776367, y = -3196.2829589844, z = 6.021}
local Car2 = {x = 146.82814025879, y = -3210.5979003906, z = 5.8575}
local DistanceOrder2 = {x = 152.90745544434, y = -3211.7609863281, z = 5.901}
local pilot
---Blip
local blips = {
     {title="Forklift", colour=5, id=473, x = 137.258, y = -3142.12, z = 18.8653},
  }
      
--[[ Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 2)
      SetBlipScale(info.blip, 0.5)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end) ]]

function ZrespPaczuszke(a)
    DeliveryTime = 0
    DeliveryTimer = true
    if a == "deski" then
        packages = CreateObject(GetHashKey("prop_boxpile_06a"), PickUp1.x,
                                PickUp1.y, PickUp1.z - 0.95, true, true, true)
        SetEntityAsMissionEntity(packages)
        SetEntityDynamic(packages, true)
        FreezeEntityPosition(packages, false)
        SetNewWaypoint(PickUp1.x, PickUp1.y)
    elseif a == "lody" then
        packages = CreateObject(GetHashKey("prop_boxpile_02b"), PickUp2.x,
                                PickUp2.y, PickUp2.z - 0.95, true, true, true)
        SetEntityAsMissionEntity(packages)
        SetEntityDynamic(packages, true)
        FreezeEntityPosition(packages, false)
        SetNewWaypoint(PickUp2.x, PickUp2.y)
    elseif a == "leki" then
        packages = CreateObject(GetHashKey("prop_boxpile_06a"), PickUp3.x,
                                PickUp3.y, PickUp3.z - 0.95, true, true, true)
        SetEntityAsMissionEntity(packages)
        SetEntityDynamic(packages, true)
        FreezeEntityPosition(packages, false)
        SetNewWaypoint(PickUp3.x, PickUp3.y)
    elseif a == "napoje" then
        packages = CreateObject(GetHashKey("prop_boxpile_09a"), PickUp4.x,
                                PickUp4.y, PickUp4.z - 0.95, true, true, true)
        SetEntityAsMissionEntity(packages)
        SetEntityDynamic(packages, true)
        FreezeEntityPosition(packages, false)
        SetNewWaypoint(PickUp4.x, PickUp4.y)
    elseif a == "kawa" then
        packages = CreateObject(GetHashKey("prop_boxpile_06a"), PickUp5.x,
                                PickUp5.y, PickUp5.z - 0.95, true, true, true)
        SetEntityAsMissionEntity(packages)
        SetEntityDynamic(packages, true)
        FreezeEntityPosition(packages, false)
        SetNewWaypoint(PickUp5.x, PickUp5.y)
    end
end

RegisterNetEvent("DeliverPackage")
AddEventHandler("DeliverPackage", function(a)
    Cancelled = false
    if a == "1" then
        if Completed == true then
            exports['mythic_notify']:SendAlert('error', 'Complete the previous order first!', 5000)
            -- ESX.ShowNotification("~r~Zakończ poprzednie zlecenie!")
            return
        end
        local b = math.random(1, 5)
        if b == 1 then
            AutoSticker = 3
            exports['mythic_notify']:SendAlert('inform', 'The delivery driver has arrived', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku desek.")
            ZrespPaczuszke("deski")
        elseif b == 2 then
            AutoSticker = 4
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the fish to be loaded', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku ryb.")
            ZrespPaczuszke("lody")
        elseif b == 3 then
            AutoSticker = 6
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the medicine to be loaded', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku lekarstw.")
            ZrespPaczuszke("leki")
        elseif b == 4 then
            AutoSticker = 2
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the drinks to be loaded', 5000)
            -- ESX.ShowNotification( "~g~Kierowca oczekuje załadunku napojów Logger Light.")
            ZrespPaczuszke("napoje")
        elseif b == 5 then
            AutoSticker = 1
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the coffee', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku kawy.")
            ZrespPaczuszke("kawa")
        end
        RequestModel(GetHashKey("benson"))
        while not HasModelLoaded(GetHashKey("benson")) do Citizen.Wait(0) end
        ClearAreaOfVehicles(RecieveVehicle.x, RecieveVehicle.y,
                            RecieveVehicle.z, 15.0, false, false, false, false,
                            false)
        transport = CreateVehicle(GetHashKey("benson"), RecieveVehicle.x,
                                  RecieveVehicle.y, RecieveVehicle.z, -2.436,
                                  996.786, 25.1887, true, true)
        SetEntityAsMissionEntity(transport)
        SetEntityHeading(transport, 52.00)
        SetVehicleDoorsLocked(transport, 2)
        SetVehicleDoorsLockedForAllPlayers(transport, true)
        SetVehicleExtra(transport, 1, true)
        SetVehicleExtra(transport, 2, true)
        SetVehicleExtra(transport, 3, true)
        SetVehicleExtra(transport, 4, true)
        SetVehicleExtra(transport, 5, true)
        SetVehicleExtra(transport, 6, true)
        SetVehicleExtra(transport, 7, true)
        SetVehicleExtra(transport, AutoSticker, false)
        RequestModel("s_m_m_security_01")
        while not HasModelLoaded("s_m_m_security_01") do Wait(10) end
        pilot = CreatePedInsideVehicle(transport, 1, "s_m_m_security_01", -1,
                                       true, true)
        SetBlockingOfNonTemporaryEvents(pilot, true)
        SetEntityInvincible(pilot, true)
        TaskVehiclePark(pilot, transport, CarCoord.x, CarCoord.y, CarCoord.z,
                        266.0, 1, 1.0, false)
        SetDriveTaskDrivingStyle(pilot, 263100)
        SetPedKeepTask(pilot, true)
        exports['mythic_notify']:SendAlert('inform', 'The driver is on his way', 5000)
        -- ESX.ShowNotification("~y~Kierowca jest w drodze.")
        Completed = true
        EngineOn = true
        Citizen.Wait(900)
        while EngineOn do
            Citizen.Wait(1000)
            local c = GetIsVehicleEngineRunning(transport)
            if c == 1 then
                Citizen.Wait(200)
            else
                EngineOn = false
            end
        end
        exports['mythic_notify']:SendAlert('inform', 'The driver has arrived and is ready for the package', 5000)
        -- ESX.ShowNotification("~r~Kierowca się zatrzymał i otworzył bagażnik")
        SetVehicleDoorOpen(transport, 5, false, false)
        backOpened = true
        local d, e, f = table.unpack(GetOffsetFromEntityInWorldCoords(transport,
                                                                      0.0, -6.0,
                                                                      -1.0))
        while backOpened do
            Citizen.Wait(2)
            DrawMarker(27, d, e, f, 0, 0, 0, 0, 0, 0, 1.7, 1.7, 1.7, 135, 31, 35,
                       150, 1, 0, 0, 0)
            local g = GetEntityCoords(packages)
            local h = Vdist(d, e, f, g.x, g.y, g.z)
            if h <= 2.0 then
                SetVehicleDoorShut(transport, 5, false)
                DeleteEntity(packages)
                backOpened = false
            end
        end
        if Cancelled == true then return end
        exports['mythic_notify']:SendAlert('inform', 'The package has been loaded into the truck.', 5000)
        -- ESX.ShowNotification("~r~Paczka załadowana, kierowca się zawija.")
        exports['mythic_notify']:SendAlert('success', 'You have loaded the package in ' .. DeliveryTime .. " seconds", 5000)
        -- ESX.ShowNotification("~w~Załadowałeś paczkę w ~b~" .. DeliveryTime .. " sekund.")
        if DeliveryTime < 51 then
            exports['mythic_notify']:SendAlert('success', 'You recieved ' .. Bonus1 .. " for a quick delivery")
            -- ESX.ShowNotification("~b~Premia ~g~" .. Bonus1 .."$~b~ za szybką dostawę")
            TriggerServerEvent("drp:CompleteJob", Bonus1)
            Citizen.Wait(200)
        elseif DeliveryTime >= 61 and DeliveryTime <= 65 then
            exports['mythic_notify']:SendAlert('success', 'You recieved ' .. Bonus2 .. " for a quick delivery")
            -- ESX.ShowNotification("~b~Premia ~g~" .. Bonus2 .."$~b~ za szybką dostawę")
            TriggerServerEvent("drp:CompleteJob", Bonus2)
            Citizen.Wait(200)
        elseif DeliveryTime >= 76 and DeliveryTime <= 85 then
            exports['mythic_notify']:SendAlert('success', 'You recieved ' .. Bonus3 .. " for a quick delivery")
            -- ESX.ShowNotification("~b~Premia ~g~" .. Bonus3 .."$~b~ za szybką dostawę")
            TriggerServerEvent("drp:CompleteJob", Bonus3)
            Citizen.Wait(200)
        elseif DeliveryTime > 85 then
            exports['mythic_notify']:SendAlert('error', 'No bonus as you took too long', 5000)
            -- ESX.ShowNotification("~w~Brak premi za szybką dostawe")
        end
        DeliveryTime = 0
        DeliveryTimer = false
        TriggerServerEvent("drp:CompleteJob", "nie")
        TaskVehicleDriveWander(pilot, transport, 50.0, 263100)
        Citizen.Wait(15000)
        DeleteEntity(transport)
        DeleteEntity(pilot)
        Completed = 0
        exports['mythic_notify']:SendAlert('inform', 'You can now accept another order', 5000)
        -- ESX.ShowNotification("~r~Możesz przyjąć kolejne zlecenie")
    elseif a == "2" then
        if Completed == true then
            exports['mythic_notify']:SendAlert('error', 'Please complete the previous order', 5000)
            -- ESX.ShowNotification("~r~Zakończ poprzednie zlecenie!")
            return
        end
        local b = math.random(1, 5)
        if b == 1 then
            AutoSticker = 3
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the package', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku desek.")
            ZrespPaczuszke("deski")
        elseif b == 2 then
            AutoSticker = 4
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the fish to be loaded', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku ryb.")
            ZrespPaczuszke("lody")
        elseif b == 3 then
            AutoSticker = 6
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the medication to be loaded', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku lekarstw.")
            ZrespPaczuszke("leki")
        elseif b == 4 then
            AutoSticker = 2
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the drink to be loaded', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku napojów Logger Light.")
            ZrespPaczuszke("napoje")
        elseif b == 5 then
            AutoSticker = 1
            exports['mythic_notify']:SendAlert('inform', 'The driver is waiting for the coffee to be loaded', 5000)
            -- ESX.ShowNotification("~g~Kierowca oczekuje załadunku kawy.")
            ZrespPaczuszke("kawa")
        end
        RequestModel(GetHashKey("benson"))
        while not HasModelLoaded(GetHashKey("benson")) do Citizen.Wait(0) end
        ClearAreaOfVehicles(RecieveVehicle.x, RecieveVehicle.y,
                            RecieveVehicle.z, 15.0, false, false, false, false,
                            false)
        transport = CreateVehicle(GetHashKey("benson"), RecieveVehicle2.x,
                                  RecieveVehicle2.y, RecieveVehicle2.z, -2.436,
                                  996.786, 25.1887, true, true)
        SetEntityAsMissionEntity(transport)
        SetEntityHeading(transport, 52.00)
        SetVehicleDoorsLocked(transport, 2)
        SetVehicleDoorsLockedForAllPlayers(transport, true)
        SetVehicleExtra(transport, 1, true)
        SetVehicleExtra(transport, 2, true)
        SetVehicleExtra(transport, 3, true)
        SetVehicleExtra(transport, 4, true)
        SetVehicleExtra(transport, 5, true)
        SetVehicleExtra(transport, 6, true)
        SetVehicleExtra(transport, 7, true)
        SetVehicleExtra(transport, AutoSticker, false)
        RequestModel("s_m_m_security_01")
        while not HasModelLoaded("s_m_m_security_01") do Wait(10) end
        pilot = CreatePedInsideVehicle(transport, 1, "s_m_m_security_01", -1,
                                       true, true)
        SetBlockingOfNonTemporaryEvents(pilot, true)
        SetEntityInvincible(pilot, true)
        TaskVehiclePark(pilot, transport, CarCoord2.x, CarCoord2.y, CarCoord2.z,
                        266.0, 1, 1.0, false)
        SetDriveTaskDrivingStyle(pilot, 263100)
        SetPedKeepTask(pilot, true)
        exports['mythic_notify']:SendAlert('inform', 'The driver is on his way', 5000)
        -- ESX.ShowNotification("~y~Kierowca jest w drodze.")
        Completed = true
        EngineOn = true
        Citizen.Wait(900)
        while EngineOn do
            Citizen.Wait(1000)
            local c = GetIsVehicleEngineRunning(transport)
            if c == 1 then
                Citizen.Wait(200)
            else
                EngineOn = false
            end
        end
        exports['mythic_notify']:SendAlert('inform', 'The driver has arrived', 5000)
        -- ESX.ShowNotification("~r~Kierowca się zatrzymał i otworzył bagażnik")
        SetVehicleDoorOpen(transport, 5, false, false)
        backOpened = true
        local d, e, f = table.unpack(GetOffsetFromEntityInWorldCoords(transport,
                                                                      0.0, -6.0,
                                                                      -1.0))
        while backOpened do
            Citizen.Wait(2)
            DrawMarker(1, d, e, f, 0, 0, 0, 0, 0, 0, 1.7, 1.7, 1.7, 135, 31, 35,
                       150, 1, 0, 0, 0)
            local g = GetEntityCoords(packages)
            local h = Vdist(d, e, f, g.x, g.y, g.z)
            if h <= 2.0 then
                SetVehicleDoorShut(transport, 5, false)
                DeleteEntity(packages)
                backOpened = false
            end
        end
        if Cancelled == true then return end
        exports['mythic_notify']:SendAlert('inform', 'The package has been loaded into the truck.', 5000)
        -- ESX.ShowNotification("~r~Paczka załadowana, kierowca się zawija.")
        exports['mythic_notify']:SendAlert('success', 'You loaded the package in ' .. DeliveryTime .. " seconds", 7500)
        -- ESX.ShowNotification("~w~Załadowałeś paczkę w ~b~" .. DeliveryTime .. " sekund.")

        -- Print Payment Amount

        if DeliveryTime < 51 then
            exports['mythic_notify']:SendAlert('success', 'You recieve $' .. Bonus1 .. " for a quick delivery", 7500)
            -- ESX.ShowNotification("~b~Premia ~g~" .. Bonus1 .. "$~b~ za szybką dostawę")
            TriggerServerEvent("drp:CompleteJob", Bonus1)
            Citizen.Wait(200)
        elseif DeliveryTime >= 61 and DeliveryTime <= 75 then
            exports['mythic_notify']:SendAlert('success', 'You recieve $' .. Bonus2 .. " for a quick delivery", 7500)
            -- ESX.ShowNotification("~b~Premia ~g~" .. Bonus2 .."$~b~ za szybką dostawę")
            TriggerServerEvent("drp:CompleteJob", Bonus2)
            Citizen.Wait(200)
        elseif DeliveryTime >= 76 and DeliveryTime <= 85 then
            exports['mythic_notify']:SendAlert('success', 'You recieve $' .. Bonus3 .. " for a quick delivery", 7500)
            -- ESX.ShowNotification("~b~Premia ~g~" .. Bonus3 .."$~b~ za szybką dostawę")
            TriggerServerEvent("drp:CompleteJob", Bonus3)
            Citizen.Wait(200)
        elseif DeliveryTime > 85 then
            exports['mythic_notify']:SendAlert('error', 'You were too slow and did not recieve a bonus', 7500)
            -- ESX.ShowNotification("~w~Brak premi za szybką dostawe")
        end
        DeliveryTime = 0
        DeliveryTimer = false
        TriggerServerEvent("drp:CompleteJob", "nie")
        TaskVehicleDriveWander(pilot, transport, 50.0, 263100)
        Citizen.Wait(15000)
        DeleteEntity(transport)
        DeleteEntity(pilot)
        Completed = 0
        exports['mythic_notify']:SendAlert('inform', 'You can accepted another order', 5000)
        -- ESX.ShowNotification("~r~Możesz przyjąć kolejne zlecenie")
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if DeliveryTimer == true then
            DeliveryTime = DeliveryTime + 1
            if DeliveryTime > 140 then
                Cancelled = true
                Completed = 0
                DeliveryTime = 0
                DeliveryTimer = false
                backOpened = false
                EngineOn = false
                DeleteEntity(transport)
                DeleteEntity(pilot)
                DeleteEntity(packages)
                exports['mythic_notify']:SendAlert('error', 'Order has been canceled as you took too long', 5000)
                -- ESX.ShowNotification("~r~Zlecenie Anulowano z powodu zbyt długiego załadunku")
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        -- print(OwnedHanger)
        if DoesEntityExist(packages) then
            local paczkCoord = GetEntityCoords(packages)
            DrawMarker(2, paczkCoord.x, paczkCoord.y, paczkCoord.z + 2.1, 0, 0,
                       0, 0, 0, 0, 1.0, 1.0, 1.0, 135, 31, 35, 150, 1, 0, 0, 0)
        else
            Citizen.Wait(2500)
        end
    end
end)

RegisterNetEvent("drp:YouOwnTheHanger")
AddEventHandler("drp:YouOwnTheHanger", function(hanger)
     OwnedHanger = hanger
end)

----Hanger 1
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local distCar = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Car.x,
                              Car.y, Car.z)
        local zlecDist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z,
                               DistanceOrder.x, DistanceOrder.y, DistanceOrder.z)
---hanger markers 1
        if distCar <= 10.0 or zlecDist <= 10.0 then
            DrawMarker(27, Car.x, Car.y, Car.z - 0.90, 0, 0, 0, 0, 0, 0, 1.301,
                       1.3001, 1.3001, 255, 159, 68, 100, 0, 0, 0, 0)
            DrawMarker(27, DistanceOrder.x, DistanceOrder.y,
                       DistanceOrder.z - 0.90, 0, 0, 0, 0, 0, 0, 1.301, 1.3001,
                       1.3001, 255, 159, 68, 100, 0, 0, 0, 0)
        else
            Citizen.Wait(1500)
        end

        if distCar <= 4.0 then
            DrawText3D(Car.x, Car.y, Car.z,"Press ~g~[E]~w~ for a ~o~forklift")
            if IsControlJustPressed(0, Keys["E"]) then
                PozyczPojazd("1")
            end
        end

        if zlecDist <= 4.0 then
            DrawText3D(DistanceOrder.x, DistanceOrder.y, DistanceOrder.z,"Press ~g~[E]~w~ to take an ~y~order")
            DrawText3D(DistanceOrder.x, DistanceOrder.y, DistanceOrder.z - 0.13,"Press ~g~[G]~w~ to take over the ~y~hanger")
            if IsControlJustPressed(0, Keys["E"]) then
                if OwnedHanger == 1 then
                    TriggerEvent("DeliverPackage", "1")
                    TaskStartScenarioInPlace(GetPlayerPed(-1),"WORLD_HUMAN_CLIPBOARD", 0, false)
                    Citizen.Wait(2000)
                    ClearPedTasks(GetPlayerPed(-1))
                    exports['mythic_notify']:SendAlert('Inform', 'The package is marked on your GPS use a forklift to load the package', 7500)
                    -- ESX.ShowNotification("~y~Paczka do dostarczenia zostala zaznaczona na GPS, uzyj wózka widłowego.")
                else
                    exports['mythic_notify']:SendAlert('error', 'You need to take over the hanger first', 5000)
                    -- ESX.ShowNotification("~y~Musisz przejąć hangar")
                end
            elseif IsControlJustPressed(0, Keys["G"]) then
                if OwnedHanger == 1 then
                    exports['mythic_notify']:SendAlert('error', 'You already have a hanger', 5000)
                    -- ESX.ShowNotification("~y~Masz już hangar")
                else
                    TriggerServerEvent("drp:TakeOverHanger", "1")
                    Citizen.Wait(500)
                end
            end
        end
    end
end)
----Hanger 2
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local distCar2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Car2.x,
                               Car2.y, Car2.z)
        local zlecDist2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z,
                                DistanceOrder2.x, DistanceOrder2.y,
                                DistanceOrder2.z)
---hanger markers  2
        if distCar2 <= 25.0 or zlecDist2 <= 25.0 then
            DrawMarker(27, Car2.x, Car2.y, Car2.z - 0.90, 0, 0, 0, 0, 0, 0,
                       1.301, 1.3001, 1.3001, 255, 159, 68, 100, 0, 0, 0, 0)
            DrawMarker(27, DistanceOrder2.x, DistanceOrder2.y,
                       DistanceOrder2.z - 0.90, 0, 0, 0, 0, 0, 0, 1.301, 1.3001,
                       1.3001, 255, 159, 68, 100, 0, 0, 0, 0)
        else
            Citizen.Wait(1500)
        end

        if distCar2 <= 1.0 then
            DrawText3D(Car2.x, Car2.y, Car2.z,"Press ~g~[E]~w~ for a ~o~forklift")
            if IsControlJustPressed(0, Keys["E"]) then
                PozyczPojazd("2")
            end
        end

        if zlecDist2 <= 1.0 then
            DrawText3D(DistanceOrder2.x, DistanceOrder2.y, DistanceOrder2.z,"Press ~g~[E]~w~ to take an ~y~order")
            DrawText3D(DistanceOrder2.x, DistanceOrder2.y, DistanceOrder2.z - 0.13, "Press ~g~[G]~w~ to take over the ~y~hanger")
            if IsControlJustPressed(0, Keys["E"]) then
                if OwnedHanger == 2 then
                    TriggerEvent("DeliverPackage", "2")
                    TaskStartScenarioInPlace(GetPlayerPed(-1),"WORLD_HUMAN_CLIPBOARD", 0, false)
                    Citizen.Wait(2000)
                    ClearPedTasks(GetPlayerPed(-1))
                    exports['mythic_notify']:SendAlert('Inform', 'The package is marked on your GPS use a forklift to load the package', 7500)
                    -- ESX.ShowNotification("~y~Paczka do dostarczenia zostala zaznaczona na GPS, uzyj wózka widłowego.")
                else
                    exports['mythic_notify']:SendAlert('error', 'You need to take over the hanger first', 5000)
                    -- ESX.ShowNotification("~y~Musisz przejąć hangar")
                end
            elseif IsControlJustPressed(0, Keys["G"]) then
                if OwnedHanger == 2 then
                    exports['mythic_notify']:SendAlert('error', 'You already have a hanger', 5000)
                    -- ESX.ShowNotification("~y~Masz już hangar")
                else
                    TriggerServerEvent("drp:TakeOverHanger", "2")
                    Citizen.Wait(500)
                end
            end
        end
    end
end)

local VehicleIsOut = 0
local truck

function PozyczPojazd(a)
    if a == "1" then
        if VehicleIsOut == 0 then
            RequestModel(GetHashKey("forklift"))
            while not HasModelLoaded(GetHashKey("forklift")) do
                Citizen.Wait(0)
            end
            ClearAreaOfVehicles(Car.x, Car.y, Car.z, 15.0, false, false, false,
                                false, false)
            truck = CreateVehicle(GetHashKey("forklift"), Car.x, Car.y, Car.z,
                                  -2.436, 996.786, 25.1887, true, true)
            SetEntityHeading(truck, 52.00)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), truck, -1)
            SetVehicleColours(truck, 111, 111)
            SetEntityInvincible(truck, true)
            local plate = GetVehicleNumberPlateText(truck)
            TriggerServerEvent('garage:addKeys', plate)
            VehicleIsOut = 1
        else
            VehicleIsOut = 0
            DeleteEntity(truck)
            exports['mythic_notify']:SendAlert('Inform', 'Your forklift has been returned you may take out a new one', 5000)
            -- ESX.ShowNotification("~y~Twój poprzedni pojazd został skasowany, możesz pobrać nowy")
        end
    elseif a == "2" then
        if VehicleIsOut == 0 then
            RequestModel(GetHashKey("forklift"))
            while not HasModelLoaded(GetHashKey("forklift")) do
                Citizen.Wait(0)
            end
            ClearAreaOfVehicles(Car2.x, Car2.y, Car2.z, 15.0, false, false,
                                false, false, false)
            truck = CreateVehicle(GetHashKey("forklift"), Car2.x, Car2.y,
                                  Car2.z, -2.436, 996.786, 25.1887, true, true)
            SetEntityHeading(truck, 52.00)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), truck, -1)
            SetVehicleColours(truck, 111, 111)
            SetEntityInvincible(truck, true)
            local plate = GetVehicleNumberPlateText(truck)
            TriggerServerEvent('garage:addKeys', plate)
            VehicleIsOut = 1
        else
            VehicleIsOut = 0
            DeleteEntity(truck)
            exports['mythic_notify']:SendAlert('Inform', 'Your forklift has been returned you may take out a new one', 5000)
            -- ESX.ShowNotification("~y~Twój poprzedni pojazd został skasowany, możesz pobrać nowy")
        end
    end
end
----
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1500)
        local a = GetEntityCoords(GetPlayerPed(-1), false)
        local b = Vdist(a.x, a.y, a.z, DistanceOrder2.x, DistanceOrder2.y,
                        DistanceOrder2.z)
        local c = Vdist(a.x, a.y, a.z, DistanceOrder.x, DistanceOrder.y,
                        DistanceOrder.z)
        if OwnedHanger == 1 or OwnedHanger == 2 then
            if b > 700.0 then
                exports['mythic_notify']:SendAlert('error', 'You have moved too far from the warehouse and forfeited the hanger!', 8000)
                -- ESX.ShowNotification("~y~Zbyt daleko oddaliles sie od magazynu dlatego straciles wlasciciela.")
                TriggerServerEvent("drp:OutOfHangerRange")
                Citizen.Wait(3000)
            else
                Citizen.Wait(3500)
            end
            if c > 700.0 then
                exports['mythic_notify']:SendAlert('error', 'You have moved too far from the warehouse and forfeited the hanger!', 8000)
                -- ESX.ShowNotification("~y~Zbyt daleko oddaliles sie od magazynu dlatego straciles wlasciciela.")
                TriggerServerEvent("drp:OutOfHangerRange")
                Citizen.Wait(3000)
            else
                Citizen.Wait(3500)
            end
        end
    end
end)