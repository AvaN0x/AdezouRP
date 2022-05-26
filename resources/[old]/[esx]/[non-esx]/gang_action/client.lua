local weapons = {
	GetHashKey('WEAPON_KNIFE'),
	GetHashKey('WEAPON_HAMMER'),
	GetHashKey('WEAPON_BAT'),
	GetHashKey('WEAPON_GOLFCLUB'),
	GetHashKey('WEAPON_CROWBAR'),
	GetHashKey('WEAPON_BOTTLE'),
	GetHashKey('WEAPON_DAGGER'),
	GetHashKey('WEAPON_HATCHET'),
	GetHashKey('WEAPON_MACHETE'),
	-- GetHashKey('WEAPON_SWITCHBLADE'),
	GetHashKey('WEAPON_BATTLEAXE'),
	GetHashKey('WEAPON_POOLCUE'),
	GetHashKey('WEAPON_WRENCH'),
	GetHashKey('WEAPON_PISTOL'),
	GetHashKey('WEAPON_APPISTOL'),
	GetHashKey('WEAPON_PISTOL50'),
	GetHashKey('WEAPON_REVOLVER'),
	GetHashKey('WEAPON_SNSPISTOL'),
	GetHashKey('WEAPON_HEAVYPISTOL'),
	GetHashKey('WEAPON_VINTAGEPISTOL'),
	GetHashKey('WEAPON_MICROSMG'),
	GetHashKey('WEAPON_SMG'),
	GetHashKey('WEAPON_ASSAULTSMG'),
	GetHashKey('WEAPON_MINISMG'),
	GetHashKey('WEAPON_MACHINEPISTOL'),
	GetHashKey('WEAPON_COMBATPDW'),
	GetHashKey('WEAPON_PUMPSHOTGUN'),
	GetHashKey('WEAPON_SAWNOFFSHOTGUN'),
	GetHashKey('WEAPON_ASSAULTSHOTGUN'),
	GetHashKey('WEAPON_BULLPUPSHOTGUN'),
	GetHashKey('WEAPON_HEAVYSHOTGUN'),
	GetHashKey('WEAPON_ASSAULTRIFLE'),
	GetHashKey('WEAPON_CARBINERIFLE'),
	GetHashKey('WEAPON_ADVANCEDRIFLE'),
	GetHashKey('WEAPON_SPECIALCARBINE'),
	GetHashKey('WEAPON_BULLPUPRIFLE'),
	GetHashKey('WEAPON_COMPACTRIFLE'),
	GetHashKey('WEAPON_MG'),
	GetHashKey('WEAPON_COMBATMG'),
	GetHashKey('WEAPON_GUSENBERG'),
	GetHashKey('WEAPON_SNIPERRIFLE'),
	GetHashKey('WEAPON_HEAVYSNIPER'),
	GetHashKey('WEAPON_MARKSMANRIFLE'),
	GetHashKey('WEAPON_GRENADELAUNCHER'),
	GetHashKey('WEAPON_RPG'),
	GetHashKey('WEAPON_STINGER'),
	GetHashKey('WEAPON_MINIGUN'),
	GetHashKey('WEAPON_DIGISCANNER'),
	GetHashKey('WEAPON_FIREWORK'),
	GetHashKey('WEAPON_MUSKET'),
	GetHashKey('WEAPON_HOMINGLAUNCHER'),
	GetHashKey('WEAPON_PROXMINE'),
	GetHashKey('WEAPON_FLAREGUN'),
	GetHashKey('WEAPON_MARKSMANPISTOL'),
	GetHashKey('WEAPON_RAILGUN'),
	GetHashKey('WEAPON_DBSHOTGUN'),
	GetHashKey('WEAPON_AUTOSHOTGUN'),
	GetHashKey('WEAPON_COMPACTLAUNCHER'),
	GetHashKey('WEAPON_PIPEBOMB'),
	GetHashKey('WEAPON_DOUBLEACTION'),
	GetHashKey('WEAPON_STUNGUN'),
	GetHashKey('WEAPON_COMBATPISTOL'),
	GetHashKey('WEAPON_CERAMICPISTOL'),
	-- GetHashKey('WEAPON_RAYPISTOL'),
	GetHashKey('WEAPON_NAVYREVOLVER'),
	GetHashKey('WEAPON_RAYCARBINE'),
	GetHashKey('WEAPON_RAYMINIGUN'),
	GetHashKey('WEAPON_PISTOL_MK2'),
	GetHashKey('WEAPON_SNSPISTOL_MK2'),
	GetHashKey('WEAPON_REVOLVER_MK2'),
	GetHashKey('WEAPON_SMG_MK2'),
	GetHashKey('WEAPON_PUMPSHOTGUN_MK2'),
	GetHashKey('WEAPON_ASSAULTRIFLE_MK2'),
	GetHashKey('WEAPON_CARBINERIFLE_MK2'),
	GetHashKey('WEAPON_SPECIALCARBINE_MK2'),
	GetHashKey('WEAPON_BULLPUPRIFLE_MK2'),
	GetHashKey('WEAPON_COMBATMG_MK2'),
	GetHashKey('WEAPON_HEAVYSNIPER_MK2'),
	GetHashKey('WEAPON_MARKSMANRIFLE_MK2')
}

