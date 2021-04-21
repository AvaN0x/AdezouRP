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
      {x = 72.254,    y = -1399.102, z = 28.396},
      {x = -703.776,  y = -152.258,  z = 36.435},
      {x = -167.863,  y = -298.969,  z = 38.743},
      {x = 428.694,   y = -800.106,  z = 28.511},
      {x = -829.413,  y = -1073.710, z = 10.348},
      {x = -1447.797, y = -242.461,  z = 48.840},
      {x = 11.632,    y = 6514.224,  z = 30.897},
      {x = 123.646,   y = -219.440,  z = 53.577},
      {x = 1696.291,  y = 4829.312,  z = 41.083},
      {x = 618.093,   y = 2759.629,  z = 41.108},
      {x = 1190.550,  y = 2713.441,  z = 37.242},
      {x = -1193.429, y = -772.262,  z = 16.344},
      {x = -3172.496, y = 1048.133,  z = 19.883},
      {x = -1108.441, y = 2708.923,  z = 18.127},
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
      {x = -814.308,  y = -183.823,  z = 36.568},
      {x = 136.826,   y = -1708.373, z = 28.291},
      {x = -1282.604, y = -1116.757, z = 5.990},
      {x = 1931.513,  y = 3729.671,  z = 31.844},
      {x = 1212.840,  y = -473.921,  z = 65.450},
      {x = -32.885,   y = -152.319,  z = 56.076},
      {x = -278.077,  y = 6228.463,  z = 30.695},
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
      {x = -1336.87, y= -1278.91, z = 3.88}
    },
    MenuList = {
      'mask_1',
      'mask_2',
    }
  }
}