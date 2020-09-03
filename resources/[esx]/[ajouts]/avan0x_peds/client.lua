-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Peds) do
        local hash = GetHashKey(v.Name)
        RequestModel(hash)
        
        while not HasModelLoaded(hash) do
            Wait(1)
        end
    
        for _, p in pairs(v.PosList) do
            local ped = CreatePed(v.Type, v.Name, p.x, p.y, p.z, p.h, false, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            if p.scenario then
                TaskStartScenarioInPlace(ped, p.scenario, 0, false)
            end
        end
    
    end
end)