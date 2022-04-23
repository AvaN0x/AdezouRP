-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
VehiclesSubMenu = RageUI.CreateSubMenu(MainAdminMenu, GetString("admin_menu_title"), GetString("vehicles"))
local vehiclename_lastinput = ""

function PoolVehicles()
    if perms and perms.vehicles then
        VehiclesSubMenu:IsVisible(function(Items)
            if perms.vehicles.spawnvehicle then
                Items:AddButton(GetString("vehicles_spawnvehicle"), GetString("vehicles_spawnvehicle_subtitle"), nil, function(onSelected)
                    if onSelected then
                        local result = exports.ava_core:KeyboardInput(GetString("vehicles_spawnvehicle_input"), vehiclename_lastinput or "", 20)
                        if result and result ~= "" then
                            vehiclename_lastinput = result
                            ExecuteCommand("spawnvehicle " .. result)
                        end
                    end
                end)
            end
            if perms.vehicles.repairvehicle then
                Items:AddButton(GetString("vehicles_repairvehicle"), GetString("vehicles_repairvehicle_subtitle"), nil, function(onSelected)
                    if onSelected then
                        ExecuteCommand("repairvehicle")
                    end
                end)
            end
            if perms.vehicles.flipvehicle then
                Items:AddButton(GetString("vehicles_flipvehicle"), GetString("vehicles_flipvehicle_subtitle"), nil, function(onSelected)
                    if onSelected then
                        ExecuteCommand("flipvehicle")
                    end
                end)
            end
            if perms.vehicles.tunevehiclepink then
                Items:AddButton(GetString("vehicles_tunevehiclepink"), GetString("vehicles_tunevehiclepink_subtitle"), nil, function(onSelected)
                    if onSelected then
                        ExecuteCommand("tunevehiclepink")
                    end
                end)
            end
            if perms.vehicles.tpnearestvehicle then
                Items:AddButton(GetString("vehicles_tpnearestvehicle"), GetString("vehicles_tpnearestvehicle_subtitle"), nil, function(onSelected)
                    if onSelected then
                        ExecuteCommand("tpnearestvehicle")
                    end
                end)
            end
            if perms.vehicles.deletevehicle then
                Items:AddButton(GetString("vehicles_deletevehicle"), GetString("vehicles_deletevehicle_subtitle"), nil, function(onSelected)
                    if onSelected then
                        ExecuteCommand("deletevehicle")
                    end
                end)
            end
        end)
    end
end
