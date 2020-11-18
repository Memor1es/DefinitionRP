-- AreCoordsCollidingWithExterior()
local OwnedHouse = nil
local AvailableHouses = {}
local mykeys = {}
local blips = {}
local Knockings = {}
local allapts = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    while ESX.GetPlayerData().job == nil do Wait(0) end
    TriggerServerEvent('drp-housing:getOwned', GetPlayerServerId(PlayerId()))
    while playeridentifier == nil do Wait(0) end
    Wait(10000)
    TriggerServerEvent('drp-housing:motellastpayment', playeridentifier)
    TriggerServerEvent('drp-housing:aptlastpayment', playeridentifier)
    playerJob = ESX.GetPlayerData().job.name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    playerJob = job.name
end)


Citizen.CreateThread(function()
    while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
    TriggerServerEvent('drp-housing:getOwned', GetPlayerServerId(PlayerId()))
    while playeridentifier == nil do 
        playeridentifier = ESX.GetPlayerData().identifier
        Wait(0)
    end
    while allhousing == nil do Wait(0) end

    if Config.IKEABlip['Enabled'] then
        local blip = AddBlipForCoord(Config.Furnituring['enter'])
        SetBlipSprite(blip, Config.IKEABlip['Sprite'])
        SetBlipColour(blip, Config.IKEABlip['Colour'])
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.IKEABlip['Scale'])
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Housing Furniture")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end

    if Config.IKEABlip['Enabled'] then
        local blip = AddBlipForCoord(Config.Furnituring['enter2'])
        SetBlipSprite(blip, Config.IKEABlip['Sprite'])
        SetBlipColour(blip, Config.IKEABlip['Colour'])
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, Config.IKEABlip['Scale'])
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Housing Furniture")
        EndTextCommandSetBlipName(blip)
        table.insert(blips, blip)
    end

    while true do
        Wait(500)
        repeat Wait(1) until allhousing ~= nil
        for k, v in pairs(allhousing) do
            local gotkey = false
                    for _k, _v in pairs(mykeys) do
                        if _v == v['id'] then
                            gotkey = true
                        end
                    end
            local dcoords = vector3(v['doorx'], v['doory'], v['doorz'])
            if Vdist2(GetEntityCoords(PlayerPedId()), dcoords) <= 2.5 then
                local text = 'error'
                while Vdist2(GetEntityCoords(PlayerPedId()), dcoords) <= 2.5 do
                    if not string.match(v['type'],"apt") then
                        if gotkey and v['owner'] == playeridentifier and v['type'] == "house" then
                            text = (Strings['Press_E']):format(Strings['Manage_House'])
                        elseif gotkey and v['owner'] == playeridentifier and v['type'] == "motel" then
                            text = (Strings['Press_E']):format(Strings['Manage_Room'])
                        elseif gotkey and v['owner'] ~= playeridentifier then
                            text = (Strings['Press_E']):format(Strings['Enter_Only'])
                        else
                            if v['owner'] == "none" and v['type'] == "house" then
                                text = (Strings['Press_E']):format((Strings['Buy_House']):format(v['id']))
                            elseif v['owner'] == "none" and v['type'] == "motel" then
                                text = (Strings['Press_E']):format((Strings['Rent_Room']):format(v['id']))
                            else
                                if playerJob == "police" then
                                    text = (Strings['Press_E']):format(Strings['Raid_House'])
                                elseif playerJob ~= "police" then
                                    text = (Strings['Press_E']):format(Strings['Knock_House'])
                                end
                            end
                        end
                        HelpText(text, dcoords)
                    end
                    if IsControlJustReleased(0, 38) and not string.match(v['type'],"apt") then
                        if gotkey then
                            if v['owner'] ~= playeridentifier then
                                TriggerServerEvent('drp-housing:instanceCheck', v['id'], "enter")
                            elseif v["type"] == "house" then
                                ESX.UI.Menu.CloseAll()
                                elements = {
                                    {label = Strings['Enter_House'], value = 'enter'},
                                }
                                if v['owner'] == playeridentifier then
                                    table.insert(elements, {label = (Strings['Sell_House']):format(math.floor(v['price']*(Config.SellPercentage/100))), value = 'sell'})
                                    -- table.insert(elements, {label = Strings['Garage'], value = 'garage'})
                                    table.insert(elements, {label = Strings['Reset'], value = 'reset'})
                                    doortitle = "Manage House #"..v['id']
                                else
                                    doortitle = "Enter House #"..v['id']
                                end
                                
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'manage_house',
                                {
                                    title = doortitle,
                                    align = 'bottom-right',
                                    elements = elements
                                },
                                function(data, menu)
                                    
                                    if data.current.value == 'enter' then
                                        TriggerServerEvent('drp-housing:instanceCheck', v['id'], "enter")
                                        menu.close()
                                    elseif data.current.value == 'reset' then
                                        TriggerServerEvent('drp-housing:resetInstance', v['id'])
                                        menu.close()
                                    -- elseif data.current.value == 'garage' then
                                    --     local gcoords = vector3(v['gposx'], v['gposy'], v['gposz'])
                                    --     -- local found, coords, heading = GetClosestVehicleNodeWithHeading(coords.x, coords.y, coords.z, 3.0, 100.0, 2.5)
                                    --     if v['gposx'] ~= nil then -- check if garage coord x is set
                                    --         ESX.UI.Menu.CloseAll()
                                    --         OpenGarageMenu(v['id'], gcoords, v['gheading']) -- house id, garage coords, garage heading
                                    --         return
                                    --     else
                                    --         ESX.ShowNotification("Your house has no garage")
                                    --     end
                                    elseif data.current.value == 'sell' then
                                        ESX.UI.Menu.Open(
                                            'default', GetCurrentResourceName(), 'sell',
                                        {
                                            title = (Strings['Sell_Confirm']):format(math.floor(v['price']*(Config.SellPercentage/100))),
                                            align = 'bottom-right',
                                            elements = {
                                                {label = Strings['yes'], value = 'yes'},
                                                {label = Strings['no'], value = 'no'}
                                            },
                                        },
                                        function(data2, menu2)
                                            if data2.current.value == 'yes' then
                                                TriggerServerEvent('drp-housing:sellHouse',v['id'])
                                                ESX.UI.Menu.CloseAll()
                                                Wait(5000)
                                            else
                                                menu2.close()
                                            end
                                        end, 
                                            function(data2, menu2)
                                            menu2.close()
                                        end)
                                    end
                                end,
                                function(data, menu)
                                    menu.close()
                                end)
                            elseif v["type"] == "motel" then
                                ESX.UI.Menu.CloseAll()
                                elements = {
                                    {label = Strings['Enter_Motel'], value = 'enter'},
                                }
                                if v['owner'] == playeridentifier then
                                    table.insert(elements, {label = Strings['Cancel_Motel'], value = 'cancel'})
                                    doortitle = "Manage room #"..v['id']
                                else
                                    doortitle = "Enter room #"..v['id']
                                end

                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'manage_motel',
                                {
                                    title = doortitle,
                                    align = 'bottom-right',
                                    elements = elements
                                },
                                function(data, menu)
                                    
                                    if data.current.value == 'enter' then
                                        TriggerServerEvent('drp-housing:instanceCheck', v['id'], "enter")
                                        menu.close()
                                    elseif data.current.value == 'cancel' then
                                        ESX.UI.Menu.Open(
                                            'default', GetCurrentResourceName(), 'cancel',
                                        {
                                            title = Strings['Cancel_Confirm'],
                                            align = 'bottom-right',
                                            elements = {
                                                {label = Strings['yes'], value = 'yes'},
                                                {label = Strings['no'], value = 'no'}
                                            },
                                        },
                                        function(data2, menu2)
                                            if data2.current.value == 'yes' then
                                                TriggerServerEvent('drp-housing:sellMotel',v['id'])
                                                ESX.UI.Menu.CloseAll()
                                                Wait(5000)
                                            else
                                                menu2.close()
                                            end
                                        end, 
                                            function(data2, menu2)
                                            menu2.close()
                                        end)
                                    end
                                end,
                                function(data, menu)
                                    menu.close()
                                end)
                            end
                        else
                            if v['owner'] == "none" and v["type"] == "house" then
                                ESX.UI.Menu.CloseAll()
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'buy',
                                {
                                    title = (Strings['Buy_House_Confirm']):format(k, v['price']),
                                    align = 'bottom-right',
                                    elements = {
                                        {label = Strings['yes'], value = 'yes'},
                                        {label = Strings['no'], value = 'no'}
                                    },
                                },
                                function(data, menu)
                                    if data.current.value == 'yes' then
                                        TriggerServerEvent('drp-housing:buyHouse', v['id'])
                                        ESX.UI.Menu.CloseAll()
                                        Wait(5000)
                                    else
                                        menu.close()
                                    end
                                end, 
                                    function(data, menu)
                                    menu.close()
                                end)
                            elseif v['owner'] == "none" and v["type"] == "motel" then
                                ESX.UI.Menu.CloseAll()
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'rent',
                                {
                                    title = (Strings['Rent_Confirm']):format(k, v['price']),
                                    align = 'bottom-right',
                                    elements = {
                                        {label = Strings['yes'], value = 'yes'},
                                        {label = Strings['no'], value = 'no'}
                                    },
                                },
                                function(data, menu)
                                    if data.current.value == 'yes' then
                                        TriggerServerEvent('drp-housing:rentMotel', v['id'])
                                        ESX.UI.Menu.CloseAll()
                                        Wait(5000)
                                    else
                                        menu.close()
                                    end
                                end, 
                                    function(data, menu)
                                    menu.close()
                                end)
                            else
                                if playerJob == "police" then
                                    PoliceMenu(v['id'])
                                elseif v["type"] then
                                    TriggerServerEvent('drp-housing:knockDoor', v['id'])
                                    while Vdist2(GetEntityCoords(PlayerPedId()), vector3(v['doorx'], v['doory'], v['doorz'])) <= 4.5 do Wait(0) HelpText(Strings['Waiting_Owner'], vector3(v['doorx'], v['doory'], v['doorz'])) end
                                    TriggerServerEvent('drp-housing:unKnockDoor', v['id'])
                                end
                            end
                        end
                        Wait(5000)
                    end
                    Wait(0)
                end
            end
        end
    end
