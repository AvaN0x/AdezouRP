-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.mechanic = {
    LabelName = "Mécano",
    ServiceCounter = true,
    PhoneNumber = "555-0153",
    Blip = { Name = "~y~Garage Mécano", Coord = vector3(-1145.49, -1990.55, 13.16), Sprite = 446, Color = 5 },
    JobMenu = {
        Items = {
            {
                Label = GetString("info_vehicle"),
                Desc = GetString("info_vehicle_desc"),
                Action = function(jobName)
                    local vehicle = exports.ava_core:GetVehicleInFrontOrChooseClosest()
                    if vehicle == 0 then return end

                    local plate = GetVehicleNumberPlateText(vehicle)
                    local engineHealth = math.floor(GetVehicleEngineHealth(vehicle))
                    local bodyHealth = math.floor(GetVehicleBodyHealth(vehicle))
                    local dirtLevel = GetVehicleDirtLevel(vehicle)

                    local elements = {
                        { label = GetString('vehicle_plate', plate or GetString("info_vehicle_not_found")) },
                        {
                            label = GetString('info_vehicle_engine_health',
                                engineHealth > 950
                                and "#329171"
                                or engineHealth > 500
                                and "#c9712e"
                                or "#c92e2e",
                                math.floor(engineHealth / 10)
                            )
                        },
                        {
                            label = GetString('info_vehicle_body_health',
                                bodyHealth > 950
                                and "#329171"
                                or bodyHealth > 500
                                and "#c9712e"
                                or "#c92e2e",
                                math.floor(bodyHealth / 10)
                            )
                        },
                        {
                            label = GetString('info_vehicle_dirt_level',
                                dirtLevel > 10
                                and GetString("info_vehicle_dirt_level_above_10")
                                or dirtLevel > 5
                                and GetString("info_vehicle_dirt_level_above_5")
                                or GetString("info_vehicle_dirt_level_above_0")
                            )
                        },
                    }

                    RageUI.CloseAll()
                    RageUI.OpenTempMenu(GetString("info_vehicle"), function(Items)
                        for i = 1, #elements do
                            local element = elements[i]
                            if element then
                                Items:AddButton(element.label, element.desc)
                            end
                        end
                    end)
                end,
            },
            {
                Label = GetString("tow_vehicle"),
                Desc = GetString("tow_vehicle_desc"),
                Condition = function(jobName, playerPed)
                    return GetVehiclePedIsIn(playerPed, false) == 0
                end,
                Action = function(jobName)
                    local vehicle = exports.ava_core:ChooseClosestVehicle(GetString("tow_vehicle_choose_vehicle"), 6, {}, { GetHashKey('flatbed'), GetHashKey('slamtruck') })
                    if vehicle == 0 then return end

                    -- Vehicle is already towed
                    if IsEntityAttachedToAnyVehicle(vehicle) then
                        local vehicleDimMin, vehicleDimMax = GetModelDimensions(GetEntityModel(vehicle))
                        local flatbed = GetEntityAttachedTo(vehicle)

                        local offsetLocation = vector3(0.0, -6.5 + vehicleDimMin.y, 0.0)
                        AttachEntityToEntity(vehicle, flatbed, GetEntityBoneIndexByName(flatbed, "bodyshell"), offsetLocation, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                        DetachEntity(vehicle)
                        SetVehicleOnGroundProperly(vehicle)

                        exports.ava_core:ShowNotification(GetString("tow_vehicle_detached_with_success"))
                    else
                        local flatbed = exports.ava_core:ChooseClosestVehicle(GetString("tow_vehicle_choose_flatbed"), 10, { GetHashKey('flatbed'), GetHashKey('slamtruck') })
                        if flatbed == 0 then return end

                        -- should never happen
                        if vehicle == flatbed then return end

                        -- flatbed can be a flatbed or slamtruck
                        local isSlamTruck = GetEntityModel(flatbed) == GetHashKey('slamtruck')
                        local towOffset = GetOffsetFromEntityInWorldCoords(flatbed, 0.0, -2.2, 0.4)
                        local closestVehicleOnTopOfFlatbed = GetClosestVehicle(towOffset.x, towOffset.y, towOffset.z + 1.0, 4.0, 0, 71)
                        local vehicleDimMin, vehicleDimMax = GetModelDimensions(GetEntityModel(vehicle))

                        if GetEntityModel(closestVehicleOnTopOfFlatbed) ~= GetEntityModel(flatbed) then
                            exports.ava_core:ShowNotification(GetString("tow_vehicle_flatbed_already_towed"))
                            return
                        end
                        if (isSlamTruck and (vehicleDimMin.y < -3.5 or vehicleDimMax.y > 3.5))
                            or (vehicleDimMin.y < -5 or vehicleDimMax.y > 5)
                        then
                            -- we prevent big vehicles that does not fit on slamtruck
                            exports.ava_core:ShowNotification(GetString("tow_vehicle_too_long"))
                            return
                        end

                        local boneIndex = GetEntityBoneIndexByName(flatbed, "bodyshell")
                        -- we attach the vehicle on the flatbed
                        local offsetLocation = vector3(0, -2.2, 0.4 - vehicleDimMin.z)
                        AttachEntityToEntity(vehicle, flatbed, boneIndex, offsetLocation, 0, 0, 0, false, false, false, false, 20, true)

                        -- We drop the vehicle for 500ms to get a valid rotation
                        DetachEntity(vehicle)
                        Citizen.Wait(500)
                        local newPos = GetEntityCoords(vehicle, true)
                        local vehRotation = GetEntityRotation(vehicle)
                        local flatbedRotation = GetEntityRotation(flatbed)

                        -- we attach the vehicle on the flatbed
                        local attachPos = GetOffsetFromEntityGivenWorldCoords(flatbed, newPos.x, newPos.y, newPos.z)
                        AttachEntityToEntity(vehicle, flatbed, boneIndex, attachPos.x, attachPos.y, attachPos.z, vehRotation.x - flatbedRotation.x, vehRotation.y - flatbedRotation.y, vehRotation.z - flatbedRotation.z, false, false, false, false, 20, true)

                        exports.ava_core:ShowNotification(GetString("tow_vehicle_attached_with_success"))
                    end
                end,
            },
        },
    },
    Zones = {
        ManagerMenu = {
            Coord = vector3(-1151.45, -2032.61, 12.21),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            MinimumGrade = "boss",
        },
        StockInventory = {
            Coord = vector3(-1145.19, -2004.44, 12.21),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Stockage",
            InventoryName = "job_mechanic_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        FridgeInventory = {
            Coord = vector3(-1153.45, -2025.06, 12.21),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Réfrigérateur",
            InventoryName = "job_mechanic_fridge",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(-1137.33, -2001.94, 12.21),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Blip = true,
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Outfits = {
                {
                    Label = "Tenue manches courtes",
                    Female = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":11,\"decals\":0,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":0,\"shoes\":25,\"accessory_txd\":0,\"tops\":117,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":49,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":-1,\"undershirt\":14,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":1}"),
                    Male = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":0,\"decals\":0,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":0,\"shoes\":25,\"accessory_txd\":0,\"tops\":22,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":122,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":-1,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":0}"),
                },
                {
                    Label = "Tenue manches longues",
                    Female = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":7,\"decals\":0,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":0,\"shoes\":25,\"accessory_txd\":0,\"tops\":103,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":49,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":-1,\"undershirt\":14,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":3}"),
                    Male = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":0,\"decals\":0,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":0,\"shoes\":25,\"accessory_txd\":0,\"tops\":86,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":122,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":-1,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":0}"),
                },
            },
        },
        LSCustomBooth1 = {
            Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
            Coord = vector3(-1157.43, -2022.30, 12.13),
            Size = { x = 2.0, y = 2.0, z = 1.0 },
            Color = { r = 207, g = 169, b = 47, a = 64 },
            Name = "LSCustom",
            LSCustoms = true,
            HelpText = GetString("press_to_open_lscustom"),
            Marker = 27,
        },
        LSCustomBooth2 = {
            Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
            Coord = vector3(-1143.47, -2036.05, 12.14),
            Size = { x = 2.0, y = 2.0, z = 1.0 },
            Color = { r = 207, g = 169, b = 47, a = 64 },
            Name = "LSCustom",
            LSCustoms = true,
            HelpText = GetString("press_to_open_lscustom"),
            Marker = 27,
        },
        LSCustomPaintingChamber = {
            Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
            Coord = vector3(-1167.30, -2013.47, 12.25),
            Size = { x = 2.0, y = 2.0, z = 1.0 },
            Color = { r = 207, g = 169, b = 47, a = 64 },
            Name = "LSCustom",
            LSCustoms = true,
            HelpText = GetString("press_to_open_lscustom"),
            Marker = 27,
        },
        LSCustomCenter = {
            Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
            Coord = vector3(-1150.27, -2011.06, 12.25),
            Size = { x = 2.0, y = 2.0, z = 1.0 },
            Color = { r = 207, g = 169, b = 47, a = 64 },
            Name = "LSCustom",
            LSCustoms = true,
            HelpText = GetString("press_to_open_lscustom"),
            Marker = 27,
        },
        LSCustomOutside = {
            Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
            Coord = vector3(-1149.44, -1979.88, 12.18),
            Size = { x = 2.0, y = 2.0, z = 1.0 },
            Color = { r = 207, g = 169, b = 47, a = 64 },
            Name = "LSCustom",
            LSCustoms = true,
            HelpText = GetString("press_to_open_lscustom"),
            Marker = 27,
        },
    },
    FieldZones = {
        BumperField = {
            Items = { { name = "bumber_part_worn", quantity = 1 } },
            PropHash = GetHashKey("prop_mk_race_chevron_02"),
            Coord = vector3(2364.53, 3074.66, 47.21),
            MinGroundHeight = 46,
            MaxGroundHeight = 49,
            Name = "1. Récupération de pare-choc",
            PickupCount = 5,
            Blip = true,
        },
    },
    ProcessZones = {
        BumperProcess = {
            ItemsGive = { { name = "bumber_part_worn", quantity = 1 } },
            ItemsGet = { { name = "bumber_part_revamped", quantity = 1 } },
            Delay = 12000,
            Scenario = "WORLD_HUMAN_HAMMERING", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(-325.45, -109.06, 38.04),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "2. Retapage des pare-choc",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
    },
    SellZones = {
        BumperSell = {
            Items = { { name = "bumber_part_revamped", price = 1600 } },
            Coord = vector3(540.16, -196.75, 53.51),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "3. Vente des pare-choc",
            HelpText = GetString("press_sell"),
            Marker = 27,
            Blip = true,
        },
    },
    BuyZones = {
        DorsetDriveItems = {
            Items = {
                { name = "repairkit", price = 250 },
                { name = "bodykit", price = 250 },
                { name = "rag", price = 100 },
                { name = 'blowtorch', price = 752 },
            },
            Coord = vector3(2747.39, 3472.98, 54.69),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "YOU TOOL",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
    Garages = {
        -- Job garages
        {
            Name = "jobgarage_mechanic",
            Coord = vector3(-1144.50, -1971.83, 13.16),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 207, g = 169, b = 47 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "mechanic",
            JobNeeded = "mechanic",
            SpawnPoint = { Coord = vector3(-1144.50, -1971.83, 13.16), Heading = 190.18 },
            Blip = { Name = "Garage entreprise" },
        },
        {
            Name = "jobgarage_seized",
            Coord = vector3(822.38, -1365.17, 26.13),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 207, g = 169, b = 47 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "mechanic",
            JobNeeded = "mechanic",
            SpawnPoint = { Coord = vector3(822.38, -1365.17, 26.13), Heading = 281.21 },
            Blip = { Name = "Garage saisies" },
        },
        {
            Name = "jobgarage_pound",
            Coord = vector3(383.83, -1623.05, 29.29),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 207, g = 169, b = 47 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "mechanic",
            JobNeeded = "mechanic",
            SpawnPoint = { Coord = vector3(383.83, -1623.05, 29.29), Heading = 319.31 },
            Blip = { Name = "Fourrière" },
        },
        --Player garages
        {
            Name = "garage_mechanic",
            Coord = vector3(-1112.74, -2016.33, 13.20),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "mechanic",
            SpawnPoint = { Coord = vector3(-1112.74, -2016.33, 13.20), Heading = 307.75 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    }
}
