ESX = nil
PlayerData = nil

local vehiclesCars = {0, 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 17, 18, 20};
-- 0 is on foot
-- 7 is super
-- 8 is motorcycle
-- 19 is tank


local DiffTrigger = 0.355
local MinSpeed    = 60.0 --kmh
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.UI.HUD.SetDisplay(0.0)
	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	InitHUD(ESX.GetPlayerData())
end)

function InitHUD(xPlayer)
	PlayerData = xPlayer
	Citizen.Wait(200)
	-- Cash
	SendNUIMessage({action = "setValue", key = "money", value = "$" .. ESX.Math.GroupDigits(xPlayer.money)})

	-- Accounts
	for k, account in pairs(xPlayer.accounts) do
		if account.name == "black_money" then
			SendNUIMessage({action = "setValue", key = account.name, value = "$" .. ESX.Math.GroupDigits(account.money)})
		end
	end


	-- Job
	SendNUIMessage({action = "setValue", key = "job", value = PlayerData.job.label .. " - " .. PlayerData.job.grade_label, name = PlayerData.job.name})

	-- Job2
	SendNUIMessage({action = "setValue", key = "job2", value = PlayerData.job2.label .. " - " .. PlayerData.job2.grade_label, name = PlayerData.job2.name})
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
	InitHUD(xPlayer)
end)

RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

RegisterNetEvent('ui:togglePlayerStats')
AddEventHandler('ui:togglePlayerStats', function(show)
	SendNUIMessage({action = "togglePlayerStats", show = show})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, name = job.name})
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	SendNUIMessage({action = "setValue", key = "job2", value = job2.label.." - "..job2.grade_label, name = job2.name})
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(amount)
	SendNUIMessage({action = "setValue", key = "money", value = "$" .. ESX.Math.GroupDigits(amount)})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "black_money" then
		SendNUIMessage({action = "setValue", key = account.name, value = "$" .. ESX.Math.GroupDigits(account.money)})
	end
end)

RegisterNetEvent('esx_ava_jobs:setGang')
AddEventHandler('esx_ava_jobs:setGang', function(gang)
	SendNUIMessage({action = "setValue", key = "gang", value = gang.label, name = gang.name})
end)

RegisterNetEvent('avan0x_hud:updateStatus')
AddEventHandler('avan0x_hud:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)

RegisterNetEvent('avan0x_hud:inventoryItemNotification')
AddEventHandler('avan0x_hud:inventoryItemNotification', function(add, itemLabel, count)
    SendNUIMessage({action = "itemNotification", add = add, label = itemLabel, count = count})
end)




-- KEYMAPPING

RegisterCommand('+keyToggleBelt', function()
    local ped = GetPlayerPed(-1)
    if(IsPedInAnyVehicle(ped)) then
        local car = GetVehiclePedIsIn(ped, false)
        local isAccepted = has_value(vehiclesCars, GetVehicleClass(car))
        if car and isAccepted then
            beltOn = not beltOn
            SendNUIMessage({
                action = 'setbelt',
                isAccepted = isAccepted,
                belt = beltOn
            })
        end
    end
end, false)

RegisterKeyMapping('+keyToggleBelt', 'Ceinture', 'keyboard', 'X')






-- clause menu when active
Citizen.CreateThread(function()
    local isPauseMenu = false
	while true do
		Citizen.Wait(0)

		if IsPauseMenuActive() then -- ESC Key
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggle', show = false })
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggle', show = true })
			end

			HideHudComponentThisFrame(1)  -- Wanted Stars
			HideHudComponentThisFrame(2)  -- Weapon Icon
			HideHudComponentThisFrame(3)  -- Cash
			HideHudComponentThisFrame(4)  -- MP Cash
			-- HideHudComponentThisFrame(6)  -- Vehicle Name
			HideHudComponentThisFrame(7)  -- Area Name
			HideHudComponentThisFrame(8)  -- Vehicle Class
			-- HideHudComponentThisFrame(9)  -- Street Name
			HideHudComponentThisFrame(13) -- Cash Change
			HideHudComponentThisFrame(17) -- Save Game
			HideHudComponentThisFrame(20) -- Weapon Stats

			if beltOn then
				DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
				DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
			end
		end
	end
end)

local vehiclePlayerIsIn = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		vehiclePlayerIsIn = GetVehiclePedIsIn(GetPlayerPed(-1), false)
		if vehiclePlayerIsIn ~= 0 then
			-- Speed
			carSpeed = math.ceil(GetEntitySpeed(vehiclePlayerIsIn) * 3.6)
			fuel = GetVehicleFuelLevel(vehiclePlayerIsIn)
			SendNUIMessage({
				action = 'showcarhud',
				showhud = true,
				speed = carSpeed,
				fuel = fuel
			})

			SendNUIMessage({
				action = 'setbelt',
				isAccepted = has_value(vehiclesCars, GetVehicleClass(vehiclePlayerIsIn)),
				belt = beltOn
			})
		else
			SendNUIMessage({
				action = 'showcarhud',
				showhud = false
			})
			beltOn = false
			Citizen.Wait(500)
		end
	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		if vehiclePlayerIsIn ~= 0 and (wasInCar or has_value(vehiclesCars, GetVehicleClass(vehiclePlayerIsIn))) then
			local ped = GetPlayerPed(-1)

			wasInCar = true

			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(vehiclePlayerIsIn)

			if speedBuffer[2] ~= nil
			and speedBuffer[2] > (MinSpeed / 3.5)
			and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * DiffTrigger) then
				if not beltOn
				and GetEntitySpeedVector(vehiclePlayerIsIn, true).y > 1.0  then
					local co = GetEntityCoords(ped)
					SetEntityCoords(ped, co.x, co.y, co.z - 0.47, true, true, true)
					SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
					Citizen.Wait(1)
					SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
				elseif GetPedInVehicleSeat(vehiclePlayerIsIn, -1) == ped then
					StartScreenEffect('MP_Celeb_Lose', 5000, false)
					ShakeGameplayCam("DRUNK_SHAKE", 3.0)
					Wait(5000)
					StopGameplayCamShaking(true)
				end
			end

			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(vehiclePlayerIsIn)
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(100)
	end
end)

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

RegisterNetEvent('avan0x_hud:copyToClipboard')
AddEventHandler('avan0x_hud:copyToClipboard', function(content)
	SendNUIMessage({action = "copyToClipboard", content = content})
end)



RegisterCommand('+keyDetailsHUD', function()
	SendNUIMessage({action = "toggleMainStats", show = true})
end, false)

RegisterCommand('-keyDetailsHUD', function()
	SendNUIMessage({action = "toggleMainStats", show = false})
end, false)

RegisterKeyMapping('+keyDetailsHUD', 'Détails du HUD', 'keyboard', 'LMENU')
