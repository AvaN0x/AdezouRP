-- local Keys = {
-- 	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
-- 	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
-- 	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
-- 	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
-- 	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
-- 	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
-- 	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
-- 	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
-- 	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
-- }

local CurrentAction = nil
local GUI					   = {}
GUI.Time						= 0
local HasAlreadyEnteredMarker   = false
local LastZone				  = nil
local CurrentActionMsg		  = ''
local CurrentActionData		 = {}
local times 					= 0 -- pound timer

local this_Garage = {}
local VehiclesList = {}
local PlayerData = nil

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_ava_garage:getVehiclesPrices', function(vehicles)
		VehiclesList = vehicles
	end)

	setBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	ESX.TriggerServerCallback('esx_ava_garage:getVehiclesPrices', function(vehicles)
		VehiclesList = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)


function setBlips()
	for k, v in pairs(Config.Garages) do
		if v.Name ~= "hide" then
			local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
			SetBlipSprite (blip, v.Blip.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.7)
			SetBlipColour (blip, v.Blip.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.Name)
			EndTextCommandSetBlipName(blip)
		end
	end
	for k, v in pairs(Config.Pound) do
		local blip = AddBlipForCoord(v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z)
		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, v.Blip.Color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Fourriere")
		EndTextCommandSetBlipName(blip)
	end
end

function OpenMenuGarage(PointType, target)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	
	if PointType == 'open_garage_menu' then
		table.insert(elements,{label = "Liste des véhicules", value = 'list_vehicles'})
		table.insert(elements,{label = "Rentrer vehicules", value = 'stock_vehicle'})
	elseif PointType == 'pound' then
		table.insert(elements,{label = "Retour vehicule personnel", value = 'return_vehicle'})
		if PlayerData.job ~= nil and PlayerData.job.name ~= "unemployed" then
			table.insert(elements,{label = "Retour vehicule "..PlayerData.job.label, value = 'return_vehicle', job = "society_"..PlayerData.job.name})
		end
		if PlayerData.job2 ~= nil and PlayerData.job2.name ~= "unemployed2" then
			table.insert(elements,{label = "Retour vehicule "..PlayerData.job2.label, value = 'return_vehicle', job = "society_"..PlayerData.job2.name})
		end
	end

	local title
	if target then
		title = 'Garage entreprise'
	else
		title = 'Garage'
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			css	  = 'garage',
			title	= title,
			align	= 'right',
			elements = elements,
		},
		function(data, menu)
			menu.close()
			if data.current.value == 'list_vehicles' then
				ListVehiclesMenu(this_Garage.Type, target)
			elseif data.current.value == 'stock_vehicle' then
				StockVehicleMenu(target)
				if target == nil then
					CurrentAction = 'open_garage_menu'
				end
			elseif data.current.value == 'return_vehicle' then
				ReturnVehicleMenu(data.current.job)
			end
		end,
		function(data, menu)
			menu.close()
			if target == nil then
				CurrentAction = 'open_garage_menu'
			end
		end
	)
end


-- Afficher les listes des vehicules
function ListVehiclesMenu(type, target)
	local elements = {}
	
	ESX.TriggerServerCallback('esx_ava_garage:getVehicles', function(vehicles)
		
		local count = 0

		for _,v in pairs(vehicles) do

			local hashVehicule = v.vehicle.model
			local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
			local labelvehicle
			if v.location == 'any' or v.location == this_Garage.Identifier then
				labelvehicle = vehicleName..' - '.. v.vehicle.plate
			elseif v.location == "garage_POUND" then
				labelvehicle = "<span style=\"color:red;\">"..vehicleName..' - '.. v.vehicle.plate ..'</span>'
			else
				labelvehicle = "<span style=\"color:darkgray;\">"..vehicleName..' - '.. v.vehicle.plate ..'</span>'
			end
			table.insert(elements, {label = labelvehicle, detail = "Essence : " .. math.floor(v.fuel) .. " %", value = v})
			count = count + 1
		end

		-- ESX.TriggerServerCallback('esx_ava_garage:getParkingSlots', function(parking_slots_count)
		ESX.TriggerServerCallback('esx_ava_garage:getParkingInfos', function(data)
			local parking_slots_count = data.parking_slots
			print(data.parking_slots..'/'..data.owned_count..'/'..data.parked_count)
			local title

			if target then
				title = 'Garage entreprise'
			else
				title = 'Garage ('..count..'/'..parking_slots_count..')'
			end

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'spawn_vehicle',
			{
				css	  = 'garage',
				title	= title,
				align	= 'right',
				elements = elements,
			},
			function(data, menu)
				if data.current.value.location == 'any' or data.current.value.location == this_Garage.Identifier then
					menu.close()

					SpawnVehicle(data.current.value.vehicle, data.current.value.fuel, target)
					TriggerServerEvent('esx_ava_garage:modifystate', data.current.value.vehicle, "garage_POUND", target, true)
				elseif data.current.value.location == "garage_POUND" then
					TriggerEvent('esx:showNotification', 'Ce véhicule est à la fourriere')
				else
					TriggerEvent('esx:showNotification', 'Ce véhicule est dans un autre garage')
				end
			end,
			function(data, menu)
				menu.close()
				-- CurrentAction = 'open_garage_menu'
				OpenMenuGarage('open_garage_menu', target)
			end)
		end, this_Garage.Type)

	end, type, target)
