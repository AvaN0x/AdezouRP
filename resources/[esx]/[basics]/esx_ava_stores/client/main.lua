-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local GUI = {
    Time = 0
}
local PlayerData = {}
local mainBlips = {}

local HasAlreadyEnteredMarker = false
local CurrentZoneName = nil
local CurrentZoneCategory = nil
local CurrentZoneValue = nil
local CurrentHelpText = nil
local CurrentActionEnabled = false





Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

    Citizen.Wait(1000)
    TriggerServerEvent("esx_ava_stores:requestGang")

    for _, v in pairs(Config.Stores) do
        if v.Blip then
            for _, coord in pairs(v.Pos) do
                local blip = AddBlipForCoord(coord)

                SetBlipSprite (blip, v.Blip.Sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale  (blip, v.Blip.Scale)
                SetBlipColour (blip, v.Blip.Colour)
                SetBlipAsShortRange(blip, true)
        
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(v.Name)
                EndTextCommandSetBlipName(blip)
        
                table.insert(mainBlips, blip)
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

RegisterNetEvent('esx_ava_stores:setGang')
AddEventHandler('esx_ava_stores:setGang', function(gang)
	if gang and gang.name then
		actualGang = {name = gang.name, grade = gang.grade}
	else
		actualGang = nil
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if mainBlips then
            for _, blip in ipairs(mainBlips) do
                RemoveBlip(blip)
            end
        end
        mainBlips = {}
	end
end)




local playerCoords = nil
local playerPed = nil

Citizen.CreateThread(function()
	while true do
        playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		Wait(500)
    end
end)




-------------
-- Markers --
-------------

Citizen.CreateThread(function()
	while true do
        local waitTimer = 500

        for _, v in pairs(Config.Stores) do
            for _, coord in pairs(v.Pos) do
                if v.Marker ~= nil and #(playerCoords - coord) < Config.DrawDistance then
                    DrawMarker(v.Marker, coord.x, coord.y, coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                    waitTimer = 0
                end
            end
        end
            
        Wait(waitTimer)
    end
end)

