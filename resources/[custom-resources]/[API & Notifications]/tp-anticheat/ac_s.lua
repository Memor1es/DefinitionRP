-- with this you can turn on/off specific anticheese components, note: you can also turn these off while the script is running by using events, see examples for such below
Components = {
	Teleport = true,
	GodMode = true,
	Speedhack = true,
	WeaponBlacklist = false,
	CustomFlag = true,
}

--[[
event examples are:

anticheese:SetComponentStatus( component, state )
	enables or disables specific components
		component:
			an AntiCheese component, such as the ones listed above, must be a string
		state:
			the state to what the component should be set to, accepts booleans such as "true" for enabled and "false" for disabled


anticheese:ToggleComponent( component )
	sets a component to the opposite mode ( e.g. enabled becomes disabled ), there is no reason to use this.
		component:
			an AntiCheese component, such as the ones listed above, must be a string

anticheese:SetAllComponents( state )
	enables or disables **all** components
		state:
			the state to what the components should be set to, accepts booleans such as "true" for enabled and "false" for disabled


These can be used by triggering them like following:
	TriggerEvent("anticheese:SetComponentStatus", "Teleport", false)

These Events CAN NOT be called from the clientside

]]
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		GetInitialPlayerData()
	end
end)

function GetInitialPlayerData()
	local players = ESX.GetPlayers()
	for i=1, #players, 1 do
		local xPlayer = ESX.GetPlayerFromId(players[i])
	end
end

Users = {}
violations = {}

RegisterServerEvent("anticheese:timer")
AddEventHandler("anticheese:timer", function()
	if Users[source] then
		if (os.time() - Users[source]) < 15 and Components.Speedhack then -- prevent the player from doing a good old cheat engine speedhack
			DropPlayer(source, "Speedhacking")
		else
			Users[source] = os.time()
		end
	else
		Users[source] = os.time()
	end
end)

AddEventHandler('es:playerLoaded',function(source)
	if IsPlayerAceAllowed(source,"anticheese.bypass") then
		TriggerClientEvent('bansql:anticheat', source, false)
	end
end)

AddEventHandler('playerDropped', function()
	if(Users[source])then
		Users[source] = nil
	end
end)

RegisterServerEvent("anticheese:kick")
AddEventHandler("anticheese:kick", function(reason)
	DropPlayer(source, reason)
end)

AddEventHandler("anticheese:SetComponentStatus", function(component, state)
	if type(component) == "string" and type(state) == "boolean" then
		Components[component] = state -- changes the component to the wished status
	end
end)

AddEventHandler("anticheese:ToggleComponent", function(component)
	if type(component) == "string" then
		Components[component] = not Components[component]
	end
end)

AddEventHandler("anticheese:SetAllComponents", function(state)
	if type(state) == "boolean" then
		for i,theComponent in pairs(Components) do
			Components[i] = state
		end
	end
end)

