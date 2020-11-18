ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)

inGame = false
myTeam = nil
menuOpen = false
drawTimer = false
timer = Config.RestartTime
redScore = 0
blueScore = 0

Citizen.CreateThread(function()
    while true do
		local sleep = 1000
		local plyCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(plyCoords, Config.MenuCoords.x, Config.MenuCoords.y, Config.MenuCoords.z, true)
        if distance < 10.0 then
            sleep = 4
            DrawM("Press [E] for Paintballing", 27, Config.MenuCoords.x, Config.MenuCoords.y, Config.MenuCoords.z - 0.945, 255, 255, 255, 1.5, 15)
            if distance < 0.7 and menuOpen == false then
                if IsControlJustReleased(0, 38) then
                    drawJoinMenu()
                    menuOpen = true
                end
            elseif distance > 1.5 and menuOpen == true then
                ESX.UI.Menu.CloseAll()
                menuOpen = false
            end
        end
		Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
		local sleep = 1000
		local plyCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(plyCoords, Config.ExitPoint.x, Config.ExitPoint.y, Config.ExitPoint.z, true)
        if distance < 5.0 then
            sleep = 4
            DrawM("Press [E] to Leave", 27, Config.ExitPoint.x, Config.ExitPoint.y, Config.ExitPoint.z - 0.945, 255, 255, 255, 1.5, 15)
            if distance < 0.7 then
                if IsControlJustReleased(0, 38) then
                    exitPaintballing()
                end
            end
        end
		Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if drawTimer then
            DrawCountdown(timer)
        end
        if inGame then
            drawScores()
        end
    end
end)

function drawScores()
    SetTextColour(180, 180, 180, 180)
    SetTextFont(8)
    SetTextScale(1.2, 1.2)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(true)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(0, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString("Blue: " .. blueScore .. " | Red: "..redScore)
    DrawText(0.8, 0.15)
end

RegisterNetEvent('drp-paintballing:updateScores')
AddEventHandler('drp-paintballing:updateScores', function(scores)
    redScore = scores["Red"]
    blueScore = scores["Blue"]
end)

RegisterNetEvent('drp-paintballing:giveTeam')
AddEventHandler('drp-paintballing:giveTeam', function(team)
    myTeam = team
    SetEntityCoords(GetPlayerPed(-1), Config.CommonArea.x, Config.CommonArea.y, Config.CommonArea.z)
end)

RegisterNetEvent('drp-paintballing:startCountdown')
AddEventHandler('drp-paintballing:startCountdown', function()
    if myTeam ~= nil then
        showCountdown()
    end
end)

function exitPaintballing()
    SetEntityCoords(GetPlayerPed(-1), Config.MenuCoords.x, Config.MenuCoords.y, Config.MenuCoords.z)
    TriggerServerEvent('drp-paintballing:leave')
    myTeam = nil
    drawTimer = false
end

function showCountdown()
    if myTeam ~= nil then
        timer = Config.RestartTime
        drawTimer = true
        while timer > 0 do
            Citizen.Wait(1000)
            timer = timer - 1
        end
        drawTimer = false
        TriggerEvent('drp-paintballing:sendToTeamSpawn')
    end
end

RegisterNetEvent('drp-paintballing:sendToTeamSpawn')
AddEventHandler('drp-paintballing:sendToTeamSpawn', function()
    inGame = true
    TriggerServerEvent('drp-paintballing:giveWeapons')
    if myTeam == "Red" then
        SetEntityCoords(GetPlayerPed(-1), Config.RedStart.x, Config.RedStart.y, Config.RedStart.z)
    elseif myTeam == "Blue" then
        SetEntityCoords(GetPlayerPed(-1), Config.BlueStart.x, Config.BlueStart.y, Config.BlueStart.z)
    else -- no team gtfo
        SetEntityCoords(GetPlayerPed(-1), Config.MenuCoords.x, Config.MenuCoords.y, Config.MenuCoords.z)
    end
end)

RegisterNetEvent('drp-paintballing:teamWin')
AddEventHandler('drp-paintballing:teamWin', function(team)
    if inGame then
        print(team.." Team WON!")
        SetEntityCoords(GetPlayerPed(-1), Config.CommonArea.x, Config.CommonArea.y, Config.CommonArea.z)
        inGame = false
        blueScore = 0
        redScore = 0
    end
end)

function payEntryFee()
    TriggerServerEvent("drp-paintballing:joinTeam")
end

function drawJoinMenu()
    local menuElements = {}
    table.insert(menuElements, {
        ["label"] = "<span style='font-weight:bold;color:green;'>Pay Entry Fee $"..Config.Price.."</span>",
        ["action"] = "joingame"
    })
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_paintball_menu", {
        ["title"] = "LS Paintball Co",
        ["align"] = "bottom-right",
        ["elements"] = menuElements
    }, function(menuData, menuHandle)
        local currentAction = menuData["current"]["action"]

        if currentAction == "joingame" then
            menuHandle.close()
            payEntryFee()
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end, function(menuData, menuHandle)
        local currentAction = menuData["current"]["action"]
        -- Called when switching menu entries up and down
    end)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    if inGame then
        weapon = data.deathCause
        if IsPaintball(weapon) then
            respawn()
            if myTeam == "Red" then
                TriggerServerEvent('drp-paintballing:kill', "Blue")
            elseif myTeam == "Blue" then        
                TriggerServerEvent('drp-paintballing:kill', "Red")
            end
        else
            respawn()
        end
    end
end)

function respawn()
    print("Respawning")
    if myTeam == "Red" then
        Citizen.Wait(100)
        TriggerEvent('tp_ambulancejob:revive')
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        TriggerEvent('mythic_hospital:client:ResetLimbs')
        SetEntityCoords(GetPlayerPed(-1), Config.RedStart.x, Config.RedStart.y, Config.RedStart.z)
    elseif myTeam == "Blue" then
        Citizen.Wait(100)
        TriggerEvent('tp_ambulancejob:revive')
        TriggerEvent('mythic_hospital:client:RemoveBleed')
        TriggerEvent('mythic_hospital:client:ResetLimbs')
        SetEntityCoords(GetPlayerPed(-1), Config.BlueStart.x, Config.BlueStart.y, Config.BlueStart.z)
    else -- no team gtfo
        -- Teleport outside the building
    end
end

function IsPaintball(Weapon)
    if Weapon == GetHashKey('WEAPON_PISTOL50') then
        return true
    end
	return false
end



-- DRAW FUNCTIONS
function DrawM(hint, type, x, y, z)
	Draw3DText(x, y, z + 1.2, hint)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function DrawCountdown(text)
    SetTextColour(139, 0, 0, 180)
    SetTextFont(8)
    SetTextScale(1.2, 1.2)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(true)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(0, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.15)
    DrawRect(
        0.5, --X
        0.19, --Y
        0.1, --Width
        0.09, --Height
        0, --r
        0, --g
        0, --b
        150 --a
        )
end