end)

--------APARTMENT THREAD--------------
Citizen.CreateThread(function()
    while true do
        Wait(500)
        repeat Wait(1) until allapts ~= nil
        for k, v in pairs(allapts) do
            local dcoords = vector3(v['doorx'], v['doory'], v['doorz'])
            if Vdist2(GetEntityCoords(PlayerPedId()), dcoords) <= 20 then
                local text = 'error'
                while Vdist2(GetEntityCoords(PlayerPedId()), dcoords) <= 20 do
                    local text = 'Welcome to '..v['name'].." apartments!"
                    local bool, groundz = GetGroundZFor_3dCoord(dcoords.x, dcoords.y, dcoords.z)
                    local markercoords = vector3(dcoords.x,dcoords.y,groundz+0.1)
                    DrawMarker(27, markercoords, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(5, 5.0, 3.0), 0, 0, 0, 150, false, false, 2, false, false, false)
                    HelpText(text, dcoords)
                    if IsControlJustReleased(0, 38) then
                        openAptMenu(v['name'])
                    end
                    Wait(0)
                end
            end
        end
    end
end)

-------- GARAGE THREAD ---------

Citizen.CreateThread(function()
    while true do
        Wait(0)
        repeat Wait(1) until allhousing ~= nil
        for k, v in pairs(allhousing) do
            local gotkey = false
                    for _k, _v in pairs(mykeys) do
                        if _v == v['id'] then
                            gotkey = true
                        end
                    end
            if v['owner'] == playeridentifier and v['type'] == "house" then
                local bool, groundz = GetGroundZFor_3dCoord(v['gposx'], v['gposy'], v['gposz'])
                local gcoords = vector3(v['gposx'], v['gposy'], groundz)
                if v['gposx'] ~= nil then
                    while #(GetEntityCoords(PlayerPedId()) - gcoords) <= 15.0 and Config.EnableGarage do
                        Wait(0)
                        if #(GetEntityCoords(PlayerPedId()) - gcoords) <= 2.0 and IsPedInAnyVehicle(PlayerPedId(), false) and Config.EnableGarage then
                            DrawMarker(1, gcoords-vector3(0.0, 0.0, 0.5), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.2), 255, 255, 25, 150, false, false, 2, false, false, false)
                            HelpText(Strings['Store_Garage'], gcoords)
                            if IsControlJustReleased(0, 38) then

                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

                                ESX.TriggerServerCallback("betrayed_garage:validateVehicle", function(valid)
                                    if valid then
                                        TriggerEvent('housing:storeCar', v['id'])
                                    else
                                        exports['mythic_notify']:DoHudText('error', 'This vehicle does not belong to you.')
                                    end
                                end, vehicleProps)
                            end
                        elseif #(GetEntityCoords(PlayerPedId()) - gcoords) <= 2.0 then
                            DrawMarker(1, gcoords-vector3(0.0, 0.0, 0.5), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.2), 255, 255, 25, 150, false, false, 2, false, false, false)
                            HelpText(Strings['Open_Garage'], gcoords)
                            if IsControlJustReleased(0, 38) then
                                ESX.UI.Menu.CloseAll()
                                OpenGarageMenu(v['id'], gcoords, v['gheading'])
                            end
                        end
                    end
                end
            elseif gotkey and v["type"] == "house" and v["owner"] ~= none then
                local bool, groundz = GetGroundZFor_3dCoord(v['gposx'], v['gposy'], v['gposz'])
                local gcoords = vector3(v['gposx'], v['gposy'], groundz)
                if v['gposx'] ~= nil then
                    while #(GetEntityCoords(PlayerPedId()) - gcoords) <= 2.0 and Config.EnableGarage do
                        Wait(0)
                        if #(GetEntityCoords(PlayerPedId()) - gcoords) <= 5.0 and IsPedInAnyVehicle(PlayerPedId(), false) and Config.EnableGarage then
                            DrawMarker(1, gcoords-vector3(0.0, 0.0, 0.5), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.2), 255, 255, 25, 150, false, false, 2, false, false, false)
                            HelpText(Strings['Store_Garage'], gcoords)
                            if IsControlJustReleased(0, 38) then

                                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

                                ESX.TriggerServerCallback("betrayed_garage:validateVehicle", function(valid)
                                    if valid then
                                        TriggerEvent('housing:storeCar', v['id'])
                                    else
                                        exports['mythic_notify']:DoHudText('error', 'This vehicle does not belong to you.')
                                    end
                                end, vehicleProps)
                            end
                        elseif #(GetEntityCoords(PlayerPedId()) - gcoords) <= 2.0 then
                            DrawMarker(1, gcoords-vector3(0.0, 0.0, 0.5), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.2), 255, 255, 25, 150, false, false, 2, false, false, false)
                            HelpText(Strings['Open_Garage'], gcoords)
                            if IsControlJustReleased(0, 38) then
                                ESX.UI.Menu.CloseAll()
                                OpenGarageMenu(v['id'], gcoords, v['gheading'])
                            end
                        end
                    end
                end
            end
        end
    end
end)


