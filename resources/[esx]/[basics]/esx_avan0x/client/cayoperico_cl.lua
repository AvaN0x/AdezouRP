-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local island = vector3(4858.0, -5171.0, 2.0)
local isIslandLoaded = nil
local isInIsland = nil

Citizen.CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        isInIsland = #(playerCoords - island) < 2200.0

        if isIslandLoaded ~= isInIsland then
            print((isInIsland and "Load" or "Unload") .. " Cayo Perico.")
            isIslandLoaded = isInIsland

            -- switch island (will disable Los Santos)
            Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', isIslandLoaded) -- or use false to disable it

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
            if not isIslandLoaded then
                Citizen.Wait(1000)
                -- ? source : islandhopper.meta

                RequestIpl("H4_islandx_terrain_01")
                RequestIpl("H4_islandx_terrain_02")
                RequestIpl("H4_islandx_terrain_03")
                RequestIpl("H4_islandx_terrain_04")
                RequestIpl("H4_islandx_terrain_05")
                RequestIpl("H4_islandx_terrain_06")
            end

        end

        Citizen.Wait(5000)
    end
end)
