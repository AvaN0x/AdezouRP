-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false

    repeat
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false)
        end
        finished, ped = FindNextPed(handle)
    until not finished

    EndFindPed(handle)
end

Citizen.CreateThread(function()
    local playerId <const> = PlayerId()

    -- calm all IA
    local hashKeyPlayer <const> = GetHashKey("PLAYER")
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_WEICHENG"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_LOST"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("COP"), hashKeyPlayer)
    -- SetRelationshipBetweenGroups(1, GetHashKey("ARMY"), hashKeyPlayer)
    -- SetRelationshipBetweenGroups(1, GetHashKey("SECURITY_GUARD"), hashKeyPlayer)

    -- DT_Invalid
    -- DT_PoliceAutomobile
    -- DT_PoliceHelicopter
    -- DT_FireDepartment
    -- DT_SwatAutomobile
    -- DT_AmbulanceDepartment
    -- DT_PoliceRiders
    -- DT_PoliceVehicleRequest
    -- DT_PoliceRoadBlock
    -- DT_PoliceAutomobileWaitPulledOver
    -- DT_PoliceAutomobileWaitCruising
    -- DT_Gangs
    -- DT_SwatHelicopter
    -- DT_PoliceBoat
    -- DT_ArmyVehicle
    -- DT_BikerBackup
    for i = 1, 15 do
        EnableDispatchService(i, false)
    end

    -- * remove wanted level
    SetMaxWantedLevel(0)
    SetPoliceIgnorePlayer(playerId, true)
    SetDispatchCopsForPlayer(playerId, false)
    SetAudioFlag("OnlyAllowScriptTriggerPoliceScanner", true)
    SetAudioFlag("PoliceScannerDisabled", true)

    -- * set some stats
    StatSetInt(GetHashKey("MP0_STAMINA"), 30, true)
    StatSetInt(GetHashKey("MP0_STRENGTH"), 0, true)
    StatSetInt(GetHashKey("MP0_LUNG_CAPACITY"), 100, true)
    StatSetInt(GetHashKey("MP0_WHEELIE_ABILITY"), 0, true)
    StatSetInt(GetHashKey("MP0_FLYING_ABILITY"), 0, true)
    StatSetInt(GetHashKey("MP0_SHOOTING_ABILITY"), 0, true)
    StatSetInt(GetHashKey("MP0_STEALTH_ABILITY"), 0, true)

    SetWeaponsNoAutoreload(AVAConfig.DisableWeaponsAutoReload)
    SetWeaponsNoAutoswap(AVAConfig.DisableWeaponsAutoSwap)

    local loop = 0
    while true do
        Wait(0)
        loop = loop + 1
        DisablePlayerVehicleRewards(playerId)
        SetPlayerHealthRechargeMultiplier(playerId, 0.0)

        SetPedDensityMultiplierThisFrame(0.5)
        SetVehicleDensityMultiplierThisFrame(0.65)
        SetRandomVehicleDensityMultiplierThisFrame(0.65)
        SetParkedVehicleDensityMultiplierThisFrame(0.8)

        -- * These natives have to be called every frame.
        -- SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
        -- SetGarbageTrucks(false)
        -- SetRandomBoats(false)

        -- SetCreateRandomCops(false)
        -- SetCreateRandomCopsNotOnScenarios(false)
        -- SetCreateRandomCopsOnScenarios(false)

        if GetPlayerWantedLevel(playerId) > 0 then
            SetPlayerWantedLevel(playerId, 0, false)
            SetPlayerWantedLevelNow(playerId, false)
        end

        if loop == 500 then
            loop = 0
            SetWeaponDrops()
        end
    end
end)

---------------------------------------
-------- CAN'T FALL AT LOADING --------
---------------------------------------
if AVAConfig.PreventPlayerFromFalling then
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()

        dprint("Freeze player, waiting for collisions to load")
        FreezeEntityPosition(playerPed, true)
        while not HasCollisionLoadedAroundEntity(playerPed) do
            Wait(10)
        end
        FreezeEntityPosition(playerPed, false)
        dprint("Unfreeze player, collisions loaded around player")
    end)
end
