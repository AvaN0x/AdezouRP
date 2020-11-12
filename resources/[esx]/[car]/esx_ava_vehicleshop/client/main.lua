-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
---------- FROM esx_vehicleshop -----------
-------------------------------------------

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsInShopMenu            = false
local Categories              = {}
local Vehicles                = {}
local LastVehicles            = {}
local CurrentVehicleData      = nil

ESX                           = nil
local PlayerGroup = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(10000)

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function (categories)
		Categories = categories
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles
	end)

	while PlayerGroup == nil do
		ESX.TriggerServerCallback("esx_avan0x:getUsergroup", function(group) 
			PlayerGroup = group
		end)
		Citizen.Wait(10)
	end

	if PlayerGroup ~= nil and (PlayerGroup == "superadmin" or PlayerGroup == "owner") then
		for k_shop, v_shop in pairs(Config.Shops) do
			table.insert(v_shop.Categories, "hide_" .. v_shop.VehicleType)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function (categories)
	Categories = categories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function (vehicles)
	Vehicles = vehicles
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]

		ESX.Game.DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end


function StartShopRestriction()
	Citizen.CreateThread(function()
		while IsInShopMenu do
			Citizen.Wait(1)

			DisableControlAction(0, 75,  true) -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		end
	end)
end

function OpenShopMenu()
	IsInShopMenu = true

	StartShopRestriction()
	ESX.UI.Menu.CloseAll()

	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, true)
	SetEntityVisible(playerPed, false)
	SetEntityCoords(playerPed, CurrentActionData.Zones.ShopInside.Pos.x, CurrentActionData.Zones.ShopInside.Pos.y, CurrentActionData.Zones.ShopInside.Pos.z)
	local vehiclesByCategory = {}
	local elements           = {}
	local playerData = ESX.GetPlayerData()

	for i=1, #Categories, 1 do
		-- if Categories[i].name ~= "motorcycles" then
			vehiclesByCategory[Categories[i].name] = {}
		-- end
	end

	for i=1, #Vehicles, 1 do
		if IsModelInCdimage(GetHashKey(Vehicles[i].model)) then
			-- if Vehicles[i].category ~= "motorcycles" then
			print(Vehicles[i].model)
				table.insert(vehiclesByCategory[Vehicles[i].category], Vehicles[i])
			-- end
		else
			print(('esx_vehicleshop: vehicle "%s" does not exist'):format(Vehicles[i].model))
		end
	end

	for i=1, #Categories, 1 do
		-- if not string.match(Categories[i].name, '^society_.*$') or -- on récupère les catégories normales
		if has_value(CurrentActionData.Categories, Categories[i].name) then

			local category         = Categories[i]
			local categoryVehicles = vehiclesByCategory[category.name]
			local options          = {}

			for j=1, #categoryVehicles, 1 do
				local vehicle = categoryVehicles[j]

				table.insert(options, ('%s <span style="color:green; float:right;">%s</span>'):format(vehicle.name, _U('generic_shopitem', (vehicle.price))))
			end

			table.insert(elements, {
				name    = category.name,
				label   = category.label,
				value   = 0,
				type    = 'slider',
				max     = #Categories[i],
				options = options
			})
		elseif (playerData.job ~= nil and playerData.job.grade_name == 'boss' and Categories[i].name == "society_"..playerData.job.name) or
			(playerData.job2 ~= nil and playerData.job2.grade_name == 'boss' and Categories[i].name == "society_"..playerData.job2.name) then

			local category         = Categories[i]
			local categoryVehicles = vehiclesByCategory[category.name]
			local options          = {}

			local foreachDiff = 0
			for j=1, #categoryVehicles, 1 do
				local vehicle = categoryVehicles[j - foreachDiff]
				if vehicle.society_category == CurrentActionData.JobOthers or has_value(CurrentActionData.Categories, vehicle.society_category) then
					table.insert(options, ('%s <span style="color:green; float:right;">%s</span>'):format(vehicle.name, _U('generic_shopitem', (vehicle.price))))
				else
					table.remove(vehiclesByCategory[category.name], j - foreachDiff)
					foreachDiff = foreachDiff + 1
				end
			end

			if #options > 0 then
				table.insert(elements, {
					name    = category.name,
					label   = category.label,
					value   = 0,
					type    = 'slider',
					max     = #Categories[i],
					options = options
				})
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
		title    = _U('car_dealer'),
		align    = 'top-left',
		css 	 = "concess",
		elements = elements
	}, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('buy_vehicle_shop', vehicleData.name, ESX.Math.GroupDigits(vehicleData.price)),
			align = 'top-left',
			elements = {
				{label = _U('no'),  value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				local playerData = ESX.GetPlayerData()

				if playerData.job.grade_name == 'boss' and string.match(data.current.name, '^society_.*$') then
					local elements = {}

					if (playerData.job ~= nil and playerData.job.grade_name == 'boss' and data.current.name == "society_"..playerData.job.name) then
						table.insert(elements, {label = _U('society_type'), value = 'society'})
					end
					if (playerData.job2 ~= nil and playerData.job2.grade_name == 'boss' and data.current.name == "society_"..playerData.job2.name) then
						table.insert(elements, {label = _U('society_type2'), value = 'society2'})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm_buy_type', {
						title = _U('purchase_type'),
						align = 'top-left',
						elements = elements
					}, function (data3, menu3)
						ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(hasEnoughMoney)
							if hasEnoughMoney then
								IsInShopMenu = false

								menu3.close()
								menu2.close()
								menu.close()
								DeleteShopInsideVehicles()

								ESX.Game.SpawnVehicle(vehicleData.model, CurrentActionData.Zones.ShopSpawnCarSecond.Pos, CurrentActionData.Zones.ShopSpawnCarSecond.Heading, function (vehicle)
									SetVehicleColours(vehicle, 111, 111)
									TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

									local newPlate     = GeneratePlate()
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									vehicleProps.plate = newPlate
									SetVehicleNumberPlateText(vehicle, newPlate)

										TriggerServerEvent('esx_vehicleshop:setVehicleOwnedSociety', data.current.name, vehicleProps, CurrentActionData.VehicleType)
										ESX.ShowNotification('~r~La LSPD a la liberté de fouiller et de saisir les véhicules sans plaques.')
										TriggerServerEvent('esx_vehiclelock:givekey', 'no', newPlate) -- vehicle lock

									ESX.ShowNotification(_U('vehicle_purchased'))
								end)

								FreezeEntityPosition(playerPed, false)
								SetEntityVisible(playerPed, true)
							else
								ESX.ShowNotification(_U('not_enough_money'))
							end
						end, vehicleData.model)

					end, function (data3, menu3)
						menu3.close()
					end)
				else
					ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function (hasEnoughMoney)
						if hasEnoughMoney then
							ESX.TriggerServerCallback('esx_ava_garage:getParkingInfos', function(parkingInfos)
								if (parkingInfos.owned_count < parkingInfos.parking_slots) then
									IsInShopMenu = false
									menu2.close()
									menu.close()
									DeleteShopInsideVehicles()

									ESX.Game.SpawnVehicle(vehicleData.model, CurrentActionData.Zones.ShopSpawnCar.Pos, CurrentActionData.Zones.ShopSpawnCar.Heading, function (vehicle)
										SetVehicleColours(vehicle, 111, 111)
										TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

										local newPlate     = GeneratePlate()
										local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
										vehicleProps.plate = newPlate
										SetVehicleNumberPlateText(vehicle, newPlate)

											TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, CurrentActionData.VehicleType)
											ESX.ShowNotification('~r~La LSPD a la liberté de fouiller et de saisir les véhicules sans plaques.')
											TriggerServerEvent('esx_ava_keys:giveKey', vehicleProps.plate, 1)

										ESX.ShowNotification(_U('vehicle_purchased'))
									end)

									FreezeEntityPosition(playerPed, false)
									SetEntityVisible(playerPed, true)
								else
									ESX.ShowNotification(_U('no_more_parking_slots'))
								end
							end, CurrentActionData.VehicleType)
						else
							ESX.ShowNotification(_U('not_enough_money'))
						end
					end, vehicleData.model)
				end
			end
		end, function (data2, menu2)
			menu2.close()
		end)
	end, function (data, menu)
		menu.close()
		DeleteShopInsideVehicles()
		local playerPed = PlayerPedId()

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, CurrentActionData.Zones.ShopMenu.Pos.x, CurrentActionData.Zones.ShopMenu.Pos.y, CurrentActionData.Zones.ShopMenu.Pos.z)

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}

		IsInShopMenu = false
	end, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()
		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, CurrentActionData.Zones.ShopInside.Pos, CurrentActionData.Zones.ShopInside.Heading, function (vehicle)
			table.insert(LastVehicles, vehicle)
			SetVehicleColours(vehicle, 111, 111)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
			SetModelAsNoLongerNeeded(vehicleData.model)
		end)
	end)
	DeleteShopInsideVehicles()
