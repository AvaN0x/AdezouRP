-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

TriggerEvent('es:addGroupCommand', 'announce', "admin", function(source, args, user)
	TriggerClientEvent('esx_avan0x:announce', -1, "~r~ANNONCE STAFF", table.concat(args, " "), 10)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Autorisations insuffisantes !")
end, 
{
	help = "Annoncer un message à l'ensemble du serveur", 
	params = {
		{
			name = "announcement", 
			help = "Le message à annoncer"
		}
	}
})