ESX = nil

local menuOpen = false
local wasOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		
		
		if GetDistanceBetweenCoords(coords, config.zones.MineDealer.coords, true) < 1.5 then

			ESX.ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour ~g~Vendre")

			if IsControlJustReleased(0, 38) then
					OpenMineShop()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenMineShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = config.items[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">$%s</span>'):format(v.label, ESX.Math.GroupDigits(price)),
				name = v.name,
				price = price,

				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mine_shop', {
		title    = 'Acheteur de minerais',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('caruby_mining:sell', data.current.name, data.current.value)
		-- menu.close()
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

function CreateBlipCircle(coords, text, radius, color, sprite)
	local blip 

	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha (blip, 128)

	blip = AddBlipForCoord(coords)

	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 0.7)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	for k,zone in pairs(config.zones) do
		CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
	end
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(coords, config.zones.MineProcessing.coords, true) < 10 then
			DrawMarker(2, 1109.24, -2007.90, 31.64, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 25, 165, 165, 0,0, 0,0)	
		end
	end
end)