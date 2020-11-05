-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local IsDead = false

ESX = nil
PlayerData = nil
PlayerGroup = nil
actualGang = nil

local societyMoney, societyDirtyMoney, society2Money, society2DirtyMoney = nil, nil, nil, nil
local noclip, showname = false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	while PlayerGroup == nil do
		ESX.TriggerServerCallback("esx_avan0x:getUsergroup", function(group) 
			PlayerGroup = group
		end)
		Citizen.Wait(10)
	end

	-- TriggerServerEvent("esx_ava_gang:requestGang") -- already triggered in esx_ava_gang

	AdminLoop()

	RefreshMoney()
	RefreshDirtyMoney()

	RefreshMoney2()
	RefreshDirtyMoney2()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	PlayerData.job = job
	RefreshMoney()
	societyDirtyMoney = nil
	RefreshDirtyMoney()
end)

RegisterNetEvent("esx:setJob2")
AddEventHandler("esx:setJob2", function(job2)
	PlayerData.job2 = job2
	RefreshMoney2()
	society2DirtyMoney = nil
	RefreshDirtyMoney2()
end)

RegisterNetEvent('esx_ava_gang:setGang')
AddEventHandler('esx_ava_gang:setGang', function(gang)
	actualGang = gang
end)

AddEventHandler("esx:onPlayerDeath", function()
	IsDead = true
end)

AddEventHandler("playerSpawned", function(spawn)
	IsDead = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, Config.MenuKey) and not IsDead then
			OpenPersonalMenu()
		end
	end
end)







