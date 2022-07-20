-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Utils = {}

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

---Check if date is valid
---day from 1 to 31
---month from 1 to 12
---year from 1 to 9999
---@param date string
---@return boolean
AVA.Utils.IsDateValid = function(date)
    local day, month, year = string.match(date, "(%d%d?)/(%d%d?)/(%d%d%d%d)") -- /(\d{1,2})\/(\d{1,2})\/(\d{4})/
    if not year or not month or not day then
        return false
    end
    month, day, year = tonumber(month), tonumber(day), tonumber(year)

    -- Check validity of values
    if day <= 0 or day > 31 or month <= 0 or month > 12 or year <= 0 then
        return false
    end

    -- Values may be right, check based on month
    if month == 4 or month == 6 or month == 9 or month == 11 then
        -- April, June, September, November
        -- Maximum of 30 days
        return day <= 30

    elseif month == 2 then
        -- February
        -- Check for leap year
        if year % 400 == 0 or (year % 4 == 0 and year % 100 ~= 0) then
            -- Leap year
            return day <= 29
        end
        return day <= 28
    end

    -- January, March, May, July, August, October, December
    -- Maximum of 31 days
    return day <= 31
end
exports("IsDateValid", AVA.Utils.IsDateValid)
