-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- local functions
local setCurrentTattoosDlc, prepareTattoosMenu, InsideOfClothesMenuControls, CloseClothesMenu, OpenClothesMenu, AddMenuCam, SetCamCoords, RemoveMenuCam,
    HideSkinElementsOnItem

function ClothesStore()
    local store = Config.Stores[CurrentZoneName]
    if not store then
        return
    end

    local hasEnoughMoney<const> = exports.ava_core:TriggerServerCallback("ava_stores:server:clothesStore:checkMoney", CurrentZoneName)
    if not hasEnoughMoney then
        exports.ava_core:ShowNotification(GetString("cant_afford"))
        CurrentActionEnabled = true
    else
        OpenClothesMenu(store.SkinElements, store.Subtitle, store.Title.textureName, store.Title.textureDirectory)
    end
end

local playerPed = nil

-- Camera vars
local camVerticalOffset = 0.0
local camHorizontalOffset = 0.0
local camMaxVertical = 0.0
local camMinVertical = 0.0
-- Menu things
local playerChangedGender = false -- Used to restor player weapons if gender changed
local validateChanges = false
local validateButtonRightLabel = nil
local menuElements = nil
local MenuNeededValues = nil
local MenuItemIndices = nil
local lastElementsIndexToHide = nil
local lastTattooToApply = nil

-- Player skin
local SavePlayerSkin = nil
local PlayerSkin = nil
local SkinMaxVals = nil
local SkinMinVals = nil

local MainClothesMenu = RageUI.CreateMenu("", GetString("clothes_menu"), 0, 0, "avaui", "avaui_title_adezou")
MainClothesMenu.Closable = false
MainClothesMenu:AddInstructionButton({GetControlInstructionalButton(0, 140, true), GetString("cm_reset_to_min")})
MainClothesMenu:AddInstructionButton({GetControlInstructionalButton(0, 26, true), GetString("cm_toggle_cam")})
MainClothesMenu.Closed = function()
    CloseClothesMenu()

    -- If did not validate, or do not have enough money, revert changes
    if not validateChanges or not exports.ava_core:TriggerServerCallback("ava_stores:server:clothesStore:payClothes", CurrentZoneName, PlayerSkin) then
        -- Reset player skin to original
        exports.ava_mp_peds:setPlayerSkin(SavePlayerSkin)
    end
    SavePlayerSkin = nil
    PlayerSkin = nil
    SkinMaxVals = nil
    SkinMinVals = nil
    MenuNeededValues = nil
    MenuItemIndices = nil
    if CurrentZoneName then
        CurrentActionEnabled = true
    end
end

local TattoosMenu = RageUI.CreateSubMenu(MainClothesMenu, "", GetString("tattoos_menu"), 0, 0, "avaui", "avaui_title_adezou")
-- TattoosMenu.Closable = false
TattoosMenu:AddInstructionButton({GetControlInstructionalButton(0, 26, true), GetString("cm_toggle_cam")})
TattoosMenu.Closed = function()
    lastTattooToApply = nil
    exports.ava_mp_peds:reloadPedOverlays(playerPed)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if SavePlayerSkin then
            CloseClothesMenu()
            exports.ava_mp_peds:setPlayerSkin(SavePlayerSkin)
        end
    end
end)

function CloseClothesMenu()
    playerPed = PlayerPedId()
    -- Restore hidden skin elements
    HideSkinElementsOnItem()

    RemoveMenuCam()
    SetEntityVelocity(playerPed, 1.0, 1.0, 1.0)
    SetPedGravity(playerPed, 1.0, 1.0, 1.0)

    if playerChangedGender then
        TriggerServerEvent("ava_core:server:reloadLoadout")
    end
end

function OpenClothesMenu(elements, menuName, titleTexture, titleTextureDirectory)
    RageUI.CloseAll()
    MainClothesMenu.Sprite.Dictionary = titleTextureDirectory or "avaui"
    MainClothesMenu.Sprite.Texture = titleTexture or "avaui_title_adezou"
    MainClothesMenu.Subtitle = menuName or GetString("clothes_menu")
    TattoosMenu.Sprite.Dictionary = titleTextureDirectory or "avaui"
    TattoosMenu.Sprite.Texture = titleTexture or "avaui_title_adezou"
    TattoosMenu.Subtitle = menuName or GetString("clothes_menu")

    if type(elements) == "table" then
        menuElements = {}
        for i = 1, #elements do
            menuElements[elements[i]] = true
        end
    else
        menuElements = nil
    end

    -- Init elements used to display the menu
    MenuNeededValues = {}
    MenuItemIndices = {}
    -- Get player current skin for the save
    SavePlayerSkin = exports.ava_mp_peds:getPlayerCurrentSkin()
    -- Get player skin saved from core, this one should be the same than the database
    PlayerSkin = exports.ava_core:getPlayerSkinData()
    -- Apply player skin in case of a modified values
    exports.ava_mp_peds:setPlayerSkin(PlayerSkin)
    playerPed = PlayerPedId()
    -- Get min and max vals
    SkinMinVals = exports.ava_mp_peds:getMinValues()
    SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)

    validateButtonRightLabel = nil
    camVerticalOffset = Config.ClothesStore.DefaultCamVerticalOffset
    camHorizontalOffset = 0.0
    camMaxVertical = Config.ClothesStore.MaxCamVerticalOffset
    camMinVertical = Config.ClothesStore.MinCamVerticalOffset
    -- If is inside a shop
    if CurrentZoneName then
        local store = Config.Stores[CurrentZoneName]

        if type(store.MaxCamVerticalOffset) == "number" and store.MaxCamVerticalOffset > camMinVertical and store.MaxCamVerticalOffset < camMaxVertical then
            camMaxVertical = store.MaxCamVerticalOffset + 0.0
        end
        if type(store.MinCamVerticalOffset) == "number" and store.MinCamVerticalOffset > camMinVertical and store.MinCamVerticalOffset < camMaxVertical then
            camMinVertical = store.MinCamVerticalOffset + 0.0
        end
        if type(store.DefaultCamVerticalOffset) == "number" and store.DefaultCamVerticalOffset > camMinVertical and store.DefaultCamVerticalOffset
            < camMaxVertical then
            camVerticalOffset = store.DefaultCamVerticalOffset + 0.0
        end
        if store.Price then
            validateButtonRightLabel = GetString("clothes_menu_validate_right_label_money", store.Price)
        end
    end
    -- If needed, prepare tattoos menu
    if not menuElements or menuElements.tattoos then
        prepareTattoosMenu()
    end

    validateChanges = false
    playerChangedGender = false
    if IsPedArmed(playerPed, 7) then -- 7 == 4 | 2 | 1
        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
    end
    AddMenuCam()
    RageUI.Visible(MainClothesMenu, true)
