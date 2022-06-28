-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

if GetConvar("ava_loadingscreen_manual_shutdown", "false") ~= "false" then
    local isShutdown = false

    AddEventHandler("playerSpawned", function()
        if not isShutdown then
            ShutdownLoadingScreenNui()
            isShutdown = true
        end
    end)
end
