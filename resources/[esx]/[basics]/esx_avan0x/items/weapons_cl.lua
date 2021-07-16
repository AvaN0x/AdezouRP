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
local CLIP_SIZE = 25
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
                if GetAmmoInPedWeapon(playerPed, weaponHash) <= CLIP_SIZE * 9 then
                    TriggerServerEvent("esx_avan0x:removeClip")
                    AddAmmoToPed(playerPed, weaponHash, CLIP_SIZE)
                    ESX.ShowNotification("Tu as utilisé un chargeur de " .. CLIP_SIZE .. " balles.")
                else
                    ESX.ShowNotification("Tu ne peux pas utiliser plus de chargeurs avec cette arme.")
                end
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
    SetWeaponsNoAutoreload(true)
    SetWeaponsNoAutoswap(true)

    while true do
        Wait(0)
        DisableControlAction(0, 140, true) -- light melee attack

        if IsControlJustPressed(0, 45) then
            local playerPed = PlayerPedId()
            if IsPedArmed(playerPed, 4) and not isReloading then
                local weaponHash = GetSelectedPedWeapon(playerPed)

                if weaponHash ~= nil then
                    -- local _, actualClipSize = GetAmmoInClip(playerPed, weaponHash)
                    local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
                    local maxClipSize = GetMaxAmmoInClip(playerPed, weaponHash, true)
                    print(pedAmmo .. "/" .. maxClipSize)
                    if pedAmmo >= 0 and maxClipSize < 1000 and pedAmmo < maxClipSize and not IsPedSwappingWeapon(playerPed) then
                        isReloading = true
                        SetPedCanSwitchWeapon(playerPed, false)
                        TriggerServerEvent('esx_avan0x:checkClip')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("esx_avan0x:checkIfClipsNeededBeforeRemove")
AddEventHandler("esx_avan0x:checkIfClipsNeededBeforeRemove", function(weaponName)
    local playerPed = PlayerPedId()
    local weaponHash = GetHashKey(weaponName)

    if weaponHash ~= nil then
        local pedAmmo = GetAmmoInPedWeapon(playerPed, weaponHash)
        local equivalentInClips = math.floor(pedAmmo / CLIP_SIZE)
        SetPedAmmo(playerPed, weaponHash, (pedAmmo - equivalentInClips * CLIP_SIZE))
        TriggerServerEvent("esx_avan0x:requestClipsAndRemove", weaponName, equivalentInClips)
    end
end)



-- local playerPed = nil

-- Citizen.CreateThread(function()
--     SetWeaponsNoAutoreload(true)
--     SetWeaponsNoAutoswap(true)
-- 	while true do
--         playerPed = PlayerPedId()
-- 		Wait(5000)
--     end
-- end)


-- local reloadKeyIsPressed = false
-- local isReloading = false
-- local hasNoClips = false

-- local noAmmo = false

-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
        
--         if isReloading then
--             Wait(100)
--         elseif IsPedArmed(playerPed, 4) then
--             local weaponHash = GetSelectedPedWeapon(playerPed)

--             if weaponHash ~= nil then
--                 local _, actualClipSize = GetAmmoInClip(playerPed, weaponHash)
--                 DisableControlAction(0, 45, true) -- reload
--                 DisableControlAction(0, 140, true) -- light melee attack

--                 if (not noAmmo and actualClipSize == 0) and not IsPedSwappingWeapon(playerPed) then
--                     -- isReloading = true
--                     noAmmo = true
--                     print(weaponHash)
--                     ESX.ShowNotification(weaponHash)

--                     TaskSwapWeapon(playerPed, false)
--                     -- SetCurrentPedWeapon(playerPed, weaponHash, true)
                    
--                     -- SetPedCanSwitchWeapon(playerPed, false)
--                     -- DisablePlayerFiring(playerPed, true) -- only one frame


--                     -- TriggerServerEvent('esx_avan0x:checkClip', weaponHash)

--                 elseif (IsDisabledControlPressed(0, 45) and actualClipSize < GetMaxAmmoInClip(playerPed, weaponHash, true)) and not IsPedSwappingWeapon(playerPed) then
--                     isReloading = true
--                     SetPedCanSwitchWeapon(playerPed, false)
--                     -- DisablePlayerFiring(playerPed, true) -- only one frame
--                     TriggerServerEvent('esx_avan0x:checkClip', weaponHash)
--                 elseif actualClipSize > 0 then
--                     noAmmo = false
--                 end
--             end
--         end

--     end
-- end)


-- RegisterNetEvent('esx_avan0x:useClip')
-- AddEventHandler('esx_avan0x:useClip', function(canReload, weaponHash)
--     local playerPed = PlayerPedId()
--     if not weaponHash then
--         weaponHash = GetSelectedPedWeapon(playerPed)
--     end
--     if canReload then
--         local _, actualClipSize = GetAmmoInClip(playerPed, weaponHash)
--         local maxClipSize = GetMaxAmmoInClip(playerPed, weaponHash, true)

--         if (actualClipSize < maxClipSize) then
--             SetCurrentPedWeapon(playerPed, weaponHash, true)
--             TriggerServerEvent("esx_avan0x:removeClip")
--             SetAmmoInClip(playerPed, weaponHash, 0)
--             SetPedAmmo(playerPed, weaponHash, maxClipSize)
--             MakePedReload(playerPed)
--             -- TaskReloadWeapon(playerPed)

--             print(weaponHash .. " : " ..  actualClipSize .. "/" .. maxClipSize)
--             ESX.ShowNotification(weaponHash .. " : " .. actualClipSize .. "/" .. maxClipSize)

--             Citizen.Wait(1000)
--         end
--     else
--         hasNoClips = true
--         print("Tu n'as plus de chargeurs")
--         ESX.ShowNotification("Tu n'as plus de chargeurs")
--     end
--     SetPedCanSwitchWeapon(playerPed, true)
--     Wait(500)
--     isReloading = false
-- end)

