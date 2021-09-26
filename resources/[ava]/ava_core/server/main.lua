-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA = {}

exports("GetSharedObject", function()
    return AVA
end)

-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

local resourceName<const> = GetCurrentResourceName()
for i = 1, GetNumResourceMetadata(resourceName, "ava_config"), 1 do
    local dataName = GetResourceMetadata(resourceName, "ava_config", i - 1)
    if dataName == "discord_config" then
        AVAConfig.Discord = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1))

    elseif dataName == "debug_prints" then
        AVAConfig.Debug = true

    elseif dataName == "max_characters" then
        local value = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1)) or 0
        if value ~= "null" and tonumber(value) > 0 then
            AVAConfig.MaxChars = tonumber(value)
        else
            print("^3[WARN] max_characters was not valid, value must be a number > 0^0")
        end

    elseif dataName == "max_jobs_count" then
        local value = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1)) or 0
        if value ~= "null" and tonumber(value) > 0 then
            AVAConfig.MaxJobsCount = tonumber(value)
        else
            print("^3[WARN] max_jobs_count was not valid, value must be a number > 0^0")
        end

    elseif dataName == "max_gangs_count" then
        local value = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1)) or 0
        if value ~= "null" and tonumber(value) > 0 then
            AVAConfig.MaxGangsCount = tonumber(value)
        else
            print("^3[WARN] max_gangs_count was not valid, value must be a number > 0^0")
        end
    end
end

---Print only if AVAConfig.Debug is true
function dprint(...)
    if AVAConfig.Debug then
        print("^3[DEBUG] ^0", ...)
    end
end

dprint([[
Console colors : 
    ^0^ 0 : AvaN0x's Core
    ^1^ 1 : AvaN0x's Core
    ^2^ 2 : AvaN0x's Core
    ^3^ 3 : AvaN0x's Core
    ^4^ 4 : AvaN0x's Core
    ^5^ 5 : AvaN0x's Core
    ^6^ 6 : AvaN0x's Core
    ^7^ 7 : AvaN0x's Core
    ^8^ 8 : AvaN0x's Core
    ^9^ 9 : AvaN0x's Core^0]])

-----------------------------------------------
--------------- Init principals ---------------
-----------------------------------------------

---Add an ace
---@param principal string
---@param object string
AVA.AddAce = function(principal, object)
    if type(principal) == "string" and type(object) == "string" then
        dprint(("add_ace ^4%s^0 ^5%s^0 allow"):format(principal, object))
        ExecuteCommand(("add_ace %s %s allow"):format(principal, object))
    end
end
AddEventHandler("ava_core:server:add_ace", AVA.AddAce)

---Add a principal and an ace that only this principal have (if specified)
---@param principal string
---@param object string
---@param with_ace boolean "will create an ace with it, under the form of `ace.${principal}"
AVA.AddPrincipal = function(principal, object, with_ace)
    if type(principal) == "string" and type(object) == "string" then
        dprint(("add_principal ^4%s^0 ^5%s^0"):format(principal, object))
        ExecuteCommand(("add_principal %s %s"):format(principal, object))
        if with_ace then
            AVA.AddAce(principal, "ace." .. principal)
        end
    end
end
AddEventHandler("ava_core:server:add_principal", AVA.AddPrincipal)

---Remove a principal
---@param principal string
---@param object string
AVA.RemovePrincipal = function(principal, object)
    if type(principal) == "string" and type(object) == "string" then
        dprint(("remove_principal ^4%s^0 ^5%s^0"):format(principal, object))
        ExecuteCommand(("remove_principal %s %s"):format(principal, object))
    end
end
AddEventHandler("ava_core:server:remove_principal", AVA.RemovePrincipal)

-- if using "snail" instead of "builtin.everyone", then players can do commands and console can't
AVA.AddPrincipal("group.mod", "builtin.everyone", true)

AVA.AddPrincipal("group.admin", "group.mod", true)
AVA.AddAce("group.admin", "command.stop")
AVA.AddAce("group.admin", "command.start")
AVA.AddAce("group.admin", "command.restart")
AVA.AddAce("group.admin", "command.ensure")

AVA.AddPrincipal("group.superadmin", "group.admin", true)
AVA.AddAce("group.superadmin", "command")

-------------------------------------
--------------- Items ---------------
-------------------------------------
AVA.UsableItems = {}

---Register an usable item
---@param itemName any
---@param callback fun(itemName: string, callback: function)
AVA.RegisterUsableItem = function(itemName, callback)
    if type(itemName) == "string" and AVAConfig.Items[itemName]
        and (type(callback) == "function" or (type(callback) == "table" and callback["__cfx_functionReference"] ~= nil)) then
        AVA.UsableItems[itemName] = callback
        AVAConfig.Items[itemName].usable = true

        dprint("Usable item added: ^3" .. itemName .. "^0")
    end
end
exports("RegisterUsableItem", AVA.RegisterUsableItem)

AVA.RegisterUsableItem("bread", function(src)
    print(src .. " tried to eat bread, unfortunately this feature is not done.")
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        aPlayer.inventory.removeItem("bread", 1)
    end
end)

---Get all items data
---@return table
AVA.GetItemsData = function()
    return AVAConfig.Items or {}
end
exports("GetItemsData", AVA.GetItemsData)

---Get all items data
---@param name string
---@return table
AVA.GetItemData = function(name)
    return AVAConfig.Items and AVAConfig.Items[name]
end
exports("GetItemData", AVA.GetItemData)

-------------------------------------
--------------- Jobs ---------------
-------------------------------------

---Get all jobs data
---@return table
AVA.GetJobsData = function()
    return AVAConfig.Jobs or {}
end
exports("GetJobsData", AVA.GetJobsData)

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
            grades[gradeCount] = {label = grade.label, name = grade.name, canManage = grade.manage}
        end
    end
    return grades
end
exports("GetAllJobGrades", AVA.GetAllJobGrades)

dprint("^6[JOBS] Start initializing principals for each jobs^0")
for jobName, job in pairs(AVAConfig.Jobs) do
    dprint("^6[JOBS]^0 Start principals for job ^6" .. jobName .. " ^0(^6" .. job.label .. "^0)")
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
    else
        print("^1" .. jobName .. " is missing grades^0")
    end
end
dprint("^6[JOBS] Ended initializing principals for each jobs^0")

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
                                -- TODO check if society has money
                                if true then
                                    -- TODO take money from society
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
