-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local function getGradesInfos(jobName)
    local grades = exports.ava_core:GetAllJobGrades(jobName)
    local gradesLabel = {}
    for i = 1, #grades do
        local grade = grades[i]
        gradesLabel[grade.name] = {label = grade.label or grade.name, index = i}
    end
    return gradesLabel
end

exports.ava_core:RegisterServerCallback("ava_jobs:getAllEmployees", function(source, jobName)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        -- get informations about grades
        local grades<const> = exports.ava_core:GetAllJobGrades(jobName)
        local gradesInfos = {}
        for i = 1, #grades do
            local grade = grades[i]
            gradesInfos[grade.name] = {label = grade.label or grade.name, index = i}
        end

        local employees = {}
        local countEmployees = 0
        local result = MySQL.query.await("SELECT `id`, `character`, `jobs` FROM `ava_players` WHERE INSTR(`jobs`, :jobName)", {jobName = jobName})
        if result then
            for i = 1, #result do
                local res = result[i]
                res.character = json.decode(res.character)
                res.jobs = json.decode(res.jobs)

                local grade
                for j = 1, #res.jobs do
                    local job = res.jobs[j]
                    if job.name == jobName then
                        grade = gradesInfos[job.grade]
                    end
                end

                -- this condition should never return false
                if grade then
                    countEmployees = countEmployees + 1
                    employees[countEmployees] = {
                        name = ("%s %s"):format(res.character.firstname, res.character.lastname),
                        id = res.id,
                        grade = grade.label,
                        gradeId = grade.index,
                    }
                end
            end
        end
        return employees
    end
end)

RegisterNetEvent("ava_jobs:server:manager_menu_fire", function(targetCitizenId, jobName)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        local aTargetPlayer = exports.ava_core:GetPlayerByCitizenId(targetCitizenId)
        if aTargetPlayer and aTargetPlayer.src then
            jobFireTarget(src, aTargetPlayer.src, jobName)
            return
        end

        local targetJobs = MySQL.scalar.await("SELECT `jobs` FROM `ava_players` WHERE `id` = :id", {id = targetCitizenId})
        if not targetJobs then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
            return
        end
        targetJobs = json.decode(targetJobs)
        if type(targetJobs) ~= "table" then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
            return
        end

        local index, targetGrade
        for i = 1, #targetJobs do
            local job = targetJobs[i]
            if job.name == jobName then
                index = i
                targetGrade = job.grade
                break
            end
        end
        if index == nil then
            if cfgJob.isGang then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_gang"), nil, "ava_core_logo", cfgJob.label)
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_job"), nil, "ava_core_logo", cfgJob.label)
            end
            return
        end

        -- check if the player is not trying to fire someone with a higher grade
        if not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".grade." .. targetGrade) then
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

        if job.grade == targetGrade and not IsPlayerAceAllowed(src, "job." .. jobName .. ".highest") then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_fire_same_grade"), nil, "ava_core_logo", cfgJob.label)
            return
        end

        table.remove(targetJobs, index)

        MySQL.update.await("UPDATE `ava_players` SET `jobs` = :jobs WHERE `id` = :id", {jobs = json.encode(targetJobs), id = targetCitizenId})
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_target_fired"), nil, "ava_core_logo", cfgJob.label)
    end
end)

