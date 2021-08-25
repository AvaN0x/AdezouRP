-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- isAdmin will be true if the player have at least "mod" principal
isAdmin = nil

MainPersonalMenu = RageUI.CreateMenu("", "Menu personnel", 0, 0, "avaui", "avaui_title_adezou")

RegisterCommand("personalMenu", function()
    RageUI.Visible(MainPersonalMenu, true)
end)

RegisterKeyMapping("personalMenu", "Menu personnel", "keyboard", "F5")

function RageUI.PoolMenus:PersonalMenu()
    MainPersonalMenu:IsVisible(function(Items)

    end)
end
