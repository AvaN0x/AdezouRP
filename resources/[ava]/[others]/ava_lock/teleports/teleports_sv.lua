-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local teleportersInfo = {}

RegisterServerEvent("ava_teleports:updateState")
AddEventHandler("ava_teleports:updateState", function(tpID, state)
    local aPlayer = exports.ava_core:GetPlayer(source)

    if type(tpID) ~= "number" then
        print(("ava_teleports: %s didn't send a number!"):format(xPlayer.identifier))
        return
    end

    if type(state) ~= "boolean" then
        print(("ava_teleports: %s attempted to update invalid state!"):format(xPlayer.identifier))
        return
    end

    if not ConfigTeleports.TeleportersList[tpID] then
        print(("ava_teleports: %s attempted to update invalid door!"):format(xPlayer.identifier))
        return
    end

    teleportersInfo[tpID] = state

    TriggerClientEvent("ava_teleports:setState", -1, tpID, state)
end)

exports.ava_core:RegisterServerCallback("ava_doors:getTeleportersInfo", function()
    return teleportersInfo
end)
