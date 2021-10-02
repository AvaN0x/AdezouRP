-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava_jobs:server:bank_managment:deposit", function(jobName, amount)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local accounts = exports.ava_core:GetJobsAccounts(jobName)

    if accounts then
        local inventory = aPlayer.getInventory()
        amount = math.floor(tonumber(amount))

        if amount == nil or amount <= 0 or not inventory.canRemoveItem("cash", amount) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("amount_invalid"))
        else
            inventory.removeItem("cash", amount)
            accounts.addAccountBalance("bank", amount)
        end
    end
end)

RegisterNetEvent("ava_jobs:server:bank_managment:withdraw", function(jobName, amount)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local accounts = exports.ava_core:GetJobsAccounts(jobName)

    if accounts then
        local inventory = aPlayer.getInventory()
        amount = math.floor(tonumber(amount))

        if amount == nil or amount <= 0 or amount > accounts.getAccountBalance("bank") then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("amount_invalid"))
        elseif not inventory.canAddItem("cash", amount) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_hold_that_much_cash"))
        else
            accounts.removeAccountBalance("bank", amount)
            inventory.addItem("cash", amount)
        end
    end
end)

RegisterNetEvent("ava_jobs:server:bank_managment:washMoney", function(jobName, amount)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local accounts = exports.ava_core:GetJobsAccounts(jobName)

    if accounts then
        local inventory = aPlayer.getInventory()
        amount = math.floor(tonumber(amount))

        if amount == nil or amount <= 0 or not inventory.canRemoveItem("dirtycash", amount) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("amount_invalid"))
        else
            inventory.removeItem("dirtycash", amount)
            accounts.addAccountBalance("bank", amount)
        end
    end
end)
