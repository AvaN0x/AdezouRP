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
-- TODO make all JobMenuItem be a command?
Config.JobMenuElement = {
    PoliceMegaphone = {
        Label = GetString("police_megaphone"),
        Desc = GetString("police_megaphone_desc"),
        AllowedVehicles = {
            `police`,
            `police2`,
            `police3`,
            `police4`,
            `fbi`,
            `fbi2`,
            `riot`,
            `riot2`,
            `policet`,
            `sheriff`,
            `sheriff2`,
            `pranger`,
            `bcat`,
            `pbus`,
            `polbuffalo`,
            `polgauntlet`,
            `polbullet`,
            `polvacca`,
            `predator`,
            `umoracle`,
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
                        { label = "LSPD! Stop...", desc = "LSPD! Stop your vehicle now!", distance = 30.0, volume = 0.6,
                            soundName = "stop_vehicle" },
                        { label = "Driver! Stop...", desc = "Driver! Stop your vehicle", distance = 30.0, volume = 0.6,
                            soundName = "stop_vehicle-2" },
                        { label = "Stop the fucking car...", desc = "This is the LSPD! Stop the fucking car immediately!",
                            distance = 30.0, volume = 0.6, soundName = "stop_the_f_car" },
                        { label = "Stop or executed...", desc = "LSPD! Stop your vehicle now or you'll be executed!",
                            distance = 30.0, volume = 0.6, soundName = "stop_or_executed" },
                        { label = "Stop or I kill ya...",
                            desc = "Stop your vehicle right fucking now! Or I swear I am going to kill ya!",
                            distance = 30.0, volume = 0.6, soundName = "stop_or_i_kill" },
                    },
                },
                {
                    label = GetString("police_megaphone_stop"),
                    RightLabel = "→→→",
                    elements = {
                        { label = "Dont make me...", desc = "Stop! Don't make me shoot ya! Give yourself up!",
                            distance = 30.0, volume = 0.6, soundName = "dont_make_me" },
                        { label = "Dont move a muscle...",
                            desc = "Stop and dont move a muscle, or you'll be shot by the LSPD!", distance = 30.0,
                            volume = 0.6, soundName = "stop_dont_move" },
                        { label = "Give yourself up...",
                            desc = "LSPD! If you give yourself up I'll be a lot nicer shithead!", distance = 30.0,
                            volume = 0.6, soundName = "give_yourself_up" },
                        { label = "Stay right there...", desc = "LSPD! Stay right there and don't move, fucker!",
                            distance = 30.0, volume = 0.6, soundName = "stay_right_there" },
                        { label = "Freeze...", desc = "Freeze! LSPD!", distance = 30.0, volume = 0.6,
                            soundName = "freeze_lspd" },
                    },
                },
                {
                    label = GetString("police_megaphone_clear"),
                    RightLabel = "→→→",
                    elements = {
                        { label = "Clear the area...", desc = "This is the LSPD! Clear the area. Now!", distance = 30.0,
                            volume = 0.6, soundName = "clear_the_area" },
                        { label = "Go away now...", desc = "This is the LSPD! Go away now or there will be trouble.",
                            distance = 30.0, volume = 0.6, soundName = "this_is_the_lspd" },
                        { label = "Move along people...", desc = "Move along people. We don't want trouble.",
                            distance = 30.0, volume = 0.6, soundName = "move_along_people" },
                        { label = "Get out of here...", desc = "Get out of here now. This is the LSPD.", distance = 30.0,
                            volume = 0.6, soundName = "get_out_of_here_now" },
                        { label = "Disperse now...", desc = "This is the LSPD! Disperse, now!", distance = 30.0,
                            volume = 0.6, soundName = "disperse_now" },
                    },
                },
                {
                    label = GetString("police_megaphone_insult"),
                    RightLabel = "→→→",
                    elements = {
                        { label = "It's over...", desc = "It's over for you! This is the police!", distance = 30.0,
                            volume = 0.6, soundName = "its_over_for_you" },
                        { label = "You are finished...", desc = "You are finished dickhead! Stop!", distance = 30.0,
                            volume = 0.6, soundName = "you_are_finished_dhead" },
                        { label = "You can't hide boy...", desc = "You can't hide boy. We will track you down!",
                            distance = 30.0, volume = 0.6, soundName = "cant_hide_boi" },
                        { label = "Drop a missile...", desc = "Can't we just drop a missile on this moron?!",
                            distance = 30.0, volume = 0.6, soundName = "drop_a_missile" },
                        { label = "Shoot to kill...", desc = "This is the LSPD! I'm gonna shoot to kill!",
                            distance = 30.0, volume = 0.6, soundName = "shoot_to_kill" },
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
                                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", sound.distance, sound.
                                    soundName, sound.volume)
                            end
                        end)
                    end
                end
            end)

        end,
    },
}

Config.Jobs = {}

Config.JobCenter = {
    Blip = { Sprite = 682, Color = 27 },
    JobList = {
        { JobName = "unemployed", Label = "Chômage", Desc = "Inscrivez vous au chômage pour recevoir des aides" },
        { JobName = "winemaker", Label = "🍇 Intérimaire Vigneron",
            Desc = "Travail dans les vignes pour la fabrication de jus et de vin" },
        { JobName = "tailor", Label = "🧶 Intérimaire Couturier",
            Desc = "Travail dans la couture et la fabrique de vêtements" },
        { JobName = "lumberjack", Label = "🪓 Intérimaire Bûcheron", Desc = "Travail dans la scierie" },
    },
    Coord = vector3(-266.94, -960.04, 30.24),
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Color = { r = 255, g = 133, b = 85 },
    Name = "Pole Emploi",
    HelpText = GetString("press_to_open"),
    Marker = 27,
}

Config.BankManagment = {
    Blip = { Sprite = 525, Color = 12, Scale = 0.6 },
    Coord = vector3(248.23, 222.42, 105.31),
    Size = { x = 1.5, y = 1.5, z = 1.0 },
    Color = { r = 74, g = 159, b = 86 },
    Name = "Compte entreprise",
    HelpText = GetString("press_to_open"),
    Marker = 27,
}
