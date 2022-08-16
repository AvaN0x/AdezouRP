-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local language <const> = GetConvar("ava_core_language", "en")
local file = LoadResourceFile(GetCurrentResourceName(), ("languages/%s.json"):format(language))
local langs = {}

local prepareLangs;
--- Prepare the array as we need it
--- Every array will be added to its parent with a key concatened with current path with an underscore as separator
prepareLangs = function(data, path)
    if not data then return end

    for k, v in pairs(data) do
        local _path = path and ("%s_%s"):format(path, k) or k
        if type(v) == "table" then
            -- If array, make recursive call
            prepareLangs(v, _path)
        elseif k == "" then
            -- If key is empty, we only take the current path
            langs[path] = v
        else
            langs[_path] = v
        end
    end
end
prepareLangs(json.decode(file), nil)

-- Remove these from memory
prepareLangs, file = nil, nil

-- local strings = file and json.decode(file) or {}

---Get string from language files
---@param str string "string name"
---@param ... any "format arguments"
---@return string
local function GetString(str, ...)
    if langs[str] then
        return string.format(langs[str], ...)
    else
        print("^1[Lang missing] ^0langs[\"^6" .. str .. "^0\"] does not exist in ^6" .. language .. "^0.")
        return str
    end
end

return GetString
