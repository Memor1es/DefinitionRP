ESX						= nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('drp:harnessCheck')
AddEventHandler('drp:harnessCheck', function()
    local src = source
    xPlayer = ESX.GetPlayerFromId(src)

    local xItem = xPlayer.getInventoryItem('harness')

    if xItem.count >= 1 then
        local chance = math.random(1,100)
        if chance < 25 then
            xPlayer.removeInventoryItem('harness', 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "The harness saved you, but the buckle looks damaged.", length = 12000})
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "The harness saved you.", length = 12000})
        end
    else
        TriggerClientEvent('drp:harnessEject', src)
        -- TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "DEBUG: No harness", length = 12000})
    end
end)