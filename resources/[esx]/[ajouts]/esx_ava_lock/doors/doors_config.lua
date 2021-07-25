-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config.Doors = {
	Debug = false,
	DebugKey = 79,
	ObjectDistance = 30,
	DefaultDistance = 1.0,
	DefaultSize = 0.3,

	DoorList = {
		-- Mission Row
		
		{ -- Entrance Doors
			textCoords = vector3(434.75, -981.92, 30.84),
			authorizedJobs = { 'lspd', 'state' },
			locked = false,
			doors = {
				{
					objHash = GetHashKey('v_ilev_ph_door01'),
					objYaw = -90.0,
					objCoords = vector3(434.7, -980.6, 30.8)
				},
				{
					objHash = GetHashKey('v_ilev_ph_door002'),
					objYaw = -90.0,
					objCoords = vector3(434.7, -983.2, 30.8)
				}
			}
		},
		{ -- To locker room & roof
			objHash = GetHashKey('v_ilev_ph_gendoor004'),
			objYaw = 90.0,
			objCoords  = vector3(449.6, -986.4, 30.6),
			textCoords = vector3(450.10, -986.94, 30.80),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{ -- Rooftop
			objHash = GetHashKey('v_ilev_gtdoor02'),
			objYaw = 90.0,
			objCoords  = vector3(464.3, -984.6, 43.69),
			textCoords = vector3(464.36, -983.58, 43.83),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{ -- Captain Office
			objHash = GetHashKey('v_ilev_ph_gendoor002'),
			objYaw = -180.0,
			objCoords  = vector3(447.2, -980.6, 30.6),
			textCoords = vector3(447.79, -980.01, 30.75),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{ -- To downstairs (double doors)
			textCoords = vector3(444.71, -989.44, 30.80),
			authorizedJobs = { 'lspd', 'state' },
			locked = true,
			doors = {
				{
					objHash = GetHashKey('v_ilev_ph_gendoor005'),
					objYaw = 180.0,
					objCoords = vector3(443.9, -989.0, 30.6)
				},
				{
					objHash = GetHashKey('v_ilev_ph_gendoor005'),
					objYaw = 0.0,
					objCoords = vector3(445.3, -988.7, 30.6)
				}
			}
		},
		{ -- Armory
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 90.0,
			objCoords = vector3(452.67, -982.97, 30.6),
			textCoords = vector3(453.09, -982.13, 30.80),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- Main Cells
			objHash = GetHashKey('v_ilev_ph_cellgate'),
			objYaw = 0.0,
			objCoords  = vector3(463.8, -992.6, 24.9),
			textCoords = vector3(463.27, -992.66, 25.06),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- Cell 1
			objHash = GetHashKey('v_ilev_ph_cellgate'),
			objYaw = -90.0,
			objCoords  = vector3(462.3, -993.6, 24.9),
			textCoords = vector3(461.81, -993.11, 25.06),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- Cell 2
			objHash = GetHashKey('v_ilev_ph_cellgate'),
			objYaw = 90.0,
			objCoords  = vector3(462.3, -998.1, 24.9),
			textCoords = vector3(461.81, -998.96, 25.06),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- Cell 3
			objHash = GetHashKey('v_ilev_ph_cellgate'),
			objYaw = 90.0,
			objCoords  = vector3(462.704, -1001.92, 24.9149),
			textCoords = vector3(461.81, -1002.60, 25.06),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- To Back
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 0.0,
			objCoords  = vector3(463.4, -1003.5, 25.0),
			textCoords = vector3(464.68, -1003.54, 25.01),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- double porte escalier étage
			textCoords = vector3(443.06, -993.22, 30.83931),
			authorizedJobs = { 'lspd', 'state' },
			locked = true,
			doors = {
				{
					objHash = GetHashKey('v_ilev_ph_gendoor006'),
					objYaw = 90.0,
					objCoords  = vector3(443.02980, -991.941, 30.83931),
				},
				{
					objHash = GetHashKey('v_ilev_ph_gendoor006'),
					objYaw = 270.511,
					objCoords  = vector3(443.02980, -994.54120, 30.83931)
				}
			}
		},

		{-- Cellule Mapping
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 0.0,
			objCoords  = vector3(467.19220, -996.45940, 25.00599),
			textCoords = vector3(468.23, -996.51, 25.00599),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 0.0,
			objCoords  = vector3(471.47550, -996.45940, 25.00599),
			textCoords = vector3(472.52, -996.35, 25.00599),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 0.0,
			objCoords  = vector3(475.75430, -996.45940, 25.00599),
			textCoords = vector3(476.8, -996.33, 25.00599),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 0.0,
			objCoords  = vector3(480.03010, -996.45940, 25.00599),
			textCoords = vector3(481.08, -996.39, 25.00599),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- Salle interview 
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 360.0,
			objCoords  = vector3(480.03010, -1003.53800, 25.00599),
			textCoords = vector3(481.08, -1003.48, 25.00599),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 180.0,
			objCoords  = vector3(477.04970, -1003.55300, 25.01203),
			textCoords = vector3(476.02, -1003.55, 25.01203),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 0.0,
			objCoords  = vector3(471.47470, -1003.53800, 25.01223),
			textCoords = vector3(472.53, -1003.62, 25.01223),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_gtdoor'),
			objYaw = 180.0,
			objCoords  = vector3(467.82, -1003.51, 25.01203),
			textCoords = vector3(467.43, -1003.61, 25.01203),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{-- double porte garage
			textCoords = vector3(445.92, -998.9, 30.78942),
			authorizedJobs = { 'lspd', 'state' },
			locked = true,
			doors = {
				{
					objHash = GetHashKey('v_ilev_gtdoor'),
					objYaw = 180.0,
					objCoords  = vector3(447.21840, -999.00230, 30.78942),
				},
				{
					objHash = GetHashKey('v_ilev_gtdoor'),
					objYaw = 360.0,
					objCoords  = vector3(444.62120, -999.00100, 30.78866)
				}
			}
		},
		{-- Parking
			objHash = GetHashKey('prop_gate_airport_01'),
			objCoords  = vector3(416.58, -1024.52, 29.11),
			textCoords = vector3(416.85, -1021.52, 29.56),
			authorizedJobs = { 'lspd', 'state' },
			locked = true,
			distance = 16,
			size = 0.4
		},
		{-- Back (double doors)
			textCoords = vector3(468.67, -1014.45, 26.54),
			authorizedJobs = { 'lspd' },
			locked = true,
			doors = {
				{
					objHash = GetHashKey('v_ilev_rc_door2'),
					objYaw = 0.0,
					objCoords  = vector3(467.3, -1014.4, 26.5)
				},
				{
					objHash = GetHashKey('v_ilev_rc_door2'),
					objYaw = 180.0,
					objCoords  = vector3(469.9, -1014.4, 26.5)
				}
			}
		},
		{-- Back Gate
			objHash = GetHashKey('hei_prop_station_gate'),
			objYaw = 90.0,
			objCoords  = vector3(488.8, -1017.2, 27.1),
			textCoords = vector3(488.89, -1022.81, 29.15),
			authorizedJobs = { 'lspd' },
			locked = true,
			distance = 12
		},
		{-- Saisi
			objHash = GetHashKey('prop_fnclink_02gate7'),
			objYaw = 90.0,
			objCoords  = vector3( 475.42, -985.93, 24.10),
			textCoords = vector3( 475.42, -985.93, 25.12),
			authorizedJobs = { 'lspd' },
			locked = true
		},
		{ -- Chief office
			objHash = -1320876379,
			objYaw = 0.0,
			objCoords  = vector3(462.76, -1001.00, 35.93),
			textCoords = vector3(462.20, -1001.01, 35.95),
			authorizedJobs = { 'lspd' },
			locked = true
		},


		-- PACIFIC STANDARD
		{
			objHash = GetHashKey('v_ilev_bk_vaultdoor'),
			objYaw = 160.0,
			objOpenYaw = 30.0,
			objCoords  = vector3( 255.59, 224.03, 101.88),
			textCoords = vector3( 252.82, 228.64, 102.08),
			authorizedJobs = { 'lspd' },
			locked = true
		},



		--
		-- Bolingbroke Penitentiary
		--

		-- Entrance (Two big gates)
		{
			objHash = GetHashKey('prop_gate_prison_01'),
			objCoords  = vector3(1844.9, 2604.8, 44.6),
			textCoords = vector3(1844.9, 2608.5, 48.0),
			authorizedJobs = { 'lspd' },
			locked = true,
			distance = 12,
			size = 0.4
		},
		{
			objHash = GetHashKey('prop_gate_prison_01'),
			objCoords  = vector3(1818.5, 2604.8, 44.6),
			textCoords = vector3(1818.5, 2608.4, 48.0),
			authorizedJobs = { 'lspd' },
			locked = true,
			distance = 12,
			size = 0.4
		},





		-- Unicorn
		{
			objHash = GetHashKey('prop_strip_door_01'), -- Main door
			objYaw = 30.0,
			objCoords  = vector3(127.9552, -1298.503, 29.41962),
			textCoords = vector3(128.99, -1297.90, 29.32),
			authorizedJobs = { 'unicorn' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_door_orangesolid'), -- Dressing
			objYaw = -60.0,
			objCoords  = vector3(113.9822, -1297.43, 29.41868),
			textCoords = vector3(113.38, -1296.39, 29.42),
			authorizedJobs = { 'unicorn' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_roc_door2'), -- Bureau 2
			objYaw = 30.0,
			objCoords  = vector3(99.08321, -1293.701, 29.41868),
			textCoords = vector3(100.12, -1293.10, 29.42),
			authorizedJobs = { 'unicorn' },
			locked = true
		},
		{
			objHash = GetHashKey('prop_magenta_door'), -- Derrière
			objYaw = -150.0,
			objCoords  = vector3(96.09197, -1284.854, 29.43878),
			textCoords = vector3(95.05, -1285.45, 29.44),
			authorizedJobs = { 'unicorn' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_roc_door2'), -- porte mapping intérieur, accès bar
			objYaw = 30.0,
			objCoords  = vector3(134.36, -1290.70, 29.27),
			textCoords = vector3(134.88, -1290.45, 29.41),
			authorizedJobs = { 'unicorn' },
			locked = true
		},
		{
			objHash = GetHashKey('v_ilev_roc_door2'), -- porte sur le coté
			objYaw = -60.0,
			objCoords  = vector3(135.28, -1279.47, 29.42),
			textCoords = vector3(135.70, -1279.78, 29.57),
			authorizedJobs = { 'unicorn' },
			locked = true
		},





		-- BAHAMAS
		{
			textCoords = vector3(-1388.11, -587.33, 30.50),
			authorizedJobs = { 'bahama' },
			locked = true,
			doors = {
				{
					objHash = GetHashKey('v_ilev_ph_gendoor006'),
					objYaw = 33.5,
					objCoords  = vector3(-1387.026, -586.6138, 30.49563)
				},
				{
					objHash = GetHashKey('v_ilev_ph_gendoor006'),
					objYaw = -147.5,
					objCoords  = vector3(-1389.212, -588.0406, 30.49132)
				}
			}
		},

		-- mechanic : center city
		{
			objHash = GetHashKey('prop_com_ls_door_01'),
			objCoords  = vector3( -356.09, -134.81, 39.01),
			textCoords = vector3( -356.09, -134.81, 39.01),
			authorizedJobs = { 'mechanic' },
			locked = true,
			distance = 12
		},
		{
			objHash = -58137547,
			objYaw = 340.0,
			objCoords  = vector3(-347.91, -125.0, 39.01),
			textCoords = vector3(-348.17, -124.92, 39.16),
			authorizedJobs = { 'mechanic' },
			locked = true
		},
		{
			objHash = -58137547,
			objYaw = 250.0,
			objCoords  = vector3(-346.00, -122.4, 39.01),
			textCoords = vector3(-345.65, -122.38, 39.15),
			authorizedJobs = { 'mechanic' },
			locked = true
		},
		{
			objHash = -58137547,
			objYaw = 70.0,
			objCoords  = vector3(-322.06, -120.90, 39.01),
			textCoords = vector3(-321.77, -121.36, 39.16),
			authorizedJobs = { 'mechanic' },
			locked = true
		},


		-- mechanic : airport
		{
			objHash = GetHashKey('prop_com_ls_door_01'),
			objCoords  = vector3(-1146.15, -1991.06, 13.19),
			textCoords = vector3(-1145.90, -1991.14, 12.25),
			authorizedJobs = { 'mechanic' },
			locked = true,
			distance = 12
		},
		{
			objHash = -58137547,
			objYaw = 225.0,
			objCoords  = vector3(-1140.71, -2002.95, 13.19),
			textCoords = vector3(-1140.31, -2002.49, 13.33),
			authorizedJobs = { 'mechanic' },
			locked = true
		},
		{
			objHash = -58137547,
			objYaw = 135.0,
			objCoords  = vector3(-1139.49, -2005.42, 13.19),
			textCoords = vector3(-1139.08, -2005.84, 13.32),
			authorizedJobs = { 'mechanic' },
			locked = true
		},
		{
			objHash = -58137547,
			objYaw = 315.0,
			objCoords  = vector3(-1147.91, -2028.17, 13.19),
			textCoords = vector3(-1148.24, -2027.92, 13.33),
			authorizedJobs = { 'mechanic' },
			locked = true
		},



		-- GOUV
		{
			textCoords = vector3(-545.51, -203.39, 38.40), -- entrée
			authorizedJobs = { 'state', 'lspd' },
			locked = true,
			doors = {
				{
					-- Hash = GetHashKey('ball_prop_citydoor'),
					objHash = 2537604,
					objYaw = -150.0,
					objCoords  = vector3( -545.97, -203.69, 38.22)
				},
				{
					-- Hash = GetHashKey('ball_prop_citydoor'),
					objHash = 2537604,
					objYaw = 30.0,
					objCoords  = vector3( -544.96, -203.13, 38.22)
				}
			}
		},
		{ -- porte arrière vers garage OUEST
			textCoords = vector3(-582.69, -195.25, 38.60),
			authorizedJobs = { 'state' },
			locked = true,
			doors = {
				{
					objHash = GetHashKey('ball_prop_citydoor2'),
					objYaw = -150.0,
					objCoords  = vector3( -583.11, -195.59, 38.22)
				},
				{
					objHash = GetHashKey('ball_prop_citydoor2'),
					objYaw = 30.0,
					objCoords  = vector3( -582.15, -195.02, 38.22)
				}
			}
		},
		{ -- porte du bureau du gouverneur
			textCoords = vector3(-549.37, -196.34, 47.54), -- entrée
			authorizedJobs = { 'state' },
			locked = true,
			doors = {
				{
					objHash = GetHashKey('hei_prop_hei_bankdoor_new'),
					objYaw = -150.0,
					objCoords  = vector3( -548.72, -196.32, 47.41)
				},
				{
					objHash = GetHashKey('hei_prop_hei_bankdoor_new'),
					objYaw = 30.0,
					objCoords  = vector3( -549.88, -196.99, 47.41)
				}
			}
		},


		-- CLUCKIN
		{
			textCoords = vector3(-511.63, -683.87, 33.41),
			authorizedJobs = { 'cluckin' },
			locked = true,
			doors = {
				{
					objHash = -1432609915,
					objYaw = 180.0,
					objCoords = vector3(-512.83, -683.73, 33.18)
				},
				{
					objHash = 903328250,
					objYaw = 180.0,
					objCoords = vector3(-510.5, -683.72, 33.18)
				}
			}
		},
		{
			objHash = -738011261,
			objCoords  = vector3( -512.26, -697.28, 33.17),
			textCoords = vector3(-512.21, -697.24, 33.41),
			objYaw = 180.0,
			authorizedJobs = { 'cluckin' },
			locked = true,
		},


		-- TAXI
		{ -- main door
			textCoords = vector3(907.42, -160.26, 74.77),
			authorizedJobs = { 'taxi' },
			locked = true,
			doors = {
				{
					objHash = 1519319655,
					objYaw = 58.5,
					objCoords = vector3(907.79, -159.61, 74.17)
				},
				{
					objHash = 1519319655,
					objYaw = 238.5,
					objCoords = vector3(906.27, -161.14, 74.17)
				}
			}
		},
		{
			textCoords = vector3(894.35, -179.26, 74.7),
			authorizedJobs = { 'taxi' },
			locked = true,
			doors = {
				{
					objHash = -2023754432,
					objYaw = 58.5,
					objCoords = vector3(894.3, -180.0, 74.7)
				},
				{
					objHash = -2023754432,
					objYaw = 238.5,
					objCoords = vector3(894.7, -178.68, 74.7)
				}
			}
		},
		{
			objHash = -2023754432,
			objCoords  = vector3( 896.11, -145.42, 76.89),
			textCoords = vector3( 896.11, -145.42, 77.0),
			objYaw = 328.0,
			authorizedJobs = { 'taxi' },
			locked = true
		},
		{
			objHash = 2064385778,
			objCoords  = vector3( 900.08, -147.9, 76.66),
			textCoords = vector3( 900.08, -147.9, 76.66),
			authorizedJobs = { 'taxi' },
			locked = true,
			distance = 5.0
		},
	
		-- HOPITAL
		{ -- entrance top
			textCoords = vector3(299.5, -584.9, 44.70),
			authorizedJobs = { 'ems' },
			locked = false,
			distance = 2.0,
			doors = {
				{
					objHash = -487908756,
					objCoords = vector3(299.5, -584.9, 43.28)
				},
				{
					objHash = 661758796,
					objCoords = vector3(299.5, -584.9, 43.28)
				}
			}
		},
		{ -- entrance front bottom
			textCoords = vector3(356.93, -590.49, 30.22),
			authorizedJobs = { 'ems' },
			locked = false,
			distance = 2.0,
			doors = {
				{
					objHash = -487908756,
					objCoords = vector3(357.06, -590.44, 28.79)
				},
				{
					objHash = 661758796,
					objCoords = vector3(357.06, -590.44, 28.79)
				}
			}
		},
		{
			objHash = 854291622,
			objCoords  = vector3( 308.31, -597.51, 43.28),
			textCoords = vector3( 307.91, -597.31, 43.38),
			authorizedJobs = { 'ems' },
			objYaw = 160.0,
			locked = true
		},
        { -- entrance back bottom
			textCoords = vector3(319.84, -560.44, 28.95),
			authorizedJobs = { 'ems' },
			locked = true,
			doors = {
				{
					objHash = 1248599813,
                    objYaw = 205.0,
					objCoords = vector3(319.95, -560.82, 28.80)
				},
				{
					objHash = -1421582160,
                    objYaw = 25.0,
					objCoords = vector3(319.95, -560.82, 28.80)
				}
			}
		},
        {
            textCoords = vector3(333.71, -563.12, 28.82),
            authorizedJobs = { 'ems' },
            locked = true,
            distance = 12,
            doors = {
                {
                    objHash = -820650556,
                    objCoords  = vector3( 330.21, -561.80, 30.80),
                },
                {
                    objHash = -820650556,
                    objCoords = vector3(337.49, -564.44, 30.80)
                }
            }
        },


		-- -- ORGA CELTIC
		-- {
		-- 	textCoords = vector3(-1864.00, 2060.55, 140.98),
		-- 	authorizedGangs = { 'orga_celtic' },
		-- 	locked = true,
		-- 	distance = 0.8,
		-- 	doors = {
		-- 		{
		-- 			objHash = 988364535,
		-- 			objCoords = vector3(-1864.64, 2060.55, 140.98),
		-- 			objYaw = 270.0
		-- 		},
		-- 		{
		-- 			objHash = -1141522158,
		-- 			objCoords = vector3(-1864.64, 2060.55, 140.98),
		-- 			objYaw = 270.0
		-- 		}
		-- 	}
		-- },


		-- BIKER LOST
		{
			objHash = 190770132,
			objCoords  = vector3(981.90, -102.50, 74.85),
			textCoords = vector3(982.03, -102.44, 74.99),
			authorizedGangs = { 'biker_lost' },
			objYaw = 42.65,
			locked = true
		},

        -- attack a taco
        {
			objHash = -176100808,
			objYaw = 50.0,
			objCoords  = vector3(8.48, -1600.36, 29.39),
			textCoords = vector3(8.55, -1600.87, 29.52),
			authorizedJobs = { 'attackataco' },
			locked = true
		},
        {
			objHash = -176100808,
            objYaw = 320.0,
			objCoords  = vector3(12.93, -1604.84, 29.37),
			textCoords = vector3(12.62, -1604.92, 29.52),
			authorizedJobs = { 'attackataco' },
			locked = true
		},
        {
			objHash = -176100808,
            objYaw = 50.0,
			objCoords  = vector3(19.87, -1604.72, 29.37),
			textCoords = vector3(19.57, -1604.90, 29.52),
			authorizedJobs = { 'attackataco' },
			locked = true
		},
        {
			objHash = -176100808,
            objYaw = 320.0,
			objCoords  = vector3(18.87, -1599.13, 29.37),
			textCoords = vector3(18.60, -1599.20, 29.52),
			authorizedJobs = { 'attackataco' },
			locked = true
		},



        {
            textCoords = vector3(-2148.63, 1106.05, 27.8),
            locked = true,
            distance = 12,
            doors = {
                {
                    objHash = -348431101,
                    objYaw = 190.0,
                    objCoords  = vector3(-2149.04, 1101.94, 28.66)
                },
                {
                    objHash = 129720997,
                    objYaw = 350.0,
                    objCoords = vector3(-2149.11, 1109.94, 28.66)
                }
            }
        },
	}
}