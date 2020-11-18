local hasOpened = false
local recentopen = false
local guiEnabled = false
local curNotifications = {}
local minumero = nil
local fondoURL = 'nui://betrayed_phone/html/fondo.jpg'

RegisterNetEvent("betrayed_phone:cargarFondo")
AddEventHandler("betrayed_phone:cargarFondo", function(url)
  fondoURL = url
end)

RegisterNetEvent("betrayed_phone:miNumero")
AddEventHandler("betrayed_phone:miNumero", function(num)
  minumero = num
end)

function openGuiNow()

  if hasPhone() then
    
    GiveWeaponToPed(GetPlayerPed(-1), 0xA2719263, 0, 0, 1)
    guiEnabled = true
    SetNuiFocus(true)

	SendNUIMessage({openPhone = true, fondo = fondoURL, numero = minumero})

    TriggerEvent('phoneEnabled',true)
    TriggerEvent('animation:sms',true)

    if hasOpened == false then
      ResetContacts()
      TriggerServerEvent('betrayed_phone:obtenerContactos')
      hasOpened = true
    end
    doTimeUpdate()
  else
    closeGui()
    TriggerEvent("DoLongHudText","You don't have a phone.",2)
  end
  recentopen = false
end

function openGui()
  if recentopen then
    return
  end
  if hasPhone() then
    
    GiveWeaponToPed(GetPlayerPed(-1), 0xA2719263, 0, 0, 1)
    guiEnabled = true
    SetNuiFocus(true)
	SendNUIMessage({openPhone = true, fondo = fondoURL, numero = minumero})
    TriggerEvent('phoneEnabled',true)
    TriggerEvent('animation:sms',true)

    if hasOpened == false then
	  ResetContacts()
      TriggerServerEvent('betrayed_phone:obtenerContactos')
      hasOpened = true
    end
    doTimeUpdate()
  else
    closeGui()
    closeGui()
    TriggerEvent("DoLongHudText","You don't have a phone.",2)
  end
  Citizen.Wait(2000)
  recentopen = false
end

function closeGui()
  SetNuiFocus(false,false)
  SendNUIMessage({openPhone = false})
  guiEnabled = false
  TriggerEvent('animation:sms',false)
  TriggerEvent('phoneEnabled',false)
  recentopen = true
  Citizen.Wait(2000)
  recentopen = false
  insideDelivers = false
end

function closeGui2()
  SetNuiFocus(false)
  SendNUIMessage({openPhone = false})
  guiEnabled = false
  recentopen = true
  Citizen.Wait(2000)
  recentopen = false  
end

RegisterNetEvent('phone:addnotification')
AddEventHandler('phone:addnotification', function(name,message)
    if not guiEnabled then
      SendNUIMessage({
          openSection = "newemail"
      }) 
    end 
    curNotifications[#curNotifications+1] = { ["name"] = name, ["message"] = message }
end)

RegisterNUICallback('notifications', function()

    lstnotifications = {}

    for i = 1, #curNotifications do

        local message2 = {
          id = tonumber(i),
          name = curNotifications[tonumber(i)].name,
          message = curNotifications[tonumber(i)].message
        }

        table.insert(lstnotifications, message2)
    end

    
  SendNUIMessage({openSection = "notifications", list = lstnotifications})

end)

function refreshmail()
    lstnotifications = {}
    for i = 1, #curNotifications do

        local message2 = {
          id = tonumber(i),
          name = curNotifications[tonumber(i)].name,
          message = curNotifications[tonumber(i)].message
        }
        table.insert(lstnotifications, message2)
    end
    SendNUIMessage({openSection = "notifications", list = lstnotifications})
end

RegisterNetEvent('betrayed_phone:abrir')
AddEventHandler('betrayed_phone:abrir', function()
  openGui()
end)

RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNetEvent('phone:close')
AddEventHandler('phone:close', function(number, message)
  closeGui()
end)

function GuiEnabled()
  return guiEnabled
end