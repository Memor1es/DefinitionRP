-- Raymond Calitri

Config = {}

Config.DrawDistance = 100.0
Config.CopsRequired = 2
Config.BlipUpdateTime = 3000 --In milliseconds. I used it on 3000. If you want instant update, 50 is more than enough. Even 100 is good. I hope it doesn't kill FPS and the server.
Config.CooldownMinutes = 10
Config.WaitTime = 3000 -- Time to wait for job from Ray
Config.PoliceTrackingTime = 5000 -- Length of Police Tracking Time
Config.RaymondLoc = {['x'] =753.38354492188, ['y'] =-3182.0593261719, ['z'] =7.4057788848877}


Config.Cars = {
    [1] = "ADDER",
    [2] = "ZENTORNO",
    [3] = "NERO",
    [4] = "T20",
    [5] = "INFERNUS"
}

--[[ Config.Locations = {
    [1] = {['x'] = 784.24627685547, ['y'] = -3095.0007324219, ['z'] = 5.8004751205444, ['h'] = 0.0, ['info'] = " near the docks."},
    [2] = {['x'] = 784.24627685547, ['y'] = -3095.0007324219, ['z'] = 5.8004751205444, ['h'] = 0.0, ['info'] = " near the docks."},
    [3] = {['x'] = 784.24627685547, ['y'] = -3095.0007324219, ['z'] = 5.8004751205444, ['h'] = 0.0, ['info'] = " near the docks."},
    [4] = {['x'] = 784.24627685547, ['y'] = -3095.0007324219, ['z'] = 5.8004751205444, ['h'] = 0.0, ['info'] = " near the docks."},
    [5] = {['x'] = 784.24627685547, ['y'] = -3095.0007324219, ['z'] = 5.8004751205444, ['h'] = 0.0, ['info'] = " near the docks."},
} ]]

Config.Locations = { -- For testing
    [1] = {['x'] = 743.26440429688, ['y'] = -3175.66796875, ['z'] = 5.900541305542, ['h'] = 0.0, ['info'] = " near the docks."},
}