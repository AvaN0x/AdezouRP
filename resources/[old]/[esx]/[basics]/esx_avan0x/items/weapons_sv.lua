-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local weapons = {
    "weapon_advancedrifle",
    "weapon_appistol",
    "weapon_assaultrifle",
    "weapon_assaultrifle_mk2",
    "weapon_assaultshotgun",
    "weapon_assaultsmg",
    "weapon_autoshotgun",
    "weapon_bat",
    "weapon_battleaxe",
    "weapon_bottle",
    "weapon_bullpuprifle",
    "weapon_bullpuprifle_mk2",
    "weapon_bullpupshotgun",
    "weapon_carbinerifle",
    "weapon_carbinerifle_mk2",
    "weapon_combatmg",
    "weapon_combatmg_mk2",
    "weapon_combatpdw",
    "weapon_combatpistol",
    "weapon_compactlauncher",
    "weapon_compactrifle",
    "weapon_crowbar",
    "weapon_dagger",
    "weapon_dbshotgun",
    "weapon_doubleaction",
    "weapon_fireextinguisher",
    "weapon_firework",
    "weapon_flare",
    "weapon_flaregun",
    "weapon_flashlight",
    "weapon_golfclub",
    "weapon_grenade",
    "weapon_grenadelauncher",
    "weapon_gusenberg",
    "weapon_hammer",
    "weapon_hatchet",
    "weapon_heavypistol",
    "weapon_heavyshotgun",
    "weapon_heavysniper",
    "weapon_heavysniper_mk2",
    "weapon_hominglauncher",
    "weapon_knife",
    "weapon_knuckle",
    "weapon_machete",
    "weapon_machinepistol",
    "weapon_marksmanpistol",
    "weapon_marksmanrifle",
    "weapon_marksmanrifle_mk2",
    "weapon_microsmg",
    "weapon_minigun",
    "weapon_minismg",
    "weapon_musket",
    "weapon_nightstick",
    "gadget_parachute",
    "weapon_petrolcan",
    "weapon_pistol50",
    "weapon_pistol",
    "weapon_pistol_mk2",
    "weapon_poolcue",
    "weapon_pumpshotgun",
    "weapon_pumpshotgun_mk2",
    "weapon_railgun",
    "weapon_revolver",
    "weapon_revolver_mk2",
    "weapon_rpg",
    "weapon_sawnoffshotgun",
    "weapon_smg",
    "weapon_smg_mk2",
    "weapon_sniperrifle",
    "weapon_snspistol",
    "weapon_snspistol_mk2",
    "weapon_specialcarbine",
    "weapon_specialcarbine_mk2",
    "weapon_stickybomb",
    "weapon_stungun",
    "weapon_switchblade",
    "weapon_vintagepistol",
    "weapon_wrench",
    "weapon_hazardcan",
    "weapon_ceramicpistol",
    "weapon_raypistol",
    "weapon_navyrevolver",
    "weapon_raycarbine",
    "weapon_rayminigun",
    "weapon_gadgetpistol",
    "weapon_combatshotgun",
    "weapon_militaryrifle",
}

local projectiles = {
    "weapon_ball",
    "weapon_bzgas",
    "weapon_molotov",
    "weapon_pipebomb",
    "weapon_proxmine",
    "weapon_smokegrenade",
    "weapon_snowball",
}

RegisterServerEvent("esx_avan0x:giveWeapon")
AddEventHandler('esx_avan0x:giveWeapon', function(weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(weaponName, 1)
	xPlayer.addWeapon(weaponName, 0)
end)

RegisterServerEvent("esx_avan0x:giveProjectile")
AddEventHandler('esx_avan0x:giveProjectile', function(source, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(weaponName, 1)
	xPlayer.addWeapon(weaponName, 1)
end)

for k, weaponName in ipairs(weapons) do
    ESX.RegisterUsableItem(weaponName, function(source)
        TriggerClientEvent("esx_avan0x:checkGiveWeapon", source, weaponName)
    end)
end

for k, weaponName in ipairs(projectiles) do
    ESX.RegisterUsableItem(weaponName, function(source)
        TriggerEvent("esx_avan0x:giveProjectile", source, weaponName)
    end)
end

local expectedToRequestClips = {}

RegisterServerEvent('esx_avan0x:useWeaponItem')
AddEventHandler('esx_avan0x:useWeaponItem', function(weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

	if inventory.getItem(string.lower(weaponName)) then
        if xPlayer.hasWeapon(weaponName) then
            if not inventory.canAddItem(string.lower(weaponName), 1) then
                TriggerClientEvent('esx:showNotification', source, "Vous n'avez plus de place pour cela")
            else
                expectedToRequestClips[xPlayer.identifier] = weaponName
                TriggerClientEvent('esx_avan0x:checkIfClipsNeededBeforeRemove', source, weaponName)
                inventory.addItem(string.lower(weaponName), 1)
                xPlayer.removeWeapon(weaponName)
            end
        else
            TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas faire cela")
        end
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas faire cela")
		SendWebhookMessage("L'arme `" .. weaponName .. "` n'est pas un item")
	end
end)

RegisterServerEvent('esx_avan0x:requestClipsAndRemove')
AddEventHandler('esx_avan0x:requestClipsAndRemove', function(weaponName, clipCount)
	local xPlayer = ESX.GetPlayerFromId(source)

    if expectedToRequestClips[xPlayer.identifier] then
        local inventory = xPlayer.getInventory()
        if expectedToRequestClips[xPlayer.identifier] == weaponName then
            if clipCount <= 10 then
                local clipCanTake = inventory.canTake("clip")
                if clipCanTake > 0 then
                    inventory.addItem("clip", (clipCanTake > clipCount and clipCount or clipCanTake))
                end
            else
                print(('%s attempted to exploit useWeaponItem!'):format(GetPlayerIdentifiers(source)[1]))
            end
        end
        expectedToRequestClips[xPlayer.identifier] = nil
    else
        print(('%s attempted to exploit useWeaponItem!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

-----------
-- Clips --
-----------
RegisterServerEvent("esx_avan0x:removeClip")
AddEventHandler("esx_avan0x:removeClip", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("clip", 1)
end)

ESX.RegisterUsableItem("clip", function(source)
	TriggerClientEvent("esx_avan0x:useClip", source)
end)

RegisterServerEvent('esx_avan0x:checkClip')
AddEventHandler('esx_avan0x:checkClip', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    if inventory.getItem('clip').count > 0 then
        TriggerClientEvent('esx_avan0x:useClip', source)
    else
        TriggerClientEvent('esx_avan0x:useClip', source, true)
    end
end)

-- ESX.RegisterUsableItem("clip", function(source)
-- 	TriggerClientEvent("esx_avan0x:useClip", source, true)
-- end)

-- RegisterServerEvent('esx_avan0x:checkClip')
-- AddEventHandler('esx_avan0x:checkClip', function(weaponHash)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     local inventory = xPlayer.getInventory()

--     if inventory.getItem('clip').count > 0 then
--         TriggerClientEvent('esx_avan0x:useClip', source, true, weaponHash)
--     else
--         TriggerClientEvent('esx_avan0x:useClip', source, false, weaponHash)
--     end
-- end)
