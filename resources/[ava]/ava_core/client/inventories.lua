-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local InventoryElements, InventoryTopElements = {}, {}

local InventoryMenu = RageUI.CreateMenu("", ".", 0, 0, "avaui", "avaui_title_adezou")
InventoryMenu:AddInstructionButton({GetControlGroupInstructionalButton(2, 15, 0), "Changer de tri"})



local SortIndexes = {
    { name = "weight", label = "poids" },
    { name = "quantity", label = "quantité" },
    { name = "alpha", label = "ordre alphabétique" },
    { name = "type", label = "type" }
}
local sortNotificationId = 0
local sortIndex = GetResourceKvpInt("ava_core_inventory_sort")

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
            return a.item.label:lower() > b.item.label:lower()
        end)

    elseif indexName == "type" then
        table.sort(InventoryElements, function(a, b)
            return (a.item.type or a.item.label:lower()) > (b.item.type or b.item.label:lower())
        end)

    end
end

local function SetSortingIndex(index)
    sortIndex = index % #SortIndexes
    SetResourceKvpInt("ava_core_inventory_sort", sortIndex)

    if sortNotificationId ~= -1 then
        -- remove old notification of sorter to only show the actual sorting label
        ThefeedRemoveItem(sortNotificationId)
    end
    sortNotificationId = AVA.ShowNotification(nil, nil, "ava_core_logo", "Inventaire", ("Trié par ~y~%s~s~."):format(SortIndexes[sortIndex + 1].label), nil, "ava_core_logo")

    SortInventory()
end

local function ReloadInventoryData()
    local invItems, maxWeight, actualWeight, title = AVA.TriggerServerCallback("ava_core:server:getInventoryItems")
    -- dprint(json.encode(invItems, { indent = true }), maxWeight, actualWeight, title)

    InventoryElements, InventoryTopElements = {}, {}
    local invElementsCount = 0

    for i = 1, #invItems, 1 do
        local item = invItems[i]
        if item then
            item.total_weight = item.quantity * item.weight
            local unit = item.type
                and item.type == "liquid" and "L"
                or "kg"

            local element = {
                item = item,
                label = item.label,
                description = ("Poids unité : %." .. (item.weight < 10 and "3" or "2") .. "f %s%s"):format(item.weight / 1000, unit, item.desc and ("\n%s"):format(item.desc) or ""),
                RightLabel = ("%s %s - %s %s"):format(
                    item.limit
                        and ("%s/%s"):format(item.quantity, item.limit)
                        or tostring(item.quantity),
                    item.type and item.type == "money" and "$" or "u.",
                    string.format("%.1f", item.total_weight / 1000),
                    unit
                ),
                LeftBadge = not item.noIcon and function() return {BadgeDictionary = "ava_items", BadgeTexture = item.name} end or nil
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


    InventoryMenu.Subtitle = ("%s (%s/%skg)"):format(title, string.format("%.3f", actualWeight / 1000), string.format("%.1f", maxWeight / 1000))
end

local function OpenMyInventory()
    if not RageUI.Visible(InventoryMenu) then
        ReloadInventoryData()

        RageUI.CloseAll()
        RageUI.Visible(InventoryMenu, true)
    end
end

local function SelectItem(item)
    dprint(item.name)
end

function RageUI.PoolMenus:AvaCoreInventory()
	InventoryMenu:IsVisible(function(Items)
        if IsDisabledControlJustPressed(2, 207) then -- PageDown
            SetSortingIndex(sortIndex > 0 and (sortIndex - 1) or (#SortIndexes - 1))
        elseif IsDisabledControlJustPressed(2, 208) then -- PageUp
            SetSortingIndex(sortIndex < (#SortIndexes - 1) and (sortIndex + 1) or 0)
        end

        if AVAConfig.InventoryMoneyOnTop then
            for i = 1, #InventoryTopElements, 1 do
                local element = InventoryTopElements[i]
                Items:AddButton(element.label, element.description, { LeftBadge = element.LeftBadge, RightLabel = element.RightLabel }, function(onSelected)
                    if onSelected then
                        SelectItem(element.item)
                    end
                end)
            end
        end

        for i = 1, #InventoryElements, 1 do
            local element = InventoryElements[i]
            Items:AddButton(element.label, element.description, { LeftBadge = element.LeftBadge, RightLabel = element.RightLabel }, function(onSelected)
                if onSelected then
                    SelectItem(element.item)
                end
            end)
        end
    end)
end

RegisterCommand('+keyInventory', function()
	OpenMyInventory()
end)

RegisterKeyMapping('+keyInventory', 'Inventaire', 'keyboard', AVAConfig.InventoryKey)