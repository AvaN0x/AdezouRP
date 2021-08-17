-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.table_has_value = function(table, val)
	if type(table) == "table" then
		for i = 1, #table, 1 do
			if table[i] == val then
				return true
			end
		end
	end
	return false
end
exports("table_has_value", AVA.table_has_value)