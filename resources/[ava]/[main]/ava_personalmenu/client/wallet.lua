-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
WalletSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("wallet_menu"))
local CardList<const> = {{type = "see", Name = GetString("wallet_see_card")}, {type = "show", Name = GetString("wallet_show_card")}}
local CardIndex = 1

local function ListCardHandler(Index, onSelected, onListChange, cardName, license)
    if onListChange then
        CardIndex = Index
    end
    if onSelected then
        if CardList[CardIndex].type == "see" then
            TriggerEvent("ava_core:client:showMyCard", cardName, license)
        else
            local targetId, localId = exports.ava_core:ChooseClosestPlayer()
            if targetId then
                TriggerServerEvent("ava_core:server:showMyCard", targetId, cardName)
            end
        end
    end
end
function PoolWallet()
    WalletSubMenu:IsVisible(function(Items)
        Items:AddList(GetString("wallet_card_identity"), CardList, CardIndex, GetString("wallet_card_identity_subtitle"), nil,
            function(Index, onSelected, onListChange)
                ListCardHandler(Index, onSelected, onListChange, "identity")
            end)

        if playerLicenses then
            for i = 1, #playerLicenses do
                local license = playerLicenses[i]
                Items:AddList(GetString("wallet_card_" .. license.name), CardList, CardIndex, GetString("wallet_card_" .. license.name .. "_subtitle"), nil,
                    function(Index, onSelected, onListChange)
                        ListCardHandler(Index, onSelected, onListChange, license.name, license)
                    end)
            end
        end
    end)
end

