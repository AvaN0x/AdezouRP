-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.KeyboardInput = function(textEntry, inputText, maxLength)
    AddTextEntry("AVA_KYBRD_INPT", textEntry or "")
    DisplayOnscreenKeyboard(1, "AVA_KYBRD_INPT", '', inputText or "", '', '', '', maxLength or 255)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end

    local result = ""
    if UpdateOnscreenKeyboard() ~= 2 then
        result = tostring(GetOnscreenKeyboardResult())
    end
    Citizen.Wait(100)
    return result or ""
end

AVA.ShowNotification = function(text, color, textureName, title, subtitle, iconType, textureDict)
    AddTextEntry("AVA_NOTF_TE", text or "")
	BeginTextCommandThefeedPost("AVA_NOTF_TE")
    if color then
        -- color : 
        -- https://pastebin.com/d9aHPbXN
        SetNotificationBackgroundColor(color)
    end
    if textureName then
        textureDict = textureDict or textureName
        -- icon :
        -- https://wiki.rage.mp/index.php?title=Notification_Pictures

        -- iconTypes:  
        -- 1 : Chat Box  
        -- 2 : Email  
        -- 3 : Add Friend Request  
        -- 4 : Nothing  
        -- 5 : Nothing  
        -- 6 : Nothing  
        -- 7 : Right Jumping Arrow  
        -- 8 : RP Icon  
        -- 9 : $ Icon 
        if not HasStreamedTextureDictLoaded(textureDict) then
            RequestStreamedTextureDict(textureDict, false)
            while not HasStreamedTextureDictLoaded(textureDict) do Wait(0) end
        end    
        EndTextCommandThefeedPostMessagetext(textureDict, textureName, false, iconType or 4, title, subtitle)
        SetStreamedTextureDictAsNoLongerNeeded(textureDict)
    end
	EndTextCommandThefeedPostTicker(false, true)
end
RegisterNetEvent("ava_core:client:ShowNotification", AVA.ShowNotification)


AVA.ShowHelpNotification = function(text)
    AddTextEntry("AVA_NOTF_TE", text)
    BeginTextCommandDisplayHelp("AVA_NOTF_TE")
    EndTextCommandDisplayHelp(0, false, true, -1)
end