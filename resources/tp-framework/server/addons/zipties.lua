local ZiptiedPlayers = {}

ESX.RegisterUsableItem('ziptie', function(source)
	TriggerClientEvent('DRP:Client:Zipties:StartZiptie', source)
end)

ESX.RegisterUsableItem('lighter', function(source)
	local _src = source
	TriggerClientEvent('DRP:Client:Zipties:Unziptie', _src)
end)

--[[
ESX.RegisterUsableItem('scissors', function(source)
	local _src = source
	TriggerClientEvent('DRP:Client:Zipties:Unziptie', _src)
end)
]] -- If we add scissors in the future, zipties will immediately work with them

ESX.RegisterServerCallback('DRP:Server:Zipties:Check', function(source, cb, data)
    if source and data then
        local _src = tonumber(data)
        if ZiptiedPlayers[tonumber(_src)] then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('DRP:Server:Zipties:DoNotificationBar')
AddEventHandler('DRP:Server:Zipties:DoNotificationBar', function(src, action)
    if src and action then
        TriggerClientEvent('DRP:Server:Client:DoNotificationBar', src, action)
    end
end)

RegisterServerEvent('DRP:Server:Zipties:ZiptiePlayer')
AddEventHandler('DRP:Server:Zipties:ZiptiePlayer', function(player, toggle)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if xPlayer then
        local count = xPlayer.getInventoryItem('ziptie')
        if count then count = count.count; end
        if count and count > 0 then 
            if player then
                if toggle then
                    if not ZiptiedPlayers[tonumber(player)] then
                        xPlayer.removeInventoryItem('ziptie', 1)
                        TriggerClientEvent('DRP:Client:Zipties:ZiptiePlayer', player, true, _src, player)
                    else
                        TriggerClientEvent('DRP:Client:ShowMythicNotification', _src, 'error', 'The player is already ziptied', 5000)
                    end
                else
                    if ZiptiedPlayers[tonumber(player)] then
                        TriggerClientEvent('DRP:Client:Zipties:ZiptiePlayer', player, false, _src, player)
                    else
                        TriggerClientEvent('DRP:Client:ShowMythicNotification', _src, 'error', 'The player is not ziptied', 5000)
                    end
                end
            end
        else
            TriggerClientEvent('DRP:Client:ShowMythicNotification', _src, 'error', 'You do not have enough zipties.', 5000)
        end
    else
        TriggerClientEvent('DRP:Client:ShowMythicNotification', _src, 'error', 'There was an problem trying to ziptie this person', 5000)
    end
end)

RegisterServerEvent('DRP:Server:Zipties:ZiptiePlayer2')
AddEventHandler('DRP:Server:Zipties:ZiptiePlayer2', function(player, toggle)
    local _src = source
    if player then
        if toggle then
            if not ZiptiedPlayers[tonumber(player)] then
                ZiptiedPlayers[tonumber(player)] = true
                collectgarbage()
            end
        else
            if ZiptiedPlayers[tonumber(player)] then
                ZiptiedPlayers[tonumber(player)] = false
                collectgarbage()
            end
        end
    end
end)