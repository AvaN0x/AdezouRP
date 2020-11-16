-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local noclip, show_names, show_hashes, admin_mode = false, false, false, false
local visibleHash = {}

function OpenAdminMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_admin",
	{
		title    = _("admin_menu"),
		align    = "left",
		elements = {
            {label = _("orange", _("players_list")), value = "players_list"},
            {label = _("orange", _("all_players")), value = "all_players"},
			{label = _("blue", _("admin_tp_marker")), value = "tp_marker"},
			{label = _("pink", _("admin_noclip")), value = "noclip", type="checkbox", checked=noclip},
			{label = _("green", _("admin_repair_vehicle")), value = "repair_vehicle"},
			{label = _("green", _("admin_tp_nearest_vehicle")), value = "tp_nearest_vehicle"},
			{label = _("orange", _("admin_show_hash")), value = "show_hash", type="checkbox", checked=show_hashes},
			{label = _("bright_red", _("admin_mode")), value = "admin_mode", type="checkbox", checked=admin_mode},
			{label = _("red", _("admin_change_skin")), value = "change_skin"},
		}
	}, function(data, menu)
		if data.current.value == "players_list" then
			players_list()
		elseif data.current.value == "all_players" then
			all_players()
		elseif data.current.value == "tp_marker" then
            admin_tp_marker()
		elseif data.current.value == "noclip" then
			admin_noclip()
		elseif data.current.value == "repair_vehicle" then
			admin_vehicle_repair()
		elseif data.current.value == "tp_nearest_vehicle" then
			admin_tp_nearest_vehicle()
		elseif data.current.value == "show_hash" then
			show_hashes = not show_hashes
		elseif data.current.value == "admin_mode" then
			ToggleAdminMode()
		elseif data.current.value == "change_skin" then
			TriggerEvent('esx_skin:openSaveableMenu', source)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function all_players()
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_admin_allplayers",
	{
		title    = _("all_players"),
		align    = "left",
		elements = {
			{label = _("orange", _("admin_spectate")), value = "admin_spectate"},
            {label = _("orange", _("admin_show_names")), value = "show_names", type="checkbox", checked=show_names},
            {label = _("pink", _("admin_revive_all_close")), value = "admin_revive_all_close"},
			{label = _("orange", _("admin_unban")), value = "admin_unban"},
		}
	}, function(data, menu)
		if data.current.value == "admin_unban" then
			admin_unban()
		elseif data.current.value == "admin_spectate" then
			players_list_spectate()
		elseif data.current.value == "show_names" then
            show_names = not show_names
			RemoveAllPlayersBlips()
		elseif data.current.value == "admin_revive_all_close" then
			ReviveAllClose()
        end
    end, function(data, menu)
		menu.close()
	end)
end

function players_list()
    local elements = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(elements, {label = GetPlayerServerId(player) .. ' - ' .. GetPlayerName(player), value = player})
    end
    if #elements >= 1 then
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_admin_playerslist",
        {
            title    = _("admin_spectate"),
            align    = "left",
            elements = elements
        }, function(data, menu)
            PlayerManagment(data.current.value)
		end, function(data, menu)
            menu.close()
        end)
    end
end

function players_list_spectate()
    local elements = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(elements, {label = GetPlayerServerId(player) .. ' - ' .. GetPlayerName(player), value = player})
    end
    if #elements >= 1 then
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_admin_playerslist_spectate",
        {
            title    = _("players_list"),
            align    = "left",
            elements = elements
        }, function(data, menu)
            PlayerManagment(data.current.value)
		end, function(data, menu)
			admin_spectate_player(-1)
            menu.close()
		end, function(data, menu)
			admin_spectate_player(data.current.value)
        end)
    end
end

function PlayerManagment(player)
	local serverID = GetPlayerServerId(player)
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_admin_playermanagment_" .. serverID,
	{
		title    = serverID .. ' - ' .. GetPlayerName(player),
		align    = "left",
		elements = {
			{label = _("blue", _("admin_goto")), value = "admin_goto"},
			{label = _("blue", _("admin_bring")), value = "admin_bring"},
			{label = _("pink", _("admin_revive")), value = "admin_revive"},
			{label = _("pink", _("admin_debug")), value = "admin_debug"},
			{label = _("orange", _("admin_spectate")), value = "admin_spectate"},
			{label = _("bright_red", _("admin_kill")), value = "admin_kill"},
			{label = _("bright_red", _("admin_kick")), value = "admin_kick"},
			{label = _("bright_red", _("admin_ban")), value = "admin_ban"},
		}
	}, function(data, menu)
		if data.current.value == "admin_goto" then
			SetPedCoordsKeepVehicle(PlayerPedId(), GetEntityCoords(GetPlayerPed(player)))
		elseif data.current.value == "admin_bring" then
			TriggerServerEvent('esx_ava_personalmenu:bring_sv', serverID, GetEntityCoords(PlayerPedId()))
        elseif data.current.value == "admin_revive" then
            TriggerServerEvent("esx_ava_emsjob:revive2", serverID)
        elseif data.current.value == "admin_debug" then
			TriggerServerEvent("esx_ava_emsjob:revive2", serverID, true)
		elseif data.current.value == "admin_spectate" then
			admin_spectate_player(player)
        elseif data.current.value == "admin_kill" then
			TriggerServerEvent('esx_ava_personalmenu:kill_sv', serverID)
		elseif data.current.value == "admin_kick" then
			EnterReason(function(reason)
				TriggerServerEvent("esx_ava_personalmenu:kick", GetPlayerName(PlayerId()), serverID, reason)
			end)
		elseif data.current.value == "admin_ban" then
			EnterReason(function(reason)
				TriggerServerEvent("ava_connection:banPlayer", serverID, reason)
			end)
		end
    end, function(data, menu)
		admin_spectate_player(-1)
		menu.close()
	end)
