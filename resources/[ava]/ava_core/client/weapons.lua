-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local ammoTypesToItem = {
    [GetHashKey("ammo_grenade")] = "weapon_grenade",
    [GetHashKey("ammo_bzgas")] = "weapon_bzgas",
    [GetHashKey("ammo_molotov")] = "weapon_molotov",
    [GetHashKey("ammo_stickybomb")] = "weapon_stickybomb",
    [GetHashKey("ammo_proxmine")] = "weapon_proxmine",
    [GetHashKey("ammo_snowball")] = "weapon_snowball",
    [GetHashKey("ammo_pipebomb")] = "weapon_pipebomb",
    [GetHashKey("ammo_ball")] = "weapon_ball",
    [GetHashKey("ammo_smokegrenade")] = "weapon_smokegrenade",
    [GetHashKey("ammo_flare")] = "weapon_flare",

    [GetHashKey("ammo_stungun")] = "infinite",
    [GetHashKey("ammo_raypistol")] = "infinite",

    [GetHashKey("ammo_grenadelauncher")] = "ammo_grenadelauncher",
    [GetHashKey("ammo_grenadelauncher_smoke")] = "ammo_grenadelauncher_smoke",
    [GetHashKey("ammo_rpg")] = "ammo_rpg",
    [GetHashKey("ammo_minigun")] = "ammo_minigun",
    [GetHashKey("ammo_fireextinguisher")] = "ammo_fireextinguisher",
    [GetHashKey("ammo_petrolcan")] = "ammo_petrolcan",
    [GetHashKey("ammo_hominglauncher")] = "ammo_hominglauncher",
    [GetHashKey("ammo_rifle")] = "ammo_rifle",
    [GetHashKey("ammo_rifle_tracer")] = "ammo_rifle_tracer",
    [GetHashKey("ammo_rifle_incendiary")] = "ammo_rifle_incendiary",
    [GetHashKey("ammo_rifle_armorpiercing")] = "ammo_rifle_armorpiercing",
    [GetHashKey("ammo_rifle_fmj")] = "ammo_rifle_fmj",
    [GetHashKey("ammo_sniper")] = "ammo_sniper",
    [GetHashKey("ammo_sniper_tracer")] = "ammo_sniper_tracer",
    [GetHashKey("ammo_sniper_incendiary")] = "ammo_sniper_incendiary",
    [GetHashKey("ammo_sniper_armorpiercing")] = "ammo_sniper_armorpiercing",
    [GetHashKey("ammo_sniper_fmj")] = "ammo_sniper_fmj",
    [GetHashKey("ammo_sniper_explosive")] = "ammo_sniper_explosive",
    [GetHashKey("ammo_shotgun")] = "ammo_shotgun",
    [GetHashKey("ammo_shotgun_incendiary")] = "ammo_shotgun_incendiary",
    [GetHashKey("ammo_shotgun_armorpiercing")] = "ammo_shotgun_armorpiercing",
    [GetHashKey("ammo_shotgun_hollowpoint")] = "ammo_shotgun_hollowpoint",
    [GetHashKey("ammo_shotgun_explosive")] = "ammo_shotgun_explosive",
    [GetHashKey("ammo_pistol")] = "ammo_pistol",
    [GetHashKey("ammo_pistol_tracer")] = "ammo_pistol_tracer",
    [GetHashKey("ammo_pistol_incendiary")] = "ammo_pistol_incendiary",
    [GetHashKey("ammo_pistol_hollowpoint")] = "ammo_pistol_hollowpoint",
    [GetHashKey("ammo_pistol_fmj")] = "ammo_pistol_fmj",
    [GetHashKey("ammo_smg")] = "ammo_smg",
    [GetHashKey("ammo_smg_tracer")] = "ammo_smg_tracer",
    [GetHashKey("ammo_smg_incendiary")] = "ammo_smg_incendiary",
    [GetHashKey("ammo_smg_hollowpoint")] = "ammo_smg_hollowpoint",
    [GetHashKey("ammo_smg_fmj")] = "ammo_smg_fmj",
    [GetHashKey("ammo_mg")] = "ammo_mg",
    [GetHashKey("ammo_mg_tracer")] = "ammo_mg_tracer",
    [GetHashKey("ammo_mg_incendiary")] = "ammo_mg_incendiary",
    [GetHashKey("ammo_mg_armorpiercing")] = "ammo_mg_armorpiercing",
    [GetHashKey("ammo_mg_fmj")] = "ammo_mg_fmj",
    [GetHashKey("ammo_flaregun")] = "ammo_flaregun",
    [GetHashKey("ammo_hazardcan")] = "ammo_hazardcan",
    [GetHashKey("ammo_firework")] = "ammo_firework",
    [GetHashKey("ammo_railgun")] = "ammo_railgun",
    [GetHashKey("ammo_fertilizercan")] = "ammo_fertilizercan",
    [GetHashKey("ammo_emplauncher")] = "ammo_emplauncher",
}

local shotAmmos = {}
local waitingToTrigger = false

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
            Wait(3000)
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
        if IsPedShooting(AVA.Player.playerPed) then
            local weaponHash = GetSelectedPedWeapon(AVA.Player.playerPed)
            local ammoTypeHash = GetPedAmmoTypeFromWeapon(AVA.Player.playerPed, weaponHash)
            local ammoItemName = ammoTypesToItem[ammoTypeHash]
            if ammoItemName and ammoItemName ~= "infinite" then
                shotAmmo(ammoItemName)
            end
        end
    end
end)

RegisterNetEvent("ava_core:client:weaponAdded", function(weaponHash)
    local playerPed = PlayerPedId()
    local ammoTypeHash = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)
    local ammoItemName = ammoTypesToItem[ammoTypeHash]

    if ammoItemName and ammoItemName ~= "infinite" then
        local ammoCount = exports.ava_core:TriggerServerCallback("ava_core:server:getItemQuantity", ammoItemName)
        if ammoCount then
            -- dprint("UPDATE AMMO", weaponHash, ammoItemName, ammoCount)
            SetPedAmmoByType(playerPed, ammoTypeHash, ammoCount)
        end
    end
end)

RegisterNetEvent("ava_core:client:updateAmmoTypeCount", function(ammoTypeHash, ammoCount)
    -- dprint("UPDATE AMMO", ammoTypesToItem[ammoTypeHash] or "NOT_FOUND", ammoCount)
    SetPedAmmoByType(PlayerPedId(), ammoTypeHash, ammoCount)
end)
