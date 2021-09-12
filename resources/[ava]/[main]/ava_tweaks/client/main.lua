-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-----------------------------------------
-------- DISABLE VEHICLE WEAPONS --------
-----------------------------------------
local inLoop = false
local playerVehicle = 0

local WeaponsToDisable = {
    -- [GetHashKey("VEHICLE_WEAPON_ROTORS")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TANK")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_SEARCHLIGHT")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_RADAR")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_BULLET")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_LAZER")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_ENEMY_LASER")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_BUZZARD")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_HUNTER")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_PLANE_ROCKET")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_INSURGENT")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_PLAYER_SAVAGE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_TECHNICAL")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_NOSE_TURRET_VALKYRIE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_VALKYRIE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_CANNON_BLAZER")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_BOXVILLE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_RUINER_BULLET")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_RUINER_ROCKET")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_HUNTER_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_HUNTER_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_HUNTER_CANNON")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_HUNTER_BARRAGE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TULA_NOSEMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TULA_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TULA_DUALMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TULA_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_SEABREEZE_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_MICROLIGHT_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_DOGFIGHTER_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_DOGFIGHTER_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_MOGUL_NOSE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_MOGUL_DUALNOSE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_MOGUL_TURRET")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_MOGUL_DUALTURRET")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_ROGUE_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_ROGUE_CANNON")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_ROGUE_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_BOMBUSHKA_DUALMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_BOMBUSHKA_CANNON")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_HAVOK_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_VIGILANTE_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_VIGILANTE_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TURRET_LIMO")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_DUNE_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_DUNE_GRENADELAUNCHER")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_DUNE_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TAMPA_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TAMPA_MORTAR")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TAMPA_FIXEDMINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TAMPA_DUALMINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_HALFTRACK_DUALMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_HALFTRACK_QUADMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_APC_CANNON")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_APC_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_APC_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_ARDENT_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TECHNICAL_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_INSURGENT_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TRAILER_QUADMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TRAILER_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_TRAILER_DUALAA")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_NIGHTSHARK_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_OPPRESSOR_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_OPPRESSOR_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_MOBILEOPS_CANNON")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_AKULA_TURRET_SINGLE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_AKULA_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_AKULA_TURRET_DUAL")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_AKULA_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_AKULA_BARRAGE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_AVENGER_CANNON")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_BARRAGE_TOP_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_BARRAGE_TOP_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_BARRAGE_REAR_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_BARRAGE_REAR_MINIGUN")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_BARRAGE_REAR_GL")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_CHERNO_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_COMET_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_DELUXO_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_DELUXO_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_KHANJALI_CANNON")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_KHANJALI_CANNON_HEAVY")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_KHANJALI_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_KHANJALI_GL")] = true,
    [GetHashKey("VEHICLE_WEAPON_REVOLTER_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_SAVESTRA_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_SUBCAR_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_SUBCAR_MISSILE")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_SUBCAR_TORPEDO")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_THRUSTER_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_THRUSTER_MISSILE")] = true,
    [GetHashKey("VEHICLE_WEAPON_VISERIS_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_VOLATOL_DUALMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_WATER_CANNON")] = true,
    -- [1422046295] = true, -- water cannon
    [749486726] = true, -- paragon2 MG
}

local function Loop(value, vehicle)
    -- change come values to make the actual or next loop work
    if value then
        playerVehicle = vehicle
    end

    if value and inLoop then
        return
    end
    inLoop = value

    if inLoop then
        Citizen.CreateThread(function()
            while inLoop do
                if playerVehicle ~= 0 then
                    local playerPed = PlayerPedId()
                    local vehicle = playerVehicle

                    if AVAConfig.DisableVehicleJump then
                        DisableControlAction(0, 350, true)
                    end
                    if AVAConfig.DisableVehicleRocketBoost then
                        DisableControlAction(0, 351, true)
                    end
                    if AVAConfig.DisableBikeWings then
                        DisableControlAction(0, 354, true)
                    end
                    if AVAConfig.DisableVehicleTransform then
                        DisableControlAction(0, 357, true)
                    end

                    if AVAConfig.DisableVehicleWeapons and DoesVehicleHaveWeapons(vehicle) then
                        local hasWeapon, vehWeaponHash = GetCurrentPedVehicleWeapon(playerPed)
                        if hasWeapon and WeaponsToDisable[vehWeaponHash] then
                            DisableVehicleWeapon(true, vehWeaponHash, vehicle, playerPed)
                            SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"))
                        end
                    end
                end
                Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if isInVehicle then
        Loop(true, vehicle)
    end
end)

AddEventHandler("ava_core:client:enteredVehicle", function(vehicle)
    Loop(true, vehicle)
end)
AddEventHandler("ava_core:client:leftVehicle", function(vehicle)
    playerVehicle = 0
    Loop(false)
end)

RegisterNetEvent("ava_tweaks:client:vehweaphash", function()
    local hasWeapon, vehWeaponHash = GetCurrentPedVehicleWeapon(PlayerPedId())
    local text

    if hasWeapon then
        text = GetString("vehweaphash_print", vehWeaponHash)
        exports.ava_hud:copyToClipboard(vehWeaponHash)
    else
        text = GetString("vehweaphash_print_no_weap")
    end

    print(text)
    TriggerEvent("chat:addMessage", {args = {text}})
end)
