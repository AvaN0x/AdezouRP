-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterServerCallback("ava_drivingschool:server:payForLicense", function(source, licenseName)
    local src = source
    local price = AVAConfig.Prices[licenseName]

    if price ~= nil then
        local aPlayer = exports.ava_core:GetPlayer(src)
        if aPlayer then
            local inventory = aPlayer.getInventory()
            if inventory.canRemoveItem("cash", price) then
                inventory.removeItem("cash", price)
                return true
            end
        end
    end
    return false
end)

RegisterNetEvent("ava_drivingschool:client:passedTest", function(licenseName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        aPlayer.addLicense(licenseName)
    end
end)
