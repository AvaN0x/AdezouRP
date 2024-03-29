-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local LastActionTimer = 0

PlayerData = {}

local HasAlreadyEnteredMarker = false
local LastZone = nil
CurrentZoneName = nil
local CurrentHelpText = nil
CurrentActionEnabled = false

local mainBlips = {}

Citizen.CreateThread(function()
    PlayerData = exports.ava_core:getPlayerData()
end)

Citizen.CreateThread(function()
    for _, v in pairs(Config.Stores) do
        if not v.Distance then
            v.Distance = v.Size.x or 1.5
        end
        if not v.DrawDistance then
            v.DrawDistance = Config.DrawDistance
        end

        local function CreateBlip(coord)
            local blip = AddBlipForCoord(coord.x, coord.y, coord.z)

            SetBlipSprite(blip, v.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.Blip.Scale or 0.8)
            SetBlipColour(blip, v.Blip.Color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.Blip.Name or v.Name)
            EndTextCommandSetBlipName(blip)

            table.insert(mainBlips, blip)
        end

        if v.Blip then
            if v.Coords then
                for _, coord in pairs(v.Coords) do
                    CreateBlip(coord)
                end
            elseif v.Coord then
                CreateBlip(v.Coord)
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if mainBlips then
            for _, blip in ipairs(mainBlips) do
                RemoveBlip(blip)
            end
        end
        mainBlips = {}
    end
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        PlayerData[k] = v
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
end)

playerCoords = nil
playerPed = nil

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        Wait(500)
    end
end)

-------------
-- Markers --
-------------

Citizen.CreateThread(function()
    -- Mandatory wait!
    Wait(1000)
    while true do
        local waitTimer = 500
        local isInMarker = false
        local currentZoneName = nil

        for k, v in pairs(Config.Stores) do
            if v.Coords then
                for _, coord in ipairs(v.Coords) do
                    local distance = #(playerCoords - coord)
                    if distance < v.DrawDistance then
                        if v.Marker ~= nil then
                            DrawMarker(v.Marker, coord.x, coord.y, coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x,
                                v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                                v.Color.b, v.Color.a or 100, false, true, 2, false, false, false, false)
                        end
                        waitTimer = 0
                        if distance < v.Distance then
                            isInMarker = true
                            currentZoneName = k
                        end
                    end
                end
            elseif v.Coord then
                local distance = #(playerCoords - v.Coord)
                if distance < v.DrawDistance then
                    if v.Marker ~= nil then
                        DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x,
                            v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, v.Color.a or 100, false, true, 2, false, false, false, false)
                    end
                    waitTimer = 0
                    if distance < v.Distance then
                        isInMarker = true
                        currentZoneName = k
                    end
                end
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and CurrentZoneName ~= currentZoneName) then
            HasAlreadyEnteredMarker = true
            LastZone = currentZoneName
            TriggerEvent("ava_stores:client:hasEnteredMarker", currentZoneName)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent("ava_stores:client:hasExitedMarker", LastZone)
        end
        Wait(waitTimer)
    end
end)

AddEventHandler("ava_stores:client:hasEnteredMarker", function(zoneName)
    if Config.Stores[zoneName].HelpText ~= nil then
        CurrentHelpText = Config.Stores[zoneName].HelpText
    end

    CurrentZoneName = zoneName
    CurrentActionEnabled = true
end)

AddEventHandler("ava_stores:client:hasExitedMarker", function(zoneName)
    RageUI.CloseAllInternal()
    CurrentZoneName = nil
end)

-----------------
-- Key Control --
-----------------
Citizen.CreateThread(function()
    while true do
        local wait = 50

        if CurrentZoneName ~= nil and CurrentActionEnabled then
            wait = 0
            if CurrentHelpText ~= nil then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName(CurrentHelpText)
                EndTextCommandDisplayHelp(0, 0, 1, -1)
            end

            if IsControlJustReleased(0, 38) -- E
                and (GetGameTimer() - LastActionTimer) > 300 then
                CurrentActionEnabled = false
                LastActionTimer = GetGameTimer()
                local store = Config.Stores[CurrentZoneName]

                if store.Items then
                    BuyZone()
                elseif store.SkinElements then
                    ClothesStore()
                elseif store.SavedOutfits then
                    SavedOutfits()
                elseif store.Carwash then
                    CarWash()
                elseif store.VehicleShop then
                    OpenVehicleShopMenu()
                elseif store.SellVehicle then
                    OpenSellZoneMenu()
                elseif store.LSCustoms then
                    LSCustoms()
                elseif store.Rental then
                    OpenRentalMenu()
                end

            end
        end
        Wait(wait)
    end
end)

