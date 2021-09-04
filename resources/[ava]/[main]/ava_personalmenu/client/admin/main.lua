-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MainAdminMenu = RageUI.CreateMenu("", GetString("admin_menu_title"), 0, 0, "avaui", "avaui_title_adezou")
---@type adminmenu_perms
perms = {}
playersData = {}

local noclipEnabled = false
local tpcoords_lastinput = ""

RegisterCommand("adminmenu", function()
    if isAdmin == nil then
        isAdmin, perms = AVA.TriggerServerCallback("ava_core:isAdminAllowed")
    end

    if isAdmin then
        -- print(json.encode(perms, {indent = true}))

        RageUI.CloseAll()
        RageUI.Visible(MainAdminMenu, true)
    end
end)

RegisterKeyMapping("adminmenu", GetString("admin_menu"), "keyboard", "HOME")

function RageUI.PoolMenus:AdminMenu()
    MainAdminMenu:IsVisible(function(Items)
        if perms then
            if perms.playerlist then
                Items:AddButton(GetString("admin_menu_player_list"), GetString("admin_menu_player_list_subtitle"), {RightLabel = "→→→"}, nil,
                    PlayerListSubMenu)
            end
            if perms.playersoptions then
                Items:AddButton(GetString("admin_menu_players_options"), GetString("admin_menu_players_options_subtitle"), {RightLabel = "→→→"}, nil,
                    PlayersOptionsSubMenu)
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
            if perms.noclip then
                Items:CheckBox(GetString("admin_menu_noclip"), GetString("admin_menu_noclip_subtitle"), noclipEnabled, nil, function(onSelected, IsChecked)
                    if (onSelected) then
                        ExecuteCommand("noclip")
                    end
                end)
            end
            if perms.vehicles then
                Items:AddButton(GetString("admin_menu_vehicles"), GetString("admin_menu_vehicles_subtitle"), {RightLabel = "→→→"}, nil, VehiclesSubMenu)
            end
        end
    end)

    PoolPlayerList()
    PoolVehicles()
end

--------------------------------------
--------------- NOCLIP ---------------
--------------------------------------
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local pi = math.pi
local function getCamDirection(playerPed)
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(playerPed)
    local pitch = GetGameplayCamRelativePitch()

    local x = -sin(heading * pi / 180.0)
    local y = cos(heading * pi / 180.0)
    local z = sin(pitch * pi / 180.0)

    local len = sqrt(x * x + y * y + z * z)

    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z, heading
end

RegisterNetEvent("ava_personalmenu:client:toggleNoclip", function()
    noclipEnabled = not noclipEnabled

    if not noclipEnabled then
        return
    end

    Citizen.CreateThread(function()
        local unpack = table.unpack
        local instructionalButtons = exports.ava_core:GetScaleformInstructionalButtons({
            {control = "~INPUT_AIM~", label = GetString("admin_menu_noclip_leave")},
            {control = "~INPUT_SPRINT~", label = GetString("admin_menu_noclip_accelerate")},
            {control = GetControlGroupInstructionalButton(2, 0, 0), label = GetString("admin_menu_noclip_move")},
            {control = GetControlGroupInstructionalButton(2, 4, 0), label = GetString("admin_menu_noclip_up_down")},
        })
        local playerPed = PlayerPedId()

        FreezeEntityPosition(playerPed, true)
        SetEntityVisible(playerPed, false, false)
        SetLocalPlayerVisibleLocally(true)
        ClearPedTasksImmediately(playerPed)

        while noclipEnabled do
            Wait(0)
            playerPed = PlayerPedId()
            local x, y, z
            local speed = 0.5

            SetEntityVelocity(playerPed, 0.0001, 0.0001, 0.0001)
            SetLocalPlayerVisibleLocally(true)
            SetEntityAlpha(playerPed, 100, false)

            if IsControlPressed(0, 21) then -- ~INPUT_SPRINT~
                speed = 5.0
            end

            local isUpKeyPressed = IsControlPressed(0, 172)
            local isDownPressed = IsControlPressed(0, 173)
            local isLeftPressed = IsControlPressed(0, 34) -- A
            local isRightPressed = IsControlPressed(0, 35) -- D
            if isUpKeyPressed or isDownPressed or isLeftPressed or isRightPressed then
                local xOffset, zOffset = 0, 0

                if isUpKeyPressed then
                    zOffset = 0.1 * speed
                elseif isDownPressed then
                    zOffset = -0.1 * speed
                end
                if isLeftPressed then
                    xOffset = -0.5 * speed
                elseif isRightPressed then
                    xOffset = 0.5 * speed
                end

                x, y, z = unpack(GetOffsetFromEntityInWorldCoords(playerPed, xOffset, 0, zOffset))
            end

            local isForwardPressed = IsControlPressed(0, 32) -- W
            local isBackwardPressed = IsControlPressed(0, 33) -- S
            if isForwardPressed or isBackwardPressed then
                if not x or not y or not z then
                    x, y, z = unpack(GetEntityCoords(playerPed, true))
                end
                local dx, dy, dz, camHeading = getCamDirection(playerPed)

                if isForwardPressed then
                    x = x + speed * dx
                    y = y + speed * dy
                    z = z + speed * dz
                elseif isBackwardPressed then
                    x = x - speed * dx
                    y = y - speed * dy
                    z = z - speed * dz
                end
                SetEntityHeading(playerPed, camHeading)
            end

            if x and y and z then
                SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)
            end
            if isUpKeyPressed or isDownPressed then
                SetGameplayCamRelativeHeading(0)
            end

            DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)

            if IsControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 25) then -- ~INPUT_AIM~
                noclipEnabled = false
            end
        end

        FreezeEntityPosition(playerPed, false)
        SetEntityVisible(playerPed, true, false)
        SetLocalPlayerVisibleLocally(true)
        ResetEntityAlpha(playerPed)
    end)
end)