end

--todo add default value ?
function EnterReason(cb)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), "ava_personalmenu_admin_playermanagment_enter_reason", {
		title = _('admin_enter_reason')
	}, function(data, menu)
		menu.close()
		cb(data.value)
	end, function(data, menu)
		menu.close()
	end)
end


function AdminLoop()
	if PlayerGroup ~= nil and (PlayerGroup == "mod" or PlayerGroup == "admin" or PlayerGroup == "superadmin" or PlayerGroup == "owner") then
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(10)
				if noclip then
					local playerPed = PlayerPedId()
					local x, y, z = getPosition(playerPed)
					local dx, dy, dz = getCamDirection(playerPed)
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
				else
					Citizen.Wait(500)
				end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(10)
				if show_names then
					local playerPed = PlayerPedId()
					for _, player in ipairs(GetActivePlayers()) do
						if GetPlayerPed(player) ~= playerPed then
							local headId = CreateFakeMpGamerTag(GetPlayerPed(player), (GetPlayerServerId(player) .. ' - ' .. GetPlayerName(player)), false, false, "", false)
						end
					end
				else
					Citizen.Wait(4000)
				end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				if noclip then
					SetEntityInvincible(PlayerPedId(), true)
				elseif admin_mode then
					local playerPed = PlayerPedId()
					SetEntityInvincible(playerPed, true)
					SetSuperJumpThisFrame(PlayerId(-1))
					SetPedMoveRateOverride(playerPed, 2.15)
				else
					Citizen.Wait(2000)
				end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(3000)
				if show_hashes then
					local playerPed = PlayerPedId()
					local playerCoords = GetEntityCoords(playerPed)
					visibleHash = {}
					for _, v in ipairs(GetGamePool("CObject")) do
						local prop = GetObjectIndexFromEntityIndex(v)
						local propCoords = GetEntityCoords(prop)
						if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, propCoords.x, propCoords.y, propCoords.z, false) < 10.0 then
							table.insert(visibleHash, {hash = GetEntityModel(prop), coords = propCoords})
						end
					end
					for _, v in ipairs(GetGamePool("CVehicle")) do
						local prop = GetObjectIndexFromEntityIndex(v)
						local propCoords = GetEntityCoords(prop)
						if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, propCoords.x, propCoords.y, propCoords.z, false) < 10.0 then
							table.insert(visibleHash, {hash = GetEntityModel(prop), entity = prop})
						end
					end
				else
					Citizen.Wait(7000)
				end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(10)
				if show_hashes then
					local playerPed = PlayerPedId()
					local playerCoords = GetEntityCoords(playerPed)
					for _, prop in ipairs(visibleHash) do
						if prop.coords then
							DrawText3D(prop.coords.x, prop.coords.y, prop.coords.z, prop.hash, 0.3)
						else
							local coords = GetEntityCoords(prop.entity)
							DrawText3D(coords.x, coords.y, coords.z, prop.hash, 0.3)
						end
					end
				else
					Citizen.Wait(7000)
				end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Wait(5000)
				if show_names then
					local playerPed = PlayerPedId()
					for _, player in ipairs(GetActivePlayers()) do
						if GetPlayerPed(player) ~= playerPed then
							local targetPed = GetPlayerPed(player)
							local blip = GetBlipFromEntity(targetPed)

							if not DoesBlipExist(blip) then
								blip = AddBlipForEntity(targetPed)
								SetBlipSprite(blip, 1)
								SetBlipColour(blip, 8)
								SetBlipCategory(blip, 7)
								SetBlipScale(blip, 0.7)
								ShowHeadingIndicatorOnBlip(blip, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString(GetPlayerServerId(player) .. ' - ' .. GetPlayerName(player))
								EndTextCommandSetBlipName(blip)
							end
						end
					end
				end
			end
		end)
	end
end

function getPosition(playerPed)
	local x, y, z = table.unpack(GetEntityCoords(playerPed, true))

	return x, y, z
end

function getCamDirection(playerPed)
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

