Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)

		-- SetPedDensityMultiplierThisFrame(0.5)
        SetVehicleDensityMultiplierThisFrame(0.65)
		SetRandomVehicleDensityMultiplierThisFrame(0.65)
		SetParkedVehicleDensityMultiplierThisFrame(0.8)


		--? These natives have to be called every frame.
        -- SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
		-- SetGarbageTrucks(false)
		-- SetRandomBoats(false)
		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
	end
end)
