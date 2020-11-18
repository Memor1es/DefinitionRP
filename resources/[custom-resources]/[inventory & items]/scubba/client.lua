ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj 
		end)
		Citizen.Wait(0)
	end
end)

oxygenTank = 0.0
gearOn = false
attachedProp = 0
attachedProp2 = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	Citizen.Wait(2500)
	ESX.TriggerServerCallback('drp:getOxygenLevel', function(oxygen)
		oxygenTank = oxygen
	end)
end)

RegisterNetEvent('drp:applyScubaGear')
AddEventHandler('drp:applyScubaGear', function()
	if not gearOn then
		wearGear()
	else
		removeGear()
	end
end)

function wearGear()
	local vehFront = VehicleInFront()
	if vehFront > 0 then
		loadAnimDict('anim@narcotics@trash')
		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 3800, 49, 3.0, 0, 0, 0)		
		exports["t0sic_loadingbar"]:StartDelayedFunction('Putting on Scuba Gear', 4000, function() 
            loadAnimDict('anim@narcotics@trash')
			TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1900, 49, 3.0, 0, 0, 0)
			attachProps()
			-- TriggerEvent('menu:hasOxygenTank', true) -- F5 Menu
			gearOn = true
			TriggerEvent('drp-hud:setOxygen', true, oxygenTank)
		end)
	else
		exports['mythic_notify']:SendAlert('error', 'You need to be near a vehicle to do this.', 7000)
	end
end

function removeGear()
	-- TriggerEvent('menu:hasOxygenTank', false) -- F5 Menu
	gearOn = false
	removeAttachedProp()
	removeAttachedProp2()
	TriggerEvent('drp-hud:setOxygen', false, oxygenTank)
end

RegisterNetEvent('drp:scubbaIsGearOn')
AddEventHandler('drp:scubbaIsGearOn', function()
	if gearOn then
		TriggerServerEvent('drp:scubbaConfirmUseTank')
	else
		exports['mythic_notify']:SendAlert('error', 'You need to put your scuba gear on!' , 10000)
	end
end)


RegisterNetEvent('drp:useOxygenTank')
AddEventHandler('drp:useOxygenTank', function()
	local vehFront = VehicleInFront()
	if vehFront > 0 then
		loadAnimDict('anim@narcotics@trash')
		TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 3800, 49, 3.0, 0, 0, 0)		
		exports["t0sic_loadingbar"]:StartDelayedFunction('Refilling Tanks...', 4000, function() 
            loadAnimDict('anim@narcotics@trash')
			TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1900, 49, 3.0, 0, 0, 0)
			
			-- TriggerEvent('menu:hasOxygenTank', true) -- F5 Menu
			oxygenTank = 100.0
			TriggerEvent('drp-hud:setOxygen', true, oxygenTank)
		end)
	else
		exports['mythic_notify']:SendAlert('error', 'You need to be near a vehicle to do this.', 7000)
	end
end)

--[[ RegisterNetEvent("UseOxygenTank")
AddEventHandler("UseOxygenTank",function()
	oxygenTank = 100.0
    TriggerEvent('menu:hasOxygenTank', true) 
end) ]]


-- MAIN OXYGEN THREADS
Citizen.CreateThread(function()
	while true do
		Wait(1)
		-- print(oxygenTank)
		if gearOn then
			if oxygenTank > 0 and IsPedSwimmingUnderWater(PlayerPedId()) then
				SetPedDiesInWater(PlayerPedId(), false)
				if oxygenTank > 25.0 then
					oxygenTank = oxygenTank - 0.005
				else
					oxygenTank = oxygenTank - 0.0005
				end
				TriggerEvent('drp-hud:setOxygen', true, oxygenTank)
			else
				if oxygenTank <= 0 and IsPedSwimmingUnderWater(PlayerPedId()) then
					SetPedDiesInWater(PlayerPedId(), true)
					TriggerEvent('drp-hud:setOxygen', true, oxygenTank)
					oxygenTank = 0
				end
			end
		else
			Wait(1000)
		end
	end
end)
Citizen.CreateThread(function()
    while true do
	    Citizen.Wait(500)
		if IsPedSwimmingUnderWater(PlayerPedId()) then
			if gearOn then
				if oxygenTank <= 0.0 then
					exports['mythic_notify']:SendAlert('error', 'Tank Empty', 650)
				elseif oxygenTank <= 25.0 then
					exports['mythic_notify']:SendAlert('inform', 'Tank Level Dangerously Low ' ..(math.floor(oxygenTank * 10) / 10)..' units', 650)
				else
					exports['mythic_notify']:SendAlert('inform', 'Tank Level ' ..(math.floor(oxygenTank * 10) / 10)..' units', 650)
				end
				TriggerServerEvent('drp:updateOxygenLevels', oxygenTank)
			else
				SetPedDiesInWater(PlayerPedId(), true)
			end
		end
	end
end)

-- Debug Thread
--[[ Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		drawLine()
	end
end) ]]


-- FUNCTIONS

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end

function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0, -0.5)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0) -- Maybe this is incorrect, adjusting y and z values?
	local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

function drawLine()
	local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 3.0, -0.5)
	local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0) -- Maybe this is incorrect, adjusting y and z values?
	local a, b, c, d, result = GetRaycastResult(rayHandle)
	if (result == 0) then
		DrawLine(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 255, 10, 10, 255)
	else
		DrawLine(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, 255, 10, 255)
	end
end

function attachProps()
	attachProp("p_s_scuba_tank_s", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
	attachProp2("p_s_scuba_mask_s", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
end

function removeAttachedProp2()
	DeleteEntity(attachedProp2)
	attachedProp2 = 0
end

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end

function attachProp2(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp2()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp2 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp2, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(attachModel)
end

function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent 
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	SetModelAsNoLongerNeeded(attachModel)
end