local Config = {
    secondsUntilKick = 1200,
    secondsBeforeAlert = 300
}
local timer = Config.secondsUntilKick
local prevPos = nil

Citizen.CreateThread(function()
	while true do
		Wait(1000)

		local playerPed = GetPlayerPed(-1)
		if playerPed then
			local currentPos = GetEntityCoords(playerPed, true)

			if currentPos == prevPos then
				if timer > 0 then
					if timer == Config.secondsBeforeAlert then
						TriggerEvent("chatMessage", "AFK", {255, 0, 0}, " Tu vas te faire kick dans " .. timer .. " secondes pour AFK !\nFait ^2/afk^7 pour reset le timer.")
					end

                    timer = timer - 1
				else
					TriggerServerEvent("afkkick:kick")
				end
			else
				timer = Config.secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)


RegisterCommand("afk", function(source, args, rawCommand)
    if timer <= Config.secondsBeforeAlert then
        timer = Config.secondsUntilKick
        TriggerEvent("chatMessage", "AFK", {0, 255, 0}, " Timer de kick AFK reset.")
    end
end, false)
