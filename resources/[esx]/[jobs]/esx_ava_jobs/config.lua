-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config = {}
Config.DrawDistance = 30.0
Config.Locale = 'fr'
Config.MaxPickUp = 70
Config.MaxPickUpIllegal = 70
Config.JobMenuKey = "F6"

Config.JobMenuElement = {
    PoliceMegaphone = {
        Label = _('police_megaphone'),
        Detail = _('police_megaphone_detail'),
        AllowedVehicles = {
            GetHashKey('police'),
            GetHashKey('police2'),
            GetHashKey('police3'),
            GetHashKey('police4'),
            GetHashKey('fbi'),
            GetHashKey('fbi2'),
            GetHashKey('riot'),
            GetHashKey('riot2'),
            GetHashKey('policet'),
            GetHashKey('sheriff'),
            GetHashKey('sheriff2'),
            GetHashKey('riot'),
            GetHashKey('pranger'),
            GetHashKey('bcat'),
            GetHashKey('pbus'),
            GetHashKey('polbuffalo'),
            GetHashKey('polgauntlet'),
            GetHashKey('polbullet'),
            GetHashKey('polvacca'),
            GetHashKey('predator'),
            GetHashKey('umoracle')
        },
        Condition = function(jobName, playerPed)
            local veh = GetVehiclePedIsIn(playerPed, false)
            if veh ~= 0 and (GetPedInVehicleSeat(veh, -1) == playerPed or GetPedInVehicleSeat(veh, 0) == playerPed) then
                for k, vehicleHash in ipairs(Config.JobMenuElement.PoliceMegaphone.AllowedVehicles) do
                    if IsVehicleModel(veh, vehicleHash) then
                        return true
                    end
                end
            end
            return false
        end,
        Action = function(parentData, parentMenu, jobName)
            local elements = {
                {
                    label = _('police_megaphone_stop_vehicle'), type = "submenu", elements = {
                        {label = "LSPD! Stop...", detail = "LSPD! Stop your vehicle now!", distance = 30.0, volume = 0.6, soundName = "stop_vehicle"},
                        {label = "Driver! Stop...", detail = "Driver! Stop your vehicle", distance = 30.0, volume = 0.6, soundName = "stop_vehicle-2"},
                        {label = "Stop the fucking car...", detail = "This is the LSPD! Stop the fucking car immediately!", distance = 30.0, volume = 0.6, soundName = "stop_the_f_car"},
                        {label = "Stop or executed...", detail = "LSPD! Stop your vehicle now or you'll be executed!", distance = 30.0, volume = 0.6, soundName = "stop_or_executed"},
                        {label = "Stop or I kill ya...", detail = "Stop your vehicle right fucking now! Or I swear I am going to kill ya!", distance = 30.0, volume = 0.6, soundName = "stop_or_i_kill"}
                    }
                },
                {
                    label = _('police_megaphone_stop'), type = "submenu", elements = {
                        {label = "Dont make me...", detail = "Stop! Don't make me shoot ya! Give yourself up!", distance = 30.0, volume = 0.6, soundName = "dont_make_me"},
                        {label = "Dont move a muscle...", detail = "Stop and dont move a muscle, or you'll be shot by the LSPD!", distance = 30.0, volume = 0.6, soundName = "stop_dont_move"},
                        {label = "Give yourself up...", detail = "LSPD! If you give yourself up I'll be a lot nicer shithead!", distance = 30.0, volume = 0.6, soundName = "give_yourself_up"},
                        {label = "Stay right there...", detail = "LSPD! Stay right there and don't move, fucker!", distance = 30.0, volume = 0.6, soundName = "stay_right_there"},
                        {label = "Freeze...", detail = "Freeze! LSPD!", distance = 30.0, volume = 0.6, soundName = "freeze_lspd"},
                    }
                },
                {
                    label = _('police_megaphone_clear'), type = "submenu", elements = {
                        {label = "Clear the area...", detail = "This is the LSPD! Clear the area. Now!", distance = 30.0, volume = 0.6, soundName = "clear_the_area"},
                        {label = "Go away now...", detail = "This is the LSPD! Go away now or there will be trouble.", distance = 30.0, volume = 0.6, soundName = "this_is_the_lspd"},
                        {label = "Move along people...", detail = "Move along people. We don't want trouble.", distance = 30.0, volume = 0.6, soundName = "move_along_people"},
                        {label = "Get out of here...", detail = "Get out of here now. This is the LSPD.", distance = 30.0, volume = 0.6, soundName = "get_out_of_here_now"},
                        {label = "Disperse now...", detail = "This is the LSPD! Disperse, now!", distance = 30.0, volume = 0.6, soundName = "disperse_now"},
                    }
                },
                {
                    label = _('police_megaphone_insult'), type = "submenu", elements = {
                        {label = "It's over...", detail = "It's over for you! This is the police!", distance = 30.0, volume = 0.6, soundName = "its_over_for_you"},
                        {label = "You are finished...", detail = "You are finished dickhead! Stop!", distance = 30.0, volume = 0.6, soundName = "you_are_finished_dhead"},
                        {label = "You can't hide boy...", detail = "You can't hide boy. We will track you down!", distance = 30.0, volume = 0.6, soundName = "cant_hide_boi"},
                        {label = "Drop a missile...", detail = "Can't we just drop a missile on this moron?!", distance = 30.0, volume = 0.6, soundName = "drop_a_missile"},
                        {label = "Shoot to kill...", detail = "This is the LSPD! I'm gonna shoot to kill!", distance = 30.0, volume = 0.6, soundName = "shoot_to_kill"},
                    }
                },

            }
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_jobs_megaphone_menu',
            {
                title = _('police_megaphone'),
                align = 'left',
                elements = elements
            },
            function(data, menu)
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_jobs_megaphone_submenu',
                {
                    title = _('police_megaphone'),
                    align = 'left',
                    elements = data.current.elements
                },
                function(data2, menu2)
                    if Config.JobMenuElement.PoliceMegaphone.Condition(jobName, PlayerPedId()) then
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", data2.current.distance, data2.current.soundName, data2.current.volume)
                    else
                        menu2.close()
                        menu.close()
                    end
                end,
                function(data2, menu2)
                    menu2.close()
                    CurrentActionEnabled = true
                end)
            end,
            function(data, menu)
                menu.close()
                CurrentActionEnabled = true
            end)
        end
    },
}


