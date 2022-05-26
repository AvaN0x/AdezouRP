-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local playerCount = 0

local function updatePlayerCount()
    playerCount = #GetPlayers()
    TriggerClientEvent("ava_hud:client:playerCount", -1, playerCount)
end
updatePlayerCount()

RegisterNetEvent("ava_hud:server:requestPlayerCount", function()
    local src = source
    TriggerClientEvent("ava_hud:client:playerCount", src, playerCount)
end)

AddEventHandler("playerJoining", updatePlayerCount)
AddEventHandler("playerDropped", updatePlayerCount)
