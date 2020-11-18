RegisterCommand('search', function(source, args, raw)
    TriggerClientEvent('disc-inventoryhud:search', source)
end)

RegisterCommand('steal', function(source, args, raw)
    TriggerClientEvent('disc-inventoryhud:steal', source)
end)

ESX.RegisterServerCallback('disc-inventoryhud:getIdentifier', function(source, cb, serverid)
    cb(ESX.GetPlayerFromId(serverid).identifier)
end)

RegisterServerEvent('disc-inventoryhud:StealCash')
AddEventHandler('disc-inventoryhud:StealCash', function(data)
    local player = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromIdentifier(data.target)
    if player and target then
        if Config.Steal.cash then
            local targetsMoney = target.getMoney()
            local playersMoney = player.getMoney()
            local stealAmount
            if targetsMoney <= 2000 then
                stealAmount = targetsMoney
            else
                stealAmount = 2000
            end
            -- local targetFinalamount = targetsMoney - stealAmount
            player.addMoney(stealAmount)
            target.removeMoney(stealAmount)
        end
        if Config.Steal.black_money then
            player.addAccountMoney('black_money', target.getAccount('black_money').money)
            target.setAccountMoney('black_money', 0)
        end

        TriggerClientEvent('disc-inventoryhud:stealCooldown', source)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', target.source)
    end
end)

RegisterServerEvent('disc-inventoryhud:SeizeCash')
AddEventHandler('disc-inventoryhud:SeizeCash', function(data)
    local player = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromIdentifier(data.target)
    if player and target then
        if Config.Seize.cash then
            player.addMoney(target.getMoney())
            target.setMoney(0)
        end
        if Config.Seize.black_money then
            player.addAccountMoney('black_money', target.getAccount('black_money').money)
            target.setAccountMoney('black_money', 0)
        end
        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', target.source)
    end
end)



