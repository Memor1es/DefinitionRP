----------------------
---     GARAGE     ---
----------------------
TriggerEvent('es:addGroupCommand', 'setgarage', 'admin', function(source, args, raw)
    Wait(100)
    local source = source
    local ped = GetPlayerPed(source)
    local gcoords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    if args[1] ~= "" and heading ~= 0.0 then
        local id = args[1]
        MySQL.Async.execute('UPDATE houses SET gposx=@gposx,gposy=@gposy,gposz=@gposz,gheading=@gheading WHERE id = @id', {
            ['@gposx'] = gcoords.x,
            ['@gposy'] = gcoords.y,
            ['@gposz'] = gcoords.z,
            ['@gheading'] = heading,
            ['@id'] = id,
        }, function(rowschanged)
                if rowschanged > 0 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, {
                    type = 'success', text = "Garage created at house ID: "..id, length = 7500})
                    TriggerEvent('discordbot:houseLog', "```[GARAGE SET] "..GetPlayerName(source).." has set up or updated a garage at:"..id.."```")
                    TriggerClientEvent('drp-housing:reloadHouses', -1)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, {
                        type = 'error', text = "House with ID:"..id.." does not exist.", length = 7500})
                end
            end)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {
            type = 'error', text = "ID incorrect or heading was 0", length = 7500})
    end
end, function(source, args, raw)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows updating / setting a garage"})

local bliptoggle = false
TriggerEvent('es:addGroupCommand', 'hblips', 'admin', function(source)
    local src = source
    if bliptoggle == false then
        bliptoggle = true
        TriggerClientEvent('drp-housing:blips', src, bliptoggle)
    else
        bliptoggle = false
        TriggerClientEvent('drp-housing:blips', src, bliptoggle)
    end
end, function(source, args, raw)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows toggle of housing blips"})


----------------------
---    CREATION    ---
----------------------
TriggerEvent('es:addGroupCommand', 'createhouse', 'admin', function(source, args, raw)
    Wait(100)
    local source = source
    local type = args[1]
    local price = args[2]
    TriggerClientEvent('drp-housing:createHousecom', source, type, price)
end, function(source, args, raw)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows creating of new properties"})

TriggerEvent('es:addGroupCommand', 'createmotel', 'admin', function(source, args, raw)
    Wait(100)
    local source = source
    local type = "motel"
    local price = args[1]
    TriggerClientEvent('drp-housing:createMotelcom', source, type, price)
end, function(source, args, raw)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows creating of new properties"})

TriggerEvent('es:addGroupCommand', 'createapt', 'admin', function(source, args, raw)
    Wait(100)
    local source = source
    local name = args[1]
    local amount = tonumber(args[2])
    local price = tonumber(args[3])
    if args[1] ~= nil and args[2] ~= nil and args[3] ~= nil and args[4] == nil then
        TriggerClientEvent('drp-housing:createAptcom', source, name, amount, price)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {
            type = 'error', text = "Correct format /createapt name maxapts rentcost", length = 7500})
    end
end, function(source, args, raw)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows creating of apartment complexes"})

----------------------
---    DELETION    ---
----------------------
TriggerEvent('es:addGroupCommand', 'deletehouse', 'admin', function(source, args, raw)
    local src = source
    if args[1] ~= nil and args[2] == nil then
        TriggerClientEvent('drp-housing:doorcheck', src, args[1])
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "You typed something wrong...", length = 7500})
    end
end, function(source, args, raw)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows deletion of houses"})


----------------------------------------------------------------

RegisterServerEvent('drp-housing:createHouse')
AddEventHandler('drp-housing:createHouse', function(coords, prop, price, groundz)
    local src = source
    local coords = coords
    local prop = prop
    local price = price
    MySQL.Async.execute('INSERT INTO houses (type,doorx,doory,doorz, prop, price, owner) VALUES (@type, @doorx,@doory,@doorz, @prop, @price, @owner)', {
        ['@type'] = "house",
        ['@doorx'] = coords.x,
        ['@doory'] = coords.y,
        ['@doorz'] = groundz + 0.75,
        ['@prop'] = prop,
        ['@price'] = price,
        ['@owner'] = "none",
    }, function(rowsChanged)        
        TriggerClientEvent('drp-housing:reloadHouses', -1)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = "House created", length = 7500})
        TriggerEvent('discordbot:houseLog', "```[CREATE HOUSE] "..GetPlayerName(src).." has created house at X:"..coords.x..",Y:"..coords.y..",Z:"..groundz.."```")
    end)
end)

