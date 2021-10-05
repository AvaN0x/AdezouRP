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
        local result = exports.oxmysql:fetchSync("SELECT `id`, `character`, `jobs` FROM `players` WHERE INSTR(`jobs`, :jobName)", {jobName = jobName})
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
            print(targetCitizenId)
            jobFireTarget(src, aTargetPlayer.src, jobName)
            return
        end

        local targetJobs = exports.oxmysql:scalarSync("SELECT `jobs` FROM `players` WHERE `id` = :id", {id = targetCitizenId})
        if not targetJobs then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
        end
        targetJobs = json.decode(targetJobs)
        if type(targetJobs) ~= "table" then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"), nil, "ava_core_logo", cfgJob.label)
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

        table.remove(targetJobs, index)

        exports.oxmysql:executeSync("UPDATE `players` SET `jobs` = :jobs WHERE `id` = :id", {jobs = json.encode(targetJobs), id = targetCitizenId})
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
                print("can't do this to yourself")
                return
            end
            jobChangeGradeTarget(source, target, jobName, gradeName)
            return
        end

        -- todo do things manually with database
    end
end)
