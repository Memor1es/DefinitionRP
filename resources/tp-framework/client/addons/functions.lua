ESX = nil
ESXLoaded = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end)

RegisterNetEvent("tp-framework:tpm")
AddEventHandler("tp-framework:tpm", function()
	local WaypointHandle = GetFirstBlipInfoId(8)
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
				break
			end
			Citizen.Wait(5)
		end
		ESX.ShowNotification("Teleported.")
	else
		ESX.ShowNotification("Please place your waypoint.")
	end
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

exports('Print', PrintTableOrString)




RegisterCommand('testcom', function(source, args, raw)
    local count = exports['tp-framework']:GetJobCount("police")
    exports['tp-framework']:Print(count)
end)


RegisterNetEvent('tp-framework:unmoneyroll')
AddEventHandler('tp-framework:unmoneyroll', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	exports["t0sic_loadingbar"]:StartDelayedFunction("Unrolling money...", 1500, function()
    end)
end)

RegisterNetEvent('tp-framework:moneyroll')
AddEventHandler('tp-framework:moneyroll', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	exports["t0sic_loadingbar"]:StartDelayedFunction("Rolling money", 1500, function()
    end)
end)

RegisterNetEvent('tp-framework:namechangetag')
AddEventHandler('tp-framework:namechangetag', function()
ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'First name change', {title = "Enter your new firstname."},
    function(data, menu)
        local firstname = string.gsub(data.value, "(%a)([%w_']*)", titleCase)
        menu.close()
        if firstname ~= nil then
            lastnamechange(firstname)
        end
    end,
    function(data, menu)
        menu.close()
        ESX.UI.Menu.CloseAll()
    end)
end)

function lastnamechange(firstname)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'Last name change', {title = "Enter your new lastname."},
    function(data2, menu2)
        local lastname = string.gsub(data2.value, "(%a)([%w_']*)", titleCase)
        menu2.close()   
        if lastname ~= nil then
            print(firstname,lastname)
            TriggerServerEvent('tp-framework:namechange', firstname, lastname)
        end
    end,
    function(data2, menu2)
        menu2.close()
        ESX.UI.Menu.CloseAll()
    end)
end

function titleCase( first, rest )
    return first:upper()..rest:lower()
end