-------------------------------------------
-------- REMADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil
local MissionStarted = false

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

RegisterNetEvent('esx_ava_crate_lost:startMission')
AddEventHandler('esx_ava_crate_lost:startMission', function()
    if MissionStarted then
        ESX.ShowNotification("T'en as déjà un en cours sacam")
        return
    end
    local MissionCompleted = false
    MissionStarted = true
    local spawnLoc = Config.Locations[math.random(1, #Config.Locations)]
    local zoneBlip = AddBlipForRadius((spawnLoc.x + math.random(-45, 45)), (spawnLoc.y + math.random(-45, 45)), spawnLoc.z, 120.0)
        SetBlipSprite(zoneBlip, 9)
        SetBlipColour(zoneBlip, 76)
        SetBlipAlpha(zoneBlip, 95)
        SetBlipRoute(zoneBlip, true)

    DrawMissionText("Va la bas.", 5000)


print(spawnLoc)
	local startTime = GetGameTimer()
	local timer = 600000 -- 10 minutes

    local playerPed = PlayerPedId()
    local PropSpawned = nil
    local distance
	repeat
		Citizen.Wait(0)
        distance = #(GetEntityCoords(playerPed) - spawnLoc)
        -- DrawLine(spawnLoc.x, spawnLoc.y, spawnLoc.z, spawnLoc.x, spawnLoc.y, spawnLoc.z + 10, 255, 0, 255, 255) -- debug
		if distance < 80.0 then
			if not PropSpawned then
                PropSpawned = true
                ESX.Game.SpawnObject(GetHashKey(Config.Prop), spawnLoc, function(obj)
                    PropSpawned = obj
                    PlaceObjectOnGroundProperly(obj)
                    FreezeEntityPosition(obj, true)
                    spawnLoc = GetEntityCoords(obj)
                end)
				ESX.ShowNotification("Vous êtes proche de la caisse")
			end

			if distance < 2 then
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer la caisse")

				if IsControlJustPressed(0, 38) then
                    TriggerEvent('esx_ava_lock:dooranim')
                    TriggerServerEvent("esx_ava_crate_lost:getitem")
                    MissionCompleted = true
                end
			end
        else
            Wait(500)
		end
	until not ((GetGameTimer() - startTime) < math.floor(timer) and not MissionCompleted) or (MissionCompleted and distance < 60)

	if not MissionCompleted then
		ESX.ShowNotification("Vous avez manqué de temps et la caisse a été volée")
	else
		ESX.ShowNotification("Vous avez récupéré la caisse")
	end
    RemoveBlip(zoneBlip)
    ESX.Game.DeleteObject(PropSpawned)
    MissionStarted = false
end)