--====================================================================================
--  Inicio script
--====================================================================================


ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local NumerosActivos = {}
local TweetsActuales = {}
local PaginasAmarillas = {}

AddEventHandler('onServerResourceStart', function(resName)
	if resName == "betrayed_phone" then
		TweetsActuales = obtenerTweets()
	end
end)

AddEventHandler('es:playerLoaded',function(source)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
		NumerosActivos[myPhoneNumber] = true
		TriggerClientEvent("betrayed_phone:NumerosActivos", -1, NumerosActivos)
		TriggerClientEvent("betrayed_phone:cargarContactos", sourcePlayer, obtenerContactos(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:cargarSMS", sourcePlayer, obtenerSMS(myPhoneNumber),myPhoneNumber)
		TriggerClientEvent("betrayed_phone:cargarGaleria", sourcePlayer, obtenerGaleria(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:cargarFondo", sourcePlayer, obtenerFondo(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:cargarApps", sourcePlayer, obtenerApps(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:miNumero", sourcePlayer, myPhoneNumber)
		TriggerClientEvent("betrayed_phone:userTwitter", sourcePlayer, obtenerUserTwitter(identifier))
		TriggerClientEvent("betrayed_phone:actualizaTweets", sourcePlayer, TweetsActuales,true)
		TriggerClientEvent('betrayed_phone:listaAmarillas',sourcePlayer, PaginasAmarillas)
    end)
end)

-- Solo para restartear
RegisterServerEvent('betrayed_phone:restart')
AddEventHandler('betrayed_phone:restart', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
		NumerosActivos[myPhoneNumber] = true
		TriggerClientEvent("betrayed_phone:NumerosActivos", -1, NumerosActivos)
		TriggerClientEvent("betrayed_phone:cargarContactos", sourcePlayer, obtenerContactos(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:cargarSMS", sourcePlayer, obtenerSMS(myPhoneNumber),myPhoneNumber)
		TriggerClientEvent("betrayed_phone:cargarGaleria", sourcePlayer, obtenerGaleria(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:cargarFondo", sourcePlayer, obtenerFondo(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:cargarApps", sourcePlayer, obtenerApps(myPhoneNumber))
		TriggerClientEvent("betrayed_phone:miNumero", sourcePlayer, myPhoneNumber)
		TriggerClientEvent("betrayed_phone:userTwitter", sourcePlayer, obtenerUserTwitter(identifier))
		TriggerClientEvent("betrayed_phone:actualizaTweets", sourcePlayer, TweetsActuales,true)
		TriggerClientEvent('betrayed_phone:listaAmarillas',sourcePlayer, PaginasAmarillas)
    end)
end)

AddEventHandler('playerDropped', function()
	local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	NumerosActivos[num] = false
	TriggerClientEvent("betrayed_phone:NumerosActivos", -1, NumerosActivos)
end)

RegisterServerEvent('betrayed_phone:oculto')
AddEventHandler('betrayed_phone:oculto', function(val)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	NumerosActivos[num] = val
	TriggerClientEvent("betrayed_phone:NumerosActivos", -1, NumerosActivos)
end)
--====================================================================================
--  GENERAL - BASICO 
--====================================================================================

RegisterServerEvent('betrayed_phone:getUser')
AddEventHandler('betrayed_phone:getUser', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    TriggerClientEvent("betrayed_phone:userTwitter", sourcePlayer, obtenerUserTwitter(identifier))
end)

RegisterServerEvent('betrayed_phone:obtenerContactos')
AddEventHandler('betrayed_phone:obtenerContactos', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	local contactos = obtenerContactos(num)
	TriggerClientEvent("betrayed_phone:cargarContactos", sourcePlayer, contactos)
end)

RegisterServerEvent('betrayed_phone:agregarContacto')
AddEventHandler('betrayed_phone:agregarContacto', function(nombre,numero)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	local contactos = obtenerContactos(num)
	local contacto = {
      name = nombre,
      number = numero
	}
	table.insert(contactos,contacto)
	guardarContactos(num,contactos)
	TriggerClientEvent("betrayed_phone:nuevoContacto",sourcePlayer ,nombre, numero)
	local SMS = obtenerSMS(num)
	local encontrado = false
	print(numero)
	for c,v in pairs(SMS) do
		if v.receiver == numero  or v.sender == numero  then
			encontrado = true
			v.name = getContactName(numero,contactos)
		end
	end
	print(encontrado)
	if encontrado then
		guardarSMSs(num,SMS)
		TriggerClientEvent("betrayed_phone:cargarSMSbg", sourcePlayer, SMS,num)
	end
end)

RegisterServerEvent('betrayed_phone:removerContacto')
AddEventHandler('betrayed_phone:removerContacto', function(nombre,numero)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	local contactos = obtenerContactos(num)
	local contacto = {
      name = nombre,
      number = numero
	}
	table.remove( contactos, tablefind(contactos, contacto))
	guardarContactos(num,contactos)
	TriggerClientEvent("betrayed_phone:borrarContacto",sourcePlayer ,nombre, numero)
	local SMS = obtenerSMS(num)
	local encontrado = false
	print(numero)
	for c,v in pairs(SMS) do
		if v.receiver == numero or v.sender == numero then
			encontrado = true
			v.name = getContactName(numero,contactos)
		end
	end
	print(encontrado)
	if encontrado then
		guardarSMSs(num,SMS)
		TriggerClientEvent("betrayed_phone:cargarSMSbg", sourcePlayer, SMS,num)
	end
end)

RegisterServerEvent('betrayed_phone:obtenerSMS')
AddEventHandler('betrayed_phone:obtenerSMS', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	local SMS = obtenerSMS(num)
	TriggerClientEvent("betrayed_phone:cargarSMS", sourcePlayer, SMS,num)
end)

RegisterServerEvent('betrayed_phone:obtenerSMSc')
AddEventHandler('betrayed_phone:obtenerSMSc', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	local SMS = obtenerSMS(num)
	TriggerClientEvent("betrayed_phone:cargarSMSbg", sourcePlayer, SMS,num)
end)

RegisterServerEvent('betrayed_phone:enviarSMS')
AddEventHandler('betrayed_phone:enviarSMS', function(numero,msj,gps)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
	local num = getNumberPhone(identifier)
	if numero == num then 
		TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'error', text = 'You cannot send messages to yourself', length = 2500})
		return
	end
    local otherIdentifier = getIdentifierByPhoneNumber(numero)
	local SMS = obtenerSMS(num)
	local SMS1 = obtenerSMS(numero)
	local contactos = obtenerContactos(num)
	local contactos1 = obtenerContactos(numero)
	local valgps = false
	if gps ~= false and gps ~= nil then
		valgps = ({["x"] = gps.x, ["y"] = gps.y,["z"] = gps.z}) 
	end
	local mensaje = {
      id = tonumber(#SMS + 1),
      name = getContactName(numero,contactos),
      sender = num,
      receiver = numero,
      recipient = false,
      date = os.date(),
	  message = msj,
	  gps = valgps
    }
	local mensaje1 = {
      id = tonumber(#SMS1 + 1),
      name = getContactName(num,contactos1),
      sender = num,
      receiver = numero,
      recipient = true,
      date = os.date(),
      message = msj,
	  gps = valgps
    }
	
	table.insert(SMS1,mensaje1)
	guardarSMSs(numero,SMS1)
	if numero ~= num then
		table.insert(SMS,mensaje)
		guardarSMSs(num,SMS)
		TriggerClientEvent("betrayed_phone:nuevoSMS", sourcePlayer, mensaje, false)
	end
	if otherIdentifier ~= nil then
		getSourceFromIdentifier(otherIdentifier, function (osou)
			if tonumber(osou) ~= nil then
				TriggerClientEvent("betrayed_phone:nuevoSMS", tonumber(osou), mensaje1, true)
			end
		end)
	end
end)

RegisterServerEvent('betrayed_phone:borrarChat')
AddEventHandler('betrayed_phone:borrarChat', function(numero)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	local SMS = obtenerSMS(num)
	repeat
		local encontrado = false
		for c,v in pairs(SMS) do
			if v.recipient then
				if v.sender == numero then
					encontrado = true
					table.remove(SMS,c)
				end
			else
				if v.receiver == numero then
					encontrado = true
					table.remove(SMS,c)
				end
			end
		end
	until encontrado == false
	for c,v in pairs(SMS) do
		v.id = tonumber(c)
	end
	guardarSMSs(num,SMS)
	TriggerClientEvent("betrayed_phone:cargarSMS", sourcePlayer, SMS,num)
end)

RegisterServerEvent('betrayed_phone:ActualizarGaleria')
AddEventHandler('betrayed_phone:ActualizarGaleria', function(galeria)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	guardarGaleria(num,galeria)
end)

RegisterServerEvent('betrayed_phone:actualizarURLFondo')
AddEventHandler('betrayed_phone:actualizarURLFondo', function(url)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	guardarFondo(num,url)
	TriggerClientEvent("betrayed_phone:cargarFondo", sourcePlayer, obtenerFondo(num))
end)

RegisterServerEvent('betrayed_phone:actualizaApps')
AddEventHandler('betrayed_phone:actualizaApps', function(apps)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	guardarApps(num,apps)
end)

RegisterServerEvent('betrayed_phone:twittear')
AddEventHandler('betrayed_phone:twittear', function(user,twt)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
	TweetsActuales[#TweetsActuales + 1] = { ["handle"] = user, ["message"] = twt}
	guardarTweets(TweetsActuales)
	TriggerClientEvent('betrayed_phone:actualizaTweets',-1, TweetsActuales)
end)

RegisterServerEvent('betrayed_phone:paginasAmarillas')
AddEventHandler('betrayed_phone:paginasAmarillas', function(txt)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
	local nombre = obtenerNombre(identifier)
	for c,v in pairs(PaginasAmarillas) do
		if v.steam == identifier then
			table.remove(PaginasAmarillas,c)
		end
	end
	table.insert(PaginasAmarillas,{ ["phonenumber"] = num, ["job"] = txt, ["name"] = nombre, ["steam"] = identifier})
	TriggerClientEvent('betrayed_phone:listaAmarillas',-1, PaginasAmarillas)
	TriggerClientEvent('betrayed_phone:actAmarillas',sourcePlayer)
end)

RegisterServerEvent('betrayed_phone:borrarAmarilla')
AddEventHandler('betrayed_phone:borrarAmarilla', function()
    local sourcePlayer = tonumber(source)
	local identifier = getPlayerID(source)
	for c,v in pairs(PaginasAmarillas) do
		if v.steam == identifier then
			table.remove(PaginasAmarillas,c)
		end
	end
	TriggerClientEvent('betrayed_phone:listaAmarillas',-1, PaginasAmarillas)
	TriggerClientEvent('betrayed_phone:actAmarillas',sourcePlayer)
end)

RegisterServerEvent('betrayed_phone:confirmaAsistencia')
AddEventHandler('betrayed_phone:confirmaAsistencia', function(playerid,trabajo)
	print("here")
	TriggerClientEvent('betrayed_phone:confirmaAsist',playerid, trabajo)
end)

RegisterServerEvent('tp:checkPhoneCount')
AddEventHandler('tp:checkPhoneCount', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('phone').count >= 1 then
		TriggerClientEvent('tp:heHasPhone', _source)
	else 
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You dont have a phone, Buy one at your local store', length = 7000})
	end
end)