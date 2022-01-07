-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local localSkin = {}
local localPlayerSkinSave = nil
local NumHairColors<const> = GetNumHairColors()
local NumMakeupColors<const> = GetNumMakeupColors()

-- AVAConfig.skinComponents.hair.max = GetNumberOfPedDrawableVariations(ped, 2) - 1
-- AVAConfig.skinComponents.hair_txd.max = GetNumberOfPedTextureVariations(ped, 2, localSkin.hair) - 1
-- AVAConfig.skinComponents.hair_main_color.max = NumHairColors - 1
-- AVAConfig.skinComponents.hair_scnd_color.max = NumHairColors - 1

-- Init local skin to default values
for element, value in pairs(AVAConfig.skinComponents) do
    localSkin[element] = value.default or value.min
end

---Depending on the ped type, it will either save the player skin from localSkin for later, either restore the player skin into localSkin
---@param ped entity
local function saveOrRestorePlayerLocalSkin(ped)
    -- If player is local player
    if IsPedAPlayer(ped) and PlayerPedId() == ped then
        -- If we had a save, then we restore it
        if localPlayerSkinSave then
            print("^1[DEBUG]^0 Restoring player skin")
            print("localPlayerSkinSave before", json.encode(localPlayerSkinSave, {indent = true}))
            for element, value in pairs(AVAConfig.skinComponents) do
                localSkin[element] = localPlayerSkinSave[element] or value.default or value.min
            end
            print("localSkin after", json.encode(localSkin, {indent = true}))
            localPlayerSkinSave = nil
        end
    else
        -- The ped is not the player ped
        -- If the localSkin is not already saved, we save it
        if not localPlayerSkinSave then
            localPlayerSkinSave = {}
            print("^1[DEBUG]^0 Saving player skin")
            print("localSkin before", json.encode(localSkin, {indent = true}))
            for element, value in pairs(AVAConfig.skinComponents) do
                -- Save value
                localPlayerSkinSave[element] = localSkin[element] or value.default or value.min
                -- Set value to default for localSkin
                localSkin[element] = value.default or value.min
            end
            print("localSkin after", json.encode(localSkin, {indent = true}))
            print("localPlayerSkinSave after", json.encode(localPlayerSkinSave, {indent = true}))
        end
    end
end

---Set ped components based on clothes components, internal
---@param ped entity
---@param skin table
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

-------------
-- EXPORTS --
-------------

