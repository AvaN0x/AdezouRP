-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

---Check if a given table has a value
---@param table table
---@param val func|any "if val is a function, it will be called for each element of the table"
---@return boolean
function table.has(self, val)
    if self then
        if type(val) == "function" then
            for i = 1, #table do
                local element = table[i]
                if condition(i, element) then
                    return true
                end
            end
        else
            for i = 1, #self do
                local element = self[i]
                if element == val then
                    return true
                end
            end
        end
    end
    return false
end

return table.has
