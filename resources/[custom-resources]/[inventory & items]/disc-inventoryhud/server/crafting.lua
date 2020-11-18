local craft = false

Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = "craft",
        label = "craft",
        slots = 15,
        getInventory = function(identifier, cb)
            getCraftInventory(identifier, cb)
        end,
        saveInventory = function(identifier, inventory)

        end,
        applyToInventory = function(identifier, f)
            getCraftInventory(identifier, f)
        end,
        getDisplayInventory = function(identifier, cb, source)
            getCraftDisplayInventory(identifier, cb, source)
        end
    })
end)

function getCraftInventory(identifier, cb)
    local craft = Config.Craft[identifier]
    local items = {}
    for k, v in pairs(craft.items) do
        v.usable = false
        items[tostring(k)] = v
    end
    cb(items)
end

function getCraftDisplayInventory(identifier, cb, source)
    local player = ESX.GetPlayerFromId(source)
    InvType["craft"].getInventory(identifier, function(inventory)
        local itemsObject = {}

        for k, v in pairs(inventory) do
            -- local esxItem = itemList[v.name]
            local esxItem = player.getInventoryItem(v.name)
            local recipe = true
            local description = CraftList[v.name].description .. "<br><br><strong>Items Needed:</strong><br>"
            for i,l in pairs(CraftList[v.name].recipe) do
                local label = l.label or l.item
                description = description .. " " ..l.qty.." x "..label.."<br>"
            end
            v.count = CraftList[v.name].count
            v.givable = false
            local item = createDisplayItem(v, esxItem, tonumber(k), 0, nil, description, recipe) -- (item, esxItem, slot, price, type, description, recipe)
            table.insert(itemsObject, item)
        end

        local inv = {
            invId = identifier,
            invTier = InvType["craft"],
            inventory = itemsObject,
            cash = 0,
            black_money = 0
        }
        cb(inv)
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

RegisterServerEvent('disc-inventoryhud:craft')
AddEventHandler('disc-inventoryhud:craft', function(data)
    local _source = source
    local items = CraftList[data.originItem.id].recipe
    data.time = CraftList[data.originItem.id].time
    data.craftText = CraftList[data.originItem.id].craftText or "Crafting Item..."
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- PrintTableOrString(data.originTier.name)

    for k,v in pairs(items) do
        local quantity = xPlayer.getInventoryItem(v.item).count
        if quantity >= v.qty then
            items[k].got = true
        else
            -- print(v.item)
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'You\'re missing '.. v.label, length = 12000})
            TriggerClientEvent('disc-inventoryhud:refreshInventory', _source)
            return
        end
        Citizen.Wait(100)
    end

    local count = 0

    for k,v in pairs(items) do
        count = count + 1
        xPlayer.removeInventoryItem(v.item, v.qty)
        Citizen.Wait(100)
    end

    if count == #items then
        TriggerClientEvent('disc-inventoryhud:CLcraft', _source, data)
    else
        print("ERROR")
    end
    TriggerClientEvent('disc-inventoryhud:refreshInventory', _source)
end)


RegisterServerEvent('disc-inventoryhud:SVcraft')
AddEventHandler('disc-inventoryhud:SVcraft', function(data)
    local _source = source
    -- local items = CraftList[data.originItem.id].recipe
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addInventoryItem(CraftList[data.originItem.id].id, CraftList[data.originItem.id].count)
    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = 'You crafted a '..data.originItem.label, length = 12000})


    if CraftList[data.originItem.id].gift then
        for k,v in pairs(CraftList[data.originItem.id].gift) do
            local chance = math.random(1,100)
            -- print(chance)
            if chance < v.chance then
                Citizen.Wait(100)
                xPlayer.addInventoryItem(v.item, v.amount)
                -- print("YOU WON THE LOTTERY", v.item) -- REMOVE LATER
            end
        end
    end
end)