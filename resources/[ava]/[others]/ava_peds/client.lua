-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local DrawText3D, DrawBubbleText3D = import({ "DrawText3D", "DrawBubbleText3D" })

local loopsRequired = true

local peds = {}
local pedNames = {}

Citizen.CreateThread(function()
    for k, v in pairs(Config.Peds) do
        local hash = joaat(v.PedName)
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Wait(1)
        end

        local ped = CreatePed(v.PedType, v.PedName, v.pos, v.heading, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetPedDefaultComponentVariation(ped)

        if v.variations then
            for _, variation in ipairs(v.variations) do
                SetPedComponentVariation(ped, variation.componentId, variation.drawableId or 0, variation.textureId or 0
                    , variation.paletteId or 0)
            end
        end
        if v.props then
            for _, prop in ipairs(v.props) do
                SetPedPropIndex(ped, prop.componentId, prop.drawableId or 0, prop.textureId or 0, true);
            end
        end
        if v.mp_ped then
            if v.mp_ped.skin then
                exports.ava_mp_peds:setPedSkin(ped, v.mp_ped.skin)
            end
            if v.mp_ped.clothes then
                exports.ava_mp_peds:setPedClothes(ped, v.mp_ped.clothes)
            end
        end

        if v.scenario then
            TaskStartScenarioInPlace(ped, v.scenario, 0, false)
        end

        if v.name or v.bubble then
            table.insert(pedNames,
                { pos = v.pos, entity = ped, name = v.name, bubble = v.bubble, offsetZ = v.offsetZ or 0.2 })
        end

        table.insert(peds, ped)
    end
    loopsRequired = #pedNames > 0
end)

local playerPed = nil
local playerCoords = nil

Citizen.CreateThread(function()
    while loopsRequired do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    while loopsRequired do
        local wait = 1000

        for _, ped in ipairs(pedNames) do
            if #(playerCoords - ped.pos) < 4 then
                wait = 0
                local boneCoord = GetPedBoneCoords(ped.entity, 0x796e, ped.offsetZ, 0, 0)
                if ped.name then
                    DrawText3D(boneCoord.x, boneCoord.y, boneCoord.z, ped.name, 0.25)
                end
                if ped.bubble then
                    DrawBubbleText3D(boneCoord.x, boneCoord.y, boneCoord.z, ped.bubble)
                end
            end
        end
        Wait(wait)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if peds then
            for _, ped in ipairs(peds) do
                DeleteEntity(ped)
            end
        end
        peds = {}
    end
end)
