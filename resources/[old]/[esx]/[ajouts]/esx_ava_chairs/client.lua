-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local chair = nil
local isSitting = false
local IsDead = false
local oldCoords = nil

Citizen.CreateThread(function()
	while true do
		Wait(1000)
        chair = getChair()
	end
end)

Citizen.CreateThread(function()
	while true do
        Wait(0)
        if not IsDead then
            if chair and not isSitting then
                DrawText3D(chair.x, chair.y, chair.z, _U("sit_down"))

                if IsControlJustPressed(0, Config.Key) then
                    -- Animation(Config.Anims[chair.type])
                    TriggerServerEvent("esx_ava_chairs:sitDown", chair)
                end
            elseif chair and isSitting then
                DrawText3D(chair.x, chair.y, chair.z, _U("stand_up"))

                if IsControlJustPressed(0, Config.Key) then
                    StandUp()
                end
            end
        end
    end
end)


function getChair()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	for _,v in ipairs(Config.Props) do
		local closestProp = GetClosestObjectOfType(coords, 0.7, v.hash, false, false, false)

		if DoesEntityExist(closestProp) then
			local markerCoords = GetOffsetFromEntityInWorldCoords(closestProp, v.offX, v.offY, v.offZ)

			return {x = markerCoords.x, y = markerCoords.y, z = markerCoords.z + 0.9, heading = GetEntityHeading(closestProp) + v.offHeading, type = v.type}
		end
	end
	return nil
end


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

RegisterNetEvent('esx_ava_chairs:sitDown')
AddEventHandler('esx_ava_chairs:sitDown', function()
    Animation()
end)

function Animation()
    isSitting = true
    local playerPed = PlayerPedId()
    oldCoords = GetEntityCoords(playerPed)

    TriggerEvent("skinchanger:getSkin", function(skin)
        local anim = Config.Anims[chair.type][skin.sex and "Female" or "Male"]
        if anim.dict ~= nil then
            SetEntityCoords(playerPed, chair.x, chair.y, chair.z)
            SetEntityHeading(playerPed, chair.heading)

            RequestAnimDict(anim.dict)
            while not HasAnimDictLoaded(anim.dict) do
                Citizen.Wait(0)
            end

            TaskPlayAnim(playerPed, anim.dict, anim.anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
            FreezeEntityPosition(playerPed, true)
        else
            TaskStartScenarioAtPosition(playerPed, anim.scenario, chair.x, chair.y, chair.z, chair.heading, 0, true, true)
        end
    end)
end

function StandUp()
    TriggerServerEvent("esx_ava_chairs:standUp", chair)
    isSitting = false
    local playerPed = PlayerPedId()

    ClearPedTasksImmediately(playerPed)
    FreezeEntityPosition(playerPed, false)
    SetEntityCoords(playerPed, oldCoords.x, oldCoords.y, oldCoords.z - 0.98)
end

AddEventHandler("esx:onPlayerDeath", function()
    if isSitting then
        StandUp()
    end
	IsDead = true
end)

AddEventHandler("playerSpawned", function(spawn)
	IsDead = false
end)
