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

AVA.RequestModel = function(model)
    if IsModelValid(model) and not HasModelLoaded(GetHashKey(model)) then
        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do
            Wait(0)
        end
    end
end
exports("RequestModel", AVA.RequestModel)

AVA.RequestAnimDict = function(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end
    end
end
exports("RequestAnimDict", AVA.RequestAnimDict)

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
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(0)
        end

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

    return IsEntityAVehicle(vehicle) and vehicle or 0
end
exports("GetVehicleInFront", AVA.Vehicles.GetVehicleInFront)

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
        title = "Sélectionner un joueur"
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
                    label = player ~= playerId and ("Personne #%d"):format(entityCount) or "Moi",
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
        AVA.ShowNotification("Aucun joueur assez proche")
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
        title = "Sélectionner un véhicule"
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
            entitiesToSelect[entityCount] = {label = ("Véhicule #%d"):format(entityCount), entity = veh}
        end
    end

    if entityCount > 0 then
        local p = promise.new()
        SelectEntity(title, entitiesToSelect, function(entity)
            p:resolve(entity)
        end)

        local veh = Citizen.Await(p) or {}
        return veh.entity
    else
        AVA.ShowNotification("Aucun véhicule assez proche")
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

    local vehicle = AVA.Vehicles.GetVehicleInFront(distance)
    if vehicle == 0 then
        vehicle = AVA.Vehicles.ChooseClosestVehicle(title, distance)
    end
    return vehicle
end
exports("GetVehicleInFrontOrChooseClosest", AVA.Vehicles.GetVehicleInFrontOrChooseClosest)
