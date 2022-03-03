-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
KeysSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("keys_menu"))
local playerKeys = {}

function prepareKeys()
    playerKeys = {}
    local count = 0
    local keys = exports.ava_core:TriggerServerCallback("ava_garages:server:getPlayerDisplayableKeys") or {}
    table.sort(keys, function(a, b)
        return a.keytype < b.keytype
    end)

    for i = 1, #keys do
        local key = keys[i]
        count = count + 1
        local actions = {}
        if key.keytype == 0 or key.keytype == 1 then
            table.insert(actions, { Name = GetString("key_give_double"), action = "give_double" })
        end

        if key.keytype == 0 then
            table.insert(actions, { Name = GetString("key_give_ownership"), action = "give_ownership" })
        else
            table.insert(actions, { Name = GetString("key_destroy_key"), action = "destroy_key" })
        end

        playerKeys[count] = {
            label = GetString("key_label_" .. key.keytype, key.plate),
            desc = key.label,
            id = key.vehicleid,
            actions = actions
        }
    end
    KeysSubMenu.Description = nil
end

function PoolKeys()
    KeysSubMenu:IsVisible(function(Items)
        if playerKeys then
            for i = 1, #playerKeys do
                local key = playerKeys[i]
                if key then
                    Items:AddList(key.label, key.actions, key.indice or 1, key.desc, nil, function(Index, onSelected, onListChange)
                        if onListChange then
                            playerKeys[i].indice = Index
                        end
                        if onSelected then
                            local action = key.actions[key.indice or 1].action
                            if action == "give_ownership" or action == "give_double" then
                                local targetId = exports.ava_core:ChooseClosestPlayer()
                                if targetId then
                                    if action == "give_ownership" then
                                        TriggerServerEvent("ava_garages:server:giveOwnerShip", targetId, key.id)
                                        table.remove(playerKeys, i)
                                        KeysSubMenu.Description = nil
                                    elseif action == "give_double" then
                                        TriggerServerEvent("ava_garages:server:giveDouble", targetId, key.id)
                                    end
                                end
                            elseif action == "destroy_key" then
                                TriggerServerEvent("ava_garages:server:destroyKey", key.id)
                                table.remove(playerKeys, i)
                                KeysSubMenu.Description = nil
                            end
                        end
                    end)

                end
            end
        end
    end)
end
