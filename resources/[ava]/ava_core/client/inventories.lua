-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local InventoryElements, InventoryTopElements, TargetInventoryId = nil, nil, nil
local selectedItem = nil

local InventoryMenu = RageUI.CreateMenu("", ".", 0, 0, "avaui", "avaui_title_adezou")
InventoryMenu.Display.Glare = true
InventoryMenu.Closed = function()
    InventoryElements, InventoryTopElements, TargetInventoryId = nil, nil, nil
end
InventoryMenu:AddInstructionButton({GetControlGroupInstructionalButton(2, 15, 0), GetString("inventory_sort_change")})
local ItemSelectedMenu = RageUI.CreateSubMenu(InventoryMenu, "", ".", 0, 0, "avaui", "avaui_title_adezou")
ItemSelectedMenu.Closed = function()
    selectedItem = nil
end

local SortIndexes = {
    {name = "weight", label = GetString("inventory_sort_index_weight")},
    {name = "quantity", label = GetString("inventory_sort_index_quantity")},
    {name = "alpha", label = GetString("inventory_sort_index_alpha")},
    {name = "type", label = GetString("inventory_sort_index_type")},
}
local sortNotificationId = 0
local sortIndex = GetResourceKvpInt("ava_core_inventory_sort") % #SortIndexes

---Sort the inventory with the actual sorting index
local function SortInventory()
    local indexName = SortIndexes[sortIndex + 1].name
    if indexName == "weight" then
        table.sort(InventoryElements, function(a, b)
            return a.item.total_weight > b.item.total_weight
        end)

    elseif indexName == "quantity" then
        table.sort(InventoryElements, function(a, b)
            return a.item.quantity > b.item.quantity
        end)

    elseif indexName == "alpha" then
        table.sort(InventoryElements, function(a, b)
            return a.item.label:lower() < b.item.label:lower()
        end)

    elseif indexName == "type" then
        table.sort(InventoryElements, function(a, b)
            return (a.item.type or a.item.label:lower()) < (b.item.type or b.item.label:lower())
        end)

    end
end

---Edit the index of sorting for the inventory
---@param index number
local function SetSortingIndex(index)
    sortIndex = index % #SortIndexes
    SetResourceKvpInt("ava_core_inventory_sort", sortIndex)

    if sortNotificationId ~= -1 then
        -- remove old notification of sorter to only show the actual sorting label
        ThefeedRemoveItem(sortNotificationId)
    end
    sortNotificationId = AVA.ShowNotification(nil, nil, "ava_core_logo", GetString("inventory"),
        GetString("inventory_sorted_by", SortIndexes[sortIndex + 1].label), nil, "ava_core_logo")

    SortInventory()
end

---Format a weight (in gram) into a string
---@param weight number
---@param digitCount integer
---@return string
local function formatWeight(weight, digitCount)
    if type(digitCount) ~= "number" then
        if (weight % 10) > 0 then
            digitCount = 3
        elseif (weight % 100) > 0 then
            digitCount = 2
        else
            digitCount = 1
        end
    end
    return ("%." .. digitCount .. "f"):format(weight / 1000)
end

---Get string for quantity unit
---@param itemType string
---@return string
local function getQuantityUnit(itemType)
    return itemType and itemType == "money" and "$" or ""
end

---Get inventory data from server and process it
local function ReloadInventoryWithData(invItems, maxWeight, actualWeight, title)
    -- dprint(json.encode(invItems, { indent = true }), maxWeight, actualWeight, title)
    InventoryElements, InventoryTopElements = {}, {}
    if not invItems then
        return
    end
    local invElementsCount = 0

    for i = 1, #invItems, 1 do
        local item = invItems[i]
        if item then
            item.total_weight = item.quantity * item.weight
            local unit = item.type and item.type == "liquid" and "L" or "kg"

            local element = {
                item = item,
                label = item.label,
                description = GetString("inventory_weight_unit", formatWeight(item.weight), unit,
                    (item.desc and item.desc ~= "") and ("\n%s"):format(item.desc) or ""),
                RightLabel = ("%s %s - %s %s"):format(item.limit and ("%s/%s"):format(AVA.Utils.FormatNumber(item.quantity), item.limit)
                                                          or AVA.Utils.FormatNumber(item.quantity), getQuantityUnit(item.type), formatWeight(item.total_weight),
                    unit),
                LeftBadge = not item.noIcon and function()
                    return {BadgeDictionary = "ava_items", BadgeTexture = item.name}
                end or nil,
            }

            if AVAConfig.InventoryMoneyOnTop and (item.type and item.type == "money") then
                table.insert(InventoryTopElements, 1, element)
            else
                invElementsCount = invElementsCount + 1
                InventoryElements[invElementsCount] = element
            end
        end
    end

    if AVAConfig.InventoryMoneyOnTop then
        table.sort(InventoryTopElements, function(a, b)
            return a.item.name < b.item.name
        end)
    end

    SortInventory()

    InventoryMenu.Subtitle = ("%s (%s/%skg)"):format(title, formatWeight(actualWeight), formatWeight(maxWeight, 1))
