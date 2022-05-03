-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local InventoryData = nil
local TargetInventory = nil
local TargetInventoryInteractions = nil

local selectedItem = nil

local InventoryMenu = RageUI.CreateMenu("", ".", 0, 0, "avaui", "avaui_title_adezou")
InventoryMenu.Closed = function()
    InventoryData = nil

    if TargetInventory and TargetInventory.vehicle then
        -- Close vehicle trunk
        exports.ava_core:NetworkRequestControlOfEntity(TargetInventory.vehicle)
        SetVehicleDoorShut(TargetInventory.vehicle, AVAConfig.EngineInBack[GetEntityModel(TargetInventory.vehicle)] and 4 or 5, false, false)
    end
    TargetInventory = nil
end
InventoryMenu:AddInstructionButton({ GetControlGroupInstructionalButton(2, 15, 0), GetString("inventory_sort_change") })
local ItemSelectedMenu = RageUI.CreateSubMenu(InventoryMenu, "", ".", 0, 0, "avaui", "avaui_title_adezou")
ItemSelectedMenu.Closed = function()
    selectedItem = nil
end

local SortIndexes = {
    { name = "weight", label = GetString("inventory_sort_index_weight") },
    { name = "quantity", label = GetString("inventory_sort_index_quantity") },
    { name = "alpha", label = GetString("inventory_sort_index_alpha") },
    { name = "type", label = GetString("inventory_sort_index_type") },
}
local sortNotificationId = 0
local sortIndex = GetResourceKvpInt("ava_core_inventory_sort") % #SortIndexes

---Sort the inventory with the actual sorting index
---@param inventory? table|nil
local function SortInventory(inventory)
    local indexName = SortIndexes[sortIndex + 1].name

    local sortFunction = nil
    if indexName == "weight" then
        sortFunction = function(a, b)
            return a.item.total_weight > b.item.total_weight
        end

    elseif indexName == "quantity" then
        sortFunction = function(a, b)
            return a.item.quantity > b.item.quantity
        end

    elseif indexName == "alpha" then
        sortFunction = function(a, b)
            return a.item.label:lower() < b.item.label:lower()
        end

    elseif indexName == "type" then
        sortFunction = function(a, b)
            return (a.item.type or a.item.label:lower()) < (b.item.type or b.item.label:lower())
        end

    end

    if sortFunction then
        if inventory then
            -- If inventory arg, then sort it
            table.sort(inventory, sortFunction)

        else
            -- Else sort global vars
            table.sort(InventoryData.Remaining, sortFunction)
            if TargetInventory and TargetInventory.Data then
                table.sort(TargetInventory.Data.Remaining, sortFunction)
            end
        end
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

---Get item unit label
---@param item table
---@return string
local function GetItemUnit(item)
    return item.type and item.type == "liquid" and "L" or "kg"
end

---Get right label from an item and its unit
---@param item table
---@param unit string
local function GetElementRightLabel(item, unit)
    return ("%s %s - %s %s"):format(item.limit
        and ("%s/%s"):format(AVA.Utils.FormatNumber(item.quantity), item.limit)
        or AVA.Utils.FormatNumber(item.quantity),
        getQuantityUnit(item.type), formatWeight(item.total_weight), unit)
end

---Get inventory data from server and process it
local function GetDisplayableInventoryFromData(invItems, maxWeight, actualWeight, title)
    local inventory = {
        Top = {},
        Remaining = {},
        MaxWeight = maxWeight,
        ActualWeight = actualWeight
    }

    local invElementsCount = 0
    for i = 1, #invItems, 1 do
        local item = invItems[i]
        if item then
            item.total_weight = item.quantity * item.weight
            local unit = GetItemUnit(item)

            local element = {
                item = item,
                label = item.label,
                description = GetString("inventory_weight_unit", formatWeight(item.weight), unit,
                    (item.desc and item.desc ~= "") and ("\n%s"):format(item.desc) or ""),
                RightLabel = GetElementRightLabel(item, unit),
                LeftBadge = not item.noIcon and function()
                    return { BadgeDictionary = "ava_items", BadgeTexture = item.name }
                end or nil,
            }

            if AVAConfig.InventoryAlwaysDisplayedOnTop and (item.type and item.type == "money") then
                table.insert(inventory.Top, 1, element)
            else
                invElementsCount = invElementsCount + 1
                inventory.Remaining[invElementsCount] = element
            end
        end
    end

    -- Sort inventory
    if AVAConfig.InventoryAlwaysDisplayedOnTop then
        table.sort(inventory.Top, function(a, b)
            return a.item.name < b.item.name
        end)
    end
    SortInventory(inventory)

    return inventory
