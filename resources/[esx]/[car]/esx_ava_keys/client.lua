-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
IsDead = false

ESX = nil
local my_keys = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

	Citizen.Wait(5000)
    TriggerServerEvent("esx_ava_keys:requestKeys")
end)

RegisterNetEvent('esx_ava_keys:requestNewKeys')
AddEventHandler('esx_ava_keys:requestNewKeys', function(plate)
    if keys_has_value(my_keys, plate) then
        TriggerServerEvent("esx_ava_keys:requestKeys")
    end
end)

RegisterNetEvent('esx_ava_keys:setKeys')
AddEventHandler('esx_ava_keys:setKeys', function(keys)
    my_keys = keys
    print(ESX.DumpTable(my_keys))
end)

AddEventHandler("esx:onPlayerDeath", function()
	IsDead = true
end)

AddEventHandler("playerSpawned", function(spawn)
	IsDead = false
end)

Citizen.CreateThread(function()
    RequestAnimDict("anim@mp_player_intmenu@key_fob@")
    while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
        Citizen.Wait(100)
    end
	while true do
		Citizen.Wait(10)
		if IsControlJustReleased(0, 303) then
			ToggleOpenCar()
		end
	end
end)

function ToggleOpenCar()
    local playerPed = GetPlayerPed(-1)
	local vehicle = nil

    if IsPedInAnyVehicle(playerPed, true) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        local coords = GetEntityCoords(playerPed, true)
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 71)
        if vehicle ~= 0 then
            TaskPlayAnim(playerPed, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
        end
    end
    print(vehicle)
    if vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        print(plate)
		if keys_has_value(my_keys, plate) then
			local locked = GetVehicleDoorLockStatus(vehicle)
            VehicleAnim(vehicle)
            if locked == 1 or locked == 0 then -- if unlocked is unlocked and  is none
                SetVehicleDoorsLocked(vehicle, 2)
                PlayVehicleDoorCloseSound(vehicle, 1)
				ESX.ShowAdvancedColoredNotification(_('keys'), plate, _('you_closed_vehicle'), 'CHAR_PEGASUS_DELIVERY', 1, 2)
            elseif locked == 2 then -- 2 is locked
                SetVehicleDoorsLocked(vehicle, 1)
                PlayVehicleDoorOpenSound(vehicle, 0)
				ESX.ShowAdvancedColoredNotification(_('keys'), plate, _('you_opened_vehicle'), 'CHAR_PEGASUS_DELIVERY', 1, 2)
			end
		else
			ESX.ShowAdvancedColoredNotification(_('keys'), plate, _('have_no_key'), 'CHAR_PEGASUS_DELIVERY', 1, 2)
		end
    end
end

function VehicleAnim(vehicle)
    Citizen.CreateThread(function()
        SetVehicleLights(vehicle, 2)
        Wait(200)
        SetVehicleLights(vehicle, 0)
        Wait(200)
        SetVehicleLights(vehicle, 2)
        Wait(400)
        SetVehicleLights(vehicle, 0)
    end)
end

function keys_has_value(tab, plate)
    for k, v in ipairs(tab) do
        if v.plate == plate then
            return true
        end
    end

    return false
end

RegisterNetEvent('esx_ava_keys:keysMenu')
AddEventHandler('esx_ava_keys:keysMenu', function()
    TriggerServerEvent("esx_ava_keys:requestKeys")
    MyKeysMenu()
end)

function MyKeysMenu()
    local elements = {}
    for k, v in ipairs(my_keys) do
        if v.type == 1 then
            table.insert(elements, {label = _('main', v.plate), value = v})
        else
            table.insert(elements, {label = _('double', v.plate), value = v})
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'my_keys', {
		title = _('menu_header'),
		align = 'left',
		elements = elements
	},
    function(data, menu)
        local elements2 = {}
        if data.current.value.type == 1 then
            table.insert(elements2, {label = _('change_owner'), value = 'change_owner'})
        end
        table.insert(elements2, {label = _('give_double'), value = 'give_double'})
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'my_keys_selected', {
            title = data.current.label,
            align = 'left',
            elements = elements2
        },
        function(data2, menu2)
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance < 3 then
                if data2.current.value == 'give_double' then
                    TriggerServerEvent('esx_ava_keys:giveKey', data.current.value.plate, 2, GetPlayerServerId(closestPlayer))
                elseif data2.current.value == 'change_owner' then
                    TriggerServerEvent('esx_ava_keys:giveOwnerShip', data.current.value.plate, GetPlayerServerId(closestPlayer))
                end
            else
                ESX.ShowNotification(_('no_players_nearby'))
            end
            menu2.close()
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end
