-------------------------------------------
------- EDITED BY GITHUB.COM/AVAN0X -------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ESX				= nil
inMenu			= false
local showblips	= true
local atbank	= false
local bankMenu	= true
local banks = {
	{name="Pacific Standard", id=108, colour = 18, x=242.04, y=224.45, z=106.286},
	{name="Banque", id=108, colour = 4, x=-1212.980, y=-330.841, z=37.787},
	{name="Banque", id=108, colour = 4, x=-2962.582, y=482.627, z=15.703},
	{name="Banque", id=108, colour = 4, x=-112.202, y=6469.295, z=31.626},
	{name="Banque", id=108, colour = 4, x=314.187, y=-278.621, z=54.170},
	{name="Banque", id=108, colour = 4, x=-351.534, y=-49.529, z=49.042},
	{name="Banque", id=108, colour = 4, x=1175.0643310547, y=2706.6435546875, z=38.094036102295},
	{name="Banque", id=108, colour = 4, x=149.4551, y=-1038.95, z=29.366}
}	

local atms = {
	{name="ATM", id=277, x=237.43, y=217.87, z=106.840, w = 296.0},
	{name="ATM", id=277, x=-386.733, y=6045.953, z=31.501, w = 0.0},
	{name="ATM", id=277, x=-386.733, y=6045.953, z=31.501, w = 0.0},
	{name="ATM", id=277, x=-284.037, y=6224.385, z=31.187, w = 0.0},
	{name="ATM", id=277, x=-284.037, y=6224.385, z=31.187, w = 0.0},
	{name="ATM", id=277, x=-135.165, y=6365.738, z=31.101, w = 0.0},
	{name="ATM", id=277, x=-110.753, y=6467.703, z=31.784, w = 0.0},
	{name="ATM", id=277, x=-94.9690, y=6455.301, z=31.784, w = 0.0},
	{name="ATM", id=277, x=155.4300, y=6641.991, z=31.784, w = 0.0},
	{name="ATM", id=277, x=174.6720, y=6637.218, z=31.784, w = 0.0},
	{name="ATM", id=277, x=1703.138, y=6426.783, z=32.730, w = 0.0},
	{name="ATM", id=277, x=1735.114, y=6411.035, z=35.164, w = 0.0},
	{name="ATM", id=277, x=1702.842, y=4933.593, z=42.051, w = 0.0},
	{name="ATM", id=277, x=1967.333, y=3744.293, z=32.272, w = 0.0},
	{name="ATM", id=277, x=1821.917, y=3683.483, z=34.244, w = 0.0},
	{name="ATM", id=277, x=1174.532, y=2705.278, z=38.027, w = 0.0},
	{name="ATM", id=277, x=540.0420, y=2671.007, z=42.177, w = 0.0},
	{name="ATM", id=277, x=2564.399, y=2585.100, z=38.016, w = 0.0},
	{name="ATM", id=277, x=2558.683, y=349.6010, z=108.050, w = 0.0},
	{name="ATM", id=277, x=2558.051, y=389.4817, z=108.660, w = 0.0},
	{name="ATM", id=277, x=1077.692, y=-775.796, z=58.218, w = 0.0},
	{name="ATM", id=277, x=1139.018, y=-469.886, z=66.789, w = 0.0},
	{name="ATM", id=277, x=1168.975, y=-457.241, z=66.641, w = 0.0},
	{name="ATM", id=277, x=1153.884, y=-326.540, z=69.245, w = 0.0},
	{name="ATM", id=277, x=381.2827, y=323.2518, z=103.270, w = 0.0},
	{name="ATM", id=277, x=265.0043, y=212.1717, z=106.780, w = 0.0},
	{name="ATM", id=277, x=285.2029, y=143.5690, z=104.970, w = 0.0},
	{name="ATM", id=277, x=157.7698, y=233.5450, z=106.450, w = 0.0},
	{name="ATM", id=277, x=-164.568, y=233.5066, z=94.919, w = 0.0},
	{name="ATM", id=277, x=-1827.04, y=785.5159, z=138.020, w = 0.0},
	{name="ATM", id=277, x=-1409.39, y=-99.2603, z=52.473, w = 0.0},
	{name="ATM", id=277, x=-1205.35, y=-325.579, z=37.870, w = 0.0},
	{name="ATM", id=277, x=-1215.64, y=-332.231, z=37.881, w = 0.0},
	{name="ATM", id=277, x=-2072.41, y=-316.959, z=13.345, w = 0.0},
	{name="ATM", id=277, x=-2975.72, y=379.7737, z=14.992, w = 0.0},
	{name="ATM", id=277, x=-2962.60, y=482.1914, z=15.762, w = 0.0},
	{name="ATM", id=277, x=-2955.70, y=488.7218, z=15.486, w = 0.0},
	{name="ATM", id=277, x=-3044.22, y=595.2429, z=7.595, w = 0.0},
	{name="ATM", id=277, x=-3144.13, y=1127.415, z=20.868, w = 0.0},
	{name="ATM", id=277, x=-3241.10, y=996.6881, z=12.500, w = 0.0},
	{name="ATM", id=277, x=-3241.11, y=1009.152, z=12.877, w = 0.0},
	{name="ATM", id=277, x=-1305.40, y=-706.240, z=25.352, w = 0.0},
	{name="ATM", id=277, x=-538.225, y=-854.423, z=29.234, w = 0.0},
	{name="ATM", id=277, x=-711.156, y=-818.958, z=23.768, w = 0.0},
	{name="ATM", id=277, x=-717.614, y=-915.880, z=19.268, w = 0.0},
	{name="ATM", id=277, x=-526.566, y=-1222.90, z=18.434, w = 0.0},
	{name="ATM", id=277, x=-256.831, y=-719.646, z=33.444, w = 0.0},
	{name="ATM", id=277, x=-203.548, y=-861.588, z=30.205, w = 0.0},
	{name="ATM", id=277, x=112.4102, y=-776.162, z=31.427, w = 0.0},
	{name="ATM", id=277, x=112.9290, y=-818.710, z=31.386, w = 0.0},
	{name="ATM", id=277, x=119.9000, y=-883.826, z=31.191, w = 0.0},
	{name="ATM", id=277, x=-846.304, y=-340.402, z=38.687, w = 0.0},
	{name="ATM", id=277, x=-1204.35, y=-324.391, z=37.877, w = 0.0},
	{name="ATM", id=277, x=-1216.27, y=-331.461, z=37.773, w = 0.0},
	{name="ATM", id=277, x=-56.1935, y=-1752.53, z=29.452, w = 0.0},
	{name="ATM", id=277, x=-261.692, y=-2012.64, z=30.121, w = 0.0},
	{name="ATM", id=277, x=-273.001, y=-2025.60, z=30.197, w = 0.0},
	{name="ATM", id=277, x=314.187, y=-278.621, z=54.170, w = 0.0},
	{name="ATM", id=277, x=-351.534, y=-49.529, z=49.042, w = 0.0},
	{name="ATM", id=277, x=24.589, y=-946.056, z=29.357, w = 0.0},
	{name="ATM", id=277, x=-254.112, y=-692.483, z=33.616, w = 0.0},
	{name="ATM", id=277, x=-1570.197, y=-546.651, z=34.955, w = 0.0},
	{name="ATM", id=277, x=-1415.909, y=-211.825, z=46.500, w = 0.0},
	{name="ATM", id=277, x=-1430.112, y=-211.014, z=46.500, w = 0.0},
	{name="ATM", id=277, x=33.232, y=-1347.849, z=29.497, w = 0.0},
	{name="ATM", id=277, x=129.216, y=-1292.347, z=29.269, w = 0.0},
	{name="ATM", id=277, x=287.645, y=-1282.646, z=29.659, w = 0.0},
	{name="ATM", id=277, x=289.012, y=-1256.545, z=29.440, w = 0.0},
	{name="ATM", id=277, x=295.839, y=-895.640, z=29.217, w = 0.0},
	{name="ATM", id=277, x=1686.753, y=4815.809, z=42.008, w = 0.0},
	{name="ATM", id=277, x=-302.408, y=-829.945, z=32.417, w = 0.0},
	{name="ATM", id=277, x=5.134, y=-919.949, z=29.557, w = 0.0},
	{name="ATM", id=277, x=-1132.024, y=-1704.055, z=3.44, w = 0.0},
	{name="ATM", id=277, x=-572.796, y=-397.908, z=33.9, w = 0.0},

	{name="ATM", id=277, x=903.69, y=-164.06, z=74.17, w = 0.0}, -- taxi

}
--================================================================================================
--==                                THREADING - DO NOT EDIT                                     ==
--================================================================================================

