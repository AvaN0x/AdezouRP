-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MainAdminMenu = RageUI.CreateMenu("", GetString("admin_menu_title"), 0, 0, "avaui", "avaui_title_adezou")
---@type adminmenu_perms
perms = {}
playersData = {}

RegisterCommand("adminmenu", function()
    if isAdmin == nil then
        isAdmin, perms = AVA.TriggerServerCallback("ava_core:isAdminAllowed")
    end

    if isAdmin then
        print(json.encode(perms, {indent = true}))

        RageUI.Visible(MainAdminMenu, true)
    end
end)

RegisterKeyMapping("adminmenu", GetString("admin_menu"), "keyboard", "HOME")

function RageUI.PoolMenus:AdminMenu()
    MainAdminMenu:IsVisible(function(Items)
        if perms.playerlist then
            Items:AddButton(GetString("admin_menu_player_list"), GetString("admin_menu_player_list_subtitle"), nil, function(onSelected)
            end, PlayerListSubMenu)
        end
        if perms.playersoptions then
            Items:AddButton(GetString("admin_menu_players_options"), GetString("admin_menu_players_options_subtitle"), nil, function(onSelected)
            end, PlayersOptionsSubMenu)
        end
        if perms.vehicles then
            Items:AddButton(GetString("admin_menu_vehicles"), GetString("admin_menu_vehicles_subtitle"), nil, function(onSelected)
            end, VehiclesSubMenu)
        end
    end)

    PoolPlayerList()
    PoolVehicles()
end