function PoliceMenu(house)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'police-menu',
    {
        title = 'Police Menu',
        align = 'bottom-right',
        elements = {
            {label = "Knock on door", value = 'knock'},
            {label = "Raid House", value = 'raid'}
        },
    },
    function(data, menu)
        if data.current.value == 'knock' then
            ESX.UI.Menu.CloseAll()
            Citizen.CreateThread(function()
                TriggerServerEvent('drp-housing:knockDoor', house)
                Citizen.Wait(2500)
                TriggerServerEvent('drp-housing:unKnockDoor', house)
            end)
        else
            ESX.UI.Menu.CloseAll()
            TriggerServerEvent('drp-housing:instanceCheck', house,"raid")
        end
    end,
        function(data, menu)
        menu.close()
    end)
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


Citizen.CreateThread(function()
    while true do
        Wait(0)
        local dist = Vdist2(GetEntityCoords(PlayerPedId()), Config.Furnituring['enter'])
        if dist <= 50.0 then
            DrawMarker(27, Config.Furnituring['enter'], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, true, false, false)
            if dist <= 1.5 then
                HelpText((Strings['Press_E']):format(Strings['Buy_Furniture']), Config.Furnituring['enter'])
                if IsControlJustReleased(0, 38) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    local currentcategory = 1
                    local category = Config.Furniture['Categories'][currentcategory]

                    local current = 1
                    local cooldown = GetGameTimer()

                    local model = GetHashKey(Config.Furniture[category[1]][current][2])

                    if IsModelValid(model) then
                        local startedLoading = GetGameTimer()
                        while not HasModelLoaded(model) do 
                            RequestModel(model) Wait(0) 
                            if GetGameTimer() - startedLoading >= 1500 then
                                ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                break
                            end
                        end
                        furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport'])
                        SetEntityHeading(furniture, 0.0)
                    else
                        ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                    end

                    local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
                    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.0))
                    PointCamAtCoord(cam, GetEntityCoords(furniture))
                    RenderScriptCams(1, 0, 0, 1, 1)
                    SetCamActive(cam, true) 
                    FreezeEntityPosition(PlayerPedId(), true)
                    while true do
                        Wait(0)
                        HelpText((Strings['Buying_Furniture']):format(category[2], Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]))

                        DrawText3D(GetEntityCoords(furniture), ('%s (~g~$%s~w~)'):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]), 0.5)

                        DisableControlAction(0, 24)
                        DisableControlAction(0, 25)
                        DisableControlAction(0, 14)
                        DisableControlAction(0, 15)
                        DisableControlAction(0, 16)
                        DisableControlAction(0, 17)
                        NetworkOverrideClockTime(15, 0, 0)
                        ClearOverrideWeather()
                        ClearWeatherTypePersist()
                        SetWeatherTypePersist('EXTRASUNNY')
                        SetWeatherTypeNow('EXTRASUNNY')
                        SetWeatherTypeNowPersist('EXTRASUNNY')

                        if IsControlJustReleased(0, 194) then
                            break
                        elseif IsControlJustReleased(0, 172) then
                            if Config.Furniture['Categories'][currentcategory + 1] then
                                category = Config.Furniture['Categories'][currentcategory + 1]
                                currentcategory = currentcategory + 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][1]
                                currentcategory = 1
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlPressed(0, 34) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) + 0.25)
                        elseif IsControlPressed(0, 35) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) - 0.25)
                        elseif IsDisabledControlPressed(0, 96) then
                            local currentCoord = GetCamCoord(cam)
                            if currentCoord.z + 0.1 <= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.5).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z + 0.1)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsDisabledControlPressed(0, 97) then
                            local currentCoord = GetCamCoord(cam)
                            if currentCoord.z - 0.1 >= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 0.1).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z - 0.1)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsControlPressed(0, 33) then
                            local fov = GetCamFov(cam)
                            if fov + 0.1 >= 129.9 then fov = 129.9 else fov = fov + 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlPressed(0, 32) then
                            local fov = GetCamFov(cam)
                            if fov - 0.1 <= 1.1 then fov = 1.1 else fov = fov - 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlJustReleased(0, 173) then
                            if Config.Furniture['Categories'][currentcategory - 1] then
                                category = Config.Furniture['Categories'][currentcategory - 1]
                                currentcategory = currentcategory - 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][#Config.Furniture['Categories']]
                                currentcategory = #Config.Furniture['Categories']
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlJustReleased(0, 191) then
                            local answered = false
                            ESX.UI.Menu.CloseAll()
                            ESX.UI.Menu.Open(
                                'default', GetCurrentResourceName(), 'buy_furniture',
                            {
                                title = (Strings['Confirm_Purchase']):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]),
                                align = 'center',
                                elements = {
                                    {label = Strings['yes'], value = 'yes'},
                                    {label = Strings['no'], value = 'no'}
                                },
                            },
                            function(data, menu)
                                menu.close()
                                if data.current.value == 'yes' then
                                    TriggerServerEvent('drp-housing:buy_furniture', currentcategory, current)
                                    DoScreenFadeOut(250)
                                    Wait(1500)
                                    DoScreenFadeIn(500)
                                end
                                answered = true
                            end, 
                                function(data, menu)
                                    answered = true
                                    menu.close()
                                end
                            )
                            while not answered do Wait(0) end
                        elseif IsControlPressed(0, 190) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current + 1] then
                                current = current + 1
                            else
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        elseif IsControlPressed(0, 189) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current - 1] then
                                current = current - 1
                            else
                                current = #Config.Furniture[category[1]]
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        end
                    end
                    FreezeEntityPosition(PlayerPedId(), false)
                    DeleteObject(furniture)
                    RenderScriptCams(false, false, 0, true, false)
                    DestroyCam(cam)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local dist = Vdist2(GetEntityCoords(PlayerPedId()), Config.Furnituring['enter2'])
        if dist <= 50.0 then
            DrawMarker(27, Config.Furnituring['enter2'], vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, true, false, false)
            if dist <= 1.5 then
                HelpText((Strings['Press_E']):format(Strings['Buy_Furniture']), Config.Furnituring['enter2'])
                if IsControlJustReleased(0, 38) then
                    FreezeEntityPosition(PlayerPedId(), true)
                    local currentcategory = 1
                    local category = Config.Furniture['Categories'][currentcategory]

                    local current = 1
                    local cooldown = GetGameTimer()

                    local model = GetHashKey(Config.Furniture[category[1]][current][2])

                    if IsModelValid(model) then
                        local startedLoading = GetGameTimer()
                        while not HasModelLoaded(model) do 
                            RequestModel(model) Wait(0) 
                            if GetGameTimer() - startedLoading >= 1500 then
                                ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                break
                            end
                        end
                        furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport2'])
                        SetEntityHeading(furniture, 0.0)
                    else
                        ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                    end

                    local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
                    SetCamCoord(cam, GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.0))
                    PointCamAtCoord(cam, GetEntityCoords(furniture))
                    RenderScriptCams(1, 0, 0, 1, 1)
                    SetCamActive(cam, true) 
                    FreezeEntityPosition(PlayerPedId(), true)
                    while true do
                        Wait(0)
                        HelpText((Strings['Buying_Furniture']):format(category[2], Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]))

                        DrawText3D(GetEntityCoords(furniture), ('%s (~g~$%s~w~)'):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]), 0.5)

                        DisableControlAction(0, 24)
                        DisableControlAction(0, 25)
                        DisableControlAction(0, 14)
                        DisableControlAction(0, 15)
                        DisableControlAction(0, 16)
                        DisableControlAction(0, 17)
                        NetworkOverrideClockTime(15, 0, 0)
                        ClearOverrideWeather()
                        ClearWeatherTypePersist()
                        SetWeatherTypePersist('EXTRASUNNY')
                        SetWeatherTypeNow('EXTRASUNNY')
                        SetWeatherTypeNowPersist('EXTRASUNNY')

                        if IsControlJustReleased(0, 194) then
                            break
                        elseif IsControlJustReleased(0, 172) then
                            if Config.Furniture['Categories'][currentcategory + 1] then
                                category = Config.Furniture['Categories'][currentcategory + 1]
                                currentcategory = currentcategory + 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][1]
                                currentcategory = 1
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport2'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlPressed(0, 34) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) + 0.25)
                        elseif IsControlPressed(0, 35) then
                            SetEntityHeading(furniture, GetEntityHeading(furniture) - 0.25)
                        elseif IsDisabledControlPressed(0, 96) then
                            local currentCoord = GetCamCoord(cam)
                            if currentCoord.z + 0.1 <= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 4.5).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z + 0.1)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsDisabledControlPressed(0, 97) then
                            local currentCoord = GetCamCoord(cam)
                            if currentCoord.z - 0.1 >= GetOffsetFromEntityInWorldCoords(furniture, 0.0, -5.0, 0.1).z then
                                currentCoord = vector3(currentCoord.x, currentCoord.y, currentCoord.z - 0.1)
                                SetCamCoord(cam, currentCoord)
                            end
                        elseif IsControlPressed(0, 33) then
                            local fov = GetCamFov(cam)
                            if fov + 0.1 >= 129.9 then fov = 129.9 else fov = fov + 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlPressed(0, 32) then
                            local fov = GetCamFov(cam)
                            if fov - 0.1 <= 1.1 then fov = 1.1 else fov = fov - 0.1 end
                            SetCamFov(cam, fov)
                        elseif IsControlJustReleased(0, 173) then
                            if Config.Furniture['Categories'][currentcategory - 1] then
                                category = Config.Furniture['Categories'][currentcategory - 1]
                                currentcategory = currentcategory - 1
                                current = 1
                            else
                                category = Config.Furniture['Categories'][#Config.Furniture['Categories']]
                                currentcategory = #Config.Furniture['Categories']
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport2'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                        elseif IsControlJustReleased(0, 191) then
                            local answered = false
                            ESX.UI.Menu.CloseAll()
                            ESX.UI.Menu.Open(
                                'default', GetCurrentResourceName(), 'buy_furniture',
                            {
                                title = (Strings['Confirm_Purchase']):format(Config.Furniture[category[1]][current][1], Config.Furniture[category[1]][current][3]),
                                align = 'center',
                                elements = {
                                    {label = Strings['yes'], value = 'yes'},
                                    {label = Strings['no'], value = 'no'}
                                },
                            },
                            function(data, menu)
                                menu.close()
                                if data.current.value == 'yes' then
                                    TriggerServerEvent('drp-housing:buy_furniture', currentcategory, current)
                                    DoScreenFadeOut(250)
                                    Wait(1500)
                                    DoScreenFadeIn(500)
                                end
                                answered = true
                            end, 
                                function(data, menu)
                                    answered = true
                                    menu.close()
                                end
                            )
                            while not answered do Wait(0) end
                        elseif IsControlPressed(0, 190) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current + 1] then
                                current = current + 1
                            else
                                current = 1
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport2'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        elseif IsControlPressed(0, 189) and cooldown < GetGameTimer() then
                            if Config.Furniture[category[1]][current - 1] then
                                current = current - 1
                            else
                                current = #Config.Furniture[category[1]]
                            end
                            DeleteObject(furniture)
                            model = GetHashKey(Config.Furniture[category[1]][current][2])
                            if IsModelValid(model) then
                                local startedLoading = GetGameTimer()
                                while not HasModelLoaded(model) do 
                                    RequestModel(model) Wait(0) 
                                    if GetGameTimer() - startedLoading >= 1500 then
                                        ESX.ShowNotification(('The model (%s) is taking a looong time to load. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                                        break
                                    end
                                end
                                furniture = CreateObjectNoOffset(model, Config.Furnituring['teleport2'])
                                SetEntityHeading(furniture, 0.0)
                            else
                                ESX.ShowNotification(('The model (%s) isn\'t valid. Contact the server owner.'):format(Config.Furniture[category[1]][current][2]))
                            end
                            cooldown = GetGameTimer() + 250
                        end
                    end
                    FreezeEntityPosition(PlayerPedId(), false)
                    DeleteObject(furniture)
                    RenderScriptCams(false, false, 0, true, false)
                    DestroyCam(cam)
                end
            end
        end
    end
end)

RegisterNetEvent('drp-housing:spawnHouse')
AddEventHandler('drp-housing:spawnHouse', function(coords, houseid, shell, furniture, bfurniture)
    local prop = Config.Props[shell]
    local house = EnterHouse(prop, coords)
    local placed_furniture = {}
    for k, v in pairs(furniture) do -- Might be correct
        local model = GetHashKey(v['object'])
        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
        local object = CreateObjectNoOffset(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, false)
        SetEntityHeading(object, v['heading'])
        FreezeEntityPosition(object, true)
        SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
        table.insert(placed_furniture, object)
    end
    SetEntityHeading(house, 0.0)
    local exit = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[shell]['door'])
    local storage = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[shell]['storage'])
    local closet = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[shell]['closet'])

    TriggerServerEvent('drp-housing:setInstanceCoords', exit, coords, shell, furniture, houseid)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for i = 1, 100 do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(100)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(100)
    end
    DoScreenFadeIn(1500)

    local in_house = true
    ClearPedWetness(PlayerPedId())
    while in_house do
        NetworkOverrideClockTime(15, 0, 0)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')

        DrawMarker(27, exit, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 10, 10, 150, false, false, 2, false, false, false)
        DrawMarker(27, storage, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 10, 10, 150, false, false, 2, false, false, false)
        DrawMarker(27, closet, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 10, 10, 150, false, false, 2, false, false, false)

        if Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
                TriggerEvent('housing:openInv', houseid, shell)
            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), closet) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Closet']), closet)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), closet) <= 2.0 then
                TriggerServerEvent('drp-housing:closets')
            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), exit) <= 1.5 then
            HelpText((Strings['Press_E']):format(Strings['Manage_Door']), exit)
            if IsControlJustReleased(0, 38) then
                ESX.UI.Menu.CloseAll()
                local gotkey = false
                for _k, _v in pairs(mykeys) do
                    if _v == houseid then
                        gotkey = true
                    end
                end
                if gotkey then
                    melements = {
                        {label = Strings['Accept'], value = 'accept'}
                    }
                    if allhousing[houseid]['type'] == "house" then
                        mtitle = "Manage house"
                        table.insert(melements, {label = Strings['Furnish'], value = 'furnish'})
                        table.insert(melements, {label = Strings['Re_Furnish'], value = 'refurnish'})
                        if allhousing[houseid]['owner'] == playeridentifier then
                            -- table.insert(melements, {label = Strings['Keys'], value = 'keys'})
                        end
                        table.insert(melements, {label = Strings['Exit'], value = 'exit'})
                        
                    elseif allhousing[houseid]['type'] == "motel" then
                        mtitle = "Manage room"
                        if allhousing[houseid]['owner'] == playeridentifier then
                            -- table.insert(melements, {label = Strings['Keys'], value = 'keys'})
                        end
                        table.insert(melements, {label = Strings['Exit'], value = 'exit'})
                    else
                        mtitle = "Manage apartment"
                        table.insert(melements, {label = Strings['Furnish'], value = 'furnish'})
                        table.insert(melements, {label = Strings['Re_Furnish'], value = 'refurnish'})
                        if allhousing[houseid]['owner'] == playeridentifier then
                            -- table.insert(melements, {label = Strings['Keys'], value = 'keys'})
                        end
                        table.insert(melements, {label = Strings['Exit'], value = 'exit'})
                    end
                else
                    mtitle = ""
                    melements = {
                        {label = Strings['Exit'], value = 'exit'}
                    }
                end
                ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'manage_door',
                {
                    title = mtitle,
                    align = 'bottom-right',
                    elements = melements,
                },
                function(data, menu)
                    if data.current.value == 'keys' then
                        ESX.UI.Menu.CloseAll()
                        OpenHKeyMenu(houseid)
                    elseif data.current.value == 'exit' then
                        ESX.UI.Menu.CloseAll()
                        TriggerServerEvent('drp-housing:leaveHouse',houseid)
                        Wait(500)
                        TriggerServerEvent('drp-housing:deleteInstance',houseid)
                        Wait(500)
                        in_house = false
                    elseif data.current.value == 'refurnish' then
                        if not has then
                            local elements = {}
                            for k, v in pairs(furniture) do
                                table.insert(elements, {label = (Strings['Remove']):format(v['name'], k), value = k})
                            end
                            local editing = true
                            ESX.UI.Menu.Open(
                                'default', GetCurrentResourceName(), 'edit_furniture',
                            {
                                title = Strings['Re_Furnish'],
                                align = 'bottom-right',
                                elements = elements,
                            },
                            function(data2, menu2)
                                DeleteObject(placed_furniture[data2.current.value])
                                if bfurniture[furniture[data2.current.value]['object']] then
                                    bfurniture[furniture[data2.current.value]['object']]['amount'] = bfurniture[furniture[data2.current.value]['object']]['amount'] + 1
                                else
                                    bfurniture[furniture[data2.current.value]['object']] = {amount = 1, name = furniture[data2.current.value]['name']}
                                end
                                table.remove(furniture, data2.current.value)
                                for k, v in pairs(placed_furniture) do
                                    DeleteObject(v)
                                end
                                placed_furniture = {}
                                for k, v in pairs(furniture) do
                                    local model = GetHashKey(v['object'])
                                    while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                    local object = CreateObjectNoOffset(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, true)
                                    SetEntityHeading(object, v['heading'])
                                    FreezeEntityPosition(object, true)
                                    SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
                                    table.insert(placed_furniture, object)
                                end
                                TriggerServerEvent('drp-housing:furnish', houseid, furniture, bfurniture) -- sends the furniture locations back to server
                                menu2.close()
                                editing = false
                            end, 
                                function(data2, menu2)
                                    editing = false
                                menu2.close()
                            end)
                            while editing do
                                Wait(0)
                                for k, v in pairs(placed_furniture) do
                                    DrawText3D(GetEntityCoords(v), ('%s (#%s)'):format(furniture[k]['name'], k), 0.3)
                                end
                            end
                        else
                            ESX.ShowNotification(Strings['Guests'])
                        end
                    elseif data.current.value == 'furnish' then
                                local elements = {}
                                for k, v in pairs(bfurniture) do 
                                    table.insert(elements, {label = ('x%s %s'):format(v['amount'], v['name']), value = k, name = v['name']})
                                end
                                ESX.UI.Menu.Open(
                                    'default', GetCurrentResourceName(), 'furnish',
                                {
                                    title = Strings['Furnish'],
                                    align = 'bottom-right',
                                    elements = elements,
                                },
                                function(data2, menu2)
                                    ESX.UI.Menu.CloseAll()
                                    local model = GetHashKey(data2.current.value)
                                    while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                    local object = CreateObjectNoOffset(model, GetOffsetFromEntityInWorldCoords(house, Config.Offsets[shell]['spawn_furniture']), false, false, true)
                                    SetEntityCollision(object, false, false)
                                    SetEntityHasGravity(object, false)
                                    Wait(250)
                                    while true do
                                        Wait(0)
                                        HelpText(Strings['Furnishing'])
                                        ESX.UI.Menu.CloseAll() -- test
                                        DisableControlAction(0, 24)
                                        DisableControlAction(0, 25)
                                        DisableControlAction(0, 14)
                                        DisableControlAction(0, 15)
                                        DisableControlAction(0, 16)
                                        DisableControlAction(0, 17)
                                        -- DrawEdge(object) -- w.i.p
                                        DrawText3D(GetEntityCoords(object), ('%s, %s: %s'):format(data2.current.name, Strings['Rotation'], string.format("%.2f", GetEntityHeading(object))), 0.3)
                                        if IsControlPressed(0, 172) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.01, 0.0))
                                        elseif IsControlPressed(0, 173) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, -0.01, 0.0))
                                        elseif IsControlPressed(0, 96) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, 0.01))
                                        elseif IsControlPressed(0, 97) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, -0.01))
                                        elseif IsControlPressed(0, 174) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, -0.01, 0.0, 0.0))
                                        elseif IsControlPressed(0, 175) then
                                            SetEntityCoords(object, GetOffsetFromEntityInWorldCoords(object, 0.01, 0.0, 0.0))
                                        elseif IsDisabledControlPressed(0, 24) then
                                            SetEntityHeading(object, GetEntityHeading(object)+0.5)
                                        elseif IsDisabledControlPressed(0, 25) then
                                            SetEntityHeading(object, GetEntityHeading(object)-0.5)
                                        elseif IsControlJustReleased(0, 47) then
                                            local objCoords, houseCoords = GetEntityCoords(object), GetEntityCoords(house)
                                            local houseHeight = GetEntityHeight(house, GetEntityCoords(house), true, false)
                                            SetEntityCoords(object, objCoords.x, objCoords.y, (objCoords.z-(objCoords.z-houseCoords.z))+houseHeight)
                                        elseif IsControlPressed(0, 215) then
                                            local objCoords, houseCoords = GetEntityCoords(object), GetEntityCoords(house)
                                            local furn_offs = objCoords - houseCoords
                                            local furnished = {['offset'] = {furn_offs.x, furn_offs.y, furn_offs.z}, ['object'] = data2.current.value, ['name'] = data2.current.name, ['heading'] = GetEntityHeading(object)}
                                            table.insert(furniture, furnished)

                                                if bfurniture[data2.current.value]['amount'] > 1 then
                                                    bfurniture[data2.current.value]['amount'] = bfurniture[data2.current.value]['amount'] - 1
                                                else -- ugly code, idk how to improve ¯\_(ツ)_/¯ couldn't get table.remove to work on this shit
                                                    local oldFurniture = bfurniture
                                                        bfurniture = {}
                                                    for k, v in pairs(oldFurniture) do
                                                        if k ~= data2.current.value then
                                                            bfurniture[k] = v
                                                        end
                                                    end
                                                end

                                            DeleteObject(object)

                                            for k, v in pairs(placed_furniture) do
                                                DeleteObject(v)
                                            end
                                            placed_furniture = {}
                                            for k, v in pairs(furniture) do
                                                local model = GetHashKey(v['object'])
                                                while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
                                                local object = CreateObjectNoOffset(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, true)
                                                SetEntityHeading(object, v['heading'])
                                                FreezeEntityPosition(object, true)
                                                SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
                                                table.insert(placed_furniture, object)
                                            end
                                            TriggerServerEvent('drp-housing:furnish', houseid, furniture, bfurniture)
                                            break
                                        elseif IsControlPressed(0, 202) then
                                            DeleteObject(object)
                                            break
                                        end
                                    end
                                end, 
                                    function(data2, menu2)
                                    menu2.close()
                                end)
                    elseif data.current.value == 'accept' then 
                        local elements = {}

                        for k, v in pairs(Knockings) do
                            table.insert(elements, v)
                        end

                        ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'let_in_fresh',
                        {
                            title = Strings['Let_In'],
                            align = 'bottom-right',
                            elements = elements,
                        },
                        function(data2, menu2)
                            if Knockings[data2.current.value] then
                                TriggerServerEvent('drp-housing:letIn', data2.current.value, storage, houseid)
                            end
                            menu2.close()
                        end, 
                            function(data2, menu2)
                            menu2.close()
                        end)
                    end
                end, 
                    function(data, menu)
                    menu.close()
                end)
            end
        end
        Wait(0)
    end
    DeleteObject(house)
    for k, v in pairs(placed_furniture) do
        DeleteObject(v)
    end
