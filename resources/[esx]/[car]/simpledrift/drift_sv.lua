RegisterServerEvent("drift:toggledrift")
AddEventHandler("drift:toggledrift", function()
	TriggerClientEvent("drift:toggledrift", source)
end)
