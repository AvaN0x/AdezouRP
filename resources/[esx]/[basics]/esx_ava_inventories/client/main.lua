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

RegisterCommand('+keyInventory', function()
	OpenMyInventory()
end, false)

RegisterKeyMapping('+keyInventory', 'Inventaire', 'keyboard', Config.OpenControl)


function OpenMyInventory()
    ESX.TriggerServerCallback('esx_ava_inventories:getMyInventory', function(inventory)
        --? types : item_standard, item_weapon, item_money, item_account
        table.sort(inventory.items, function(a,b)
            return a.label < b.label
        end)

        local elements = {}

        table.insert(elements, {label = _('label_cash', ESX.Math.GroupDigits(inventory.money)), value = "item_money", item = {name = "money", count = inventory.money}})

        for k, acc in pairs(inventory.accounts) do
            if acc.name ~= "bank" and acc.money > 0 then
                table.insert(elements, {label = _('label_account_' .. acc.name, ESX.Math.GroupDigits(acc.money)), value = "item_account", item = {name = acc.name, count = acc.money}})
            end
        end

        for k, item in ipairs(inventory.items) do
            if item.count > 0 then
                local label
                if item.limit ~= -1 then
                    label = _('label_count_limit', item.label, item.count, item.limit)
                else
                    label = _('label_count', item.label, item.count)
                end
                local detail = _('item_detail', string.format("%.3f", item.weight / 1000))
                if string.find(item.name, "weapon_") then
                    detail = detail .. "</br>" .. _('item_weapon_detail')
                end
                table.insert(elements, {label = label, value = "item_standard", item = item, detail = detail})
            end
        end

        local playerPed = PlayerPedId()
        for k, wea in pairs(inventory.weapons) do
            if wea.name ~= "WEAPON_UNARMED" then
                local ammo = GetAmmoInPedWeapon(playerPed, GetHashKey(wea.name))
                table.insert(elements, {label = _('label_weapon', wea.label), value = "item_weapon", item = {name = wea.name, usable = true}, detail = ( ammo ~= -1 and (_('weapon_ammo_amount', ammo) .. "</br>") or "") .. _('loadout_weapon_detail')})
            end
        end


        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_ava_my_inventory",
        {
            title    = _('title', inventory.label, string.format("%.2f", inventory.actual_weight / 1000), string.format("%.2f", inventory.max_weight / 1000)),
            align    = "left",
            elements = elements
        }, function(data, menu)
            local elements2 = {}
            if data.current.item.usable then
                table.insert(elements2, {label = _('use_item'), value = "use_item"})
            end
            table.insert(elements2, {label = _('give_item'), value = "give_item"})
            table.insert(elements2, {label = _('drop_item'), value = "drop_item"})

            local title = data.current.label
            if data.current.item and data.current.item.label then
                title = _('title_count', data.current.item.count, data.current.item.label)
            end
            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_ava_my_inventory_item",
            {
                title = title,
                align = "left",
                elements = elements2
            }, function(data2, menu2)
                if data2.current.value == "use_item" then
                    if data.current.value == "item_standard" then
                        UseItem(data.current.item.name)
                    elseif data.current.value == "item_weapon" then
                        ESX.UI.Menu.CloseAll()
                        TriggerServerEvent("esx_avan0x:useWeaponItem", data.current.item.name)
                        OpenMyInventory()
                    end

                elseif data2.current.value == "give_item" then
                    GetClosestPlayer(function(player)
                        GiveItem(player, data.current.value, data.current.item.name)
                    end)

                elseif data2.current.value == "drop_item" then
                    DropItem(data.current.value, data.current.item.name)
                    ESX.UI.Menu.CloseAll()
                    OpenMyInventory()
                end
            end, function(data2, menu2)
                ESX.UI.Menu.CloseAll()
                OpenMyInventory()
            end)
		end, function(data, menu)
            menu.close()
        end)
    end)
end

