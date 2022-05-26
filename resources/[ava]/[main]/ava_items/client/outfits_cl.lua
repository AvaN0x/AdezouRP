-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local appliedOutfit = nil
local savePlayerClothes = nil
local Outfits<const> = {
    jail = {
        Male = json.decode(
            "{\"bag_txd\":0,\"bracelets\":-1,\"watches\":-1,\"accessory\":0,\"ears\":-1,\"mask\":0,\"torso\":5,\"undershirt\":15,\"ears_txd\":0,\"leg\":9,\"shoes_txd\":0,\"bag\":0,\"hats\":-1,\"bracelets_txd\":0,\"bodyarmor\":0,\"bodyarmor_txd\":0,\"undershirt_txd\":0,\"accessory_txd\":0,\"tops_txd\":0,\"shoes\":61,\"tops\":5,\"torso_txd\":0,\"decals\":0,\"watches_txd\":0,\"decals_txd\":0,\"mask_txd\":6,\"hats_txd\":0,\"leg_txd\":4}"),
        Female = json.decode(
            "{\"bag_txd\":0,\"bracelets\":-1,\"watches\":-1,\"accessory\":0,\"ears\":-1,\"mask\":0,\"torso\":15,\"undershirt\":14,\"ears_txd\":0,\"leg\":134,\"shoes_txd\":12,\"bag\":0,\"hats\":-1,\"bracelets_txd\":0,\"bodyarmor\":0,\"bodyarmor_txd\":0,\"undershirt_txd\":0,\"accessory_txd\":0,\"tops_txd\":0,\"shoes\":72,\"tops\":247,\"torso_txd\":0,\"decals\":0,\"watches_txd\":0,\"decals_txd\":0,\"mask_txd\":18,\"hats_txd\":0,\"leg_txd\":4}"),
    },
}

local function applyClothesAnimation()
    local playerPed = PlayerPedId()
    exports.ava_core:RequestAnimDict("mp_safehouseshower@male@")
    TaskPlayAnim(playerPed, "mp_safehouseshower@male@", "male_shower_towel_dry_to_get_dressed", 8.0, -8, 9500, 0, 0, 0, 0, 0)
    RemoveAnimDict("mp_safehouseshower@male@")

    exports.progressBars:startUI(9500, "")
    Wait(9500)
    ClearPedSecondaryTask(playerPed)
end

local function removeOutfit()
    applyClothesAnimation()
    if savePlayerClothes then
        exports.ava_mp_peds:setPlayerClothes(savePlayerClothes)
    end
    appliedOutfit = nil
    savePlayerClothes = nil
end

RegisterNetEvent("ava_items:client:useOutfit", function(outfitName)
    if not Outfits[outfitName] then
        return
    end
    if appliedOutfit and appliedOutfit ~= outfitName then
        exports.ava_core:ShowNotification(GetString("you_must_remove_applied_outfit"))
        return
    end
    if appliedOutfit then
        removeOutfit()
    else
        appliedOutfit = outfitName
        savePlayerClothes = exports.ava_mp_peds:getPlayerClothes()
        local playerSkin = exports.ava_core:getPlayerSkinData()
        applyClothesAnimation()
        exports.ava_mp_peds:setPlayerClothes(Outfits[outfitName][playerSkin.gender == 0 and "Male" or "Female"])
    end
end)

RegisterNetEvent("ava_core:client:editItemInventoryCount", function(itemName, itemLabel, isAddition, editedQuantity, newQuantity)
    if appliedOutfit and newQuantity == 0 and AVAConfig.OutfitItemNames[itemName] == appliedOutfit then
        removeOutfit()
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if appliedOutfit and resource == GetCurrentResourceName() then
        if savePlayerClothes then
            exports.ava_mp_peds:setPlayerClothes(savePlayerClothes)
        end
    end
end)
