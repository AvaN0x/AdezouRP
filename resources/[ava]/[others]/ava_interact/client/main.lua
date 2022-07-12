-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local TimeLastAction = 0
local checkCanInteract
---Models that the player can interact with
local Models = {}
---Specific zones that the player can interact with
local Zones = {}

local Interactions = {}
local closestIndex = nil

local playerCoords = nil
local playerPed = nil
local IsDead = false

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)

        -- Loop to update coords if needed and check if player can interact
        for i = 1, #Interactions do
            local interaction = Interactions[i]
            if interaction then
                checkCanInteract(interaction)
                if interaction.entity then
                    interaction.coords = GetOffsetFromEntityInWorldCoords(interaction.entity, interaction.data.offset.x,
                        interaction.data.offset.y, interaction.data.offset.z)
                end
            end
        end
        Wait(300)
    end
end)

AddEventHandler("ava_core:client:playerIsDead", function(isDead)
    IsDead = isDead
end)

function checkCanInteract(interaction)
    if interaction.data.canInteract then
        interaction._canInteract = interaction.data.canInteract(interaction.entity)
    end
    return interaction._canInteract
end

Citizen.CreateThread(function()
    while true do
        local interactions = {}
        local count = 0
        local checkCount = 0

        local gamePool <const> = GetGamePool("CObject")
        for i = 1, #gamePool do
            local entity = GetObjectIndexFromEntityIndex(gamePool[i])
            local model = GetEntityModel(entity)

            if Models[model] then
                for j = 1, #Models[model] do
                    local data <const> = Models[model][j]
                    if data then
                        local entityCoords = GetOffsetFromEntityInWorldCoords(entity, data.offset.x, data.offset.y,
                            data.offset.z)
                        if #(playerCoords - entityCoords) < AVAConfig.CheckDistance then
                            count += 1
                            interactions[count] = {
                                entity = entity,
                                model = model,
                                coords = entityCoords,
                                _canInteract = true,
                                data = data
                            }
                            checkCanInteract(interactions[count])
                        end

                    end
                end
            end

            -- Wait a frame if needed to lighten the CPU usage
            checkCount += 1
            if checkCount % 500 == 0 then
                Wait(0)
            end
        end

        for i = 1, #Zones do
            local data = Zones[i]
            if data then
                if #(playerCoords - data.coords) < AVAConfig.CheckDistance then
                    count += 1
                    interactions[count] = {
                        _canInteract = true,
                        coords = data.coords,
                        data = data
                    }
                    checkCanInteract(interactions[count])
                end

                -- Wait a frame if needed to lighten the CPU usage
                checkCount += 1
                if checkCount % 500 == 0 then
                    Wait(0)
                end
            end
        end

        Interactions = interactions
        Wait(AVAConfig.CheckInterval)
    end
end)

local function Interact(interaction)
    local data <const> = interaction.data

    if data.action then
        data.action(interaction.entity)
    elseif data.event then
        TriggerEvent(data.event, interaction.entity, data, interaction.model)
    elseif data.serverEvent then
        TriggerServerEvent(data.serverEvent, interaction.entity, data, interaction.model)
    elseif data.command then
        ExecuteCommand(data.command)
    else
        print(("Interacting with %s (model: %s, entity: %s) but missing any action."):format(data.label,
            interaction.model, interaction.entity))
    end
end

Citizen.CreateThread(function()
    local MarkerData <const> = {
        r = 115,
        g = 173,
        b = 93,
        a = 155,
        size = 0.10,
    }
    local ClosestMarkerData <const> = {
        r = 255,
        g = 133,
        b = 85,
        a = 155,
        size = 0.15,
    }
    while true do
        local wait = 100

        local _closestIndex = nil
        local closestDistance = nil
        for i = 1, #Interactions do
            local interaction <const> = Interactions[i]
            if interaction and interaction._canInteract then
                local data <const> = interaction.data
                local coords <const> = interaction.coords

                local distance <const> = #(playerCoords - interaction.coords)
                if distance < data.drawDistance then
                    wait = 0
                    local isClosest <const> = i == closestIndex

                    if data.marker then
                        local markerData = isClosest and ClosestMarkerData or MarkerData
                        DrawMarker(data.marker, interaction.coords.x, interaction.coords.y, interaction.coords.z, 0.0,
                            0.0, 0.0, 0.0, 180.0, 0.0,
                            markerData.size, markerData.size, markerData.size, markerData.r, markerData.g, markerData.b,
                            markerData.a, false, false, 2, true, false, false, false)
                    end

                    if distance < data.distance then
                        -- DrawText3D(interaction.coords.x, interaction.coords.y, interaction.coords.z + 0.2, data.label)

                        if not closestDistance or distance < closestDistance then
                            closestDistance = distance
                            _closestIndex = i
                        end
                    end
                end
            end
        end

        if closestIndex and not IsDead then
            local interaction <const> = Interactions[closestIndex]
            if interaction and interaction._canInteract then
                -- Help text
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName(("~%s~ %s"):format(interaction.data.control.Name,
                    interaction.data.label))
                EndTextCommandDisplayHelp(0, false, true, -1)

                -- Interaction
                DisableControlAction(0, interaction.data.control.Index, true)
                if IsDisabledControlJustPressed(0, interaction.data.control.Index) and
                    (GetGameTimer() - TimeLastAction) > 500 and checkCanInteract(interaction) then
                    TimeLastAction = GetGameTimer()

                    Interact(interaction)
                end
            end
        end

        closestIndex = _closestIndex
        Wait(wait)
    end
end)



