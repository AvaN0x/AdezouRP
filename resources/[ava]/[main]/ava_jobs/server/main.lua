-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
CoreJobs = exports.ava_core:GetJobsData()

-- #region services
local jobsServices = {}

RegisterServerEvent("ava_jobs:setService", function(jobName, state)
    local src = source
    if not jobsServices[jobName] then
        jobsServices[jobName] = {}
    end
    jobsServices[jobName][tostring(src)] = state and true or nil
    print(src, jobName, state, jobsServices[jobName][tostring(src)])
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    for jobName, v in pairs(jobsServices) do
        if v[source] ~= nil then
            jobsServices[jobName][tostring(src)] = nil
        end
    end
end)

---Get count of players in service
---@param jobName string
---@return number count
function getCountInService(jobName)
    local count = 0
    local debugString = ""
    if CoreJobs[jobName] and jobsServices[jobName] then
        local ace = "ace.job." .. jobName .. ".main"
        for _, playerSrc in pairs(GetPlayers()) do
            if IsPlayerAceAllowed(playerSrc, ace) and jobsServices[jobName][tostring(playerSrc)] ~= nil then
                count = count + 1
                debugString = debugString .. tostring(playerSrc) .. " "
            end
        end
    end
    exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_dev", "asked for count of " .. jobName,
        "ID des joueurs : " .. debugString .. "\ncount value : `" .. count .. "`", 15902015)
    return count
end
exports("getCountInService", isInService)

---Check if a player is in service
---@param source any
---@param job string
---@return boolean
function isInService(source, jobName)
    return (CoreJobs[jobName] and jobsServices[jobName]) and jobsServices[jobName][tostring(source)] == true or false
end
exports("isInService", isInService)

---Check if a player is in service or has a job
---@param source any
---@param jobName string
---@return boolean
function isInServiceOrHasJob(source, jobName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    return isInService(source, jobName) or aPlayer.hasJob(jobName)
end
exports("isInServiceOrHasJob", isInServiceOrHasJob)
-- #endregion