RegisterServerEvent('drp-housing:createMotel')
AddEventHandler('drp-housing:createMotel', function(coords, prop, price, groundz)
    local src = source
    local coords = coords
    local prop = prop
    local price = price
    MySQL.Async.execute('INSERT INTO houses (type,doorx,doory,doorz, prop, price, owner) VALUES (@type, @doorx,@doory,@doorz, @prop, @price, @owner)', {
        ['@type'] = "motel",
        ['@doorx'] = coords.x,
        ['@doory'] = coords.y,
        ['@doorz'] = groundz + 0.75,
        ['@prop'] = prop,
        ['@price'] = price,
        ['@owner'] = "none",
    }, function(rowsChanged)        
        TriggerClientEvent('drp-housing:reloadHouses', -1)
        -- TriggerEvent('drp-housing:getOwned', src)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = "Motel room created", length = 7500})
        TriggerEvent('discordbot:houseLog', "```[CREATE MOTEL] "..GetPlayerName(src).." has created motel at X:"..coords.x..",Y:"..coords.y..",Z:"..groundz.."```")
    end)
end)

RegisterServerEvent('drp-housing:createApt')
AddEventHandler('drp-housing:createApt', function(coords, groundz, name, maxapt, price)
    local src = source
    local name = name
    local coords = coords
    local maxapt = maxapt
    local rent = price
    MySQL.Async.execute('INSERT INTO apartments (doorx,doory,doorz, name, rent, maxapt) VALUES (@doorx,@doory,@doorz, @name, @rent, @maxapt)', {
        ['@doorx'] = coords.x,
        ['@doory'] = coords.y,
        ['@doorz'] = groundz + 0.75,
        ['@name'] = name,
        ['@rent'] = rent,
        ['@maxapt'] = maxapt,
    }, function(rowsChanged)    
        for i=1,maxapt do
            MySQL.Async.execute('INSERT INTO houses (type,doorx,doory,doorz, prop, price, owner) VALUES (@type, @doorx,@doory,@doorz, @prop, @price, @owner)', {
                ['@type'] = "apt "..name,
                ['@doorx'] = coords.x,
                ['@doory'] = coords.y,
                ['@doorz'] = groundz + 0.75,
                ['@prop'] = "nice",
                ['@price'] = rent,
                ['@owner'] = "none",
            })
        end
        TriggerClientEvent('drp-housing:reloadHouses', -1)
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = "Apartment complex created", length = 7500})
        TriggerEvent('discordbot:houseLog', "```[CREATE APT] "..GetPlayerName(src).." has created apartment complex at X:"..coords.x..",Y:"..coords.y..",Z:"..groundz.."```")
    end)
end)

RegisterServerEvent('drp-housing:deletehouse')
AddEventHandler('drp-housing:deletehouse', function(distance,house)
    local src = source
    local distance = distance
    local result = MySQL.Async.fetchAll('SELECT * FROM houses WHERE id = @id', {
        ['@id'] = house,
    }, 
    function(result)
        if result[2] then
            TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "Script error... more than one house?", length = 7500})
        elseif result[1] then
            if distance < 5 then
                MySQL.Async.execute('DELETE FROM houses WHERE id = @id', {
                    ['@id'] = house,
                },
                function(rowschanged)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = "Deleted house ID:"..house, length = 7500})
                    TriggerEvent('discordbot:houseLog', "```[DELETE HOUSE] "..GetPlayerName(src).." has deleted house ID:"..house.."```")
                    Wait(100)
                    TriggerEvent('drp-housing:removehousekey', house, src)
                    TriggerClientEvent('drp-housing:reloadHouses', -1)
                end)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = "You are too far from the door of house ID:"..house, length = 7500})
            end
        end
    end)
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local instances = {}
local houses = {}

RegisterServerEvent('drp-housing:enterHouse')
AddEventHandler('drp-housing:enterHouse', function(id, source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE id = @id", {
        ['@id'] = id
    },
        function(result)
        local house = result[1].id
        local shell = result[1].prop
        local furniture = json.decode(result[1].furniture)
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.identifier,
        }, function(result2)
            local bfurniture = json.decode(result2[1].bought_furniture)
            for k, v in pairs(Config.HouseSpawns) do
                if not v['taken'] then
                    TriggerClientEvent('drp-housing:spawnHouse', xPlayer.source, v['coords'], house, shell, furniture, bfurniture)
                    instances[id] = {
                        ['id'] = id,
                        ['owner'] = src,
                        ['coords'] = v['coords'],
                        ['housespawn'] = k,
                        ['players'] = {}}
                    instances[id]['players'][src] = src
                    houses[id] = src
                    v['taken'] = true

                    return
                end
            end
        end)
    end)
