Config = {}
Config.Locale = 'fr'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police', 'state' },
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
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- To downstairs (double doors)
	{
		textCoords = vector3(444.6, -989.4, 30.9),
		authorizedJobs = { 'police', 'state' },
		locked = true,
		distance = 2,
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
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 90.0,
		objCoords = vector3(452.67, -982.97, 30.6),
		textCoords = vector3(453.05, -982.22, 30.8),
		authorizedJobs = { 'police' },
		locked = true
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
		locked = true,
		distance = 1.8
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 1.8
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.704, -1001.92, 24.9149),
		textCoords = vector3(461.806, -1002.450, 25.064),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 1.8
	},

	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 1.6
	},


	-- COMICO GROSSE UPDATE TOUTES LES PORTES

	-- double porte escalier étage 
	{
		textCoords = vector3(443.06, -993.22, 30.83931),
		authorizedJobs = { 'police', 'state' },
		locked = true,
		distance = 2,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor006',
				objYaw = 90.0,
				objCoords  = vector3(443.02980, -991.941, 30.83931),
			},

			{
				objName = 'v_ilev_ph_gendoor006',
				objYaw = 270.511,
				objCoords  = vector3(443.02980, -994.54120, 30.83931)
			}
		}
	},

	-- Cellule Mapping
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(467.19220, -996.45940, 25.00599),
		textCoords = vector3(468.23, -996.51, 25.00599),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 1.8
	},

	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(471.47550, -996.45940, 25.00599),
		textCoords = vector3(472.52, -996.35, 25.00599),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 1.8
	},

	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(475.75430, -996.45940, 25.00599),
		textCoords = vector3(476.8, -996.33, 25.00599),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 1.8
	},

	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(480.03010, -996.45940, 25.00599),
		textCoords = vector3(481.08, -996.39, 25.00599),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 1.8
	},

	-- Salle interview 

	{
		objName = 'v_ilev_gtdoor',
		objYaw = 360.0,
		objCoords  = vector3(480.03010, -1003.53800, 25.00599),
		textCoords = vector3(481.08, -1003.48, 25.00599),
		authorizedJobs = { 'police' },
		locked = true
	},

	{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(477.04970, -1003.55300, 25.01203),
		textCoords = vector3(476.02, -1003.55, 25.01203),
		authorizedJobs = { 'police' },
		locked = true
	},

	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(471.47470, -1003.53800, 25.01223),
		textCoords = vector3(472.53, -1003.62, 25.01223),
		authorizedJobs = { 'police' },
		locked = true
	},

	{
		objName = 'v_ilev_gtdoor',
		objYaw = 180.0,
		objCoords  = vector3(467.82, -1003.51, 25.01203),
		textCoords = vector3(467.43, -1003.61, 25.01203),
		authorizedJobs = { 'police' },
		locked = true
	},

	-- double porte garage
	{
		textCoords = vector3(445.92, -998.9, 30.78942),
		authorizedJobs = { 'police', 'state' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_gtdoor',
				objYaw = 180.0,
				objCoords  = vector3(447.21840, -999.00230, 30.78942),
			},

			{
				objName = 'v_ilev_gtdoor',
				objYaw = 360.0,
				objCoords  = vector3(444.62120, -999.00100, 30.78866)
			}
		}
	},

	-- Parking
	{
		objName = 'prop_gate_airport_01',
		-- objCoords  = vector3( 416.98, -1024.89, 28.16},
		objCoords  = vector3(416.58, -1024.52, 29.11),
		textCoords = vector3(416.85, -1021.52, 29.56),
		authorizedJobs = { 'police', 'state' },
		locked = true,
		distance = 16,
		size = 2
	},


	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 2.5,
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
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	-- Saisi
	{
		objName = 'prop_fnclink_02gate7',
		objYaw = 90.0,
		objCoords  = vector3( 475.42, -985.93, 24.10),
		textCoords = vector3( 475.42, -985.93, 25.12),
		authorizedJobs = { 'police' },
		locked = true
	},

	

	
	-- PACIFIC STANDARD
	{
		objName = 'v_ilev_bk_vaultdoor',
		objYaw = 160.0,
		objOpenYaw = 30.0,
		objCoords  = vector3( 255.59, 224.03, 101.88),
		textCoords = vector3( 252.82, 228.64, 102.08),
		authorizedJobs = { 'police' },
		distance = 1.8,
		locked = true
	},



	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police' },
		locked = true,
		distance = 12,
		size = 2
	},





	-- Unicorn

	{
		objName = 'prop_strip_door_01', -- Entrer
		objYaw = 30.0,
		objCoords  = vector3(127.9552, -1298.503, 29.41962),
		textCoords = vector3(128.79, -1297.97, 29.27),
		authorizedJobs = { 'unicorn' },
		locked = true
	},

	{
		objName = 'v_ilev_door_orangesolid', -- Bureau 1
		objYaw = -60.0,
		objCoords  = vector3(113.9822, -1297.43, 29.41868),
		textCoords = vector3(113.51, -1296.45, 29.41868),
		authorizedJobs = { 'unicorn' },
		locked = true
	},

	{
		objName = 'v_ilev_roc_door2', -- Bureau 2
		objYaw = 30.0,
		objCoords  = vector3(99.08321, -1293.701, 29.41868),
		textCoords = vector3(99.94, -1293.11, 29.41868),
		authorizedJobs = { 'unicorn' },
		locked = true
	},

	{
		objName = 'prop_magenta_door', -- Derrière
		objYaw = -150.0,
		objCoords  = vector3(96.09197, -1284.854, 29.43878),
		textCoords = vector3(95.24, -1285.45, 29.43878),
		authorizedJobs = { 'unicorn' },
		locked = true
	},

	{
		objName = 'v_ilev_roc_door2', -- porte mapping intérieur, accès bar
		objYaw = 30.0,
		objCoords  = vector3(134.36, -1290.70, 29.27),
		textCoords = vector3(134.36, -1290.70, 29.27),
		authorizedJobs = { 'unicorn' },
		locked = true
	},
	{
		objName = 'v_ilev_roc_door2', -- porte sur le coté
		objYaw = -60.0,
		objCoords  = vector3(135.28, -1279.47, 29.42),
		textCoords = vector3(135.28, -1279.47, 29.42),
		authorizedJobs = { 'unicorn' },
		locked = true
	},





	-- BAHAMAS
	{
		textCoords = vector3(-1388.22, -587.12, 30.64),
		authorizedJobs = { 'bahama' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor006',
				objYaw = 33.5,
				objCoords  = vector3(-1387.026, -586.6138, 30.49563)
			},

			{
				objName = 'v_ilev_ph_gendoor006',
				objYaw = -147.5,
				objCoords  = vector3(-1389.212, -588.0406, 30.49132)
			}
		}
	},




	-- MECANO
	-- { -- benny's
	-- 	objName = 'lr_prop_supermod_door_01',
	-- 	objCoords  = vector3( -205.6828, -1310.683, 30.29572),
	-- 	textCoords = vector3( -205.73, -1310.55, 32.37),
	-- 	authorizedJobs = { 'mecano' },
	-- 	locked = true,
	-- 	distance = 12
	-- },

	{
		objName = 'prop_com_ls_door_01',
		objCoords  = vector3( -356.09, -134.81, 39.01),
		textCoords = vector3( -356.09, -134.81, 39.01),
		authorizedJobs = { 'mecano' },
		locked = true,
		distance = 12
	},
	{
		objName = 'prop_com_ls_door_01',
		objCoords  = vector3( -349.75, -117.25, 39.16),
		textCoords = vector3( -349.75, -117.25, 39.16),
		authorizedJobs = { 'mecano' },
		locked = true,
		distance = 12
	},
	{
		objName = 'apa_v_ilev_ss_door7', -- porte sur le coté
		objYaw = 250.0,
		objCoords  = vector3(-345.69, -122.54, 39.01),
		textCoords = vector3(-345.69, -122.54, 39.01),
		authorizedJobs = { 'mecano' },
		distance = 1.5,
		locked = true
	},
	{
		objName = 'apa_v_ilev_ss_door8', -- porte sur le coté
		objYaw = 70.0,
		objCoords  = vector3(-347.98, -133.61, 39.01),
		textCoords = vector3(-347.98, -133.61, 39.01),
		authorizedJobs = { 'mecano' },
		distance = 1.5,
		locked = true
	},
	{
		objName = 'portels_3',
		objCoords  = vector3( -321.84, -141.27, 39.01),
		textCoords = vector3( -321.84, -141.27, 39.01),
		authorizedJobs = { 'mecano' },
		locked = true,
		distance = 6
	},


	-- -- Prison
	-- --
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1798.45, 2479.15, -122.54),
	-- 	textCoords = vector3( 1798.45, 2479.15, -122.54),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1795.29, 2479.18, -122.55),
	-- 	textCoords = vector3( 1795.29, 2479.18, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1792.13, 2479.21, -122.55),
	-- 	textCoords = vector3( 1792.13, 2479.21, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1788.95, 2479.18, -122.55),
	-- 	textCoords = vector3( 1788.95, 2479.18, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1785.79, 2479.21, -122.55),
	-- 	textCoords = vector3( 1785.79, 2479.21, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1788.96, 2487.11, -122.55),
	-- 	textCoords = vector3( 1788.96, 2487.11, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1792.13, 2487.1, -122.55),
	-- 	textCoords = vector3( 1792.13, 2487.1, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1795.29, 2487.12, -122.56),
	-- 	textCoords = vector3( 1795.29, 2487.12, -122.56),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1795.3, 2487.12, -118.93),
	-- 	textCoords = vector3( 1795.3, 2487.12, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1792.13, 2487.12, -118.91),
	-- 	textCoords = vector3( 1792.13, 2487.12, -118.91),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1788.96, 2487.12, -118.93),
	-- 	textCoords = vector3( 1788.96, 2487.12, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1785.79, 2479.21, -118.91), 
	-- 	textCoords = vector3( 1785.79, 2479.21, -118.91),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1788.95, 2479.18, -118.93), 
	-- 	textCoords = vector3( 1788.95, 2479.18, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1792.13, 2479.21, -118.93), 
	-- 	textCoords = vector3( 1792.13, 2479.21, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1795.28, 2479.2, -118.92), 
	-- 	textCoords = vector3( 1795.28, 2479.2, -118.92),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1798.44, 2479.21, -118.92), 
	-- 	textCoords = vector3( 1798.44, 2479.21, -118.92),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1798.45, 2487.12, -118.92),
	-- 	textCoords = vector3( 1798.45, 2487.12, -118.92),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1798.45, 2487.14, -122.54),
	-- 	textCoords = vector3( 1798.45, 2487.14, -122.54),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1790.44, 2479.185, -122.55),
	-- 	textCoords = vector3( 1790.44, 2479.185, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1787.28, 2479.18, -122.55),
	-- 	textCoords = vector3( 1787.28, 2479.18, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1793.63, 2479.21, -122.55),
	-- 	textCoords = vector3( 1793.63, 2479.21, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1796.79, 2479.19, -122.55),
	-- 	textCoords = vector3( 1796.79, 2479.19, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1799.95,  2479.19, -122.54),
	-- 	textCoords = vector3( 1799.95,  2479.19, -122.54),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1793.63,  2487.11, -122.55),
	-- 	textCoords = vector3( 1793.63,  2487.11, -122.55),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1796.77, 2487.11, -122.56),
	-- 	textCoords = vector3( 1796.77, 2487.11, -122.56),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1790.44,  2479.18, -118.93),
	-- 	textCoords = vector3( 1790.44,  2479.18, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1787.28,  2479.21, -118.91),
	-- 	textCoords = vector3( 1787.28,  2479.21, -118.91),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1793.62,  2479.21, -118.93),
	-- 	textCoords = vector3( 1793.62,  2479.21, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1796.78,  2479.19, -118.92),
	-- 	textCoords = vector3( 1796.78,  2479.19, -118.92),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1799.94,  2479.21, -118.92),
	-- 	textCoords = vector3( 1799.94,  2479.21, -118.92),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1790.44,  2487.12, -118.93),
	-- 	textCoords = vector3( 1790.44,  2487.12, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1793.62,  2487.13, -118.91),
	-- 	textCoords = vector3( 1793.62,  2487.13, -118.91),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1796.8,  2487.12, -118.93),
	-- 	textCoords = vector3( 1796.8,  2487.12, -118.93),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1799.94,  2487.12, -118.92),
	-- 	textCoords = vector3( 1799.94,  2487.12, -118.92),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },
	-- {
	-- 	objName = 'prop_ld_jail_door',
	-- 	objCoords  = vector3( 1799.95,  2487.12, -122.54),
	-- 	textCoords = vector3( 1799.95,  2487.12, -122.54),
	-- 	authorizedJobs = { 'police' },
	-- 	locked = true,
	-- 	distance = 1.8,
	-- 	objYaw = 0
	-- },




	-- GOUV
	-- {
	-- 	textCoords = vector3(-545.52, -203.53, 38.22), -- entrée
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = -150.0,
	-- 			objCoords  = vector3( -545.97, -203.69, 38.22)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = 30.0,
	-- 			objCoords  = vector3( -544.96, -203.13, 38.22)
	-- 		}
	-- 	}
	-- },
	-- { -- porte bureau gouv
	-- 	objName = 'v_ilev_ra_door2',
	-- 	objYaw = -60.0,
	-- 	objCoords  = vector3(-555.93, -191.12, 69.8),
	-- 	textCoords = vector3(-555.83, -192.1, 70.15),
	-- 	authorizedJobs = { 'state' },
	-- 	distance = 1.5,
	-- 	locked = true
	-- },
	-- { -- entrée principale a droite
	-- 	textCoords = vector3(-556.33, -196.52, 38.22),
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door2',
	-- 			objYaw = -60.0,
	-- 			objCoords  = vector3( -555.87, -197.12, 38.22)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door2',
	-- 			objYaw = 120.0,
	-- 			objCoords  = vector3( -556.77, -195.98, 38.22)
	-- 		}
	-- 	}
	-- },
	-- { -- entrée principale a gauche
	-- 	textCoords = vector3(-546.12, -190.55, 38.22),
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door2',
	-- 			objYaw = -60.0,
	-- 			objCoords  = vector3( -545.92, -191.32, 38.22)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door2',
	-- 			objYaw = 120.0,
	-- 			objCoords  = vector3( -546.42, -190.04, 38.22)
	-- 		}
	-- 	}
	-- },

	-- { -- porte arrière vers garage OUEST
	-- 	textCoords = vector3(-582.67, -195.17, 38.22), 
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = -150.0,
	-- 			objCoords  = vector3( -583.11, -195.59, 38.22)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = 30.0,
	-- 			objCoords  = vector3( -582.15, -195.02, 38.22)
	-- 		}
	-- 	}
	-- },
	-- { -- porte arrière vers garage EST
	-- 	textCoords = vector3(-534.01, -167.11, 38.22), 
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = -150.0,
	-- 			objCoords  = vector3( -534.56, -167.29, 38.22)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = 30.0,
	-- 			objCoords  = vector3( -533.44, -166.97, 38.22)
	-- 		}
	-- 	}
	-- },
	-- { -- entrée aile droite centre
	-- 	textCoords = vector3(-516.0, -210.55, 38.22),
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = -60.0,
	-- 			objCoords  = vector3( -515.7, -210.97, 38.22)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = 120.0,
	-- 			objCoords  = vector3( -516.27, -210.05, 38.22)
	-- 		}
	-- 	}
	-- },
	-- { -- entrée aile droite exterieur
	-- 	textCoords = vector3(-506.65, -199.83, 34.25),
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'v_ilev_ra_door4r',
	-- 			objYaw = 120.0,
	-- 			objCoords  = vector3( -506.39, -200.32, 34.25)
	-- 		},
			
	-- 		{
	-- 			objName = 'v_ilev_ra_door4l',
	-- 			objYaw = 300.0,
	-- 			objCoords  = vector3( -506.8, -199.51, 34.25)
	-- 		}
	-- 	}
	-- },
	-- { -- entrée aile gauche centre
	-- 	textCoords = vector3(-556.44, -228.68, 38.22),
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = -60.0,
	-- 			objCoords  = vector3( -556.22, -229.08, 38.22)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door1',
	-- 			objYaw = 120.0,
	-- 			objCoords  = vector3( -556.53, -228.17, 38.22)
	-- 		}
	-- 	}
	-- },
	-- { -- entrée aile gauche exterieur
	-- 	textCoords = vector3(-567.79, -235.24, 34.25),
	-- 	authorizedJobs = { 'state' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'cls_cityhall_door3',
	-- 			objYaw = 120.0,
	-- 			objCoords  = vector3( -568.13, -234.8, 34.25)
	-- 		},
			
	-- 		{
	-- 			objName = 'cls_cityhall_door3',
	-- 			objYaw = 300.0,
	-- 			objCoords  = vector3( -567.82, -235.86, 34.25)
	-- 		}
	-- 	}
	-- },






	-- -- AGENT IMMO
	-- {
	-- 	textCoords = vector3(-139.79, -626.26, 168.82),
	-- 	authorizedJobs = { 'realestateagent' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'ex_prop_exec_office_door01',
	-- 			objYaw = 6.0,
	-- 			objCoords = vector3(-139.57, -626.05, 168.82)
	-- 		},
			
	-- 		{
	-- 			objName = 'ex_prop_exec_office_door01',
	-- 			objYaw = -174.0,
	-- 			objCoords = vector3(-140.25, -626.16, 168.82)
	-- 		}
	-- 	}
	-- },

	


	-- -- AMMUNATION
	-- { -- entrée 
	-- 	textCoords = vector3(17.42, -1114.96, 29.79),
	-- 	authorizedJobs = { 'ammunation' },
	-- 	locked = true,
	-- 	distance = 2.5,
	-- 	doors = {
	-- 		{
	-- 			objName = 'v_ilev_gc_door04',
	-- 			objYaw = 160.0,
	-- 			objCoords  = vector3( 16.62, -1114.90, 29.79)
	-- 		},
			
	-- 		{
	-- 			objName = 'v_ilev_gc_door03',
	-- 			objYaw = 340.0,
	-- 			objCoords  = vector3( 17.91, -1115.35, 29.8)
	-- 		}
	-- 	}
	-- },


}

