-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.ems = {
    LabelName = "EMS",
    ServiceCounter = true,
    PhoneNumber = "912",
    Blip = { Name = "~b~Hopital", Coord = vector3(298.48, -584.48, 43.28), Sprite = 61, Color = 26 },
    JobMenu = {
        Items = {
            {
                Label = GetString("ems_check_injuries"),
                Desc = GetString("ems_check_injuries_desc"),
                Action = function(jobName)
                    local targetId, localId = exports.ava_core:ChooseClosestPlayer()
                    if not targetId then return end

                    local playerData = exports.ava_core:TriggerServerCallback("ava_jobs:server:ems:getPlayerData",
                        targetId)
                    if not playerData then return end

                    local targetPed = GetPlayerPed(localId)
                    local elements = {
                        playerData.injured and {
                            label = GetString('ems_injuries_label',
                                playerData.injured > 0 and "#c92e2e" or "#329171",
                                playerData.injured > 50
                                and GetString('ems_injuries_injured_high')
                                or playerData.injured > 30
                                and GetString('ems_injuries_injured')
                                or playerData.injured > 0
                                and GetString('ems_injuries_injured_low')
                                or GetString('ems_injuries_healthy')
                            )
                        }
                    }

                    if DoesEntityExist(targetPed) then
                        local health = GetEntityHealth(targetPed)
                        local maxHealth = GetEntityMaxHealth(targetPed)
                        local percentHealth = math.floor((health / maxHealth) * 100)
                        print(health, maxHealth, percentHealth)
                        table.insert(elements, {
                            label = GetString('ems_health_label',
                                percentHealth == 100 and "#329171" or "#c92e2e",
                                -- percentHealth == 100
                                --     and GetString('ems_health_full')
                                --     or percentHealth > 50
                                --         and GetString('ems_health_high')
                                --         or percentHealth > 30
                                --             and GetString('ems_health_middle')
                                --             or GetString('ems_health_low')
                                health .. "/" .. maxHealth
                            )
                        })
                    end

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
        },
    },
    Zones = {
        ManagerMenu = {
            Coord = vector3(327.22, -601.81, 42.29),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 139, b = 90 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
            MinimumGrade = "boss",
        },
        Cloakroom = {
            Coord = vector3(306.89, -601.61, 42.30),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 139, b = 90 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Outfits = {
                {
                    Label = "Tenue manches courtes",
                    Female = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":109,\"decals\":66,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":96,\"shoes\":25,\"accessory_txd\":0,\"tops\":258,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":99,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":121,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":0}"),
                    Male = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":85,\"decals\":58,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":126,\"shoes\":25,\"accessory_txd\":0,\"tops\":250,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":96,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":122,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":0}"),
                },
                {
                    Label = "Tenue manches longues",
                    Female = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":105,\"decals\":65,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":96,\"shoes\":25,\"accessory_txd\":0,\"tops\":257,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":99,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":121,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":0}"),
                    Male = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":90,\"decals\":57,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":126,\"shoes\":25,\"accessory_txd\":0,\"tops\":249,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":96,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":122,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":0}"),
                },
                {
                    Label = "Tenue chirurgien",
                    Female = json.decode(
                        "{\"decals\":0,\"torso\":109,\"leg\":133,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":27,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":15,\"tops\":141,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":0,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":6,\"bag\":0,\"tops_txd\":1,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                    Male = json.decode(
                        "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":85,\"decals\":0,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":0,\"shoes\":25,\"accessory_txd\":0,\"tops\":273,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":96,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":-1,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":20}"),
                },
            },
        },
        FridgeInventory = {
            Coord = vector3(312.24, -596.59, 42.29),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 139, b = 90 },
            Name = "Réfrigérateur",
            InventoryName = "job_ems_fridge",
            HelpText = GetString("press_to_open"),
            Blip = true,
            Marker = 27,
        },
        PharmacyStock = {
            Coord = vector3(300.45, -577.95, 27.87),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 139, b = 90 },
            Name = "Pharmacie",
            InventoryName = "job_ems_pharmacy",
            HelpText = GetString("press_to_open"),
            Blip = true,
            Marker = 27,
        },
    },
    BuyZones = {
        DorsetDriveItems = {
            Items = {
                { name = "ethylotest", price = 300 },
                { name = "defibrillator", price = 550 },
                { name = "bandage", price = 300 },
                { name = "medikit", price = 400 },
                { name = "dolizou", price = 100 },
            },
            Coord = vector3(-447.57, -341.08, 33.52),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 0, g = 139, b = 90 },
            Name = "Pharmacie",
            HelpText = GetString("press_buy"),
            MinimumGrade = "doctor",
            Marker = 27,
            Blip = true,
        },
        TailorItems = {
            Items = { { name = "bandage", price = 100 } },
            Coord = vector3(740.00, -970.21, 23.48),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 0, g = 139, b = 90 },
            Name = "Pharmacie",
            HelpText = GetString("press_buy"),
            MinimumGrade = "doctor",
            Marker = 27,
            Blip = true,
        },
    },
    Garages = {
        -- Job garages
        {
            Name = "jobgarage_ems",
            Coord = vector3(360.60, -559.97, 28.85),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 139, b = 90 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "ems",
            JobNeeded = "ems",
            SpawnPoint = { Coord = vector3(360.12, -561.02, 28.85), Heading = 160.0 },
            Blip = { Name = "Garage entreprise" },
        },
        {
            Name = "jobgarage_ems",
            Coord = vector3(351.05, -588.07, 74.17),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 139, b = 90 },
            Marker = 34,
            VehicleType = 2,
            IsJobGarage = "ems",
            JobNeeded = "ems",
            SpawnPoint = { Coord = vector3(351.05, -588.07, 74.17), Heading = 245.0 },
            Blip = { Name = "Heliport" },
        },
        -- Player garages
        {
            Name = "garage_ems",
            Coord = vector3(323.62, -545.24, 28.74),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "ems",
            SpawnPoint = { Coord = vector3(323.62, -545.24, 28.74), Heading = 268.32 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    }
}
