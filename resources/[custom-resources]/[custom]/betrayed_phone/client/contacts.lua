local TablaSMSs = {}
local TablaContactos = {}
local NumerosActivosClient = {}
local phoneNotifications = true
local EstoyOculto = false

function Mute()
  return phoneNotifications
end

function phoneMsg(inputText)
  exports['mythic_notify']:DoHudText('inform', inputText)
end

function ResetContacts()
  TablaContactos = {}
  SendNUIMessage({
        emptyContacts = true
  })
end

function getContactName(number)
  if (#TablaContactos ~= 0) then
    for k,v in pairs(TablaContactos) do
      if v ~= nil then
        if (v.number ~= nil and (v.number) == (number)) then
          return v.name
        end
      end
    end
  end

  return number
end

function EstaAgendado(number)
  if (#TablaContactos ~= 0) then
    for k,v in pairs(TablaContactos) do
      if v ~= nil then
        if (v.number ~= nil and (v.number) == (number)) then
          return true
        end
      end
    end
  end

  return false
end

RegisterNetEvent("betrayed_phone:NumerosActivos")
AddEventHandler("betrayed_phone:NumerosActivos", function(NumerosActivos)
  ResetContacts()
  if GuiEnabled() then
   TriggerServerEvent('betrayed_phone:obtenerContactos')
  end
  NumerosActivosClient = NumerosActivos
end)

RegisterNetEvent('betrayed_phone:cargarContactos')
AddEventHandler('betrayed_phone:cargarContactos', function(contactos)

  ResetContacts()
  local sort_func = function( a,b ) return string.sub(a.name, 1, 1) < string.sub(b.name, 1, 1) end
  table.sort( contactos, sort_func )

  if (#contactos ~= 0) then
    for k,v in pairs(contactos) do
      if v ~= nil then
        local contacto = {
        }
        if NumerosActivosClient[v.number] then
        
          contacto = {
            name = v.name,
            number = v.number,
            activated = 1
          }
        else
    
          contacto = {
            name = v.name,
            number = v.number,
            activated = 0
          }
        end
		
        table.insert(TablaContactos, contacto)
        SendNUIMessage({
          newContact = true,
          contact = contacto,
        })
      end
    end
  else
       SendNUIMessage({
        emptyContacts = true
      })
  end
end)

RegisterNetEvent('betrayed_phone:agregarContacto')
AddEventHandler('betrayed_phone:agregarContacto', function(name, number)
  if(name ~= nil and number ~= nil) then
    TriggerServerEvent('betrayed_phone:agregarContacto', name, number)
  else
     phoneMsg("You have to put name and number!")
  end
end)

RegisterNetEvent('betrayed_phone:nuevoContacto')
AddEventHandler('betrayed_phone:nuevoContacto', function(name, number)

  phoneMsg("Saved contact!")
  TriggerServerEvent('betrayed_phone:obtenerContactos')
  --TriggerServerEvent('betrayed_phone:obtenerSMSc')
end)

RegisterNetEvent('betrayed_phone:borrarContacto')
AddEventHandler('betrayed_phone:borrarContacto', function(name, number)

  
  TriggerServerEvent('betrayed_phone:obtenerContactos')
  --TriggerServerEvent('betrayed_phone:obtenerSMSc')
end)

RegisterNetEvent('phone:deleteSMS')
AddEventHandler('phone:deleteSMS', function(id)
  table.remove( TablaSMSs, tablefindKeyVal(TablaSMSs, 'id', tonumber(id)))
  phoneMsg("Message Removed!")
end)

RegisterNetEvent('phone:loadSMSOther')
AddEventHandler('phone:loadSMSOther', function(messages,mynumber)
  openGui()
  TablaSMSs = {}
  if (#messages ~= 0) then
    for k,v in pairs(messages) do
      if v ~= nil then
        local ireceived = false
        if v.receiver == mynumber then
          ireceived = true
        end
        local message = {
          id = tonumber(v.id),
          name = getContactName(v.sender),
          sender = tonumber(v.sender),
          receiver = tonumber(v.receiver),
          recipient = ireceived,
          date = tonumber(v.date),
          message = v.message,
          gps = v.gps 
        }
        table.insert(TablaSMSs, message)
      end
    end
  end
  SendNUIMessage({openSection = "messagesOther", list = TablaSMSs})
end)




RegisterNetEvent('betrayed_phone:nuevoSMS')
AddEventHandler('betrayed_phone:nuevoSMS', function(msj, recip)
  local message = msj
  table.insert(TablaSMSs, message)

  SendNUIMessage({
    newSMS = true,
    sms = message,
  })

  if recip and hasPhone() then 

    if not GuiEnabled() then
      SendNUIMessage({
          openSection = "newsms"
      }) 
    end
    
    if phoneNotifications then
      TriggerEvent("DoLongHudText","You just received a new SMS.",16)
      PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
    end
  end
  --TriggerServerEvent('betrayed_phone:obtenerSMSc')
end)

RegisterNUICallback('btnMute', function()
  if phoneNotifications then
	exports['mythic_notify']:DoHudText('inform', "Notifications Off!")
  else
    exports['mythic_notify']:DoHudText('inform', "Notifications Activated!")
  end
  phoneNotifications = not phoneNotifications
end)

RegisterNUICallback('btnOculto', function()
  if EstoyOculto then
	exports['mythic_notify']:DoHudText('inform', "Now all your contacts can see you online!")
	TriggerServerEvent('betrayed_phone:oculto',true)
	EstoyOculto = false
  else
    exports['mythic_notify']:DoHudText('inform', "Now you will be seen as disconnected to all your contacts!")
	TriggerServerEvent('betrayed_phone:oculto',false)
	EstoyOculto = true
  end
end)

-- SMS Events
RegisterNetEvent('betrayed_phone:cargarSMS')
AddEventHandler('betrayed_phone:cargarSMS', function(messages,mynumber)

  TablaSMSs = {}
  if (#messages ~= 0) then
    for k,v in pairs(messages) do
      if v ~= nil then
        local message = {
          id = tonumber(v.id),
          name = v.name,
          sender = (v.sender),
          receiver = (v.receiver),
          recipient = v.recipient,
          date = v.date,
          message = v.message,
          gps = v.gps 
        }
        table.insert(TablaSMSs, message)
      end
    end
  end
  SendNUIMessage({openSection = "messages", list = TablaSMSs})
end)

RegisterNetEvent('betrayed_phone:cargarSMSbg')
AddEventHandler('betrayed_phone:cargarSMSbg', function(messages,mynumber)

  TablaSMSs = {}
  if (#messages ~= 0) then
    for k,v in pairs(messages) do
      if v ~= nil then
        local message = {
          id = tonumber(v.id),
          name = v.name,
          sender = (v.sender),
          receiver = (v.receiver),
          recipient = v.recipient,
          date = v.date,
          message = v.message,
          gps = v.gps 
        }
        table.insert(TablaSMSs, message)
      end
    end
  end
  SendNUIMessage({openSection = "updateMessages", list = TablaSMSs})
end)

local llamadosServicios = {}

RegisterNetEvent('betrayed_phone:confirmaAsist')
AddEventHandler('betrayed_phone:confirmaAsist', function(trabajo)
  if llamadosServicios[config.servicios[trabajo]] then
    llamadosServicios[config.servicios[trabajo]] = false
    exports['mythic_notify']:PersistentHudText('END', config.servicios[trabajo])
    exports['mythic_notify']:DoLongHudText('success', 'A '..config.servicios[trabajo]..' is attending your call, please wait here!')
  end
end)

RegisterNetEvent('betrayed_phone:enviarSMS')
AddEventHandler('betrayed_phone:enviarSMS', function(number, message,gps)
  if(number ~= nil and message ~= nil) then
    if tablefind(config.servicios,number) then
      if not llamadosServicios[number] then
        llamadosServicios[number] = true
        local texto = "Called | "..message
        if number == "Police" then
          texto = "911 | "..message
        end
        local coords = GetEntityCoords(GetPlayerPed(-1))
        exports['mythic_notify']:PersistentHudText('START', number,'inform', "Service | Awaiting response from a "..number.." <img src='https://thumbs.gfycat.com/UnitedSmartBinturong-max-1mb.gif' width='12' height='12'>", { ['background-color'] = '#6587C1', ['color'] = '#ffffff' })
        print(tablefind(config.servicios,number))
        TriggerServerEvent('MF_Trackables:NotifyAll',texto,coords,tablefind(config.servicios,number),true,GetPlayerServerId(PlayerId()))
        Citizen.Wait(180000)
        llamadosServicios[number] = false
        exports['mythic_notify']:PersistentHudText('END', number)
      else
        exports['mythic_notify']:DoHudText('error', 'You already called this service, please wait!')
      end
    else
      if gps then
        TriggerServerEvent('betrayed_phone:enviarSMS', number, message,GetEntityCoords(GetPlayerPed(-1)))
      else
        TriggerServerEvent('betrayed_phone:enviarSMS', number, message,false)
      end
      TriggerEvent("InteractSound_CL:PlayOnOne","sendsms",0.5)
      TriggerEvent("DoLongHudText","Message sent.",16)
    end
  else
    phoneMsg("You must put number and message!")
  end
end)

RegisterNUICallback('contacts', function(data, cb)

  if (#TablaSMSs == 0) then

    TriggerServerEvent('betrayed_phone:obtenerSMSc')

  end
  
  if (#TablaContactos == 0) then
	
	TriggerServerEvent('betrayed_phone:obtenerContactos')
	
  end

  SendNUIMessage({openSection = "contacts"})
  cb('ok')
end)

RegisterNUICallback('newContact', function(data, cb)
  SendNUIMessage({openSection = "newContact"})
  cb('ok')
end)

RegisterNUICallback('newContactSubmit', function(data, cb)
  TriggerEvent('betrayed_phone:agregarContacto', data.name, data.number)
  cb('ok')
end)

RegisterNUICallback('removeContact', function(data, cb)
  TriggerServerEvent('betrayed_phone:removerContacto', data.name, data.number)
  cb('ok')
end)

RegisterNUICallback('messages', function(data, cb)
  loading()
  if (#TablaSMSs == 0) then
    TriggerServerEvent('betrayed_phone:obtenerSMS')
  else
    SendNUIMessage({openSection = "messages", list = TablaSMSs})
  end
  cb('ok')
end)

RegisterNUICallback('messageRead', function(data, cb)

  SendNUIMessage({openSection = "messageRead", list = TablaSMSs, senderN = data.number,agendado = EstaAgendado(data.number)})

  cb('ok')
end)

function abrirultimochat(numero)
  SendNUIMessage({openSection = "messageRead", list = TablaSMSs, senderN = numero,agendado = EstaAgendado(numero)})
end

RegisterNUICallback('messageDelete', function(data, cb)
  TriggerServerEvent('phone:removeSMS', data.id, data.number)
  cb('ok')
end)

RegisterNUICallback('newMessage', function(data, cb)
  SendNUIMessage({openSection = "newMessage"})
  cb('ok')
end)

RegisterNUICallback('messageReply', function(data, cb)
  SendNUIMessage({openSection = "newMessageReply", number = data.number})
  cb('ok')
end)

RegisterNUICallback('newMessageSubmit', function(data, cb)
  if not exports["ambulancejob"]:GetDeath() then
    TriggerEvent('betrayed_phone:enviarSMS', data.number, data.message, data.gps)
    cb('ok')
  else
    TriggerEvent("DoLongHudText","You can't do this hurt.",2)
  end
end)

RegisterNUICallback('marcarUbicacion', function(data, cb)
  exports['mythic_notify']:DoHudText('inform', "You marked a location on your GPS")
  SetNewWaypoint(tonumber(data.coords.x), tonumber(data.coords.y))
end)

RegisterNUICallback('borrarChat', function(data, cb)
  TriggerServerEvent('betrayed_phone:borrarChat',data.number)
end)