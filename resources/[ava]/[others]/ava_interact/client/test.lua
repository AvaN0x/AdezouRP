-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_interact:addModel(`v_corp_offchair`, {
    label = "Hello World",
    offset = vector3(0.0, 0.05, 0.5),
    -- distance = AVAConfig.DefaultDistance,
    -- drawDistance = AVAConfig.DefaultDistance,
})

exports.ava_interact:addModel(`prop_bench_01a`, {
    {
        label = "seat 1",
        offset = vector3(0.6, 0.0, 0.5),
        control = "F"
    },
    {
        label = "seat 2",
        offset = vector3(0.0, 0.0, 0.5),
        control = "F"
    },
    {
        label = "seat 3",
        offset = vector3(-0.6, 0.0, 0.5),
        control = "F"
    },
})

exports.ava_interact:addModel(`v_ilev_ph_bench`, {
    {
        label = "seat 1",
        offset = vector3(0.6, 0.0, 0.5),
        control = "F",
        distance = 100
    },
    {
        label = "seat 2",
        offset = vector3(0.0, 0.0, 0.5),
        control = "F"
    },
    {
        label = "seat 3",
        offset = vector3(-0.6, 0.0, 0.5),
        control = "F"
    },
})

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