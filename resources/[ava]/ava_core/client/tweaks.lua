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
    -- calm all IA
    local hashKeyPlayer = GetHashKey("PLAYER")
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), hashKeyPlayer)
    SetRelationshipBetweenGroups(1, GetHashKey("COP"), hashKeyPlayer)

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

    local loop = 0
    local playerId = PlayerId()
    while true do
        Wait(0)
        loop = loop + 1
        DisablePlayerVehicleRewards(playerId)

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

        if loop == 500 then
            loop = 0
            SetWeaponDrops()
        end
    end
end)

if AVAConfig.ClearMissionrowPD then
    local missionrowPDCoords = vector3(470.00, -990.00, 25.0)
    Citizen.CreateThread(function()
        while not AVA.Player.Data do
            Wait(10)
        end
        while true do
            Wait((#(AVA.Player.Data.position - missionrowPDCoords) < 50) and 0 or 1000)
            ClearAreaOfPeds(missionrowPDCoords.x, missionrowPDCoords.y, missionrowPDCoords.z, 50.0, 1)

            ClearAreaOfVehicles(missionrowPDCoords.x, missionrowPDCoords.y, missionrowPDCoords.z, 300, false, false, false, false, false)
            RemoveVehiclesFromGeneratorsInArea(missionrowPDCoords.x - 90.0, missionrowPDCoords.y - 90.0, missionrowPDCoords.z - 90.0,
                missionrowPDCoords.x + 90.0, missionrowPDCoords.y + 90.0, missionrowPDCoords.z + 90.0)
        end
    end)
end
