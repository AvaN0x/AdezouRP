-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- TODO check if needs to be redone
local damageValues = {
    -- [GetHashKey("WEAPON_ANIMAL")] = 1.0,
    -- [GetHashKey("WEAPON_COUGAR")] = 1.0,
    [GetHashKey("WEAPON_UNARMED")] = 0.35,
    -- [GetHashKey("WEAPON_KNIFE")] = 1.0,
    [GetHashKey("WEAPON_NIGHTSTICK")] = 0.2,
    [GetHashKey("WEAPON_HAMMER")] = 0.25,
    [GetHashKey("WEAPON_BAT")] = 0.25,
    [GetHashKey("WEAPON_CROWBAR")] = 0.5,
    [GetHashKey("WEAPON_GOLFCLUB")] = 0.25,
    [GetHashKey("WEAPON_KNUCKLE")] = 0.3,
    [GetHashKey("WEAPON_HATCHET")] = 1.0,
    [GetHashKey("WEAPON_MACHETE")] = 1.0,
    [GetHashKey("WEAPON_FLASHLIGHT")] = 0.05,
    [GetHashKey("WEAPON_SWITCHBLADE")] = 0.5,
    [GetHashKey("WEAPON_POOLCUE")] = 0.3,
    [GetHashKey("WEAPON_WRENCH")] = 0.2,
    -- [GetHashKey("WEAPON_BOTTLE")] = 1.0,
    -- [GetHashKey("WEAPON_PISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_COMBATPISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_APPISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_PISTOL50")] = 1.0,
    -- [GetHashKey("WEAPON_MICROSMG")] = 1.0,
    -- [GetHashKey("WEAPON_SMG")] = 1.0,
    -- [GetHashKey("WEAPON_ASSAULTSMG")] = 1.0,
    -- [GetHashKey("WEAPON_ASSAULTRIFLE")] = 1.0,
    -- [GetHashKey("WEAPON_CARBINERIFLE")] = 1.0,
    -- [GetHashKey("WEAPON_ADVANCEDRIFLE")] = 1.0,
    -- [GetHashKey("WEAPON_MG")] = 1.0,
    -- [GetHashKey("WEAPON_COMBATMG")] = 1.0,
    -- [GetHashKey("WEAPON_PUMPSHOTGUN")] = 1.0,
    -- [GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = 1.0,
    -- [GetHashKey("WEAPON_ASSAULTSHOTGUN")] = 1.0,
    -- [GetHashKey("WEAPON_BULLPUPSHOTGUN")] = 1.0,
    -- [GetHashKey("WEAPON_STUNGUN")] = 1.0,
    -- [GetHashKey("WEAPON_SNIPERRIFLE")] = 1.0,
    -- [GetHashKey("WEAPON_HEAVYSNIPER")] = 1.0,
    -- [GetHashKey("WEAPON_REMOTESNIPER")] = 1.0,
    -- [GetHashKey("WEAPON_GRENADELAUNCHER")] = 1.0,
    -- [GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE")] = 1.0,
    -- [GetHashKey("WEAPON_RPG")] = 1.0,
    -- [GetHashKey("WEAPON_PASSENGER_ROCKET")] = 1.0,
    -- [GetHashKey("WEAPON_AIRSTRIKE_ROCKET")] = 1.0,
    -- [GetHashKey("WEAPON_STINGER")] = 1.0,
    -- [GetHashKey("WEAPON_MINIGUN")] = 1.0,
    -- [GetHashKey("WEAPON_GRENADE")] = 1.0,
    -- [GetHashKey("WEAPON_STICKYBOMB")] = 1.0,
    -- [GetHashKey("WEAPON_SMOKEGRENADE")] = 1.0,
    -- [GetHashKey("WEAPON_BZGAS")] = 1.0,
    -- [GetHashKey("WEAPON_MOLOTOV")] = 1.0,
    -- [GetHashKey("WEAPON_FIREEXTINGUISHER")] = 1.0,
    -- [GetHashKey("WEAPON_PETROLCAN")] = 1.0,
    -- [GetHashKey("WEAPON_DIGISCANNER")] = 1.0,
    -- [GetHashKey("WEAPON_BRIEFCASE")] = 1.0,
    -- [GetHashKey("WEAPON_BRIEFCASE_02")] = 1.0,
    -- [GetHashKey("WEAPON_BALL")] = 1.0,
    -- [GetHashKey("WEAPON_FLARE")] = 1.0,
    -- [GetHashKey("WEAPON_VEHICLE_ROCKET")] = 1.0,
    -- [GetHashKey("WEAPON_BARBED_WIRE")] = 1.0,
    -- [GetHashKey("WEAPON_DROWNING")] = 1.0,
    -- [GetHashKey("WEAPON_DROWNING_IN_VEHICLE")] = 1.0,
    -- [GetHashKey("WEAPON_BLEEDING")] = 1.0,
    -- [GetHashKey("WEAPON_ELECTRIC_FENCE")] = 1.0,
    -- [GetHashKey("WEAPON_EXPLOSION")] = 1.0,
    -- [GetHashKey("WEAPON_FALL")] = 1.0,
    -- [GetHashKey("WEAPON_EXHAUSTION")] = 1.0,
    -- [GetHashKey("WEAPON_HIT_BY_WATER_CANNON")] = 1.0,
    -- [GetHashKey("WEAPON_RAMMED_BY_CAR")] = 1.0,
    -- [GetHashKey("WEAPON_RUN_OVER_BY_CAR")] = 1.0,
    -- [GetHashKey("WEAPON_HELI_CRASH")] = 1.0,
    -- [GetHashKey("WEAPON_FIRE")] = 1.0,
    -- [GetHashKey("WEAPON_SNSPISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_GUSENBERG")] = 1.0,
    -- [GetHashKey("WEAPON_SPECIALCARBINE")] = 1.0,
    -- [GetHashKey("WEAPON_HEAVYPISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_BULLPUPRIFLE")] = 1.0,
    -- [GetHashKey("WEAPON_DAGGER")] = 1.0,
    -- [GetHashKey("WEAPON_VINTAGEPISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_FIREWORK")] = 1.0,
    -- [GetHashKey("WEAPON_MUSKET")] = 1.0,
    -- [GetHashKey("WEAPON_HEAVYSHOTGUN")] = 1.0,
    -- [GetHashKey("WEAPON_MARKSMANRIFLE")] = 1.0,
    -- [GetHashKey("WEAPON_HOMINGLAUNCHER")] = 1.0,
    -- [GetHashKey("WEAPON_PROXMINE")] = 1.0,
    [GetHashKey("WEAPON_SNOWBALL")] = 0.01,
    -- [GetHashKey("WEAPON_FLAREGUN")] = 1.0,
    -- [GetHashKey("WEAPON_GARBAGEBAG")] = 1.0,
    -- [GetHashKey("WEAPON_HANDCUFFS")] = 1.0,
    -- [GetHashKey("WEAPON_COMBATPDW")] = 1.0,
    -- [GetHashKey("WEAPON_MARKSMANPISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_RAILGUN")] = 1.0,
    -- [GetHashKey("WEAPON_MACHINEPISTOL")] = 1.0,
    -- [GetHashKey("WEAPON_AIR_DEFENCE_GUN")] = 1.0,
    -- [GetHashKey("WEAPON_REVOLVER")] = 1.0,
    -- [GetHashKey("WEAPON_DBSHOTGUN")] = 1.0,
    -- [GetHashKey("WEAPON_COMPACTRIFLE")] = 1.0,
    -- [GetHashKey("WEAPON_AUTOSHOTGUN")] = 1.0,
    -- [GetHashKey("WEAPON_BATTLEAXE")] = 1.0,
    -- [GetHashKey("WEAPON_COMPACTLAUNCHER")] = 1.0,
    -- [GetHashKey("WEAPON_MINISMG")] = 1.0,
    -- [GetHashKey("WEAPON_PIPEBOMB")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_ROTORS")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_TANK")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_PLANE_ROCKET")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_LAZER")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_LASER")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_BULLET")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_BUZZARD")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_HUNTER")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_ENEMY_LASER")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_SEARCHLIGHT")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_RADAR")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_WATER_CANNON")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_INSURGENT")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_TECHNICAL")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_NOSE_TURRET_VALKYRIE")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_SAVAGE")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_LIMO")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_CANNON_BLAZER")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_BOXVILLE")] = 1.0,
    -- [GetHashKey("VEHICLE_WEAPON_RUINER_BULLET")] = 1.0,
}

-- * old way of doing it
-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         -- TODO probably edit to only edit the actually equiped weapon
--         for k, v in pairs(damageValues) do
--             SetWeaponDamageModifierThisFrame(k, v)
--         end
--     end
-- end)

local playerPed
local currWeaponHash

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        currWeaponHash = GetSelectedPedWeapon(playerPed)
        Wait(200)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 200
        if currWeaponHash and damageValues[currWeaponHash] then
            wait = 0
            SetWeaponDamageModifierThisFrame(currWeaponHash, damageValues[currWeaponHash])
        end
        Wait(wait)
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--         Wait(5)

--         SetPedSuffersCriticalHits(PlayerPedId(), false) -- headshot will not be a critical hit
--     end
-- end)
