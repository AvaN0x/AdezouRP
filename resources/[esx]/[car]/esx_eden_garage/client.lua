-- Local
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

local CurrentAction = nil
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local times 			= 0

local this_Garage = {}
local VehiclesList = {}

-- Fin Local

-- Init ESX
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
-- Fin init ESX

--- Gestion Des blips
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    --PlayerData = xPlayer
    --TriggerServerEvent('esx_jobs:giveBackCautionInCaseOfDrop')
	refreshBlips()
	ESX.TriggerServerCallback('eden_garage:getVehiclesPrices', function(vehicles)
		VehiclesList = vehicles
	end)
end)

function refreshBlips()
	local zones = {}
	local blipInfo = {}	
	local PlayerData = ESX.GetPlayerData()
	for zoneKey,zoneValues in pairs(Config.Garages) do
		if zoneValues.Name ~= "hide" then
			local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
			SetBlipSprite (blip, Config.BlipInfos.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.7)
			SetBlipColour (blip, Config.BlipInfos.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(zoneValues.Name)
			EndTextCommandSetBlipName(blip)
		end
	end
	for zoneKey,zoneValues in pairs(Config.Pound) do
		local blip = AddBlipForCoord(zoneValues.MunicipalPoundPoint.Pos.x, zoneValues.MunicipalPoundPoint.Pos.y, zoneValues.MunicipalPoundPoint.Pos.z)
		SetBlipSprite (blip, Config.BlipPound.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, Config.BlipPound.Color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Fourriere")
		EndTextCommandSetBlipName(blip)
	end
end
-- Fin Gestion des Blips

-- gros cercle dégueu au parking central
-- local blips = {

-- 	{title="", colour=0, id=0, x = 229.53, y = -793.18, z = 29.67}
-- 	}
-- 	Citizen.CreateThread(function()
  
-- 		  Citizen.Wait(0)
  
--   local bool = true
	
-- 	if bool then
		  
-- 		  for k,v in pairs(blips) do
			 
  
-- 				 zoneblip = AddBlipForRadius(v.x,v.y,v.z, 400.0)
-- 							SetBlipSprite(zoneblip,1)
-- 							SetBlipColour(zoneblip,50)
-- 							SetBlipAlpha(zoneblip,75)
						   
-- 		  end
		   
	  
-- 		   for _, info in pairs(blips) do
		  
-- 			   info.blip = AddBlipForCoord(info.x, info.y, info.z)
-- 						   SetBlipSprite(info.blip, info.id)
-- 						   SetBlipDisplay(info.blip, 4)
-- 						   SetBlipColour(info.blip, info.colour)
-- 						   SetBlipAsShortRange(info.blip, true)
-- 						   BeginTextCommandSetBlipName("STRING")
-- 						   AddTextComponentString(info.title)
-- 						   EndTextCommandSetBlipName(info.blip)
-- 		   end
		 
-- 		 bool = false
	 
-- 	 end
--   end)

--Fonction Menu

function OpenMenuGarage(PointType)

	ESX.UI.Menu.CloseAll()

	local elements = {}

	
	if PointType == 'spawn' then
		table.insert(elements,{label = "Liste des véhicules", value = 'list_vehicles'})
	elseif PointType == 'delete' then
		table.insert(elements,{label = "Rentrer vehicules", value = 'stock_vehicle'})
	elseif PointType == 'pound' then
		table.insert(elements,{label = "Retour vehicule personnel", value = 'return_vehicle'})
		local xPlayer = ESX.GetPlayerData()
		if xPlayer.job ~= nil then
			table.insert(elements,{label = "Retour vehicule "..xPlayer.job.label, value = 'return_society_vehicle', job = xPlayer.job.name})
		end
		if xPlayer.job2 ~= nil then
			table.insert(elements,{label = "Retour vehicule "..xPlayer.job2.label, value = 'return_society_vehicle', job = xPlayer.job2.name})
		end

	-- elseif PointType == 'society_spawn' then
	-- 	table.insert(elements,{label = "Liste des véhicules", value = 'list_society_vehicles'})
	-- elseif PointType == 'society_delete' then
	-- 	table.insert(elements,{label = "Rentrer vehicules", value = 'stock_society_vehicle'})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			css      = 'garage',
			title    = 'Garage',
			align    = 'right',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'list_vehicles') then
				ListVehiclesMenu()
			elseif (data.current.value == 'stock_vehicle') then
				StockVehicleMenu()
			elseif (data.current.value == 'return_vehicle') then
				ReturnVehicleMenu()
			elseif (data.current.value == 'return_society_vehicle') then
				ReturnSocietyVehicleMenu("society_"..data.current.job)
			-- elseif (data.current.value == 'list_society_vehicles') then
			-- 	ListSocietyVehiclesMenu(tostring(this_Garage.Name))
			-- elseif (data.current.value == 'stock_society_vehicle') then
			-- 	StockSocietyVehicleMenu(tostring(this_Garage.Name))
			end

			-- local playerPed = GetPlayerPed(-1)
			-- SpawnVehicle(data.current.value)
			-- TriggerServerEvent('eden_garage:modifystate', data.current.value, false)


		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end


-- Afficher les listes des vehicules
function ListVehiclesMenu()
	local elements = {}
	
	ESX.TriggerServerCallback('eden_garage:getVehicles', function(vehicles)
		
		local count = 0

		for _,v in pairs(vehicles) do

			local hashVehicule = v.vehicle.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle

    		if(v.state)then
    			labelvehicle = vehicleName..' - '.. v.vehicle.plate ..': Garage'
    		else
    			labelvehicle = vehicleName..' - '.. v.vehicle.plate ..': Fourriere'
    		end	
			table.insert(elements, {label =labelvehicle , value = v})
			count = count + 1
		end

		-- ESX.TriggerServerCallback('eden_garage:getParkingSlots', function(parking_slots_count)
		ESX.TriggerServerCallback('eden_garage:getParkingInfos', function(data)
			local parking_slots_count = data.parking_slots
			print(data.parking_slots..'/'..data.owned_count..'/'..data.parked_count)

			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'spawn_vehicle',
			{
				css      = 'garage',
				title    = 'Garage ('..count..'/'..parking_slots_count..')',
				align    = 'right',
				elements = elements,
			},
			function(data, menu)
				if(data.current.value.state)then
					menu.close()
					SpawnVehicle(data.current.value.vehicle, data.current.value.fuel)
					TriggerServerEvent('eden_garage:modifystate', data.current.value.vehicle, false)
				else
					TriggerEvent('esx:showNotification', 'Votre véhicule est à la fourriere')
				end
			end,
			function(data, menu)
				menu.close()
				--CurrentAction = 'open_garage_action'
			end)	
		end)

	end)
end

function ListSocietyVehiclesMenu(societyName)
	local elements = {}
	ESX.TriggerServerCallback('eden_garage:getSocietyVehicles', function(vehicles)

		for _,v in pairs(vehicles) do

			local hashVehicule = v.vehicle.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle

    		if(v.state)then
    			labelvehicle = vehicleName..' - '.. v.vehicle.plate ..': Garage'
    		else
    			labelvehicle = vehicleName..' - '.. v.vehicle.plate ..': Fourriere'
    		end	
			table.insert(elements, {label =labelvehicle , value = v})
			
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_society_vehicle',
		{
			css      = 'garage',
			title    = 'Garage entreprise',
			align    = 'right',
			elements = elements,
		},
		function(data, menu)
			if(data.current.value.state)then
				menu.close()
				SpawnVehicle(data.current.value.vehicle, data.current.value.fuel)
				TriggerServerEvent('eden_garage:modifySocietystate', data.current.value.vehicle, false, tostring(societyName))
				TriggerServerEvent('esx_vehiclelock:givekey', 'no', data.current.value.vehicle.plate)
			else
				TriggerEvent('esx:showNotification', 'Votre véhicule est à la fourriere')
			end
		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end
	)	
	end, tostring(societyName))
