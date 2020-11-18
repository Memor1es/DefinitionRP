local vehicleKeys = {}
local myVehicleKeys = {}

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
 ESX = obj
end)

local robbableItems = {
 [1] = {chance = 3, id = 0, name = 'Cash', quantity = math.random(1, 32)}, -- really common
 [2] = {chance = 6, id = 1, name = 'Keys', isWeapon = false}, -- rare
 [3] = {chance = 3, id = 'chips', name = 'Chips', quantity = 1}, -- really common
 [4] = {chance = 5, id = 'vicodin', name = 'Vicodin', quantity = 1}, -- rare
 [5] = {chance = 8, id = 'WEAPON_KNIFE', name = 'Knife', quantity = 1}, -- super rare
 [6] = {chance = 7, id = 'jumelles', name = 'Binoculars', quantity = 1}, -- rare
 [7] = {chance = 4, id = 'cigarett', name = 'Cigaretts', quantity = 10}, -- rare
 [8] = {chance = 9, id = 'highgrademaleseed', name = 'Male weed seed', quantity = 1}, -- rare rare
}

RegisterServerEvent('garage:searchItem')
AddEventHandler('garage:searchItem', function(plate)
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()

  item = robbableItems[math.random(1, #robbableItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 then
    xPlayer.addMoney(item.quantity)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You found $'..item.quantity, length = 7000})
   elseif item.isWeapon then
    xPlayer.addWeapon(item.id, 50)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Item Added!', length = 7000})
   elseif tonumber(item.id) == 1 then
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You have found the keys to the vehicle!', length = 7000})
    vehicleKeys[plate] = {}
    table.insert(vehicleKeys[plate], {id = ident})
    TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
    TriggerClientEvent('vehicle:start', source)
   else
    xPlayer.addInventoryItem(item.id, item.quantity)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Item Added!', length = 7000})
   end
  else
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You found nothing.', length = 7000})
  end
end)


RegisterServerEvent('garage:giveKey')
AddEventHandler('garage:giveKey', function(target, plate)
 local targetSource = tonumber(target)
 local xPlayer = ESX.GetPlayerFromId(targetSource)
 local ident = xPlayer.getIdentifier()
 local xPlayer2 = ESX.GetPlayerFromId(source)
 local ident2 = xPlayer2.getIdentifier()
 local plate = tostring(plate)

 vehicleKeys[plate] = {}
 table.insert(vehicleKeys[plate], {id = ident})
 TriggerClientEvent('mythic_notify:client:SendAlert', targetSource, { type = 'success', text = 'You just recieved keys to a vehicle', length = 7000})
 TriggerClientEvent('garage:updateKeys', targetSource, vehicleKeys, ident)
end)

RegisterServerEvent('garage:addKeys')
AddEventHandler('garage:addKeys', function(plate)
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()

 if vehicleKeys[plate] ~= nil then
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 else
  vehicleKeys[plate] = {}
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 end
end)

RegisterCommand("allkeys",function(source, args)
	local source = source
  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier,
  }, function(result)
    for i=1, #result, 1 do
    TriggerEvent('garage:addKeysManually', source, result[i].plate)
    end
  end)
end)

RegisterServerEvent('garage:addKeysManually')
AddEventHandler('garage:addKeysManually', function(source, plate)
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()

 if vehicleKeys[plate] ~= nil then
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 else
  vehicleKeys[plate] = {}
  table.insert(vehicleKeys[plate], {id = ident})
  TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
 end
end)


RegisterServerEvent('garage:removeKeys')
AddEventHandler('garage:removeKeys', function(plate)
 local source = tonumber(source)
 local xPlayer = ESX.GetPlayerFromId(source)
 local ident = xPlayer.getIdentifier()
 if vehicleKeys[plate] ~= nil then
  for id,v in pairs(vehicleKeys[plate]) do
   if v.id == ident then
    table.remove(vehicleKeys[plate], id)
   end
  end
 end
 TriggerClientEvent('garage:updateKeys', source, vehicleKeys, ident)
end)

RegisterServerEvent('removelockpick')
AddEventHandler('removelockpick', function()
  local source = tonumber(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if math.random(1, 20) == 1 then
    xPlayer.removeInventoryItem("lockpick", 1)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'The lockpick bent out of shape.', length = 7000})
  end
end)


ESX.RegisterUsableItem('lockpick', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  TriggerClientEvent('lockpickingsomething', source)
end)

 ----- STORM WARNING CRAP
Citizen.CreateThread(function()
  while true do
      Wait(60000)
      local date = os.date("*t", os.time())
      if date.hour == 2 and date.min == 55 or date.hour == 10 and date.min == 55 or date.hour == 18 and date.min == 55 then
          --TriggerClientEvent('InteractSound_CL:PlayOnOne', -1, 'sirenrestart', 0.1)
          Citizen.Wait(10000)
          TriggerEvent("tp:restarting")
          print('SERVER: Restarting in 10 minutes!') 
      end
  end
end)