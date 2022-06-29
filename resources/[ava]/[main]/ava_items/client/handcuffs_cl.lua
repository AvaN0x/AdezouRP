-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- TODO: redo, atm it's inspired by esx_policejob
-- TODO: use statebags and things to make it better

local isHandcuffed = false
local dragStatus = {}
dragStatus.isDragged = false

AddEventHandler('ava_deaths:client:playerRevived', function(spawn)
    TriggerEvent('ava_items:handcuffs:unrestrain')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('ava_items:handcuffs:unrestrain')
    end
end)


RegisterNetEvent('ava_items:handcuffs:useHandcuff', function()
    OpenCuffsMenu()
end)

function OpenCuffsMenu()

    RageUI.CloseAll()
    RageUI.OpenTempMenu("Menottes", function(Items)
        Items:AddButton("Mettre les menottes", "", nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer(nil, 2.0)
                if not targetId then return end

                local playerPed = PlayerPedId()
                local playerheading = GetEntityHeading(playerPed)
                local playerlocation = GetEntityForwardVector(playerPed)
                local playerCoords = GetEntityCoords(playerPed)
                TriggerServerEvent('ava_items:handcuffs:requestarrest', targetId, playerheading, playerCoords,
                    playerlocation)
                Wait(5000)
                TriggerServerEvent('ava_items:handcuffs:handcuffs', targetId)
            end
        end)
        Items:AddButton("Enlever les menottes", "", nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer(nil, 2.0)
                if not targetId then return end

                local playerPed = PlayerPedId()
                local playerheading = GetEntityHeading(playerPed)
                local playerlocation = GetEntityForwardVector(playerPed)
                local playerCoords = GetEntityCoords(playerPed)
                TriggerServerEvent('ava_items:handcuffs:requestrelease', targetId, playerheading, playerCoords,
                    playerlocation)
                Wait(5000)
                TriggerServerEvent('ava_items:handcuffs:unhandcuff', targetId)
            end
        end)
        Items:AddButton("Escorter la personne", "", nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer(nil, 2.0)
                if not targetId then return end

                TriggerServerEvent('ava_items:handcuffs:drag', targetId)
            end
        end)
        Items:AddButton("Mettre dans le véhicule", "", nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer(nil, 2.0)
                if not targetId then return end

                TriggerServerEvent('ava_items:handcuffs:putInVehicle', targetId)
            end
        end)
        Items:AddButton("Retirer du véhicule", "", nil, function(onSelected)
            if onSelected then
                local targetId, localId = exports.ava_core:ChooseClosestPlayer(nil, 2.0)
                if not targetId then return end

                TriggerServerEvent('ava_items:handcuffs:OutVehicle', targetId)
            end
        end)
    end)



end

RegisterNetEvent('ava_items:handcuffs:handcuffs', function()
    isHandcuffed = true
    local playerPed = PlayerPedId()

    Citizen.CreateThread(function()
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
        end

        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
        SetPedCanPlayGestureAnims(playerPed, false)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(false) -- TODO use state bag saved value or something
    end)
end)

RegisterNetEvent('ava_items:handcuffs:unrestrain', function()
    if isHandcuffed then
        local playerPed = PlayerPedId()
        isHandcuffed = false
        if dragStatus.isDragged then
            dragStatus.isDragged = false
            DetachEntity(playerPed, true, false)
        end

        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
        FreezeEntityPosition(playerPed, false)
        DisplayRadar(true) -- TODO bring back to state before getting cuffed
    end
end)

RegisterNetEvent('ava_items:handcuffs:drag', function(copId)
    if not isHandcuffed then
        return
    end

    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
    local playerPed
    local targetPed

    while true do
        local wait = 500

        if isHandcuffed then
            playerPed = PlayerPedId()
            wait = 0

            if dragStatus.isDragged then
                targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

                -- undrag if target is in an vehicle
                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false
                        , false, 2, true)
                else
                    dragStatus.isDragged = false
                    DetachEntity(playerPed, true, false)
                end

                if IsPedDeadOrDying(targetPed, true) then
                    dragStatus.isDragged = false
                    DetachEntity(playerPed, true, false)
                end

            else
                DetachEntity(playerPed, true, false)
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('ava_items:handcuffs:putInVehicle', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if not isHandcuffed then
        return
    end

    if IsAnyVehicleNearPoint(coords, 5.0) then
        local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

        if DoesEntityExist(vehicle) then
            local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

            for i = maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    freeSeat = i
                    break
                end
            end

            if freeSeat then
                TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
                dragStatus.isDragged = false
            end
        end
    end
end)

RegisterNetEvent('ava_items:handcuffs:OutVehicle', function()
    local playerPed = PlayerPedId()

    if not IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    local vehicle = GetVehiclePedIsIn(playerPed, false)
    TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()

        if isHandcuffed then
            -- DisableControlAction(0, 1, true) -- Disable horizontal cam
            -- DisableControlAction(0, 2, true) -- Disable vertical cam
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            --DisableControlAction(0, 32, true) -- W
            --DisableControlAction(0, 34, true) -- A
            --DisableControlAction(0, 31, true) -- S
            --DisableControlAction(0, 30, true) -- D

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?

            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job

            -- DisableControlAction(0, 0, true) -- Disable changing view
            -- DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            -- DisableControlAction(2, 199, true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 36, true) -- Disable going stealth

            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle

            if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
                exports.ava_core:RequestAnimDict("mp_arresting")
                TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
                RemoveAnimDict("mp_arresting")
            end
        else
            Wait(500)
        end
    end
end)


RegisterNetEvent('ava_items:handcuffs:getarrested', function(playerheading, playercoords, playerlocation)
    local playerPed = PlayerPedId()
    SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
    local x, y, z = table.unpack(playercoords + playerlocation * 1.0)
    SetEntityCoords(playerPed, x, y, z)
    SetEntityHeading(playerPed, playerheading)
    Wait(250)
    exports.ava_core:RequestAnimDict('mp_arrest_paired')
    TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
    RemoveAnimDict("mp_arrest_paired")
    Wait(3760)
    cuffed = true
    exports.ava_core:RequestAnimDict('mp_arresting')
    TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
    RemoveAnimDict("mp_arresting")
end)

RegisterNetEvent('ava_items:handcuffs:doarrested', function()
    local playerPed = PlayerPedId()

    Wait(250)
    exports.ava_core:RequestAnimDict('mp_arrest_paired')
    TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
    RemoveAnimDict("mp_arrest_paired")
    Wait(3000)
end)

RegisterNetEvent('ava_items:handcuffs:douncuffing', function()
    local playerPed = PlayerPedId()

    Wait(250)
    exports.ava_core:RequestAnimDict('mp_arresting')
    TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
    RemoveAnimDict("mp_arresting")

    Wait(5500)
    ClearPedTasks(playerPed)
end)

RegisterNetEvent('ava_items:handcuffs:getuncuffed', function(playerheading, playercoords, playerlocation)
    local playerPed = PlayerPedId()

    local x, y, z = table.unpack(playercoords + playerlocation * 1.0)
    SetEntityCoords(playerPed, x, y, z - 1.0)
    SetEntityHeading(playerPed, playerheading)
    Wait(250)
    exports.ava_core:RequestAnimDict('mp_arresting')
    TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8, -1, 2, 0, 0, 0, 0)
    RemoveAnimDict("mp_arresting")

    Wait(5500)
    cuffed = false
    ClearPedTasks(playerPed)
end)
