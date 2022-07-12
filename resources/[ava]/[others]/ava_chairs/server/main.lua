-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local UsedSpots = {}
local PlayerUsing = {}

local function standPlayerUp(src)
    if PlayerUsing[src] ~= nil then
        UsedSpots[PlayerUsing[src]] = nil
        PlayerUsing[src] = nil
    end
end

exports.ava_core:RegisterServerCallback("ava_chairs:server:settle", function(source, x, y, z, index)
    local src = source
    local coord = vector3(x, y, z)

    if UsedSpots[coord] == nil then
        PlayerUsing[src] = coord
        UsedSpots[coord] = true
        return true
    end
    return false
end)

RegisterNetEvent("ava_chairs:server:standUp", function(chair)
    standPlayerUp(source)
end)
AddEventHandler("playerDropped", function()
    standPlayerUp(source)
end)
