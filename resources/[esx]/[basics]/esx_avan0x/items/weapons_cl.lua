-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent('esx_avan0x:checkGiveWeapon')
AddEventHandler('esx_avan0x:checkGiveWeapon', function(weaponName)
	if not HasPedGotWeapon(PlayerPedId(), GetHashKey(string.upper(weaponName)), false) then
		TriggerServerEvent('esx_avan0x:giveWeapon', weaponName)
	else
		ESX.ShowNotification("Vous avez déjà cette arme sur vous.")
	end
end)

