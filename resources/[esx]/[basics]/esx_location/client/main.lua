ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function OpenVehicleMenu() -- Menu location véhicules

    local elements = {
        {label = 'Scooter 250$', value = 'Faggio', price = 250},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_menu',
        {
            title = 'Location de véhicules', -- Titre du menu
            elements = elements
        },
        function(data, menu)
            for i=1, #elements, 1 do
                local playerPed = GetPlayerPed(-1)
                local platenum = math.random(00001, 99998)
				local coords    = Config.Zones.LocationVehicleEntering.Pos 
				local price     = data.current.price
                ESX.Game.SpawnVehicle(data.current.value, coords, 200.0, function(vehicle)
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1) -- Téléportation du joueur dans le véhicule
                    SetVehicleNumberPlateText(vehicle, 'LOCATION' .. platenum) -- Modification de la plaque d'immatriculation en LOCATION
                end)
                TriggerServerEvent('esx_location:Buy', price) -- Event permetant de faire payer le joueur
                break
            end
            menu.close()
    end,
    function(data, menu)
        menu.close()
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Location de véhicules'
        CurrentActionData = {}
    end
    )
end



function OpenBikeMenu() -- Menu location vélos

	local elements = {
        {label = 'BMX $75', value = 'bmx', price = 75},
        {label = 'Scorcher $85', value = 'scorcher', price = 85},
        {label = 'Cruiser $30', value = 'cruiser', price = 30},
        {label = 'Fixter $80', value = 'fixter', price = 80},
        {label = 'Tribike Vert $100', value = 'tribike', price = 100},
        {label = 'Tribike Rouge $100', value = 'tribike2', price = 100},
        {label = 'Tribike Bleu $100', value = 'tribike3', price = 100},
    }
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_menu',
        {
            title = 'Location de vélos', -- Titre du menu
            elements = elements
        },
        function(data, menu)
            for i=1, #elements, 1 do
                local playerPed = GetPlayerPed(-1)
                local platenum = math.random(00001, 99998)
				local coords    = Config.Zones.LocationBike.Pos 
				local price     = data.current.price
                ESX.Game.SpawnVehicle(data.current.value, coords, 200.0, function(vehicle)
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1) -- Téléportation du joueur dans le véhicule
                    SetVehicleNumberPlateText(vehicle, 'LOCATION' .. platenum) -- Modification de la plaque d'immatriculation en LOCATION
                end)
                TriggerServerEvent('esx_location:Buy', price) -- Event permetant de faire payer le joueur
                break
            end
            menu.close()
    end,
    function(data, menu)
        menu.close()
        CurrentAction     = 'locationVelo_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Location de vélos'
        CurrentActionData = {}
    end
    )
end


AddEventHandler('esx_location:hasEnteredMarker', function(zone)

    if zone == 'LocationVehicleEntering' then
        CurrentAction     = 'locationVehicle_menu'
        CurrentActionMsg  = '~INPUT_CONTEXT~ Location de véhicules'
		CurrentActionData = {}
	elseif zone == 'LocationBike' then
		CurrentAction     = 'locationVelo_menu'
		CurrentActionMsg  = '~INPUT_CONTEXT~ Location de vélos'
		CurrentActionData = {}
	
	end

end)

AddEventHandler('esx_location:hasExitedMarker', function(zone)
    CurrentAction = nil
end)

local playerCoords = nil
local playerPed = nil

Citizen.CreateThread(function()
	while true do
        playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		Citizen.Wait(500)
    end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
        local waitTime = 500
		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and #(playerCoords - v.Pos) < Config.DrawDistance) then
                waitTime = 0
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
        Citizen.Wait(waitTime)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Wait(100)
		local isInMarker  = false
		local currentZone = nil
		for k,v in pairs(Config.Zones) do
			if(#(playerCoords - v.Pos) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_location:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_location:hasExitedMarker', LastZone)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 300 then
                if CurrentAction == 'locationVehicle_menu' then
                    OpenVehicleMenu()
				end
				if CurrentAction == 'locationVelo_menu' then
                    OpenBikeMenu()
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
            end
        else
            Citizen.Wait(50)
		end
    end  
end)

-- Blips
Citizen.CreateThread(function()	

    local blip = AddBlipForCoord(Config.Zones.LocationVehicleEntering.Pos.x, Config.Zones.LocationVehicleEntering.Pos.y, Config.Zones.LocationVehicleEntering.Pos.z)
    
	SetBlipSprite (blip, 409)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.6)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("~o~Location de véhicules")
    EndTextCommandSetBlipName(blip)
 

	local blip2 = AddBlipForCoord(Config.Zones.LocationBike.Pos.x, Config.Zones.LocationBike.Pos.y, Config.Zones.LocationBike.Pos.z)
    
	SetBlipSprite (blip2, 409)
	SetBlipDisplay(blip2, 4)
	SetBlipScale  (blip2, 0.7)
	SetBlipColour (blip2, 17)
	SetBlipAsShortRange(blip2, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("~o~Location de vélos")
    EndTextCommandSetBlipName(blip2)

end)