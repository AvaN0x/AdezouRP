-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local ManagerMenu = RageUI.CreateMenu("", GetString("manager_menu", ""), 0, 0, "avaui", "avaui_title_adezou")
local openedMenuJobName = nil
ManagerMenu.Closed = function()
    CurrentActionEnabled = true
end

local ManageEmployeesMenu = RageUI.CreateSubMenu(ManagerMenu, "", GetString("manager_menu_manage_employees"), 0, 0, "avaui", "avaui_title_adezou")
local ManageEmployeeMenu = RageUI.CreateSubMenu(ManageEmployeesMenu, "", "name", 0, 0, "avaui", "avaui_title_adezou")
local selectedEmployee, myGrade

function OpenManagerMenuMenu(jobName)
    local job = playerJobs[jobName]
    if not job then
        return
    end
    openedMenuJobName = jobName

    ManagerMenu.Subtitle = GetString("manager_menu", job.LabelName)
    RageUI.CloseAll()
    RageUI.Visible(ManagerMenu, true)
end

local jobEmployees
local function fetchEmployees()
    jobEmployees = nil
    ManageEmployeesMenu.Description = GetString("manager_menu_fetching_data")
    Citizen.CreateThread(function()
        jobEmployees = exports.ava_core:TriggerServerCallback("ava_jobs:getAllEmployees", openedMenuJobName)
        table.sort(jobEmployees, function(a, b)
            return a.gradeId > b.gradeId
        end)
        local myCitizenId = PlayerData.character.citizenId
        for i = 1, #jobEmployees do
            if tostring(jobEmployees[i].id) == tostring(myCitizenId) then
                jobEmployees[i].myself = true
                myGrade = jobEmployees[i].gradeId
            end
        end
        ManageEmployeesMenu.Description = nil
    end)
end

function RageUI.PoolMenus:ManagerMenu()
    ManagerMenu:IsVisible(function(Items)
        local playerJobsJobName = playerJobs[openedMenuJobName]
        if not playerJobsJobName or not playerJobsJobName.canManage then
            RageUI.GoBack()
            return
        end

        if not playerJobsJobName.isGang then
            Items:AddButton(GetString("manager_menu_bills"), GetString("manager_menu_bills_subtitle"), {IsDisabled = true, RightLabel = "→→→"},
                function(onSelected)
                    if onSelected then
                        -- TODO get all bills and be able to pay them
                    end
                end)
        end

        local manage_menu_manage_string = playerJobsJobName.isGang and "manager_menu_manage_members" or "manager_menu_manage_employees"
        Items:AddButton(GetString(manage_menu_manage_string), GetString(manage_menu_manage_string .. "_subtitle"), {RightLabel = "→→→"},
            function(onSelected)
                if onSelected then
                    fetchEmployees()
                end
            end, ManageEmployeesMenu)

        if not playerJobsJobName.isGang then
            Items:AddButton(GetString("manager_menu_manage_salaries"), GetString("manager_menu_manage_salaries_subtitle"),
                {IsDisabled = true, RightLabel = "→→→"}, function(onSelected)
                    if onSelected then
                        -- TODO get all grades and their salaries
                    end
                end)
        end
    end)

    ManageEmployeesMenu:IsVisible(function(Items)
        if jobEmployees then
            for i = 1, #jobEmployees do
                local employee = jobEmployees[i]
                -- Items:AddButton(employee.name, nil, {RightLabel = employee.grade}, function(onSelected)
                Items:AddButton(employee.name, nil, {RightLabel = employee.grade, LeftBadge = employee.myself and RageUI.BadgeStyle}, function(onSelected)
                    if onSelected then
                        -- TODO get all grades and their salaries
                        selectedEmployee = employee
                        ManageEmployeeMenu.Subtitle = employee.name
                    end
                end, ManageEmployeeMenu)
            end
        end
    end)

    ManageEmployeeMenu:IsVisible(function(Items)
        if not selectedEmployee then
            RageUI.GoBack()
            return
        end

        Items:AddButton(GetString("job_menu_fire"), GetString("job_menu_fire_subtitle"), nil, function(onSelected)
            if onSelected then
                TriggerServerEvent("ava_jobs:server:manager_menu_fire", selectedEmployee.id, openedMenuJobName)
                RageUI.CloseAllInternal()
                CurrentActionEnabled = true
            end
        end)
        Items:AddButton(GetString("job_menu_change_grade"), GetString("job_menu_change_grade_subtitle"),
            {IsDisabled = selectedEmployee.myself or selectedEmployee.gradeId > (myGrade or 0)}, function(onSelected)
                if onSelected then
                    local jobIsGang<const> = playerJobs[openedMenuJobName].isGang
                    local grades = exports.ava_core:TriggerServerCallback("ava_jobs:getAllGrades", openedMenuJobName)

                    if grades then
                        for i = 1, #grades do
                            local grade = grades[i]
                            grade.actual = i == selectedEmployee.gradeId
                            grade.desc = grade.actual and GetString("job_menu_player_actual_grade")
                                             or (grade.canManage
                                                 and GetString(jobIsGang and "job_menu_grade_can_manage_members" or "job_menu_grade_can_manage_employees"))
                        end

                        RageUI.OpenTempMenu(GetString("job_menu_select_grade"), function(Items)
                            for i = 1, #grades do
                                local grade = grades[i]

                                Items:AddButton(grade.label, grade.desc,
                                    {LeftBadge = grade.canManage and RageUI.BadgeStyle.Star, IsDisabled = grade.actual or i > (myGrade or 0)},
                                    function(onSelected)
                                        if onSelected then
                                            TriggerServerEvent("ava_jobs:server:manager_menu_change_grade", selectedEmployee.id, openedMenuJobName, grade.name)
                                            RageUI.CloseAllInternal()
                                            CurrentActionEnabled = true
                                        end
                                    end)
                            end
                        end, nil, ManageEmployeeMenu.Sprite.Texture, ManageEmployeeMenu.Sprite.Dictionary)
                    end
                end
            end)

    end)

end

