-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.RegisterServerCallback("ava_core:server:getPlayerLicenses", function(source, cb)
    local aPlayer = AVA.Players.GetPlayer(source)
    if aPlayer then
        return aPlayer.getLicenses()
    end
    return nil
end)

RegisterNetEvent("ava_core:server:showMyCard", function(targetId, cardName)
    local src = source
    if src ~= targetId then
        local aPlayer = AVA.Players.GetPlayer(src)
        if aPlayer then
            if cardName == "identity" then
                TriggerClientEvent("ava_core:client:showCard", targetId, cardName, aPlayer.citizenId, aPlayer.character)
            else
                local hasLicense, license = aPlayer.hasLicense(cardName)
                if hasLicense then
                    TriggerClientEvent("ava_core:client:showCard", targetId, cardName, aPlayer.citizenId, aPlayer.character, license)
                end
            end
        end
    end
end)
