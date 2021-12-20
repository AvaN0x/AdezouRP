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
    local id = (type(args[1]) == "string" and args[1] ~= "0") and tonumber(args[1]) or source

    for name, cfgStatus in pairs(AVAConfig.Status) do
        if cfgStatus.afterHeal then
            TriggerClientEvent("ava_status:client:set", id, name, cfgStatus.afterHeal)
        end
    end
    TriggerClientEvent("ava_status:client:heal", id)
end, GetString("heal_help"), {{name = "player?", help = GetString("player_id_or_empty")}})

local Consumables<const> = json.decode(LoadResourceFile(GetCurrentResourceName(), "consumables.json") or "{}") or {}
for i = 1, #Consumables do
    local consumable<const> = Consumables[i]
    exports.ava_core:RegisterUsableItem(consumable.name, function(src, aPlayer, cfgItem)
        aPlayer.getInventory().removeItem(consumable.name, 1)
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("you_consumed", cfgItem.label))

        if consumable.status then
            for statusName, statusValue in pairs(consumable.status) do
                TriggerClientEvent("ava_status:client:add", src, statusName, statusValue)
            end
        end

        if consumable.clientEvent then
            TriggerClientEvent(consumable.clientEvent.name, src, consumable.clientEvent.args and table.unpack(consumable.clientEvent.args))
        end
    end)
end