end

---Get inventory data and displays it
local function ReloadInventoryWithData(invItems, maxWeight, actualWeight, title)
    if not invItems then return end

    InventoryData = GetDisplayableInventoryFromData(invItems, maxWeight, actualWeight, title)

    -- InventoryMenu.Subtitle = ("%s (%s/%skg)"):format(title, formatWeight(actualWeight), formatWeight(maxWeight, 1))
    InventoryMenu.Title = title
    InventoryMenu.Subtitle = ("%s/%skg"):format(formatWeight(actualWeight), formatWeight(maxWeight, 1))
end

local function OpenMyInventory()
    if not RageUI.Visible(InventoryMenu) then
        ReloadInventoryWithData(AVA.TriggerServerCallback("ava_core:server:getInventoryItems"))

        RageUI.CloseAll()
        RageUI.Visible(InventoryMenu, true)
    end
end

---Check wether an item is in the inventory data, in case of success, return everything needed to find it back
---@param inventoryData table
---@param itemName string item name
---@return boolean wether the item is in the inventory data or not
---@return string|nil object name from inventory data
---@return integer|nil index
local function IsItemInInventoryData(inventoryData, itemName)
    for i = 1, #inventoryData.Top, 1 do
        if inventoryData.Top[i].item.name == itemName then
            return true, "Top", i
        end
    end
    for i = 1, #inventoryData.Remaining, 1 do
        if inventoryData.Remaining[i].item.name == itemName then
            return true, "Remaining", i
        end
    end
    return false
end