Citizen.CreateThread(function()
	webhook = Config.webhookban


	function SendWebhookMessage(webhook,message)
		if webhook ~= "none" then
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
		end
	end

	function WarnPlayer(playername, reason)
		local isKnown = false
		local isKnownCount = 1
		local isKnownExtraText = ""
		for i,thePlayer in ipairs(violations) do
			if thePlayer.name == name then
				isKnown = true
				if violations[i].count == 3 then
					--TriggerEvent("bansql:icheat", source)
					isKnownCount = violations[i].count
					table.remove(violations,i)
					isKnownExtraText = ", @Staff Investigation requis."
				else
					violations[i].count = violations[i].count+1
					isKnownCount = violations[i].count
				end
			end
		end

		if not isKnown then
			table.insert(violations, { name = name, count = 1 })
		end

		return isKnown, isKnownCount,isKnownExtraText
	end

	function GetPlayerNeededIdentifiers(player)
		local ids = GetPlayerIdentifiers(player)
		for i,theIdentifier in ipairs(ids) do
			if string.find(theIdentifier,"license:") or -1 > -1 then
				license = theIdentifier
			elseif string.find(theIdentifier,"steam:") or -1 > -1 then
				steam = theIdentifier
			end
		end
		if not steam then
			steam = "steam: missing"
		end
		return license, steam
	end

	RegisterServerEvent('AntiCheese:SpeedFlag')
	AddEventHandler('AntiCheese:SpeedFlag', function(rounds, roundm)
		if Components.Speedhack and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)

			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Speed Hacking")

			SendWebhookMessage(webhook, "**Speed Hacker!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nWas travelling "..rounds.. " units. That's "..roundm.." more than normal! \nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)



	RegisterServerEvent('AntiCheese:NoclipFlag')
	AddEventHandler('AntiCheese:NoclipFlag', function(distance)
		if Components.Teleport and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Noclip/Teleport Hacking")


			SendWebhookMessage(webhook,"**Noclip/Teleport!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nCaught with "..distance.." units between last checked location\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)
	
	
	RegisterServerEvent('AntiCheese:MoneyFlag')
	AddEventHandler('AntiCheese:MoneyFlag', function(money)
		if not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)

--			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Possible Money Cheat")


			SendWebhookMessage(webhook,"**Anti-CheatMoney! ** \n```\nJoueur:"..name.."\n"..license.."\n"..steam.."\nA gagné "..money.."$ en une minutes.\n```")
--			SendWebhookMessage(webhook,"**Possible Money Cheat!** \n```\nJoueur:"..name.."\n"..license.."\n"..steam.."\nA gagné "..money.."$ en une minutes.\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)
	
	
	RegisterServerEvent('AntiCheese:CustomFlag')
	AddEventHandler('AntiCheese:CustomFlag', function(reason,extrainfo)
		if Components.CustomFlag and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)
			if not extrainfo then extrainfo = "no extra informations provided" end
			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,reason)


			SendWebhookMessage(webhook,"**"..reason.."** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\n"..extrainfo.."\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)

	RegisterServerEvent('AntiCheese:HealthFlag')
	AddEventHandler('AntiCheese:HealthFlag', function(invincible,oldHealth, newHealth, curWait)
		if Components.GodMode and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Health Hacking")

			if invincible then
				SendWebhookMessage(webhook,"**Health Hack!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nRegenerated "..newHealth-oldHealth.."hp ( to reach "..newHealth.."hp ) in "..curWait.."ms! ( PlayerPed was invincible )\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
			else
				SendWebhookMessage(webhook,"**Health Hack!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nRegenerated "..newHealth-oldHealth.."hp ( to reach "..newHealth.."hp ) in "..curWait.."ms! ( Health was Forced )\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
			end
		end
	end)

	RegisterServerEvent('AntiCheese:JumpFlag')
	AddEventHandler('AntiCheese:JumpFlag', function(jumplength)
		if Components.SuperJump and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"SuperJump Hacking")

			SendWebhookMessage(webhook,"**SuperJump Hack!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nJumped "..jumplength.."ms long\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)

	RegisterServerEvent('AntiCheese:WeaponFlag')
	AddEventHandler('AntiCheese:WeaponFlag', function(weapon)
		if Components.WeaponBlacklist and not IsPlayerAceAllowed(source,"anticheese.bypass") then
			license, steam = GetPlayerNeededIdentifiers(source)
			name = GetPlayerName(source)

			isKnown, isKnownCount, isKnownExtraText = WarnPlayer(name,"Inventory Cheating")

			SendWebhookMessage(webhook,"**Inventory Hack!** \n```\nUser:"..name.."\n"..license.."\n"..steam.."\nGot Weapon: "..weapon.."( Blacklisted )\nAnticheat Flags:"..isKnownCount..""..isKnownExtraText.." ```")
		end
	end)
end)


local BlockedExplosions = {0, 1, 2, 4, 5, 25, 32, 33, 35, 36, 37, 38, 40}
local ExplosionsLog = ""
AddEventHandler("explosionEvent",function(sender, ev)
	for _, v in ipairs(BlockedExplosions) do
		if ev.explosionType == v and ev.damageScale ~= 0.0 then
			CancelEvent()
			local name = GetPlayerName(sender)
			local playerData = ESX.GetPlayerFromId(sender)
			if playerData == nil then
				GetInitialPlayerData()
				playerData = ESX.GetPlayerFromId(sender)
			end
			if playerData then
				local id = playerData.identifier
				local coords = " | Coords X:"..round(ev.posX)..",Y:"..round(ev.posY)..",Z:"..round(ev.posZ)
				local exevent = "| ownerNetID:"..ev.ownerNetId.." | ExplosionType:"..ev.explosionType..coords.." | "..id.." |"
				TriggerClientEvent('EasyAdmin:EXCaptureScreenshot', sender)
				TriggerEvent('discordbot:exlog', "[ILLEGAL EXPLOSION] "..name.." has been kicked for triggering a blocked explosion: ```"..exevent.."``` <@&672205395229409291> <@&620730564949049344> <@&637431761407705109>")
				Wait(5000)
				DropPlayer(sender, "You have been kicked from the server")
			end
		end
	end
end)

function round(number)
	return number - (number % 1)
end



--LEGAL EXPLOSIONS ONLY
-- local BlockedExplosions = {0, 1, 2, 4, 5, 13, 25, 32, 33, 35, 36, 37, 38}
-- local ExplosionsLog = ""
-- AddEventHandler("explosionEvent",function(sender, ev)
-- 	local name = GetPlayerName(sender)
-- 	local playerData = ESX.GetPlayerFromId(sender)
-- 	local id = playerData.identifier
-- 	local coords = " | Coords X:"..round(ev.posX)..",Y:"..round(ev.posY)..",Z:"..round(ev.posZ)
-- 	local exevent = "| ownerNetID:"..ev.ownerNetId.." | ExplosionType:"..ev.explosionType..coords.." | "..id.." |"
-- 	if ev.explosionType ~= 0 and ev.explosionType ~= 1 and ev.explosionType ~= 2 and ev.explosionType ~= 4 and ev.explosionType ~= 5 and ev.explosionType ~= 13 and ev.explosionType ~= 25 and ev.explosionType ~= 32 and ev.explosionType ~= 33 and ev.explosionType ~= 35 and ev.explosionType ~= 36 and ev.explosionType ~= 37 and ev.explosionType ~= 38 and ev.damageScale ~= 0.0 then
-- 		TriggerEvent('discordbot:exlog', "[LEGAL EXPLOSION] "..name.." has triggered an explosion: ```"..exevent.."```")
-- 	end
-- end)

function round(number)
	return number - (number % 1)
end