end

local function OpenMyInventory()
    if not RageUI.Visible(InventoryMenu) then
        ReloadInventoryWithData(AVA.TriggerServerCallback("ava_core:server:getInventoryItems"))

        RageUI.CloseAll()
        RageUI.Visible(InventoryMenu, true)
    end
end

---Action when selecting an item
---@param item table
local function SelectItem(item)
    selectedItem = item
    dprint(item.name)
    ItemSelectedMenu.Index = 1
    ItemSelectedMenu.Subtitle = ("%s - %s %s"):format(item.label, AVA.Utils.FormatNumber(item.quantity), getQuantityUnit(item.type))
end

function RageUI.PoolMenus:AvaCoreInventory()
    InventoryMenu:IsVisible(function(Items)
        if IsDisabledControlJustPressed(2, 207) then -- PageDown
            SetSortingIndex(sortIndex > 0 and (sortIndex - 1) or (#SortIndexes - 1))
        elseif IsDisabledControlJustPressed(2, 208) then -- PageUp
            SetSortingIndex(sortIndex < (#SortIndexes - 1) and (sortIndex + 1) or 0)
        end

        if AVAConfig.InventoryMoneyOnTop and InventoryTopElements then
            for i = 1, #InventoryTopElements, 1 do
                local element = InventoryTopElements[i]
                Items:AddButton(element.label, element.description, {LeftBadge = element.LeftBadge, RightLabel = element.RightLabel}, function(onSelected)
                    if onSelected then
                        SelectItem(element.item)
                    end
                end, ItemSelectedMenu)
            end
        end

        if InventoryElements then
            for i = 1, #InventoryElements, 1 do
                local element = InventoryElements[i]
                Items:AddButton(element.label, element.description, {LeftBadge = element.LeftBadge, RightLabel = element.RightLabel}, function(onSelected)
                    if onSelected then
                        SelectItem(element.item)
                    end
                end, ItemSelectedMenu)
            end
        end
    end)

    ItemSelectedMenu:IsVisible(function(Items)
        if selectedItem.quantity > 0 then
            if not TargetInventoryId then
                if selectedItem.usable then
                    Items:AddButton(GetString("inventory_use"), nil, nil, function(onSelected)
                        if onSelected then
                            selectedItem.quantity = selectedItem.quantity - 1
                            local selectedItem = selectedItem
                            if selectedItem.closeInv then
                                RageUI.CloseAllInternal()
                            end
                            TriggerServerEvent("ava_core:server:useItem", selectedItem.name)
                        end
                    end)
                end
                Items:AddButton(GetString("inventory_give"), nil, nil, function(onSelected)
                    if onSelected then
                        local selectedItem = selectedItem
                        Citizen.CreateThread(function()
                            local targetId = AVA.Utils.ChooseClosestPlayer()
                            if targetId then
                                local count = tonumber(AVA.KeyboardInput(GetString("inventory_give_enter_quantity",
                                    AVA.Utils.FormatNumber(selectedItem.quantity), getQuantityUnit(selectedItem.type)), "", 10))
                                if type(count) == "number" and math.floor(count) == count and count > 0 then
                                    TriggerServerEvent("ava_core:server:giveItem", targetId, selectedItem.name, count)
                                end
                            end
                            OpenMyInventory()
                        end)
                    end
                end)
                Items:AddButton(GetString("inventory_drop"), nil, {IsDisabled = AVA.Player.isInVehicle}, function(onSelected)
                    if onSelected then
                        local selectedItem = selectedItem
                        local count = tonumber(AVA.KeyboardInput(GetString("inventory_drop_enter_quantity", AVA.Utils.FormatNumber(selectedItem.quantity),
                            getQuantityUnit(selectedItem.type)), "", 10))
                        if type(count) == "number" and math.floor(count) == count and count > 0 then
                            RequestAnimDict("pickup_object")
                            while not HasAnimDictLoaded("pickup_object") do
                                Wait(0)
                            end
                            TaskPlayAnim(AVA.Player.playerPed, "pickup_object", "putdown_low", 8.0, -8, 1200, 16, 0, 0, 0, 0)
                            RemoveAnimDict("pickup_object")

                            Wait(500)
                            TriggerServerEvent("ava_core:server:dropItem", AVA.GeneratePickupCoords(), selectedItem.name, count)
                        end
                        OpenMyInventory()
                    end
                end)
                Items:AddButton(GetString("inventory_drop_max"), GetString("inventory_drop_max_subtitle"), {IsDisabled = AVA.Player.isInVehicle},
                    function(onSelected)
                        if onSelected then
                            local selectedItem = selectedItem
                            RequestAnimDict("pickup_object")
                            while not HasAnimDictLoaded("pickup_object") do
                                Wait(0)
                            end
                            TaskPlayAnim(AVA.Player.playerPed, "pickup_object", "putdown_low", 8.0, 1.0, 500, 16, 0, 0, 0, 0)
                            RemoveAnimDict("pickup_object")

                            Wait(500)
                            TriggerServerEvent("ava_core:server:dropItem", AVA.GeneratePickupCoords(), selectedItem.name, selectedItem.quantity)

                            OpenMyInventory()
                        end
                    end)
            else
                Items:AddButton(GetString("inventory_take"), nil, nil, function(onSelected)
                    if onSelected then
                        local selectedItem = selectedItem
                        local count = tonumber(AVA.KeyboardInput(GetString("inventory_take_enter_quantity", AVA.Utils.FormatNumber(selectedItem.quantity),
                            getQuantityUnit(selectedItem.type)), "", 10))
                        if type(count) == "number" and math.floor(count) == count and count > 0 then
                            TriggerServerEvent("ava_core:server:takeItem", TargetInventoryId, selectedItem.name, count)
                        end
                        TriggerEvent("ava_core:client:openTargetInventory", TargetInventoryId)
                    end
                end)
            end
        else
            RageUI.GoBack()
        end
    end)
end

RegisterCommand("keyInventory", function()
    if exports.ava_core:canOpenMenu() then
        OpenMyInventory()
    end
end)

RegisterKeyMapping("keyInventory", GetString("inventory"), "keyboard", AVAConfig.InventoryKey)

local editItem_timelastReload, editItem_waitingToReload = -1, false
RegisterNetEvent("ava_core:client:editItemInventoryCount", function(itemName, itemLabel, isAddition, editedQuantity, newQuantity)
    if not editItem_waitingToReload and InventoryElements and InventoryTopElements and RageUI.Visible(InventoryMenu) then
        -- prevent spamming the server for data
        -- this will do it with at least 500ms between each calls
        editItem_waitingToReload = true
        local timer = GetGameTimer()
        while (math.abs(timer - editItem_timelastReload) < 500) do
            timer = GetGameTimer()
            Wait(10)
        end
        editItem_timelastReload = timer
        editItem_waitingToReload = false
        -- Only reload if inventory is still visible
        if RageUI.Visible(InventoryMenu) and not TargetInventoryId then
            ReloadInventoryWithData(AVA.TriggerServerCallback("ava_core:server:getInventoryItems"))
        end
    end
    if selectedItem and selectedItem.name == itemName then
        selectedItem.quantity = newQuantity
        ItemSelectedMenu.Subtitle = ("%s - %s %s"):format(selectedItem.label, AVA.Utils.FormatNumber(selectedItem.quantity), getQuantityUnit(selectedItem.type))
    end
end)

RegisterNetEvent("ava_core:client:openTargetInventory", function(targetId)
    RageUI.CloseAll()
    TargetInventoryId = targetId
    ReloadInventoryWithData(AVA.TriggerServerCallback("ava_core:server:getTargetInventoryItems", targetId))

    RageUI.Visible(InventoryMenu, true)
end)

if AVAConfig.NPWD then
    exports("hasPhoneItem", function()
        return exports.ava_core:TriggerServerCallback("ava_core:server:getItemQuantity", "phone") > 0
    end)
end

