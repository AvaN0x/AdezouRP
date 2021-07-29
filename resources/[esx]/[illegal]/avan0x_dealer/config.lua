-------------------------------------------
------- REMADE BY GITHUB.COM/AVAN0X -------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config = {}

-- For the door.
Config.DrawTextDist = 2.0

-- The door.
Config.HintLocation      =   vector4(143.9,-131.7,53.86, 155.37) -- new point
Config.SalesLocations    =   {
    [1] = vector4(-544.2, -1799.3, 22.4, 68.92),
    [2] = vector4(-496.85, -1762.41, 18.65, 262.54),
    [3] = vector4(-483.48, -1691.74, 19.14, 88.9),
    [4] = vector4(-509.04, -1630.83, 17.8, 117.78),
    [5] = vector4(-523.99, -1635.44, 18.04, 62.83),
    [6] = vector4(-569.83, -1676.52, 19.68, 115.1),
    [7] = vector4(-566.44, -1719.98, 19.07, 51.7),
    [8] = vector4(-574.6, -1684.7, 20.04, 212.86),
    [9] = vector4(-409.53, -1702.04, 19.42, 20.27),

    [10] = vector4(910.31, -1488.07, 30.26, 266.75),
    [11] = vector4(914.36, -1488.12, 30.49, 258.32),
    [12] = vector4(927.96, -1488.0, 30.49, 91.17),
    [13] = vector4(945.66, -1521.86, 31.1, 50.15),
    [14] = vector4(929.6, -1508.36, 30.73, 335.24),
    [15] = vector4(948.72, -1491.06, 30.7, 140.4),

    [16] = vector4(264.65, -3220.85, 5.79, 230.56),
    [17] = vector4(261.35, -3136.19, 5.79, 282.51),
    [18] = vector4(153.43, -3074.01, 5.9, 132.01),

    [19] = vector4(1252.9, -2576.11, 42.96, 193.05),
    [20] = vector4(1638.0, -2283.67, 105.66, 305.8),
    [21] = vector4(1555.37, -2170.28, 77.47, 236.73),
    [22] = vector4(1573.07, -2171.38, 77.51, 168.2),
    [23] = vector4(1502.55, -2109.75, 76.24, 93.51),

    [24] = vector4(2760.22, 1525.99, 24.5, 153.54),
    [25] = vector4(2721.81, 1473.86, 24.5, 124.62),
    [26] = vector4(2652.53, 1405.69, 24.51, 350.96),

    [27] = vector4(2327.79, 2530.82, 46.67, 159.82),

    [28] = vector4(2361.22, 3142.98, 48.21, 174.62),
    [29] = vector4(2359.79, 3118.82, 48.21, 66.83),
    [30] = vector4(2330.74, 3060.93, 48.5, 256.51),
    [31] = vector4(2344.15, 3061.39, 48.5, 93.74),

    [32] = vector4(1935.98, 3808.59, 32.04, 338.88),
    [33] = vector4(1873.24, 3749.99, 32.99, 37.95),

    [34] = vector4(1654.21, 4737.91, 42.03, 67.15),
    [35] = vector4(1726.11, 4776.9, 41.97, 277.21),
    [36] = vector4(1701.99, 4821.2, 41.95, 282.16),
    [37] = vector4(1700.92, 4857.69, 42.03, 284.39),
    [38] = vector4(1696.12, 4872.15, 42.04, 325.36),

    [39] = vector4(281.63, 6797.22, 15.7, 342.26),
    [40] = vector4(279.25, 6782.38, 15.7, 2.91),

}

Config.DealerPed = 's_m_y_dealer_01'


-- TODO This is not beautiful at all, change it at some time
Config.DrugItems = {
    -- ['Montre Rolex'] = 'rolex',
    ['Lingot d\'Or'] = 'gold',
    ['Diamant'] = 'diamond',
    ['Pochon de cannabis'] = 'bagweed',
    ['Pochon de cocaïne'] = 'bagcoke',
    ['Pochon d\'extazy'] = 'bagexta',
    ['Pochon de Meth'] = 'methamphetamine',

    ['Montre en or'] = 'watch_gold',
    ['Montre en diamant'] = 'watch_diamond',
    ['Montre en argent'] = 'watch_steel',
    ['Montre en émeraude'] = 'watch_emerald',
    ['Montre en ruby'] = 'watch_ruby',
    ['Collier en or'] = 'necklace_gold',
    ['Collier en diamant'] = 'necklace_diamond',
    ['Collier en argent'] = 'necklace_steel',
    ['Collier en émeraude'] = 'necklace_emerald',
    ['Collier en ruby'] = 'necklace_ruby',
    ['Bague en or'] = 'ring_gold',
    ['Bague en diamant'] = 'ring_diamond',
    ['Bague en argent'] = 'ring_steel',
    ['Bague en émeraude'] = 'ring_emerald',
    ['Bague en ruby'] = 'ring_ruby',
    ['Bracelet en or'] = 'bracelet_gold',
    ['Bracelet en diamant'] = 'bracelet_diamond',
    ['Bracelet en argent'] = 'bracelet_steel',
    ['Bracelet en émeraude'] = 'bracelet_emerald',
    ['Bracelet en ruby'] = 'bracelet_ruby',
    ['Caisse D\'armes'] = 'weaponbox',
}

Config.DrugPrices = {
    ['gold'] = 150,
    ['diamond'] = 600,
    ['bagweed'] = 70,
    ['bagcoke'] = 165,
    ['bagexta'] = 90,
    ['methamphetamine'] = 220,

    ['watch_gold'] = 328,
    ['watch_diamond'] = 532,
    ['watch_steel'] = 212,
    ['watch_emerald'] = 749,
    ['watch_ruby'] = 799,
    ['necklace_gold'] = 314,
    ['necklace_diamond'] = 481,
    ['necklace_steel'] = 173,
    ['necklace_emerald'] = 701,
    ['necklace_ruby'] = 747,
    ['ring_gold'] = 198,
    ['ring_diamond'] = 268,
    ['ring_steel'] = 112,
    ['ring_emerald'] = 362,
    ['ring_ruby'] = 432,
    ['bracelet_gold'] = 232,
    ['bracelet_diamond'] = 376,
    ['bracelet_steel'] = 146,
    ['bracelet_emerald'] = 493,
    ['bracelet_ruby'] = 626,
    ['weaponbox'] = 4876,
}

Config.MaxPriceVariance = 10.0 -- %