Config.Jobs = {
    lspd = {
        SocietyName = 'society_lspd',
        LabelName = 'LSPD',
        ServiceCounter = true,
        Blip = {
            Name = "~b~Commissariat",
            Sprite = 60,
            Colour = 3
        },
        JobMenu = {
            {
                Label = _('fine'),
                Detail = _('fine_detail'),
                Action = function(parentData, parentMenu, jobName)
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fine_amount',
                    {
                        title = _('fine_amount')
                    },
                    function(data, menu)
                        local amount = tonumber(data.value)
                        if amount == nil or amount <= 0 then
                            ESX.ShowNotification(_('amount_invalid'))
                        else
                            menu.close()
                            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), "fine_reason", {
                                title = _('fine_reason')
                            }, function(data2, menu2)
                                menu2.close()
                                local reason = data2.value
                                exports.esx_avan0x:ChooseClosestPlayer(function(targetId)
                                    local playerPed = PlayerPedId()

                                    Citizen.CreateThread(function()
                                        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                                        Citizen.Wait(5000)
                                        ClearPedTasks(playerPed)
                                        TriggerServerEvent('esx_billing:sendBill1', targetId, Config.Jobs[jobName].SocietyName, string.len(reason) > 0 and "Amende : " .. reason or "Amende", amount)
                                    end)
                                end)

                            end, function(data2, menu2)
                                menu2.close()
                            end)
                        end
                    end,
                    function(data, menu)
                        menu.close()
                    end)
                end
            },
            {
                Label = _('search'),
                Detail = _('search_detail'),
                Action = function(parentData, parentMenu, jobName)
                    exports.esx_avan0x:ChooseClosestPlayer(function(targetId)
                        TriggerServerEvent('esx_avan0x:showNotification', targetId, _('being_searched'))
                        TriggerEvent("esx_ava_inventories:openPlayerInventory", targetId)
                    end)
                end
            },
            {
                Label = _('check_bills'),
                Detail = _('check_bills_detail'),
                Type = "submenu",
                Action = function(parentData, parentMenu, jobName)
                    exports.esx_avan0x:ChooseClosestPlayer(function(targetId)
                        ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
                            local elements = {}
                            for k, bill in ipairs(bills) do
                                table.insert(elements, {label = _("unpaid_bill", bill.label, bill.amount)})
                            end
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
                                title    = _('unpaid_bills'),
                                align    = 'left',
                                elements = elements
                            },
                            nil,
                            function(data, menu)
                                menu.close()
                            end)
                        end, targetId)
                    end)
                end
            },
            {
                Label = _('manage_licences'),
                Detail = _('manage_licences_detail'),
                Type = "submenu",
                Action = function(parentData, parentMenu, jobName)
                    exports.esx_avan0x:ChooseClosestPlayer(function(targetId)
                        local elements = {}

                        ESX.TriggerServerCallback('esx_ava_jobs:getPlayerData', function(playerData)
                            if playerData.licenses then
                                for k, v in pairs(playerData.licenses) do
                                    if v.label and v.type then
                                        table.insert(elements, {label = v.label, type = v.type, detail = _('license_revoke')})
                                    end
                                end
                            end

                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_licences', {
                                title    = _('manage_licences'),
                                align    = 'top-left',
                                elements = elements,
                            }, function(data, menu)
                                ESX.ShowNotification(_('licence_you_revoked', data.current.label, playerData.firstname .. ' ' .. playerData.lastname))
                                TriggerServerEvent('esx_avan0x:showNotification', targetId, _('license_revoked', data.current.label))

                                TriggerServerEvent('esx_license:removeLicense', targetId, data.current.type)

                                menu.close()
                            end, function(data, menu)
                                menu.close()
                            end)

                        end, targetId)
                    end)
                end,
                ExcludeGrades = {"recruit"}
            },
            {
                Label = _('manage_weapon_license'),
                Detail = _('manage_weapon_license_detail'),
                Action = function(parentData, parentMenu, jobName)
                    exports.esx_avan0x:ChooseClosestPlayer(function(targetId)
                        ESX.TriggerServerCallback('esx_ava_jobs:getPlayerData', function(playerData)
                            local alreadyOwn = false
                            if playerData.licenses then
                                for k, v in pairs(playerData.licenses) do
                                    if v.type == "weapon" then
                                        alreadyOwn = true
                                    end
                                end
                            end

                            if alreadyOwn then
                                ESX.ShowNotification(_('already_own_weapon_licence', playerData.firstname .. ' ' .. playerData.lastname))
                            else
                                ESX.ShowNotification(_('you_gave_weapon_licence', playerData.firstname .. ' ' .. playerData.lastname))
                                TriggerServerEvent('esx_license:addLicense', targetId, 'weapon')
                                TriggerServerEvent('esx_avan0x:showNotification', targetId, _('license_weapon_gived'))
                            end


                        end, targetId)
                    end)

                end,
                OnlyGrades = {"sergeant_chef", "lieutenant", "chef", "boss"}
            },
            {
                Label = _('info_vehicle'),
                Detail = _('info_vehicle_detail'),
                Action = function(parentData, parentMenu, jobName)
                    exports.esx_avan0x:ChooseClosestVehicle(function(vehicle)
                        local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                        ESX.TriggerServerCallback('esx_ava_jobs:getVehicleInfos', function(vehicleInfos)
                            local elements = {
                                {label = _('vehicle_plate', vehicleInfos.plate)}
                            }

                            table.insert(elements, {label = _('vehicle_owner', vehicleInfos.owner or _('vehicle_owner_unknown'))})

                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'info_vehicle', {
                                title = _('info_vehicle'),
                                align = 'left',
                                elements = elements
                            },
                            nil,
                            function(data, menu)
                                menu.close()
                            end)
                        end, vehicleData.plate)
                    end)

                end
            },
            Config.JobMenuElement.PoliceMegaphone
        },
        Zones = {
            JobActions = {
                Pos = vector3(451.95, -973.39, 29.71),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 122, b = 204},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(452.76, -992.84, 29.71),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 122, b = 204},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Outfits = {
                    {
                        Label = "Cadet manches courtes",
                        Male = json.decode('{"bags_2":0,"pants_1":59,"pants_2":0,"chain_2":0,"bags_1":0,"tshirt_2":0,"helmet_2":0,"torso_1":102,"shoes_2":0,"helmet_1":-1,"chain_1":0,"bproof_2":0,"torso_2":0,"arms":19,"bproof_1":0,"tshirt_1":59,"shoes_1":25}'),
                        Female = json.decode('{}'),
                        OnlyGrades = {"recruit"}
                    },
                    {
                        Label = "Cadet manches longues",
                        Male = json.decode('{"bags_2":0,"pants_1":59,"pants_2":0,"chain_2":0,"bags_1":0,"tshirt_2":0,"helmet_2":0,"torso_1":101,"shoes_2":0,"helmet_1":-1,"chain_1":0,"bproof_2":0,"torso_2":0,"arms":20,"bproof_1":0,"tshirt_1":59,"shoes_1":25}'),
                        Female = json.decode('{}'),
                        OnlyGrades = {"recruit"}
                    },
                    {
                        Label = "Tenue manches courtes",
                        Male = json.decode('{"pants_1":59,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":102,"tshirt_1":53,"torso_2":0,"bproof_1":0,"arms":19,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_2":0,"helmet_1":-1,"chain_1":0}'),
                        Female = json.decode('{"pants_1":61,"bags_2":0,"bags_1":84,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":93,"tshirt_1":27,"torso_2":0,"bproof_1":0,"helmet_2":0,"arms":31,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_1":-1,"chain_1":1}')
                    },
                    {
                        Label = "Tenue manches longues",
                        Male = json.decode('{"pants_1":59,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":101,"tshirt_1":53,"torso_2":0,"bproof_1":0,"arms":20,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_2":0,"helmet_1":-1,"chain_1":0}'),
                        Female = json.decode('{"pants_1":61,"bags_2":0,"bags_1":84,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":92,"tshirt_1":27,"torso_2":0,"bproof_1":0,"helmet_2":0,"arms":3,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_1":-1,"chain_1":1}')
                    },
                    {
                        Label = "Tenue hiver",
                        Male = json.decode('{"pants_1":59,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":103,"tshirt_1":65,"torso_2":0,"bproof_1":0,"arms":27,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_2":0,"helmet_1":-1,"chain_1":0}'),
                        Female = json.decode('{"pants_1":61,"bags_2":0,"bags_1":84,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":119,"tshirt_1":45,"torso_2":1,"bproof_1":0,"helmet_2":0,"arms":7,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_1":-1,"chain_1":1}')
                    },
                    {
                        Label = "Tenue SWAT",
                        Male = json.decode('{"pants_1":59,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":93,"tshirt_1":53,"torso_2":1,"bproof_1":0,"arms":19,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_2":0,"helmet_1":-1,"chain_1":0}'),
                        Female = json.decode('{"pants_1":61,"bags_2":0,"bags_1":74,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":84,"tshirt_1":33,"torso_2":1,"bproof_1":0,"helmet_2":0,"arms":31,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_1":-1,"chain_1":1}')
                    },
                    {
                        Label = "Tenue SWAT Lourd",
                        Male = json.decode('{"pants_1":59,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":0,"chain_2":1,"torso_1":219,"tshirt_1":44,"torso_2":2,"bproof_1":7,"arms":17,"shoes_1":25,"bproof_2":0,"shoes_2":0,"helmet_2":0,"helmet_1":75,"chain_1":0}'),
                        Female = json.decode('{"pants_1":90,"bags_2":0,"bags_1":74,"tshirt_2":0,"pants_2":2,"chain_2":0,"torso_1":43,"tshirt_1":33,"torso_2":0,"bproof_1":11,"helmet_2":0,"arms":49,"shoes_1":25,"bproof_2":3,"shoes_2":0,"helmet_1":74,"chain_1":1}')
                    },
                    {
                        Label = "Tenue DOA",
                        Male = json.decode('{"pants_1":59,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":102,"tshirt_1":53,"torso_2":0,"bproof_1":7,"arms":19,"shoes_1":25,"bproof_2":4,"shoes_2":0,"helmet_2":0,"helmet_1":-1,"chain_1":0}'),
                        Female = json.decode('{"pants_1":61,"bags_2":0,"bags_1":74,"tshirt_2":0,"pants_2":0,"chain_2":0,"torso_1":93,"tshirt_1":27,"torso_2":0,"bproof_1":7,"helmet_2":0,"arms":31,"shoes_1":25,"bproof_2":3,"shoes_2":0,"helmet_1":-1,"chain_1":1}')
                    },
                    {
                        Label = "Tenue vélo",
                        Male = json.decode('{"pants_1":32,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":1,"chain_2":0,"torso_1":93,"tshirt_1":15,"torso_2":0,"bproof_1":1,"arms":30,"shoes_1":13,"bproof_2":0,"shoes_2":0,"helmet_2":0,"helmet_1":49,"chain_1":0}'),
                        Female = json.decode('{"pants_1":31,"bags_2":0,"bags_1":42,"tshirt_2":0,"pants_2":1,"chain_2":0,"torso_1":84,"tshirt_1":51,"torso_2":2,"bproof_1":0,"helmet_2":0,"arms":31,"shoes_1":10,"bproof_2":0,"shoes_2":0,"helmet_1":47,"chain_1":1}')
                    },
                    {
                        Label = "Tenue moto",
                        Male = json.decode('{"pants_1":32,"bags_2":0,"bags_1":0,"tshirt_2":0,"pants_2":1,"chain_2":0,"torso_1":154,"tshirt_1":13,"torso_2":0,"bproof_1":0,"arms":22,"shoes_1":13,"bproof_2":0,"shoes_2":0,"helmet_2":1,"helmet_1":79,"chain_1":0}'),
                        Female = json.decode('{"pants_1":31,"bags_2":0,"bags_1":48,"tshirt_2":0,"pants_2":1,"chain_2":0,"torso_1":21,"tshirt_1":27,"torso_2":3,"bproof_1":0,"helmet_2":0,"arms":32,"shoes_1":40,"bproof_2":0,"shoes_2":0,"helmet_1":78,"chain_1":0}')
                    }
                }
            },
            ArmoryStock = {
				Pos = vector3(452.28, -980.15, 29.71),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 122, b = 204},
				Name  = "Armurerie",
                StockName = "society_lspd_armory",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            SeizureStock = {
				Pos = vector3(472.63, -990.40, 23.93),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 122, b = 204},
				Name  = "Coffre saisies",
                StockName = "society_lspd_seizure",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(455.02, -1017.44, 28.44),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 122, b = 204},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(455.02, -1017.44, 28.44),
                    Heading = 90.0
                }
            },
            HeliGarage = {
                Name  = "Héliport",
                HelpText = _('spawn_veh'),
                Pos = vector3(449.57, -981.17, 43.69),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 122, b = 204},
                Distance = 3,
                Marker = 34,
                Type = "heli",
                SpawnPoint = {
                    Pos = vector3(449.57, -981.17, 43.69),
                    Heading = 90.0
                }
            },
            BoatGarage = {
                Name  = "Marina",
                HelpText = _('spawn_veh'),
                Pos = vector3(-784.55, -1437.14, 1.40),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 122, b = 204},
                Distance = 5,
                Marker = 35,
                Type = "boat",
                SpawnPoint = {
                    Pos = vector3(-786.55, -1437.14, 1.40),
                    Heading = 140.0
                },
                Blip = true
            },
            SeizedCarGarage = {
                Name = "Garage saisies",
                HelpText = _('spawn_veh'),
                Pos = vector3(447.44, -997.07, 25.76),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 221, g = 79, b = 67},
                Marker = 36,
                Type = "car",
                IsNonProprietaryGarage = true,
                Identifier = "seized_LSPD",
                SpawnPoint = {
                    Pos = vector3(447.44, -997.07, 24.78),
                    Heading = 180.0
                }
            },
        },
        BuyZones = {
            BuyItems = {
                Items = {
                    {name = 'bproof_vest', price = 15000},
                    {name = 'handcuffs', price = 10000},
                },
                Pos = vector3(812.26, -2153.55, 28.64),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 221, g = 79, b = 67},
                Name = "Achat de protections et menottes",
                HelpText = _('press_buy'),
                OnlyGrades = {"chef", "boss"},
                Marker = 27,
                Blip = true
            }
        }
    },
    ems = {
        SocietyName = 'society_ems',
        LabelName = 'EMS',
        ServiceCounter = true,
        Blip = {
            Name = "~b~Hopital",
            Pos = vector3(298.48, -584.48, 43.28),
            Sprite = 61,
            Colour = 26
        },
        JobMenu = {
            {
                Label = _('ems_check_injuries'),
                Detail = _('ems_check_injuries_detail'),
                Action = function(parentData, parentMenu, jobName)
                    exports.esx_avan0x:ChooseClosestPlayer(function(targetId)
                        ESX.TriggerServerCallback('esx_ava_jobs:ems:getTargetData', function(playerData)
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_check_injuries', {
                                title = _('ems_check_injuries'),
                                align = 'left',
                                elements = {
                                    {
                                        label = _('ems_injuries_label',
                                            playerData.injured > 0 and "#c92e2e" or "#329171",
                                            playerData.injured > 50
                                                and _('ems_injuries_injured_high')
                                                or playerData.injured > 30
                                                    and _('ems_injuries_injured')
                                                    or playerData.injured > 0
                                                        and _('ems_injuries_injured_low')
                                                        or _('ems_injuries_healthy')
                                        )
                                    }
                                }
                            },
                            nil,
                            function(data, menu)
                                menu.close()
                            end)
                
                        end, targetId)
                    end)
                
                end
            },
        },
        Zones = {
            JobActions = {
                Pos = vector3(339.21, -595.63, 42.30),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 139, b = 90},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true,
                NoStock = true,
                OnlyGrades = {"boss"}
            },
            Dressing = {
                Pos = vector3(299.03, -598.51, 42.30),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 139, b = 90},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
            },
            PharmacyStock = {
				Pos = vector3(309.77, -568.66, 42.30),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 139, b = 90},
				Name  = "Pharmacie",
                StockName = "society_ems_pharmacy",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(337.34, -579.28, 28.80),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 139, b = 90},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(337.34, -579.28, 28.80),
                    Heading = 340.0
                }
            },
            KitchenStock = {
				Pos = vector3(306.89, -601.61, 42.30),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 0, g = 139, b = 90},
				Name  = "Cuisine",
                StockName = "society_ems",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            HeliGarage = {
                Name  = "Héliport",
                HelpText = _('spawn_veh'),
                Pos = vector3(351.05, -588.07, 74.17),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 139, b = 90},
                Distance = 3,
                Marker = 34,
                Type = "heli",
                SpawnPoint = {
                    Pos = vector3(351.05, -588.07, 74.17),
                    Heading = 245.0
                }
            },
        },
        BuyZones = {
            BuyItems = {
                Items = {
                    {name = 'ethylotest', price = 15000},
                    {name = 'defibrillator', price = 15000},
                    {name = 'bandage', price = 15000},
                    {name = 'medikit', price = 15000},
                },
                Pos = vector3(-447.57, -341.08, 33.52),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 0, g = 139, b = 90},
                Name = "Pharmacie",
                HelpText = _('press_buy'),
                OnlyGrades = {"doctor", "boss"},
                Marker = 27,
                Blip = true
            }
        }
    },
    vigneron = {
        SocietyName = 'society_vigneron',
        LabelName = 'Vigneron',
        Blip = {
            Sprite = 85,
            Colour = 19
        },
        Zones = {
            JobActions = {
                Pos = vector3(-1895.18, 2063.98, 140.03),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(-1874.90, 2054.53, 140.09),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(-1888.97, 2045.06, 140.87),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 255, b = 0},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(-1898.16, 2048.77, 139.89),
                    Heading = 70.0
                },
                Blip = true
            },
        },
        FieldZones = {
            RaisinField = {
                Items = {
                    {name = 'raisin', quantity = 8}
                },
                PropHash = GetHashKey('prop_mk_race_chevron_02'),
                Pos = vector3(-1809.662, 2210.119, 90.681),
                GroundCheckHeights = {88.0, 89.0, 90.0, 91.0, 92.0, 93.0, 94.0, 95.0, 96.0, 97.0, 98.0, 99.0, 100.0},
                Name = "1. Récolte",
                Blip = true
            }
        },
        ProcessZones = {
            VineProcess = {
                ItemsGive = {
                    {name = 'raisin', quantity = 10}
                },
                ItemsGet = {
                    {name = 'vine', quantity = 1},
                    {name = 'jus_raisin', quantity = 1}
                },
                Delay = 6000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(-1930.97, 2055.08, 139.83),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "2. Traitement vin",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            },
            ChampagneProcess = {
                ItemsGive = {
                    {name = 'raisin', quantity = 10}
                },
                ItemsGet = {
                    {name = 'champagne', quantity = 1},
                    {name = 'grand_cru', quantity = 1}
                },
                Delay = 8000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(-1866.50, 2058.95, 140.02),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "Traitement champagne et grand cru",
                HelpText = _('press_traitement'),
                ExcludeGrades = {"interim"},
                Marker = 27,
                Blip = true
            }
        },
        ProcessMenuZones = {
            BoxingProcess = {
                Title = 'Mise en caisse',
                Process = {
                    VineProcess = {
                        Name = 'Caisse de Vin',
                        ItemsGive = {
                            {name = 'vine', quantity = 6},
                            {name = 'woodenbox', quantity = 1}
                        },
                        ItemsGet = {
                            {name = 'vinebox', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                    },
                    JusRaisinProcess = {
                        Name = 'Caisse de Jus de raisin',
                        ItemsGive = {
                            {name = 'jus_raisin', quantity = 6},
                            {name = 'woodenbox', quantity = 1}
                        },
                        ItemsGet = {
                            {name = 'jus_raisinbox', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                    },
                    ChampagneProcess = {
                        Name = 'Caisse de Champagne',
                        ItemsGive = {
                            {name = 'champagne', quantity = 6},
                            {name = 'woodenbox', quantity = 1}
                        },
                        ItemsGet = {
                            {name = 'champagnebox', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                    },
                    GrandCruProcess = {
                        Name = 'Caisse de Grand Cru',
                        ItemsGive = {
                            {name = 'grand_cru', quantity = 6},
                            {name = 'woodenbox', quantity = 1}
                        },
                        ItemsGet = {
                            {name = 'grand_crubox', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                    }
                },
                MaxProcess = 3,
                Pos = vector3(-1933.06, 2061.9, 139.86),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "4. Traitement en caisses",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            }
        },
        SellZones = {
            WineMerchantSell = {
                Items = {
                    {name = 'vinebox', price = 1600},
                    {name = 'jus_raisinbox', price = 650}
                },
                Pos = vector3(-158.737, -54.651, 53.42),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "5. Vente des produits",
                HelpText = _('press_sell'),
                Marker = 27,
                Blip = true
            }
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    {name = 'woodenbox', price = 20}
                },
                Pos = vector3(396.77, -345.88, 45.86),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "3. Achat de caisses",
                HelpText = _('press_buy'),
                Marker = 27,
                Blip = true
            }
        }
    },
    tailor = {
        SocietyName = 'society_tailor',
        LabelName = 'Couturier',
        Blip = {
            Sprite = 366,
            Colour = 0
        },
        Zones = {
            JobActions = {
                Pos = vector3(708.48, -966.69, 29.42),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(708.91, -959.63, 29.42),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(719.11, -989.22, 24.12),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 255, b = 0},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(719.11, -989.22, 23.12),
                    Heading = 279.0
                },
                Blip = true
            },
        },
        FieldZones = {
            WoolField = {
                Items = {
                    {name = 'wool', quantity = 8}
                },
                PropHash = GetHashKey('prop_mk_race_chevron_02'),
                Pos = vector3(1887.45, 4630.05, 37.12),
                GroundCheckHeights = {36, 37, 38, 39, 40, 41},
                Name = "1. Récolte",
                Blip = true
            },
        },
        ProcessZones = {
            FabricProcess = {
                ItemsGive = {
                    {name = 'wool', quantity = 10}
                },
                ItemsGet = {
                    {name = 'fabric', quantity = 4}
                },
                Delay = 4000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(712.75, -973.78, 29.42),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "2. Traitement laine",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            },
            ClotheProcess = {
                ItemsGive = {
                    {name = 'fabric', quantity = 2}
                },
                ItemsGet = {
                    {name = 'clothe', quantity = 1}
                },
                Delay = 4000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(716.5, -961.82, 29.42),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "3. Traitement du tissu",
                HelpText = _('press_traitement'),
                NoInterim = false,
                Marker = 27,
                Blip = true
            },
            ClothesBoxProcess = {
                ItemsGive = {
                    {name = 'clothe', quantity = 9},
                    {name = 'cardboardbox', quantity = 1}
                },
                ItemsGet = {
                    {name = 'clothebox', quantity = 1}
                },
                Delay = 3000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(718.73, -973.74, 29.42),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "5. Mise en caisse des vetements",
                HelpText = _('press_traitement'),
                NoInterim = false,
                Marker = 27,
                Blip = true
            }
        },
        SellZones = {
            ClothesSell = {
                Items = {
                    {name = 'clothebox', price = 1420}
                },
                Pos = vector3(71.67, -1390.47, 28.4),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "6. Vente des produits",
                HelpText = _('press_sell'),
                Marker = 27,
                Blip = true
            }
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    {name = 'cardboardbox', price = 20}
                },
                Pos = vector3(406.5, -350.02, 45.84),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "4. Achat de cartons",
                HelpText = _('press_buy'),
                Marker = 27,
                Blip = true
            }
        }
    },
    cluckin = {
        SocietyName = 'society_cluckin',
        LabelName = 'Cluckin Bell',
        Blip = {
            Sprite = 141,
            Colour = 46
                },
        Zones = {
            JobActions = {
                Pos = vector3(-513.13, -699.59, 32.19),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(-510.19, -700.42, 32.19),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(-465.3, -619.36, 31.17),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 255, b = 0},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(-465.3, -619.36, 31.17),
                    Heading = 86.0
                },
                Blip = true
            },
        },
        FieldZones = {
            ChickenField = {
                Items = {
                    {name = 'alive_chicken', quantity = 2}
                },
                PropHash = 610857585,
                Pos = vector3(85.95, 6331.61, 30.25),
                GroundCheckHeights = {29, 30, 31, 32},
                Name = "1. Récolte",
                Blip = true
            },
        },
        ProcessZones = {
            PluckProcess = {
                ItemsGive = {
                    {name = 'alive_chicken', quantity = 2}
                },
                ItemsGet = {
                    {name = 'plucked_chicken', quantity = 2}
                },
                Delay = 8000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(-91.05, 6240.41, 30.11),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "2. Déplumage",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            },
            RawProcess = {
                ItemsGive = {
                    {name = 'plucked_chicken', quantity = 2}
                },
                ItemsGet = {
                    {name = 'raw_chicken', quantity = 8}
                },
                Delay = 10000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(-103.89, 6206.29, 30.05),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "3. Découpe",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            }
        },
        ProcessMenuZones = {
            CookingProcess = {
                Title = 'Cuisine',
                Process = {
                    NuggetsProcess = {
                        Name = 'Nuggets',
                        ItemsGive = {
                            {name = 'raw_chicken', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'nuggets', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    ChickenBurgerProcess = {
                        Name = 'Chicken Burger',
                        ItemsGive = {
                            {name = 'raw_chicken', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'chickenburger', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    DoubleChickenBurgerProcess = {
                        Name = 'Double Chicken Burger',
                        ItemsGive = {
                            {name = 'raw_chicken', quantity = 4}
                        },
                        ItemsGet = {
                            {name = 'doublechickenburger', quantity = 1}
                        },
                        Delay = 3000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    TendersProcess = {
                        Name = 'Tenders',
                        ItemsGive = {
                            {name = 'raw_chicken', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'tenders', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    ChickenWrapProcess = {
                        Name = 'Wrap au poulet',
                        ItemsGive = {
                            {name = 'raw_chicken', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'chickenwrap', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    FritesProcess = {
                        Name = 'Frites',
                        ItemsGive = {
                            {name = 'potato', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'frites', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    PotatoesProcess = {
                        Name = 'Potatoes',
                        ItemsGive = {
                            {name = 'potato', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'potatoes', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    }
                },
                MaxProcess = 5,
                Pos = vector3(-520.07, -701.52, 32.19),
                Size = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name = "Cuisine",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            }
        },
        SellZones = {
            ChickenSell = {
                Items = {
                    {name = 'raw_chicken', price = 100}
                },
                Pos = vector3(-138.13, -256.69, 42.61),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "4. Vente des produits",
                HelpText = _('press_sell'),
                Marker = 27,
                Blip = true
            }
        },
        BuyZones = {
            BuyDrinks = {
                Items = {
                    {name = 'potato', price = 20},
                    {name = 'icetea', price = 20},
                    {name = 'sprite', price = 20},
                    {name = 'orangina', price = 20},
                    {name = 'cocacola', price = 20}
                },
                Pos = vector3(406.5, -350.02, 45.84),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "Achat de boissons",
                HelpText = _('press_buy'),
                Marker = 27,
                Blip = true
            }
        }
    },
    bahama = {
        Disabled = true,
        SocietyName = 'society_bahama',
        LabelName = 'Bahama',
        Blip = {
            Sprite = 93,
            Colour = 0
        },
        Zones = {
            JobActions = {
                Pos = vector3(-1390.48, -600.57, 29.34),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(-1386.81, -608.41, 29.34),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(-1419.26, -596.3, 30.45),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 255, b = 0},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(-1419.26, -596.3, 30.45),
                    Heading = 299.0
                },
                Blip = true
            },
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    {name = 'icetea', price = 15},
                    {name = 'sprite', price = 15},
                    {name = 'orangina', price = 15},
                    {name = 'coffee', price = 13},
                    {name = 'cocacola', price = 15},
                    {name = 'ice', price = 2},
                    {name = 'martini', price = 20},
                    {name = 'martini2', price = 20},
                    {name = 'rhum', price = 20},
                    {name = 'tequila', price = 20},
                    {name = 'vodka', price = 20},
                    {name = 'beer', price = 20},
                    {name = 'whisky', price = 20}
                },
                Pos = vector3(376.81, -362.84, 45.85),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "Achat de boissons",
                HelpText = _('press_buy'),
                Marker = 27,
                Blip = true
            }
        }
    },
    unicorn = {
        SocietyName = 'society_unicorn',
        LabelName = 'Unicorn',
        Blip = {
            Sprite = 121,
            Colour = 0
        },
        Zones = {
            JobActions = {
                Pos = vector3(132.14, -1290.15, 28.29),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(106.71, -1299.75, 27.79),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27,
                Blip = true
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(144.25, -1284.85, 29.34),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 0, g = 255, b = 0},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(144.25, -1284.85, 29.34),
                    Heading = 298.0
                },
                Blip = true
            },
        },
        FieldZones = {
            OrangesField = {
                Items = {
                    {name = 'orange', quantity = 8}
                },
                PropHash = GetHashKey('ex_mp_h_acc_fruitbowl_01'),
                Pos = vector3(373.23, 6511.44, 28.31),
                GroundCheckHeights = {27.0, 28.0, 29.0},
                Name = "1. Récolte d'oranges",
                Blip = true
            }
        },
        SellZones = {
            OrangeSell = {
                Items = {
                    {name = 'orange', price = 40},
                },
                Pos = vector3(106.17, -1280.60, 28.27),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "2. Vente d'oranges",
                HelpText = _('press_sell'),
                Marker = 27,
                Blip = true
            }
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    {name = 'icetea', price = 15},
                    {name = 'sprite', price = 15},
                    {name = 'orangina', price = 15},
                    {name = 'coffee', price = 13},
                    {name = 'cocacola', price = 15},
                    {name = 'ice', price = 2},
                    {name = 'martini', price = 20},
                    {name = 'martini2', price = 20},
                    {name = 'rhum', price = 20},
                    {name = 'tequila', price = 20},
                    {name = 'vodka', price = 20},
                    {name = 'beer', price = 20},
                    {name = 'whisky', price = 20}
                },
                Pos = vector3(387.02, -343.28, 45.85),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name = "Achat de boissons",
                HelpText = _('press_buy'),
                Marker = 27,
                Blip = true
            }
        }
    },
    nightclub = {
        SocietyName = 'society_nightclub',
        LabelName = 'Galaxy',
        Blip = {
            Pos = vector3(-676.83, -2458.79, 12.96),
            Sprite = 614,
            Colour = 7
        },
        Zones = {
            JobActions = {
                Pos = vector3(-1583.19, -3014.04, -76.99),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 156, g = 110, b = 175},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(-1619.66, -3020.41, -76.19),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 156, g = 110, b = 175},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(-685.96, -2481.24, 13.83),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 156, g = 110, b = 175},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(-685.96, -2481.24, 13.83),
                    Heading = 299.0
                },
                Blip = true
            },
        },
        BuyZones = {
            BuyBox = {
                Items = {
                    {name = 'icetea', price = 15},
                    {name = 'sprite', price = 15},
                    {name = 'orangina', price = 15},
                    {name = 'coffee', price = 13},
                    {name = 'cocacola', price = 15},
                    {name = 'ice', price = 2},
                    {name = 'martini', price = 20},
                    {name = 'martini2', price = 20},
                    {name = 'rhum', price = 20},
                    {name = 'tequila', price = 20},
                    {name = 'vodka', price = 20},
                    {name = 'beer', price = 20},
                    {name = 'whisky', price = 20}
                },
                Pos = vector3(376.81, -362.84, 45.85),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 156, g = 110, b = 175},
                Name = "Achat de boissons",
                HelpText = _('press_buy'),
                Marker = 27,
                Blip = true
            }
        }
    },
    attackataco = {
        SocietyName = 'society_attackataco',
        LabelName = 'Attack-A-Taco',
        Blip = {
            Sprite = 468,
            Colour = 46
        },
        Zones = {
            JobActions = {
                Pos = vector3(17.27, -1602.66, 28.40),
                Size = {x = 1.0, y = 1.0, z = 1.5},
                Color = {r = 255, g = 217, b = 106},
                Name = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(20.20, -1601.98, 28.40),
                Size = {x = 1.0, y = 1.0, z = 1.5},
                Color = {r = 255, g = 217, b = 106},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            CarGarage = {
                Name = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(17.83, -1595.44, 29.28),
                Size = {x = 2.0, y = 2.0, z = 2.0},
                Color = {r = 255, g = 217, b = 106},
                Marker = 36,
                Type = "car",
                SpawnPoint = {
                    Pos = vector3(17.83, -1595.44, 29.28),
                    Heading = 50.0
                },
                Blip = true
            },
        },
        FieldZones = {
            CowField = {
                Items = {
                    {name = 'cow_part', quantity = 2}
                },
                PropHash = GetHashKey('prop_mk_race_chevron_02'),
                Pos = vector3(996.82, -2123.07, 30.48),
                GroundCheckHeights = {29, 30},
                Name = "1. Récolte",
                Radius = 5,
                Blip = true
            },
        },
        ProcessZones = {
            RawProcess = {
                ItemsGive = {
                    {name = 'cow_part', quantity = 2}
                },
                ItemsGet = {
                    {name = 'minced_meat', quantity = 2}
                },
                Delay = 12000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(994.46, -2162.40, 28.49),
                Size = {x = 5.0, y = 5.0, z = 3.5},
                Distance = 2.5,
                Color = {r = 255, g = 217, b = 106},
                Name = "2. Hachage",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            }
        },
        ProcessMenuZones = {
            CookingProcess = {
                Title = 'Cuisine',
                Process = {
                    ChickenBurgerProcess = {
                        Name = 'Tacos Spicy Audacieux',
                        ItemsGive = {
                            {name = 'minced_meat', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'tacos_odacious', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    DoubleChickenBurgerProcess = {
                        Name = 'Tacos Impensable',
                        ItemsGive = {
                            {name = 'minced_meat', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'tacos_impensable', quantity = 1}
                        },
                        Delay = 3000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    TendersProcess = {
                        Name = 'Tacos Gourmet du chef',
                        ItemsGive = {
                            {name = 'minced_meat', quantity = 3}
                        },
                        ItemsGet = {
                            {name = 'tacos_gourmet', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    FritesProcess = {
                        Name = 'Frites',
                        ItemsGive = {
                            {name = 'potato', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'frites', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    },
                    PotatoesProcess = {
                        Name = 'Potatoes',
                        ItemsGive = {
                            {name = 'potato', quantity = 2}
                        },
                        ItemsGet = {
                            {name = 'potatoes', quantity = 1}
                        },
                        Delay = 2000,
                        Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
                    }
                },
                MaxProcess = 5,
                Pos = vector3(11.50, -1599.42, 28.40),
                Size = {x = 1.0, y = 1.0, z = 1.5},
                Color = {r = 255, g = 217, b = 106},
                Name = "Cuisine",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            }
        },
        SellZones = {
            ChickenSell = {
                Items = {
                    {name = 'minced_meat', price = 80}
                },
                Pos = vector3(445.93, -1241.86, 29.30),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 255, g = 217, b = 106},
                Name = "4. Vente des produits",
                HelpText = _('press_sell'),
                Marker = 27,
                Blip = true
            }
        },
        BuyZones = {
            BuyDrinks = {
                Items = {
                    {name = 'potato', price = 20},
                    {name = 'icetea', price = 20},
                    {name = 'sprite', price = 20},
                    {name = 'orangina', price = 20},
                    {name = 'cocacola', price = 20}
                },
                Pos = vector3(388.90, -367.34, 45.84),
                Size = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 255, g = 217, b = 106},
                Name = "Achat de boissons",
                HelpText = _('press_buy'),
                Marker = 27,
                Blip = true
            }
        }
    },



    weed = {
        isIllegal = true,
        KeyName = 'keyweed',
        FieldZones = {
            CannaField = {
                Items = {
                    {name = 'cannabis', quantity = 5}
                },
                PropHash = GetHashKey('prop_weed_01'),
                Pos = vector3(3824.07, 4429.46, 3.0),
                GroundCheckHeights = {1.0, 2.0, 3.0, 4.0},
                Radius = 4
            }
        },
        ProcessZones = {
            BagProcess = {
                ItemsGive = {
                    {name = 'cannabis', quantity = 5},
                    {name = 'dopebag', quantity = 1}
                },
                ItemsGet = {
                    {name = 'bagweed', quantity = 1}
                },
                Delay = 8000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(859.08, 2877.4, 57.98),
                NeedKey = true
            },
        },
    },
    coke = {
        isIllegal = true,
        KeyName = 'keycoke',
        FieldZones = {
            CokeField = {
                Items = {
                    {name = 'cokeleaf', quantity = 5}
                },
                PropHash = GetHashKey('prop_plant_fern_02a'),
                Pos = vector3(-294.48, 2524.97, 74.62),
                GroundCheckHeights = {74.0, 75.0},
                Radius = 5
            }
        },
        ProcessZones = {
            CokeProcess = {
                ItemsGive = {
                    {name = 'cokeleaf', quantity = 2}
                },
                ItemsGet = {
                    {name = 'coke', quantity = 2}
                },
                Delay = 10000,
                Scenario = 'world_human_clipboard', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(1019.13, -2511.48, 28.48),
                NeedKey = true
            },
            BagProcess = {
                ItemsGive = {
                    {name = 'coke', quantity = 5},
                    {name = 'dopebag', quantity = 1}
                },
                ItemsGet = {
                    {name = 'bagcoke', quantity = 1}
                },
                Delay = 15000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(1017.72, -2529.39, 28.3),
                NeedKey = true
            }
        },
    },
    meth = {
        isIllegal = true,
        KeyName = 'keymeth',
        FieldZones = {
            MethyField = {
                Items = {
                    {name = 'methylamine', quantity = 15}
                },
                PropHash = GetHashKey('prop_barrel_exp_01c'),
                Pos = vector3(1595.49, -1702.09, 88.12),
                GroundCheckHeights = {88.0, 89.0},
                Radius = 5
            },
            PseudoField = {
                Items = {
                    {name = 'methpseudophedrine', quantity = 15}
                },
                PropHash = GetHashKey('prop_barrel_01a'),
                Pos = vector3(1762.37, -1654.8, 112.68),
                GroundCheckHeights = {112.0, 113.0},
                Radius = 5
            },
            MethaField = {
                Items = {
                    {name = 'methacide', quantity = 15}
                },
                PropHash = GetHashKey('prop_barrel_exp_01c'),
                Pos = vector3(1112.49, -2299.49, 30.5),
                GroundCheckHeights = {30.0, 31.0},
                Radius = 4
            }
        },
        ProcessZones = {
            BagProcess = {
                ItemsGive = {
                    {name = 'methylamine', quantity = 5},
                    {name = 'methpseudophedrine', quantity = 5},
                    {name = 'methacide', quantity = 5},
                    {name = 'dopebag', quantity = 1},
                },
                ItemsGet = {
                    {name = 'methamphetamine', quantity = 1}
                },
                Delay = 10000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(1390.33, 3608.5, 38.94),
                NeedKey = true
            }
        },
    },
    exta = {
        isIllegal = true,
        KeyName = 'keyexta',
        FieldZones = {
            MdmaField = {
                Items = {
                    {name = 'extamdma', quantity = 10}
                },
                PropHash = GetHashKey('prop_drug_package_02'),
                Pos = vector3(-1063.23, -1113.14, 2.16),
                GroundCheckHeights = {2.0},
                Radius = 3
            },
            AmphetField = {
                Items = {
                    {name = 'extaamphetamine', quantity = 10}
                },
                PropHash = GetHashKey('ex_office_swag_pills2'),
                Pos = vector3(177.98, 306.6, 105.37),
                GroundCheckHeights = {105.0, 106.0},
                Radius = 3
            }
        },
        ProcessZones = {
            ExtaProcess = {
                ItemsGive = {
                    {name = 'extamdma', quantity = 2},
                    {name = 'extaamphetamine', quantity = 2}
                },
                ItemsGet = {
                    {name = 'extazyp', quantity = 10}
                },
                Delay = 10000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(1983.23, 3026.61, 47.69),
                NeedKey = true
            },
            BagProcess = {
                ItemsGive = {
                    {name = 'extazyp', quantity = 5},
                    {name = 'dopebag', quantity = 1},
                },
                ItemsGet = {
                    {name = 'bagexta', quantity = 1}
                },
                Delay = 10000,
                Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
                Pos = vector3(1984.5, 3054.88, 47.22),
                NeedKey = true
            }
        },
    },



    gang_vagos = {
        isGang = true,
		LabelName = "Vagos",
		Zones = {
			Stock = {
				Pos = vector3(338.3, -2012.73, 21.41),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 250, g = 197, b = 50},
				Name  = "Coffre",
                StockName = "gang_vagos",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            Dressing = {
                Pos = vector3(341.44, -2021.80, 24.61),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 250, g = 197, b = 50},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27
            },
		}
	},
	gang_ballas = {
        isGang = true,
		LabelName = "Ballas",
		Zones = {
			Stock = {
				Pos = vector3(118.93, -1966.05, 20.35),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 152, g = 60, b = 137},
				Name  = "Coffre",
                StockName = "gang_ballas",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            Dressing = {
                Pos = vector3(117.25, -1964.02, 20.35),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 152, g = 60, b = 137},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27
            },
		}
	},
	gang_families = {
        isGang = true,
		LabelName = "Families",
		Zones = {
			Stock = {
				Pos = vector3(-157.71, -1603.08, 34.06),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 72, g = 171, b = 57},
				Name  = "Coffre",
                StockName = "gang_families",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            Dressing = {
                Pos = vector3(-155.54, -1604.27, 34.06),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 72, g = 171, b = 57},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27
            },
		}
	},
	gang_marabunta = {
        isGang = true,
		LabelName = "Marabunta",
		Zones = {
			Stock = {
				Pos = vector3(1294.62, -1745.05, 53.30),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 136, g = 243, b = 216},
				Name  = "Coffre",
                StockName = "gang_marabunta",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            Dressing = {
                Pos = vector3(1301.05, -1745.58, 53.30),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27
            },
		}
	},
	biker_lost = {
        isGang = true,
		LabelName = "The Lost",
		Zones = {
			Stock = {
				Pos = vector3(977.11, -104.00, 73.87),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 136, g = 243, b = 216},
				Name  = "Coffre",
                StockName = "biker_lost",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            Dressing = {
				Pos = vector3(986.63, -92.71, 73.87),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27
            },
		}
	},
	orga_cartel = {
        isGang = true,
		LabelName = "Cartel",
		Zones = {
			Stock = {
				Pos = vector3(1402.51, 1152.79, 113.35),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 136, g = 243, b = 216},
				Name  = "Coffre",
                StockName = "orga_cartel",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            Dressing = {
                Pos = vector3(1394.72, 1157.10, 113.35),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27
            },
		}
	},
	orga_mafia = {
        isGang = true,
		LabelName = "Mafia",
		Zones = {
			Stock = {
				Pos = vector3(-854.99, 26.75, 40.56),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 136, g = 243, b = 216},
				Name  = "Coffre",
                StockName = "orga_mafia",
                HelpText = _('press_to_open'),
				Marker = 27
			},
		}
	},
	orga_hapf = {
        isGang = true,
        LabelName = "HAPF",
		Zones = {
			Stock = {
				Pos = vector3(-1108.60, -1643.52, 3.66),
				Size  = {x = 1.5, y = 1.5, z = 1.0},
				Color = {r = 212, g = 0, b = 0},
				Name  = "Coffre",
                StockName = "orga_hapf",
                HelpText = _('press_to_open'),
				Marker = 27
			},
            Dressing = {
				Pos = vector3(-1109.53, -1640.54, 3.66),
                Size = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 212, g = 0, b = 0},
                Name = "Dressing",
                HelpText = _('press_to_open'),
                NoJobDress = true,
                Marker = 27
            },
		},
        BuyZones = {
            BuyBox = {
                Items = {
                    {name = 'lockpick', price = 200}
                },
                Pos = vector3(-1108.25, -1637.40, 3.64),
                Size = {x = 1.5, y = 1.5, z = 1.5},
				Color = {r = 136, g = 243, b = 216},
                Name = "Achat de lockpicks",
                HelpText = _('press_buy'),
                Marker = 27
            }
        }
	},
	orga_illegal_custom = {
        isGang = true,
        LabelName = "Custom illégal"
	},

}

