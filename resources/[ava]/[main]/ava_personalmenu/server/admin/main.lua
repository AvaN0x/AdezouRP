-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
---@class adminmenu_perms
local requiredPerms<const> = {
    playerlist = {spec = true, ["goto"] = true, summon = true, kill = true},
    vehicles = {spawnvehicle = true, deletevehicle = true, flipvehicle = true, repairvehicle = true, tpnearestvehicle = true, tunevehiclepink = true},
    adminmode = true,
}

TriggerEvent("ava_core:server:add_ace", "group.mod", "adminmenu")

local function checkPerms(source, key, value)
    -- init value with requiredPerms
    if type(value) == "nil" then
        value = requiredPerms
    end
    if type(value) == "table" then
        local result = {}
        -- recursive if table
        for k, v in pairs(value) do
            result[k] = checkPerms(source, k, v)
        end
        -- check to see if we need to keep this table
        local keep = false
        for k, v in pairs(result) do
            -- if v is an array, it means that something inside of it is AceAllowedd
            if type(v) == table or v then
                keep = true
                break
            end
        end
        return keep and result or nil
    else
        -- only keep true or nil
        return IsPlayerAceAllowed(source, "command." .. key) and true or nil
    end
end

exports.ava_core:RegisterServerCallback("ava_core:isAdminAllowed", function(source)
    local menuAllowed = IsPlayerAceAllowed(source, "adminmenu")
    return not not menuAllowed, menuAllowed and checkPerms(source, key, value) or nil
end)
