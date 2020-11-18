----------------------------------------
--- Discord Whitelist, Made by FAXES ---
----------------------------------------

--- Config ---
roleNeeded = "Whitelisted"
notWhitelisted = "You are not whitelisted. Head over to www.definitionrp.com to apply." -- Message displayed when they are not whitelist with the role
noDiscord = "You must have Discord open to join this server." -- Message displayed when discord is not found

roles = { -- Role nickname(s) needed to pass the whitelist
    "Whitelisted",
}


--- Code ---

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local src = source
    deferrals.defer()
    Citizen.Wait(100)
    deferrals.update("Checking Permissions")

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end

    if identifierDiscord then
        for i = 1, #roles do
            Citizen.Wait(100)
            if exports.discord_perms:IsRolePresent(src, roles[i]) then
                -- deferrals.done()
                Citizen.Wait(2000)
                showCard(deferrals)
                break
            else
                deferrals.done(notWhitelisted)
            end
        end
        -- deferrals.done() -- Uncomment for Public
    end
end)

function showCard(deferrals)
    deferrals.presentCard([==[
        {
            "type": "AdaptiveCard",
            "$schema": "https://adaptivecards.io/schemas/adaptive-card.json",
            "version": "1.0",
            "body": [
                {
                    "type": "TextBlock",
                    "text": "You are joining Definition RP",
                    "horizontalAlignment": "Center",
                    "size": "ExtraLarge",
                    "weight": "Lighter",
                    "color": "Warning"
                },
                {
                    "type": "TextBlock",
                    "text": "You are automatically agreeing to our Rules and Guidelines",
                    "isSubtle": true,
                    "horizontalAlignment": "Center"
                }
            ],
            "actions": [
                {
                    "type": "Action.OpenUrl",
                    "title": "Forums",
                    "id": "F",
                    "url": "https://www.definitionrp.com"
                },
                {
                    "type": "Action.OpenUrl",
                    "title": "Discord",
                    "url": "https://discord.gg/definition"
                }
            ]
        }]==])
    Citizen.Wait(5000)
    deferrals.done()
end



--[[
{
                    "type": "Image",
                    "url": "add your image url here "
                },
]]