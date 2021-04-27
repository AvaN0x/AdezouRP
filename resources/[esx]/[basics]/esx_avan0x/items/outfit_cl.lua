-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local usedOutfit = nil

RegisterNetEvent('esx_avan0x:settenuecasa')
AddEventHandler('esx_avan0x:settenuecasa', function()
	if usedOutfit ~= 'casa' then
		usedOutfit = 'casa'
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
		usedOutfit = nil
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


RegisterNetEvent('esx_avan0x:settenueprison')
AddEventHandler('esx_avan0x:settenueprison', function()
	if usedOutfit ~= 'prison' then
		usedOutfit = 'prison'
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
				-- local clothesSkin = {
				-- 	['tshirt_1']  = 14, ['tshirt_2']  = 0,
				-- 	['torso_1']   = 73, ['torso_2']   = 0,
				-- 	['decals_1']  = 0,  ['decals_2']  = 0,
				-- 	['mask_1']    = 0, ['mask_2']    = 6,
				-- 	['arms']      = 14,
				-- 	['pants_1']   = 3, ['pants_2']   = 15,
				-- 	['shoes_1']   = 52, ['shoes_2']   = 0,
				-- 	['helmet_1']  = -1, ['helmet_2']  = 0,
				-- 	['bags_1']    = 0, ['bags_2']  = 0,
				-- 	['bproof_1']  = 0,  ['bproof_2']  = 0,
				-- 	['chain_1']	  = 0,  ['chain_2']   = 0
				-- }
				-- TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                TriggerEvent('skinchanger:loadClothes', skin, json.decode('{"chain_2":0,"bproof_1":0,"chain_1":0,"bags_2":0,"shoes_2":12,"torso_1":247,"tshirt_1":14,"helmet_2":0,"torso_2":0,"pants_1":134,"helmet_1":-1,"arms":15,"shoes_1":72,"tshirt_2":0,"bags_1":84,"bproof_2":0,"pants_2":4}'))
			end
		end)
	else
		usedOutfit = nil
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