end
RegisterNetEvent("ava_jobs:client:OpenClothesMenu", OpenClothesMenu)

-- #region cam stuff
local cam = nil
local camInstructionalButton<const> = {GetControlGroupInstructionalButton(0, 25, 0), GetString("cm_move_cam")}
function AddMenuCam()
    MainClothesMenu:AddInstructionButton(camInstructionalButton)
    MainClothesMenu.EnableMouse = true

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoords()

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
end

local cos = math.cos
local sin = math.sin
function SetCamCoords()
    local playerCoords<const> = GetEntityCoords(playerPed)
    local offsetCoords<const> = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.7, 0.0)
    local coordX<const> = playerCoords.x + (offsetCoords.x - playerCoords.x) * cos(camHorizontalOffset) - (offsetCoords.y - playerCoords.y)
                              * sin(camHorizontalOffset)

    local coordY<const> = playerCoords.y + (offsetCoords.x - playerCoords.x) * sin(camHorizontalOffset) + (offsetCoords.y - playerCoords.y)
                              * cos(camHorizontalOffset)

    SetCamCoord(cam, coordX, coordY, playerCoords.z + (camVerticalOffset < -0.7 and -0.7 or camVerticalOffset))
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + (camVerticalOffset > 0.7 and 0.7 or camVerticalOffset) - 0.05)
end

function RemoveMenuCam()
    MainClothesMenu:RemoveInstructionButton(camInstructionalButton)
    MainClothesMenu.EnableMouse = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end
-- #endregion cam stuff

-- #region skin modification based on current element
local savedSkinElements = nil
---Hide elements on certain menu items, ex: hide hats on hair menu
---@param index number "start at 1"
function HideSkinElementsOnItem(index)
    -- Restor player skin
    if savedSkinElements then
        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, savedSkinElements)
        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
        savedSkinElements = nil
    end

    -- Check if a save is needed based on current index
    if index ~= nil and Config.ClothesStore.ElementsHiddenOnItems and Config.ClothesStore.ElementsHiddenOnItems[index]
        and Config.ClothesStore.ElementsHiddenOnItems[index][PlayerSkin.gender] then
        savedSkinElements = {}
        for elementName, _ in pairs(Config.ClothesStore.ElementsHiddenOnItems[index][PlayerSkin.gender]) do
            savedSkinElements[elementName] = PlayerSkin[elementName]
        end
        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, Config.ClothesStore.ElementsHiddenOnItems[index][PlayerSkin.gender])
        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
    end
end
-- #endregion skin modification based on current element

-- #region menu list stuff
local gendersList<const> = {GetString("cm_male"), GetString("cm_female")}
local tattoosDLCList = nil
local tattoosZonesList = nil
-- #endregion menu list stuff
function setCurrentTattoosDlc(index)
    MenuNeededValues.currentTattooCollection = Config.ClothesStore.Tattoos[tostring(PlayerSkin.gender)][index]
    MenuNeededValues.tattooZoneIndex = 1
    tattoosZonesList = {}
    local count = 0
    for zoneName, _ in pairs(MenuNeededValues.currentTattooCollection.Zones) do
        count = count + 1
        tattoosZonesList[count] = {Name = GetString("cm_t_" .. zoneName), zoneName = zoneName}
    end
    table.sort(tattoosZonesList, function(a, b)
        return a.zoneName < b.zoneName
    end)

    -- get current player tattoos to display them as possessed
    MenuNeededValues.currentCollectionAppliedTattoos = {}
    for i = 1, #PlayerSkin.tattoos do
        if PlayerSkin.tattoos[i].collection == MenuNeededValues.currentTattooCollection.name then
            MenuNeededValues.currentCollectionAppliedTattoos[PlayerSkin.tattoos[i].overlay] = true
        end
    end
end

function prepareTattoosMenu()
    local tattoos = Config.ClothesStore.Tattoos[tostring(PlayerSkin.gender)]
    tattoosDLCList = {}
    local count = 0
    for i = 1, #tattoos do
        if tattoos[i].name then
            count = count + 1
            tattoosDLCList[count] = {Name = GetString("cm_t_" .. tattoos[i].name), index = i}
        end
    end

    -- Init to first dlc
    setCurrentTattoosDlc(tattoosDLCList[1].index)
end

