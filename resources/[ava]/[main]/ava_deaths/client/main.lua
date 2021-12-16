-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
IsDead = false

local function RespawnPlayer()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Citizen.Wait(50)
        end

        local position = GetEntityCoords(playerPed)

        SetEntityCoordsNoOffset(playerPed, position, false, false, false, true)
        NetworkResurrectLocalPlayer(position, 0.0, true, false)
        SetPlayerInvincible(playerPed, false)
        ClearPedBloodDamage(playerPed)
        TriggerEvent("playerSpawned", {x = position.x, y = position.y, z = position.z, heading = 0.0})
        TriggerEvent("ava_core:client:playerRevived")

        SetEntityHealth(playerPed, 105)

        StopScreenEffect("DeathFailOut")
        DoScreenFadeIn(800)
    end)
end

AddEventHandler("ava_core:client:playerRevived", function()
    IsDead = true
end)

AddEventHandler("ava_core:client:playerDeath", function()
    IsDead = true
    TriggerEvent("RageUI.CloseAll")
    StartScreenEffect("DeathFailOut", AVAConfig.DeadScreenMaxDuration, false)

    Wait(AVAConfig.DeadScreenMaxDuration)
    RespawnPlayer()
end)

-- DEBUG COMMAND
RegisterCommand("revive", function()
    RespawnPlayer()
end)
