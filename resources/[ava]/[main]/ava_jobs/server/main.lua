-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
CoreJobs = exports.ava_core:GetJobsData()

-- #region services
local jobsServices = {}

RegisterServerEvent("ava_jobs:setService")
AddEventHandler("ava_jobs:setService", function(jobName, state)
    if not jobsServices[jobName] then
        jobsServices[jobName] = {}
    end
    jobsServices[jobName][source] = state and true or nil
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    for jobName, v in pairs(jobsServices) do
        if v[source] ~= nil then
            jobsServices[jobName][source] = nil
        end
    end
end)
function isInService(source, job)
    return jobsServices[job] and jobsServices[job][source] == true or false
end
exports("isInService", isInService)

function isInServiceOrHasJob(source, job)
    local aPlayer = exports.ava_core:GetPlayer(source)
    return isInService(source, job) or aPlayer.hasJob(jobName)
end
exports("isInServiceOrHasJob", isInServiceOrHasJob)
-- #endregion
