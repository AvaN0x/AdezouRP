local knockedOut = false
local wait = 15
local count = 40

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local playerPed = GetPlayerPed(-1)
		if IsPedInMeleeCombat(playerPed) then
			if GetEntityHealth(playerPed) < 115 then
				SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
				ShowNotification("~r~Vous êtes KO!")
				wait = 15
				knockedOut = true
			end
		end
		if knockedOut == true then
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(playerPed)

			-- todo Change with GetGameTime()
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 40
					wait = wait - 1
				end
			else
				knockedOut = false
			end
		end
	end
end)

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end
