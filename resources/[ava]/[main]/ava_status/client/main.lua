-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- Contains only name and value of statuses
local PlayerStatus = nil
-- Contain objects handling statuses
local aPlayerStatus = {}

Citizen.CreateThread(function()
    PlayerStatus = exports.ava_core:getPlayerData().status

    initStatus(PlayerStatus)
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        if k == "status" then
            initStatus(v)
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    initStatus(data.status)
end)

function initStatus(statusArray)
    for i = 1, #statusArray do
        local status = status[i]
        if aPlayerStatus[status.name] then
            aPlayerStatus[status.name].value = status.value
        else
            local cfgStatus<const> = AVAConfig.Status[status.name]
            if cfgStatus and cfgStatus.update then
                aPlayerStatus[status.name] = CreateStatus(status.name, status.value)
            end
        end
    end

    for name, cfgStatus in pairs(AVAConfig.Status) do
        if not aPlayerStatus[name] then
            local value = cfgStatus.default or 10000
            statusArray[#statusArray + 1] = {name = name, value = value}
            aPlayerStatus[name] = CreateStatus(name, value)
        end
    end

    PlayerStatus = statusArray
end

Citizen.CreateThread(function()
    while true do
        Wait(AVAConfig.Interval)
        for i = 1, #PlayerStatus do
            local status = PlayerStatus[i]
            local aStatus = aPlayerStatus[status.name]
            status.value = aStatus.update()
            TriggerEvent("ava_hud:client:updateStatus", status.name, aStatus.getPercent())
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(AVAConfig.SaveTimeout)
        TriggerServerEvent("ava_status:server:update", PlayerStatus)
    end
end)
