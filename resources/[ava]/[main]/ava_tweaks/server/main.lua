-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterCommand("vehweaphash", nil, function(source, args)
    TriggerClientEvent("ava_tweaks:client:vehweaphash", source)
end, GetString("vehweaphash_help"))

--------------------------------------
--------------- Deaths ---------------
--------------------------------------

-- * death verification
local deathCauses = {
    Suicide = {Label = GetString("suicide"), Hash = {0}},
    Melee = {Label = GetString("melee"), Hash = {-1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466, -538741184}},
    Bullet = {
        Label = GetString("bullet"),
        Hash = {
            -86904375,
            453432689,
            1593441988,
            584646201,
            -1716589765,
            324215364,
            736523883,
            -270015777,
            -1074790547,
            -2084633992,
            -1357824103,
            -1660422300,
            2144741730,
            487013001,
            2017895192,
            -494615257,
            -1654528753,
            100416529,
            205991906,
            1119849093,
            -1076751822,
            -1045183535,
        },
    },
    Knife = {Label = GetString("knife"), Hash = {-1716189206, 1223143800, -1955384325, -1833087301, 910830060}},
    Car = {Label = GetString("car"), Hash = {133987706, -1553120962}},
    Animal = {Label = GetString("animal"), Hash = {-100946242, 148160082}},
    FallDamage = {Label = GetString("fallDamage"), Hash = {-842959696}},
    Explosion = {
        Label = GetString("explosion"),
        Hash = {
            -1568386805,
            1305664598,
            -1312131151,
            375527679,
            324506233,
            1752584910,
            -1813897027,
            741814745,
            -37975472,
            539292904,
            341774354,
            -1090665087,
            -1355376991,
        },
    },
    Gas = {Label = GetString("gas"), Hash = {-1600701090}},
    Burn = {Label = GetString("burn"), Hash = {615608432, 883325847, -544306709}},
    Drown = {Label = GetString("drown"), Hash = {-10959621, 1936677264}},
}

local function GetDeathCauseLabel(deathCause)
    for _, v in pairs(deathCauses) do
        for __, v_ in ipairs(v.Hash) do
            if v_ == deathCause then
                return v.Label
            end
        end
    end
    return deathCause
end

RegisterNetEvent("ava_core:server:playerDeath", function(data)
    local src = source
    local srcName = GetPlayerName(src)
    if data.killedByPlayer then
        local deathCauseLabel = GetDeathCauseLabel(data.weapon)
        local distance = math.abs(#(data.coords - data.killerCoords))
        local killerName = GetPlayerName(data.killerId)
        exports.ava_core:TriggerClientWithAceEvent("ava_personalmenu:client:notifAdmins", "ace.group.mod", "death",
            GetString("killey_by_notification", srcName, killerName, deathCauseLabel))

        exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_deaths", "",
            GetString("killey_by_embed", srcName, killerName, deathCauseLabel, tostring(data.weapon), tonumber(distance)), 0xFF0000)
    else
        local deathCauseLabel = GetDeathCauseLabel(data.cause)
        exports.ava_core:TriggerClientWithAceEvent("ava_personalmenu:client:notifAdmins", "ace.group.mod", "death",
            GetString("killey_notification", srcName, deathCauseLabel))
        exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_deaths", "", GetString("killey_embed", srcName, deathCauseLabel, tostring(data.cause)), 0xFF0000)
    end
end)

-------------------------------------------------
--------------- LOCK NPC VEHICLES ---------------
-------------------------------------------------

if AVAConfig.LockNPCVehicles then
    local alwaysLocked = {}
    for i = 1, #AVAConfig.AlwaysLockedVehicles do
        alwaysLocked[GetHashKey(AVAConfig.AlwaysLockedVehicles[i])] = true
    end
    AVAConfig.AlwaysLockedVehicles = alwaysLocked
    alwaysLocked = nil

    AddEventHandler("entityCreated", function(entity)
        -- entity is not a vehicle or is not a "random" population car
        if GetEntityType(entity) ~= 2 or GetEntityPopulationType(entity) > 5 then
            return
        end

        -- if random is under LockPercentage or vehicle should always be locked and vehicle is not a bike
        if (math.random() < AVAConfig.LockPercentage or AVAConfig.AlwaysLockedVehicles[GetEntityModel(entity)]) then
            -- lock vehicle
            SetVehicleDoorsLocked(entity, 2)
        end
    end)
end

------------------------------------------------
--------------- EXPLOSION EVENTS ---------------
------------------------------------------------

local BlockedExplosions<const> = {1, 2, 4, 5, 25, 32, 33, 35, 36, 37, 38}

AddEventHandler("explosionEvent", function(sender, event)
    for i = 1, #BlockedExplosions do
        if event.explosionType == BlockedExplosions[i] then
            -- CancelEvent()
            exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_dev", "", GetPlayerName(sender)
                .. " made an explosionEvent that would have been canceled, value : " .. event.explosionType, 0xFF0000)
            return
        end
    end
    exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_dev", "", GetPlayerName(sender) .. " made an explosionEvent, value : " .. event.explosionType, 0xFF0000)
end)
