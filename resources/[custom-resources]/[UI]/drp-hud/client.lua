ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

local toghud = true
local enableCruise = false
local setSpeed = 0
local seatbeltIsOn = false

-- Compass and Time
local directions = { [0] = '', [1] = '', [2] = '', [3] = '', [4] = '', [5] = '', [6] = '', [7] = '', [8] = '' } 
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
local timeText = ""
local locationText = ""
local locationColorText = {255, 255, 255}   -- Color used to display location and time

RegisterCommand('hud', function(source, args, rawCommand)
    toghud = not toghud
end)

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)
    if show == true then
        toghud = true
    else
        toghud = false
    end
end)

Citizen.CreateThread(function()
    while true do
        if toghud == true then
            if (not IsPedInAnyVehicle(PlayerPedId(), false) )then
                DisplayRadar(0)
            else
                DisplayRadar(1)
            end
        else
            DisplayRadar(0)
        end
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                TriggerEvent('esx_status:getStatus','stress',function(stress)
                    local myhunger = hunger.getPercent()
                    local mythirst = thirst.getPercent()
                    local mystress = stress.getPercent()
                    SendNUIMessage({
                        action = "updateStatusHud",
                        show = toghud,
                        hunger = myhunger,
                        thirst = mythirst,
                        stress = mystress,
                    })
                end)
            end)
        end)
        Citizen.Wait(5000)
    end
end)

RegisterNetEvent('drp-hud:setOxygen')
AddEventHandler('drp-hud:setOxygen', function(show, oxygen)
    if show then
        SendNUIMessage({
            action = 'inWater',
            oxygen = oxygen,
        })
    else
        SendNUIMessage({
            action = 'outWater',
        })
    end
end)

-- STATUS HUD THREAD
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local player = PlayerPedId()
        local health = (GetEntityHealth(player) - 100)
        local armor = GetPedArmour(player)
        local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
        SendNUIMessage({
            action = 'updateStatusHud',
            show = toghud,
            health = health,
            armour = armor,
            stamina = stamina,
        })
    end
end)

-- VEHICLE HUD THREAD
local lastInCarFrame = false
local currInCarFrame = false
Citizen.CreateThread(function()
	while true do
        local Ped = GetPlayerPed(-1)
        local pedInVeh = IsPedInAnyVehicle(Ped)
        lastInCarFrame = currInCarFrame -- store last frame
        if(pedInVeh) then
            -- drawTxt(timeText, 4, locationColorText, 0.4, 0.2, 0.2 + 0.018) -- Time
            -- Display heading, street name and zone when possible
            drawTxt(locationText, 4, locationColorText, 1.0, 0.5, 0.05) -- Will have to consider converting this to nui to drop ms
            currInCarFrame = true
            if lastInCarFrame == false and currInCarFrame == true then
                SendNUIMessage({
                    action = "inCar"
                })
            end
			local PedCar = GetVehiclePedIsIn(Ped, false)
            if PedCar and (GetPedInVehicleSeat(PedCar, -1) == Ped or GetPedInVehicleSeat(PedCar, 0) == Ped) then
                
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 2.23694)
				fuel = GetVehicleFuelLevel(PedCar)

				SendNUIMessage({
                    action = "updateCarHud",
					showhud = true,
					speed = carSpeed,
					showfuel = true,
                    fuel = fuel,
                    cruise = enableCruise,
                    seatbelt = seatbeltIsOn
				})
			else
				SendNUIMessage({
                    action = "updateCarHud",
					showhud = false
				})
			end
        else
            if currInCarFrame == true and lastInCarFrame == true then
                currInCarFrame = false
                lastInCarFrame = false
                SendNUIMessage({
                    action = "outCar"
                })
            end
			SendNUIMessage({
                action = "updateCarHud",
				showhud = false
			})
		end
		Citizen.Wait(5)
	end
end)

local currLevel = 2
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if IsControlJustPressed(1, 20) then
            currLevel =  exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:mode')
            if currLevel > 3 then
                currLevel = 1
            end
            if currLevel == 1 then
                SendNUIMessage({
                    action = 'setVoice',
                    voice = 66
                })
            elseif currLevel == 2 then
                SendNUIMessage({
                    action = 'setVoice',
                    voice = 33
                })
            elseif currLevel == 3 then
                SendNUIMessage({
                    action = 'setVoice',
                    voice = 100
                })
            end
        end
        --[[ isTalking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking')
        if isTalking ~= nil then
            SendNUIMessage({
                action = 'talking',
                isTalking = isTalking
            })
        end ]]
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Citizen.Wait(1500)
    SendNUIMessage({
        action = 'setVoice',
        voice = 66
    })
    SendNUIMessage({
        action = 'charLoaded'
    })
end)

