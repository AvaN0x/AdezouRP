-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
StatusFunctions["hunger"] = function(value, percent, playerHealth, newHealth)
    if percent == 0 then
        newHealth = playerHealth > 150 and (newHealth - 2) or (newHealth - 4)
    elseif percent > 100 then
        TriggerEvent("ava_status:client:add", "injured", 15)
    end

    return newHealth
end

StatusFunctions["thirst"] = StatusFunctions["hunger"]

-------------------------------------
--------------- Drunk ---------------
-------------------------------------
local DrunkStage = -1

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
            local shouldFade<const> = DrunkStage == -1
            Citizen.CreateThread(function()
                local playerPed = PlayerPedId()
                if shouldFade then
                    DoScreenFadeOut(800)
                    Wait(1000)
                end

                if stage == 0 then
                    exports.ava_core:RequestAnimDict("move_m@drunk@slightlydrunk")
                    SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
                    ShakeGameplayCam("DRUNK_SHAKE", 1.0)
                elseif stage == 1 then
                    exports.ava_core:RequestAnimDict("move_m@drunk@moderatedrunk")
                    SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
                    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
                elseif stage == 2 then
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
                DrunkStage = stage
            end)
        end

    elseif DrunkStage ~= -1 then
        -- If drunk, reset
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

---------------------------------------
--------------- Injured ---------------
---------------------------------------
local InjuredStage, InjuredLoop = -1, 0

StatusFunctions["injured"] = function(value, percent, playerHealth, newHealth)
    if percent > 0 then
        local stage = 0
        if percent > 50 then
            stage = 1
            -- else
            -- stage = 0
        end

        if InjuredStage ~= stage or InjureLoop >= 10 then
            InjureLoop = 0
            local shouldFade<const> = (stage == 1 and InjuredStage == 0) or (stage == 0 and InjuredStage == 1)
            Citizen.CreateThread(function()
                local playerPed = PlayerPedId()
                if shouldFade then
                    DoScreenFadeOut(800)
                    Wait(1000)
                end

                exports.ava_core:RequestAnimDict("move_injured_generic")
                SetPedMovementClipset(playerPed, "move_injured_generic", true)

                if stage == 0 and InjuredStage == 1 then
                    -- If previous was 1 and actual is 0
                    ClearTimecycleModifier()
                elseif stage == 1 then
                    -- TODO Need to decide which timecycle modifier to use
                    -- SetTimecycleModifier("phone_cam5")

                    SetTimecycleModifier("pulse")

                    -- SetTimecycleModifier("redmist")
                    -- SetTimecycleModifierStrength(0.7)
                end

                SetPedMotionBlur(playerPed, true)

                if shouldFade then
                    DoScreenFadeIn(800)
                end
                InjuredStage = stage
            end)
        end
        InjureLoop = InjureLoop + 1

    elseif InjuredStage ~= -1 then
        -- If injured, reset
        InjuredStage = -1
        ResetPlayerStatusEffects()
    end

    return newHealth
end
