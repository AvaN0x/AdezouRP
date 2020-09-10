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
	SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)
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
		if not string.match(Categories[i].name, '^society_.*$') or -- on récupère les catégories normales
			(playerData.job ~= nil and playerData.job.grade_name == 'boss' and Categories[i].name == "society_"..playerData.job.name) or
			(playerData.job2 ~= nil and playerData.job2.grade_name == 'boss' and Categories[i].name == "society_"..playerData.job2.name) then

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
					local elements = {
					}
					
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

								ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.ShopSpawnCarSecond.Pos, Config.Zones.ShopSpawnCarSecond.Heading, function (vehicle)
									TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

									local newPlate     = GeneratePlate()
									local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
									local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
									vehicleProps.plate = newPlate
									SetVehicleNumberPlateText(vehicle, newPlate)
									SetVehicleColours(vehicle, 111, 111)
									
										TriggerServerEvent('esx_vehicleshop:setVehicleOwnedSociety', data.current.name, vehicleProps)
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

									ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.ShopSpawnCar.Pos, Config.Zones.ShopSpawnCar.Heading, function (vehicle)
										TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

										local newPlate     = GeneratePlate()
										local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
										local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
										vehicleProps.plate = newPlate
										SetVehicleNumberPlateText(vehicle, newPlate)
										SetVehicleColours(vehicle, 111, 111)

											TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps)
											ESX.ShowNotification('~r~La LSPD a la liberté de fouiller et de saisir les véhicules sans plaques.')
											TriggerServerEvent('esx_vehiclelock:registerkey', vehicleProps.plate, nil)

										ESX.ShowNotification(_U('vehicle_purchased'))
									end)

									FreezeEntityPosition(playerPed, false)
									SetEntityVisible(playerPed, true)
								else
									ESX.ShowNotification(_U('no_more_parking_slots'))
								end
							end)
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

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		SetEntityVisible(playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.ShopMenu.Pos.x, Config.Zones.ShopMenu.Pos.y, Config.Zones.ShopMenu.Pos.z)

		IsInShopMenu = false
	end, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()
		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function (vehicle)
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

AddEventHandler('esx_vehicleshop:hasEnteredMarker', function (zone)
	if zone == 'ShopMenu' then
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {}
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
					plate = plate
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
			SetEntityCoords(playerPed, Config.Zones.ShopMenu.Pos.x, Config.Zones.ShopMenu.Pos.y, Config.Zones.ShopMenu.Pos.z)
		end
	end
end)


-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.ShopMenu.Pos.x, Config.Zones.ShopMenu.Pos.y, Config.Zones.ShopMenu.Pos.z)

	SetBlipSprite (blip, 326)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('car_dealer'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_vehicleshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehicleshop:hasExitedMarker', LastZone)
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
					if Config.LicenseEnable then
						OpenShopMenu()
					else
						OpenShopMenu()
					end
				elseif CurrentAction == 'resell_vehicle' then
					ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold)
						if vehicleSold then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
							ESX.ShowNotification(_U('vehicle_sold_for', CurrentActionData.label, ESX.Math.GroupDigits(CurrentActionData.price)))
						else
							ESX.ShowNotification(_U('not_yours'))
						end
					end, CurrentActionData.plate, CurrentActionData.model)
				end

				CurrentAction = nil
			end
		end
	end
end)