end)

RegisterNetEvent('drp-housing:leaveHouse')
AddEventHandler('drp-housing:leaveHouse', function(house)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(PlayerPedId(), vector3(allhousing[house]['doorx'], allhousing[house]['doory'], allhousing[house]['doorz']))
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(),  vector3(allhousing[house]['doorx'], allhousing[house]['doory'], allhousing[house]['doorz']))
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), vector3(allhousing[house]['doorx'], allhousing[house]['doory'], allhousing[house]['doorz']))
        Wait(50)
    end
    DoScreenFadeIn(1500)
end)

RegisterNetEvent('drp-housing:doorcheck')
AddEventHandler('drp-housing:doorcheck', function(house)
    local ped = GetPlayerPed(-1)
    local pcoords = GetEntityCoords(ped)
    local hid = tonumber(house)
    local hcoords = vector3(allhousing[hid]['doorx'], allhousing[hid]['doory'], allhousing[hid]['doorz'])
    local dcheckdist = Vdist2(pcoords,hcoords)
    TriggerServerEvent('drp-housing:deletehouse', dcheckdist,house)
end)

RegisterNetEvent('drp-housing:knockAccept')
AddEventHandler('drp-housing:knockAccept', function(coords, house, storage, spawnpos, furniture, host)
    local prop = allhousing[house]['prop']
    local shell = allhousing[house]['prop']
    prop = EnterHouse(Config.Props[prop], spawnpos)
    local placed_furniture = {}
    for k, v in pairs(furniture) do
        local model = GetHashKey(v['object'])
        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
        local object = CreateObjectNoOffset(model, GetOffsetFromEntityInWorldCoords(prop, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, false)
        SetEntityHeading(object, v['heading'])
        FreezeEntityPosition(object, true)
        table.insert(placed_furniture, object)
    end
    SetEntityHeading(prop, 0.0)
    local storage = GetOffsetFromEntityInWorldCoords(prop, Config.Offsets[shell]['storage'])
    local closet = GetOffsetFromEntityInWorldCoords(prop, Config.Offsets[shell]['closet'])

    while not DoesEntityExist(prop) do Wait(0) end
    NetworkConcealPlayer(PlayerId(),true,true)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for i = 1, 100 do
        SetEntityCoords(PlayerPedId(), coords)
        Wait(100)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), coords)
        Wait(100)
    end

    while not IsScreenFadedOut() do Wait(0) end
    SetEntityCoords(PlayerPedId(), coords)
    for i = 1, 25 do
        SetEntityCoords(PlayerPedId(),  coords)
        Wait(50)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), coords)
        Wait(50)
    end


    DoScreenFadeIn(1500)
    NetworkConcealPlayer(PlayerId(),false,false)
    while true do
        Wait(0)
        NetworkOverrideClockTime(15, 0, 0)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')
        DrawMarker(27, coords, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        DrawMarker(27, storage, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)
        DrawMarker(27, closet, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 0, 255, 150, false, false, 2, false, false, false)

        if Vdist2(GetEntityCoords(PlayerPedId()), coords) <= 1.5 then
            HelpText((Strings['Press_E']):format(Strings['Exit']), coords)
            if IsControlJustReleased(0, 38) then
                ESX.UI.Menu.CloseAll()
                DoScreenFadeOut(750)
                TriggerServerEvent('drp-housing:leaveHouse',house)
                Wait(100)
                TriggerServerEvent('drp-housing:deleteInstance',house)
                for k, v in pairs(placed_furniture) do
                    DeleteObject(v)
                end
                DoScreenFadeIn(1500)
                Citizen.Wait(3500)
                DeleteObject(prop)
                return
            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
                TriggerEvent('housing:openInv', house, allhousing[house]['prop'])
            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), closet) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Closet']), closet)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), closet) <= 2.0 then
                TriggerServerEvent('drp-housing:closets')
            end
        end
    end
