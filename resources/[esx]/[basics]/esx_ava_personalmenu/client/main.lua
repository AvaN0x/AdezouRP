-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
IsDead = false

ESX = nil
PlayerData = nil
PlayerGroup = nil
actualGang = nil

local societyMoney, societyDirtyMoney, society2Money, society2DirtyMoney = nil, nil, nil, nil

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
		Citizen.Wait(10)
		if IsControlJustReleased(0, Config.MenuKey) and not IsDead then
			OpenPersonalMenu()
		end
	end
end)





function OpenPersonalMenu()
	local playerPed = PlayerPedId()
	local elements = {
		{label = _("orange", _("sim_card")), value = "sim_card"},
		{label = _("orange", _("my_keys")), value = "my_keys"},
		{label = _("pink", _("wallet")), value = "wallet"},
		{label = _("pink", _("bills_menu")), value = "bills"}
	}
	
	if  IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local isDriver = (GetPedInVehicleSeat(vehicle, -1) == playerPed)
		if GetVehicleClass(GetVehiclePedIsIn(playerPed, false)) ~= 13 then -- remove if bike
			if isDriver or (GetPedInVehicleSeat(vehicle, 0) == playerPed and GetPedInVehicleSeat(vehicle, -1) == 0) then
				table.insert(elements, {label = _("vehicle_menu"), value = "vehicle_menu"})
			end
		end
		if isDriver then
			table.insert(elements, {label = _("speed_limiter"), value = "speed_limiter"})
		end
	end
	
	-- todo, only if the user have a phone
	table.insert(elements, {label = _("bright_red", _("life_invader")), value = "life_invader"})

	table.insert(elements, {label = _("blue", _("others_menu")), value = "others_menu"})

	if PlayerData.job ~= nil and PlayerData.job.name ~= "unemployed" and PlayerData.job.grade_name ~= "interim" then
		table.insert(elements, {label = _("red", _("society_menu", PlayerData.job.label)), value = "society"})
	end
	if PlayerData.job2 ~= nil and PlayerData.job2.name ~= "unemployed2" and PlayerData.job2.grade_name ~= "interim" then
		table.insert(elements, {label = _("red", _("society_menu", PlayerData.job2.label)), value = "society2"})
	end

	if actualGang and actualGang.name and actualGang.grade == 1 then
		table.insert(elements, {label = _("bright_red", _("gang_menu", actualGang.label)), value = "gang_menu"})
	end

	if PlayerGroup ~= nil and (PlayerGroup == "mod" or PlayerGroup == "admin" or PlayerGroup == "superadmin" or PlayerGroup == "owner") then
		table.insert(elements, {label = _("orange", _("admin_menu")), value = "admin_menu"})
	end


	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu",
	{
		title    = _("menu_header"),
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
			table.insert(elements, {label = _("bills_item", bills[i].label, bills[i].amount), value = "pay_bill", billId = bills[i].id})
		end

		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_bills",
		{
			title    = _("bills_menu"),
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
		title    = _("wallet"),
		align    = "left",
		elements = {
			{label = _("blue", _("wallet_idcard")), value = nil},
			{label = _("green", _("wallet_driver_license")), value = "driver"},
			{label = _("red", _("wallet_weapon_port_license")), value = "weapon"}
		}
	}, function(data, menu)
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_wallet2",
		{
			title    = data.current.label,
			align    = "left",
			elements = {
				{label = _("wallet_show"), value = "show"},
				{label = _("wallet_check"), value = "check"}
			}
		}, function(data2, menu2)
			if data2.current.value == "show" then
				closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestDistance ~= -1 and closestDistance <= 3.0 then
					TriggerServerEvent("jsfour-idcard:open", GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), data.current.value)
				else
					ESX.ShowNotification(_("no_players_nearby"))
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
		table.insert(elements, {label = _("vehicle_engine"), value = "vehicle_engine"})

		if DoesVehicleHaveDoor(vehicle, 4) then
			table.insert(elements, {label = _("vehicle_hood"), value = "vehicle_door", door = 4})
		end
		if DoesVehicleHaveDoor(vehicle, 5) then
			table.insert(elements, {label = _("vehicle_trunk"), value = "vehicle_door", door = 5})
		end
		if DoesVehicleHaveDoor(vehicle, 0) and GetVehicleClass(vehicle) ~= 8 then -- remove if motorcycle
			table.insert(elements, {label = _("vehicle_door_frontleft"), value = "vehicle_door", door = 0})
		end
		if DoesVehicleHaveDoor(vehicle, 1) then
			table.insert(elements, {label = _("vehicle_door_frontright"), value = "vehicle_door", door = 1})
		end
		if DoesVehicleHaveDoor(vehicle, 2) then
			table.insert(elements, {label = _("vehicle_door_backleft"), value = "vehicle_door", door = 2})
		end
		if DoesVehicleHaveDoor(vehicle, 3) then
			table.insert(elements, {label = _("vehicle_door_backright"), value = "vehicle_door", door = 3})
		end

	elseif GetPedInVehicleSeat(vehicle, 0) == playerPed and GetPedInVehicleSeat(vehicle, -1) == 0 then
		table.insert(elements, {label = _("vehicle_move_to_driver_seat"), value = "move_to_driver_seat"})
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_vehicle_menu",
	{
		title    = _("vehicle_menu"),
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
					ESX.ShowNotification(_("not_in_passenger_seat"))
				end
			end
		else
			ESX.ShowNotification(_("not_in_vehicle"))
		end

	end, function(data, menu)
		menu.close()
	end)