end
-- Fin Afficher les listes des vehicules


function reparation(prix,vehicle,vehicleProps)
	
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "Rentrer le vehicule cassés", value = 'yes'},
		{label = "Aller voir un mécanicien", value = 'no'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'delete_menu',
		{
			css      = 'garage',
			title    = 'vehicule endomagé',
			align    = 'right',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				-- TriggerServerEvent('eden_garage:payhealth1', prix)
				ranger(vehicle,vehicleProps)
			end
			if(data.current.value == 'no') then
				ESX.ShowNotification('Passez voir le mécano')
			end

		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end

function reparationSociety(prix,vehicle,vehicleProps, societyName)
	
	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = "Rentrer le vehicule cassés", value = 'yes'},
		{label = "Aller voir un mécanicien", value = 'no'},
	}
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'delete_menu',
		{
			css      = 'garage',
			title    = 'vehicule endomagé',
			align    = 'right',
			elements = elements,
		},
		function(data, menu)

			menu.close()
			if(data.current.value == 'yes') then
				-- TriggerServerEvent('eden_garage:payhealth1', prix)
				rangerSociety(vehicle,vehicleProps, societyName)
			end
			if(data.current.value == 'no') then
				ESX.ShowNotification('Passez voir le mécano')
			end

		end,
		function(data, menu)
			menu.close()
			
		end
	)	
