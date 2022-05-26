-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local bodyArmorOn = false
local clothesBodyArmorSave = {}

---@type function
local equipBodyArmor, removeBodyArmor

RegisterNetEvent("ava_items:client:useBodyarmor", function()
    local playerPed = PlayerPedId()
    if not bodyArmorOn then
        equipBodyArmor(playerPed)
    else
        removeBodyArmor(playerPed, true)
    end
end)

equipBodyArmor = function(playerPed)
    bodyArmorOn = true

    if not IsEntityPlayingAnim(playerPed, "clothingtie", "try_tie_negative_a", 3) then
        exports.ava_core:RequestAnimDict("clothingtie")
        TaskPlayAnim(playerPed, "clothingtie", "try_tie_negative_a", 8.0, -8, -1, 49, 0, 0, 0, 0)
        RemoveAnimDict("clothingtie")
    end

    exports["progressBars"]:startUI((2000), GetString("bodyarmor_equip_progressbar"))
    Wait(2000)
    ClearPedSecondaryTask(playerPed)

    SetPedArmour(playerPed, 100)
    local playerSkin = exports.ava_mp_peds:getPlayerCurrentSkin()
    clothesBodyArmorSave = {bodyarmor = playerSkin.bodyarmor, bodyarmor_txd = playerSkin.bodyarmor_txd}

    if playerSkin.gender == 0 then -- male
        exports.ava_mp_peds:setPlayerClothes({bodyarmor = 26, bodyarmor_txd = 9})
    else
        exports.ava_mp_peds:setPlayerClothes({bodyarmor = 27, bodyarmor_txd = 9})
    end

    exports.ava_core:ShowNotification(GetString("bodyarmor_equip"))

    Citizen.CreateThread(function()
        while bodyArmorOn do
            Wait(500)
            if GetPedArmour(PlayerPedId()) == 0 then
                removeBodyArmor(PlayerPedId())
                TriggerServerEvent("ava_items:server:bodyarmor:remove")
            end
        end
    end)

end

removeBodyArmor = function(playerPed, playAnim)
    bodyArmorOn = false

    if playAnim then
        if not IsEntityPlayingAnim(playerPed, "clothingtie", "try_tie_negative_a", 3) then
            exports.ava_core:RequestAnimDict("clothingtie")
            TaskPlayAnim(playerPed, "clothingtie", "try_tie_negative_a", 8.0, -8, -1, 49, 0, 0, 0, 0)
            RemoveAnimDict("clothingtie")
        end

        exports["progressBars"]:startUI((2000), GetString("bodyarmor_unequip_progressbar"))
        Wait(2000)
        ClearPedSecondaryTask(playerPed)
    end

    SetPedArmour(playerPed, 0)
    exports.ava_mp_peds:setPlayerClothes({bodyarmor = clothesBodyArmorSave.bodyarmor, bodyarmor_txd = clothesBodyArmorSave.bodyarmor_txd})
    clothesBodyArmorSave = {}

    exports.ava_core:ShowNotification(GetString("bodyarmor_unequip"))
end

RegisterNetEvent("ava_core:client:editItemInventoryCount", function(itemName, itemLabel, isAddition, editedQuantity, newQuantity)
    if bodyArmorOn and itemName == "bodyarmor" and newQuantity == 0 then
        removeBodyArmor(PlayerPedId(), true)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if bodyArmorOn and resource == GetCurrentResourceName() then
        removeBodyArmor(PlayerPedId())
    end
end)
