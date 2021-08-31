-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- isAdmin will be true if the player have at least "mod" principal
isAdmin = nil
playerPed = 0
playerVehicle = 0
playerVehicleData = {}

local isInMenuLoop = false

MainPersonalMenu = RageUI.CreateMenu("", GetString("personal_menu"), 0, 0, "avaui", "avaui_title_adezou")
MainPersonalMenu.Closed = function()
    isInMenuLoop = false
end

local function startInMenuLoop()
    if isInMenuLoop then
        return
    end
    isInMenuLoop = true

    Citizen.CreateThread(function()
        while isInMenuLoop do
            playerPed = PlayerPedId()

            playerVehicle = GetVehiclePedIsIn(playerPed, false)
            if playerVehicle ~= 0 then
                playerVehicleData = {}
                playerVehicleData.class = GetVehicleClass(playerVehicle)
                
                local driver = GetPedInVehicleSeat(playerVehicle, -1)
                if driver == playerPed then
                    -- is driver
                    playerVehicleData.playerSeat = -1
                    playerVehicleData.isDriverSeatFree = false
                elseif GetPedInVehicleSeat(playerVehicle, -1) == playerPed then
                    -- is passenger
                    playerVehicleData.playerSeat = 0
                    playerVehicleData.isDriverSeatFree = driver == 0
                else
                    -- we only care about driver and passenger seats
                    playerVehicleData.playerSeat = 2
                end
                
                playerVehicleData.isEngineOn = GetIsVehicleEngineRunning(playerVehicle)
            end
            Wait(500)
        end
    end)
end

RegisterCommand("personalMenu", function()
    if isAdmin == nil then
        isAdmin, perms = AVA.TriggerServerCallback("ava_core:isAdminAllowed")
    end

    startInMenuLoop()
    RageUI.CloseAll()
    RageUI.Visible(MainPersonalMenu, true)
end)

RegisterKeyMapping("personalMenu", GetString("personal_menu"), "keyboard", "F5")



function RageUI.PoolMenus:PersonalMenu()
    MainPersonalMenu:IsVisible(function(Items)
        Items:AddButton(GetString("personal_menu_emotes"), nil, {RightLabel = "→→→"}, nil)
        Items:AddButton(GetString("personal_menu_vehicle_management"), nil, {RightLabel = "→→→", IsDisabled = playerVehicle == 0}, nil, VehiclesManagementSubMenu)
        
        Items:AddButton(GetString("personal_menu_save_player"), nil, {LeftBadge = RageUI.BadgeStyle.Tick}, function(onSelected)
            if onSelected then
                ExecuteCommand("save")
            end
        end)
        if isAdmin then
            Items:AddButton(GetString("personal_menu_admin_menu"), nil, {RightLabel = "→→→", LeftBadge = RageUI.BadgeStyle.Alert}, nil, MainAdminMenu)
        end
    end)

    PoolVehicleManagement()
end
