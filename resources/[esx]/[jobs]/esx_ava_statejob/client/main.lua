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

local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local IsDead                    = false

ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'state_cloakroom',
	{
		title    = _U('cloakroom_menu'),
		align    = 'left',
		elements = {
			{ label = _U('wear_citizen'), value = 'wear_citizen' },
			{ label = _U('wear_work'),    value = 'wear_work'}
		}
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
				TriggerServerEvent("player:serviceOff", "state")
			end)
		elseif data.current.value == 'wear_work' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					TriggerServerEvent("player:serviceOn", "state")
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					TriggerServerEvent("player:serviceOn", "state")
				end
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end)
end

function OpenArmurerie()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'state_armurerie',
	{
		title    = _U('armurerie_menu'),
		align    = 'left',
		elements = {
			{ label = _U('add_weapon'), value = 'add_weapon'},	-- faire un toggle (prendre / enlever)
			{ label = _U('rem_weapon'), value = 'rem_weapon'},
		}
	}, function(data, menu)
		if data.current.value == 'add_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'rem_weapon' then
			OpenPutWeaponMenu()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'armurerie'
		CurrentActionMsg  = _U('armurerie_prompt')
		CurrentActionData = {}
	end)
end

function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('esx_ava_statejob:getArmoryWeapons', function(weapons)
  
	  local elements = {}
  
	  for i=1, #weapons, 1 do
		if weapons[i].count > 0 then
		  table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
		end
	  end
  
	  ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'armory_get_weapon',
		{
		  title    = 'Armurerie',
		  align    = 'top-left',
		  elements = elements,
		},
		function(data, menu)
  
		  menu.close()
		  if not HasPedGotWeapon(PlayerPedId(), GetHashKey(data.current.value), false) then
			ESX.TriggerServerCallback('esx_ava_statejob:removeArmoryWeapon', function()
			  OpenGetWeaponMenu()
			end, data.current.value)
		  else
			ESX.ShowNotification("Vous avez déjà cette arme sur vous.")
		  end
  
		end,
		function(data, menu)
		  menu.close()
		end
	  )
  
	end)
  
end
  
function OpenPutWeaponMenu()
  
	local elements   = {}
	local playerPed  = GetPlayerPed(-1)
	local weaponList = ESX.GetWeaponList()
  
	for i=1, #weaponList, 1 do
  
	  local weaponHash = GetHashKey(weaponList[i].name)
  
	  if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
		local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
		table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
	  end
  
	end
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'armory_put_weapon',
	  {
		title    = 'Armurerie',
		align    = 'top-left',
		elements = elements,
	  },
	  function(data, menu)
  
		menu.close()
  
		ESX.TriggerServerCallback('esx_ava_statejob:addArmoryWeapon', function()
		  OpenPutWeaponMenu()
		end, data.current.value)
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  
end


function OpenstateActionsMenu()
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('take_stock'), value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'state' and ESX.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
		table.insert(elements, {label = "Factures impayées", value = 'billUnpaid'})
		table.insert(elements, {label = "Gestion places de parking", value = 'parkingSlots'})
		table.insert(elements, {label = "Sortie de fourrière", value = 'exitPound'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'state_actions',
	{
		title    = 'Gouvernement',
		align    = 'left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()


		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()


		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'state', function(data, menu)
				menu.close()
			end, {wash = false})


		elseif data.current.value == 'billUnpaid' then

			ESX.TriggerServerCallback('esx_ava_statejob:getBillUnpaid', function(result)
				local elements = {
					head = { 'Nom', 'Type', 'Montant', 'Concerné', 'Date', "Jours"},
					rows = {}
				}

				for i=1, #result, 1 do
					table.insert(elements.rows, {
						data = result[i],
						cols = {
							result[i].name,
							result[i].label,
							result[i].amount .. " $",
							result[i].target,
							result[i].date,
							result[i].jours
						}
					})
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'billUnpaid', elements, function(data2, menu2)

				end, function(data2, menu2)
					menu2.close()
				end)
			end)


		elseif data.current.value == 'parkingSlots' then


			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'parkingSlots', {
				title = 'Nom à chercher'
			}, function(data, menu)
				menu.close()
				ESX.TriggerServerCallback('esx_ava_statejob:getParkingSlots', function(result)
					local elements = {
						head = { 'Nom', 'Places', 'Actions'},
						rows = {}
					}

					for i=1, #result, 1 do
						table.insert(elements.rows, {
							data = result[i],
							cols = {
								result[i].name,
								result[i].parking_slots,
								'{{' .. "-" .. '|remove}} {{' .. "+" .. '|add}}'
							}
						})
					end

					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'parkingSlots', 
						elements, 
					function(data2, menu2)

						if data2.value == 'remove' then
							menu2.close()
							print(data2.data.identifier .. ' remove a parking place')
							if data2.data.parking_slots > Config.MinParkingSlots then
								ESX.TriggerServerCallback('esx_ava_statejob:setParkingSlots', function()
									TriggerEvent('esx:showNotification', _U('park_rem', data2.data.name))
								end, data2.data, data2.data.parking_slots - 1)
							else
								TriggerEvent('esx:showNotification', _U('park_already_min', data2.data.name))
							end
						elseif data2.value == 'add' then
							menu2.close()
							print(data2.data.identifier .. ' add a parking place')
							if data2.data.parking_slots < Config.MaxParkingSlots then
								ESX.TriggerServerCallback('esx_ava_statejob:setParkingSlots', function()
									TriggerEvent('esx:showNotification', _U('park_add', data2.data.name))
								end, data2.data, data2.data.parking_slots + 1)
							else
								TriggerEvent('esx:showNotification', _U('park_already_max', data2.data.name))
							end
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end, data.value)
			end, function(data, menu)
				menu.close()
			end)



			
		elseif data.current.value == 'exitPound' then

			ESX.TriggerServerCallback('esx_ava_statejob:getPoundedSocietyVehicles', function(result)
				local elements = {}

				for i=1, #result, 1 do
					table.insert(elements, {label = "Retour vehicule "..result[i].label, value = result[i].society})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'exitPound', 
				{
					title    = 'Fourrière',
					align    = 'left',
					elements = elements
				}, function(data2, menu2)

					TriggerEvent("esx_ava_garage:ReturnVehiclesMenuByState", data2.current.value)

				end, function(data2, menu2)
					menu2.close()
				end)

			end, data.value)




		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'state_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function OpenMobilestateActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_state_actions',
	{
		title    = 'Gouvernement',
		align    = 'left',
		elements = {
			{ label = _U('billing'),   value = 'billing' }
		}
	}, function(data, menu)
		if data.current.value == 'billing' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)
				if amount == nil then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_near'))
					else
						TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(closestPlayer), 'society_state', 'state', amount)
						ESX.ShowNotification(_U('billing_sent'))
					end

				end

			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	
	return false
