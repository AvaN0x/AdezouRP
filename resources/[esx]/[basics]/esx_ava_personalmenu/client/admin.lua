-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local noclip, showname, showHash = false, false, false
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
			{label = _("pink", _("admin_noclip")), value = "noclip"},
			{label = _("green", _("admin_repair_vehicle")), value = "repair_vehicle"},
			{label = _("orange", _("admin_show_hash")), value = "show_hash"},
			{label = _("red", _("admin_change_skin")), value = "change_skin"},
		}
	}, function(data, menu)
		if data.current.value == "tp_marker" then
            admin_tp_marker()
		elseif data.current.value == "players_list" then
            players_list()
		elseif data.current.value == "all_players" then
            all_players()
		elseif data.current.value == "noclip" then
			admin_noclip()
		elseif data.current.value == "repair_vehicle" then
			admin_vehicle_repair()
		elseif data.current.value == "show_hash" then
			showHash = not showHash
		elseif data.current.value == "change_skin" then
			changer_skin()
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
            {label = _(showname and "green" or "orange", _("admin_show_names")), value = "show_names"},
		}
	}, function(data, menu)
        if data.current.value == "show_names" then
            showname = not showname
            for _, id in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(id)
                local blip = GetBlipFromEntity(ped)

                if DoesBlipExist(blip) then
                    RemoveBlip(blip)
                end
            end
            menu.update({value = "show_names"}, {label = _(showname and "green" or "orange", _("admin_show_names"))})
            menu.refresh()
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
            title    = _("players_list"),
            align    = "left",
            elements = elements
        }, function(data, menu)
            PlayerManagment(data.current.value)
        end, function(data, menu)
            menu.close()
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
			{label = _("pink", _("admin_revive")), value = "admin_revive"},
			{label = _("blue", _("admin_goto")), value = "admin_goto"},
			{label = _("blue", _("admin_bring")), value = "admin_bring"},
			{label = _("red", _("admin_kill")), value = "admin_kill"},
			{label = _("red", _("admin_kick")), value = "admin_kick"},
		}
	}, function(data, menu)
        if data.current.value == "admin_revive" then
            TriggerServerEvent("esx_ava_emsjob:revive2", serverID)
        elseif data.current.value == "admin_goto" then
            admin_goto(serverID)
        elseif data.current.value == "admin_bring" then
            admin_bring(serverID)
        elseif data.current.value == "admin_kill" then
			SetEntityHealth(GetPlayerPed(player), 0)
		elseif data.current.value == "admin_kick" then
			EnterReason(function(reason)
				TriggerServerEvent("esx_ava_personalmenu:kick", GetPlayerName(PlayerId()), serverID, reason)
			end)
        end
    end, function(data, menu)
		menu.close()
	end)
end

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
					playerPed = PlayerPedId()
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
				else
					Citizen.Wait(500)
				end
			end
		end)
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(30)
				if showname then
					playerPed = PlayerPedId()
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
				Citizen.Wait(3000)
				if showHash then
					playerPed = PlayerPedId()
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
				if showHash then
					playerPed = PlayerPedId()
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
				if showname then
					playerPed = PlayerPedId()
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

function admin_goto(id)
    SetPedCoordsKeepVehicle(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(id))))
end

function admin_bring(id)
    TriggerServerEvent('esx_ava_personalmenu:bring_sv', id, GetEntityCoords(PlayerPedId()))
end

RegisterNetEvent('esx_ava_personalmenu:bring_cl')
AddEventHandler('esx_ava_personalmenu:bring_cl', function(playerPedCoords)
	SetPedCoordsKeepVehicle(PlayerPedId(), playerPedCoords)
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
