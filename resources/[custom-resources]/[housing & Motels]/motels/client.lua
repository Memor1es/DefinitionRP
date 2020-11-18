motels.ownedRooms = {}

-- Don't touch these...
motels.inventOffset = vector3(1.40,-3.5,0.60)
motels.wardrobeOffset = vector3(-1.3,2.5,1.0)
-- Srs.

RegisterCommand('myid', function(...) print(PlayerId()); end)

motels.awake = function()
  while not ESX do Citizen.Wait(0); end
  while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
  motels.plyData = ESX.GetPlayerData()
  Wait(500)
  motels.start()
end

motels.start = function()
  ESX.TriggerServerCallback(GetCurrentResourceName()..':getStartData', function(data,id)
    motels.id = id

    for k,v in pairs(data) do
      motels.ownedRooms[v] = true
    end

    if Config.UseHomeMotel then
      if Config.SpawnInHome then
        DoScreenFadeOut(1)
        Wait(100)

        TriggerEvent('vSync:toggle',false)
        NetworkOverrideClockTime(20, 0, 0)

        local homeMotel = Config.Motels[Config.HomeMotel]
        local homeSpawn = motels.getSpawn(PlayerId(),homeMotel)
        local homeDoor = homeMotel.Entrys[math.max(1,PlayerId() % #homeMotel.Entrys + 1)]
        local homeExit = vector4(homeSpawn.x-1.6,homeSpawn.y-4.0,homeSpawn.z+0.5, 0.0)
        local interior = motels.createMotel(homeSpawn)
        local wardrobe = vector3(homeSpawn.x + motels.wardrobeOffset.x, homeSpawn.y + motels.wardrobeOffset.y, homeSpawn.z + motels.wardrobeOffset.z)
        --local inventory = vector3(homeSpawn.x + motels.inventOffset.x, homeSpawn.y + motels.inventOffset.y, homeSpawn.z + motels.inventOffset.z)

        local ped = GetPlayerPed(-1)
        SetEntityCoordsNoOffset(ped, homeExit.x,homeExit.y,homeExit.z)
        SetEntityHeading(ped, homeExit.w)
        Wait(500)

        local peds = ESX.Game.GetPeds({GetPlayerPed(-1)})
        for k,v in pairs(peds) do
          local dist = utils.vecDist(GetEntityCoords(v),homeExit.xyz)
          if dist < 10.0 and v ~= GetPlayerPed(-1) then
            SetEntityAsMissionEntity(v,true,true)
            DeleteEntity(v)
          end
        end

        DoScreenFadeIn(500)
        Wait(500)

        motels.curRoom = {
          spawn = homeSpawn,
          entry = homeDoor,
          exit = homeExit,
          --inventory = inventory,
          wardrobe = wardrobe,
          objects = interior
        }

        motels.ownedRooms[motels.curRoom.entry] = true
        motels.homeRoom = motels.curRoom.entry
      else
        local homeMotel = Config.Motels[Config.HomeMotel]
        local ent = homeMotel.Entrys[math.max(1,PlayerId() % #homeMotel.Entrys)]
        motels.ownedRooms[ent] = true
        motels.homeRoom = ent
      end
    end

    if Config.ShowBlips then motels.setupBlips(); end

    motels.update()
  end)
end

motels.setupBlips = function()
  for k,v in pairs(Config.Motels) do
    local blip = AddBlipForCoord(v.Location.x, v.Location.y, v.Location.z)
    SetBlipSprite               (blip, v.BlipSprite)
    SetBlipDisplay              (blip, v.BlipDisplay)
    SetBlipScale                (blip, 0.6)
    SetBlipColour               (blip, v.BlipCol)
    SetBlipAsShortRange         (blip, false)
    SetBlipHighDetail           (blip, true)
    BeginTextCommandSetBlipName ("STRING")
    AddTextComponentString      (v.BlipText)
    EndTextCommandSetBlipName   (blip)
  end
end

motels.getSpawn = function(id,motel)
  local maxX = motel.GridWidth
  local maxY = motel.GridLength
  local start = motel.GridLocation

  if Config.UsingOneSync then
    id = id - 128
  end

  local boundary = Config.GridBoundaries
  local spacing = math.max(2.5,Config.GridSpacing)

  local motelKey = 0
  local positions = {}
  for z=start.z,-math.huge,-(boundary.z*spacing) do
    for y=start.y,start.y+(boundary.y * spacing * maxY),boundary.y*spacing do
      for x=start.x,start.x+(boundary.x * spacing * maxX),boundary.x*spacing do
        if motelKey == id then 
          return vector3(x,y,z)
        else  
          motelKey = motelKey + 1
        end
      end
    end
  end
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  motels.plyData.job = job
end)

motels.update = function()
  while true do
    if motels.curRoom then
      local closestAct,actDist,actText = motels.getClosestAction(motels.curRoom)
      if actDist < Config.ActDist then
        ESX.ShowHelpNotification(actText)
        if IsControlJustPressed(0, 38) then
          motels.doAction(closestAct)
        end
      end
    else
      local closestZone,zoneDist = motels.getClosestZone()
      if zoneDist < 100.0 then
        local closestDoor,doorDist = motels.getClosestDoor(closestZone)
        if doorDist < Config.DrawDist then
          DrawMarker(3, closestDoor.x,closestDoor.y,closestDoor.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.2,0.2,0.2, 0,155,0,155, false,true) 

          if doorDist < Config.ActDist then
          	Draw3DText(closestDoor.x, closestDoor.y, closestDoor.z + 0.5, '[E] To Interact')
            --ESX.ShowHelpNotification("Press ~INPUT_PICKUP~ to interact.")
            if IsControlJustPressed(0, 38) then
              motels.doorLoop(closestDoor,closestZone)
            end
          end
        end
      end
    end
    Wait(0)
  end
end


motels.doorLoop = function(door,zone)
  local plyPos = GetEntityCoords(GetPlayerPed(-1))
  motels.busy = true
  ESX.TriggerServerCallback('motels:getOwner',function(owner)
    local _owner = owner
    while motels.busy do
      local dist = utils.vecDist(GetEntityCoords(GetPlayerPed(-1)),plyPos)
      if dist > 1.0 then motels.busy = false; end

      if motels.homeRoom ~= door and motels.ownedRooms[door] then
      	Draw3DText(door.x, door.y, door.z + 0.5, '[E] To enter / [G] To sell')
        --ESX.ShowHelpNotification("Press ~INPUT_DETONATE~ to enter.\nPress ~INPUT_VEH_HEADLIGHT~ to sell.")
        if IsControlJustPressed(0, 38) then
          motels.enterRoom(door,zone)
        elseif IsControlJustPressed(0, 47) then
          motels.sellRoom(door,zone)
        end
      elseif motels.ownedRooms[door] then
      	Draw3DText(door.x, door.y, door.z + 0.5, '[E] To enter')
        --ESX.ShowHelpNotification("Press ~INPUT_DETONATE~ to enter.")
        if IsControlJustPressed(0, 38) then
          motels.enterRoom(door,zone)
        end
      else
        if _owner then

          if motels.plyData and motels.plyData.job and motels.plyData.job.name == Config.PoliceJobName then
            Draw3DText(door.x, door.y, door.z + 0.5, '[E] To knock / [G] To raid')
            --ESX.ShowHelpNotification("Press ~INPUT_DETONATE~ to knock on the door.\nPress ~INPUT_VEH_HEADLIGHT~ to raid the property.")
            if IsControlJustPressed(0, 38) then
              motels.knockOnDoor(door,zone)            
            elseif IsControlJustPressed(0, 47) then
              motels.enterRoom(door,zone)
            end
          else
            Draw3DText(door.x, door.y, door.z + 0.5, '[E] To Knock On The Door')
            if IsControlJustPressed(0, 38) then
              motels.knockOnDoor(door,zone)
            end
          end

        else
          if zone ~= Config.HomeMotel then
          	Draw3DText(door.x, door.y, door.z + 0.5, 'Press [E] To Buy This Room ($'..Config.Prices[zone]..')')
            --ESX.ShowHelpNotification("Press ~INPUT_DETONATE~ to buy this room ($"..Config.Prices[zone]..")")
            if IsControlJustPressed(0, 38) then
              motels.buyRoom(door,zone)
            end
          else
          	--exports['mythic_notify']:SendAlert('error', 'No interactions available.', 7000)
            ESX.ShowHelpNotification("No interactions available.")
          end
        end
      end
      Wait(0)
    end
  end,zone,door)
  while motels.busy do Wait(0); end
end

motels.goToDoor = function(room)
  local p = room
  local plyPed = GetPlayerPed(-1)
  TaskGoStraightToCoord(plyPed, p.x, p.y, p.z, 10.0, 10, p.w, 0.5)
  local dist = 999
  local tick = 0
  while dist > 0.5 and tick < 10000 do
    local pPos = GetEntityCoords(plyPed)
    dist = utils.vecDist(pPos, p.xyz)
    tick = tick + 1
    Citizen.Wait(100)  
  end
  ClearPedTasksImmediately(plyPed)
end

motels.knockOnDoor = function(door,zone)
  motels.goToDoor(door)
  local plyPed = GetPlayerPed(-1)
  while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do RequestAnimDict("timetable@jimmy@doorknock@"); Citizen.Wait(0); end
  TaskPlayAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )     
  Citizen.Wait(0)
  while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do Citizen.Wait(0); end 
  TriggerServerEvent('motels:knock', door)
  exports['mythic_notify']:SendAlert('inform', 'You knocked on the door', 7000)
  --ESX.ShowNotification("You knocked on the door.")
end

motels.hasKnocked = function(door,id)
  if not motels.curRoom then return; end
  if motels.curRoom.entry and motels.curRoom.entry == door then
  	exports['mythic_notify']:SendAlert('inform', 'Somebody knocked on your door. Use /invin ID to let them in. [ID:' ..id.. ']', 15000)
    --ESX.ShowNotification("Somebody knocked on your door. Use /invin ID to let them in. [ID:~g~"..id..'~s~]')
  end
end

motels.inviteIn = function(source,args)
  if not motels.curRoom then 
    return   
  elseif not args or not args[1] then
  	exports['mythic_notify']:SendAlert('error', 'Enter an ID next time.', 7000)
    --ESX.ShowNotification("Enter an ID next time.")
  else
    TriggerServerEvent('motels:invitePlayer', args[1], motels.curRoom.entry, motels.curRoom.spawn)
  end
end

motels.inviteInside = function(door,spawn)
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local dist = utils.vecDist(pos,door)
  if dist < 20.0 then
    Citizen.CreateThread(function(...)
      local startTime = GetGameTimer()
      exports['mythic_notify']:SendAlert('inform', 'You where invited inside. Press [H] to accept.', 20000)
      --ESX.ShowNotification("You where invited inside. Press [~g~H~s~] to accept.")
      while (GetGameTimer() - startTime) < 8 * 1000 do
        if IsControlJustPressed(0, 104) then
          local zone,dist = motels.getClosestZone()
          motels.enterRoom(door,zone,spawn)
          return
        end
        Wait(0)
      end
    end)
  end
end

RegisterCommand('invin', motels.inviteIn)

motels.getClosestZone = function()
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local closest,closestDist
  for k,v in pairs(Config.Motels) do
    local dist = utils.vecDist(pos,v.Location)
    if not closestDist or dist < closestDist then
      closestDist = dist
      closest = k
    end
  end
  if closest and closestDist then
    return closest,closestDist
  else
    return false,999999
  end
end

motels.getClosestDoor = function(zone)
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local closest,closestDist
  for k,v in pairs(Config.Motels[zone].Entrys) do
    local dist = utils.vecDist(pos,v)
    if not closestDist or dist < closestDist then
      closestDist = dist
      closest = v
    end
  end
  if closest and closestDist then
    return closest,closestDist
  else
    return false,999999
  end
end

motels.getClosestAction = function(room)
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local closest,closestDist,actText

  local exitDist = utils.vecDist(room.exit, pos)
  closestDist = exitDist
  closest = "exit"
  actText = "Press ~INPUT_PICKUP~ to leave the room."

  --local inventDist = utils.vecDist(room.inventory, pos)
  --if not closestDist or inventDist < closestDist then
  --  closestDist = inventDist
  --  closest = "inventory"
  --  actText = "Press ~INPUT_PICKUP~ to access the inventory."
  --end

  local wardrobeDist = utils.vecDist(room.wardrobe, pos)
  if not closestDist or wardrobeDist < closestDist then
    closestDist = wardrobeDist
    closest = "wardrobe"
    actText = "Press ~INPUT_PICKUP~ to access the wardrobe."
  end

  if closest and closestDist and actText then
    return closest,closestDist,actText
  else
    return false,99999,false
  end
end

motels.doAction = function(action)
  if action == "exit" then
    motels.leaveRoom()
  elseif action == "wardrobe" then
    motels.wardrobeMenu()
  else
    local closestZone,zoneDist = motels.getClosestZone()
    --motels.openInventory(closestZone,motels.curRoom.entry)
  end
end

motels.enterRoom = function(door,zone,hSpawn)
  DoScreenFadeOut(500)
  Wait(600)

  TriggerEvent('vSync:toggle',false)
  NetworkOverrideClockTime(20, 0, 0)

  local motel = Config.Motels[zone]
  for k,v in pairs(motel.Entrys) do 
    if v == door then
      if not hSpawn then 
        hSpawn = motels.getSpawn(k,motel)
      end
    end
  end
  local spawn = (hSpawn  or motels.getSpawn(PlayerId(),motel))

  local motel = Config.Motels[zone]
  local spawn = (hSpawn or motels.getSpawn(PlayerId(),motel))
  local exit = vector4(spawn.x-1.6,spawn.y-4.0,spawn.z+0.5, 0.0)
  local interior = motels.createMotel(spawn)
  local wardrobe = vector3(spawn.x + motels.wardrobeOffset.x, spawn.y + motels.wardrobeOffset.y, spawn.z + motels.wardrobeOffset.z)
  --local inventory = vector3(spawn.x + motels.inventOffset.x, spawn.y + motels.inventOffset.y, spawn.z + motels.inventOffset.z)

  local ped = GetPlayerPed(-1)
  SetEntityCoordsNoOffset(ped, exit.x,exit.y,exit.z)
  SetEntityHeading(ped, exit.w)
  Wait(500)

  local peds = ESX.Game.GetPeds({GetPlayerPed(-1)})
  for k,v in pairs(peds) do
    local dist = utils.vecDist(GetEntityCoords(v),exit.xyz)
    if dist < 10.0 and v ~= GetPlayerPed(-1) then
      SetEntityAsMissionEntity(v,true,true)
      DeleteEntity(v)
    end
  end

  DoScreenFadeIn(500)
  Wait(600)

  motels.curRoom = {
    spawn = spawn,
    entry = door,
    exit = exit,
    --inventory = inventory,
    wardrobe = wardrobe,
    objects = interior,
  }
end

motels.leaveRoom = function()
  local room = motels.curRoom
  DoScreenFadeOut(500)
  Wait(500)

  TriggerEvent('vSync:toggle',true)
  TriggerServerEvent('vSync:requestSync')

  local ped = GetPlayerPed(-1)
  SetEntityCoordsNoOffset(ped, room.entry.x,room.entry.y,room.entry.z)
  SetEntityHeading(ped, room.entry.w)

  for k,v in pairs(room.objects) do
    SetEntityAsMissionEntity(v,true,true)
    DeleteEntity(v)
    DeleteObject(v)
  end

  DoScreenFadeIn(500)
  Wait(500)

  motels.curRoom = false
end

motels.buyRoom = function(door,zone)
  ESX.TriggerServerCallback('motels:tryBuy', function(canBuy,price)
    if canBuy then
      motels.ownedRooms[door] = true
      exports['mythic_notify']:SendAlert('success', 'You purchased this room', 10000)
      --ESX.ShowNotification("You purchased this room.")
    else
      exports['mythic_notify']:SendAlert('error', 'You cant afford this room', 20000)
      ESX.ShowNotification("You can't afford to buy this room.")
    end
  end,zone,door)
end

motels.sellRoom = function(door,zone)
  TriggerServerEvent('motels:sellDoor', zone,door)
  exports['mythic_notify']:SendAlert('inform', 'You sold your room', 20000)
  --ESX.ShowNotification("You sold your room.")
  motels.ownedRooms[door] = false
  motels.busy = false
  Wait(1000)
end

--[[ motels.openInventory = function(zone,door)  
  ESX.TriggerServerCallback('motels:getInventory', function(inventory)
    TriggerEvent("esx_inventoryhud:openPropertyInventory", inventory, false, {zone = zone, door = door})
  end,zone,door)  
end ]]

motels.wardrobeMenu = function()     
  local elements = {}
  elements[1] = {label = "Change Clothes",val="Change"}
  elements[2] = {label = "Delete Outfit",val="Delete"}

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
    title    = "Wardrobe",
    align    = 'top-left',
    elements = elements
  }, function(data, menu)
    ESX.TriggerServerCallback('motels:getPlayerDressing', function(d)
      local dressing = d
      if data.current.val == "Change" then
        local elements = {}
        for i=1, #dressing, 1 do
          table.insert(elements, {
            label = dressing[i],
            value = i
          })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'change_clothes', {
          title    = "Change Clothes",
          align    = 'top-left',
          elements = elements
        }, function(data2, menu2)
          TriggerEvent('skinchanger:getSkin', function(skin)
            ESX.TriggerServerCallback('motels:getPlayerOutfit', function(clothes)
              TriggerEvent('skinchanger:loadClothes', skin, clothes)
              TriggerEvent('esx_skin:setLastSkin', skin)

              TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
              end)
            end, data2.current.value)
          end)
        end, function(data2, menu2)
          menu2.close()
        end)
      elseif data.current.val == "Delete" then
        local elements = {}

        for i=1, #dressing, 1 do
          table.insert(elements, {
            label = dressing[i],
            value = i
          })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
          title    = "Delete Outfit",
          align    = 'top-left',
          elements = elements
        }, function(data2, menu2)
          menu2.close()
          TriggerServerEvent('motels:removeOutfit', data2.current.value)
          ESX.ShowNotification("Outfit deleted.")
        end, function(data2, menu2)
          menu2.close()
        end)
      end
    end)
  end, function(data, menu)
    menu.close()
  end)