end

function IsInAuthorizedHelico()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedHelico, 1 do
		if vehModel == GetHashKey(Config.AuthorizedHelico[i].model) then
			return true
		end
	end
	
	return false
end


function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_ava_statejob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = 'state Stock',
			align    = 'left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('esx_ava_statejob:getStockItem', itemName, count)
					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_ava_statejob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard', -- not used
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('esx_ava_statejob:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

AddEventHandler('esx_ava_statejob:hasEnteredMarker', function(zone)
	if zone == 'Doorbell' then
		CurrentAction = 'doorbell_guest'
		CurrentActionMsg = _U('press_to_ring')
		CurrentActionData = {}
	elseif zone == 'StateAction' then
		CurrentAction     = 'state_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	elseif zone == 'CloakRoom' or zone == 'CloakRoom2' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	elseif zone == 'Armurerie' then
		CurrentAction     = 'armurerie'
		CurrentActionMsg  = _U('armurerie_prompt')
		CurrentActionData = {}
	elseif zone == 'SocietyGarage' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	elseif zone == 'SocietyHeliGarage' then
		CurrentAction     = 'heli_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	end

end)

AddEventHandler('esx_ava_statejob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_state'),
		number     = 'state',
		base64Icon = 'data:image/png;base64,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',
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.Doorbell.Pos.x, Config.Zones.Doorbell.Pos.y, Config.Zones.Doorbell.Pos.z)

	SetBlipSprite (blip, 419)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 0)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('blipname'))
	EndTextCommandSetBlipName(blip)
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if (ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'state') or (ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.name == 'state') then
			local coords = GetEntityCoords(PlayerPedId())

			for k,v in pairs(Config.Zones) do
				if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		else
			-- Citizen.Wait(500)
			local v = Config.Zones.Doorbell
			local coords = GetEntityCoords(PlayerPedId())

			if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end

		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		-- if (ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'state') or (ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.name == 'state') then
			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
				isInMarker  = true
				currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_ava_statejob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ava_statejob:hasExitedMarker', LastZone)
			end
		-- else
		-- 	Citizen.Wait(500)
		-- end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			if CurrentActionMsg == _U('press_to_ring') then
				ESX.ShowHelpNotification(CurrentActionMsg)
			elseif (ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'state') or (ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.name == 'state') then
				ESX.ShowHelpNotification(CurrentActionMsg)
			end

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'doorbell_guest' then
					SendNotification("Ding Dong !")
					DoorbellGuest()			
				elseif (ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'state') or (ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.name == 'state') then
					if CurrentAction == 'state_actions_menu' then
						OpenstateActionsMenu()
					elseif CurrentAction == 'cloakroom' then
						OpenCloakroom()
					elseif CurrentAction == 'armurerie' then
						OpenArmurerie()
					elseif CurrentAction == 'vehicle_spawner' then
						TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', "society_state", Config.Zones.SocietyGarage)
					elseif CurrentAction == "heli_spawner" then
						TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', "society_state", Config.Zones.SocietyHeliGarage)
					end
				end
				CurrentAction = nil
			end
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

------------ sonnette

function DoorbellGuest()
	TriggerServerEvent("esx_ava_statejob:sendSonnette")
end

local stopRequest = false
RegisterNetEvent("esx_ava_statejob:sendRequest")
AddEventHandler("esx_ava_statejob:sendRequest", function(name,id)
	stopRequest = true
	ESX.ShowAdvancedNotification(
		'Secrétaire', 
		'GOUVERNEMENT', 
		"~b~"..name.." ~w~a sonné à la porte du gouvernement.\n~g~Y~s~ / ~r~X~s~", 'CHAR_ANTONIA', 2)


	stopRequest = false
	while not stopRequest do
		Citizen.Wait(0)

		if(IsControlJustPressed(1, 246)) then
			TriggerServerEvent("esx_ava_statejob:sendStatusToPeople", id, 1)
			ESX.ShowNotification('~g~Vous avez pris l\'appel')
			stopRequest = true
		end

		if(IsControlJustPressed(1, 73)) then
			TriggerServerEvent("esx_ava_statejob:sendStatusToPeople", id,0)
			ESX.ShowNotification('~r~Vous avez refusé l\'appel')
			stopRequest = true
		end
	end
end)

RegisterNetEvent("esx_ava_statejob:sendStatus")
AddEventHandler("esx_ava_statejob:sendStatus", function(status)
	if(status == 1) then
		SendNotification("~g~Quelqu'un va venir vous ouvrir")
	else
		SendNotification("~r~Personne ne peut venir")
	end
end)

function SendNotification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(false, false)
end
