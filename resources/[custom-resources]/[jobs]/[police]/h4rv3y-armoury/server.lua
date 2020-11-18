local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---------------------------------------------------------------------------
--- Get's Character Information
---------------------------------------------------------------------------
function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			phone_number = identity['phone_number']
		}
	else
		return nil
	end
end
---------------------------------------------------------------------------
--- Take Item
---------------------------------------------------------------------------
RegisterServerEvent("h4rv3y-armoury:takeitem")
AddEventHandler("h4rv3y-armoury:takeitem", function(item, rack)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
	if xPlayer then
		if rack then 
			if Config.usingDiscInventory then
				xPlayer.addInventoryItem(item, 1)
			else
				xPlayer.addWeapon(item, Config.ammoAmount)
			end
		else
			if Config.usingDiscInventory then
				xPlayer.removeInventoryItem(item, 1)
			else
				xPlayer.removeWeapon(item)
			end
		end
    end
end)
---------------------------------------------------------------------------
--- To Discord Webhook
---------------------------------------------------------------------------
RegisterServerEvent('h4vr3y-armoury:sendToDiscord')
AddEventHandler('h4vr3y-armoury:sendToDiscord', function(itemType, rack)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local id = ESX.GetPlayerFromId(_source).getIdentifier()
    local name = getIdentity(_source)
    fullname = name.firstname  .. ' ' .. name.lastname
    local DATE = os.date(" %H:%M %d.%m.%y")

	if xPlayer then
		if rack then
			local message = "```diff\n- " ..fullname.. " ["..id.."] | has taken a "..itemType.." from the Police Armory | at "..DATE.."\n```"
			PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Police Armory", content = message}), { ['Content-Type'] = 'application/json' })
		else
			local message = "```diff\n+ " ..fullname.. " ["..id.."] | has racked a "..itemType.." to the Police Armory | at "..DATE.."\n```"
			PerformHttpRequest(""..Config.DiscordWebook.."", function(err, text, headers) end, 'POST', json.encode({username = "Police Armory", content = message}), { ['Content-Type'] = 'application/json' })
		end
    end
end)