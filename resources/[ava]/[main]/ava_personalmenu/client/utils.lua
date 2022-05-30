-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function DrawText3D(x, y, z, text, size, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r or 255, g or 255, b or 255, 215)
        SetTextEntry("STRING")
        AddTextComponentSubstringPlayerName(text)

        SetTextCentre(1)
        SetTextOutline()

        EndTextCommandDisplayText(_x, _y)
    end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end