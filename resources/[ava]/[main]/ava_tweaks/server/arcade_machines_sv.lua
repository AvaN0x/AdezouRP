-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Slots = {
    -- Entrance on the right
    [1] = {
        { Coord = vector3(2735.393, -371.681, -50), Heading = 0 }, -- ch_prop_arcade_street_01d
        { Coord = vector3(2735.393, -371.681, -49.99), Heading = 0 }, -- ch_prop_arcade_penetrator_01a
        { Coord = vector3(2735.393, -371.401, -50), Heading = 0 }, -- ch_prop_arcade_invade_01a
        { Coord = vector3(2735.393, -371.489, -50), Heading = 0 },
    },

    [2] = {
        { Coord = vector3(2733.5, -371.671, -50), Heading = 0 }, -- ch_prop_arcade_street_01d
        { Coord = vector3(2733.5, -371.671, -49.99), Heading = 0 }, -- ch_prop_arcade_penetrator_01a
        { Coord = vector3(2733.5, -371.401, -50), Heading = 0 }, -- ch_prop_arcade_invade_01a
        { Coord = vector3(2733.5, -371.489, -50), Heading = 0 },
    },

    [3] = {
        { Coord = vector3(2731.353, -371.671, -50), Heading = 0 }, -- ch_prop_arcade_street_01d
        { Coord = vector3(2731.353, -371.671, -49.99), Heading = 0 }, -- ch_prop_arcade_penetrator_01a
        { Coord = vector3(2731.353, -371.401, -50), Heading = 0 }, -- ch_prop_arcade_invade_01a
        { Coord = vector3(2731.353, -371.489, -50), Heading = 0 },
    },

    -- In front of the entrance facing the entrance
    [4] = { Coord = vector3(2730.043, -373.551, -50), Heading = 90 },
    [5] = { Coord = vector3(2730.043, -374.551, -50), Heading = 90 },
    [6] = { Coord = vector3(2730.043, -375.461, -50), Heading = 90 },
    [7] = { Coord = vector3(2730.144, -378.494, -50), Heading = 90 },
    [8] = {
        { Coord = vector3(2730.144, -377.562, -50), Heading = 90 },
        { Coord = vector3(2730.094, -377.572, -50), Heading = 90 }, -- ch_prop_arcade_invade_01a
        { Coord = vector3(2730.474, -377.572, -50), Heading = 90 }, -- ch_prop_arcade_gun_bird_01a, ch_prop_arcade_degenatron_01a
        { Coord = vector3(2730.444, -377.692, -50), Heading = 90 }, -- ch_prop_arcade_race_car_01a, ch_prop_arcade_race_car_01b, ch_prop_arcade_race_truck_01a
        { Coord = vector3(2730.404, -377.572, -50), Heading = 90 }, -- ch_prop_arcade_street_01d
        { Coord = vector3(2730.404, -377.572, -49.99), Heading = 90 }, -- ch_prop_arcade_penetrator_01a
    },

    -- In front of the entrance
    [9] = { Coord = vector3(2733.81, -377.882, -50), Heading = -90 },
    [10] = { Coord = vector3(2733.81, -376.9826, -50), Heading = -90 },
    [11] = { Coord = vector3(2733.81, -376.0827, -50), Heading = -90 },
    [12] = { Coord = vector3(2733.81, -375.1803, -50), Heading = -90 },

    -- Against the office wall
    [13] = { Coord = vector3(2729.147, -379.508, -50), Heading = 0 },
    [14] = { Coord = vector3(2728.201, -379.508, -50), Heading = 0 },
    [15] = { Coord = vector3(2727.211, -379.508, -50), Heading = 0 },
    [16] = { Coord = vector3(2726.251, -379.508, -50), Heading = 0 },
    [17] = { Coord = vector3(2725.291, -379.508, -50), Heading = 0 },
    [18] = { Coord = vector3(2724.33, -379.508, -50), Heading = 0 },
    [19] = { Coord = vector3(2723.36, -379.508, -50), Heading = 0 },

    -- Between the two stairs of the stage
    [20] = { Coord = vector3(2732.556, -387.504, -50), Heading = -135 },
    [21] = { Coord = vector3(2733.226, -386.83, -50), Heading = -135 },
    [22] = { Coord = vector3(2733.891, -386.164, -50), Heading = -135 },
    [23] = { Coord = vector3(2734.327, -385.089, -50), Heading = -90 },

    [24] = { Coord = vector3(2734.237, -383.259, -50), Heading = -90 },
    [25] = {
        { Coord = vector3(2734.237, -382.289, -50), Heading = -90 },

        { Coord = vector3(2733.95, -382.63, -50), Heading = -90 }, -- ch_prop_arcade_wpngun_01a, ch_prop_arcade_degenatron_01a
        { Coord = vector3(2733.93, -382.9, -50), Heading = -90 }, -- ch_prop_arcade_race_car_01a, ch_prop_arcade_race_car_01b, ch_prop_arcade_race_truck_01a
        { Coord = vector3(2733.93, -382.84, -50), Heading = -90 }, -- ch_prop_arcade_race_car_01a, ch_prop_arcade_race_car_01b, ch_prop_arcade_race_truck_01a
        { Coord = vector3(2734.147, -382.62, -50), Heading = -90 }, -- ch_prop_arcade_street_01d
        { Coord = vector3(2734.147, -382.62, -49.99), Heading = -90 }, -- ch_prop_arcade_penetrator_01a
        { Coord = vector3(2734.357, -382.62, -50), Heading = -90 }, -- ch_prop_arcade_invade_01a
    },

    -- Around center pillar
    [26] = { Coord = vector3(2729.64, -383.07, -50), Heading = 180 },
    [27] = { Coord = vector3(2728.738, -383.07, -50), Heading = 180 },
    [28] = {
        { Coord = vector3(2727.888, -383.899, -50), Heading = -90 }, -- ch_prop_arcade_street_01c
        { Coord = vector3(2728.348, -383.899, -50), Heading = -90 },
    },
    [29] = { Coord = vector3(2728.738, -384.72, -50), Heading = 0 },
    [30] = { Coord = vector3(2729.638, -384.72, -50), Heading = 0 },
    [31] = {
        { Coord = vector3(2730.479, -383.899, -50), Heading = 90 }, -- ch_prop_arcade_street_01c
        { Coord = vector3(2730.149, -383.899, -50), Heading = 90 },
    },

    -- Middle of stage
    [32] = { Coord = vector3(2738.437, -385.319, -49.41), Heading = -90 },
    [33] = {
        { Coord = vector3(2738.437, -386.659, -49.41), Heading = -90 },

        { Coord = vector3(2738.078, -385.993, -49.41), Heading = -90 }, -- ch_prop_arcade_gun_bird_01a, ch_prop_arcade_race_car_01a, ch_prop_arcade_race_truck_01a, ch_prop_arcade_race_car_01b, ch_prop_arcade_degenatron_01a
        { Coord = vector3(2738.177, -385.993, -49.41), Heading = -90 }, -- ch_prop_arcade_street_01d
        { Coord = vector3(2738.467, -385.969, -49.396), Heading = -90 }, -- ch_prop_arcade_penetrator_01a
        { Coord = vector3(2738.467, -385.969, -49.41), Heading = -90 }, -- ch_prop_arcade_invade_01a
        { Coord = vector3(2738.177, -385.969, -49.396), Heading = -90 }, -- ch_prop_arcade_penetrator_01a
        { Coord = vector3(2738.177, -385.969, -49.41), Heading = -90 }, -- ch_prop_arcade_street_01d
    },

    [34] = { Coord = vector3(2731.697, -392.009, -49.41), Heading = 180 },
    [35] = {
        { Coord = vector3(2730.487, -392.009, -49.41), Heading = 180 },

        { Coord = vector3(2731.237, -391.719, -49.41), Heading = 180 }, -- ch_prop_arcade_gun_bird_01a, ch_prop_arcade_degenatron_01a
        { Coord = vector3(2731.607, -391.659, -49.41), Heading = 180 }, -- ch_prop_arcade_race_car_01a, ch_prop_arcade_race_car_01b, ch_prop_arcade_race_truck_01a
        { Coord = vector3(2731.607, -391.839, -49.41), Heading = 180 }, -- ch_prop_arcade_street_01d
        { Coord = vector3(2731.297, -392.009, -49.396), Heading = 180 }, -- ch_prop_arcade_penetrator_01a
        { Coord = vector3(2731.297, -392.009, -49.41), Heading = 180 }, -- ch_prop_arcade_invade_01a
    },

    [36] = { Coord = vector3(2696.054, -368.974, -55.78), Heading = 135 },
    [37] = { Coord = vector3(2696.054, -370.124, -55.78), Heading = 45 },
    [38] = { Coord = vector3(2694.954, -370.074, -55.78), Heading = -45 },
    [39] = { Coord = vector3(2694.954, -368.974, -55.78), Heading = -135 },
}

