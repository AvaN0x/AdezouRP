-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local GUI = {}
GUI.Time = 0
-- local PlayerData                = {}

local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}

local actualGang = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	local foundGang = nil
	while foundGang == nil do
		ESX.TriggerServerCallback('esx_ava_gang:getGang', function(gang)
			if gang and gang.name and Config.Gangs[gang.name] then
				actualGang = {name = gang.name, data = Config.Gangs[gang.name], grade = gang.grade}
			end
			foundGang = true
			print(foundGang)
		end)
		Citizen.Wait(10)
	end
end)


RegisterNetEvent('esx_ava_gang:setGang')
AddEventHandler('esx_ava_gang:setGang', function(gang)
	if gang and gang.name and Config.Gangs[gang.name] then
		actualGang = {name = gang.name, data = Config.Gangs[gang.name], grade = gang.grade}
	else
		actualGang = {}
	end
end)


AddEventHandler('esx_ava_gang:hasEnteredMarker', function(zone)
	if zone == 'Stock' then
		CurrentAction     = 'stock'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_ava_gang:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)



-- Display markers
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if actualGang and actualGang.name then
			local coords = GetEntityCoords(GetPlayerPed(-1))
			for k,v in pairs(actualGang.data.Zones) do
				if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		else
			Wait(10000)
		end
	end
end)


-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if actualGang and actualGang.name then
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil
			
			for k,v in pairs(actualGang.data.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			
			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_ava_gang:hasEnteredMarker', currentZone)
			end
			
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ava_gang:hasExitedMarker', LastZone)
			end
		else
			Wait(10000)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if actualGang and actualGang.name then
			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 300 then
					if CurrentAction == 'stock' then
						OpenStockMenu()
					end
					CurrentAction = nil
					GUI.Time = GetGameTimer()
				end
			end
		else
			Wait(10000)
		end
	end
end)





---------------------------
-------- FUNCTIONS --------
---------------------------



function OpenStockMenu()
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('take_stock'), value = 'get_stock'}
	}

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_actions',
	{
		title    = actualGang.data.Name,
		align    = 'left',
		css 	 = 'gang',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		elseif data.current.value == 'recruitment_menu' then
			-- TriggerEvent('esx_society:openBossMenu', Config.JobName, function(data, menu)
			-- 	menu.close()
			-- end, {wash = false})
		end
	end,
	function(data, menu)
		menu.close()
		CurrentAction     = 'stock'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end


function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_ava_gang:getPlayerInventory', function(inventory)
		local elements = {}
		table.insert(elements, {label = "Argent " .. inventory.cash .. '$', type = 'cash'})
		table.insert(elements, {label = "Argent sale " .. inventory.black_cash .. '$', type = 'black_cash'})

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			elements = elements
		},
		function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
			{
				title = _U('quantity')
			},
			function(data2, menu2)
				local count = tonumber(data2.value)
				if count == nil or count <= 0 then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					if data.current.type == "item_standard" then
						TriggerServerEvent('esx_ava_gang:putStockItems', data.current.value, count, actualGang.name)
					elseif data.current.type == "cash" then
						TriggerServerEvent('esx_ava_gang:depositMoney', actualGang.name, count)
					elseif data.current.type == "black_cash" then
						TriggerServerEvent('esx_ava_gang:depositMoneyDirty', actualGang.name, count)
					end
					OpenPutStocksMenu()
				end
			end,
			function(data2, menu2)
				menu2.close()
			end)
		end,
		function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_ava_gang:getStockItems', function(inventory)
		local elements = {}
		table.insert(elements, {label = "Argent " .. inventory.cash .. '$', type = 'cash'})
		table.insert(elements, {label = "Argent sale " .. inventory.black_cash .. '$', type = 'black_cash'})

		for i=1, #inventory.items, 1 do
			if (inventory.items[i].count ~= 0) then
				table.insert(elements, {label = 'x' .. inventory.items[i].count .. ' ' .. inventory.items[i].label, value = inventory.items[i].name, type = 'item_standard'})
			end
		end

		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = actualGang.data.Name .. ' Stock',
			align    = 'left',
			css 	 = 'gang',
			elements = elements
		},
		function(data, menu)
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
			{
				title = _U('quantity')
			},
			function(data2, menu2)
				local count = tonumber(data2.value)
				if count == nil or count <= 0 then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					if data.current.type == "item_standard" then
						TriggerServerEvent('esx_ava_gang:getStockItem', data.current.value, count, actualGang.name)
					elseif data.current.type == "cash" then
						TriggerServerEvent('esx_ava_gang:withdrawMoney', actualGang.name, count)
					elseif data.current.type == "black_cash" then
						TriggerServerEvent('esx_ava_gang:withdrawMoneyDirty', actualGang.name, count)
					end
					OpenGetStocksMenu()
				end
			end,
			function(data2, menu2)
				menu2.close()
			end)
		end,
		function(data, menu)
			menu.close()
		end)
	end, actualGang.name)
end


-------------------------
-------- MEMBERS --------
-------------------------


RegisterNetEvent('esx_ava_gang:openMenu')
AddEventHandler('esx_ava_gang:openMenu', function()
	if actualGang and actualGang.name then
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_gang_recruitment_menu",
		{
			title    = actualGang.data.Name,
			align    = "left",
			elements = {
				{label = _U("gang_hire"), value = "gang_hire"},
				{label = _U("gang_fire"), value = "gang_fire"},
				{label = _U("gang_promote"), value = "gang_promote"},
				{label = _U("gang_demote"), value = "gang_demote"}
			}
		}, function(data2, menu2)
			closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer == -1 or closestDistance > 3.0 then
				ESX.ShowNotification(_U("no_players_nearby"))

			elseif data2.current.value == "gang_hire" then
				TriggerServerEvent("esx_ava_gang:gang_hire", GetPlayerServerId(closestPlayer), actualGang.name)

			elseif data2.current.value == "gang_fire" then
				TriggerServerEvent("esx_ava_gang:gang_fire", GetPlayerServerId(closestPlayer), actualGang.name)


			elseif data2.current.value == "gang_promote" then
				TriggerServerEvent("esx_ava_gang:gang_set_manage", GetPlayerServerId(closestPlayer), actualGang.name, 1)

			elseif data2.current.value == "gang_demote" then
				TriggerServerEvent("esx_ava_gang:gang_set_manage", GetPlayerServerId(closestPlayer), actualGang.name, 0)

			end
		end, function(data2, menu2)
			menu2.close()
		end)
	else
		ESX.ShowNotification(_U("not_in_a_gang"))
	end
end)