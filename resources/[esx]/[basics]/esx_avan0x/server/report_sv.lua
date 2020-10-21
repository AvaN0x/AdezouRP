-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


TriggerEvent('es:addGroupCommand', 'report', 'user', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
    local name = (GetPlayerName(source) or "SteamName")

    local msg = table.concat(args, " ") or ""

	if msg ~= "" then
		SendWebhookEmbedMessage("avan0x_wh_staff", "", "**" .. name .. "** :\n"..msg, 16733269)

		TriggerClientEvent('esx_avan0x:sendReport', -1, source, name, msg)
	end
end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient Permissions.'}})
end, {
	help = "Report au staff",
	params = {
		{
			name = "message",
			help = "Le contenu de votre message"
		}
	}
})
