-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava_status:server:update", function(data)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer then
        aPlayer.set("status", data)
    end
end)
