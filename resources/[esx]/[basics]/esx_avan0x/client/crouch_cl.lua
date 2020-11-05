local IsDead = false

local crouchKey = 36
local crouched = false

AddEventHandler("esx:onPlayerDeath", function()
	IsDead = true
end)

AddEventHandler("playerSpawned", function(spawn)
	IsDead = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

        if not IsDead then
            local plyPed = PlayerPedId()
            DisableControlAction(1, crouchKey, true)

            if IsDisabledControlJustPressed(1, crouchKey) then
                RequestAnimSet("move_ped_crouched")

                while not HasAnimSetLoaded("move_ped_crouched") do
                    Citizen.Wait(100)
                end 

                if crouched == true then
                    ResetPedMovementClipset(plyPed, 0)
                    crouched = false
                elseif crouched == false then
                    SetPedMovementClipset(plyPed, "move_ped_crouched", 0.25)
                    crouched = true
                end
            end
        end
    end
end)