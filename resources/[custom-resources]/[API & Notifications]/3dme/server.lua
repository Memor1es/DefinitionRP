local logEnabled = false
ESX = nil
performingSale = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			firstname = identity['firstname'],
			lastname = identity['lastname'],	
		}
	else
		return nil
	end
end

local logEnabled = true

function GetRPName(playerId, cb)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)
		cb("["..GetPlayerName(playerId).."] "..result[1].firstname.." "..result[1].lastname)
	end)
end

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	local _source = source
	print("3DME: " .. "["..source.."] - ".. text)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, _source)
	if logEnabled then
		setLog(text, source)
	end
end)

function setLog(text, source) 
	local time = os.date("%d/%m/%Y %X")
	GetRPName(source, function(name)
		local identifier = GetPlayerIdentifiers(source)
		local data = time .. ' : ' .. name .. ' - ' .. identifier[1] .. ' : ' .. text
	
		local content = LoadResourceFile(GetCurrentResourceName(), "log.txt")
		local newContent = content .. '\r\n' .. data
		SaveResourceFile(GetCurrentResourceName(), "log.txt", newContent, -1)
	end)
end