local weapontypes = {
{name = "WEAPON_ADVANCEDRIFLE", id = "WEAPON_ADVANCEDRIFLE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_APPISTOL", id = "WEAPON_APPISTOL",label = "You feel a small metalic object"},
{name = "WEAPON_ASSUALTRIFLE", id = "WEAPON_ASSUALTRIFLE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_ASSUALTSMG", id = "WEAPON_ASSUALTSMG",label = "You feel a large heavy metalic object"},
{name = "WEAPON_AUTOSHOTGUN", id = "WEAPON_AUTOSHOTGUN",label = "You feel a large heavy metalic object"},
{name = "WEAPON_BAT", id = "WEAPON_BAT",label = "You feel a long metalic object"},
{name = "WEAPON_BULLPUPRIFLE", id = "WEAPON_BULLPUPRIFLE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_BULLPUPSHOTGUN", id = "WEAPON_BULLPUPSHOTGUN",label = "You feel a large heavy metalic object"},
{name = "WEAPON_CARBINERIFLE", id = "WEAPON_CARBINERIFLE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_COMBATMG", id = "WEAPON_COMBATMG",label = "You feel a large heavy metalic object"},
{name = "WEAPON_COMBATPDW", id = "WEAPON_COMBATPDW",label = "You feel a large heavy metalic object"} ,
{name = "WEAPON_COMBATPISTOL", id = "WEAPON_COMBATPISTOL",label = "You feel a small metalic object"},
{name = "WEAPON_COMPACTRIFLE", id = "WEAPON_COMPACTRIFLE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_CROWBAR", id = "WEAPON_CROWBAR",label = "You feel a long metalic object"},
{name = "WEAPON_DAGGER", id = "WEAPON_DAGGER",label = "You feel a sharp object"},
{name = "WEAPON_DBSHOTGUN", id = "WEAPON_DBSHOTGUN",label = "You feel a large heavy metalic object"},
{name = "WEAPON_DOUBLEACTION", id = "WEAPON_DOUBLEACTION",label = "You feel a large heavy metalic object"},
{name = "WEAPON_FLAREGUN", id = "WEAPON_FLAREGUN",label = "You feel a small metalic object"},
{name = "WEAPON_GUNSENBERG", id = "WEAPON_GUNSENBERG",label = "You feel a large heavy metalic object"},
{name = "WEAPON_HATCHET", id = "WEAPON_HATCHET",label = "You feel a sharp object"},
{name = "WEAPON_HEAVYPISTOL", id = "WEAPON_HEAVYPISTOL",label = "You feel a small metalic object"},
{name = "WEAPON_HEAVYSHOTGUN", id = "WEAPON_HEAVYSHOTGUN",label = "You feel a large heavy metalic object"},
{name = "WEAPON_HEAVYSNIPER", id = "WEAPON_HEAVYSNIPER",label = "You feel a large heavy metalic object"},
{name = "WEAPON_BBAT", id = "WEAPON_BBAT",label = "You feel a wooden circular object"},
{name = "WEAPON_KITCHENKNIFE", id = "WEAPON_KITCHENKNIFE",label = "You feel a sharp object"},
{name = "WEAPON_MALLET", id = "WEAPON_MALLET",label = "You feel a medium object"},
{name = "WEAPON_SHOVEL", id = "WEAPON_SHOVEL",label = "You feel a large pointed object"},
{name = "WEAPON_KNIFE", id = "WEAPON_KNIFE",label = "You feel a sharp object"},
{name = "WEAPON_MACHETE", id = "WEAPON_MACHETE",label = "You feel a sharp object"},
{name = "WEAPON_MACHINEPISTOL", id = "WEAPON_MACHINEPISTOL",label = "You feel a small metalic object"},
{name = "WEAPON_MARKSMANRIFLE", id = "WEAPON_MARKSMANRIFLE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_MG", id = "WEAPON_MG", itemId = "WEAPON_MG",label = "You feel a large heavy metalic object"},
{name = "WEAPON_MICROSMG", id = "WEAPON_MICROSMG",label = "You feel a small metalic object"},
{name = "WEAPON_MINISMG", id = "WEAPON_MINISMG",label = "You feel a small metalic object"},
{name = "WEAPON_MUSKET", id = "WEAPON_MUSKET",label = "You feel a large heavy metalic object"},
{name = "WEAPON_NIGHTSTICK", id = "WEAPON_NIGHTSTICK",label = "You feel a long metalic object"},
{name = "WEAPON_PISTOL", id = "WEAPON_PISTOL",label = "You feel a small metalic object"},
{name = "WEAPON_PISTOL50", id = "WEAPON_PISTOL50",label = "You feel a small metalic object"},
{name = "WEAPON_PUMPSHOTGUN", id = "WEAPON_PUMPSHOTGUN",label = "You feel a large heavy metalic object"},
{name = "WEAPON_REVOLVER", id = "WEAPON_REVOLVER",label = "You feel a small metalic object"},
{name = "WEAPON_SAWNOFFSHOTGUN", id = "WEAPON_SAWNOFFSHOTGUN",label = "You feel a large heavy metalic object"},
{name = "WEAPON_SMG", id = "WEAPON_SMG",label = "You feel a small metalic object"},
{name = "WEAPON_SNIPERRIFLE", id = "WEAPON_SNIPERRIFLE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_SNSPISTOL", id = "WEAPON_SNSPISTOL",label = "You feel a small metalic object"},
{name = "WEAPON_SPECIALCARBINE", id = "WEAPON_SPECIALCARBINE",label = "You feel a large heavy metalic object"},
{name = "WEAPON_STINGER", id = "WEAPON_STINGER",label = "You feel a small metalic object"},
{name = "WEAPON_STUNGUN", id = "WEAPON_STUNGUN",label = "You feel a small metalic object"},
{name = "WEAPON_SWITCHBLADE", id = "WEAPON_SWITCHBLADE",label = "You feel a sharp object"},
{name = "WEAPON_VINTAGEPISTOL", id = "WEAPON_VINTAGEPISTOL",label = "You feel a small metalic object"},
{name = "WEAPON_PISTOL_MK2", id = "WEAPON_PISTOL_MK2",label = "You feel a small metalic object"}
}


RegisterServerEvent('disc-inventoryhud:friskdown')
AddEventHandler('disc-inventoryhud:friskdown', function(identifier)
    saveInventory(identifier, 'player')
    local _source = source
    MySQL.Async.fetchAll("SELECT * FROM disc_inventory WHERE owner = @identifier AND data LIKE '%WEAPON%'", { 
        ['@identifier'] = identifier,
    }, function(result)
        if json.encode(result) ~= "[]" then
            for i=1, #weapontypes do
                if string.match(json.encode(result), weapontypes[i]["name"]) then
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = weapontypes[i]["label"], length = 5000})
                end
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'You didnt feel anything...', length = 5000})
        end
    end)
end)

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