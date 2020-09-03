Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- prevent crashing
		SetPedDensityMultiplierThisFrame(0.5) -- set npc/ai peds density to 0
		SetRandomVehicleDensityMultiplierThisFrame(0.3) -- 
		SetParkedVehicleDensityMultiplierThisFrame(0.3)
		-- These natives have to be called every frame.
		SetVehicleModelIsSuppressed(GetHashKey("rubble"), true)
        SetVehicleModelIsSuppressed(GetHashKey("taco"), true)
        SetVehicleModelIsSuppressed(GetHashKey("biff"), true)
		SetGarbageTrucks(false) -- Stop garbage trucks from randomly spawning
		--SetRandomBoats(false) -- Stop random boats from spawning in the water.
		SetCreateRandomCops(false) -- disable random cops walking/driving around.
		SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning.
		SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning.
	end
end)

---------------------------------
--------- ikNox#6088 ------------
---------------------------------