function OpenPersonalMenu()
	local playerPed = PlayerPedId()
	local elements = {
		{label = _U("orange", _U("sim_card")), value = "sim_card"},
		{label = _U("orange", _U("my_keys")), value = "my_keys"},
		{label = _U("pink", _U("wallet")), value = "wallet"},
		{label = _U("pink", _U("bills_menu")), value = "bills"}
	}
	
	if  IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local isDriver = (GetPedInVehicleSeat(vehicle, -1) == playerPed)
		if GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) ~= 13 then -- remove if bike
			if isDriver or (GetPedInVehicleSeat(vehicle, 0) == playerPed and GetPedInVehicleSeat(vehicle, -1) == 0) then
				table.insert(elements, {label = _U("vehicle_menu"), value = "vehicle_menu"})
			end
		end
		if isDriver then
			table.insert(elements, {label = _U("speed_limiter"), value = "speed_limiter"})
		end
	end
	
	-- todo, only if the user have a phone
	table.insert(elements, {label = _U("bright_red", _U("life_invader")), value = "life_invader"})

	table.insert(elements, {label = _U("blue", _U("others_menu")), value = "others_menu"})

	if PlayerData.job ~= nil and PlayerData.job.name ~= "unemployed" and PlayerData.job.grade_name ~= "interim" then
		table.insert(elements, {label = _U("red", _U("society_menu", PlayerData.job.label)), value = "society"})
	end
	if PlayerData.job2 ~= nil and PlayerData.job2.name ~= "unemployed2" and PlayerData.job2.grade_name ~= "interim" then
		table.insert(elements, {label = _U("red", _U("society_menu", PlayerData.job2.label)), value = "society2"})
	end

	if actualGang and actualGang.name and actualGang.grade == 1 then
		table.insert(elements, {label = _U("bright_red", _U("gang_menu", actualGang.label)), value = "gang_menu"})
	end

	if PlayerGroup ~= nil and (PlayerGroup == "mod" or PlayerGroup == "admin" or PlayerGroup == "superadmin" or PlayerGroup == "owner") then
		table.insert(elements, {label = _U("orange", _U("admin_menu")), value = "admin_menu"})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu",
	{
		title    = _U("menu_header"),
		align    = "left",
		elements = elements
	}, function(data, menu)

		if data.current.value == "sim_card" then
			TriggerEvent("NB:closeAllSubMenu")
			TriggerEvent("NB:closeAllMenu")
			TriggerEvent("NB:closeMenuKey")
			TriggerEvent("NB:carteSIM")

		elseif data.current.value == "my_keys" then
			TriggerEvent("esx_menu:key")

		elseif data.current.value == "wallet" then
			menu.close()
			OpenWalletMenu()

		elseif data.current.value == "vehicle_menu" then
			OpenVehicleMenu()

		elseif data.current.value == "speed_limiter" then
			OpenSpeedMenu()

		elseif data.current.value == "bills" then
			OpenBillsMenu()

		elseif data.current.value == "life_invader" then
			OpenLifeInvaderMenu()

		elseif data.current.value == "others_menu" then
			OpenOthersMenu()

		elseif data.current.value == "society" then
			OpenSocietyMenu(PlayerData.job, societyMoney, societyDirtyMoney)

		elseif data.current.value == "society2" then
			OpenSocietyMenu(PlayerData.job2, society2Money, society2DirtyMoney)

		elseif data.current.value == "gang_menu" then
			TriggerEvent("esx_ava_gang:openMenu")

		elseif data.current.value == "admin_menu" then
			OpenAdminMenu()

		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBillsMenu()
	ESX.TriggerServerCallback("esx_ava_personalmenu:getBills", function(bills)
		local elements = {}

		for i = 1, #bills, 1 do
			table.insert(elements, {label = _U("bills_item", bills[i].label, bills[i].amount), value = "pay_bill", billId = bills[i].id})
		end

		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_bills",
		{
			title    = _U("bills_menu"),
			align    = "left",
			elements = elements
		}, function(data, menu)
			if data.current.value == "pay_bill" then
				ESX.TriggerServerCallback("esx_billing:payBill", function()
					menu.close()
					OpenBillsMenu()
				end, data.current.billId)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenWalletMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_wallet",
	{
		title    = _U("wallet"),
		align    = "left",
		elements = {
			{label = _U("blue", _U("wallet_idcard")), value = nil},
			{label = _U("green", _U("wallet_driver_license")), value = "driver"},
			{label = _U("red", _U("wallet_weapon_port_license")), value = "weapon"}
		}
	}, function(data, menu)
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_wallet2",
		{
			title    = data.current.label,
			align    = "left",
			elements = {
				{label = _U("wallet_show"), value = "show"},
				{label = _U("wallet_check"), value = "check"}
			}
		}, function(data2, menu2)
			if data2.current.value == "show" then
				closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestDistance ~= -1 and closestDistance <= 3.0 then
					TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), data.current.value)
				else
					ESX.ShowNotification(_U("no_players_nearby"))
				end
			elseif data2.current.value == "check" then
				TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), data.current.value)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVehicleMenu()
	local playerPed = PlayerPedId()
	local vDoorsOpen = {
		[0] = false, -- front left
		[1] = false, -- front right
		[2] = false, -- back left
		[3] = false, -- back right
		[4] = false, -- hood
		[5] = false -- trunk
	}
	
	local elements = {}
	vehicle = GetVehiclePedIsIn(playerPed, false)

	if GetPedInVehicleSeat(vehicle, -1) == playerPed then
		table.insert(elements, {label = _U("vehicle_engine"), value = "vehicle_engine"})

		if DoesVehicleHaveDoor(vehicle, 4) then
			table.insert(elements, {label = _U("vehicle_hood"), value = "vehicle_door", door = 4})
		end
		if DoesVehicleHaveDoor(vehicle, 5) then
			table.insert(elements, {label = _U("vehicle_trunk"), value = "vehicle_door", door = 5})
		end
		if DoesVehicleHaveDoor(vehicle, 0) and GetVehicleClass(vehicle) ~= 8 then -- remove if motorcycle
			table.insert(elements, {label = _U("vehicle_door_frontleft"), value = "vehicle_door", door = 0})
		end
		if DoesVehicleHaveDoor(vehicle, 1) then
			table.insert(elements, {label = _U("vehicle_door_frontright"), value = "vehicle_door", door = 1})
		end
		if DoesVehicleHaveDoor(vehicle, 2) then
			table.insert(elements, {label = _U("vehicle_door_backleft"), value = "vehicle_door", door = 2})
		end
		if DoesVehicleHaveDoor(vehicle, 3) then
			table.insert(elements, {label = _U("vehicle_door_backright"), value = "vehicle_door", door = 3})
		end

	elseif GetPedInVehicleSeat(vehicle, 0) == playerPed and GetPedInVehicleSeat(vehicle, -1) == 0 then
		table.insert(elements, {label = _U("vehicle_move_to_driver_seat"), value = "move_to_driver_seat"})
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_vehicle_menu",
	{
		title    = _U("vehicle_menu"),
		align    = "left",
		elements = elements
	}, function(data, menu)
		if IsPedSittingInAnyVehicle(playerPed) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
			if data.current.value == "vehicle_engine" then
				if GetIsVehicleEngineRunning(vehicle) then
					SetVehicleEngineOn(vehicle, false, false, true)
					SetVehicleUndriveable(vehicle, true)
				elseif not GetIsVehicleEngineRunning(vehicle) then
					SetVehicleEngineOn(vehicle, true, false, true)
					SetVehicleUndriveable(vehicle, false)
				end
			elseif data.current.value == "vehicle_door" then
				vDoorsOpen[data.current.door] = not vDoorsOpen[data.current.door]
				if vDoorsOpen[data.current.door] then
					SetVehicleDoorOpen(vehicle, data.current.door, false, false)
				else
					SetVehicleDoorShut(vehicle, data.current.door, false, false)
				end
			elseif data.current.value == "move_to_driver_seat" then
				if GetPedInVehicleSeat(vehicle, 0) == playerPed and GetPedInVehicleSeat(vehicle, -1) == 0 then
					TriggerEvent("esx_avan0x:moveToDriverSeat")
					Citizen.Wait(5000)
					menu.refresh()
					OpenVehicleMenu()
				else
					ESX.ShowNotification(_U("not_in_passenger_seat"))
				end
			end
		else
			ESX.ShowNotification(_U("not_in_vehicle"))
		end

	end, function(data, menu)
		menu.close()
	end)