function BuyZone()
    if not exports.ava_core:canOpenMenu() then return end
    local store = Config.Stores[CurrentZoneName]

    local items = exports.ava_core:TriggerServerCallback("ava_stores:getStoreItems", 0, CurrentZoneName)

    local elements = {}
    local count = 0
    for i = 1, #items do
        local item = items[i]
        count = count + 1
        elements[count] = {
            label = item.label,
            rightLabel = GetString("store_item_right_label", item.isDirtyMoney and "~r~" or "",
                exports.ava_core:FormatNumber(item.price)),
            leftBadge = not item.noIcon and function()
                return { BadgeDictionary = "ava_items", BadgeTexture = item.name }
            end or nil,
            price = item.price,
            name = item.name,
            maxCanTake = item.maxCanTake,
            desc = item.desc,
        }
    end

    if count > 0 then
        RageUI.CloseAll()
        RageUI.OpenTempMenu(store.Name, function(Items)
            for i = 1, #elements do
                local element = elements[i]
                Items:AddButton(element.label, element.desc,
                    { RightLabel = element.rightLabel, LeftBadge = element.leftBadge }, function(onSelected)
                    if onSelected then
                        local count = tonumber(exports.ava_core:KeyboardInput(GetString("how_much_max",
                            element.maxCanTake or 0), "", 10))

                        if type(count) == "number" and math.floor(count) == count and count > 0 then
                            if count > element.maxCanTake then
                                exports.ava_core:ShowNotification(GetString("cant_carry"))
                            else
                                TriggerServerEvent("ava_stores:server:buyItem", CurrentZoneName, element.name, count)
                                RageUI.CloseAllInternal()
                            end
                        else
                            exports.ava_core:ShowNotification(GetString("invalid_quantity"))
                        end
                    end
                end)
            end
        end, function()
            CurrentActionEnabled = true
        end, store.Title and store.Title.textureName, store.Title and store.Title.textureDirectory)

    else
        exports.ava_core:ShowNotification(GetString("nothing_can_buy"))
        CurrentActionEnabled = true
    end
end

function CarWash()
    local veh = GetVehiclePedIsUsing(playerPed)
    if veh == 0 then
        exports.ava_core:ShowNotification(GetString("carwash_not_in_vehicle"))
        CurrentActionEnabled = true
    elseif math.ceil(GetEntitySpeed(veh) * 3.6) > 5 then
        exports.ava_core:ShowNotification(GetString("carwash_driving_too_fast"))
        CurrentActionEnabled = true
    else
        local hasEnoughMoney = exports.ava_core:TriggerServerCallback("ava_stores:carwash:checkMoney", CurrentZoneName)
        if not hasEnoughMoney then
            exports.ava_core:ShowNotification(GetString("cant_afford"))
            CurrentActionEnabled = true
        else
            local carwash = Config.Stores[CurrentZoneName]
            local particles = {}
            local isWorking = true

            Citizen.CreateThread(function()
                while isWorking do
                    DisableAllControlActions(0)
                    EnableControlAction(0, 1, true) -- Enable horizontal cam
                    EnableControlAction(0, 2, true) -- Enable vertical cam
                    Wait(0)
                end
            end)

            FreezeEntityPosition(veh, true)
            FreezeEntityPosition(playerPed, true)
            if carwash.Carwash.Particles then
                local assetName = "scr_carwash"

                for i = 1, #carwash.Carwash.Particles do
                    RequestNamedPtfxAsset(assetName)
                    UseParticleFxAsset(assetName)

                    while not HasNamedPtfxAssetLoaded(assetName) do
                        Wait(10)
                    end

                    local particle = carwash.Carwash.Particles[i]
                    table.insert(particles,
                        StartParticleFxLoopedAtCoord(particle.Name, particle.Coord.x, particle.Coord.y, particle.Coord.z
                            , (particle.RotX or 270) + 0.0, particle.Heading + 0.0, 0.0, 1.0, 0.0, 0, 0))
                end
            end

            exports.progressBars:startUI(carwash.Carwash.Duration or 5000, GetString("carwash_on_cleaning"))
            Wait(carwash.Carwash.Duration or 5000)

            WashDecalsFromVehicle(veh, 1.0)
            SetVehicleDirtLevel(veh)

            if #particles > 0 then
                for i = 1, #particles do
                    if DoesParticleFxLoopedExist(particles[i]) then
                        StopParticleFxLooped(particles[i], 0)
                        RemoveParticleFx(particles[i], 0)
                    end
                end
                particles = nil
            end

            isWorking = false
            FreezeEntityPosition(playerPed, false)
            FreezeEntityPosition(veh, false)
            CurrentActionEnabled = true
            exports.ava_core:ShowNotification(GetString("carwash_vehicle_cleaned"))
        end
    end
end
