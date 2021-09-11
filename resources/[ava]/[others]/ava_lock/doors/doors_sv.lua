-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local doorsInfo = {}

RegisterServerEvent("ava_doors:updateState")
AddEventHandler("ava_doors:updateState", function(doorID, state)
    local aPlayer = exports.ava_core:GetPlayer(source)

    if type(doorID) ~= "number" then
        print(("ava_doors: %s didn't send a number!"):format(aPlayer.identifiers.license))
        return
    end

    if type(state) ~= "boolean" then
        print(("ava_doors: %s attempted to update invalid state!"):format(aPlayer.identifiers.license))
        return
    end

    if not ConfigDoors.DoorList[doorID] then
        print(("ava_doors: %s attempted to update invalid door!"):format(aPlayer.identifiers.license))
        return
    end

    doorsInfo[doorID] = state

    TriggerClientEvent("ava_doors:setState", -1, doorID, state)
end)

exports.ava_core:RegisterServerCallback("ava_doors:getDoorsInfo", function()
    return doorsInfo
end)
