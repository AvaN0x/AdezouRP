-------------------------------------------
------- EDITED BY GITHUB.COM/AVAN0X -------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("bank:deposit", function(amount)
    if not amount then
        return
    end
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()
    amount = math.floor(tonumber(amount))

    if amount == nil or amount <= 0 or not inventory.canRemoveItem("cash", amount) then
        TriggerClientEvent("bank:result", src, "error", "Montant invalide.")
    else
        inventory.removeItem("cash", amount)
        aPlayer.addAccountBalance("bank", amount)
        TriggerEvent("ava_logs:server:log", { aPlayer.citizenId, "deposit", amount })
    end
end)

RegisterNetEvent("bank:withdraw", function(amount)
    if not amount then
        return
    end
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()
    amount = math.floor(tonumber(amount))

    if amount == nil or amount <= 0 or amount > aPlayer.getAccountBalance("bank") then
        TriggerClientEvent("bank:result", src, "error", "Montant invalide.")
    elseif not inventory.canAddItem("cash", amount) then
        TriggerClientEvent("bank:result", src, "error", "Vous ne pouvez pas porter autant de liquide sur vous.")
    else
        aPlayer.removeAccountBalance("bank", amount)
        inventory.addItem("cash", amount)
        TriggerEvent("ava_logs:server:log", { aPlayer.citizenId, "withdraw", amount })
    end
end)

RegisterNetEvent("bank:balance", function()
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    TriggerClientEvent("currentbalance", src, aPlayer.getAccountBalance("bank"))
end)

RegisterNetEvent("bank:transfer", function(target, amount)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)

    if tostring(aPlayer.citizenId) == tostring(target) then
        TriggerClientEvent("bank:result", src, "error", "Vous ne pouvez pas faire de transfert à vous même.")
    else
        local aTargetPlayer = exports.ava_core:GetPlayerByCitizenId(tostring(target))
        if not aTargetPlayer then
            TriggerClientEvent("bank:result", src, "error", "Destinataire introuvable.")
        else
            amount = math.floor(tonumber(amount))
            local balance = aPlayer.getAccountBalance("bank")

            if balance < amount or amount <= 0 then
                TriggerClientEvent("bank:result", src, "error", "Vous n'avez pas assez d'argent en banque.")
            else
                aPlayer.removeAccountBalance("bank", amount)
                aTargetPlayer.addAccountBalance("bank", amount)
                TriggerClientEvent("ava_core:client:ShowNotification", aTargetPlayer.src, nil, nil, "CHAR_BANK_FLEECA", "Vous avez reçu",
                    ("$~g~%s~s~"):format(amount), nil, "CHAR_BANK_FLEECA")
                TriggerClientEvent("bank:result", src, "success", "Transfert effectué.")
                TriggerEvent("ava_logs:server:log", { aPlayer.citizenId, "transfer to", aTargetPlayer.citizenId, amount })
            end
        end
    end
end)
