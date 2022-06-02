-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.lspd = {
    LabelName = "LSPD",
    ServiceCounter = true,
    PhoneNumber = "911",
    Blip = { Name = "~b~Commissariat", Coord = vector3(440.68, -981.63, 30.69), Sprite = 60, Color = 3 },
    JobMenu = {
        Items = {
            -- {
            --     Label = GetString("fine"),
            --     Desc = GetString("fine_desc"),
            --     Action = function(jobName)
            --         -- TODO not important
            --     end,
            -- },
            {
                Label = GetString("search"),
                Desc = GetString("search_desc"),
                Action = function(jobName)
                    local targetId, localId = exports.ava_core:ChooseClosestPlayer()
                    if not targetId then return end

                    TriggerServerEvent("ava_core:server:ShowNotification", targetId, GetString("being_searched"))
                    TriggerEvent("ava_core:client:openTargetInventory", targetId)
                end,
            },
            {
                Label = GetString("check_bills"),
                Desc = GetString("check_bills_desc"),
                RightLabel = "→→→",
                Action = function(jobName)
                    local targetId, localId = exports.ava_core:ChooseClosestPlayer()
                    if not targetId then return end

                    local elements = {}

                    local count = 0
                    local bills = exports.ava_core:TriggerServerCallback("ava_jobs:server:getTargetBills", targetId) or {}
                    for i = 1, #bills do
                        local bill = bills[i]
                        count = count + 1
                        elements[count] = {
                            label = bill.content:len() > 36 and bill.content:sub(0, 33) .. "..." or bill.content,
                            desc = GetString("bill_description", bill.date, bill.content),
                            rightLabel = GetString("bill_amount", exports.ava_core:FormatNumber(bill.amount))
                        }
                    end

                    RageUI.CloseAll()
                    RageUI.OpenTempMenu(GetString("check_bills"), function(Items)
                        for i = 1, #elements do
                            local element = elements[i]
                            if element then
                                Items:AddButton(element.label, element.desc, { RightLabel = element.rightLabel })
                            end
                        end
                    end)
                end,
            },
            {
                Label = GetString("manage_licences"),
                Desc = GetString("manage_licences_desc"),
                RightLabel = "→→→",
                Action = function(jobName)
                    local targetId, localId = exports.ava_core:ChooseClosestPlayer()
                    if not targetId then return end

                    local playerData = exports.ava_core:TriggerServerCallback("ava_jobs:server:getPlayerData", targetId) or {}

                    if playerData and playerData.name and playerData.licenses then
                        RageUI.CloseAll()
                        RageUI.OpenTempMenu(playerData.name, function(Items)
                            for i = 1, #playerData.licenses do
                                local license = playerData.licenses[i]
                                if license.name ~= "trafficLaws" then
                                    Items:AddButton(GetString("license_details_" .. license.name), GetString("license_revoke_desc"), { RightLabel = GetString("license_revoke") }, function(onSelected)
                                        if onSelected and exports.ava_core:ShowConfirmationMessage(GetString("license_revoke_confirm_title"),
                                            GetString("license_revoke_confirm_firstline", GetString("license_details_" .. license.name), playerData.name),
                                            GetString("license_revoke_confirm_secondline"))
                                        then
                                            if exports.ava_core:TriggerServerCallback("ava_jobs:server:revokeLicense", targetId, license.name) then
                                                exports.ava_core:ShowNotification(GetString("licence_you_revoked", GetString("license_details_" .. license.name), playerData.name))
                                                TriggerServerEvent("ava_core:server:ShowNotification", targetId, GetString("license_revoked", GetString("license_details_" .. license.name)))
                                            end
                                        end
                                    end)
                                end
                            end
                        end)
                    end
                end,
                MinimumGrade = "officer",
            },
            {
                Label = GetString("manage_weapon_license"),
                Desc = GetString("manage_weapon_license_desc"),
                Action = function(jobName)
                    local targetId, localId = exports.ava_core:ChooseClosestPlayer(nil, nil, true)
                    if not targetId then return end

                    local playerData = exports.ava_core:TriggerServerCallback("ava_jobs:server:getPlayerData", targetId) or {}
                    if not playerData or not playerData.name or not playerData.licenses then return end

                    for i = 1, #playerData.licenses do
                        local license = playerData.licenses[i]
                        if license.name == "weapon" then
                            exports.ava_core:ShowNotification(GetString("already_own_weapon_licence", playerData.name))
                            return
                        end
                    end

                    if exports.ava_core:TriggerServerCallback("ava_jobs:server:giveWeaponLicense", targetId) then
                        exports.ava_core:ShowNotification(GetString("you_gave_weapon_licence", playerData.name))
                        TriggerServerEvent("ava_core:server:ShowNotification", targetId, GetString("license_weapon_given"))
                    end
                end,
                MinimumGrade = "sergeant_chief",
            },
            {
                Label = GetString("info_vehicle"),
                Desc = GetString("info_vehicle_desc"),
                Action = function(jobName)
                    local vehicle = exports.ava_core:GetVehicleInFrontOrChooseClosest()
                    if vehicle == 0 then return end

                    local vehicleInfos = exports.ava_core:TriggerServerCallback("ava_jobs:server:getVehicleInfos", VehToNet(vehicle), GetVehicleNumberPlateText(vehicle)) or {}

                    local elements = {
                        vehicleInfos.plate and { label = GetString("vehicle_plate", vehicleInfos.plate) },
                        vehicleInfos.owner and { label = GetString("vehicle_owner", vehicleInfos.owner) }
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
                Label = GetString("info_vehicle_search"),
                Desc = GetString("info_vehicle_search_desc"),
                Action = function(jobName)
                    local plate = exports.ava_core:KeyboardInput(GetString("info_vehicle_enter_plate"), "", 12)
                    if not plate or plate == "" then return end

                    local vehicleInfos = exports.ava_core:TriggerServerCallback("ava_jobs:server:getVehicleInfos", nil, plate) or {}

                    local elements = {
                        vehicleInfos.plate and { label = GetString("vehicle_plate", vehicleInfos.plate) },
                        vehicleInfos.owner and { label = GetString("vehicle_owner", vehicleInfos.owner) }
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
            Config.JobMenuElement.PoliceMegaphone,
        },
    },
    Zones = {
        ManagerMenu = {
            Coord = vector3(465.03, -1009.06, 34.95),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 122, b = 204 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(452.76, -992.84, 29.71),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 122, b = 204 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Outfits = {
                {
                    Label = "Cadet manches courtes",
                    Male = json.decode(
                        '{"leg_txd":0,"watches_txd":0,"bracelets":-1,"undershirt":15,"accessory":0,"tops":102,"hats_txd":0,"accessory_txd":0,"leg":59,"glasses_txd":0,"shoes_txd":0,"shoes":25,"hats":-1,"mask":0,"mask_txd":0,"tops_txd":0,"torso":19,"bag_txd":0,"bracelets_txd":0,"bodyarmor":10,"undershirt_txd":0,"torso_txd":0,"decals_txd":0,"ears_txd":0,"bodyarmor_txd":0,"watches":-1,"glasses":-1,"ears":-1,"decals":0,"bag":0}'),
                    Female = json.decode(
                        '{"watches_txd":0,"bag_txd":0,"accessory_txd":0,"bag":0,"ears_txd":0,"watches":-1,"glasses_txd":0,"shoes":25,"leg":61,"mask":0,"tops_txd":0,"undershirt":15,"torso":31,"accessory":0,"bodyarmor_txd":0,"decals":0,"shoes_txd":0,"hats_txd":0,"hats":-1,"bracelets":-1,"decals_txd":0,"leg_txd":0,"tops":93,"ears":-1,"undershirt_txd":0,"mask_txd":0,"bracelets_txd":0,"torso_txd":0,"bodyarmor":19,"glasses":-1}'),
                },
                {
                    Label = "Cadet manches longues",
                    Male = json.decode(
                        '{"mask_txd":0,"leg":59,"accessory":0,"hats":-1,"bag":0,"undershirt":15,"torso_txd":0,"ears":-1,"tops_txd":0,"shoes_txd":0,"shoes":25,"torso":1,"hats_txd":0,"accessory_txd":0,"glasses_txd":0,"bracelets_txd":0,"watches":-1,"decals_txd":0,"bodyarmor":10,"ears_txd":0,"leg_txd":0,"bag_txd":0,"undershirt_txd":0,"bodyarmor_txd":0,"decals":0,"watches_txd":0,"tops":101,"mask":0,"bracelets":-1,"glasses":-1}'),
                    Female = json.decode(
                        '{"watches_txd":0,"bag_txd":0,"accessory_txd":0,"bag":0,"ears_txd":0,"watches":-1,"glasses_txd":0,"shoes":25,"leg":61,"mask":0,"tops_txd":3,"undershirt":15,"torso":3,"accessory":0,"bodyarmor_txd":0,"decals":0,"shoes_txd":0,"hats_txd":0,"hats":-1,"bracelets":-1,"decals_txd":0,"leg_txd":0,"tops":92,"ears":-1,"undershirt_txd":0,"mask_txd":0,"bracelets_txd":0,"torso_txd":0,"bodyarmor":19,"glasses":-1}'),
                },
                {
                    Label = "Tenue manches courtes",
                    Male = json.decode(
                        "{\"leg\":59,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":102,\"undershirt\":53,\"tops_txd\":0,\"bodyarmor\":0,\"torso\":19,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats_txd\":0,\"hats\":-1,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":61,\"bag_txd\":0,\"bag\":84,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":93,\"undershirt\":27,\"tops_txd\":0,\"bodyarmor\":0,\"hats_txd\":0,\"torso\":31,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats\":-1,\"accessory\":1}"),
                },
                {
                    Label = "Tenue manches longues",
                    Male = json.decode(
                        "{\"leg\":59,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":101,\"undershirt\":53,\"tops_txd\":0,\"bodyarmor\":0,\"torso\":20,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats_txd\":0,\"hats\":-1,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":61,\"bag_txd\":0,\"bag\":84,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":92,\"undershirt\":27,\"tops_txd\":0,\"bodyarmor\":0,\"hats_txd\":0,\"torso\":3,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats\":-1,\"accessory\":1}"),
                },
                {
                    Label = "Tenue hiver",
                    Male = json.decode(
                        "{\"leg\":59,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":103,\"undershirt\":65,\"tops_txd\":0,\"bodyarmor\":0,\"torso\":27,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats_txd\":0,\"hats\":-1,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":61,\"bag_txd\":0,\"bag\":84,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":119,\"undershirt\":45,\"tops_txd\":1,\"bodyarmor\":0,\"hats_txd\":0,\"torso\":7,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats\":-1,\"accessory\":1}"),
                },
                {
                    Label = "Tenue SWAT",
                    Male = json.decode(
                        "{\"leg\":59,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":93,\"undershirt\":53,\"tops_txd\":1,\"bodyarmor\":0,\"torso\":19,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats_txd\":0,\"hats\":-1,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":61,\"bag_txd\":0,\"bag\":74,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":84,\"undershirt\":33,\"tops_txd\":1,\"bodyarmor\":0,\"hats_txd\":0,\"torso\":31,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats\":-1,\"accessory\":1}"),
                },
                {
                    Label = "Tenue SWAT Lourd",
                    Male = json.decode(
                        "{\"leg\":59,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":1,\"tops\":219,\"undershirt\":44,\"tops_txd\":2,\"bodyarmor\":7,\"torso\":17,\"shoes\":25,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats_txd\":0,\"hats\":75,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":90,\"bag_txd\":0,\"bag\":74,\"undershirt_txd\":0,\"leg_txd\":2,\"accessory_txd\":0,\"tops\":43,\"undershirt\":33,\"tops_txd\":0,\"bodyarmor\":11,\"hats_txd\":0,\"torso\":49,\"shoes\":25,\"bodyarmor_txd\":3,\"shoes_txd\":0,\"hats\":74,\"accessory\":1}"),
                },
                {
                    Label = "Tenue DOA",
                    Male = json.decode(
                        "{\"leg\":59,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":102,\"undershirt\":53,\"tops_txd\":0,\"bodyarmor\":7,\"torso\":19,\"shoes\":25,\"bodyarmor_txd\":4,\"shoes_txd\":0,\"hats_txd\":0,\"hats\":-1,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":61,\"bag_txd\":0,\"bag\":74,\"undershirt_txd\":0,\"leg_txd\":0,\"accessory_txd\":0,\"tops\":93,\"undershirt\":27,\"tops_txd\":0,\"bodyarmor\":7,\"hats_txd\":0,\"torso\":31,\"shoes\":25,\"bodyarmor_txd\":3,\"shoes_txd\":0,\"hats\":-1,\"accessory\":1}"),
                },
                {
                    Label = "Tenue vélo",
                    Male = json.decode(
                        "{\"leg\":32,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":1,\"accessory_txd\":0,\"tops\":93,\"undershirt\":15,\"tops_txd\":0,\"bodyarmor\":1,\"torso\":30,\"shoes\":13,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats_txd\":0,\"hats\":49,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":31,\"bag_txd\":0,\"bag\":42,\"undershirt_txd\":0,\"leg_txd\":1,\"accessory_txd\":0,\"tops\":84,\"undershirt\":51,\"tops_txd\":2,\"bodyarmor\":0,\"hats_txd\":0,\"torso\":31,\"shoes\":10,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats\":47,\"accessory\":1}"),
                },
                {
                    Label = "Tenue moto",
                    Male = json.decode(
                        "{\"leg\":32,\"bag_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"leg_txd\":1,\"accessory_txd\":0,\"tops\":154,\"undershirt\":13,\"tops_txd\":0,\"bodyarmor\":0,\"torso\":22,\"shoes\":13,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats_txd\":1,\"hats\":79,\"accessory\":0}"),
                    Female = json.decode(
                        "{\"leg\":31,\"bag_txd\":0,\"bag\":42,\"undershirt_txd\":0,\"leg_txd\":1,\"accessory_txd\":0,\"tops\":21,\"undershirt\":27,\"tops_txd\":3,\"bodyarmor\":0,\"hats_txd\":0,\"torso\":32,\"shoes\":40,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats\":78,\"accessory\":0}"),
                },
            },
        },
        FridgeInventory = {
            Coord = vector3(464.71, -990.09, 29.71),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 122, b = 204 },
            Name = "Réfrigérateur",
            InventoryName = "job_lspd_fridge",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        ArmoryInventory = {
            Coord = vector3(452.28, -980.15, 29.71),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 122, b = 204 },
            Name = "Armurerie",
            InventoryName = "job_lspd_armory",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        SeizureInventory = {
            Coord = vector3(472.63, -990.40, 23.93),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 0, g = 122, b = 204 },
            Name = "Coffre saisies",
            InventoryName = "job_lspd_seizure",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
    },
    Garages = {
        -- Job garages
        {
            Name = "jobgarage_lspd",
            Coord = vector3(455.02, -1017.44, 28.44),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "lspd",
            JobNeeded = "lspd",
            SpawnPoint = { Coord = vector3(455.02, -1017.44, 28.44), Heading = 90.0 },
            Blip = { Name = "Garage entreprise" },
        },
        {
            Name = "jobgarage_lspd",
            Coord = vector3(449.57, -981.17, 43.69),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Distance = 3,
            Marker = 34,
            VehicleType = 2,
            IsJobGarage = "lspd",
            JobNeeded = "lspd",
            SpawnPoint = { Coord = vector3(449.57, -981.17, 43.69), Heading = 90.0 },
            Blip = { Name = "Heliport" },
        },
        {
            Name = "jobgarage_lspd",
            Coord = vector3(-784.55, -1437.14, 1.40),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Distance = 5,
            Marker = 35,
            VehicleType = 1,
            IsJobGarage = "lspd",
            JobNeeded = "lspd",
            SpawnPoint = { Coord = vector3(-786.55, -1437.14, 1.40), Heading = 140.0 },
            Blip = { Name = "Marina" }
        },
        -- Player garages
        {
            Name = "garage_lspd",
            Coord = vector3(454.79, -1024.43, 28.48),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "lspd",
            SpawnPoint = { Coord = vector3(454.79, -1024.43, 28.48), Heading = 5.0 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    },
    BuyZones = {
        BuyItems = {
            Items = {
                { name = "bodyarmor", price = 1500 },
                { name = "handcuffs", price = 1000 },
                { name = "gpstracker", price = 2000 },
                { name = "weapon_nightstick", price = 2500 },
                { name = "weapon_flare", price = 15000 },
                { name = "weapon_stungun", price = 40000 },
                { name = "ammo_pistol", price = 8 },
                { name = "weapon_combatpistol", price = 42000 },
                { name = "ammo_smg", price = 11 },
                { name = "weapon_assaultsmg", price = 60000 },
                { name = "ammo_shotgun", price = 16 },
                { name = "weapon_pumpshotgun", price = 75000 },
                { name = "ammo_rifle", price = 12 },
                { name = "weapon_carbinerifle", price = 72000 },
            },
            Coord = vector3(812.26, -2153.55, 28.64),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 221, g = 79, b = 67 },
            Name = "Achat de protections et menottes",
            HelpText = GetString("press_buy"),
            MinimumGrade = "lieutenant",
            Marker = 27,
            Blip = true,
        },
    },
}
