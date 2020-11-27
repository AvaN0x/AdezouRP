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

        local elements = {}
        for k, item in ipairs(inventory.items) do
            if item.count > 0 then
                local label
                if item.limit ~= -1 then
                    label = _('label_count_limit', item.label, item.count, item.limit)
                else
                    label = _('label_count', item.label, item.count)
                end
                table.insert(elements, {label = label, value = "item", item = item, detail = _('item_detail', string.format("%.3f", item.weight / 1000))})
            end
        end
        table.sort(elements, function(a,b)
            return a.label < b.label
        end)


        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_ava_my_inventory_" .. name,
        {
            title    = _('title', inventory.label, string.format("%.2f", inventory.actual_weight / 1000), string.format("%.2f", inventory.max_weight / 1000)),
            align    = "left",
            elements = elements
        }, function(data, menu)
            if data.current.value == "item" then
                print(data.current.item.label)
            end
		end, function(data, menu)
            menu.close()
        end)


    end, name)
end