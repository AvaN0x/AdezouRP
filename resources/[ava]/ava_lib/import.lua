-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-- Load a file containing the function and return the function
local LoadResourceFile = LoadResourceFile
local type = type
local load = load
local side <const> = IsDuplicityVersion() and 'server' or 'client'

local resourceName <const> = "ava_lib"

---Import a file or more from the library and return it.
---@param name string|string[] "name or names"
---@return unknown|unknown[]
function import(name)
    -- Arg is an array, we have to import every element
    if type(name) == "table" then
        local res = {}
        for i = 1, #name do
            res[i] = import(name[i])
        end
        return table.unpack(res)
    end
    -- Else arg should be a string
    if type(name) ~= "string" then
        error("import: argument must be a string or an array of strings")
    end

    local path = ("packages/%s/%s.lua"):format(side, name)
    local file = LoadResourceFile(resourceName, path)

    -- If file is not found, try to load the file from the shared folder
    if not file then
        local path = ("packages/shared/%s.lua"):format(name)
        file = LoadResourceFile(resourceName, path)
    end

    -- If file is still not found, error
    if not file then
        return error(("import: failed, could not find `%s`"):format(name))
    end

    -- Try to load the file
    local f, err = load(file)
    if err then
        return error(("import: failed, could not load `%s`"):format(path))
    end

    -- Return the function if it is a function
    local success, res = pcall(f)
    if not success then
        return error(("import: failed, could not get content from `%s`"):format(path))
    end
    return res
end

---Import a file or more from the library and add it/them to the global table.
---@param name string|string[] "name or names"
---@return unknown|unknown[]
function importGlobal(name)
    if type(name) == "table" then
        for i = 1, #name do
            importGlobal(name[i])
        end
    elseif type(name) == "string" then
        if _G[name] then
            error(("importGlobal: `%s` already exists in the global table"):format(name))
        else
            _G[name] = import(name)
        end
    else
        error("importGlobal: argument must be a string or an array of strings")
    end
end