-- TODO remove interactions on resource stop

local function _addModel(resource, model, data)
    -- TODO unique id for each interaction
    local modelData = {
        resource = resource,
        metadata = data.metadata,
        offset = data.offset or vector3(0.0, 0.0, 0.0),
        label = data.label or GetString("interact"),
        distance = data.distance or AVAConfig.DefaultDistance,
        drawDistance = data.drawDistance or
            ((data.distance or AVAConfig.DefaultDistance) + AVAConfig.DefaultOnlyDrawDistance),
        marker = not data.noMarker and (data.marker or 2) or false,
        control = AVAConfig.Controls["E"],
        -- Action
        action = data.action, -- function | nil
        event = data.event, -- string | nil
        serverEvent = data.serverEvent, -- string | nil
        command = data.command, -- string | nil
        -- Can interact with
        canInteract = data.canInteract, -- function | nil
    }

    -- Add control
    if type(data.control) == "table" and data.control.Index and data.control.Name then
        modelData.control = data.control
    elseif type(data.control) == "string" and AVAConfig.Controls[data.control] then
        modelData.control = AVAConfig.Controls[data.control]
    end

    Models[model][#Models[model] + 1] = modelData
end

local addModel = function(model, data)
    if not Models[model] then
        Models[model] = {}
    end
    local resource <const> = GetInvokingResource()

    if table.type(data) == "array" then
        -- Support for arrays
        for i = 1, #data do
            local d = data[i]
            if d then
                _addModel(resource, model, d)
            end
        end
    else
        _addModel(resource, model, data)
    end
end
exports("addModel", addModel)

local addZone = function(coords, data)
    if not coords or not data then return end

    local zoneData = {
        resource = GetInvokingResource(),
        metadata = data.metadata,
        coords = coords,
        label = data.label or GetString("interact"),
        distance = data.distance or AVAConfig.DefaultDistance,
        drawDistance = data.drawDistance or
            ((data.distance or AVAConfig.DefaultDistance) + AVAConfig.DefaultOnlyDrawDistance),
        marker = not data.noMarker and (data.marker or 2) or false,
        control = AVAConfig.Controls["E"],
        -- Action
        action = data.action, -- function | nil
        event = data.event, -- string | nil
        serverEvent = data.serverEvent, -- string | nil
        command = data.command, -- string | nil
        -- Can interact with
        canInteract = data.canInteract, -- function | nil
    }

    -- Add control
    if type(data.control) == "table" and data.control.Index and data.control.Name then
        zoneData.control = data.control
    elseif type(data.control) == "string" and AVAConfig.Controls[data.control] then
        zoneData.control = AVAConfig.Controls[data.control]
    end

    Zones[#Zones + 1] = zoneData
end
exports("addZone", addZone)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then
        -- Clear models
        for model, data in pairs(Models) do
            for i = #data, 1, -1 do
                if data[i].resource == resource then
                    table.remove(data, i)
                end
            end
            if #Models[model] == 0 then
                Models[model] = nil
            end
        end
        -- Clear Zones
        for i = #Zones, 1, -1 do
            if Zones[i].resource == resource then
                table.remove(Zones, i)
            end
        end
        -- Clear current interactions
        for i = #Interactions, 1, -1 do
            local interaction = Interactions[i]
            if interaction and interaction.data.resource == resource then
                table.remove(Interactions, i)
                if i == closestIndex then
                    closestIndex = nil
                end
            end
        end
    end
end)


-- function DrawText3D(x, y, z, text, size, r, g, b, a)
--     local onScreen, _x, _y = World3dToScreen2d(x, y, z)

--     if onScreen then
--         SetTextScale(0.35, size or 0.35)
--         SetTextFont(0)
--         SetTextProportional(1)
--         SetTextColour(r or 255, g or 255, b or 255, a or 215)
--         SetTextEntry("STRING")
--         AddTextComponentSubstringPlayerName(text)
--         SetTextCentre(1)
--         SetTextOutline()

--         EndTextCommandDisplayText(_x, _y)
--     end
-- end