local props = {
    -- Gun for ch_prop_arcade_gun_01a ?
    -- "ch_prop_arcade_wpngun_01a",

    -- I don't know for which aracade this is
    -- "ch_prop_arcade_gun_bird_01a",

    -- Car for different race arcade
    -- "ch_prop_arcade_race_bike_02a",
    -- "ch_prop_arcade_race_car_01a",
    -- "ch_prop_arcade_race_car_01b",
    -- "ch_prop_arcade_race_truck_01a",
    -- "ch_prop_arcade_race_truck_01b",

    -- "ch_prop_ch_usb_drive01x",

    -- I don't know what the claws are for
    -- "ch_prop_arcade_claw_01a_c",
    -- "ch_prop_arcade_claw_01a_c_d",
    -- "ch_prop_arcade_claw_01a_r1",
    -- "ch_prop_arcade_claw_01a_r2",

    -- Plushies
    -- "ch_prop_arcade_claw_plush_01a",
    -- "ch_prop_arcade_claw_plush_02a",
    -- "ch_prop_arcade_claw_plush_03a",
    -- "ch_prop_arcade_claw_plush_04a",
    -- "ch_prop_arcade_claw_plush_05a",
    -- "ch_prop_arcade_claw_plush_06a",
    -- "ch_prop_princess_robo_plush_07a",
    -- "ch_prop_shiny_wasabi_plush_08a",
    -- "ch_prop_master_09a",

    -- Arcade machines
    "ch_prop_arcade_space_01a",
    "ch_prop_arcade_wizard_01a",
    "ch_prop_arcade_degenatron_01a",
    "ch_prop_arcade_monkey_01a",
    "ch_prop_arcade_penetrator_01a",
    "ch_prop_arcade_invade_01a",
    "ch_prop_arcade_street_01a",
    "ch_prop_arcade_street_01b",
    "ch_prop_arcade_street_01c",
    "ch_prop_arcade_street_01d",
    "sum_prop_arcade_qub3d_01a",
    -- "ch_prop_arcade_gun_01a",
    -- "ch_prop_arcade_race_02a",
    -- "ch_prop_arcade_race_01a",
    -- "tr_prop_tr_camhedz_01a",
    -- "ch_prop_arcade_love_01a",
    -- "ch_prop_arcade_fortune_01a",

    -- Scanners
    -- "ch_prop_fingerprint_scanner_01a",
    -- "ch_prop_fingerprint_scanner_01a",
}
local tightProps = {
    "ch_prop_arcade_space_01a",
    "ch_prop_arcade_wizard_01a",
    "ch_prop_arcade_degenatron_01a",
    "ch_prop_arcade_monkey_01a",
    "ch_prop_arcade_penetrator_01a",
    "ch_prop_arcade_invade_01a",
    "ch_prop_arcade_street_01a",
    "ch_prop_arcade_street_01b",
    "ch_prop_arcade_street_01c",
    "ch_prop_arcade_street_01d",
    "sum_prop_arcade_qub3d_01a",

}
local wideProps = {
    "ch_prop_arcade_gun_01a",
    "ch_prop_arcade_race_02a",
    "ch_prop_arcade_race_01a",
    "tr_prop_tr_camhedz_01a",
    "ch_prop_arcade_love_01a",
    "ch_prop_arcade_fortune_01a",
}

