-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- Only configure the phone if the phone resource is found
if GetResourceState("npwd") == "missing" then return end

local sendSourceMessageToJob

Citizen.CreateThread(function()
    while GetResourceState("npwd") ~= "started" do
        Wait(0)
    end

    for jobName, job in pairs(Config.Jobs) do
        if not job.isIllegal and not job.isGang and job.PhoneNumber then
            job.PhoneNumber = tostring(job.PhoneNumber)
            print("^6[JOBS]^0 Configure phone number ^6" .. job.PhoneNumber .. "^0 for ^6" .. job.LabelName .. "^0")

            exports.npwd:onMessage(job.PhoneNumber, function(ctx)
                sendSourceMessageToJob(ctx.source, jobName, ctx.data.message, ctx.data.sourcePhoneNumber)
            end)
        end
    end
end)


---@class sendMessageToJobData
---@field message string
---@field sourcePhoneNumber string
---@field location? vector3

---Send a message to every players concerned by a job
---@param jobName string
---@param data sendMessageToJobData
sendMessageToJob = function(jobName, data)
    local job = Config.Jobs[jobName]
    if data and job and job.PhoneNumber then
        local msg = nil
        if data.sourcePhoneNumber then
            msg = ("%s - %s:\n\n%s"):format(job.LabelName, data.sourcePhoneNumber, data.message)
        else
            msg = ("%s:\n%s"):format(job.LabelName, data.message)
        end

        for k, src in pairs(GetPlayers()) do
            -- If player has the job
            if IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".main") then -- TODO Filter tempworkers?
                local aPlayer = exports.ava_core:GetPlayer(src)
                if aPlayer and aPlayer.phoneNumber then
                    print("^4[JOBS NPWD]^0 Send message to ^2" .. aPlayer.phoneNumber .. "^0 from ^2" .. job.PhoneNumber .. "^0")

                    -- Send message to the player
                    exports.npwd:emitMessage({
                        senderNumber = job.PhoneNumber,
                        targetNumber = aPlayer.phoneNumber,
                        message = msg,
                        embed = data.location and {
                            type = "location",
                            coords = { data.location.x, data.location.y, data.location.z },
                            phoneNumber = job.PhoneNumber,
                        }
                    })
                end
            end
        end
    end
end
exports("sendMessageToJob", sendMessageToJob)

---Send a message to every players concerned by a job
---@param source string
---@param jobName string
---@param message string
---@param sourcePhoneNumber? string|nil
sendSourceMessageToJob = function(source, jobName, message, sourcePhoneNumber)
    sendMessageToJob(jobName, {
        message = message,
        sourcePhoneNumber = sourcePhoneNumber,
        location = GetEntityCoords(GetPlayerPed(source))
    })
end
exports("sendSourceMessageToJob", sendSourceMessageToJob)

---Get job phone number
---@param jobName string
---@return string|nil
local function getJobPhoneNumber(jobName)
    local job = Config.Jobs[jobName]
    if job and job.PhoneNumber then
        return job.PhoneNumber
    end
    return nil
end

exports("getJobPhoneNumber", getJobPhoneNumber)