function GetClosestPlayer(cb)
    local playerPed = PlayerPedId()
    local playerId = PlayerId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayers = false
    local elements = {}

    for k, player in ipairs(players) do
        if player ~= playerId then
            foundPlayers = true
            -- todo draw player name and a line to them?
            table.insert(elements, {
                label = GetPlayerName(player),
                player = GetPlayerServerId(player)
            })
        end
    end

    if foundPlayers then
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_ava_inventories_get_close_player",
        {
            title = _('select_a_player'),
            align = "left",
            elements = elements
        }, function(data, menu)
            menu.close()
            cb(data.current.player)
        end, function(data, menu)
            menu.close()
        end)
    else
        ESX.ShowNotification(_("no_players_near"))
    end
end

--? my inventory
function UseItem(itemName)
    TriggerServerEvent("esx:useItem", itemName)
    for k, item in ipairs(Config.CloseMenuItems) do
        if item == itemName then
            ESX.UI.Menu.CloseAll()
            break
        end
    end
end

function GiveItem(player, itemType, itemName)
    local amount = 1
    if itemType ~= "item_weapon" then
        amount = tonumber(ESX.KeyboardInput(_('enter_amount'), "", 10))
    end
    if type(amount) == "number" and math.floor(amount) == amount and amount > 0 then
        TriggerServerEvent("esx_ava_inventories:giveItem", 'inventory', itemType, player, itemName, amount)
        ESX.Streaming.RequestAnimDict("mp_common", function()
            local playerPed = PlayerPedId()
            TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, 8, 2000, 1, 0, 0, 0, 0)

            Citizen.Wait(2000)
            ClearPedTasksImmediately(playerPed)
        end)
    end
end

function DropItem(itemType, itemName)
    local amount = 1
    if itemType ~= "item_weapon" then
        amount = tonumber(ESX.KeyboardInput(_('enter_amount'), "", 10))
    end
    local playerPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(amount) == "number" and math.floor(amount) == amount and amount > 0 then
        TriggerServerEvent("esx_ava_inventories:dropItem", 'inventory', itemType, itemName, amount)
    end
end
















--? other inventory
RegisterNetEvent('esx_ava_inventories:openPlayerInventory')
AddEventHandler('esx_ava_inventories:openPlayerInventory', function(serverId)
    OpenOtherPlayerInventory(serverId)
end)

function OpenOtherPlayerInventory(serverId)
    ESX.TriggerServerCallback('esx_ava_inventories:getTargetInventory', function(inventory)

        table.sort(inventory.items, function(a,b)
            return a.label < b.label
        end)

        local elements = {}

        table.insert(elements, {label = _('label_cash', ESX.Math.GroupDigits(inventory.money)), value = "item_money", item = {name = "money", count = inventory.money}})

        for k, acc in pairs(inventory.accounts) do
            if acc.name ~= "bank" and acc.money > 0 then
                table.insert(elements, {label = _('label_account_' .. acc.name, ESX.Math.GroupDigits(acc.money)), value = "item_account", item = {name = acc.name, count = acc.money}})
            end
        end

        for k, item in ipairs(inventory.items) do
            if item.count > 0 then
                local label
                if item.limit ~= -1 then
                    label = _('label_count_limit', item.label, item.count, item.limit)
                else
                    label = _('label_count', item.label, item.count)
                end
                table.insert(elements, {label = label, value = "item_standard", item = item, detail = _('item_detail', string.format("%.3f", item.weight / 1000))})
            end
        end

        for k, wea in pairs(inventory.weapons) do
            table.insert(elements, {label = _('label_weapon', wea.label), value = "item_weapon", item = {name = wea.name}})
        end

        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_ava_my_inventory",
        {
            title    = _('title', inventory.label, string.format("%.2f", inventory.actual_weight / 1000), string.format("%.2f", inventory.max_weight / 1000)),
            align    = "left",
            elements = elements
        }, function(data, menu)
            menu.close()
            TakePlayerItem(serverId, data.current.value, data.current.item.name)
            OpenOtherPlayerInventory(serverId)
		end, function(data, menu)
            menu.close()
        end)

    end, serverId)