end

motels.intModels = {
    shell     = `playerhouse_hotel`,
    stuff     = GetHashKey("v_49_motelmp_stuff"),
    winframe  = GetHashKey("v_49_motelmp_winframe"),
    winglass  = GetHashKey("v_49_motelmp_glass"),
    wincurt   = GetHashKey("v_49_motelmp_curtains"),
    bed       = GetHashKey("v_49_motelmp_bed"),       
    chair     = GetHashKey("prop_chair_04a"),       
    kettle    = GetHashKey("prop_kettle"),            
    cabinet   = GetHashKey("Prop_TV_Cabinet_03"),     
    tv        = GetHashKey("prop_tv_06"),             
    screen    = GetHashKey("v_49_motelmp_screen"),    
    toilet    = GetHashKey("Prop_LD_Toilet_01"),      
    sink      = GetHashKey("prop_sink_06"),           
    clock     = GetHashKey("Prop_Game_Clock_02"),     
    phone     = GetHashKey("v_res_j_phone"),          
    ironboard = GetHashKey("v_ret_fh_ironbrd"),       
    iron      = GetHashKey("prop_iron_01"),           
    mugA      = GetHashKey("V_Ret_TA_Mug"),           
    mugB      = GetHashKey("V_Ret_TA_Mug"),           
    resB      = GetHashKey("v_res_binder"),           
    clothes   = GetHashKey("v_49_motelmp_clothes"),   
    trainerA  = GetHashKey("v_res_fa_trainer02r"),    
    trainerB  = GetHashKey("v_res_fa_trainer02l"),      
    bag       = GetHashKey("p_ld_heist_bag_s_1"),
}

