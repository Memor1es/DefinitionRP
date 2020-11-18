function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d-%04d", numBase0, numBase1 )
	return num
end

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end

function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
			local data = getDataByPhoneNumber(myPhoneNumber)
        until (id == nil and data == nil)
        MySQL.Async.insert("UPDATE users SET phone_number = @myPhoneNumber WHERE identifier = @identifier", { 
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
			MySQL.Async.execute('INSERT INTO betrayed_phone (`numero`,`contactos`,`mensajes`,`galeria`,`apps`) VALUES (@numero,@contactos,@mensajes,@galeria,@apps)',
			{['@numero'] = myPhoneNumber,
			['@contactos'] = json.encode({}),
			['@mensajes'] = json.encode({}),
            ['@galeria'] = json.encode({}),
            ['@apps'] = json.encode({}),},function ()
				cb(myPhoneNumber)
			end)
        end)
    else
		local DataOfNumber = getDataByPhoneNumber(myPhoneNumber)
		if DataOfNumber == nil then
			MySQL.Async.execute('INSERT INTO betrayed_phone (`numero`,`contactos`,`mensajes`,`galeria`,`apps`) VALUES (@numero,@contactos,@mensajes,@galeria,@apps)',
			{['@numero'] = myPhoneNumber,
			['@contactos'] = json.encode({}),
			['@mensajes'] = json.encode({}),
            ['@galeria'] = json.encode({}),
            ['@apps'] = json.encode({}),},function ()
				cb(myPhoneNumber)
			end)
		else
			cb(myPhoneNumber)
		end
    end
end

--====================================================================================
--  Funciones de Obtencion de Datos
--====================================================================================

function getContactName(number,contactos)

  if (#contactos ~= 0) then
    for k,v in pairs(contactos) do
      if v ~= nil then
        if (v.number ~= nil and (v.number) == (number)) then
          return v.name
        end
      end
    end
  end

  return number
end

function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end

function getDataByPhoneNumber(phone_number)
    local result = MySQL.Sync.fetchAll("SELECT betrayed_phone.numero FROM betrayed_phone WHERE numero = @numero", {
        ['@numero'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].numero
    end
    return nil
end

function getSourceFromIdentifier(identifier, cb)
    TriggerEvent("es:getPlayers", function(users)
        for k , user in pairs(users) do
            if (user.getIdentifier ~= nil and user.getIdentifier() == identifier) or (user.identifier == identifier) then
                cb(k)
                break
                return
            end
        end
    end)
    cb(nil)
end

function obtenerContactos(phone_number)
	local result = MySQL.Sync.fetchAll("SELECT betrayed_phone.contactos FROM betrayed_phone WHERE numero = @numero", {
        ['@numero'] = phone_number
    })
    if result[1] ~= nil then
        return json.decode(result[1].contactos) or {}
    end
	return {}
end

function obtenerGaleria(phone_number)
	local result = MySQL.Sync.fetchAll("SELECT betrayed_phone.galeria FROM betrayed_phone WHERE numero = @numero", {
        ['@numero'] = phone_number
    })
    if result[1] ~= nil then
        return json.decode(result[1].galeria) or {}
    end
	return {}
end

function obtenerSMS(phone_number)
	local result = MySQL.Sync.fetchAll("SELECT betrayed_phone.mensajes FROM betrayed_phone WHERE numero = @numero", {
        ['@numero'] = phone_number
    })
    if result[1] ~= nil then
        return json.decode(result[1].mensajes) or {}
    end
	return {}
end

function obtenerFondo(phone_number)
	local result = MySQL.Sync.fetchAll("SELECT betrayed_phone.fondo FROM betrayed_phone WHERE numero = @numero", {
        ['@numero'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].fondo
    end
	return {}
end

function obtenerApps(phone_number)
	local result = MySQL.Sync.fetchAll("SELECT betrayed_phone.apps FROM betrayed_phone WHERE numero = @numero", {
        ['@numero'] = phone_number
    })
    if result[1] ~= nil then
        return json.decode(result[1].apps) or {}
    end
	return {}
end

function obtenerTweets()
    local result = MySQL.Sync.fetchScalar("SELECT datos FROM betrayed_varios WHERE nombre=@nombre",{['@nombre'] = "tweets"})
    return json.decode(result) or {}
end

function obtenerUserTwitter(ident)
    local data = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier=@identifier',{['@identifier'] = ident})
    while not data do Citizen.Wait(0); end
    if data[1].firstname == nil then
        return nil
    else
        return '@'..data[1].firstname..'_'..data[1].lastname
    end
end

function obtenerNombre(ident)
    local data = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier=@identifier',{['@identifier'] = ident})
    while not data do Citizen.Wait(0); end
    if data[1].firstname == nil then
        return nil
    else
        return data[1].firstname..' '..data[1].lastname
    end
end

--====================================================================================
--  Funciones de Guardado
--====================================================================================

function guardarTweets(tweets)
    MySQL.Sync.execute("UPDATE betrayed_varios SET datos=@datos WHERE nombre=@nombre", {['@datos'] = json.encode(tweets), ['@nombre'] = "tweets"})
end

function guardarApps(numero,apps)
    MySQL.Async.insert("UPDATE betrayed_phone SET apps = @apps WHERE numero = @numero", { 
       ['@apps'] = json.encode(apps),
       ['@numero'] = numero
   }, function ()
       return true
   end)
end

function guardarContactos(numero,contactos)
	 MySQL.Async.insert("UPDATE betrayed_phone SET contactos = @contactos WHERE numero = @numero", { 
		['@contactos'] = json.encode(contactos),
		['@numero'] = numero
	}, function ()
		return true
	end)
end

function guardarGaleria(numero,galeria)
	 MySQL.Async.insert("UPDATE betrayed_phone SET galeria = @galeria WHERE numero = @numero", { 
		['@galeria'] = json.encode(galeria),
		['@numero'] = numero
	}, function ()
		return true
	end)
end

function guardarSMSs(numero,sms)
	 MySQL.Async.insert("UPDATE betrayed_phone SET mensajes = @mensajes WHERE numero = @numero", { 
		['@mensajes'] = json.encode(sms),
		['@numero'] = numero
	}, function ()
		return true
	end)
end

function guardarFondo(numero,fondo)
	 MySQL.Async.insert("UPDATE betrayed_phone SET fondo = @fondo WHERE numero = @numero", { 
		['@fondo'] = fondo,
		['@numero'] = numero
	}, function ()
		return true
	end)
end

function tablefind(tab,el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

function tablefindKeyVal(tab,key,val)
  for index, value in pairs(tab) do
    if value ~= nil  and value[key] ~= nil and value[key] == val then
      return index
    end
  end
end