end


function ranger(vehicle,vehicleProps)
	-- ESX.Game.DeleteVehicle(vehicle)
	DeleteEntity(vehicle)
	TriggerServerEvent('eden_garage:modifystate', vehicleProps, true)
	TriggerEvent('esx:showNotification', 'Votre véhicule est dans le garage')
end

function rangerSociety(vehicle, vehicleProps, societyName)
	-- ESX.Game.DeleteVehicle(vehicle)
	DeleteEntity(vehicle)
	TriggerServerEvent('eden_garage:modifySocietystate', vehicleProps, true, societyName)
	TriggerEvent('esx:showNotification', 'Votre véhicule est dans le garage')
end

-- Fonction qui permet de rentrer un vehicule
function StockVehicleMenu()
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then

		local playerPed = GetPlayerPed(-1)
    	local coords    = GetEntityCoords(playerPed)
    	local vehicle =GetVehiclePedIsIn(playerPed,false)     
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth  = GetVehicleEngineHealth(current)
		TriggerEvent('esx_legacyfuel:GetFuel', vehicle, function(fuel)
			local vfuel = tonumber(string.format("%." .. 3 .. "f", fuel))
			ESX.TriggerServerCallback('eden_garage:stockv',function(valid)

				if (valid) then
					TriggerServerEvent('eden_garage:debug', "plaque vehicule rentree au garage: "  .. vehicleProps.plate)
					TriggerServerEvent('eden_garage:logging',"santee vehicule rentree au garage: " .. engineHealth)
					if engineHealth < 1000 then
						local fraisRep= math.floor((1000 - engineHealth)*100)			      
						reparation(fraisRep,vehicle,vehicleProps)
					else
						ranger(vehicle,vehicleProps)
					end	
				else
					TriggerEvent('esx:showNotification', 'Vous ne pouvez pas stocker ce véhicule')
				end
			end, vehicleProps, fuel)
		end)
	else
		TriggerEvent('esx:showNotification', 'Il n\'y a pas de vehicule à rentrer')
	end
end

function StockSocietyVehicleMenu(societyName)
	local playerPed  = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed,  false) then

		local playerPed = GetPlayerPed(-1)
    	local coords    = GetEntityCoords(playerPed)
    	local vehicle =GetVehiclePedIsIn(playerPed,false)     
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
		local current 	    = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth  = GetVehicleEngineHealth(current)
		TriggerEvent('esx_legacyfuel:GetFuel', vehicle, function(fuel)
			local vfuel = tonumber(string.format("%." .. 3 .. "f", fuel))
			ESX.TriggerServerCallback('eden_garage:stockSocietyv',function(valid)

				if (valid) then
					TriggerServerEvent('eden_garage:debug', "plaque vehicule entreprise rentree au garage: "  .. vehicleProps.plate)
					TriggerServerEvent('eden_garage:logging',"santee vehicule entreprise rentree au garage: " .. engineHealth)
					if engineHealth < 1000 then
						local fraisRep= math.floor((1000 - engineHealth)*100)			      
						reparationSociety(fraisRep,vehicle,vehicleProps, societyName)
					else
						rangerSociety(vehicle,vehicleProps, societyName)
					end	
				else
					TriggerEvent('esx:showNotification', 'Vous ne pouvez pas stocker ce véhicule')
				end
			end, vehicleProps, societyName, vfuel)
		end)

	else
		TriggerEvent('esx:showNotification', 'Il n\'y a pas de vehicule à rentrer')
	end

end

-- Fin fonction qui permet de rentrer un vehicule 
--Fin fonction Menu


