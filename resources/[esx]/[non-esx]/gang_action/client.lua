local weapons = {
	'WEAPON_KNIFE',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	-- 'WEAPON_SWITCHBLADE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_CARBINERIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_RPG',
	'WEAPON_STINGER',
	'WEAPON_MINIGUN',
	'WEAPON_DIGISCANNER',
	'WEAPON_FIREWORK',
	'WEAPON_MUSKET',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_PROXMINE',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_RAILGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_PIPEBOMB',
	'WEAPON_DOUBLEACTION',
	'WEAPON_STUNGUN',
	'WEAPON_COMBATPISTOL',
	'WEAPON_CERAMICPISTOL',
	-- 'WEAPON_RAYPISTOL',
	'WEAPON_NAVYREVOLVER',
	'WEAPON_RAYCARBINE',
	'WEAPON_RAYMINIGUN',
	'WEAPON_PISTOL_MK2',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_REVOLVER_MK2',
	'WEAPON_SMG_MK2',
	'WEAPON_PUMPSHOTGUN_MK2',
	'WEAPON_ASSAULTRIFLE_MK2',
	'WEAPON_CARBINERIFLE_MK2',
	'WEAPON_SPECIALCARBINE_MK2',
	'WEAPON_BULLPUPRIFLE_MK2',
	'WEAPON_COMBATMG_MK2',
	'WEAPON_HEAVYSNIPER_MK2',
	'WEAPON_MARKSMANRIFLE_MK2'
}

local holstered = true
local canfire = true
local currWeapon = GetHashKey('WEAPON_UNARMED')

local playerPed = nil
local playerPed = nil
local playerPed = nil
local canCheck = nil

Citizen.CreateThread(function()
	while true do
        playerPed = PlayerPedId()
        canCheck = DoesEntityExist( playerPed ) and not IsEntityDead( playerPed ) and not IsPedInAnyVehicle(playerPed, true)
		Wait(500)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if canCheck then
            local newWeap = GetSelectedPedWeapon(playerPed)
			if currWeapon ~= newWeap then
                local inParachute = IsPedInParachuteFreeFall(playerPed) or GetPedParachuteState(playerPed) ~= -1
                if not inParachute then
                    local playerCoords = GetEntityCoords(playerPed, true)
                    local rot = GetEntityHeading(playerPed)

                    SetCurrentPedWeapon(playerPed, currWeapon, true)
                    loadAnimDict( "reaction@intimidation@1h" )

                    if CheckWeapon(newWeap) then
                        if holstered then
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
                        elseif newWeap ~= currWeapon then
                            print(2)
                            canFire = false
                            TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "outro", playerCoords, 0, 0, rot, 8.0, 3.0, -1, 50, 0, 0, 0)
                            Citizen.Wait(1600)
                            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
                            --ClearPedTasks(playerPed)
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
                        if not holstered and CheckWeapon(currWeapon) then
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
                else
                    currWeapon = newWeap
                end
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
	end
end)

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == newWeap then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end
