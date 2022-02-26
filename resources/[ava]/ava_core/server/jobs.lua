-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
---@type aJobAccounts[]
AVA.JobsAccounts = {}
local CustomSalaries = {}

---Get all jobs data
---@return table
AVA.GetJobsData = function()
    return AVAConfig.Jobs or {}
end
exports("GetJobsData", AVA.GetJobsData)

---Get accounts
---@param jobName string
---@return aJobAccounts
AVA.GetJobAccounts = function(jobName)
    return AVA.JobsAccounts[jobName]
end
exports("GetJobAccounts", AVA.GetJobAccounts)

Citizen.CreateThread(function()
    dprint("^6[JOBS] Start initializing datas for each jobs^0")
    local data = MySQL.query.await("SELECT `name`, `accounts`, `salaries` FROM `ava_jobs`", {})
    if data then
        for i = 1, #data do
            local jobData = data[i]
            local cfgJob = AVAConfig.Jobs[jobData.name]
            if cfgJob and not cfgJob.Disabled and not cfgJob.noBoss then
                dprint(("Add JobsAccounts for ^5%s^0 from fetch"):format(jobData.name))
                AVA.JobsAccounts[jobData.name] = CreateJobAccounts(jobData.name, jobData.accounts and json.decode(jobData.accounts) or {})

                local salaries = jobData.salaries and json.decode(jobData.salaries)
                if type(salaries) == "table" then
                    CustomSalaries[jobData.name] = salaries
                    for j = 1, #cfgJob.grades do
                        local grade = cfgJob.grades[j]
                        if grade.name ~= "tempworker" and salaries[grade.name] ~= nil and type(salaries[grade.name]) == "number" then
                            dprint(("Change salary to ^5%d^0 for ^5%s.%s^0 from fetch"):format(salaries[grade.name], jobData.name, grade.name))
                            grade.salary = tonumber(salaries[grade.name])
                        end
                    end
                end
            end
        end
    end

    dprint("^6[JOBS] Start initializing principals for each jobs and check accounts^0")
    for jobName, job in pairs(AVAConfig.Jobs) do
        if not job.Disabled then
            dprint("^6[JOBS]^0 Start principals for job ^6" .. jobName .. " ^0(^6" .. job.label .. "^0)")

            if not AVA.JobsAccounts[jobName] and not job.isGang and not job.noBoss then
                dprint(("Add missing JobsAccounts for ^5%s^0"):format(jobName))
                AVA.JobsAccounts[jobName] = CreateJobAccounts(jobName)
                MySQL.insert("INSERT INTO `ava_jobs` (`name`, `accounts`, `salaries`) VALUES (:name, :accounts, :salaries)",
                    { name = jobName, accounts = "[]", salaries = "{}" }, function()
                        dprint(("Missing JobsAccounts for ^5%s^0 added to database"):format(jobName))
                    end)
            end

            local principal<const> = "job." .. jobName
            AVA.AddPrincipal(principal .. ".main", "builtin.everyone", true)
            if job.grades then
                local lastGradePrincipal = principal .. ".main"
                for i = 1, #job.grades do
                    local grade<const> = job.grades[i]
                    local gradePrincipal<const> = principal .. ".grade." .. grade.name
                    AVA.AddPrincipal(gradePrincipal, lastGradePrincipal, true)
                    if grade.manage then
                        AVA.AddAce(gradePrincipal, principal .. ".manage")
                    end
                    lastGradePrincipal = gradePrincipal
                end
                AVA.AddAce(lastGradePrincipal, principal .. ".highest")
            else
                print("^1" .. jobName .. " is missing grades^0")
            end
        end
    end
    dprint("^6[JOBS] Ended initializing principals for each jobs^0")
    dprint("^6[JOBS] Ended initializing datas for each jobs^0")
end)

AVA.RegisterServerCallback("ava_core:server:getJobAccountBalance", function(source, jobName, accountName)
    local src = source
    if IsPlayerAceAllowed(src, "job." .. jobName .. ".manage") then
        local account = AVA.JobsAccounts[jobName]
        if account then
            return account.getAccountBalance(accountName)
        end
    end
end)

AVA.SaveAllJobsAccounts = function()
    local promises = {}
    local count = 0
    for src, aPlayer in pairs(AVA.Players.List) do
    end

    for jobName, aJobAccounts in pairs(AVA.JobsAccounts) do
        if aJobAccounts.modified then
            count = count + 1
            promises[count] = aJobAccounts.save()
        end
    end
    Citizen.Await(promise.all(promises))
    print("^2[SAVE JOBS ACCOUNTS]^0 Every jobs accounts has been saved.")
    TriggerEvent("ava_logs:server:log", "Every jobs accounts has been saved.")
end

AVA.SaveJobAccounts = function(aJobAccounts)
    if aJobAccounts then
        local p = promise.new()
        MySQL.update("UPDATE `ava_jobs` SET `accounts` = :accounts WHERE `name` = :name",
            { name = aJobAccounts.name, accounts = json.encode(aJobAccounts.getAccounts()) }, function(result)
                aJobAccounts.modified = false
                print("^2[SAVE JOB ACCOUNTS] ^0" .. aJobAccounts.name)
                p:resolve()
            end)
        return p
    else
        error("^1[AVA.SaveJobAccounts]^0 aJobAccounts is not valid.")
    end
end

