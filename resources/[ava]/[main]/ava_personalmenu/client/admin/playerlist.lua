-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
PlayerListSubMenu = RageUI.CreateSubMenu(MainAdminMenu, "", GetString("player_list"))

function PoolPlayerList()
    if perms.playerlist then
        PlayerListSubMenu:IsVisible(function(Items)

        end)
    end
end

