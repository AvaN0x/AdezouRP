-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}
AVAConfig.CoordsLoop = 500
AVAConfig.CoordsLoopInside = 200

-- * states :
-- *  - 0 = can be burglarized
-- *  - 1 = user inside and can't be burglarized
-- *  - 2 = can't be burglarized
AVAConfig.Houses = {
    { coord = vector3(87.046157836914, -834.94946289063, 31.049072265625), heading = 69.448822021484, state = 0 },
    { coord = vector3(92.637367248535, -819.78460693359, 31.285034179688), heading = 66.614181518555, state = 0 },
    { coord = vector3(109.4373626709, -1090.6021728516, 29.296752929688), heading = 341.57479858398, state = 0 },
    { coord = vector3(291.53405761719, -1078.6417236328, 29.397827148438), heading = 273.54330444336, state = 0 },
    { coord = vector3(996.90991210938, -729.62634277344, 57.806640625), heading = 307.55905151367, state = 0 },
    { coord = vector3(979.23956298828, -716.20220947266, 58.2109375), heading = 304.72439575195, state = 0 },
    { coord = vector3(970.87915039063, -701.48571777344, 58.480590820313), heading = 350.07873535156, state = 0 },
    { coord = vector3(959.80218505859, -669.79779052734, 58.446899414063), heading = 299.0551071167, state = 0 },
    { coord = vector3(943.25274658203, -653.34063720703, 58.463745117188), heading = 219.68503570557, state = 0 },
    { coord = vector3(928.68133544922, -639.70550537109, 58.227783203125), heading = 316.06298828125, state = 0 },
    { coord = vector3(902.99340820313, -615.53405761719, 58.446899414063), heading = 225.35432815552, state = 0 },
    { coord = vector3(886.82635498047, -608.26812744141, 58.430053710938), heading = 313.22833251953, state = 0 },
    { coord = vector3(861.58679199219, -583.56921386719, 58.1435546875), heading = 341.57479858398, state = 0 },
    { coord = vector3(843.9560546875, -562.66815185547, 57.991943359375), heading = 185.66929101944, state = 0 },
    { coord = vector3(850.27252197266, -532.61535644531, 57.924560546875), heading = 262.20472717285, state = 0 },
    { coord = vector3(861.49450683594, -509.06372070313, 57.705444335938), heading = 225.35432815552, state = 0 },
    { coord = vector3(878.29449462891, -498.03955078125, 58.076171875), heading = 225.35432815552, state = 0 },
    { coord = vector3(906.13189697266, -489.46813964844, 59.424194335938), heading = 199.84251785278, state = 0 },
    { coord = vector3(921.876953125, -477.75823974609, 61.075439453125), heading = 197.00787353516, state = 0 },
    { coord = vector3(944.43957519531, -463.21319580078, 61.547241210938), heading = 128.97637939453, state = 0 },
    { coord = vector3(967.22637939453, -451.51647949219, 62.77734375), heading = 208.34645462036, state = 0 },
    { coord = vector3(987.58679199219, -433.02856445313, 64.00732421875), heading = 199.84251785278, state = 0 },
    { coord = vector3(1010.5054931641, -423.57363891602, 65.338500976563), heading = 301.88976287842, state = 0 },
    { coord = vector3(1028.7561035156, -408.38241577148, 66.332641601563), heading = 216.85039138794, state = 0 },
    { coord = vector3(1060.4439697266, -378.27691650391, 68.2197265625), heading = 205.51181030273, state = 0 },
    { coord = vector3(1056.2637939453, -448.93185424805, 66.248291015625), heading = 344.4094543457, state = 0 },
    { coord = vector3(1098.5802001953, -464.47912597656, 67.309936523438), heading = 168.6614074707, state = 0 },
    { coord = vector3(1090.4571533203, -484.24615478516, 65.658569335938), heading = 63.779525756836, state = 0 },
    { coord = vector3(1046.2550048828, -498.15823364258, 64.276977539063), heading = 341.57479858398, state = 0 },
    { coord = vector3(-3089.2746582031, 221.06373596191, 14.114990234375), heading = 321.7322845459, state = 0 },
    { coord = vector3(-3105.3098144531, 246.46154785156, 12.480590820313), heading = 282.04724121094, state = 0 },
    { coord = vector3(-3093.71875, 349.60879516602, 7.5435791015625), heading = 256.5354309082, state = 0 },
    { coord = vector3(-3091.4504394531, 379.39779663086, 7.10546875), heading = 253.70078277588, state = 0 },
    { coord = vector3(-3039.560546875, 493.06814575195, 6.7685546875), heading = 276.37794494629, state = 0 },
    { coord = vector3(-3029.9604492188, 568.61535644531, 7.813232421875), heading = 259.37007141113, state = 0 },
    { coord = vector3(-2977.0153808594, 609.25714111328, 20.2314453125), heading = 103.4645690918, state = 0 },
    { coord = vector3(-2972.6506347656, 642.72528076172, 25.977294921875), heading = 103.4645690918, state = 0 },
    { coord = vector3(-2994.6066894531, 683.03735351563, 25.03369140625), heading = 106.29922485352, state = 0 },
    { coord = vector3(-2993.1428222656, 707.49890136719, 28.673217773438), heading = 199.84251785278, state = 0 },
    { coord = vector3(-3017.1823730469, 746.58459472656, 27.695922851563), heading = 106.29922485352, state = 0 },
    { coord = vector3(-3229.0417480469, 927.30987548828, 13.96337890625), heading = 296.22047424316, state = 0 },
    { coord = vector3(-3238.3647460938, 952.60217285156, 13.323120117188), heading = 273.54330444336, state = 0 },
    { coord = vector3(-3251.2614746094, 1027.3582763672, 11.756103515625), heading = 262.20472717285, state = 0 },
    { coord = vector3(-3232.8527832031, 1068.1450195313, 11.031494140625), heading = 253.70078277588, state = 0 },
    { coord = vector3(-3232.2065429688, 1081.4769287109, 10.795654296875), heading = 214.01574707031, state = 0 },
    { coord = vector3(-3200.2548828125, 1165.859375, 9.6497802734375), heading = 253.70078277588, state = 0 },
    { coord = vector3(-3190.9846191406, 1297.75390625, 19.06884765625), heading = 245.1968536377, state = 0 },
}

