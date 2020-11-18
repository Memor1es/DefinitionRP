local function isAdmin(source)
    local allowed = false
    for i,id in ipairs(Config.EAS.admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(source)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
	end
	if IsPlayerAceAllowed(source, "lance.eas") then
		allowed = true
	end
    return allowed
end

local function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterServerEvent("alert:sv")
AddEventHandler("alert:sv", function (msg, msg2)
	if (isAdmin(source)) then
    		TriggerClientEvent("SendAlert", -1, msg, msg2)
	end
end)

AddEventHandler('chatMessage', function(source, name, msg)
	if (isAdmin(source)) then
		local command = stringsplit(msg, " ")[1];

		if command == "/alert" then
		    CancelEvent()
		    TriggerClientEvent("alert:Send", source, string.sub(msg, 8), Config.EAS.Departments)
        end
        
        if command == "/1alertgogogo" then
            TriggerClientEvent("SendAlert", -1, "USGVMT", "This is not a test, this is your Emergency Broadcast System. Announcing the commencement of the annual purge sanctioned by the U.S. Government. Weapons of class four and lower have been authorized for use during the purge. All other weapons are restricted. Government officials of ranking 10 have been granted immunity and shall not be harmed. Commencing at the siren, any and all crime (including murder) will be legal for 30 minutes. When the purge concludes. Blessed be our new founding fathers and America... A nation reborn. May God be with you all.")
        end
	end
end)