-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local language = GetConvar("ava_core_language", "en")
local file = LoadResourceFile(GetCurrentResourceName(), ("languages/%s.json"):format(language))
local strings = file and json.decode(file) or {}

---Get string from language files
---@param str string "string name"
---@param ... any "format arguments"
---@return string
local function GetString(str, ...)
    if not strings then
        print("^1[strings missing]^0 strings have not already loaded.")
        return str
    elseif strings[str] then
        return string.format(strings[str], ...)
    else
        print("^1[String missing] ^0strings[\"^6" .. str .. "^0\"] does not exist in ^6" .. language .. "^0.")
        return str
    end
end

return GetString
