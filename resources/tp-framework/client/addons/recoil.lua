-- No Headshots
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    Citizen.Wait(5000)
    ped = PlayerPedId()
    SetPedSuffersCriticalHits(ped, false)
end)


local recoils = {
--[[ 	[453432689] = 0.3, -- PISTOL
	[3219281620] = 0.3, -- PISTOL MK2
	[1593441988] = 0.2, -- COMBAT PISTOL
	[584646201] = 0.1, -- AP PISTOL
	[2578377531] = 0.6, -- PISTOL .50
	[324215364] = 0.2, -- MICRO SMG
	[736523883] = 0.1, -- SMG
	[2024373456] = 0.1, -- SMG MK2
	[4024951519] = 0.1, -- ASSAULT SMG
	[3220176749] = 0.2, -- ASSAULT RIFLE
	[961495388] = 0.2, -- ASSAULT RIFLE MK2
	[2210333304] = 1.0, -- CARBINE RIFLE
	[4208062921] = 1.0, -- CARBINE RIFLE MK2
	[2937143193] = 0.1, -- ADVANCED RIFLE
	[2634544996] = 0.1, -- MG
	[2144741730] = 0.1, -- COMBAT MG
	[3686625920] = 0.1, -- COMBAT MG MK2
	[487013001] = 0.4, -- PUMP SHOTGUN
	[1432025498] = 0.35, -- PUMP SHOTGUN MK2
	[2017895192] = 0.7, -- SAWNOFF SHOTGUN
	[3800352039] = 0.4, -- ASSAULT SHOTGUN
	[2640438543] = 0.2, -- BULLPUP SHOTGUN
	[911657153] = 0.1, -- STUN GUN
	[100416529] = 0.5, -- SNIPER RIFLE
	[205991906] = 0.7, -- HEAVY SNIPER
	[177293209] = 0.6, -- HEAVY SNIPER MK2
	[856002082] = 1.2, -- REMOTE SNIPER
	[2726580491] = 1.0, -- GRENADE LAUNCHER
	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE
	[2982836145] = 0.0, -- RPG
	[1752584910] = 0.0, -- STINGER
	[1119849093] = 0.01, -- MINIGUN
	[3218215474] = 0.2, -- SNS PISTOL
	[1627465347] = 0.1, -- GUSENBERG
	[3231910285] = 0.2, -- SPECIAL CARBINE
	[-1768145561] = 0.15, -- SPECIAL CARBINE MK2
	[3523564046] = 0.5, -- HEAVY PISTOL
	[2132975508] = 0.2, -- BULLPUP RIFLE
	[-2066285827] = 0.15, -- BULLPUP RIFLE MK2
	[137902532] = 0.4, -- VINTAGE PISTOL
	[2828843422] = 0.7, -- MUSKET
	[984333226] = 0.2, -- HEAVY SHOTGUN
	[3342088282] = 0.3, -- MARKSMAN RIFLE
	[1785463520] = 0.25, -- MARKSMAN RIFLE MK2
	[1672152130] = 0, -- HOMING LAUNCHER
	[1198879012] = 0.9, -- FLARE GUN
	[171789620] = 0.2, -- COMBAT PDW
	[3696079510] = 0.9, -- MARKSMAN PISTOL
	[1834241177] = 2.4, -- RAILGUN
	[3675956304] = 0.3, -- MACHINE PISTOL
	[3249783761] = 1.0, -- REVOLVER
	[-879347409] = 0.6, -- REVOLVER MK2
	[4019527611] = 0.7, -- DOUBLE BARREL SHOTGUN
	[1649403952] = 0.3, -- COMPACT RIFLE
	[317205821] = 0.2, -- AUTO SHOTGUN
	[125959754] = 0.5, -- COMPACT LAUNCHER
    [3173288789] = 0.1, -- MINI SMG ]]

    [-1716589765] = 1.0, -- .50 PISTOL

	[-2084633992] = 0.2, -- CARBINE
	[-1074790547] = 0.5, -- ASSAULT RIFLE
	[-86904375] = 0.2, -- CARBINE MK2

    [-1746263880] = 0.7, -- DOUBLE ACTION REVOLVER
    [453432689] = 0.4,      -- PISTOL
    [-1075685676] = 0.4,    -- PISTOL MK2
}



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if IsPedShooting(PlayerPedId()) and not IsPedDoingDriveby(PlayerPedId()) then
            local _,wep = GetCurrentPedWeapon(PlayerPedId())
            local dmg = GetWeaponDamage(wep, false)
            -- print(tostring(wep), "hihi")
            -- print(tostring(dmg), "hello")
			-- _,cAmmo = GetAmmoInClip(PlayerPedId(), wep)
            if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0
				if GetFollowPedCamViewMode() ~= 4 then
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						SetGameplayCamRelativePitch(p+0.1, 1.0)
						tv = tv+0.1
					until tv >= recoils[wep]
				else
					repeat 
						Wait(0)
						p = GetGameplayCamRelativePitch()
						if recoils[wep] > 0.1 then
							SetGameplayCamRelativePitch(p+0.6, 1.2)
							tv = tv+0.6
						else
							SetGameplayCamRelativePitch(p+0.016, 0.333)
							tv = tv+0.1
						end
					until tv >= recoils[wep]
				end
			end
        elseif IsPedShooting(PlayerPedId()) and IsPedDoingDriveby(PlayerPedId()) then
            local _,wep = GetCurrentPedWeapon(PlayerPedId())
			-- _,cAmmo = GetAmmoInClip(PlayerPedId(), wep)
            if recoils[wep] and recoils[wep] ~= 0 then
				tv = 0
                if GetFollowPedCamViewMode() ~= 4 then
                    repeat 
                        Wait(0)
                        p = GetGameplayCamRelativePitch()
                        -- print(p)
						SetGameplayCamRelativePitch(p+3.0, 1.0)
						tv = tv+0.2
					until tv >= recoils[wep]
				else
					repeat 
                        Wait(0)
                        p = GetGameplayCamRelativePitch()
                        -- print(p)
                        if recoils[wep] > 0.1 then
                            SetGameplayCamRelativePitch(p+100.0, 1.0)
							tv = tv+0.1
                        else
							SetGameplayCamRelativePitch(p+0.016, 0.333)
							tv = tv+0.1
						end
					until tv >= recoils[wep]
				end
			end
        end
	end
end)


-- stop shooting behind you fucks
function lookingBehind()
	local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
	local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, drp_driveby.dist, 0.0)
    --DrawMarker(1,coordB,0,0,0,0,0,0,1.001,1.0001,0.4001,0,155,255,175,0,0,0,0)
    local onScreen,_x,_y=World3dToScreen2d(coordB.x,coordB.y,coordB.z)
   	return onScreen
end


drp_driveby = {}
drp_driveby['driveby'] = true -- can anybody shoot?
drp_driveby['driver'] = true  -- can driver shoot?
drp_driveby['rear'] = false -- can shoot behind?
drp_driveby['dist'] = -8.0 -- how far behind the ped is the cut off point? (the closer it is, the less backwards they will be able to shoot)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			local canshoot = true
			if drp_driveby.driver == false then
				local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
				if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
					canshoot = false -- no shooty shooty driver
				end
			end
			if drp_driveby.driveby == false then
				canshoot = false -- no shooty shooty ever
			end
			if canshoot and not drp_driveby.rear then
				canshoot = not lookingBehind()
			end

			SetPlayerCanDoDriveBy(PlayerId(), canshoot)
		end
	end
end)

SetPlayerCanDoDriveBy(PlayerId(), true)