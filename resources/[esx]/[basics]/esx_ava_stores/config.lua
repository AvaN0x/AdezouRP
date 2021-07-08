-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config = {}
Config.DrawDistance = 15.0
Config.Locale = 'fr'


Config.Stores = {
    TwentyFourSeven = {
        Blip = {
            Sprite = 52,
            Colour = 4,
            Scale = 0.6  
        },
        Pos = {
            vector3(373.87, 325.87, 102.59), -- Clinton Ave
            vector3(2557.45, 382.28, 107.64), -- Route 15
            vector3(-3039.55, 586.05, 6.93), -- Inesedo Rd.
            vector3(-3241.91, 1001.52, 11.85), -- Barberego Rd.
            vector3(547.70, 2671.29, 41.18), -- Route 68
            vector3(1961.46, 3740.67, 31.36), -- Alhambra Drive
            vector3(2678.90, 3280.81, 54.26), -- Route 13
            vector3(1729.06, 6414.20, 34.06), -- Route 1
            vector3(26.12, -1345.49, 28.52), -- Innocence Blvd
        },
        Items = {
            {name = 'bread', price = 13},
            {name = 'water', price = 12},
            {name = 'donut', price = 4},
            {name = 'dopebag', price = 5},
            {name = 'tel', price = 500},
            {name = 'sim', price = 50},
            {name = 'radio', price = 200},
            {name = 'weapon_flashlight', price = 700},
        },
        Marker = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 134, g = 180, b = 84},
        Distance = 1.5,
        Name = "Twenty Four Seven",
        HelpText = _('press_buy')
    },

    RobsLiquor = {
        Blip = {
            Sprite = 52,
            Colour = 4,
            Scale = 0.6  
        },
        Pos = {
            vector3(1135.83, -982.10, 45.44), -- Vespucci Blvd
            vector3(-1222.91, -906.98, 11.34), -- San Andreas Ave
            vector3(-1487.55, -379.10, 39.18), -- Prosperity St
            vector3(-2967.99, 390.96, 14.06), -- Great Route 1
            vector3(1165.98, 2709.03, 37.18), -- Route 68
            vector3(1392.56, 3604.68, 34.01), -- Algonquin Blvd
        },
        Items = {
            {name = 'bread', price = 13},
            {name = 'water', price = 12},
            {name = 'donut', price = 4},
            {name = 'dopebag', price = 5},
            {name = 'tel', price = 500},
            {name = 'sim', price = 50},
            {name = 'radio', price = 200},
            {name = 'weapon_flashlight', price = 700},
        },
        Marker = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 134, g = 180, b = 84},
        Distance = 1.5,
        Name = "Robs Liquor",
        HelpText = _('press_buy')
    },


    LTDgasoline = {
        Blip = {
            Sprite = 52,
            Colour = 4,
            Scale = 0.6  
        },
        Pos = {
            vector3(-48.05, -1756.84, 28.44), -- Grove Street
            vector3(1163.27, -323.11, 68.23), -- W Mirror Drive
            vector3(-707.54, -913.97, 18.24), -- Little Seoul
            vector3(-1820.84, 793.00, 137.13), -- North Rockford Drive
            vector3(1698.63, 4924.23, 41.08), -- Grapeseed Ave
        },
        Items = {
            {name = 'bread', price = 13},
            {name = 'water', price = 12},
            {name = 'donut', price = 4},
            {name = 'dopebag', price = 5},
            {name = 'tel', price = 500},
            {name = 'sim', price = 50},
            {name = 'radio', price = 200},
            {name = 'weapon_flashlight', price = 700},
        },
        Marker = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 134, g = 180, b = 84},
        Distance = 1.5,
        Name = "LTD gasoline",
        HelpText = _('press_buy')
    },


    Ammunation = {
        Blip = {
            Sprite = 110,
            Colour = 1,
            Scale = 0.6  
        },
        Pos = {
            vector3(-662.31, -935.17, 20.85), -- Little Seoul
            vector3(1693.02, 3759.61, 33.73), -- Sandy Shores
            vector3(-330.28, 6083.78, 30.47), -- Paleto
            vector3(252.30, -50.00, 68.97), -- Spanish Ave
            vector3(2568.04, 294.26, 107.75), -- Route 15
            vector3(-1117.89, 2698.55, 17.57), -- Route 68
            vector3(-1305.71, -394.37, 35.72), -- Del Perro
            vector3(-3172.21, 1087.77, 19.86), -- Great Route 1
            vector3(842.40, -1033.40, 27.21), -- Vespucci Blvd
        },
        Items = {
            {name = 'clip', price = 200},
            {name = 'weapon_doubleaction', price = 100000},
            {name = 'weapon_pistol', price = 40000},
            {name = 'weapon_flare', price = 50000},
            {name = 'weapon_knife', price = 2200},
            {name = 'weapon_switchblade', price = 1500},
            {name = 'weapon_machete', price = 1500},
            {name = 'weapon_battleaxe', price = 1800},
            {name = 'weapon_bat', price = 1000},
            {name = 'gadget_parachute', price = 5000},
        },
        Marker = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 175, g = 0, b = 0},
        Distance = 1.5,
        Name = "Ammunation",
        HelpText = _('press_buy')
    },


    ShootingAmmunation = {
        Blip = {
            Sprite = 313,
            Colour = 1,
            Scale = 0.6  
        },
        Pos = {
            vector3(21.56, -1106.61, 28.82), -- Adam's Apple Blvd
            vector3(810.37, -2157.41, 28.64), -- Dry Dock Street
        },
        Items = {
            {name = 'clip', price = 200},
            {name = 'weapon_doubleaction', price = 100000},
            {name = 'weapon_pistol', price = 40000},
            {name = 'weapon_flare', price = 50000},
            {name = 'weapon_knife', price = 2200},
            {name = 'weapon_switchblade', price = 1500},
            {name = 'weapon_machete', price = 1500},
            {name = 'weapon_battleaxe', price = 1800},
            {name = 'weapon_bat', price = 1000},
            {name = 'gadget_parachute', price = 5000},
        },
        Marker = 27,
        Size = {x = 1.0, y = 1.0, z = 1.0},
        Color = {r = 175, g = 0, b = 0},
        Distance = 1.5,
        Name = "Ammunation",
        HelpText = _('press_buy')
    },

    BlackMarket = {
        Pos = {
            vector3(1716.30, 3295.09, 40.32)
        },
        Items = {
            {name = 'headbag', price = 200, isDirtyMoney = true},
            {name = 'tenuecasa', price = 200, isDirtyMoney = true},
            {name = 'balisegps', price = 200, isDirtyMoney = true},
        },
        Distance = 1,
        Name = "Black Market",
        HelpText = _('press_buy')
    },
}

