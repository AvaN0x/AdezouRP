-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config = {}
Config.DrawDistance = 30.0
Config.Locale = "fr"
Config.MaxPickUp = 70
Config.MaxPickUpIllegal = 70
Config.JobMenuKey = "F6"

-- TODO declare these in client side and not config
Config.JobMenuElement = {
    PoliceMegaphone = {
        Label = GetString("police_megaphone"),
        Desc = GetString("police_megaphone_desc"),
        AllowedVehicles = {
            GetHashKey("police"),
            GetHashKey("police2"),
            GetHashKey("police3"),
            GetHashKey("police4"),
            GetHashKey("fbi"),
            GetHashKey("fbi2"),
            GetHashKey("riot"),
            GetHashKey("riot2"),
            GetHashKey("policet"),
            GetHashKey("sheriff"),
            GetHashKey("sheriff2"),
            GetHashKey("pranger"),
            GetHashKey("bcat"),
            GetHashKey("pbus"),
            GetHashKey("polbuffalo"),
            GetHashKey("polgauntlet"),
            GetHashKey("polbullet"),
            GetHashKey("polvacca"),
            GetHashKey("predator"),
            GetHashKey("umoracle"),
        },
        Condition = function(jobName, playerPed)
            local veh = GetVehiclePedIsIn(playerPed, false)
            if veh ~= 0 and (GetPedInVehicleSeat(veh, -1) == playerPed or GetPedInVehicleSeat(veh, 0) == playerPed) then
                local vehModel = GetEntityModel(veh)
                for k, vehicleHash in ipairs(Config.JobMenuElement.PoliceMegaphone.AllowedVehicles) do
                    if vehModel == vehicleHash then
                        return true
                    end
                end
            end
            return false
        end,
        Action = function(jobName)
            local elements = {
                {
                    label = GetString("police_megaphone_stop_vehicle"),
                    RightLabel = "→→→",
                    elements = {
                        { label = "LSPD! Stop...", desc = "LSPD! Stop your vehicle now!", distance = 30.0, volume = 0.6, soundName = "stop_vehicle" },
                        { label = "Driver! Stop...", desc = "Driver! Stop your vehicle", distance = 30.0, volume = 0.6, soundName = "stop_vehicle-2" },
                        { label = "Stop the fucking car...", desc = "This is the LSPD! Stop the fucking car immediately!", distance = 30.0, volume = 0.6, soundName = "stop_the_f_car" },
                        { label = "Stop or executed...", desc = "LSPD! Stop your vehicle now or you'll be executed!", distance = 30.0, volume = 0.6, soundName = "stop_or_executed" },
                        { label = "Stop or I kill ya...", desc = "Stop your vehicle right fucking now! Or I swear I am going to kill ya!", distance = 30.0, volume = 0.6, soundName = "stop_or_i_kill" },
                    },
                },
                {
                    label = GetString("police_megaphone_stop"),
                    RightLabel = "→→→",
                    elements = {
                        { label = "Dont make me...", desc = "Stop! Don't make me shoot ya! Give yourself up!", distance = 30.0, volume = 0.6, soundName = "dont_make_me" },
                        { label = "Dont move a muscle...", desc = "Stop and dont move a muscle, or you'll be shot by the LSPD!", distance = 30.0, volume = 0.6, soundName = "stop_dont_move" },
                        { label = "Give yourself up...", desc = "LSPD! If you give yourself up I'll be a lot nicer shithead!", distance = 30.0, volume = 0.6, soundName = "give_yourself_up" },
                        { label = "Stay right there...", desc = "LSPD! Stay right there and don't move, fucker!", distance = 30.0, volume = 0.6, soundName = "stay_right_there" },
                        { label = "Freeze...", desc = "Freeze! LSPD!", distance = 30.0, volume = 0.6, soundName = "freeze_lspd" },
                    },
                },
                {
                    label = GetString("police_megaphone_clear"),
                    RightLabel = "→→→",
                    elements = {
                        { label = "Clear the area...", desc = "This is the LSPD! Clear the area. Now!", distance = 30.0, volume = 0.6, soundName = "clear_the_area" },
                        { label = "Go away now...", desc = "This is the LSPD! Go away now or there will be trouble.", distance = 30.0, volume = 0.6, soundName = "this_is_the_lspd" },
                        { label = "Move along people...", desc = "Move along people. We don't want trouble.", distance = 30.0, volume = 0.6, soundName = "move_along_people" },
                        { label = "Get out of here...", desc = "Get out of here now. This is the LSPD.", distance = 30.0, volume = 0.6, soundName = "get_out_of_here_now" },
                        { label = "Disperse now...", desc = "This is the LSPD! Disperse, now!", distance = 30.0, volume = 0.6, soundName = "disperse_now" },
                    },
                },
                {
                    label = GetString("police_megaphone_insult"),
                    RightLabel = "→→→",
                    elements = {
                        { label = "It's over...", desc = "It's over for you! This is the police!", distance = 30.0, volume = 0.6, soundName = "its_over_for_you" },
                        { label = "You are finished...", desc = "You are finished dickhead! Stop!", distance = 30.0, volume = 0.6, soundName = "you_are_finished_dhead" },
                        { label = "You can't hide boy...", desc = "You can't hide boy. We will track you down!", distance = 30.0, volume = 0.6, soundName = "cant_hide_boi" },
                        { label = "Drop a missile...", desc = "Can't we just drop a missile on this moron?!", distance = 30.0, volume = 0.6, soundName = "drop_a_missile" },
                        { label = "Shoot to kill...", desc = "This is the LSPD! I'm gonna shoot to kill!", distance = 30.0, volume = 0.6, soundName = "shoot_to_kill" },
                    },
                },
            }

            RageUI.CloseAll()
            RageUI.OpenTempMenu(GetString("police_megaphone"), function(Items)
                for i = 1, #elements do
                    local element = elements[i]
                    Items:AddSeparator(element.label)
                    for i = 1, #element.elements do
                        local sound = element.elements[i]
                        Items:AddButton(sound.label, sound.desc, nil, function(onSelected)
                            if onSelected and Config.JobMenuElement.PoliceMegaphone.Condition(jobName, PlayerPedId()) then
                                -- TODO use something else than InteractSound
                                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", sound.distance, sound.soundName, sound.volume)
                            end
                        end)
                    end
                end
            end)

        end,
    },
}

