-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local island = vector3(4858.0, -5171.0, 2.0)
local isCayoLoaded = nil
local isCayoMinimapLoaded = nil

-- ? source : islandhopper.meta
local ipls = {
    mains = {
        "h4_islandx_terrain_01",
        "h4_islandx_terrain_01_lod",
        "h4_islandx_terrain_01_slod",
        "h4_islandx_terrain_02",
        "h4_islandx_terrain_02_lod",
        "h4_islandx_terrain_02_slod",
        "h4_islandx_terrain_03",
        "h4_islandx_terrain_03_lod",
        "h4_islandx_terrain_04",
        "h4_islandx_terrain_04_lod",
        "h4_islandx_terrain_04_slod",
        "h4_islandx_terrain_05",
        "h4_islandx_terrain_05_lod",
        "h4_islandx_terrain_05_slod",
        "h4_islandx_terrain_06",
        "h4_islandx_terrain_06_lod",
        "h4_islandx_terrain_06_slod",
    },
    neededWhileClose = {
        "h4_mph4_terrain_01_grass_0",
        "h4_mph4_terrain_01_grass_1",
        "h4_mph4_terrain_02_grass_0",
        "h4_mph4_terrain_02_grass_1",
        "h4_mph4_terrain_02_grass_2",
        "h4_mph4_terrain_02_grass_3",
        "h4_mph4_terrain_04_grass_0",
        "h4_mph4_terrain_04_grass_1",
        "h4_mph4_terrain_05_grass_0",
        "h4_mph4_terrain_06_grass_0",
        -- "h4_islandx_terrain_01",
        -- "h4_islandx_terrain_01_lod",
        -- "h4_islandx_terrain_01_slod",
        -- "h4_islandx_terrain_02",
        -- "h4_islandx_terrain_02_lod",
        -- "h4_islandx_terrain_02_slod",
        -- "h4_islandx_terrain_03",
        -- "h4_islandx_terrain_03_lod",
        -- "h4_islandx_terrain_04",
        -- "h4_islandx_terrain_04_lod",
        -- "h4_islandx_terrain_04_slod",
        -- "h4_islandx_terrain_05",
        -- "h4_islandx_terrain_05_lod",
        -- "h4_islandx_terrain_05_slod",
        -- "h4_islandx_terrain_06",
        -- "h4_islandx_terrain_06_lod",
        -- "h4_islandx_terrain_06_slod",
        "h4_islandx_terrain_props_05_a",
        "h4_islandx_terrain_props_05_a_lod",
        "h4_islandx_terrain_props_05_b",
        "h4_islandx_terrain_props_05_b_lod",
        "h4_islandx_terrain_props_05_c",
        "h4_islandx_terrain_props_05_c_lod",
        "h4_islandx_terrain_props_05_d",
        "h4_islandx_terrain_props_05_d_lod",
        "h4_islandx_terrain_props_05_d_slod",
        "h4_islandx_terrain_props_05_e",
        "h4_islandx_terrain_props_05_e_lod",
        "h4_islandx_terrain_props_05_e_slod",
        "h4_islandx_terrain_props_05_f",
        "h4_islandx_terrain_props_05_f_lod",
        "h4_islandx_terrain_props_05_f_slod",
        "h4_islandx_terrain_props_06_a",
        "h4_islandx_terrain_props_06_a_lod",
        "h4_islandx_terrain_props_06_a_slod",
        "h4_islandx_terrain_props_06_b",
        "h4_islandx_terrain_props_06_b_lod",
        "h4_islandx_terrain_props_06_b_slod",
        "h4_islandx_terrain_props_06_c",
        "h4_islandx_terrain_props_06_c_lod",
        "h4_islandx_terrain_props_06_c_slod",
        "h4_mph4_terrain_01",
        "h4_mph4_terrain_01_long_0",
        "h4_mph4_terrain_02",
        "h4_mph4_terrain_03",
        "h4_mph4_terrain_04",
        "h4_mph4_terrain_05",
        "h4_mph4_terrain_06",
        "h4_mph4_terrain_06_strm_0",
        "h4_mph4_terrain_lod",
        "h4_mph4_terrain_occ_00",
        "h4_mph4_terrain_occ_01",
        "h4_mph4_terrain_occ_02",
        "h4_mph4_terrain_occ_03",
        "h4_mph4_terrain_occ_04",
        "h4_mph4_terrain_occ_05",
        "h4_mph4_terrain_occ_06",
        "h4_mph4_terrain_occ_07",
        "h4_mph4_terrain_occ_08",
        "h4_mph4_terrain_occ_09",
        -- "h4_boatblockers",
        "h4_islandx",
        "h4_islandx_disc_strandedshark",
        "h4_islandx_disc_strandedshark_lod",
        "h4_islandx_disc_strandedwhale",
        "h4_islandx_disc_strandedwhale_lod",
        "h4_islandx_props",
        "h4_islandx_props_lod",
        -- "h4_islandx_sea_mines",
        "h4_mph4_island",
        "h4_mph4_island_long_0",
        "h4_mph4_island_strm_0",
        "h4_aa_guns",
        "h4_aa_guns_lod",
        "h4_beach",
        "h4_beach_bar_props",
        "h4_beach_lod",
        "h4_beach_party",
        "h4_beach_party_lod",
        "h4_beach_props",
        "h4_beach_props_lod",
        "h4_beach_props_party",
        "h4_beach_props_slod",
        "h4_beach_slod",
        "h4_islandairstrip",
        "h4_islandairstrip_doorsclosed",
        "h4_islandairstrip_doorsclosed_lod",
        "h4_islandairstrip_doorsopen",
        "h4_islandairstrip_doorsopen_lod",
        "h4_islandairstrip_hangar_props",
        "h4_islandairstrip_hangar_props_lod",
        "h4_islandairstrip_hangar_props_slod",
        "h4_islandairstrip_lod",
        "h4_islandairstrip_props",
        "h4_islandairstrip_propsb",
        "h4_islandairstrip_propsb_lod",
        "h4_islandairstrip_propsb_slod",
        "h4_islandairstrip_props_lod",
        "h4_islandairstrip_props_slod",
        "h4_islandairstrip_slod",
        "h4_islandxcanal_props",
        "h4_islandxcanal_props_lod",
        "h4_islandxcanal_props_slod",
        "h4_islandxdock",
        "h4_islandxdock_lod",
        "h4_islandxdock_props",
        "h4_islandxdock_props_2",
        "h4_islandxdock_props_2_lod",
        "h4_islandxdock_props_2_slod",
        "h4_islandxdock_props_lod",
        "h4_islandxdock_props_slod",
        "h4_islandxdock_slod",
        "h4_islandxdock_water_hatch",
        "h4_islandxtower",
        "h4_islandxtower_lod",
        "h4_islandxtower_slod",
        "h4_islandxtower_veg",
        "h4_islandxtower_veg_lod",
        "h4_islandxtower_veg_slod",
        "h4_islandx_barrack_hatch",
        "h4_islandx_barrack_props",
        "h4_islandx_barrack_props_lod",
        "h4_islandx_barrack_props_slod",
        "h4_islandx_checkpoint",
        "h4_islandx_checkpoint_lod",
        "h4_islandx_checkpoint_props",
        "h4_islandx_checkpoint_props_lod",
        "h4_islandx_checkpoint_props_slod",
        "h4_islandx_maindock",
        "h4_islandx_maindock_lod",
        "h4_islandx_maindock_props",
        "h4_islandx_maindock_props_2",
        "h4_islandx_maindock_props_2_lod",
        "h4_islandx_maindock_props_2_slod",
        "h4_islandx_maindock_props_lod",
        "h4_islandx_maindock_props_slod",
        "h4_islandx_maindock_slod",
        "h4_islandx_mansion",
        "h4_islandx_mansion_b",
        "h4_islandx_mansion_b_lod",
        "h4_islandx_mansion_b_side_fence",
        "h4_islandx_mansion_b_slod",
        "h4_islandx_mansion_entrance_fence",
        "h4_islandx_mansion_guardfence",
        "h4_islandx_mansion_lights",
        "h4_islandx_mansion_lockup_01",
        "h4_islandx_mansion_lockup_01_lod",
        "h4_islandx_mansion_lockup_02",
        "h4_islandx_mansion_lockup_02_lod",
        "h4_islandx_mansion_lockup_03",
        "h4_islandx_mansion_lockup_03_lod",
        "h4_islandx_mansion_lod",
        "h4_islandx_mansion_office",
        "h4_islandx_mansion_office_lod",
        "h4_islandx_mansion_props",
        "h4_islandx_mansion_props_lod",
        "h4_islandx_mansion_props_slod",
        "h4_islandx_mansion_slod",
        "h4_islandx_mansion_vault",
        "h4_islandx_mansion_vault_lod",
        "h4_island_padlock_props",
        -- "h4_mansion_gate_broken",
        "h4_mansion_gate_closed",
        "h4_mansion_remains_cage",
        "h4_mph4_airstrip",
        "h4_mph4_airstrip_interior_0_airstrip_hanger",
        "h4_mph4_beach",
        "h4_mph4_dock",
        "h4_mph4_island_lod",
        "h4_mph4_island_ne_placement",
        "h4_mph4_island_nw_placement",
        "h4_mph4_island_se_placement",
        "h4_mph4_island_sw_placement",
        "h4_mph4_mansion",
        "h4_mph4_mansion_b",
        "h4_mph4_mansion_b_strm_0",
        "h4_mph4_mansion_strm_0",
        "h4_mph4_wtowers",
        "h4_ne_ipl_00",
        "h4_ne_ipl_00_lod",
        "h4_ne_ipl_00_slod",
        "h4_ne_ipl_01",
        "h4_ne_ipl_01_lod",
        "h4_ne_ipl_01_slod",
        "h4_ne_ipl_02",
        "h4_ne_ipl_02_lod",
        "h4_ne_ipl_02_slod",
        "h4_ne_ipl_03",
        "h4_ne_ipl_03_lod",
        "h4_ne_ipl_03_slod",
        "h4_ne_ipl_04",
        "h4_ne_ipl_04_lod",
        "h4_ne_ipl_04_slod",
        "h4_ne_ipl_05",
        "h4_ne_ipl_05_lod",
        "h4_ne_ipl_05_slod",
        "h4_ne_ipl_06",
        "h4_ne_ipl_06_lod",
        "h4_ne_ipl_06_slod",
        "h4_ne_ipl_07",
        "h4_ne_ipl_07_lod",
        "h4_ne_ipl_07_slod",
        "h4_ne_ipl_08",
        "h4_ne_ipl_08_lod",
        "h4_ne_ipl_08_slod",
        "h4_ne_ipl_09",
        "h4_ne_ipl_09_lod",
        "h4_ne_ipl_09_slod",
        "h4_nw_ipl_00",
        "h4_nw_ipl_00_lod",
        "h4_nw_ipl_00_slod",
        "h4_nw_ipl_01",
        "h4_nw_ipl_01_lod",
        "h4_nw_ipl_01_slod",
        "h4_nw_ipl_02",
        "h4_nw_ipl_02_lod",
        "h4_nw_ipl_02_slod",
        "h4_nw_ipl_03",
        "h4_nw_ipl_03_lod",
        "h4_nw_ipl_03_slod",
        "h4_nw_ipl_04",
        "h4_nw_ipl_04_lod",
        "h4_nw_ipl_04_slod",
        "h4_nw_ipl_05",
        "h4_nw_ipl_05_lod",
        "h4_nw_ipl_05_slod",
        "h4_nw_ipl_06",
        "h4_nw_ipl_06_lod",
        "h4_nw_ipl_06_slod",
        "h4_nw_ipl_07",
        "h4_nw_ipl_07_lod",
        "h4_nw_ipl_07_slod",
        "h4_nw_ipl_08",
        "h4_nw_ipl_08_lod",
        "h4_nw_ipl_08_slod",
        "h4_nw_ipl_09",
        "h4_nw_ipl_09_lod",
        "h4_nw_ipl_09_slod",
        "h4_se_ipl_00",
        "h4_se_ipl_00_lod",
        "h4_se_ipl_00_slod",
        "h4_se_ipl_01",
        "h4_se_ipl_01_lod",
        "h4_se_ipl_01_slod",
        "h4_se_ipl_02",
        "h4_se_ipl_02_lod",
        "h4_se_ipl_02_slod",
        "h4_se_ipl_03",
        "h4_se_ipl_03_lod",
        "h4_se_ipl_03_slod",
        "h4_se_ipl_04",
        "h4_se_ipl_04_lod",
        "h4_se_ipl_04_slod",
        "h4_se_ipl_05",
        "h4_se_ipl_05_lod",
        "h4_se_ipl_05_slod",
        "h4_se_ipl_06",
        "h4_se_ipl_06_lod",
        "h4_se_ipl_06_slod",
        "h4_se_ipl_07",
        "h4_se_ipl_07_lod",
        "h4_se_ipl_07_slod",
        "h4_se_ipl_08",
        "h4_se_ipl_08_lod",
        "h4_se_ipl_08_slod",
        "h4_se_ipl_09",
        "h4_se_ipl_09_lod",
        "h4_se_ipl_09_slod",
        "h4_sw_ipl_00",
        "h4_sw_ipl_00_lod",
        "h4_sw_ipl_00_slod",
        "h4_sw_ipl_01",
        "h4_sw_ipl_01_lod",
        "h4_sw_ipl_01_slod",
        "h4_sw_ipl_02",
        "h4_sw_ipl_02_lod",
        "h4_sw_ipl_02_slod",
        "h4_sw_ipl_03",
        "h4_sw_ipl_03_lod",
        "h4_sw_ipl_03_slod",
        "h4_sw_ipl_04",
        "h4_sw_ipl_04_lod",
        "h4_sw_ipl_04_slod",
        "h4_sw_ipl_05",
        "h4_sw_ipl_05_lod",
        "h4_sw_ipl_05_slod",
        "h4_sw_ipl_06",
        "h4_sw_ipl_06_lod",
        "h4_sw_ipl_06_slod",
        "h4_sw_ipl_07",
        "h4_sw_ipl_07_lod",
        "h4_sw_ipl_07_slod",
        "h4_sw_ipl_08",
        "h4_sw_ipl_08_lod",
        "h4_sw_ipl_08_slod",
        "h4_sw_ipl_09",
        "h4_sw_ipl_09_lod",
        "h4_sw_ipl_09_slod",
        "h4_underwater_gate_closed",
        "h4_islandx_placement_01",
        "h4_islandx_placement_02",
        "h4_islandx_placement_03",
        "h4_islandx_placement_04",
        "h4_islandx_placement_05",
        "h4_islandx_placement_06",
        "h4_islandx_placement_07",
        "h4_islandx_placement_08",
        "h4_islandx_placement_09",
        "h4_islandx_placement_10",
        "h4_mph4_island_placement",
    },
}

