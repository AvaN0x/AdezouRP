-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.RegisterServerCallback("ava_core:server:getPlayerLicenses", function(source)
    local aPlayer = AVA.Players.GetPlayer(source)
    if aPlayer then
        return aPlayer.getLicenses()
    end
    return nil
end)
---Get max license points for a license
---@param licenseName string
---@return integer|nil "Integer corresponding to the max points, or nil if the license has no points"
AVA.GetLicenseMaxPoints = function(licenseName)
    if AVAConfig.Licenses[licenseName] and AVAConfig.Licenses[licenseName].hasPoints then
        return AVAConfig.Licenses[licenseName].maxPoints
    end
    return nil
end
exports("GetLicenseMaxPoints", AVA.GetLicenseMaxPoints)

AVA.RegisterServerCallback("ava_core:server:getLicenseMaxPoints", function(source, licenseName)
    return AVA.GetLicenseMaxPoints(licenseName)
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