local objects = {}

local function spawnProp(hash, x, y, z, h)
    local object = CreateObjectNoOffset(hash, x + 0.0, y + 0.0, z + 0.0, true, true, false)
    SetEntityHeading(object, h + 0.0)
    FreezeEntityPosition(object, true)
    table.insert(objects, object)
end

Citizen.CreateThread(function()
    spawnProp(`ch_prop_arcade_fortune_door_01a`, 2727.911, -371.9659, -48.3982, 90.0)

    for index, coord in ipairs(Slots) do
        local prop = props[math.random(1, #props)]
        if coord.Coord then
            spawnProp(joaat(prop), coord.Coord.x, coord.Coord.y, coord.Coord.z, coord.Heading)
        else
            -- for _, coord2 in ipairs(coord) do
            local coord2 = coord[1]
            spawnProp(joaat(prop), coord2.Coord.x, coord2.Coord.y, coord2.Coord.z, coord2.Heading)
            -- end
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for k, object in ipairs(objects) do
            DeleteEntity(object)
        end
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         for i = 1, #Slots do
--             local coord = Slots[i]
--             if coord.Coord then
--                 DrawText3D(coord.Coord.x, coord.Coord.y, coord.Coord.z, tostring(i))
--             else
--                 local offset = 0.0
--                 for j, coord2 in ipairs(coord) do
--                     -- local coord2 = coord[1]
--                     DrawText3D(coord2.Coord.x, coord2.Coord.y, coord2.Coord.z + offset, tostring(i .. "." .. j))
--                     offset = offset + 0.15
--                 end
--             end
--         end
--     end
-- end)

-- function DrawText3D(x, y, z, text, size, r, g, b)
--     local onScreen, _x, _y = World3dToScreen2d(x, y, z)

--     if onScreen then
--         SetTextScale(0.35, size or 0.35)
--         SetTextFont(0)
--         SetTextProportional(1)
--         SetTextColour(r or 255, g or 255, b or 255, 215)
--         SetTextEntry("STRING")
--         AddTextComponentSubstringPlayerName(text)
--         SetTextCentre(1)
--         SetTextOutline()

--         EndTextCommandDisplayText(_x, _y)
--     end
-- end
