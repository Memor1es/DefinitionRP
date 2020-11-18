motels = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
Citizen.CreateThread(function(...) while not ESX do TriggerEvent('esx:getSharedObject',function(obj) ESX = obj; end); Citizen.Wait(0); end; end)

Config = {
  -- Don't change this. Notifies you of updates.
  __VERSION = "1.01",

  -- Distance to perform action/draw marker.
  ActDist = 2.0,
  DrawDist = 10.0,

  -- Make sure you set this if using onesync...
  UsingOneSync = false,

  -- Show blips for motels?
  ShowBlips = false,

  -- Home motel = all players get a free room, nobody can buy a room here.
  -- Make sure you set this before running the script.
  -- Don't change it unless you plan on clearing motel inventories.
  -- If no home motel, set to "None"
  -- If no home motel, make sure you set UseHomeMotel and SpawnInHomeMotel to false.
  HomeMotel = "none",

  -- Spawn players in home motel on login?
  UseHomeMotel = false,
  SpawnInHome = false,

  -- Probably wouldn't touch these...
  GridSpacing = 2.5,
  GridBoundaries = vector3(2.60,4.16,4.0),

  PoliceJobName = "police",

  RepaymentPercent = 20,

  -- Purchase room prices.
  Prices = {
    PinkCage = 1650,
    Bilingsgate = 955,
    Motoa = 685,
    Rancho = 795,
    VonCrastenburg = 955,
    DreamView = 1355,
    CrownJewels = 1199,
    BayviewLodge = 765,
    Eastern = 1095,
  },

  Motels = {
    PinkCage = {
      Location = vector3(326.29,-212.31,55.08),
      GridLocation = vector3(326.29,-212.31,10.0),
      GridWidth = 8,
      GridLength = 8,

      BlipCol     = 41,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "Pink Cage Motel",

      Entrys = {    
        vector4(312.8461, -218.8517, 54.2217, 341.8450),
        vector4(312.8461, -218.8517, 58.0192, 341.8450),
        vector4(310.7988, -218.1135, 54.2217, 341.8450),
        vector4(310.7988, -218.1135, 58.0192, 341.8450),
        vector4(307.2478, -216.6887, 54.2217, 341.8450),
        vector4(307.2478, -216.6887, 58.0192, 341.8450),
        vector4(307.4836, -213.2668, 54.2217, 249.6511),
        vector4(307.4836, -213.2668, 58.0192, 249.6511),
        vector4(309.5486, -207.9482, 54.2217, 249.6511),
        vector4(309.5486, -207.9482, 58.0192, 249.6511),
        vector4(311.2804, -203.4071, 54.2217, 249.6511),
        vector4(311.2804, -203.4071, 58.0192, 249.6511),
        vector4(313.2985, -198.0486, 54.2217, 249.6511),
        vector4(313.2985, -198.0486, 58.0192, 249.6511),
        vector4(315.6986, -194.7650, 54.2217, 162.3896),
        vector4(315.6986, -194.7650, 58.0192, 162.3896),
        vector4(319.3502, -196.1419, 54.2217, 162.3896),
        vector4(319.3502, -196.1419, 58.0192, 162.3896),
        --vector4(321.4276, -196.9552, 54.2217, 162.3896), Water in property
        --vector4(321.4276, -196.9552, 58.0192, 162.3896), Water in property
        vector4(329.4300, -225.0200, 54.2200, 341.8500), --Water in property
        vector4(331.4400, -225.9700, 54.2200, 341.8500),
        vector4(334.9700, -227.3600, 54.2200, 341.8500),
        vector4(337.0900, -224.8100, 54.2200, 249.6500),
        vector4(339.2100, -219.4500, 54.2200, 249.6500),
        vector4(340.8000, -214.8900, 54.2200, 249.6500),
        vector4(342.8800, -209.6000, 54.2200, 249.6500),
        vector4(344.5900, -205.0100, 54.2200, 162.3800),
        vector4(346.8100, -199.7300, 54.2200, 162.3800),
        vector4(329.4300, -225.0200, 58.0200, 341.8500),
        vector4(331.4400, -225.9700, 58.0200, 341.8500),
        vector4(334.9700, -227.3600, 58.0200, 341.8500),
        vector4(337.0900, -224.8100, 58.0200, 249.6500),
        vector4(339.2100, -219.4500, 58.0200, 249.6500),
        vector4(340.8000, -214.8900, 58.0200, 249.6500),
        vector4(342.8800, -209.6000, 58.0200, 249.6500),
        vector4(344.5900, -205.0100, 58.0200, 162.3800),
        vector4(346.8100, -199.7300, 58.0200, 162.3800),
      },
    },

    Bilingsgate = {
      Location = vector3(565.20,-1761.26,29.17),
      GridLocation = vector3(539.01,-1762.67,15.97),
      GridWidth = 5,
      GridLength = 5,

      BlipCol     = 53,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "Bilingsgate Motel",

      Entrys = {
        vector4(561.66,-1751.83,29.31,240.48),
        vector4(557.84,-1759.65,29.31,240.48),
        vector4(554.94,-1766.37,29.31,240.48),
        vector4(552.32,-1771.54,29.31,240.48),
        vector4(550.41,-1775.52,29.31,240.48),
        vector4(566.21,-1778.17,29.35,340.48),
        vector4(559.11,-1777.32,33.44,340.48),
        vector4(550.06,-1770.53,33.44,240.48),
        vector4(552.56,-1765.25,33.44,240.48),
        vector4(555.71,-1758.65,33.44,240.48),
        vector4(559.42,-1750.84,33.44,240.48),
        vector4(561.81,-1747.32,33.44,160.48),
      },
    },

    Rancho = {
      Location = vector3(361.95, -1798.7, 29.1),
      GridLocation = vector3(361.95, -1798.7, 10.1),
      GridWidth = 3,
      GridLength = 3,

      BlipCol     = 6,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "The Rancho Motel",

      Entrys = {
        vector4(372.3,-1791.44,29.1,52.8),
        vector4(367.49,-1802.21,29.07,138.35),
        vector4(379.24,-1811.95,29.05,138.1),
        vector4(398.29,-1789.68,29.17,320.21),
        vector4(380.63,-1813.25,29.05,139.71),
        vector4(405.37,-1795.74,29.01,360.61),
      },
    },

    VonCrastenburg = {
      Location = vector3(435.98, 215.37, 103.17),
      GridLocation = vector3(435.98, 215.37, 80.17),
      GridWidth = 3,
      GridLength = 3,

      BlipCol     = 7,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "Von Crastenburg Motel",

      Entrys = {
        vector4(484.20,212.30,104.74,246.74),
        vector4(482.34,207.18,104.74,243.99),
        vector4(486.67,201.17,104.74,336.93),
        vector4(507.41,193.61,104.75,342.35),
        vector4(513.81,191.29,104.75,333.12),
        vector4(520.98,192.95,104.74,065.31),
        vector4(522.87,198.14,104.74,065.41),
        vector4(526.34,207.70,104.74,066.18),
        vector4(528.67,214.06,104.74,063.98),
        vector4(526.72,226.56,104.74,157.79),
        vector4(520.16,229.01,104.74,156.43),
        vector4(510.59,232.50,104.74,155.57),
        vector4(504.20,234.80,104.74,154.31),
        vector4(497.65,237.19,104.74,156.32),
        vector4(489.99,228.17,104.74,243.29),
        vector4(487.76,221.79,104.74,245.92),
        vector4(484.29,212.32,108.31,334.59),
        vector4(482.39,207.08,108.31,241.81),
        vector4(486.61,201.25,108.31,240.76),
        vector4(507.44,193.63,108.31,334.96),
        vector4(513.80,191.31,108.31,335.46),
        vector4(520.91,193.00,108.31,063.99),
        vector4(522.88,198.15,108.31,066.17),
      },
    },

    DreamView =  {
      Location = vector3(-104.86, 6315.9, 31.58),
      GridLocation = vector3(-104.86, 6315.9, 10.58),
      GridWidth = 3,
      GridLength = 3,

      BlipCol     = 78,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "Dream View Motel",

      Entrys = {
        vector4(-84.89,6362.6,35.5,219.4),
        vector4(-90.21,6357.16,35.5,219.24),
        vector4(-93.52,6353.94,35.5,221.76),
        vector4(-98.99,6348.48,35.5,220.79),
        vector4(-102.21,6345.27,35.5,222.78),
        vector4(-107.61,6339.87,35.5,227.06),
        vector4(-106.73,6333.99,35.5,313.4),
        vector4(-103.49,6330.74,35.5,314.67),
        vector4(-84.85,6362.64,31.58,221.99),
        vector4(-90.23,6357.25,31.58,222.64),
        vector4(-93.5,6353.99,31.58,225.76),
        vector4(-107.59,6339.88,31.58,229.77),
        vector4(-106.75,6333.98,31.58,313.69),
        vector4(-103.47,6330.71,31.58,314.67),
        vector4(-120.23,6327.27,35.5,229.85),
        vector4(-114.3,6326.06,35.5,134.59),
        vector4(-111.04,6322.79,35.5,136.5),
        vector4(-120.19,6327.31,31.58,223.62),
        vector4(-114.34,6326.08,31.58,130.33),
        vector4(-111.11,6322.87,31.58,134.49), 
      },
    },

    CrownJewels = {
      Location = vector3(-1317.17, -939.03, 9.73),
      GridLocation = vector3(-1317.17, -939.03, -10.0),
      GridWidth = 3,
      GridLength = 3,

      BlipCol     = 60,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "Crown Jewels Motel",

      Entrys = {
        vector4(-1309.0,-931.23,13.36,195.52),
        vector4(-1309.04,-931.26,16.36,205.2),
        vector4(-1310.97,-931.9,16.36,202.03),
        vector4(-1318.03,-934.51,16.36,200.19),
        vector4(-1319.78,-935.12,16.36,195.97),
        vector4(-1329.41,-938.58,15.36,201.68),
        vector4(-1331.19,-939.3,15.36,194.77),
        vector4(-1338.25,-941.88,15.36,190.56),
        vector4(-1339.16,-941.41,15.36,289.13),
        vector4(-1319.81,-935.18,13.36,198.88),
        vector4(-1318.01,-934.53,13.36,199.41),
        vector4(-1310.91,-931.95,13.36,200.61),
        vector4(-1309.0,-931.23,13.36,192.03),
        vector4(-1329.37,-938.63,12.36,203.38),
        vector4(-1331.24,-939.33,12.36,199.42),
        vector4(-1338.3,-941.45,12.35,16.43),
        vector4(-1339.2,-941.4,12.35,101.41),
      },
    },

    BayviewLodge = {
      Location = vector3(-695.99, 5802.4, 17.33),
      GridLocation = vector3(-695.99, 5802.4, -3.33),
      GridWidth = 3,
      GridLength = 3,

      BlipCol     = 69,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "Bayview Lodge Motel",

      Entrys = {
        vector4(-681.93,5770.73,17.51,61.64),
        vector4(-683.74,5766.74,17.51,58.03),
        vector4(-685.59,5762.73,17.51,62.5),
        vector4(-687.43,5758.96,17.51,60.26),
        vector4(-694.23,5761.31,17.51,327.58),
        vector4(-681.93,5770.73,17.51,331.36),
        vector4(-698.17,5763.12,17.51,328.17),
        vector4(-702.1,5764.96,17.51,335.04),
        vector4(-706.01,5766.77,17.51,333.22),
        vector4(-709.94,5768.59,17.51,332.44),
      },
    },

    Eastern = {
      Location = vector3(317.33, 2623.21, 44.46),
      GridLocation = vector3(317.33, 2623.21, 25.46),
      GridWidth = 3,
      GridLength = 3,

      BlipCol     = 17,
      BlipSprite  = 475,
      BlipScale   = 1.0,
      BlipDisplay = 3,
      BlipText    = "Eastern Motel",

      Entrys = {
        vector4(341.65,2614.96,44.67,23.35),
        vector4(347.09,2618.03,44.67,27.34),
        vector4(354.44,2619.71,44.67,24.63),
        vector4(359.76,2622.87,44.67,21.57),
        vector4(367.1,2624.54,44.67,23.82),
        vector4(372.58,2627.6,44.67,30.03),
        vector4(379.87,2629.24,44.67,29.74),
        vector4(385.27,2632.36,44.67,22.79),
        vector4(392.58,2634.09,44.67,37.75),
        vector4(398.01,2637.01,44.67,33.42),
      },
    },
  },
}

mLibs = exports["meta_libs"]