-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local island = vector3(4858.0, -5171.0, 2.0)
local isIslandLoaded = nil
local isInIsland = nil

-- ? source : islandhopper.meta
local ipls = {
    mains = {
        "H4_islandx_terrain_01",
        "H4_islandx_terrain_02",
        "H4_islandx_terrain_03",
        "H4_islandx_terrain_04",
        "H4_islandx_terrain_05",
        "H4_islandx_terrain_06"
    },
    neededWhileClose = {
        "h4_islandairstrip",
        "h4_islandairstrip_props",
        "h4_islandx_mansion",
        "h4_islandx_mansion_props",
        "h4_islandx_props",
        "h4_islandxdock",
        "h4_islandxdock_props",
        "h4_islandxdock_props_2",
        "h4_islandxtower",
        "h4_islandx_maindock",
        "h4_islandx_maindock_props",
        "h4_islandx_maindock_props_2",
        "h4_IslandX_Mansion_Vault",
        "h4_islandairstrip_propsb",
        "h4_beach",
        "h4_beach_props",
        "h4_beach_bar_props",
        "h4_islandx_barrack_props",
        "h4_islandx_checkpoint",
        "h4_islandx_checkpoint_props",
        "h4_islandx_Mansion_Office",
        "h4_islandx_Mansion_LockUp_01",
        "h4_islandx_Mansion_LockUp_02",
        "h4_islandx_Mansion_LockUp_03",
        "h4_islandairstrip_hangar_props",
        "h4_IslandX_Mansion_B",
        "h4_islandairstrip_doorsclosed",
        "h4_Underwater_Gate_Closed",
        "h4_mansion_gate_closed",
        "h4_aa_guns",
        "h4_IslandX_Mansion_GuardFence",
        "h4_IslandX_Mansion_Entrance_Fence",
        "h4_IslandX_Mansion_B_Side_Fence",
        "h4_IslandX_Mansion_Lights",
        "h4_islandxcanal_props",
        "h4_beach_props_party",
        "h4_ne_ipl_00",
        "h4_ne_ipl_01",
        "h4_ne_ipl_02",
        "h4_ne_ipl_03",
        "h4_ne_ipl_04",
        "h4_ne_ipl_05",
        "h4_ne_ipl_06",
        "h4_ne_ipl_07",
        "h4_ne_ipl_08",
        "h4_ne_ipl_09",
        "h4_nw_ipl_00",
        "h4_nw_ipl_01",
        "h4_nw_ipl_02",
        "h4_nw_ipl_03",
        "h4_nw_ipl_04",
        "h4_nw_ipl_05",
        "h4_nw_ipl_06",
        "h4_nw_ipl_07",
        "h4_nw_ipl_08",
        "h4_nw_ipl_09",
        "h4_se_ipl_00",
        "h4_se_ipl_01",
        "h4_se_ipl_02",
        "h4_se_ipl_03",
        "h4_se_ipl_04",
        "h4_se_ipl_05",
        "h4_se_ipl_06",
        "h4_se_ipl_07",
        "h4_se_ipl_08",
        "h4_se_ipl_09",
        "h4_sw_ipl_00",
        "h4_sw_ipl_01",
        "h4_sw_ipl_02",
        "h4_sw_ipl_03",
        "h4_sw_ipl_04",
        "h4_sw_ipl_05",
        "h4_sw_ipl_06",
        "h4_sw_ipl_07",
        "h4_sw_ipl_08",
        "h4_sw_ipl_09",
        "h4_islandx_mansion",
        "h4_islandxtower_veg",
        "h4_islandx_sea_mines",
        "h4_islandx",
        "h4_islandx_barrack_hatch",
        "h4_islandxdock_water_hatch",
        "h4_beach_party",
        "h4_mph4_terrain_01_grass_0",
        "h4_mph4_terrain_01_grass_1",
        "h4_mph4_terrain_02_grass_0",
        "h4_mph4_terrain_02_grass_1",
        "h4_mph4_terrain_02_grass_2",
        "h4_mph4_terrain_02_grass_3",
        "h4_mph4_terrain_04_grass_0",
        "h4_mph4_terrain_04_grass_1",
        "h4_mph4_terrain_04_grass_2",
        "h4_mph4_terrain_04_grass_3",
        "h4_mph4_terrain_05_grass_0",
        "h4_mph4_terrain_06_grass_0"
    }
}

Citizen.CreateThread(function()
    for k, v in ipairs(ipls.mains) do
        RequestIpl(v)
    end
    while true do
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        isInIsland = #(playerCoords - island) < 2200.0

        if isIslandLoaded ~= isInIsland then
            print((isInIsland and "Load" or "Unload") .. " Cayo Perico.")
            isIslandLoaded = isInIsland

            -- switch island (will disable Los Santos)
            -- Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', isIslandLoaded) -- or use false to disable it
            SetDeepOceanScaler(isIslandLoaded and 0.0 or 1.0)

            -- switch radar interior
            Citizen.InvokeNative(0x5E1460624D194A38, isIslandLoaded)

            -- misc natives
            Citizen.InvokeNative(0xF74B1FFA4A15FBEA, isIslandLoaded)
            Citizen.InvokeNative(0x53797676AD34A9AA, not isIslandLoaded)
            SetScenarioGroupEnabled('Heist_Island_Peds', isIslandLoaded)

            -- audio stuff
            SetAudioFlag('PlayerOnDLCHeist4Island', isIslandLoaded)
            SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', isIslandLoaded, true)
            SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', not isIslandLoaded, true)

            -- load the terrain of the island / los santos
            Citizen.Wait(1000)
            if isIslandLoaded then
                for k, v in ipairs(ipls.neededWhileClose) do
                    RequestIpl(v)
                end
            else
                for k, v in ipairs(ipls.neededWhileClose) do
                    RemoveIpl(v)
                end
            end

        end

        Citizen.Wait(5000)
    end
end)
