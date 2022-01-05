-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local localSkin = {}
local localPlayerSkinSave = nil
local NumHairColors<const> = GetNumHairColors()

local Categories = {
    gender = {
        components = {"gender"},
        setPed = function(ped)
            local model<const> = localSkin.gender == 0 and GetHashKey("mp_m_freemode_01") or GetHashKey("mp_f_freemode_01")

            if model ~= GetEntityModel(ped) and IsModelValid(model) and IsModelInCdimage(model) then
                local p = promise.new()
                Citizen.CreateThread(function()
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Wait(0)
                    end

                    SetPlayerModel(PlayerId(), model)
                    ped = PlayerPedId()

                    SetModelAsNoLongerNeeded(model)

                    p:resolve()
                end)
                Citizen.Await(p)
            end
            print("set default variation")
            ClearPedDecorations(ped)
            -- ClearPedDecorationsLeaveScars(ped)
            SetPedDefaultComponentVariation(ped)
            SetPedHairColor(ped, 0, 0)
            SetPedEyeColor(ped, 0)
            SetPedHeadBlendData(ped, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, false);
            ClearAllPedProps(ped, 0)
        end,
        -- updateMax = function()

        -- end,
    },
    -- TODO drawable 0
    -- TODO drawable 1
    hair = {
        components = {"hair", "hair_txd", "main_hair_color", "scnd_hair_color"},
        setPed = function(ped)
            ClearPedDecorationsLeaveScars(ped)
            -- Hair
            -- SetPedComponentVariation(ped, 2, localSkin.hair, localSkin.hair_txd, 2)
            SetPedComponentVariation(ped, 2, localSkin.hair, localSkin.hair_txd, 0)
            print(ped, 2, localSkin.hair, localSkin.hair_txd, 0)
            -- Hair Color
            SetPedHairColor(ped, localSkin.main_hair_color, localSkin.scnd_hair_color)
            print(ped, localSkin.main_hair_color, localSkin.scnd_hair_color)

            -- TODO Hair overlay
        end,
        updateMax = function(ped)
            AVAConfig.skinComponents.hair.max = GetNumberOfPedDrawableVariations(ped, 2) - 1
            AVAConfig.skinComponents.hair_txd.max = GetNumberOfPedTextureVariations(ped, 2, localSkin.hair) - 1
            AVAConfig.skinComponents.main_hair_color.max = NumHairColors - 1
            AVAConfig.skinComponents.scnd_hair_color.max = NumHairColors - 1
        end,
    },
    -- gender = {
    --     components = {"gender"},
    --     setPed = function(ped)

    --     end,
    --     updateMax = function()

    --     end,
    -- },
}

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

local function setPedCategoryInternal(ped, category, skin)
    if skin then
        for i = 0, #category.components do
            local component<const> = category.components[i]
            if skin[component] then
                localSkin[component] = skin[component]
            end
        end
    end

    print("Applying skin category with " .. json.encode(category.components) .. " to " .. ped)
    category.setPed(ped)
    if category.updateMax then
        category.updateMax(ped)
    end
end

---Set a ped component from a category
---@param ped entity
---@param category string
---@param skin table
function setPedSkinWithCategory(ped, category, skin)
    saveOrRestorePlayerLocalSkin(ped)

    if Categories[category] then
        if category == "gender" and ped ~= PlayerPedId() then
            print("^1[ERROR] An error occured, you cannot change the gender of a non player ped.^0")
            return
        end
        setPedCategoryInternal(ped, Categories[category], skin)
    end
end
exports("setPedSkinWithCategory", setPedSkinWithCategory)

---Set ped components based on all categories
---@param ped entity
---@param skin table
function setPedSkin(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)

    -- TODO start with gender
    print("Setting skin to " .. ped)
    if ped == PlayerPedId() then
        setPedCategoryInternal(ped, Categories["gender"], skin)
        ped = PlayerPedId()
    end
    for categoryName, category in pairs(Categories) do
        if categoryName ~= "gender" then
            setPedCategoryInternal(ped, category, skin)
        end
    end
end
exports("setPedSkin", setPedSkin)

---Apply ped components from the skin array
---@param ped entity
---@param skin table
function applyPedSkin(ped, skin)
    saveOrRestorePlayerLocalSkin(ped)
    local categories = {}

    -- go on every element from skin, add the category to categories and set it
    -- TODO start with gender

end
exports("applyPedSkin", applyPedSkin)

---Returns player skin
---@return table
function getPlayerSkin()
    return localPlayerSkinSave or localSkin
end
exports("getPlayerSkin", getPlayerSkin)