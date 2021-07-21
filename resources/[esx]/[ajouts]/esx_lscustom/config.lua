Config                 = {}
Config.DrawDistance    = 100.0
Config.Locale = 'fr'
Config.IsMecanoJobOnly = true
Config.EnableJobLogs   = false -- only turn this on if you are using esx_joblogs

Config.Zones = {

	ls1 = {
		Pos   = vector3(-1143.65, -2035.83, 12.14),
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	},

	ls2 = {
		Pos   = vector3(-1157.53, -2022.34, 12.14),
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	},

	ls3 = {
		Pos   = vector3(-1150.08, -2011.03, 12.25),
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	},

	lsdehors = {
		Pos   = vector3(-1149.95, -1983.33, 12.18),
		Size  = {x = 3.0, y = 3.0, z = 0.2},
		Color = {r = 204, g = 204, b = 0},
		Marker= 1,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	},

	-- lshidden = {
	-- 	Pos   = vector3(733.86, -1084.62, 21.19),
	-- 	Size  = {x = 3.0, y = 3.0, z = 0.2},
	-- 	Color = {r = 204, g = 204, b = 0},
	-- 	Marker= 1,
	-- 	Name  = _U('blip_name'),
	-- 	Hint  = _U('press_custom'),
    --     IsIllegal = true,
    --     WhiteList = {
    --         "main",
    --         "cosmetics",
    --         "resprays",
    --         "wheels",
    --         "modFrontWheelsColor",
    --         "wheelColor",
    --         "primaryRespray",
    --         "secondaryRespray",
    --         "pearlescentRespray",
    --         "color1",
    --         "color2",
    --         "pearlescentColor",
    --         "windowTint",
    --         "plateIndex",
    --     }
	-- },


	-- ls_lspd = {
	-- 	Pos   = vector3(871.67, -1350.52, 25.33),
	-- 	Size  = {x = 3.0, y = 3.0, z = 0.2},
	-- 	Color = {r = 204, g = 204, b = 0},
	-- 	Marker= 1,
	-- 	Name  = _U('blip_name'),
	-- 	Hint  = _U('press_custom'),
    --     IsOnlyCash = true,
    --     WhiteList = {
    --         "main",
    --         "cosmetics",
    --         "resprays",
    --         "wheels",
    --         "modFrontWheelsColor",
    --         "wheelColor",
    --         "primaryRespray",
    --         "secondaryRespray",
    --         "pearlescentRespray",
    --         "color1",
    --         "color2",
    --         "pearlescentColor",
    --         "windowTint",
    --         "plateIndex",
    --     }
	-- }

}

Config.Colors = {
	{ label = _U('classic'), value = 'classic'},
	{ label = _U('matte'), value = 'matte'},
	{ label = _U('metal'), value = 'metal'},
	{ label = _U('util'), value = 'util'},
	{ label = _U('worn'), value = 'worn'},
}

