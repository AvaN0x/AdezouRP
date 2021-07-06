-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


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
	for k, v in pairs(Config.Insurance) do
		local blip = AddBlipForCoord(v.Blip.Pos or v.Pos)
		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.6)
		SetBlipColour (blip, v.Blip.Color)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Assurance")
		EndTextCommandSetBlipName(blip)
	end
    for k, v in pairs(Config.Pound) do
		local blip = AddBlipForCoord(v.Blip.Pos or v.Pos)
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
        if not this_Garage.OnlyParkCars then
            table.insert(elements,{label = "Liste des véhicules", value = 'list_vehicles'})
        end
        table.insert(elements,{label = "Rentrer vehicules", value = 'stock_vehicle'})

	elseif PointType == 'insurance' or PointType == 'pound' then
        local isInsurance = PointType == 'insurance' and true or false
		table.insert(elements, {label = "Retour vehicule personnel", value = 'return_vehicle', isInsurance = isInsurance})
		if PlayerData.job ~= nil and PlayerData.job.name ~= "unemployed" then
			table.insert(elements, {label = "Retour vehicule "..PlayerData.job.label, value = 'return_vehicle', isInsurance = isInsurance, job = "society_"..PlayerData.job.name})
		end
		if PlayerData.job2 ~= nil and PlayerData.job2.name ~= "unemployed2" then
			table.insert(elements, {label = "Retour vehicule "..PlayerData.job2.label, value = 'return_vehicle', isInsurance = isInsurance, job = "society_"..PlayerData.job2.name})
		end
	end

	local title = this_Garage.IsGangGarage
        and "Garage de gang"
        or target
            and "Garage entreprise"
            or "Garage"

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			css	  = 'garage',
			title	= title,
			align	= 'right',
			elements = elements,
		},
		function(data, menu)
			if data.current.value == 'list_vehicles' then
				ListVehiclesMenu(this_Garage.Type, target)

			elseif data.current.value == 'stock_vehicle' then
				StockVehicleMenu(target)

			elseif data.current.value == 'return_vehicle' then
				ReturnVehicleMenu(data.current.isInsurance, data.current.job)

			end
		end,
		function(data, menu)
			menu.close()
        end
	)
end


-- Afficher les listes des vehicules
function ListVehiclesMenu(type, target)
	local elements = {}

    ESX.TriggerServerCallback('esx_ava_garage:getVehicles', function(vehicles)

		for _,v in pairs(vehicles) do
			local hashVehicule = v.vehicle.model
			local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
			local labelvehicle
			if v.location == this_Garage.Identifier then
				labelvehicle = vehicleName..' - '.. v.vehicle.plate

			elseif v.location == "garage_INSURANCE" then
				labelvehicle = "<span style=\"color: #c9712e;\">"..vehicleName..' - '.. v.vehicle.plate ..'</span>'

            elseif v.location == "garage_POUND" then
				labelvehicle = "<span style=\"color: #c92e2e;\">"..vehicleName..' - '.. v.vehicle.plate ..'</span>'

            elseif string.match(v.location, "^seized_") then
				labelvehicle = "<span style=\"color: #c92e2e;\">"..vehicleName..' - '.. v.vehicle.plate ..'</span>'

			else
				labelvehicle = "<span style=\"color: darkgray;\">"..vehicleName..' - '.. v.vehicle.plate ..'</span>'
			end
			table.insert(elements, {label = labelvehicle, detail = "Essence : " .. math.floor(v.fuel) .. " %", value = v})
		end

		ESX.TriggerServerCallback('esx_ava_garage:getParkingInfos', function(data)
			local parking_slots_count = data.parking_slots
			-- print(data.parking_slots..'/'..data.owned_count..'/'..data.parked_count)

            local title = this_Garage.IsGangGarage
                and "Garage de gang"
                or target
                    and "Garage entreprise"
                    or 'Garage (' .. #vehicles .. '/' .. parking_slots_count .. ')'

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

                    if not IsPedInAnyVehicle(PlayerPedId(), false) then
                        SpawnVehicle(data.current.value.vehicle, data.current.value.fuel, target)
                        TriggerServerEvent('esx_ava_garage:modifystate', data.current.value.vehicle, "garage_INSURANCE", target, true, this_Garage.onlyCheckGarage, this_Garage.Identifier, this_Garage.IsGangGarage)
                    end

				elseif data.current.value.location == "garage_INSURANCE" then
					TriggerEvent('esx:showNotification', 'Ce véhicule est introuvable.')

                elseif data.current.value.location == "garage_POUND" then
					TriggerEvent('esx:showNotification', 'Ce véhicule est à la fourriere.')

                elseif string.match(data.current.value.location, "^seized_") then
					TriggerEvent('esx:showNotification', 'Ce véhicule est a été saisi.')

				else
					TriggerEvent('esx:showNotification', 'Ce véhicule est dans un autre garage.')
				end
			end,
			function(data, menu)
				menu.close()
				OpenMenuGarage('open_garage_menu', target)
			end)
		end, this_Garage.Type)

	end, type, this_Garage.Identifier, target, this_Garage.onlyCheckGarage, this_Garage.IsGangGarage)