---Action when selecting an item
---@param item table
local function SelectItem(item)
    if TargetInventory then
        local interactionType <const> = TargetInventoryInteractions[TargetInventory.CurrentInteractionIndex or 1].type
        local interactionSucceeded = false
        local quantity = nil

        if TargetInventory.playerId then
            -- Target inventory is a player

            if interactionType == "take" then
                quantity = tonumber(AVA.KeyboardInput(GetString("inventory_take_enter_quantity", AVA.Utils.FormatNumber(item.quantity),
                    getQuantityUnit(item.type)), "", 10))
                if type(quantity) == "number" and math.floor(quantity) == quantity and quantity > 0 then
                    TriggerServerEvent("ava_core:server:takePlayerItem", TargetInventory.playerId, item.name, quantity)
                    interactionSucceeded = not WasEventCanceled()
                end

            elseif interactionType == "put" then
                quantity = tonumber(AVA.KeyboardInput(GetString("inventory_give_enter_quantity",
                    AVA.Utils.FormatNumber(item.quantity), getQuantityUnit(item.type)), "", 10))
                if type(quantity) == "number" and math.floor(quantity) == quantity and quantity > 0 then
                    TriggerServerEvent("ava_core:server:giveItem", TargetInventory.playerId, item.name, quantity)
                    interactionSucceeded = not WasEventCanceled()
                end
            end

        elseif TargetInventory.invType and TargetInventory.invName then
            -- Target inventory is a typed inventory

            if interactionType == "take" then
                quantity = tonumber(AVA.KeyboardInput(GetString("inventory_take_enter_quantity", AVA.Utils.FormatNumber(item.quantity),
                    getQuantityUnit(item.type)), "", 10))
                if type(quantity) == "number" and math.floor(quantity) == quantity and quantity > 0 then
                    TriggerServerEvent("ava_core:server:takeInventoryItem", TargetInventory.invType, TargetInventory.invName, item.name, quantity)
                    interactionSucceeded = not WasEventCanceled()
                end

            elseif interactionType == "put" then
                quantity = tonumber(AVA.KeyboardInput(GetString("inventory_put_enter_quantity",
                    AVA.Utils.FormatNumber(item.quantity), getQuantityUnit(item.type)), "", 10))
                if type(quantity) == "number" and math.floor(quantity) == quantity and quantity > 0 then
                    TriggerServerEvent("ava_core:server:putInventoryItem", TargetInventory.invType, TargetInventory.invName, item.name, quantity)
                    interactionSucceeded = not WasEventCanceled()
                end
            end
        end

        -- Interaction was successful (item taken/put)
        if interactionSucceeded then
            -- Update inventories with the added/removed quantity
            -- TODO update inventory total weight
            if interactionType == "take" then
                -- Take, we need to add to player inventory and remove from target inventory

                --#region update on take interaction
                -- Get element from target inventory
                local _isInInventoryData, _objectName, _index = IsItemInInventoryData(TargetInventory.Data, item.name)
                -- This should never return false
                if not _isInInventoryData then return end
                local targetInvElement = TargetInventory.Data[_objectName][_index]
                -- This should never be nil, but just in case
                if not targetInvElement or not targetInvElement.item then return end

                local isInInventoryData, objectName, index = IsItemInInventoryData(InventoryData, item.name)
                if isInInventoryData then
                    -- Item is in player inventory
                    local element = InventoryData[objectName][index]
                    -- This should never be nil, but just in case
                    if element and element.item then
                        -- We add the quantity to the player inventory
                        element.item.quantity = element.item.quantity + quantity
                        element.item.total_weight = element.item.quantity * item.weight
                        element.RightLabel = GetElementRightLabel(element.item, GetItemUnit(element.item))
                    end
                else
                    -- Create a copy and add it to player inventory
                    local element = {
                        item = json.decode(json.encode(targetInvElement.item)),
                        label = targetInvElement.label,
                        description = targetInvElement.description,
                        RightLabel = targetInvElement.RightLabel,
                        LeftBadge = targetInvElement.LeftBadge,
                    }
                    -- Update item data
                    element.item.quantity = quantity
                    element.item.total_weight = element.item.quantity * item.weight
                    element.RightLabel = GetElementRightLabel(element.item, GetItemUnit(element.item))

                    -- Add to player inventory
                    -- We use the same objectName as the target inventory
                    table.insert(InventoryData[_objectName], element)

                    -- Sort inventory
                    SortInventory(InventoryData[_objectName])
                end

                -- Update from target inventory
                targetInvElement.item.quantity = targetInvElement.item.quantity - quantity
                -- If new quantity is positive (or in top category), update the element
                if targetInvElement.item.quantity > 0 or _objectName == "Top" then
                    -- Should not happen, but just in case, this is related to the "Top" inventory
                    if targetInvElement.item.quantity < 0 then
                        targetInvElement.item.quantity = 0
                    end
                    targetInvElement.item.total_weight = targetInvElement.item.quantity * item.weight
                    targetInvElement.RightLabel = GetElementRightLabel(targetInvElement.item, GetItemUnit(targetInvElement.item))
                else
                    -- Else remove it
                    table.remove(TargetInventory.Data[_objectName], _index)
                end
                --#endregion update on take interaction

            elseif interactionType == "put" then
                -- Take, we need to add to target inventory and remove from player inventory

                --#region update on put interaction
                -- Get element from player inventory
                local _isInInventoryData, _objectName, _index = IsItemInInventoryData(InventoryData, item.name)
                -- This should never return false
                if not _isInInventoryData then return end
                local playerInvElement = InventoryData[_objectName][_index]
                -- This should never be nil, but just in case
                if not playerInvElement or not playerInvElement.item then return end

                local isInInventoryData, objectName, index = IsItemInInventoryData(TargetInventory.Data, item.name)
                if isInInventoryData then
                    -- Item is in target inventory
                    local element = TargetInventory.Data[objectName][index]
                    -- This should never be nil, but just in case
                    if element and element.item then
                        -- We add the quantity to the target inventory
                        element.item.quantity = element.item.quantity + quantity
                        element.item.total_weight = element.item.quantity * item.weight
                        element.RightLabel = GetElementRightLabel(element.item, GetItemUnit(element.item))
                    end
                else
                    -- Create a copy and add it to target inventory
                    local element = {
                        item = json.decode(json.encode(playerInvElement.item)),
                        label = playerInvElement.label,
                        description = playerInvElement.description,
                        RightLabel = playerInvElement.RightLabel,
                        LeftBadge = playerInvElement.LeftBadge,
                    }
                    -- Update item data
                    element.item.quantity = quantity
                    element.item.total_weight = element.item.quantity * item.weight
                    element.RightLabel = GetElementRightLabel(element.item, GetItemUnit(element.item))

                    -- Add to target inventory
                    -- We use the same objectName as the target inventory
                    table.insert(TargetInventory.Data[_objectName], element)

                    -- Sort inventory
                    SortInventory(TargetInventory.Data[_objectName])
                end

                -- Update from player inventory
                playerInvElement.item.quantity = playerInvElement.item.quantity - quantity
                -- If new quantity is positive (or in top category), update the element
                if playerInvElement.item.quantity > 0 or _objectName == "Top" then
                    -- Should not happen, but just in case, this is related to the "Top" inventory
                    if playerInvElement.item.quantity < 0 then
                        playerInvElement.item.quantity = 0
                    end
                    playerInvElement.item.total_weight = playerInvElement.item.quantity * item.weight
                    playerInvElement.RightLabel = GetElementRightLabel(playerInvElement.item, GetItemUnit(playerInvElement.item))
                else
                    -- Else  remove it
                    table.remove(InventoryData[_objectName], _index)
                end
                --#endregion update on put interaction
            end

        end
    else
        selectedItem = item
        ItemSelectedMenu.Index = 1
        ItemSelectedMenu.Subtitle = ("%s - %s %s"):format(item.label, AVA.Utils.FormatNumber(item.quantity), getQuantityUnit(item.type))
    end
