-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local TimeLastAction = 0
---Models that the player can interact with
local Models = {}
---Specific zones that the player can interact with
local Zones = {}

local Interactions = {}

local playerCoords = nil
local playerPed = nil

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        Wait(300)
    end
end)

Citizen.CreateThread(function()
    while true do
        local interactions = {}
        local count = 0

        local gamePool <const> = GetGamePool("CObject")
        for i = 1, #gamePool do
            local entity = GetObjectIndexFromEntityIndex(gamePool[i])
            local model = GetEntityModel(entity)

            if Models[model] then
                for j = 1, #Models[model] do
                    local data <const> = Models[model][j]
                    local entityCoords = GetOffsetFromEntityInWorldCoords(entity, data.offset.x, data.offset.y,
                        data.offset.z)
                    if #(playerCoords - entityCoords) < AVAConfig.CheckDistance then
                        count = count + 1
                        interactions[count] = {
                            entity = entity,
                            data = data
                        }
                    end
                end
            end
        end
        Interactions = interactions
        Wait(AVAConfig.CheckInterval)
    end
end)


-- TODO remove interactions on resource stop

-- TODO id unique pour chaque interaction ?
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
                Models[model][#Models[model] + 1] = {
                    resource = resource,
                    label = d.label or GetString("interact"),
                    distance = d.distance or AVAConfig.DefaultDistance,
                    drawDistance = d.drawDistance or
                        ((d.distance or AVAConfig.DefaultDistance) + AVAConfig.DefaultOnlyDrawDistance),
                    offset = d.offset or vector3(0.0, 0.0, 0.0),
                    marker = not d.noMarker and (d.marker or 2) or false,
                }
            end
        end
    else
        Models[model][#Models[model] + 1] = {
            resource = resource,
            label = data.label or GetString("interact"),
            distance = data.distance or AVAConfig.DefaultDistance,
            drawDistance = data.drawDistance or
                ((data.distance or AVAConfig.DefaultDistance) + AVAConfig.DefaultOnlyDrawDistance),
            offset = data.offset or vector3(0.0, 0.0, 0.0),
            marker = not data.noMarker and (data.marker or 2) or false,
        }
    end
end
exports("addModel", addModel)


-- TODO
-- Zones[#Zones + 1] = {
--     label = "Hello World",
--     coords = vector3(434.15, -981.71, 30.70),
--     distance = 3,
-- }


local closestIndex = nil
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
            if interaction then
                local data <const> = interaction.data
                local coords <const> = GetOffsetFromEntityInWorldCoords(interaction.entity, data.offset.x,
                    data.offset.y, data.offset.z)

                local distance <const> = #(playerCoords - coords)
                if distance < data.drawDistance then
                    wait = 0
                    local isClosest <const> = i == closestIndex

                    if data.marker then
                        local markerData = isClosest and ClosestMarkerData or MarkerData
                        DrawMarker(data.marker, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0,
                            markerData.size, markerData.size, markerData.size, markerData.r, markerData.g, markerData.b,
                            markerData.a, false, false, 2, true, false, false, false)
                    end

                    if distance < data.distance then
                        -- DrawText3D(coords.x, coords.y, coords.z + 0.2, data.label)
                        if isClosest then
                            BeginTextCommandDisplayHelp("STRING")
                            AddTextComponentSubstringPlayerName(" ~INPUT_PICKUP~ " .. data.label)
                            EndTextCommandDisplayHelp(0, false, true, -1)
                        end

                        if not closestDistance or distance < closestDistance then
                            closestDistance = distance
                            _closestIndex = i
                        end
                    end
                end
            end
        end

        if closestIndex then
            local interaction <const> = Interactions[closestIndex]
            if interaction then
                -- TODO interact
            end
        end

        closestIndex = _closestIndex
        Wait(wait)
    end
end)


function DrawText3D(x, y, z, text, size, r, g, b, a)
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
