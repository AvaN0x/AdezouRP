-- TODO redo it
local IsDead = false

local crouchKey = 36
local crouched = false

AddEventHandler("ava_core:client:playerDeath", function()
    IsDead = true
end)

AddEventHandler("ava_core:client:playerSpawned", function(spawn)
    IsDead = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not IsDead then
            DisableControlAction(1, crouchKey, true)

            if IsDisabledControlJustPressed(1, crouchKey) then
                local plyPed = PlayerPedId()
                RequestAnimSet("move_ped_crouched")
                while not HasAnimSetLoaded("move_ped_crouched") do
                    Citizen.Wait(50)
                end
                RemoveAnimSet("move_ped_crouched")

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
