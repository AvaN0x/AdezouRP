Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local id = GetPlayerServerId(PlayerId())
		Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', "~o~Adezou RôlePlay~s~ | Discord : ~o~discord.gg/3Q8dvDT~s~ | ID: ~o~".. GetPlayerServerId(PlayerId()) .."~s~ | ~o~".. #GetActivePlayers() .." connecté(e)s")
		end
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_LEAVE", "Se déconnecter d'~o~Adezou")
end)

Citizen.CreateThread(function()
    AddTextEntry("PM_PANE_QUIT", "Quitter ~o~FiveM 🐌")
end)