end)

RegisterNetEvent('drp-housing:reloadHouses')
AddEventHandler('drp-housing:reloadHouses', function()
    while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while ESX.GetPlayerData().job == nil do Wait(0) end
    TriggerServerEvent('drp-housing:getOwned', GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('drp-housing:knockedDoor')
AddEventHandler('drp-housing:knockedDoor', function(src, name)
    ESX.ShowNotification(Strings['Someone_Knocked'])
    if Knockings[src] == nil then
        Knockings[src] = {label = (Strings['Accept_Player']):format(name), value = src}
    end
end)

RegisterNetEvent('drp-housing:removeDoorKnock')
AddEventHandler('drp-housing:removeDoorKnock', function(src)
    local newTable = {}
    for k, v in pairs(Knockings) do
        if v.value ~= src then
            table.remove(newTable, v)
        end
    end
    Knockings = newTable
end)

RegisterNetEvent('drp-housing:blips')
AddEventHandler('drp-housing:blips', function(blip)
    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    for k, v in pairs(allhousing) do
        local gotkey = false
        for _k, _v in pairs(mykeys) do
            if _v == v.id then
                gotkey = true
            end
        end
        if v["owner"] == playeridentifier and not string.match(v["type"],"apt") then
            CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 40, 3, 0.6, 'Owned Property')
        elseif gotkey then
            CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 40, 2, 0.6, 'Friends Property')
        elseif blip then
            if v['owner'] ~= "none" and not string.match(v["type"],"apt") then
                CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 374, 2, 0.6, 'Owned House')
            elseif string.match(v['type'],"apt") then
                Citizen.Wait(1)
                CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 374, 0, 0.6, 'Available House')
            end
        end
    end
    for k, v in pairs(allapts) do
        CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 475, 3, 0.6, v['name']..' Apartments')
    end
