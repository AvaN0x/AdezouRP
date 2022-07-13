-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
IsAnimated = false
IsLongAnimated = false

local function StartAnim(playerPed, animDict, animName, flag)
    exports.ava_core:RequestAnimDict(animDict)
    TaskPlayAnim(playerPed, animDict, animName, 8.0, 8.0, -1, flag or 49, 0, 0, 0, 0)
    RemoveAnimDict(animDict)
end

function SetLongAnimated(animDict, animName, flag, prop)
    IsLongAnimated = true

    Citizen.CreateThread(function()
        -- Handle animation
        StartAnim(PlayerPedId(), animDict, animName, flag)
        repeat
            Wait(500)
            if not IsEntityPlayingAnim(PlayerPedId(), animDict, animName, 3) then
                StartAnim(PlayerPedId(), animDict, animName, flag)
            end
        until not IsLongAnimated
        ClearPedSecondaryTask(PlayerPedId())
    end)
    Citizen.CreateThread(function()
        -- Handle player controls
        local instructionalButtons = exports.ava_core:GetScaleformInstructionalButtons({ { control = "~INPUT_VEH_DUCK~",
            label = GetString("cancel_animation") } })

        while IsLongAnimated do
            Wait(0)
            DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)
            if IsControlJustPressed(1, 73) or IsControlJustPressed(1, 24) or IsControlJustPressed(1, 25) then -- X, RMB or LMB
                IsLongAnimated = false
            end
        end

        if prop then
            exports.ava_core:DeleteObject(prop)
        end
    end)
end

function StopLongAnimatedIfNeeded()
    if IsLongAnimated then
        IsLongAnimated = false
        Wait(50)
    end
end

--------------------------------------
--------------- Events ---------------
--------------------------------------

RegisterNetEvent("ava_status:client:eat", function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or "prop_cs_burger_01"
        IsAnimated = true
        StopLongAnimatedIfNeeded()

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.052, 0.031, -70.0, 175.0, 90.0, true, true, false,
                true, 1, true)

            StartAnim(playerPed, "mp_player_inteat@burger", "mp_player_int_eat_burger_fp", 49)

            Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(playerPed)
            exports.ava_core:DeleteObject(prop)
        end)
    end
end)

RegisterNetEvent("ava_status:client:drink", function(prop_name)
    if not IsAnimated then
        prop_name = prop_name or "prop_ld_flow_bottle"
        IsAnimated = true
        StopLongAnimatedIfNeeded()

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(joaat(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.15, 0.018, 0.031, -100.0, 55.0, 350.0, true, true, false,
                true, 1, true)

            StartAnim(playerPed, "mp_player_intdrink", "loop_bottle", 49)

            Wait(3000)
            IsAnimated = false
            ClearPedSecondaryTask(playerPed)
            exports.ava_core:DeleteObject(prop)
        end)
    end
end)

RegisterNetEvent("ava_status:client:smoke", function()
    if not IsAnimated then
        IsAnimated = true
        StopLongAnimatedIfNeeded()

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()

            local x, y, z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(`p_amb_joint_01`, x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.145, 0.038, 0.045, 0.0, 0.0, 80.0, true, true, false, true
                , 1, true)

            SetLongAnimated("amb@world_human_smoking_pot@male@base", "base", 49, prop)

            IsAnimated = false
        end)
    end
end)

RegisterNetEvent("ava_status:client:takePill", function()
    if not IsAnimated then
        IsAnimated = true
        StopLongAnimatedIfNeeded()

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()

            StartAnim(playerPed, "mp_player_intdrink", "loop_bottle", 49)

            Wait(1000)

            IsAnimated = false
            ClearPedSecondaryTask(playerPed)
        end)
    end
end)

-------------------------------------
--------------- Reset ---------------
-------------------------------------

function ResetPlayerStatusEffects()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()

        DoScreenFadeOut(1200)
        Wait(1000)

        ClearTimecycleModifier()
        SetPedIsDrunk(playerPed, false) -- only sound
        SetPedMotionBlur(playerPed, false)
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(playerPed, 0)

        DoScreenFadeIn(800)
    end)
end
