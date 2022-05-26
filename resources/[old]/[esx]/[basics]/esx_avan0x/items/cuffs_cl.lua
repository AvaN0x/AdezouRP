-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local isHandcuffed = false
local dragStatus = {}
dragStatus.isDragged = false


AddEventHandler('playerSpawned', function(spawn)
	TriggerEvent('esx_avan0x:handcuffs:unrestrain')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_avan0x:handcuffs:unrestrain')
	end
end)


RegisterNetEvent('esx_avan0x:useHandcuffs')
AddEventHandler('esx_avan0x:useHandcuffs', function()
    OpenCuffsMenu()
end)

function OpenCuffsMenu()

    local elements = {
        {label = '<span style="color:green;">Mettre les menottes</span>', value = 'handcuff'},
        {label = '<span style="color:red;">Enlever les menottes</span>', value = 'unhandcuff'},
        {label = 'Escorter la personne', value = 'drag'},
        {label = '<span style="color:green;">Mettre dans le véhicule</span>', value = 'put_in_vehicle'},
        {label = '<span style="color:red;">Retirer du véhicule</span>', value = 'out_the_vehicle'}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Menu_Menottes', {
        title    = 'Menu Menottes',
        align    = 'top',
        elements = elements
    }, function(data2, menu2)
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            local action = data2.current.value

            if action == 'handcuff' then
                local target, distance = ESX.Game.GetClosestPlayer()
                playerheading = GetEntityHeading(GetPlayerPed(-1))
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                local target_id = GetPlayerServerId(target)
                if distance <= 2.0 then
                    TriggerServerEvent('esx_avan0x:handcuffs:requestarrest', target_id, playerheading, playerCoords, playerlocation)
                    Wait(5000)
                    TriggerServerEvent('esx_avan0x:handcuffs:handcuff', GetPlayerServerId(closestPlayer))
                else
                    ESX.ShowNotification('Not Close Enough')
                end
            elseif action == 'unhandcuff' then
                local target, distance = ESX.Game.GetClosestPlayer()
                playerheading = GetEntityHeading(GetPlayerPed(-1))
                playerlocation = GetEntityForwardVector(PlayerPedId())
                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                local target_id = GetPlayerServerId(target)
                TriggerServerEvent('esx_avan0x:handcuffs:requestrelease', target_id, playerheading, playerCoords, playerlocation)
                Wait(5000)
                TriggerServerEvent('esx_avan0x:handcuffs:unhandcuff', GetPlayerServerId(closestPlayer))
            elseif action == 'drag' then
                TriggerServerEvent('esx_avan0x:handcuffs:drag', GetPlayerServerId(closestPlayer))
            elseif action == 'put_in_vehicle' then
                TriggerServerEvent('esx_avan0x:handcuffs:putInVehicle', GetPlayerServerId(closestPlayer))
            elseif action == 'out_the_vehicle' then
                TriggerServerEvent('esx_avan0x:handcuffs:OutVehicle', GetPlayerServerId(closestPlayer))
            end
        else
            ESX.ShowNotification('Pas de joueurs proches')
        end

    end, function(data2, menu2)
        menu2.close()
    end)


end



RegisterNetEvent('esx_avan0x:handcuffs:handcuff')
AddEventHandler('esx_avan0x:handcuffs:handcuff', function()
	isHandcuffed = true
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
        end

        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        SetPedCanPlayGestureAnims(playerPed, false)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(false)
	end)

end)

RegisterNetEvent('esx_avan0x:handcuffs:unrestrain')
AddEventHandler('esx_avan0x:handcuffs:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

RegisterNetEvent('esx_avan0x:handcuffs:drag')
AddEventHandler('esx_avan0x:handcuffs:drag', function(copId)
	if not isHandcuffed then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if isHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_avan0x:handcuffs:putInVehicle')
AddEventHandler('esx_avan0x:handcuffs:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not isHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_avan0x:handcuffs:OutVehicle')
AddEventHandler('esx_avan0x:handcuffs:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			-- DisableControlAction(0, 1, true) -- Disable horizontal cam
			-- DisableControlAction(0, 2, true) -- Disable vertical cam
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, 32, true) -- W
			--DisableControlAction(0, 34, true) -- A
			--DisableControlAction(0, 31, true) -- S
			--DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			-- DisableControlAction(0, 0, true) -- Disable changing view
			-- DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			-- DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


-- Nouvelle menotte 

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
		RemoveAnimDict(dictname)
	end
end


RegisterNetEvent('esx_avan0x:handcuffs:getarrested')
AddEventHandler('esx_avan0x:handcuffs:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	cuffed = true
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('esx_avan0x:handcuffs:doarrested')
AddEventHandler('esx_avan0x:handcuffs:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)

end) 

RegisterNetEvent('esx_avan0x:handcuffs:douncuffing')
AddEventHandler('esx_avan0x:handcuffs:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('esx_avan0x:handcuffs:getuncuffed')
AddEventHandler('esx_avan0x:handcuffs:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	z = z - 1.0
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	cuffed = false
	ClearPedTasks(GetPlayerPed(-1))
end)
