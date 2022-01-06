-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local localSkin = {}
local localPlayerSkinSave = nil
local NumHairColors<const> = GetNumHairColors()

-- AVAConfig.skinComponents.hair.max = GetNumberOfPedDrawableVariations(ped, 2) - 1
-- AVAConfig.skinComponents.hair_txd.max = GetNumberOfPedTextureVariations(ped, 2, localSkin.hair) - 1
-- AVAConfig.skinComponents.main_hair_color.max = NumHairColors - 1
-- AVAConfig.skinComponents.scnd_hair_color.max = NumHairColors - 1

-- Init local skin to default values
for element, value in pairs(AVAConfig.allComponents) do
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
            for element, value in pairs(AVAConfig.allComponents) do
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
            for element, value in pairs(AVAConfig.allComponents) do
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

---Set ped components based on skin components, internal
---@param ped entity
---@param skin table
local function setPedSkinInternal(ped, skin)
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
    -- ClearPedDecorationsLeaveScars(ped)
    SetPedDefaultComponentVariation(ped)
    SetPedHairColor(ped, 0, 0)
    SetPedEyeColor(ped, 0)
    ClearAllPedProps(ped, 0)

    -- #region HeadBlend
    SetPedHeadBlendData(ped, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, false)
    while not HasPedHeadBlendFinished(ped) do
        Wait(0)
    end
    -- #endregion HeadBlend
    -- TODO drawable 0
    -- TODO drawable 1

    -- Hair
    SetPedComponentVariation(ped, 2, localSkin.hair, localSkin.hair_txd, 0)
    -- Hair Color
    SetPedHairColor(ped, localSkin.main_hair_color, localSkin.scnd_hair_color)

    -- Hair overlays and tattoos
    reloadPedOverlays(ped)
end

---Set ped components based on clothes components, internal
---@param ped entity
---@param skin table
local function setPedClothesInternal(ped, skin)

end

-------------
-- EXPORTS --
-------------

---Set ped components based on all components
---@param ped entity
---@param skin table
function setPedAllComponents(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)

    if skin then
        for component, _ in pairs(AVAConfig.allComponents) do
            if skin[component] then
                localSkin[component] = skin[component]
            end
        end
    end

    setPedSkinInternal(ped, skin)
    setPedClothesInternal(ped, skin)
end
exports("setPedAllComponents", setPedAllComponents)

---Set ped components based on skin components
---@param ped entity
---@param skin table
function setPedSkin(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)

    if skin then
        for i = 0, #AVAConfig.skinComponents do
            local component<const> = AVAConfig.skinComponents[i]
            if skin[component] then
                localSkin[component] = skin[component]
            end
        end
    end

    setPedSkinInternal(ped, skin)
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

