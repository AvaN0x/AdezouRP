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

-----------
-- Clips --
-----------
local isReloading = false

RegisterNetEvent("esx_avan0x:useClip")
AddEventHandler("esx_avan0x:useClip", function(noClipsAvailable)
    local playerPed = PlayerPedId()
    if noClipsAvailable then
        ESX.ShowNotification("Vous n'avez plus de chargeurs.")
    else
        if IsPedArmed(playerPed, 4) then
            local weaponHash = GetSelectedPedWeapon(playerPed)
            if weaponHash ~= nil then
                TriggerServerEvent("esx_avan0x:removeClip")
                AddAmmoToPed(playerPed, weaponHash, 25)
                ESX.ShowNotification("Tu as utilisé un chargeur de 25 balles.")
            else
                ESX.ShowNotification("Tu n'as pas d'arme en main.")
            end
        else
            ESX.ShowNotification("Ce type de munition ne convient pas.")
        end
    end
    SetPedCanSwitchWeapon(playerPed, true)
    isReloading = false
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        DisableControlAction(0, 140, true) -- light melee attack

        if IsControlJustPressed(0, 45) then
            local playerPed = PlayerPedId()
            print(isReloading)
            if IsPedArmed(playerPed, 4) and not isReloading then
                local weaponHash = GetSelectedPedWeapon(playerPed)

                if weaponHash ~= nil then
                    -- local _, actualClipSize = GetAmmoInClip(playerPed, weaponHash)
                    local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
                    local maxClipSize = GetMaxAmmoInClip(playerPed, weaponHash, true)
                    print(pedAmmo .. "/" .. maxClipSize)
                    if pedAmmo < maxClipSize and not IsPedSwappingWeapon(playerPed) then
                        isReloading = true
                        SetPedCanSwitchWeapon(playerPed, false)
                        TriggerServerEvent('esx_avan0x:checkClip')
                    end
                end
            end
        end
    end
end)
