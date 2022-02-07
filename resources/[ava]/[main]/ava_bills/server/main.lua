-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- #region inserts
---Send a bill from a player to another player
---@param sourceCitizenId "source player's citizen id"
---@param targetCitizenId "target player's citizen id"
---@param amount "amount of money"
---@param content "content of the bill"
---@return integer|nil "bill id or nil"
local sendBillToPlayer = function(sourceCitizenId, targetCitizenId, amount, content)
    if type(amount) == "number" and type(content) == "string" and amount > 0 and content:len() > 2 and sourceCitizenId ~= targetCitizenId then
        local id = MySQL.insert.await(
            "INSERT INTO `ava_bills`(`type`, `player_from`, `player_to`, `amount`, `content`) VALUES (0, :player_from, :player_to, :amount, :content)",
            {player_from = sourceCitizenId, player_to = targetCitizenId, amount = amount, content = content:sub(0, 256)})
        return id
    end
    return nil
end
exports("sendBillToPlayer", sendBillToPlayer)

---Send a bill from a job to a player
---@param sourceJobName "source job name"
---@param targetCitizenId "target player's citizen id"
---@param amount "amount of money"
---@param content "content of the bill"
---@param sourceCitizenId? "source player's citizen id or nil"
---@return integer|nil "bill id or nil"
local sendJobBillToPlayer = function(sourceJobName, targetCitizenId, amount, content, sourceCitizenId)
    if type(amount) == "number" and type(content) == "string" and amount > 0 and content:len() > 2 then
        local id = MySQL.insert.await(
            "INSERT INTO `ava_bills`(`type`, `player_to`, `job_from`, `player_from`, `amount`, `content`) VALUES (2, :player_to, :job_from, :player_from, :amount, :content)",
            {player_to = targetCitizenId, job_from = sourceJobName, amount = amount, content = content:sub(0, 256), player_from = sourceCitizenId})
        return id
    end
    return nil
end
exports("sendJobBillToPlayer", sendJobBillToPlayer)

---Send a bill from a player to a job
---@param sourceCitizenId "source player's citizen id"
---@param targetJobName "target job name"
---@param amount "amount of money"
---@param content "content of the bill"
---@return integer|nil "bill id or nil"
local sendBillToJob = function(sourceCitizenId, targetJobName, amount, content)
    if type(amount) == "number" and type(content) == "string" and amount > 0 and content:len() > 2 then
        local id = MySQL.insert.await(
            "INSERT INTO `ava_bills`(`type`, `player_from`, `job_to`, `amount`, `content`) VALUES (1, :player_from, :job_to, :amount, :content)",
            {player_from = sourceCitizenId, job_to = targetJobName, amount = amount, content = content:sub(0, 256)})
        return id
    end
    return nil
end
exports("sendBillToJob", sendBillToJob)

---Send a bill from a job to another job
---@param sourceJobName "source job name"
---@param targetJobName "target job name"
---@param amount "amount of money"
---@param content "content of the bill"
---@param sourceCitizenId? "source player's citizen id or nil"
---@return integer|nil "bill id or nil"
local sendJobBillToJob = function(sourceJobName, targetJobName, amount, content, sourceCitizenId)
    if type(amount) == "number" and type(content) == "string" and amount > 0 and content:len() > 2 and sourceJobName ~= targetJobName then
        local id = MySQL.insert.await(
            "INSERT INTO `ava_bills`(`type`, `job_from`, `job_to`, `player_from`, `amount`, `content`) VALUES (3, :job_from, :job_to, :player_from, :amount, :content)",
            {job_from = sourceJobName, job_to = targetJobName, player_from = sourceCitizenId, amount = amount, content = content:sub(0, 256)})
        return id
    end
    return nil
end
exports("sendJobBillToJob", sendJobBillToJob)

