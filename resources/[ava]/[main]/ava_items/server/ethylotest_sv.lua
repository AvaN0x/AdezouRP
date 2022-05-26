-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterUsableItem("ethylotest", function(source)
    TriggerClientEvent("ava_items:ethylotest", source)
end)

RegisterServerEvent("ava_items:server:ethylotest:remove", function()
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        inventory.removeItem("ethylotest", 1)
    end
end)

exports.ava_core:RegisterServerCallback("ava_items:server:ethylotest:getTargetData", function(source, target)
    local aTarget = exports.ava_core:GetPlayer(target)
    if not aTarget then
        return
    end
    local data = {drunk = 0, drugged = 0}
    local playerStatus = aTarget.status

    for i = 1, #playerStatus, 1 do
        if playerStatus[i].name == "drunk" then
            data.drunk = math.floor((playerStatus[i].value / 100))
        elseif playerStatus[i].name == "drugged" then
            data.drugged = math.floor((playerStatus[i].value / 100))
        end
    end

    return data
end)