function GetColors(type)
	local colors = {}
    if type == "classic" then
        colors = {
            {id = 0, name = "BLACK"},
            {id = 1, name = "GRAPHITE"},
            {id = 2, name = "BLACK_STEEL"},
            {id = 3, name = "DARK_SILVER"},
            {id = 4, name = "SILVER"},
            {id = 5, name = "BLUE_SILVER"},
            {id = 6, name = "ROLLED_STEEL"},
            {id = 7, name = "SHADOW_SILVER"},
            {id = 8, name = "STONE_SILVER"},
            {id = 9, name = "MIDNIGHT_SILVER"},
            {id = 10, name = "CAST_IRON_SIL"},
            {id = 11, name = "ANTHR_BLACK"},

            {id = 27, name = "RED"},
            {id = 28, name = "TORINO_RED"},
            {id = 29, name = "FORMULA_RED"},
            {id = 30, name = "BLAZE_RED"},
            {id = 31, name = "GRACE_RED"},
            {id = 32, name = "GARNET_RED"},
            {id = 33, name = "SUNSET_RED"},
            {id = 34, name = "CABERNET_RED"},
            {id = 35, name = "CANDY_RED"},
            {id = 36, name = "SUNRISE_ORANGE"},
            {id = 37, name = "GOLD"},
            {id = 38, name = "ORANGE"},

            {id = 49, name = "DARK_GREEN"},
            {id = 50, name = "RACING_GREEN"},
            {id = 51, name = "SEA_GREEN"},
            {id = 52, name = "OLIVE_GREEN"},
            {id = 53, name = "BRIGHT_GREEN"},
            {id = 54, name = "PETROL_GREEN"},

            {id = 61, name = "GALAXY_BLUE"},
            {id = 62, name = "DARK_BLUE"},
            {id = 63, name = "SAXON_BLUE"},
            {id = 64, name = "BLUE"},
            {id = 65, name = "MARINER_BLUE"},
            {id = 66, name = "HARBOR_BLUE"},
            {id = 67, name = "DIAMOND_BLUE"},
            {id = 68, name = "SURF_BLUE"},
            {id = 69, name = "NAUTICAL_BLUE"},
            {id = 70, name = "ULTRA_BLUE"},
            {id = 71, name = "PURPLE"},
            {id = 72, name = "SPIN_PURPLE"},
            {id = 73, name = "RACING_BLUE"},
            {id = 74, name = "LIGHT_BLUE"},

            {id = 88, name = "YELLOW"},
            {id = 89, name = "RACE_YELLOW"},
            {id = 90, name = "BRONZE"},
            {id = 91, name = "FLUR_YELLOW"},
            {id = 92, name = "LIME_GREEN"},

            {id = 94, name = "UMBER_BROWN"},
            {id = 95, name = "CREEK_BROWN"},
            {id = 96, name = "CHOCOLATE_BROWN"},
            {id = 97, name = "MAPLE_BROWN"},
            {id = 98, name = "SADDLE_BROWN"},
            {id = 99, name = "STRAW_BROWN"},
            {id = 100, name = "MOSS_BROWN"},
            {id = 101, name = "BISON_BROWN"},
            {id = 102, name = "WOODBEECH_BROWN"},
            {id = 103, name = "BEECHWOOD_BROWN"},
            {id = 104, name = "SIENNA_BROWN"},
            {id = 105, name = "SANDY_BROWN"},
            {id = 106, name = "BLEECHED_BROWN"},
            {id = 107, name = "CREAM"},

            {id = 111, name = "WHITE"},
            {id = 112, name = "FROST_WHITE"},

            {id = 135, name = "HOT PINK"},
            {id = 136, name = "SALMON_PINK"},
            {id = 137, name = "PINK"},
            {id = 138, name = "BRIGHT_ORANGE"},

            {id = 141, name = "MIDNIGHT_BLUE"},
            {id = 142, name = "MIGHT_PURPLE"},
            {id = 143, name = "WINE_RED"},

            {id = 145, name = "BRIGHT_PURPLE"},
            {id = 146, name = "VERY_DARK_BLUE"},
            {id = 147, name = "BLACK_GRAPHITE"},

            {id = 150, name = "LAVA_RED"}
        }

    elseif type == "matte" then
        colors = {
            {id = 12, name = "BLACK"},
            {id = 13, name = "GREY"},
            {id = 14, name = "LIGHT_GREY"},

            {id = 39, name = "RED"},
            {id = 40, name = "DARK_RED"},
            {id = 41, name = "ORANGE"},
            {id = 42, name = "YELLOW"},

            {id = 55, name = "LIME_GREEN"},

            {id = 82, name = "DARK_BLUE"},
            {id = 83, name = "BLUE"},
            {id = 84, name = "MIDNIGHT_BLUE"},

            {id = 128, name = "GREEN"},

            {id = 148, name = "Purple"},
            {id = 149, name = "MIGHT_PURPLE"},

            {id = 151, name = "MATTE_FOR"},
            {id = 152, name = "MATTE_OD"},
            {id = 153, name = "MATTE_DIRT"},
            {id = 154, name = "MATTE_DESERT"},
            {id = 155, name = "MATTE_FOIL"}
        }

    elseif type == "metal" then
        colors = {
            {id = 117, name = "BR_STEEL"},
            {id = 118, name = "BR BLACK_STEEL"},
            {id = 119, name = "BR_ALUMINIUM"},

            {id = 158, name = "GOLD_P"},
            {id = 159, name = "GOLD_S"},

            {id = 120, name = "CHROME"}
        };

    elseif type == "util" then
        colors = {
            {id = 15, name = "BLACK"},
            {id = 16, name = "FMMC_COL1_1"},
            {id = 17, name = "DARK_SILVER"},
            {id = 18, name = "SILVER"},
            {id = 19, name = "BLACK_STEEL"},
            {id = 20, name = "SHADOW_SILVER"},

            {id = 43, name = "DARK_RED"},
            {id = 44, name = "RED"},
            {id = 45, name = "GARNET_RED"},

            {id = 56, name = "DARK_GREEN"},
            {id = 57, name = "GREEN"},

            {id = 75, name = "DARK_BLUE"},
            {id = 76, name = "MIDNIGHT_BLUE"},
            {id = 77, name = "SAXON_BLUE"},
            {id = 78, name = "NAUTICAL_BLUE"},
            {id = 79, name = "BLUE"},
            {id = 80, name = "FMMC_COL1_13"},
            {id = 81, name = "BRIGHT_PURPLE"},

            {id = 93, name = "STRAW_BROWN"},

            {id = 108, name = "UMBER_BROWN"},
            {id = 109, name = "MOSS_BROWN"},
            {id = 110, name = "SANDY_BROWN"},

            {id = 122, name = "veh_color_off_white"},

            {id = 125, name = "BRIGHT_GREEN"},

            {id = 127, name = "HARBOR_BLUE"},

            {id = 134, name = "FROST_WHITE"},

            {id = 139, name = "LIME_GREEN"},
            {id = 140, name = "ULTRA_BLUE"},

            {id = 144, name = "GREY"},

            {id = 157, name = "LIGHT_BLUE"},

            {id = 160, name = "YELLOW"}
        }

    elseif type == "worn" then
        colors = {
            {id = 21, name = "BLACK"},
            {id = 22, name = "GRAPHITE"},
            {id = 23, name = "LIGHT_GREY"},
            {id = 24, name = "SILVER"},
            {id = 25, name = "BLUE_SILVER"},
            {id = 26, name = "SHADOW_SILVER"},

            {id = 46, name = "RED"},
            {id = 47, name = "SALMON_PINK"},
            {id = 48, name = "DARK_RED"},

            {id = 58, name = "DARK_GREEN"},
            {id = 59, name = "GREEN"},
            {id = 60, name = "SEA_GREEN"},

            {id = 85, name = "DARK_BLUE"},
            {id = 86, name = "BLUE"},
            {id = 87, name = "LIGHT_BLUE"},

            {id = 113, name = "SANDY_BROWN"},
            {id = 114, name = "BISON_BROWN"},
            {id = 115, name = "CREEK_BROWN"},
            {id = 116, name = "BLEECHED_BROWN"},

            {id = 121, name = "veh_color_off_white"},

            {id = 123, name = "ORANGE"},
            {id = 124, name = "SUNRISE_ORANGE"},

            {id = 126, name = "veh_color_taxi_yellow"},

            {id = 129, name = "RACING_GREEN"},
            {id = 130, name = "ORANGE"},
            {id = 131, name = "WHITE"},
            {id = 132, name = "FROST_WHITE"},
            {id = 133, name = "OLIVE_GREEN"},
        }
    end

	return colors
