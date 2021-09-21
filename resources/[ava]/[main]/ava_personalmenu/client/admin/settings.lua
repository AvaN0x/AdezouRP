-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava_personalmenu:client:notifAdmins", function(notifType, ...)
    checkAdminPerms()
    if isAdmin then
        -- * type can be : "death", "loginout"
            exports.ava_core:ShowNotification(...)
    end
end)