end

function RageUI.PoolMenus:AvaCoreInventory()
    InventoryMenu:IsVisible(function(Items)
        local inventory = (TargetInventory and not TargetInventory.ShowMyInventory)
            and TargetInventory.Data
            or InventoryData

        if not inventory then return end

        if IsDisabledControlJustPressed(2, 207) then -- PageDown
            SetSortingIndex(sortIndex > 0 and (sortIndex - 1) or (#SortIndexes - 1))
        elseif IsDisabledControlJustPressed(2, 208) then -- PageUp
            SetSortingIndex(sortIndex < (#SortIndexes - 1) and (sortIndex + 1) or 0)
        end

        if TargetInventory then
            Items:AddList(GetString("inventory_interact"), TargetInventoryInteractions, TargetInventory.CurrentInteractionIndex or 1, nil, nil,
                function(Index, onSelected, onListChange)
                if onListChange then
                    TargetInventory.CurrentInteractionIndex = Index
                    local interactionType = TargetInventoryInteractions[TargetInventory.CurrentInteractionIndex].type
                    if interactionType == "take" then
                        TargetInventory.ShowMyInventory = false
                        InventoryMenu.Subtitle = ("%s/%skg"):format(formatWeight(TargetInventory.Data.ActualWeight), formatWeight(TargetInventory.Data.MaxWeight, 1))

                    elseif interactionType == "put" then
                        TargetInventory.ShowMyInventory = true
                        InventoryMenu.Subtitle = ("%s/%skg"):format(formatWeight(InventoryData.ActualWeight), formatWeight(InventoryData.MaxWeight, 1))

                    end
                    InventoryMenu:ResetIndex()
                end
            end)
        end

        if AVAConfig.InventoryAlwaysDisplayedOnTop and inventory.Top then
            for i = 1, #inventory.Top, 1 do
                local element = inventory.Top[i]
                if element then
                    Items:AddButton(element.label, element.description, { LeftBadge = element.LeftBadge, RightLabel = element.RightLabel }, function(onSelected)
                        if onSelected then
                            SelectItem(element.item)
                        end
                    end, not TargetInventory and ItemSelectedMenu)
                end
            end
        end

        if inventory.Remaining then
            for i = 1, #inventory.Remaining, 1 do
                local element = inventory.Remaining[i]
                if element then
                    Items:AddButton(element.label, element.description, { LeftBadge = element.LeftBadge, RightLabel = element.RightLabel }, function(onSelected)
                        if onSelected then
                            SelectItem(element.item)
                        end
                    end, not TargetInventory and ItemSelectedMenu)
                end
            end
        end
    end)

    ItemSelectedMenu:IsVisible(function(Items)
        if selectedItem.quantity > 0 and not TargetInventory then
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
            Items:AddButton(GetString("inventory_drop"), nil, { IsDisabled = AVA.Player.isInVehicle }, function(onSelected)
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
            Items:AddButton(GetString("inventory_drop_max"), GetString("inventory_drop_max_subtitle"), { IsDisabled = AVA.Player.isInVehicle },
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
    -- Do not reload anything if not the current player inventory
    if TargetInventory then return end

    if not editItem_waitingToReload and InventoryData and (RageUI.Visible(InventoryMenu) or RageUI.Visible(ItemSelectedMenu)) then
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
        if (RageUI.Visible(InventoryMenu) or RageUI.Visible(ItemSelectedMenu)) then
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
    TargetInventory = {
        invType = 0,
        playerId = targetId
    }
    TargetInventoryInteractions = { { type = "take", Name = GetString("inventory_take") }, { type = "put", Name = GetString("inventory_give") } }

    ReloadInventoryWithData(AVA.TriggerServerCallback("ava_core:server:getTargetInventoryItems", targetId))
    TargetInventory.Data = InventoryData
    InventoryData = GetDisplayableInventoryFromData(AVA.TriggerServerCallback("ava_core:server:getInventoryItems"))
    InventoryMenu:ResetIndex()
    RageUI.Visible(InventoryMenu, true)
end)

if AVAConfig.NPWD then
    exports("hasPhoneItem", function()
        -- TODO exports.npwd:setPhoneDisabled
        return exports.ava_core:TriggerServerCallback("ava_core:server:getItemQuantity", "phone") > 0
    end)
end



--#region trunks
---Get vehicle trunk size from vehicle entity
---@param veh entity
---@return integer "trunk size"
local GetVehicleTrunkSize = function(veh)
    return AVAConfig.TrunksSizes.ModelSpecific[GetEntityModel(veh)]
        or AVAConfig.TrunksSizes.ClassSpecific[GetVehicleClass(veh)]
        or 0
end


local LastActionTimer = 0
RegisterCommand("vehicletrunk", function()
    if not exports.ava_core:canOpenMenu() or GetGameTimer() - LastActionTimer < 500 then return end

    local vehicle = exports.ava_core:GetVehicleInFront()
    if vehicle == 0 then
        vehicle = exports.ava_core:GetClosestVehicle(1.5, true)
    end

    -- TODO? check if player is next to the trunk ? use AVAConfig.EngineInBack

    if vehicle > 0 then
        LastActionTimer = GetGameTimer()
        -- Vehicle is locked
        if GetVehicleDoorLockStatus(vehicle) > 1 then
            AVA.ShowNotification(GetString("vehicle_vehicle_is_locked"))
            return
        end

        -- Get trunk size
        local trunkSize = GetVehicleTrunkSize(vehicle)
        if trunkSize <= 0 then
            AVA.ShowNotification(GetString("vehicle_has_no_trunk"))
            return
        end

        -- Player animation
        local animDirectory, animName = "anim@mp_player_intmenu@key_fob@", "fob_click_fp"
        RequestAnimDict(animDirectory)
        while not HasAnimDictLoaded(animDirectory) do Wait(0) end
        TaskPlayAnim(AVA.Player.playerPed, animDirectory, animName, 8.0, 8.0, -1, 48, 1, false, false, false)
        RemoveAnimDict(animDirectory)

        -- Get trunk data
        local invType, invName, trunkItems, maxWeight, actualWeight, title = exports.ava_core:TriggerServerCallback("ava_core:server:getVehicleTrunk", VehToNet(vehicle), trunkSize)
        if not trunkItems then return end

        -- Open trunk
        exports.ava_core:NetworkRequestControlOfEntity(vehicle)
        SetVehicleDoorOpen(vehicle, AVAConfig.EngineInBack[GetEntityModel(vehicle)] and 4 or 5, false, false)

        -- Open inventory
        RageUI.CloseAll()
        InventoryType, InventoryName = invType, invName
        TargetInventory = {
            vehicle = vehicle,
            invType = tonumber(invType),
            invName = invName,
        }
        TargetInventoryInteractions = { { type = "take", Name = GetString("inventory_take") }, { type = "put", Name = GetString("inventory_put") } }

        ReloadInventoryWithData(trunkItems, maxWeight, actualWeight, title)
        TargetInventory.Data = InventoryData
        InventoryData = GetDisplayableInventoryFromData(AVA.TriggerServerCallback("ava_core:server:getInventoryItems"))
        InventoryMenu:ResetIndex()
        RageUI.Visible(InventoryMenu, true)
    end
end)
RegisterKeyMapping("vehicletrunk", GetString("vehicle_trunk"), "keyboard", AVAConfig.TrunkKey)



--#endregion trunks