motels.intOffsets = {
    shell     = vector3(-0.70,-0.40, -1.3),
    stuff     = vector3( 0.00, 0.00, 0.00),
    winframe  = vector3( 0.74,-4.26, 1.11),
    winglass  = vector3( 0.74,-4.26, 1.13),
    wincurt   = vector3( 0.74,-4.15, 0.90),
    bed       = vector3( 1.40,-0.55,-0.05),
    chair     = vector3( 2.10,-2.40,-0.05),
    kettle    = vector3(-2.30, 0.60, 0.90),
    cabinet   = vector3(-2.30,-0.60, 0.00),
    tv        = vector3(-2.30,-0.60, 0.70),
    screen    = vector3(-2.21,-0.60, 0.79),
    toilet    = vector3( 2.10, 2.90, 0.00),
    sink      = vector3( 1.10, 4.00, 0.00),
    clock     = vector3(-2.55,-0.60, 2.00),
    phone     = vector3( 2.40,-1.90, 0.64),
    ironboard = vector3(-1.70, 3.50, 0.15),
    iron      = vector3(-1.90, 2.85, 0.63),
    mugA      = vector3(-2.30, 0.95, 0.90),
    mugB      = vector3(-2.20, 0.90, 0.90),
    resB      = vector3(-2.20, 1.30, 0.87),
    clothes   = vector3(-2.00, 2.00, 0.15),
    trainerA  = vector3(-1.90, 3.00, 0.38),
    trainerB  = vector3(-2.10, 2.95, 0.38),    
    bag       = vector3( 1.40,-3.50, 0.60),
}

