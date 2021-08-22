-------------------------------------------
------- EDITED BY GITHUB.COM/AVAN0X -------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
inMenu = false
local showblips = true
local atbank = false

local bank = nil
local atm = nil

local banks = {
    {name = "Pacific Standard", id = 108, colour = 18, x = 242.04, y = 224.45, z = 106.286},
    {name = "Banque", id = 108, colour = 4, x = -1212.980, y = -330.841, z = 37.787},
    {name = "Banque", id = 108, colour = 4, x = -2962.582, y = 482.627, z = 15.703},
    {name = "Banque", id = 108, colour = 4, x = -112.202, y = 6469.295, z = 31.626},
    {name = "Banque", id = 108, colour = 4, x = 314.187, y = -278.621, z = 54.170},
    {name = "Banque", id = 108, colour = 4, x = -351.534, y = -49.529, z = 49.042},
    {name = "Banque", id = 108, colour = 4, x = 1175.06, y = 2706.64, z = 38.09},
    {name = "Banque", id = 108, colour = 4, x = 149.4551, y = -1038.95, z = 29.366},
}

local atmsProps = {
    {hash = -1126237515, offX = 0.0, offY = -0.5, offZ = 0.8},
    {hash = 506770882, offX = 0.0, offY = -0.5, offZ = 0.8},
    {hash = -1364697528, offX = 0.0, offY = -0.5, offZ = 0.8},
    {hash = -870868698, offX = 0.0, offY = -0.5, offZ = 0.8},
}

-- ===============================================
-- ==             Core Threading                ==
-- ===============================================
Citizen.CreateThread(function()
    while true do
        Wait(500)
        if not inMenu then
            bank = nearBank()
            atm = nearATM()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if bank and not inMenu then
            DisplayHelpText("Appuie sur ~INPUT_PICKUP~ pour accèder à compte ~b~")

            if IsControlJustPressed(1, 38) then
                OpenBank()
            end
        elseif atm and not inMenu then
            DisplayHelpText("Appuie sur ~INPUT_PICKUP~ pour accèder à compte ~b~")

            if IsControlJustPressed(1, 38) then
                atm = nearATM() -- update the nearest ATM to be sure to go at the closest one

                local playerPed = PlayerPedId()
                local isAtCoord = exports.ava_core:CancelableGoStraightToCoord(playerPed, vector3(atm.x, atm.y, atm.z), 10.0, 10, atm.heading, 0.5)

                if isAtCoord then
                    ClearPedTasksImmediately(playerPed)
                    exports.ava_core:RequestAnimDict("amb@prop_human_atm@male@enter")
                    TaskPlayAnim(playerPed, "amb@prop_human_atm@male@enter", "enter", 8.0, -8, 4000, 0, 0, 0, 0, 0)
                    Citizen.Wait(4000)

                    exports.ava_core:RequestAnimDict("amb@prop_human_atm@male@base")
                    TaskPlayAnim(playerPed, "amb@prop_human_atm@male@base", "base", 8.0, 8, -1, 1, 0, 0, 0, 0)
                    Citizen.Wait(1000)

                    OpenBank()
                end
            end
        end

        if IsControlJustPressed(1, 322) and inMenu then
            CloseBank()
        end
    end
end)

function OpenBank()
    inMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({type = "openGeneral"})
    TriggerServerEvent("bank:balance")
end

function CloseBank()
    SetNuiFocus(false, false)
    SendNUIMessage({type = "closeAll"})
    Wait(500)
    if atm then
        local playerPed = PlayerPedId()
        exports.ava_core:RequestAnimDict("amb@prop_human_atm@male@exit")
        TaskPlayAnim(playerPed, "amb@prop_human_atm@male@exit", "exit", 8.0, -8, 7000, 0, 0, 0, 0, 0)
        Citizen.Wait(7000)

        ClearPedTasksImmediately(playerPed)
    end
    inMenu = false
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        if atm then
            ClearPedTasksImmediately(PlayerPedId())
        end
    end
end)

-- ===============================================
-- ==             Map Blips	                   ==
-- ===============================================
Citizen.CreateThread(function()
    if showblips then
        for k, v in ipairs(banks) do
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip, v.id)
            SetBlipColour(blip, v.colour)
            SetBlipScale(blip, 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(tostring(v.name))
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- ===============================================
-- ==           Deposit Event                   ==
-- ===============================================
RegisterNetEvent("currentbalance")
AddEventHandler("currentbalance", function(balance)
    local character = exports.ava_core:getPlayerCharacterData()

    SendNUIMessage({type = "balanceHUD", balance = balance, player = ("%s %s"):format(character.firstname, character.lastname), citizenId = character.citizenId})
end)

-- ===============================================
-- ==           Deposit Event                   ==
-- ===============================================
RegisterNUICallback("deposit", function(data)
    TriggerServerEvent("bank:deposit", tonumber(data.amount))
    TriggerServerEvent("bank:balance")
end)

-- ===============================================
-- ==          Withdraw Event                   ==
-- ===============================================
RegisterNUICallback("withdraw", function(data)
    TriggerServerEvent("bank:withdraw", tonumber(data.amountw))
    TriggerServerEvent("bank:balance")
end)

-- ===============================================
-- ==         Balance Event                     ==
-- ===============================================
RegisterNUICallback("balance", function()
    TriggerServerEvent("bank:balance")
end)

RegisterNetEvent("balance:back")
AddEventHandler("balance:back", function(balance)
    SendNUIMessage({type = "balanceReturn", bal = balance})
end)

-- ===============================================
-- ==         Transfer Event                    ==
-- ===============================================
RegisterNUICallback("transfer", function(data)
    TriggerServerEvent("bank:transfer", data.to, data.amountt)
    TriggerServerEvent("bank:balance")
end)

-- ===============================================
-- ==         Result   Event                    ==
-- ===============================================
RegisterNetEvent("bank:result")
AddEventHandler("bank:result", function(type, message)
    SendNUIMessage({type = "result", m = message, t = type})
end)

-- ===============================================
-- ==               NUIFocusoff                 ==
-- ===============================================
RegisterNUICallback("NUIFocusOff", function()
    CloseBank()
end)

-- ===============================================
-- ==            Capture Bank Distance          ==
-- ===============================================
function nearBank()
    local player = GetPlayerPed(-1)
    local playerloc = GetEntityCoords(player, 0)

    for _, search in pairs(banks) do
        local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc["x"], playerloc["y"], playerloc["z"], true)

        if distance <= 3 then
            return search
        end
    end
    return nil
end

function nearATM()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    for _, v in ipairs(atmsProps) do
        local closestATM = GetClosestObjectOfType(coords, 1.0, v.hash, false, false, false)

        if DoesEntityExist(closestATM) then
            local markerCoords = GetOffsetFromEntityInWorldCoords(closestATM, v.offX, v.offY, v.offZ)

            return {x = markerCoords.x, y = markerCoords.y, z = markerCoords.z, heading = GetEntityHeading(closestATM)}
        end
    end
    return nil
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