function InsideOfClothesMenuControls()
    ClearPedTasks(playerPed)

    -- Prevent player from moving too far
    SetEntityVelocity(playerPed, 0.0, 0.0, 0.0)
    SetPedGravity(playerPed, 0.0, 0.0, 0.0)

    DisableControlAction(0, 24, true) -- INPUT_ATTACK
    DisableControlAction(0, 25, true) -- INPUT_AIM
    DisableControlAction(0, 26, true) -- INPUT_LOOK_BEHIND
    DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
    DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
    DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE

    DisableControlAction(0, 16, true) -- INPUT_SELECT_NEXT_WEAPON
    DisableControlAction(0, 17, true) -- INPUT_SELECT_PREV_WEAPON
    DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
    -- DisableControlAction(0, 157, true) -- INPUT_SELECT_WEAPON_UNARMED
    DisableControlAction(0, 158, true) -- INPUT_SELECT_WEAPON_MELEE
    DisableControlAction(0, 159, true) -- INPUT_SELECT_WEAPON_HANDGUN
    DisableControlAction(0, 160, true) -- INPUT_SELECT_WEAPON_SHOTGUN
    DisableControlAction(0, 161, true) -- INPUT_SELECT_WEAPON_SMG
    DisableControlAction(0, 162, true) -- INPUT_SELECT_WEAPON_AUTO_RIFLE
    DisableControlAction(0, 163, true) -- INPUT_SELECT_WEAPON_SNIPER
    DisableControlAction(0, 164, true) -- INPUT_SELECT_WEAPON_HEAVY
    DisableControlAction(0, 165, true) -- INPUT_SELECT_WEAPON_SPECIAL

    -- Toggle cam
    if IsDisabledControlJustReleased(0, 26) then
        if cam then
            RemoveMenuCam()
        else
            AddMenuCam()
        end
    end

    -- Cam is on? allow the user to move the cam
    if cam then
        DisableControlAction(0, 108, true) -- INPUT_VEH_FLY_ROLL_LEFT_ONLY left
        DisableControlAction(0, 109, true) -- INPUT_VEH_FLY_ROLL_RIGHT_ONLY right
        DisableControlAction(0, 110, true) -- INPUT_VEH_FLY_PITCH_UD down
        DisableControlAction(0, 111, true) -- INPUT_VEH_FLY_PITCH_UP_ONLY up

        if IsDisabledControlPressed(0, 111) and camVerticalOffset < camMaxVertical then
            camVerticalOffset = camVerticalOffset + 0.01
            SetCamCoords()
        elseif IsDisabledControlPressed(0, 110) and camVerticalOffset > camMinVertical then
            camVerticalOffset = camVerticalOffset - 0.01
            SetCamCoords()
        end

        if IsDisabledControlPressed(0, 109) then
            camHorizontalOffset = camHorizontalOffset + 0.02
            SetCamCoords()
        elseif IsDisabledControlPressed(0, 108) then
            camHorizontalOffset = camHorizontalOffset - 0.02
            SetCamCoords()
        end
    end
end

