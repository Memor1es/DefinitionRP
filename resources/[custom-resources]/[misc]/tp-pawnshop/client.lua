--- on server restart, math random to load 3 positions out of the list,
--- information can be got from a random place similar to shady backalley dude


ESX = nil
finished = nil
local insideMarker = false
local MissionStarted = false
local activeShops = {}
local saleItems = {}
local peds = {}

Citizen.CreateThread(function()
    math.randomseed(GetGameTimer())
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('onResourceStart', function(r)
    if r == GetCurrentResourceName() then
        -- print('big boobs')
        TriggerServerEvent('tp-pawnshop:requestShops')
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerServerEvent('tp-pawnshop:requestShops')
end)

RegisterNetEvent('tp-pawnshop:sendShops')
AddEventHandler('tp-pawnshop:sendShops', function(sv_activeShops, sv_saleItems)
    activeShops = sv_activeShops
    saleItems = sv_saleItems

    -- for i = 1, #activeShops do
    --     peds[i] = _CreatePed(Config.ShopPed, activeShops[i].x, activeShops[i].y, activeShops[i].z, activeShops[i].h)
    --     Citizen.Wait(10)
    -- end

end)

function _CreatePed(hash, x, y, z, heading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end
    local bool, groundZ = GetGroundZFor_3dCoord_2(x, y, z+2)
    local ped = CreatePed(5, hash, x, y, groundZ, true, true)
    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    FreezeEntityPosition(ped, true)
    return ped
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        for k,v in pairs(activeShops) do
            for i = 1, #activeShops, 1 do
                local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, activeShops[i].x, activeShops[i].y, activeShops[i].z, true)
                if (distance < 1.5) and insideMarker == false then
                    DrawMarker(Config.ShopMarker, activeShops[i].x, activeShops[i].y, activeShops[i].z-0.985, 0.0, 0.0, 0.0, 0.0, 0, 0.0, Config.ShopMarkerScale.x, Config.ShopMarkerScale.y, Config.ShopMarkerScale.z, Config.ShopMarkerColor.r,Config.ShopMarkerColor.g,Config.ShopMarkerColor.b,Config.ShopMarkerColor.a, false, false, 2, false, false, false, false)
                end
                if (distance < 1.0) and insideMarker == false then
                    DrawText3Ds(activeShops[i].x, activeShops[i].y, activeShops[i].z, Config.ShopDraw3DText)
                    if IsControlJustPressed(0, 38) then
                        OpenPawnShop(i)
                        insideMarker = true
                        Citizen.Wait(500)
                    end
                end
            end
        end
    end
end)

function OpenPawnShop(shopNumber)
    -- print(shopNumber)
    local player = PlayerPedId()
    FreezeEntityPosition(player, true)
    local elements = {}

    for k,v in pairs(saleItems) do
        if v.shop == shopNumber then
            table.insert(elements, {
                label = v.Label .. " | "..('<span style="color:green;">%s</span>'):format("$"..v.SellPrice..""),
                itemName = v.itemName,
                SellPrice = v.SellPrice
            })
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tp-pawnshop-menu',
    {
        title = "Shady Buyer",
        align = "bottom-right",
        elements = elements
    },
    function(data, menu)
        if data.current.itemName == data.current.itemName then
            OpenSellDialogMenu(data.current.itemName, data.current.SellPrice)
        end
    end, function(data, menu)
        menu.close()
        insideMarker = false
        FreezeEntityPosition(player, false)
    end,function(data,menu)
    end)
end

function OpenSellDialogMenu(itemName, SellPrice)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'tp-pawnshop-menu-sell', {
		title = "Amount to Sell?"
	}, function(data, menu)
		menu.close()
		amountToSell = tonumber(data.value)
		totalSellPrice = (SellPrice * amountToSell)
        TriggerServerEvent("tp-pawnshop:SellItem",amountToSell,totalSellPrice,itemName)
        -- print(totalSellPrice)
	end,
	function(data, menu)
		menu.close()
	end)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 500
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

Citizen.CreateThread(function()
    local noteTemplate = Utils.DrawTextTemplate()
    noteTemplate.x = 0.5
    noteTemplate.y = 0.5
    local timer = 0
    while true do
        Citizen.Wait(0)
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        if not MissionStarted then
            local dist = Utils.GetVecDist(plyPos, Config.HintLocation)
            if dist < 10 then
            local p = Config.HintLocation
            Utils.DrawText3D(p.x,p.y,p.z, "Press [~r~E~s~] to knock on the door.")
            if IsControlJustPressed(0, Keys["E"]) and GetGameTimer() - timer > 150 then    
                timer = GetGameTimer()
                TaskGoStraightToCoord(plyPed, p.x, p.y, p.z, 10.0, 10, p.w, 0.5)
                Wait(3000)
                ClearPedTasksImmediately(plyPed)
    
                while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do RequestAnimDict("timetable@jimmy@doorknock@"); Citizen.Wait(0); end
                TaskPlayAnim( plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )     
                Citizen.Wait(0)
                while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do Citizen.Wait(0); end          
    
                Citizen.Wait(1000)
    
                TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true, args = {"Me", "You notice a small piece of paper slide under the door."}})
                ClearPedTasksImmediately(plyPed)
    
                local randNum = math.random(1,#activeShops)
                local spawnLoc = activeShops[randNum]
                local nearStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(spawnLoc.x,spawnLoc.y,spawnLoc.z))
                noteTemplate.text = "Find the buyer near "..nearStreet..".\nDon't be late."
    
                SetNewWaypoint(spawnLoc.x + math.random(10,20),spawnLoc.y + math.random(10,20))
    
                local timer = GetGameTimer()
                while (GetGameTimer() - timer) < (Config.NotificationTime * 1000) do
                Citizen.Wait(0)
                DrawSprite("commonmenu","", 0.5,0.53, 0.2,0.1,0.0, 125,125,125,200)
                Utils.DrawText(noteTemplate)
                end
                MissionStarted = true
            end
            end
        end
    end
end)

function PrintTableOrString(t, s)
    if t then
        if type(t) ~= 'table' then 
            print("^1 [^3debug^1] ["..type(t).."] ^7", t)
            return
        else
            for k, v in pairs(t) do
                local kfmt = '["' .. tostring(k) ..'"]'
                if type(k) ~= 'string' then
                    kfmt = '[' .. k .. ']'
                end
                local vfmt = '"'.. tostring(v) ..'"'
                if type(v) == 'table' then
                    PrintTableOrString(v, (s or '')..kfmt)
                else
                    if type(v) ~= 'string' then
                        vfmt = tostring(v)
                    end
                    print(" ^1[^3debug^1] ["..type(t).."]^7", (s or '')..kfmt, '=', vfmt)
                end
            end
        end
    else
        print("^1Error Printing Request - The Passed through variable seems to be nil^7")
    end
end