end

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) then
		RequestModel(modelHash)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(_U('shop_awaiting_model'))
		EndTextCommandBusyString(4)

		while not HasModelLoaded(modelHash) do
			Citizen.Wait(1)
			DisableAllControlActions(0)
		end

		RemoveLoadingPrompt()
	end
end



RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function (job2)
	ESX.PlayerData.job2 = job2
end)

AddEventHandler('esx_vehicleshop:hasEnteredMarker', function (zone, data)
	if zone == 'ShopMenu' then
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = data
	elseif zone == 'ResellVehicle' then

		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then

			local vehicle     = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for i=1, #Vehicles, 1 do
					if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
						vehicleData = Vehicles[i]
						break
					end
				end

				resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
				model = GetEntityModel(vehicle)
				plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

				CurrentAction     = 'resell_vehicle'
				CurrentActionMsg  = _U('sell_menu', vehicleData.name, ESX.Math.GroupDigits(resellPrice))

				CurrentActionData = {
					vehicle = vehicle,
					label = vehicleData.name,
					price = resellPrice,
					model = model,
					plate = plate,
					category = vehicleData.category,
					shopdata = data
				}
			end
		end
	end
end)

AddEventHandler('esx_vehicleshop:hasExitedMarker', function (zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()
			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			SetEntityVisible(playerPed, true)
			SetEntityCoords(playerPed, CurrentActionData.Zones.ShopMenu.Pos.x, CurrentActionData.Zones.ShopMenu.Pos.y, CurrentActionData.Zones.ShopMenu.Pos.z)
		end
	end
end)


-- Create Blips
Citizen.CreateThread(function()
	for k_shop, v_shop in pairs(Config.Shops) do
		local blip = AddBlipForCoord(v_shop.Zones.ShopMenu.Pos.x, v_shop.Zones.ShopMenu.Pos.y, v_shop.Zones.ShopMenu.Pos.z)

		SetBlipSprite(blip, v_shop.Blip.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, v_shop.Blip.Color)

		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v_shop.Name)
		EndTextCommandSetBlipName(blip)

		if v_shop.Zones.ResellVehicle.Blip then
			local blip2 = AddBlipForCoord(v_shop.Zones.ResellVehicle.Pos.x, v_shop.Zones.ResellVehicle.Pos.y, v_shop.Zones.ResellVehicle.Pos.z)

			SetBlipSprite(blip2, v_shop.Blip.Sprite)
			SetBlipDisplay(blip2, 4)
			SetBlipScale(blip2, 0.6)
			SetBlipColour(blip2, 79)

			SetBlipAsShortRange(blip2, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('vehicle_sell_label'))
			EndTextCommandSetBlipName(blip2)
		end
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local found = false

		for k_shop, v_shop in pairs(Config.Shops) do
			for k, v in pairs(v_shop.Zones) do
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
					found = true
				end
			end
		end
		
		if not found then
			Citizen.Wait(1000)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone, currentZoneData = nil, nil

		for k_shop, v_shop in pairs(Config.Shops) do
			for k, v in pairs(v_shop.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
					currentZoneData = v_shop
					break
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_vehicleshop:hasEnteredMarker', currentZone, currentZoneData)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehicleshop:hasExitedMarker', LastZone)
		end

		if not isInMarker then
			Citizen.Wait(200)
		end
	end
end)


-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction == nil then
			Citizen.Wait(500)
		else
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'shop_menu' then
					ESX.ShowNotification('~r~La LSPD a la liberté de fouiller et de saisir les véhicules sans plaques.')
					OpenShopMenu()
				elseif CurrentAction == 'resell_vehicle' then
					if CurrentActionData.category == CurrentActionData.shopdata.JobOthers or has_value(CurrentActionData.shopdata.Categories, CurrentActionData.category) then
						ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold)
							if vehicleSold then
								ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
								ESX.ShowNotification(_U('vehicle_sold_for', CurrentActionData.label, ESX.Math.GroupDigits(CurrentActionData.price)))
							else
								ESX.ShowNotification(_U('not_yours'))
							end
						end, CurrentActionData.plate, CurrentActionData.model)
					else
						ESX.ShowNotification(_U('cant_sell_here'))
					end
				end

				CurrentAction = nil
			end
		end
	end
end)

