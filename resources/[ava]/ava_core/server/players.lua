-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.Players = {}
AVA.Players.List = {}

------------------------------------------
--------------- Connecting ---------------
------------------------------------------
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    
    print(src, "playerConnecting")
    print("playerConnecting json.encode(AVA.Players.List)", json.encode(AVA.Players.List))

    -- mandatory wait!
    Wait(0)

	deferrals.update("Vérification des permissions...")

    Wait(1000)

    deferrals.done()
end)


---------------------------------------
--------------- Joining ---------------
---------------------------------------

local function setupPlayer(src, oldSource)
    Citizen.CreateThread(function()
        -- mandatory wait!
        Wait(0)

        print(src, "playerJoining, oldId : ", oldSource)

        AVA.Players.List[tostring(src)] = CreatePlayer(src)

        print("playerJoining json.encode(AVA.Players.List)", json.encode(AVA.Players.List))

        TriggerClientEvent("ava_core:client:playerLoaded", src, AVA.Players.List[tostring(src)])
    end)
end


AddEventHandler('playerJoining', function(oldSource)
    local src = source
    setupPlayer(src, oldSource)
end)

for _, source in ipairs(GetPlayers()) do
    setupPlayer(source)
end

--* replaced with event playerJoining
-- RegisterNetEvent('ava_core:server:playerJoined', function()
--     local src = source
--     print(src, "ava_core:server:playerJoined")
-- end)



---------------------------------------
--------------- Dropped ---------------
---------------------------------------

AddEventHandler('playerDropped', function(reason)
    local src = source
    print(src, "playerDropped", reason)
    if AVA.Players.List[tostring(src)] then
        AVA.Players.List[tostring(src)] = nil
    end
    print("playerDropped json.encode(AVA.Players.List)", json.encode(AVA.Players.List))
end)

