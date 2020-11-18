Citizen.CreateThread(function()
    for k,v in pairs(Config.eLockers) do
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = v.type,
            label = v.label,
            slots = v.slots
        })
    end
end)

RegisterServerEvent("eLockers:sendCaseFileID")
AddEventHandler("eLockers:sendCaseFileID", function(id)
    local src = source
    TriggerClientEvent("eLockers:openCaseFile", src, id)
end)

RegisterServerEvent("eLockers:openNewFile")
AddEventHandler("eLockers:openNewFile", function(id)
    local src = source
    local player = ESX.GetPlayerFromId(source)
    if player then
        local sqlQuery = [[
            SELECT * FROM characters WHERE identifier = @identifier
        ]]
        MySQL.Async.fetchAll(sqlQuery, {
            ["@identifier"] = player.identifier,
        }, function(result)
            if result[1] then
                local fullname = result[1].firstname.." "..result[1].lastname
                MySQL.Async.fetchAll('SELECT * FROM eLockers WHERE id = @id', {
                    ['@id'] = id,
                }, function(result2)
                    if not result2[1] then
                        MySQL.Async.execute('INSERT INTO eLockers (id, name, date) VALUES (@id , @name, @date)', {
                            ['@id'] = id,
                            ['@name'] = fullname,
                            ['@date'] = os.date("%m/%d/%Y")
                        })
                    end
                end)
            end
        end)
    end
end)

RegisterServerEvent("eLockers:deleteCaseFile")
AddEventHandler("eLockers:deleteCaseFile", function(id)
    local src = source
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('DELETE FROM eLockers WHERE id = @id', {
        ['@id'] = id,
    }, function(rowschanged)
        MySQL.Async.fetchAll('SELECT * FROM disc_inventory WHERE owner = @owner', {
            ['@owner'] = "CASEFILE:"..id,
        }, function(result)
            if result[1] then
                MySQL.Async.execute('DELETE FROM disc_inventory WHERE owner = @owner', {
                    ['@owner'] = "CASEFILE:"..id,
                })
            end
        end)
    end)
end)

ESX.RegisterServerCallback('eLockers:checkLocker', function(source, cb, eLockerName)
    local player = ESX.GetPlayerFromId(source)
    if player then
        local sqlQuery = [[
            SELECT * FROM disc_inventory WHERE owner = @owner AND type = @type
        ]]
        MySQL.Async.fetchAll(sqlQuery, {
            ["@owner"] = eLockerName,
            ["@type"] = "eLocker"
        }, function(result)
            if result[1] then
                cb('true')
            else
                cb('false')
            end
        end)
    end
end)

ESX.RegisterServerCallback('eLockers:checkCaseFiles', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    if player then
        local sqlQuery = [[
            SELECT * FROM eLockers
        ]]
        MySQL.Async.fetchAll(sqlQuery, {
        }, function(result)
            if result[1] then
                cb(result)
            end
        end)
    end
end)