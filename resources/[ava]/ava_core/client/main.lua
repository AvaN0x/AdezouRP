-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
importGlobal("dprint")

AVA = {}

exports("GetSharedObject", function()
    return AVA
end)

-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

local resourceName <const> = GetCurrentResourceName()
for i = 1, GetNumResourceMetadata(resourceName, "ava_config"), 1 do
    local dataName = GetResourceMetadata(resourceName, "ava_config", i - 1)

    if dataName == "npwd" then
        AVAConfig.NPWD = true
    end
end
