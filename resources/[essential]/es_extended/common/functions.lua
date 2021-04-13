local Charset = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

ESX.GetRandomString = function(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

ESX.GetConfig = function()
	return Config
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)
	local weapons = ESX.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			return i, weapons[i]
		end
	end
end

ESX.GetWeaponList = function()
	return Config.Weapons
end

ESX.GetWeaponLabel = function(weaponName)
	weaponName = string.upper(weaponName)
	local weapons = ESX.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			return weapons[i].label
		end
	end
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = ESX.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			for j=1, #weapons[i].components, 1 do
				if weapons[i].components[j].name == weaponComponent then
					return weapons[i].components[j]
				end
			end
		end
	end
end

ESX.TableContainsValue = function(table, value)
	for k, v in pairs(table) do
		if v == value then
			return true
		end
	end

	return false
end

ESX.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

    if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

ESX.Round = function(value, numDecimalPlaces)
	return ESX.Math.Round(value, numDecimalPlaces)
end

--? added by AvaN0x
ESX.KeyboardInput = function(textEntry, inputText, maxLength)
    AddTextEntry("FMMC_KEY_TIP1", textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", '', inputText, '', '', '', maxLength)
    input = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(100)
        input = false
        return result or ''
    else
        Citizen.Wait(100)
        input = false
        return ''
    end
end