function RageUI.PoolMenus:ClothesMenu()
    MainClothesMenu:IsVisible(function(Items)
        local elementsIndexToHide = nil
        InsideOfClothesMenuControls()

        local resetElement<const> = IsDisabledControlJustReleased(0, 140)

        -- #region elements
        if not menuElements or menuElements.gender then
            Items:AddList(GetString("cm_gender"), gendersList, PlayerSkin.gender + 1, GetString("cm_gender_subtitle"), {},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {gender = resetElement and SkinMinVals.gender or (Index - 1)})
                        playerPed = PlayerPedId()
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)

                        -- Used to restore weapons
                        playerChangedGender = true
                    end
                end)

            Items:AddList(GetString("cm_mother"), SkinMaxVals.mother + 1, PlayerSkin.mother + 1, GetString("cm_mother_subtitle"), {},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {mother = resetElement and SkinMinVals.mother or (Index - 1)})
                    end
                end)
            Items:AddList(GetString("cm_father"), SkinMaxVals.father + 1, PlayerSkin.father + 1, GetString("cm_father_subtitle"), {},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {father = resetElement and SkinMinVals.father or (Index - 1)})
                    end
                end)
            Items:SliderHeritage(GetString("cm_resemblance"), PlayerSkin.shape_mix / 5, GetString("cm_resemblance_subtitle"),
                function(Selected, Active, onListChange, SliderIndex, Percent)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {shape_mix = resetElement and SkinMinVals.shape_mix or Percent})
                    end
                end)
            Items:SliderHeritage(GetString("cm_skin_tone"), PlayerSkin.skin_mix / 5, GetString("cm_skin_tone_subtitle"),
                function(Selected, Active, onListChange, SliderIndex, Percent)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {skin_mix = resetElement and SkinMinVals.skin_mix or Percent})
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
            -- elementsIndexToHide = 1 -- Head
        end
        if not menuElements or menuElements.eyebrown then
            Items:AddButton("TODO eyebrown", nil, {}, nil) -- TODO
            -- eyebrown_high
            -- eyebrown_forward
            -- elementsIndexToHide = 1 -- Head
        end
        if not menuElements or menuElements.cheeks then
            Items:AddButton("TODO cheeks", nil, {}, nil) -- TODO
            -- cheeks_bone_high
            -- cheeks_bone_width
            -- cheeks_width
            -- elementsIndexToHide = 1 -- Head
        end
        if not menuElements or menuElements.eyes then
            Items:AddButton("TODO eyes", nil, {}, nil) -- TODO
            -- eyes_openning
            -- elementsIndexToHide = 1 -- Head
        end
        if not menuElements or menuElements.lips then
            Items:AddButton("TODO lips", nil, {}, nil) -- TODO
            -- lips_thickness
            -- elementsIndexToHide = 1 -- Head
        end
        if not menuElements or menuElements.jaw then
            Items:AddButton("TODO jaw", nil, {}, nil) -- TODO
            -- jaw_bone_width
            -- jaw_bone_back_lenght
            -- elementsIndexToHide = 1 -- Head
        end
        if not menuElements or menuElements.chin then
            Items:AddButton("TODO chin", nil, {}, nil) -- TODO
            -- chin_bone_lowering
            -- chin_bone_lenght
            -- chin_bone_width
            -- chin_hole
            -- elementsIndexToHide = 1 -- Head
        end
        if not menuElements or menuElements.neck then
            Items:AddButton("TODO neck", nil, {}, nil) -- TODO
            -- neck_thickness
            -- elementsIndexToHide = 1 -- Head
        end

        if not menuElements or menuElements.hair then
            MenuItemIndices.hair = Items:AddList(GetString("cm_hair"), SkinMaxVals.hair + 1, PlayerSkin.hair + 1, GetString("cm_hair_subtitle"),
                {Min = SkinMinVals.hair + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed,
                            {hair = resetElement and SkinMinVals.hair or (Index - 1), hair_txd = SkinMinVals.hair_txd})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_hair_txd"), SkinMaxVals.hair_txd + 1, PlayerSkin.hair_txd + 1, GetString("cm_hair_txd_subtitle"),
                {Min = SkinMinVals.hair_txd + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {hair_txd = resetElement and SkinMinVals.hair_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.beard then
            MenuItemIndices.beard = Items:AddList(GetString("cm_beard"), SkinMaxVals.beard + 1, PlayerSkin.beard + 1, GetString("cm_beard_subtitle"),
                {Min = SkinMinVals.beard + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {
                            beard = resetElement and SkinMinVals.beard or (Index - 1),
                            beard_txd = SkinMinVals.beard_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.eyebrows then
            MenuItemIndices.eyebrows = Items:AddList(GetString("cm_eyebrows"), SkinMaxVals.eyebrows + 1, PlayerSkin.eyebrows + 1,
                GetString("cm_eyebrows_subtitle"), {Min = SkinMinVals.eyebrows + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {
                            eyebrows = resetElement and SkinMinVals.eyebrows or (Index - 1),
                            eyebrows_txd = SkinMinVals.eyebrows_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.eyes_color then
            Items:AddList(GetString("cm_eyes_color_txd"), SkinMaxVals.eyes_color + 1, PlayerSkin.eyes_color + 1, GetString("cm_eyes_color_subtitle"),
                {Min = SkinMinVals.eyes_color + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {eyes_color = resetElement and SkinMinVals.eyes_color or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.ageing then
            MenuItemIndices.ageing = Items:AddList(GetString("cm_ageing"), SkinMaxVals.ageing + 1, PlayerSkin.ageing + 1, GetString("cm_ageing_subtitle"),
                {Min = SkinMinVals.ageing + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {ageing = resetElement and SkinMinVals.ageing or (Index - 1)})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.makeup then
            MenuItemIndices.makeup = Items:AddList(GetString("cm_makeup"), SkinMaxVals.makeup + 1, PlayerSkin.makeup + 1, GetString("cm_makeup_subtitle"),
                {Min = SkinMinVals.makeup + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {
                            makeup = resetElement and SkinMinVals.makeup or (Index - 1),
                            makeup_txd = SkinMinVals.makeup_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.lipstick then
            MenuItemIndices.lipstick = Items:AddList(GetString("cm_lipstick"), SkinMaxVals.lipstick + 1, PlayerSkin.lipstick + 1,
                GetString("cm_lipstick_subtitle"), {Min = SkinMinVals.lipstick + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {
                            lipstick = resetElement and SkinMinVals.lipstick or (Index - 1),
                            lipstick_txd = SkinMinVals.lipstick_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.blush then
            MenuItemIndices.blush = Items:AddList(GetString("cm_blush"), SkinMaxVals.blush + 1, PlayerSkin.blush + 1, GetString("cm_blush_subtitle"),
                {Min = SkinMinVals.blush + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {
                            blush = resetElement and SkinMinVals.blush or (Index - 1),
                            blush_txd = SkinMinVals.blush_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.chesthair then
            MenuItemIndices.chesthair = Items:AddList(GetString("cm_chesthair"), SkinMaxVals.chesthair + 1, PlayerSkin.chesthair + 1,
                GetString("cm_chesthair_subtitle"), {Min = SkinMinVals.chesthair + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 2 -- Clothes
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {
                            chesthair = resetElement and SkinMinVals.chesthair or (Index - 1),
                            chesthair_txd = SkinMinVals.chesthair_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.complexion then
            MenuItemIndices.complexion = Items:AddList(GetString("cm_complexion"), SkinMaxVals.complexion + 1, PlayerSkin.complexion + 1,
                GetString("cm_complexion_subtitle"), {Min = SkinMinVals.complexion + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {complexion = resetElement and SkinMinVals.complexion or (Index - 1)})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.sundamage then
            MenuItemIndices.sundamage = Items:AddList(GetString("cm_sundamage"), SkinMaxVals.sundamage + 1, PlayerSkin.sundamage + 1,
                GetString("cm_sundamage_subtitle"), {Min = SkinMinVals.sundamage + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {sundamage = resetElement and SkinMinVals.sundamage or (Index - 1)})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.moles then
            MenuItemIndices.moles = Items:AddList(GetString("cm_moles"), SkinMaxVals.moles + 1, PlayerSkin.moles + 1, GetString("cm_moles_subtitle"),
                {Min = SkinMinVals.moles + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 1 -- Head
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {moles = resetElement and SkinMinVals.moles or (Index - 1)})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.bodyblemishes then
            MenuItemIndices.bodyblemishes = Items:AddList(GetString("cm_bodyblemishes"), SkinMaxVals.bodyblemishes + 1, PlayerSkin.bodyblemishes + 1,
                GetString("cm_bodyblemishes_subtitle"), {Min = SkinMinVals.bodyblemishes + 1}, function(Index, onSelected, onListChange)
                    elementsIndexToHide = 2 -- Clothes
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {bodyblemishes = resetElement and SkinMinVals.bodyblemishes or (Index - 1)})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end
        if not menuElements or menuElements.addbodyblemishes then
            MenuItemIndices.addbodyblemishes = Items:AddList(GetString("cm_addbodyblemishes"), SkinMaxVals.addbodyblemishes + 1,
                PlayerSkin.addbodyblemishes + 1, GetString("cm_addbodyblemishes_subtitle"), {Min = SkinMinVals.addbodyblemishes + 1},
                function(Index, onSelected, onListChange)
                    elementsIndexToHide = 2 -- Clothes
                    if onListChange or resetElement then
                        PlayerSkin =
                            exports.ava_mp_peds:setPedSkin(playerPed, {addbodyblemishes = resetElement and SkinMinVals.addbodyblemishes or (Index - 1)})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
        end

        if not menuElements or menuElements.torso then
            Items:AddList(GetString("cm_torso"), SkinMaxVals.torso + 1, PlayerSkin.torso + 1, GetString("cm_torso_subtitle"), {Min = SkinMinVals.torso + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            torso = resetElement and SkinMinVals.torso or (Index - 1),
                            torso_txd = SkinMinVals.torso_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_torso_txd"), SkinMaxVals.torso_txd + 1, PlayerSkin.torso_txd + 1, GetString("cm_torso_txd_subtitle"),
                {Min = SkinMinVals.torso_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {torso_txd = resetElement and SkinMinVals.torso_txd or (Index - 1)})
                    end
                end)
        end

        if not menuElements or menuElements.tops then
            Items:AddList(GetString("cm_tops"), SkinMaxVals.tops + 1, PlayerSkin.tops + 1, GetString("cm_tops_subtitle"), {Min = SkinMinVals.tops + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            tops = resetElement and SkinMinVals.tops or (Index - 1),
                            tops_txd = SkinMinVals.tops_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_tops_txd"), SkinMaxVals.tops_txd + 1, PlayerSkin.tops_txd + 1, GetString("cm_tops_txd_subtitle"),
                {Min = SkinMinVals.tops_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {tops_txd = resetElement and SkinMinVals.tops_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.undershirt then
            Items:AddList(GetString("cm_undershirt"), SkinMaxVals.undershirt + 1, PlayerSkin.undershirt + 1, GetString("cm_undershirt_subtitle"),
                {Min = SkinMinVals.undershirt + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            undershirt = resetElement and SkinMinVals.undershirt or (Index - 1),
                            undershirt_txd = SkinMinVals.undershirt_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_undershirt_txd"), SkinMaxVals.undershirt_txd + 1, PlayerSkin.undershirt_txd + 1,
                GetString("cm_undershirt_txd_subtitle"), {Min = SkinMinVals.undershirt_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {undershirt_txd = resetElement and SkinMinVals.undershirt_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.bodyarmor then
            Items:AddList(GetString("cm_bodyarmor"), SkinMaxVals.bodyarmor + 1, PlayerSkin.bodyarmor + 1, GetString("cm_bodyarmor_subtitle"),
                {Min = SkinMinVals.bodyarmor + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            bodyarmor = resetElement and SkinMinVals.bodyarmor or (Index - 1),
                            bodyarmor_txd = SkinMinVals.bodyarmor_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_bodyarmor_txd"), SkinMaxVals.bodyarmor_txd + 1, PlayerSkin.bodyarmor_txd + 1, GetString("cm_bodyarmor_txd_subtitle"),
                {Min = SkinMinVals.bodyarmor_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {bodyarmor_txd = resetElement and SkinMinVals.bodyarmor_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.decals then
            Items:AddList(GetString("cm_decals"), SkinMaxVals.decals + 1, PlayerSkin.decals + 1, GetString("cm_decals_subtitle"),
                {Min = SkinMinVals.decals + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            decals = resetElement and SkinMinVals.decals or (Index - 1),
                            decals_txd = SkinMinVals.decals_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_decals_txd"), SkinMaxVals.decals_txd + 1, PlayerSkin.decals_txd + 1, GetString("cm_decals_txd_subtitle"),
                {Min = SkinMinVals.decals_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {decals_txd = resetElement and SkinMinVals.decals_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.leg then
            Items:AddList(GetString("cm_leg"), SkinMaxVals.leg + 1, PlayerSkin.leg + 1, GetString("cm_leg_subtitle"), {Min = SkinMinVals.leg + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed,
                            {leg = resetElement and SkinMinVals.leg or (Index - 1), leg_txd = SkinMinVals.leg_txd})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_leg_txd"), SkinMaxVals.leg_txd + 1, PlayerSkin.leg_txd + 1, GetString("cm_leg_txd_subtitle"),
                {Min = SkinMinVals.leg_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {leg_txd = resetElement and SkinMinVals.leg_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.shoes then
            Items:AddList(GetString("cm_shoes"), SkinMaxVals.shoes + 1, PlayerSkin.shoes + 1, GetString("cm_shoes_subtitle"), {Min = SkinMinVals.shoes + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            shoes = resetElement and SkinMinVals.shoes or (Index - 1),
                            shoes_txd = SkinMinVals.shoes_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_shoes_txd"), SkinMaxVals.shoes_txd + 1, PlayerSkin.shoes_txd + 1, GetString("cm_shoes_txd_subtitle"),
                {Min = SkinMinVals.shoes_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {shoes_txd = resetElement and SkinMinVals.shoes_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.bag then
            Items:AddList(GetString("cm_bag"), SkinMaxVals.bag + 1, PlayerSkin.bag + 1, GetString("cm_bag_subtitle"), {Min = SkinMinVals.bag + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed,
                            {bag = resetElement and SkinMinVals.bag or (Index - 1), bag_txd = SkinMinVals.bag_txd})
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_bag_txd"), SkinMaxVals.bag_txd + 1, PlayerSkin.bag_txd + 1, GetString("cm_bag_txd_subtitle"),
                {Min = SkinMinVals.bag_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {bag_txd = resetElement and SkinMinVals.bag_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.accessory then
            Items:AddList(GetString("cm_accessory"), SkinMaxVals.accessory + 1, PlayerSkin.accessory + 1, GetString("cm_accessory_subtitle"),
                {Min = SkinMinVals.accessory + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            accessory = resetElement and SkinMinVals.accessory or (Index - 1),
                            accessory_txd = SkinMinVals.accessory_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_accessory_txd"), SkinMaxVals.accessory_txd + 1, PlayerSkin.accessory_txd + 1, GetString("cm_accessory_txd_subtitle"),
                {Min = SkinMinVals.accessory_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {accessory_txd = resetElement and SkinMinVals.accessory_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.mask then
            Items:AddList(GetString("cm_mask"), SkinMaxVals.mask + 1, PlayerSkin.mask + 1, GetString("cm_mask_subtitle"), {Min = SkinMinVals.mask + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            mask = resetElement and SkinMinVals.mask or (Index - 1),
                            mask_txd = SkinMinVals.mask_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_mask_txd"), SkinMaxVals.mask_txd + 1, PlayerSkin.mask_txd + 1, GetString("cm_mask_txd_subtitle"),
                {Min = SkinMinVals.mask_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {mask_txd = resetElement and SkinMinVals.mask_txd or (Index - 1)})
                    end
                end)
        end

        if not menuElements or menuElements.hats then
            Items:AddList(GetString("cm_hats"), SkinMaxVals.hats + 1, PlayerSkin.hats + 1, GetString("cm_hats_subtitle"), {Min = SkinMinVals.hats + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            hats = resetElement and SkinMinVals.hats or (Index - 1),
                            hats_txd = SkinMinVals.hats_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_hats_txd"), SkinMaxVals.hats_txd + 1, PlayerSkin.hats_txd + 1, GetString("cm_hats_txd_subtitle"),
                {Min = SkinMinVals.hats_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {hats_txd = resetElement and SkinMinVals.hats_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.glasses then
            Items:AddList(GetString("cm_glasses"), SkinMaxVals.glasses + 1, PlayerSkin.glasses + 1, GetString("cm_glasses_subtitle"),
                {Min = SkinMinVals.glasses + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            glasses = resetElement and SkinMinVals.glasses or (Index - 1),
                            glasses_txd = SkinMinVals.glasses_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_glasses_txd"), SkinMaxVals.glasses_txd + 1, PlayerSkin.glasses_txd + 1, GetString("cm_glasses_txd_subtitle"),
                {Min = SkinMinVals.glasses_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {glasses_txd = resetElement and SkinMinVals.glasses_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.ears then
            Items:AddList(GetString("cm_ears"), SkinMaxVals.ears + 1, PlayerSkin.ears + 1, GetString("cm_ears_subtitle"), {Min = SkinMinVals.ears + 1},
                function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            ears = resetElement and SkinMinVals.ears or (Index - 1),
                            ears_txd = SkinMinVals.ears_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_ears_txd"), SkinMaxVals.ears_txd + 1, PlayerSkin.ears_txd + 1, GetString("cm_ears_txd_subtitle"),
                {Min = SkinMinVals.ears_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {ears_txd = resetElement and SkinMinVals.ears_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.watches then
            Items:AddList(GetString("cm_watches"), SkinMaxVals.watches + 1, PlayerSkin.watches + 1, GetString("cm_watches_subtitle"),
                {Min = SkinMinVals.watches + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            watches = resetElement and SkinMinVals.watches or (Index - 1),
                            watches_txd = SkinMinVals.watches_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_watches_txd"), SkinMaxVals.watches_txd + 1, PlayerSkin.watches_txd + 1, GetString("cm_watches_txd_subtitle"),
                {Min = SkinMinVals.watches_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {watches_txd = resetElement and SkinMinVals.watches_txd or (Index - 1)})
                    end
                end)
        end
        if not menuElements or menuElements.bracelets then
            Items:AddList(GetString("cm_bracelets"), SkinMaxVals.bracelets + 1, PlayerSkin.bracelets + 1, GetString("cm_bracelets_subtitle"),
                {Min = SkinMinVals.bracelets + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {
                            bracelets = resetElement and SkinMinVals.bracelets or (Index - 1),
                            bracelets_txd = SkinMinVals.bracelets_txd,
                        })
                        SkinMaxVals = exports.ava_mp_peds:getMaxValues(playerPed)
                    end
                end)
            Items:AddList(GetString("cm_bracelets_txd"), SkinMaxVals.bracelets_txd + 1, PlayerSkin.bracelets_txd + 1, GetString("cm_bracelets_txd_subtitle"),
                {Min = SkinMinVals.bracelets_txd + 1}, function(Index, onSelected, onListChange)
                    if onListChange or resetElement then
                        PlayerSkin = exports.ava_mp_peds:setPedClothes(playerPed, {bracelets_txd = resetElement and SkinMinVals.bracelets_txd or (Index - 1)})
                    end
                end)
        end

        if not menuElements or menuElements.tattoos then
            Items:AddButton(GetString("cm_tattoos"), GetString("cm_tattoos_subtitle"), {RightBadge = RageUI.BadgeStyle.Tattoo}, function(onSelected)
                if onSelected then
                    elementsIndexToHide = 3 -- All elements
                end
            end, TattoosMenu)
        end

        Items:AddButton(GetString("clothes_menu_cancel"), GetString("clothes_menu_cancel_subtitle"), {}, function(onSelected)
            if onSelected then
                -- Timeout 0 because there would be an error inside of panels
                Citizen.SetTimeout(0, RageUI.CloseAllInternal)
            end
        end)
        Items:AddButton(GetString("clothes_menu_validate"), GetString("clothes_menu_validate_subtitle"), {
            Color = {BackgroundColor = RageUI.ItemsColour.MenuYellow, HighLightColor = RageUI.ItemsColour.PmMitemHighlight},
            RightLabel = validateButtonRightLabel,
        }, function(onSelected)
            if onSelected then
                validateChanges = true
                -- Timeout 0 because there would be an error inside of panels
                Citizen.SetTimeout(0, RageUI.CloseAllInternal)
            end
        end)
        -- #endregion elements

        if lastElementsIndexToHide ~= elementsIndexToHide then
            lastElementsIndexToHide = elementsIndexToHide
            HideSkinElementsOnItem(lastElementsIndexToHide)
        end
    end, function(Panels)
        -- #region panels
        if (not menuElements or menuElements.hair) and MenuItemIndices.hair then
            Panels:ColourPanel(GetString("cm_hair_main_color"), RageUI.PanelColour.HairCut, MenuNeededValues.hair_main_color
                or (PlayerSkin.hair_main_color > 9 and (PlayerSkin.hair_main_color - 7) or (PlayerSkin.hair_main_color + 1)), PlayerSkin.hair_main_color + 1,
                function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.hair_main_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {hair_main_color = CurrentIndex - 1})
                end, MenuItemIndices.hair)
            Panels:ColourPanel(GetString("cm_hair_scnd_color"), RageUI.PanelColour.HairCut, MenuNeededValues.hair_scnd_color
                or (PlayerSkin.hair_scnd_color > 9 and (PlayerSkin.hair_scnd_color - 7) or (PlayerSkin.hair_scnd_color + 1)), PlayerSkin.hair_scnd_color + 1,
                function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.hair_scnd_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {hair_scnd_color = CurrentIndex - 1})
                end, MenuItemIndices.hair)
        end

        if (not menuElements or menuElements.beard) and MenuItemIndices.beard then
            Panels:PercentagePanel(PlayerSkin.beard_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {beard_op = Percent * 100})
            end, MenuItemIndices.beard)

            Panels:ColourPanel(GetString("cm_beard_color"), RageUI.PanelColour.HairCut,
                MenuNeededValues.beard_color or (PlayerSkin.beard_color > 9 and (PlayerSkin.beard_color - 7) or (PlayerSkin.beard_color + 1)),
                PlayerSkin.beard_color + 1, function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.beard_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {beard_color = CurrentIndex - 1})
                end, MenuItemIndices.beard)
        end

        if (not menuElements or menuElements.eyebrows) and MenuItemIndices.eyebrows then
            Panels:PercentagePanel(PlayerSkin.eyebrows_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {eyebrows_op = Percent * 100})
            end, MenuItemIndices.eyebrows)

            Panels:ColourPanel(GetString("cm_eyebrows_color"), RageUI.PanelColour.HairCut, MenuNeededValues.eyebrows_color
                or (PlayerSkin.eyebrows_color > 9 and (PlayerSkin.eyebrows_color - 7) or (PlayerSkin.eyebrows_color + 1)), PlayerSkin.eyebrows_color + 1,
                function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.eyebrows_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {eyebrows_color = CurrentIndex - 1})
                end, MenuItemIndices.eyebrows)
        end

        if (not menuElements or menuElements.chesthair) and MenuItemIndices.chesthair then
            Panels:PercentagePanel(PlayerSkin.chesthair_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {chesthair_op = Percent * 100})
            end, MenuItemIndices.chesthair)

            Panels:ColourPanel(GetString("cm_chesthair_color"), RageUI.PanelColour.HairCut, MenuNeededValues.chesthair_color
                or (PlayerSkin.chesthair_color > 9 and (PlayerSkin.chesthair_color - 7) or (PlayerSkin.chesthair_color + 1)), PlayerSkin.chesthair_color + 1,
                function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.chesthair_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {chesthair_color = CurrentIndex - 1})
                end, MenuItemIndices.chesthair)
        end

        if (not menuElements or menuElements.blush) and MenuItemIndices.blush then
            Panels:PercentagePanel(PlayerSkin.blush_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {blush_op = Percent * 100})
            end, MenuItemIndices.blush)

            Panels:ColourPanel(GetString("cm_blush_color"), RageUI.PanelColour.Makeup,
                MenuNeededValues.blush_color or (PlayerSkin.blush_color > 9 and (PlayerSkin.blush_color - 7) or (PlayerSkin.blush_color + 1)),
                PlayerSkin.blush_color + 1, function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.blush_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {blush_color = CurrentIndex - 1})
                end, MenuItemIndices.blush)
        end

        if (not menuElements or menuElements.ageing) and MenuItemIndices.ageing then
            Panels:PercentagePanel(PlayerSkin.ageing_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {ageing_op = Percent * 100})
            end, MenuItemIndices.ageing)
        end
        if (not menuElements or menuElements.complexion) and MenuItemIndices.complexion then
            Panels:PercentagePanel(PlayerSkin.complexion_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {complexion_op = Percent * 100})
            end, MenuItemIndices.complexion)
        end
        if (not menuElements or menuElements.sundamage) and MenuItemIndices.sundamage then
            Panels:PercentagePanel(PlayerSkin.sundamage_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {sundamage_op = Percent * 100})
            end, MenuItemIndices.sundamage)
        end
        if (not menuElements or menuElements.moles) and MenuItemIndices.moles then
            Panels:PercentagePanel(PlayerSkin.moles_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {moles_op = Percent * 100})
            end, MenuItemIndices.moles)
        end
        if (not menuElements or menuElements.bodyblemishes) and MenuItemIndices.bodyblemishes then
            Panels:PercentagePanel(PlayerSkin.bodyblemishes_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {bodyblemishes_op = Percent * 100})
            end, MenuItemIndices.bodyblemishes)
        end
        if (not menuElements or menuElements.addbodyblemishes) and MenuItemIndices.addbodyblemishes then
            Panels:PercentagePanel(PlayerSkin.addbodyblemishes_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {addbodyblemishes_op = Percent * 100})
            end, MenuItemIndices.addbodyblemishes)
        end

        if (not menuElements or menuElements.makeup) and MenuItemIndices.makeup then
            Panels:PercentagePanel(PlayerSkin.makeup_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {makeup_op = Percent * 100})
            end, MenuItemIndices.makeup)

            Panels:ColourPanel(GetString("cm_makeup_main_color"), RageUI.PanelColour.Makeup, MenuNeededValues.makeup_main_color
                or (PlayerSkin.makeup_main_color > 9 and (PlayerSkin.makeup_main_color - 7) or (PlayerSkin.makeup_main_color + 1)),
                PlayerSkin.makeup_main_color + 1, function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.makeup_main_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {makeup_main_color = CurrentIndex - 1})
                end, MenuItemIndices.makeup)
            Panels:ColourPanel(GetString("cm_makeup_scnd_color"), RageUI.PanelColour.Makeup, MenuNeededValues.makeup_scnd_color
                or (PlayerSkin.makeup_scnd_color > 9 and (PlayerSkin.makeup_scnd_color - 7) or (PlayerSkin.makeup_scnd_color + 1)),
                PlayerSkin.makeup_scnd_color + 1, function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.makeup_scnd_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {makeup_scnd_color = CurrentIndex - 1})
                end, MenuItemIndices.makeup)
        end
        if (not menuElements or menuElements.lipstick) and MenuItemIndices.lipstick then
            Panels:PercentagePanel(PlayerSkin.lipstick_op / 100, nil, nil, nil, function(Percent)
                PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {lipstick_op = Percent * 100})
            end, MenuItemIndices.lipstick)

            Panels:ColourPanel(GetString("cm_lipstick_color"), RageUI.PanelColour.Makeup, MenuNeededValues.lipstick_color
                or (PlayerSkin.lipstick_color > 9 and (PlayerSkin.lipstick_color - 7) or (PlayerSkin.lipstick_color + 1)), PlayerSkin.lipstick_color + 1,
                function(MinimumIndex, CurrentIndex)
                    MenuNeededValues.lipstick_color = MinimumIndex
                    PlayerSkin = exports.ava_mp_peds:setPedSkin(playerPed, {lipstick_color = CurrentIndex - 1})
                end, MenuItemIndices.lipstick)
        end
        -- #endregion panels
    end)

    TattoosMenu:IsVisible(function(Items)
        local tattooToApply = nil
        InsideOfClothesMenuControls()

        Items:AddList(GetString("cm_t_dlclist"), tattoosDLCList, MenuNeededValues.tattooDLCIndex or 1, GetString("cm_t_dlclist_subtitle"), nil,
            function(Index, onSelected, onListChange)
                if onListChange then
                    MenuNeededValues.tattooDLCIndex = Index
                    setCurrentTattoosDlc(tattoosDLCList[MenuNeededValues.tattooDLCIndex].index)
                end
            end)

        Items:AddList(GetString("cm_t_zonelist"), tattoosZonesList, MenuNeededValues.tattooZoneIndex or 1, GetString("cm_t_zonelist_subtitle"), nil,
            function(Index, onSelected, onListChange)
                if onListChange then
                    MenuNeededValues.tattooZoneIndex = Index
                end
            end)

        local tattoos<const> = MenuNeededValues.currentTattooCollection.Zones[tattoosZonesList[MenuNeededValues.tattooZoneIndex].zoneName]
        if tattoos then
            for i = 1, #tattoos do
                local tattoo<const> = tattoos[i]
                local isApplied<const> = MenuNeededValues.currentCollectionAppliedTattoos[tattoo.name]
                Items:AddButton(GetString("cm_t_tattoo_number", i), GetString("cm_t_enter_to_apply_tattoo"),
                    {RightBadge = isApplied and RageUI.BadgeStyle.Tattoo}, function(onSelected)
                        if not isApplied then
                            tattooToApply = tattoo.name
                            if onSelected then
                                lastTattooToApply = nil
                                tattooToApply = nil

                                MenuNeededValues.currentCollectionAppliedTattoos[tattoo.name] = true
                                table.insert(PlayerSkin.tattoos, {collection = MenuNeededValues.currentTattooCollection.name, overlay = tattoo.name})
                                PlayerSkin = exports.ava_mp_peds:setPedSkin(PlayerPedId(), {tattoos = PlayerSkin.tattoos})
                            end
                        end
                    end)
            end
        end

        if lastTattooToApply ~= tattooToApply then
            lastTattooToApply = tattooToApply
            exports.ava_mp_peds:reloadPedOverlays(playerPed)
            if lastTattooToApply then
                AddPedDecorationFromHashes(PlayerPedId(), MenuNeededValues.currentTattooCollection.name, lastTattooToApply)
            end
        end
    end)

end
