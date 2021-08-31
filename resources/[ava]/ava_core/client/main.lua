-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA = {}

exports("GetSharedObject", function()
    return AVA
end)

-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

local resourceName<const> = GetCurrentResourceName()
for i = 1, GetNumResourceMetadata(resourceName, "ava_config"), 1 do
    if GetResourceMetadata(resourceName, "ava_config", i - 1) == "debug_prints" then
        AVAConfig.Debug = true
    end
end

function dprint(...)
    if AVAConfig.Debug then
        print("^3[DEBUG] ^0", ...)
    end
end
