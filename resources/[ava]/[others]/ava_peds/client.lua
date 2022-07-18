-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local DrawText3D = import("DrawText3D")

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

---Draw a "bubble" like text, only one can be displayed at a time
---@param x nulber
---@param y nulber
---@param z nulber
---@param text string
---@param backgroundColor? number
---@param bubbleStyle? number
function DrawBubbleText3D(x, y, z, text, backgroundColor, bubbleStyle)
    local onScreen = World3dToScreen2d(x, y, z)
    if onScreen then
        AddTextEntry("AVA_DRW_BBLT3D", text)
        BeginTextCommandDisplayHelp("AVA_DRW_BBLT3D")
        EndTextCommandDisplayHelp(2, false, false, -1)
        SetFloatingHelpTextWorldPosition(1, x, y, z)

        local backgroundColor = backgroundColor or 15 -- see https://docs.fivem.net/docs/game-references/hud-colors/
        local bubbleStyle = bubbleStyle or 3
        -- -1 centered, no triangles
        -- 0 left, no triangles
        -- 1 centered, triangle top
        -- 2 left, triangle left
        -- 3 centered, triangle bottom
        -- 4 right, triangle right
        SetFloatingHelpTextStyle(1, 1, backgroundColor, -1, bubbleStyle, 0)
    end
end
