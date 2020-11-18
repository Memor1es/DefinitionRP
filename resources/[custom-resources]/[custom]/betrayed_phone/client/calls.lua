local inPhone = false
local onhold = false
local PhoneBooth = GetEntityCoords(GetPlayerPed(-1))
local AnonCall = false
local dead = false
local TokoVoipID = nil

local recentcalls = {}

RegisterNUICallback('btnPhoneNumber', function()
      SendNUIMessage({
        openSection = "calls"
      })
  for i = 1, #recentcalls do
      SendNUIMessage({
        openSection = "addcall",
        typecall = recentcalls[i]["type"],
        phonenumber = recentcalls[i]["number"],
        contactname = recentcalls[i]["name"],
      })
  end
end)

--call status 0 = no call, 1 = dialing, 2 = receiving call, 3 = in progresss
myID = 0
mySourceID = 0

mySourceHoldStatus = false
callStatus = 0
costCount = 1

function Llamado()
  return callStatus
end

Citizen.CreateThread(function()
  local focus = true
  while true do
    local guiEnabled = GuiEnabled()
    if guiEnabled then
      SendNUIMessage({openSection = "callStatus", status = callStatus})
      DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
      DisableControlAction(0, 2, guiEnabled) -- LookUpDown
      DisableControlAction(0, 14, guiEnabled) -- INPUT_WEAPON_WHEEL_NEXT
      DisableControlAction(0, 15, guiEnabled) -- INPUT_WEAPON_WHEEL_PREV
      DisableControlAction(0, 16, guiEnabled) -- INPUT_SELECT_NEXT_WEAPON
      DisableControlAction(0, 17, guiEnabled) -- INPUT_SELECT_PREV_WEAPON
      DisableControlAction(0, 99, guiEnabled) -- INPUT_VEH_SELECT_NEXT_WEAPON
      DisableControlAction(0, 100, guiEnabled) -- INPUT_VEH_SELECT_PREV_WEAPON
      DisableControlAction(0, 115, guiEnabled) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      DisableControlAction(0, 116, guiEnabled) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
      DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate
      DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    else
    end

    Citizen.Wait(1)
  end
end)

RegisterNUICallback('btnAnswer', function()
    closeGui()
    TriggerEvent("betrayed_phone:answercall")
end)
RegisterNUICallback('btnHangup', function()
    closeGui()
    TriggerEvent("betrayed_phone:hangup")
end)

RegisterNUICallback('callContact', function(data, cb)
    closeGui()
    AnonCall = false
    if callStatus == 0 and not exports["ambulancejob"]:GetDeath() and hasPhone() then
      callStatus = 1
      TriggerEvent("betrayed_phone:iniciarLlamadaLoop")
      TriggerServerEvent('betrayed_phone:llamarContacto', data.number, true)
    else
      TriggerEvent("DoLongHudText","It seems that you are in a call, I inherit the phone, scribe /h to restore your calls.",2)
    end
    cb('ok')
end)

RegisterNUICallback('callNumber', function(data)
    closeGui()
    local number = data.callnum
    if callStatus == 0 and not exports["ambulancejob"]:GetDeath() and hasPhone() then
      callStatus = 1
      TriggerEvent("betrayed_phone:iniciarLlamadaLoop")
      TriggerServerEvent('betrayed_phone:llamarContacto', data.number, true)
    else
      TriggerEvent("DoLongHudText","It seems that you are in a call, I inherit the phone, scribe /h to restore your calls.",2)
    end
    TriggerServerEvent("betrayed_phone:llamarContacto",number,true)
end)

