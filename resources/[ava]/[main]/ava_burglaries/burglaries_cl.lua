-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local isInside = false
local thisHouse = nil

Citizen.CreateThread(function()
    local houseInfos = exports.ava_core:TriggerServerCallback("ava_burglaries:server:getHousesInfo")
    for ID, state in pairs(houseInfos) do
        AVAConfig.Houses[ID].state = state
    end
end)

local playerCoords = nil
local playerPed = nil
local coordsLoop = 500

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        if not isInside then
            thisHouseID, thisHouse = getClosestHouse()
        end
        Wait(coordsLoop)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        local isIn, house, houseID = isInside, thisHouse, thisHouseID
        if isIn then
            TriggerServerEvent("ava_burglaries:server:leaveHouse", houseID)
            local coords = house and house.coord or vector3(296.81, -769.55, 28.35)
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
        end
    end
end)

-- todo not working, fix later
-- --* safety to allow user to exit the house if they spawn inside
-- AddEventHandler('playerSpawned', function()
-- 	local playerPed = PlayerPedId()
-- 	local coords = GetEntityCoords(playerPed)
-- 	if not isInside and GetDistanceBetweenCoords(AVAConfig.Appartment.coord.x, AVAConfig.Appartment.coord.y, AVAConfig.Appartment.coord.z, coords.x, coords.y, coords.z, false) <= 23.0 then
-- 		isInside = true
-- 		LoopExit()
-- 	end
-- end)

function getClosestHouse()
    for k, v in ipairs(AVAConfig.Houses) do
        if #(v.coord - playerCoords) <= 2.0 then
            return k, v
        end
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        local wait = 500
        if thisHouse and not isInside then
            wait = 0

            local text = nil
            if thisHouse.state == 0 then
                text = GetString("house_weak_door")
            elseif thisHouse.state == 1 then
                text = GetString("house_user_inside_door")
            else
                text = GetString("house_burglarized_door")
            end

            DrawText3D(thisHouse.coord.x, thisHouse.coord.y, thisHouse.coord.z, text, 0.3)
        end
        Wait(wait)
    end
end)

RegisterNetEvent("ava_items:client:useLockpick", function()
    if not thisHouse or isInside or thisHouse.state ~= 0 then
        return
    end

    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    local minigameSuccess <const> = exports.ava_lockpicking:StartMinigame()
    ClearPedTasksImmediately(playerPed)
    TriggerServerEvent("ava_items:server:usedLockpick", minigameSuccess)

    if not minigameSuccess then
        return
    end
    isInside = true
    coordsLoop = AVAConfig.CoordsLoopInside

    lockpicking = false
    TriggerServerEvent("ava_burglaries:server:enterHouse", thisHouseID)
    Teleport(AVAConfig.Appartment.coord, AVAConfig.Appartment.heading)
    TryCallCops()
    LoopExit()
    ResetBurglary()
    while isInside do
        Wait(0)
        for k, v in ipairs(AVAConfig.Furnitures) do
            local distance = #(v.coord - playerCoords)

            if distance <= 0.7 then
                if v.empty then
                    DrawText3D(v.coord.x, v.coord.y, v.coord.z, GetString("empty"), 0.3)

                else
                    DrawText3D(v.coord.x, v.coord.y, v.coord.z, GetString("press_search"), 0.3)

                    if IsControlJustReleased(0, 38) then
                        FreezeEntityPosition(playerPed, true)
                        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

                        exports["progressBars"]:startUI(3000, GetString("searching"))
                        Wait(3000)

                        if exports.ava_core:TriggerServerCallback("ava_burglaries:server:searchFurniture", thisHouseID) then
                            exports.ava_core:ShowHelpNotification(GetString("found_in_furniture"))
                        else
                            exports.ava_core:ShowHelpNotification(GetString("found_nothing_in_furniture"))
                        end
                        v.empty = true

                        ClearPedTasksImmediately(playerPed)
                        FreezeEntityPosition(playerPed, false)
                    end
                end
            elseif distance <= 4.0 and not v.empty then
                DrawText3D(v.coord.x, v.coord.y, v.coord.z, GetString("search_in_distance"), 0.3)

            end
        end
    end

end)

function ResetBurglary()
    for k, v in ipairs(AVAConfig.Furnitures) do
        v.empty = false
    end
end

function LoopExit()
    Citizen.CreateThread(function()
        while isInside do
            Wait(0)
            if #(AVAConfig.Appartment.coord - playerCoords) <= 2.0 then
                DrawText3D(AVAConfig.Appartment.coord.x, AVAConfig.Appartment.coord.y, AVAConfig.Appartment.coord.z,
                    GetString("press_exit"), 0.3)

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("ava_burglaries:server:leaveHouse", thisHouseID)
                    if thisHouse then
                        Teleport(thisHouse.coord, thisHouse.heading)
                        TriggerServerEvent("ava_burglaries:server:updateState", thisHouseID, 2)
                    else
                        Teleport(vector3(296.81, -769.55, 28.35), 330.0)
                    end
                    isInside = false
                    coordsLoop = AVAConfig.CoordsLoop
                end
            else
                Wait(500)
            end
        end
    end)
end

function TryCallCops()
    local random = math.random(0, 100)
    if random <= 65 then
        Citizen.CreateThread(function()
            Wait(math.random(18000, 23000))
            -- only call the cops, if the user is still in the house
            if isInside then
                TriggerServerEvent("ava_burglaries:server:callCops", thisHouseID)
            end
        end)
    end
end

function Teleport(coords, heading)
    local playerPed = GetPlayerPed(-1)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    DoScreenFadeOut(100)
    Wait(250)
    FreezeEntityPosition(playerPed, true)

    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    if heading then
        SetEntityHeading(playerPed, heading)
    end

    Wait(1000)
    FreezeEntityPosition(playerPed, false)
    DoScreenFadeIn(100)
end

function DrawText3D(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

-- Set state for houses
RegisterNetEvent("ava_burglaries:client:setState", function(doorID, state)
    AVAConfig.Houses[doorID].state = state
end)
