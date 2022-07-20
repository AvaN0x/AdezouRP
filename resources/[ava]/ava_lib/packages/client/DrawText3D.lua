-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

---Draw a text at
---@param x number coordinate x
---@param y number coordinate y
---@param z number coordinate z
---@param text string text to display
---@param size? number|nil size to display
---@param r? number|nil red
---@param g? number|nil green
---@param b? number|nil blue
---@param a? number|nil alpha
local function DrawText3D(x, y, z, text, size, r, g, b, a)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r or 255, g or 255, b or 255, a or 215)
        SetTextEntry("STRING")
        AddTextComponentSubstringPlayerName(text)
        SetTextCentre(1)
        SetTextOutline()

        EndTextCommandDisplayText(_x, _y)
    end
end

return DrawText3D