AVAConfig.Appartment = { coord = vector3(346.52, -1013.19, -99.2), heading = 357.81 }

-- TODO better coords for this
AVAConfig.Furnitures = {
    { coord = vector3(345.78, -1001.48, -99.30), empty = true },
    { coord = vector3(339.27, -1003.83, -99.40), empty = true },
    { coord = vector3(337.62, -998.35, -99.40), empty = true },
    { coord = vector3(337.67, -995.00, -99.40), empty = true },
    { coord = vector3(345.83, -995.70, -99.50), empty = true },
    { coord = vector3(351.29, -999.74, -99.30), empty = true },
    { coord = vector3(351.29, -992.99, -99.20), empty = true },
    { coord = vector3(348.64, -994.84, -99.40), empty = true },
    { coord = vector3(346.68, -994.22, -99.40), empty = true },
}

-- TODO do it in a better way
AVAConfig.StealableItems = {
    "dildo",
    "watch_gold",
    "watch_diamond",
    "watch_steel",
    "watch_emerald",
    "watch_ruby",
    "necklace_gold",
    "necklace_diamond",
    "necklace_steel",
    "necklace_emerald",
    "necklace_ruby",
    "ring_gold",
    "ring_diamond",
    "ring_steel",
    "ring_emerald",
    "ring_ruby",
    "bracelet_gold",
    "bracelet_diamond",
    "bracelet_steel",
    "bracelet_emerald",
    "bracelet_ruby",
    "gpstracker",
}
