Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        --? disabled for the moment to test if it's worth it
		-- SetPedDensityMultiplierThisFrame(0.5)
		-- SetRandomVehicleDensityMultiplierThisFrame(0.3)
		-- SetParkedVehicleDensityMultiplierThisFrame(0.3)

        --? values from another script
        -- SetVehicleDensityMultiplierThisFrame(0.65)
		-- SetParkedVehicleDensityMultiplierThisFrame(0.8)


		--? These natives have to be called every frame.
        -- SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
		-- SetGarbageTrucks(false)
		-- SetRandomBoats(false)
		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
	end
end)
