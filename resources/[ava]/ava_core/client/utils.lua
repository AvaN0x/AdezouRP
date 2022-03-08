-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
---Prompt the user a text
---@param titleText string
---@param defaultText? string
---@param maxLength? number
---@return string result prompted text
AVA.KeyboardInput = function(titleText, defaultText, maxLength)
    AddTextEntry("AVA_KYBRD_INPT", titleText or "")
    DisplayOnscreenKeyboard(1, "AVA_KYBRD_INPT", "", defaultText or "", "", "", "", maxLength or 255)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end

    local result = ""
    if UpdateOnscreenKeyboard() ~= 2 then
        result = tostring(GetOnscreenKeyboardResult())
    end
    Citizen.Wait(100)
    return AVA.Utils.Trim(result) or ""
end
exports("KeyboardInput", AVA.KeyboardInput)

---Show a feedpost to the user
---@param text string
---@param color? number
---@param textureName? string
---@param title? string
---@param subtitle? string
---@param iconType? number
---@param textureDict? string
---@return number notificationId
AVA.ShowNotification = function(text, color, textureName, title, subtitle, iconType, textureDict)
    local feedPostId
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
            while not HasStreamedTextureDictLoaded(textureDict) do
                Wait(0)
            end
        end
        feedPostId = EndTextCommandThefeedPostMessagetext(textureDict, textureName, false, iconType or 4, title, subtitle)
        SetStreamedTextureDictAsNoLongerNeeded(textureDict)
    else
        feedPostId = EndTextCommandThefeedPostTicker(false, true)
    end
    return feedPostId
end
exports("ShowNotification", AVA.ShowNotification)
RegisterNetEvent("ava_core:client:ShowNotification", AVA.ShowNotification)

local displayConfirmationMessage = false

---ASYNC
---Prompt the player with a confirmation message
---@param title string
---@param firstLine string
---@param secondLine string
---@param background boolean
---@param instructionalKey integer
---@return boolean
AVA.ShowConfirmationMessage = function(title, firstLine, secondLine, background, instructionalKey)
    AddTextEntry("AVA_SCM_TITLE", tostring(title) or "")
    AddTextEntry("AVA_SCM_FIRST_LINE", tostring(firstLine) or "")
    AddTextEntry("AVA_SCM_SECOND_LINE", tostring(secondLine) or "")

    local p = promise.new()

    Citizen.CreateThread(function()
        displayConfirmationMessage = true
        while displayConfirmationMessage do
            Wait(0)
            SetWarningMessageWithHeaderAndSubstringFlags("AVA_SCM_TITLE", "AVA_SCM_FIRST_LINE", instructionalKey or 36, "AVA_SCM_SECOND_LINE", false, 0, 0,
                background)

            DisableAllControlActions(2)
            if IsDisabledControlJustPressed(2, 201) or IsDisabledControlJustPressed(2, 217) then -- confirm
                p:resolve(true)
                return
            elseif IsDisabledControlJustPressed(2, 202) then -- cancel
                break
            end
        end
        p:resolve(false)
    end)

    return Citizen.Await(p)
end
exports("ShowConfirmationMessage", AVA.ShowConfirmationMessage)

---Hide previously opened confirmation message
---@return boolean "true if a confirmation message was opened"
AVA.ForceHideConfirmationMessage = function()
    if displayConfirmationMessage then
        displayConfirmationMessage = false
        return true
    end
    return false
end
exports("ForceHideConfirmationMessage", AVA.ForceHideConfirmationMessage)

AVA.ShowHelpNotification = function(text)
    AddTextEntry("AVA_NOTF_HELP", text)
    BeginTextCommandDisplayHelp("AVA_NOTF_HELP")
    EndTextCommandDisplayHelp(0, false, true, -1)
end
exports("ShowHelpNotification", AVA.ShowHelpNotification)

---Prepare a freemode message for the player
---It can be on top of the screen or in the middle
---@param title string "Top text"
---@param subtitle string "Bottom text"
---@param onTop boolean "true = on top, false = in the middle"
---@param duration number "Duration in milliseconds, if specified it will be shown for that amount of time the scaleform will be returned as a function result for the script to handle it
---@return integer|nil "Only returned if duration is not specified"
AVA.ShowFreemodeMessage = function(title, subtitle, onTop, duration)
    local scaleform = RequestScaleformMovie("mp_big_message_freemode")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, onTop and "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE" or "SHOW_SHARD_CENTERED_MP_MESSAGE")
    PushScaleformMovieMethodParameterString(title)
    PushScaleformMovieMethodParameterString(subtitle)
    -- PushScaleformMovieMethodParameterInt(1)
    EndScaleformMovieMethod()

    if duration and duration > 0 then
        Citizen.CreateThread(function()
            local loop = true
            SetTimeout(duration, function()
                loop = false
            end)
            while loop do
                Wait(0)
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
            end
            SetScaleformMovieAsNoLongerNeeded(scaleform)
        end)
    else
        return scaleform
    end
end
exports("ShowFreemodeMessage", AVA.ShowFreemodeMessage)

---Show a mission text to the player
---@param text string text to show
---@param duration? number|nil duration, defaults to 1000
AVA.DrawMissionText = function(text, duration)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text or "")
    EndTextCommandPrint(duration or 1000, true)