end

function TakePlayerItem(player, itemType, itemName)
    local amount = 1
    if itemType ~= "item_weapon" then
        amount = tonumber(ESX.KeyboardInput(_('enter_amount'), "", 10))
    end
    if type(amount) == "number" and math.floor(amount) == amount and amount > 0 then
        TriggerServerEvent("esx_ava_inventories:takePlayerItem", 'inventory', itemType, player, itemName, amount)
    end
end







RegisterNetEvent('esx_ava_inventories:OpenSharedInventory')
AddEventHandler('esx_ava_inventories:OpenSharedInventory', function(name)
    ESX.TriggerServerCallback("esx_ava_inventories:getSharedInventory", function(inventory)
        OpenOtherInventory(inventory)
    end, name)
end)

function OpenOtherInventory(inventory)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ava_open_other_inventory',
	{
		title = inventory.label,
		align = 'left',
		elements = {
            {label = _U('deposit_stock'), value = 'put_stock'},
            {label = _U('take_stock'), value = 'get_stock'}
        }
	},
	function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutInventory(inventory.name)
		elseif data.current.value == 'get_stock' then
			OpenTakeInventory(inventory.name)
		end
	end,
	function(data, menu)
		menu.close()
	end)
end


-- function OpenPutStocksMenu()
-- 	ESX.TriggerServerCallback('esx_ava_inventories:getMyInventory', function(inventory)
-- 		local elements = {}
-- 		table.insert(elements, {label = "Argent " .. inventory.money .. '$', type = 'cash'})
--         for k, acc in pairs(inventory.accounts) do
--             if acc.name == "black_money" then
-- 				table.insert(elements, {label = "Argent sale " .. acc.money .. '$', type = 'black_cash'})
-- 				break
-- 			end
--         end

-- 		for i=1, #inventory.items, 1 do
-- 			local item = inventory.items[i]
-- 			if item.count > 0 then
-- 				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
-- 			end
-- 		end

-- 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
-- 		{
-- 			title    = _U('inventory'),
-- 			elements = elements
-- 		},
-- 		function(data, menu)
-- 			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
-- 			{
-- 				title = _U('quantity')
-- 			},
-- 			function(data2, menu2)
-- 				local count = tonumber(data2.value)
-- 				if count == nil or count <= 0 then
-- 					ESX.ShowNotification(_U('quantity_invalid'))
-- 				else
-- 					menu2.close()
-- 					menu.close()
-- 					if data.current.type == "item_standard" then
-- 						TriggerServerEvent('esx_ava_gang:putStockItems', data.current.value, count, actualGang.name)
-- 					elseif data.current.type == "cash" then
-- 						TriggerServerEvent('esx_ava_gang:depositMoney', actualGang.name, count)
-- 					elseif data.current.type == "black_cash" then
-- 						TriggerServerEvent('esx_ava_gang:depositMoneyDirty', actualGang.name, count)
-- 					end
-- 					OpenPutStocksMenu()
-- 				end
-- 			end,
-- 			function(data2, menu2)
-- 				menu2.close()
-- 			end)
-- 		end,
-- 		function(data, menu)
-- 			menu.close()
-- 		end)
-- 	end)
-- end