--Fonction pour spawn vehicule
function SpawnVehicle(vehicle, fuel)

	ESX.Game.SpawnVehicle(vehicle.model,{
		x=this_Garage.SpawnPoint.Pos.x ,
		y=this_Garage.SpawnPoint.Pos.y,
		z=this_Garage.SpawnPoint.Pos.z + 1											
		},this_Garage.SpawnPoint.Heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		TriggerEvent('esx_legacyfuel:SetFuel', callback_vehicle, fuel)
		local vhealth = vehicle.health
		-- SetVehicleEngineHealth(callback_vehicle, tonumber(vhealth)) -- fait de la merde
		-- SetVehicleBodyHealth(callback_vehicle, tonumber(vhealth)) -- fait de la merde
		if (vhealth <= 970) then
			-- SetVehicleDamage(callback_vehicle, 0.0, 0.0, 0.33, 200.0, 100.0, true)
			SetVehicleDamage(callback_vehicle, 0.33, 0.33, 0.33, 200.0, 100.0, true)
			SetVehicleDamage(callback_vehicle, -0.33, 0.33, 0.33, 200.0, 100.0, true)
			SetVehicleDamage(callback_vehicle, 0.33, -0.33, 0.33, 200.0, 100.0, true)
			SetVehicleDamage(callback_vehicle, -0.33, -0.33, 0.33, 200.0, 100.0, true)
		end

		local plate = GetVehicleNumberPlateText(callback_vehicle)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
	end)
	
	-- TriggerServerEvent('eden_garage:modifystate', vehicle, false)

end
--Fin fonction pour spawn vehicule

--Fonction pour spawn vehicule fourriere
function SpawnPoundedVehicle(vehicle)

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnMunicipalPoundPoint.Pos.x ,
		y = this_Garage.SpawnMunicipalPoundPoint.Pos.y,
		z = this_Garage.SpawnMunicipalPoundPoint.Pos.z + 1											
		},this_Garage.SpawnMunicipalPoundPoint.Heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TriggerEvent('esx_legacyfuel:SetFuel', callback_vehicle, 20.0)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
	end)
	TriggerServerEvent('eden_garage:modifystate', vehicle, true)

	Citizen.Wait(10000)
		TriggerServerEvent('eden_garage:modifystate', vehicle, false)

	-- end)

end

function SpawnPoundedSocietyVehicle(vehicle, societyName)

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnMunicipalPoundPoint.Pos.x ,
		y = this_Garage.SpawnMunicipalPoundPoint.Pos.y,
		z = this_Garage.SpawnMunicipalPoundPoint.Pos.z + 1											
		},this_Garage.SpawnMunicipalPoundPoint.Heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		local plate = GetVehicleNumberPlateText(callback_vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TriggerEvent('esx_legacyfuel:SetFuel', callback_vehicle, 20.0)
		TriggerServerEvent("ls:mainCheck", plate, callback_vehicle, true)
		end)
	TriggerServerEvent('eden_garage:modifySocietystate', vehicle, true, societyName)

	Citizen.Wait(10000)
		TriggerServerEvent('eden_garage:modifySocietystate', vehicle, false, societyName)

end

--Fin fonction pour spawn vehicule fourriere
--Action das les markers
AddEventHandler('eden_garage:hasEnteredMarker', function(zone)

	if zone == 'spawn' then
		CurrentAction     = 'spawn'
		CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour sortir un vehicule"
		CurrentActionData = {}
	elseif zone == 'delete' then
		CurrentAction     = 'delete'
		CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour rentrer un vehicule"
		CurrentActionData = {}
	elseif zone == 'pound' then
		CurrentAction     = 'pound_action_menu'
		CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour acceder a la fourriere"
		CurrentActionData = {}
	-- elseif zone == 'society_spawn' then
	-- 	CurrentAction     = 'society_spawn'
	-- 	CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour sortir un vehicule d'entreprise"
	-- 	CurrentActionData = {}
	-- elseif zone == 'society_delete' then
	-- 	CurrentAction     = 'society_delete'
	-- 	CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour rentrer un vehicule d'entreprise"
	-- 	CurrentActionData = {}	
	end
end)

AddEventHandler('eden_garage:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)
--Fin Action das les markers

function ReturnVehicleMenu()

	ESX.TriggerServerCallback('eden_garage:getOutVehicles', function(vehicles)

		local elements = {}

		for _,v in pairs(vehicles) do

			local hashVehicule = v.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle

			local exitPrice = Config.Price

			print(exitPrice)
			for i=1, #VehiclesList, 1 do
				if v.model == GetHashKey(VehiclesList[i].model) then
					print(VehiclesList[i].model)
					exitPrice = math.ceil(VehiclesList[i].price * 0.07)
					if exitPrice < Config.Price then
						exitPrice = Config.Price
						print("go prix minimums")
					end
					break
				end
			end

    		labelvehicle = vehicleName..' - '.. v.plate ..': $'..exitPrice
    	
			table.insert(elements, {label =labelvehicle , value = v, price = exitPrice})
			
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_vehicle',
		{
			css      = 'four',
			title    = 'Fourrière',
			align    = 'right',
			elements = elements,
		},
		function(data, menu)
			ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
				menu.close()
				if hasEnoughMoney then
					
					if times == 0 then
						TriggerServerEvent('eden_garage:pay', data.current.price)
						SpawnPoundedVehicle(data.current.value)
						times=times+1
						Citizen.Wait(60000)
							times=0
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
			--CurrentAction = 'open_garage_action'
		end
		)	
	end)