end

function OpenSpeedMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_speed_limiter",
	{
		title    = _U("speed_limiter"),
		align    = "left",
		elements = {
			{label = _U("speed_disable"), value = "speed_disable"},
			{label = _U("speed_set_at", 50), value = "set_speed", speed = 50},
			{label = _U("speed_set_at", 90), value = "set_speed", speed = 90},
			{label = _U("speed_set_at", 130), value = "set_speed", speed = 130}
		}
	}, function(data, menu)
		if data.current.value == "speed_disable" then
			TriggerEvent("teb_speed_control:stop")
		elseif data.current.value == "set_speed" then
			TriggerEvent("teb_speed_control:setSpeedLimiter", data.current.speed)
		end
	end, function(data, menu)
		menu.close()
	end)

end


function OpenLifeInvaderMenu()
	ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "life_invader", {
		title = _U("enter_message")
	}, function(data, menu)
		menu.close()
		TriggerServerEvent("esx_avan0x:lifeInvader", data.value)
	end, function(data, menu)
		menu.close()
	end)
end



local interface = true
function OpenOthersMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_others",
	{
		title    = _U("others_menu"),
		align    = "left",
		elements = {
			{label = _U("others_toggle_hud"), value = "toggle_hud"}
		}
	}, function(data, menu)
		if data.current.value == "toggle_hud" then
			interface = not interface
			TriggerEvent('ui:toggle', interface)
			DisplayRadar(interface)
		end
	end, function(data, menu)
		menu.close()
	end)
end





---------------
-- JOB MENUS --
---------------

