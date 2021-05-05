-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config = {}
Config.DrawDistance = 30.0
Config.Locale = 'fr'
Config.MaxPickUp = 70

Config.Jobs = {
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
                Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name  = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(-1874.90, 2054.53, 140.09),
                Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name  = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            SocietyGarage = {
                Name  = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(-1888.97, 2045.06, 140.87),
                Size  = {x = 2.0, y = 2.0, z = 2.0},
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
                Name  = "1. Récolte",
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "2. Traitement vin",
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "Traitement champagne et grand cru",
                HelpText = _('press_traitement'),
                NoInterim = true,
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "4. Traitement en caisses",
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
                Size  = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name  = "5. Vente des produits",
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
                Size  = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name  = "3. Achat de caisses",
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
                Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name  = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(708.91, -959.63, 29.42),
                Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name  = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            SocietyGarage = {
                Name  = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(719.11, -989.22, 24.12),
                Size  = {x = 2.0, y = 2.0, z = 2.0},
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
                Name  = "1. Récolte",
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "2. Traitement laine",
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "3. Traitement du tissu",
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "5. Mise en caisse des vetements",
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
                Size  = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name  = "6. Vente des produits",
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
                Size  = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name  = "4. Achat de cartons",
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
                Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name  = "Point d'action",
                HelpText = _('press_to_open'),
                Marker = 27
            },
            Dressing = {
                Pos = vector3(-510.19, -700.42, 32.19),
                Size  = {x = 1.5, y = 1.5, z = 1.0},
                Color = {r = 136, g = 243, b = 216},
                Name  = "Dressing",
                HelpText = _('press_to_open'),
                Marker = 27,
                Blip = true
            },
            SocietyGarage = {
                Name  = "Garage véhicule",
                HelpText = _('spawn_veh'),
                Pos = vector3(-465.3, -619.36, 31.17),
                Size  = {x = 2.0, y = 2.0, z = 2.0},
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
                Name  = "1. Récolte",
                Marker = -1,
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "2. Déplumage",
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "3. Découpe",
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
                Size  = {x = 2.5, y = 2.5, z = 1.5},
                Color = {r = 252, g = 186, b = 3},
                Name  = "Cuisine",
                HelpText = _('press_traitement'),
                Marker = 27,
                Blip = true
            }
        },
        SellZones = {
            ChickenSell = {
                Items = {
                    {name = 'raw_chicken', price = 50}
                },
                Pos = vector3(-138.13, -256.69, 42.61),
                Size  = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name  = "4. Vente des produits",
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
                Size  = {x = 1.5, y = 1.5, z = 1.5},
                Color = {r = 136, g = 232, b = 9},
                Name  = "Achat de boissons",
                Marker = 27,
                Blip = true
            }
        }
    },
    -- cluckin = {
    --     SocietyName = '',
    --     LabelName = '',
    --     Blip = {
    --         Sprite = ,
    --         Colour = 
    --     },
    --     Zones = {
    --         JobActions = {
    --             HelpText = _('press_to_open'),
    --         },
    --         Dressing = {
    --             HelpText = _('press_to_open'),
    --         },
    --         SocietyGarage = {
    --             HelpText = _('spawn_veh'),
    --         },
    --     },
    --     FieldZones = {
    --     },
    --     ProcessZones = {
    --     },
    --     SellZones = {
    --     },
    --     BuyZones = {
    --     }
    -- },
}