RegisterNetEvent("ava_bills:server:sendBillToPlayer", function(targetId, amount, content)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local aTargetPlayer = exports.ava_core:GetPlayer(targetId)
    if aPlayer and aTargetPlayer and sendBillToPlayer(aPlayer.citizenId, aTargetPlayer.citizenId, amount, content) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("bill_sent"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
        TriggerClientEvent("ava_core:client:ShowNotification", targetId, GetString("bill_received"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
    end
end)

RegisterNetEvent("ava_bills:server:sendJobBillToPlayer", function(sourceJobName, targetId, amount, content)
    local src = source
    if type(sourceJobName) == "string" and IsPlayerAceAllowed(src, "job." .. sourceJobName .. ".manage") then
        local aPlayer = exports.ava_core:GetPlayer(src)
        local aTargetPlayer = exports.ava_core:GetPlayer(targetId)
        if aPlayer and aTargetPlayer then
            if sendJobBillToPlayer(sourceJobName, aTargetPlayer.citizenId, amount, content, aPlayer.citizenId) then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("bill_sent"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
                TriggerClientEvent("ava_core:client:ShowNotification", targetId, GetString("bill_received"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
            end
        end
    end
end)

RegisterNetEvent("ava_bills:server:sendBillToJob", function(targetJobName, amount, content)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer and sendBillToJob(aPlayer.citizenId, targetJobName, amount, content) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("bill_sent"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
    end
end)

RegisterNetEvent("ava_bills:server:sendJobBillToJob", function(sourceJobName, targetJobName, amount, content)
    local src = source
    if type(sourceJobName) == "string" and IsPlayerAceAllowed(src, "job." .. sourceJobName .. ".manage") then
        local aPlayer = exports.ava_core:GetPlayer(src)
        local aTargetPlayer = exports.ava_core:GetPlayer(targetId)
        if aPlayer and aTargetPlayer then
            if sendJobBillToJob(sourceJobName, targetJobName, amount, content, aPlayer.citizenId) then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("bill_sent"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
            end
        end
    end
end)
-- #endregion inserts

-- #region getters
local getPlayerBills = function(citizenId)
    return MySQL.query.await(
        "SELECT `id`, `type`, `player_from`, `job_from`, `amount`, `content`, DATE_FORMAT(`date`, '%d/%m/%Y') AS `date` FROM `ava_bills` WHERE `player_to` = :citizenId ORDER BY `date` DESC",
        {citizenId = citizenId}) or {}
end
exports("getPlayerBills", getPlayerBills)
local getPlayerBillsSent = function(citizenId)
    return MySQL.query.await(
        "SELECT `id`, `type`, `player_to`, `job_to`, `amount`, `content`, DATE_FORMAT(`date`, '%d/%m/%Y') AS `date` FROM `ava_bills` WHERE `player_from` = :citizenId ORDER BY `date` DESC",
        {citizenId = citizenId}) or {}
end
exports("getPlayerBillsSent", getPlayerBillsSent)

local getJobBills = function(jobName)
    return MySQL.query.await(
        "SELECT `id`, `type`, `player_from`, `job_from`, `amount`, `content`, DATE_FORMAT(`date`, '%d/%m/%Y') AS `date` FROM `ava_bills` WHERE `job_to` = :jobName ORDER BY `date` DESC",
        {jobName = jobName}) or {}
end
exports("getJobBills", getJobBills)
local getJobBillsSent = function(jobName)
    return MySQL.query.await(
        "SELECT `id`, `type`, `player_to`, `job_to`, `amount`, `content`, DATE_FORMAT(`date`, '%d/%m/%Y') AS `date` FROM `ava_bills` WHERE `job_from` = :jobName ORDER BY `date` DESC",
        {jobName = jobName}) or {}
end
exports("getJobBillsSent", getJobBillsSent)

exports.ava_core:RegisterServerCallback("ava_bills:server:getPlayerBills", function(source)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        return getPlayerBills(aPlayer.citizenId)
    end
end)

exports.ava_core:RegisterServerCallback("ava_bills:server:getJobBills", function(source, jobName)
    local src = source
    if type(jobName) ~= "string" or not IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        return
    end
    return getJobBills(jobName)
end)

-- #endregion getters
---Make source pay a bill
---@param source number
---@param billId number
---@return boolean "success"
local sourcePayBill = function(source, billId)
    local src = source
    if not billId or type(billId) ~= "number" then
        return false
    end
    local bill = MySQL.single.await(
        "SELECT `type`, `player_from`, `player_to`, `job_from`, `job_to`, `amount`, `content` FROM `ava_bills` WHERE `id` = :billId", {billId = billId})
    print(billId, json.encode(bill, {indent = true}))
    if not bill then
        return false
    end
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return false
    end

    local billWasPaid = false

    if bill.player_to and bill.player_to == aPlayer.citizenId then
        -- Is bill to player, will be paid with player bank account
        if aPlayer.getAccountBalance("bank") < bill.amount then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_not_enough_money"))
            return false
        end

        print("type", bill.type)
        if bill.type == 0 then
            -- Player to player
            local aPlayerFrom = exports.ava_core:GetPlayerByCitizenId(bill.player_from)
            if not aPlayerFrom then
                -- TODO pay disconnected player
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("target_is_not_in_city"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
                return false
            end
            aPlayer.removeAccountBalance("bank", bill.amount)
            aPlayerFrom.addAccountBalance("bank", bill.amount)
            billWasPaid = true

            local formatedAmount<const> = exports.ava_core:FormatNumber(bill.amount)
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("you_paid_bill", formatedAmount), nil, "CHAR_BANK_FLEECA", GetString("bank"))
            TriggerClientEvent("ava_core:client:ShowNotification", aPlayerFrom.src, GetString("bill_paid_by_player", formatedAmount), nil, "CHAR_BANK_FLEECA",
                GetString("bank"))

        elseif bill.type == 2 then
            -- Job to player
            local accountsFrom = exports.ava_core:GetJobAccounts(bill.job_from)
            if not accountsFrom then
                return false
            end
            aPlayer.removeAccountBalance("bank", bill.amount)
            accountsFrom.addAccountBalance("bank", bill.amount)
            billWasPaid = true

            local formatedAmount<const> = exports.ava_core:FormatNumber(bill.amount)
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("you_paid_bill", formatedAmount), nil, "CHAR_BANK_FLEECA", GetString("bank"))

            -- Send notification to the player that sended the job bill, if there is one
            if bill.player_from then
                local aPlayerFrom = exports.ava_core:GetPlayerByCitizenId(bill.player_from)
                if aPlayerFrom then
                    TriggerClientEvent("ava_core:client:ShowNotification", aPlayerFrom.src, GetString("job_bill_paid_by_player", formatedAmount), nil,
                        "CHAR_BANK_FLEECA", GetString("bank"))
                end
            end
        end

    elseif bill.job_to and IsPlayerAceAllowed(src, "job." .. bill.job_to .. ".manage") then
        -- Is bill to job, will be paid with job bank account
        local accounts = exports.ava_core:GetJobAccounts(bill.job_to)
        if not accounts then
            return false
        end
        if accounts.getAccountBalance("bank") < bill.amount then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_not_enough_money"))
            return false
        end

        if bill.type == 1 then
            -- Player to job
            local aPlayerFrom = exports.ava_core:GetPlayerByCitizenId(bill.player_from)
            if not aPlayerFrom then
                -- TODO pay disconnected player
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("target_is_not_in_city"), nil, "CHAR_BANK_FLEECA", GetString("bank"))
                return false
            end
            accounts.removeAccountBalance("bank", bill.amount)
            aPlayerFrom.addAccountBalance("bank", bill.amount)
            billWasPaid = true

            local formatedAmount<const> = exports.ava_core:FormatNumber(bill.amount)
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("your_job_paid_bill", formatedAmount), nil, "CHAR_BANK_FLEECA",
                GetString("bank"))
            TriggerClientEvent("ava_core:client:ShowNotification", aPlayerFrom.src, GetString("bill_paid_by_job", formatedAmount), nil, "CHAR_BANK_FLEECA",
                GetString("bank"))

        elseif bill.type == 3 then
            -- Job to job
            local accountsFrom = exports.ava_core:GetJobAccounts(bill.job_from)
            if not accountsFrom then
                return false
            end
            accounts.removeAccountBalance("bank", bill.amount)
            accountsFrom.addAccountBalance("bank", bill.amount)
            billWasPaid = true

            local formatedAmount<const> = exports.ava_core:FormatNumber(bill.amount)
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("your_job_paid_bill", formatedAmount), nil, "CHAR_BANK_FLEECA",
                GetString("bank"))

            -- Send notification to the player that sended the job bill, if there is one
            if bill.player_from then
                local aPlayerFrom = exports.ava_core:GetPlayerByCitizenId(bill.player_from)
                if not aPlayerFrom then
                    TriggerClientEvent("ava_core:client:ShowNotification", aPlayerFrom.src, GetString("job_bill_paid_by_job", formatedAmount), nil,
                        "CHAR_BANK_FLEECA", GetString("bank"))
                end
            end
        end
    end

    if billWasPaid then
        MySQL.update.await("DELETE FROM `ava_bills` WHERE `id` = :id", {id = billId})
    end
    return billWasPaid
end
exports("sourcePayBill", sourcePayBill)

exports.ava_core:RegisterServerCallback("ava_bills:server:payBill", function(source, billId)
    return sourcePayBill(source, billId)
end)
