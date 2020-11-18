local housingInventory = {
    type = 'housing',
    owner = 'XYZ123'
}

RegisterNetEvent('housing:openInv')
AddEventHandler('housing:openInv', function(ownerId, prop)
    local playerPed = PlayerPedId()
    ESX.TriggerServerCallback('disc-inventoryhud:getIdentifier', function(identifier)
        housingInventory.owner = "house-"..ownerId
        housingInventory.type = "housing-"..prop
        openInventory(housingInventory)
    end, GetPlayerServerId(NetworkGetEntityOwner(playerPed)))
end)