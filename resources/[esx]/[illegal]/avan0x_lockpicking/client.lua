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
