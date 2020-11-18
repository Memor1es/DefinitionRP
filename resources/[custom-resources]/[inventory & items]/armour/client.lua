ESX              = nil
local PlayerData = {}
local cooldown = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('DRP:Armour:ErrorCooldown')
AddEventHandler('DRP:Armour:ErrorCooldown', function()
  exports['mythic_notify']:SendAlert('error', 'Your too tired to put on more armor. please wait longer.', 5000)
end)


RegisterNetEvent('esx_armour:armour:light')
AddEventHandler('esx_armour:armour:light', function()
  -- Doing cooldowns server side to prevent client manipulation.
    ESX.TriggerServerCallback('DRP:Armor:CheckCooldown', function(onCooldown)
      if onCooldown then
        exports['mythic_notify']:SendAlert('error', 'Your too tired to put on more armor. please wait longer.', 5000)
      else
        exports['mythic_progbar']:Progress({
          name = "armour_put_on_action",
          duration = 20000,
          label = "Putting on Armour",
          useWhileDead = false,
          canCancel = false,
          controlDisables = {
              disableMovement = false,
              disableCarMovement = false,
              disableMouse = false,
              disableCombat = false,
          },
          animation = {
            animDict = "oddjobs@basejump@ig_15",
            anim = "puton_parachute",
            flags = 49,
            time = 2100,
          },
        }, function(status)
          if not status then
              TriggerServerEvent('DRP:Armour:StartCooldown')
              local playerPed = GetPlayerPed(-1)
              Citizen.CreateThread(function()
              SetPedArmour(playerPed, 100)
            end)
          end
        end)
      end
    end)
end)


-- We will register the command ready for when we introduce heavy armour

RegisterNetEvent('esx_armour:armour:heavy')
AddEventHandler('esx_armour:armour:heavy', function()
  -- Doing cooldowns server side to prevent client manipulation.
    ESX.TriggerServerCallback('DRP:Armor:CheckCooldown', function(onCooldown)
      if onCooldown then
        exports['mythic_notify']:SendAlert('error', 'Your too tired to put on more armor. please wait longer.', 5000)
      else
        exports['mythic_progbar']:Progress({
          name = "armour_put_on_action",
          duration = 20000,
          label = "Putting on Armour",
          useWhileDead = false,
          canCancel = false,
          controlDisables = {
              disableMovement = false,
              disableCarMovement = false,
              disableMouse = false,
              disableCombat = false,
          },
          animation = {
            animDict = "oddjobs@basejump@ig_15",
            anim = "puton_parachute",
            flags = 49,
            time = 2100,
          },
        }, function(status)
          if not status then
              TriggerServerEvent('DRP:Armour:StartCooldown')
              local playerPed = GetPlayerPed(-1)
              Citizen.CreateThread(function()
              SetPedArmour(playerPed, 100)
            end)
          end
        end)
      end
    end)
end)