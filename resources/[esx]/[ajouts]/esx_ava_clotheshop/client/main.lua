-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
PlayerData = nil
local GUI = {}
GUI.Time = 0
local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local this_shop = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)


--* draw blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Shops) do
		for k2, v2 in ipairs(v.Coords) do
			local blip = AddBlipForCoord(v2.x, v2.y, v2.z)
			SetBlipSprite (blip, v.Blip.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, v.Blip.Scale)
			SetBlipColour (blip, v.Blip.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U(k))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

local playerCoords = nil
local playerPed = nil

Citizen.CreateThread(function()
	while true do
        playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		Wait(500)
    end
end)


--* draw markers
Citizen.CreateThread(function()
	while true do
        local waitTime = 500
		for k,v in pairs(Config.Shops) do
			for k2, v2 in ipairs(v.Coords) do
				if (#(playerCoords - v2) < Config.DrawDistance) then
                    waitTime = 0
					DrawMarker(v.Marker, v2.x, v2.y, v2.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)	
				end
			end
		end
        Citizen.Wait(waitTime)
	end
end)

--* menu trigger managment
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local isInMarker  = false

		for k,v in pairs(Config.Shops) do
			for k2, v2 in ipairs(v.Coords) do
				if (#(playerCoords - v2) < Config.MarkerSize.x) then
					isInMarker  = true
					this_shop = v
					currentZone = k
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone				= currentZone
			TriggerEvent('esx_ava_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_ava_clotheshop:hasExitedMarker', LastZone)
		end
	end
end)

AddEventHandler('esx_ava_clotheshop:hasEnteredMarker', function(zone)
	CurrentAction = zone
	CurrentActionMsg = _U('prompt_open_menu')
end)

AddEventHandler('esx_ava_clotheshop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 150 then
				OpenShopMenu(CurrentAction)
				CurrentAction = nil
				GUI.Time = GetGameTimer()
			end
        else
            Citizen.Wait(50)
		end
	end
end)


--* shop stuff
function OpenShopMenu(shopName)
	local shop = Config.Shops[shopName]
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = _U('catalog'), value = 'catalog'}
	}
	if shop.CanSave then
		table.insert(elements, {label = _U('my_outfits'), value = 'my_outfits'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), shopName,
		{
			css =	'skin',
			title = _U(shopName),
			align = 'left',
			elements = elements
		},
	function(data, menu)
		if data.current.value == 'catalog' then
			menu.close()
			TriggerEvent('esx_skin:openRestrictedMenu', function(dataSkin, menuSkin)
				menuSkin.close()
				TriggerEvent('skinchanger:getSkin', function(skin)
					TriggerServerEvent('esx_skin:save', skin)
				end)

				ESX.TriggerServerCallback('esx_ava_clotheshop:checkMoney', function(hasEnoughMoney)
					print(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerServerEvent('esx_ava_clotheshop:pay', _U(shopName))
					else
						TriggerServerEvent('esx_billing:sendBillWithId', PlayerData.identifier, 'society_state', _U(shopName), Config.Price)
					end
				end)

				CurrentAction = shopName
				CurrentActionMsg = _U('prompt_open_menu')	
			end, function(dataSkin, menuSkin)
				menuSkin.close()
				CurrentAction = shopName
				CurrentActionMsg = _U('prompt_open_menu')	
			end, shop.MenuList)
		elseif data.current.value == 'my_outfits' then
			OpenOutfitsMenu(shopName)
		end
	end,
	function(data, menu)
		menu.close()
		CurrentAction = shopName
		CurrentActionMsg = _U('prompt_open_menu')
	end)
end

function OpenOutfitsMenu(shopName, only_outfits)
    local elements = {}

    if not only_outfits then 
        elements = {
            {label = _U('add_outfits'), value = 'add_outfits'},
            {label = _U('rem_outfits'), value = 'rem_outfits'}
        }
    end
	ESX.TriggerServerCallback('esx_ava_clotheshop:getPlayerDressing', function(dressing)
		for i=1, #dressing, 1 do
			table.insert(elements, {label = "- " .. dressing[i], value = "outfit", outfit = i})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), shopName .. "_my_outfits",
		{
			css = 'skin',
			title = _U('my_outfits'),
			align = 'left',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'add_outfits' then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name',
				{
					css =	'vetement',
					title = _U('name_outfit'),
				},
				function(data2, menu2)
					menu2.close()
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_ava_clotheshop:saveOutfit', data2.value, skin)
					end)
					ESX.ShowAdvancedColoredNotification(_U('my_outfits'), '', _U('saved_outfit'), 'CHAR_HUMANDEFAULT', 1, 2)
				end,
				function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'rem_outfits' then
				menu.close()
				local elements2 = {}
				for i=1, #dressing, 1 do
					table.insert(elements2, {label = dressing[i], value = i})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_outfit',
				{
					css	   = 'skin',
					title    = _U('rem_outfits'),
					align    = 'left',
					elements = elements2,
				},
				function(data2, menu2)
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_ava_clotheshop:deleteOutfit', data2.current.value)

					ESX.ShowAdvancedColoredNotification(_U('my_outfits'), '', _U('removed_outfit'), 'CHAR_HUMANDEFAULT', 1, 2)
				end,
				function(data2, menu2)
					menu2.close()
				end)
			elseif data.current.value == 'outfit' then
				TriggerEvent('skinchanger:getSkin', function(skin)
					ESX.TriggerServerCallback('esx_ava_clotheshop:getPlayerOutfit', function(clothes)
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)

						ESX.ShowAdvancedColoredNotification(_U('my_outfits'), '', _U('equiped_outfit'), 'CHAR_HUMANDEFAULT', 1, 2)
					end, data.current.outfit)
				end)
			end
		end,
		function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent("esx_ava_clotheshop:openOutfitsMenu")
AddEventHandler("esx_ava_clotheshop:openOutfitsMenu", function()
    OpenOutfitsMenu("esx_ava_jobs", true)
end)


