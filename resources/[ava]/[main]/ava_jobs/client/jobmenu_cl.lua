-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
--------------
-- Job Menu --
--------------
local SelectJobMenu = RageUI.CreateMenu("", GetString("job_menu"), 0, 0, "avaui", "avaui_title_adezou")
local JobsToSelect = {}
RegisterCommand("keyJobMenu", function()
    OpenJobMenu()
end)

RegisterKeyMapping("keyJobMenu", GetString("job_menu_key"), "keyboard", Config.JobMenuKey)

local function updateJobsToSelect()
    JobsToSelect = {}
    local jobCount = 0
    for jobName, job in pairs(playerJobs) do
        if not job.isIllegal and (job.canManage or job.JobMenu) then
            jobCount = jobCount + 1
            JobsToSelect[jobCount] = {label = job.LabelName, name = jobName, isGang = job.isGang and 1 or 0, LeftBadge = job.isGang and RageUI.BadgeStyle.Gun}
        end
    end

    if #JobsToSelect > 1 then
        table.sort(JobsToSelect, function(a, b)
            return a.isGang < b.isGang
        end)
    end
end

local MainJobMenu = RageUI.CreateSubMenu(SelectJobMenu, "", GetString("job_menu_title", ""), 0, 0, "avaui", "avaui_title_adezou")
local JobMenuElements = {}
local openedMenuJobName = nil
MainJobMenu.Closed = function()
    JobMenuElements = {}
    openedMenuJobName = nil

    updateJobsToSelect()
end
local JobMenuManage = RageUI.CreateSubMenu(MainJobMenu, "", GetString("job_menu_manage_job"))
local JobMenuBills = RageUI.CreateSubMenu(MainJobMenu, "", GetString("job_menu_bills"))

local function JobMenu(jobName)
    local playerJobsJobName = playerJobs[jobName]
    if not playerJobsJobName then
        return
    end
    openedMenuJobName = jobName

    local jobGrade<const> = playerJobsJobName.grade

    JobMenuElements = {}
    if playerJobsJobName.JobMenu and playerJobsJobName.JobMenu.Items then
        local elementCount = 0
        for k, v in pairs(playerJobsJobName.JobMenu.Items) do
            if (not v.MinimumGrade or (playerJobsJobName.grade == v.MinimumGrade or tableHasValue(playerJobsJobName.underGrades, v.MinimumGrade)))
                and (not v.Condition or v.Condition(jobName, playerPed)) then
                elementCount = elementCount + 1
                JobMenuElements[elementCount] = {label = v.Label, name = k, desc = v.Desc, RightLabel = v.RightLabel}
            end
        end
    end

    MainJobMenu.Subtitle = GetString(playerJobsJobName.isGang and "job_menu_title_gang" or "job_menu_title", playerJobsJobName.LabelName)
    if not RageUI.Visible(MainJobMenu) then
        RageUI.Visible(MainJobMenu, true)
    end
end

function OpenJobMenu()
    updateJobsToSelect()

    if #JobsToSelect == 1 then
        RageUI.CloseAll()
        JobMenu(JobsToSelect[1].name)
    elseif #JobsToSelect > 1 then
        RageUI.CloseAll()
        RageUI.Visible(SelectJobMenu, true)
    end
end

