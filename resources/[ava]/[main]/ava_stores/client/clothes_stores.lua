-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function ClothesStore()
    local store = Config.Stores[CurrentZoneName]

    OpenClothesMenu(store.SkinElements, store.Subtitle, store.Title.textureName, store.Title.textureDirectory)
end

local validateChanges = false
local validateButtonRightLabel = nil
local menuElements = nil
local MainClothesMenu = RageUI.CreateMenu("", GetString("clothes_menu"), 0, 0, "avaui", "avaui_title_adezou")
MainClothesMenu.Closable = false
MainClothesMenu.Closed = function()
    print("menu closed, validate changes: " .. (validateChanges and "true" or "false"))

    if CurrentZoneName then
        CurrentActionEnabled = true
    end
end

function OpenClothesMenu(elements, menuName, titleTexture, titleTextureDirectory)
    RageUI.CloseAll()
    MainClothesMenu.Sprite.Dictionary = titleTextureDirectory or "avaui"
    MainClothesMenu.Sprite.Texture = titleTexture or "avaui_title_adezou"
    MainClothesMenu.Subtitle = menuName or GetString("clothes_menu")

    if type(elements) == "table" then
        menuElements = {}
        for i = 1, #elements do
            menuElements[elements[i]] = true
        end
    else
        menuElements = nil
    end

    validateButtonRightLabel = nil
    if CurrentZoneName then
        local store = Config.Stores[CurrentZoneName]

        if store.Price then
            validateButtonRightLabel = GetString("clothes_menu_validate_right_label_money", store.Price)
        end
    end
    validateChanges = false
    RageUI.Visible(MainClothesMenu, true)
end
RegisterNetEvent("ava_jobs:client:OpenClothesMenu", OpenClothesMenu)

function RageUI.PoolMenus:ClothesMenu()
    MainClothesMenu:IsVisible(function(Items)
        DisableControlAction(0, 24, true) -- INPUT_ATTACK
        DisableControlAction(0, 25, true) -- INPUT_AIM
        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
        DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
        DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE

        if not menuElements or menuElements.undershirt then
            Items:AddButton("WIP undershirt", nil, {}, nil)
        end
        if not menuElements or menuElements.hair then
            Items:AddButton("WIP hair", nil, {}, nil)
        end
        if not menuElements or menuElements.mask then
            Items:AddButton("WIP mask", nil, {}, nil)
        end

        Items:AddButton(GetString("clothes_menu_cancel"), GetString("clothes_menu_cancel_subtitle"), {}, function(onSelected)
            if onSelected then
                RageUI.CloseAllInternal()
            end
        end)
        Items:AddButton(GetString("clothes_menu_validate"), GetString("clothes_menu_validate_subtitle"), {
            Color = {BackgroundColor = RageUI.ItemsColour.MenuYellow, HighLightColor = RageUI.ItemsColour.PmMitemHighlight},
            RightLabel = validateButtonRightLabel,
        }, function(onSelected)
            if onSelected then
                validateChanges = true
                RageUI.CloseAllInternal()
            end
        end)

    end, function(Panels)

    end)
end

