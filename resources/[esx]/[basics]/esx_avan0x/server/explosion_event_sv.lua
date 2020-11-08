local BlockedExplosions = {1, 2, 4, 5, 25, 32, 33, 35, 36, 37, 38}

AddEventHandler("explosionEvent", function(sender, ev)
    for _, v in ipairs(BlockedExplosions) do
		if ev.explosionType == v then
			-- CancelEvent()
			-- // ban the creator or so but be careful. always check owner id in some other ways to confirm he's cheating
			SendWebhookEmbedMessage("avan0x_wh_dev", "", GetPlayerName(sender) .. " made an explosionEvent that got canceled, value : " .. v, 16711680) -- #ff0000
			return
		end
    end
	SendWebhookEmbedMessage("avan0x_wh_dev", "", GetPlayerName(sender) .. " made an explosionEvent, value : " .. ev.explosionType, 16711680) -- #ff0000
end)