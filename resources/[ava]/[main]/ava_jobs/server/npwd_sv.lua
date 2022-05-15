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


---Send a message to every players concerned by a job
---@param source string
---@param jobName string
---@param message string
---@param sourcePhoneNumber? string|nil
sendSourceMessageToJob = function(source, jobName, message, sourcePhoneNumber)
    local job = Config.Jobs[jobName]
    if job and job.PhoneNumber then
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local msg = nil
        if sourcePhoneNumber then
            msg = ("%s - %s:\n\n%s"):format(job.LabelName, sourcePhoneNumber, message)
        else
            msg = ("%s:\n%s"):format(job.LabelName, message)
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
                        embed = {
                            type = "location",
                            coords = { playerCoords.x, playerCoords.y, playerCoords.z },
                            phoneNumber = job.PhoneNumber,
                        }
                    })
                end
            end
        end
    end
end
exports("sendSourceMessageToJob", sendSourceMessageToJob)
