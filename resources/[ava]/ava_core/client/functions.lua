-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.KeyboardInput = function(textEntry, inputText, maxLength)
    AddTextEntry("AVA_KYBRD_INPT", textEntry or "")
    DisplayOnscreenKeyboard(1, "AVA_KYBRD_INPT", '', inputText or "", '', '', '', maxLength or 255)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end

    local result = ""
    if UpdateOnscreenKeyboard() ~= 2 then
        result = tostring(GetOnscreenKeyboardResult())
    end
    Citizen.Wait(100)
    return result or ""
end

AVA.ShowNotification = function(text, color, textureName, title, subtitle, iconType, textureDict)
    AddTextEntry("AVA_NOTF_TE", text or "")
	BeginTextCommandThefeedPost("AVA_NOTF_TE")
    if color then
        -- color :
        -- https://pastebin.com/d9aHPbXN
        SetNotificationBackgroundColor(color)
    end
    if textureName then
        textureDict = textureDict or textureName
        -- icon :
        -- https://wiki.rage.mp/index.php?title=Notification_Pictures

        -- iconTypes:
        -- 1 : Chat Box
        -- 2 : Email
        -- 3 : Add Friend Request
        -- 4 : Nothing
        -- 5 : Nothing
        -- 6 : Nothing
        -- 7 : Right Jumping Arrow
        -- 8 : RP Icon
        -- 9 : $ Icon
        if not HasStreamedTextureDictLoaded(textureDict) then
            RequestStreamedTextureDict(textureDict, false)
            while not HasStreamedTextureDictLoaded(textureDict) do Wait(0) end
        end
        EndTextCommandThefeedPostMessagetext(textureDict, textureName, false, iconType or 4, title, subtitle)
        SetStreamedTextureDictAsNoLongerNeeded(textureDict)
    end
	EndTextCommandThefeedPostTicker(false, true)
end
RegisterNetEvent("ava_core:client:ShowNotification", AVA.ShowNotification)


AVA.ShowHelpNotification = function(text)
    AddTextEntry("AVA_NOTF_TE", text)
    BeginTextCommandDisplayHelp("AVA_NOTF_TE")
    EndTextCommandDisplayHelp(0, false, true, -1)
end



----------------------------------------
--------------- Vehicles ---------------
----------------------------------------

AVA.Vehicles = {}
AVA.Vehicles.SpawnVehicle = function(vehName, coords, heading, isNetwork)
    local p = promise:new()
    isNetwork = (isNetwork == nil or isNetwork == true)

	Citizen.CreateThread(function()
        -- get vehicle model hash
        local modelHash = type(vehName) == 'number' and vehName or GetHashKey(vehName)

        -- get vehicle model
		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do Wait(0) end

		local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, isNetwork, false)
        -- init vehicle
        SetVehicleOnGroundProperly(vehicle)
        
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
        SetVehicleIsWanted(vehicle, false)
        SetVehRadioStation(vehicle, 'OFF')
        
        if isNetwork then
            -- init vehicle on network
            local id = VehToNet(vehicle)
            SetNetworkIdExistsOnAllMachines(id, true)
            SetNetworkIdCanMigrate(id, true)
        end

        -- unload veh model
        SetModelAsNoLongerNeeded(modelHash)

        -- request collisions around the location of the vehicle
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Wait(0)
		end

        p:resolve(vehicle)
	end)

    return Citizen.Await(p)
end


AVA.Vehicles.SpawnVehicleLocal = function(vehName, coords, heading)
	return AVA.Vehicles.SpawnVehicle(vehName, coords, heading, false)
end

AVA.Vehicles.DeleteVehicle = function(vehicle)
    if IsEntityAVehicle(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end

AVA.Vehicles.GetVehicleInFront = function(distance)
    local yOffset = distance
    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        yOffset = 4
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, yOffset + 0.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z, offsetCoords.x, offsetCoords.y, offsetCoords.z, 10, playerPed, 0)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    return IsEntityAVehicle(vehicle) and vehicle or 0
end