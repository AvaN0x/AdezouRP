-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- isAdmin will be true if the player have at least "mod" principal
isAdmin = nil
playerPed = 0
playerVehicle = 0
playerVehicleData = {}

isInMenuLoop = false
local DoorsToCheck<const> = {{4, "hood"}, {5, "trunk"}, {0, "front_left"}, {1, "front_right"}, {2, "back_left"}, {3, "back_right"}}

MainPersonalMenu = RageUI.CreateMenu("", GetString("personal_menu"), 0, 0, "avaui", "avaui_title_adezou")
MainPersonalMenu.Display.Glare = true
MainPersonalMenu.Closed = function()
    isInMenuLoop = false
end

local function startInMenuLoop()
    if isInMenuLoop then
        return
    end
    isInMenuLoop = true

    Citizen.CreateThread(function()
        local pairs = pairs
        while isInMenuLoop do
            playerPed = PlayerPedId()

            vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle ~= 0 then
                newData = {}
                newData.class = GetVehicleClass(vehicle)

                local driver = GetPedInVehicleSeat(vehicle, -1)
                if driver == playerPed then
                    -- is driver
                    newData.playerSeat = -1
                    newData.isDriverSeatFree = false
                elseif GetPedInVehicleSeat(vehicle, 0) == playerPed then
                    -- is passenger
                    newData.playerSeat = 0
                    newData.isDriverSeatFree = driver == 0
                else
                    -- we only care about driver and passenger seats
                    newData.playerSeat = 2
                end

                newData.doors = {}
                local doorCount = 0
                for i = 1, #DoorsToCheck do
                    local door = DoorsToCheck[i]
                    if DoesVehicleHaveDoor(vehicle, door[1]) then
                        doorCount = doorCount + 1
                        newData.doors[doorCount] = door
                    end
                end

                newData.isEngineOn = GetIsVehicleEngineRunning(vehicle)
            end
            playerVehicle = vehicle
            playerVehicleData = newData
            Wait(500)
        end
    end)
end

RegisterCommand("personalMenu", function()
    checkAdminPerms()

    startInMenuLoop()
    RageUI.CloseAll()
    RageUI.Visible(MainPersonalMenu, true)
end)

RegisterKeyMapping("personalMenu", GetString("personal_menu"), "keyboard", "F5")

function RageUI.PoolMenus:PersonalMenu()
    MainPersonalMenu:IsVisible(function(Items)
        Items:AddButton(GetString("personal_menu_emotes"), nil, {RightLabel = "→→→"}, nil)
        Items:AddButton(GetString("personal_menu_vehicle_management"), nil,
            {RightLabel = "→→→", IsDisabled = playerVehicle == 0 or playerVehicleData.playerSeat == 2}, function(onSelected)
                if onSelected then
                    OnVehiclesManagementSubMenuOpened()
                end
            end, VehiclesManagementSubMenu)

        Items:AddButton(GetString("personal_menu_miscs"), nil, {RightLabel = "→→→"}, nil, MiscsSubMenu)

        Items:AddButton(GetString("personal_menu_save_player"), nil, {LeftBadge = RageUI.BadgeStyle.Tick}, function(onSelected)
            if onSelected then
                ExecuteCommand("save")
            end
        end)

        if isAdmin then
            Items:AddButton(GetString("personal_menu_admin_menu"), nil, {RightLabel = "→→→", LeftBadge = RageUI.BadgeStyle.Alert}, nil, MainAdminMenu)
        end
    end)

    PoolMiscs()
    PoolVehicleManagement()
end
