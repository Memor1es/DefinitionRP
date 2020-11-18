-- StarBlazt Chat

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		PlayerData = ESX.GetPlayerData()
	end
end)


RegisterCommand('911', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local source = GetPlayerServerId(PlayerId())
    local name = GetPlayerName(PlayerId())
    local caller = GetPlayerServerId(PlayerId())
    local msg = rawCommand:sub(4)
    local playerCoords = GetEntityCoords(PlayerPedId())
    streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    streetName = GetStreetNameFromHashKey(streetName)
    if exports["disc-inventoryhud"]:hasEnoughOfItem('phone', 1) then
        TriggerServerEvent('chat:server:911source', source, caller, msg)
        TriggerServerEvent('911', source, {
            x = ESX.Math.Round(playerCoords.x, 1),
            y = ESX.Math.Round(playerCoords.y, 1),
            z = ESX.Math.Round(playerCoords.z, 1)
        }, caller, msg, streetName, emergency)

        local dict = "cellphone@"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'cellphone_call_listen_base', 3) then
            TaskPlayAnim(playerPed, dict, "cellphone_call_listen_base", 2.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            TriggerEvent("attachItemPhone","phone01")
        end
        
        Wait(5000)

        ClearPedTasks(playerPed)
        TriggerEvent("destroyPropPhone")
    else
        exports['mythic_notify']:SendAlert('error', 'You don\'t have a phone.' , 10000)
    end
end, false)

RegisterCommand('311', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local source = GetPlayerServerId(PlayerId())
    local name = GetPlayerName(PlayerId())
    local caller = GetPlayerServerId(PlayerId())
    local msg = rawCommand:sub(4)
    local playerCoords = GetEntityCoords(PlayerPedId())
    streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
    streetName = GetStreetNameFromHashKey(streetName)
    if exports["disc-inventoryhud"]:hasEnoughOfItem('phone', 1) then
        TriggerServerEvent('chat:server:311source', source, caller, msg)
        TriggerServerEvent('311', source, {
            x = ESX.Math.Round(playerCoords.x, 1),
            y = ESX.Math.Round(playerCoords.y, 1),
            z = ESX.Math.Round(playerCoords.z, 1)
        }, caller, msg, streetName, emergency)

        local dict = "cellphone@"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'cellphone_call_listen_base', 3) then
            TaskPlayAnim(playerPed, dict, "cellphone_call_listen_base", 2.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            TriggerEvent("attachItemPhone","phone01")
        end
        
        Wait(5000)

        ClearPedTasks(playerPed)
        TriggerEvent("destroyPropPhone")
    else
        exports['mythic_notify']:SendAlert('error', 'You don\'t have a phone.' , 10000)
    end
end, false)


RegisterNetEvent('chat:EmergencySend911r')
AddEventHandler('chat:EmergencySend911r', function(fal, caller, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message emergency">911r {0} ({1}): {2} </div>',
        args = {caller, fal, msg}
        });
    end
end)

RegisterNetEvent('chat:EmergencySend311r')
AddEventHandler('chat:EmergencySend311r', function(fal, caller, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
        template = '<div class="chat-message nonemergency">311r {0} ({1}): {2} </div>',
        args = {caller, fal, msg}
        });
    end
end)

RegisterNetEvent('chat:EmergencySend911')
AddEventHandler('chat:EmergencySend911', function(fal, caller, streetName, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message emergency">911 | {0} ({1}) | Location: {2} - {3} </div>',
            args = { fal, caller, streetName, msg }
        });
    end
end)

RegisterNetEvent('chat:EmergencySend311')
AddEventHandler('chat:EmergencySend311', function(fal, caller, streetName, msg)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        TriggerEvent('chat:addMessage', {
            template = '<div class="chat-message emergency">311 | {0} ({1}) | Location: {2} - {3} </div>',
            args = { fal, caller, streetName, msg }
        });
    end
end)

RegisterCommand('911r', function(target, args, rawCommand)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        local playerPed = PlayerPedId()
        local source = GetPlayerServerId(PlayerId())
        local target = tonumber(args[1])
        local msg = rawCommand:sub(8)
        TriggerServerEvent(('chat:server:911r'), target, source, msg)
        TriggerServerEvent('911r', target, source, msg)

        local dict = "cellphone@"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'cellphone_call_listen_base', 3) then
            TaskPlayAnim(playerPed, dict, "cellphone_call_listen_base", 2.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            TriggerEvent("attachItemPhone","phone01")
        end
        
        Wait(5000)

        ClearPedTasks(playerPed)
        TriggerEvent("destroyPropPhone")
    end
end, false)

RegisterCommand('311r', function(target, args, rawCommand)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        local playerPed = PlayerPedId()
        local source = GetPlayerServerId(PlayerId())
        local target = tonumber(args[1])
        local msg = rawCommand:sub(8)
        TriggerServerEvent(('chat:server:311r'), target, source, msg)
        TriggerServerEvent('311r', target, source, msg)

        local dict = "cellphone@"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'cellphone_call_listen_base', 3) then
            TaskPlayAnim(playerPed, dict, "cellphone_call_listen_base", 2.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            TriggerEvent("attachItemPhone","phone01")
        end
        
        Wait(5000)

        ClearPedTasks(playerPed)
        TriggerEvent("destroyPropPhone")
    end
end, false)

RegisterNetEvent('marker:911Marker')
AddEventHandler('marker:911Marker', function(targetCoords)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        local alpha = 250
        local call = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite (call, 480)
		SetBlipDisplay(call, 4)
		SetBlipScale  (call, 1.5)
        SetBlipAsShortRange(call, true)
        SetBlipAlpha(call, alpha)

        SetBlipHighDetail(call, true)
		SetBlipAsShortRange(call, true)

        SetBlipColour (call, 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('911 Call')
        EndTextCommandSetBlipName(call)

		while alpha ~= 0 do
			Citizen.Wait(100 * 4)
			alpha = alpha - 1
			SetBlipAlpha(call, alpha)

			if alpha == 0 then
				RemoveBlip(call)
				return
			end
        end
    end
end)

RegisterNetEvent('marker:311Marker')
AddEventHandler('marker:311Marker', function(targetCoords, type)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then
        local alpha = 300
        local call = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite (call, 480)
		SetBlipDisplay(call, 4)
		SetBlipScale  (call, 1.5)
        SetBlipAsShortRange(call, true)
        SetBlipAlpha(call, alpha)

        SetBlipHighDetail(call, true)
		SetBlipAsShortRange(call, true)

        SetBlipColour (call, 64)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('311 Call')
        EndTextCommandSetBlipName(call)

		while alpha ~= 0 do
			Citizen.Wait(100 * 4)
			alpha = alpha - 1
			SetBlipAlpha(call, alpha)

			if alpha == 0 then
				RemoveBlip(call)
				return
			end
        end
    end
end)