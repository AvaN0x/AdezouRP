-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local itemCantBeUsed = {}
-- itemCantBeUsed[itemName][steamIdentifier] == true

ESX.RegisterUsableItem("dolizou", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not itemCantBeUsed["dolizou"] then
        itemCantBeUsed["dolizou"] = {}
    end

    if not itemCantBeUsed["dolizou"][xPlayer.identifier] then
        itemCantBeUsed["dolizou"][xPlayer.identifier] = true

        TriggerEvent("esx_ava_needs:useItem", source, "dolizou")

        TriggerClientEvent("esx_status:remove", source, "injured", 50000)

        TriggerClientEvent("esx_ava_needs:onTakePill", source)

        Citizen.CreateThread(function()
            Citizen.Wait(30 * 60 * 1000)
            itemCantBeUsed["dolizou"][xPlayer.identifier] = nil
        end)
    else
        local item = xPlayer.getInventoryItem("dolizou")
        TriggerClientEvent("esx:showNotification", source, _U("cant_take_more", item.label))

    end
end)