end


function StockVehicleMenu(target)
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then

		local playerPed = GetPlayerPed(-1)
		local coords	= GetEntityCoords(playerPed)
		local vehicle   = GetVehiclePedIsIn(playerPed,false)
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local current 		= GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth  = GetVehicleEngineHealth(current)
		TriggerEvent('esx_legacyfuel:GetFuel', vehicle, function(fuel)
			local vfuel = tonumber(string.format("%." .. 3 .. "f", fuel))
			ESX.TriggerServerCallback('esx_ava_garage:stockv', function(valid)

				if (valid) then
                    if (GetPedInVehicleSeat(vehicle, -1) == playerPed) then
                        ranger(vehicle, vehicleProps, this_Garage.Identifier, target)
                    else
                        TriggerEvent('esx:showNotification', 'Vous devez être le conducteur pour ranger un véhicule.')
                    end
				else
					TriggerEvent('esx:showNotification', 'Vous ne pouvez pas stocker ce véhicule ici')
				end
			end, vehicleProps, fuel, this_Garage.Type, this_Garage.Identifier, target)
		end)
	else
		TriggerEvent('esx:showNotification', 'Il n\'y a pas de vehicule à rentrer')
	end
end



function ranger(vehicle, vehicleProps, gIdentifier, target)
	DeleteEntity(vehicle)
	TriggerServerEvent('esx_ava_garage:modifystate', vehicleProps, gIdentifier, target, true)
	TriggerEvent('esx:showNotification', 'Ce véhicule est maintenant dans ce garage')
end


function SpawnVehicle(vehicle, fuel, target)
	ESX.Game.SpawnVehicle(vehicle.model,{
		x=this_Garage.SpawnPoint.Pos.x ,
		y=this_Garage.SpawnPoint.Pos.y,
		z=this_Garage.SpawnPoint.Pos.z + 1
		},this_Garage.SpawnPoint.Heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetEntityAsMissionEntity(callback_vehicle)
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		TriggerEvent('esx_legacyfuel:SetFuel', callback_vehicle, fuel)
		local vhealth = vehicle.health
		if (vhealth <= 950) then
			SetVehicleDamage(callback_vehicle, 0.33, 0.33, 0.33, 200.0, 100.0, true)
			SetVehicleDamage(callback_vehicle, -0.33, 0.33, 0.33, 200.0, 100.0, true)
			SetVehicleDamage(callback_vehicle, 0.33, -0.33, 0.33, 200.0, 100.0, true)
			SetVehicleDamage(callback_vehicle, -0.33, -0.33, 0.33, 200.0, 100.0, true)
		end

		local plate = GetVehicleNumberPlateText(callback_vehicle)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
	end)
	if target then
		TriggerServerEvent('esx_ava_keys:giveKey', vehicle.plate, 2)
	end

	-- TriggerServerEvent('esx_ava_garage:modifystate', vehicle, "garage_POUND")

end

function SpawnPoundedVehicle(vehicle, target)

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnMunicipalPoundPoint.Pos.x ,
		y = this_Garage.SpawnMunicipalPoundPoint.Pos.y,
		z = this_Garage.SpawnMunicipalPoundPoint.Pos.z + 1
		}, this_Garage.SpawnMunicipalPoundPoint.Heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetEntityAsMissionEntity(callback_vehicle)
		TriggerEvent('esx_legacyfuel:SetFuel', callback_vehicle, 20.0)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
	end)
	if target then
		TriggerServerEvent('esx_ava_keys:giveKey', vehicle.plate, 2)
	end
	TriggerServerEvent('esx_ava_garage:modifystate', vehicle, "no_garages", target)

	Citizen.Wait(10000)
	TriggerServerEvent('esx_ava_garage:modifystate', vehicle, "garage_POUND", target)

end