local reticleBlackList = {
    GetHashKey('WEAPON_SNIPERRIFLE'),
	GetHashKey('WEAPON_HEAVYSNIPER'),
	GetHashKey('WEAPON_HEAVYSNIPER_MK2')
}

local hideReticle = true

local holstered = true
local canfire = true
local currWeapon = GetHashKey('WEAPON_UNARMED')

local playerPed = nil

Citizen.CreateThread(function()
	while true do
        playerPed = PlayerPedId()
		Wait(1000)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DoesEntityExist( playerPed ) and not IsEntityDead( playerPed ) and not IsPedInAnyVehicle(playerPed, true) and not (IsPedInParachuteFreeFall(playerPed) or GetPedParachuteState(playerPed) ~= -1) then
            local newWeap = GetSelectedPedWeapon(playerPed)
			if currWeapon ~= newWeap then
                local playerCoords = GetEntityCoords(playerPed, true)
                local rot = GetEntityHeading(playerPed)

                SetCurrentPedWeapon(playerPed, currWeapon, true)
                loadAnimDict( "reaction@intimidation@1h" )

                if array_contain_value(weapons, newWeap) then
                    if holstered or currWeapon == GetHashKey('WEAPON_UNARMED')then
                        print(1)
                        canFire = false
                        TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "intro", playerCoords, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                        Citizen.Wait(1000)
                        SetCurrentPedWeapon(playerPed, newWeap, true)
                        currWeapon = newWeap
                        Citizen.Wait(2000)
                        ClearPedTasks(playerPed)
                        holstered = false
                        canFire = true
                    else
                        print(2)
                        canFire = false
                        TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "outro", playerCoords, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                        Citizen.Wait(1600)
                        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
                        --ClearPedTasks(playerPed)

                        playerCoords = GetEntityCoords(playerPed, true) --* this is needed to prevent a rollback effect
                        TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "intro", playerCoords, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                        Citizen.Wait(1000)
                        SetCurrentPedWeapon(playerPed, newWeap, true)
                        currWeapon = newWeap
                        Citizen.Wait(2000)
                        ClearPedTasks(playerPed)
                        holstered = false
                        canFire = true
                    end
                else
                    if not holstered and array_contain_value(weapons, currWeapon) then
                        print(3)
                        canFire = false
                        TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "outro", playerCoords, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                        Citizen.Wait(1600)
                        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
                        ClearPedTasks(playerPed)
                        SetCurrentPedWeapon(playerPed, newWeap, true)
                        holstered = true
                        canFire = true
                        currWeapon = newWeap
                    else
                        print(4)
                        SetCurrentPedWeapon(playerPed, newWeap, true)
                        holstered = false
                        canFire = true
                        currWeapon = newWeap
                    end
                end

                hideReticle = not array_contain_value(reticleBlackList, currWeapon)
                print(hideReticle)
            end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not canFire then
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(playerPed, true)
		end

        if hideReticle then
            HideHudComponentThisFrame(14) -- Reticle
        end
	end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function array_contain_value(array, value)
    if array and value then
        for i = 1, #array, 1 do
            if array[i] == value then
                return true
            end
        end
	end
	return false
end