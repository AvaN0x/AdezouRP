-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
---@class skin
---@field gender number
---@field father number
---@field mother number
---@field shape_mix number
---@field skin_mix number
---@field nose_width number
---@field nose_peak_hight number
---@field nose_peak_lenght number
---@field nose_bone_high number
---@field nose_peak_lowering number
---@field nose_bone_twist number
---@field eyebrow_high number
---@field eyebrow_forward number
---@field cheeks_bone_high number
---@field cheeks_bone_width number
---@field cheeks_width number
---@field eyes_openning number
---@field eyes_color number
---@field lips_thickness number
---@field jaw_bone_width number
---@field jaw_bone_back_lenght number
---@field chin_bone_lowering number
---@field chin_bone_lenght number
---@field chin_bone_width number
---@field chin_hole number
---@field neck_thickness number
---@field blemishes number
---@field blemishes_op number
---@field beard number
---@field beard_op number
---@field beard_color number
---@field eyebrows number
---@field eyebrows_op number
---@field eyebrows_color number
---@field ageing number
---@field ageing_op number
---@field makeup number
---@field makeup_op number
---@field makeup_main_color number
---@field makeup_scnd_color number
---@field blush number
---@field blush_op number
---@field blush_color number
---@field complexion number
---@field complexion_op number
---@field sundamage number
---@field sundamage_op number
---@field lipstick number
---@field lipstick_op number
---@field lipstick_color number
---@field moles number
---@field moles_op number
---@field chesthair number
---@field chesthair_op number
---@field chesthair_color number
---@field bodyblemishes number
---@field bodyblemishes_op number
---@field addbodyblemishes number
---@field addbodyblemishes_op number
---@field mask number
---@field mask_txd number
---@field torso number
---@field torso_txd number
---@field hair number
---@field hair_txd number
---@field hair_main_color number
---@field hair_scnd_color number
---@field leg number
---@field leg_txd number
---@field bag number
---@field bag_txd number
---@field shoes number
---@field shoes_txd number
---@field accessory number
---@field accessory_txd number
---@field undershirt number
---@field undershirt_txd number
---@field bodyarmor number
---@field bodyarmor_txd number
---@field decals number
---@field decals_txd number
---@field tops number
---@field tops_txd number
---@field hats number
---@field hats_txd number
---@field glasses number
---@field glasses_txd number
---@field ears number
---@field ears_txd number
---@field watches number
---@field watches_txd number
---@field bracelets number
---@field bracelets_txd number
---@field tattoos table
local localSkin = {}
local localPlayerSkinSave = nil
local NumHairColors<const> = GetNumHairColors()
local NumMakeupColors<const> = GetNumMakeupColors()

local function round(x)
    if type(x) == "number" then
        return math.floor(x + 0.5)
    end
    return x
end

-- Reset local skin to default values
---@return skin localSkin
function reset()
    for component, value in pairs(AVAConfig.skinComponents) do
        localSkin[component] = value.default or value.min
    end
    return localSkin
end
exports("reset", reset)
reset()

-- Reset local skin clothes to default values
---@return skin localSkin
function resetClothes()
    for i = 1, #AVAConfig.clothesComponents do
        local componentName<const> = AVAConfig.clothesComponents[i]
        localSkin[componentName] = AVAConfig.skinComponents[componentName].default or AVAConfig.skinComponents[componentName].min
    end
    return localSkin
end
exports("resetClothes", resetClothes)

---Depending on the ped type, it will either save the player skin from localSkin for later, either restore the player skin into localSkin
---@param ped entity
local function saveOrRestorePlayerLocalSkin(ped)
    -- If player is local player
    if IsPedAPlayer(ped) and PlayerPedId() == ped then
        -- If we had a save, then we restore it
        if localPlayerSkinSave then
            print("^1[DEBUG]^0 Restoring player skin")
            for component, value in pairs(AVAConfig.skinComponents) do
                localSkin[component] = localPlayerSkinSave[component] or value.default or value.min
            end
            localPlayerSkinSave = nil
        end
    else
        -- The ped is not the player ped
        -- If the localSkin is not already saved, we save it
        if not localPlayerSkinSave then
            localPlayerSkinSave = {}
            print("^1[DEBUG]^0 Saving player skin")
            for component, value in pairs(AVAConfig.skinComponents) do
                -- Save value
                localPlayerSkinSave[component] = localSkin[component] or value.default or value.min
                -- Set value to default for localSkin
                localSkin[component] = value.default or value.min
            end
        end
    end
