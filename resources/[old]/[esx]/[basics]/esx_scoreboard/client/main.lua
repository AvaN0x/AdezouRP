local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local idVisable = true
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(2000)
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(500)
	SendNUIMessage({
		action = 'updateServerInfo',

		maxPlayers = GetConvarInt('sv_maxclients', 256),
		uptime = 'unknown',
		playTime = '00h 00m'
	})
	SendNUIMessage({
		action = 'setIdPlayer',
		
		id = GetPlayerServerId(PlayerId())
	})
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

-- RegisterNetEvent('esx_scoreboard:updatePing')
-- AddEventHandler('esx_scoreboard:updatePing', function(connectedPlayers)
-- 	SendNUIMessage({
-- 		action  = 'updatePing',
-- 		players = connectedPlayers
-- 	})
-- end)

-- RegisterNetEvent('esx_scoreboard:toggleID')
-- AddEventHandler('esx_scoreboard:toggleID', function(state)
-- 	if state then
-- 		idVisable = state
-- 	else
-- 		idVisable = not idVisable
-- 	end

-- 	SendNUIMessage({
-- 		action = 'toggleID',
-- 		state = idVisable
-- 	})
-- end)

-- RegisterNetEvent('uptime:tick')
-- AddEventHandler('uptime:tick', function(uptime)
-- 	SendNUIMessage({
-- 		action = 'updateServerInfo',
-- 		uptime = uptime
-- 	})
-- end)

function UpdatePlayerTable(connectedPlayers)
	-- local formattedPlayerList, num = {}, 1
	local ems = 0
	local police = 0
	local taxi = 0
	local mechanic = 0
	local state = 0
	-- local slaughterer = 0
	-- local fueler = 0
	-- local lumberjack = 0
	-- local tailor = 0 
	-- local reporter = 0 
	-- local miner = 0
	-- local unemployed = 0
	-- local estate = 0 
	-- local cardeal = 0 
	-- local arma = 0 
	-- local players = 0

	for k,v in pairs(connectedPlayers) do

		-- if num == 1 then
		-- 	table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
		-- 	num = 2
		-- elseif num == 2 then
		-- 	table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
		-- 	num = 3
		-- elseif num == 3 then
		-- 	table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.ping))
		-- 	num = 4
		-- elseif num == 4 then
		-- 	table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.id, v.ping))
		-- 	num = 1
		-- end

		-- players = players + 1

		if v.job == 'ems' or v.job2 == 'ems' then
			ems = ems + 1
        end
		if v.job == 'lspd' or v.job2 == 'lspd' then
		    police = police + 1
        end
		if v.job == 'taxi' or v.job2 == 'taxi' then
            taxi = taxi + 1
        end
		if v.job == 'mechanic' or v.job2 == 'mechanic' then
            mechanic = mechanic + 1
        end
		if v.job == 'state' or v.job2 == 'state' then
			state = state + 1
        end
		--[[ elseif v.job == 'slaughterer' then
			slaughterer = slaughterer + 1
		elseif v.job == 'fueler' then
			fueler = fueler + 1
		elseif v.job == 'lumberjack' then
			lumberjack = lumberjack + 1
		elseif v.job == 'tailor' then
			tailor = tailor + 1 ]]
		-- elseif v.job == 'journaliste' then
		-- 	reporter = reporter + 1
		--[[ elseif v.job == 'miner' then
			miner = miner + 1 ]]
		-- elseif v.job == 'unemployed' then
		-- 	unemployed = unemployed + 1
		-- elseif v.job == 'realestateagent' then
		-- 	estate = estate + 1
		-- elseif v.job == 'cardealer' then
		-- 	cardeal = cardeal + 1
		-- elseif v.job == 'armeria' then
		-- 	arma = arma + 1
		-- end
	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	-- SendNUIMessage({
	-- 	action  = 'updatePlayerList',
	-- 	players = table.concat(formattedPlayerList)
	-- })

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {
			ems = ems, 
			police = police, 
			taxi = taxi, 
			mechanic = mechanic, 
			state = state, 
			-- slaughterer = slaughterer,
			-- fueler = fueler, 
			-- lumberjack = lumberjack, 
			-- tailor = tailor, 
			-- reporter = reporter,
			-- miner = miner, 
			-- unemployed = unemployed, 
			-- estate = estate, 
			-- cardeal = cardeal, 
			-- arma = arma, 
			-- player_count = players
		}
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, Keys['F7']) and IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(200)

		-- D-pad up on controllers works, too!
		elseif IsControlJustReleased(0, 172) and not IsInputDisabled(0) then
			ToggleScoreBoard()
			Citizen.Wait(200)
		end
	end
end)

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({
				action  = 'close'
			})
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		playMinute = playMinute + 1
	
		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updateServerInfo',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)
