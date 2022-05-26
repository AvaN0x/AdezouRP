-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local function getDetailString(percent)
    if (percent > 60) then
        return _('ethylotest_really_high')
    elseif (percent > 40) then
        return _('ethylotest_high')
    elseif (percent > 20) then
        return _('ethylotest_moderate')
    elseif (percent > 0) then
        return _('ethylotest_low')
    else
        return nil;
    end
end


RegisterNetEvent('esx_avan0x:ethylotest')
AddEventHandler('esx_avan0x:ethylotest', function()
    exports.esx_avan0x:ChooseClosestPlayer(function(targetId)
        TriggerServerEvent("esx_avan0x:ethylotest:remove")
        ESX.TriggerServerCallback('esx_avan0x:ethylotest:getTargetData', function(playerData)
            local elements = {
                {
                    label = _('ethylotest_drunk',
                        playerData.drunk > 0 and "#c92e2e" or "#329171",
                        playerData.drunk > 0 and _('ethylotest_positive') or _('ethylotest_negative')
                    ),
                    detail = getDetailString(playerData.drunk)
                },
                {
                    label = _('ethylotest_drugged',
                        playerData.drugged > 0 and "#c92e2e" or "#329171",
                        playerData.drugged > 0 and _('ethylotest_positive') or _('ethylotest_negative')
                    ),
                    detail = getDetailString(playerData.drugged)
                }
            }

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ethylotest_check', {
                title = _('ethylotest_menu'),
                align = 'left',
                elements = elements,
            },
            nil,
            function(data, menu)
                menu.close()
            end)

        end, targetId)
    end, "", nil, true)
end)


