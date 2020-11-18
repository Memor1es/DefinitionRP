local guiEnabled = false
local dead = false

AddEventHandler('onClientResourceStart', function(res)
  DoScreenFadeIn(300)
  if res == "betrayed_phone" then
      TriggerServerEvent('betrayed_phone:restart')
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsControlJustPressed(1, 288) then
      TriggerServerEvent("tp:checkPhoneCount")
    end
	end
end)

RegisterNetEvent('tp:heHasPhone')
AddEventHandler('tp:heHasPhone', function()
    GotPhone()
end)


function GotPhone()
  local dead = exports["ambulancejob"]:GetDeath()
      if not dead then
        ActualizaApps()
        TriggerEvent('betrayed_phone:abrir')
      else
        exports['mythic_notify']:DoHudText('inform', 'You cant do this unconscious')
      end
end


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
blip = 0

function CreateBlip(location)
    DeleteBlip()
    blip = AddBlipForCoord(location["x"],location["y"],location["z"])
    SetBlipSprite(blip, 514)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pick Up")
    EndTextCommandSetBlipName(blip)
end
function DeleteBlip()
  if DoesBlipExist(blip) then
    RemoveBlip(blip)
  end
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

local customGPSlocations = {
  [1] = { ["x"] = 484.77066040039, ["y"] = -77.643089294434, ["z"] = 77.600166320801, ["info"] = "Garage A"},
  [2] = { ["x"] = -331.96115112305, ["y"] = -781.52337646484, ["z"] = 33.964477539063,  ["info"] = "Garage B"},
  [3] = { ["x"] = -451.37295532227, ["y"] = -794.06591796875, ["z"] = 30.543809890747, ["info"] = "Garage C"},
  [4] = { ["x"] = 399.51190185547, ["y"] = -1346.2742919922, ["z"] = 31.121940612793, ["info"] = "Garage D"},
  [5] = { ["x"] = 598.77319335938, ["y"] = 90.707237243652, ["z"] = 92.829048156738, ["info"] = "Garage E"},
  [6] = { ["x"] = 641.53442382813, ["y"] = 205.42562866211, ["z"] = 97.186958312988, ["info"] = "Garage F"},
  [7] = { ["x"] = 82.359413146973, ["y"] = 6418.9575195313, ["z"] = 31.479639053345, ["info"] = "Garage G"},
  [8] = { ["x"] = -794.578125, ["y"] = -2020.8499755859, ["z"] = 8.9431390762329, ["info"] = "Garage H"},
  [9] = { ["x"] = -669.15631103516, ["y"] = -2001.7552490234, ["z"] = 7.5395741462708, ["info"] = "Garage I"},
  [10] = { ["x"] = -606.86322021484, ["y"] = -2236.7624511719, ["z"] = 6.0779848098755, ["info"] = "Garage J"},
  [11] = { ["x"] = -166.60482788086, ["y"] = -2143.9333496094, ["z"] = 16.839847564697, ["info"] = "Garage K"},
  [12] = { ["x"] = -38.922565460205, ["y"] = -2097.2663574219, ["z"] = 16.704851150513, ["info"] = "Garage L"},
  [13] = { ["x"] = -70.179389953613, ["y"] = -2004.4139404297, ["z"] = 18.016941070557, ["info"] = "Garage M"},
  [14] = { ["x"] = 549.47796630859, ["y"] = -55.197559356689, ["z"] = 71.069190979004, ["info"] = "Garage Impound Lot"},
  [15] = { ["x"] = 364.27685546875, ["y"] = 297.84490966797, ["z"] = 103.49515533447, ["info"] = "Garage O"},
  [16] = { ["x"] = -338.31619262695, ["y"] = 266.79782104492, ["z"] = 85.741966247559, ["info"] = "Garage P"},
  [17] = { ["x"] = 273.66683959961, ["y"] = -343.83737182617, ["z"] = 44.919876098633, ["info"] = "Garage Q"},
  [18] = { ["x"] = 66.215492248535, ["y"] = 13.700443267822, ["z"] = 69.047248840332, ["info"] = "Garage R"},
  [19] = { ["x"] = 3.3330917358398, ["y"] = -1680.7877197266, ["z"] = 29.170293807983, ["info"] = "Garage Imports"},
  [20] = { ["x"] = 286.67013549805, ["y"] = 79.613700866699, ["z"] = 94.362899780273, ["info"] = "Garage S"},
  [21] = { ["x"] = 211.79, ["y"] = -808.38, ["z"] = 30.833, ["info"] = "Garage T"},
  [22] = { ["x"] = 447.65, ["y"] = -1021.23, ["z"] = 28.45, ["info"] = "Garage Police Department"},
  [23] = { ["x"] = -25.59, ["y"] = -720.86, ["z"] = 32.22, ["info"] = "Garage House"},
}
local loadedGPS = false
RegisterNetEvent('openGPS')
AddEventHandler('openGPS', function(mansions,houses,rented)
  
  SendNUIMessage({openSection = "GPS"})
  if loadedGPS then
    return
  end
  for i = 1, #customGPSlocations do
    SendNUIMessage({openSection = "AddGPSLocation", info = customGPSlocations[i]["info"], house_id = i, house_type = 69})
    Citizen.Wait(1)
  end

  loadedGPS = true
end)


RegisterNetEvent('GPS:SetRoute')
AddEventHandler('GPS:SetRoute', function(house_id,house_model)
	
	local house_id = tonumber(house_id)
	local house_model = tonumber(house_model)

	if house_model == 1 then
		mygps = robberycoords[house_id]
		
	elseif house_model == 2 then
		
		mygps = robberycoordsMansions[house_id]
	elseif house_model == 3 then
		
		mygps = rentedOffices[house_id]["location"]
		mygps["info"] = rentedOffices[house_id]["name"]
	else
		mygps = customGPSlocations[house_id]
	end
	if GPSblip ~= nil then
		RemoveBlip(GPSblip)
	end
	GPSblip = AddBlipForCoord(mygps["x"],mygps["y"],mygps["z"])
	TriggerEvent("GPSActivated",true)
	SetBlipRoute(GPSblip, 1)
	SetBlipAsFriendly(GPSblip, 1)
	SetBlipColour(GPSblip, 6)
end)

RegisterNetEvent('GPSLocations')
AddEventHandler('GPSLocations', function()
	if GPSblip ~= nil then
		RemoveBlip(GPSblip)
		GPSblip = nil
	end	
	TriggerEvent("GPSActivated",false)
	TriggerEvent("openGPS",robberycoordsMansions,robberycoords,rentedOffices)
end)

RegisterNUICallback('loadUserGPS', function(data)
     TriggerEvent("GPS:SetRoute",data.house_id,data.house_type)
end)

RegisterNUICallback('btnCamera', function()
  SetNuiFocus(true,true)
end)

