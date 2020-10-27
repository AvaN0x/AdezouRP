-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local GUI = {}
GUI.Time = 0
-- local PlayerData                = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	-- while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
	-- 	Citizen.Wait(10)
	-- end

	-- PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	for name, config in pairs(Config.Gangs) do

		local HasAlreadyEnteredMarker   = false
		local LastZone                  = nil
		local CurrentAction             = nil
		local CurrentActionMsg          = ''
		local CurrentActionData         = {}


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
				local coords = GetEntityCoords(GetPlayerPed(-1))
				for k,v in pairs(config.Zones) do
					if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
						DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					end
				end
			end
		end)


		-- Enter / Exit marker events
		Citizen.CreateThread(function()
			while true do
				Wait(0)
				local coords      = GetEntityCoords(GetPlayerPed(-1))
				local isInMarker  = false
				local currentZone = nil

				for k,v in pairs(config.Zones) do
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
			end
		end)

		-- Key Controls
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				if CurrentAction ~= nil then
					SetTextComponentFormat('STRING')
					AddTextComponentString(CurrentActionMsg)
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)

					if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 300 then
						if CurrentAction == 'stock' then
							OpenStockMenu(name, config)
						end
						CurrentAction = nil
						GUI.Time = GetGameTimer()
					end
				end
			end
		end)

	end
end)




---------------------------
-------- FUNCTIONS --------
---------------------------



function OpenStockMenu(name, config)
	local elements = {
		{label = _U('deposit_stock'), value = 'put_stock'},
		{label = _U('take_stock'), value = 'get_stock'}
	}

	-- if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName and (PlayerData.job.grade_name == 'boss')) 
	-- or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName and (PlayerData.job2.grade_name == 'boss')) then
	-- 	table.insert(elements, {label = _U('recruitment_menu'), value = 'recruitment_menu'})
	-- end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_actions',
	{
		title    = config.Name,
		align    = 'left',
		css 	 = 'gang',
		elements = elements
	},
	function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutStocksMenu(name, config)
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu(name, config)
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


function OpenPutStocksMenu(name, config)
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
						TriggerServerEvent('esx_ava_gang:putStockItems', data.current.value, count, name)
					elseif data.current.type == "cash" then
						TriggerServerEvent('esx_ava_gang:depositMoney', name, count)
					elseif data.current.type == "black_cash" then
						TriggerServerEvent('esx_ava_gang:depositMoneyDirty', name, count)
					end
					OpenPutStocksMenu(name, config)
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

function OpenGetStocksMenu(name, config)
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
			title    = config.Name .. ' Stock',
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
						TriggerServerEvent('esx_ava_gang:getStockItem', data.current.value, count, name)
					elseif data.current.type == "cash" then
						TriggerServerEvent('esx_ava_gang:withdrawMoney', name, count)
					elseif data.current.type == "black_cash" then
						TriggerServerEvent('esx_ava_gang:withdrawMoneyDirty', name, count)
					end
					OpenGetStocksMenu(name, config)
				end
			end,
			function(data2, menu2)
				menu2.close()
			end)
		end,
		function(data, menu)
			menu.close()
		end)
	end, name)
end
