-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local language = GetConvar("ava_core_language", "en")
local file = LoadResourceFile(GetCurrentResourceName(), ("languages/%s.json"):format(language))
local strings = file and json.decode(file) or {}

function GetString(string, ...)
    if not strings then
        print("^1[strings missing]^0 strings have not already loaded.")
        return string
    elseif strings[string] then
        return string.format(strings[string], ...)
    else
        print("^1[String missing] ^0strings[\"^6" .. string .. "^0\"] does not exist in ^6" .. language .. "^0.")
        return string
    end
end
