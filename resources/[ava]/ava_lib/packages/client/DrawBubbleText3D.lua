-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

---Draw a "bubble" like text, only one can be displayed at a time
---@param x nulber
---@param y nulber
---@param z nulber
---@param text string
---@param backgroundColor? number
---@param bubbleStyle? number
local function DrawBubbleText3D(x, y, z, text, backgroundColor, bubbleStyle)
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

return DrawBubbleText3D
