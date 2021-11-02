-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava_jobs:server:job_menu_hire", function(target, jobName)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        local aTargetPlayer = exports.ava_core:GetPlayer(target)
        if aTargetPlayer then
            if aTargetPlayer.hasJob(jobName) then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_is_already_hired"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            if (cfgJob.isGang and aTargetPlayer.canAddAnotherGang()) or aTargetPlayer.canAddAnotherJob() then
                local jobAdded, finalGrade = aTargetPlayer.addJob(jobName)
                if jobAdded then
                    local gradeLabel = exports.ava_core:GetGradeLabel(jobName, finalGrade)
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_target_hired_as", gradeLabel), nil, "ava_core_logo",
                        cfgJob.label)
                    TriggerClientEvent("ava_core:client:ShowNotification", target, GetString("hired_as_grade", gradeLabel), nil, "ava_core_logo", cfgJob.label)
                end
            else
                if cfgJob.isGang then
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_cannot_have_more_gangs"), nil, "ava_core_logo", cfgJob.label)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_cannot_have_more_jobs"), nil, "ava_core_logo", cfgJob.label)
                end
            end
        end
    end
end)

function jobFireTarget(source, target, jobName)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        local aTargetPlayer = exports.ava_core:GetPlayer(target)
        if aTargetPlayer then
            local targetHasJob, targetJob = aTargetPlayer.hasJob(jobName)
            if not targetHasJob then
                if cfgJob.isGang then
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_gang"), nil, "ava_core_logo", cfgJob.label)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_job"), nil, "ava_core_logo", cfgJob.label)
                end
                return
            end

            -- check if the player is not trying to fire someone with a higher grade
            if not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".grade." .. targetJob.grade) then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_fire_higher_grade"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            -- check if the player is not trying to fire someone with the same grade while not having the highest grade
            local aPlayer = exports.ava_core:GetPlayer(src)
            if not aPlayer then
                -- player is nil
                -- this should never happen
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            local _, job = aPlayer.hasJob(jobName)
            if not job then
                -- job is nil
                -- this should never happen
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            if job.grade == targetJob.grade and not IsPlayerAceAllowed(src, "job." .. jobName .. ".highest") then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_fire_same_grade"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            local jobRemoved = aTargetPlayer.removeJob(jobName)
            if jobRemoved then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_target_fired"), nil, "ava_core_logo", cfgJob.label)
                if cfgJob.isGang then
                    TriggerClientEvent("ava_core:client:ShowNotification", target, GetString("fired_from_gang"), nil, "ava_core_logo", cfgJob.label)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", target, GetString("fired_from_job"), nil, "ava_core_logo", cfgJob.label)
                end
            end
        end
    end
end

RegisterNetEvent("ava_jobs:server:job_menu_fire", function(target, jobName)
    jobFireTarget(source, target, jobName)
end)

function jobChangeGradeTarget(source, target, jobName, gradeName)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        local aTargetPlayer = exports.ava_core:GetPlayer(target)
        if aTargetPlayer then
            -- check if grade exists
            if not exports.ava_core:GradeExistForJob(jobName, gradeName) then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_menu_grade_do_not_exists"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            -- check if the player is not trying to change the grade of someone to a higher grade
            if not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".grade." .. gradeName) then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_to_higher_grade"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            local targetHasJob, targetJob = aTargetPlayer.hasJob(jobName)
            if not targetHasJob then
                if cfgJob.isGang then
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_gang"), nil, "ava_core_logo", cfgJob.label)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_job"), nil, "ava_core_logo", cfgJob.label)
                end
                return
            end

            -- check if the player is not trying to change the grade of someone with a higher grade
            if not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".grade." .. targetJob.grade) then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_grade_someone_with_higher_grade"), nil, "ava_core_logo",
                    cfgJob.label)
                return
            end

            -- check if the player is not trying to change the grade of someone with the same grade while not having the highest grade
            local aPlayer = exports.ava_core:GetPlayer(src)
            if not aPlayer then
                -- player is nil
                -- this should never happen
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            local _, job = aPlayer.hasJob(jobName)
            if not job then
                -- job is nil
                -- this should never happen
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
                return
            end

            if job.grade == targetJob.grade and not IsPlayerAceAllowed(src, "job." .. jobName .. ".highest") then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_grade_someone_with_same_grade"), nil, "ava_core_logo",
                    cfgJob.label)
                return
            elseif job.grade == gradeName and not IsPlayerAceAllowed(src, "job." .. jobName .. ".highest") then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_grade_someone_to_same_grade"), nil, "ava_core_logo",
                    cfgJob.label)
                return
            end

            local jobAdded, finalGrade = aTargetPlayer.addJob(jobName, gradeName)
            if jobAdded then
                local gradeLabel = exports.ava_core:GetGradeLabel(jobName, finalGrade)
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_target_grade_changed_to", gradeLabel), nil, "ava_core_logo",
                    cfgJob.label)
                TriggerClientEvent("ava_core:client:ShowNotification", target, GetString("grade_changed_to", gradeLabel), nil, "ava_core_logo", cfgJob.label)
            end
        end
    end
end

RegisterNetEvent("ava_jobs:server:job_menu_change_grade", function(target, jobName, gradeName)
    jobChangeGradeTarget(source, target, jobName, gradeName)
end)

exports.ava_core:RegisterServerCallback("ava_jobs:getAllGrades", function(source, jobName, target)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        local grades = exports.ava_core:GetAllJobGrades(jobName)
        if target then
            local aTargetPlayer = exports.ava_core:GetPlayer(target)
            if aTargetPlayer then
                local hasJob, targetJob = aTargetPlayer.hasJob(jobName)
                if hasJob then
                    local targetGrade<const> = targetJob.grade
                    for i = 1, #grades do
                        local grade = grades[i]
                        if grade.name == targetGrade then
                            grade.actual = true
                        end
                    end
                    return grades, true
                end
            end
        end
        return grades
    end
end)