function OpenSocietyMenu(job, money, dirtyMoney)
	local elements = {}
	if job.grade_name == "boss" then
		table.insert(elements, {label = _U("society_money", money or 0)})
		if dirtyMoney ~= nil and tonumber(dirtyMoney) > 0 then
			table.insert(elements, {label = _U("society_dirty_money", dirtyMoney or 0)})
		end
	end

	
	-- todo, only if the user have a phone
	table.insert(elements, {label = _U("life_invader"), value = "life_invader"})
	table.insert(elements, {label = _U("billing"), value = "billing"})
	
	
	if job.grade_name == "boss" then
		table.insert(elements, {label = _U("society_first_job"), value = "society_first_job"})
		table.insert(elements, {label = _U("society_second_job"), value = "society_second_job"})
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_society",
	{
		title    = _U("society_menu", job.label),
		align    = "left",
		elements = elements
	}, function(data, menu)
		if data.current.value == "life_invader" then
			ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "life_invader", {
				title = _U("enter_message")
			}, function(data, menu)
				menu.close()
				TriggerServerEvent("esx_avan0x:lifeInvader", data.value, job.label)
			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == "billing" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing',
				{
					title = _U('billing_amount')
				},
				function(data, menu)
					local amount = tonumber(data.value)
					if amount == nil or amount <= 0 then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification(_U('no_players_nearby'))
						else
							local playerPed = GetPlayerPed(-1)

							Citizen.CreateThread(function()
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
								Citizen.Wait(5000)
								ClearPedTasks(playerPed)
								TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(closestPlayer), "society_"..job.name, job.label, amount)
							end)
						end
					end
				end,
				function(data, menu)
					menu.close()
				end)
		elseif data.current.value == "society_first_job" then
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_society_first_job",
			{
				title    = _U("society_first_job", job.label),
				align    = "left",
				elements = {
					{label = _U("society_hire"), value = "society_hire"},
					{label = _U("society_fire"), value = "society_fire"},
					{label = _U("society_promote"), value = "society_promote"},
					{label = _U("society_demote"), value = "society_demote"}
				}
			}, function(data2, menu2)
				closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification(_U("no_players_nearby"))

				elseif data2.current.value == "society_hire" then
					TriggerServerEvent("esx_ava_personalmenu:society_hire", GetPlayerServerId(closestPlayer), job.name)

				elseif data2.current.value == "society_fire" then
					TriggerServerEvent("esx_ava_personalmenu:society_fire", GetPlayerServerId(closestPlayer), job.name)

				elseif data2.current.value == "society_promote" then
					TriggerServerEvent("esx_ava_personalmenu:society_promote", GetPlayerServerId(closestPlayer), job.name)

				elseif data2.current.value == "society_demote" then
					TriggerServerEvent("esx_ava_personalmenu:society_demote", GetPlayerServerId(closestPlayer), job.name)

				end
			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == "society_second_job" then
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_society_second_job",
			{
				title    = _U("society_second_job", job.label),
				align    = "left",
				elements = {
					{label = _U("society_hire"), value = "society_hire"},
					{label = _U("society_fire"), value = "society_fire"},
					{label = _U("society_promote"), value = "society_promote"},
					{label = _U("society_demote"), value = "society_demote"}
				}
			}, function(data2, menu2)
				closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification(_U("no_players_nearby"))

				elseif data2.current.value == "society_hire" then
					TriggerServerEvent("esx_ava_personalmenu:society_hire2", GetPlayerServerId(closestPlayer), job.name)

				elseif data2.current.value == "society_fire" then
					TriggerServerEvent("esx_ava_personalmenu:society_fire2", GetPlayerServerId(closestPlayer), job.name)

				elseif data2.current.value == "society_promote" then
					TriggerServerEvent("esx_ava_personalmenu:society_promote2", GetPlayerServerId(closestPlayer), job.name)

				elseif data2.current.value == "society_demote" then
					TriggerServerEvent("esx_ava_personalmenu:society_demote2", GetPlayerServerId(closestPlayer), job.name)

				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function RefreshMoney()
	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSocietyMoney(money)
		end, PlayerData.job.name)
	end
end

function RefreshDirtyMoney()
	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyDirtyMoney', function(money)
			UpdateSocietyDirtyMoney(money)
		end, PlayerData.job.name)
	end
end

function RefreshMoney2()
	if PlayerData.job2 ~= nil and PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			UpdateSociety2Money(money)
		end, PlayerData.job2.name)
	end
end

function RefreshDirtyMoney2()
	if PlayerData.job2 ~= nil and PlayerData.job2.grade_name == 'boss' then
		ESX.TriggerServerCallback('esx_society:getSocietyDirtyMoney', function(money)
			UpdateSociety2DirtyMoney(money)
		end, PlayerData.job2.name)
	end
end


RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)
	if PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' and 'society_' .. PlayerData.job.name == society then
		UpdateSocietyMoney(money)
	elseif PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' and 'society_' .. PlayerData.job.name .. "_black" == society then 
		UpdateSocietyDirtyMoney(money)
	end
	if PlayerData.job2 ~= nil and PlayerData.job2.grade_name == 'boss' and 'society_' .. PlayerData.job2.name == society then
		UpdateSociety2Money(money)
	elseif PlayerData.job2 ~= nil and PlayerData.job2.grade_name == 'boss' and 'society_' .. PlayerData.job2.name .. "_black" == society then 
		UpdateSociety2DirtyMoney(money)
	end
end)


