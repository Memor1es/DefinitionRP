local gameResult, gamePlaying = false, false

function gameTest()
    TriggerEvent('DRP:Games:StartPhoneLetters', {}, function(success)
        if success then
            print('passed')
        else
            print('failed')
        end
    end)
end

--[[
### EXAMPLE TRIGGER

TriggerEvent('DRP:Games:StartPhoneLetters', {
    tries = 10,
    failures = 5,
    time = 500,
    duration = 500,
    chars = {"e","w","a"} -- If omitted then will use default (a,s,d,w,i,j,k,l)
        -- This entire table can be a empty table for default values
}, function(success)
    if success then
        -- What to do if they were successful at the game
    else
        -- What to do if they failed at the game or cancelled.
    end

    -- What do do if they either fail or succeed at the game
end)

### END OF EXAMPLE
]]

RegisterNUICallback("gameResult", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        endGame = true,
        })
    TriggerEvent('phone:close')
    gameResult = data.result
    gamePlaying = false
end)

RegisterNUICallback("gameClose", function(data, cb)
    print('cancelling game?')
    SetNuiFocus(false, false)
    SendNUIMessage({
        endGame = true,
        })
    TriggerEvent('phone:close')
    gameResult = false
    gamePlaying = false
end)

RegisterNetEvent('DRP:Games:StartPhoneLetters')
AddEventHandler('DRP:Games:StartPhoneLetters', function(options, cb)
    local hasPhone = exports["disc-inventoryhud"]:hasEnoughOfItem('phone', 1)
    if hasPhone then
        if options ~= nil and type(options) == "table" then
            options.tries = options.tries or 20
            options.failures = options.failures or 10
            options.duration = options.duration or 5000
            options.time = options.time or 2000
            options.chars = options.chars or {"w","a","s","d","i","j","k","l"}
        else
            options = {}
            options.tries = 20
            options.failures = 10
            options.duration = 5000
            options.time = 2000
            options.chars = {"w","a","s","d","i","j","k","l"}
        end

        if options.fleeca then
            TriggerServerEvent('drp-framework:updateFleecaCooldown')
        end

        if options.pacific then

        end

        if options.paleto then

        end

        if not gamePlaying then
            gamePlaying = true
            gameResult = false
            SetNuiFocus(true, true)
            TriggerEvent('animation:sms',true)
            TriggerEvent('phoneEnabled',true)
            SendNUIMessage({
                startGame = true,
                data = {
                    action = "start",
                    tries = options.tries,
                    failures = options.failures,
                    duration = options.duration,
                    letters = options.time,
                    chars = options.chars
                }
            })
            Citizen.CreateThread(function()
                while true do
                        repeat Wait(0) until gamePlaying == false
                        cb(gameResult)
                    break
                    Citizen.Wait(0)
                end
            end)
        end
    else
        cb(false)
        exports['mythic_notify']:SendAlert('error', 'You need a phone to complete this task', 5000)
    end
end)
--[[
Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, 38) then
            gameTest()
        end
        Citizen.Wait(3)
    end
end)]]