end

function GetWindowName(index)
	if (index == 1) then
		return "Pure Black"
	elseif (index == 2) then
		return "Darksmoke"
	elseif (index == 3) then
		return "Lightsmoke"
	elseif (index == 4) then
		return "Limo"
	elseif (index == 5) then
		return "Green"
	else
		return "Unknown"
	end
end

function GetHornName(index)
	if (index == -1) then
		return GetLabelText("CMOD_HRN_0")
    elseif (index == 0) then
		return GetLabelText("CMOD_HRN_TRK")
	elseif (index == 1) then
		return GetLabelText("CMOD_HRN_COP")
	elseif (index == 2) then
		return GetLabelText("CMOD_HRN_CLO")
	elseif (index == 3) then
		return GetLabelText("CMOD_HRN_MUS1")
	elseif (index == 4) then
		return GetLabelText("CMOD_HRN_MUS2")
	elseif (index == 5) then
		return GetLabelText("CMOD_HRN_MUS3")
	elseif (index == 6) then
		return GetLabelText("CMOD_HRN_MUS4")
	elseif (index == 7) then
		return GetLabelText("CMOD_HRN_MUS5")
	elseif (index == 8) then
		return GetLabelText("CMOD_HRN_SAD")
	elseif (index == 9) then
		return GetLabelText("HORN_CLAS1")
	elseif (index == 10) then
		return GetLabelText("HORN_CLAS2")
	elseif (index == 11) then
		return GetLabelText("HORN_CLAS3")
	elseif (index == 12) then
		return GetLabelText("HORN_CLAS4")
	elseif (index == 13) then
		return GetLabelText("HORN_CLAS5")
	elseif (index == 14) then
		return GetLabelText("HORN_CLAS6")
	elseif (index == 15) then
		return GetLabelText("HORN_CLAS7")
	elseif (index == 16) then
		return GetLabelText("HORN_CNOTE_C0")
	elseif (index == 17) then
		return GetLabelText("HORN_CNOTE_D0")
	elseif (index == 18) then
		return GetLabelText("HORN_CNOTE_E0")
	elseif (index == 19) then
		return GetLabelText("HORN_CNOTE_F0")
	elseif (index == 20) then
		return GetLabelText("HORN_CNOTE_G0")
	elseif (index == 21) then
		return GetLabelText("HORN_CNOTE_A0")
	elseif (index == 22) then
		return GetLabelText("HORN_CNOTE_B0")
	elseif (index == 23) then
		return GetLabelText("HORN_CNOTE_C1")
	elseif (index == 24) then
		return GetLabelText("HORN_HIPS1")
	elseif (index == 25) then
		return GetLabelText("HORN_HIPS2")
	elseif (index == 26) then
		return GetLabelText("HORN_HIPS3")
	elseif (index == 27) then
		return GetLabelText("HORN_HIPS4")
	elseif (index == 28) then
		return GetLabelText("HORN_INDI_1")
	elseif (index == 29) then
		return GetLabelText("HORN_INDI_2")
	elseif (index == 30) then
		return GetLabelText("HORN_INDI_3")
	elseif (index == 31) then
		return GetLabelText("HORN_INDI_4")
	elseif (index == 32) then
		return GetLabelText("HORN_LUXE2")
	elseif (index == 33) then
		return GetLabelText("HORN_LUXE1")
	elseif (index == 34) then
		return GetLabelText("HORN_LUXE3")
	elseif (index == 35) then
		return GetLabelText("HORN_LUXE2") .. " (2)" -- same as 32, but this one auto stop on first loop
	elseif (index == 36) then
		return GetLabelText("HORN_LUXE1") .. " (2)" -- same as 33, but this one auto stop on first loop
	elseif (index == 37) then
		return GetLabelText("HORN_LUXE3") .. " (2)" -- same as 34, but this one auto stop on first loop
	elseif (index == 38) then
		return GetLabelText("HORN_HWEEN1")
	elseif (index == 39) then
		return GetLabelText("HORN_HWEEN1") .. " (2)" -- same as 38, but this one auto stop on first loop
	elseif (index == 40) then
		return GetLabelText("HORN_HWEEN2")
	elseif (index == 41) then
		return GetLabelText("HORN_HWEEN2") .. " (2)" -- same as 40, but this one auto stop on first loop
	elseif (index == 42) then
		return GetLabelText("HORN_LOWRDER1")
	elseif (index == 43) then
		return GetLabelText("HORN_LOWRDER1") .. " (2)" -- same as 43, but this one auto stop on first loop
	elseif (index == 44) then
		return GetLabelText("HORN_LOWRDER2")
	elseif (index == 45) then
		return GetLabelText("HORN_LOWRDER2") .. " (2)" -- same as 44, but this one auto stop on first loop
	elseif (index == 46) then
		return GetLabelText("HORN_XM15_1")
	elseif (index == 47) then
		return GetLabelText("HORN_XM15_1") .. " (2)" -- almost the same as 46, but this one auto stop on first loop
	elseif (index == 48) then
		return GetLabelText("HORN_XM15_2")
	elseif (index == 49) then
		return GetLabelText("HORN_XM15_2") .. " (2)" -- almost the same as 48, but this one auto stop on first loop
	elseif (index == 50) then
		return GetLabelText("HORN_XM15_3")
	elseif (index == 51) then
		return GetLabelText("HORN_XM15_3") .. " (2)" -- almost the same as 51, but this one auto stop on first loop
	elseif (index == 52) then
		return GetLabelText("CMOD_AIRHORN_01")
	elseif (index == 53) then
		return GetLabelText("CMOD_AIRHORN_01") .. " (2)" -- same as 52, but this one auto stop on first loop
	elseif (index == 54) then
		return GetLabelText("CMOD_AIRHORN_02")
	elseif (index == 55) then
		return GetLabelText("CMOD_AIRHORN_02") .. " (2)" -- same as 54, but this one auto stop on first loop
	elseif (index == 56) then
		return GetLabelText("CMOD_AIRHORN_03")
	elseif (index == 57) then
		return GetLabelText("CMOD_AIRHORN_03") .. " (2)" -- same as 56, but this one auto stop on first loop
	else
		return "Klaxon #" .. index
	end
