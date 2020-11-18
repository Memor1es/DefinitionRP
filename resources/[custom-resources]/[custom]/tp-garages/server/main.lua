ESX = nil

local cachedData = {}

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)


ESX.RegisterServerCallback("betrayed_garage:obtenerVehiculos", function(source, callback, garage)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				plate, vehicle
			FROM
				owned_vehicles
			WHERE
				owner = @cid
		]]

		if garage then
			sqlQuery = [[
				SELECT
					plate, vehicle
				FROM
					owned_vehicles
				WHERE
					owner = @cid and garage = @garage
			]]
		end

		MySQL.Async.fetchAll(sqlQuery, {
			["@cid"] = player["identifier"],
			["@garage"] = garage
		}, function(responses)
			getPlayerVehiclesOut(player.identifier ,function(data)
				enviar = {responses,data}
				callback(enviar)
			end)
		end)
	else
		callback(false)
	end
end)

function getPlayerVehiclesOut(identifier,cb)
	local vehicles = {}
	local data = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = identifier})	
	cb(data)
end

ESX.RegisterServerCallback("betrayed_garage:validateVehicle", function(source, callback, vehicleProps, garage)
	local player = ESX.GetPlayerFromId(source)

	if player then
		local sqlQuery = [[
			SELECT
				owner
			FROM
				owned_vehicles
			WHERE
				plate = @plate
		]]

		MySQL.Async.fetchAll(sqlQuery, {
			["@plate"] = vehicleProps["plate"]
		}, function(responses)
			if responses[1] then
				callback(true)
			else
				callback(false)
			end
		end)
	else
		callback(false)
	end
end)

ESX.RegisterServerCallback('betrayed_garage:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local deudas = 0
	local result = MySQL.Sync.fetchAll('SELECT * FROM billing WHERE identifier = @identifier',{['@identifier'] = xPlayer.identifier})
	for i=1, #result, 1 do
		amount = result[i].amount
		deudas = deudas + amount
    end
    if deudas >= 2000 then
        cb("deudas")
        return
    end
	if xPlayer.get('money') >= 200 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('betrayed_garage:pay')
AddEventHandler('betrayed_garage:pay', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(200)
end)

RegisterServerEvent('betrayed_garage:modifystate')
AddEventHandler('betrayed_garage:modifystate', function(vehicleProps, state, garage,vehiclename)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local plate = vehicleProps.plate
	local vName = vehiclename

	if garage == nil then
		MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = "OUT" , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehiclename=@vehiclename WHERE plate=@plate",{['@vehiclename'] = vName , ['@plate'] = plate})
	else 

		MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = garage , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehiclename=@vehiclename WHERE plate=@plate",{['@vehiclename'] = vName , ['@plate'] = plate})

	end
end)

RegisterServerEvent('betrayed_garage:modifyHouse')
AddEventHandler('betrayed_garage:modifyHouse', function(vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local plate = vehicleProps.plate

	--MySQL.Sync.execute("UPDATE owned_vehicles SET garage=@garage WHERE plate=@plate",{['@garage'] = garage , ['@plate'] = plate})
	MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})

	
end)

RegisterServerEvent("betrayed_garage:sacarometer")
AddEventHandler("betrayed_garage:sacarometer", function(vehicle,state,src1)
	local src = source
	if src1 then
		src = src1
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	while xPlayer == nil do Citizen.Wait(1); end
	local plate = all_trim(vehicle)
	local state = state
	MySQL.Sync.execute("UPDATE owned_vehicles SET state =@state WHERE plate=@plate",{['@state'] = state , ['@plate'] = plate})
end)

function all_trim(s)
	return s:match( "^%s*(.-)%s*$" )
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
  end

 RegisterNetEvent("garages:CheckGarageForVeh")
AddEventHandler("garages:CheckGarageForVeh", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = identifier }, function(vehicles)
        MySQL.Async.fetchAll('SELECT * FROM impounded_vehicles WHERE owner = @identifier', {['@identifier'] = identifier}, function(impoundedvehicles)
            TriggerClientEvent('phone:Garage', src, vehicles, impoundedvehicles)
        end)
    end)
end)

TriggerEvent('es:addGroupCommand', 'fixcar', 'admin', function(source, args, user)
	local source = source
	local plate = ""
    if args[3] ~= nil then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Format must be XXXXXXX or XXXX XXXX'})
    elseif args[1] == nil then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You must type in a plate.'})
    elseif args[2] ~= nil then
        plate = args[1].." "..args[2]
		fixcar(source, plate)
    else
		plate = args[1]
        fixcar(source, plate)
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows fixing of car in database"})

function fixcar(source, plate)
local source = source
local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate',{
	['@plate'] = plate})
	if result[1] == nil then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No car found with plate '..plate, length = 7000})
	else
		vehicleProps = json.decode(result[1]["vehicle"])
		vehicleProps.windows = ""
		MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle=@vehicle WHERE plate=@plate",{['@vehicle'] = json.encode(vehicleProps) , ['@plate'] = plate})
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = 'Successfully fixed car with plate '..plate, length = 7000})
	end
end

TriggerEvent('es:addGroupCommand', 'updatecars', 'admin', function(source, args, raw)
	local src = source
	local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles',{
		})
		for i = 1, #result do
			if result[i].vehiclename == "voiture" then
				local vProps = json.decode(result[i].vehicle)
				local model = vProps.model
				local plate = result[i].plate
				Wait(1000)
				TriggerClientEvent('drp-garages:updateVehName', src, model, plate)
			end
		end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Allows fixing of car names in database"})

RegisterNetEvent("drp-garages:updateVehName")
AddEventHandler("drp-garages:updateVehName", function(modelName, plate)
	local src = source
    MySQL.Sync.execute("UPDATE owned_vehicles SET vehiclename =@vehiclename WHERE plate=@plate",{
		['@vehiclename'] = modelName,
		['@plate'] = plate
	})
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