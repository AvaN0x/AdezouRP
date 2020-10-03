-------------------------------------------
-------- REMADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Keys = {
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

ESX = nil
local MissionCompleted = nil
local MissionStarted
local PedSpawned = nil
local zoneBlip = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function DrawMissionText(msg, time)
	ClearPrints()
	SetTextEntry_2('STRING')
	AddTextComponentString(msg)
	DrawSubtitleTimed(time, 1)
end

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		local timer = 0
		local plyPed = PlayerPedId()
		local coords = GetEntityCoords(plyPed)
		if not MissionStarted then
			local p = Config.HintLocation
			if GetDistanceBetweenCoords(coords, p, true) < Config.DrawTextDist then
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour frapper à la porte")
				if IsControlJustPressed(0, Keys["E"]) then    
					timer = GetGameTimer()
					TaskGoStraightToCoord(plyPed, p.x, p.y, p.z, 10.0, 10, p.w, 0.5)
					Wait(3000)
					ClearPedTasksImmediately(plyPed)

					while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do 
						RequestAnimDict("timetable@jimmy@doorknock@")
						Citizen.Wait(0)
					end
					TaskPlayAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )     
					Citizen.Wait(0)
					while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do 
						Citizen.Wait(0)
					end    

					Citizen.Wait(1000)
					
					TriggerServerEvent('3dme:shareDisplay', "* L'individu remarque un petit morceau de papier glissé sous la porte *")

					ClearPedTasksImmediately(plyPed)

					local randNum = math.random(1,#Config.SalesLocations)
					local spawnLoc = Config.SalesLocations[randNum]

					MissionStarted = spawnLoc

					zoneBlip = AddBlipForRadius((spawnLoc.x + math.random(-45,45)),(spawnLoc.y + math.random(-45,45)),spawnLoc.z, 120.0)
						SetBlipSprite(zoneBlip,9)
						SetBlipColour(zoneBlip,1)
						SetBlipAlpha(zoneBlip,95)
						SetBlipRoute(zoneBlip, true)

					DrawMissionText("Tu as ~y~10~s~ minutes, ne sois pas en retard.", 5000)
					MissionStart()
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function MissionStart()
	local plyPed = GetPlayerPed(-1)
	local pPos = GetEntityCoords(plyPed)
	local tPos = MissionStarted
	local prices = {}
	for k,v in pairs(Config.DrugItems) do 
	  prices[v] = math.floor(Config.DrugPrices[v]*(math.random(100.0-Config.MaxPriceVariance,100.0+Config.MaxPriceVariance)/100.0))
	end
	local startTime = GetGameTimer()
	local timer = 600000 -- 10 minutes 
	while ((GetGameTimer() - startTime) < math.floor(timer) and not MissionCompleted) or (MissionCompleted and GetDistanceBetweenCoords(pPos, tPos, true) < (Config.DrawTextDist*30.0)) do
	  Citizen.Wait(0)   
	  plyPed = GetPlayerPed(-1)
	  pPos = GetEntityCoords(plyPed)
	  if GetDistanceBetweenCoords(pPos, tPos, true) < 30.0 then
		if not PedSpawned then
		  local hash = GetHashKey(Config.DealerPed)
		  while not HasModelLoaded(hash) do RequestModel(hash); Citizen.Wait(0); end
		  PedSpawned = CreatePed(4, hash, tPos.x,tPos.y,tPos.z,tPos.w, true,true)
		  SetEntityAsMissionEntity(PedSpawned,true,true)
		  Wait(2000)
		  FreezeEntityPosition(PedSpawned,true)
		  SetModelAsNoLongerNeeded(hash)
		  ESX.ShowNotification("Vous êtes proche de l'acheteur")
		end
		if GetDistanceBetweenCoords(pPos, tPos, true) < Config.DrawTextDist then
		  if not MissionCompleted then 
			startTime = 0
			MissionCompleted = true
			RemoveBlip(zoneBlip)
		  end
		  ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au dealer")
  
		  if IsControlJustPressed(0,38) then
			ESX.TriggerServerCallback('avan0x_dealer:GetDrugCount', function(counts)
			  ESX.UI.Menu.CloseAll()
			  local elements = {}
			  for k,v in pairs(Config.DrugItems) do 
				drugPrice = prices[v]
				table.insert(elements, {label = k..' : $'..drugPrice, val = v, price = drugPrice})
			  end
			  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Drug_Dealer',{ title = "Acheteur de drogues", align = 'left', elements = elements },
				function(data,menu) 
				  local count = false 
				  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'How_Much', {title = "Combien voulez-vous vendre ? [Max : "..counts[data.current.val].."]"}, 
					function(data2, menu2)
					  local quantity = tonumber(data2.value)
  
					  if quantity == nil then
						ESX.ShowNotification("Montant non valide")
					  else
						count = quantity
						menu2.close()
					  end
					end, 
					function(data2, menu2)
					  menu2.close()
					end
				  )
				  while not count do Citizen.Wait(0); end
				  if tonumber(count) > tonumber(counts[data.current.val]) then 
					ESX.ShowNotification("Tu n'as pas tant que ça. "..data.current.val..".")
				  else 
					TriggerServerEvent('avan0x_dealer:Sold',data.current.val,data.current.price,count)
					menu.close()
					Citizen.Wait(1500)
				  end
				end,
				function(data,menu)
				  menu.close()
				end
			  )
			end)
		  end
		end
	  end
	end
  
	if not MissionCompleted then
	  ESX.ShowNotification("Vous avez manqué de temps et l'acheteur est parti.")
	  RemoveBlip(zoneBlip)
	  if PedSpawned then 
		DeletePed(PedSpawned)
	  end
	  MissionCompleted = false 
	  MissionStarted = false
	  PedSpawned = false
	else
	  ESX.ShowNotification("Le dealer a quitté l'endroit.")
	  if PedSpawned then 
		DeletePed(PedSpawned)
	  end
	  MissionCompleted = false 
	  MissionStarted = false
	  PedSpawned = false
	end
  end
  