Config.Jobs = {
    -- #region jobs
    lspd = {
        LabelName = "LSPD",
        ServiceCounter = true,
        Blip = { Name = "~b~Commissariat", Coord = vector3(440.68, -981.63, 30.69), Sprite = 60, Colour = 3 },
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
                        local targetId, localId = exports.ava_core:ChooseClosestPlayer()
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
                            "{\"bag_txd\":0,\"leg\":59,\"leg_txd\":0,\"accessory_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"hats_txd\":0,\"tops\":102,\"shoes_txd\":0,\"hats\":-1,\"accessory\":0,\"bodyarmor_txd\":0,\"tops_txd\":0,\"torso\":19,\"bodyarmor\":0,\"undershirt\":59,\"shoes\":25}"),
                    },
                    {
                        Label = "Cadet manches longues",
                        Male = json.decode(
                            "{\"bag_txd\":0,\"leg\":59,\"leg_txd\":0,\"accessory_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"hats_txd\":0,\"tops\":101,\"shoes_txd\":0,\"hats\":-1,\"accessory\":0,\"bodyarmor_txd\":0,\"tops_txd\":0,\"torso\":20,\"bodyarmor\":0,\"undershirt\":59,\"shoes\":25}"),
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
                            "{\"leg\":31,\"bag_txd\":0,\"bag\":48,\"undershirt_txd\":0,\"leg_txd\":1,\"accessory_txd\":0,\"tops\":21,\"undershirt\":27,\"tops_txd\":3,\"bodyarmor\":0,\"hats_txd\":0,\"torso\":32,\"shoes\":40,\"bodyarmor_txd\":0,\"shoes_txd\":0,\"hats\":78,\"accessory\":0}"),
                    },
                },
            },
            ArmoryStock = {
                Coord = vector3(452.28, -980.15, 29.71),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 0, g = 122, b = 204 },
                Name = "Armurerie",
                StockName = "society_lspd_armory",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            SeizureStock = {
                Coord = vector3(472.63, -990.40, 23.93),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 0, g = 122, b = 204 },
                Name = "Coffre saisies",
                StockName = "society_lspd_seizure",
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
                Blip = { Name = "Marina", Sprite = 60, Colour = 3 }
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
            },
        },
        BuyZones = {
            BuyItems = {
                Items = { { name = "bproof_vest", price = 15000 }, { name = "handcuffs", price = 10000 }, { name = "balisegps", price = 2000 } },
                Coord = vector3(812.26, -2153.55, 28.64),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 221, g = 79, b = 67 },
                Name = "Achat de protections et menottes",
                HelpText = GetString("press_buy"),
                MinimumGrade = "chief",
                Marker = 27,
                Blip = true,
            },
        },
    },
    ems = {
        LabelName = "EMS",
        ServiceCounter = true,
        Blip = { Name = "~b~Hopital", Coord = vector3(298.48, -584.48, 43.28), Sprite = 61, Colour = 26 },
        JobMenu = {
            Items = {
                {
                    Label = GetString("ems_check_injuries"),
                    Desc = GetString("ems_check_injuries_desc"),
                    Action = function(jobName)

                    end,
                },
            },
        },
        Zones = {
            ManagerMenu = {
                Coord = vector3(339.21, -595.63, 42.30),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 0, g = 139, b = 90 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
                MinimumGrade = "boss",
            },
            Cloakroom = {
                Coord = vector3(299.03, -598.51, 42.30),
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
                        Label = "Tenue chirurgie",
                        Female = json.decode(
                            "{\"decals\":0,\"torso\":109,\"leg\":133,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":27,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":15,\"tops\":141,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":0,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":6,\"bag\":0,\"tops_txd\":1,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                        Male = json.decode(
                            "{\"ears_txd\":0,\"bag_txd\":0,\"torso\":85,\"decals\":0,\"bodyarmor_txd\":0,\"glasses\":-1,\"shoes_txd\":0,\"bag\":0,\"undershirt_txd\":0,\"accessory\":0,\"shoes\":25,\"accessory_txd\":0,\"tops\":273,\"bracelets_txd\":0,\"hats_txd\":0,\"bodyarmor\":0,\"leg\":96,\"glasses_txd\":0,\"mask_txd\":0,\"hats\":-1,\"undershirt\":15,\"ears\":-1,\"torso_txd\":0,\"mask\":0,\"watches\":-1,\"bracelets\":-1,\"decals_txd\":0,\"leg_txd\":0,\"watches_txd\":0,\"tops_txd\":20}"),
                    },
                },
            },
            PharmacyStock = {
                Coord = vector3(309.77, -568.66, 42.30),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 0, g = 139, b = 90 },
                Name = "Pharmacie",
                StockName = "society_ems_pharmacy",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(337.34, -579.28, 28.80),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 0, g = 139, b = 90 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(337.34, -579.28, 28.80), Heading = 340.0 },
            },
            KitchenStock = {
                Coord = vector3(306.89, -601.61, 42.30),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 0, g = 139, b = 90 },
                Name = "Cuisine",
                StockName = "society_ems",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            HeliGarage = {
                Name = "Héliport",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(351.05, -588.07, 74.17),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 0, g = 139, b = 90 },
                Distance = 3,
                Marker = 34,
                Type = "heli",
                SpawnPoint = { Coord = vector3(351.05, -588.07, 74.17), Heading = 245.0 },
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
    },
    mechanic = {
        LabelName = "Mécano",
        ServiceCounter = true,
        Blip = { Name = "~y~Garage Mécano", Coord = vector3(-1145.49, -1990.55, 13.16), Sprite = 446, Colour = 5 },
        JobMenu = {
            Items = {
                {
                    Label = GetString("info_vehicle"),
                    Desc = GetString("info_vehicle_desc"),
                    Action = function(jobName)

                    end,
                },
                {
                    Label = GetString("tow_vehicle"),
                    Desc = GetString("tow_vehicle_desc"),
                    Condition = function(jobName, playerPed)
                        return GetVehiclePedIsIn(playerPed, false) == 0
                    end,
                    Action = function(jobName)
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
            MainStock = {
                Coord = vector3(-1145.19, -2004.44, 12.21),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 207, g = 169, b = 47 },
                Name = "Stockage",
                StockName = "society_mechanic",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            FridgeStock = {
                Coord = vector3(-1153.45, -2025.06, 12.21),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 207, g = 169, b = 47 },
                Name = "Frigo",
                StockName = "society_mechanic_fridge",
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
                LSCustom = true,
                HelpText = GetString("press_to_open_lscustom"),
                Marker = 27,
            },
            LSCustomBooth2 = {
                Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
                Coord = vector3(-1143.47, -2036.05, 12.14),
                Size = { x = 2.0, y = 2.0, z = 1.0 },
                Color = { r = 207, g = 169, b = 47, a = 64 },
                Name = "LSCustom",
                LSCustom = true,
                HelpText = GetString("press_to_open_lscustom"),
                Marker = 27,
            },
            LSCustomPaintingChamber = {
                Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
                Coord = vector3(-1167.30, -2013.47, 12.25),
                Size = { x = 2.0, y = 2.0, z = 1.0 },
                Color = { r = 207, g = 169, b = 47, a = 64 },
                Name = "LSCustom",
                LSCustom = true,
                HelpText = GetString("press_to_open_lscustom"),
                Marker = 27,
            },
            LSCustomCenter = {
                Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
                Coord = vector3(-1150.27, -2011.06, 12.25),
                Size = { x = 2.0, y = 2.0, z = 1.0 },
                Color = { r = 207, g = 169, b = 47, a = 64 },
                Name = "LSCustom",
                LSCustom = true,
                HelpText = GetString("press_to_open_lscustom"),
                Marker = 27,
            },
            LSCustomOutside = {
                Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
                Coord = vector3(-1149.44, -1979.88, 12.18),
                Size = { x = 2.0, y = 2.0, z = 1.0 },
                Color = { r = 207, g = 169, b = 47, a = 64 },
                Name = "LSCustom",
                LSCustom = true,
                HelpText = GetString("press_to_open_lscustom"),
                Marker = 27,
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-1144.45, -1971.70, 13.16),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 207, g = 169, b = 47 },
                Marker = 36,
                Type = "car",
                Blip = true,
                SpawnPoint = { Coord = vector3(-1144.45, -1971.70, 13.16), Heading = 190.0 },
            },
            SeizedCarGarage = {
                Name = "Garage saisies",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(822.47, -1365.20, 26.13),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 221, g = 79, b = 67 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                Identifier = "seized_LSPD",
                OnlyParkCars = true,
                Blip = true,
            },
            PoundCarGarage = {
                Name = "Fourrière",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(383.76, -1623.09, 29.29),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 201, g = 113, b = 46 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                Identifier = "garage_POUND",
                OnlyParkCars = true,
                Blip = true,
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
                Items = { { name = "repairkit", price = 250 }, { name = "bodykit", price = 250 }, { name = "cloth", price = 100 } },
                Coord = vector3(2747.39, 3472.98, 54.69),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 207, g = 169, b = 47 },
                Name = "YOU TOOL",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    government = {
        LabelName = "Gouvernement",
        ServiceCounter = true,
        Blip = { Name = "Gouvernement", Coord = vector3(-545.17, -204.17, 37.24), Sprite = 419, Colour = 0 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(-536.25, -189.45, 46.76),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 207, g = 169, b = 47 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                MinimumGrade = "governor",
            },
            MainStock = {
                Coord = vector3(-536.75, -180.95, 37.24),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 207, g = 169, b = 47 },
                Name = "Stockage",
                StockName = "society_government",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(-527.59, -186.21, 46.76),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 207, g = 169, b = 47 },
                Blip = true,
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Outfits = {
                    {
                        Label = "Agent de sécurité",
                        Female = json.decode(
                            "{\"decals\":0,\"torso\":23,\"leg\":133,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":27,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":37,\"tops\":92,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":0,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":23,\"bag\":0,\"tops_txd\":2,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                        Male = json.decode(
                            "{\"decals\":0,\"torso\":22,\"leg\":10,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":10,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":32,\"tops\":294,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":0,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":0,\"bag\":0,\"tops_txd\":0,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                    },

                },
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-580.32, -171.30, 37.86),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 207, g = 169, b = 47 },
                Marker = 36,
                Type = "car",
                Blip = true,
                SpawnPoint = { Coord = vector3(-580.32, -171.30, 37.86), Heading = 285.0 },
            },
        },
    },
    winemaker = {
        LabelName = "Vigneron",
        Blip = { Sprite = 85, Colour = 19 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(-1895.18, 2063.98, 140.03),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                MinimumGrade = "employee",
            },
            Cloakroom = {
                Coord = vector3(-1874.90, 2054.53, 140.09),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-1888.97, 2045.06, 140.87),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 0, g = 255, b = 0 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(-1898.16, 2048.77, 139.89), Heading = 70.0 },
                Blip = true,
            },
        },
        FieldZones = {
            GrapeField = {
                Items = { { name = "grape", quantity = 8 } },
                PropHash = GetHashKey("prop_mk_race_chevron_02"),
                Coord = vector3(-1809.662, 2210.119, 90.681),
                MinGroundHeight = 88,
                MaxGroundHeight = 100,
                Name = "1. Récolte",
                -- Distance = 1.3,
                Blip = true,
            },
        },
        ProcessZones = {
            WineProcess = {
                ItemsGive = { { name = "grape", quantity = 10 } },
                ItemsGet = { { name = "wine", quantity = 1 }, { name = "grapejuice", quantity = 1 } },
                Delay = 6000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(-1930.97, 2055.08, 139.83),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "2. Traitement vin",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
            ChampagneProcess = {
                ItemsGive = { { name = "grape", quantity = 10 } },
                ItemsGet = { { name = "champagne", quantity = 1 }, { name = "luxurywine", quantity = 1 } },
                Delay = 8000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(-1866.50, 2058.95, 140.02),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "Traitement champagne et grand cru",
                HelpText = GetString("press_traitement"),
                MinimumGrade = "employee",
                Marker = 27,
                Blip = true,
            },
        },
        ProcessMenuZones = {
            BoxingProcess = {
                Title = "Mise en caisse",
                Process = {
                    WineProcess = {
                        Name = "Caisse de Vin",
                        Desc = "Une caisse de six bouteilles",
                        ItemsGive = { { name = "wine", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                        ItemsGet = { { name = "winebox", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    JusRaisinProcess = {
                        Name = "Caisse de Jus de raisin",
                        Desc = "Une caisse de six bouteilles",
                        ItemsGive = { { name = "grapejuice", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                        ItemsGet = { { name = "grapejuicebox", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    ChampagneProcess = {
                        Name = "Caisse de Champagne",
                        Desc = "Une caisse de six bouteilles",
                        ItemsGive = { { name = "champagne", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                        ItemsGet = { { name = "champagnebox", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    luxurywineProcess = {
                        Name = "Caisse de Grand Cru",
                        Desc = "Une caisse de six bouteilles",
                        ItemsGive = { { name = "luxurywine", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                        ItemsGet = { { name = "luxurywinebox", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 3,
                Coord = vector3(-1933.06, 2061.9, 139.86),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "4. Traitement en caisses",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
        },
        SellZones = {
            WineMerchantSell = {
                Items = { { name = "winebox", price = 1600 }, { name = "grapejuicebox", price = 650 } },
                Coord = vector3(-158.737, -54.651, 53.42),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "5. Vente des produits",
                HelpText = GetString("press_sell"),
                Marker = 27,
                Blip = true,
            },
        },
        BuyZones = {
            BuyBox = {
                Items = { { name = "woodenbox", price = 20 } },
                Coord = vector3(396.77, -345.88, 45.86),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "3. Achat de caisses",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    tailor = {
        LabelName = "Couturier",
        Blip = { Sprite = 366, Colour = 0 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(708.48, -966.69, 29.42),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                MinimumGrade = "employee",
            },
            Cloakroom = {
                Coord = vector3(708.91, -959.63, 29.42),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
             Cloakroom = {
                Coord = vector3(708.91, -959.63, 29.42),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
                Outfits = {
                    {
                        Label = "Tenue de Travail",
                        Male = json.decode(
                            "{"watches":-1,"watches_txd":0,"bag":87,"leg":0,"accessory_txd":0,"bodyarmor_txd":0,"undershirt_txd":0,"bracelets_txd":0,"bracelets":-1,"decals_txd":0,"accessory":0,"torso_txd":0,"tops":1,"ears_txd":0,"ears":-1,"tops_txd":0,"mask":0,"bodyarmor":0,"mask_txd":0,"hats":-1,"leg_txd":2,"glasses":-1,"glasses_txd":0,"undershirt":163,"bag_txd":6,"shoes_txd":0,"decals":0,"torso":0,"hats_txd":0,"shoes":1}"),
                        Female = json.decode(
                            "{"watches":-1,"watches_txd":0,"bag":87,"leg":1,"accessory_txd":0,"bodyarmor_txd":0,"undershirt_txd":0,"bracelets_txd":0,"bracelets":-1,"decals_txd":0,"accessory":0,"torso_txd":0,"tops":0,"ears_txd":0,"ears":-1,"tops_txd":0,"mask":0,"bodyarmor":0,"mask_txd":0,"hats":-1,"leg_txd":2,"glasses":-1,"glasses_txd":0,"undershirt":199,"bag_txd":6,"shoes_txd":2,"decals":0,"torso":0,"hats_txd":0,"shoes":1}"),
                    },         
                },            
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(719.11, -989.22, 24.12),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 0, g = 255, b = 0 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(719.11, -989.22, 23.12), Heading = 279.0 },
                Blip = true,
            },
        },
        FieldZones = {
            WoolField = {
                Items = { { name = "wool", quantity = 8 } },
                PropHash = GetHashKey("prop_mk_race_chevron_02"),
                Coord = vector3(1887.45, 4630.05, 37.12),
                MinGroundHeight = 36,
                MaxGroundHeight = 41,
                Name = "1. Récolte",
                Blip = true,
            },
        },
        ProcessZones = {
            FabricProcess = {
                ItemsGive = { { name = "wool", quantity = 10 } },
                ItemsGet = { { name = "fabric", quantity = 4 } },
                Delay = 4000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(712.75, -973.78, 29.42),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "2. Traitement laine",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
            ClotheProcess = {
                ItemsGive = { { name = "fabric", quantity = 2 } },
                ItemsGet = { { name = "clothe", quantity = 1 } },
                Delay = 4000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(716.5, -961.82, 29.42),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "3. Traitement du tissu",
                HelpText = GetString("press_traitement"),
                NoInterim = false,
                Marker = 27,
                Blip = true,
            },
            ClothesBoxProcess = {
                ItemsGive = { { name = "clothe", quantity = 9 }, { name = "cardboardbox", quantity = 1 } },
                ItemsGet = { { name = "clothebox", quantity = 1 } },
                Delay = 3000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(718.73, -973.74, 29.42),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "5. Mise en caisse des vetements",
                HelpText = GetString("press_traitement"),
                NoInterim = false,
                Marker = 27,
                Blip = true,
            },
        },
        SellZones = {
            ClothesSell = {
                Items = { { name = "clothebox", price = 1420 } },
                Coord = vector3(71.67, -1390.47, 28.4),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "6. Vente des produits",
                HelpText = GetString("press_sell"),
                Marker = 27,
                Blip = true,
            },
        },
        BuyZones = {
            BuyBox = {
                Items = { { name = "cardboardbox", price = 20 } },
                Coord = vector3(406.5, -350.02, 45.84),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "4. Achat de cartons",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    cluckin = {
        LabelName = "Cluckin Bell",
        Blip = { Sprite = 141, Colour = 46 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(-513.13, -699.59, 32.19),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(-510.19, -700.42, 32.19),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
                Outfits = {
                    {
                        Label = "Tenue de service",
                        Female = json.decode(
                            "{\"decals\":0,\"torso\":9,\"leg\":106,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":13,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":15,\"tops\":294,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":15,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":2,\"bag\":0,\"tops_txd\":10,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                        Male = json.decode(
                            "{\"decals\":0,\"torso\":6,\"leg\":105,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":12,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":15,\"tops\":281,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":5,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":5,\"bag\":0,\"tops_txd\":10,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                    },
                },

            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-465.3, -619.36, 31.17),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 0, g = 255, b = 0 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(-465.3, -619.36, 31.17), Heading = 86.0 },
                Blip = true,
            },
        },
        FieldZones = {
            ChickenField = {
                Items = { { name = "alive_chicken", quantity = 2 } },
                PropHash = 610857585,
                Coord = vector3(85.95, 6331.61, 30.25),
                MinGroundHeight = 29,
                MaxGroundHeight = 32,
                Name = "1. Récolte",
                Blip = true,
            },
        },
        ProcessZones = {
            PluckProcess = {
                ItemsGive = { { name = "alive_chicken", quantity = 2 } },
                ItemsGet = { { name = "plucked_chicken", quantity = 2 } },
                Delay = 8000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(-91.05, 6240.41, 30.11),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "2. Déplumage",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
            RawProcess = {
                ItemsGive = { { name = "plucked_chicken", quantity = 2 } },
                ItemsGet = { { name = "raw_chicken", quantity = 8 } },
                Delay = 10000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(-103.89, 6206.29, 30.05),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "3. Découpe",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
        },
        ProcessMenuZones = {
            CookingProcess = {
                Title = "Cuisine",
                Process = {
                    NuggetsProcess = {
                        Name = "Nuggets",
                        ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                        ItemsGet = { { name = "nuggets", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    ChickenBurgerProcess = {
                        Name = "Chicken Burger",
                        ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                        ItemsGet = { { name = "chickenburger", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    DoubleChickenBurgerProcess = {
                        Name = "Double Chicken Burger",
                        ItemsGive = { { name = "raw_chicken", quantity = 4 } },
                        ItemsGet = { { name = "doublechickenburger", quantity = 1 } },
                        Delay = 3000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    TendersProcess = {
                        Name = "Tenders",
                        ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                        ItemsGet = { { name = "tenders", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    ChickenWrapProcess = {
                        Name = "Wrap au poulet",
                        ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                        ItemsGet = { { name = "chickenwrap", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    FritesProcess = {
                        Name = "Frites",
                        ItemsGive = { { name = "potato", quantity = 2 } },
                        ItemsGet = { { name = "frites", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    PotatoesProcess = {
                        Name = "Potatoes",
                        ItemsGive = { { name = "potato", quantity = 2 } },
                        ItemsGet = { { name = "potatoes", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 5,
                Coord = vector3(-520.07, -701.52, 32.19),
                Size = { x = 2.5, y = 2.5, z = 1.5 },
                Color = { r = 252, g = 186, b = 3 },
                Name = "Cuisine",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
        },
        SellZones = {
            ChickenSell = {
                Items = { { name = "raw_chicken", price = 100 } },
                Coord = vector3(-138.13, -256.69, 42.61),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "4. Vente des produits",
                HelpText = GetString("press_sell"),
                Marker = 27,
                Blip = true,
            },
        },
        BuyZones = {
            BuyDrinks = {
                Items = {
                    { name = "potato", price = 20 },
                    { name = "icetea", price = 20 },
                    { name = "sprite", price = 20 },
                    { name = "orangina", price = 20 },
                    { name = "cocacola", price = 20 },
                },
                Coord = vector3(406.5, -350.02, 45.84),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "Achat de boissons",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    bahama = {
        Disabled = true,
        LabelName = "Bahama",
        Blip = { Sprite = 93, Colour = 0 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(-1390.48, -600.57, 29.34),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(-1386.81, -608.41, 29.34),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-1419.26, -596.3, 30.45),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 0, g = 255, b = 0 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(-1419.26, -596.3, 30.45), Heading = 299.0 },
                Blip = true,
            },
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    { name = "icetea", price = 15 },
                    { name = "sprite", price = 15 },
                    { name = "orangina", price = 15 },
                    { name = "coffee", price = 13 },
                    { name = "cocacola", price = 15 },
                    { name = "ice", price = 2 },
                    { name = "martini", price = 20 },
                    { name = "martini2", price = 20 },
                    { name = "rhum", price = 20 },
                    { name = "tequila", price = 20 },
                    { name = "vodka", price = 20 },
                    { name = "beer", price = 20 },
                    { name = "whisky", price = 20 },
                },
                Coord = vector3(376.81, -362.84, 45.85),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "Achat de boissons",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    unicorn = {
        LabelName = "Unicorn",
        Blip = { Sprite = 121, Colour = 0 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(132.14, -1290.15, 28.29),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(106.71, -1299.75, 27.79),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(144.25, -1284.85, 29.34),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 0, g = 255, b = 0 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(144.25, -1284.85, 29.34), Heading = 298.0 },
                Blip = true,
            },
        },
        FieldZones = {
            OrangesField = {
                Items = { { name = "orange", quantity = 8 } },
                PropHash = GetHashKey("ex_mp_h_acc_fruitbowl_01"),
                Coord = vector3(373.23, 6511.44, 28.31),
                MinGroundHeight = 27,
                MaxGroundHeight = 29,
                Name = "1. Récolte d'oranges",
                Blip = true,
            },
        },
        SellZones = {
            OrangeSell = {
                Items = { { name = "orange", price = 40 } },
                Coord = vector3(106.17, -1280.60, 28.27),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "2. Vente d'oranges",
                HelpText = GetString("press_sell"),
                Marker = 27,
                Blip = true,
            },
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    { name = "icetea", price = 15 },
                    { name = "sprite", price = 15 },
                    { name = "orangina", price = 15 },
                    { name = "coffee", price = 13 },
                    { name = "cocacola", price = 15 },
                    { name = "ice", price = 2 },
                    { name = "martini", price = 20 },
                    { name = "martini2", price = 20 },
                    { name = "rhum", price = 20 },
                    { name = "tequila", price = 20 },
                    { name = "vodka", price = 20 },
                    { name = "beer", price = 20 },
                    { name = "whisky", price = 20 },
                },
                Coord = vector3(387.02, -343.28, 45.85),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 136, g = 232, b = 9 },
                Name = "Achat de boissons",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    nightclub = {
        LabelName = "Galaxy",
        Blip = { Coord = vector3(-676.83, -2458.79, 12.96), Sprite = 614, Colour = 7 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(-1583.19, -3014.04, -76.99),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 156, g = 110, b = 175 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(-1619.66, -3020.41, -76.19),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 156, g = 110, b = 175 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-685.96, -2481.24, 13.83),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 156, g = 110, b = 175 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(-685.96, -2481.24, 13.83), Heading = 299.0 },
                Blip = true,
            },
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    { name = "icetea", price = 15 },
                    { name = "sprite", price = 15 },
                    { name = "orangina", price = 15 },
                    { name = "coffee", price = 13 },
                    { name = "cocacola", price = 15 },
                    { name = "ice", price = 2 },
                    { name = "martini", price = 20 },
                    { name = "martini2", price = 20 },
                    { name = "rhum", price = 20 },
                    { name = "tequila", price = 20 },
                    { name = "vodka", price = 20 },
                    { name = "beer", price = 20 },
                    { name = "whisky", price = 20 },
                },
                Coord = vector3(376.81, -362.84, 45.85),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 156, g = 110, b = 175 },
                Name = "Achat de boissons",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    attackataco = {
        LabelName = "Attack-A-Taco",
        Blip = { Sprite = 468, Colour = 46 },
        Zones = {
            ManagerMenu = {
                Coord = vector3(17.27, -1602.66, 28.40),
                Size = { x = 1.0, y = 1.0, z = 1.5 },
                Color = { r = 255, g = 217, b = 106 },
                Name = "Actions patron",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(20.20, -1601.98, 28.40),
                Size = { x = 1.0, y = 1.0, z = 1.5 },
                Color = { r = 255, g = 217, b = 106 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
                Blip = true,
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(17.83, -1595.44, 29.28),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 255, g = 217, b = 106 },
                Marker = 36,
                Type = "car",
                SpawnPoint = { Coord = vector3(17.83, -1595.44, 29.28), Heading = 50.0 },
                Blip = true,
            },
        },
        FieldZones = {
            CowField = {
                Items = { { name = "cow_part", quantity = 2 } },
                PropHash = GetHashKey("prop_mk_race_chevron_02"),
                Coord = vector3(996.82, -2123.07, 30.48),
                MinGroundHeight = 29,
                MaxGroundHeight = 30,
                Name = "1. Récolte",
                Radius = 5,
                Blip = true,
            },
        },
        ProcessZones = {
            RawProcess = {
                ItemsGive = { { name = "cow_part", quantity = 2 } },
                ItemsGet = { { name = "minced_meat", quantity = 8 } },
                Delay = 12000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(994.46, -2162.40, 28.49),
                Size = { x = 5.0, y = 5.0, z = 3.5 },
                Distance = 2.5,
                Color = { r = 255, g = 217, b = 106 },
                Name = "2. Hachage",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
        },
        ProcessMenuZones = {
            CookingProcess = {
                Title = "Cuisine",
                Process = {
                    OdaciousProcess = {
                        Name = "Taco Spicy Audacieux",
                        ItemsGive = { { name = "minced_meat", quantity = 2 } },
                        ItemsGet = { { name = "tacos_odacious", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    ImpensableProcess = {
                        Name = "Taco Impensable",
                        ItemsGive = { { name = "minced_meat", quantity = 2 } },
                        ItemsGet = { { name = "tacos_impensable", quantity = 1 } },
                        Delay = 3000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    GourmetProcess = {
                        Name = "Taco Gourmet du chef",
                        ItemsGive = { { name = "minced_meat", quantity = 3 }, { name = "bagcoke", quantity = 1 } },
                        ItemsGet = { { name = "tacos_gourmet", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    FritesProcess = {
                        Name = "Frites",
                        ItemsGive = { { name = "potato", quantity = 2 } },
                        ItemsGet = { { name = "frites", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                    PotatoesProcess = {
                        Name = "Potatoes",
                        ItemsGive = { { name = "potato", quantity = 2 } },
                        ItemsGet = { { name = "potatoes", quantity = 1 } },
                        Delay = 2000,
                        Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 5,
                Coord = vector3(11.50, -1599.42, 28.40),
                Size = { x = 1.0, y = 1.0, z = 1.5 },
                Color = { r = 255, g = 217, b = 106 },
                Name = "Cuisine",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = true,
            },
        },
        SellZones = {
            ChickenSell = {
                Items = { { name = "minced_meat", price = 80 } },
                Coord = vector3(445.93, -1241.86, 29.30),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 255, g = 217, b = 106 },
                Name = "3. Vente des produits",
                HelpText = GetString("press_sell"),
                Marker = 27,
                Blip = true,
            },
        },
        BuyZones = {
            BuyDrinks = {
                Items = {
                    { name = "potato", price = 20 },
                    { name = "icetea", price = 20 },
                    { name = "sprite", price = 20 },
                    { name = "orangina", price = 20 },
                    { name = "cocacola", price = 20 },
                },
                Coord = vector3(388.90, -367.34, 45.84),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 255, g = 217, b = 106 },
                Name = "Achat de boissons",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    -- #endregion jobs

    -- #region drugs
    weed = {
        isIllegal = true,
        KeyName = "keyweed",
        FieldZones = {
            CannaField = {
                Items = { { name = "weed", quantity = 5 } },
                PropHash = GetHashKey("prop_weed_01"),
                Coord = vector3(3824.07, 4429.46, 3.0),
                MinGroundHeight = 1,
                MaxGroundHeight = 4,
                Radius = 4,
            },
        },
        ProcessZones = {
            BagProcess = {
                ItemsGive = { { name = "weed", quantity = 5 }, { name = "dopebag", quantity = 1 } },
                ItemsGet = { { name = "bagweed", quantity = 1 } },
                Delay = 8000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(859.08, 2877.4, 57.98),
                NeedKey = true,
            },
        },
    },
    coke = {
        isIllegal = true,
        KeyName = "keycoke",
        FieldZones = {
            CokeField = {
                Items = { { name = "cokeleaf", quantity = 5 } },
                PropHash = GetHashKey("prop_plant_fern_02a"),
                Coord = vector3(-294.48, 2524.97, 74.62),
                MinGroundHeight = 74,
                MaxGroundHeight = 75,
                Radius = 4,
            },
        },
        ProcessZones = {
            CokeProcess = {
                ItemsGive = { { name = "cokeleaf", quantity = 2 } },
                ItemsGet = { { name = "coke", quantity = 2 } },
                Delay = 8000,
                Scenario = "world_human_clipboard", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(1019.13, -2511.48, 28.48),
                NeedKey = true,
            },
            BagProcess = {
                ItemsGive = { { name = "coke", quantity = 5 }, { name = "dopebag", quantity = 1 } },
                ItemsGet = { { name = "bagcoke", quantity = 1 } },
                Delay = 10000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(1017.72, -2529.39, 28.3),
                NeedKey = true,
            },
        },
    },
    meth = {
        isIllegal = true,
        KeyName = "keymeth",
        FieldZones = {
            MethyField = {
                Items = { { name = "methylamine", quantity = 15 } },
                PropHash = GetHashKey("prop_barrel_exp_01c"),
                Coord = vector3(1595.49, -1702.09, 88.12),
                MinGroundHeight = 88,
                MaxGroundHeight = 89,
                Radius = 5,
            },
            PseudoField = {
                Items = { { name = "methpseudophedrine", quantity = 15 } },
                PropHash = GetHashKey("prop_barrel_01a"),
                Coord = vector3(584.86, -491.21, 24.75),
                MinGroundHeight = 23,
                MaxGroundHeight = 24,
                Radius = 5,
            },
            MethaField = {
                Items = { { name = "methacide", quantity = 15 } },
                PropHash = GetHashKey("prop_barrel_exp_01c"),
                Coord = vector3(1112.49, -2299.49, 30.5),
                MinGroundHeight = 30,
                MaxGroundHeight = 31,
                Radius = 4,
            },
        },
        ProcessZones = {
            BagProcess = {
                ItemsGive = {
                    { name = "methylamine", quantity = 5 },
                    { name = "methpseudophedrine", quantity = 5 },
                    { name = "methacide", quantity = 5 },
                    { name = "dopebag", quantity = 1 },
                },
                ItemsGet = { { name = "methamphetamine", quantity = 1 } },
                Delay = 10000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(1390.33, 3608.5, 38.94),
                NeedKey = true,
            },
        },
    },
    exta = {
        isIllegal = true,
        KeyName = "keyexta",
        FieldZones = {
            MdmaField = {
                Items = { { name = "extamdma", quantity = 10 } },
                PropHash = GetHashKey("prop_drug_package_02"),
                Coord = vector3(-1063.23, -1113.14, 2.16),
                MinGroundHeight = 2,
                MaxGroundHeight = 2,
                Radius = 3,
            },
            AmphetField = {
                Items = { { name = "extaamphetamine", quantity = 10 } },
                PropHash = GetHashKey("ex_office_swag_pills2"),
                Coord = vector3(177.98, 306.6, 105.37),
                MinGroundHeightght = 105,
                MaxGroundHeight = 106,
                Radius = 3,
            },
        },
        ProcessZones = {
            ExtaProcess = {
                ItemsGive = { { name = "extamdma", quantity = 2 }, { name = "extaamphetamine", quantity = 2 } },
                ItemsGet = { { name = "extazyp", quantity = 10 } },
                Delay = 10000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(1983.23, 3026.61, 47.69),
                NeedKey = true,
            },
            BagProcess = {
                ItemsGive = { { name = "extazyp", quantity = 5 }, { name = "dopebag", quantity = 1 } },
                ItemsGet = { { name = "bagexta", quantity = 1 } },
                Delay = 10000,
                Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                Coord = vector3(1984.5, 3054.88, 47.22),
                NeedKey = true,
            },
        },
    },
    -- #endregion drugs

    -- #region gangs / organizations
    gang_vagos = {
        isGang = true,
        LabelName = "Vagos",
        Zones = {
            Stock = {
                Coord = vector3(332.24, -2018.62, 21.37),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 250, g = 197, b = 50 },
                Name = "Coffre",
                StockName = "gang_vagos",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(335.83, -2021.79, 21.37),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 250, g = 197, b = 50 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(335.46, -2039.61, 21.13),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 250, g = 197, b = 50 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_vagos",
                SpawnPoint = { Coord = vector3(335.46, -2039.61, 21.13), Heading = 50.0 },
            },
        },
    },
    gang_ballas = {
        isGang = true,
        LabelName = "Ballas",
        Zones = {
            Stock = {
                Coord = vector3(118.93, -1966.05, 20.35),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 152, g = 60, b = 137 },
                Name = "Coffre",
                StockName = "gang_ballas",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(117.25, -1964.02, 20.35),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 152, g = 60, b = 137 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(91.82, -1964.06, 20.75),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 152, g = 60, b = 137 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_ballas",
                SpawnPoint = { Coord = vector3(91.82, -1964.06, 20.75), Heading = 321.59 },
            },
        },
    },
    gang_families = {
        isGang = true,
        LabelName = "Families",
        Zones = {
            Stock = {
                Coord = vector3(-140.31, -1599.21, 33.85),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 72, g = 171, b = 57 },
                Name = "Coffre",
                StockName = "gang_families",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(-147.68, -1596.57, 33.85),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 72, g = 171, b = 57 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-109.22, -1599.54, 31.64),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 72, g = 171, b = 57 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_families",
                SpawnPoint = { Coord = vector3(-109.22, -1599.54, 31.64), Heading = 316.36 },
            },
        },
    },
    gang_marabunta = {
        isGang = true,
        LabelName = "Marabunta",
        Zones = {
            Stock = {
                Coord = vector3(1294.62, -1745.05, 53.30),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Coffre",
                StockName = "gang_marabunta",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(1301.05, -1745.58, 53.30),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(1329.94, -1724.45, 56.04),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 136, g = 243, b = 216 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_marabunta",
                SpawnPoint = { Coord = vector3(1329.94, -1724.45, 56.04), Heading = 10.77 },
            },
        },
    },
    biker_lost = {
        isGang = true,
        LabelName = "The Lost",
        Blip = { Sprite = 556, Colour = 31 },
        Blips = { { Name = "Bunker", Coord = vector3(2109.59, 3325.00, 45.36) } },
        Zones = {
            Stock = {
                Coord = vector3(977.11, -104.00, 73.87),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Coffre",
                StockName = "biker_lost",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(986.63, -92.71, 73.87),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(975.37, -140.63, 74.23),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 136, g = 243, b = 216 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_lost",
                SpawnPoint = { Coord = vector3(975.37, -140.63, 74.23), Heading = 50.0 },
            },
            Crate = {
                Coord = vector3(987.05, -144.41, 73.29),
                Name = "Crate",
                HelpText = GetString("press_to_talk"),
                Action = function()
                    TriggerEvent("ava_lock:dooranim")
                    TriggerEvent("esx_ava_crate_lost:startMission")
                end,
            },
        },
        ProcessMenuZones = {
            -- clips
            {
                Title = "Fabrication de chargeurs",
                Process = {
                    ClipProcess = {
                        Name = "Chargeurs",
                        ItemsGive = { { name = "steel", quantity = 1 }, { name = "gunpowder", quantity = 4 } },
                        ItemsGet = { { name = "clip", quantity = 5 } },
                        Delay = 2000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 5,
                Coord = vector3(898.04, -3221.57, -99.23),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 72, g = 34, b = 43 },
                Name = "Fabrication de chargeurs",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = false,
            },

            -- pistols
            {
                Title = "Fabrication de pistolets",
                Process = {
                    PistolProcess = {
                        Name = "Pistolet 9mm",
                        ItemsGive = { { name = "steel", quantity = 25 }, { name = "plastic", quantity = 10 }, { name = "grease", quantity = 5 } },
                        ItemsGet = { { name = "weapon_pistol", quantity = 1 } },
                        Delay = 20000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    PistolCal50Process = {
                        Name = "Pistolet Cal50",
                        ItemsGive = { { name = "steel", quantity = 40 }, { name = "plastic", quantity = 70 }, { name = "grease", quantity = 13 } },
                        ItemsGet = { { name = "weapon_pistol50", quantity = 1 } },
                        Delay = 20000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    VintagePistolProcess = {
                        Name = "Pistolet Vintage",
                        ItemsGive = { { name = "steel", quantity = 32 }, { name = "plastic", quantity = 10 }, { name = "grease", quantity = 5 } },
                        ItemsGet = { { name = "weapon_vintagepistol", quantity = 1 } },
                        Delay = 20000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 5,
                Coord = vector3(905.98, -3230.79, -99.27),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 72, g = 34, b = 43 },
                Name = "Fabrication de pistolets",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = false,
            },

            -- smgs
            {
                Title = "Fabrication de pistolets mitrailleurs",
                Process = {
                    UZIProcess = {
                        Name = "Uzi",
                        ItemsGive = { { name = "steel", quantity = 60 }, { name = "plastic", quantity = 45 }, { name = "grease", quantity = 10 } },
                        ItemsGet = { { name = "weapon_microsmg", quantity = 1 } },
                        Delay = 20000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    MachinePistolProcess = {
                        Name = "Tec-9",
                        ItemsGive = { { name = "steel", quantity = 50 }, { name = "plastic", quantity = 35 }, { name = "grease", quantity = 5 } },
                        ItemsGet = { { name = "weapon_machinepistol", quantity = 1 } },
                        Delay = 20000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    MiniSmgProcess = {
                        Name = "Scorpion",
                        ItemsGive = { { name = "steel", quantity = 58 }, { name = "plastic", quantity = 35 }, { name = "grease", quantity = 5 } },
                        ItemsGet = { { name = "weapon_minismg", quantity = 1 } },
                        Delay = 20000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 5,
                Coord = vector3(896.58, -3217.3, -99.24),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 72, g = 34, b = 43 },
                Name = "Fabrication de pistolets mitrailleurs",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = false,
            },

            -- shotguns
            {
                Title = "Fabrication de fusils à pompe",
                Process = {
                    SawnOffProcess = {
                        Name = "Fusil à pompe",
                        ItemsGive = { { name = "steel", quantity = 60 }, { name = "plastic", quantity = 45 }, { name = "grease", quantity = 10 } },
                        ItemsGet = { { name = "weapon_sawnoffshotgun", quantity = 1 } },
                        Delay = 40000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    DoubleBarrelProcess = {
                        Name = "Double canon scié",
                        ItemsGive = { { name = "steel", quantity = 55 }, { name = "plastic", quantity = 40 }, { name = "grease", quantity = 10 } },
                        ItemsGet = { { name = "weapon_dbshotgun", quantity = 1 } },
                        Delay = 40000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 5,
                Coord = vector3(891.73, -3196.8, -99.18),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 72, g = 34, b = 43 },
                Name = "Fabrication de fusils à pompe",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = false,
            },

            -- assault rifles
            {
                Title = "Fabrication de fusils d'assaut",
                Process = {
                    GusenbergProcess = {
                        Name = "Gusenberg",
                        ItemsGive = { { name = "steel", quantity = 130 }, { name = "plastic", quantity = 110 }, { name = "grease", quantity = 15 } },
                        ItemsGet = { { name = "weapon_gusenberg", quantity = 1 } },
                        Delay = 40000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    ARProcess = {
                        Name = "AK-47",
                        ItemsGive = { { name = "steel", quantity = 125 }, { name = "plastic", quantity = 100 }, { name = "grease", quantity = 15 } },
                        ItemsGet = { { name = "weapon_assaultrifle", quantity = 1 } },
                        Delay = 50000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                    CompactARProcess = {
                        Name = "AK compact",
                        ItemsGive = { { name = "steel", quantity = 115 }, { name = "plastic", quantity = 85 }, { name = "grease", quantity = 10 } },
                        ItemsGet = { { name = "weapon_compactrifle", quantity = 1 } },
                        Delay = 35000,
                        Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                    },
                },
                MaxProcess = 5,
                Coord = vector3(884.92, -3199.9, -99.18),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 72, g = 34, b = 43 },
                Name = "Fabrication de fusils d'assaut",
                HelpText = GetString("press_traitement"),
                Marker = 27,
                Blip = false,
            },
        },
        BuyZones = {
            BuyMaterials = {
                Items = {
                    { name = "steel", price = 800, isDirtyMoney = true },
                    { name = "plastic", price = 350, isDirtyMoney = true },
                    { name = "gunpowder", price = 100, isDirtyMoney = true },
                    { name = "grease", price = 60, isDirtyMoney = true },
                },
                Coord = vector3(612.6, -3074.04, 5.09),
                Size = { x = 1.5, y = 1.5, z = 1.5 },
                Color = { r = 72, g = 34, b = 43 },
                Name = "Achat de matériaux",
                HelpText = GetString("press_buy"),
                Marker = 27,
                Blip = true,
            },
        },
    },
    orga_cartel = {
        isGang = true,
        LabelName = "Cartel",
        Zones = {
            Stock = {
                Coord = vector3(1402.51, 1152.79, 113.35),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Coffre",
                StockName = "orga_cartel",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(1394.72, 1157.10, 113.35),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(1404.57, 1114.41, 114.84),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 136, g = 243, b = 216 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_cartel",
                SpawnPoint = { Coord = vector3(1406.34, 1117.52, 114.84), Heading = 63.56 },
            },
            GangHeliGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(1458.70, 1111.70, 114.33),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 136, g = 243, b = 216 },
                Marker = 34,
                Type = "heli",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_cartel",
                SpawnPoint = { Coord = vector3(1458.70, 1111.70, 114.33), Heading = 63.56 },
            },
        },
    },
    orga_mafia = {
        isGang = true,
        LabelName = "Mafia",
        Zones = {
            Stock = {
                Coord = vector3(-854.99, 26.75, 40.56),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 136, g = 243, b = 216 },
                Name = "Coffre",
                StockName = "orga_mafia",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-871.18, -54.99, 38.03),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 136, g = 243, b = 216 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_mafia",
                SpawnPoint = { Coord = vector3(-871.18, -54.99, 38.03), Heading = 288.73 },
            },
        },
    },
    orga_hapf = {
        isGang = true,
        LabelName = "HAPF",
        Zones = {
            Stock = {
                Coord = vector3(-1108.60, -1643.52, 3.66),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 212, g = 0, b = 0 },
                Name = "Coffre",
                StockName = "orga_hapf",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            Cloakroom = {
                Coord = vector3(-1109.53, -1640.54, 3.66),
                Size = { x = 1.5, y = 1.5, z = 1.0 },
                Color = { r = 212, g = 0, b = 0 },
                Name = "Vestiaire",
                HelpText = GetString("press_to_open"),
                Marker = 27,
            },
            GangCarGarage = {
                Name = "Garage gang",
                HelpText = GetString("spawn_veh"),
                Coord = vector3(-1070.73, -1670.35, 4.44),
                Size = { x = 2.0, y = 2.0, z = 2.0 },
                Color = { r = 212, g = 0, b = 0 },
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                IsGangGarage = true,
                Identifier = "garage_hapf",
                SpawnPoint = { Coord = vector3(-1070.73, -1670.35, 4.44), Heading = 35.32 },
            },
        },
    },
    -- #endregion gangs / organizations
}

Config.JobCenter = {
    Blip = { Sprite = 682, Colour = 27 },
    JobList = {
        { JobName = "unemployed", Label = "Chômage", Desc = "Inscrivez vous au chômage pour recevoir des aides" },
        { JobName = "winemaker", Label = "🍇 Intérimaire Vigneron", Desc = "Travail dans les vignes pour la fabrication de jus et de vin" },
        { JobName = "tailor", Label = "🧶 Intérimaire Couturier", Desc = "Travail dans la couture et la fabrique de vêtements" },
    },
    Coord = vector3(-266.94, -960.04, 30.24),
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Color = { r = 255, g = 133, b = 85 },
    Name = "Pole Emploi",
    HelpText = GetString("press_to_open"),
    Marker = 27,
}

Config.BankManagment = {
    Blip = { Sprite = 525, Colour = 12, Scale = 0.6 },
    Coord = vector3(248.23, 222.42, 105.31),
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Color = { r = 74, g = 159, b = 86 },
    Name = "Compte entreprise",
    HelpText = GetString("press_to_open"),
    Marker = 27,
}
