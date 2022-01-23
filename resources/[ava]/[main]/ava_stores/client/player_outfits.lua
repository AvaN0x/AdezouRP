-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports("OpenPlayerOutfitsMenu", OpenPlayerOutfitsMenu)

local playerOutfits = nil
local outfitOptions<const> = {{Name = GetString("po_equip"), action = "equip"}, {Name = GetString("po_delete"), action = "delete"}}

function SavedOutfits()
    local store = Config.Stores[CurrentZoneName]

    OpenPlayerOutfitsMenu()
end

function OpenPlayerOutfitsMenu()
    if not playerOutfits then
        playerOutfits = exports.ava_core:TriggerServerCallback("ava_stores:server:getPlayerOutfits")
        if type(playerOutfits) == "table" then
            for i = 1, #playerOutfits do
                playerOutfits[i].outfit = json.decode(playerOutfits[i].outfit)
            end
        else
            playerOutfits = {}
        end
    end

    local outfitChanged = false
    local indices = {}
    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("po_title"), function(Items)
        Items:AddButton(GetString("po_add_outfit"), GetString("po_add_outfit_subtitle"), {RightBadge = RageUI.BadgeStyle.Clothes}, function(onSelected)
            if onSelected then
                local label = exports.ava_core:KeyboardInput(GetString("po_input_label"), GetString("po_placeholder_number", #playerOutfits + 1), 50)

                -- check if label is valid
                if not label or label == "" then
                    exports.ava_core:ShowNotification(GetString("po_invalid_label"))
                    return
                end

                Citizen.CreateThread(function()
                    local outfit = exports.ava_mp_peds:getPlayerClothes()
                    local outfitId = exports.ava_core:TriggerServerCallback("ava_stores:server:savePlayerOutfit", label, outfit)
                    table.insert(playerOutfits, {id = outfitId, label = label, outfit = outfit})
                end)
            end
        end)

        for i = 1, #playerOutfits do
            local outfit = playerOutfits[i]
            if outfit then
                Items:AddList(outfit.label, outfitOptions, indices[i] or 1, nil, nil, function(Index, onSelected, onListChange)
                    if onListChange then
                        indices[i] = Index
                    end
                    if onSelected then
                        local action = outfitOptions[indices[i] or 1].action
                        if action == "equip" then
                            outfitChanged = true
                            exports.ava_mp_peds:setPlayerClothes(outfit.outfit)

                        elseif action == "delete"
                            and exports.ava_core:ShowConfirmationMessage(GetString("po_confirm_title"), GetString("po_confirm_firstline", outfit.label),
                                GetString("po_confirm_secondline")) then
                            TriggerServerEvent("ava_stores:server:deletePlayerOutfit", outfit.id)
                            table.remove(playerOutfits, i)
                            Wait(0)
                        end
                    end
                end)
            end
        end
    end, function()
        if outfitChanged then
            TriggerServerEvent("ava_stores:server:setPlayerSkin", exports.ava_mp_peds:getPlayerCurrentSkin())
        end
        if CurrentZoneName then
            CurrentActionEnabled = true
        end
    end)

end
RegisterNetEvent("ava_stores:client:OpenPlayerOutfitsMenu", OpenPlayerOutfitsMenu)
