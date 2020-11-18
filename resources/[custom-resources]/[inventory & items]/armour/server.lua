ESX = nil
local cooldowns = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('armour', function(source)
	local _src = source
	if cooldowns[_src] == nil then
	  local xPlayer = ESX.GetPlayerFromId(_src)
	  xPlayer.removeInventoryItem('armour', 1)
	  TriggerClientEvent('esx_armour:armour:light', _src)
	else
		TriggerClientEvent('DRP:Armour:ErrorCooldown', _src)
	end
end)

RegisterServerEvent('DRP:Armour:StartCooldown')
AddEventHandler('DRP:Armour:StartCooldown', function()
	local _src = source
	cooldowns[_src] = true
	Citizen.SetTimeout(180000, function() -- 3 minutes
		cooldowns[_src] = nil
	end)
end)

-- Doing cooldowns server side to prevent client manipulation
ESX.RegisterServerCallback('DRP:Armor:CheckCooldown', function(source, cb, data)
	local _src = source
	if cooldowns[_src] == nil then
		cb(false)
	else
		cb(true)
	end
end)