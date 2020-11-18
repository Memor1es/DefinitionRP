--====================================================================================
--  Inicio script
--====================================================================================

RegisterCommand("call", function(source, args, rawCommand)
    local sourcePlayer = tonumber(source)
    local numero = args[1]
	if numero == nil or numero == '' then 
        TriggerClientEvent('mythic_notify:client:SendAlert', sourcePlayer, { type = 'inform', text = 'You must enter a valid number!', length = 4000})
        return
    end
    TriggerClientEvent('betrayed_phone:comandoLlamar', sourcePlayer,numero)
end, false)

RegisterCommand("h", function(source, args, rawCommand)
    local sourcePlayer = tonumber(source)
    TriggerClientEvent('betrayed_phone:hangupcall', sourcePlayer)
end, false)

RegisterCommand("a", function(source, args, rawCommand)
    local sourcePlayer = tonumber(source)
    TriggerClientEvent('betrayed_phone:answercall', sourcePlayer)
end, false)

RegisterServerEvent('betrayed_phone:llamarContacto')
AddEventHandler('betrayed_phone:llamarContacto', function(numero, anonimo)    
    --- Mis datos ----
    local sourcePlayer = tonumber(source)
    local Midentifier = getPlayerID(source)
    local num = getNumberPhone(Midentifier)
    
    if numero == nil or numero == '' then 
        return
    end

    ---- Datos del otro ----
    local destPlayer = getIdentifierByPhoneNumber(numero)
    local contactos = obtenerContactos(num)

    ----- Eventos ------
    local is_valid = destPlayer ~= nil and destPlayer ~= Midentifier
    local llamo = false

    if is_valid == true then
        getSourceFromIdentifier(destPlayer, function (srcTo)
            if srcTo ~= nill then -- esta conectado
                llamo = true
                --- yo ---
                TriggerClientEvent('betrayed_phone:intentoLlamar', sourcePlayer,sourcePlayer,srcTo)
                --- otro ---
                TriggerClientEvent('betrayed_phone:reciboLlamado', srcTo,sourcePlayer,num)
            end
        end)
    else -- soy yo o no existe.
        TriggerClientEvent('betrayed_phone:intentoLlamar', sourcePlayer,sourcePlayer,nil)
    end

    if not llamo then
        TriggerClientEvent('betrayed_phone:intentoLlamar', sourcePlayer,sourcePlayer,nil)
    end
end)

RegisterServerEvent('betrayed_phone:ContestoLlamado')
AddEventHandler('betrayed_phone:ContestoLlamado', function(srcTo)
    local sourcePlayer = tonumber(source)
    TriggerClientEvent('betrayed_phone:InicioLlamado', srcTo,srcTo,sourcePlayer)
end)

RegisterServerEvent('betrayed_phone:cortarLlamado')
AddEventHandler('betrayed_phone:cortarLlamado', function(srcTo)
    TriggerClientEvent('betrayed_phone:cortarLlamadoOtro', srcTo)
end)

RegisterServerEvent('betrayed_phone:ponerEnEspera')
AddEventHandler('betrayed_phone:ponerEnEspera', function(srcTo,estado)
    TriggerClientEvent('OnHold:Client', srcTo,estado)
end)

