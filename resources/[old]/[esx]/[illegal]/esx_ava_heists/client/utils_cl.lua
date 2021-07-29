-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

function ToggleAlarm(name, toggle)
    if not name then
        return
    end

	if toggle then
		while not PrepareAlarm(name) do
			Citizen.Wait(0)
		end

		StartAlarm(name, 0)
	else
		StopAlarm(name, true)
	end
end