local instalando = false
local AppStoreApps = config.apps

RegisterNetEvent("betrayed_phone:cargarApps")
AddEventHandler("betrayed_phone:cargarApps", function(apps)
	for c,v in pairs(apps) do
		if config.apps[c].data.disponible then
			AppStoreApps[c].data = v.data
		end
		AppStoreApps[c].codigo = v.codigo
	end
	ActualizaApps()
end)

					
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
		if instalando then
			local descargaactiva
			for c,v in pairs(AppStoreApps) do
				if v.data.descargando then
					descargaactiva = true
					if v.data.contador > 0 then
						v.data.contador = v.data.contador - 1
					else
						exports['mythic_notify']:PersistentHudText('END', c)
						v.data.descargando = false
						v.data.bajada = true
						SendNUIMessage({
							resetappstore = true,
						})
						TriggerServerEvent('betrayed_phone:actualizaApps', AppStoreApps)
						ActualizaApps()
					end
				end
			end
			if not descargaactiva then
				instalando = false
			end
		end
	end
end)

RegisterNUICallback('instalarApp', function(data, cb)
	if not puedeinstalar(data.id) then return; end
	exports['mythic_notify']:PersistentHudText('START', data.id,'inform', "App Store | Installing "..AppStoreApps[data.id].nombre.." <img src='https://thumbs.gfycat.com/UnitedSmartBinturong-max-1mb.gif' width='12' height='12'>", { ['background-color'] = '#00ACFB', ['color'] = '#ffffff' })
	AppStoreApps[data.id].data.descargando = true
	AppStoreApps[data.id].data.contador = 20
	instalando = true
	SendNUIMessage({
		resetappstore = true,
	})
	ActualizaApps()
end)

RegisterNUICallback('desinstalarApp', function(data, cb)
	exports['mythic_notify']:DoHudText('inform', 'Uninstalling '..AppStoreApps[data.id].nombre)
	AppStoreApps[data.id].data.descargando = true
	AppStoreApps[data.id].data.contador = 4
	SendNUIMessage({
		resetappstore = true,
	})
	ActualizaApps()
	Citizen.CreateThread(function() 
		Citizen.Wait(5000)
		AppStoreApps[data.id].data.descargando = false
		AppStoreApps[data.id].data.bajada = false
		SendNUIMessage({
			resetappstore = true,
		})
		TriggerServerEvent('betrayed_phone:actualizaApps', AppStoreApps)
		ActualizaApps()
	end)
end)

RegisterNUICallback('btnAppStore', function(data, cb)
	ActualizaApps()
end)

function appInstalada(app)
	return AppStoreApps[app].data.bajada
end

function puedeinstalar(id)
	-- disponible para descargar
	if AppStoreApps[id].data.disponible == false then
		exports['mythic_notify']:DoHudText('error', 'This app is not available to download')
		return false
	end
	-- cantidad instalando
	local cantinstall = 0
	for c,v in pairs(AppStoreApps) do
		if v.data.descargando then
			cantinstall = cantinstall + 1
		end
	end
	if cantinstall >= 2 then
		exports['mythic_notify']:DoHudText('error', 'Wait for other Apps to install')
		return false
	else
		return true
	end
end

function ActualizaApps()
	local descarga = false
	local sort_func = function( a,b ) return a.bName < b.bName end
  	table.sort( AppStoreApps, sort_func )
	for c,v in pairs(AppStoreApps) do
		if v.codigo.necesario == false then
			SendNUIMessage({
			newApp = true,
				app = {
				id = c,
				location = v.nombre,
				install = v.data.bajada,
				descargando = v.data.descargando
				},
			})
			if v.data.descargando then
				descarga = true
			end
		end
	end
	SendNUIMessage({
		descargando = descarga,
	  })
end
