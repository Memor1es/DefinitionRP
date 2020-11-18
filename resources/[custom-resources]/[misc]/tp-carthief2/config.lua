-- Raymond Calitri

Config = {}
Config.DrawDistance = 100.0
Config.CopsRequired = 0
Config.BlipUpdateTime = 50 --In milliseconds. I used it on 3000. If you want instant update, 50 is more than enough. Even 100 is good. I hope it doesn't kill FPS and the server.
Config.CooldownMinutes = 10
Config.DespawnTimerMinutes = 20
Config.WaitTime = 5000 -- Time to wait for job from Ray
Config.TrackerTimeMinutes = 0.25 -- Length of Police Tracking Time
Config.DamageMultiplier = 50
Config.RaymondLoc = {['x'] =753.38354492188, ['y'] =-3182.0593261719, ['z'] =7.4057788848877}

Config.Cars = {
    [1] = "ADDER",
    [2] = "ZENTORNO",
    [3] = "NERO",
    [4] = "T20",
}

Config.SpawnLocations = { -- For testing
    [1] = {['x'] = 772.39233398438, ['y'] = -3188.9655761719, ['z'] = 5.900815486908, ['h'] = 0.0, ['info'] = " near the docks."},
}

Config.DeliveryLocations = { -- For testing
    -- [1] = {['x'] = 894.20526123047, ['y'] = -1021.053527832, ['z'] = 34.96647644043, ['h'] = 0.0, ['info'] = " opposite racers edge."},
    [1] = {['x'] = 772.39233398438, ['y'] = -3188.9655761719, ['z'] = 5.900815486908, ['h'] = 0.0, ['info'] = " near the docks."},
}