Citizen.CreateThread(function()
    for k, v in ipairs(ipls.mains) do
        RequestIpl(v)
    end
    -- for k, v in ipairs(ipls.neededWhileClose) do
    --     RequestIpl(v)
    -- end

    -- remove snow
    SetZoneEnabled(GetZoneFromNameId("PrLog"), false)

    -- local entitySetName = "pearl_necklace_set"
    local entitySetName = "panther_set"
    -- local entitySetName = "pink_diamond_set"

    local interiorID = 280065
    if IsValidInterior(interiorID) then
        ActivateInteriorEntitySet(interiorID, entitySetName)
        SetInteriorEntitySetColor(interiorID, entitySetName, 1)

        RefreshInterior(interiorID)
    end

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isCloseToCayo = #(playerCoords - island) < 2200.0

        if isCayoLoaded ~= isCloseToCayo then
            print((isCloseToCayo and "Load" or "Unload") .. " Cayo Perico.")
            isCayoLoaded = isCloseToCayo
            isCayoMinimapLoaded = isCloseToCayo

            -- switch island (will disable Los Santos)
            -- SetIslandHopperEnabled('HeistIsland', isCayoLoaded)

            SetDeepOceanScaler(isCayoLoaded and 0.0 or 1.0)

            -- switch radar interior
            SetToggleMinimapHeistIsland(isCayoLoaded)

            -- misc natives
            SetAiGlobalPathNodesType(isCayoLoaded)
            Citizen.InvokeNative(0x53797676AD34A9AA, not isCayoLoaded)
            SetScenarioGroupEnabled("Heist_Island_Peds", isCayoLoaded)

            -- audio stuff
            SetAudioFlag("PlayerOnDLCHeist4Island", isCayoLoaded) -- disable radios
            SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", isCayoLoaded, true)
            SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", not isCayoLoaded, true)

            -- load the terrain of the island / los santos
            Wait(1000)
            if isCayoLoaded then
                for k, v in ipairs(ipls.neededWhileClose) do
                    RequestIpl(v)
                end
            else
                for k, v in ipairs(ipls.neededWhileClose) do
                    RemoveIpl(v)
                end
            end

        end

        Wait(5000)
    end
end)

---Handle the minimap loading and unloading
CreateThread(function()
    while true do
        local wait = 500
        if IsPauseMenuActive() and not IsMinimapInInterior() then
            -- If the player is in the pause menu and not looking at an interior minimap
            if isCayoMinimapLoaded then
                -- If the minimap was loaded with SetToggleMinimapHeistIsland, then we disable it
                isCayoMinimapLoaded = false
                SetToggleMinimapHeistIsland(false)
            end
            -- We force load the cayo perico minimap
            SetRadarAsExteriorThisFrame()
            SetRadarAsInteriorThisFrame(`h4_fake_islandx`, 4700.0, -5145.0, 0, 0)
            wait = 0

        elseif not isCayoMinimapLoaded and isCayoLoaded then
            -- If the minimap is not loaded with SetToggleMinimapHeistIsland and the player is close to cayo perico, then we load it
            isCayoMinimapLoaded = true
            SetToggleMinimapHeistIsland(true)
        end
        Wait(wait)
    end
end)
