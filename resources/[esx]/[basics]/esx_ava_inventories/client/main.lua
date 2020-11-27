-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsControlJustReleased(0, Config.OpenControl) then
            OpenMyInventory('inventory')
        end
    end
end)

function OpenMyInventory(name)
    ESX.TriggerServerCallback('esx_ava_inventories:getMyInventory', function(inventory)
        ESX.ShowNotification(inventory.actual_weight .. "/" .. inventory.max_weight)
        print(ESX.DumpTable(inventory))
    end, name)
end