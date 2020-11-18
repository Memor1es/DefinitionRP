ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(
            "esx:getSharedObject",
            function(obj)
                ESX = obj
            end
        )
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(
    function()
        while true do
        Citizen.Wait(60000)

        local config = Config or {}
        local blacklistedCommands = config.BlacklistedCommands or {}
        local registeredCommands = GetRegisteredCommands()

        for _, command in ipairs(registeredCommands) do
            for _, blacklistedCommand in pairs(blacklistedCommands) do
                if
                    (string.lower(command.name) == string.lower(blacklistedCommand) or
                        string.lower(command.name) == string.lower("+" .. blacklistedCommand) or
                        string.lower(command.name) == string.lower("_" .. blacklistedCommand) or
                        string.lower(command.name) == string.lower("-" .. blacklistedCommand) or
                        string.lower(command.name) == string.lower("/" .. blacklistedCommand))
                then
                    TriggerServerEvent("framework:commandBan", _source, "Framework has detected suspicious activity! Triggered Event: " .. blacklistedCommand)
                end
            end
        end

        ESX.TriggerServerCallback("framework:getRegisteredCommands",function(_registeredCommands)
            for _, command in ipairs(_registeredCommands) do
                for _, blacklistedCommand in pairs(blacklistedCommands) do
                    if
                        (string.lower(command.name) == string.lower(blacklistedCommand) or
                            string.lower(command.name) == string.lower("+" .. blacklistedCommand) or
                            string.lower(command.name) == string.lower("_" .. blacklistedCommand) or
                            string.lower(command.name) == string.lower("-" .. blacklistedCommand) or
                            string.lower(command.name) == string.lower("/" .. blacklistedCommand))
                    then
                        TriggerServerEvent("framework:commandBan",_source,"Framework has detected activity! Triggered Event: " .. blacklistedCommand)
                    end
                end
            end
        end)
    end
end)