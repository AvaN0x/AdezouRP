-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local isShutdown = false

AddEventHandler("playerSpawned", function()
	if not isShutdown then
		ShutdownLoadingScreenNui()
		isShutdown = true
	end
end)