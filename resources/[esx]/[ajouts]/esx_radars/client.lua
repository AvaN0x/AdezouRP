--===============================================--===============================================
--= stationary radars based on  https://github.com/DreanorGTA5Mods/StationaryRadar           =
--===============================================--===============================================
ESX              = nil
local PlayerData = {}
local blips = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
    
    setBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    setBlips()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    PlayerData.job2 = job2
end)


local radars = {
    {x = 442.7, y = -510.11, z = 28.68-0.98,        max = 130,  size = 10, name = "Freeway Sud"},  --Entrée ville freeway
    {x = 1869.47, y = 3612.34, z = 34.51-0.98,      max = 90,   size = 10, name = "Joshua Road Est"}, -- Panneau sandy shores senora ouest
    {x = 310.2, y = 3426.03, z = 36.76-0.98,        max = 90,   size = 10, name = "Joshua Road Ouest"}, -- senora east
    {x = 2065.84, y = 4682.78, z = 41.18-0.98,      max = 90,   size = 10, name = "Seaview Road"}, --mckenzie
    {x = 386.21, y = 6577.61, z = 27.74-0.98,       max = 130,  size = 10, name = "Paleto Blvd Est"}, --Paleto est
    {x = -427.96, y = 5929.92, z = 32.35-0.98,      max = 130,  size = 10, name = "Paleto Blvd Ouest"}, --Paleto ouest
    {x = -1602.93, y = 1342.68, z = 132.58-0.98,    max = 90,   size = 10, name = "Route 11"}, --route vigneron jet ski
    {x = 87.99, y = -1026.12, z = 29.49-0.98,       max = 90,   size = 10, name = "Elgin Avenue"}, --centre ammunation
    {x = -210.82, y = -875.29, z = 29.58-0.98,      max = 90,   size = 10, name = "Vespucci Blvd"}, --parking rouge
    {x = -2490.99, y = -216.1, z = 18.05-0.98,      max = 130,  size = 10, name = "Great ocean"}, --great ocean 
    {x = -202.36, y = -483.42, z = 34.54-0.98,      max = 90,   size = 15, name = "Las Lagunas Blvd"}, --Las Lagunas Blvd
}

Citizen.CreateThread(function()
    while Config.Debug do
        Wait(0)
        
        for k, radar in pairs(radars) do
            local player = PlayerPedId()
            local coords = GetEntityCoords(player, true)
            if #(coords - vector3(radar.x, radar.y, radar.z)) < 100 then
                DrawMarker(1, radar.x, radar.y, radar.z - 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radar.size * 2 + 0.0, radar.size * 2 + 0.0, 4.0, 255, 255, 255, 256, false, true, 2, false, false, false, false)
                DrawMarker(1, radar.x, radar.y, radar.z + 2, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, radar.size * 2 + 0.0, radar.size * 2 + 0.0, 4.0, 255, 255, 255, 256, false, true, 2, false, false, false, false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(20)
        
        for k, radar in pairs(radars) do
            local player = PlayerPedId()
            local coords = GetEntityCoords(player, true)
            if #(coords - vector3(radar.x, radar.y, radar.z)) < radar.size and math.abs(coords.z - radar.z) < 2 then -- we only want a height difference of maximum 2
                checkSpeed(radar.max, radar.name)
            end
        end
    end
end)

function checkSpeed(maxspeed, radarName)
    local pP = PlayerPedId()
    local speed = GetEntitySpeed(pP)
    local vehicle = GetVehiclePedIsIn(pP, false)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local plate = GetVehicleNumberPlateText(vehicle)
    local kmphspeed = math.ceil(speed*2.236936*1.60934)
	local fineamount = nil
    local truespeed = kmphspeed
    local roundedSpeedOver = nil
    if kmphspeed > (maxspeed + 5) and driver == pP then
        Citizen.Wait(250)

        if truespeed >= (maxspeed + 5) and truespeed <= (maxspeed + 10) then
            fineamount = Config.MinFine
            roundedSpeedOver = 5
        else
            local speedOver = truespeed - maxspeed
            roundedSpeedOver = speedOver - (speedOver % 10)
            fineamount = math.ceil(Config.MinFine * ((roundedSpeedOver / 10) * (roundedSpeedOver / 10) / 3))
            if fineamount < Config.MinFine then
                fineamount = Config.MinFine
            elseif fineamount > Config.MaxFine then
                fineamount = Config.MaxFine
            end
        end
        local finelevel = plate..' : +'..roundedSpeedOver..'km/h'
        local stolen = true

        ESX.TriggerServerCallback('esx_radars:getVehicleOwner', function(vowner)
            if vowner then
                if vowner ~= 'society_lspd' and vowner ~= 'society_ems' then
                    if PlayerData.job.grade_name == "interim" and vowner == "society_"..PlayerData.job.name 
                    or PlayerData.job2.grade_name == "interim" and vowner == "society_"..PlayerData.job2.name then
                        TriggerServerEvent('esx_billing:sendBillWithId', PlayerData.identifier, 'society_lspd', finelevel, fineamount)
                    else
                        TriggerServerEvent('esx_billing:sendBillWithId', vowner, 'society_lspd', finelevel, fineamount)
                    end
                end
                stolen = false
            end
            StartScreenEffect('SuccessNeutral', 350, false)

            TriggerServerEvent('esx_radars:notifPolice', plate, truespeed, radarName, stolen)

        end, plate)
        Citizen.Wait(10000)
    end
end


function setBlips()
    -- add blips if police
    if (PlayerData.job ~= nil and PlayerData.job.name == 'lspd') or (PlayerData.job2 ~= nil and PlayerData.job2.name == 'lspd') then
        if blips[1] ~= nil then
            for i=1, #blips, 1 do
                RemoveBlip(blips[i])
                blips[i] = nil
            end
        end

        for k,v in ipairs(radars)do
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip, 1)
            SetBlipColour(blip, 4)
            SetBlipScale(blip, 0.4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(tostring('~c~'..v.name))
            EndTextCommandSetBlipName(blip)
            table.insert(blips, blip)
        end
    else
        if blips and blips[1] ~= nil then
            for i=1, #blips, 1 do
                RemoveBlip(blips[i])
                blips[i] = nil
            end
        end
    end
end

