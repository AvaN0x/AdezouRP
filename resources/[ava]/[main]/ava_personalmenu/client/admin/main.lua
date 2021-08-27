-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MainAdminMenu = RageUI.CreateMenu("", GetString("admin_menu_title"), 0, 0, "avaui", "avaui_title_adezou")
---@type adminmenu_perms
perms = {}
playersData = {}

local tpcoords_lastinput = ""

RegisterCommand("adminmenu", function()
    if isAdmin == nil then
        isAdmin, perms = AVA.TriggerServerCallback("ava_core:isAdminAllowed")
    end

    if isAdmin then
        -- print(json.encode(perms, {indent = true}))

        RageUI.Visible(MainAdminMenu, true)
    end
end)

RegisterKeyMapping("adminmenu", GetString("admin_menu"), "keyboard", "HOME")

function RageUI.PoolMenus:AdminMenu()
    MainAdminMenu:IsVisible(function(Items)
        if perms.playerlist then
            Items:AddButton(GetString("admin_menu_player_list"), GetString("admin_menu_player_list_subtitle"), { RightLabel = "→→→" }, nil, PlayerListSubMenu)
        end
        if perms.playersoptions then
            Items:AddButton(GetString("admin_menu_players_options"), GetString("admin_menu_players_options_subtitle"), { RightLabel = "→→→" }, nil, PlayersOptionsSubMenu)
        end
        if perms.tpcoords then
            Items:AddButton(GetString("admin_menu_tpcoords"), GetString("admin_menu_tpcoords_subtitle"), nil, function(onSelected)
                if onSelected then
                    local result = AVA.KeyboardInput(GetString("admin_menu_tpcoords_input"), tpcoords_lastinput or "", 30)
                    if result and result ~= "" then
                        tpcoords_lastinput = result
                        ExecuteCommand("tpcoords " .. result)
                    end
                end
            end)
        end
        if perms.tpwaypoint then
            Items:AddButton(GetString("admin_menu_tpwaypoint"), GetString("admin_menu_tpwaypoint_subtitle"), nil, function(onSelected)
                if onSelected then
                    ExecuteCommand("tpwaypoint")
                end
            end)
        end
        if perms.vehicles then
            Items:AddButton(GetString("admin_menu_vehicles"), GetString("admin_menu_vehicles_subtitle"), { RightLabel = "→→→" }, nil, VehiclesSubMenu)
        end
    end)

    PoolPlayerList()
    PoolVehicles()
end

