-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent('esx_avan0x:announce')
AddEventHandler('esx_avan0x:announce', function(title, msg, sec)
    TriggerEvent('chat:addMessage', {
        color = { 220, 53, 69 },
        multiline = false,
        args = { "[Annonce] " , msg }
    })
	ESX.Scaleform.ShowFreemodeMessage(title, msg, sec)
end)