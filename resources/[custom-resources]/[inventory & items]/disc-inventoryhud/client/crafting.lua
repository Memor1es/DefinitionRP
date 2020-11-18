local craftSecondaryInventory = {
    type = 'craft',
    owner = ''
}

Citizen.CreateThread(function()
    for k, v in pairs(Config.Craft) do
        if v.enableBlip then
            for val, coords in pairs(v.coords) do
                local blip = {
                    name = k,
                    coords = coords,
                    colour = v.blipColour or 2,
                    sprite = v.blipSprite or 52
                }
                TriggerEvent('disc-base:registerBlip', blip)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end
    for k, v in pairs(Config.Craft) do
        for val, coords in pairs(v.coords) do
            local bool, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
            if bool then
                coords = vector3(coords.x, coords.y, groundZ + 0.01)
            end

            local marker = {
                name = k .. val,
                coords = coords,
                type = v.markerType or 1,
                colour = v.markerColour or { r = 128, b = 128, g = 128 },
                size = v.size or vector3(2.0, 2.0, 1.0),
                action = function()
                    if ESX.PlayerData.job.name == v.job or v.job == 'all' then
                        craftSecondaryInventory.owner = k
                        openInventory(craftSecondaryInventory)
                    else
                        exports['mythic_notify']:SendAlert('error', 'You don\'t have the right job for this' , 10000)
                    end
                end,
                shouldDraw = function()
                    return true--[[ ESX.PlayerData.job.name == v.job or  v.job == 'all']]
                end,
                msg = v.msg or _U('keycraft'),
                -- msg = "Press E to use"
            }
            TriggerEvent('disc-base:registerMarker', marker)
        end
    end
end)

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end
    while true do
        for k, v in pairs(Config.Craft) do
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            for val, coords in pairs(v.coords) do
                if #(playerPos - coords) < 5 then
                    Draw3DText(coords.x, coords.y, coords.z, v.text)
                end
            end
        end
        Citizen.Wait(0)
    end
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

RegisterNetEvent('disc-inventoryhud:CLcraft')
AddEventHandler('disc-inventoryhud:CLcraft', function(data)
    playerPed = PlayerPedId()
    disableControls = true
    closeInventory()
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, false)
    exports["t0sic_loadingbar"]:StartDelayedFunction(data.craftText, data.time * 1000, function()
        disableControls = false
        ClearPedTasksImmediately(playerPed)
        TriggerServerEvent('disc-inventoryhud:SVcraft', data)
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if disableControls then
            DisableControlAction(0, 38, true)
        end
    end
end)