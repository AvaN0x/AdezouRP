-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local function getDetailString(percent)
    if (percent > 60) then
        return GetString("ethylotest_really_high")
    elseif (percent > 40) then
        return GetString("ethylotest_high")
    elseif (percent > 20) then
        return GetString("ethylotest_moderate")
    elseif (percent > 0) then
        return GetString("ethylotest_low")
    else
        return nil;
    end
end

RegisterNetEvent("ava_items:ethylotest", function()
    local targetId, localId = exports.ava_core:ChooseClosestPlayer("", nil, true)
    if not targetId then
        return
    end
    TriggerServerEvent("ava_items:server:ethylotest:remove")
    local playerData = exports.ava_core:TriggerServerCallback("ava_items:server:ethylotest:getTargetData", targetId)
    if not playerData then
        return
    end

    print(json.encode(playerData, {indent = true}))
    local elements = {}
    if playerData.drunk ~= nil then
        table.insert(elements, {
            label = GetString("ethylotest_drunk", playerData.drunk > 0 and "#c92e2e" or "#329171",
                playerData.drunk > 0 and GetString("ethylotest_positive") or GetString("ethylotest_negative")),
            desc = getDetailString(playerData.drunk),
        })
    end
    if playerData.drugged ~= nil then
        table.insert(elements, {
            label = GetString("ethylotest_drugged", playerData.drugged > 0 and "#c92e2e" or "#329171",
                playerData.drugged > 0 and GetString("ethylotest_positive") or GetString("ethylotest_negative")),
            desc = getDetailString(playerData.drugged),
        })
    end

    print(json.encode(elements, {indent = true}))
    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("ethylotest_menu"), function(Items)
        for i = 1, #elements do
            local element = elements[i]
            Items:AddButton(element.label, element.desc)
        end
    end)
end)