end
exports("DrawMissionText", AVA.DrawMissionText)

----------------------------------------
--------------- Requests ---------------
----------------------------------------

---Request control of an entity over network
---@param entity entity
AVA.NetworkRequestControlOfEntity = function(entity)
    if IsAnEntity(entity) and not NetworkHasControlOfEntity(entity) then
        NetworkRequestControlOfEntity(entity)
        while not NetworkHasControlOfEntity(entity) do
            Citizen.Wait(1)
        end
    end
end
exports("NetworkRequestControlOfEntity", AVA.NetworkRequestControlOfEntity)

---Request a model
---@param model string|number
AVA.RequestModel = function(model)
    model = type(model) == "number" and model or GetHashKey(model)
    if IsModelValid(model) and not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    end
end
exports("RequestModel", AVA.RequestModel)

---Request an animDict
---@param animDict string
AVA.RequestAnimDict = function(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
end
exports("RequestAnimDict", AVA.RequestAnimDict)

---Teleport a player to coords with or without vehicle
---@param x number
---@param y number
---@param z number
---@param allowVehicle boolean
AVA.TeleportPlayerToCoords = function(x, y, z, allowVehicle)
    if type(x) ~= "number" and type(x) ~= "number" and type(x) ~= "number" then
        return
    end

    local playerPed = PlayerPedId()
    x = x + 0.0
    y = y + 0.0
    z = z + 0.0

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    RequestCollisionAtCoord(x, y, z)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    -- only teleport vehicle if player is driver
    local doTeleportVehicle = allowVehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed

    if doTeleportVehicle then
        FreezeEntityPosition(vehicle, true)
        SetPedCoordsKeepVehicle(playerPed, x, y, z)
    else
        FreezeEntityPosition(playerPed, true)
        SetEntityCoords(playerPed, x, y, z)
    end

    while not HasCollisionLoadedAroundEntity(playerPed) do
        Wait(100)
    end

    if z == 0 then
        dprint("Looking for a new ground because z was 0.")

        -- make entity invisible when searching ground
        local wasVisible = IsEntityVisible(playerPed)
        if wasVisible then
            SetEntityVisible(playerPed, false)
        end

        for loopZ = 1, 1000, 1 do
            SetPedCoordsKeepVehicle(playerPed, x, y, loopZ + 0.0)
            local foundGround, zPos = GetGroundZFor_3dCoord(x, y, loopZ + 0.0)
            if foundGround then
                z = zPos + 0.0
                break
            end
            Wait(0)
        end

        -- if we are over 1000, then we teleport the player to the Z == 0 to, in most cases, make it fall in the ground and teleport back to the ground
        if z > 1000 then
            z = 0.0
        end

        if wasVisible then
            SetEntityVisible(playerPed, true)
        end

        SetPedCoordsKeepVehicle(playerPed, x, y, z)
    end

    if doTeleportVehicle then
        FreezeEntityPosition(vehicle, false)
    else
        FreezeEntityPosition(playerPed, false)
    end

    DoScreenFadeIn(500)
    SetGameplayCamRelativeHeading(0)
end
exports("TeleportPlayerToCoords", AVA.TeleportPlayerToCoords)

---------------------------------------
--------------- Objects ---------------
---------------------------------------

---Spawn an object at a given coords
---@param objectName string|number
---@param coords vector3
---@param isNetwork? boolean set the vehicle to be on network or only on local
---@return vehicle
AVA.SpawnObject = function(objectName, coords, isNetwork)
    local p = promise.new()
    isNetwork = (isNetwork == nil or isNetwork == true)

    Citizen.CreateThread(function()
        -- get vehicle model hash
        local modelHash = type(objectName) == "number" and objectName or GetHashKey(objectName)

        -- get object model
        AVA.RequestModel(modelHash)

        local obj = CreateObject(modelHash, coords.x, coords.y, coords.z, isNetwork, false, true)

        -- unload veh model
        SetModelAsNoLongerNeeded(modelHash)

        p:resolve(obj)
    end)

    return Citizen.Await(p)
end
exports("SpawnObject", AVA.SpawnObject)

---Spawn an object at a given coords on local
---@param objectName string|number
---@param coords vector3
---@return vehicle
AVA.SpawnObjectLocal = function(objectName, coords)
    return AVA.SpawnObject(objectName, coords, false)
end
exports("SpawnObjectLocal", AVA.SpawnObjectLocal)

---Delete an object
---@param object any
AVA.DeleteObject = function(object)
    if GetEntityType(object) == 3 then -- is entity an object
        SetEntityAsMissionEntity(object, false, true)
        DeleteObject(object)
    end
end
exports("DeleteObject", AVA.DeleteObject)

----------------------------------------
--------------- Vehicles ---------------
----------------------------------------

---Spawn a vehicle at a given coords and heading
---@param vehName string|number
---@param coords vector3
---@param heading float
---@param isNetwork? boolean set the vehicle to be on network or only on local
---@return vehicle
AVA.SpawnVehicle = function(vehName, coords, heading, isNetwork)
    local p = promise.new()
    isNetwork = (isNetwork == nil or isNetwork == true)

    Citizen.CreateThread(function()
        -- get vehicle model hash
        local modelHash = type(vehName) == "number" and vehName or GetHashKey(vehName)

        -- get vehicle model
        AVA.RequestModel(modelHash)

        local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, isNetwork, false)
        -- init vehicle
        SetVehicleOnGroundProperly(vehicle)

        SetEntityAsMissionEntity(vehicle, true, false)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetVehicleIsWanted(vehicle, false)
        SetVehRadioStation(vehicle, "OFF")

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
exports("SpawnVehicle", AVA.SpawnVehicle)

---Spawn a vehicle at a given coords and heading on local
---@param vehName string|number
---@param coords vector3
---@param heading float
---@return vehicle
AVA.SpawnVehicleLocal = function(vehName, coords, heading)
    return AVA.SpawnVehicle(vehName, coords, heading, false)
end
exports("SpawnVehicleLocal", AVA.SpawnVehicleLocal)

---Delete a vehicle
---@param vehicle entity
AVA.DeleteVehicle = function(vehicle)
    if IsEntityAVehicle(vehicle) then
        AVA.NetworkRequestControlOfEntity(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end
exports("DeleteVehicle", AVA.DeleteVehicle)

---Get vehicle data, mod, extras, etc...
---@param vehicle integer
---@return table
AVA.GetVehicleModsData = function(vehicle)
    if not IsEntityAVehicle(vehicle) then
        return
    end

    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelsColor = GetVehicleExtraColours(vehicle)

    if GetIsVehiclePrimaryColourCustom(vehicle) then
        colorPrimary = { GetVehicleCustomPrimaryColour(vehicle) }
    end
    if GetIsVehicleSecondaryColourCustom(vehicle) then
        colorSecondary = { GetVehicleCustomSecondaryColour(vehicle) }
    end

    local extras = {}
    for i = 0, 14 do
        if DoesExtraExist(vehicle, i) then
            extras[tostring(i)] = IsVehicleExtraTurnedOn(vehicle, i) and 0 or 1
        end
    end

    return {
        model = GetEntityModel(vehicle),
        extras = extras,
        livery = GetVehicleLivery(vehicle),

        -- plate
        plate = GetVehicleNumberPlateText(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle),

        -- colors
        colorPrimary = colorPrimary,
        colorSecondary = colorSecondary,
        pearlescentColor = pearlescentColor,
        interiorColor = GetVehicleInteriorColor(vehicle),
        dashboardColor = GetVehicleDashboardColour(vehicle),

        -- wheels
        wheelsColor = wheelsColor,
        wheels = GetVehicleWheelType(vehicle),
        tyreSmokeColor = { GetVehicleTyreSmokeColor(vehicle) },

        windowTint = GetVehicleWindowTint(vehicle),

        neonColor = { GetVehicleNeonLightsColour(vehicle) },
        neonEnabled = {
            IsVehicleNeonLightEnabled(vehicle, 0),
            IsVehicleNeonLightEnabled(vehicle, 1),
            IsVehicleNeonLightEnabled(vehicle, 2),
            IsVehicleNeonLightEnabled(vehicle, 3),
        },

        modSpoilers = GetVehicleMod(vehicle, 0),
        modFrontBumper = GetVehicleMod(vehicle, 1),
        modRearBumper = GetVehicleMod(vehicle, 2),
        modSideSkirt = GetVehicleMod(vehicle, 3),
        modExhaust = GetVehicleMod(vehicle, 4),
        modFrame = GetVehicleMod(vehicle, 5),
        modGrille = GetVehicleMod(vehicle, 6),
        modHood = GetVehicleMod(vehicle, 7),
        modFender = GetVehicleMod(vehicle, 8),
        modRightFender = GetVehicleMod(vehicle, 9),
        modRoof = GetVehicleMod(vehicle, 10),

        modHorns = GetVehicleMod(vehicle, 14),

        modEngine = GetVehicleMod(vehicle, 11),
        modBrakes = GetVehicleMod(vehicle, 12),
        modTransmission = GetVehicleMod(vehicle, 13),
        modSuspension = GetVehicleMod(vehicle, 15),
        modArmor = GetVehicleMod(vehicle, 16),
        modTurbo = IsToggleModOn(vehicle, 18),

        modSmokeEnabled = IsToggleModOn(vehicle, 20),
        modXenon = IsToggleModOn(vehicle, 22),
        modXenonColour = GetVehicleXenonLightsColour(vehicle),

        modFrontWheels = GetVehicleMod(vehicle, 23),
        modCustomTiresF = GetVehicleModVariation(vehicle, 23),
        modBackWheels = GetVehicleMod(vehicle, 24),
        modCustomTiresR = GetVehicleModVariation(vehicle, 24),

        modPlateHolder = GetVehicleMod(vehicle, 25),
        modVanityPlate = GetVehicleMod(vehicle, 26),

        modTrimA = GetVehicleMod(vehicle, 27),
        modTrimB = GetVehicleMod(vehicle, 44),
        modOrnaments = GetVehicleMod(vehicle, 28),
        modDashboard = GetVehicleMod(vehicle, 29),
        modDial = GetVehicleMod(vehicle, 30),
        modDoorSpeaker = GetVehicleMod(vehicle, 31),
        modSeats = GetVehicleMod(vehicle, 32),
        modSteeringWheel = GetVehicleMod(vehicle, 33),
        modShifterLeavers = GetVehicleMod(vehicle, 34),
        modPlaques = GetVehicleMod(vehicle, 35),
        modSpeakers = GetVehicleMod(vehicle, 36),
        modTrunk = GetVehicleMod(vehicle, 37),
        modHydraulics = GetVehicleMod(vehicle, 38),
        modEngineBlock = GetVehicleMod(vehicle, 39),
        modAirFilter = GetVehicleMod(vehicle, 40),
        modStruts = GetVehicleMod(vehicle, 41),
        modArchCover = GetVehicleMod(vehicle, 42),
        modAerials = GetVehicleMod(vehicle, 43),
        modTank = GetVehicleMod(vehicle, 45),
        modWindows = GetVehicleMod(vehicle, 46),
        modDoorR = GetVehicleMod(vehicle, 47),
        modLivery = GetVehicleMod(vehicle, 48),
        modLightbar = GetVehicleMod(vehicle, 49),

        -- modDriftTyres = GetDriftTyresEnabled(vehicle), -- Disabled
    }
end
exports("GetVehicleModsData", AVA.GetVehicleModsData)

---Set vehicle data, mod, extras, etc...
---@param vehicle integer
---@param data table
AVA.SetVehicleModsData = function(vehicle, data)
    if not IsEntityAVehicle(vehicle) or type(data) ~= "table" then
        return
    end
    SetVehicleModKit(vehicle, 0)

    if data.extras then
        for id, disable in pairs(data.extras) do
            SetVehicleExtra(vehicle, tonumber(id), disable)
        end
    end
    if data.livery then
        SetVehicleLivery(vehicle, data.livery)
    end
    if data.plate then
        SetVehicleNumberPlateText(vehicle, data.plate)
    end
    if data.plateIndex then
        SetVehicleNumberPlateTextIndex(vehicle, data.plateIndex)
    end
    local colorPrimary<const>, colorSecondary<const> = GetVehicleColours(vehicle)
    if data.colorPrimary then
        if type(data.colorPrimary) == "table" then
            SetVehicleCustomPrimaryColour(vehicle, data.colorPrimary[1], data.colorPrimary[2], data.colorPrimary[3])
        else
            SetVehicleColours(vehicle, data.colorPrimary, colorSecondary)
        end
    end
    if data.colorSecondary then
        if type(data.colorSecondary) == "table" then
            SetVehicleCustomSecondaryColour(vehicle, data.colorSecondary[1], data.colorSecondary[2], data.colorSecondary[3])
        else
            SetVehicleColours(vehicle, data.colorPrimary or colorPrimary, data.colorSecondary)
        end
    end
    local pearlescentColor<const>, wheelsColor<const> = GetVehicleExtraColours(vehicle)
    if data.pearlescentColor then
        SetVehicleExtraColours(vehicle, data.pearlescentColor, wheelsColor)
    end
    if data.wheelsColor then
        SetVehicleExtraColours(vehicle, data.pearlescentColor or pearlescentColor, data.wheelsColor)
    end
    if data.interiorColor then
        SetVehicleInteriorColor(vehicle, data.interiorColor)
    end
    if data.dashboardColor then
        SetVehicleDashboardColour(vehicle, data.dashboardColor)
    end
    if data.wheels then
        SetVehicleWheelType(vehicle, data.wheels)
    end
    if data.tyreSmokeColor then
        SetVehicleTyreSmokeColor(vehicle, data.tyreSmokeColor[1], data.tyreSmokeColor[2], data.tyreSmokeColor[3])
    end
    if data.windowTint then
        SetVehicleWindowTint(vehicle, data.windowTint)
    end
    if data.neonColor then
        SetVehicleNeonLightsColour(vehicle, data.neonColor[1], data.neonColor[2], data.neonColor[3])
    end
    if data.neonEnabled then
        for i = 0, #data.neonEnabled - 1 do
            SetVehicleNeonLightEnabled(vehicle, i, data.neonEnabled[i + 1])
        end
    end
    if data.modSpoilers then
        SetVehicleMod(vehicle, 0, data.modSpoilers, false)
    end
    if data.modFrontBumper then
        SetVehicleMod(vehicle, 1, data.modFrontBumper, false)
    end
    if data.modRearBumper then
        SetVehicleMod(vehicle, 2, data.modRearBumper, false)
    end
    if data.modSideSkirt then
        SetVehicleMod(vehicle, 3, data.modSideSkirt, false)
    end
    if data.modExhaust then
        SetVehicleMod(vehicle, 4, data.modExhaust, false)
    end
    if data.modFrame then
        SetVehicleMod(vehicle, 5, data.modFrame, false)
    end
    if data.modGrille then
        SetVehicleMod(vehicle, 6, data.modGrille, false)
    end
    if data.modHood then
        SetVehicleMod(vehicle, 7, data.modHood, false)
    end
    if data.modFender then
        SetVehicleMod(vehicle, 8, data.modFender, false)
    end
    if data.modRightFender then
        SetVehicleMod(vehicle, 9, data.modRightFender, false)
    end
    if data.modRoof then
        SetVehicleMod(vehicle, 10, data.modRoof, false)
    end
    if data.modHorns then
        SetVehicleMod(vehicle, 14, data.modHorns, false)
    end
    if data.modEngine then
        SetVehicleMod(vehicle, 11, data.modEngine, false)
    end
    if data.modBrakes then
        SetVehicleMod(vehicle, 12, data.modBrakes, false)
    end
    if data.modTransmission then
        SetVehicleMod(vehicle, 13, data.modTransmission, false)
    end
    if data.modSuspension then
        SetVehicleMod(vehicle, 15, data.modSuspension, false)
    end
    if data.modArmor then
        SetVehicleMod(vehicle, 16, data.modArmor, false)
    end
    if data.modTurbo then
        ToggleVehicleMod(vehicle, 18, data.modTurbo)
    end
    if data.modSmokeEnabled then
        ToggleVehicleMod(vehicle, 20, data.modSmokeEnabled)
    end
    if data.modXenon then
        ToggleVehicleMod(vehicle, 22, data.modXenon)
    end
    if data.modXenonColour then
        SetVehicleXenonLightsColour(vehicle, data.modXenonColour)
    end
    if data.modFrontWheels then
        SetVehicleMod(vehicle, 23, data.modFrontWheels, data.modCustomTiresF or false)
    end
    if data.modBackWheels then
        SetVehicleMod(vehicle, 24, data.modBackWheels, data.modCustomTiresR or false)
    end
    if data.modPlateHolder then
        SetVehicleMod(vehicle, 25, data.modPlateHolder, false)
    end
    if data.modVanityPlate then
        SetVehicleMod(vehicle, 26, data.modVanityPlate, false)
    end
    if data.modTrimA then
        SetVehicleMod(vehicle, 27, data.modTrimA, false)
    end
    if data.modTrimB then
        SetVehicleMod(vehicle, 27, data.modTrimB, false)
    end
    if data.modOrnaments then
        SetVehicleMod(vehicle, 28, data.modOrnaments, false)
    end
    if data.modDashboard then
        SetVehicleMod(vehicle, 29, data.modDashboard, false)
    end
    if data.modDial then
        SetVehicleMod(vehicle, 30, data.modDial, false)
    end
    if data.modDoorSpeaker then
        SetVehicleMod(vehicle, 31, data.modDoorSpeaker, false)
    end
    if data.modSeats then
        SetVehicleMod(vehicle, 32, data.modSeats, false)
    end
    if data.modSteeringWheel then
        SetVehicleMod(vehicle, 33, data.modSteeringWheel, false)
    end
    if data.modShifterLeavers then
        SetVehicleMod(vehicle, 34, data.modShifterLeavers, false)
    end
    if data.modPlaques then
        SetVehicleMod(vehicle, 35, data.modPlaques, false)
    end
    if data.modSpeakers then
        SetVehicleMod(vehicle, 36, data.modSpeakers, false)
    end
    if data.modTrunk then
        SetVehicleMod(vehicle, 37, data.modTrunk, false)
    end
    if data.modHydraulics then
        SetVehicleMod(vehicle, 38, data.modHydraulics, false)
    end
    if data.modEngineBlock then
        SetVehicleMod(vehicle, 39, data.modEngineBlock, false)
    end
    if data.modAirFilter then
        SetVehicleMod(vehicle, 40, data.modAirFilter, false)
    end
    if data.modStruts then
        SetVehicleMod(vehicle, 41, data.modStruts, false)
    end
    if data.modArchCover then
        SetVehicleMod(vehicle, 42, data.modArchCover, false)
    end
    if data.modAerials then
        SetVehicleMod(vehicle, 43, data.modAerials, false)
    end
    if data.modTank then
        SetVehicleMod(vehicle, 45, data.modTank, false)
    end
    if data.modWindows then
        SetVehicleMod(vehicle, 46, data.modWindows, false)
    end
    if data.modDoorR then
        SetVehicleMod(vehicle, 47, data.modDoorR, false)
    end
    if data.modLivery then
        SetVehicleMod(vehicle, 48, data.modLivery, false)
    end
    if data.modLightbar then
        SetVehicleMod(vehicle, 49, data.modLightbar, false)
    end
end
exports("SetVehicleModsData", AVA.SetVehicleModsData)

---Get vehicle health data, damaged parts...
---@param vehicle integer
---@return table
AVA.GetVehicleHealthData = function(vehicle)
    if not IsEntityAVehicle(vehicle) then
        return
    end

    return {
        -- health, rounded to nearest integer
        bodyHealth = math.floor(GetVehicleBodyHealth(vehicle) + 0.5),
        engineHealth = math.floor(GetVehicleEngineHealth(vehicle) + 0.5),
        tankHealth = math.floor(GetVehiclePetrolTankHealth(vehicle) + 0.5),
        fuelLevel = math.floor(GetVehicleFuelLevel(vehicle) + 0.5),
        dirtLevel = math.floor(GetVehicleDirtLevel(vehicle) + 0.5),

        -- 1 is intact, 0 is broken
        windowsStates = {
            IsVehicleWindowIntact(vehicle, 0) and 1 or 0, -- VEH_EXT_WINDSCREEN
            IsVehicleWindowIntact(vehicle, 1) and 1 or 0, -- VEH_EXT_WINDSCREEN_R
            IsVehicleWindowIntact(vehicle, 2) and 1 or 0, -- VEH_EXT_WINDOW_LF
            IsVehicleWindowIntact(vehicle, 3) and 1 or 0, -- VEH_EXT_WINDOW_RF
            IsVehicleWindowIntact(vehicle, 4) and 1 or 0, -- VEH_EXT_WINDOW_LR
            IsVehicleWindowIntact(vehicle, 5) and 1 or 0, -- VEH_EXT_WINDOW_RR
            IsVehicleWindowIntact(vehicle, 6) and 1 or 0, -- VEH_EXT_WINDOW_LM
            IsVehicleWindowIntact(vehicle, 7) and 1 or 0, -- VEH_EXT_WINDOW_RM
        },
        -- 1 is burst, 0 is not
        wheelsStates = {
            IsVehicleTyreBurst(vehicle, 0, false) and 1 or 0, -- wheel_lf
            IsVehicleTyreBurst(vehicle, 1, false) and 1 or 0, -- wheel_rf
            IsVehicleTyreBurst(vehicle, 2, false) and 1 or 0, -- wheel_lm
            IsVehicleTyreBurst(vehicle, 3, false) and 1 or 0, -- wheel_rm
            IsVehicleTyreBurst(vehicle, 4, false) and 1 or 0, -- wheel_lr
            IsVehicleTyreBurst(vehicle, 5, false) and 1 or 0, -- wheel_rr
        },
        -- 1 is broken, 0 is not
        doorsStates = {
            IsVehicleDoorDamaged(vehicle, 0) and 1 or 0, -- VEH_EXT_DOOR_DSIDE_F
            IsVehicleDoorDamaged(vehicle, 1) and 1 or 0, -- VEH_EXT_DOOR_DSIDE_R
            IsVehicleDoorDamaged(vehicle, 2) and 1 or 0, -- VEH_EXT_DOOR_PSIDE_F
            IsVehicleDoorDamaged(vehicle, 3) and 1 or 0, -- VEH_EXT_DOOR_PSIDE_R
            IsVehicleDoorDamaged(vehicle, 4) and 1 or 0, -- VEH_EXT_BONNET
            IsVehicleDoorDamaged(vehicle, 5) and 1 or 0, -- VEH_EXT_BOOT
        },
    }
end
exports("GetVehicleHealthData", AVA.GetVehicleHealthData)

---Set vehicle health data, damaged parts...
---@param vehicle integer
---@param data table
AVA.SetVehicleHealthData = function(vehicle, data)
    if not IsEntityAVehicle(vehicle) or type(data) ~= "table" then
        return
    end

    if data.bodyHealth then
        SetVehicleBodyHealth(vehicle, data.bodyHealth + 0.0)
    end
    if data.engineHealth then
        SetVehicleEngineHealth(vehicle, data.engineHealth + 0.0)
    end
    if data.tankHealth then
        SetVehiclePetrolTankHealth(vehicle, data.engineHealth + 0.0)
    end
    if data.fuelLevel then
        SetVehicleFuelLevel(vehicle, data.fuelLevel + 0.0)
    end
    if data.dirtLevel then
        SetVehicleDirtLevel(vehicle, data.dirtLevel + 0.0)
    end
    if data.windowsStates then
        for i = 0, #data.windowsStates - 1 do
            if data.windowsStates[i + 1] == 0 then
                SmashVehicleWindow(vehicle, i)
            end
        end
    end
    if data.wheelsStates then
        for i = 0, #data.wheelsStates - 1 do
            if data.wheelsStates[i + 1] == 1 then
                SetVehicleTyreBurst(vehicle, i, false, 1000.0)
            end
        end
    end
    if data.doorsStates then
        for i = 0, #data.doorsStates - 1 do
            if data.doorsStates[i + 1] == 1 then
                SetVehicleDoorBroken(vehicle, i, true)
            end
        end
    end
end
exports("SetVehicleHealthData", AVA.SetVehicleHealthData)

---Get the vehicle in front of the user
---@param distance? number
---@return entity 
AVA.GetVehicleInFront = function(distance)
    local yOffset = distance
    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        yOffset = 4
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, yOffset + 0.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z, offsetCoords.x, offsetCoords.y, offsetCoords.z,
        10, playerPed, 0)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    if IsEntityAVehicle(vehicle) then
        AVA.NetworkRequestControlOfEntity(vehicle)
        return vehicle
    end
    return 0
end
exports("GetVehicleInFront", AVA.GetVehicleInFront)

---Get the closest vehicle
---@param maxDistance? number
---@param notPlayerVehicle? bool "does't count player vehicle"
---@return entity closestVeh
---@return number closestDistance 
AVA.GetClosestVehicle = function(maxDistance, notPlayerVehicle)
    if maxDistance and tonumber(maxDistance) and tonumber(maxDistance) > 0 then
        maxDistance = maxDistance + 0.0
    end
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerVeh = notPlayerVehicle and GetVehiclePedIsIn(playerPed, false) or 0
    local closestVeh, closestDistance = 0, nil

    for _, v in ipairs(GetGamePool("CVehicle")) do
        local veh = GetObjectIndexFromEntityIndex(v)
        local vehCoords = GetEntityCoords(veh)
        local distance = #(playerCoords - vehCoords)
        if (not maxDistance or distance < maxDistance) and (not closestDistance or distance < closestDistance) and veh ~= playerVeh then
            closestVeh = veh
            closestDistance = distance
        end
    end

    if IsEntityAVehicle(closestVeh) then
        AVA.NetworkRequestControlOfEntity(closestVeh)
        return closestVeh, closestDistance
    end
    return 0
end
exports("GetClosestVehicle", AVA.GetClosestVehicle)

---use example : 
---```lua
---     local instructionalButtons = exports.ava_core:GetScaleformInstructionalButtons({{control = "~INPUT_AIM~", label = "Aim"}})
---     DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)
---```
---to optimise it you can call the export outside of a loop
---@param buttons table {{control: string, label: string}}
---@return any scaleform
AVA.Utils.GetScaleformInstructionalButtons = function(buttons)
    local instructionScaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(instructionScaleform) do
        Wait(0)
    end

    PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
    PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
    PushScaleformMovieFunctionParameterBool(0)
    PopScaleformMovieFunctionVoid()

    for i = 1, #buttons, 1 do
        PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(i - 1)

        PushScaleformMovieMethodParameterButtonName(buttons[i].control)
        PushScaleformMovieFunctionParameterString(buttons[i].label)
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PushScaleformMovieFunctionParameterInt(-1)
    PopScaleformMovieFunctionVoid()

    return instructionScaleform
end
exports("GetScaleformInstructionalButtons", AVA.Utils.GetScaleformInstructionalButtons)

---Draw a text on screen
---@param x number
---@param y number
---@param z number
---@param text string
---@param size? number
---@param r? number
---@param g? number
---@param b? number
---@param a? number
AVA.Utils.DrawText3D = function(x, y, z, text, size, r, g, b, a)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r or 255, g or 255, b or 255, a or 215)
        SetTextEntry("STRING")
        AddTextComponentSubstringPlayerName(text)
        SetTextCentre(1)
        SetTextOutline()

        EndTextCommandDisplayText(_x, _y)
    end
