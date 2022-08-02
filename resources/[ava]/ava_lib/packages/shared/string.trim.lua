-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

---Trim
---@param string string
---@return string
function string.trim(self)
    return (string.gsub(self, "^%s*(.-)%s*$", "%1"))
end

return string.trim
