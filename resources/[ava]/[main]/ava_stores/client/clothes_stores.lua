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
local SavePlayerSkin = nil
local PlayerSkin = nil
local MenuIndices = nil
local SkinMaxVals = nil
local MainClothesMenu = RageUI.CreateMenu("", GetString("clothes_menu"), 0, 0, "avaui", "avaui_title_adezou")
MainClothesMenu.Closable = false
MainClothesMenu.Closed = function()
    print("menu closed, validate changes: " .. (validateChanges and "true" or "false"))

    if CurrentZoneName then
        CurrentActionEnabled = true
    end
    -- Reset player skin to original
    exports.ava_mp_peds:setPlayerSkin(SavePlayerSkin)
    SavePlayerSkin = nil
    PlayerSkin = nil
    MenuIndices = nil
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if SavePlayerSkin then
            exports.ava_mp_peds:setPlayerSkin(SavePlayerSkin)
        end
    end
end)

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

    -- Init elements used to display the menu
    MenuIndices = {}
    SavePlayerSkin = exports.ava_mp_peds:getPlayerCurrentSkin()
    PlayerSkin = {}
    for k, v in pairs(SavePlayerSkin) do
        PlayerSkin[k] = v
    end
    SkinMaxVals = exports.ava_mp_peds:getMaxValues()
    validateButtonRightLabel = nil

    -- If is inside a shop
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

-- #region menu list stuff
local gendersList<const> = {GetString("cm_male"), GetString("cm_female")}
local MotherListId<const> = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45}
local FatherListId<const> = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44}

-- #endregion menu list stuff