end
exports("DrawText3D", AVA.Utils.DrawText3D)

---Draw a "bubble" like text, only one can be displayed at a time
---@param x nulber
---@param y nulber
---@param z nulber
---@param text string
---@param backgroundColor? number
---@param bubbleStyle? number
AVA.Utils.DrawBubbleText3D = function(x, y, z, text, backgroundColor, bubbleStyle)
    local onScreen = World3dToScreen2d(x, y, z)
    if onScreen then
        AddTextEntry("AVA_DRW_BBLT3D", text)
        BeginTextCommandDisplayHelp("AVA_DRW_BBLT3D")
        EndTextCommandDisplayHelp(2, false, false, -1)
        SetFloatingHelpTextWorldPosition(1, x, y, z)

        local backgroundColor = backgroundColor or 15 -- see https://pastebin.com/d9aHPbXN
        local bubbleStyle = bubbleStyle or 3
        -- -1 centered, no triangles
        -- 0 left, no triangles
        -- 1 centered, triangle top
        -- 2 left, triangle left
        -- 3 centered, triangle bottom
        -- 4 right, triangle right
        SetFloatingHelpTextStyle(1, 1, backgroundColor, -1, bubbleStyle, 0)
    end
end
exports("DrawBubbleText3D", AVA.Utils.DrawBubbleText3D)

