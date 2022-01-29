-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local ConfigBlips = {
    {Coord = vector3(783.37, -1867.88, 0.0), Sprite = 777, Colour = 0, Scale = 0.8, Name = "LS Car Meet"},
    {Coord = vector3(5943.0, -6272.0, 0.0), Sprite = 575, Colour = 0, Scale = 0.0, Name = "Cayo Perico"},
}
local placedBlips = {}

Citizen.CreateThread(function()
    for _, v in pairs(ConfigBlips) do
        local function CreateBlip(coord)
            local blip = AddBlipForCoord(coord or vector3(0.0, 0.0, 0.0))

            SetBlipSprite(blip, v.Sprite or 1)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.Scale or 0.8)
            SetBlipColour(blip, v.Colour or 0)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Name or "")
            EndTextCommandSetBlipName(blip)

            table.insert(placedBlips, blip)
        end

        if v.Coords then
            for _, coord in pairs(v.Coords) do
                CreateBlip(coord)
            end
        elseif v.Coord then
            CreateBlip(v.Coord)
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if placedBlips then
            for _, blip in ipairs(placedBlips) do
                RemoveBlip(blip)
            end
        end
        placedBlips = {}
    end
end)

-- -- used to know new blips
-- Citizen.CreateThread(function()
--     local lastKnownBlipId = 802
--     for i = lastKnownBlipId, lastKnownBlipId + 25, 1 do
--         local blip = AddBlipForCoord(vector3(-1000.0 + ((i % 775) * 25), -3500.0, 0.0))

--         SetBlipSprite (blip, i)
--         SetBlipDisplay(blip, 4)
--         SetBlipScale  (blip, 0.8)
--         SetBlipColour (blip, 0)
--         SetBlipAsShortRange(blip, true)

--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentString(i)
--         EndTextCommandSetBlipName(blip)

--         table.insert(placedBlips, blip)
--     end
-- end)