end

---Set ped components based on clothes components, internal
---@param ped entity
---@param skin skin
local function setPedClothesInternal(ped, skin)
    -- Mask
    SetPedComponentVariation(ped, 1, localSkin.mask, localSkin.mask_txd, 0)
    -- Torso
    SetPedComponentVariation(ped, 3, localSkin.torso, localSkin.torso_txd, 0)
    -- Leg
    SetPedComponentVariation(ped, 4, localSkin.leg, localSkin.leg_txd, 0)
    -- Bag
    SetPedComponentVariation(ped, 5, localSkin.bag, localSkin.bag_txd, 0)
    -- Shoes
    SetPedComponentVariation(ped, 6, localSkin.shoes, localSkin.shoes_txd, 0)
    -- Accessory
    SetPedComponentVariation(ped, 7, localSkin.accessory, localSkin.accessory_txd, 0)
    -- Undershirt
    SetPedComponentVariation(ped, 8, localSkin.undershirt, localSkin.undershirt_txd, 0)
    -- Kevlar
    SetPedComponentVariation(ped, 9, localSkin.bodyarmor, localSkin.bodyarmor_txd, 0)
    -- Decals
    SetPedComponentVariation(ped, 10, localSkin.decals, localSkin.decals_txd, 0)
    -- Torso
    SetPedComponentVariation(ped, 11, localSkin.tops, localSkin.tops_txd, 0)

    -- Hats
    if localSkin.hats == -1 then
        ClearPedProp(ped, 0)
    else
        SetPedPropIndex(ped, 0, localSkin.hats, localSkin.hats_txd, 0)
    end

    -- Glasses
    if localSkin.glasses == -1 then
        ClearPedProp(ped, 1)
    else
        SetPedPropIndex(ped, 1, localSkin.glasses, localSkin.glasses_txd, 0)
    end

    -- Ears
    if localSkin.ears == -1 then
        ClearPedProp(ped, 2)
    else
        SetPedPropIndex(ped, 2, localSkin.ears, localSkin.ears_txd, 0)
    end

    -- Watches
    if localSkin.watches == -1 then
        ClearPedProp(ped, 6)
    else
        SetPedPropIndex(ped, 6, localSkin.watches, localSkin.watches_txd, 0)
    end

    -- Bracelets
    if localSkin.bracelets == -1 then
        ClearPedProp(ped, 7)
    else
        SetPedPropIndex(ped, 7, localSkin.bracelets, localSkin.bracelets_txd, 0)
    end
end

---Reload ped overlays, hairs and tattoos, internal
---@param ped entity
local function reloadPedOverlaysInternal(ped)
    ClearPedDecorations(ped)

    if AVAConfig.HairOverlays[localSkin.gender] then
        -- Default to 0
        local overlay<const> = AVAConfig.HairOverlays[localSkin.gender][localSkin.hair] or AVAConfig.HairOverlays[localSkin.gender][0]
        if overlay and overlay.collection and overlay.overlay then
            print("^3[DEBUG]^0 Set hair overlays", overlay.collection, overlay.overlay)
            AddPedDecorationFromHashes(ped, overlay.collection, overlay.overlay)
        end
    end

    if localSkin.tattoos then
        for i = 1, #localSkin.tattoos do
            local tattoo<const> = localSkin.tattoos[i]
            if tattoo.collection and tattoo.overlay then
                print("^3[DEBUG]^0 Set tattoo", tattoo.collection, tattoo.overlay)
                AddPedDecorationFromHashes(ped, tattoo.collection, tattoo.overlay)
            end
        end
    end
end
-------------
-- EXPORTS --
-------------

