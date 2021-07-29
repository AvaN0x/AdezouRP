-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


function Win()
	ESX.ShowNotification("Tu as cassé le verrou")
	TriggerEvent('avan0x_lockpicking:LockpickingComplete', true)
    TriggerServerEvent('avan0x_lockpicking:LockpickingComplete', true)
end

function Lose()
	ESX.ShowNotification("Tu n'as pas réussi à casser le verrou")
	TriggerEvent('avan0x_lockpicking:LockpickingComplete', false)
    TriggerServerEvent('avan0x_lockpicking:LockpickingComplete', false)
end

RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
	Lose()
end)

RegisterNUICallback('NUIWin', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
	Win()
end)

RegisterNUICallback('NUILose', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
	Lose()
end)

RegisterNetEvent('avan0x_lockpicking:StartLockPicking')
AddEventHandler('avan0x_lockpicking:StartLockPicking', function() 
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

RegisterNetEvent('esx_ava_lockpick:onUse')
AddEventHandler('esx_ava_lockpick:onUse', function()
	local playerPed   = GetPlayerPed(-1)
	local coords    = GetEntityCoords(playerPed)
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.0) then
		vehicle = nil

		if not IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			TriggerEvent('avan0x_lockpicking:StartLockPicking')
		end
	else
		vehicle = nil
	end
end)

RegisterNetEvent('avan0x_lockpicking:LockpickingComplete')
AddEventHandler('avan0x_lockpicking:LockpickingComplete', function(result)
	local playerPed   = GetPlayerPed(-1)
	ClearPedTasksImmediately(playerPed)
	if result and vehicle then
		SetVehicleDoorsLocked(vehicle, 1)
		SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        Citizen.InvokeNative(0xDBC631F109350B8C, vehicle, false)
		ClearPedTasksImmediately(playerPed)

		vehicle = nil
	end
end)