RegisterNetEvent("ava_jobs:server:manager_menu_change_grade", function(targetCitizenId, jobName, gradeName)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        local aTargetPlayer = exports.ava_core:GetPlayerByCitizenId(targetCitizenId)
        if aTargetPlayer and aTargetPlayer.src then
            if aTargetPlayer.src == tostring(src) then
                -- can't change your own grade
                return
            end
            jobChangeGradeTarget(source, aTargetPlayer.src, jobName, gradeName)
            return
        end

        if not exports.ava_core:GradeExistForJob(jobName, gradeName) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_menu_grade_do_not_exist"), nil, "ava_core_logo", cfgJob.label)
            return
        end

        -- check if the player is not trying to change the grade of someone to a higher grade
        if not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".grade." .. gradeName) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_to_higher_grade"), nil, "ava_core_logo", cfgJob.label)
            return
        end

        local targetJobs = MySQL.scalar.await("SELECT `jobs` FROM `ava_players` WHERE `id` = :id", {id = targetCitizenId})
        if not targetJobs then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
            return
        end
        targetJobs = json.decode(targetJobs)
        if type(targetJobs) ~= "table" then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
            return
        end

        local index
        for i = 1, #targetJobs do
            local job = targetJobs[i]
            if job.name == jobName then
                index = i
                break
            end
        end
        if index == nil then
            if cfgJob.isGang then
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_gang"), nil, "ava_core_logo", cfgJob.label)
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_do_not_have_this_job"), nil, "ava_core_logo", cfgJob.label)
            end
            return
        end

        -- check if the player is not trying to change the grade of someone with a higher grade
        if not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".grade." .. targetJobs[index].grade) then
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

        if job.grade == targetJobs[index].grade and not IsPlayerAceAllowed(src, "job." .. jobName .. ".highest") then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_grade_someone_with_same_grade"), nil, "ava_core_logo",
                cfgJob.label)
            return
        elseif job.grade == gradeName and not IsPlayerAceAllowed(src, "job." .. jobName .. ".highest") then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_grade_someone_to_same_grade"), nil, "ava_core_logo",
                cfgJob.label)
            return
        end

        targetJobs[index].grade = gradeName

        MySQL.update.await("UPDATE `ava_players` SET `jobs` = :jobs WHERE `id` = :id", {jobs = json.encode(targetJobs), id = targetCitizenId})

        local gradeLabel = exports.ava_core:GetGradeLabel(jobName, gradeName)
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("player_target_grade_changed_to", gradeLabel), nil, "ava_core_logo", cfgJob.label)
    end
end)

RegisterNetEvent("ava_jobs:server:manager_menu_change_grade_salary", function(jobName, gradeName, amount)
    local src = source

    local cfgJob = CoreJobs[jobName]
    if not cfgJob then
        return
    end
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        -- check if the player is not trying to change the grade of someone to a higher grade
        -- or if the grade is tempworker
        if not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".grade." .. gradeName) or gradeName == "tempworker" then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_salary_of_this_grade"), nil, "ava_core_logo", cfgJob.label)
            return
        end

        local aPlayer = exports.ava_core:GetPlayer(src)
        if not aPlayer then
            -- player is nil
            -- this should never happen
            return
        end
        local grades = exports.ava_core:GetAllJobGrades(jobName)
        if not grades then
            -- grades is nil
            -- this should never happen
            return
        end
        local _, job = aPlayer.hasJob(jobName)
        if not job then
            -- job is nil
            -- this should never happen
            return
        end
        local myGradeId, targetGradeId, gradeLabel
        for i = 1, #grades do
            local grade = grades[i]
            if gradeName == grade.name then
                targetGradeId = i
                gradeLabel = grade.label
            end
            if job.grade == grade.name then
                myGradeId = i
            end
        end
        if not targetGradeId or not myGradeId then
            -- could not find target grade id and aPlayer gride id
            -- this should never happen
            return
        end

        -- player cannot change its own salary if he/she do not have the highest grade
        if targetGradeId == myGradeId and targetGradeId < #grades then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cannot_change_salary_of_this_grade"), nil, "ava_core_logo", cfgJob.label)
            return
        end

        if exports.ava_core:SetGradeSalary(jobName, gradeName, amount) then
            TriggerClientEvent("ava_core:client:ShowNotification", src,
                GetString("changed_salary_to", amount > 999 and exports.ava_core:FormatNumber(amount) or amount), nil, "ava_core_logo", cfgJob.label, gradeLabel)
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("amount_invalid"), nil, "ava_core_logo", cfgJob.label)
        end
    end
end)