end

function OpenSpeedMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_speed_limiter",
	{
		title    = _("speed_limiter"),
		align    = "left",
		elements = {
			{label = _("speed_disable"), value = "speed_disable"},
			{label = _("speed_set_at", 50), value = "set_speed", speed = 50},
			{label = _("speed_set_at", 90), value = "set_speed", speed = 90},
			{label = _("speed_set_at", 130), value = "set_speed", speed = 130}
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
		title = _("enter_message")
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
		title    = _("others_menu"),
		align    = "left",
		elements = {
			{label = _("others_toggle_hud"), value = "toggle_hud"}
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
		table.insert(elements, {label = _("society_money", money or 0)})
		if dirtyMoney ~= nil and tonumber(dirtyMoney) > 0 then
			table.insert(elements, {label = _("society_dirty_money", dirtyMoney or 0)})
		end
	end

	
	-- todo, only if the user have a phone
	table.insert(elements, {label = _("life_invader"), value = "life_invader"})
	table.insert(elements, {label = _("billing"), value = "billing"})
	
	
	if job.grade_name == "boss" then
		table.insert(elements, {label = _("society_first_job"), value = "society_first_job"})
		table.insert(elements, {label = _("society_second_job"), value = "society_second_job"})
	end

	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_society",
	{
		title    = _("society_menu", job.label),
		align    = "left",
		elements = elements
	}, function(data, menu)
		if data.current.value == "life_invader" then
			ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "life_invader", {
				title = _("enter_message")
			}, function(data, menu)
				menu.close()
				TriggerServerEvent("esx_avan0x:lifeInvader", data.value, job.label)
			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == "billing" then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing',
				{
					title = _('billing_amount')
				},
				function(data, menu)
					local amount = tonumber(data.value)
					if amount == nil or amount <= 0 then
						ESX.ShowNotification(_('invalid_amount'))
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification(_('no_players_nearby'))
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
				title    = _("society_first_job", job.label),
				align    = "left",
				elements = {
					{label = _("society_hire"), value = "society_hire"},
					{label = _("society_fire"), value = "society_fire"},
					{label = _("society_promote"), value = "society_promote"},
					{label = _("society_demote"), value = "society_demote"}
				}
			}, function(data2, menu2)
				closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification(_("no_players_nearby"))

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
				title    = _("society_second_job", job.label),
				align    = "left",
				elements = {
					{label = _("society_hire"), value = "society_hire"},
					{label = _("society_fire"), value = "society_fire"},
					{label = _("society_promote"), value = "society_promote"},
					{label = _("society_demote"), value = "society_demote"}
				}
			}, function(data2, menu2)
				closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					ESX.ShowNotification(_("no_players_nearby"))

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


function DrawText3D(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentString(text)
        DrawText(_x, _y)
        -- local factor = (string.len(text)) / 350
        -- DrawRect(_x, _y + 0.0125, factor + 0.015, 0.03, 35, 35, 35, 150)
    end
end