-------- /llamar ??
RegisterNetEvent('betrayed_phone:comandoLlamar')
AddEventHandler('betrayed_phone:comandoLlamar', function(pnumber)
  AnonCall = false
  if callStatus == 0 and not exports["ambulancejob"]:GetDeath() and hasPhone() then
    callStatus = 1
    TriggerEvent("betrayed_phone:iniciarLlamadaLoop")
    recentcalls[#recentcalls + 1] = { ["type"] = 2, ["number"] = pnumber, ["name"] = getContactName(pnumber) }
    TriggerServerEvent('betrayed_phone:llamarContacto', pnumber, true)
  else
    TriggerEvent("DoLongHudText","It seems that you are in a call, I inherit the phone, scribe /h to restore your calls.",2)
  end
end)

---- loop llamadas
RegisterNetEvent('betrayed_phone:iniciarLlamadaLoop')
AddEventHandler('betrayed_phone:iniciarLlamadaLoop', function()
  local lPed = GetPlayerPed(-1)
  RequestAnimDict("cellphone@")
  while not HasAnimDictLoaded("cellphone@") do
    Citizen.Wait(0)
  end
  local count = 0
  costCount = 1
  inPhone = false
  Citizen.Wait(200)
  ClearPedTasks(lPed)
  
  TriggerEvent("attachItemPhone","phone01")

  TriggerEvent("DoLongHudText", "[E] Call waiting.",10)

  --print("Call Information: Status" .. callStatus .. " SourceID" .. mySourceID .. " MyID" .. myID)

  if mySourceHoldStatus then
    print("The other person left you waiting")
  else
    print("The other person is not waiting")
  end

  while callStatus ~= 0 do

    local dead = exports["ambulancejob"]:GetDeath()
    if dead then
      print("I finish the call because I'm dead?")
      endCall()
    end


    if IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_call_listen_base", 3) and not IsPedRagdoll(GetPlayerPed(-1)) then
      --ClearPedSecondaryTask(lPed)
    else 



      if IsPedRagdoll(GetPlayerPed(-1)) then
        Citizen.Wait(1000)
      end
      TaskPlayAnim(lPed, "cellphone@", "cellphone_call_listen_base", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
    end
    Citizen.Wait(1)
    count = count + 1

    if AnonCall then
       local dPB = GetDistanceBetweenCoords(PhoneBooth, GetEntityCoords( GetPlayerPed(-1) ), true)
       if dPB > 2.0 then
        TriggerEvent("DoLongHudText", "You walked too far away.",10)
        print("I finish the call because I walked too far away?")
        endCall()
       end
    end



    if IsControlJustPressed(0, 38) then
      TriggerEvent("betrayed_phone:holdToggle")
    end

    if onhold then
      if count == 800 then
         count = 0
         TriggerEvent("DoLongHudText", "Call waiting.",10)
      end
    end

      --check if not unarmed
    local curw = GetSelectedPedWeapon(GetPlayerPed(-1))
    noweapon = GetHashKey("WEAPON_UNARMED")
    if noweapon ~= curw then
      SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
    end

  end
  ClearPedTasks(lPed)
  TaskPlayAnim(lPed, "cellphone@", "cellphone_call_out", 2.0, 2.0, 800, 49, 0, 0, 0, 0)
  Citizen.Wait(700)
  TriggerEvent("destroyPropPhone")
end)

---------------- TEXT LOOP --------------------
RegisterNetEvent('betrayed_phone:callactive')
AddEventHandler('betrayed_phone:callactive', function()
    Citizen.Wait(100)
    local held1 = false
    local held2 = false
    while callStatus == 3 do
      local phoneString = ""
      Citizen.Wait(1)

      if onhold then
        phoneString = phoneString .. "Is on hold | "
        if not held1 then
          TriggerEvent("DoLongHudText","You have put the call on hold.",888)
          held1 = true
        end
      else
        phoneString = phoneString .. "Active call | "
        if held1 then
          TriggerEvent("DoLongHudText","Your call is no longer on hold.",888)
          held1 = false
        end
      end

      if mySourceHoldStatus then
        phoneString = phoneString .. "You are waiting"
        if not held2 then
          TriggerEvent("DoLongHudText","They left you on hold.",2)
          held2 = true
        end
      else
        phoneString = phoneString .. "Active call"
        if held2 then
          TriggerEvent("DoLongHudText","You are no longer waiting.",2)
          held2 = false
        end
      end
      drawTxt(0.97, 1.46, 1.0,1.0,0.33, phoneString, 255, 255, 255, 255)  -- INT: kmh
    end
end)

RegisterNetEvent('betrayed_phone:failedCall')
AddEventHandler('betrayed_phone:failedCall', function()
    t("The call failed")
    endCall()
end)

RegisterNetEvent('betrayed_phone:hangup')
AddEventHandler('betrayed_phone:hangup', function(AnonCall)
    TriggerEvent("DoLongHudText","You hung up!",10)
    callTimer = 0
    if AnonCall then
      t("Hang up anonymous call")
      endCall2()
    else
      t("End call")
      endCall()
    end
end)

RegisterNetEvent('betrayed_phone:hangupcall')
AddEventHandler('betrayed_phone:hangupcall', function()
    TriggerEvent("DoLongHudText","You hung up!",10)
    callTimer = 0
    if AnonCall then
      t("Hang up anonymous call")
      endCall2()
    else
      t("End call")
      endCall()
    end
end)
RegisterNetEvent('betrayed_phone:cortarLlamadoOtro')
AddEventHandler('betrayed_phone:cortarLlamadoOtro', function()
    TriggerEvent("DoLongHudText","Your call is over!",2)
    myID = 0
    mySourceID = 0

    mySourceHoldStatus = false
    callStatus = 0
    onhold = false
    exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
    TokoVoipID = nil
end)


RegisterNetEvent('betrayed_phone:answercall')
AddEventHandler('betrayed_phone:answercall', function()
  if callStatus == 2 and not exports["ambulancejob"]:GetDeath() then
    answerCall()
    TriggerEvent("betrayed_phone:iniciarLlamadaLoop")
    TriggerEvent("DoLongHudText","You have answered a call.",1)
    callTimer = 0
  else
    TriggerEvent("DoLongHudText","They are not calling you, you are injuring or it took too long.",2)
  end
end)

RegisterNetEvent('betrayed_phone:intentoLlamar')
AddEventHandler('betrayed_phone:intentoLlamar', function(srcID,sentSource)
    TriggerEvent("DoLongHudText","You have started a call.",1)
    myID = srcID
    mySourceID = sentSource
    initiatingCall()
    if not AnonCall then
      --TriggerEvent("InteractSound_CL:PlayOnOne","demo",0.1)
    end
end)

RegisterNetEvent('betrayed_phone:InicioLlamado')
AddEventHandler('betrayed_phone:InicioLlamado', function(srcID,sentSource)
  myID = srcID
  mySourceID = sentSource
  callStatus = 3
  callTimer = 0
    exports.tokovoip_script:addPlayerToRadio(srcID + 120)
    TokoVoipID = srcID + 120

  TriggerEvent("betrayed_phone:callactive")
end)


RegisterNetEvent('betrayed_phone:reciboLlamado')
AddEventHandler('betrayed_phone:reciboLlamado', function(srcID, calledNumber)
  local callFrom = getContactName(calledNumber)
  recentcalls[#recentcalls + 1] = { ["type"] = 1, ["number"] = calledNumber, ["name"] = callFrom }

  if callStatus == 0 then
    myID = 0
    mySourceID = srcID
    callStatus = 2    

    receivingCall(callFrom) -- Send contact name if exists, if not send number
  else
    TriggerEvent("DoLongHudText",'You are receiving a call from ' .. callFrom .. ' but you are currently in one, sending "occupied".',2)
  end
end)


RegisterNetEvent('betrayed_phone:holdToggle')
AddEventHandler('betrayed_phone:holdToggle', function()
  if myID == nil then
    myID = 0
  end
  if myID ~= 0 then
    if not onhold then
      TriggerEvent("DoLongHudText", "Call waiting.",10)
      onhold = true
      exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
      TriggerServerEvent("betrayed_phone:ponerEnEspera",mySourceID,true)
    else
      TriggerEvent("DoLongHudText", "It is no longer on hold.",10)
      TriggerServerEvent("betrayed_phone:ponerEnEspera",mySourceID,false)
      onhold = false
      exports.tokovoip_script:addPlayerToRadio(TokoVoipID)
    end
  else

    if mySourceID ~= 0 then
      if not onhold then
        TriggerEvent("DoLongHudText", "Call waiting.",10)
        onhold = true
        exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
        TriggerServerEvent("betrayed_phone:ponerEnEspera",mySourceID,true)
      else
        TriggerEvent("DoLongHudText", "Is no longer on hold.",10)
        TriggerServerEvent("betrayed_phone:ponerEnEspera",mySourceID,false)
        onhold = false
        exports.tokovoip_script:addPlayerToRadio(TokoVoipID)
      end
    end
  end
end)


RegisterNetEvent('OnHold:Client')
AddEventHandler('OnHold:Client', function(newHoldStatus)
    mySourceHoldStatus = newHoldStatus
    if mySourceHoldStatus then
        exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
        TriggerEvent("DoLongHudText","They just put you on hold.")
    else
        if not onhold then
            exports.tokovoip_script:addPlayerToRadio(TokoVoipID)
        end
        TriggerEvent("DoLongHudText","Your call is back on the line.")
    end
end)


------------------- FUNCIONES -----------------------

callTimer = 0
function initiatingCall()
  callTimer = 8

  TriggerEvent("DoLongHudText","You are making a call, wait.",1)
  while (callTimer > 0 and callStatus == 1) do
    if Mute() then
      if AnonCall and callTimer < 7 then
        TriggerEvent("InteractSound_CL:PlayOnOne","payphoneringing",0.5)
      elseif not AnonCall then
        TriggerEvent("InteractSound_CL:PlayOnOne","llamando",0.5)
      end
    else
      exports['mythic_notify']:DoShortHudText('inform', 'You have the phone on silent')
    end
    
    Citizen.Wait(2500)
    callTimer = callTimer - 1
  end
  if callStatus == 1 or callTimer == 0 then
    endCall()
  end
end

function receivingCall(callFrom)
  callTimer = 8

  while (callTimer > 0 and callStatus == 2) do
    if hasPhone() then
      TriggerEvent("DoLongHudText","Call from: " .. callFrom .. " /a | /h",10)
      if Mute() then
        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'recibeLlamada', 0.5)
      end
    end
    Citizen.Wait(3000)
    callTimer = callTimer - 1
  end
  if callStatus ~= 3 then
    endCall()
  end
end

function answerCall()
    if mySourceID ~= 0 then
      exports.tokovoip_script:addPlayerToRadio(mySourceID + 120)
	  TokoVoipID = mySourceID + 120
      local playerId = GetPlayerFromServerId(mySourceID)
      TriggerServerEvent("betrayed_phone:ContestoLlamado",mySourceID)
      callStatus = 3
      TriggerEvent("betrayed_phone:callactive")
    end
end

function endCall()
  callTimer = 0
  TriggerEvent("InteractSound_CL:PlayOnOne","demo",0.0)
  if mySourceID ~= 0 then
    TriggerServerEvent("betrayed_phone:cortarLlamado",mySourceID)
  end 
  myID = 0
  mySourceID = 0
  callStatus = 0
  onhold = false
  mySourceHoldStatus = false
  AnonCall = false
  exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
  TokoVoipID = nil
  SendNUIMessage({openSection = "callStatus", status = callStatus})
end

function endCall2()
  callTimer = 0
  --TriggerEvent("InteractSound_CL:PlayOnOne","payphoneend",0.1)
  if mySourceID ~= 0 then
    TriggerServerEvent("betrayed_phone:cortarLlamado",mySourceID)
  end
  myID = 0
  mySourceID = 0
  callStatus = 0
  onhold = false
  mySourceHoldStatus = false
  AnonCall = false
  exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
  TokoVoipID = nil
  SendNUIMessage({openSection = "callStatus", status = callStatus})
end


  -------------------- llamar desde un telefono publico ----------------------

local PayPhoneHex = {
    [1] = 1158960338,
    [2] = -78626473,
    [3] = 1281992692,
    [4] = -1058868155,
    [5] = -429560270,
    [6] = -2103798695,
    [7] = 295857659,
  }
  
  function checkForPayPhone()
    for i = 1, #PayPhoneHex do
      local objFound = GetClosestObjectOfType( GetEntityCoords(GetPlayerPed(-1)), 5.0, PayPhoneHex[i], 0, 0, 0)
      if DoesEntityExist(objFound) then
        return true
      end
    end
    return false
  end
  

  RegisterNetEvent('betrayed_phone:makepayphonecall')
  AddEventHandler('betrayed_phone:makepayphonecall', function(pnumber)
  
      if not checkForPayPhone() then
        TriggerEvent("DoLongHudText","You are not near a payphone.",2)
        return
      end
  
      PhoneBooth = GetEntityCoords( GetPlayerPed(-1) )
      AnonCall = true
  
      if callStatus == 0 and not exports["ambulancejob"]:GetDeath() and hasPhone() then
        callStatus = 1
        TriggerEvent("betrayed_phone:iniciarLlamadaLoop")
        TriggerEvent("InteractSound_CL:PlayOnOne","payphonestart",0.5)
        TriggerServerEvent('betrayed_phone:llamarContacto', pnumber, false)
      else
        TriggerEvent("DoLongHudText","It seems that you are already on a call, injured or without a phone, write /colgar to restore your calls.",2)
      end
  
  end)
  
  
  function t(trace)
    print(trace)
  end