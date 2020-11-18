RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end
    
    local xPlayer = ESX.GetPlayerFromId(source)

    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
      })
    
      local firstname = result[1].firstname
      local lastname  = result[1].lastname

      local owner = (firstname .. " " .. lastname)


    --TriggerEvent('chatMessage', source, author, message)

    
    if not WasEventCanceled() then
         TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="msg" style="margin-bottom: -20px; background-color: rgb(47, 92, 115);"><span style="font-weight: bold;">{0}</span> | {1}</div>',
            args = { owner, message }
        })
    end

    -- printing all chat messages to console.... no no.
    print(author .. '^7: ' .. message .. '^7')
    print(owner .. '^7: ' .. message .. '^7')
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)



    if not WasEventCanceled() then
        --TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, 'Invalid Command') 
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="msg" style="margin-bottom: -20px; background-color: rgb(180, 5, 5);"><span style="font-weight: bold;">You entered an invalid command</span></div>'
        })
    end

    CancelEvent()
end)


-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