function RageUI.PoolMenus:ClothesMenu()
    MainClothesMenu:IsVisible(function(Items)
        DisableControlAction(0, 24, true) -- INPUT_ATTACK
        DisableControlAction(0, 25, true) -- INPUT_AIM
        DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
        DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
        DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE

        -- TODO reorder elements when all of them work

        if not menuElements or menuElements.gender then
            Items:AddList(GetString("cm_gender"), gendersList, PlayerSkin.gender + 1, nil, {}, function(Index, onSelected, onListChange)
                if (onListChange) then
                    PlayerSkin = exports.ava_mp_peds:setPlayerSkin({gender = Index - 1})
                    SkinMaxVals = exports.ava_mp_peds:getMaxValues()
                end
            end)

            Items:AddList(GetString("cm_mother"), SkinMaxVals.mother + 1, PlayerSkin.mother + 1, GetString("cm_mother_subtitle"), {},
                function(Index, onSelected, onListChange)
                    if onListChange then
                        PlayerSkin = exports.ava_mp_peds:setPlayerSkin({mother = Index - 1})
                    end
                end)
            Items:AddList(GetString("cm_father"), SkinMaxVals.father + 1, PlayerSkin.father + 1, GetString("cm_father_subtitle"), {},
                function(Index, onSelected, onListChange)
                    if onListChange then
                        PlayerSkin = exports.ava_mp_peds:setPlayerSkin({father = Index - 1})
                    end
                end)
            Items:SliderHeritage(GetString("cm_resemblance"), PlayerSkin.shape_mix / 5, GetString("cm_resemblance_subtitle"),
                function(Selected, Active, OnListChange, SliderIndex, Percent)
                    if OnListChange then
                        PlayerSkin = exports.ava_mp_peds:setPlayerSkin({shape_mix = Percent})
                    end
                end)
            Items:SliderHeritage(GetString("cm_skin_tone"), PlayerSkin.skin_mix / 5, GetString("cm_skin_tone_subtitle"),
                function(Selected, Active, OnListChange, SliderIndex, Percent)
                    if OnListChange then
                        PlayerSkin = exports.ava_mp_peds:setPlayerSkin({skin_mix = Percent})
                    end
                end)
        end

        if not menuElements or menuElements.nose then
            Items:AddButton("TODO nose", nil, {}, nil) -- TODO
            -- nose_width
            -- nose_peak_hight
            -- nose_peak_lenght
            -- nose_bone_high
            -- nose_peak_lowering
            -- nose_bone_twist
        end
        if not menuElements or menuElements.eyebrown then
            Items:AddButton("TODO eyebrown", nil, {}, nil) -- TODO
            -- eyebrown_high
            -- eyebrown_forward
        end
        if not menuElements or menuElements.cheeks then
            Items:AddButton("TODO cheeks", nil, {}, nil) -- TODO
            -- cheeks_bone_high
            -- cheeks_bone_width
            -- cheeks_width
        end
        if not menuElements or menuElements.eyes then
            Items:AddButton("TODO eyes", nil, {}, nil) -- TODO
            -- eyes_openning
        end
        if not menuElements or menuElements.lips then
            Items:AddButton("TODO lips", nil, {}, nil) -- TODO
            -- lips_thickness
        end
        if not menuElements or menuElements.jaw then
            Items:AddButton("TODO jaw", nil, {}, nil) -- TODO
            -- jaw_bone_width
            -- jaw_bone_back_lenght
        end
        if not menuElements or menuElements.chin then
            Items:AddButton("TODO chin", nil, {}, nil) -- TODO
            -- chin_bone_lowering
            -- chin_bone_lenght
            -- chin_bone_width
            -- chin_hole
        end
        if not menuElements or menuElements.neck then
            Items:AddButton("TODO neck", nil, {}, nil) -- TODO
            -- neck_thickness
        end

        if not menuElements or menuElements.hair then
            Items:AddButton("TODO hair", nil, {}, nil) -- TODO
        end
        if not menuElements or menuElements.beard then
            Items:AddButton("TODO beard", nil, {}, nil) -- TODO
            -- beard
            -- beard_op
            -- beard_color
        end
        if not menuElements or menuElements.eyebrows then
            Items:AddButton("TODO eyebrows", nil, {}, nil) -- TODO
            -- eyebrows
            -- eyebrows_op
            -- eyebrows_color
        end
        if not menuElements or menuElements.chesthair then
            Items:AddButton("TODO chesthair", nil, {}, nil) -- TODO
            -- chesthair
            -- chesthair_op
            -- chesthair_main_color
        end
        if not menuElements or menuElements.eyes_color then
            Items:AddButton("TODO eyes_color", nil, {}, nil) -- TODO
            -- eyes_color
        end
        if not menuElements or menuElements.ageing then
            Items:AddButton("TODO ageing", nil, {}, nil) -- TODO
            -- ageing
            -- ageing_op
        end
        if not menuElements or menuElements.makeup then
            Items:AddButton("TODO makeup", nil, {}, nil) -- TODO
            -- makeup
            -- makeup_op
            -- makeup_main_color
            -- makeup_scnd_color
        end
        if not menuElements or menuElements.lipstick then
            Items:AddButton("TODO lipstick", nil, {}, nil) -- TODO
            -- lipstick
            -- lipstick_op
            -- lipstick_main_color
            -- lipstick_scnd_color
        end
        if not menuElements or menuElements.blush then
            Items:AddButton("TODO blush", nil, {}, nil) -- TODO
            -- blush
            -- blush_op
            -- blush_main_color
        end
        if not menuElements or menuElements.complexion then
            Items:AddButton("TODO complexion", nil, {}, nil) -- TODO
            -- complexion
            -- complexion_op
        end
        if not menuElements or menuElements.sundamage then
            Items:AddButton("TODO sundamage", nil, {}, nil) -- TODO
            -- sundamage
            -- sundamage_op
        end
        if not menuElements or menuElements.moles then
            Items:AddButton("TODO moles", nil, {}, nil) -- TODO
            -- moles
            -- moles_op
        end
        if not menuElements or menuElements.bodyblemishes then
            Items:AddButton("TODO bodyblemishes", nil, {}, nil) -- TODO
            -- bodyblemishes
            -- bodyblemishes_op
        end
        if not menuElements or menuElements.addbodyblemishes then
            Items:AddButton("TODO addbodyblemishes", nil, {}, nil) -- TODO
            -- addbodyblemishes
            -- addbodyblemishes_op
        end

        if not menuElements or menuElements.mask then
            Items:AddButton("TODO mask", nil, {}, nil) -- TODO
            -- mask
            -- mask_txd
        end
        if not menuElements or menuElements.torso then
            Items:AddButton("TODO torso", nil, {}, nil) -- TODO
            -- torso
            -- torso_txd
        end
        if not menuElements or menuElements.leg then
            Items:AddButton("TODO leg", nil, {}, nil) -- TODO
            -- leg
            -- leg_txd
        end
        if not menuElements or menuElements.bag then
            Items:AddButton("TODO bag", nil, {}, nil) -- TODO
            -- bag
            -- bag_txd
        end
        if not menuElements or menuElements.shoes then
            Items:AddButton("TODO shoes", nil, {}, nil) -- TODO
            -- shoes
            -- shoes_txd
        end
        if not menuElements or menuElements.accessory then
            Items:AddButton("TODO accessory", nil, {}, nil) -- TODO
            -- accessory
            -- accessory_txd
        end
        if not menuElements or menuElements.undershirt then
            Items:AddButton("TODO undershirt", nil, {}, nil) -- TODO
            -- undershirt
            -- undershirt_txd
        end
        if not menuElements or menuElements.bodyarmor then
            Items:AddButton("TODO bodyarmor", nil, {}, nil) -- TODO
            -- bodyarmor
            -- bodyarmor_txd
        end
        if not menuElements or menuElements.decals then
            Items:AddButton("TODO decals", nil, {}, nil) -- TODO
            -- decals
            -- decals_txd
        end
        if not menuElements or menuElements.tops then
            Items:AddButton("TODO tops", nil, {}, nil) -- TODO
            -- tops
            -- tops_txd
        end
        if not menuElements or menuElements.hats then
            Items:AddButton("TODO hats", nil, {}, nil) -- TODO
            -- hats
            -- hats_txd
        end
        if not menuElements or menuElements.glasses then
            Items:AddButton("TODO glasses", nil, {}, nil) -- TODO
            -- glasses
            -- glasses_txd
        end
        if not menuElements or menuElements.ears then
            Items:AddButton("TODO ears", nil, {}, nil) -- TODO
            -- ears
            -- ears_txd
        end
        if not menuElements or menuElements.watches then
            Items:AddButton("TODO watches", nil, {}, nil) -- TODO
            -- watches
            -- watches_txd
        end
        if not menuElements or menuElements.bracelets then
            Items:AddButton("TODO bracelets", nil, {}, nil) -- TODO
            -- bracelets
            -- bracelets_txd
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

