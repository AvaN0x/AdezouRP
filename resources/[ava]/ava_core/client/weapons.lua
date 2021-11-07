-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local ammoTypesToItem = {
    [GetHashKey("AMMO_GRENADE")] = "weapon_grenade",
    [GetHashKey("AMMO_BZGAS")] = "weapon_bzgas",
    [GetHashKey("AMMO_MOLOTOV")] = "weapon_molotov",
    [GetHashKey("AMMO_STICKYBOMB")] = "weapon_stickybomb",
    [GetHashKey("AMMO_PROXMINE")] = "weapon_proxmine",
    [GetHashKey("AMMO_SNOWBALL")] = "weapon_snowball",
    [GetHashKey("AMMO_PIPEBOMB")] = "weapon_pipebomb",
    [GetHashKey("AMMO_BALL")] = "weapon_ball",
    [GetHashKey("AMMO_SMOKEGRENADE")] = "weapon_smokegrenade",
    [GetHashKey("AMMO_FLARE")] = "weapon_flare",

    [GetHashKey("AMMO_STUNGUN")] = "INFINITE",
    [GetHashKey("AMMO_RAYPISTOL")] = "INFINITE",

    [GetHashKey("AMMO_GRENADELAUNCHER")] = "AMMO_GRENADELAUNCHER",
    [GetHashKey("AMMO_GRENADELAUNCHER_SMOKE")] = "AMMO_GRENADELAUNCHER_SMOKE",
    [GetHashKey("AMMO_RPG")] = "AMMO_RPG",
    [GetHashKey("AMMO_MINIGUN")] = "AMMO_MINIGUN",
    [GetHashKey("AMMO_FIREEXTINGUISHER")] = "AMMO_FIREEXTINGUISHER",
    [GetHashKey("AMMO_PETROLCAN")] = "AMMO_PETROLCAN",
    [GetHashKey("AMMO_HOMINGLAUNCHER")] = "AMMO_HOMINGLAUNCHER",
    [GetHashKey("AMMO_RIFLE")] = "AMMO_RIFLE",
    [GetHashKey("AMMO_RIFLE_TRACER")] = "AMMO_RIFLE_TRACER",
    [GetHashKey("AMMO_RIFLE_INCENDIARY")] = "AMMO_RIFLE_INCENDIARY",
    [GetHashKey("AMMO_RIFLE_ARMORPIERCING")] = "AMMO_RIFLE_ARMORPIERCING",
    [GetHashKey("AMMO_RIFLE_FMJ")] = "AMMO_RIFLE_FMJ",
    [GetHashKey("AMMO_SNIPER")] = "AMMO_SNIPER",
    [GetHashKey("AMMO_SNIPER_TRACER")] = "AMMO_SNIPER_TRACER",
    [GetHashKey("AMMO_SNIPER_INCENDIARY")] = "AMMO_SNIPER_INCENDIARY",
    [GetHashKey("AMMO_SNIPER_ARMORPIERCING")] = "AMMO_SNIPER_ARMORPIERCING",
    [GetHashKey("AMMO_SNIPER_FMJ")] = "AMMO_SNIPER_FMJ",
    [GetHashKey("AMMO_SNIPER_EXPLOSIVE")] = "AMMO_SNIPER_EXPLOSIVE",
    [GetHashKey("AMMO_SHOTGUN")] = "AMMO_SHOTGUN",
    [GetHashKey("AMMO_SHOTGUN_INCENDIARY")] = "AMMO_SHOTGUN_INCENDIARY",
    [GetHashKey("AMMO_SHOTGUN_ARMORPIERCING")] = "AMMO_SHOTGUN_ARMORPIERCING",
    [GetHashKey("AMMO_SHOTGUN_HOLLOWPOINT")] = "AMMO_SHOTGUN_HOLLOWPOINT",
    [GetHashKey("AMMO_SHOTGUN_EXPLOSIVE")] = "AMMO_SHOTGUN_EXPLOSIVE",
    [GetHashKey("AMMO_PISTOL")] = "AMMO_PISTOL",
    [GetHashKey("AMMO_PISTOL_TRACER")] = "AMMO_PISTOL_TRACER",
    [GetHashKey("AMMO_PISTOL_INCENDIARY")] = "AMMO_PISTOL_INCENDIARY",
    [GetHashKey("AMMO_PISTOL_HOLLOWPOINT")] = "AMMO_PISTOL_HOLLOWPOINT",
    [GetHashKey("AMMO_PISTOL_FMJ")] = "AMMO_PISTOL_FMJ",
    [GetHashKey("AMMO_SMG")] = "AMMO_SMG",
    [GetHashKey("AMMO_SMG_TRACER")] = "AMMO_SMG_TRACER",
    [GetHashKey("AMMO_SMG_INCENDIARY")] = "AMMO_SMG_INCENDIARY",
    [GetHashKey("AMMO_SMG_HOLLOWPOINT")] = "AMMO_SMG_HOLLOWPOINT",
    [GetHashKey("AMMO_SMG_FMJ")] = "AMMO_SMG_FMJ",
    [GetHashKey("AMMO_MG")] = "AMMO_MG",
    [GetHashKey("AMMO_MG_TRACER")] = "AMMO_MG_TRACER",
    [GetHashKey("AMMO_MG_INCENDIARY")] = "AMMO_MG_INCENDIARY",
    [GetHashKey("AMMO_MG_ARMORPIERCING")] = "AMMO_MG_ARMORPIERCING",
    [GetHashKey("AMMO_MG_FMJ")] = "AMMO_MG_FMJ",
    [GetHashKey("AMMO_FLAREGUN")] = "AMMO_FLAREGUN",
    [GetHashKey("AMMO_HAZARDCAN")] = "AMMO_HAZARDCAN",
    [GetHashKey("AMMO_FIREWORK")] = "AMMO_FIREWORK",
    [GetHashKey("AMMO_RAILGUN")] = "AMMO_RAILGUN",
}

RegisterNetEvent("ava_core:client:updateAmmoTypeCount", function(ammoTypeHash, ammoCount)
    dprint("UPDATE AMMO", ammoTypesToItem[ammoTypeHash] or "NOT_FOUND", ammoCount)
    SetPedAmmoByType(PlayerPedId(), ammoTypeHash, ammoCount)
end)

local shotAmmos = {}
local timeLastTrigger, waitingToTrigger = -1, false

---Trigger server with shot ammo count with an interval of 2000ms
---@param ammoItemName Actually ammo item name
local function shotAmmo(ammoItemName)
    shotAmmos[ammoItemName] = (shotAmmos[ammoItemName] or 0) + 1

    -- Only enter if we are not waiting to trigger
    if not waitingToTrigger then
        -- prevent spamming the server for data
        -- this will do it with at least 3000ms between each calls
        waitingToTrigger = true
        Citizen.CreateThread(function()
            local timer = GetGameTimer()
            while (math.abs(timer - timeLastTrigger) < 3000) do
                timer = GetGameTimer()
                Wait(10)
            end
            timeLastTrigger = timer
            waitingToTrigger = false
            for itemName, count in pairs(shotAmmos) do
                TriggerServerEvent("ava_core:server:playerShotAmmoType", itemName, count)
                shotAmmos[itemName] = nil
            end
        end)
    end
end
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        if IsPedShooting(playerPed) then
            local weaponHash = GetSelectedPedWeapon(playerPed)
            local ammoTypeHash = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)
            local ammoItemName = ammoTypesToItem[ammoTypeHash] or ammoTypeHash
            if ammoItemName ~= "INFINITE" then
                shotAmmo(ammoItemName)
            end
        end
    end
end)
