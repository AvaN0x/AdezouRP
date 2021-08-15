-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.RB = {}

local rbCount = 0
local namedRoutingBuckets = {}

AVA.RB.GetRootingBucket = function(name)
    if type(name) == "string" and name ~= "" then
        if namedRoutingBuckets[name] == nil then
            rbCount = rbCount + 1
            namedRoutingBuckets[name] = rbCount
        end
        dprint("List of known routing buckets", json.encode(namedRoutingBuckets, { indent=true }))
        return namedRoutingBuckets[name]
    else
        rbCount = rbCount + 1
        return rbCount
    end
end
exports("GetRootingBucket", AVA.RB.GetRootingBucket)

AVA.RB.MoveSourceToRB = function(src, rb)
    rb = type(rb) == "number" and rb or 0
    if GetPlayerRoutingBucket(src) ~= rb then
        print("^5ID " .. src.. "^0 is moved in routing bucket ^3" .. tostring(rb) .. "^0")
        SetPlayerRoutingBucket(src, rb)
    end
end
exports("MoveSourceToRB", AVA.RB.MoveSourceToRB)

AVA.RB.MoveSourceToRBName = function(src, rbName)
    local rb = rbName and AVA.RB.GetRootingBucket(rbName) or 0
    AVA.RB.MoveSourceToRB(src, rb)
end
exports("MoveSourceToRBName", AVA.RB.MoveSourceToRBName)

AVA.Commands.RegisterCommand("rb", "superadmin", function(source, args)
    local src = source
    AVA.RB.MoveSourceToRBName(src, args[1])
end, "move_to_rb", {{name = "rb", help = "rb"}})