-------------------------------------------
------- EDITED BY GITHUB.COM/AVAN0X -------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local ShowBlips = true

local Banks = {
    { name = "Banque", id = 108, color = 18, coords = vector3(243.26, 225.15, 106.39) },
    -- { name = "Pacific Standard", id = 108, color = 18, coords = vector3(243.26, 225.15, 106.39) },
    { name = "Banque", id = 108, color = 4, coords = vector3(-1212.50, -331.19, 38.11) },
    { name = "Banque", id = 108, color = 4, coords = vector3(-2962.04, 483.04, 16.00) },
    { name = "Banque", id = 108, color = 4, coords = vector3(-111.79, 6469.36, 31.97) },
    { name = "Banque", id = 108, color = 4, coords = vector3(314.05, -279.62, 54.47) },
    { name = "Banque", id = 108, color = 4, coords = vector3(-351.02, -50.40, 49.36) },
    { name = "Banque", id = 108, color = 4, coords = vector3(1175.02, 2707.34, 38.39) },
    { name = "Banque", id = 108, color = 4, coords = vector3(149.69, -1041.19, 29.69) },
}

local Models = {
    [`prop_fleeca_atm`] = { offset = vector3(-0.13, -0.1, 1.0), playerOffset = vector3( 0.0, -0.5, 0.8) },
    [`prop_atm_02`] = { offset = vector3(-0.13, -0.1, 1.0), playerOffset = vector3( 0.0, -0.5, 0.8) },
    [`prop_atm_03`] = { offset = vector3(-0.13, -0.1, 1.0), playerOffset = vector3( 0.0, -0.5, 0.8) },
    [`prop_atm_01`] = { offset = vector3(-0.05, -0.23, 1.0), playerOffset = vector3( 0.0, -0.5, 0.8) },
}
local inMenu = false
local atATM = false

local function LoadInteracts()
    for _, bank in ipairs(Banks) do
        if ShowBlips then
            local blip = AddBlipForCoord(bank.coords.x, bank.coords.y, bank.coords.z)
            SetBlipSprite(blip, bank.id)
            SetBlipColour(blip, bank.color)
            SetBlipScale(blip, 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(tostring(bank.name))
            EndTextCommandSetBlipName(blip)
        end

        exports.ava_interact:addZone(bank.coords, {
            label = "Accèder à mon compte",
            event = "new_banking:client:openBank",
            distance = 2,
            drawDistance = 4,
            canInteract = function() return not inMenu end
        })
    end

    for model, atm in pairs(Models) do
        exports.ava_interact:addModel(model, {
            label = "Accèder à mon compte",
            offset = atm.offset,
            event = "new_banking:client:openATM",
            canInteract = function() return not inMenu and not atATM end
        })
    end
end

Citizen.CreateThread(function()
    if ShowBlips then
        for _, bank in ipairs(Banks) do
            local blip = AddBlipForCoord(bank.coords.x, bank.coords.y, bank.coords.z)
            SetBlipSprite(blip, bank.id)
            SetBlipColour(blip, bank.colour)
            SetBlipScale(blip, 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(tostring(bank.name))
            EndTextCommandSetBlipName(blip)
        end
    end

    LoadInteracts()
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == "ava_interact" then
        LoadInteracts()
    end
end)

AddEventHandler("new_banking:client:openBank", function()
    OpenBank()
end)

AddEventHandler("new_banking:client:openATM", function(entity, data, model)
    if not Models[model] then return end

    atATM = true
    local playerPed = PlayerPedId()
    local offset = Models[model].playerOffset
    local coords = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)
    local isAtCoord = exports.ava_core:CancelableGoStraightToCoord(playerPed, coords, 10.0, 10, GetEntityHeading(entity), 0.5)

    if not isAtCoord then
        atATM = false
        return
    end

    ClearPedTasksImmediately(playerPed)
    exports.ava_core:RequestAnimDict("amb@prop_human_atm@male@enter")
    TaskPlayAnim(playerPed, "amb@prop_human_atm@male@enter", "enter", 8.0, -8, 4000, 0, 0, 0, 0, 0)
    RemoveAnimDict("amb@prop_human_atm@male@enter")
    Wait(4000)

    exports.ava_core:RequestAnimDict("amb@prop_human_atm@male@base")
    TaskPlayAnim(playerPed, "amb@prop_human_atm@male@base", "base", 8.0, 8, -1, 1, 0, 0, 0, 0)
    RemoveAnimDict("amb@prop_human_atm@male@base")
    Wait(1000)

    OpenBank()
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        if atATM then
            ClearPedTasksImmediately(PlayerPedId())
        end
    end
end)


function OpenBank()
    inMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "openGeneral" })
    TriggerServerEvent("bank:balance")
end

function CloseBank()
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "closeAll" })
    Wait(500)
    if atATM then
        local playerPed = PlayerPedId()
        exports.ava_core:RequestAnimDict("amb@prop_human_atm@male@exit")
        TaskPlayAnim(playerPed, "amb@prop_human_atm@male@exit", "exit", 8.0, -8, 7000, 0, 0, 0, 0, 0)
        RemoveAnimDict("amb@prop_human_atm@male@exit")

        Wait(7000)

        ClearPedTasksImmediately(playerPed)
    end
    inMenu = false
    atATM = false
end

-- ===============================================
-- ==           Deposit Event                   ==
-- ===============================================
RegisterNetEvent("currentbalance")
AddEventHandler("currentbalance", function(balance)
    local character = exports.ava_core:getPlayerCharacterData()

    SendNUIMessage({ type = "balanceHUD", balance = balance,
        player = ("%s %s"):format(character.firstname, character.lastname), citizenId = character.citizenId })
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
    SendNUIMessage({ type = "balanceReturn", bal = balance })
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
    SendNUIMessage({ type = "result", m = message, t = type })
end)

-- ===============================================
-- ==               NUIFocusoff                 ==
-- ===============================================
RegisterNUICallback("NUIFocusOff", function()
    CloseBank()
end)