motels.rotOffsets = {
  bag = vector3(-5.0, 15.0, 45.0),
}

motels.createObject = function(key,spawn,req)
  local offset = motels.intOffsets[key]
  local pos = vector3(spawn.x + offset.x, spawn.y + offset.y, spawn.z + offset.z)
  local model = motels.intModels[key]

  if req then
    RequestModel(model)
    while not HasModelLoaded(model) do RequestModel(model); Wait(1); end
  end 

  local obj = CreateObject(model, pos.x,pos.y,pos.z, false,false,false)

  if req then 
    Wait(100) 
    
  end

  SetModelAsNoLongerNeeded(model)

  if motels.rotOffsets[key] then
    local rot = motels.rotOffsets[key]
    SetEntityRotation(obj, rot.x,rot.y,rot.z, 2)
  end
  
  FreezeEntityPosition(obj,true)

  return obj
end

motels.createMotel = function(spawn)    
  local motel = {
    shell     = motels.createObject("shell",    spawn,  true),
    stuff     = motels.createObject("stuff",    spawn       ),
    winframe  = motels.createObject("winframe", spawn       ),
    winglass  = motels.createObject("winglass", spawn       ),
    wincurt   = motels.createObject("wincurt",  spawn       ),
    bed       = motels.createObject("bed",      spawn       ),
    chair     = motels.createObject("chair",    spawn       ),
    kettle    = motels.createObject("kettle",   spawn       ),
    cabinet   = motels.createObject("cabinet",  spawn       ),
    tv        = motels.createObject("tv",       spawn       ),
    screen    = motels.createObject("screen",   spawn       ),
    toilet    = motels.createObject("toilet",   spawn       ),
    sink      = motels.createObject("sink",     spawn       ),
    clock     = motels.createObject("clock",    spawn       ),
    phone     = motels.createObject("phone",    spawn       ),
    ironboard = motels.createObject("ironboard",spawn       ),
    iron      = motels.createObject("iron",     spawn       ),
    mugA      = motels.createObject("mugA",     spawn       ),
    mugB      = motels.createObject("mugB",     spawn       ),
    resB      = motels.createObject("resB",     spawn       ),
    clothes   = motels.createObject("clothes",  spawn       ),
    trainerA  = motels.createObject("trainerA", spawn       ),
    trainerB  = motels.createObject("trainerB", spawn       ),
    bag       = motels.createObject("bag",      spawn       ),
  }  

  SetEntityHeading( motel.chair,     GetEntityHeading(chair)     +270.0 )
  SetEntityHeading( motel.kettle,    GetEntityHeading(kettle)    +90.00 )
  SetEntityHeading( motel.cabinet,   GetEntityHeading(cabinet)   +90.00 )
  SetEntityHeading( motel.tv,        GetEntityHeading(tv)        +90.00 )
  SetEntityHeading( motel.toilet,    GetEntityHeading(toilet)    +270.0 )
  SetEntityHeading( motel.clock,     GetEntityHeading(clock)     +90.00 )
  SetEntityHeading( motel.phone,     GetEntityHeading(phone)     +220.0 )
  SetEntityHeading( motel.ironboard, GetEntityHeading(ironboard) +90.00 )
  SetEntityHeading( motel.iron,      GetEntityHeading(iron)      +230.0 )
  SetEntityHeading( motel.mugA,      GetEntityHeading(mugA)      +20.00 )
  SetEntityHeading( motel.mugB,      GetEntityHeading(mugB)      +230.0 )

  return motel
end

utils.thread(motels.awake)
utils.event(true,motels.hasKnocked,'motels:hasKnocked')
utils.event(true,motels.inviteInside,'motels:inviteInside')



function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
