-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MainAdminMenu = RageUI.CreateMenu("", "Administration", 0, 0, "avaui", "avaui_title_adezou")

RegisterCommand("adminmenu", function()
    if not isAdmin then
        isAdmin = not not AVA.TriggerServerCallback("ava_core:IsPlayerAceAllowed", "command.adminmenu")
    end
    if isAdmin then
        RageUI.Visible(MainAdminMenu, true)
    end
end)

RegisterKeyMapping("adminmenu", "Admin menu", "keyboard", "HOME")

function RageUI.PoolMenus:AdminMenu()
    MainAdminMenu:IsVisible(function(Items)

    end)
end
