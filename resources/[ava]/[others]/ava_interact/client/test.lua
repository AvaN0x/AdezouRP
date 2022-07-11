-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


exports.ava_interact:addModel(`prop_fleeca_atm`, {
    label = "ATM",
    offset = vector3(-0.13, -0.1, 1.0)
})
exports.ava_interact:addModel(`prop_atm_02`, {
    label = "ATM",
    offset = vector3(-0.13, -0.1, 1.0)
})
exports.ava_interact:addModel(`prop_atm_03`, {
    label = "ATM",
    offset = vector3(-0.13, -0.1, 1.0)
})
exports.ava_interact:addModel(`prop_atm_01`, {
    label = "ATM",
    offset = vector3(-0.05, -0.23, 1.0)
})

exports.ava_interact:addZone(vector3(434.15, -981.71, 30.70), {
    label = "Hello World",
})

Citizen.CreateThread(function()
    local modifier = 1.0
    for i = 0, 100 do
        for j = 0, 100 do
            exports.ava_interact:addZone(vector3(414.55 - i * modifier, -974.68 + j * modifier, 28.91), {
                label = "i = " .. i .. " j = " .. j,
                distance = 2
            })
        end
    end
end)