function ReturnVehicleMenu(target, isGov)
	ESX.TriggerServerCallback('esx_ava_garage:getOutVehicles', function(vehicles)
		local elements = {}

		for _,v in pairs(vehicles) do

			local hashVehicule = v.vehicle.model
			local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
			local labelvehicle
			local exitPrice = Config.MinPrice

			for i=1, #VehiclesList, 1 do
				if v.vehicle.model == GetHashKey(VehiclesList[i].model) then
					exitPrice = math.ceil(VehiclesList[i].price * Config.PoundPriceMultiplier)
					if exitPrice < Config.MinPrice then
						exitPrice = Config.MinPrice
					elseif exitPrice > Config.MaxPrice then
						exitPrice = Config.MaxPrice
					end
					break
				end
			end
			labelvehicle = vehicleName..' - '.. v.vehicle.plate ..': $'..exitPrice
			table.insert(elements, {label = labelvehicle , value = v.vehicle, price = exitPrice, type = v.type})
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_vehicle',
		{
			css	  = 'four',
			title	= 'Fourrière',
			align	= 'right',
			elements = elements,
		},
		function(data, menu)
			menu.close()
			ESX.TriggerServerCallback('esx_ava_garage:checkMoney', function(hasEnoughMoney)
				if hasEnoughMoney or (not hasEnoughMoney and isGov) then
					if times == 0 then
						if isGov then
							TriggerServerEvent('esx_ava_garage:payByState', target, data.current.price)
						else
							TriggerServerEvent('esx_ava_garage:pay', data.current.price)
						end
						if data.current.type == "car" and not isGov then
							SpawnPoundedVehicle(data.current.value, target)
							times=times+1
							Citizen.Wait(60000)
							times=0
						else
							ESX.ShowNotification('Le véhicule est sorti de la fourrière')
							TriggerServerEvent('esx_ava_garage:modifystate', data.current.value, this_Garage.Identifier, target)
						end
					elseif times > 0 then
						ESX.ShowNotification('Veuillez patienter une minute')
						Citizen.Wait(60000)
							times=0
					end
				else
					ESX.ShowNotification('Vous n\'avez pas assez d\'argent')
				end
			end, data.current.price)
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_menu'
		end
		)
	end, target)
end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local found = false

		for k,v in pairs(Config.Garages) do
			if (GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) 
				and (PlayerData and (v.Job == nil or (PlayerData.job ~= nil and PlayerData.job.name ==  v.Job) or (PlayerData.job2 ~= nil and PlayerData.job2.name ==  v.Job))) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)	
				found = true
			end
		end
		for k,v in pairs(Config.Pound) do
			if(GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.MunicipalPoundPoint.Marker, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.MunicipalPoundPoint.Size.x, v.MunicipalPoundPoint.Size.y, v.MunicipalPoundPoint.Size.z, v.MunicipalPoundPoint.Color.r, v.MunicipalPoundPoint.Color.g, v.MunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)	
				found = true
			end
		end

		if not found then
			Citizen.Wait(1000)
		end
	end
end)

AddEventHandler('esx_ava_garage:hasEnteredMarker', function(zone)
	if zone == 'open_garage_menu' then
		CurrentAction	 = 'open_garage_menu'
		CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour ouvrir le garage"
		CurrentActionData = {}
	elseif zone == 'open_pound_menu' then
		CurrentAction	 = 'pound_action_menu'
		CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour acceder a la fourriere"
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_ava_garage:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		local coords	  = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false

		for _,v in pairs(Config.Garages) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < (v.Distance or v.Size.x)) then
				if v.Job == nil or (PlayerData and ((PlayerData.job ~= nil and PlayerData.job.name ==  v.Job) or (PlayerData.job2 ~= nil and PlayerData.job2.name ==  v.Job))) then
					isInMarker  = true
					this_Garage = v
					currentZone = 'open_garage_menu'
				end
			end
		end
		for _,v in pairs(Config.Pound) do
			if(GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < v.MunicipalPoundPoint.Size.x) then
				isInMarker  = true
				this_Garage = v
				currentZone = 'open_pound_menu'
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone				= currentZone
			TriggerEvent('esx_ava_garage:hasEnteredMarker', currentZone)
		end
		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_ava_garage:hasExitedMarker', LastZone)
		end
		if not isInMarker then
			Citizen.Wait(200)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 150 then
				if CurrentAction == 'open_garage_menu' then
					OpenMenuGarage('open_garage_menu')
				elseif CurrentAction == 'pound_action_menu' then
					OpenMenuGarage('pound')
				end
				CurrentAction = nil
				GUI.Time	  = GetGameTimer()
			end
		end
	end
end)


-- Societygarage
RegisterNetEvent("esx_ava_garage:OpenSocietyVehiclesMenu")
AddEventHandler("esx_ava_garage:OpenSocietyVehiclesMenu", function(societyName, garage, type)
	this_Garage = garage
	this_Garage.Identifier = "garage_SOCIETY"
	if not this_Garage.Type then
		this_Garage.Type = 'car'
	end
	OpenMenuGarage('open_garage_menu', tostring(societyName))
end)

RegisterNetEvent("esx_ava_garage:ReturnVehiclesMenuByState")
AddEventHandler("esx_ava_garage:ReturnVehiclesMenuByState", function(societyName)
	ReturnVehicleMenu(societyName, true)
end)
