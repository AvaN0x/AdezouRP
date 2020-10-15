-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

--                 if IsControlJustPressed(0, Config.objects.ButtonToStandUp) then
--                     InUse = false
--                     TriggerServerEvent('ChairBedSystem:Server:Leave', oElement.fObjectCoords)
--                     ClearPedTasksImmediately(ply)
--                     FreezeEntityPosition(ply, false)
                    
--                     local x, y, z = table.unpack(PlyLastPos)
--                     if GetDistanceBetweenCoords(x, y, z, plyCoords) < 10 then
--                         SetEntityCoords(ply, vector3(x, y, z - 0.98))
--                     end
--                 end
--             end
--         end
--         Wait(0)
--     end
-- end)

-- -- Medium Thread
-- CreateThread(function()
--     while true do
--         plyCoords = GetEntityCoords(PlayerPedId())
--         Wait(1000)
--     end
-- end)


-- -- Slow Thread
-- CreateThread(function()
--     Wait(1500)
--     while true do
--         for _, element in pairs(Config.objects.Props ) do
--             local closestObject = GetClosestObjectOfType(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, element.hash or GetHashKey(element.object), 0, 0, 0)
--             local coordsObject = GetEntityCoords(closestObject)
--             local distanceDiff = #(coordsObject - plyCoords)
--             if (distanceDiff < 3.0 and closestObject ~= 0) then
--                 if (distanceDiff < 2.0) then
--                     oElement = {
--                         fObject = closestObject,
--                         fObjectCoords = coordsObject,
--                         fObjectcX = element.verticalOffsetX,
--                         fObjectcY = element.verticalOffsetY,
--                         fObjectcZ = element.verticalOffsetZ,
--                         fObjectDir = element.direction,
--                         fObjectIsBed = element.bed
--                     }
--                     isWithinObject = true
--                 end
--                 break
--             else
--                 isWithinObject = false
--             end
--         end
--         Wait(2000)
--     end
-- end)


