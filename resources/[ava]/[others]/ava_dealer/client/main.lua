-------------------------------------------
-------- REMADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- TODO REDO

local MissionCompleted = nil
local MissionStarted
local PedSpawned = nil
local zoneBlip = nil

function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end

local playerCoords = nil
local playerPed = nil

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        Wait(500)
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        if not MissionStarted then
            local p = Config.HintLocation
            if #(playerCoords - p.xyz) < Config.DrawTextDist then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_CONTEXT~ pour frapper à la porte")
                EndTextCommandDisplayHelp(0, 0, 1, -1)

                if IsControlJustPressed(0, 38) then
                    TaskGoStraightToCoord(playerPed, p.x, p.y, p.z, 10.0, 10, p.w, 0.5)
                    Wait(3000)
                    ClearPedTasksImmediately(playerPed)

                    exports.ava_core:RequestAnimDict("timetable@jimmy@doorknock@")
                    TaskPlayAnim(playerPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0)
                    RemoveAnimDict("timetable@jimmy@doorknock@")
                    Wait(0)
                    while IsEntityPlayingAnim(playerPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do
                        Wait(0)
                    end


                    Wait(1000)

                    TriggerServerEvent('3dme:shareDisplay',
                        "* L'individu remarque un petit morceau de papier glissé sous la porte *")

                    ClearPedTasksImmediately(playerPed)

                    if exports.ava_core:TriggerServerCallback('ava_dealer:serveraskCanStart') then

                        local randNum = math.random(1, #Config.SalesLocations)
                        local spawnLoc = Config.SalesLocations[randNum]
                        print(spawnLoc)
                        MissionStarted = spawnLoc

                        zoneBlip = AddBlipForRadius((spawnLoc.x + math.random(-45, 45)),
                            (spawnLoc.y + math.random(-45, 45)), spawnLoc.z, 120.0)
                        SetBlipSprite(zoneBlip, 9)
                        SetBlipColour(zoneBlip, 1)
                        SetBlipAlpha(zoneBlip, 95)
                        SetBlipRoute(zoneBlip, true)

                        DrawMissionText("Tu as ~y~10~s~ minutes, ne sois pas en retard.", 5000)
                        MissionStart()
                    else
                        DrawMissionText("Personne n'est dispo maintenant, ~y~dégage~s~.", 5000)

                    end
                end
            end
        else
            Wait(1000)
        end
    end
end)

function MissionStart()
    local tPos = MissionStarted
    local prices = {}
    for k, v in pairs(Config.DrugItems) do
        prices[v] = math.floor(Config.DrugPrices[v] *
            (math.random(100.0 - Config.MaxPriceVariance, 100.0 + Config.MaxPriceVariance) / 100.0))
    end
    local startTime = GetGameTimer()
    local timer = 600000 -- 10 minutes
    while ((GetGameTimer() - startTime) < math.floor(timer) and not MissionCompleted) or
        (MissionCompleted and #(playerCoords - tPos.xyz) < 60) do
        Wait(0)
        if #(playerCoords - tPos.xyz) < 30.0 then
            if not PedSpawned then
                local hash = GetHashKey(Config.DealerPed)
                while not HasModelLoaded(hash) do
                    RequestModel(hash)
                    Wait(0)
                end
                PedSpawned = CreatePed(4, hash, tPos.x, tPos.y, tPos.z, tPos.w, true, true)
                SetEntityAsMissionEntity(PedSpawned, true, true)
                Wait(2000)
                FreezeEntityPosition(PedSpawned, true)
                SetModelAsNoLongerNeeded(hash)
                exports.ava_core:ShowNotification("Vous êtes proche de l'acheteur")

            end

            if #(playerCoords - tPos.xyz) < Config.DrawTextDist then
                if not MissionCompleted then
                    startTime = 0
                    MissionCompleted = true
                    RemoveBlip(zoneBlip)

                    if math.random(0, 100) < 40 then
                        TriggerServerEvent("ava_dealer:servercallCops")
                    end
                end
                SetTextComponentFormat("STRING")
                AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_CONTEXT~ pour parler au dealer")
                EndTextCommandDisplayHelp(0, 0, 1, -1)

                if IsControlJustPressed(0, 38) then
                    OpenDealerMenu(prices)
                end
            end
        end
    end
    if not MissionCompleted then
        exports.ava_core:ShowNotification("Vous avez manqué de temps et l'acheteur est parti.")
        RemoveBlip(zoneBlip)
        if PedSpawned then
            DeletePed(PedSpawned)
        end
        MissionCompleted = false
        MissionStarted = false
        PedSpawned = false
    else
        exports.ava_core:ShowNotification("Le dealer a quitté l'endroit.")
        if PedSpawned then
            DeletePed(PedSpawned)
        end
        MissionCompleted = false
        MissionStarted = false
        PedSpawned = false
    end
end

function OpenDealerMenu(prices)
    local counts = exports.ava_core:TriggerServerCallback('ava_dealer:serverGetDrugCount')

    local elements = {}
    local count = 0
    for itemLabel, itemName in pairs(Config.DrugItems) do
        if counts[itemName] > 0 or itemName == 'gold' or itemName == 'diamond' then
            local drugPrice = prices[itemName]

            count = count + 1
            elements[count] = {
                label = itemLabel,
                rightLabel = "$" .. exports.ava_core:FormatNumber(drugPrice),
                price = drugPrice,
                name = itemName,
                count = counts[itemName],
            }
        end
    end

    RageUI.CloseAll()
    RageUI.OpenTempMenu("Dealer", function(Items)
        for i = 1, #elements do
            local element = elements[i]
            Items:AddButton(element.label, nil, { RightLabel = element.rightLabel }, function(onSelected)
                if onSelected then
                    local count = tonumber(exports.ava_core:KeyboardInput("Combien voulez-vous vendre ? [Max : " ..
                        element.count .. "]"))

                    if type(count) == "number" and math.floor(count) == count and count > 0 then
                        TriggerServerEvent('ava_dealer:serverSold', element.name, element.price, count)
                    else
                        exports.ava_core:ShowNotification("Quantité invalide")
                    end
                end
            end)
        end
    end)
end
