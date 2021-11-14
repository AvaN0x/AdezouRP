-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
StatusFunctions["hunger"] = function(value, percent, playerHealth, newHealth)
    if percent == 0 then
        newHealth = playerHealth > 150 and (newHealth - 2) or (newHealth - 4)
    elseif percent > 100 then
        TriggerEvent("ava_status:client:add", "injured", 10)
    end

    return newHealth
end

StatusFunctions["thirst"] = StatusFunctions["hunger"]