-- RegisterNetEvent('ChairBedSystem:Client:Animation')
-- AddEventHandler('ChairBedSystem:Client:Animation', function(v, coords)
--     local object = v.fObject
--     local vertx = v.fObjectcX
--     local verty = v.fObjectcY
--     local vertz = v.fObjectcZ
--     local dir = v.fObjectDir
--     local isBed = v.fObjectIsBed
--     local objectcoords = coords
    
--     local ped = PlayerPedId()
--     PlyLastPos = GetEntityCoords(ped)
--     FreezeEntityPosition(object, true)
--     FreezeEntityPosition(ped, true)
--     InUse = true
--     if isBed == false then
--         if Config.objects.SitAnimation.dict ~= nil then
--             SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
--             SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
--             local dict = Config.objects.SitAnimation.dict
--             local anim = Config.objects.SitAnimation.anim
            
--             AnimLoadDict(dict, anim, ped)
--         else
--             TaskStartScenarioAtPosition(ped, Config.objects.SitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
--         end
--     else
--         if Anim == 'back' then
--             if Config.objects.BedBackAnimation.dict ~= nil then
--                 SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
--                 SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
--                 local dict = Config.objects.BedBackAnimation.dict
--                 local anim = Config.objects.BedBackAnimation.anim
                
--                 Animation(dict, anim, ped)
--             else
--                 TaskStartScenarioAtPosition(ped, Config.objects.BedBackAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true
--             )
--             end
--         elseif Anim == 'stomach' then
--             if Config.objects.BedStomachAnimation.dict ~= nil then
--                 SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
--                 SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
--                 local dict = Config.objects.BedStomachAnimation.dict
--                 local anim = Config.objects.BedStomachAnimation.anim
                
--                 Animation(dict, anim, ped)
--             else
--                 TaskStartScenarioAtPosition(ped, Config.objects.BedStomachAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + dir, 0, true, true)
--             end
--         elseif Anim == 'sit' then
--             if Config.objects.BedSitAnimation.dict ~= nil then
--                 SetEntityCoords(ped, objectcoords.x, objectcoords.y, objectcoords.z + 0.5)
--                 SetEntityHeading(ped, GetEntityHeading(object) - 180.0)
--                 local dict = Config.objects.BedSitAnimation.dict
--                 local anim = Config.objects.BedSitAnimation.anim
                
--                 Animation(dict, anim, ped)
--             else
--                 TaskStartScenarioAtPosition(ped, Config.objects.BedSitAnimation.anim, objectcoords.x + vertx, objectcoords.y + verty, objectcoords.z - vertz, GetEntityHeading(object) + 180.0, 0, true, true)
--             end
--         end
--     end
-- end)



-- function DrawText3Ds(x, y, z, text)
--     local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
--     if onScreen then
--         SetTextScale(0.35, 0.35)
--         SetTextFont(4)
--         SetTextProportional(1)
--         SetTextColour(255, 255, 255, 215)
--         SetTextEntry("STRING")
--         SetTextCentre(1)
--         SetTextOutline()

--         AddTextComponentString(text)
--         DrawText(_x, _y)
--         local factor = (string.len(text)) / 350
--         -- DrawRect(_x, _y + 0.0125, factor + 0.015, 0.03, 35, 35, 35, 150)
--     end
-- end

function Animation(dict, anim, ped)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
    
    TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
end

local chair = nil
local isSitting = false

local oldCoords = nil

local Props = {
	{hash = -1531508740, offX = 0.0, offY = 0.0, offZ = -1.0, offHeading = 180.0, bed = false},

    {hash = GetHashKey("v_med_bed1"), offX = 0.0, offY = 0.0, offZ = -1.4, offHeading = 0.0, bed = true},
    {hash = GetHashKey("v_med_bed2"), offX = 0.0, offY = 0.0, offZ = -1.4, offHeading = 0.0, bed = true},
    {hash = GetHashKey("v_med_emptybed"), offX = 0.0, offY = 0.0, offZ = -1.2, offHeading = 90.0, bed = true},
	{hash = GetHashKey("prop_bench_01a"), offX = 0.0, offY = 0.0, offZ = -0.4, offHeading = 180.0, bed = false},
	{hash = GetHashKey("prop_busstop_02"), offX = 0.0, offY = 0.5, offZ = -0.4, offHeading = 180.0, bed = false},

}



Citizen.CreateThread(function()
	while true do
		Wait(500)
        chair = getChair()
	end
end)

Citizen.CreateThread(function()
	while true do
        Wait(0)
        if chair and not isSitting then
            DrawMarker(27, chair.x, chair.y, chair.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 0, 100, false, true, 2, false, false, false, false)

            if IsControlJustPressed(0, 38) then -- E
				local playerPed = PlayerPedId()
				isSitting = true
				oldCoords = GetEntityCoords(playerPed)

                    TaskStartScenarioAtPosition(playerPed, Config.objects.SitAnimation.anim, chair.x, chair.y, chair.z, chair.heading, 0, true, true)
			end
		elseif chair and isSitting then
			DrawMarker(27, chair.x, chair.y, chair.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)

			if IsControlJustPressed(0, 38) then -- E
				local playerPed = PlayerPedId()
				isSitting = false

				SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z - 0.98)
			end

        end
    end
end)


function getChair()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	for _,v in ipairs(Props) do
		local closestProp = GetClosestObjectOfType(coords, 1.0, v.hash, false, false, false)

		if DoesEntityExist(closestProp) then
			local markerCoords = GetOffsetFromEntityInWorldCoords(closestProp, v.offX, v.offY, v.offZ)

			return {x = markerCoords.x, y = markerCoords.y, z = markerCoords.z + 0.9, heading = GetEntityHeading(closestProp) + v.offHeading, bed = v.bed}
		end
	end
	return nil
end