--===============================================
--==           Base ESX Threading              ==
--===============================================
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)





--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
	Citizen.CreateThread(function()
		while true do
			Wait(0)
			local ped = PlayerPedId()
			local bank = nearBank()
			local atm = nearATM()
			if bank and not inMenu then
				DisplayHelpText("Appuie sur ~INPUT_PICKUP~ pour accèder à compte ~b~")
			
				if IsControlJustPressed(1, 38) then
					OpenBank()
				end
			elseif atm and not inMenu then
				DisplayHelpText("Appuie sur ~INPUT_PICKUP~ pour accèder à compte ~b~")
			
				if IsControlJustPressed(1, 38) then
					TaskGoStraightToCoord(ped, atm.x, atm.y, atm.z, 10.0, 10, atm.w, 0.5)
					Wait(2500)
					-- ClearPedTasksImmediately(ped)
					TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, false)
					Wait(8000)

					OpenBank()
					Wait(15000)
					ClearPedTasksImmediately(ped)

				end
			end
					
			if IsControlJustPressed(1, 322) and inMenu then
				SetNuiFocus(false, false)
				SendNUIMessage({type = 'close'})
				-- ClearPedTasks(ped)
				Wait(500)
				ClearPedTasksImmediately(ped)
				inMenu = false
			end
		end
	end)
end


function OpenBank()
	inMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({type = 'openGeneral'})
	TriggerServerEvent('bank:balance')
	local ped = GetPlayerPed(-1)
end

--===============================================
--==             Map Blips	                   ==
--===============================================
Citizen.CreateThread(function()
	if showblips then
		for k,v in ipairs(banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipColour(blip, v.colour)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
		end
	end
end)



--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit1', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdraw1', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transfer', data.to, data.amountt)
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Result   Event                    ==
--===============================================
RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
	local ped = GetPlayerPed()
	-- ClearPedTasks(ped)
	Wait(500)
	ClearPedTasksImmediately(ped)
	inMenu = false
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			return search
		end
	end
	return nil
end

function nearATM()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(atms) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 1.5 then
			return search
		end
	end
	return nil
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end