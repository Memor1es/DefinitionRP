local stashSecondaryInventory = {
    type = 'stash',
    owner = ''
}

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end

    for k, v in pairs(Config.Stash) do
        local marker = {
            name = k,
            type = v.markerType or 1,
            coords = v.coords,
            colour = v.markerColour or { r = 55, b = 255, g = 55 },
            size = v.size or vector3(0.5, 0.5, 1.0),
            action = function()
                stashSecondaryInventory.owner = k
                openInventory(stashSecondaryInventory)
            end,
            shouldDraw = function()
                local playerJob = ESX.PlayerData.job.name
                local ident = ESX.PlayerData.identifier
                if v.job ~= nil then
                    for t, q in pairs(v.job) do
                        if playerJob == q then
                            return true
                        end
                    end
                end

                if v.players ~= nil then
                    for t, q in pairs(v.players) do
                        if ident == q then
                            return true
                        end
                    end
                end

                if v.job == nil and v.players == nil then
                    return true
                end
                return false
            end,
            msg = v.msg or 'Press ~INPUT_CONTEXT~ to open Stash',
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local player = GetPlayerPed(-1)
        local coords = GetEntityCoords(player)
        for k, v in pairs(Config.Stash) do
            if GetDistanceBetweenCoords(coords, v.coords, true) < 3.0 then
                ESX.Game.Utils.DrawText3D(vector3(v.coords), "[~g~E~w~] Open Storage", 0.6)
            end
        end
    end

end)