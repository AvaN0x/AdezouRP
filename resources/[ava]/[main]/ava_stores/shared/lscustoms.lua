-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.LSCustoms = {
    MinimumBodyHealth = 950.0,
    MinimumEngineHealth = 950.0,

    JobPartPaid = 0.8,
    AllowedJobsToPay = { mechanic = true },

    Menu = {
        {
            label = GetString("lscustoms_aesthetics"),
            menu = {
                { label = GetString("lscustoms_extras"), mod = "extras" },
                { label = GetString("lscustoms_livery"), mod = "livery" },
                { label = GetString("lscustoms_modLivery"), mod = "modLivery" },
                {
                    label = GetString("lscustoms_bumpers"),
                    menu = {
                        { label = GetString("lscustoms_frontBumper"), mod = "modFrontBumper" },
                        { label = GetString("lscustoms_rearBumper"), mod = "modRearBumper" },
                    }
                },
                { label = GetString("lscustoms_exhaust"), mod = "modExhaust" },
                { label = GetString("lscustoms_hood"), mod = "modHood" },
                { label = GetString("lscustoms_hydraulics"), mod = "modHydraulics" },
                {
                    label = GetString("lscustoms_cockpit"),
                    menu = {
                        { label = GetString("lscustoms_dashboard"), mod = "modDashboard" },
                        { label = GetString("lscustoms_seats"), mod = "modSeats" },
                        { label = GetString("lscustoms_steeringWheel"), mod = "modSteeringWheel" },
                        { label = GetString("lscustoms_shifterLeavers"), mod = "modShifterLeavers" },
                        { label = GetString("lscustoms_dial"), mod = "modDial" },
                        { label = GetString("lscustoms_ornaments"), mod = "modOrnaments" },
                        { label = GetString("lscustoms_doorSpeaker"), mod = "modDoorSpeaker" },
                        { label = GetString("lscustoms_plaques"), mod = "modPlaques" },
                        { label = GetString("lscustoms_speakers"), mod = "modSpeakers" },
                    }
                },
                { label = GetString("lscustoms_roof"), mod = "modRoof" },
                { label = GetString("lscustoms_sideSkirt"), mod = "modSideSkirt" },
                { label = GetString("lscustoms_spoilers"), mod = "modSpoilers" },
                { label = GetString("lscustoms_trunk"), mod = "modTrunk" },
                { label = GetString("lscustoms_trimA"), mod = "modTrimA" },
                { label = GetString("lscustoms_trimB"), mod = "modTrimB" },
                { label = GetString("lscustoms_engineBlock"), mod = "modEngineBlock" },
                { label = GetString("lscustoms_airFilter"), mod = "modAirFilter" },
                { label = GetString("lscustoms_struts"), mod = "modStruts" },
                { label = GetString("lscustoms_archCover"), mod = "modArchCover" },
                { label = GetString("lscustoms_aerials"), mod = "modAerials" },
                { label = GetString("lscustoms_tank"), mod = "modTank" },
                { label = GetString("lscustoms_doorL"), mod = "modDoorL" },
                { label = GetString("lscustoms_doorR"), mod = "modDoorR" },
                { label = GetString("lscustoms_lightbar"), mod = "modLightbar" },
                { label = GetString("lscustoms_fender"), mod = "modFender" },
                { label = GetString("lscustoms_frame"), mod = "modFrame" },
                { label = GetString("lscustoms_grille"), mod = "modGrille" },
                {
                    label = GetString("lscustoms_lights"),
                    menu = {
                        { label = GetString("lscustoms_xenon"), mod = "modXenon" },
                        { label = GetString("lscustoms_xenonColour"), mod = "modXenonColour" },
                        { label = GetString("lscustoms_neonColor"), mod = "neonColor" },
                    }
                },
                {
                    label = GetString("lscustoms_respray"),
                    menu = {
                        { label = GetString("lscustoms_colorPrimary"), mod = "colorPrimary" },
                        { label = GetString("lscustoms_colorSecondary"), mod = "colorSecondary" },
                        { label = GetString("lscustoms_pearlescentColor"), mod = "pearlescentColor" },
                        { label = GetString("lscustoms_dashboardColor"), mod = "dashboardColor" },
                        { label = GetString("lscustoms_interiorColor"), mod = "interiorColor" },
                    }
                },
                {
                    label = GetString("lscustoms_wheels"),
                    menu = {
                        { label = GetString("lscustoms_wheelsType"), mod = "wheelsType" },
                        { label = GetString("lscustoms_wheelColor"), mod = "wheelsColor" },
                        { label = GetString("lscustoms_tyreSmokeColor"), mod = "tyreSmokeColor" },
                    }
                },
                { label = GetString("lscustoms_horn"), mod = "modHorn" },
                { label = GetString("lscustoms_plateIndex"), mod = "plateIndex" },
                { label = GetString("lscustoms_plateHolder"), mod = "modPlateHolder" },
                { label = GetString("lscustoms_vanityPlate"), mod = "modVanityPlate" },
                { label = GetString("lscustoms_windowTint"), mod = "windowTint" },
            }
        },
        {
            label = GetString("lscustoms_performances"),
            menu = {
                -- { label = GetString("lscustoms_armor"), mod = "modArmor" },
                { label = GetString("lscustoms_brakes"), mod = "modBrakes" },
                { label = GetString("lscustoms_engine"), mod = "modEngine" },
                { label = GetString("lscustoms_suspension"), mod = "modSuspension" },
                { label = GetString("lscustoms_transmission"), mod = "modTransmission" },
                { label = GetString("lscustoms_turbo"), mod = "modTurbo" },
            }
        },
    },
    Mods = {
        modArmor = {
            priceMultiplier = 1.5, -- TODO price based on level
            type = "mod",
            mod = 16,
            displayAsLevels = true
        },
        modBrakes = {
            priceMultiplier = 0.08, -- TODO price based on level
            type = "mod",
            mod = 12,
            displayAsLevels = true
        },
        modEngine = {
            priceMultiplier = 0.25, -- TODO price based on level
            type = "mod",
            mod = 11,
            displayAsLevels = true
        },
        modSuspension = {
            priceMultiplier = 0.15, -- TODO price based on level
            type = "mod",
            mod = 15,
            displayAsLevels = true
        },
        modTransmission = {
            priceMultiplier = 0.23, -- TODO price based on level
            type = "mod",
            mod = 13,
            displayAsLevels = true
        },
        modTurbo = {
            priceMultiplier = 0.35,
            type = "toggle",
            mod = 18
        },
        modSpoilers = {
            priceMultiplier = 0.025,
            -- staticPrice = 10000,
            type = "mod",
            mod = 0
        },
        wheelsColor = {
            priceMultiplier = 0.008,
            type = "color", -- TODO
            target = "wheels"
        },
        wheelsType = {
            priceMultiplier = 0.05,
            type = "wheels", -- TODO
            -- Somehow get type and select the correct wheel
            -- modFrontWheels
            -- modCustomTiresF
            -- modBackWheels
            -- modCustomTiresR
        },
        tyreSmokeColor = {
            priceMultiplier = 0.008,
            type = "list",
            target = "tyreSmokeColor"
        },
        modFrontBumper = {
            priceMultiplier = 0.015,
            type = "mod",
            mod = 1
        },
        modRearBumper = {
            priceMultiplier = 0.014,
            type = "mod",
            mod = 2
        },
        modExhaust = {
            priceMultiplier = 0.011,
            type = "mod",
            mod = 4
        },
        modHood = {
            priceMultiplier = 0.012,
            type = "mod",
            mod = 7
        },
        modHorn = {
            priceMultiplier = 0.006,
            type = "mod",
            mod = 14
        },
        modHydraulics = {
            priceMultiplier = 0.012,
            type = "mod",
            mod = 38
        },
        modDashboard = {
            priceMultiplier = 0.0115,
            type = "mod",
            mod = 29
        },
        modSeats = {
            priceMultiplier = 0.012,
            type = "mod",
            mod = 32
        },
        modSteeringWheel = {
            priceMultiplier = 0.009,
            type = "mod",
            mod = 33
        },
        modShifterLeavers = {
            priceMultiplier = 0.006,
            type = "mod",
            mod = 34
        },
        modDial = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 30
        },
        modOrnaments = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 28
        },
        modDoorSpeaker = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 31
        },
        modPlaques = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 35
        },
        modSpeakers = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 36
        },
        modXenon = {
            priceMultiplier = 0.008,
            type = "toggle",
            mod = 22
        },
        modXenonColour = {
            priceMultiplier = 0.004,
            type = "list",
            target = "xenon"
        },
        neonColor = {
            priceMultiplier = 0.01,
            type = "list",
            target = "neon"
        },
        extras = {
            priceMultiplier = 0.015,
            type = "extras"
        },
        livery = {
            priceMultiplier = 0.008,
            type = "livery"
        },
        modLivery = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 48
        },
        plateIndex = {
            staticPrice = 3000,
            type = "list",
            target = "plateIndex"
        },
        modPlateHolder = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 25
        },
        modVanityPlate = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 26
        },
        modRoof = {
            priceMultiplier = 0.012,
            type = "mod",
            mod = 10
        },
        colorPrimary = { -- TODO
            priceMultiplier = 0.009,
            type = "color",
            target = "primary"
        },
        colorSecondary = { -- TODO
            priceMultiplier = 0.009,
            type = "color",
            target = "secondary"
        },
        pearlescentColor = { -- TODO
            priceMultiplier = 0.008,
            type = "color",
            target = "pearlescent"
        },
        dashboardColor = {
            priceMultiplier = 0.009,
            type = "color", -- TODO
            target = "dashboard"
        },
        interiorColor = {
            priceMultiplier = 0.009,
            type = "color", -- TODO
            target = "interior"
        },
        modSideSkirt = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 3
        },
        modTrunk = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 37
        },
        modTrimA = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 27
        },
        modTrimB = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 44
        },
        modEngineBlock = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 39
        },
        modAirFilter = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 40
        },
        modStruts = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 41
        },
        modArchCover = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 42
        },
        modAerials = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 43
        },
        modTank = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 45
        },
        modDoorL = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 46
        },
        modDoorR = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 47
        },
        modLightbar = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 49
        },
        modFender = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 8
        },
        modFrame = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 5
        },
        modGrille = {
            priceMultiplier = 0.008,
            type = "mod",
            mod = 6
        },
        windowTint = {
            staticPrice = 2500,
            type = "list",
            target = "windowTint"
        },
    }
}