end)


RegisterServerEvent('drp-housing:raidHouse')
AddEventHandler('drp-housing:raidHouse', function(passedHouse, _source)
    local src = _source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE id = @id",{
        ['@id'] = passedHouse
    }, function(result)
            local house = passedHouse
            local furniture = json.decode(result[1].furniture)
            if result[1].id == passedHouse then
                for k, v in pairs(Config.HouseSpawns) do
                    if not v['taken'] then
                        TriggerClientEvent('drp-housing:spawnRaidHouse', xPlayer.source, passedHouse, v['coords'], furniture)
                        TriggerEvent('discordbot:houseLog', "```[RAID INSTANCE] "..GetPlayerName(src).." has raided house ID:"..passedHouse.."```")
                        instances[passedHouse] = {
                            ['id'] = passedHouse,
                            ['owner'] = src,
                            ['coords'] = v['coords'],
                            ['housespawn'] = k,
                            ['players'] = {},
                            }
                            instances[passedHouse]['players'][src] = src
                            houses[passedHouse] = src
                            v['taken'] = true
                        return
                    end
                end
            else
                print(('There seems to be some kind of error in the script "%s", #%s tried to enter house %s but he/she doesn\'t own house #%s.'):format(GetCurrentResourceName(), xPlayer.identifier, id, id))
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

RegisterServerEvent('drp-housing:buy_furniture')
AddEventHandler('drp-housing:buy_furniture', function(category, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local hadMoney = false
    if Config.Furniture[Config.Furniture['Categories'][category][1]][id] then
        if xPlayer.getAccount('bank').money >= Config.Furniture[Config.Furniture['Categories'][category][1]][id][3] then
            xPlayer.removeAccountMoney('bank', Config.Furniture[Config.Furniture['Categories'][category][1]][id][3])
            hadMoney = true
        else
            if xPlayer.getMoney() >= Config.Furniture[Config.Furniture['Categories'][category][1]][id][3] then
                xPlayer.removeMoney(Config.Furniture[Config.Furniture['Categories'][category][1]][id][3])
                hadMoney = true
            else
                TriggerClientEvent('esx:showNotifciation', xPlayer.source, Strings['no_money'])
            end
        end
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'There seems to be some kind of error in the script, could not buy furniture.')
    end
    if hadMoney then
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result)
            local furniture = json.decode(result[1]['bought_furniture'])
            if furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]] then 
                furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]]['amount'] = furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]]['amount'] + 1
            else
                furniture[Config.Furniture[Config.Furniture['Categories'][category][1]][id][2]] = {['amount'] = 1, ['name'] = Config.Furniture[Config.Furniture['Categories'][category][1]][id][1]}
            end
            MySQL.Async.execute("UPDATE users SET bought_furniture=@bought_furniture WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@bought_furniture'] = json.encode(furniture)}) 
            TriggerClientEvent('esx:showNotification', xPlayer.source, (Strings['Bought_Furniture']):format(Config.Furniture[Config.Furniture['Categories'][category][1]][id][1], Config.Furniture[Config.Furniture['Categories'][category][1]][id][3]))
        end)
    end
end)

RegisterServerEvent('drp-housing:leaveHouse')
AddEventHandler('drp-housing:leaveHouse', function(house)
    local src = source
    if instances[house]['players'][src] then
        local oldPlayers = instances[house]['players']
        local newPlayers = {}
        for k, v in pairs(oldPlayers) do
            if v ~= src then
                newPlayers[k] = v
            end
        end
        instances[house]['players'] = newPlayers
    end
end)

RegisterServerEvent('drp-housing:deleteInstance')
AddEventHandler('drp-housing:deleteInstance', function(house)
    local src = source
    local players = json.encode(instances[house]['players'])
    if players == "[]" then
        Config.HouseSpawns[instances[house]['housespawn']]['taken'] = false
        instances[house] = {}
        TriggerClientEvent('drp-housing:leaveHouse',src, house)
    else
        TriggerClientEvent('drp-housing:leaveHouse', src, house)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    if instances[1] ~= nil then
        for k, v in pairs(instances) do
            for k2, v2 in pairs(instances[k]['players']) do
                if instances[k]['players'][k2] == src then
                    instances[k]['players'][k2] = {}
                    if #instances[k]['players'] == 0 then
                        instances[k] = {}
                    end
                    return
                end
            end
        end
    end
end)

