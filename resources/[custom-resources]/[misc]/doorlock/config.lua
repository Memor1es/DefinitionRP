Config = {}
Config.Locale = 'en'

Config.DoorList = {

	--Pacific Vault
	{
		objName = 'v_ilev_bk_vaultdoor',
		objYaw = -200.0,
		objCoords  = vector3(255.228, 223.930, 102.426),
		textCoords = vector3(255.228, 223.930, 102.426),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police', 'offpolice' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_door01',
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 'v_ilev_ph_door002',
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objYaw = 90.0,
		objCoords  = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.1, -986.3, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 90.0,
		objCoords  = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.5, -986.0, 31.5),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	-- Armory
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -90.0,
		objCoords  = vector3(452.6, -982.7, 30.6),
		textCoords = vector3(453.0, -982.6, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	-- To downstairs (double doors)

	{
		textCoords = vector3(444.6, -989.4, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(443.9, -989.0, 30.6)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(445.3, -988.7, 30.6)
			}
		}
	},

	-- New doble doors (leading to downstair stuff near cells)

	{
		textCoords = vector3(465.5, -990.0, 25.4),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 90.0,
				objCoords = vector3(465.5, -989.1, 24.9)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = -90.0,
				objCoords = vector3(465.5, -990.4, 24.9)
			}
		}
	},

	{
		textCoords = vector3(452.0, -983.8, 26.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(450.7, -983.8, 26.8)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(453.7, -983.8, 26.8)
			}
		}
	},
	{
		textCoords = vector3(446.1, -986.6, 26.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = -90.0,
				objCoords = vector3(446.1, -987.7, 26.8)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 90.0,
				objCoords = vector3(446.1, -985.1, 26.8)
			}
		}
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = { 'police' },
		locked = true
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords  = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords  = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 18,
		size = 2
	},

	-------------
	-- Parsons --
	-------------

	{
		textCoords = vector3(-1477.41, 884.86, 182.88),
		authorizedJobs = { 'police', 'ambulance', 'offambulance' },
		locked = true,
		distance = 9,
		doors = {
			{
				objHash = -1918480350,
				objYaw = 79.0,
				objCoords  = vector3(-1477.2, 887.6, 183.0),
			},

			{
				objHash = -349730013,
				objYaw = 79.0,
				objCoords  = vector3(-1478.2, 882.2, 183.0),
			}
		}
	},

	----------------
	-- Courthouse --
	----------------

	{
        objHash = 1042741067,
        objCoords  = vector3(-558.0, -186.3, 38.3),
        textCoords = vector3(-557.7, -186.8, 38.2),
        objYaw = 120.0,
        authorizedJobs = {'lawyer'},
        locked = true
	},
	
	{
        objHash = 1042741067,
        objCoords  = vector3(-560.7, -196.7, 38.3),
        textCoords = vector3(-561.2, -197.1, 38.2),
        objYaw = 30.0,
        authorizedJobs = {'lawyer'},
        locked = true
    },


	---------------
	-- FlyWheels --
	---------------
	-- Front door
	{
		objHash = -725970636,
		objCoords  = vector3(1775.6, 3327.7, 41.4),
		textCoords = vector3(1775.9, 3327.2, 41.4),
		authorizedJobs = { 'flywheels' },
        locked = false,
        objYaw = 300.0,
	},

	-- Front office to staff
	{
		objHash = -538477509,
		objCoords  = vector3(1773.3, 3319.9, 41.6),
		textCoords = vector3(1773.0, 3320.4, 41.4),
		authorizedJobs = { 'flywheels' },
        locked = true,
        objYaw = 300.0,
	},

	-- Office to shopfloor
	{
		objHash = -538477509,
		objCoords  = vector3(1770.8, 3325.6, 41.5),
		textCoords = vector3(1771.4, 3325.8, 41.4),
		authorizedJobs = { 'flywheels' },
        locked = true,
        objYaw = 210.0,
	},

	-- Shop Floor back hallway
	{
		objHash = -538477509,
		objCoords  = vector3(1764.5, 3321.9, 41.5),
		textCoords = vector3(1765.1, 3322.1, 41.4),
		authorizedJobs = { 'flywheels' },
        locked = true,
        objYaw = 210.0,
	},

	-- Back hallway to staff
	{
		objHash = -538477509,
		objCoords  = vector3(1769.1, 3317.4, 41.6),
		textCoords = vector3(1768.7, 3318.0, 41.4),
		authorizedJobs = { 'flywheels' },
        locked = true,
        objYaw = 300.0,
	},

	-- Back door
	{
		objHash = -1859992197,
		objCoords  = vector3(1765.2, 3320.0, 41.4),
		textCoords = vector3(1764.8, 3320.5, 41.4),
		authorizedJobs = { 'flywheels' },
        locked = true,
        objYaw = 300.0,
	},

	---------------------
	-- Sandy Shores PD --
	---------------------

	-- Entrance
	
	{
		objHash = -1765048490,
		objCoords  = vector3(1855.7, 3683.9, 34.5),
		textCoords = vector3(1855.0, 3683.7, 34.2),
		authorizedJobs = { 'police', 'offpolice' },
        locked = false,
        objYaw = 30.0,
	},
	
	-- Bossman Office

	{
		objHash = -1765048490,
		objCoords  = vector3(1860.7, 3692.4, 34.5),
		textCoords = vector3(1860.1, 3691.9, 34.2),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 30.0,
    },

	-- Reception Single Door

	{
		objHash = -2023754432,
		objCoords  = vector3(1857.2, 3690.2, 34.4),
		textCoords = vector3(1856.6, 3689.9, 34.2),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 210.0,
    },

	-- Reception Double Door

	{
		textCoords = vector3(1848.3, 3690.5, 34.2),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 209.1,
				objCoords  = vector3(1849.4, 3691.2, 34.4),
			},

			{
				objHash = -2023754432,
				objYaw = 28.7,
				objCoords  = vector3(1847.1, 3689.9, 34.4)
			}
		}
	},

	-- Reception Left door to basement

	{
		textCoords = vector3(1850.5, 3682.9, 34.2),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 120.5,
				objCoords  = vector3(1851.2, 3681.8, 34.4),
			},

			{
				objHash = -2023754432,
				objYaw = 300.1,
				objCoords  = vector3(1849.9, 3684.1, 34.4)
			}
		}
	},

	-- Stairs down top

	{
		textCoords = vector3(1847.4, 3683.3, 34.2),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 210.3,
				objCoords  = vector3(1848.6, 3683.9, 34.4),
			},

			{
				objHash = -2023754432,
				objYaw = 29.9,
				objCoords  = vector3(1846.4, 3682.6, 34.4)
			}
		}
	},

	-- Stairs down bottom

	{
		textCoords = vector3(1847.6, 3683.1, 30.2),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 210.1,
				objCoords  = vector3(1848.6, 3683.9, 30.4),
			},

			{
				objHash = -2023754432,
				objYaw = 390.1,
				objCoords  = vector3(1846.4, 3682.6, 30.4)
			}
		}
	},

	-- Basement double doors

	{
		textCoords = vector3(1850.3, 3682.7, 30.2),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 120.4,
				objCoords  = vector3(1850.9, 3681.6, 30.4),
			},

			{
				objHash = -2023754432,
				objYaw = 299.8,
				objCoords  = vector3(1849.6, 3683.8, 30.4)
			}
		}
	},

	-- Basement Interview rooms

	{
		objHash = 749848321,
		objCoords  = vector3(1856.1, 3688.2, 30.4),
		textCoords = vector3(1855.7, 3687.9, 30.2),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 29.8,
	},
	
	{
		objHash = 749848321,
		objCoords  = vector3(1852.9, 3686.4, 30.4),
		textCoords = vector3(1852.3, 3686.0, 30.2),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 29.8,
    },


	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 12,
		size = 2
	},


	-- Reception Building Prison

	{
		objHash = -1033001619,
		objCoords  = vector3(1845.1, 2585.2, 46.0),
		textCoords = vector3(1845.4, 2585.9, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
        locked = false,
        objYaw = 89.8,
    },

	{
		objHash = -1033001619,
		objCoords  = vector3(1837.7, 2595.1, 46.0),
		textCoords = vector3(1837.5, 2594.6, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 270.4,
	},
	
	{
		objHash = -1033001619,
		objCoords  = vector3(1834.0, 2591.1, 46.0),
		textCoords = vector3(1834.0, 2591.7, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 89.9,
    },

	{
		objHash = -1033001619,
		objCoords  = vector3(1837.6, 2585.2, 46.0),
		textCoords = vector3(1837.6, 2586.0, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 89.9,
	},
	
	{
		objHash = -1033001619,
		objCoords  = vector3(1826.4, 2585.2, 46),
		textCoords = vector3(1826.4, 2585.9, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 89.9,
	},
	
	{
		objHash = -1033001619,
		objCoords  = vector3(1827.7, 2584.6, 46),
		textCoords = vector3(1828.3, 2584.5, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 300,
	},
	
	{
		objHash = -1033001619,
		objCoords  = vector3(1827.3, 2587.5, 46),
		textCoords = vector3(1828.0, 2587.5, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
        objYaw = 360,
	},
	
	{
		objHash = -1033001619,
		objCoords  = vector3(1819.1, 2593.6, 46.0),
		textCoords = vector3(1819.2, 2594.3, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.9,
    },

	-- Prison Block Main
	
	-- Reception
	-- Double Door

	{
		textCoords = vector3(1791.1, 2593.8, 46.1),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = 262839150,
				objYaw = 270.3,
				objCoords  = vector3(1791.1, 2592.5, 46.3),
			},

			{
				objHash = 1645000677,
				objYaw = 89.6,
				objCoords  = vector3(1791.0, 2595.1, 46.3)
			}
		}
	},

	-- Single doors

	{
		objHash = 262839150,
		objCoords  = vector3(1786.3, 2600.2, 46.0),
		textCoords = vector3(1785.7, 2600.1, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 360,
    },

	{
		objHash = 1028191914,
		objCoords  = vector3(1783.8, 2599.2, 45.9),
		textCoords = vector3(1784.0, 2598.4, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.9,
	},

	-- Kitchen

	{
		objHash = 1028191914,
		objCoords  = vector3(1782.3, 2595.8, 45.9),
		textCoords = vector3(1781.7, 2595.7, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 360,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1774.9, 2593.7, 45.9),
		textCoords = vector3(1775.1, 2593.0, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.9,
	},
	
	-- Cellblock
	-- Entry Door

	{
		objHash = 430324891,
		objCoords  = vector3(1785.8, 2590.0, 44.7),
		textCoords = vector3(1786.58, 2590.1, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},

	-- Cells
	-- 1
	{
		objHash = 430324891,
		objCoords  = vector3(1787.5, 2585.6, 44.7),
		textCoords = vector3(1787.5, 2586.3, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},
	-- 2
	{
		objHash = 430324891,
		objCoords  = vector3(1787.5, 2581.7, 44.7),
		textCoords = vector3(1787.5, 2582.4, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},
	-- 3
	{
		objHash = 430324891,
		objCoords  = vector3(1787.5, 2576.5, 44.7),
		textCoords = vector3(1787.6, 2578.5, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},
	-- 4
	{
		objHash = 430324891,
		objCoords  = vector3(1787.5, 2572.6, 44.7),
		textCoords = vector3(1787.7, 2574.7, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},
	-- 5
	{
		objHash = 430324891,
		objCoords  = vector3(1771.6, 2575.3, 44.7),
		textCoords = vector3(1771.8, 2573.5, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},
	-- 6
	{
		objHash = 430324891,
		objCoords  = vector3(1771.6, 2579.3, 44.7),
		textCoords = vector3(1771.7, 2577.5, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},
	-- 7
	{
		objHash = 430324891,
		objCoords  = vector3(1771.6, 2583.2, 44.7),
		textCoords = vector3(1771.7, 2581.4, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},
	-- 8
	{
		objHash = 430324891,
		objCoords  = vector3(1771.6, 2587.1, 44.7),
		textCoords = vector3(1771.7, 2585.2, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},

	-- Cellblock to Gym

	{
		objHash = 430324891,
		objCoords  = vector3(1773.1, 2589.6, 44.7),
		textCoords = vector3(1773.8, 2590.1, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = false,
		distance = 3,
		size = 2
	},

	-- Showerblock 

	{
		objHash = 430324891,
		objCoords  = vector3(1762.7, 2587.6, 44.7),
		textCoords = vector3(1763.4, 2587.5, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},

	-- Perma locked door upstairs

	{
		objHash = 1028191914,
		objCoords  = vector3(1771.5, 2571.6, 50.7),
		textCoords = vector3(1771.6, 2571.0, 50.6),
		authorizedJobs = { 'cardealerf' },
        locked = true,
		objYaw = 89.9,
	},

	-- Internal Tower

	{
		objHash = 1028191914,
		objCoords  = vector3(1780.3, 2596.0, 50.8),
		textCoords = vector3(1779.7, 2595.9, 50.7),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 120,
	},

	-- Upstairs double

	{
		textCoords = vector3(1779.8, 2601.8, 50.8),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = 1028191914,
				objYaw = 180.,
				objCoords  = vector3(1778.3, 2601.7, 50.8),
			},

			{
				objHash = 1028191914,
				objYaw = 360,
				objCoords  = vector3(1780.9, 2601.8, 50.8)
			}
		}
	},


	-- Solitary --

	-- airlock

	{
		objHash = 430324891,
		objCoords  = vector3(1767.3, 2607.4, 49.5),
		textCoords = vector3(1767.4, 2606.8, 50.6),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},

	{
		objHash = 430324891,
		objCoords  = vector3(1763.1, 2600.2, 49.5),
		textCoords = vector3(1763.9, 2600.2, 50.6),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 3,
		size = 2
	},

	-- Security room

	{
		objHash = 1028191914,
		objCoords  = vector3(1764.9, 2608.4, 50.7),
		textCoords = vector3(1764.9, 2607.6, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.7,
	},

	-- Soliatary Cells

	-- 1

	{
		objHash = 871712474,
		objCoords  = vector3(1765.1, 2597.6, 50.6),
		textCoords = vector3(1765.3, 2596.9, 50.6),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.7,
	},
	-- 2
	{
		objHash = 871712474,
		objCoords  = vector3(1765.1, 2594.7, 50.6),
		textCoords = vector3(1765.2, 2594.1, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.7,
	},
	-- 3
	{
		objHash = 871712474,
		objCoords  = vector3(1765.1, 2591.8, 50.6),
		textCoords = vector3(1765.0, 2591.1, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.7,
	},
	-- 4
	{
		objHash = 871712474,
		objCoords  = vector3(1765.1, 2588.8, 50.6),
		textCoords = vector3(1765.2, 2588.1, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 89.7,
	},
	-- 5
	{
		objHash = 871712474,
		objCoords  = vector3(1762.7, 2587.6, 50.6),
		textCoords = vector3(1762.7, 2588.3, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.4,
	},
	-- 6
	{
		objHash = 871712474,
		objCoords  = vector3(1762.7, 2590.6, 50.6),
		textCoords = vector3(1762.8, 2591.2, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.4,
	},
	-- 7
	{
		objHash = 871712474,
		objCoords  = vector3(1762.7, 2593.5, 50.6),
		textCoords = vector3(1762.8, 2594.2, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.4,
	},
	-- 8
	{
		objHash = 871712474,
		objCoords  = vector3(1762.7, 2596.5, 50.6),
		textCoords = vector3(1762.7, 2597.1, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.4,
	},

	-- Visitation --
	-- Upstairs single
	{
		objHash = 1028191914,
		objCoords  = vector3(1787.7, 2606.0, 50.7),
		textCoords = vector3(1787.5, 2606.5, 50.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.1,
	},

	-- Downstairs double 

	{
		textCoords = vector3(1785.7, 2609.7, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = 262839150,
				objYaw = 180.0,
				objCoords  = vector3(1784.5, 2609.6, 46.3),
			},

			{
				objHash = 1645000677,
				objYaw = 362.0,
				objCoords  = vector3(1787.1, 2609.7, 46.3)
			}
		}
	},

	-- Downstairs singles

	{
		objHash = 1028191914,
		objCoords  = vector3(1787.0, 2621.0, 45.9),
		textCoords = vector3(1786.4, 2621.0, 45.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 360.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1781.8, 2619.2, 46.1),
		textCoords = vector3(1781.9, 2618.5, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 90.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1781.9, 2613.5, 46.1),
		textCoords = vector3(1781.9, 2614.2, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1769.1, 2613.5, 46.1),
		textCoords = vector3(1769.2, 2614.2, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1766.8, 2615.4, 46.1),
		textCoords = vector3(1766.3, 2615.3, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 360.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1763.4, 2617.4, 46.1),
		textCoords = vector3(1763.3, 2616.7, 45.9),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 90.0,
	},

	{
		objHash = 1645000677,
		objCoords  = vector3(1759.9, 2614.6, 45.9),
		textCoords = vector3(1759.8, 2615.4, 45.5),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.0,
	},

	-- Guards block
	{
		objHash = 1028191914,
		objCoords  = vector3(1785.9, 2566.8, 45.9),
		textCoords = vector3(1785.1, 2566.8, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 360.0,
	},

	{
		objHash = 1645000677,
		objCoords  = vector3(1776.1, 2551.3, 46.0),
		textCoords = vector3(1776.0, 2552.0, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1784.6, 2550.2, 45.9),
		textCoords = vector3(1785.3, 2550.3, 45.8),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 180.0,
	},

	{
		objHash = 262839150,
		objCoords  = vector3(1791.6, 2551.3, 46.0),
		textCoords = vector3(1791.6, 2551.8, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 270.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1783.1, 2548.6, 45.9),
		textCoords = vector3(1783.2, 2547.9, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 90.0,
	},

	{
		objHash = 1028191914,
		objCoords  = vector3(1782.0, 2545.4, 45.9),
		textCoords = vector3(1781.3, 2545.3, 45.7),
		authorizedJobs = { 'police', 'offpolice' },
        locked = true,
		objYaw = 360.0,
	},

	--[[ car dealer gates
	{
		objName = 'prop_facgate_08',
		objCoords  = vector3(-37.5, -1075.7, 25.7),
		textCoords = vector3(-37.5, -1078.7, 27.7),
		authorizedJobs = { 'cardealer' },
		locked = false,
		distance = 12,
		size = 2
	},
	{
		objName = 'prop_facgate_08',
		objCoords  = vector3(-20.8, -1117.6, 25.9),
		textCoords = vector3(-23.8, -1117.6, 27.9),
		authorizedJobs = { 'cardealer' },
		locked = false,
		distance = 12,
		size = 2
	},
	--]]
	

	-- Side entrance doors
	
	{
		objName = 'v_ilev_ph_gendoor005',
		objYaw = 90.0,
		objCoords  = vector3(450.1, -981.4, 30.8),
		textCoords = vector3(450.1, -982.2, 31.0),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,


	},		
	{
		objName = 'v_ilev_ph_gendoor005',
		objCoords  = vector3(450.1, -984.0, 30.8),
		textCoords = vector3(450.1, -984.0, -100.8),
		objYaw = -90.0,
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,


	},	
	{
		objHash = -305065920,
		objCoords  = vector3(946.2, -984.7, 41.5),
		textCoords = vector3(946.2, -984.3, 40.3),
		--objYaw = -90.0,
		authorizedJobs = { 'racersedge', 'offracersedge', 'police', 'offpolice'},
		locked = true,
		distance = 14,
		size = 1


	},


	----------------------

	{
		objName = 'v_ilev_roc_door3',
		objCoords  = vector3(948.7, -964.4, 39.8),
		textCoords = vector3(948.7, -963.8, 40.2),
		objYaw = 90.0,
		authorizedJobs = { 'racersedge', 'offracersedge', 'police', 'offpolice' },
		locked = true,


	},
	{
		objName = 'v_ilev_roc_door2',
		objCoords  = vector3(955.6, -971.5, 39.9),
		textCoords = vector3(955.0, -971.5, 40.2),
		objYaw = 180.0,
		authorizedJobs = { 'racersedge', 'offracersedge', 'police', 'offpolice'},
		locked = true,


	},	

	--
	-- Addons
	--
	
	-- Entrance Gate (Mission Row mod) https://www.gta5-mods.com/maps/mission-row-pd-ymap-fivem-v1
	{
		objName = 'prop_facgate_08',
		objCoords  = vector3(410.7606, -1027.048, 28.40136),
		textCoords = vector3(410.7606, -1024.500, 30.40136),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 14,
		size = 1
    },
    
    -----------------------------------------
    ------------- VAGOS TACOS ---------------
    -----------------------------------------
    {
		objHash = -176100808,
		objCoords  = vector3(13.552, -1605.699, 29.523),
		textCoords = vector3(12.93,-1605.342,30.0),
		authorizedJobs = {'vagos'},
        locked = true,
        objYaw = 320.0,
    },
    {
		objHash = -176100808,
		objCoords  = vector3(9.33, -1599.93, 29.523),
		textCoords = vector3(8.92,-1600.43, 30.0),
		authorizedJobs = {'vagos'},
        locked = true,
        objYaw = 49.8,
    },
    {
		objHash = -176100808,
		objCoords  = vector3(19.526,-1599.98,29.523),
        textCoords  = vector3(19.076974868774,-1599.4967041016,29.389762878418),
        objYaw = 320.0,
		authorizedJobs = {'vagos'},
		locked = true,
    },
    {
		objHash = -176100808,
		objCoords  = vector3(20.349, -1603.969, 29.523),
        textCoords  = vector3(19.84,-1604.59,29.3906),
        objYaw = 50.0,
		authorizedJobs = {'vagos'},
		locked = true,
    },

    -----------------------------------
    ------------- LSWC ----------------
    -----------------------------------
    {
        objHash = 534758478,
        objCoords  = vector3(-1879.15300,2056.40600,141.13410),
        textCoords = vector3(-1878.9384,2056.9335,140.984),
        objYaw = 250.0,
        authorizedJobs = {'lswc'},
        locked = true,
    },
    {
        objHash = -710818483,
        objCoords  = vector3(-1860.67200,2057.72700,135.68900),
        textCoords = vector3(-1860.69384,2058.472, 135.459),
        objYaw = 269.7,
        authorizedJobs = {'lswc'},
        locked = true,
    },
    {
        objHash = -710818483,
        objCoords  = vector3(-1864.813, 2057.723, 135.689),
        textCoords = vector3(-1864.816,2058.445,135.445),
        objYaw = 269.7,
        authorizedJobs = {'lswc'},
        locked = true,
    },
    {
        objHash = 534758478,
        objCoords  = vector3(-1885.679, 2060.775, 145.731),
        textCoords = vector3(-1885.0921630859,2060.3237304688,145.9),
        objYaw = 160.0,
        authorizedJobs = {'lswc'},
        locked = true,
    },
    {
        objHash = 534758478,
        objCoords  = vector3(-1883.23, 2059.88, 145.73),
        textCoords = vector3(-1884.0040283203,2060.1755371094,145.9),
        objYaw = 340.0,
        authorizedJobs = {'lswc'},
        locked = true,
	},
	
	{
		objName = 'v_ilev_ph_gendoor006',
		objYaw = 180.0,
		objCoords  = vector3(466.75,-1003.46, 25.05),
		textCoords = vector3(467.52,-1003.52, 25.05),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true
	},

	-- PD

	{ -- Extra Cell 5
        objName = 'v_ilev_gtdoor',
        objCoords  = vector3(480.63, -997.90, 24.91),
        textCoords = vector3(479.89, -997.77, 24.91),
        authorizedJobs = { 'police' },
        locked = true,
        objYaw = 180.0

    },
    
    { -- Extra Cell 2
        objName = 'v_ilev_gtdoor',
        objCoords  = vector3(471.32, -998.32, 24.91),
        textCoords = vector3(471.32, -998.32, 24.91),
        authorizedJobs = { 'police' },
        locked = true,
        objYaw = 180.0,

    },        
    
    { -- Extra Cell 1
        objName = 'v_ilev_gtdoor',
        objCoords  = vector3(469.10, -997.90, 25.04),
        textCoords = vector3(468.48, -998.28, 25.04),
        authorizedJobs = { 'police' },
        locked = true,
        objYaw = 180.0,
    },

    { -- Extra Cell 3
        objName = 'v_ilev_gtdoor',
        objYaw = 180.0,
        objCoords  = vector3(474.86, -997.90, 25.04),
        textCoords = vector3(474.11, -997.52, 25.04),
        authorizedJobs = { 'police' },
        locked = true
    },

    { -- Extra Cell 4
        objName = 'v_ilev_gtdoor',
        objCoords  = vector3(477.75, -997.90, 25.04),
        textCoords = vector3(476.80, -997.88, 25.04),
        authorizedJobs = { 'police' },
        locked = true,
        objYaw = 180.0,
    },

    -------------------------
    ---- VANILLA UNICORN ----
    -------------------------

    { -- Office to Parking Lot  
        objName = 'prop_magenta_door',
        objCoords  = vector3(96.091, -1284.854, 29.438),
        textCoords = vector3(95.5861, -1285.3039, 29.3800),
        authorizedJobs = { 'vanillaunicorn' },
        locked = true,
        objYaw = 210.0,
    },

    { -- Office to Dressing Room  
        objName = 'v_ilev_roc_door2',
        objCoords  = vector3(99.083, -1293.701, 29.418),
        textCoords = vector3(99.5963, -1293.2485, 29.3687),
        authorizedJobs = { 'vanillaunicorn' },
        locked = true,
        objYaw = 30.0,
    },

    { -- Dressing Room to Main Area 
        objName = 'v_ilev_door_orangesolid',
        objCoords  = vector3(113.98, -1297.43, 29.418),
        textCoords = vector3(113.6468, -1296.8188, 29.5687),
        authorizedJobs = { 'vanillaunicorn' },
        locked = true,
        objYaw = 300.0,
    },

    { -- Parking Lot to Main Area 
        objName = 'prop_strip_door_01',
        objCoords  = vector3(127.955, -1298.503, 29.419),
        textCoords = vector3(128.513,-1298.195, 29.369),
        authorizedJobs = { 'vanillaunicorn' },
        locked = true,
        objYaw = 30.0,
    },

	{ -- Parking Lot to storage 
	objHash = -626684119,
	objCoords  = vector3(135.0, -1278.7, 29.5),
	textCoords = vector3(135.5, -1279.2, 29.4),
	authorizedJobs = { 'vanillaunicorn' },
	locked = true,
	objYaw = 300.0,
	},

	{ -- Door to storeroom 
	objHash = -626684119,
	objCoords  = vector3(133.8, -1291.0, 29.4),
	textCoords = vector3(134.3, -1290.7, 29.2),
	authorizedJobs = { 'vanillaunicorn' },
	locked = true,
	objYaw = 30.0,
	},




    -------------------------
    ---- DIAMOND CASINO  ----
    -------------------------

    { -- Management Doors
		textCoords = vector3(946.91247558594, 40.86861038208, 25.617230224609),
		authorizedJobs = { 'diamondcasino' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = 21324050,
				objYaw = 327.80,
				objCoords = vector3(945.852, 41.5786, 25.8209)
			},

			{
				objHash = 21324050,
				objYaw = 148.224,
				objCoords = vector3(947.981, 40.2479, 25.8209)
			}
		}
	},

    { -- Entrance Doors
		textCoords = vector3(1006.0042, 73.7319, 23.4763),
		authorizedJobs = { 'diamondcasino' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = 680601509,
				objYaw = 237.80,
				objCoords = vector3(1006.497, 74.605, 23.426)
			},

			{
				objHash = 680601509,
				objYaw = 58.21,
				objCoords = vector3(1005.43, 72.909, 23.426)
			}
		}
    },
    
    -------------------------
    ----- MERRYWEATHER  -----
    -------------------------

    { -- Office Door 1
        objName = 'v_ilev_ss_door01',
        objCoords  = vector3(585.969, -3117.248, 18.918),
        textCoords = vector3(585.90228271484, -3117.9396972656, 18.768583297729),
        authorizedJobs = { 'merryweather' },
        locked = true,
        objYaw = 90.0,
    },
    { -- Office Door 2
        objName = 'v_ilev_ss_door01',
        objCoords  = vector3(552.47, -3117.248, 18.918),
        textCoords = vector3(552.21557617188, -3117.8979492188, 18.768398284912),
        authorizedJobs = { 'merryweather' },
        locked = true,
        objYaw = 90.0,
    },
    { -- Gate 1
		objName = 'prop_gate_docks_ld',
		objYaw = 180.0,
		objCoords  = vector3(476.327, -3115.92, 5.1623),
		textCoords = vector3(478.99395751953, -3116.203125, 6.5700612068176),
		authorizedJobs = { 'merryweather' },
		locked = true,
		distance = 10,
		size = 2
    },
    { -- Gate 2
		objName = 'prop_gate_docks_ld',
		objYaw = 0.0,
		objCoords  = vector3(492.2758, -3115.93, 5.1623),
		textCoords = vector3(489.51806640625,-3116.0261230469, 6.5700597763062),
		authorizedJobs = { 'merryweather' },
		locked = true,
		distance = 10,
		size = 2
	},
    { -- Pawn Shop Door
        objName = 'v_ilev_tort_door',
        objCoords  = vector3(134.395, -2204.09, 7.51433),
        textCoords = vector3(134.33181762695, -2203.4694824219, 7.3598127365112),
        authorizedJobs = { 'merryweather' },
        locked = true,
        objYaw = 270.0,
    },


	-- Paleto PD
	-- Front double
	{
		textCoords = vector3(-443.6, 6016.1, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objHash = -1501157055,
				objYaw = 135.0,
				objCoords  = vector3(-444.5, 6017.0, 31.8),
			},

			{
				objHash = -1501157055,
				objYaw = 315.0,
				objCoords  = vector3(-442.6, 6015.2, 31.8)
			}
		}
	},

	-- Reception Left Double

	{
		textCoords = vector3(-441.9, 6011.9, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 44.6,
				objCoords  = vector3(-442.8, 6010.9, 31.8),
			},

			{
				objHash = -2023754432,
				objYaw = 225.0,
				objCoords  = vector3(-441.0, 6012.7, 31.8)
			}
		}
	},

	-- Reception Front Double

	{
		textCoords = vector3(-448.6, 6007.6, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 135.1,
				objCoords  = vector3(-447.7, 6006.7, 31.8),
			},

			{
				objHash = -2023754432,
				objYaw = 315.0,
				objCoords  = vector3(-449.5, 6008.5, 31.8)
			}
		}
	},

	-- Reception to Locker room

	{
        objHash = -2023754432,
        objCoords  = vector3(-450.7, 6016.3, 31.8),
        textCoords = vector3(-450.2, 6015.9, 31.7),
        objYaw = 315.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
    },
	
	-- Lockeroom doors single

	{
        objHash = -2023754432,
        objCoords  = vector3(-453.3, 6018.9, 31.8),
        textCoords = vector3(-452.8, 6018.5, 31.7),
        objYaw = 315.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},
	
	{
        objHash = -2023754432,
        objCoords  = vector3(-454.0, 6010.2, 31.8),
        textCoords = vector3(-453.5, 6010.7, 31.7),
        objYaw = 45.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},
	
	-- Armoury

	{
        objHash = 749848321,
        objCoords  = vector3(-437.0, 6003.7, 31.8),
        textCoords = vector3(-436.4, 6003.3, 31.7),
        objYaw = 135.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	{
        objHash = 749848321,
        objCoords  = vector3(-439.1, 5998.1, 31.8),
        textCoords = vector3(-438.7, 5998.6, 31.7),
        objYaw = 225.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	{
        objHash = 749848321,
        objCoords  = vector3(-440.4, 5998.6, 31.8),
        textCoords = vector3(-440.8, 5999.0, 31.7),
        objYaw = 315.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	-- Outside doors

	{
        objHash = -2023754432,
        objCoords  = vector3(-447.2, 6002.3, 31.8),
        textCoords = vector3(-446.7, 6001.8, 31.7),
        objYaw = 315.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	{
        objHash = -2023754432,
        objCoords  = vector3(-450.9, 6006.0, 31.9),
        textCoords = vector3(-451.4, 6006.6, 31.8),
        objYaw = 135.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	-- Internal Double

	{
		textCoords = vector3(-441.7, 6008.3, 31.7),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -2023754432,
				objYaw = 315.0,
				objCoords  = vector3(-442.6, 6009.3, 31.8),
			},

			{
				objHash = -2023754432,
				objYaw = 135.0,
				objCoords  = vector3(-440.8, 6007.4, 31.8)
			}
		}
	},	

	-- Internal Single

	{
        objHash = 749848321,
        objCoords  = vector3(-447.7, 6005.1, 31.8),
        textCoords = vector3(-447.1, 6004.6, 31.7),
        objYaw = 135.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	-- Top Floor Office

	{
        objHash = -1501157055,
        objCoords  = vector3(-445.3, 6010.3, 36.6),
        textCoords = vector3(-445.9, 6010.7, 36.5),
        objYaw = 315.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	-- Basement--

	-- Double

	{
		textCoords = vector3(-435.5, 6008.7, 27.9),
		authorizedJobs = { 'police', 'offpolice' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objHash = -1320876379,
				objYaw = 225.0,
				objCoords  = vector3(-436.5, 6007.8, 28.1),
			},

			{
				objHash = -1320876379,
				objYaw = 45.0,
				objCoords  = vector3(-434.6, 6009.6, 28.1)
			}
		}
	},	

	-- Interviews

	{
        objHash = 749848321,
        objCoords  = vector3(-436.6, 6002.5, 28.1),
        textCoords = vector3(-437.0, 6002.0, 27.9),
        objYaw = 45.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	{
        objHash = 749848321,
        objCoords  = vector3(-433.9, 6005.2, 28.1),
        textCoords = vector3(-433.5, 6005.7, 27.9),
        objYaw = 225.0,
        authorizedJobs = { 'police', 'offpolice' },
        locked = true
	},

	-- Cells

	{
        objHash = -1927754726,
        objCoords  = vector3(-438.2, 6006.1, 28.1),
        textCoords = vector3(-438.6, 6005.6, 27.9),
        objYaw = 45.0,
        authorizedJobs = { 'police' },
        locked = true
	},

	{
        objHash = -1927754726,
        objCoords  = vector3(-442.1, 6010.0, 28.1),
        textCoords = vector3(-442.5, 6009.5, 27.9),
        objYaw = 45.0,
        authorizedJobs = { 'police' },
        locked = true
	},

	{
        objHash = -1927754726,
        objCoords  = vector3(-444.3, 6012.2, 28.1),
        textCoords = vector3(-444.7, 6011.7, 27.9),
        objYaw = 45.0,
        authorizedJobs = { 'police' },
        locked = true
	},


	------------
	-- Pillbox--
    ------------

    -- # Lobby to ward

    {
        textCoords = vector3(303.8, -581.7, 43.3),
        authorizedJobs = { 'ambulance', 'offambulance', 'police' },
        locked = false,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 340.0,
                objCoords = vector3(302.8, -581.4, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 340.0,
                objCoords = vector3(305.2, -582.3, 43.4)
            }
        }
    },
--  # Main treatment ward
    {
        textCoords = vector3(317.3, -578.8, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance', 'police' },
        locked = false,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 160.0,
                objCoords = vector3(318.4, -579.2, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 160.0,
                objCoords = vector3(316.0, -578.3, 43.4)
            }
        }
    },
--  # Single doors
    {
        objHash = 854291622,
        objCoords  = vector3(303.959, -572.557, 43.4),
        textCoords = vector3(304.21, -571.94, 43.2),
        objYaw = 70.0,
        authorizedJobs = {'ambulance', 'offambulance'},
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 340.0,
        objCoords  = vector3(307.118, -569.569, 43.4),
        textCoords = vector3(307.9, -569.7, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 340.0,
        objCoords  = vector3(340.7, -581.8, 43.4),
        textCoords = vector3(341.2, -582.0, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 250.0,
        objCoords  = vector3(352.1, -594.1, 43.4),
        textCoords = vector3(351.9, -594.7, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 70.0,
        objCoords  = vector3(346.8, -593.6, 43.4),
        textCoords = vector3(347.1, -592.9, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 340.0,
        objCoords  = vector3(358.7, -593.8, 43.4),
        textCoords = vector3(359.3, -594.0, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 340.0,
        objCoords  = vector3(339.0, -586.7, 43.4),
        textCoords = vector3(339.6, -586.9, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 340.0,
        objCoords  = vector3(336.8, -592.5, 43.4),
        textCoords = vector3(337.5, -592.7, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true
    },
    {
        objHash = 854291622,
        objYaw = 160.0,
        objCoords  = vector3(309.1, -597.7, 43.4),
        textCoords = vector3(308.4, -597.6, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance', 'police' },
        locked = true
    },
--  # Surgery Rooms 
--  #1
    {
        textCoords = vector3(313.3, -571.7, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 340.0,
                objCoords = vector3(312.0, -571.3, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 340.0,
                objCoords = vector3(314.4, -572.2, 43.4)
            }
        }
    },
--  #2
    {
        textCoords = vector3(318.9, -573.8, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 340.0,
                objCoords = vector3(317.8, -573.4, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 340.0,
                objCoords = vector3(320.2, -574.3, 43.4)
            }
        }
    },
--  #3
    {
        textCoords = vector3(324.4, -575.7, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance' },
        locked = true,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 340.0,
                objCoords = vector3(323.2, -575.4, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 340.0,
                objCoords = vector3(325.6, -576.3, 43.4)
            }
        }
    },
--  Ward B
    {
        textCoords = vector3(326.1, -579.1, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance', 'police' },
        locked = true,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 250.0,
                objCoords = vector3(325.54, -578.0, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 250.0,
                objCoords = vector3(325.6, -580.45, 43.4)
            }
        }
    },
-- lobby to hallway back

    {
        textCoords = vector3(325.4, -589.7, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance', 'police' },
        locked = true,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 340.0,
                objCoords = vector3(324.2, -589.2, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 340.0,
                objCoords = vector3(326.6, -590.1, 43.4)
            }
        }
    },

-- Ward c 

    {
        textCoords = vector3(348.9, -587.6, 43.2),
        authorizedJobs = { 'ambulance', 'offambulance', },
        locked = true,
        distance = 2.5,
        doors = {
            {
                objHash = -434783486,
                objYaw = 250.0,
                objCoords = vector3(349.3, -586.3, 43.4)
            },

            {
                objHash = -1700911976,
                objYaw = 250.0,
                objCoords = vector3(348.8, -588.7, 43.4)
            }
        }
    },
}
