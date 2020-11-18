local storageSecondaryInventory = {
    type = 'evidence',
    owner = 'XYZ123'
}

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end
    for k, v in pairs(Config.eLockers) do
        local marker = {
            name = k,
            type = v.markerType or 1,
            coords = v.mcoords,
            colour = v.markerColour or { r = 55, b = 255, g = 55 },
            size = v.size or vector3(1.0, 1.0, 1.0),
            locname = v.label,
            invtype = v.type,
            slots = v.slots,
            action = function()
                if ESX.PlayerData.job.grade >= 4 then
                    elockerMenu()
                end
            end,
            shouldDraw = function()
                return ESX.PlayerData.job.name == v.job or v.job == 'all'
            end,
            msg = 'Open evidence locker',
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end
    while true do
        Citizen.Wait(0)
        local player = GetPlayerPed(-1)
        local coords = GetEntityCoords(player)
        for k, v in pairs(Config.eLockers) do
            if GetDistanceBetweenCoords(coords, v.coords, true) < 3.0 and ESX.PlayerData.job.grade >= 4 and ESX.PlayerData.job.name == v.job then
                ESX.Game.Utils.DrawText3D(vector3(v.coords), "[~g~E~w~] Open evidence locker", 0.6)
            end
        end
    end
end)

function elockerMenu()
    ESX.TriggerServerCallback('eLockers:checkCaseFiles', function(cb)
        local eLocker = cb
        local elements = {
            head = {"Casefile ID","Opened by","Date opened","Actions"},
            rows = {}
        }

        for k,v in pairs(eLocker) do
            table.insert(elements.rows, {
                data = v.id,
                cols = {
                    v.id,
                    v.name,
                    v.date,
                    '{{' .. "Open" .. '|open}} {{' .. "Delete" .. '|delete}}',
                }
            })
        end
        ESX.UI.Menu.Open('list', GetCurrentResourceName(),'Case_Files', elements, function(data, menu)
            if data.value == 'open' then
                TriggerEvent("eLockers:openCaseFile",data.data)
                menu.close()
            elseif data.value == 'delete' then
                openELockerconfirm(data.data)
                menu.close()
			end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function openELockerconfirm(id)

    local elements1 = {}

    table.insert(elements1, {
        ["label"] = "<span style='color:green'>Yes</span>", 
        ["action"] = "yes"
    })
    table.insert(elements1, {
        ["label"] = "<span style='color:red'>No</span>", 
        ["action"] = "no"
    })

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "confirm_menu", {
        ["title"] = "Are you sure?",
        ["align"] = "right",
        ["elements"] = elements1
    }, function(menuData, menuHandle)
        local currentAction = menuData["current"]["action"]
        
        if currentAction == "yes" then
            TriggerServerEvent("eLockers:deleteCaseFile",id)
            menuHandle.close()
            Wait(200)
            elockerMenu()
        elseif currentAction == "no" then
            menuHandle.close()
            elockerMenu()
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

RegisterNetEvent("eLockers:openCaseFile")
AddEventHandler("eLockers:openCaseFile", function(id)
    for k, v in pairs(Config.eLockers) do
        local player = GetPlayerPed(-1)
        local coords = GetEntityCoords(player)
        if GetDistanceBetweenCoords(coords, v.coords, true) < 3.0 then
            local type = "eLocker"
            local eLockerName = "CASEFILE:"..id
            ESX.TriggerServerCallback('eLockers:checkLocker', function(cb)
                if cb == true then
                    TriggerServerEvent('disc-inv:refreshLocker', eLockerName, type)
                    Citizen.Wait(100)
                    storageSecondaryInventory.owner = eLockerName
                    storageSecondaryInventory.type = type
                    openInventory(storageSecondaryInventory)
                else
                    TriggerServerEvent('disc-inv:refreshLocker', eLockerName, type)
                    TriggerServerEvent('eLockers:openNewFile', id)
                    Citizen.Wait(100)
                    storageSecondaryInventory.owner = eLockerName
                    storageSecondaryInventory.type = type
                    openInventory(storageSecondaryInventory)
                end
            end, eLockerName)
        end
    end
end)


