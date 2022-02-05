-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
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