RegisterCommand('showUI', function(source, args, raw)
    SendNUIMessage({
        action = 'charLoaded'
    })
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)  
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local speed = math.floor(GetEntitySpeed(vehicle) * 2.236936)
        Citizen.Wait(5)
        if IsPedInAnyVehicle(ped) then
            local seatOne = GetPedInVehicleSeat(vehicle, -1)
            local seatTwo = GetPedInVehicleSeat(vehicle, 0)

            if ((seatOne == ped or seatTwo == ped)) then
                if ((IsControlJustPressed(0, 29) and seatOne ~= nil and seatOne == ped)) then
                    if enableCruise == false then 
                        enableCruise = true 
                        cruiseSpeed = GetEntitySpeed(vehicle) 
                        SetEntityMaxSpeed(vehicle, cruiseSpeed)
                    else 
                        enableCruise = false 
                        maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
                        SetEntityMaxSpeed(vehicle, maxSpeed)
                    end
                end
                if ((IsControlJustPressed(1, 27) and seatOne ~= nil and seatOne == ped)) then
                    if enableCruise then
                        cruiseSpeed = cruiseSpeed + 2.10
                        SetEntityMaxSpeed(vehicle, cruiseSpeed)
                    end
                elseif ((IsControlJustPressed(1, 173) and seatOne ~= nil and seatOne == ped)) then
                    if enableCruise then
                        cruiseSpeed = cruiseSpeed - 2.10
                        SetEntityMaxSpeed(vehicle, cruiseSpeed)
                    end
                end
                if IsControlJustReleased(0, 311) then -- Check for bikes class 8
                    seatbeltIsOn = not seatbeltIsOn
                    if seatbeltPlaySound then
                        PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    end
                end
            end
        else
            seatbeltIsOn = false
            enableCruise = false
        end
    end
end)


-- TIME AND LOCATION STUFFS
-- thread to update strings
Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        local pedInVeh = IsPedInAnyVehicle(player)
        -- Update when player is in a vehicle or on foot (if enabled)
        if pedInVeh then
            -- Get player, position and vehicle
            local position = GetEntityCoords(player)

            -- Update time text string
            local hour = GetClockHours()
            local minute = GetClockMinutes()
            timeText = ("%.2d"):format((hour == 0) and 12 or hour) .. ":" .. ("%.2d"):format( minute) .. ((hour < 12) and " AM" or " PM")

            -- Get heading and zone from lookup tables and street name from hash
            local heading = directions[math.floor((GetEntityHeading(player) + 22.5) / 45.0)]
            local zoneNameFull = zones[GetNameOfZone(position.x, position.y, position.z)]
            local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
            
            -- Update location text string
            locationText = heading
            locationText = (streetName == "" or streetName == nil) and (locationText) or (locationText .. streetName)
            locationText = (zoneNameFull == "" or zoneNameFull == nil) and (locationText) or (locationText .. " | " .. zoneNameFull)

            -- Update every second
            Citizen.Wait(1000)
        else
            -- Wait until next frame
            Citizen.Wait(500)
        end
    end
end)

-- COMPASS

local compass = { cardinal={}, intercardinal={}}

-- Configuration. Please be careful when editing. It does not check for errors.
compass.show = true
compass.position = {x = 0.5, y = 0.03, centered = true}
compass.width = 0.3
compass.fov = 100
compass.followGameplayCam = true

compass.ticksBetweenCardinals = 5.0
compass.tickColour = {r = 255, g = 255, b = 255, a = 255}
compass.tickSize = {w = 0.001, h = 0.003}

compass.cardinal.textSize = 0.40
compass.cardinal.textOffset = 0.002
compass.cardinal.textColour = {r = 255, g = 255, b = 255, a = 255}

compass.cardinal.tickShow = true
compass.cardinal.tickSize = {w = 0.001, h = 0.012}
compass.cardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}

compass.intercardinal.show = true
compass.intercardinal.textShow = true
compass.intercardinal.textSize = 0.15
compass.intercardinal.textOffset = 0.002
compass.intercardinal.textColour = {r = 255, g = 255, b = 255, a = 255}

compass.intercardinal.tickShow = true
compass.intercardinal.tickSize = {w = 0.001, h = 0.006}
compass.intercardinal.tickColour = {r = 255, g = 255, b = 255, a = 255}
-- End of configuration

local compassToggle = false
RegisterCommand('compass', function()
    compassToggle = not compassToggle
end)

