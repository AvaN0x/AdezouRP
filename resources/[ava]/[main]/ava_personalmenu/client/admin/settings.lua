-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AdminSettingsSubMenu = RageUI.CreateSubMenu(MainAdminMenu, GetString("admin_menu_title"), GetString("admin_settings"))
local AdminSettings = {}
AdminSettings.Notifications = {}
AddEventHandler("ava_personalmenu:client:playerIsAdmin", function()
    Citizen.CreateThread(function()
        -- * 1 mean disabled, 0 is enabled
        AdminSettings.Notifications = {
            death = not (GetResourceKvpInt("admin_notifications_disabled_death") == 1),
            loginout = not (GetResourceKvpInt("admin_notifications_disabled_loginout") == 1),
        }
        print(json.encode(AdminSettings))
    end)
end)

function PoolAdminSettings()
    AdminSettingsSubMenu:IsVisible(function(Items)
        for notifName, v in pairs(AdminSettings.Notifications) do
            Items:CheckBox(GetString("admin_notifications_" .. notifName), GetString("admin_notifications_" .. notifName .. "_subtitle"), v, nil,
                function(onSelected, IsChecked)
                    if (onSelected) then
                        AdminSettings.Notifications[notifName] = not AdminSettings.Notifications[notifName]
                        SetResourceKvpInt("admin_notifications_disabled_" .. notifName, AdminSettings.Notifications[notifName] and 0 or 1) -- 1 is disabled
                        print(GetResourceKvpInt("admin_notifications_disabled_" .. notifName))
                    end
                end)
        end
    end)
end

RegisterNetEvent("ava_personalmenu:client:notifAdmins", function(notifType, ...)
    checkAdminPerms()
    if isAdmin then
        -- * type can be : "death", "loginout"
        print(notifType, AdminSettings.Notifications[notifType])
        if not AdminSettings.Notifications or AdminSettings.Notifications[notifType] == nil or AdminSettings.Notifications[notifType] == true then
            exports.ava_core:ShowNotification(...)
        end
    end
end)
