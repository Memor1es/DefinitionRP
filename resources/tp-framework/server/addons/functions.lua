ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while ESX == nil do
		Wait(1)
	end
end)

TriggerEvent('es:addGroupCommand', 'tpm', 'admin', function(source, args, user)
	TriggerClientEvent("tp-framework:tpm", source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Admin: Teleport to marker"})

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

exports('Print', PrintTableOrString)

--[[ 
    Usage: 
        exports['tp-framework']:Print("something to print")
    or
        exports['tp-framework']:Print(tableValue)
]]

ESX.RegisterUsableItem('moneyroll', function(source)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent('tp-framework:unmoneyroll', _source)
    xPlayer.removeInventoryItem('moneyroll', 1)
    Wait(1500)
    xPlayer.addAccountMoney("black_money", 5000)
end)

RegisterCommand('rollmoney', function(source, args)
    if args[1] ~= nil and tonumber(args[1]) > 1 then
        amount = tonumber(args[1])
        rollmoney(source, amount)
    else
        amount = 1
        rollmoney(source, amount)
    end
end)

function rollmoney(source, amount)
    local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
    local bmacc = xPlayer.getAccount('black_money').money
    if bmacc >= (amount * 5000) then
        TriggerClientEvent('tp-framework:moneyroll', _source)
        xPlayer.removeAccountMoney("black_money", (amount*5000))
        Wait(1500)
        xPlayer.addInventoryItem('moneyroll', amount)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "You don't have enough dirty money!", length = 7500, style = { ['background-color'] = '#e43838', ['color'] = '#ffffff' } })
    end
end

RegisterServerEvent("tp-framework:namechange")
AddEventHandler("tp-framework:namechange", function(firstname, lastname)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = tostring(xPlayer.getIdentifier())
    if firstname ~= nil and lastname ~= nil then
        xPlayer.removeInventoryItem('namechangetag', 1)
        Wait(1000)
        DropPlayer(_source, "Please re-enter the city with your new registration.")
        Wait(1000)
        updatemdtname(firstname,lastname,identifier)
        Wait(1000)
        updateemsmdtname(firstname,lastname,identifier)
        Wait(1000)
        updateusername(firstname,lastname,identifier)
        Wait(1000)
        updatecharname(firstname,lastname,identifier)
    end
end)

function updatecharname(firstname, lastname, identifier)
    MySQL.Async.execute("UPDATE characters SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier", { 
        ['@identifier'] = identifier,
        ['@firstname'] = firstname,
        ['@lastname'] = lastname
    })
    print("Character table updated",firstname, lastname, identifier)
end

function updateusername(firstname, lastname, identifier)
    MySQL.Async.execute("UPDATE users SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier", { 
        ['@identifier'] = identifier,
        ['@firstname'] = firstname,
        ['@lastname'] = lastname
    })
    print("Users table updated",firstname, lastname, identifier)
end

function updatemdtname(firstname, lastname, identifier)
    local result = MySQL.Async.fetchAll("SELECT id FROM characters WHERE identifier = @identifier", { 
        ['@identifier'] = identifier,
    }, function(result)
        if result[1] then
            local charid = result[1].id
            local newname = firstname.." "..lastname
            if newname ~= nil then
                MySQL.Async.execute("UPDATE mdt_reports SET name = @name WHERE char_id = @char_id", { 
                    ['@char_id'] = charid,
                    ['@name'] = newname,
                })
                print("PD mdt name update",firstname, lastname, identifier)
            end
        end
    end)
end

function updateemsmdtname(firstname, lastname, identifier)
    local result1 = MySQL.Async.fetchAll("SELECT id FROM characters WHERE identifier = @identifier", { 
        ['@identifier'] = identifier,
    }, function(result1)
        if result1[1] then
            local charid = result1[1].id
            local newname = firstname.." "..lastname
            if newname ~= nil then
                MySQL.Async.execute("UPDATE mdt_reports_ems SET name = @name WHERE char_id = @char_id", { 
                    ['@char_id'] = charid,
                    ['@name'] = newname,
                })
                print("EMS mdt name update",firstname, lastname, identifier)
            end
        end
    end)
end

ESX.RegisterUsableItem('namechangetag', function(source)
    TriggerClientEvent('tp-framework:namechangetag',source)
end)