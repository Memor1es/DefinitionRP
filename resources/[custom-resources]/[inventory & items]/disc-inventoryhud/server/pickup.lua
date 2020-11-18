ESX = nil

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'pickup',
        label = 'pickup',
        slots = 5
    })
end)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local data = {}

RegisterServerEvent("pickupItem")
AddEventHandler("pickupItem", function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local source = source
    TriggerClientEvent("keen:addItem", xPlayer.source, item, count)
end)

RegisterServerEvent("inv:createPickup") -- Step 3
AddEventHandler("inv:createPickup", function(item,slot)
    local owner = "pickup - "..item.uid
    local data = {
    ["1"] = {
    name = item.item,
    count = item.qty
    }
}

createInventory(owner, "pickup", data)
end)