RegisterServerEvent('drp-housing:letIn')
AddEventHandler('drp-housing:letIn', function(plr, storage, house)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if instances[house] then
        if not instances[house]['players'][plr] then 
            instances[house]['players'][plr] = plr
            local spawnpos = instances[house]['housecoords']
            MySQL.Async.fetchAll("SELECT furniture FROM houses WHERE id=@id", {['@id'] = instances[house]['id']}, function(result)
                local furniture = json.decode(result[1].furniture)
                TriggerClientEvent('drp-housing:knockAccept', plr, instances[house]['coords'], instances[house]['id'], storage, spawnpos, furniture, src)
            end)
        end
    end
end)

RegisterServerEvent('drp-housing:instanceCheck')
AddEventHandler('drp-housing:instanceCheck', function(houseid, action)
    local _source = source
    for k,v in pairs(instances) do
        if instances[k].id == houseid then
            if instances[houseid] then
                instances[houseid]['players'][_source] = _source
                local spawnpos = instances[houseid]['housecoords']
                local storage = instances[houseid]['coords']
                MySQL.Async.fetchAll("SELECT furniture FROM houses WHERE id=@id", {['@id'] = instances[houseid]['id']}, function(result)
                    local furniture = json.decode(result[1].furniture)
                    TriggerClientEvent('drp-housing:knockAccept', _source, instances[houseid]['coords'], instances[houseid]['id'], storage, spawnpos, furniture, houseid)
                end)
            end
            return
        end
    end

    if action == "raid" then
        TriggerEvent('drp-housing:raidHouse', houseid, _source)
    elseif action == "enter" then
        TriggerEvent('drp-housing:enterHouse', houseid, _source)
    end
end)

RegisterServerEvent('drp-housing:resetInstance')
AddEventHandler('drp-housing:resetInstance', function(houseid)
    local src = source
    for k, v in pairs(instances) do
        if instances[k].id == houseid then
            instances[k] = {}
        end
    end
end)

ESX.RegisterServerCallback('drp-housing:checkInstances', function(source, cb, houseid)
    for k,v in pairs(instances) do
        if instances[k].id == houseid then
            cb(instances[k])
            return
        end
    end
    cb("none")
end)

RegisterServerEvent('drp-housing:unKnockDoor')
AddEventHandler('drp-housing:unKnockDoor', function(id)
    local src = source
    if instances[id] then
        TriggerClientEvent('drp-housing:removeDoorKnock', instances[id]['owner'], src)
    end
end)

RegisterServerEvent('drp-housing:knockDoor')
AddEventHandler('drp-housing:knockDoor', function(id)
    local src = source
    if instances[id] then
        local xPlayer = ESX.GetPlayerFromId(src)
        local identifier = xPlayer.identifier
        MySQL.Async.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", {
            ['@identifier'] = identifier
        },function(result)
            local fullname = result[1].firstname.." "..result[1].lastname
            TriggerClientEvent('drp-housing:knockedDoor', instances[id]['owner'], src, fullname) -- This should send something to your client, with my source (src)
        end)
    else
        TriggerClientEvent('esx:showNotification', src, Strings['Noone_Home'])
    end
end)

RegisterServerEvent('drp-housing:setInstanceCoords')
AddEventHandler('drp-housing:setInstanceCoords', function(coords, housecoords, prop, placedfurniture, house)
    local src = source
    if instances[house] then
        instances[house]['coords'] = coords
        instances[house]['housecoords'] = housecoords
        instances[house]['furniture'] = placedfurniture
        instances[house]['prop'] = prop
    end
end)

RegisterServerEvent('drp-housing:buyHouse')
AddEventHandler('drp-housing:buyHouse', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE id = @id", {['@id'] = id}, function(result)
        if result[1].owner == "none" then
            if xPlayer.getAccount('bank').money >= result[1].price then
                xPlayer.removeAccountMoney('bank', result[1].price)
                MySQL.Async.execute("UPDATE houses SET owner=@owner WHERE id=@id", {
                    ['@owner'] = xPlayer.identifier,
                    ['@id'] = id},
                    function(rowschanged)
                    TriggerEvent('drp-housing:addhousekey', id, src)
                    TriggerClientEvent('drp-housing:reloadHouses', -1)
                end)
            else 
                TriggerClientEvent('esx:showNotification', xPlayer.source, Strings['No_Money'])
            end
        end
    end)
end)

