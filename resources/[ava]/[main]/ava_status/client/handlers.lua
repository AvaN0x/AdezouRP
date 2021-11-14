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

-------------------------------------
--------------- Drunk ---------------
-------------------------------------
local IsDrunk, DrunkStage = false, -1

StatusFunctions["drunk"] = function(value, percent, playerHealth, newHealth)
    if percent > 100 then
        newHealth = playerHealth > 150 and (newHealth - 2) or (newHealth - 4)
    elseif percent > 20 then
        -- Only effect if above 20%

        -- 0 : slightlydrunk
        -- 1 : moderatelydrunk
        -- 2 : verydrunk
        local stage = 0
        if percent > 70 then
            stage = 2
        elseif percent > 40 then
            stage = 1
            -- else
            -- stage = 0
        end

        if DrunkStage ~= stage then
            DrunkStage = stage
            local shouldFade<const> = not IsDrunk
            Citizen.CreateThread(function()
                local playerPed = PlayerPedId()
                if shouldFade then
                    DoScreenFadeOut(800)
                    Wait(1000)
                end

                if DrunkStage == 0 then
                    exports.ava_core:RequestAnimDict("move_m@drunk@slightlydrunk")
                    SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
                    ShakeGameplayCam("DRUNK_SHAKE", 1.0)
                elseif DrunkStage == 1 then
                    exports.ava_core:RequestAnimDict("move_m@drunk@moderatedrunk")
                    SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
                    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
                elseif DrunkStage == 2 then
                    exports.ava_core:RequestAnimDict("move_m@drunk@verydrunk")
                    SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
                    ShakeGameplayCam("DRUNK_SHAKE", 2.0)
                end

                SetTimecycleModifier("spectator5")
                SetPedMotionBlur(playerPed, true)
                SetPedIsDrunk(playerPed, true) -- only sound

                if shouldFade then
                    DoScreenFadeIn(800)
                end
            end)
            IsDrunk = true
        end

    elseif IsDrunk then
        -- If drunk, reset
        IsDrunk = false
        DrunkStage = -1
        ResetPlayerStatusEffects()
        ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    end

    return newHealth
end

-------------------------------------
--------------- Drugged ---------------
-------------------------------------
local IsDrugged = false

StatusFunctions["drugged"] = function(value, percent, playerHealth, newHealth)
    if percent > 100 then
        newHealth = playerHealth > 150 and (newHealth - 2) or (newHealth - 4)
    elseif percent > 20 then
        -- Only effect if above 20%
        if not IsDrugged then
            Citizen.CreateThread(function()
                local playerPed = PlayerPedId()
                DoScreenFadeOut(800)
                Wait(1000)

                SetTimecycleModifier("DRUG_gas_huffin")

                DoScreenFadeIn(800)
            end)
            IsDrugged = true
        end

    elseif IsDrugged then
        -- If drugged, reset
        IsDrugged = false
        ResetPlayerStatusEffects()
    end

    return newHealth
end
