-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local _debug = GetConvar("ava_debug", "false") ~= "false"

---Print if debug is enabled.
---@param ... unknown
local function dprint(...)
    if _debug then
        print("^3[DEBUG] ^0", ...)
    end
end

return dprint
