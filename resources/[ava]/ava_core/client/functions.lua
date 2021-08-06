-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.KeyboardInput = function(textEntry, inputText, maxLength)
    AddTextEntry("AVE_KYBRD_INPT", textEntry)
    DisplayOnscreenKeyboard(1, "AVE_KYBRD_INPT", '', inputText, '', '', '', maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end

    local result = ""
    if UpdateOnscreenKeyboard() ~= 2 then
        result = GetOnscreenKeyboardResult()
    end
    Citizen.Wait(100)
    return result or ""
end