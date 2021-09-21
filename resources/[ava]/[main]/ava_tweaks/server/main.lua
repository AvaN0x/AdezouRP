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
    Suicide = {Label = "Suicide", Hash = {0}},
    Melee = {Label = "Melee", Hash = {-1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466, -538741184}},
    Bullet = {
        Label = "Bullet",
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
    Knife = {Label = "Knife", Hash = {-1716189206, 1223143800, -1955384325, -1833087301, 910830060}},
    Car = {Label = "Car", Hash = {133987706, -1553120962}},
    Animal = {Label = "Animal", Hash = {-100946242, 148160082}},
    FallDamage = {Label = "FallDamage", Hash = {-842959696}},
    Explosion = {
        Label = "Explosion",
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
    Gas = {Label = "Gas", Hash = {-1600701090}},
    Burn = {Label = "Burn", Hash = {615608432, 883325847, -544306709}},
    Drown = {Label = "Drown", Hash = {-10959621, 1936677264}},
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
    if data.killedByPlayer then
        local deathCauseLabel = GetDeathCauseLabel(data.weapon)
        local distance = math.abs(#(data.coords - data.killerCoords))
        TriggerEvent("ava_personalmenu:server:notifAdmins", "death",
            "~r~" .. GetPlayerName(src) .. "~s~ got killed by " .. GetPlayerName(data.killerId) .. " with " .. deathCauseLabel .. ".")
        exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_deaths", "",
            GetPlayerName(src) .. " got killed by " .. GetPlayerName(data.killerId) .. " with " .. deathCauseLabel .. " (`" .. data.weapon .. "`) at distance : "
                .. distance, 16711680) -- #ff0000
    else
        local deathCauseLabel = GetDeathCauseLabel(data.cause)
        TriggerEvent("ava_personalmenu:server:notifAdmins", "death", "~r~" .. GetPlayerName(src) .. "~s~ died from " .. deathCauseLabel .. ".")
        exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_deaths", "", GetPlayerName(src) .. " died from " .. deathCauseLabel .. " (`" .. data.cause .. "`).",
            16711680) -- #ff0000
    end
end)

