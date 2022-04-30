-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

-- edit 'debug_prints' in fxmanifest.lua, any value mean true, remove if false
AVAConfig.Debug = false

-- edit 'npwd' in fxmanifest.lua, any value mean true, remove if false
AVAConfig.NPWD = false

AVAConfig.InventoryKey = "F2"

AVAConfig.InventoryMoneyOnTop = true

AVAConfig.EnablePVP = true

---Prevent player from falling at loading
AVAConfig.PreventPlayerFromFalling = true

AVAConfig.DisableWeaponsAutoReload = true

AVAConfig.DisableWeaponsAutoSwap = true

-- time between each player ped data saves (coords, healths, shield...)
AVAConfig.SavePlayerPedDataTimeout = 2000

AVAConfig.CallbackTimeout = 30000

AVAConfig.TrunkKey = "I"

AVAConfig.TrunksSizes = {}
AVAConfig.TrunksSizes.ClassSpecific = {
    [0] = 35000, -- compacts
    [1] = 50000, -- sedans
    [2] = 70000, -- SUV's
    [3] = 40000, -- coupes
    [4] = 35000, -- muscle
    [5] = 30000, -- sport classic
    [6] = 30000, -- sport
    [7] = 30000, -- super
    [8] = 5000, -- motorcycle
    [9] = 50000, -- offroad
    [10] = 120000, -- industrial
    [11] = 60000, -- utility
    [12] = 120000, -- vans
    [13] = 0, -- bicycles
    [14] = 120000, -- boats
    [15] = 120000, -- helicopter
    [16] = 150000, -- plane
    [17] = 120000, -- service
    [18] = 30000, -- emergency
    [19] = 75000, -- military
    [20] = 120000, -- commercial
    [21] = 0, -- trains
}
AVAConfig.TrunksSizes.ModelSpecific = {
    [`guardian`] = AVAConfig.TrunksSizes.ClassSpecific[2], -- SUV size
    [`flatbed`] = 20000,
}

AVAConfig.EngineInBack = {
    [`adder`] = true,
    [`zentorno`] = true,
}