---TaskGoStraightToCoord which let the user cancel it when trying to move
---@param ped ped
---@param coords vector3
---@param speed number
---@param timeout number
---@param targetHeading number
---@param distanceToSlide number
---@return boolean success player is at coords or canceled
AVA.Utils.CancelableGoStraightToCoord = function(ped, coords, speed, timeout, targetHeading, distanceToSlide)
    TaskGoStraightToCoord(ped, coords.x, coords.y, coords.z, speed, timeout, targetHeading, distanceToSlide)

    local checkControls = ped == PlayerPedId()
    -- 0x7D8F4411 is TaskGoStraightToCoord
    while GetScriptTaskStatus(ped, 0x7D8F4411) ~= 7 do
        if checkControls then
            if IsControlJustPressed(0, 32) or IsControlJustPressed(0, 33) or IsControlJustPressed(0, 34) or IsControlJustPressed(0, 35) then
                ClearPedTasks(ped)
                return false
            end
        end

        Citizen.Wait(0)
    end

    return true
end
exports("CancelableGoStraightToCoord", AVA.Utils.CancelableGoStraightToCoord)

local function SelectEntity(title, entitiesToSelect, cb)
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local selectedEntity = nil

        local SelectEntityMenu = RageUI.CreateMenu("", title or "", 0, 0, "avaui", "avaui_title_adezou")
        local isMenuVisible = true

        RageUI.PoolMenus.AvaCoreSelectEntity = function()
            local menuVisible = false
            SelectEntityMenu:IsVisible(function(Item)
                menuVisible = true
                local playerCoords = GetEntityCoords(playerPed)
                for i = 1, #entitiesToSelect, 1 do
                    local entity = entitiesToSelect[i]
                    Items:AddButton(entity.label, nil, nil, function(onSelected)
                        if onSelected then
                            selectedEntity = entity
                            RageUI.CloseAllInternal()
                        end
                    end)

                    local targetCoords = GetEntityCoords(entity.entity)
                    DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.15, targetCoords.x, targetCoords.y, targetCoords.z + 0.15, 255, 128, 0, 196)
                    AVA.Utils.DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 0.3, entity.text3d or entity.label, 0.35, nil, nil, nil, 255)
                end
            end)
            if not menuVisible then
                isMenuVisible = false
            end
        end
        RageUI.Visible(SelectEntityMenu, true)

        while isMenuVisible do
            Wait(10)
        end
        RageUI.PoolMenus.AvaCoreSelectEntity = nil
        SelectEntityMenu = nil

        cb(selectedEntity)
    end)
