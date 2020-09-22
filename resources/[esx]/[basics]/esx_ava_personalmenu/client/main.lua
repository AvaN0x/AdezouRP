-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-- local Keys = {
--   ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
--   ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
--   ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
--   ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
--   ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
--   ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
--   ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
--   ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
--   ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
-- }

local IsDead = false

ESX = nil
PlayerData = nil
PlayerGroup = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	while PlayerGroup == nil do
		ESX.TriggerServerCallback('esx_ava_personalmenu:getUsergroup', function(group) 
			PlayerGroup = group
		end)
		Citizen.Wait(10)
	end

end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, Config.MenuKey) and not IsDead then
			OpenPersonalMenu()
			print(PlayerGroup)
		end
	end
end)







function OpenPersonalMenu()
	local elements = {
		{label = _U('orange', _U('sim_card')), value = "sim_card"},
		{label = _U('orange', _U('my_keys')), value = "my_keys"}
	}

	-- if PlayerData.job ~= nil PlayerData.job.grade_name == 'boss' then
		-- table.insert(elements, {label = "", value = ""})
	-- end

	-- todo check if in vehicle

	if PlayerGroup ~= nil and (PlayerGroup == 'mod' or PlayerGroup == 'admin' or PlayerGroup == 'superadmin' or PlayerGroup == 'owner') then
		-- table.insert(elements, {label = "", value = ""})
		print("you have access to admin menu i guess")
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ava_personalmenu',
	{
		title    = _U('menu_header'),
		align    = 'left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'sim_card' then
			TriggerEvent('NB:closeAllSubMenu')
			TriggerEvent('NB:closeAllMenu')
			TriggerEvent('NB:closeMenuKey')
			
			TriggerEvent('NB:carteSIM')
		
		elseif data.current.value == 'my_keys' then
			TriggerEvent("esx_menu:key")

		end
	end, function(data, menu)
		menu.close()
	end)
end


