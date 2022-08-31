-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local ExpirationDate = "15/08/2072"

local ava_mugshots_directory, current_texture
Citizen.CreateThread(function()
    ava_mugshots_directory = CreateRuntimeTxd("ava_mugshots")
    current_texture = CreateRuntimeTexture(ava_mugshots_directory, "ava_mugshot", 64, 64)
end)
local lastId = -1

local function PrepareMugshotTexture(citizenId, base64)
    if lastId ~= citizenId then
        lastId = citizenId
        exports.ava_base64toruntime:SetRuntimeTextureBase64(current_texture, base64, 64, 64)
        SetTimeout(1500, function()
            if lastId == citizenId then
                lastId = -1
            end
        end)
    end
end

RegisterNetEvent("ava_core:client:showMyCard", function(cardType, license)
    local playerCharData = AVA.Player.getCharacterData()
    TriggerEvent("ava_core:client:showCard", cardType, playerCharData.citizenId, playerCharData, license)
end)

RegisterNetEvent("ava_core:client:showCard", function(cardType, citizenId, character, license)
    -- Card types :
    -- identity
    -- driver
    -- weapon
    PrepareMugshotTexture(citizenId, character.mugshot)

    local subtitle = ("~h~%s %s~s~"):format(character.lastname:upper(), character.firstname:gsub("%a", string.upper, 1))
    if cardType == "identity" then
        AVA.ShowNotification(GetString("card_identity_text", character.sex == 0 and "H" or "F", character.birthdate,
            ExpirationDate), 117, "ava_mugshot",
            GetString("card_" .. cardType), subtitle, nil, "ava_mugshots")
    elseif cardType == "driver" then
        -- Get number of points on driver license
        AVA.ShowNotification(GetString("card_driver_text", license.points or 0, ExpirationDate), 11, "ava_mugshot",
            GetString("card_" .. cardType), subtitle,
            nil, "ava_mugshots")
    elseif cardType == "weapon" then
        AVA.ShowNotification(GetString("card_weapon_text", ExpirationDate), 90, "ava_mugshot",
            GetString("card_" .. cardType), subtitle, nil, "ava_mugshots")
    end
end)