end)


RegisterNetEvent('drp-housing:setHouse')
AddEventHandler('drp-housing:setHouse', function(returnedhousing, returnedkeys)
    allhousing = {}
    mykeys = {}

    for k,v in pairs(returnedhousing) do
        if allhousing[returnedhousing[k].id] == nil then
            allhousing[returnedhousing[k].id] = returnedhousing[k]
        end
    end

    Wait(100)
    mykeys = json.decode(returnedkeys)
    if #mykeys < 1 then
        print("no keys")
    end

    for k, v in pairs(allhousing) do
        local gotkey = false
        for _k, _v in pairs(mykeys) do
            if _v == v.id then
                gotkey = true
            end
        end
        if v["owner"] == playeridentifier and not string.match(v['type'],"apt") then
            CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 40, 3, 0.6, 'Owned Property')
        elseif gotkey and v["owner"] ~= "none" and not string.match(v["type"],"apt") then
            CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 40, 2, 0.6, 'Friends Property')
        end
    end
end)

RegisterNetEvent('drp-housing:setApt')
AddEventHandler('drp-housing:setApt', function(returnedApts)
    allapts = {}
    for k,v in pairs(returnedApts) do
        if allapts[returnedApts[k].id] == nil then
            allapts[returnedApts[k].id] = returnedApts[k]
        end
    end

    for k, v in pairs(blips) do
        RemoveBlip(v)
    end
    for k, v in pairs(allapts) do
        CreateBlip(vector3(v['doorx'], v['doory'], v['doorz']), 475, 6, 0.6, v['name']..' Apartments')
    end
end)

EnterHouse = function(prop, coords)
    local obj = CreateObjectNoOffset(prop, coords, false)
    FreezeEntityPosition(obj, true)
    return obj
end

HelpText = function(msg, coords)
    if not coords or not Config.Use3DText then
        AddTextEntry(GetCurrentResourceName(), msg)
        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
    else
        DrawText3D(coords, string.gsub(msg, "~INPUT_CONTEXT~", "~r~[~w~E~r~]~w~"), 0.35)
    end
end

CreateBlip = function(coords, sprite, colour, scale, text)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)

    BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)


    table.insert(blips, blip)
end

