-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config = {}
Config.Locale = 'fr'

Config.Price = 75

Config.DrawDistance = 30.0
Config.MarkerSize = {x = 1.5, y = 1.5, z = 1.0}
-- Config.MarkerColor  = {r = 135, g = 0, b = 255}
-- Config.MarkerType   = 25


Config.Shops = {
    shop_clothes = {
        Color  = {r = 135, g = 0, b = 255},
        Marker = 27,
        Blip = {
            Sprite = 73,
            Color = 47,
            Scale = 0.8
        },
        CanSave = true,
        Coords = {
            vector3(72.254,    -1399.102, 28.396),
            vector3(-703.776,  -152.258,  36.435),
            vector3(-167.863,  -298.969,  38.743),
            vector3(428.694,   -800.106,  28.511),
            vector3(-829.413,  -1073.710, 10.348),
            vector3(-1447.797, -242.461,  48.840),
            vector3(11.632,    6514.224,  30.897),
            vector3(123.646,   -219.440,  53.577),
            vector3(1696.291,  4829.312,  41.083),
            vector3(618.093,   2759.629,  41.108),
            vector3(1190.550,  2713.441,  37.242),
            vector3(-1193.429, -772.262,  16.344),
            vector3(-3172.496, 1048.133,  19.883),
            vector3(-1108.441, 2708.923,  18.127),
        },
        MenuList = {
            'tshirt_1',
            'tshirt_2',
            'torso_1',
            'torso_2',
            'decals_1',
            'decals_2',
            'arms',
            'arms_2',
            'pants_1',
            'pants_2',
            'shoes_1',
            'shoes_2',
            'chain_1',
            'chain_2',
            'helmet_1',
            'helmet_2',
            'watches_1',
            'watches_2',
            'bracelets_1',
            'bracelets_2',
            'glasses_1',
            'glasses_2',
            'ears_1',
            'ears_2',
            'bags_1',
            'bags_2'
        }
    },

    shop_barber = {
        Color  = {r = 135, g = 255, b = 255},
        Marker = 27,
        Blip = {
            Sprite = 71,
            Color = 51,
            Scale = 0.8
        },
        CanSave = false,
        Coords = {
            vector3(-814.308,  -183.823,  36.568),
            vector3(136.826,   -1708.373, 28.291),
            vector3(-1282.604, -1116.757, 5.990),
            vector3(1931.513,  3729.671,  31.844),
            vector3(1212.840,  -473.921,  65.450),
            vector3(-32.885,   -152.319,  56.076),
            vector3(-278.077,  6228.463,  30.695),
        },
        MenuList = {
            'hair_1',
            'hair_2',
            'hair_color_1',
            'hair_color_2',
            'eyebrows_1',
            'eyebrows_2',
            'eyebrows_3',
            'eyebrows_4',
            'makeup_1',
            'makeup_2',
            'makeup_3',
            'makeup_4',
            'lipstick_1',
            'lipstick_2',
            'lipstick_3',
            'lipstick_4',
            'age_1',
            'age_2',
            'beard_1',
            'beard_2',
            'beard_3',
            'beard_4',
            'chest_1',
            'chest_2',
            'chest_3',
            'bodyb_1',
            'bodyb_2',
            'blemishes_1',
            'blemishes_2',
            'blush_1',
            'blush_2',
            'blush_3',
            'complexion_1',
            'complexion_2',
            'sun_1',
            'sun_2',
            'moles_1',
            'moles_2'
        }
    },

    shop_masks = {
        Color  = {r = 0, g = 255, b = 0},
        Marker = 27,
        Blip = {
            Sprite = 671,
            Color = 31,
            Scale = 0.8
        },
        CanSave = false,
        Coords = {
            vector3(-1336.87, -1278.91, 3.88)
        },
        MenuList = {
            'mask_1',
            'mask_2',
        }
    }
}