local galeria = {}
local ultimochat = false

RegisterNetEvent("betrayed_phone:cargarGaleria")
AddEventHandler("betrayed_phone:cargarGaleria", function(gal)
  galeria = gal
end)

RegisterNUICallback('btnGaleria', function(data, cb)
	for c,v in pairs(galeria) do
		if c and c ~= false and v and v ~= false then
			SendNUIMessage({
			newFoto = true,
				foto = {
				  id = v,
				},
			  })
		end
	end
end)

RegisterNUICallback('abrirfoto', function(data, cb)
	if data.chat then
		ultimochat = data.chat
		SendNUIMessage({
			openSection = "fotogrande",
			foto = data.id,
			guardada = galeria[tablefind(galeria, data.id)],
			chat = data.chat,
		})
	else
		ultimochat = false
		SendNUIMessage({
			openSection = "fotogrande",
			foto = data.id,
			guardada = galeria[tablefind(galeria, data.id)],
		})
	end
end)

RegisterNUICallback('btnVChat', function(data, cb)
	if ultimochat ~= false then
		if ultimochat == "twitter" then
			AbrirTwitter()
		else
			abrirultimochat(ultimochat)
		end
	else
		for c,v in pairs(galeria) do
			if c and c ~= false and v and v ~= false then
				SendNUIMessage({
				newFoto = true,
					foto = {
					  id = v,
					},
				  })
			end
		end
	end
end)

RegisterNUICallback('copiarURL', function(data, cb)
	exports['mythic_notify']:DoHudText('inform', 'Copied link!')
end)

RegisterNUICallback('guardarfoto', function(data, cb)
	exports['mythic_notify']:DoHudText('inform', 'You saved the image in your gallery!')
	galeria[#galeria +1] = data.url
	TriggerServerEvent('betrayed_phone:ActualizarGaleria',galeria)
	if not data.chat then
		ultimochat = false
	end
	SendNUIMessage({
          openSection = "fotogrande",
		  foto = data.url,
		  guardada = galeria[tablefind(galeria, data.url)],
		  chat = ultimochat,
    });
end)

RegisterNUICallback('errorimg', function(data, cb)
	exports['mythic_notify']:DoHudText('error', 'The image does not work, try another!')
end)

RegisterNUICallback('BaseURLFondo', function(data, cb)
	TriggerServerEvent('betrayed_phone:actualizarURLFondo',tostring(data.fondo))
end)

RegisterNUICallback('actualizarURLFondo', function(data, cb)
	exports['mythic_notify']:DoHudText('success', 'You changed your wallpaper!')
	TriggerServerEvent('betrayed_phone:actualizarURLFondo',tostring(data.fondo))
end)

RegisterNUICallback('borrarfoto', function(data, cb)
	exports['mythic_notify']:DoHudText('inform', 'You deleted the image from your gallery!')
	table.remove(galeria,tablefind(galeria, data.url))
	TriggerServerEvent('betrayed_phone:ActualizarGaleria',galeria)
	if not data.chat then
		ultimochat = false
	end
	SendNUIMessage({
          openSection = "fotogrande",
		  foto = data.url,
		  guardada = galeria[tablefind(galeria, data.url)],
		  chat = ultimochat,
    });
end)

RegisterNUICallback('cerrarfoto', function(data, cb)
	TriggerEvent('betrayed_phone:abrir')
	if not data.chat then
		ultimochat = false
	end
	SendNUIMessage({
          openSection = "fotogrande",
		  foto = data.id,
		  guardada = galeria[tablefind(galeria, data.id)],
		  chat = ultimochat,
    })
end)

RegisterNUICallback('btnCamara', function(data, cb)
	local sacada = false
	CreateMobilePhone(1)
  CellCamActivate(true, true)
  takePhoto = true
  Citizen.Wait(0)
  if guiEnabled == true then
    SetNuiFocus(false, false)
    guiEnabled = false
  end
	while takePhoto do
    Citizen.Wait(0)

		if IsControlJustPressed(1, 27) then -- Toogle Mode
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
    elseif IsControlJustPressed(1, 177) then -- CANCEL
      DestroyMobilePhone()
      CellCamActivate(false, false)
      cb(json.encode({ url = nil }))
      takePhoto = false
      break
	elseif IsControlJustPressed(1, 176) and not sacada then -- TAKE.. PIC
		sacada = true
		if Mute() then
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'foto', 0.5)
		end
		----------------------------------------------------------------------------------------------------------------------------------------------------------
		-------------------------------- HERE YOU NEED TO PUT THE WEB TO UPLOAD YOUR PHOTOS, U CAN LOOK ON GCPHONE ONE -------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------
		exports['screenshot-basic']:requestScreenshotUpload('https://www.twitchparadise.com/images/up.php', 'files', function(data) --- example https://exiliadosrp.com/up.php
			local resp = data
			DestroyMobilePhone()
			CellCamActivate(false, false)
			TriggerEvent('betrayed_phone:abrir')
			SendNUIMessage({
			  openSection = "fotogrande",
			  foto = resp,
			  guardada = galeria[tablefind(galeria, resp)],
			})
		end)
		takePhoto = false
		end
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
		HideHudAndRadarThisFrame()
  end
  Citizen.Wait(1000)
 -- PhonePlayAnim('text', false, true)
end)

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end