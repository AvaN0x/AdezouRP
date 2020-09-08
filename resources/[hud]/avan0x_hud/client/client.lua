ESX = nil
local vehiclesCars = {1,2,3,4,5,6,7,9,10,11,12,17,18,20}; 
-- 0 is on foot
-- 7 is super
-- 8 is motorcycle
-- 19 is tank


local DiffTrigger = 0.355 
local MinSpeed    = 60 --kmh
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
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer) 
	local data = xPlayer

	-- Job
	local job = data.job
	SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})

	-- Job2
	local job2 = data.job2
	SendNUIMessage({action = "setValue2", key = "job2", value = job2.label.." - "..job2.grade_label, icon2 = job2.name})
end)


RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

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
		end


		if IsControlJustReleased(0, 73) then -- X
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
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  SendNUIMessage({action = "setValue", key = "job", value = job.label.." - "..job.grade_label, icon = job.name})
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
  SendNUIMessage({action = "setValue2", key = "job2", value = job2.label.." - "..job2.grade_label, icon2 = job2.name})
end)

RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(status)
	SendNUIMessage({action = "updateStatus", status = status})
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local Ped = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(Ped)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar then
				-- Speed
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				fuel = GetVehicleFuelLevel(PedCar)
				SendNUIMessage({
					action = 'showcarhud', 
					showhud = true,
					speed = carSpeed,
					fuel = fuel
				})

				SendNUIMessage({
					action = 'setbelt',
					isAccepted = has_value(vehiclesCars, GetVehicleClass(PedCar)),
					belt = beltOn
				})
			else
				SendNUIMessage({
					action = 'showcarhud', 
					showhud = false
				})
			end
		else
			SendNUIMessage({
				action = 'showcarhud', 
				showhud = false
			})
		end

	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and (wasInCar or has_value(vehiclesCars, GetVehicleClass(car))) then
			
			wasInCar = true
			
			if beltOn then DisableControlAction(0, 75) end
			
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil 
			and speedBuffer[2] > (MinSpeed / 3.5)
			and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * DiffTrigger) then
				if not beltOn 
				and GetEntitySpeedVector(car, true).y > 1.0  then
					local co = GetEntityCoords(ped)
					SetEntityCoords(ped, co.x, co.y, co.z - 0.47, true, true, true)
					SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
					Citizen.Wait(1)
					SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
				else
					StartScreenEffect('DeathFailOut', 5000, false)
					ShakeGameplayCam("DRUNK_SHAKE", 2.0)
					Wait(5000)
					StopGameplayCamShaking(true)
			   end
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
			
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
