ESX.RegisterServerCallback('disc-inventoryhud:UseItemFromSlot', function(source, cb, slot)
    local player = ESX.GetPlayerFromId(source)
    InvType['player'].getInventory(player.identifier, function(inventory)
        if inventory[tostring(slot)] then
            local esxItem = player.getInventoryItem(inventory[tostring(slot)].name)
            if esxItem.usable then
                GetRPName(source, function(name)
                    cb(createDisplayItem(inventory[tostring(slot)], esxItem, slot))
                    TriggerEvent('discordbot:invlog', "Using "..esxItem.label.." from Hotbar slot "..slot, source)
                end)
                return
            end
        end
        cb(nil)
    end)
end)

function GetRPName(playerId, cb)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		cb(result[1].firstname.." "..result[1].lastname)
	end)
end

ESX.RegisterServerCallback('disc-inventoryhud:GetItemsInSlotsDisplay', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    InvType['player'].getInventory(player.identifier, function(inventory)
        local slotItems = {}
        for i = 1, 6, 1 do
            local item = inventory[tostring(i)]
            if item then
                local esxItem = player.getInventoryItem(item.name)
                slotItems[i] = {
                    itemId = item.name,
                    label = esxItem.label,
                    qty = item.count,
                    slot = i
                }
            else
                slotItems[i] = nil
            end
        end
        cb(slotItems)
    end)
end)


