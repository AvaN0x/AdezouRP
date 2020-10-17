-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent("esx_avan0x:clip")
AddEventHandler("esx_avan0x:clip", function()
  playerPed = GetPlayerPed(-1)
  if IsPedArmed(playerPed, 4) then
    hash = GetSelectedPedWeapon(playerPed)
    if hash ~= nil then
      TriggerServerEvent("esx_clip:remove")
      AddAmmoToPed(playerPed, hash, 25)
      ESX.ShowNotification("Tu as utilisé un chargeur de 25 balles")
    else
      ESX.ShowNotification("Tu n'as pas d'arme en main")
    end
  else
    ESX.ShowNotification("Ce type de munition ne convient pas")
  end
end)
