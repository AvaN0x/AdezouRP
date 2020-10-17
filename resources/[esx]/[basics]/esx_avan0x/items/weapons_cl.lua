-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent('adezou_items:checkGiveWeapon')
AddEventHandler('adezou_items:checkGiveWeapon', function(weaponName)
	if not HasPedGotWeapon(PlayerPedId(), GetHashKey(string.upper(weaponName)), false) then
		TriggerServerEvent('adezou_items:giveWeapon', weaponName)
	else
		ESX.ShowNotification("Vous avez déjà cette arme sur vous.")
	end
end)

