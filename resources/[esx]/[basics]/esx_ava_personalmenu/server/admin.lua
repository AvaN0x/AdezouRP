RegisterServerEvent("esx_ava_personalmenu:kick")
AddEventHandler("esx_ava_personalmenu:kick", function(author, id, label)
	DropPlayer(id, "Tu as été kick par "..author.." : ".. label)
end)