RegisterServerEvent('drp-housing:rentApt')
AddEventHandler('drp-housing:rentApt', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE id = @id", {['@id'] = id}, function(result)
        if result[1].owner == "none" then
            local bank = xPlayer.getAccount('bank').money
            if bank > result[1].price then
                MySQL.Async.execute("UPDATE houses SET owner=@owner, lastpayment=@lastpayment WHERE id=@id", {
                    ['@owner'] = xPlayer.identifier,
                    ['@id'] = id,
                    ['@lastpayment'] = GetDay()
                }, function(rowschanged)
                    TriggerEvent('drp-housing:addhousekey', id, src)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'success', text = "You have rented an apartment", length = 7500})
                    xPlayer.removeAccountMoney('bank', result[1].price)
                    TriggerClientEvent('drp-housing:reloadHouses', -1)
                end)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text = "You do not have enough money to rent this apartment", length = 7500})
            end
        end
    end)
end)

RegisterServerEvent('drp-housing:rentMotel')
AddEventHandler('drp-housing:rentMotel', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE id = @id", {['@id'] = id}, function(result)
        if result[1].owner == "none" then
            local bank = xPlayer.getAccount('bank').money
            if bank > result[1].price then
                MySQL.Async.execute("UPDATE houses SET owner=@owner, lastpayment=@lastpayment WHERE id=@id", {
                    ['@owner'] = xPlayer.identifier,
                    ['@id'] = id,
                    ['@lastpayment'] = GetDay()
                }, function(rowschanged)
                    TriggerEvent('drp-housing:addhousekey', id, src)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'success', text = "You have rented a room", length = 7500})
                    xPlayer.removeAccountMoney('bank', result[1].price)
                    TriggerClientEvent('drp-housing:reloadHouses', -1)
                end)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text = "You do not have enough money to rent this room", length = 7500})
            end
        end
    end)
end)


RegisterServerEvent('drp-housing:addhousekey')
AddEventHandler('drp-housing:addhousekey', function(id, player) -- player receiving key
    local source = player
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll("SELECT keylist FROM housekeys WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    },function(result)
        local mykeys = json.decode(result[1].keylist)

        table.insert(mykeys, id)
        updatedkeys = json.encode(mykeys)

        MySQL.Async.execute("UPDATE housekeys SET keylist=@keylist WHERE identifier=@identifier", {
            ['@identifier'] = xPlayer.identifier,
            ['@keylist'] = updatedkeys
        },
            function(rowschanged)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
            Wait(1500)
        end)
    end)
end)

RegisterServerEvent('drp-housing:removehousekey')
AddEventHandler('drp-housing:removehousekey', function(id, player) -- player receiving key
    local source = player
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll("SELECT * FROM housekeys WHERE keylist LIKE @keylist", {
        ['@keylist'] = "%"..id.."%"
    },function(result)

        for k,v in pairs(result) do
            local keys = json.decode(v.keylist)
            local identifier = v.identifier
            for i = #keys, 1, -1 do
                if keys[i] == id then
                    table.remove(keys, i)
                end
            end
            local updatedkeys = json.encode(keys)
            MySQL.Async.execute("UPDATE housekeys SET keylist=@keylist WHERE identifier=@identifier", {
                ['@identifier'] = identifier,
                ['@keylist'] = updatedkeys
            },
                function(rowschanged)
                Wait(1500)
                TriggerClientEvent('drp-housing:reloadHouses', -1)
            end)
        end
    end)
end)

RegisterServerEvent('drp-housing:removesinglekey')
AddEventHandler('drp-housing:removesinglekey', function(houseid, identifier)
    MySQL.Async.fetchAll("SELECT * FROM housekeys WHERE identifier = @identifier", {
        ['@identifier'] = identifier,
    },function(result)
        -- print("Query ran", identifier)
        local keys = json.decode(result[1].keylist)
        for i = #keys, 1, -1 do
            if keys[i] == houseid then
                table.remove(keys, i)
            end
        end
        local updatedkeys = json.encode(keys)
        MySQL.Async.execute("UPDATE housekeys SET keylist=@keylist WHERE identifier=@identifier", {
            ['@keylist'] = updatedkeys,
            ['@identifier'] = identifier
        },
            function(rowschanged)
            Wait(1500)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
        end)
    end)
end)

RegisterServerEvent('drp-housing:sellHouse')
AddEventHandler('drp-housing:sellHouse', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE owner = @owner AND id = @id", {
        ['@owner'] = xPlayer.identifier,
        ['@id'] = id
    }, function(result)
        if result[1].price then
            xPlayer.addMoney(result[1].price * (Config.SellPercentage/100))
            TriggerClientEvent('esx:showNotification', xPlayer.source, (Strings['Sold_House']):format(math.floor(result[1].price * (Config.SellPercentage/100))))
            MySQL.Async.execute("UPDATE houses SET owner=@owner WHERE id=@id", {
                ['@id'] = id,
                ['@owner'] = 'none'
            })  
            TriggerEvent('drp-housing:removehousekey', id, src)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
        end
    end)
