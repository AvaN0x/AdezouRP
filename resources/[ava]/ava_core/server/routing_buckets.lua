-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.RB = {}

local rbCount = 0
local namedRoutingBuckets = {}

---Get a rooting bucket based on the name given, or just the next accessible one
---@param name string
---@return number
AVA.RB.GetRootingBucket = function(name)
    if type(name) == "string" and name ~= "" then
        if namedRoutingBuckets[name] == nil then
            rbCount = rbCount + 1
            namedRoutingBuckets[name] = rbCount
        end
        dprint("List of known routing buckets", json.encode(namedRoutingBuckets, {indent = true}))
        return namedRoutingBuckets[name]
    else
        rbCount = rbCount + 1
        return rbCount
    end
end
exports("GetRootingBucket", AVA.RB.GetRootingBucket)

---Move source player to a given rooting bucket
---@param src string
---@param rb integer
AVA.RB.MovePlayerToRB = function(src, rb)
    rb = type(rb) == "number" and rb or 0
    if GetPlayerRoutingBucket(src) ~= rb then
        print("^5ID " .. src .. "^0 is moved in routing bucket ^3" .. tostring(rb) .. "^0")
        SetPlayerRoutingBucket(src, rb)
    end
end
exports("MovePlayerToRB", AVA.RB.MovePlayerToRB)

---Move source player to a rooting bucket with a given name
---@param src string
---@param rbName string
AVA.RB.MovePlayerToNamedRB = function(src, rbName)
    local rb = rbName and AVA.RB.GetRootingBucket(rbName) or 0
    AVA.RB.MovePlayerToRB(src, rb)
end
exports("MovePlayerToNamedRB", AVA.RB.MovePlayerToNamedRB)

AVA.Commands.RegisterCommand("rb", "superadmin", function(source, args)
    local src = source
    AVA.RB.MovePlayerToNamedRB(src, args[1])
end, "move_to_rb", {{name = "rb", help = "rb"}})