RegisterNetEvent('esx_ava_personalmenu:bring_cl')
AddEventHandler('esx_ava_personalmenu:bring_cl', function(playerPedCoords)
	SetPedCoordsKeepVehicle(PlayerPedId(), playerPedCoords)
end)

RegisterNetEvent('esx_ava_personalmenu:kill_cl')
AddEventHandler('esx_ava_personalmenu:kill_cl', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

function admin_spectate_player(player)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(player)
	if targetPed ~= playerPed then
		NetworkSetInSpectatorMode(true, targetPed)
		SetEntityInvincible(playerPed, true)
		SetEntityVisible(playerPed, false, 0)
		SetEveryoneIgnorePlayer(playerPed, true)
		SetEntityCollision(playerPed, false, false)
		FreezeEntityPosition(playerPed, true)
	else
		NetworkSetInSpectatorMode(false, targetPed)
		SetEntityInvincible(playerPed, false)
		SetEntityVisible(playerPed, true, 0)
		SetEveryoneIgnorePlayer(playerPed, false)
		SetEntityCollision(playerPed, true, true)
		FreezeEntityPosition(playerPed, false)
	end
end

function admin_noclip()
	noclip = not noclip
	local playerPed = PlayerPedId()

	if noclip then
		-- SetPlayerInvincible(playerPed, true)
		SetEntityVisible(playerPed, false, false)
		ESX.ShowNotification("NoClip ~g~Activé")
	else
		-- if not admin_mode then
			-- SetPlayerInvincible(playerPed, false)
		-- end
		SetEntityVisible(playerPed, true, false)
		ESX.ShowNotification("NoClip ~r~Désactivé")
	end
end

function RemoveAllPlayersBlips()
	if not show_names then
		for _, id in ipairs(GetActivePlayers()) do
			local ped = GetPlayerPed(id)
			local blip = GetBlipFromEntity(ped)

			if DoesBlipExist(blip) then
				RemoveBlip(blip)
			end
		end
	end
end

function admin_vehicle_repair()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

	SetVehicleFixed(vehicle)
	SetVehicleDirtLevel(vehicle, 0.0)
end

function admin_tp_nearest_vehicle()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed, true)

	TaskWarpPedIntoVehicle(playerPed, GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71), -1)
end


RegisterNetEvent('esx_ava_personalmenu:toggle_admin_mode')
AddEventHandler('esx_ava_personalmenu:toggle_admin_mode', function()
	if IsDead then
		TriggerEvent('esx_ava_emsjob:revive2')
	end
	ToggleAdminMode()
end)

function ToggleAdminMode()
	admin_mode = not admin_mode
	show_names = admin_mode

	RemoveAllPlayersBlips()
	local playerPed = PlayerPedId()
	local playerId = PlayerId()
	SetPedCanRagdoll(playerPed, not admin_mode)

	if admin_mode then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, json.decode('{"pants_1":106,"glasses_2":11,"torso_2":5,"helmet_1":-1,"chain_2":0,"bags_2":0,"arms":3,"glasses_1":29,"torso_1":274,"bproof_2":0,"tshirt_2":0,"shoes_2":5,"bproof_1":0,"bags_1":0,"shoes_1":83,"pants_2":5,"tshirt_1":15,"chain_1":0,"helmet_2":0}'))
			else
				TriggerEvent('skinchanger:loadClothes', skin, json.decode('{"glasses_2":0,"pants_2":5,"bags_2":0,"helmet_1":-1,"pants_1":113,"chain_1":0,"tshirt_2":0,"glasses_1":5,"bproof_1":0,"torso_1":287,"bproof_2":0,"chain_2":0,"shoes_1":87,"tshirt_1":14,"torso_2":5,"bags_1":0,"shoes_2":5,"arms":8,"helmet_2":0}'))
			end
		end)
	else
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		ClearPedBloodDamage(playerPed)
		ResetPedVisibleDamage(playerPed)
		ResetPedMovementClipset(playerPed, 0)
	end
end


function ReviveAllClose()
	local playerPed = PlayerPedId()
	local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 15.0)

	for k, player in ipairs(players) do
		TriggerServerEvent("esx_ava_emsjob:revive2", GetPlayerServerId(player))
	end
end

RegisterNetEvent('esx_ava_personalmenu:notifStaff')
AddEventHandler('esx_ava_personalmenu:notifStaff', function(content)
	if PlayerGroup ~= nil and (PlayerGroup == "mod" or PlayerGroup == "admin" or PlayerGroup == "superadmin" or PlayerGroup == "owner") then
		ESX.ShowNotification(content)
	end
end)

function admin_unban()
	ESX.TriggerServerCallback('ava_connection:getBannedElements', function(elements)
		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_admin_unban",
        {
            title    = _("admin_unban_title"),
            align    = "left",
            elements = elements
        }, function(data, menu)
			TriggerServerEvent('ava_connection:unban', data.current.value)
			menu.close()
		end, function(data, menu)
            menu.close()
        end)
	end)
end
