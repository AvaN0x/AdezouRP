Config                 = {}
Config.DrawDistance    = 100.0
Config.MaxErrors       = 5
Config.SpeedMultiplier = 3.6
Config.Locale = 'fr'

Config.Prices = {
	dmv         = 300,
	drive       = 300,
	drive_bike  = 250,
	drive_truck = 800
}

Config.VehicleModels = {
	drive       = 'blista',
	drive_bike  = 'esskey',
	drive_truck = 'mule'
}

Config.SpeedLimits = {
	residence = 50,
	town      = 90,
	freeway   = 130
}

Config.Zones = {

	DMVSchool = {
		Pos   = {x = 208.03, y = -1383.62, z = 29.58},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos   = {x = 249.409, y = -1407.230, z = 30.4094, h = 317.0},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = -1
	}

}

Config.CheckPoints = {

	{
		Pos = {x = 255.139, y = -1400.731, z = 29.537},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('next_point_speed', Config.SpeedLimits['residence']), 5000)
		end
	},

	{
		Pos = {x = 271.874, y = -1370.574, z = 30.932},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 234.907, y = -1345.385, z = 29.542},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				DrawMissionText(_U('stop_for_ped'), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(3000)

				FreezeEntityPosition(vehicle, false)
				DrawMissionText(_U('good_lets_cont'), 5000)
			end)
		end
	},

	{
		Pos = {x = 217.821, y = -1410.520, z = 28.292},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				DrawMissionText(_U('stop_look_left', Config.SpeedLimits['town']), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(4000)

				FreezeEntityPosition(vehicle, false)
				DrawMissionText(_U('good_turn_right'), 5000)
			end)
		end
	},

	{
		Pos = {x = 178.550, y = -1401.755, z = 27.725},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('watch_traffic_lightson'), 5000)
		end
	},

	{
		Pos = {x = 117.21, y = -1356.1, z = 28.27},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 67.76, y = -1182.17, z = 28.36},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('turn_left_hway'), 5000)
		end
	},

	{
		Pos = {x = 34.81, y = -1168.06, z = 28.58},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')

			DrawMissionText(_U('speed_limit', Config.SpeedLimits['freeway']), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
		end
	},

	{
		Pos = {x = -287.56, y = -1181.18, z = 36.34},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -425.23, y = -485.39, z = 32.41},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -609.01, y = -475.4, z = 33.728},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			DrawMissionText(_U('in_town_speed', Config.SpeedLimits['town']), 5000)
		end
	},

	{
		Pos = {x = -621.52, y = -394.97, z = 33.75},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('stop_for_passing'), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(4000)
			FreezeEntityPosition(vehicle, false)

		end
	},

	{
		Pos = {x = -611.59, y = -336.36, z = 33.77},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -464.01, y = -259.39, z = 35.0},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -259.46, y = -171.74, z = 39.12},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 1.96, y = -285.36, z = 46.42},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = -57.63, y = -528.63, z = 39.37},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 128.46, y = -579.46, z = 30.56},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 332.97, y = -663.14, z = 28.26},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('stop_for_passing'), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(3000)
			FreezeEntityPosition(vehicle, false)
			DrawMissionText(_U('turn_right'), 5000)
		end
	},

	{
		Pos = {x = 291.76, y = -831.84, z = 28.33},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 254.86, y = -931.94, z = 28.30},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 224.17, y = -1017.16, z = 28.36},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 205.37, y = -1116.27, z = 28.36},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 214.99, y = -1269.0, z = 28.37},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 240.58, y = -1311.59, z = 28.41},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 321.12, y = -1326.01, z = 31.12},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 283.72, y = -1379.79, z = 30.31},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('residence')
			DrawMissionText(_U('speed_limit', Config.SpeedLimits['residence']), 5000)

			-- DrawMissionText(_U('go_next_point'), 5000)
		end
	},

	{
		Pos = {x = 234.907, y = -1345.385, z = 29.542},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				DrawMissionText(_U('stop_for_ped'), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(1000)

				FreezeEntityPosition(vehicle, false)
				DrawMissionText(_U('gratz_almost_end'), 5000)
			end)
		end
	},


	{
		Pos = {x = 225.03, y = -1378.92, z = 29.50},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			ESX.Game.DeleteVehicle(vehicle)
		end
	}


	-- {
	-- 	Pos = {x = 255.139, y = -1400.731, z = 29.537},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('next_point_speed', Config.SpeedLimits['residence']), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 271.874, y = -1370.574, z = 30.932},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('go_next_point'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 234.907, y = -1345.385, z = 29.542},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		Citizen.CreateThread(function()
	-- 			DrawMissionText(_U('stop_for_ped'), 5000)
	-- 			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
	-- 			FreezeEntityPosition(vehicle, true)
	-- 			Citizen.Wait(4000)

	-- 			FreezeEntityPosition(vehicle, false)
	-- 			DrawMissionText(_U('good_lets_cont'), 5000)
	-- 		end)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 217.821, y = -1410.520, z = 28.292},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		setCurrentZoneType('town')

	-- 		Citizen.CreateThread(function()
	-- 			DrawMissionText(_U('stop_look_left', Config.SpeedLimits['town']), 5000)
	-- 			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
	-- 			FreezeEntityPosition(vehicle, true)
	-- 			Citizen.Wait(6000)

	-- 			FreezeEntityPosition(vehicle, false)
	-- 			DrawMissionText(_U('good_turn_right'), 5000)
	-- 		end)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 178.550, y = -1401.755, z = 27.725},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('watch_traffic_lightson'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 113.160, y = -1365.276, z = 27.725},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('go_next_point'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = -73.542, y = -1364.335, z = 27.789},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('stop_for_passing'), 5000)
	-- 		PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
	-- 		FreezeEntityPosition(vehicle, true)
	-- 		Citizen.Wait(6000)
	-- 		FreezeEntityPosition(vehicle, false)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = -355.143, y = -1420.282, z = 27.868},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('go_next_point'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = -439.148, y = -1417.100, z = 27.704},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('go_next_point'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = -453.790, y = -1444.726, z = 27.665},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		setCurrentZoneType('freeway')

	-- 		DrawMissionText(_U('hway_time', Config.SpeedLimits['freeway']), 5000)
	-- 		PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = -463.237, y = -1592.178, z = 37.519},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('go_next_point'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = -900.647, y = -1986.28, z = 26.109},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('go_next_point'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 1225.759, y = -1948.792, z = 38.718},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('go_next_point'), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 1225.759, y = -1948.792, z = 38.718},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		setCurrentZoneType('town')
	-- 		DrawMissionText(_U('in_town_speed', Config.SpeedLimits['town']), 5000)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 1163.603, y = -1841.771, z = 35.679},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		DrawMissionText(_U('gratz_stay_alert'), 5000)
	-- 		PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
	-- 	end
	-- },

	-- {
	-- 	Pos = {x = 235.283, y = -1398.329, z = 28.921},
	-- 	Action = function(playerPed, vehicle, setCurrentZoneType)
	-- 		ESX.Game.DeleteVehicle(vehicle)
	-- 	end
	-- }

}
