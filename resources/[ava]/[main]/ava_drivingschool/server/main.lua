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

RegisterNetEvent("ava_drivingschool:client:passedTrafficLawsTest", function(score)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end

    local scoreMax<const> = #AVAConfig.TrafficLawsQuestions

    -- Put the score up to a hundred
    if score >= math.floor(scoreMax * 0.70) and score <= scoreMax then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("traffic_laws_succeeded", math.ceil(score / scoreMax * 100), 100), nil,
            "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))

        if not aPlayer.hasLicense("trafficLaws") then
            aPlayer.addLicense("trafficLaws")
        end
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("traffic_laws_failed", math.ceil(score / scoreMax * 100), 100), nil,
            "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))
    end
end)

RegisterNetEvent("ava_drivingschool:client:drivingTestScore", function(countErrors)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end

    if countErrors <= AVAConfig.DriverTest.MaxNumberOfErrorsAccepted then

        local hasLicense, license = aPlayer.hasLicense("driver")
        if hasLicense then
            local maxPoints<const> = exports.ava_core:GetLicenseMaxPoints("driver")
            if license.points < maxPoints then
                aPlayer.setLicensePoints("driver", maxPoints)
                TriggerClientEvent("ava_core:client:ShowNotification", src,
                    GetString("driver_succeeded_added_points", countErrors, AVAConfig.DriverTest.MaxNumberOfErrorsAccepted), nil, "CHAR_BEVERLY",
                    GetString("driving_school"), GetString("driving_test"))
            end
        else
            aPlayer.addLicense("driver")
            TriggerClientEvent("ava_core:client:ShowNotification", src,
                GetString("driver_succeeded", countErrors, AVAConfig.DriverTest.MaxNumberOfErrorsAccepted), nil, "CHAR_BEVERLY", GetString("driving_school"),
                GetString("driving_test"))
        end
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("driver_failed", countErrors, AVAConfig.DriverTest.MaxNumberOfErrorsAccepted),
            nil, "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))

    end
end)

RegisterNetEvent("ava_drivingschool:server:setDrivingTestVehicle", function(vehNet)
    local entityState = Entity(NetworkGetEntityFromNetworkId(vehNet))
    entityState.state:set("drivingTestVehicle", true, true)
end)
