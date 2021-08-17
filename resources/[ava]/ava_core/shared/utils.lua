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
		for k, v in ipairs(table) do
			if v == val then
				return true
			end
		end
	end
	return false
end
exports("TableHasValue", AVA.Utils.TableHasValue)