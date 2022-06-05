-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

-- In seconds, no floating point
AVAConfig.ReplicateDelay = 30

AVAConfig.GlobalMultiplier = 1.0
AVAConfig.ElectricMultiplier = 0.7

-- Defaults to 1.0
AVAConfig.ClassUsage = {
    -- [0] = 1.0, -- compacts
    -- [1] = 1.0, -- sedans
    -- [2] = 1.0, -- SUV's
    -- [3] = 1.0, -- coupes
    [4] = 1.2, -- muscle
    [5] = 1.05, -- sport classic
    [6] = 1.1, -- sport
    [7] = 1.2, -- super
    -- [8] = 1.0, -- motorcycle
    -- [9] = 1.0, -- offroad
    -- [10] = 1.0, -- industrial
    -- [11] = 1.0, -- utility
    -- [12] = 1.0, -- vans
    [13] = 0.0, -- bicycles
    -- [14] = 1.0, -- boats
    -- [15] = 1.0, -- helicopter
    -- [16] = 1.0, -- plane
    -- [17] = 1.0, -- service
    -- [18] = 1.0, -- emergency
    -- [19] = 1.0, -- military
    -- [20] = 1.0, -- commercial
    -- [21] = 1.0, -- trains
}
AVAConfig.RPMUsage = {
    [1.0] = 1.8,
    [0.9] = 1.7,
    [0.8] = 1.5,
    [0.7] = 1.3,
    [0.6] = 1.0,
    [0.5] = 0.8,
    [0.4] = 0.6,
    [0.3] = 0.4,
    [0.2] = 0.2,
    [0.1] = 0.1,
    [0.0] = 0.0,
}

AVAConfig.ElectricCars = {
    [`airtug`] = true,
    [`caddy`] = true,
    [`caddy2`] = true,
    [`caddy3`] = true,
    [`cyclone`] = true,
    -- [`cyclone2`] = true, -- Part of Expanded & Enhanced DLC. If it ever comes to PC, it will be here.
    [`dilettante`] = true,
    [`dilettante2`] = true,
    [`imorgon`] = true,
    [`iwagen`] = true,
    [`khamelion`] = true,
    [`neon`] = true,
    [`raiden`] = true,
    [`rcbandito`] = true,
    [`surge`] = true,
    [`tezeract`] = true,
    [`voltic`] = true,
    [`voltic2`] = true,
}

AVAConfig.GasPumps = {
    `prop_gas_pump_1a`,
    `prop_gas_pump_1b`,
    `prop_gas_pump_1c`,
    `prop_gas_pump_1d`,
    `prop_gas_pump_old2`,
    `prop_gas_pump_old3`,
    `prop_vintage_pump`,
}
-- TODO somehow
-- AVAConfig.ElectricPumps = {}