end

function GetNeons()
	local neons = {
		{ label = 'Blanc',		    r = 255, 	g = 255, 	b = 255},
		{ label = "Slate Gray",		r = 112, 	g = 128, 	b = 144},
		{ label = "Blue",			r = 0, 		g = 0, 		b = 255},
		{ label = "Light Blue",		r = 0, 		g = 150, 	b = 255},
		{ label = "Navy Blue", 		r = 0, 		g = 0, 		b = 128},
		{ label = "Sky Blue", 		r = 135, 	g = 206, 	b = 235},
		{ label = "Turquoise", 		r = 0, 		g = 245, 	b = 255},
		{ label = "Mint Green", 	r = 50, 	g = 255, 	b = 155},
		{ label = "Lime Green", 	r = 0, 		g = 255, 	b = 0},
		{ label = "Olive", 			r = 128, 	g = 128, 	b = 0},
		{ label = 'Jaune', 	    r = 255, 	g = 255, 	b = 0},
		{ label = 'Doré', 		    r = 255, 	g = 215, 	b = 0},
		{ label = 'orange', 	    r = 255, 	g = 165, 	b = 0},
		{ label = 'Blé', 		    r = 245, 	g = 222, 	b = 179},
		{ label = 'Rouge', 		    r = 255, 	g = 0, 		b = 0},
		{ label = 'Rose', 		    r = 255, 	g = 161, 	b = 211},
		{ label = 'Rose brillant',	    r = 255, 	g = 0, 		b = 255},
		{ label = 'Violet', 	    r = 153, 	g = 0, 		b = 153},
		{ label = "Ivory", 			r = 41, 	g = 36, 	b = 33}
	}

	return neons
