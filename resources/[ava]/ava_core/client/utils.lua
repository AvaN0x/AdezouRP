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
    return result or ""
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

AVA.ShowHelpNotification = function(text)
    AddTextEntry("AVA_NOTF_TE", text)
    BeginTextCommandDisplayHelp("AVA_NOTF_TE")
    EndTextCommandDisplayHelp(0, false, true, -1)
end
exports("ShowHelpNotification", AVA.ShowHelpNotification)

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

----------------------------------------
--------------- Vehicles ---------------
----------------------------------------

AVA.Vehicles = {}
---Spawn a vehicle at a given coords and heading
---@param vehName string|number
---@param coords vector3
---@param heading float
---@param isNetwork? boolean set the vehicle to be on network or only on local
---@return vehicle
AVA.Vehicles.SpawnVehicle = function(vehName, coords, heading, isNetwork)
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
exports("SpawnVehicle", AVA.Vehicles.SpawnVehicle)

---Spawn a vehicle at a given coords and heading on local
---@param vehName string|number
---@param coords vector3
---@param heading float
---@return vehicle
AVA.Vehicles.SpawnVehicleLocal = function(vehName, coords, heading)
    return AVA.Vehicles.SpawnVehicle(vehName, coords, heading, false)
end
exports("SpawnVehicleLocal", AVA.Vehicles.SpawnVehicleLocal)

---Delete a vehicle
---@param vehicle entity
AVA.Vehicles.DeleteVehicle = function(vehicle)
    if IsEntityAVehicle(vehicle) then
        AVA.NetworkRequestControlOfEntity(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
end
exports("DeleteVehicle", AVA.Vehicles.DeleteVehicle)

---Get the vehicle in front of the user
---@param distance? number
---@return entity 
AVA.Vehicles.GetVehicleInFront = function(distance)
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
exports("GetVehicleInFront", AVA.Vehicles.GetVehicleInFront)

---Get the closest vehicle
---@param maxDistance? number
---@param notPlayerVehicle? bool "does't count player vehicle"
---@return entity closestVeh
---@return number closestDistance 
AVA.Vehicles.GetClosestVehicle = function(maxDistance, notPlayerVehicle)
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

    return closestVeh, closestDistance
end
exports("GetClosestVehicle", AVA.Vehicles.GetClosestVehicle)

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
AVA.Utils.DrawText3D = function(x, y, z, text, size, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r or 255, g or 255, b or 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentString(text)
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
        AddTextEntry(GetCurrentResourceName(), text)
        BeginTextCommandDisplayHelp(GetCurrentResourceName())
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
                            RageUI.CloseAll()
                        end
                    end)

                    local targetCoords = GetEntityCoords(entity.entity)
                    DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.3, targetCoords.x, targetCoords.y, targetCoords.z + 0.3, 255, 128, 0, 128)
                    AVA.Utils.DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 0.3, entity.label, 0.3)
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
                    label = player ~= playerId and GetString("person_number", entityCount) or "Moi",
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
AVA.Vehicles.ChooseClosestVehicle = function(title, distance, whitelist, blacklist)
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
            entitiesToSelect[entityCount] = {label = GetString("vehicle_number", entityCount), entity = veh}
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
exports("ChooseClosestVehicle", AVA.Vehicles.ChooseClosestVehicle)

---Get the vehicle in front of the player, if none is found, it calls AVA.Vehicles.ChooseClosestVehicle to let the player select a vehicle close
---@param distance number
---@param title string
---@return vehicle vehicle
AVA.Vehicles.GetVehicleInFrontOrChooseClosest = function(distance, title)
    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        distance = 4.0
    else
        distance = distance + 0.0
    end

    local vehicle = AVA.Vehicles.GetClosestVehicle(distance)
    if vehicle == 0 then
        vehicle = AVA.Vehicles.ChooseClosestVehicle(title, distance)
    end
    return vehicle
end
exports("GetVehicleInFrontOrChooseClosest", AVA.Vehicles.GetVehicleInFrontOrChooseClosest)
