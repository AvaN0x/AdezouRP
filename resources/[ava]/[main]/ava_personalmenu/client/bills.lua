-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
BillsSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("bills_menu"))
local playerBills = {}

function prepareBills()
    playerBills = {}
    local count = 0
    local bills = exports.ava_core:TriggerServerCallback("ava_bills:server:getPlayerBills") or {}
    for i = 1, #bills do
        local bill = bills[i]
        count = count + 1
        playerBills[count] = {
            label = bill.content:len() > 36 and bill.content:sub(0, 33) .. "..." or bill.content,
            desc = GetString("bill_description", bill.date, bill.content),
            rightLabel = GetString("bill_amount", exports.ava_core:FormatNumber(bill.amount)),
            id = bill.id,
        }
    end
    BillsSubMenu.Description = nil
end

function PoolBills()
    BillsSubMenu:IsVisible(function(Items)
        if playerBills then
            for i = 1, #playerBills do
                local bill = playerBills[i]
                if bill then
                    Items:AddButton(bill.label, bill.desc, {RightLabel = bill.rightLabel}, function(onSelected)
                        if onSelected then
                            Citizen.CreateThread(function()
                                if exports.ava_core:TriggerServerCallback("ava_bills:server:payBill", bill.id) then
                                    table.remove(playerBills, i)
                                end
                            end)
                        end
                    end)
                end
            end
        end
    end)
end

