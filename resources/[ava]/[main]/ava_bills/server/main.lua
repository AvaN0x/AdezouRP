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
---@return integer|nil "bill id or nil"
local sendJobBillToPlayer = function(sourceJobName, targetCitizenId, amount, content)
    if type(amount) == "number" and type(content) == "string" and amount > 0 and content:len() > 2 then
        local id = MySQL.insert.await(
            "INSERT INTO `ava_bills`(`type`, `player_to`, `job_from`, `amount`, `content`) VALUES (2, :player_to, :job_from, :amount, :content)",
            {player_to = targetCitizenId, job_from = sourceJobName, amount = amount, content = content:sub(0, 256)})
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
---@return integer|nil "bill id or nil"
local sendJobBillToJob = function(sourceJobName, targetJobName, amount, content)
    if type(amount) == "number" and type(content) == "string" and amount > 0 and content:len() > 2 and sourceJobName ~= targetJobName then
        local id = MySQL.insert.await(
            "INSERT INTO `ava_bills`(`type`, `job_from`, `job_to`, `amount`, `content`) VALUES (3, :job_from, :job_to, :amount, :content)",
            {job_from = sourceJobName, job_to = targetJobName, amount = amount, content = content:sub(0, 256)})
        return id
    end
    return nil
end
exports("sendJobBillToJob", sendJobBillToJob)

RegisterNetEvent("ava_bills:server:sendBillToPlayer", function(target)
    -- TODO
end)

RegisterNetEvent("ava_bills:server:sendJobBillToPlayer", function(target)
    -- TODO
end)

RegisterNetEvent("ava_bills:server:sendBillToJob", function(jobName)
    -- TODO
end)

RegisterNetEvent("ava_bills:server:sendJobBillToJob", function(jobName)
    -- TODO
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

RegisterNetEvent("ava_bills:server:payBill", function(billId)
    local src = source
    if not billId or type(billId) ~= "number" then
        return
    end
    local bill = MySQL.single.await(
        "SELECT `type`, `player_from`, `player_to`, `job_from`, `job_to`, `amount`, `content` FROM `ava_bills` WHERE `id` = :billId", {billId = billId})
    print("json", json.encode(bill, {indent = true}))
    if not bill then
        return
    end
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end

    if bill.player_to and bill.player_to == aPlayer.citizenId then
        -- Is bill to player, will be paid with player bank account
        if aPlayer.getAccountBalance("bank") < bill.amount then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_not_enough_money"))
            return
        end

        if bill.type == 0 then
            -- Player to player
            -- TODO

        elseif bill.type == 2 then
            -- Job to player
            -- TODO

        end
    elseif bill.job_to and IsPlayerAceAllowed(src, "job." .. bill.job_to .. ".manage") then
        -- Is bill to job, will be paid with job bank account
        local accounts = exports.ava_core:GetJobAccounts(bill.job_to)
        if not accounts then
            return
        end
        if accounts.getAccountBalance("bank") < bill.amount then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_not_enough_money"))
            return
        end

        if bill.type == 1 then
            -- Player to job
            -- TODO

        elseif bill.type == 2 then
            -- Job to job
            -- TODO

        end
    end
end)

-- Citizen.CreateThread(function()
--     print("sendBillToPlayer", sendBillToPlayer(76, 58, 10, "Lorem ipsum"))
--     print("sendJobBillToPlayer", sendJobBillToPlayer("lspd", 58, 500, "Lorem ipsum"))
--     print("sendBillToJob", sendBillToJob(58, "lspd", 538, "Lorem ipsum"))
--     print("sendJobBillToJob", sendJobBillToJob("mechanic", "lspd", 12345, "Lorem ipsum"))

--     print(json.encode(getPlayerBills(58), {indent = true}))
--     print(json.encode(getJobBills("lspd"), {indent = true}))
-- end)