---Set ped components based on skin components
---@param ped entity
---@param skin table
function setPedSkin(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)

    if skin then
        for component, _ in pairs(AVAConfig.skinComponents) do
            if skin[component] then
                localSkin[component] = skin[component]
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
    end
    -- #endregion Set player model

    ClearPedDecorations(ped)
    SetPedDefaultComponentVariation(ped)
    ClearAllPedProps(ped, 0)

    -- #region HeadBlendData
    SetPedHeadBlendData(ped, localSkin.mother, localSkin.father, 0, localSkin.mother, localSkin.father, 0, (localSkin.shape_mix / 100) + 0.0,
        (localSkin.skin_mix / 100) + 0.0, 0.0, false)
    while not HasPedHeadBlendFinished(ped) do
        Wait(0)
    end
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
    SetPedFaceFeature(ped, 6, (localSkin.eyebrown_high / 100) + 0.0) -- Eyebrow height
    SetPedFaceFeature(ped, 7, (localSkin.eyebrown_forward / 100) + 0.0) -- Eyebrow depth

    -- Cheeks
    SetPedFaceFeature(ped, 8, (localSkin.cheeks_bone_high / 100) + 0.0) -- Cheekbones Height
    SetPedFaceFeature(ped, 9, (localSkin.cheeks_bone_width / 100) + 0.0) -- Cheekbones Width
    SetPedFaceFeature(ped, 10, (localSkin.cheeks_width / 100) + 0.0) -- Cheeks Width

    -- Eyes
    SetPedFaceFeature(ped, 11, (localSkin.eyes_openning / 100) + 0.0) -- Eyes squint
    SetPedEyeColor(ped, localSkin.eyes_color) -- Eyes color

    -- Lips
    SetPedFaceFeature(ped, 12, (localSkin.lips_thickness / 100) + 0.0) -- Lip Fullness

    -- Jaw
    SetPedFaceFeature(ped, 13, (localSkin.jaw_bone_width / 100) + 0.0) -- Jaw Bone Width
    SetPedFaceFeature(ped, 14, (localSkin.jaw_bone_back_lenght / 100) + 0.0) -- Jaw Bone Length

    -- Chin
    SetPedFaceFeature(ped, 15, (localSkin.chimp_bone_lowering / 100) + 0.0) -- Chin Height
    SetPedFaceFeature(ped, 16, (localSkin.chimp_bone_lenght / 100) + 0.0) -- Chin Length
    SetPedFaceFeature(ped, 17, (localSkin.chimp_bone_width / 100) + 0.0) -- Chin Width
    SetPedFaceFeature(ped, 18, (localSkin.chimp_hole / 100) + 0.0) -- Chin Hole Size

    -- Neck
    SetPedFaceFeature(ped, 19, (localSkin.neck_thickness / 100) + 0.0) -- Neck Thickness
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
    SetPedHeadOverlayColor(ped, 5, 2, localSkin.blush_main_color) -- Blush Color
    -- Complexion
    SetPedHeadOverlay(ped, 6, localSkin.complexion, (localSkin.complexion_op / 100) + 0.0)
    -- SunDamage
    SetPedHeadOverlay(ped, 7, localSkin.sundamage, (localSkin.sundamage_op / 100) + 0.0)
    -- Lipstick
    SetPedHeadOverlay(ped, 8, localSkin.lipstick, (localSkin.lipstick_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 8, 1, localSkin.lipstick_main_color, localSkin.lipstick_scnd_color)
    -- Moles/Freckles
    SetPedHeadOverlay(ped, 9, localSkin.moles, (localSkin.moles_op / 100) + 0.0)
    -- Chest Hair
    SetPedHeadOverlay(ped, 10, localSkin.chesthair, (localSkin.chesthair_op / 100) + 0.0)
    SetPedHeadOverlayColor(ped, 10, 1, localSkin.chesthair_color, localSkin.chesthair_color)
    -- Body Blemishes
    SetPedHeadOverlay(ped, 11, localSkin.bodyblemishes == -1 and 255 or localSkin.bodyblemishes, (localSkin.bodyblemishes_op / 100) + 0.0)
    -- Add Body Blemishes
    SetPedHeadOverlay(ped, 12, localSkin.addbodyblemishes == -1 and 255 or localSkin.addbodyblemishes, (localSkin.addbodyblemishes_op / 100) + 0.0) -- Blemishes 'added body effect' + opacity
    -- #endregion Ped head overlays

    -- Hair
    SetPedComponentVariation(ped, 2, localSkin.hair, localSkin.hair_txd, 0)
    -- Hair Color
    SetPedHairColor(ped, localSkin.hair_main_color, localSkin.hair_scnd_color)

    -- Hair overlays and tattoos
    reloadPedOverlays(ped)

    setPedClothesInternal(ped, skin)
end
exports("setPedSkin", setPedSkin)

---Set ped components based on clothes components
---@param ped entity
---@param skin table
function setPedClothes(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)

    if skin then
        for i = 0, #AVAConfig.clothesComponents do
            local component<const> = AVAConfig.clothesComponents[i]
            if skin[component] then
                localSkin[component] = skin[component]
            end
        end
    end

    setPedClothesInternal(ped, skin)
end
exports("setPedClothes", setPedClothes)

---Returns player skin
---@return table
function getPlayerSkin()
    return localPlayerSkinSave or localSkin
end
exports("getPlayerSkin", getPlayerSkin)

---Reload ped overlays, hairs and tattoos
---@param ped entity
function reloadPedOverlays(ped)
    ClearPedDecorations(ped)

    if AVAConfig.HairOverlays[localSkin.gender] then
        local overlay<const> = AVAConfig.HairOverlays[localSkin.gender][localSkin.hair]
        if overlay and overlay.collection and overlay.overlay then
            print("^3[DEBUG]^0 Set hair overlays", overlay.collection, overlay.overlay)
            AddPedDecorationFromHashes(ped, overlay.collection, overlay.overlay)
        end
    end

    -- TODO tattoos
end
exports("reloadPlayerOverlays", reloadPlayerOverlays)

-------------------
-- DEBUG COMMAND -- 
-------------------

RegisterCommand("testmp", function(source, args, rawCommand)
    local skin = {
        [0] = {
            gender = 0,
            father = 12,
            mother = 24,
            shape_mix = 100,
            skin_mix = 100,

            -- Hairs
            hair = 57,
            hair_txd = 0,
            hair_main_color = 34,
            hair_scnd_color = 0,

            nose_width = 100,
            nose_peak_hight = 100,
            nose_peak_lenght = 100,
            nose_bone_high = 100,
            nose_peak_lowering = 100,
            nose_bone_twist = 100,

            eyebrown_high = 100,
            eyebrown_forward = 100,

            cheeks_bone_high = 100,
            cheeks_bone_width = 100,
            cheeks_width = 100,

            eyes_openning = 100,
            eyes_color = 100,

            lips_thickness = 100,

            jaw_bone_width = 100,
            jaw_bone_back_lenght = 100,

            chimp_bone_lowering = 100,
            chimp_bone_lenght = 100,
            chimp_bone_width = 100,
            chimp_hole = 100,

            neck_thickness = 100,

            mask = 0,
            mask_txd = 0,
            torso = 15,
            torso_txd = 0,
            leg = 61,
            leg_txd = 1,
            bag = 0,
            bag_txd = 0,
            shoes = 5,
            shoes_txd = 0,
            accessory = 0,
            accessory_txd = 0,
            undershirt = 15,
            undershirt_txd = 0,
            bodyarmor = 0,
            bodyarmor_txd = 0,
            decals = 0,
            decals_txd = 0,
            tops = 15,
            tops_txd = 0,

            hats = 35,
            hats_txd = 0,
            glasses = 31,
            glasses_txd = 0,
            ears = 1,
            ears_txd = 0,
            watches = 10,
            watches_txd = 0,
            bracelets = 2,
            bracelets_txd = 0,

            blemishes = 4,
            blemishes_op = 100,
            beard = 8,
            beard_op = 100,
            beard_color = 34,
            eyebrows = 0,
            eyebrows_op = 100,
            eyebrows_color = 34,
            ageing = 4,
            ageing_op = 100,
            makeup = 12,
            makeup_op = 100,
            makeup_main_color = 0,
            makeup_scnd_color = 0,
            blush = 0,
            blush_op = 100,
            blush_main_color = 0,
            complexion = 0,
            complexion_op = 100,
            sundamage = 0,
            sundamage_op = 100,
            lipstick = 4,
            lipstick_op = 100,
            lipstick_main_color = 0,
            lipstick_scnd_color = 0,
            moles = 5,
            moles_op = 100,
            chesthair = 8,
            chesthair_op = 100,
            chesthair_color = 34,
            bodyblemishes = 9,
            bodyblemishes_op = 100,
            addbodyblemishes = 0,
            addbodyblemishes_op = 100,
        },
        [1] = {
            gender = 1,
            -- Hairs
            hair = 80,
            hair_txd = 0,
            hair_main_color = 40,
            hair_scnd_color = 0,

        },
    }

    exports.ava_mp_peds:setPedSkin(PlayerPedId(), skin[args[1] and tonumber(args[1]) or 0])

    -- print(json.encode(exports.ava_mp_peds:getPlayerSkin(), {indent = true}))
    TriggerServerEvent("ava_core:server:reloadLoadout")
end)