end

function ReturnSocietyVehicleMenu(societyName)

	ESX.TriggerServerCallback('eden_garage:getOutSocietyVehicles', function(vehicles)

		local elements = {}

		for _,v in pairs(vehicles) do

			local hashVehicule = v.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle

			local exitPrice = Config.Price

			for i=1, #VehiclesList, 1 do
				if v.model == GetHashKey(VehiclesList[i].model) then
					exitPrice = math.ceil(VehiclesList[i].price * 0.04)
					if exitPrice < Config.Price then
						exitPrice = Config.Price
					end
					break
				end
			end

    		labelvehicle = vehicleName..' - '.. v.plate ..': $'..exitPrice
    	
			table.insert(elements, {label =labelvehicle , value = v, price = exitPrice})
			
		end


		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_society_vehicle',
		{
			css      = 'four',
			title    = 'Fourrière entreprise',
			align    = 'right',
			elements = elements,
		},
		function(data, menu)
			ESX.TriggerServerCallback('eden_garage:checkMoney', function(hasEnoughMoney)
				menu.close()
				if hasEnoughMoney then
					
					if times == 0 then
						TriggerServerEvent('eden_garage:pay', data.current.price)
						SpawnPoundedSocietyVehicle(data.current.value, societyName)
						times=times+1
						Citizen.Wait(60000)
							times=0
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
			--CurrentAction = 'open_garage_action'
		end
		)	
	end, tostring(societyName))
end

function ReturnSocietyVehicleMenuByState(societyName)

	ESX.TriggerServerCallback('eden_garage:getOutSocietyVehicles', function(vehicles)

		local elements = {}

		for _,v in pairs(vehicles) do

			local hashVehicule = v.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle

			local exitPrice = Config.Price

			for i=1, #VehiclesList, 1 do
				if v.model == GetHashKey(VehiclesList[i].model) then
					exitPrice = math.ceil(VehiclesList[i].price * 0.04)
					if exitPrice < Config.Price then
						exitPrice = Config.Price
					end
					break
				end
			end

    		labelvehicle = vehicleName..' - '.. v.plate ..': $'..exitPrice
    	
			table.insert(elements, {label =labelvehicle , value = v, price = exitPrice})
			
		end


		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_society_vehicle',
		{
			css      = 'four',
			title    = 'Fourrière entreprise',
			align    = 'right',
			elements = elements,
		},
		function(data, menu)
			menu.close()
			TriggerServerEvent('eden_garage:payByState', tostring(societyName), data.current.price)
			TriggerServerEvent('eden_garage:modifySocietystate', data.current.value, true, societyName)

		end,
		function(data, menu)
			menu.close()
			--CurrentAction = 'open_garage_action'
		end
		)	
	end, tostring(societyName))
end


-- Affichage markers
Citizen.CreateThread(function()
	while true do
		Wait(0)		
		local coords = GetEntityCoords(GetPlayerPed(-1))			
		local xPlayer = ESX.GetPlayerData()
		for k,v in pairs(Config.Garages) do
			if ((GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) 
				and (v.Job == nil or (xPlayer.job ~= nil and xPlayer.job.name ==  v.Job) or (xPlayer.job2 ~= nil and xPlayer.job2.name ==  v.Job))) then
				DrawMarker(v.SpawnPoint.Marker, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, false, true, 2, false, false, false, false)	
				DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, false, false, false, false)	
			end
		end
		for k,v in pairs(Config.Pound) do
			if(GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.MunicipalPoundPoint.Marker, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.MunicipalPoundPoint.Size.x, v.MunicipalPoundPoint.Size.y, v.MunicipalPoundPoint.Size.z, v.MunicipalPoundPoint.Color.r, v.MunicipalPoundPoint.Color.g, v.MunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)	
				DrawMarker(v.SpawnMunicipalPoundPoint.Marker, v.SpawnMunicipalPoundPoint.Pos.x, v.SpawnMunicipalPoundPoint.Pos.y, v.SpawnMunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnMunicipalPoundPoint.Size.x, v.SpawnMunicipalPoundPoint.Size.y, v.SpawnMunicipalPoundPoint.Size.z, v.SpawnMunicipalPoundPoint.Color.r, v.SpawnMunicipalPoundPoint.Color.g, v.SpawnMunicipalPoundPoint.Color.b, 100, false, true, 2, false, false, false, false)
			end		
		end	
		-- for k,v in pairs(Config.SocietyGarage) do
		-- 	if ((GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) 
		-- 		and (v.Job == nil or (xPlayer.job ~= nil and xPlayer.job.name ==  v.Job) or (xPlayer.job2 ~= nil and xPlayer.job2.name ==  v.Job))) then
		-- 		DrawMarker(v.SpawnPoint.Marker, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, false, true, 2, false, false, false, false)	
		-- 		DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, false, false, false, false)	
		-- 	end
		-- end
	end