---Check whether a grade exist for a job or not
---@param jobName string
---@param gradeName string
---@return boolean
AVA.GradeExistForJob = function(jobName, gradeName)
    local cfgJob<const> = AVAConfig.Jobs[jobName]
    if cfgJob then
        for i = 1, #cfgJob.grades do
            local grade<const> = cfgJob.grades[i]
            if grade.name == gradeName then
                return true
            end
        end
    end
    return false
end
exports("GradeExistForJob", AVA.GradeExistForJob)

---Get grade label
---@param jobName string
---@param gradeName string
---@return string
AVA.GetGradeLabel = function(jobName, gradeName)
    local cfgJob<const> = AVAConfig.Jobs[jobName]
    if cfgJob then
        for i = 1, #cfgJob.grades do
            local grade<const> = cfgJob.grades[i]
            if grade.name == gradeName then
                return grade.label
            end
        end
    end
    return ""
end
exports("GetGradeLabel", AVA.GetGradeLabel)

---Get an array with all grades existing for a job
---@param jobName string
---@return table
AVA.GetAllJobGrades = function(jobName)
    local cfgJob<const> = AVAConfig.Jobs[jobName]
    local grades = {}
    if cfgJob then
        local gradeCount = 0
        for i = 1, #cfgJob.grades do
            local grade = cfgJob.grades[i]
            gradeCount = gradeCount + 1
            grades[gradeCount] = { label = grade.label, name = grade.name, canManage = grade.manage, salary = grade.salary }
        end
    end
    return grades
end
exports("GetAllJobGrades", AVA.GetAllJobGrades)

---Set job grade salary
---@param jobName string
---@param gradeName string
---@param salary number
---@return success
AVA.SetGradeSalary = function(jobName, gradeName, salary)
    if type(salary) == "number" and salary > 0 then
        local cfgJob<const> = AVAConfig.Jobs[jobName]
        if cfgJob then
            for i = 1, #cfgJob.grades do
                local grade<const> = cfgJob.grades[i]
                if grade.name == gradeName then
                    grade.salary = salary
                    if type(CustomSalaries[jobName]) ~= "table" then
                        CustomSalaries[jobName] = {}
                    end
                    CustomSalaries[jobName][gradeName] = salary
                    MySQL.update.await("UPDATE `ava_jobs` SET `salaries` = :salaries WHERE `name` = :name",
                        { name = jobName, salaries = json.encode(CustomSalaries[jobName]) })
                    dprint(("Change salary to ^5%d^0 for ^5%s.%s^0 from SetGradeSalary"):format(salary, jobName, gradeName))
                    return true
                end
            end
        end
    end

    return false
end
exports("SetGradeSalary", AVA.SetGradeSalary)

-----------------------------------------
--------------- Paychecks ---------------
-----------------------------------------

if AVAConfig.PayCheckTimeout then
    local function timeoutPayCheck()
        dprint("^4[PAYCHECK] Start paychecks^0")
        for src, aPlayer in pairs(AVA.Players.List) do
            if type(aPlayer.jobs) == "table" then
                for i = 1, #aPlayer.jobs do
                    local job<const> = aPlayer.jobs[i]
                    local cfgJob<const> = AVAConfig.Jobs[job.name]
                    if cfgJob and not cfgJob.isGang then
                        local salary, notificationSubtitle = -1, ""
                        for j = 1, #cfgJob.grades do
                            local grade<const> = cfgJob.grades[j]
                            if grade.name == job.grade and grade.salary ~= nil then
                                salary = grade.salary
                                notificationSubtitle = (cfgJob.label or "") .. " - " .. (grade.label or "")
                                break
                            end
                        end
                        if salary > 0 then
                            dprint("^2Salary found for " .. aPlayer.getDiscordTag() .. " with job " .. job.name .. "^0", salary, job.grade, notificationSubtitle)
                            if job.grade == "tempworker" or job.name == "unemployed" then
                                -- player is employed by job center and need to be paid by them
                                aPlayer.addAccountBalance("bank", salary)
                                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("received_job_center", salary), nil, "CHAR_BANK_MAZE",
                                    GetString("salary"), notificationSubtitle, 9, "CHAR_BANK_MAZE")
                            else
                                local jobAccounts = AVA.JobsAccounts[job.name]
                                if jobAccounts and salary <= jobAccounts.getAccountBalance("bank") then
                                    jobAccounts.removeAccountBalance("bank", salary)
                                    aPlayer.addAccountBalance("bank", salary)
                                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("received_salary", salary), nil, "CHAR_BANK_MAZE",
                                        GetString("salary"), notificationSubtitle, 9, "CHAR_BANK_MAZE")
                                else
                                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("society_not_enough_money"), nil, "CHAR_BANK_MAZE",
                                        GetString("salary"), notificationSubtitle, 9, "CHAR_BANK_MAZE")
                                end
                            end
                        else
                            dprint("^1Salary not found for " .. aPlayer.getDiscordTag() .. " with job " .. job.name .. "^0")
                        end
                    end
                    Wait(0)
                end
            end
        end
        print("^4[PAY CHECK] ^0Every paycheck has been delivered.")
        SetTimeout(AVAConfig.PayCheckTimeout * 60 * 1000, timeoutPayCheck)
    end

    SetTimeout(AVAConfig.PayCheckTimeout * 60 * 1000, timeoutPayCheck)
end
