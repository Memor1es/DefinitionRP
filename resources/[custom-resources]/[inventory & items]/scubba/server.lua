ESX = nil
oxygenLevels = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
------------- Diving Suit -----------------------
ESX.RegisterUsableItem('scubba', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('drp:applyScubaGear', _source)
end)
------------- Oxygen Tank -----------------------
ESX.RegisterUsableItem('scubba_tank', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local count = xPlayer.getInventoryItem('scubba').count

    if count == 0 then
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You don\'t have scuba gear.', length = 12000})
    else
        TriggerClientEvent('drp:scubbaIsGearOn', _source)
    end
end)
-------------------------------------------------

RegisterNetEvent('drp:scubbaConfirmUseTank')
AddEventHandler('drp:scubbaConfirmUseTank', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('scubba_tank', 1)
    TriggerClientEvent('drp:useOxygenTank', _source)
end)



RegisterNetEvent('drp:updateOxygenLevels')
AddEventHandler('drp:updateOxygenLevels', function(oxygen)
    local _source = source
    oxygenLevels[_source] = oxygen
end)

AddEventHandler('esx:playerDropped', function(source)
    local _source = source
    local player = ESX.GetPlayerFromId(source)
    if oxygenLevels[_source] ~= nil then
        MySQL.Sync.execute("UPDATE users SET oxygen=@oxygen WHERE identifier=@identifier",
        {
            ['@identifier'] = player.identifier,
            ['@oxygen'] = oxygenLevels[_source]
        })
        Wait(1000)
        oxygenLevels[_source] = nil
    end
end)

ESX.RegisterServerCallback('drp:getOxygenLevel', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    local result = MySQL.Sync.fetchAll('SELECT * FROM `users` WHERE `identifier`=@id', 
    {
        ["@id"] = identifier
    })
    cb(result[1]["oxygen"])
end)


-- DEBUG THEAD
--[[ 
Citizen.CreateThread(function()
    while true do
        Wait(1)
        for k,v in pairs(oxygenLevels) do
            print(v)
        end
    end
end) ]]