end)
-- Fin affichage markers

-- Activer le menu quand player dedans
Citizen.CreateThread(function()
	local currentZone = 'garage'
	while true do

		Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local xPlayer = ESX.GetPlayerData()

		for _,v in pairs(Config.Garages) do
			if(GetDistanceBetweenCoords(coords, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, true) < v.Size.x) then
				if (v.Job == nil or (xPlayer.job ~= nil and xPlayer.job.name ==  v.Job) or (xPlayer.job2 ~= nil and xPlayer.job2.name ==  v.Job)) then
					isInMarker  = true
					this_Garage = v
					currentZone = 'spawn'
				end
			end

			if(GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < v.Size.x) then
				if (v.Job == nil or (xPlayer.job ~= nil and xPlayer.job.name ==  v.Job) or (xPlayer.job2 ~= nil and xPlayer.job2.name ==  v.Job)) then
					isInMarker  = true
					this_Garage = v
					currentZone = 'delete'
				end
			end
		end
		for _,v in pairs(Config.Pound) do
			if(GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true) < v.MunicipalPoundPoint.Size.x) then
				isInMarker  = true
				this_Garage = v
				currentZone = 'pound'
			end
		end
		-- for _,v in pairs(Config.SocietyGarage) do
		-- 	if (v.Job == nil or (xPlayer.job ~= nil and xPlayer.job.name ==  v.Job) or (xPlayer.job2 ~= nil and xPlayer.job2.name ==  v.Job)) then
		-- 		if(GetDistanceBetweenCoords(coords, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, true) < v.Size.x) then
		-- 			isInMarker  = true
		-- 			this_Garage = v
		-- 			currentZone = 'society_spawn'
		-- 		end

		-- 		if(GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true) < v.Size.x) then
		-- 			isInMarker  = true
		-- 			this_Garage = v
		-- 			currentZone = 'society_delete'
		-- 		end
		-- 	end
		-- end



		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('eden_garage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('eden_garage:hasExitedMarker', LastZone)
		end

	end
end)


-- Fin activer le menu fourriere quand player dedans

-- Controle touche
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  Keys['E']) and (GetGameTimer() - GUI.Time) > 150 then

				if CurrentAction == 'pound_action_menu' then
					OpenMenuGarage('pound')
				elseif CurrentAction == 'spawn' then
					OpenMenuGarage('spawn')
				elseif CurrentAction == 'delete' then
					OpenMenuGarage('delete')
				-- elseif CurrentAction == 'society_spawn' then
				-- 	OpenMenuGarage('society_spawn')
				-- elseif CurrentAction == 'society_delete' then
				-- 	OpenMenuGarage('society_delete')
				end


				CurrentAction = nil
				GUI.Time      = GetGameTimer()

			end
		end
	end
end)
-- Fin controle touche


-- Societygarage
RegisterNetEvent("eden_garage:ListSocietyVehiclesMenu")
AddEventHandler("eden_garage:ListSocietyVehiclesMenu", function(societyName, garage)
	this_Garage = garage
	ListSocietyVehiclesMenu(tostring(societyName))

end)

RegisterNetEvent("eden_garage:StockSocietyVehicleMenu")
AddEventHandler("eden_garage:StockSocietyVehicleMenu", function(societyName)
	StockSocietyVehicleMenu(tostring(societyName))

end)


RegisterNetEvent("eden_garage:ReturnSocietyVehicleMenuByState")
AddEventHandler("eden_garage:ReturnSocietyVehicleMenuByState", function(societyName)
	ReturnSocietyVehicleMenuByState(tostring(societyName))
end)