end


function StockVehicleMenu(target)
	local playerPed  = PlayerPedId()

	if IsPedInAnyVehicle(playerPed,  false) then
		local coords	= GetEntityCoords(playerPed)
		local vehicle   = GetVehiclePedIsIn(playerPed,false)
		local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)

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
			end, vehicleProps, fuel, this_Garage.Type, this_Garage.Identifier, target, this_Garage.onlyCheckGarage, this_Garage.Identifier, this_Garage.IsGangGarage)
		end)
	else
		TriggerEvent('esx:showNotification', 'Il n\'y a pas de vehicule à rentrer')
	end
end



function ranger(vehicle, vehicleProps, gIdentifier, target)
	DeleteEntity(vehicle)
	TriggerServerEvent('esx_ava_garage:modifystate', vehicleProps, gIdentifier, target, true, this_Garage.onlyCheckGarage, this_Garage.Identifier, this_Garage.IsGangGarage)
	TriggerEvent('esx:showNotification', 'Ce véhicule est maintenant dans ce garage')
end


function SpawnVehicle(vehicle, fuel, target)
	ESX.Game.SpawnVehicle(vehicle.model,{
            x=this_Garage.SpawnPoint.Pos.x + 0.0,
            y=this_Garage.SpawnPoint.Pos.y + 0.0,
            z=this_Garage.SpawnPoint.Pos.z + 1.0
		},this_Garage.SpawnPoint.Heading + 0.0, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetEntityAsMissionEntity(callback_vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
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

end

function SpawnPoundedVehicle(vehicle, target)

	ESX.Game.SpawnVehicle(vehicle.model, {
		x = this_Garage.SpawnPoint.Pos.x + 0.0,
		y = this_Garage.SpawnPoint.Pos.y + 0.0,
		z = this_Garage.SpawnPoint.Pos.z + 1.0
		}, this_Garage.SpawnPoint.Heading + 0.0, function(callback_vehicle)
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
	TriggerServerEvent('esx_ava_garage:modifystate', vehicle, "no_garages", target, this_Garage.onlyCheckGarage, this_Garage.Identifier, this_Garage.IsGangGarage)

	Citizen.Wait(10000)
	TriggerServerEvent('esx_ava_garage:modifystate', vehicle, "garage_INSURANCE", target, this_Garage.onlyCheckGarage, this_Garage.Identifier, this_Garage.IsGangGarage)

end



function ReturnVehicleMenu(isInsurance, target, isGov)
	ESX.TriggerServerCallback('esx_ava_garage:getOutVehicles', function(vehicles)
		local elements = {}

        local playerPed = PlayerPedId()
        local lastVehicle = GetVehiclePedIsIn(playerPed, true)
        local lastVehiclePlate = lastVehicle ~= 0 and GetVehicleNumberPlateText(lastVehicle) or ""

		for _,v in pairs(vehicles) do
            -- Do not display the plate of the last vehicle the player went in
            if not isInsurance or v.vehicle.plate ~= lastVehiclePlate then
                local hashVehicule = v.vehicle.model
                local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
                local labelvehicle
                local exitPrice = -1

                for i=1, #VehiclesList, 1 do
                    if v.vehicle.model == GetHashKey(VehiclesList[i].model) then
                        if isInsurance then
                            exitPrice = math.ceil(VehiclesList[i].price * Config.InsurancePriceMultiplier)
                            if exitPrice < Config.InsuranceMinPrice then
                                exitPrice = Config.InsuranceMinPrice
                            elseif exitPrice > Config.InsuranceMaxPrice then
                                exitPrice = Config.InsuranceMaxPrice
                            end
                        else
                            exitPrice = math.ceil(VehiclesList[i].price * Config.PoundPriceMultiplier)
                            if exitPrice < Config.PoundMinPrice then
                                exitPrice = Config.PoundMinPrice
                            elseif exitPrice > Config.PoundMaxPrice then
                                exitPrice = Config.PoundMaxPrice
                            end
                        end
                        break
                    end
                end
                if exitPrice ~= -1 then
                    labelvehicle = vehicleName..' - '.. v.vehicle.plate ..': $'..exitPrice
                    table.insert(elements, {label = labelvehicle , value = v.vehicle, price = exitPrice, type = v.type})
                else
                    print("ERROR : " .. v.vehicle.model .. " is not a valid vehicle model.")
                end
            end
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'return_vehicle',
		{
			title	= isInsurance and 'Assurance' or "Fourrière",
			align	= 'left',
			elements = elements,
		},
		function(data, menu)
			menu.close()
			ESX.TriggerServerCallback('esx_ava_garage:checkMoney', function(hasEnoughMoney)
                if hasEnoughMoney or (not hasEnoughMoney and isGov) then
                    if times == 0 then
                        if isGov then
                            TriggerServerEvent('esx_ava_garage:payByState', isInsurance, target, data.current.price)
                        else
                            TriggerServerEvent('esx_ava_garage:pay', isInsurance, data.current.price)
                        end
                        if not isInsurance and data.current.type == "car" and not isGov then
                            SpawnPoundedVehicle(data.current.value, target)
                            times = times + 1
							Citizen.Wait(60000)
							times = 0
                        else
                            if isInsurance then
                                ESX.ShowNotification("L'assurance vient de remettre ce véhicule.")
                            else
                                ESX.ShowNotification("Le véhicule est sorti de la fourrière'")
                            end
                            TriggerServerEvent('esx_ava_garage:modifystate', data.current.value, Config.DefaultGarage, target, this_Garage.onlyCheckGarage, this_Garage.Identifier, this_Garage.IsGangGarage)
                        end
                    else
                        ESX.ShowNotification('Veuillez patienter une minute')
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas assez d\'argent')
                end
			end, data.current.price)
		end,
		function(data, menu)
			menu.close()
		end)
	end, isInsurance, target)
end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local found = false

		for k,v in pairs(Config.Garages) do
			if (#(coords - v.Pos) < Config.DrawDistance)
				and (PlayerData and (v.Job == nil or (PlayerData.job ~= nil and PlayerData.job.name ==  v.Job) or (PlayerData.job2 ~= nil and PlayerData.job2.name ==  v.Job))) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				found = true
			end
		end
		for k,v in pairs(Config.Insurance) do
			if (#(coords - v.Pos) < Config.DrawDistance) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				found = true
			end
		end
		for k,v in pairs(Config.Pound) do
			if (#(coords - v.Pos) < Config.DrawDistance) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
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

	elseif zone == 'open_insurance_menu' then
		CurrentAction	 = 'insurance_action_menu'
		CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour accéder à l'assurance"
		CurrentActionData = {}

	elseif zone == 'open_pound_menu' then
		CurrentAction	 = 'pound_action_menu'
		CurrentActionMsg  = "Appuyer sur ~INPUT_PICKUP~ pour accéder à la fourrière"
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
		local coords	  = GetEntityCoords(PlayerPedId())
		local isInMarker  = false

		for _,v in pairs(Config.Garages) do
			if (#(coords - v.Pos) < (v.Distance or v.Size.x)) then
				if v.Job == nil or (PlayerData and ((PlayerData.job ~= nil and PlayerData.job.name ==  v.Job) or (PlayerData.job2 ~= nil and PlayerData.job2.name ==  v.Job))) then
					isInMarker  = true
					this_Garage = v
					currentZone = 'open_garage_menu'
				end
			end
		end
		for _,v in pairs(Config.Insurance) do
			if (#(coords - v.Pos) < v.Size.x) then
				isInMarker  = true
				this_Garage = v
				currentZone = 'open_insurance_menu'
			end
		end
		for _,v in pairs(Config.Pound) do
			if (#(coords - v.Pos) < v.Size.x) then
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
                    
				elseif CurrentAction == 'insurance_action_menu' then
					OpenMenuGarage('insurance')

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
AddEventHandler("esx_ava_garage:OpenSocietyVehiclesMenu", function(societyName, garage, type) --* type is not used?
	this_Garage = garage
	this_Garage.Identifier = "garage_SOCIETY"
	if not this_Garage.Type then
		this_Garage.Type = 'car'
	end
	OpenMenuGarage('open_garage_menu', tostring(societyName))
end)

RegisterNetEvent("esx_ava_garage:ReturnVehiclesMenuByState")
AddEventHandler("esx_ava_garage:ReturnVehiclesMenuByState", function(societyName)
	ReturnVehicleMenu(true, societyName, true)
end)

-- used for seized vehicles
RegisterNetEvent("esx_ava_garage:openSpecialVehicleMenu")
AddEventHandler("esx_ava_garage:openSpecialVehicleMenu", function(garage, jobName)
	this_Garage = garage
    this_Garage.onlyCheckGarage = true
	if this_Garage.IsGangGarage == nil then
		this_Garage.IsGangGarage = false
	end
	if this_Garage.OnlyParkCars == nil then
		this_Garage.OnlyParkCars = false
	end
	if not this_Garage.Type then
		this_Garage.Type = 'car'
	end
	OpenMenuGarage('open_garage_menu', jobName)
end)