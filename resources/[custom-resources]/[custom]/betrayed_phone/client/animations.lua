local phoneProp = 0
local phoneModel = GetHashKey("prop_amb_phone")
-- OR "prop_npc_phone"
-- OR "prop_npc_phone_02"
-- OR "prop_cs_phone_01"

RegisterNetEvent('attachItemPhone')
AddEventHandler('attachItemPhone', function(tipo)
    if tipo == "tablet01" then
        phoneModel = GetHashKey("prop_cs_tablet")
    else
        phoneModel = GetHashKey("prop_amb_phone")
    end
    deletePhone()
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Citizen.Wait(1)
	end
	phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
	AttachEntityToEntity(phoneProp, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end)

RegisterNetEvent('destroyPropPhone')
AddEventHandler('destroyPropPhone', function(enable)
    deletePhone()
end)

function deletePhone ()
	if phoneProp ~= 0 then
		Citizen.InvokeNative(0xAE3CBE5BF394C9C9 , Citizen.PointerValueIntInitialized(phoneProp))
		phoneProp = 0
	end
end


-- read -- cellphone_text_read_base
-- texting -- cellphone_swipe_screen
-- phone away -- cellphone_text_out

RegisterNetEvent('animation:sms')
AddEventHandler('animation:sms', function(enable,llamar)
  local lPed = GetPlayerPed(-1)
  inPhone = enable

  RequestAnimDict("cellphone@")
  while not HasAnimDictLoaded("cellphone@") do
    Citizen.Wait(0)
  end
  
  if Llamado() ~= 0 then return; end
  local intrunk = false
  if not intrunk then
    TaskPlayAnim(lPed, "cellphone@", "cellphone_text_in", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  end
  Citizen.Wait(300)
  if inPhone then
    TriggerEvent("attachItemPhone","phone01")
    Citizen.Wait(150)
    while inPhone do

      local dead = false
      if dead then
        closeGui()
        inPhone = false
      end
      local intrunk = false
      if not intrunk and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_text_read_base", 3) and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_swipe_screen", 3) then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      end    
      Citizen.Wait(1)
      if Llamado() ~= 0 then break; end
    end
    local intrunk = false
    if not intrunk then
      ClearPedTasks(GetPlayerPed(-1))
    end
  else
    if llamar then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_read_base", 2.0, 1.0, 5.0, 49, 0, 0, 0, 0)
    else
        local intrunk = false
        if not intrunk then
        Citizen.Wait(100)
        ClearPedTasks(GetPlayerPed(-1))
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_out", 2.0, 1.0, 5.0, 49, 0, 0, 0, 0)
        Citizen.Wait(400)
        TriggerEvent("destroyPropPhone")
        Citizen.Wait(400)
        ClearPedTasks(GetPlayerPed(-1))
        else
        TriggerEvent("destroyPropPhone")
        end
    end
  end
end)

