-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

local loopsRequired = true

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

local pedNames = {}

Citizen.CreateThread(function()
    for k, v in pairs(Config.Peds) do
        local hash = GetHashKey(v.Name)
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Wait(1)
        end

        for _, p in pairs(v.PosList) do
            local ped = CreatePed(v.Type, v.Name, p.pos, p.heading, false, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            SetPedDefaultComponentVariation(ped)

            if p.variations then
                for _, variation in ipairs(p.variations) do
                    SetPedComponentVariation(ped, variation.componentId, variation.drawableId or 0, variation.textureId or 0, variation.paletteId or 0)
                end
            end
            if p.props then
                for _, prop in ipairs(p.props) do
                    SetPedPropIndex(ped, prop.componentId, prop.drawableId or 0, prop.textureId or 0, true);
                end
            end

            if p.scenario then
                TaskStartScenarioInPlace(ped, p.scenario, 0, false)
            end

            if p.name or p.bubble then
                table.insert(pedNames, {pos = p.pos, entity = ped, name = p.name, bubble = p.bubble, offsetZ = p.offsetZ or 0.2})
            end
        end

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
                local boneCoord = GetPedBoneCoords(ped.entity, 0x796e, ped.offsetZ , 0, 0)
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

        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


function DrawBubbleText3D(x, y, z, text, backgroundColor, bubbleStyle)
    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1)
    SetFloatingHelpTextWorldPosition(1, x, y, z)


    local backgroundColor = backgroundColor or 15 -- see https://pastebin.com/d9aHPbXN
    local bubbleStyle = bubbleStyle or 3
    -- -1 centered, no triangles
    -- 0 left, no triangles
    -- 1 centered, triangle top
    -- 2 left, triangle left
    -- 3 centered, triangle bottom
    -- 4 right, triangle right
    SetFloatingHelpTextStyle(1, 1, backgroundColor, -1, bubbleStyle, 0)
end
