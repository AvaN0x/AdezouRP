-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Utils = {}

---Trim
---@param string string
---@return string
AVA.Utils.Trim = function(string)
    return (string.gsub(string, "^%s*(.-)%s*$", "%1"))
end
exports("Trim", AVA.Utils.Trim)

---Check if a given table has a value
---@param table table
---@param val any
---@return boolean
AVA.Utils.TableHasValue = function(table, val)
    if table then
        for i = 1, #table do
            local element = table[i]
            if element == val then
                return true
            end
        end
    end
    return false
end
exports("TableHasValue", AVA.Utils.TableHasValue)

---Check if a given table has a condition
---@param table table
---@param condition fun(i: index, element: any)
---@return boolean
AVA.Utils.TableHasCondition = function(table, condition)
    if type(table) == "table" and condition then
        for i = 1, #table do
            local element = table[i]
            if condition(i, element) then
                return true
            end
        end
    end
    return false
end
exports("TableHasCondition", AVA.Utils.TableHasCondition)

---Format a number from "123456789" to "123 456 789"
---@param number any
---@return string
AVA.Utils.FormatNumber = function(number)
    return tostring(number):reverse():gsub("%d%d%d", "%1 "):reverse():gsub("^ ", "")
end
exports("FormatNumber", AVA.Utils.FormatNumber)

---Format a vector3 to a readable string
---@param coord vector3
---@return string
AVA.Utils.Vector3ToString = function(coord)
    return type(coord) == "vector3" and ("vector3(%.2f, %.2f, %.2f)"):format(coord.x, coord.y, coord.z)
end
exports("Vector3ToString", AVA.Utils.Vector3ToString)
