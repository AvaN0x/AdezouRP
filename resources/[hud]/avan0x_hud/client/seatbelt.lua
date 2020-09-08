Cfg             = {}
Cfg.Strings     = { belt_on = 'Belt ^5 on^0.', belt_off = 'Belt ^1 off^0.' }


local DiffTrigger = 0.355 
local MinSpeed    = 60 --kmh
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end


local vehiclesCars = {1,2,3,4,5,6,7,9,10,11,12,17,18,20}; 
-- 0 is on foot
-- 7 is super
-- 8 is motorcycle
-- 19 is tank

Citizen.CreateThread(function()
	Citizen.Wait(100)
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
					local fw = Fwv(ped)
					SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
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
				
			if IsControlJustReleased(0, 73) then -- X
				beltOn = not beltOn				  
				if beltOn then 
					TriggerEvent('chatMessage', Cfg.Strings.belt_on)
				else 
					TriggerEvent('chatMessage', Cfg.Strings.belt_off) end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
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
