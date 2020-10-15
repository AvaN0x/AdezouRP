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

-- function Animation(dict, anim, ped)
--     RequestAnimDict(dict)
--     while not HasAnimDictLoaded(dict) do
--         Citizen.Wait(0)
--     end
    
--     TaskPlayAnim(ped, dict, anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
-- end


-- todo case when user die

