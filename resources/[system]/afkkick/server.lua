RegisterServerEvent("afkkick:kick")
AddEventHandler("afkkick:kick", function()
	DropPlayer(source, "Tu as été AFK trop longtemps.")
end)