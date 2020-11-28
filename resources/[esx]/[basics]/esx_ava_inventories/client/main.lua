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
        local elements = {}
        --? types : item_standard, item_weapon, item_money, item_account
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
        table.sort(elements, function(a,b)
            return a.label < b.label
        end)


        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_ava_my_inventory_" .. name,
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

            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_ava_my_inventory_" .. name .. "item",
            {
                title    = _('title_count', data.current.item.count, data.current.item.label),
                align    = "left",
                elements = elements2
            }, function(data2, menu2)
                if data2.current.value == "use_item" then
                    if data.current.value == "item_standard" then
                        UseItem(data.current.item.name)
                    end

                elseif data2.current.value == "give_item" then
                    GetClosestPlayer(function(player)
                        GiveItem(name, player, data.current.value, data.current.item.name)
                    end)

                elseif data2.current.value == "drop_item" then
                    DropItem(name, data.current.value, data.current.item.name)
                    ESX.UI.Menu.CloseAll()
                    OpenMyInventory(name)
                end
            end, function(data2, menu2)
                ESX.UI.Menu.CloseAll()
                OpenMyInventory(name)
            end)
		end, function(data, menu)
            menu.close()
        end)
    end, name)
end

function EnterAmount(cb)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), "ava_inventories_enter_amount", {
		title = _('enter_amount')
	}, function(data, menu)
		menu.close()
		cb(data.value)
	end, function(data, menu)
		menu.close()
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

function GiveItem(inventoryName, player, itemType, itemName)
    local amount = tonumber(ESX.KeyboardInput(_('enter_amount'), "1", 10))
    if type(amount) == "number" and math.floor(amount) == amount then
        TriggerServerEvent("esx_ava_inventories:giveItem", inventoryName, itemType, player, itemName, amount)
    end
end

function DropItem(inventoryName, itemType, itemName)
    local amount = tonumber(ESX.KeyboardInput(_('enter_amount'), "1", 10))
    local playerPed = PlayerPedId()
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(amount) == "number" and math.floor(amount) == amount then
        TriggerServerEvent("esx_ava_inventories:dropItem", inventoryName, itemType, itemName, amount)
    end
end

--? other inventory
function TakeItem()

end

function PutItem()

end
