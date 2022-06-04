-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-----------------------------------------
-------- DISABLE VEHICLE WEAPONS --------
-----------------------------------------
local inLoop = false
local playerVehicle = 0
local disableAirControl = false

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
    [GetHashKey("VEHICLE_WEAPON_CANNON_BLAZER")] = true,
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
    [GetHashKey("VEHICLE_WEAPON_SUBCAR_MG")] = true, -- stromberg && toreador
    [GetHashKey("VEHICLE_WEAPON_SUBCAR_MISSILE")] = true, -- stromberg && toreador
    [GetHashKey("VEHICLE_WEAPON_SUBCAR_TORPEDO")] = true, -- stromberg && toreador
    -- [GetHashKey("VEHICLE_WEAPON_THRUSTER_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_THRUSTER_MISSILE")] = true,
    [GetHashKey("VEHICLE_WEAPON_VISERIS_MG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_VOLATOL_DUALMG")] = true,
    -- [GetHashKey("VEHICLE_WEAPON_WATER_CANNON")] = true,
    -- [1422046295] = true, -- water cannon
    [749486726] = true, -- paragon2 MG
    [231629074] = true, -- scramjet MG
    [-1125578533] = true, -- scramjet ROCKET
    [GetHashKey("VEHICLE_WEAPON_GRANGER2_MG")] = true, -- contract vehicles
}

local vehicleClassDisableAirControl = {
    [0] = true, -- compacts
    [1] = true, -- sedans
    [2] = true, -- SUV's
    [3] = true, -- coupes
    [4] = true, -- muscle
    [5] = true, -- sport classic
    [6] = true, -- sport
    [7] = true, -- super
    [8] = false, -- motorcycle
    [9] = true, -- offroad
    [10] = true, -- industrial
    [11] = true, -- utility
    [12] = true, -- vans
    [13] = false, -- bicycles
    [14] = false, -- boats
    [15] = false, -- helicopter
    [16] = false, -- plane
    [17] = true, -- service
    [18] = true, -- emergency
    [19] = false, -- military
}

local function Loop(value, vehicle, seat)
    -- change come values to make the actual or next loop work
    if value then
        playerVehicle = vehicle
        disableAirControl = AVAConfig.DisableAirControl and vehicleClassDisableAirControl[GetVehicleClass(vehicle)]
    end

    -- Try to enable loop but already in loop
    if value and inLoop then return end

    inLoop = value

    -- Not in loop, no need to go further
    if not inLoop then return end

    Citizen.CreateThread(function()
        while inLoop and playerVehicle ~= 0 do
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
                local playerPed = PlayerPedId()
                local hasWeapon, vehWeaponHash = GetCurrentPedVehicleWeapon(playerPed)
                if hasWeapon and WeaponsToDisable[vehWeaponHash] then
                    DisableVehicleWeapon(true, vehWeaponHash, vehicle, playerPed)
                    SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"))
                end
            end

            if disableAirControl and IsEntityInAir(vehicle) then
                DisableControlAction(0, 59) -- INPUT_VEH_MOVE_LR
                DisableControlAction(0, 60) -- INPUT_VEH_MOVE_UD
            end
            Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if isInVehicle then
        Loop(true, vehicle, seat)
    end
end)

AddEventHandler("ava_core:client:enteredVehicle", function(vehicle, seat)
    Loop(true, vehicle, seat)

    if AVAConfig.DisableVehicleKers then
        SetVehicleKersAllowed(vehicle, false)
    end

    -- * try to stop vehicle from despawning
    if not IsEntityAMissionEntity(vehicle) then
        SetEntityAsMissionEntity(vehicle)
    end

    if AVAConfig.DisableBikeHelmet then
        SetPedConfigFlag(PlayerPedId(), 35, false) -- CPED_CONFIG_FLAG_UseHelmet 
    end
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
    TriggerEvent("chat:addMessage", { args = { text } })
end)

---------------------------------------
-------- REMOVE STATIC EMITTERS --------
---------------------------------------
Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(0)
    end

    print("session started")
    -- Remove unicorn ambiant sound
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE", false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM", false)
    SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", false)

    -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_01", false)
    -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_02", false)
    -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_03", false)
    -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_04", false)
    -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_05", false)
    -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_01", false)
    -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_02", false)
    -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_Takeover", false)

    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_01", false)
    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_02", false)

    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_01", true)
    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_02", true)
    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_01_B", true)
    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_02_B", true)
    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_music_01", true)
    SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_music_02", true)

    -- SetStaticEmitterEnabled("DLC_Tuner_Car_Meet_Test_Area_Sounds", false)
    -- SetStaticEmitterEnabled("DLC_Tuner_Car_Meet_Scripted_Sounds", false)

    SetAmbientZoneState("AZ_tr_tuner_car_meet_Meet_BG", false, true)
    SetAmbientZoneState("AZ_tr_tuner_car_meet_Meet_BG_2", false, true)

    -- Downtown ammunation
    SetStaticEmitterEnabled("LOS_SANTOS_AMMUNATION_GUN_RANGE", false)
    SetStaticEmitterEnabled("SE_AMMUNATION_CYPRESS_FLATS_GUN_RANGE", false)
end)

------------------------------------
-------- Animation keybinds --------
------------------------------------
local onHandsup = false
RegisterCommand("handsup", function()
    onHandsup = not onHandsup
    ExecuteCommand(onHandsup and "e handsup" or "e c")
end)

RegisterKeyMapping("handsup", GetString("handsup_help"), "keyboard", "M")

if AVAConfig.ClearMissionrowPD then
    local missionrowPDCoords = vector3(470.00, -990.00, 25.0)
    Citizen.CreateThread(function()
        while true do
            Wait((#(GetEntityCoords(PlayerPedId()) - missionrowPDCoords) < 150) and 0 or 1000)
            ClearAreaOfPeds(missionrowPDCoords.x, missionrowPDCoords.y, missionrowPDCoords.z, 80.0, 1)

            ClearAreaOfVehicles(missionrowPDCoords.x, missionrowPDCoords.y, missionrowPDCoords.z, 300, false, false, false, false, false)
            RemoveVehiclesFromGeneratorsInArea(missionrowPDCoords.x - 90.0, missionrowPDCoords.y - 90.0, missionrowPDCoords.z - 90.0,
                missionrowPDCoords.x + 90.0, missionrowPDCoords.y + 90.0, missionrowPDCoords.z + 90.0)
        end
    end)
end
