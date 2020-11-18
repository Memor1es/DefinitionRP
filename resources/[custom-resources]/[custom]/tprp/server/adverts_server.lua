players = {}
host = nil
local adverts = {
    "Don't forget to apply for whitelist!",
    "Don't forget to apply for whitelist!"
}
local nextadvert = 1

RegisterServerEvent("Z:newplayer")
AddEventHandler("Z:newplayer", function()
    players[source] = true

    if not host then
        host = source
        TriggerClientEvent("Z:adverthost", source)
    end
end)

AddEventHandler("playerDropped", function(reason)
    players[source] = nil

    if source == host then
        if #players > 0 then
            for mSource, _ in pairs(players) do
                host = mSource
                TriggerClientEvent("Z:adverthost", source)
                break
            end
        else
            host = nil
        end
    end
end)

RegisterServerEvent("Z:timeleftsync")
AddEventHandler("Z:timeleftsync", function(nTimeLeft)
	timeLeft = nTimeLeft
    if timeLeft < 1 then
        local index = (nextadvert % #adverts) + 1
        --   TriggerClientEvent("chatMessage", -1, "^7[^4ADVERT^7]", {255, 255, 255}, adverts[index])
        for _, player in ipairs(GetPlayers()) do
            if not exports.discord_perms:IsRolePresent(player, "Whitelisted") then
                TriggerClientEvent('chat:addMessage', player, { template = '<div class="chat-message-advert"><b>Advert:</b> {0}</div>', args = {adverts[index]} })
            end
        end
        nextadvert = nextadvert + 1
    end
end)
