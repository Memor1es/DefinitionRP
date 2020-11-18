ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

players = {}
scores = {
    ["Red"] = 0,
    ["Blue"] = 0
}
gameActive = false

AddEventHandler('esx:playerDropped', function(playerId, reason)
    print("player dropped")
    -- local _source = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

    local count = xPlayer.getInventoryItem('WEAPON_PISTOL50').count
    xPlayer.removeInventoryItem("WEAPON_PISTOL50", count)

    for k,v in pairs(players) do
        if players[k]["source"] == playerId then
            print("changed pos")
            table.remove(players, k)
            MySQL.Async.execute('UPDATE users SET position = @position WHERE identifier = @identifier', {
                ['@position']   = json.encode(Config.MenuCoords),
                ['@identifier'] = identifier
            })
            break
        end
    end
end)

RegisterCommand('printp', function(source, args, raw)
    exports['tp-framework']:Print(players)
end)

RegisterServerEvent('drp-paintballing:leave')
AddEventHandler('drp-paintballing:leave', function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local identifier = xPlayer.identifier

    local count = xPlayer.getInventoryItem('WEAPON_PISTOL50').count
    xPlayer.removeInventoryItem("WEAPON_PISTOL50", count)

    print("player left")
    for k,v in pairs(players) do
        if players[k]["source"] == _source then
            table.remove(players, k)
            break
        end
    end
end)

--[[ 
AddEventHandler('playerDropped', function()
	
end)
]]

RegisterServerEvent('drp-paintballing:joinTeam')
AddEventHandler('drp-paintballing:joinTeam', function()
    local _source = source
    local team = decideTeams()
    table.insert(players, {source = _source, team = team})
    TriggerClientEvent('drp-paintballing:giveTeam', _source, team)
    print("player added")
end)

RegisterServerEvent('drp-paintballing:kill')
AddEventHandler('drp-paintballing:kill', function(team)
    if team == "Blue" then
        scores["Blue"] = scores["Blue"] + 1
    else
        scores["Red"] = scores["Red"] + 1
    end
    TriggerClientEvent('drp-paintballing:updateScores', -1, scores)

    if scores["Red"] >= Config.MaxKills then
        resetGame("Red")
    elseif scores["Blue"] >= Config.MaxKills then
        resetGame("Blue")
    end
end)

RegisterServerEvent('drp-paintballing:giveWeapons')
AddEventHandler('drp-paintballing:giveWeapons', function()
    for k,v in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(players[k]["source"])
        -- xPlayer.addWeapon("WEAPON_PISTOL50", 500)
        xPlayer.addInventoryItem("WEAPON_PISTOL50", 1)
    end
end)

function resetGame(team)
    gameActive = false
    scores["Red"] = 0
    scores["Blue"] = 0

    for k,v in pairs(players) do
        local xPlayer = ESX.GetPlayerFromId(players[k]["source"])

        local count = xPlayer.getInventoryItem('WEAPON_PISTOL50').count
        xPlayer.removeInventoryItem("WEAPON_PISTOL50", count)
    end

    TriggerClientEvent('drp-paintballing:teamWin', -1, team)
end

function decideTeams()
    local red = 0
    local blue = 0
    for i=1, #players, 1 do
        if players[i].team == "Red" then
            red = red + 1
        elseif players[i].team == "Blue" then
            blue = blue + 1
        end
    end
    if (red < blue) then
        return "Red"
    else
        return "Blue"
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if gameActive == false then
            Citizen.Wait(1000)
            if #players >= 2 then
                TriggerClientEvent('drp-paintballing:startCountdown', -1)
                gameActive = true
            end
        end
    end
end)