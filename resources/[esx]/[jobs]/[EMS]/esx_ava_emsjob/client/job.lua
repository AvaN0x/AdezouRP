Citizen.CreateThread(function()
	while not PlayerData do
		Citizen.Wait(10)
    end
end)

function OpenMobileAmbulanceActionsMenu()
	TriggerEvent("EMS:updateBlip")
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'top-left',
		elements = {
			{label = _U('ems_menu'), value = 'citizen_interaction'},
			{label = _U('give_bill'), value = 'billing'},
		}
	}, function(data, menu)
		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				css		= 'Ambulance',
				title = _U('bill_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players'))
					else
						menu.close()
						TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(closestPlayer), 'society_ambulance', _U('billing'), amount)
					end
				end
			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('ems_menu_title'),
				align    = 'top-left',
				elements = {
					{label = _U('ems_menu_revive'), value = 'revive'},
					{label = _U('ems_menu_small'), value = 'small'},
					{label = _U('ems_menu_big'), value = 'big'},
				}
            }, function(data, menu)
                if IsBusy then return end
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 1.0 then
					ESX.ShowNotification(_U('no_players'))
				else
					if data.current.value == 'revive' then
						IsBusy = true

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								if IsPedDeadOrDying(closestPlayerPed, 1) then
                                    local playerPed = PlayerPedId()

                                    ESX.ShowNotification(_U('revive_inprogress'))
									local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

									for i=1, 15, 1 do
										Citizen.Wait(900)
										ESX.Streaming.RequestAnimDict(lib, function()
											TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
										end)
									end

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))
									RemoveAnimDict('mini@cpr@char_a@cpr_str')
									RemoveAnimDict('cpr_pumpchest')
									-- Show revive award?
									if Config.ReviveReward > 0 then
										ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward))
									else
										ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
									end
								else
									ESX.ShowNotification(_U('player_not_unconscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
							IsBusy = false
						end, 'medikit')

					elseif data.current.value == 'small' then
						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_bandage'))
							end
						end, 'bandage')

					elseif data.current.value == 'big' then

						ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
							if quantity > 0 then
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local health = GetEntityHealth(closestPlayerPed)

								if health > 0 then
									local playerPed = PlayerPedId()

									IsBusy = true
									ESX.ShowNotification(_U('heal_inprogress'))
									TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
									Citizen.Wait(10000)
									ClearPedTasks(playerPed)

									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
									TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
									ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
									IsBusy = false
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end
							else
								ESX.ShowNotification(_U('not_enough_medikit'))
							end
						end, 'medikit')
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

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title    = _U('pharmacy_menu_title'),
		align    = 'top-left',
		elements = {
			{label = _U('pharmacy_take', _U('medikit')), value = 'medikit'},
			{label = _U('pharmacy_take', _U('bandage')), value = 'bandage'}
		}
	}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenAmbulanceActionsMenu()
	local elements = {
		{label = _U('cloakroom'), value = 'cloakroom'}
	}

	if (PlayerData.job.name == 'ems' and PlayerData.job.grade_name == 'boss') or (PlayerData.job2.name == 'ems' and PlayerData.job2.grade_name == 'boss') then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title    = _U('ambulance'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('esx_society:openBossMenu', 'ems', function(data, menu)
				menu.close()
			end, {wash = false})
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenCloakroomMenu()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = {
			{label = _U('ems_clothes_civil'), value = 'citizen_wear'},
			{label = _U('ems_clothes_ems'), value = 'ambulance_wear'},
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			enService = false
			TriggerEvent("EMS:PriseDeService", false)
		elseif data.current.value == 'ambulance_wear' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
			enService = true
			TriggerEvent("EMS:PriseDeService", true)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end









Citizen.CreateThread(function()
    Citizen.Wait(1000)
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentHospital, currentPart

		for hospitalNum, hospital in pairs(Config.Hospitals) do
			if (PlayerData.job and PlayerData.job.name == 'ems') or (PlayerData.job2 and PlayerData.job2.name == 'ems') then

			if hospital.AmbulanceActions then
				local distance = GetDistanceBetweenCoords(playerCoords, hospital.AmbulanceActions.Pos.x, hospital.AmbulanceActions.Pos.y, hospital.AmbulanceActions.Pos.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(20, hospital.AmbulanceActions.Pos.x, hospital.AmbulanceActions.Pos.y, hospital.AmbulanceActions.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 17, Config.Marker.a, true, true, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart = true, hospitalNum, 'AmbulanceActions'
				end
			end

            if hospital.Pharmacies then
				local distance = GetDistanceBetweenCoords(playerCoords, hospital.Pharmacies.Pos.x, hospital.Pharmacies.Pos.y, hospital.Pharmacies.Pos.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(20, hospital.Pharmacies.Pos.x, hospital.Pharmacies.Pos.y, hospital.Pharmacies.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 17, Config.Marker.a, false, true, 2, Config.Marker.rotate, false, false, false)
                    letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart = true, hospitalNum, 'Pharmacy'
				end
			end

			if hospital.SocietyGarage then
				local distance = GetDistanceBetweenCoords(playerCoords, hospital.SocietyGarage.Spawner, true)

				if distance < Config.DrawDistance then
					DrawMarker(hospital.SocietyGarage.Marker.type, hospital.SocietyGarage.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, hospital.SocietyGarage.Marker.x, hospital.SocietyGarage.Marker.y, hospital.SocietyGarage.Marker.z, hospital.SocietyGarage.Marker.r, hospital.SocietyGarage.Marker.g, hospital.SocietyGarage.Marker.b, hospital.SocietyGarage.Marker.a, false, false, 2, hospital.SocietyGarage.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < hospital.SocietyGarage.Marker.x then
					isInMarker, currentHospital, currentPart = true, hospitalNum, 'SocietyGarage'
				end
			end


			if hospital.SocietyHeliGarage then
				local distance = GetDistanceBetweenCoords(playerCoords, hospital.SocietyHeliGarage.Spawner, true)

				if distance < Config.DrawDistance then
					DrawMarker(hospital.SocietyHeliGarage.Marker.type, hospital.SocietyHeliGarage.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, hospital.SocietyHeliGarage.Marker.x, hospital.SocietyHeliGarage.Marker.y, hospital.SocietyHeliGarage.Marker.z, hospital.SocietyHeliGarage.Marker.r, hospital.SocietyHeliGarage.Marker.g, hospital.SocietyHeliGarage.Marker.b, hospital.SocietyHeliGarage.Marker.a, false, false, 2, hospital.SocietyHeliGarage.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < hospital.SocietyHeliGarage.Marker.x then
					isInMarker, currentHospital, currentPart = true, hospitalNum, 'SocietyHeliGarage'
				end
			end
		end

		-- Logic for exiting & entering markers
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart)) then

			if
				(LastHospital ~= nil and LastPart ~= nil) and
				(LastHospital ~= currentHospital or LastPart ~= currentPart)
			then
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker, LastHospital, LastPart = true, currentHospital, currentPart

			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart)

		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
	end
end)




Citizen.CreateThread(function()
    Citizen.Wait(1000)
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'AmbulanceActions' then
					OpenAmbulanceActionsMenu()
				elseif CurrentAction == 'Pharmacy' then
					OpenPharmacyMenu()
				elseif CurrentAction == 'SocietyGarage' then
					TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', "society_ambulance", Config.Hospitals[CurrentActionData.hospital].SocietyGarage)
				elseif CurrentAction == 'SocietyHeliGarage' then
					TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', "society_ambulance", Config.Hospitals[CurrentActionData.hospital].SocietyHeliGarage)
				end

				CurrentAction = nil
			end
		elseif (PlayerData.job ~= nil and PlayerData.job.name == 'ems') and not IsDead then
			if IsControlJustReleased(0, 167) then -- F6
				OpenMobileAmbulanceActionsMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if (PlayerData.job and PlayerData.job.name == 'ems') or (PlayerData.job2 and PlayerData.job2.name == 'ems') then
		if part == 'AmbulanceActions' then
			CurrentAction = part
			CurrentActionMsg = _U('actions_prompt')
			CurrentActionData = {}
		elseif part == 'Pharmacy' then
			CurrentAction = part
			CurrentActionMsg = _U('open_pharmacy')
			CurrentActionData = {}
		elseif part == 'SocietyGarage' then
			CurrentAction = part
			CurrentActionMsg = _U('garage_prompt')
			CurrentActionData = {hospital = hospital, partNum = partNum}
		elseif part == 'SocietyHeliGarage' then
			CurrentAction = part
			CurrentActionMsg = _U('garage_prompt')
			CurrentActionData = {hospital = hospital, partNum = partNum}
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(hospital, part, partNum)
	CurrentAction = nil
end)






RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