Citizen.CreateThread( function()
	if compass.position.centered then
		compass.position.x = compass.position.x - compass.width / 2
	end
	
	while true do
		Wait(5)
		if IsPedInAnyVehicle(PlayerPedId()) or compassToggle then
		
			local pxDegree = compass.width / compass.fov
			local playerHeadingDegrees = 0
			
			if compass.followGameplayCam then
				-- Converts [-180, 180] to [0, 360] where E = 90 and W = 270
				local camRot = Citizen.InvokeNative( 0x837765A25378F0BB, 0, Citizen.ResultAsVector() )
				playerHeadingDegrees = 360.0 - ((camRot.z + 360.0) % 360.0)
			else
				-- Converts E = 270 to E = 90
				playerHeadingDegrees = 360.0 - GetEntityHeading(PlayerPedId())
			end
			
			local tickDegree = playerHeadingDegrees - compass.fov / 2
			local tickDegreeRemainder = compass.ticksBetweenCardinals - (tickDegree % compass.ticksBetweenCardinals)
			local tickPosition = compass.position.x + tickDegreeRemainder * pxDegree
			
			tickDegree = tickDegree + tickDegreeRemainder
			
			while tickPosition < compass.position.x + compass.width do
				if (tickDegree % 90.0) == 0 then
					-- Draw cardinal
					if compass.cardinal.tickShow then
						DrawRect( tickPosition, compass.position.y, compass.cardinal.tickSize.w, compass.cardinal.tickSize.h, compass.cardinal.tickColour.r, compass.cardinal.tickColour.g, compass.cardinal.tickColour.b, compass.cardinal.tickColour.a )
					end
					
					drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, compass.position.y + compass.cardinal.textOffset, {
						size = compass.cardinal.textSize,
						colour = compass.cardinal.textColour,
						outline = true,
						centered = true
					})
				elseif (tickDegree % 45.0) == 0 and compass.intercardinal.show then
					-- Draw intercardinal
					if compass.intercardinal.tickShow then
						DrawRect( tickPosition, compass.position.y, compass.intercardinal.tickSize.w, compass.intercardinal.tickSize.h, compass.intercardinal.tickColour.r, compass.intercardinal.tickColour.g, compass.intercardinal.tickColour.b, compass.intercardinal.tickColour.a )
					end
					
					if compass.intercardinal.textShow then
						drawText( degreesToIntercardinalDirection( tickDegree ), tickPosition, compass.position.y + compass.intercardinal.textOffset, {
							size = compass.intercardinal.textSize,
							colour = compass.intercardinal.textColour,
							outline = true,
							centered = true
						})
					end
				else
					-- Draw tick
					DrawRect( tickPosition, compass.position.y, compass.tickSize.w, compass.tickSize.h, compass.tickColour.r, compass.tickColour.g, compass.tickColour.b, compass.tickColour.a )
				end
				
				-- Advance to the next tick
				tickDegree = tickDegree + compass.ticksBetweenCardinals
				tickPosition = tickPosition + pxDegree * compass.ticksBetweenCardinals
			end
		end
	end
end)

function drawText( str, x, y, style )
	if style == nil then
		style = {}
	end
	SetTextFont( (style.font ~= nil) and style.font or 0 )
	SetTextScale( 0.0, (style.size ~= nil) and style.size or 1.0 )
	SetTextProportional( 1 )
	if style.colour ~= nil then
		SetTextColour( style.colour.r ~= nil and style.colour.r or 255, style.colour.g ~= nil and style.colour.g or 255, style.colour.b ~= nil and style.colour.b or 255, style.colour.a ~= nil and style.colour.a or 255 )
	else
		SetTextColour( 255, 255, 255, 255 )
	end
	if style.shadow ~= nil then
		SetTextDropShadow( style.shadow.distance ~= nil and style.shadow.distance or 0, style.shadow.r ~= nil and style.shadow.r or 0, style.shadow.g ~= nil and style.shadow.g or 0, style.shadow.b ~= nil and style.shadow.b or 0, style.shadow.a ~= nil and style.shadow.a or 255 )
	else
		SetTextDropShadow( 0, 0, 0, 0, 255 )
	end
	if style.border ~= nil then
		SetTextEdge( style.border.size ~= nil and style.border.size or 1, style.border.r ~= nil and style.border.r or 0, style.border.g ~= nil and style.border.g or 0, style.border.b ~= nil and style.border.b or 0, style.border.a ~= nil and style.shadow.a or 255 )
	end
	if style.centered ~= nil and style.centered == true then
		SetTextCentre( true )
	end
	if style.outline ~= nil and style.outline == true then
		SetTextOutline()
	end
	SetTextEntry( "STRING" )
	AddTextComponentString( str )
	DrawText( x, y )
end

-- Helper function to draw text to screen
function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, 0.4)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextCentre(true)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end


function degreesToIntercardinalDirection( dgr )
	dgr = dgr % 360.0
	
	if (dgr >= 0.0 and dgr < 22.5) or dgr >= 337.5 then
		return "N "
	elseif dgr >= 22.5 and dgr < 67.5 then
		return "NE"
	elseif dgr >= 67.5 and dgr < 112.5 then
		return "E"
	elseif dgr >= 112.5 and dgr < 157.5 then
		return "SE"
	elseif dgr >= 157.5 and dgr < 202.5 then
		return "S"
	elseif dgr >= 202.5 and dgr < 247.5 then
		return "SW"
	elseif dgr >= 247.5 and dgr < 292.5 then
		return "W"
	elseif dgr >= 292.5 and dgr < 337.5 then
		return "NW"
	end
end