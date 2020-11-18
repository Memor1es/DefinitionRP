---======================---
---Written by Tościk#9715---
---======================---
local payForLocation = 10 --<< ile kosztuje aktywacja misji (czystej z banku)
-----------------------------------
--[[ local MisjaAktywna = 0
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end) ]]
--[[ RegisterServerEvent('tp_gruppe:akceptujto')
AddEventHandler('tp_gruppe:akceptujto', function() ]]
--local copsOnDuty = 0
--local Players = ESX.GetPlayers()
--[[ local _source = source ]]
--local xPlayer = ESX.GetPlayerFromId(_source)
--local accountMoney = 0
--accountMoney = xPlayer.getAccount('bank').money

--[[ RegisterCom
	--[[ if MisjaAktywna == 0 then ]]
--if accountMoney < payForLocation then
--TriggerClientEvent('esx:showNotification', source, '~ r ~ You need $ 5,000 in the bank to accept the mission')
--else
--[[ 			TriggerEvent('tprp:GetJobCount', 'police', function(count)
				if (count >= neededPolice) then
					TriggerClientEvent("tp_gruppe:Pozwolwykonac", _source)
					OdpalTimer()
				else
					TriggerClientEvent('esx:showNotification', source, '~ r ~ You need at least ~ g ~'..neededPolice.. '~ r ~ LSPD to activate the mission.')
				end
			end) ]]
--[[
			for i = 1, #Players do
				local xPlayer = ESX.GetPlayerFromId(Players[i])
				if xPlayer["job"]["name"] == "police" then
				copsOnDuty = copsOnDuty + 1
				end
			end
			if copsOnDuty >= neededPolice then
				TriggerClientEvent("tp_gruppe:Pozwolwykonac", _source)
				xPlayer.removeAccountMoney('bank', payForLocation)
				OdpalTimer()
			else
				TriggerClientEvent('esx:showNotification', source, '~ r ~ You need at least ~ g ~'..neededPolice.. '~ r ~ LSPD to activate the mission.')
			end]]
--end
--[[ 	else
		TriggerClientEvent('esx:showNotification', source, '~ r ~ Someone is already doing this mission')
	end
end)

function OdpalTimer()
	MisjaAktywna = 1
	Wait(resetTimer)
	MisjaAktywna = 0
end

RegisterServerEvent('tp_gruppe:zawiadompsy')
AddEventHandler('tp_gruppe:zawiadompsy', function(x, y, z) 
    TriggerClientEvent('tp_gruppe:infodlalspd', -1, x, y, z)
end)

RegisterServerEvent('tp_gruppe:graczZrobilnapad')
AddEventHandler('tp_gruppe:graczZrobilnapad', function
			end
		end
    end)
end)

end)



RegisterNetEvent('tp_gruppe:removeC4')
AddEventHandler('tp_gruppe:removeC4', function()

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('c4', 1)

	exports['mythic_notify']:SendAlert('error', 'Removed 1x C4 from your inventory', 8000)
end) ]]
ESX = nil

TriggerEvent(
	"esx:getSharedObject",
	function(obj)
		ESX = obj
	end
)

Trucks = {}

TriggerEvent(
	"esx:getSharedObject",
	function(obj)
		ESX = obj
	end
)

ESX.RegisterUsableItem(
	"securityblack",
	function(source)
		TriggerClientEvent("tp:gruppeCard", source)
	end
)

RegisterServerEvent("tp:gruppeItem")
AddEventHandler(
	"tp:gruppeItem",
	function(item, amount)
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.addInventoryItem(item, amount)
		TriggerClientEvent("esx:showNotification", source, "You found an interesting item in the van!")
	end
)

RegisterServerEvent("tp:gruppe:addPlate")
AddEventHandler("tp:gruppe:addPlate", function(truckPlate)
		table.insert(Trucks, tostring(truckPlate))
end)

ESX.RegisterServerCallback("tp:gruppe:checkPlate", function(source, cb, plate)
	local truckFound = false
		for i = 1, #Trucks, 1 do
			if Trucks[i] == plate then
				truckFound = true
				cb(false) -- truck already robbed before
				break
			end
		end
		if truckFound == false then
			cb(true)
			return
		end
end)

--[[ ESX.RegisterServerCallback('tp:gruppe:checkPlate', function(source, cb, plate)
	print(#Trucks)
	if #Trucks == 0 then
		cb(true)
	else
		for _, value in pairs(Trucks) do
			if value == plate then
				cb(false) -- truck already robbed before
				print("false")
			end
		end
	end
end) ]]


RegisterServerEvent("tp_gruppe:SendPlayerToPd")
AddEventHandler(
	"tp_gruppe:SendPlayerToPd",
	function(x, y, z)
		TriggerClientEvent("tp_gruppe:informPD", -1, x, y, z)
	end
)

RegisterServerEvent("tp:removeIDcard")
AddEventHandler(
	"tp:removeIDcard",
	function()
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem("securityblack", 1)
	end
)

RegisterServerEvent("tp_gruppe:gimmethadirtycash")
AddEventHandler("tp_gruppe:gimmethadirtycash", function(amount)
	local _source = source
	if amount > 6000 then
		TriggerEvent('banCheater', _source, "Using a LUA injector! (False bans are not possible) Triggered Event: tp_gruppe:gimmethadirtycash with amount of"..amount)
	else
		local xPlayer = ESX.GetPlayerFromId(_source)
		local amount = amount
		xPlayer.addAccountMoney("black_money", amount)
		TriggerClientEvent("esx:showNotification", source, "You're taking ~g~$" .. amount .. " ~w~from the van")
	end
end)