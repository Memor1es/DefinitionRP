Citizen.CreateThread(function()
    for k,v in pairs(Config.houseSizes) do
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = "housing-"..k,
            label = "House Storage",
            slots = v.slots
        })
    end
end)