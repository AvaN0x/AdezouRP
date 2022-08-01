-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local ammoTypesToItem = {
    [`ammo_grenade`] = "weapon_grenade",
    [`ammo_bzgas`] = "weapon_bzgas",
    [`ammo_molotov`] = "weapon_molotov",
    [`ammo_stickybomb`] = "weapon_stickybomb",
    [`ammo_proxmine`] = "weapon_proxmine",
    [`ammo_snowball`] = "weapon_snowball",
    [`ammo_pipebomb`] = "weapon_pipebomb",
    [`ammo_ball`] = "weapon_ball",
    [`ammo_smokegrenade`] = "weapon_smokegrenade",
    [`ammo_flare`] = "weapon_flare",

    [`ammo_stungun`] = "infinite",
    [`ammo_raypistol`] = "infinite",

    [`ammo_grenadelauncher`] = "ammo_grenadelauncher",
    [`ammo_grenadelauncher_smoke`] = "ammo_grenadelauncher_smoke",
    [`ammo_rpg`] = "ammo_rpg",
    [`ammo_minigun`] = "ammo_minigun",
    [`ammo_fireextinguisher`] = "ammo_fireextinguisher",
    [`ammo_petrolcan`] = "ammo_petrolcan", -- TODO Figure a way to deal with this
    [`ammo_hominglauncher`] = "ammo_hominglauncher",
    [`ammo_rifle`] = "ammo_rifle",
    [`ammo_rifle_tracer`] = "ammo_rifle_tracer",
    [`ammo_rifle_incendiary`] = "ammo_rifle_incendiary",
    [`ammo_rifle_armorpiercing`] = "ammo_rifle_armorpiercing",
    [`ammo_rifle_fmj`] = "ammo_rifle_fmj",
    [`ammo_sniper`] = "ammo_sniper",
    [`ammo_sniper_tracer`] = "ammo_sniper_tracer",
    [`ammo_sniper_incendiary`] = "ammo_sniper_incendiary",
    [`ammo_sniper_armorpiercing`] = "ammo_sniper_armorpiercing",
    [`ammo_sniper_fmj`] = "ammo_sniper_fmj",
    [`ammo_sniper_explosive`] = "ammo_sniper_explosive",
    [`ammo_shotgun`] = "ammo_shotgun",
    [`ammo_shotgun_incendiary`] = "ammo_shotgun_incendiary",
    [`ammo_shotgun_armorpiercing`] = "ammo_shotgun_armorpiercing",
    [`ammo_shotgun_hollowpoint`] = "ammo_shotgun_hollowpoint",
    [`ammo_shotgun_explosive`] = "ammo_shotgun_explosive",
    [`ammo_pistol`] = "ammo_pistol",
    [`ammo_pistol_tracer`] = "ammo_pistol_tracer",
    [`ammo_pistol_incendiary`] = "ammo_pistol_incendiary",
    [`ammo_pistol_hollowpoint`] = "ammo_pistol_hollowpoint",
    [`ammo_pistol_fmj`] = "ammo_pistol_fmj",
    [`ammo_smg`] = "ammo_smg",
    [`ammo_smg_tracer`] = "ammo_smg_tracer",
    [`ammo_smg_incendiary`] = "ammo_smg_incendiary",
    [`ammo_smg_hollowpoint`] = "ammo_smg_hollowpoint",
    [`ammo_smg_fmj`] = "ammo_smg_fmj",
    [`ammo_mg`] = "ammo_mg",
    [`ammo_mg_tracer`] = "ammo_mg_tracer",
    [`ammo_mg_incendiary`] = "ammo_mg_incendiary",
    [`ammo_mg_armorpiercing`] = "ammo_mg_armorpiercing",
    [`ammo_mg_fmj`] = "ammo_mg_fmj",
    [`ammo_flaregun`] = "ammo_flaregun",
    [`ammo_hazardcan`] = "ammo_hazardcan", -- TODO Figure a way to deal with this
    [`ammo_firework`] = "ammo_firework",
    [`ammo_railgun`] = "ammo_railgun",
    [`ammo_fertilizercan`] = "ammo_fertilizercan", -- TODO Figure a way to deal with this
    [`ammo_emplauncher`] = "ammo_emplauncher",
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

RegisterNetEvent("ava_core:client:weaponCheckAmmos", function(weaponHash)
    if IsWeaponValid(weaponHash) then
        local ammoTypeHash <const> = GetPedAmmoTypeFromWeapon(AVA.Player.playerPed, weaponHash)
        local ammoItemName = ammoTypesToItem[ammoTypeHash]

        if ammoItemName and ammoItemName ~= "infinite" then
            local ammoCount = exports.ava_core:TriggerServerCallback("ava_core:server:getItemQuantity", ammoItemName)
            if ammoCount then
                -- dprint("UPDATE AMMO", weaponHash, ammoItemName, ammoCount)
                SetPedAmmoByType(AVA.Player.playerPed, ammoTypeHash, ammoCount)
            end
        end
    end
end)

RegisterNetEvent("ava_core:client:updateAmmoTypeCount", function(ammoTypeHash, ammoCount)
    -- dprint("UPDATE AMMO", ammoTypesToItem[ammoTypeHash] or "NOT_FOUND", ammoCount)
    SetPedAmmoByType(AVA.Player.playerPed, ammoTypeHash, ammoCount)
end)

RegisterNetEvent("ava_core:client:setLoadoutAmmos", function(weapons, ammos)
    -- mandatory wait!
    Wait(100)
    AVA.Player.playerPed = PlayerPedId()
    for i = 1, #weapons do
        if IsWeaponValid(weapons[i]) then
            -- #region Wait for the player to get the weapon
            local tryGetPedWeaponCount = 0
            while not HasPedGotWeapon(AVA.Player.playerPed, weapons[i], false) do
                -- Prevent infinite loop
                if tryGetPedWeaponCount > 50 then
                    break
                end
                tryGetPedWeaponCount = tryGetPedWeaponCount + 1

                Wait(50)
            end
            -- #endregion Wait for the player to get the weapon

            if tryGetPedWeaponCount > 50 then
                dprint("Failed to get ped weapon", weapons[i])
            else
                local ammoTypeHash <const> = GetPedAmmoTypeFromWeapon(AVA.Player.playerPed, weapons[i])
                local ammoItemName = ammoTypesToItem[ammoTypeHash]

                if ammoItemName and ammoItemName ~= "infinite" then
                    local ammoCount = ammos[ammoItemName] or 0
                    if ammoCount then
                        -- dprint("UPDATE AMMO", weapons[i], ammoItemName, ammoCount)
                        SetPedAmmoByType(AVA.Player.playerPed, ammoTypeHash, ammoCount)
                    end
                end
            end
        end
    end
end)