rgb = function(speed)
    local result = {}
    local n = GetGameTimer() / 200
    result.r = math.floor(math.sin(n * speed + 0) * 127 + 128)
    result.g = math.floor(math.sin(n * speed + 2) * 127 + 128)
    result.b = math.floor(math.sin(n * speed + 4) * 127 + 128)
    return result
end

DrawEdge = function(entity)
    local left, right = GetModelDimensions(GetEntityModel(entity))
    local leftoffset, rightoffset = GetOffsetFromEntityInWorldCoords(entity, left.x, left.y, left.z), GetOffsetFromEntityInWorldCoords(entity, right.x, right.y, right.z)
    local coords = GetEntityCoords(entity)

    local color = rgb(0.5)

    DrawLine(rightoffset, rightoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset, leftoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, rightoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, leftoffset.y, leftoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)

    DrawLine(rightoffset.x, leftoffset.y, leftoffset.z, leftoffset, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, rightoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, leftoffset.y, rightoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)

    DrawLine(leftoffset.x, leftoffset.y, rightoffset.z, leftoffset.x, rightoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, rightoffset.z, rightoffset.x, leftoffset.y, rightoffset.z, color.r, color.g, color.b, 255)
    DrawLine(leftoffset.x, leftoffset.y, leftoffset.z, leftoffset.x, rightoffset.y, leftoffset.z, color.r, color.g, color.b, 255)
    DrawLine(rightoffset.x, rightoffset.y, leftoffset.z, rightoffset.x, leftoffset.y, leftoffset.z, color.r, color.g, color.b, 255)

end



RegisterNetEvent('drp-housing:spawnRaidHouse')
AddEventHandler('drp-housing:spawnRaidHouse', function(passedHouse, coords, furniture)
    
    local prop = allhousing[passedHouse]['prop']
    local house = EnterHouse(Config.Props[prop], coords)
    local placed_furniture = {}
    for k, v in pairs(furniture) do
        local model = GetHashKey(v['object'])
        while not HasModelLoaded(model) do RequestModel(model) Wait(0) end
        local object = CreateObjectNoOffset(model, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])), false, false, false)
        SetEntityHeading(object, v['heading'])
        FreezeEntityPosition(object, true)
        SetEntityCoordsNoOffset(object, GetOffsetFromEntityInWorldCoords(house, vector3(v['offset'][1], v['offset'][2], v['offset'][3])))
        table.insert(placed_furniture, object)
    end
    SetEntityHeading(house, 0.0)
    local exit = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['door'])
    local storage = GetOffsetFromEntityInWorldCoords(house, Config.Offsets[prop]['storage'])
    TriggerServerEvent('drp-housing:setInstanceCoords', exit, coords, prop, furniture, passedHouse)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    for i = 1, 100 do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(100)
    end
    while IsEntityWaitingForWorldCollision(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), exit)
        Wait(100)
    end
    DoScreenFadeIn(1500)
    local in_house = true
    ClearPedWetness(PlayerPedId())
    while in_house do
        NetworkOverrideClockTime(15, 0, 0)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')

        DrawMarker(27, exit, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 10, 10, 150, false, false, 2, false, false, false)
        DrawMarker(27, storage, vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), vector3(1.0, 1.0, 1.0), 255, 10, 10, 150, false, false, 2, false, false, false)
        if Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
            HelpText((Strings['Press_E']):format(Strings['Storage']), storage)
            if IsControlJustReleased(0, 38) and Vdist2(GetEntityCoords(PlayerPedId()), storage) <= 2.0 then
                TriggerEvent('housing:openInv', passedHouse, allhousing[passedHouse]['prop'])
            end
        end
        if Vdist2(GetEntityCoords(PlayerPedId()), exit) <= 1.5 then
            HelpText((Strings['Press_E']):format(Strings['Exit']), exit)
            if IsControlJustReleased(0, 38) then
                ESX.UI.Menu.CloseAll()
                DoScreenFadeOut(750)
                DoScreenFadeIn(1500)
                TriggerServerEvent('drp-housing:leaveHouse',passedHouse)
                Wait(500)
                TriggerServerEvent('drp-housing:deleteInstance',passedHouse)
                in_house = false
                return
            end
        end
        Wait(0)
    end
    DeleteObject(passedHouse)
    for k, v in pairs(placed_furniture) do
        DeleteObject(v)
    end
end)

--[[ Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 344) then
            OpenKeyMenu()
        end
    end
end) ]]

function OpenKeyMenu()
    local kelements = {}
    for k,v in pairs(mykeys) do
        if allhousing[v]["owner"] == playeridentifier and not string.match(allhousing[v]["type"],"apt") then
            table.insert(kelements, {label = "[Owner] Key for "..allhousing[v]["type"].." #"..v, value = v})
        elseif allhousing[v]["owner"] == playeridentifier and string.match(allhousing[v]["type"],"apt") then
            table.insert(kelements, {label = "[Owner] Key for "..allhousing[v]["type"], value = v})
        elseif string.match(allhousing[v]["type"],"apt") then
            table.insert(kelements, {label = "[Guest] Key for "..allhousing[v]["type"], value = v})
        else
            table.insert(kelements, {label = "[Guest] Key for "..allhousing[v]["type"].." #"..v, value = v})
        end
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'manage_keys',
    {
        title = "Key Chain",
        align = 'bottom-right',
        elements = kelements,
    },
    function(data, menu)
        local elements = {
            [1] = {label = "Give Key to Nearby Player", value = "give"},
            [2] = {label = "Drop this key", value = "drop"},
        }

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'manage_specific_key',
        {
            title = "Manage Key for House #"..data.current.value,
            align = 'bottom-right',
            elements = elements,
        },
        function(data2, menu2)
            if data2.current.value == "give" then
                local houseid = data.current.value
                if playeridentifier == allhousing[houseid]['owner'] then
                    ESX.UI.Menu.CloseAll()
                    local playersInArea = ESX.Game.GetPlayersInArea(GetEntityCoords(GetPlayerPed(-1)), 2.0)
                    local nearbyplayers = {}
                    for i=1, #playersInArea, 1 do
                        if playersInArea[i] ~= PlayerId() then
                            local serverid = GetPlayerServerId(playersInArea[i])
                            table.insert(nearbyplayers, serverid)
                        end
                    end
                    -- TriggerServerEvent('drp-housing:giveMenu', data.current.value, nearbyplayers)
                    -- OpenGiveMenu(data.current.value, nearbyplayers)
                else
                    exports['mythic_notify']:SendAlert('error', 'You do not own this property', 7000)
                end
            end
            if data2.current.value == "drop" then
                ESX.UI.Menu.CloseAll()
                local houseid = data.current.value
                if playeridentifier == allhousing[houseid]['owner'] then
                    exports['mythic_notify']:SendAlert('error', 'Why dont you just sell your property?', 7000)
                else
                    TriggerServerEvent('drp-housing:removeKeyFromMenu', houseid, playeridentifier)
                    exports['mythic_notify']:SendAlert('success', 'You throw the key away', 7000)
                end
            end
            menu2.close()
        end, 
            function(data2, menu2)
            menu2.close()
        end)
    end, 
        function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('drp-housing:openGiveMenu')
AddEventHandler('drp-housing:openGiveMenu', function(houseid, nearbyplayers)
    OpenGiveMenu(houseid, nearbyplayers)
end)

function OpenGiveMenu(houseid, nearbyplayers, player)
    local elements = {}

    for i=1, #nearbyplayers, 1 do
        if nearbyplayers[i].player ~= GetPlayerServerId(PlayerId()) then
            table.insert(elements, {label = nearbyplayers[i].name, value = nearbyplayers[i].player})
        end
    end


    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'give_key_players',
    {
        title = "Choose the recipient",
        align = 'bottom-right',
        elements = elements,
    },
    function(data, menu)
        TriggerServerEvent('drp-housing:giveKeyFromMenu', data.current.value, houseid)
        exports['mythic_notify']:SendAlert('success', 'You have given a copy of your key', 7000)
        ESX.UI.Menu.CloseAll()
    end, 
        function(data, menu)
        menu.close()
    end)
