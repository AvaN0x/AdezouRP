-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- isAdmin will be true if the player have at least "mod" principal
isAdmin = nil

MainPersonalMenu = RageUI.CreateMenu("", "Menu personnel", 0, 0, "avaui", "avaui_title_adezou")

RegisterCommand("personalMenu", function()
    if isAdmin == nil then
        isAdmin, perms = AVA.TriggerServerCallback("ava_core:isAdminAllowed")
    end

    RageUI.CloseAll()
    RageUI.Visible(MainPersonalMenu, true)
end)

RegisterKeyMapping("personalMenu", "Menu personnel", "keyboard", "F5")

function RageUI.PoolMenus:PersonalMenu()
    MainPersonalMenu:IsVisible(function(Items)
        Items:AddButton(GetString("personal_menu_emotes"), nil, {RightLabel = "→→→"}, nil)
        Items:AddButton(GetString("personal_menu_vehicle_management"), nil, {RightLabel = "→→→"}, nil)
        
        Items:AddButton(GetString("personal_menu_save_player"), nil, {LeftBadge = RageUI.BadgeStyle.Tick}, function(onSelected)
            if onSelected then
                ExecuteCommand("save")
            end
        end)
        if isAdmin then
            Items:AddButton(GetString("personal_menu_admin_menu"), nil, {RightLabel = "→→→", LeftBadge = RageUI.BadgeStyle.Alert}, nil, MainAdminMenu)
        end
    end)
end