end)

RegisterServerEvent('drp-housing:sellMotel')
AddEventHandler('drp-housing:sellMotel', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE owner = @owner AND id = @id", {
        ['@owner'] = xPlayer.identifier,
        ['@id'] = id
    }, function(result)
        if result[1].price then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "You cancelled your room")
            MySQL.Async.execute("UPDATE houses SET owner=@owner WHERE id=@id", {
                ['@id'] = id,
                ['@owner'] = 'none'
            })  
            TriggerEvent('drp-housing:removehousekey', id, src)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
        end
    end)
end)

RegisterServerEvent('drp-housing:sellApt')
AddEventHandler('drp-housing:sellApt', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE owner = @owner AND id = @id", {
        ['@owner'] = xPlayer.identifier,
        ['@id'] = id
    }, function(result)
        if result[1].price then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "You cancelled your apartment")
            MySQL.Async.execute("UPDATE houses SET owner=@owner WHERE id=@id", {
                ['@id'] = id,
                ['@owner'] = 'none'
            })  
            TriggerEvent('drp-housing:removehousekey', id, src)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
        end
    end)
end)

RegisterServerEvent('drp-housing:getOwned')
AddEventHandler('drp-housing:getOwned', function(passedsource)
    local src = passedsource
    local xPlayer = ESX.GetPlayerFromId(src)
    local result = MySQL.Async.fetchAll("SELECT * FROM houses", {}, function(result)
        local allhousing = result
        MySQL.Async.fetchAll("SELECT * FROM housekeys WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(result2)
            if result2[1] == nil then
                MySQL.Async.fetchAll("SELECT * FROM characters WHERE identifier = @identifier", { 
                    ['@identifier'] = xPlayer.identifier,
                }, function(result0)
                    if result0 then
                        local name = result0[1].firstname.." "..result0[1].lastname
                        MySQL.Async.execute("INSERT INTO housekeys (identifier,name) VALUES (@identifier, @name)", {
                            ['@identifier'] = xPlayer.identifier,
                            ['@name'] = name,
                        }, function(rowschanged)
                            local mykeys = "[]"
                            TriggerClientEvent('drp-housing:setHouse', xPlayer.source, allhousing, mykeys)
                            TriggerEvent('phone:getHousingData', allhousing)
                        end)
                    end
                end)
            else
                local mykeys = result2[1].keylist
                TriggerClientEvent('drp-housing:setHouse', xPlayer.source, allhousing, mykeys)
                TriggerEvent('phone:getHousingData', allhousing)
            end
        end)
    end)
    local result9 = MySQL.Async.fetchAll("SELECT * FROM apartments", {}, function(result9)
        if result9 then
            local allapts = result9
            TriggerClientEvent('drp-housing:setApt', xPlayer.source, allapts)
        end
    end)
end)

RegisterServerEvent('drp-housing:furnish')
AddEventHandler('drp-housing:furnish', function(houseid, housefurniture, playerfurniture)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.execute("UPDATE houses SET furniture=@furniture WHERE id=@id", {
        ['@id'] = houseid,
        ['@furniture'] = json.encode(housefurniture)
    }) 
    MySQL.Async.execute("UPDATE users SET bought_furniture=@bought_furniture WHERE identifier=@identifier", {
        ['@identifier'] = xPlayer.identifier,
        ['@bought_furniture'] = json.encode(playerfurniture)
    }) 
end)

ESX.RegisterServerCallback('drp-housing:hasGuests', function(source, cb, houseid)
    if #instances[houseid]['players'] > 1 then
        cb(true) -- Has guests
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('drp-housing:housekeys', function(source, cb, id) -- RETURNS TABLE OF PLAYERS WITH SPECIFIC KEY
    local housekeys = {}
    MySQL.Async.fetchAll("SELECT * FROM housekeys WHERE keylist LIKE @keylist", {
        ['@keylist'] = "%"..id.."%"
    },function(result)
        for k,v in pairs(result) do
            local keys = json.decode(v.keylist)
            local identifier = v.identifier
            local name = v.name
            for i = #keys, 1, -1 do
                if keys[i] == id then
                    table.insert(housekeys, v)
                end
            end
        end
        cb(housekeys)
    end)
end)

ESX.RegisterServerCallback('drp-housing:aptMenu', function(source, cb, name)
    local aptslist = {}
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE type = @type", {
        ['@type'] = "apt "..name
    },function(result)
        for k,v in pairs(result) do
            table.insert(aptslist, v)
        end
        cb(aptslist)
    end)