---Set ped components based on skin components
---@param ped entity
---@param skin skin
---@return skin "skin that got applied"
function setPedSkin(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)

    local shouldReloadOverlays = false
    if skin then
        for component, _ in pairs(AVAConfig.skinComponents) do
            if skin[component] then
                localSkin[component] = round(skin[component])
                if not shouldReloadOverlays and AVAConfig.ShouldReloadOverlay[component] then
                    shouldReloadOverlays = true
                end
            end
        end
    end

    -- #region Set player model
    local model<const> = localSkin.gender == 0 and GetHashKey("mp_m_freemode_01") or GetHashKey("mp_f_freemode_01")

    if model ~= GetEntityModel(ped) and IsModelValid(model) and IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        ped = PlayerPedId()

        SetModelAsNoLongerNeeded(model)
        ClearPedDecorations(ped)
        shouldReloadOverlays = true
    end
    -- #endregion Set player model

    ClearAllPedProps(ped, 0)

    -- #region HeadBlendData
    SetPedHeadBlendData(ped, localSkin.mother, localSkin.father, 0, localSkin.mother, localSkin.father, 0, (localSkin.shape_mix / 100) + 0.0,
        (localSkin.skin_mix / 100) + 0.0, 0.0, false)
    -- while not HasPedHeadBlendFinished(ped) do
    --     Wait(0)
    -- end
    -- #endregion HeadBlendData

    -- #region Ped face
    -- Nose
    SetPedFaceFeature(ped, 0, (localSkin.nose_width / 100) + 0.0)
    SetPedFaceFeature(ped, 1, (localSkin.nose_peak_hight / 100) + 0.0)
    SetPedFaceFeature(ped, 2, (localSkin.nose_peak_lenght / 100) + 0.0)
    SetPedFaceFeature(ped, 3, (localSkin.nose_bone_high / 100) + 0.0)
    SetPedFaceFeature(ped, 4, (localSkin.nose_peak_lowering / 100) + 0.0)
    SetPedFaceFeature(ped, 5, (localSkin.nose_bone_twist / 100) + 0.0)

    -- Eyebrows
    SetPedFaceFeature(ped, 6, (localSkin.eyebrow_high / 100) + 0.0)
    SetPedFaceFeature(ped, 7, (localSkin.eyebrow_forward / 100) + 0.0)

    -- Cheeks
    SetPedFaceFeature(ped, 8, (localSkin.cheeks_bone_high / 100) + 0.0)
    SetPedFaceFeature(ped, 9, (localSkin.cheeks_bone_width / 100) + 0.0)
    SetPedFaceFeature(ped, 10, (localSkin.cheeks_width / 100) + 0.0)

    -- Eyes
    SetPedFaceFeature(ped, 11, (localSkin.eyes_openning / 100) + 0.0)
    SetPedEyeColor(ped, localSkin.eyes_color)

    -- Lips
    SetPedFaceFeature(ped, 12, (localSkin.lips_thickness / 100) + 0.0)

    -- Jaw
    SetPedFaceFeature(ped, 13, (localSkin.jaw_bone_width / 100) + 0.0)
    SetPedFaceFeature(ped, 14, (localSkin.jaw_bone_back_lenght / 100) + 0.0)

    -- Chin
    SetPedFaceFeature(ped, 15, (localSkin.chin_bone_lowering / 100) + 0.0)
    SetPedFaceFeature(ped, 16, (localSkin.chin_bone_lenght / 100) + 0.0)
    SetPedFaceFeature(ped, 17, (localSkin.chin_bone_width / 100) + 0.0)
    SetPedFaceFeature(ped, 18, (localSkin.chin_hole / 100) + 0.0)

    -- Neck
    SetPedFaceFeature(ped, 19, (localSkin.neck_thickness / 100) + 0.0)
    -- #endregion Ped face

    -- #region Ped head overlays
    -- 255 is to disable
    -- Blemishes
    SetPedHeadOverlay(ped, 0, localSkin.blemishes, (localSkin.blemishes_op / 100) + 0.0)
    -- Beard
    SetPedHeadOverlay(ped, 1, localSkin.beard, (localSkin.beard_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 1, 1, localSkin.beard_color, localSkin.beard_color)
    -- Eyebrows
    SetPedHeadOverlay(ped, 2, localSkin.eyebrows, (localSkin.eyebrows_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 2, 1, localSkin.eyebrows_color, localSkin.eyebrows_color)
    -- Ageing
    SetPedHeadOverlay(ped, 3, localSkin.ageing, (localSkin.ageing_op / 100) + 0.0)
    -- Makeup
    SetPedHeadOverlay(ped, 4, localSkin.makeup, (localSkin.makeup_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 4, 2, localSkin.makeup_main_color, localSkin.makeup_scnd_color)
    -- Blush
    SetPedHeadOverlay(ped, 5, localSkin.blush, (localSkin.blush_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 5, 2, localSkin.blush_color)
    -- Complexion
    SetPedHeadOverlay(ped, 6, localSkin.complexion, (localSkin.complexion_op / 100) + 0.0)
    -- SunDamage
    SetPedHeadOverlay(ped, 7, localSkin.sundamage, (localSkin.sundamage_op / 100) + 0.0)
    -- Lipstick
    SetPedHeadOverlay(ped, 8, localSkin.lipstick, (localSkin.lipstick_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 8, 1, localSkin.lipstick_color, localSkin.lipstick_color)
    -- Moles/Freckles
    SetPedHeadOverlay(ped, 9, localSkin.moles, (localSkin.moles_op / 100) + 0.0)
    -- Chest Hair
    SetPedHeadOverlay(ped, 10, localSkin.chesthair, (localSkin.chesthair_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 10, 1, localSkin.chesthair_color, localSkin.chesthair_color)
    -- Body Blemishes
    SetPedHeadOverlay(ped, 11, localSkin.bodyblemishes == -1 and 255 or localSkin.bodyblemishes, (localSkin.bodyblemishes_op / 100) + 0.0)
    -- Add Body Blemishes
    SetPedHeadOverlay(ped, 12, localSkin.addbodyblemishes == -1 and 255 or localSkin.addbodyblemishes, (localSkin.addbodyblemishes_op / 100) + 0.0)
    -- #endregion Ped head overlays

    -- Hair
    SetPedComponentVariation(ped, 2, localSkin.hair, localSkin.hair_txd, 0)
    -- Hair Color
    SetPedHairColor(ped, localSkin.hair_main_color, localSkin.hair_scnd_color)

    -- Hair overlays and tattoos
    if shouldReloadOverlays then
        reloadPedOverlaysInternal(ped)
    end

    setPedClothesInternal(ped, skin)
    return localSkin
end
exports("setPedSkin", setPedSkin)

---Set player ped components based on skin components
---@param skin skin
---@return skin "skin that got applied"
function setPlayerSkin(skin)
    return setPedSkin(PlayerPedId(), skin)
end
exports("setPlayerSkin", setPlayerSkin)

---Set ped components based on clothes components
---@param ped entity
---@param skin skin
---@return skin "skin that got applied"
function setPedClothes(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)

    if skin then
        for i = 1, #AVAConfig.clothesComponents do
            local component<const> = AVAConfig.clothesComponents[i]
            if skin[component] then
                localSkin[component] = round(skin[component])
            end
        end
    end

    setPedClothesInternal(ped, skin)
    return localSkin
end
exports("setPedClothes", setPedClothes)

---Set player ped components based on clothes components
---@param skin skin
function setPlayerClothes(skin)
    return setPedClothes(PlayerPedId(), skin)
end
exports("setPlayerClothes", setPlayerClothes)

---Returns player skin
---@return skin table
function getPlayerCurrentSkin()
    return localPlayerSkinSave or localSkin
end
exports("getPlayerCurrentSkin", getPlayerCurrentSkin)

---Returns player clothes
---@return table
function getPlayerClothes()
    local playerSkin<const> = getPlayerCurrentSkin()
    local clothes = {}

    for i = 1, #AVAConfig.clothesComponents do
        local component<const> = AVAConfig.clothesComponents[i]
        clothes[component] = playerSkin[component]
    end

    return clothes
end
exports("getPlayerClothes", getPlayerClothes)

---Get max values for all skins
---@param entity ped
---@return skin
function getMaxValues(ped)
    if not ped then
        ped = PlayerPedId()
    end
    saveOrRestorePlayerLocalSkin(ped)

    return {
        gender = AVAConfig.skinComponents.gender.max,
        -- #region HeadBlendData
        father = AVAConfig.skinComponents.father.max,
        mother = AVAConfig.skinComponents.mother.max,
        shape_mix = AVAConfig.skinComponents.shape_mix.max,
        skin_mix = AVAConfig.skinComponents.skin_mix.max,
        -- #endregion HeadBlendData

        -- #region Ped face
        -- Nose
        nose_width = AVAConfig.skinComponents.nose_width.max,
        nose_peak_hight = AVAConfig.skinComponents.nose_peak_hight.max,
        nose_peak_lenght = AVAConfig.skinComponents.nose_peak_lenght.max,
        nose_bone_high = AVAConfig.skinComponents.nose_bone_high.max,
        nose_peak_lowering = AVAConfig.skinComponents.nose_peak_lowering.max,
        nose_bone_twist = AVAConfig.skinComponents.nose_bone_twist.max,
        -- Eyebrows
        eyebrow_high = AVAConfig.skinComponents.eyebrow_high.max,
        eyebrow_forward = AVAConfig.skinComponents.eyebrow_forward.max,
        -- Cheeks
        cheeks_bone_high = AVAConfig.skinComponents.cheeks_bone_high.max,
        cheeks_bone_width = AVAConfig.skinComponents.cheeks_bone_width.max,
        cheeks_width = AVAConfig.skinComponents.cheeks_width.max,
        -- Eyes
        eyes_openning = AVAConfig.skinComponents.eyes_openning.max,
        eyes_color = AVAConfig.skinComponents.eyes_color.max,
        -- Lips
        lips_thickness = AVAConfig.skinComponents.lips_thickness.max,
        -- Jaw
        jaw_bone_width = AVAConfig.skinComponents.jaw_bone_width.max,
        jaw_bone_back_lenght = AVAConfig.skinComponents.jaw_bone_back_lenght.max,
        -- Chin
        chin_bone_lowering = AVAConfig.skinComponents.chin_bone_lowering.max,
        chin_bone_lenght = AVAConfig.skinComponents.chin_bone_lenght.max,
        chin_bone_width = AVAConfig.skinComponents.chin_bone_width.max,
        chin_hole = AVAConfig.skinComponents.chin_hole.max,
        -- Neck
        neck_thickness = AVAConfig.skinComponents.neck_thickness.max,
        -- #endregion Ped face

        -- #region Ped head overlays
        -- Blemishes
        blemishes = GetNumHeadOverlayValues(0) - 1,
        blemishes_op = AVAConfig.skinComponents.blemishes_op.max,
        -- Beard
        beard = GetNumHeadOverlayValues(1) - 1,
        beard_op = AVAConfig.skinComponents.beard_op.max,
        beard_color = NumHairColors - 1,
        -- Eyebrows
        eyebrows = GetNumHeadOverlayValues(2) - 1,
        eyebrows_op = AVAConfig.skinComponents.eyebrows_op.max,
        eyebrows_color = NumHairColors - 1,
        -- Ageing
        ageing = GetNumHeadOverlayValues(3) - 1,
        ageing_op = AVAConfig.skinComponents.ageing_op.max,
        -- Makeup
        makeup = GetNumHeadOverlayValues(4) - 1,
        makeup_op = AVAConfig.skinComponents.makeup_op.max,
        makeup_main_color = NumMakeupColors - 1,
        makeup_scnd_color = NumMakeupColors - 1,
        -- Blush
        blush = GetNumHeadOverlayValues(5) - 1,
        blush_op = AVAConfig.skinComponents.blush_op.max,
        blush_color = NumMakeupColors - 1,
        -- Complexion
        complexion = GetNumHeadOverlayValues(6) - 1,
        complexion_op = AVAConfig.skinComponents.complexion_op.max,
        -- SunDamage
        sundamage = GetNumHeadOverlayValues(7) - 1,
        sundamage_op = AVAConfig.skinComponents.sundamage_op.max,
        -- Lipstick
        lipstick = GetNumHeadOverlayValues(8) - 1,
        lipstick_op = AVAConfig.skinComponents.lipstick_op.max,
        lipstick_color = NumMakeupColors - 1,
        -- Moles/Freckles
        moles = GetNumHeadOverlayValues(8) - 1,
        moles_op = AVAConfig.skinComponents.moles_op.max,
        -- Chest Hair
        chesthair = GetNumHeadOverlayValues(10) - 1,
        chesthair_op = AVAConfig.skinComponents.chesthair_op.max,
        chesthair_color = NumHairColors - 1,
        -- Body Blemishes
        bodyblemishes = GetNumHeadOverlayValues(11) - 1,
        bodyblemishes_op = AVAConfig.skinComponents.bodyblemishes_op.max,
        -- Add Body Blemishes
        addbodyblemishes = GetNumHeadOverlayValues(12) - 1,
        addbodyblemishes_op = AVAConfig.skinComponents.addbodyblemishes_op.max,
        -- #endregion Ped head overlays

        -- #region Components
        -- Mask
        mask = GetNumberOfPedDrawableVariations(ped, 1) - 1,
        mask_txd = GetNumberOfPedTextureVariations(ped, 1, localSkin.mask) - 1,
        -- Hairs
        hair = GetNumberOfPedDrawableVariations(ped, 2) - 1,
        hair_txd = GetNumberOfPedTextureVariations(ped, 2, localSkin.hair) - 1,
        hair_main_color = NumHairColors - 1,
        hair_scnd_color = NumHairColors - 1,
        -- Torso
        torso = GetNumberOfPedDrawableVariations(ped, 3) - 1,
        torso_txd = GetNumberOfPedTextureVariations(ped, 3, localSkin.torso) - 1,
        -- Leg
        leg = GetNumberOfPedDrawableVariations(ped, 4) - 1,
        leg_txd = GetNumberOfPedTextureVariations(ped, 4, localSkin.leg) - 1,
        -- Bag
        bag = GetNumberOfPedDrawableVariations(ped, 5) - 1,
        bag_txd = GetNumberOfPedTextureVariations(ped, 5, localSkin.bag) - 1,
        -- Shoes
        shoes = GetNumberOfPedDrawableVariations(ped, 6) - 1,
        shoes_txd = GetNumberOfPedTextureVariations(ped, 6, localSkin.shoes) - 1,
        -- Accessory
        accessory = GetNumberOfPedDrawableVariations(ped, 7) - 1,
        accessory_txd = GetNumberOfPedTextureVariations(ped, 7, localSkin.accessory) - 1,
        -- Undershirt
        undershirt = GetNumberOfPedDrawableVariations(ped, 8) - 1,
        undershirt_txd = GetNumberOfPedTextureVariations(ped, 8, localSkin.undershirt) - 1,
        -- Kevlar
        bodyarmor = GetNumberOfPedDrawableVariations(ped, 9) - 1,
        bodyarmor_txd = GetNumberOfPedTextureVariations(ped, 9, localSkin.bodyarmor) - 1,
        -- Decals
        decals = GetNumberOfPedDrawableVariations(ped, 10) - 1,
        decals_txd = GetNumberOfPedTextureVariations(ped, 10, localSkin.decals) - 1,
        -- Torso
        tops = GetNumberOfPedDrawableVariations(ped, 11) - 1,
        tops_txd = GetNumberOfPedTextureVariations(ped, 11, localSkin.tops) - 1,
        -- #endregion Components

        -- #region Props
        -- Hats
        hats = GetNumberOfPedPropDrawableVariations(ped, 0) - 1,
        hats_txd = localSkin.hats == -1 and 0 or (GetNumberOfPedPropTextureVariations(ped, 0, localSkin.hats) - 1),
        -- Glasses
        glasses = GetNumberOfPedPropDrawableVariations(ped, 1) - 1,
        glasses_txd = localSkin.glasses == -1 and 0 or (GetNumberOfPedPropTextureVariations(ped, 1, localSkin.glasses) - 1),
        -- Ears
        ears = GetNumberOfPedPropDrawableVariations(ped, 2) - 1,
        ears_txd = localSkin.ears == -1 and 0 or (GetNumberOfPedPropTextureVariations(ped, 2, localSkin.ears) - 1),
        -- Watches
        watches = GetNumberOfPedPropDrawableVariations(ped, 6) - 1,
        watches_txd = localSkin.watches == -1 and 0 or (GetNumberOfPedPropTextureVariations(ped, 6, localSkin.watches) - 1),
        -- Bracelets
        bracelets = GetNumberOfPedPropDrawableVariations(ped, 7) - 1,
        bracelets_txd = localSkin.bracelets == -1 and 0 or (GetNumberOfPedPropTextureVariations(ped, 7, localSkin.bracelets) - 1),
        -- #endregion Props
    }
end
exports("getMaxValues", getMaxValues)

---Get min values for all skins
---@return skin
function getMinValues()
    local values = {}
    for name, value in pairs(AVAConfig.skinComponents) do
        values[name] = value.min
    end
    return values
end
exports("getMinValues", getMinValues)

---Reload ped overlays, hairs and tattoos
---@param ped entity
function reloadPedOverlays(ped)
    saveOrRestorePlayerLocalSkin(ped)

    reloadPedOverlaysInternal(ped)
end
exports("reloadPedOverlays", reloadPedOverlays)

---Edit player skin array but do not apply it
---@param skin skin
---@return skin
function editPlayerSkinWithoutApplying(skin)
    saveOrRestorePlayerLocalSkin(PlayerPedId())

    if skin then
        for component, _ in pairs(AVAConfig.skinComponents) do
            if skin[component] then
                localSkin[component] = skin[component]
            end
        end
    end

    return localSkin
end
exports("editPlayerSkinWithoutApplying", editPlayerSkinWithoutApplying)
