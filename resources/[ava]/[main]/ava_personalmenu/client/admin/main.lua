-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MainAdminMenu = RageUI.CreateMenu(GetString("admin_menu_title"), GetString("admin_menu_title"), 0, 0, "avaui", "avaui_title_adezou")

---@type adminmenu_perms
perms = {}
playersData = {}

local noclipEnabled = false
local tpcoords_lastinput = ""

function checkAdminPerms()
    if isAdmin == nil then
        isAdmin, perms = exports.ava_core:TriggerServerCallback("ava_core:isAdminAllowed")
        if isAdmin then
            TriggerEvent("ava_personalmenu:client:playerIsAdmin")
        end
    end
end

RegisterCommand("adminmenu", function()
    checkAdminPerms()

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
                Items:AddButton(GetString("admin_menu_player_list"), GetString("admin_menu_player_list_subtitle"), { RightLabel = "→→→" }, nil,
                    PlayerListSubMenu)
            end
            if perms.playersoptions then
                Items:AddButton(GetString("admin_menu_players_options"), GetString("admin_menu_players_options_subtitle"), { RightLabel = "→→→" }, nil,
                    PlayersOptionsSubMenu)
            end
            if perms.tpcoords then
                Items:AddButton(GetString("admin_menu_tpcoords"), GetString("admin_menu_tpcoords_subtitle"), nil, function(onSelected)
                    if onSelected then
                        local result = exports.ava_core:KeyboardInput(GetString("admin_menu_tpcoords_input"), tpcoords_lastinput or "", 30)
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
            if perms.chars then
                Items:AddButton(GetString("admin_menu_cleararea"), GetString("admin_menu_cleararea_subtitle"), { RightBadge = RageUI.BadgeStyle.Alert },
                    function(onSelected)
                        if onSelected then
                            ExecuteCommand("cleararea")
                        end
                    end)
            end
            if perms.chars then
                Items:AddButton(GetString("admin_menu_chars"), GetString("admin_menu_chars_subtitle"), {
                    RightBadge = function()
                        return { BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_male_icon" }
                    end,
                }, function(onSelected)
                    if onSelected then
                        RageUI.CloseAllInternal()
                        ExecuteCommand("chars")
                    end
                end)
            end
            Items:AddButton(GetString("admin_menu_admin_settings"), GetString("admin_menu_admin_settings_subtitle"), { RightLabel = "→→→" }, nil,
                AdminSettingsSubMenu)
            if perms.noclip then
                Items:CheckBox(GetString("admin_menu_noclip"), GetString("admin_menu_noclip_subtitle"), noclipEnabled, nil, function(onSelected, IsChecked)
                    if (onSelected) then
                        ExecuteCommand("noclip")
                    end
                end)
            end
            if perms.dev then
                Items:AddButton(GetString("admin_menu_dev_menu"), GetString("admin_menu_dev_menu_subtitle"), { RightLabel = "→→→" }, nil, DevAdminMenu)
            end
            if perms.vehicles then
                Items:AddButton(GetString("admin_menu_vehicles"), GetString("admin_menu_vehicles_subtitle"), { RightLabel = "→→→" }, nil, VehiclesSubMenu)
            end
        end
    end)

    PoolPlayerList()
    PoolVehicles()
    PoolAdminSettings()

    PoolDevMenu()
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
            { control = "~INPUT_AIM~", label = GetString("admin_menu_noclip_leave") },
            { control = "~INPUT_SPRINT~", label = GetString("admin_menu_noclip_accelerate") },
            { control = GetControlGroupInstructionalButton(2, 0, 0), label = GetString("admin_menu_noclip_move") },
            { control = GetControlGroupInstructionalButton(2, 4, 0), label = GetString("admin_menu_noclip_up_down") },
        })
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
            vehicle = 0
        end

        if vehicle ~= 0 then
            FreezeEntityPosition(vehicle, true)
            SetEntityVisible(vehicle, false, false)
            SetEntityLocallyVisible(vehicle)
        end
        FreezeEntityPosition(playerPed, true)
        SetEntityVisible(playerPed, false, false)
        SetLocalPlayerVisibleLocally(true)

        if vehicle == 0 then
            ClearPedTasksImmediately(playerPed)
        end

        while noclipEnabled do
            Wait(0)
            playerPed = PlayerPedId()
            local x, y, z
            local speed = 0.5

            if vehicle ~= 0 then
                DisableControlAction(0, 66, true) -- INPUT_VEH_GUN_LR
                DisableControlAction(0, 67, true) -- INPUT_VEH_GUN_UD
                DisableControlAction(0, 68, true) -- INPUT_VEH_AIM
                DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
                DisableControlAction(0, 70, true) -- INPUT_VEH_ATTACK2
                DisableControlAction(0, 75, true) -- INPUT_VEH_EXIT	
                DisableControlAction(0, 105, true) -- INPUT_VEH_DROP_PROJECTILE	
                DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK	

                SetEntityVelocity(vehicle, 0.0001, 0.0001, 0.0001)
                SetEntityLocallyVisible(vehicle)
                SetEntityAlpha(vehicle, 100, false)
            end
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

                x, y, z = unpack(GetOffsetFromEntityInWorldCoords(vehicle ~= 0 and vehicle or playerPed, xOffset, 0, zOffset))
            end

            local isForwardPressed = IsControlPressed(0, 32) -- W
            local isBackwardPressed = IsControlPressed(0, 33) -- S
            if isForwardPressed or isBackwardPressed then
                if not x or not y or not z then
                    x, y, z = unpack(GetEntityCoords(vehicle ~= 0 and vehicle or playerPed, true))
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
                SetEntityHeading(vehicle ~= 0 and vehicle or playerPed, camHeading)
            end

            if x and y and z then
                SetEntityCoordsNoOffset(vehicle ~= 0 and vehicle or playerPed, x, y, z, true, true, true)
            end
            if isUpKeyPressed or isDownPressed then
                SetGameplayCamRelativeHeading(0)
            end

            DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)

            if IsControlJustPressed(0, 25) or IsDisabledControlJustPressed(0, 25) then -- ~INPUT_AIM~
                noclipEnabled = false
            end
        end

        Wait(0)
        if vehicle ~= 0 then
            FreezeEntityPosition(vehicle, false)
            SetEntityVisible(vehicle, true, false)
            SetEntityLocallyVisible(vehicle)
            ResetEntityAlpha(vehicle)
        end
        FreezeEntityPosition(playerPed, false)
        SetEntityVisible(playerPed, true, false)
        SetLocalPlayerVisibleLocally(true)
        ResetEntityAlpha(playerPed)
    end)
end)

RegisterNetEvent("ava_personalmenu:client:clearArea", function()
    local coords = GetEntityCoords(PlayerPedId(), true)
    ClearAreaLeaveVehicleHealth(coords.x, coords.y, coords.z, 150.0, true, true, true, true)
end)
