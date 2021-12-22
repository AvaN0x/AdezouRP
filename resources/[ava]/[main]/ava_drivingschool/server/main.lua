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
    local aPlayer = exports.ava_core:GetPlayer(source)
    if not aPlayer then
        return
    end

    local scoreMax = 0
    for i = 1, #AVAConfig.TrafficLawsQuestions do
        local question<const> = AVAConfig.TrafficLawsQuestions[i]
        if question.oneAnswer then
            scoreMax = scoreMax + 1
        elseif question.answers then
            for j = 1, #question.answers do
                if question.answers[j].right then
                    scoreMax = scoreMax + 1
                end
            end
        end
    end

    -- Put the score up to a hundred
    if score > math.floor(scoreMax * 0.8) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("traffic_laws_succeeded", math.ceil(score / scoreMax * 100), 100))

        if not aPlayer.hasLicense("trafficLaws") then
            aPlayer.addLicense("trafficLaws")
        end
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("traffic_laws_failed", math.ceil(score / scoreMax * 100), 100))
    end
end)

RegisterNetEvent("ava_drivingschool:client:passedDrivingTest", function(score)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if not aPlayer then
        return
    end

    if not aPlayer.hasLicense("driver") then
        aPlayer.addLicense("driver")
    end
end)