end

function GetXenonColors()
	local xenons = {
		{ index = 0, label = "Blanc"},
		{ index = 1, label = "Bleu"},
		{ index = 2, label = "Bleu électrique"},
		{ index = 3, label = "Vert menthe"},
		{ index = 4, label = "Vert lime"},
		{ index = 5, label = "Jaune"},
		{ index = 6, label = "Golden Shower"},
		{ index = 7, label = "Orange"},
		{ index = 8, label = "Red"},
		{ index = 9, label = "Rose"},
		{ index = 10, label = "Rose hot"},
		{ index = 11, label = "Violet"},
		{ index = 12, label = "Lumière noire"}
	}

	return xenons
end

function GetPlatesName(index)
	if (index == 0) then
		return _U('blue_on_white_1')
	elseif (index == 1) then
		return _U('yellow_on_black')
	elseif (index == 2) then
		return _U('yellow_blue')
	elseif (index == 3) then
		return _U('blue_on_white_2')
	elseif (index == 4) then
		return _U('blue_on_white_3')
	end
end

Config.Menus = {
	main = {
		label		= 'LS CUSTOMS',
		parent		= nil,
		cosmetics	= _U('cosmetics'),
		upgrades	= _U('upgrades'),
		extra		= "Extras"

	},
	upgrades = {
		label			= _U('upgrades'),
		parent			= 'main',
		modEngine		= _U('engine'),
		modBrakes		= _U('brakes'),
		modTransmission	= _U('transmission'),
		modSuspension	= _U('suspension'),
		-- modArmor		= _U('armor'),
		modTurbo		= _U('turbo')
	},
	modEngine = {
		label = _U('engine'),
		parent = 'upgrades',
		modType = 11,
		price = {8.20, 12.40, 18.60, 26.70}
	},
	modBrakes = {
		label = _U('brakes'),
		parent = 'upgrades',
		modType = 12,
		price = {2.06, 4.1, 6.2, 8.2}
	},
	modTransmission = {
		label = _U('transmission'),
		parent = 'upgrades',
		modType = 13,
		price = {8.2, 16.3, 24.67}
	},
	modSuspension = {
		label = _U('suspension'),
		parent = 'upgrades',
		modType = 15,
		price = {1.65, 3.30, 6.61, 13.23, 17.86}
	},
	-- modArmor = {
		-- label = _U('armor'),
		-- parent = 'upgrades',
		-- modType = 16,
		-- price = {69.77, 116.28, 130.00, 150.00, 180.00, 190.00}
	-- },
	modTurbo = {
		label = _U('turbo'),
		parent = 'upgrades',
		modType = 17,
		price = {35.60}
	},
	cosmetics = {
		label				= _U('cosmetics'),
		parent				= 'main',
		bodyparts			= _U('bodyparts'),
		windowTint			= _U('windowtint'),
		modHorns			= _U('horns'),
		neonColor			= _U('neons'),
		resprays			= _U('respray'),
		modXenon			= _U('headlights'),
		modXenonColour   	= _U('headlights').." -  Couleur",
		plateIndex			= _U('licenseplates'),
		wheels				= _U('wheels'),
		modPlateHolder		= _U('modplateholder'),
		modVanityPlate		= _U('modvanityplate'),
		modTrimA			= _U('interior'),
		modOrnaments		= _U('trim'),
		modDashboard		= _U('dashboard'),
		modDial				= _U('speedometer'),
		modDoorSpeaker		= _U('door_speakers'),
		modSeats			= _U('seats'),
		modSteeringWheel	= _U('steering_wheel'),
		modShifterLeavers	= _U('gear_lever'),
		modAPlate			= _U('quarter_deck'),
		modSpeakers			= _U('speakers'),
		modTrunk			= _U('trunk'),
		modHydrolic			= _U('hydraulic'),
		modEngineBlock		= _U('engine_block'),
		modAirFilter		= _U('air_filter'),
		modStruts			= _U('struts'),
		modArchCover		= _U('arch_cover'),
		modAerials			= _U('aerials'),
		modTrimB			= _U('wings'),
		modTank				= _U('fuel_tank'),
		modWindows			= _U('windows'),
		modLivery			= _U('stickers'),
		modLivery2			= _U('stickers') -- ambulance liveries and others

	},

	modPlateHolder = {
		label = _U('modplateholder'),
		parent = 'cosmetics',
		modType = 25,
		price = 1.55
	},
	modVanityPlate = {
		label = _U('modvanityplate'),
		parent = 'cosmetics',
		modType = 26,
		price = 0.4
	},
	modTrimA = {
		label = _U('interior'),
		parent = 'cosmetics',
		modType = 27,
		price = 3.10
	},
	modOrnaments = {
		label = _U('trim'),
		parent = 'cosmetics',
		modType = 28,
		price = 0.4
	},
	modDashboard = {
		label = _U('dashboard'),
		parent = 'cosmetics',
		modType = 29,
		price = 2.06
	},
	modDial = {
		label = _U('speedometer'),
		parent = 'cosmetics',
		modType = 30,
		price = 1.86
	},
	modDoorSpeaker = {
		label = _U('door_speakers'),
		parent = 'cosmetics',
		modType = 31,
		price = 2.48
	},
	modSeats = {
		label = _U('seats'),
		parent = 'cosmetics',
		modType = 32,
		price = 2.06
	},
	modSteeringWheel = {
		label = _U('steering_wheel'),
		parent = 'cosmetics',
		modType = 33,
		price = 1.86
	},
	modShifterLeavers = {
		label = _U('gear_lever'),
		parent = 'cosmetics',
		modType = 34,
		price = 1.44
	},
	modAPlate = {
		label = _U('quarter_deck'),
		parent = 'cosmetics',
		modType = 35,
		price = 1.86
	},
	modSpeakers = {
		label = _U('speakers'),
		parent = 'cosmetics',
		modType = 36,
		price = 3.10
	},
	modTrunk = {
		label = _U('trunk'),
		parent = 'cosmetics',
		modType = 37,
		price = 2.48
	},
	modHydrolic = {
		label = _U('hydraulic'),
		parent = 'cosmetics',
		modType = 38,
		price = 2.27
	},
	modEngineBlock = {
		label = _U('engine_block'),
		parent = 'cosmetics',
		modType = 39,
		price = 2.27
	},
	modAirFilter = {
		label = _U('air_filter'),
		parent = 'cosmetics',
		modType = 40,
		price = 1.65
	},
	modStruts = {
		label = _U('struts'),
		parent = 'cosmetics',
		modType = 41,
		price = 2.89
	},
	modArchCover = {
		label = _U('arch_cover'),
		parent = 'cosmetics',
		modType = 42,
		price = 1.86
	},
	modAerials = {
		label = _U('aerials'),
		parent = 'cosmetics',
		modType = 43,
		price = 0.49
	},
	modTrimB = {
		label = _U('wings'),
		parent = 'cosmetics',
		modType = 44,
		price = 2.68
	},
	modTank = {
		label = _U('fuel_tank'),
		parent = 'cosmetics',
		modType = 45,
		price = 1.86
	},
	modWindows = {
		label = _U('windows'),
		parent = 'cosmetics',
		modType = 46,
		price = 1.86
	},
	modLivery = {
		label = _U('stickers'),
		parent = 'cosmetics',
		modType = 48,
		price = 4.13
	},
	modLivery2 = { -- ambulance liveries and others
		label = _U('stickers'),
		parent = 'cosmetics',
		modType = "modLivery",
		price = 4.13
	},

	wheels = {
		label = _U('wheels'),
		parent = 'cosmetics',
		modFrontWheelsTypes = _U('wheel_type'),
		modFrontWheelsColor = _U('wheel_color'),
		tyreSmokeColor = _U('tiresmoke')
	},
	modFrontWheelsTypes = {
		label				= _U('wheel_type'),
		parent				= 'wheels',
		modFrontWheelsType0	= _U('sport'),
		modFrontWheelsType1	= _U('muscle'),
		modFrontWheelsType2	= _U('lowrider'),
		modFrontWheelsType3	= _U('suv'),
		modFrontWheelsType4	= _U('allterrain'),
		modFrontWheelsType5	= _U('tuning'),
		modFrontWheelsType6	= _U('motorcycle'),
		modFrontWheelsType7	= _U('highend'),
		modFrontWheelsType8	= "Jantes Benny's 1",
		modFrontWheelsType9	= "Jantes Benny's 2"
	},
	modFrontWheelsType0 = {
		label = _U('sport'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 0,
		price = 2.06
	},
	modFrontWheelsType1 = {
		label = _U('muscle'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 1,
		price = 1.86
	},
	modFrontWheelsType2 = {
		label = _U('lowrider'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 2,
		price = 2.06
	},
	modFrontWheelsType3 = {
		label = _U('suv'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 3,
		price = 1.86
	},
	modFrontWheelsType4 = {
		label = _U('allterrain'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 4,
		price = 1.86
	},
	modFrontWheelsType5 = {
		label = _U('tuning'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 5,
		price = 2.27
	},
	modFrontWheelsType6 = {
		label = _U('motorcycle'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 6,
		price = 1.44
	},
	modFrontWheelsType7 = {
		label = _U('highend'),
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 7,
		price = 2.27
	},
	modFrontWheelsType8 = {
		label = "Jantes Benny's 1",
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 8,
		price = 2.27
	},
	modFrontWheelsType9 = {
		label = "Jantes Benny's 2",
		parent = 'modFrontWheelsTypes',
		modType = 23,
		wheelType = 9,
		price = 2.27
	},
	modFrontWheelsColor = {
		label = _U('wheel_color'),
		parent = 'wheels'
	},
	wheelColor = {
		label = _U('wheel_color'),
		parent = 'modFrontWheelsColor',
		modType = 'wheelColor',
		price = 0.29
	},
	plateIndex = {
		label = _U('licenseplates'),
		parent = 'cosmetics',
		modType = 'plateIndex',
		price = 0.48
	},
	resprays = {
		label = _U('respray'),
		parent = 'cosmetics',
		primaryRespray = _U('primary'),
		secondaryRespray = _U('secondary'),
		pearlescentRespray = _U('pearlescent'),
		modInteriorColor = _U('modInteriorRespray'),
		modDashboardColor = _U('modDashboardRespray'),
	},
	primaryRespray = {
		label = _U('primary'),
		parent = 'resprays',
	},
	secondaryRespray = {
		label = _U('secondary'),
		parent = 'resprays',
	},
	pearlescentRespray = {
		label = _U('pearlescent'),
		parent = 'resprays',
	},
	color1 = {
		label = _U('primary'),
		parent = 'primaryRespray',
		modType = 'color1',
		price = 0.49
	},
	color2 = {
		label = _U('secondary'),
		parent = 'secondaryRespray',
		modType = 'color2',
		price = 0.29
	},
	pearlescentColor = {
		label = _U('pearlescent'),
		parent = 'pearlescentRespray',
		modType = 'pearlescentColor',
		price = 0.39
	},
    modInteriorColor = {
		label = _U('modInteriorRespray'),
		parent = 'resprays',
		modType = 'modInteriorColor',
		price = 0.39
	},
	modDashboardColor = {
		label = _U('modDashboardRespray'),
		parent = 'resprays',
		modType = 'modDashboardColor',
		price = 0.39
	},
	modXenon = {
		label = _U('headlights'),
		parent = 'cosmetics',
		modType = 22,
		price = 1.65
	},
	modXenonColour = {
		label = _U('headlights').." -  Couleur",
		parent = 'cosmetics',
		modType = 'modXenonColour',
		price = 4.65
	},
	bodyparts = {
		label = _U('bodyparts'),
		parent = 'cosmetics',
		modFender = _U('leftfender'),
		modRightFender = _U('rightfender'),
		modSpoilers = _U('spoilers'),
		modSideSkirt = _U('sideskirt'),
		modFrame = _U('cage'),
		modHood = _U('hood'),
		modGrille = _U('grille'),
		modRearBumper = _U('rearbumper'),
		modFrontBumper = _U('frontbumper'),
		modExhaust = _U('exhaust'),
		modRoof = _U('roof')
	},
	modSpoilers = {
		label = _U('spoilers'),
		parent = 'bodyparts',
		modType = 0,
		price = 2.06
	},
	modFrontBumper = {
		label = _U('frontbumper'),
		parent = 'bodyparts',
		modType = 1,
		price = 2.27
	},
	modRearBumper = {
		label = _U('rearbumper'),
		parent = 'bodyparts',
		modType = 2,
		price = 2.27
	},
	modSideSkirt = {
		label = _U('sideskirt'),
		parent = 'bodyparts',
		modType = 3,
		price = 2.06
	},
	modExhaust = {
		label = _U('exhaust'),
		parent = 'bodyparts',
		modType = 4,
		price = 2.27
	},
	modFrame = {
		label = _U('cage'),
		parent = 'bodyparts',
		modType = 5,
		price = 2.27
	},
	modGrille = {
		label = _U('grille'),
		parent = 'bodyparts',
		modType = 6,
		price = 1.65
	},
	modHood = {
		label = _U('hood'),
		parent = 'bodyparts',
		modType = 7,
		price = 2.16
	},
	modFender = {
		label = _U('leftfender'),
		parent = 'bodyparts',
		modType = 8,
		price = 2.27
	},
	modRightFender = {
		label = _U('rightfender'),
		parent = 'bodyparts',
		modType = 9,
		price = 2.27
	},
	modRoof = {
		label = _U('roof'),
		parent = 'bodyparts',
		modType = 10,
		price = 2.27
	},
	windowTint = {
		label = _U('windowtint'),
		parent = 'cosmetics',
		modType = 'windowTint',
		price = 0.49
	},
	modHorns = {
		label = _U('horns'),
		parent = 'cosmetics',
		modType = 14,
		price = 0.49
	},
	neonColor = {
		label = _U('neons'),
		parent = 'cosmetics',
		modType = 'neonColor',
		price = 0.49
	},
	tyreSmokeColor = {
		label = _U('tiresmoke'),
		parent = 'wheels',
		modType = 'tyreSmokeColor',
		price = 0.49
	}

}

---------------------------------
--- Copyright by ikNox#6088 ---
---------------------------------