function UpdateSocietyMoney(money)
	societyMoney = ESX.Math.GroupDigits(money)
end

function UpdateSocietyDirtyMoney(money)
	societyDirtyMoney = ESX.Math.GroupDigits(money)
end

function UpdateSociety2Money(money)
	society2Money = ESX.Math.GroupDigits(money)
end

function UpdateSociety2DirtyMoney(money)
	society2DirtyMoney = ESX.Math.GroupDigits(money)
end


----------------
-- ADMIN MENU --
----------------

function OpenAdminMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_admin",
	{
		title    = _U("admin_menu"),
		align    = "left",
		elements = {
			{label = _U("blue", _U("admin_tp_marker")), value = "tp_marker"},
			{label = _U("blue", _U("admin_goto")), value = "goto"},
			{label = _U("blue", _U("admin_bring")), value = "bring"},
			{label = _U("pink", _U("admin_noclip")), value = "noclip"},
			{label = _U("green", _U("admin_repair_vehicle")), value = "repair_vehicle"},
			{label = _U("orange", _U("admin_show_names")), value = "show_names"},
			{label = _U("red", _U("admin_change_skin")), value = "change_skin"},
			{label = _U("red", _U("admin_save_skin")), value = "save_skin"}
		}
	}, function(data, menu)
		if data.current.value == "tp_marker" then
			admin_tp_marker()
		elseif data.current.value == "goto" then
			admin_goto()
		elseif data.current.value == "bring" then
			admin_bring()
		elseif data.current.value == "noclip" then
			admin_noclip()
		elseif data.current.value == "repair_vehicle" then
			admin_vehicle_repair()
		elseif data.current.value == "show_names" then
			showname = not showname
			for _, id in ipairs(GetActivePlayers()) do
				local ped = GetPlayerPed(id)
				local blip = GetBlipFromEntity(ped)

				if DoesBlipExist(blip) then
					RemoveBlip(blip)
				end
			end
		elseif data.current.value == "change_skin" then
			changer_skin()
		elseif data.current.value == "save_skin" then
			save_skin()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function AdminLoop()
	if PlayerGroup ~= nil and (PlayerGroup == "mod" or PlayerGroup == "admin" or PlayerGroup == "superadmin" or PlayerGroup == "owner") then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				playerPed = PlayerPedId()
				if noclip then
					local x, y, z = getPosition()
					local dx, dy, dz = getCamDirection()
					local speed = Config.noclip_speed

					SetTextComponentFormat('STRING')
					AddTextComponentString("~INPUT_AIM~ pour quitter, ~INPUT_SPRINT~ pour accélérer")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)

					SetEntityVelocity(playerPed, 0.0001, 0.0001, 0.0001)
					if IsControlPressed(0, 21) then
						speed = Config.noclip_speed_shift
					end
					if IsControlPressed(0, 32) then
						x = x + speed * dx
						y = y + speed * dy
						z = z + speed * dz
					end
					if IsControlPressed(0, 269) then
						x = x - speed * dx
						y = y - speed * dy
						z = z - speed * dz
					end
					SetEntityCoordsNoOffset(playerPed, x, y, z, true, true, true)

					if IsControlPressed(0, 25) then
						admin_noclip()
					end
				end
				if showname then
					for _, player in ipairs(GetActivePlayers()) do
						if GetPlayerPed(player) ~= playerPed then
							local headId = CreateFakeMpGamerTag(GetPlayerPed(player), (GetPlayerServerId(player) .. ' - ' .. GetPlayerName(player)), false, false, "", false)
						end
					end
				end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Wait(5000)
				if showname then
					playerPed = PlayerPedId()
					for _, player in ipairs(GetActivePlayers()) do
						if GetPlayerPed(player) ~= playerPed then
							local targetPed = GetPlayerPed(player)
							local blip = GetBlipFromEntity(targetPed)

							if not DoesBlipExist(blip) then
								print("blip doest not exist for "..player)
								blip = AddBlipForEntity(targetPed)
								SetBlipSprite(blip, 1)
								SetBlipColour(blip, 8)
								SetBlipCategory(blip, 7)
								SetBlipScale(blip, 0.7)
								ShowHeadingIndicatorOnBlip(blip, true)
								-- SetBlipNameToPlayerName(blip, player)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(GetPlayerServerId(player) .. ' - ' .. GetPlayerName(player))
								EndTextCommandSetBlipName(blip)
							else
								local blipSprite = GetBlipSprite(blip)
								print("blip exist for "..player.." with sprite number "..blipSprite)
								local veh = GetVehiclePedIsIn(targetPed, false)
								if not GetEntityHealth(targetPed) then
									print(player.." is dead with sprite number "..blipSprite)
									if blipSprite ~= 274 then
										print("set blip sprite to ".. 274 .. " for ".. player)
										SetBlipSprite(blip, 274)
									end
								elseif veh then
									vehClass = GetVehicleClass(veh)
									if vehClass == 16 then -- plane
										if blipSprite ~= 423 then
											print("set blip sprite to ".. 423 .. " for ".. player)
											SetBlipSprite(blip, 423)
										end
									elseif vehClass == 15 then -- heli
										if blipSprite ~= 422 then
											print("set blip sprite to ".. 422 .. " for ".. player)
											SetBlipSprite(blip, 422)
										end
									elseif vehClass == 14 then -- boat
										if blipSprite ~= 404 then
											print("set blip sprite to ".. 404 .. " for ".. player)
											SetBlipSprite(blip, 404)
										end
									elseif blipSprite ~= 1 then -- default blip
										SetBlipSprite(blip, 1)
									end
									-- show number of passenger on blip (have a max of 5?)
									local passengers = GetVehicleNumberOfPassengers(veh)
									if passengers and passengers > 1 then
										ShowNumberOnBlip(blip, passengers)
									else
										HideNumberOnBlip(blip)
									end
								else
									if blipSprite ~= 1 then
										-- hide number of passenger
										HideNumberOnBlip(blip)
										SetBlipSprite(blip, 1)
									end
								end
							end
						end
					end
				end
			end
		end)
	end
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true
	
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

