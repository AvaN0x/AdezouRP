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

exports.ava_core:RegisterCommand("heal", "admin", function(source, args)
    for name, cfgStatus in pairs(AVAConfig.Status) do
        if cfgStatus.afterHeal then
            TriggerClientEvent("ava_status:client:set", source, name, cfgStatus.afterHeal)
        end
    end
    TriggerClientEvent("ava_status:client:heal", source)
end, GetString("heal_subtitle"))