-- function OpenGetStocksMenu()
-- 	ESX.TriggerServerCallback('esx_ava_gang:getStockItems', function(inventory)
-- 		local elements = {}
-- 		table.insert(elements, {label = "Argent " .. inventory.cash .. '$', type = 'cash'})
-- 		table.insert(elements, {label = "Argent sale " .. inventory.black_cash .. '$', type = 'black_cash'})

-- 		for i=1, #inventory.items, 1 do
-- 			if (inventory.items[i].count ~= 0) then
-- 				table.insert(elements, {label = 'x' .. inventory.items[i].count .. ' ' .. inventory.items[i].label, value = inventory.items[i].name, type = 'item_standard'})
-- 			end
-- 		end

-- 		ESX.UI.Menu.Open(
-- 		'default', GetCurrentResourceName(), 'stocks_menu',
-- 		{
-- 			title    = actualGang.data.Name .. ' Stock',
-- 			align    = 'left',
-- 			css 	 = 'gang',
-- 			elements = elements
-- 		},
-- 		function(data, menu)
-- 			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
-- 			{
-- 				title = _U('quantity')
-- 			},
-- 			function(data2, menu2)
-- 				local count = tonumber(data2.value)
-- 				if count == nil or count <= 0 then
-- 					ESX.ShowNotification(_U('quantity_invalid'))
-- 				else
-- 					menu2.close()
-- 					menu.close()
-- 					if data.current.type == "item_standard" then
-- 						TriggerServerEvent('esx_ava_gang:getStockItem', data.current.value, count, actualGang.name)
-- 					elseif data.current.type == "cash" then
-- 						TriggerServerEvent('esx_ava_gang:withdrawMoney', actualGang.name, count)
-- 					elseif data.current.type == "black_cash" then
-- 						TriggerServerEvent('esx_ava_gang:withdrawMoneyDirty', actualGang.name, count)
-- 					end
-- 					OpenGetStocksMenu()
-- 				end
-- 			end,
-- 			function(data2, menu2)
-- 				menu2.close()
-- 			end)
-- 		end,
-- 		function(data, menu)
-- 			menu.close()
-- 		end)
-- 	end, actualGang.name)
-- end

function OpenPutInventory(inventoryName)
    ESX.TriggerServerCallback('esx_ava_inventories:getMyInventory', function(inventory)
        local elements = {}
        for k, item in ipairs(inventory.items) do
            if item.count > 0 then
                local label
                if item.limit ~= -1 then
                    label = _('label_count_limit', item.label, item.count, item.limit)
                else
                    label = _('label_count', item.label, item.count)
                end
                local detail = _('item_detail', string.format("%.3f", item.weight / 1000))
                table.insert(elements, {label = label, value = "item_standard", item = item, detail = detail})
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ava_inventories_put_stocks_menu',
        {
            title    = _('title', inventory.label, string.format("%.2f", inventory.actual_weight / 1000), string.format("%.2f", inventory.max_weight / 1000)),
            elements = elements
        },
        function(data, menu)
            local count = tonumber(ESX.KeyboardInput(_('enter_amount'), "", 10))
            if type(count) == "number" and math.floor(count) == count and count > 0 then
                menu.close()
                TriggerServerEvent('esx_ava_inventories:putStockItems', data.current.item.name, count, inventoryName)
                OpenPutInventory(inventoryName)
            else
                ESX.ShowNotification(_('invalid_quantity'))
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end)
end


function OpenTakeInventory(inventoryName)
    ESX.TriggerServerCallback("esx_ava_inventories:getSharedInventory", function(inventory)
        local elements = {}
        for k, item in ipairs(inventory.items) do
            if item.count > 0 then
                local label = _('label_count', item.label, item.count)
                local detail = _('item_detail', string.format("%.3f", item.weight / 1000))
                table.insert(elements, {label = label, value = "item_standard", item = item, detail = detail})
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ava_inventories_take_stocks_menu',
        {
            title    = _('title', inventory.label, string.format("%.2f", inventory.actual_weight / 1000), string.format("%.2f", inventory.max_weight / 1000)),
            elements = elements
        },
        function(data, menu)
            local count = tonumber(ESX.KeyboardInput(_('enter_amount'), "", 10))
            if type(count) == "number" and math.floor(count) == count and count > 0 then
                menu.close()
                TriggerServerEvent('esx_ava_inventories:takeStockItem', data.current.item.name, count, inventoryName)
                OpenTakeInventory(inventoryName)
            else
                ESX.ShowNotification(_('invalid_quantity'))
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end, inventoryName)
end

