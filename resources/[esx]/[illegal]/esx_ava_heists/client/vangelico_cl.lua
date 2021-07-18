-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local TrayAnimationConfig = {
    DES_Jewel_Cab = {
        Speed = 0.2,
        AnimationName = "smash_case_necklace"
    },
    DES_Jewel_Cab2 = {
        Speed = 0.143,
        AnimationName = "smash_case_e"
    },
    DES_Jewel_Cab3 = {
        Speed = 0.168,
        AnimationName = "smash_case_tray_a"
    },
    DES_Jewel_Cab4 = {
        Speed = 0.041,
        AnimationName = "smash_case_tray_b"
    },
}

function SmashTray(heistName, stageIndex, stealableName, trayIndex)
    if playerIsInAction then return end

    local heist = Config.Heists[heistName]
    if heist == nil then return end
    local stage = heist.Stages[stageIndex]
    if stage == nil then return end
    local stealable = stage.Stealables[stealableName]
    if stealable == nil then return end
    local tray = stealable.Zones[trayIndex]
    if tray == nil then return end

    local animConfig = TrayAnimationConfig[tray.RayFireName]
    if animConfig == nil then return end

    if not IsPedArmed(playerPed, 4) or GetSelectedPedWeapon(playerPed) == GetHashKey("weapon_stungun") then
        ESX.ShowNotification("Tu dois être armé pour pouvoir casser la vitrine.")
        return
    end

    Citizen.CreateThread(function()
        playerIsInAction = true
        ESX.TriggerServerCallback("esx_ava_heists:stealables:canSteal", function(canSteal)
            if canSteal then
                local isAtCoord = exports.esx_avan0x:CancelableGoStraightToCoord(playerPed, tray.Coord, 0.1, -1, tray.Heading, 0.5)

                if isAtCoord then
                    tray.Stolen = true
                    
                    TriggerServerEvent("esx_ava_heists:serverEvent", heistName, {
                        SmashTray = true,
                        StageIndex = stageIndex,
                        StealableName = stealableName,
                        TrayIndex = trayIndex,
                        PedNet = PedToNet(playerPed)
                    })

                    while not HasAnimDictLoaded("missheist_jewel") do
                        RequestAnimDict("missheist_jewel")
                        Citizen.Wait(10)
                    end   
                    RequestScriptAudioBank("SCRIPT\\JWL_HA_RAID_STORE", 0, -1)
                    RequestScriptAudioBank("SCRIPT\\JWL_HEIST_RAID_GLASS_SMASH", 0, -1)
                    StartAudioScene("JSH_2B_CABINET_SMASH")
        
                    TaskPlayAnimAdvanced(playerPed, "missheist_jewel", animConfig.AnimationName, tray.Coord, 0.0, 0.0, tray.Heading, 1000.0, -4.0, -1, 1, 11000.0)
                    Citizen.Wait(50)
                    local hasFinishedAnimation = false
                    while true do
                        Citizen.Wait(0)
                        if not IsEntityPlayingAnim(playerPed, "missheist_jewel", animConfig.AnimationName, 3) then
                            break
                        elseif GetEntityAnimCurrentTime(playerPed, "missheist_jewel", animConfig.AnimationName) >= 0.9 then
                            hasFinishedAnimation = true
                            break
                        end
                    end

                    ClearPedTasks(playerPed)
                    if hasFinishedAnimation then
                        TriggerServerEvent("esx_ava_heists:serverEvent", heistName, {
                            Steal = true,
                            StageIndex = stageIndex,
                            StealableName = stealableName,
                            TrayIndex = trayIndex,
                        })
                    else
                        tray.Stolen = false
                        ESX.ShowNotification("Tu as annulé l'animation.")
                    end
                end
            else
                -- in case somebody manage to try to steal an already stolen (on server side) tray
                tray.Stolen = true
            end
            playerIsInAction = false
        end, heistName, stageIndex, stealableName, trayIndex)
    end)
end


function SmashTrayEvent(heistName, options)
    local heist = Config.Heists[heistName]
    local stage = heist.Stages[options.StageIndex]
    local stealable = stage.Stealables[options.StealableName]
    local tray = stealable.Zones[options.TrayIndex]

    local animConfig = TrayAnimationConfig[tray.RayFireName]
    if animConfig == nil then return end

    RequestNamedPtfxAsset("scr_jewelheist")
    while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
        Citizen.Wait(0)
    end
    UseParticleFxAsset("scr_jewelheist")

    local object = GetRayfireMapObject(tray.PropCoord, 0.5, tray.RayFireName)
    SetStateOfRayfireMapObject(object, 4)

    local ped = NetToPed(options.PedNet)

    while true do
        Citizen.Wait(0)

        local currentAnimTime = GetEntityAnimCurrentTime(ped, "missheist_jewel", animConfig.AnimationName)

        if currentAnimTime > animConfig.Speed then
            for i = 1, 3, 1 do
                PlaySoundFromCoord(-1, "Glass_Smash", tray.PropCoord, 0, 0, 0)
            end
            PlaySoundFromCoord(GetSoundId(), "SMASH_CABINET_PLAYER", tray.PropCoord, "JEWEL_HEIST_SOUNDS", 0, 0, 0)

            SetStateOfRayfireMapObject(object, 6)

            StartParticleFxNonLoopedOnEntity("scr_jewel_cab_smash", GetCurrentPedWeaponEntityIndex(ped), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, 0, 0, 0)
            break
        end
    end
end