end

function OpenHKeyMenu(id)
    
    ESX.TriggerServerCallback('drp-housing:housekeys', function(cb)
        housekeys = cb
        local elements = {}

    for k,v in pairs(housekeys) do
        table.insert(elements, {label = ""..v.name, value = v.identifier})
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'manage_hkeys',
    {
        title = "House keys",
        align = 'bottom-right',
        elements = elements,
    },
    function(data, menu)
        local elements = {
            [1] = {label = "Yes", value = "yes"},
            [2] = {label = "No", value = "no"},
        }

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'manage_specific_hkey',
        {
            title = "Revoke Key?",
            align = 'bottom-right',
            elements = elements,
        },
        function(data2, menu2)
            if data2.current.value == "yes" then
                if allhousing[id]['owner'] == data.current.value then
                    exports['mythic_notify']:SendAlert('error', 'Why dont you just sell your house?', 7000)
                    menu2.close()
                else
                    TriggerServerEvent('drp-housing:removesinglekey', id, data.current.value)
                    exports['mythic_notify']:SendAlert('success', 'You have removed a key from your house', 7000)
                    menu.close()
                    menu2.close()
                end
            elseif data2.current.value == "no" then
                menu2.close()
                OpenHKeyMenu(id)
            end
            menu2.close()
        end, 
            function(data2, menu2)
            menu2.close()
        end)
    end, 
        function(data, menu)
        menu.close()
    end)
    end, id)
end

function openAptMenu(name)
    ESX.TriggerServerCallback('drp-housing:aptMenu', function(cb)
        aptslist = cb
        local elements = {}
        for k,v in pairs(aptslist) do
            local gotkey = false
            for _k, _v in pairs(mykeys) do
                if _v == v.id then
                    gotkey = true
                end
            end
            if v.owner == "none" then
                table.insert(elements, {label = "#"..k.." | Available ", value = v.id, owner = v.owner, id = k, price = v.price})
            elseif v.owner == playeridentifier then
                table.insert(elements, {label = "#"..k.." | Owned ", value = v.id, owner = v.owner, id = k, price = v.price})
            elseif gotkey then
                table.insert(elements, {label = "#"..k.." | Guest ", value = v.id, owner = v.owner, id = k, price = v.price})
            else
                table.insert(elements, {label = "#"..k.." | Unavailable ", value = v.id, owner = v.owner, id = k, price = v.price})
            end
        end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'apartment_list',
    {
        title = "Available apartments",
        align = 'bottom-right',
        elements = elements,
    },
    function(data, menu)

        local elements = {}
        local ownsapthere = false
        for b,c in pairs(aptslist) do
            if c.owner == playeridentifier then
                ownsapthere = true
            end
        end
        local gotkey = false
        for _k, _v in pairs(mykeys) do
            if _v == data.current.value then
                gotkey = true
            end
        end

        if data.current.owner == "none" and not ownsapthere then
            table.insert(elements, {label = "Rent Apartment for $"..data.current.price.."/week", value = "rent", id = data.current.value})
        elseif data.current.owner == playeridentifier or gotkey then
            table.insert(elements, {label = "Enter", value = "enter", id = data.current.value})
            if data.current.owner == playeridentifier then
                table.insert(elements, {label = "Cancel apartment", value = "cancel", id = data.current.value})
                table.insert(elements, {label = "Reset property", value = "reset", id = data.current.value})
            end
        else
            table.insert(elements, {label = "Knock", value = "knock", id = data.current.value})
            if playerJob == "police" then
                table.insert(elements, {label = "Raid", value = "raid", id = data.current.value})
            end
        end



        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'manage_specific_hkey',
        {
            title = "Apartment #"..data.current.id,
            align = 'bottom-right',
            elements = elements,
        },
        function(data2, menu2)
            menu.close()
            if data2.current.value == "rent" then
                TriggerServerEvent('drp-housing:rentApt', data.current.value)
                menu2.close()
            elseif data2.current.value == "enter" then
                TriggerServerEvent('drp-housing:instanceCheck', data.current.value, "enter")
                menu2.close()
            elseif data2.current.value == "cancel" then
                TriggerServerEvent('drp-housing:sellApt',data.current.value)
                menu2.close()
            elseif data2.current.value == "knock" then
                TriggerServerEvent('drp-housing:knockDoor', data.current.value)
                menu2.close()
            elseif data2.current.value == "raid" then
                TriggerServerEvent('drp-housing:instanceCheck', data.current.value, "raid")
                menu2.close()
            elseif data2.current.value == "reset" then
                TriggerServerEvent('drp-housing:resetInstance', data.current.value)
                menu2.close()
            end
        end, 
            function(data2, menu2)
            menu2.close()
        end)
    end, 
        function(data, menu)
        menu.close()
    end)
    end, name)
end


RegisterNetEvent('drp-housing:createHousecom')
AddEventHandler('drp-housing:createHousecom', function(type,price)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local bool, groundz = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
    if type ~= "" and price ~= "" then
        local prop = type
        local price = tonumber(price)
        TriggerServerEvent('drp-housing:createHouse', coords, prop, price, groundz)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "Please enter interior and price", length = 7500})
    end
end)

RegisterNetEvent('drp-housing:createMotelcom')
AddEventHandler('drp-housing:createMotelcom', function(type,price)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local bool, groundz = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
    if type ~= "" and price ~= "" then
        local prop = type
        local price = tonumber(price)
        TriggerServerEvent('drp-housing:createMotel', coords, prop, price, groundz)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "Please enter interior and price", length = 7500})
    end
end)

RegisterNetEvent('drp-housing:createAptcom')
AddEventHandler('drp-housing:createAptcom', function(name, maxapt, rent)
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local bool, groundz = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
    if type ~= "" and price ~= "" then
        local prop = type
        local price = tonumber(price)
        TriggerServerEvent('drp-housing:createApt', coords, groundz, name, maxapt, rent)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "Please enter interior and price", length = 7500})
    end
end)

function GetAptNumber(name,id)
    ESX.TriggerServerCallback('drp-housing:getaptnum', function(cb)
        local aptnumber = nil
        local aptslist = {}
        aptslist = cb
        for k,v in pairs(aptslist) do
            if v.id == id then
                local aptnumber = k
                return aptnumber
            end
        end
    end, name)
end


RegisterNetEvent('drp-housing:setGPS')
AddEventHandler('drp-housing:setGPS', function(houseid)
    ClearGpsPlayerWaypoint()
    SetNewWaypoint(allhousing[houseid].doorx, allhousing[houseid].doory)
end)

RegisterNetEvent('drp-housing:closet')
AddEventHandler('drp-housing:closet', function(outfit)
    local elements = {}
    for k,v in pairs(outfit) do
        table.insert(elements, {label = v.name , value = v.slot})
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'outfit_list',
    {
        title = "Available outfits",
        align = 'bottom-right',
        elements = elements,
    },
    function(data, menu)
        local chosenslot = data.current.value
        menu.close()
        TriggerEvent('disc-inventoryhud:useWeapon')
        TriggerServerEvent('drp-framework:updatearmour', GetPedArmour(PlayerPedId()))
        exports['mythic_progbar']:Progress({name = "firstaid_action",
            duration = 2600,
            label = "Changing clothes...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {disableMovement = true, disableCarMovement = true, disableMouse = true, disableCombat = true},
            animation = {animDict = "oddjobs@basejump@ig_15", anim = "puton_parachute", flags = 49}
        })
        Citizen.Wait(3000)
        TriggerEvent('betrayed_skin:outfits', 3, chosenslot)
        TriggerServerEvent('drp-framework:loadArmour')
    end, 
        function(data, menu)
        menu.close()
    end)
end)