function RageUI.PoolMenus:JobMenu()
    SelectJobMenu:IsVisible(function(Items)
        if #JobsToSelect < 1 then
            RageUI.GoBack()
            return
        end

        for i = 1, #JobsToSelect do
            local element = JobsToSelect[i]
            Items:AddButton(element.label, nil, {RightLabel = "→→→", LeftBadge = element.LeftBadge}, function(onSelected)
                if onSelected then
                    JobMenu(element.name)
                end
            end, MainJobMenu)
        end
    end)

    MainJobMenu:IsVisible(function(Items)
        local playerJobsJobName = playerJobs[openedMenuJobName]
        if not playerJobsJobName then
            RageUI.GoBack()
            return
        end

        if JobMenuElements then
            local isDisabled = playerJobsJobName.ServiceCounter and not playerServices[openedMenuJobName]
            for i = 1, #JobMenuElements do
                local element = JobMenuElements[i]
                Items:AddButton(element.label, (isDisabled and GetString("need_in_service_subtitle") or "") .. element.desc, {IsDisabled = isDisabled},
                    function(onSelected)
                        if onSelected then
                            if playerJobsJobName.JobMenu[element.name]
                                and (not playerJobsJobName.JobMenu[element.name].Condition
                                    or playerJobsJobName.JobMenu[element.name].Condition(jobName, playerPed)) then
                                playerJobsJobName.JobMenu[element.name].Action(data, menu, jobName)
                            end
                        end
                    end)
            end
        end
        if playerJobsJobName.canManage then
            if playerJobsJobName.bankBalance ~= nil then
                Items:AddButton(GetString("job_menu_bank_balance", playerJobsJobName.bankBalanceString), GetString("job_menu_bank_balance_subtitle"))
            end
            if playerJobsJobName.isGang then
                Items:AddButton(GetString("job_menu_manage_gang"), GetString("job_menu_manage_gang_subtitle"), nil, function(onSelected)
                    if onSelected then
                        JobMenuManage.Subtitle = GetString("job_menu_manage_gang")
                    end
                end, JobMenuManage)

            else
                Items:AddButton(GetString("job_menu_bills"), GetString("job_menu_bills_subtitle"), nil, function(onSelected)
                    if onSelected then
                        jobBills = {}
                        local count = 0
                        local bills = exports.ava_core:TriggerServerCallback("ava_bills:server:getJobBills", openedMenuJobName) or {}
                        for i = 1, #bills do
                            local bill = bills[i]
                            count = count + 1
                            jobBills[count] = {
                                label = bill.content:len() > 36 and bill.content:sub(0, 33) .. "..." or bill.content,
                                desc = GetString("bill_description", bill.date, bill.content),
                                rightLabel = GetString("bill_amount", exports.ava_core:FormatNumber(bill.amount)),
                                id = bill.id,
                            }
                        end
                        JobMenuBills.Description = nil
                    end
                end, JobMenuBills)

                Items:AddButton(GetString("job_menu_manage_job"), GetString("job_menu_manage_job_subtitle"), nil, function(onSelected)
                    if onSelected then
                        JobMenuManage.Subtitle = GetString("job_menu_manage_job")
                    end
                end, JobMenuManage)
            end
        end
    end)

    JobMenuManage:IsVisible(function(Items)
        local playerJobsJobName = playerJobs[openedMenuJobName]
        if not playerJobsJobName or not playerJobsJobName.canManage then
            RageUI.GoBack()
            return
        end

        Items:AddButton(GetString("job_menu_hire"), GetString("job_menu_hire_subtitle"), nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer()
                if targetId then
                    TriggerServerEvent("ava_jobs:server:job_menu_hire", targetId, openedMenuJobName)
                end
            end
        end)
        Items:AddButton(GetString("job_menu_fire"), GetString("job_menu_fire_subtitle"), nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer()
                if targetId then
                    TriggerServerEvent("ava_jobs:server:job_menu_fire", targetId, openedMenuJobName)
                end
            end
        end)
        Items:AddButton(GetString("job_menu_change_grade"), GetString("job_menu_change_grade_subtitle"), nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer()
                if targetId then
                    local jobIsGang<const> = playerJobsJobName.isGang
                    local grades, targetHasJob = exports.ava_core:TriggerServerCallback("ava_jobs:getAllGrades", openedMenuJobName, targetId)
                    if not targetHasJob then
                        if playerJobsJobName.isGang then
                            exports.ava_core:ShowNotification(GetString("player_do_not_have_this_gang"), nil, "ava_core_logo", playerJobsJobName.LabelName)
                        else
                            exports.ava_core:ShowNotification(GetString("player_do_not_have_this_job"), nil, "ava_core_logo", playerJobsJobName.LabelName)
                        end
                        return
                    end
                    if grades then
                        for i = 1, #grades do
                            local grade = grades[i]
                            grade.desc = grade.actual and GetString("job_menu_player_actual_grade")
                                             or (grade.canManage
                                                 and GetString(jobIsGang and "job_menu_grade_can_manage_members" or "job_menu_grade_can_manage_employees"))
                        end

                        RageUI.OpenTempMenu(GetString("job_menu_select_grade"), function(Items)
                            for i = 1, #grades do
                                local grade = grades[i]

                                Items:AddButton(grade.label, grade.desc, {LeftBadge = grade.canManage and RageUI.BadgeStyle.Star, IsDisabled = grade.actual},
                                    function(onSelected)
                                        if onSelected then
                                            TriggerServerEvent("ava_jobs:server:job_menu_change_grade", targetId, openedMenuJobName, grade.name)
                                            RageUI.GoBack()
                                        end
                                    end)
                            end
                        end, nil, JobMenuManage.Sprite.Texture, JobMenuManage.Sprite.Dictionary)
                    end
                end
            end
        end)
    end)

    JobMenuBills:IsVisible(function(Items)
        if jobBills then
            for i = 1, #jobBills do
                local bill = jobBills[i]
                if bill then
                    Items:AddButton(bill.label, bill.desc, {RightLabel = bill.rightLabel}, function(onSelected)
                        if onSelected then
                            Citizen.CreateThread(function()
                                if exports.ava_core:TriggerServerCallback("ava_bills:server:payBill", bill.id) then
                                    table.remove(jobBills, i)
                                end
                            end)
                        end
                    end)
                end
            end
        end
    end)
end

