-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
--------------------
-- Bank Managment --
--------------------
local updateJobsToSelect
local SelectJobMenu = RageUI.CreateMenu("", GetString("bank_managment_menu"), 0, 0, "avaui", "avaui_title_adezou")
local openedMenuJobName = nil
SelectJobMenu.Closed = function()
    if openedMenuJobName == nil then
        CurrentActionEnabled = true
    end
end

local JobsToSelect = {}

function BankManagmentMenu()
    updateJobsToSelect()

    RageUI.CloseAll()
    RageUI.Visible(SelectJobMenu, true)
end

updateJobsToSelect = function()
    JobsToSelect = {}
    local jobCount = 0
    for jobName, job in pairs(playerJobs) do
        if not job.isIllegal and not job.isGang and job.canManage then
            jobCount = jobCount + 1
            JobsToSelect[jobCount] = {label = job.LabelName, name = jobName}
        end
    end
end

local MainBankManagmentMenu = RageUI.CreateSubMenu(SelectJobMenu, "", GetString("bank_managment_menu_title", ""), 0, 0, "avaui", "avaui_title_adezou")
MainBankManagmentMenu.Closed = function()
    openedMenuJobName = nil

    updateJobsToSelect()
end

local function ManagmentMenu(jobName)
    local playerJobsJobName = playerJobs[jobName]
    if not playerJobsJobName then
        return
    end
    openedMenuJobName = jobName

    MainBankManagmentMenu.Subtitle = GetString("bank_managment_menu_title", playerJobsJobName.LabelName)
    if not RageUI.Visible(MainBankManagmentMenu) then
        RageUI.Visible(MainBankManagmentMenu, true)
    end
end

function RageUI.PoolMenus:BankManagmentMenu()
    SelectJobMenu:IsVisible(function(Items)
        if #JobsToSelect < 1 then
            RageUI.GoBack()
            return
        end

        for i = 1, #JobsToSelect do
            local element = JobsToSelect[i]
            Items:AddButton(element.label, nil, {RightLabel = "→→→"}, function(onSelected)
                if onSelected then
                    ManagmentMenu(element.name)
                end
            end, MainBankManagmentMenu)
        end
    end)

    MainBankManagmentMenu:IsVisible(function(Items)
        local playerJobsJobName = playerJobs[openedMenuJobName]
        if not playerJobsJobName or not playerJobsJobName.canManage then
            RageUI.GoBack()
            return
        end

        if playerJobsJobName.bankBalance then
            Items:AddButton(GetString("bank_managment_menu_bank_balance", playerJobsJobName.bankBalanceString),
                GetString("bank_managment_menu_bank_balance_subtitle"))
        end
        Items:AddButton(GetString("bank_managment_menu_bank_deposit"), GetString("bank_managment_menu_bank_deposit_subtitle"), nil, function(onSelected)
            if onSelected then
                local amount = tonumber(exports.ava_core:KeyboardInput(GetString("bank_managment_deposit_input"), "", 10))

                if type(amount) == "number" and math.floor(amount) == amount and amount > 0 then
                    TriggerServerEvent("ava_jobs:server:bank_managment:deposit", openedMenuJobName, amount)
                else
                    exports.ava_core:ShowNotification(GetString("amount_invalid"))
                end
            end
        end)
        Items:AddButton(GetString("bank_managment_menu_bank_withdraw"), GetString("bank_managment_menu_bank_withdraw_subtitle"), nil, function(onSelected)
            if onSelected then
                local amount = tonumber(exports.ava_core:KeyboardInput(GetString("bank_managment_withdraw_input"), "", 10))

                if type(amount) == "number" and math.floor(amount) == amount and amount > 0 then
                    TriggerServerEvent("ava_jobs:server:bank_managment:withdraw", openedMenuJobName, amount)
                else
                    exports.ava_core:ShowNotification(GetString("amount_invalid"))
                end
            end
        end)

        Items:AddButton(GetString("bank_managment_menu_bank_wash_money"), GetString("bank_managment_menu_bank_wash_money_subtitle"),
            {LeftBadge = RageUI.BadgeStyle.Gun, Color = {BackgroundColor = RageUI.ItemsColour.MenuBlueExtraDark}}, function(onSelected)
                if onSelected then
                    local amount = tonumber(exports.ava_core:KeyboardInput(GetString("bank_managment_wash_money_input"), "", 10))

                    if type(amount) == "number" and math.floor(amount) == amount and amount > 0 then
                        TriggerServerEvent("ava_jobs:server:bank_managment:washMoney", openedMenuJobName, amount)
                    else
                        exports.ava_core:ShowNotification(GetString("amount_invalid"))
                    end
                end
            end)

    end)
end