end)

ESX.RegisterServerCallback('drp-housing:getaptnum', function(source, cb, name, id)
    local aptslist = {}
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE type = @type", {
        ['@type'] = name,
    },function(result)
        for k,v in pairs(result) do
            table.insert(aptslist, v)
        end
        for _k,_v in pairs(aptslist) do
            if _v.id == id then
                apartnumber = _k
            end
        end
        cb(apartnumber)
    end)
end)


RegisterServerEvent('drp-housing:giveMenu')
AddEventHandler('drp-housing:giveMenu', function(houseid, nearbyplayers)
    -- print(houseid, nearbyplayers)
    local src = source
    local nearbyplayers = nearbyplayers
    local namelist = {}
    local data = {}
    MySQL.Async.fetchAll("SELECT * FROM characters", {
    },function(result)
        for i=1, #nearbyplayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(nearbyplayers[i])
            local identifier = xPlayer.identifier
            for ii=1, #result do
                if identifier == result[ii].identifier then
                    local fullname = result[ii].firstname.." "..result[ii].lastname
                    local player = nearbyplayers[i]
                    table.insert(namelist, {name = fullname, player = player, identifier = result[ii].identifier})
                end
            end
        end
        -- print("built list of names")
        TriggerClientEvent('phone:buildGiveKeyMenu', src, houseid, namelist)
    end)
end)

ESX.RegisterServerCallback('drp-housing:hostOnline', function(source, cb, host)
    local online = false
    if instances[host] then
        local playerlist = GetPlayers()
        for id, src in pairs(playerlist) do
            if host == tonumber(src) then
                online = true
                break
            end
        end
        if not online then
            Config.HouseSpawns[instances[host]['housespawn']]['taken'] = false
            instances[host] = {}
        end
    end
    cb(online)
end)

RegisterCommand('instance', function()
    PrintTableOrString(instances)
end)

RegisterServerEvent('drp-housing:giveKeyFromMenu')
AddEventHandler('drp-housing:giveKeyFromMenu', function(player, houseid)
    local identifier = player

    local onlinePlayers = GetPlayers()
    print(json.encode(onlinePlayers))

--[[     for k,v in pairs(onlinePlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if (xPlayer.identifier == player) then
            TriggerClientEvent('phone:addnotification', v, "Realtor", "You've been given a key to house #"..houseid)
            break
        end
    end

 ]]    
    MySQL.Async.fetchAll("SELECT keylist FROM housekeys WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    },function(result)
        local mykeys = json.decode(result[1].keylist)
        table.insert(mykeys, houseid)
        updatedkeys = json.encode(mykeys)
        MySQL.Async.execute("UPDATE housekeys SET keylist=@keylist WHERE identifier=@identifier", {
            ['@identifier'] = identifier,
            ['@keylist'] = updatedkeys
        },
            function(rowschanged)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
            Wait(1500)
        end)
    end)
end)

RegisterServerEvent('drp-housing:removeKeyFromMenu')
AddEventHandler('drp-housing:removeKeyFromMenu', function(houseid,identifier, source)
    MySQL.Async.fetchAll("SELECT * FROM housekeys WHERE identifier = @identifier", {
        ['@identifier'] = identifier,
    },function(result)
        local keys = json.decode(result[1].keylist)
        for i = #keys, 1, -1 do
            if keys[i] == houseid then
                table.remove(keys, i)
            end
        end
        local updatedkeys = json.encode(keys)
        MySQL.Async.execute("UPDATE housekeys SET keylist=@keylist WHERE identifier=@identifier", {
            ['@keylist'] = updatedkeys,
            ['@identifier'] = identifier
        },
            function(rowschanged)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
            Wait(1500)
        end)
    end)
end)




function motelpayments()
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE type = @type", {
        ['@type'] = "motel",
    },function(result)
        for k,v in pairs(result) do
            MySQL.Async.execute("UPDATE houses SET payments=@payments WHERE id = @id", {
                ['@id'] = v.id,
                ['@payments'] = v.payments - v.price
            },
                function(rowschanged)
            end)
        end
    end)
end

function GetDay()
	local timestamp = os.time()
	local d         = os.date('*t', timestamp).yday
	return d
end

