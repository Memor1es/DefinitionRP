local Config = {}
local pressedToUnziptie = false
local currentlyZiptied = false
local doingZiptie = false

Config.ZipTieReleaseWeapons = {
    `WEAPON_KNIFE`, `WEAPON_DAGGER`, `WEAPON_SWITCHBLADE`, `WEAPON_MACHETE`
}

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        if playerPed then
            local _, weapon = GetCurrentPedWeapon(playerPed, true)
            if weapon then
                for k, v in pairs(Config.ZipTieReleaseWeapons) do
                    if v == weapon then
                        if IsControlJustReleased(0, 38) and not pressedToUnziptie then
                            print('valid weapon found')
                            processUnziptie()
                            break;
                        end
                    end
                end
            end
        end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent('DRP:Client:Zipties:StartZiptie')
AddEventHandler('DRP:Client:Zipties:StartZiptie', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 1.5 then
        TriggerServerEvent('DRP:Server:Zipties:ZiptiePlayer', GetPlayerServerId(closestPlayer), true)
    end
end)

RegisterNetEvent('DRP:Server:Client:DoNotificationBar')
AddEventHandler('DRP:Server:Client:DoNotificationBar', function(action)
    if action == "ziptie" then
        exports['mythic_progbar']:Progress({
            name = "lockpickhandcuff_action",
            duration = 5000,
            label = "Zipping Ziptie",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = 'mp_arresting',
                anim = 'a_uncuff',
                time = 5000
            }
        })
    else
        exports['mythic_progbar']:Progress({
            name = "lockpickhandcuff_action",
            duration = 5000,
            label = "Cutting Ziptie",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = 'mp_arresting',
                anim = 'a_uncuff',
                time = 5000
            }
        })
    end
end)

exports('getZiptieStatus', function()
    return currentlyZiptied
end)

RegisterNetEvent('DRP:Client:Zipties:ZiptiePlayer')
AddEventHandler('DRP:Client:Zipties:ZiptiePlayer', function(toggle, requestor, ply)
    print(tostring(toggle), tostring(currentlyZiptied), tonumber(requestor))
    if toggle and not currentlyZiptied then
        local playerPed = PlayerPedId()
        if IsEntityPlayingAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 3) or IsEntityPlayingAnim(playerPedder, 'dead', 'dead_a', 3) then
            TriggerServerEvent('DRP:Server:Zipties:DoNotificationBar', tonumber(requestor), "ziptie")
            exports['mythic_progbar']:Progress({
                name = "lockpickhandcuff_action",
                duration = 5000,
                label = "Being Ziptied",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }
            }, function(status)
                if not status then
                    currentlyZiptied = true
                    SetEnableHandcuffs(playerPed, currentlyZiptied)
                    TriggerServerEvent('DRP:Server:Global:DisplayNotification', tonumber(requestor), 'success', 'The person has been Ziptied', 5000)
                    TriggerServerEvent('DRP:Server:Zipties:ZiptiePlayer2', tonumber(ply), true)
                    Citizen.CreateThread(function()
                        while currentlyZiptied do
                            DisableControlAction(0, 24, true) -- Attack
                            DisableControlAction(0, 257, true) -- Attack 2
                            DisableControlAction(0, 25, true) -- Aim
                            DisableControlAction(0, 263, true) -- Melee Attack 1
                            DisableControlAction(0, 45, true) -- Reload
                            DisableControlAction(0, 22, true) -- Jump
                            DisableControlAction(0, 44, true) -- Cover
                            DisableControlAction(0, 37, true) -- Select Weapon
                            DisableControlAction(0, 23, true) -- Also 'enter'?
                            DisableControlAction(0, 288,  true) -- Disable phone
                            DisableControlAction(0, 289, true) -- Inventory
                            DisableControlAction(0, 170, true) -- Animations
                            DisableControlAction(0, 167, true) -- Job
                            DisableControlAction(0, 73, true) -- Disable clearing animation
                            DisableControlAction(2, 199, true) -- Disable pause screen
                            DisableControlAction(0, 59, true) -- Disable steering in vehicle
                            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
                            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
                            DisableControlAction(2, 36, true) -- Disable going stealth
                            DisableControlAction(0, 47, true)  -- Disable weapon
                            DisableControlAction(0, 264, true) -- Disable melee
                            DisableControlAction(0, 257, true) -- Disable melee
                            DisableControlAction(0, 140, true) -- Disable melee
                            DisableControlAction(0, 141, true) -- Disable melee
                            DisableControlAction(0, 142, true) -- Disable melee
                            DisableControlAction(0, 143, true) -- Disable melee
                            DisableControlAction(0, 75, true)  -- Disable exit vehicle
                            DisableControlAction(27, 75, true) -- Disable exit vehicle
                            DisableControlAction(27, 165, true) -- Disable exit vehicle
                            DisableControlAction(27, 164, true) -- Disable exit vehicle
                            DisableControlAction(27, 168, true) -- Disable exit vehicle
                            DisableControlAction(27, 158, true) -- Disable exit vehicle
                            DisableControlAction(27, 157, true) -- Disable exit vehicle

                            if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
                                ESX.Streaming.RequestAnimDict('mp_arresting', function()
                                    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                                end)
                            end
                            Citizen.Wait(1)
                        end
                    end)
                end
            end)
        else
            TriggerServerEvent('DRP:Server:Global:DisplayNotification', tonumber(requestor), 'error', 'The person needs there hands up', 5000)
        end
    elseif not toggle and currentlyZiptied then
        TriggerServerEvent('DRP:Server:Zipties:DoNotificationBar', tonumber(requestor), "unziptie")
        exports['mythic_progbar']:Progress({
            name = "lockpickhandcuff_action",
            duration = 5000,
            label = "Zipties Are Being Cut",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }
        }, function(status)
            if not status then
                currentlyZiptied = false
                StopAnimTask(playerPed, 'mp_arresting', 'idle', 1)
                SetEnableHandcuffs(playerPed, currentlyZiptied)
                TriggerServerEvent('DRP:Server:Global:DisplayNotification', tonumber(requestor), 'success', 'The person has been unziptied.', 5000)
                TriggerServerEvent('DRP:Server:Zipties:ZiptiePlayer2', tonumber(ply), false)
            end
        end)
    else
        TriggerServerEvent('DRP:Server:Global:DisplayNotification', tonumber(requestor), 'error', 'There was a problem trying to ziptie this person.', 5000)
    end
end)

RegisterNetEvent('DRP:Client:Zipties:Unziptie')
AddEventHandler('DRP:Client:Zipties:Unziptie', function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 1.5 then
        ESX.TriggerServerCallback('DRP:Server:Zipties:Check', function(ziptied)
            if ziptied then
                TriggerServerEvent('DRP:Server:Zipties:ZiptiePlayer', GetPlayerServerId(closestPlayer), false)
                pressedToUnziptie = false    
            end
        end, GetPlayerServerId(closestPlayer))
    end
end)

function processUnziptie()
    pressedToUnziptie = true
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 1.5 then
        ESX.TriggerServerCallback('DRP:Server:Zipties:Check', function(ziptied)
            TriggerServerEvent('DRP:Server:Zipties:ZiptiePlayer', GetPlayerServerId(closestPlayer), false)
            pressedToUnziptie = false
        end, GetPlayerServerId(closestPlayer))
    end
end