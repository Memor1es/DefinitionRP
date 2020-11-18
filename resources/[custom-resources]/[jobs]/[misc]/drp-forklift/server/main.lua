local hangar1ID = nil
local hangar2ID = nil
local cash = {a = 100, b = 200} --how much to cash for completing a job
-----------------------------------
local ActiveJob = 0
ESX = nil

TriggerEvent("esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

AddEventHandler("playerDropped", function(DropReason)
    if hangar1ID == source then
        hangar1ID = nil
    end

    if hangar2ID == source then
        hangar2ID = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        -- print("Hanger 1: " .. tostring(hangar1ID))
        -- print("Hanger 2: " .. tostring(hangar2ID))
    end
end)

RegisterServerEvent("drp:TakeOverHanger")
AddEventHandler("drp:TakeOverHanger",function(ktory)
        if ktory == "1" then
            if hangar1ID == nil then
                hangar1ID = source
                TriggerClientEvent(
                    "mythic_notify:client:SendAlert",
                    source,
                    {
                        type = "inform",
                        text = "You have taken over the hanger",
                        length = 5000,
                        style = {["background-color"] = "#2d5c74", ["color"] = "#ffffff"}
                    }
                )
                -- TriggerClientEvent('esx:showNotification', source, '~g~Przejmujesz hangar.')
                TriggerClientEvent(
                    "mythic_notify:client:SendAlert",
                    source,
                    {
                        type = "inform",
                        text = "You can now take orders",
                        length = 5000,
                        style = {["background-color"] = "#2d5c74", ["color"] = "#ffffff"}
                    }
                )
                -- TriggerClientEvent('esx:showNotification', source, '~g~Teraz tylko ty możesz tutaj wykonywać zlecenia.')
                TriggerClientEvent("drp:YouOwnTheHanger", source, 1)
            else
                -- TriggerClientEvent('esx:showNotification', source, '~y~Ten hangar jest już zajęty przez ID ~r~'..hangar1ID)
                TriggerClientEvent(
                    "mythic_notify:client:SendAlert",source,
                    {
                        type = "Error",
                        text = "This hanger is already owned by " .. hangerID,
                        length = 5000,
                        style = {["background-color"] = "#e43838", ["color"] = "#ffffff"}
                    }
                )
            end
        elseif ktory == "2" then
            if hangar2ID == nil then
                hangar2ID = source
                TriggerClientEvent(
                    "mythic_notify:client:SendAlert",
                    source,
                    {
                        type = "inform",
                        text = "You have taken over the hanger",
                        length = 5000,
                        style = {["background-color"] = "#2d5c74", ["color"] = "#ffffff"}
                    }
                )
                -- TriggerClientEvent('esx:showNotification', source, '~g~Przejmujesz hangar.')
                TriggerClientEvent(
                    "mythic_notify:client:SendAlert",
                    source,
                    {
                        type = "inform",
                        text = "You can now take orders",
                        length = 5000,
                        style = {["background-color"] = "#2d5c74", ["color"] = "#ffffff"}
                    }
                )
                -- TriggerClientEvent('esx:showNotification', source, '~g~Teraz tylko ty możesz tutaj wykonywać zlecenia.')
                TriggerClientEvent("drp:YouOwnTheHanger", source, 2)
            else
                -- TriggerClientEvent('esx:showNotification', source, '~y~Ten hangar jest już zajęty przez ID ~r~'..hangar2ID)
                TriggerClientEvent(
                    "mythic_notify:client:SendAlert",
                    source,
                    {
                        type = "Error",
                        text = "This hanger is already owned by " .. hangerID,
                        length = 5000,
                        style = {["background-color"] = "#e43838", ["color"] = "#ffffff"}
                    }
                )
            end
        end
    end
)

RegisterServerEvent("drp:CompleteJob")
AddEventHandler("drp:CompleteJob",function(premia)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local LosujSiano = math.random(cash.a, cash.b)

        if premia == "nie" then
            xPlayer.addMoney(LosujSiano)
            TriggerClientEvent("mythic_notify:client:SendAlert",source,{type = "success", text = "You recieved $" .. LosujSiano .. ".", length = 5000, style = {["background-color"] = "#74ca74", ["color"] = "#ffffff"}})
            -- TriggerClientEvent('esx:showNotification', _source, '~g~Otrzymujesz '..LosujSiano..'$ za wykonanie dostawy')
            Wait(2500)
        else
            TriggerClientEvent("mythic_notify:client:SendAlert",source,{type = "success", text = "You recieved $" .. premia .. " bonus.", length = 5000, style = {["background-color"] = "#74ca74", ["color"] = "#ffffff"}})
            xPlayer.addMoney(premia)
            Wait(2500)
        end
    end
)

RegisterServerEvent("drp:OutOfHangerRange")
AddEventHandler("drp:OutOfHangerRange", function()

    local _source = source

	if hangar1ID == _source then
	    hangar1ID = nil
    end
    
	if hangar2ID == _source then
	    hangar2ID = nil
    end

    TriggerClientEvent("drp:YouOwnTheHanger", source, 0)
    
end)