end

---Open a menu to select a player inside
---## WARNING
---**This have to be called inside of a thread, or everything excepted a RageUI callback**
---@param title? string
---@param distance? number
---@param allowMyself? boolean
---@return number playerLocalId
---@return number playerServerId
AVA.Utils.ChooseClosestPlayer = function(title, distance, allowMyself)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerId = PlayerId()

    if not title or title == "" then
        title = GetString("select_a_person")
    end
    if not distance or not tonumber(distance) or tonumber(distance) <= 0 then
        distance = 3.0
    else
        distance = distance + 0.0
    end

    local entitiesToSelect = {}

    local entityCount = 0
    for _, player in ipairs(GetActivePlayers()) do
        if player ~= playerId or allowMyself then
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            if #(playerCoords - targetCoords) < distance then
                entityCount = entityCount + 1
                entitiesToSelect[entityCount] = {
                    entity = targetPed,
                    localId = player,
                    serverId = GetPlayerServerId(player),
                    label = player ~= playerId and GetString("person_number", entityCount) or GetString("me"),
                    text3d = player ~= playerId and GetString("text3d_person_number", entityCount) or GetString("text3d_me"),
                }
            end
        end
    end

    if entityCount > 0 then
        local p = promise.new()
        SelectEntity(title, entitiesToSelect, function(entity)
            p:resolve(entity)
        end)

        local player = Citizen.Await(p) or {}
        return player.serverId, player.localId
    else
        AVA.ShowNotification(GetString("no_persons_close_enough"))
    end
