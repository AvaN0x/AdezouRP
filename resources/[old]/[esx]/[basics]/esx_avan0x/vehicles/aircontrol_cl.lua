local vehicleClassDisableControl = {
    [0] = true,     --compacts
    [1] = true,     --sedans
    [2] = true,     --SUV's
    [3] = true,     --coupes
    [4] = true,     --muscle
    [5] = true,     --sport classic
    [6] = true,     --sport
    [7] = true,     --super
    [8] = false,    --motorcycle
    [9] = true,     --offroad
    [10] = true,    --industrial
    [11] = true,    --utility
    [12] = true,    --vans
    [13] = false,   --bicycles
    [14] = false,   --boats
    [15] = false,   --helicopter
    [16] = false,   --plane
    [17] = true,    --service
    [18] = true,    --emergency
    [19] = false    --military
}

local vehicle = 0
local disableAirControl = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local playerPed = GetPlayerPed(-1)
        vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle ~= 0 then
            if GetPedInVehicleSeat(vehicle, -1) == playerPed and vehicleClassDisableControl[GetVehicleClass(vehicle)] then
                disableAirControl = true
            else
                disableAirControl = false
            end
            --! stop vehicle from despawning
            if not IsEntityAMissionEntity(vehicle) then
                print("SetEntityAsMissionEntity(vehicle)")
                SetEntityAsMissionEntity(vehicle)
            end
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- -- Get player, vehicle and vehicle class
        -- local playerPed = GetPlayerPed(-1)
        -- local vehicle = GetVehiclePedIsIn(playerPed, false)

        -- -- Disable control if player is in the driver seat and vehicle class matches array
        -- if ((GetPedInVehicleSeat(vehicle, -1) == playerPed) and vehicleClassDisableControl[GetVehicleClass(vehicle)]) then
        if vehicle ~= 0 and disableAirControl then
            -- Check if vehicle is in the air and disable L/R and UP/DN controls
            if IsEntityInAir(vehicle) then
                DisableControlAction(2, 59)
                DisableControlAction(2, 60)
            end
        end
    end
end)