RegisterServerEvent('drp-housing:motellastpayment')
AddEventHandler('drp-housing:motellastpayment', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE owner = @owner AND type = @type", {
        ['@owner'] = xPlayer.identifier,
        ['@type'] = "motel",
    }, function(result)
        for k, v in pairs(result) do
            local sincelastpayment = GetDay() - v.lastpayment
            if sincelastpayment < 0 then
                sincelastpayment = sincelastpayment + 365
            end
            if sincelastpayment >= 7 and sincelastpayment < 14 then
                local bank = xPlayer.getAccount('bank').money
                if bank > v.price then
                    xPlayer.removeAccountMoney('bank', v.price)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'success', text = "You have paid $"..v.price.." rent on motel #"..v.id, length = 7500})
                    updatePaymentdate(v.id)
                else
                    local overdue = 7 - sincelastpayment
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text = "You failed to pay rent and you are "..due.." days overdue on day 14 you will lose motel #"..v.id, length = 7500})
                    end
            elseif sincelastpayment >= 14 then
            local bank = xPlayer.getAccount('bank').money
            local weeks = sincelastpayment/7
            local owed = v.price*weeks
                if bank > owed then
                    xPlayer.removeAccountMoney('bank', owed)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'success', text = "You have paid $"..owed.." rent on motel #"..v.id, length = 7500})
                    updatePaymentdate(v.id)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text = "You have failed to pay rent and motel #"..v.id.." was taken back by the owner", length = 7500})
                    sellProperty(v.id,src)
                end
            end
        end
    end)
end)

RegisterServerEvent('drp-housing:aptlastpayment')
AddEventHandler('drp-housing:aptlastpayment', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE owner = @owner and type LIKE @type", {
        ['@owner'] = xPlayer.identifier,
        ['@type'] = "%apt%"
    }, function(result)
        for k, v in pairs(result) do
            local sincelastpayment = GetDay() - v.lastpayment
            if sincelastpayment < 0 then
                sincelastpayment = sincelastpayment + 365
            end
            if sincelastpayment >= 7 and sincelastpayment < 14 then
                local bank = xPlayer.getAccount('bank').money
                if bank > v.price then
                    xPlayer.removeAccountMoney('bank', v.price)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'success', text = "You have paid $"..v.price.." rent on motel #"..v.id, length = 7500})
                    updatePaymentdate(v.id)
                else
                    local overdue = 7 - sincelastpayment
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'error', text = "You failed to pay rent and you are "..overdue.." days overdue on day 14 you will lose apartment #"..v.id, length = 7500})
                    end
            elseif sincelastpayment >= 14 then
                local bank = xPlayer.getAccount('bank').money
                local weeks = sincelastpayment/7
                local owed = v.price*weeks
                if bank > owed then
                    xPlayer.removeAccountMoney('bank', owed)
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {type = 'success', text = "You have paid $"..owed.." rent on motel #"..v.id, length = 7500})
                    updatePaymentdate(v.id)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', src, {
                    type = 'error', text = "You have failed to pay rent and apartment #"..v.id.." was taken back by the owner", length = 7500})
                    sellProperty(v.id,src)
                end
            end
        end
    end)
end)

function sellProperty(id,player)
    local src = player
    local xPlayer = ESX.GetPlayerFromId(src)
    MySQL.Async.fetchAll("SELECT * FROM houses WHERE owner = @owner AND id = @id", {
        ['@owner'] = xPlayer.identifier,
        ['@id'] = id
    }, function(result)
        if result[1].price then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "You cancelled your room")
            MySQL.Async.execute("UPDATE houses SET owner=@owner WHERE id=@id", {
                ['@id'] = id,
                ['@owner'] = 'none'
            })  
            TriggerEvent('drp-housing:removehousekey', id, src)
            TriggerClientEvent('drp-housing:reloadHouses', -1)
        end
    end)
end

function updatePaymentdate(id)
    MySQL.Async.execute("UPDATE houses SET lastpayment=@lastpayment WHERE id = @id", {
        ['@id'] = id,
        ['@lastpayment'] = GetDay()
    })
end

RegisterServerEvent('drp-housing:closets')
AddEventHandler('drp-housing:closets', function()
    local src = source
    local user = ESX.GetPlayerFromId(src)
    local steamid = user.identifier
    local slot = slot
    local name = name

    if not steamid then return end

    MySQL.Async.fetchAll("SELECT slot, name FROM character_outfits WHERE steamid = @steamid", {['steamid'] = steamid}, function(skincheck)
        TriggerClientEvent('drp-housing:closet',src, skincheck)
    end)
end)