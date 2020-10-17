-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local useTenu = nil

RegisterNetEvent('adezou_items:settenuecasa')
AddEventHandler('adezou_items:settenuecasa', function()
	if useTenu ~= 'casa' then
		useTenu = 'casa'
		TriggerEvent('skinchanger:getSkin', function(skin)
			-- TODO change the way the skin is stored
			if skin.sex == 0 then
				local clothesSkin = {
					['tshirt_1']  = 15, ['tshirt_2']  = 0,
					['torso_1']   = 65, ['torso_2']   = 0,
					['decals_1']  = 0,  ['decals_2']  = 0,
					['mask_1']    = 50, ['mask_2']    = 6,
					['arms']      = 17,
					['pants_1']   = 38, ['pants_2']   = 0,
					['shoes_1']   = 54, ['shoes_2']   = 0,
					['helmet_1']  = -1, ['helmet_2']  = 0,
					['bags_1']    = 44, ['bags_2']    = 0,
					['bproof_1']  = 0,  ['bproof_2']  = 0,
					['chain_1']	  = 0,  ['chain_2']   = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else
				local clothesSkin = {
					['tshirt_1']  = 14, ['tshirt_2']  = 0,
					['torso_1']   = 59, ['torso_2']   = 0,
					['decals_1']  = 0,  ['decals_2']  = 0,
					['mask_1']    = 50, ['mask_2']    = 6,
					['arms']      = 18,
					['pants_1']   = 38, ['pants_2']   = 0,
					['shoes_1']   = 55, ['shoes_2']   = 0,
					['helmet_1']  = -1, ['helmet_2']  = 0,
					['bags_1']    = 44, ['bags_2']  = 0,
					['bproof_1']  = 0,  ['bproof_2']  = 0,
					['chain_1']	  = 0,  ['chain_2']   = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end
		end)
	else
		useTenu = nil
		TriggerEvent('skinchanger:getSkin', function(skin)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, hasSkin)
				if hasSkin then
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
				end
			end)
		end)
	end
end)


RegisterNetEvent('adezou_items:settenueprison')
AddEventHandler('adezou_items:settenueprison', function()
	if useTenu ~= 'prison' then
		useTenu = 'prison'
		TriggerEvent('skinchanger:getSkin', function(skin)
			local playerPed = GetPlayerPed(-1)
			if skin.sex == 0 then
				local clothesSkin = {
					['tshirt_1']  = 15, ['tshirt_2']  = 0,
					['torso_1']   = 5, ['torso_2']   = 0,
					['decals_1']  = 0,  ['decals_2']  = 0,
					['mask_1']    = 0, ['mask_2']    = 6,
					['arms']      = 5,
					['pants_1']   = 9, ['pants_2']   = 4,
					['shoes_1']   = 61, ['shoes_2']   = 0,
					['helmet_1']  = -1, ['helmet_2']  = 0,
					['bags_1']    = 0, ['bags_2']    = 0,
					['bproof_1']  = 0,  ['bproof_2']  = 0,
					['chain_1']	  = 0,  ['chain_2']   = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			else
				local clothesSkin = {
					['tshirt_1']  = 14, ['tshirt_2']  = 0,
					['torso_1']   = 73, ['torso_2']   = 0,
					['decals_1']  = 0,  ['decals_2']  = 0,
					['mask_1']    = 0, ['mask_2']    = 6,
					['arms']      = 14,
					['pants_1']   = 3, ['pants_2']   = 15,
					['shoes_1']   = 52, ['shoes_2']   = 0,
					['helmet_1']  = -1, ['helmet_2']  = 0,
					['bags_1']    = 0, ['bags_2']  = 0,
					['bproof_1']  = 0,  ['bproof_2']  = 0,
					['chain_1']	  = 0,  ['chain_2']   = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
			end
		end)
	else
		useTenu = nil
		TriggerEvent('skinchanger:getSkin', function(skin)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, hasSkin)
				if hasSkin then
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx:restoreLoadout')
				end
			end)
		end)
	end
end)
