-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local CurrentPound = nil

function OpenPoundMenu(pound)
    print("is pound")
    CurrentPound = pound
    local vehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getVehiclesInPound", CurrentPound.Name, CurrentPound.VehicleType) or {}
    print(json.encode(vehicles, {indent = true}))
    CurrentActionEnabled = true
    -- TODO need license
end