function getPosition()
	local x, y, z = table.unpack(GetEntityCoords(playerPed, true))

	return x, y, z
end

function getCamDirection()
	local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(playerPed)
	local pitch = GetGameplayCamRelativePitch()

	local x = -math.sin(heading * math.pi/180.0)
	local y = math.cos(heading * math.pi/180.0)
	local z = math.sin(pitch * math.pi/180.0)

	local len = math.sqrt(x * x + y * y + z * z)

	if len ~= 0 then
		x = x/len
		y = y/len
		z = z/len
	end

	return x, y, z
end


function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
				break
			end
			Citizen.Wait(0)
		end
		ESX.ShowNotification("Téléportation ~g~Effectuée")
	else
		ESX.ShowNotification("Aucun ~r~Marqueur")
	end
end

function admin_goto()
	local playerPed = PlayerPedId()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)

		if type(plyId) == 'number' then
			local targetPlyCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(plyId)))
			SetPedCoordsKeepVehicle(playerPed, targetPlyCoords)
		end
	end
end

function admin_bring()
	local plyId = KeyboardInput("KORIOZ_BOX_ID", _U('dialogbox_playerid'), "", 8)

	if plyId ~= nil then
		plyId = tonumber(plyId)

		if type(plyId) == 'number' then
			local playerPedCoords = GetEntityCoords(PlayerPedId())
			TriggerServerEvent('esx_ava_personalmenu:bring_sv', plyId, playerPedCoords)
		end
	end
end

RegisterNetEvent('esx_ava_personalmenu:bring_cl')
AddEventHandler('esx_ava_personalmenu:bring_cl', function(playerPedCoords)
	SetEntityCoords(PlayerPedId(), playerPedCoords)
end)


function admin_noclip()
	noclip = not noclip
	local playerPed = PlayerPedId()

	if noclip then
		SetEntityInvincible(playerPed, true)
		SetEntityVisible(playerPed, false, false)
		ESX.ShowNotification("NoClip ~g~Activé")
	else
		SetEntityInvincible(playerPed, false)
		SetEntityVisible(playerPed, true, false)
		ESX.ShowNotification("NoClip ~r~Désactivé")
	end
end

function admin_vehicle_repair()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	SetVehicleFixed(vehicle)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function changer_skin()
	Citizen.Wait(100)
	TriggerEvent('esx_skin:openSaveableMenu', source)
end

function save_skin()
	TriggerEvent('esx_skin:requestSaveSkin', source)
end
