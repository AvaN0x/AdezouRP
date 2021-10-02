-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local UsedProps = {}
local PlayerUsing = {}

AddEventHandler("playerDropped", function()
    local _source = source
    if PlayerUsing[_source] ~= nil then
        UsedProps[PlayerUsing[_source]] = nil
        PlayerUsing[_source] = nil
    end
end)

RegisterNetEvent("ava_chairs:sitDown")
AddEventHandler("ava_chairs:sitDown", function(chair)
    local _source = source
    local coord = vector3(chair.x, chair.y, chair.z)

    if UsedProps[coord] == nil then
        PlayerUsing[_source] = coord
        UsedProps[coord] = true
        TriggerClientEvent("ava_chairs:sitDown", _source)
    end
end)

RegisterNetEvent("ava_chairs:standUp")
AddEventHandler("ava_chairs:standUp", function(chair)
    local _source = source
    local coord = vector3(chair.x, chair.y, chair.z)

    PlayerUsing[_source] = nil
    UsedProps[coord] = nil
end)
