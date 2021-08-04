-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA = {}

-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

local resourceName = GetCurrentResourceName()
for i = 1, GetNumResourceMetadata(resourceName, "my_data"), 1 do
    if GetResourceMetadata(resourceName, "my_data", i - 1) == "debug_prints" then
        AVAConfig.Debug = true
    end
end

function dprint(...)
    if AVAConfig.Debug then
        print("^3[DEBUG] ^0", ...)
    end
end