end
exports("ChooseClosestPlayer", AVA.Utils.ChooseClosestPlayer)

---Open a menu to select a player inside
---## WARNING
---**This have to be called inside of a thread, or everything excepted a RageUI callback**
---@param title? string
---@param distance? number
---@param whitelist? table table of hashes to whitelist
---@param blacklsit? table table of hashes to blacklist
---@return vehicle vehicle
AVA.ChooseClosestVehicle = function(title, distance, whitelist, blacklist)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if not title or title == "" then
        title = GetString("select_a_vehicle")
    end
    if not distance or not tonumber(distance) or tonumber(distance) <= 0 then
        distance = 5.0
    else
        distance = distance + 0.0
    end

    local entitiesToSelect = {}
    local entityCount = 0

    for _, v in ipairs(GetGamePool("CVehicle")) do
        local veh = GetObjectIndexFromEntityIndex(v)
        local vehCoords = GetEntityCoords(veh)
        local vehModel = GetEntityModel(veh)
        if #(playerCoords - vehCoords) < distance + 0.0 and (whitelist == nil or #whitelist == 0 or AVA.Utils.TableHasValue(whitelist, vehModel))
            and (blacklist == nil or #blacklist == 0 or not AVA.Utils.TableHasValue(blacklist, vehModel)) then
            entityCount = entityCount + 1
            entitiesToSelect[entityCount] = { label = GetString("vehicle_number", entityCount), entity = veh }
        end
    end

    if entityCount > 0 then
        local p = promise.new()
        SelectEntity(title, entitiesToSelect, function(entity)
            p:resolve(entity)
        end)

        local veh = Citizen.Await(p) or {}
        AVA.NetworkRequestControlOfEntity(veh.entity)
        return veh.entity
    else
        AVA.ShowNotification(GetString("no_vehicle_close_enough"))
    end
end
exports("ChooseClosestVehicle", AVA.ChooseClosestVehicle)

---Get the vehicle in front of the player, if none is found, it calls AVA.ChooseClosestVehicle to let the player select a vehicle close
---@param distance number
---@param title string
---@return vehicle vehicle
AVA.GetVehicleInFrontOrChooseClosest = function(distance, title)
    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        distance = 4.0
    else
        distance = distance + 0.0
    end

    local vehicle = AVA.GetClosestVehicle(distance)
    if vehicle == 0 then
        vehicle = AVA.ChooseClosestVehicle(title, distance)
    end
    return vehicle
end
exports("GetVehicleInFrontOrChooseClosest", AVA.GetVehicleInFrontOrChooseClosest)
