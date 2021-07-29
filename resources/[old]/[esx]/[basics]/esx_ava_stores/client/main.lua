-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local GUI = {
    Time = 0
}

local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentZoneName = nil
local CurrentHelpText = nil
local CurrentActionEnabled = false

local PlayerData = {}
local mainBlips = {}




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
        local function CreateBlip(coord)
            local blip = AddBlipForCoord(coord)
                    
            SetBlipSprite (blip, v.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, v.Blip.Scale)
            SetBlipColour (blip, v.Blip.Colour)
            SetBlipAsShortRange(blip, true)
            
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Blip.Name or v.Name)
            EndTextCommandSetBlipName(blip)
            
            table.insert(mainBlips, blip)
        end

        if v.Blip then
            if v.Coords then 
                for _, coord in pairs(v.Coords) do
                    CreateBlip(coord)
                end
            elseif v.Coord then
                CreateBlip(v.Coord)
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
        local isInMarker  = false
        local currentZoneName = nil

        local function CheckCoord(coord)

        end

        for k, v in pairs(Config.Stores) do
            if v.Coords then
                for _, coord in ipairs(v.Coords) do
                    local distance = #(playerCoords - coord)
                    if distance < Config.DrawDistance then
                        if v.Marker ~= nil then
                            DrawMarker(v.Marker, coord.x, coord.y, coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        end
                        waitTimer = 0
                        if distance < (v.Distance or v.Size.x or 1.5) then
                            isInMarker = true
                            currentZoneName = k
                        end
                    end
                end
            elseif v.Coord then
                local distance = #(playerCoords - v.Coord)
                if distance < Config.DrawDistance then
                    if v.Marker ~= nil then
                        DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                    end
                    waitTimer = 0
                    if distance < (v.Distance or v.Size.x or 1.5) then
                        isInMarker = true
                        currentZoneName = k
                    end
                end
            end
        end
            
        Wait(waitTimer)
        if (isInMarker and not HasAlreadyEnteredMarker)
            or (isInMarker and CurrentZoneName ~= currentZoneName)
        then
            HasAlreadyEnteredMarker = true
            LastZone = currentZoneName
            TriggerEvent('esx_ava_stores:hasEnteredMarker', currentZoneName)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_ava_stores:hasExitedMarker', LastZone)
        end
    end
end)



AddEventHandler('esx_ava_stores:hasEnteredMarker', function(zoneName)
	if Config.Stores[zoneName].HelpText ~= nil then
        CurrentHelpText = Config.Stores[zoneName].HelpText
    end

    CurrentZoneName = zoneName
    CurrentActionEnabled = true
end)

AddEventHandler('esx_ava_stores:hasExitedMarker', function(zoneName)
	ESX.UI.Menu.CloseAll()
	CurrentZoneName = nil
end)


-----------------
-- Key Control --
-----------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentZoneName ~= nil and CurrentActionEnabled then
            if CurrentHelpText ~= nil then
                SetTextComponentFormat('STRING')
                AddTextComponentString(CurrentHelpText)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end

			if IsControlJustReleased(0, 38) -- E
                and (GetGameTimer() - GUI.Time) > 300
            then
                CurrentActionEnabled = false
                GUI.Time = GetGameTimer()
                local store = Config.Stores[CurrentZoneName]

                if store.Items then
                    BuyZone()
                elseif store.Carwash then
                    CarWash()
                end

			end
        else
            Citizen.Wait(50)
		end
	end
end)



function BuyZone()
    local store = Config.Stores[CurrentZoneName]

    ESX.TriggerServerCallback('esx_ava_stores:GetBuyItems', function(items)
        local elements = {}
        for k, item in pairs(items) do
            table.insert(elements, {
                label = _('store_item_label', item.label, item.isDirtyMoney and "#eb4034" or "#0cc421", item.price),
                price = item.price,
                name = item.name,
                maxCanTake = item.maxCanTake
            })
        end

        if #elements > 0 then
            ESX.UI.Menu.CloseAll()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_stores_store',
            {
                title = store.Name,
                align = 'left',
                elements = elements
            },
            function(data, menu)
                local count = tonumber(exports.esx_avan0x:KeyboardInput(_('how_much_max', data.current.maxCanTake or 0), "", 10))

                if type(count) == "number" and math.floor(count) == count and count > 0 then
                    menu.close()
                    if count > data.current.maxCanTake then
                        ESX.ShowNotification(_('cant_carry'))
                    else
                        TriggerServerEvent('esx_ava_stores:BuyItem', CurrentZoneName, data.current.name, count)
                    end
                else
                    ESX.ShowNotification(_('invalid_quantity'))
                end
                CurrentActionEnabled = true
            end,
            function(data, menu)
                menu.close()
                CurrentActionEnabled = true
            end)
        else
            ESX.ShowNotification(_('nothing_can_buy'))
        end
    end, CurrentZoneName)

end



function CarWash()
    local veh = GetVehiclePedIsUsing(playerPed)
    if veh == 0 then
        ESX.ShowNotification(_('carwash_not_in_vehicle'))
        CurrentActionEnabled = true
    elseif math.ceil(GetEntitySpeed(veh) * 3.6) > 5 then
        ESX.ShowNotification(_('carwash_driving_too_fast'))
        CurrentActionEnabled = true
    else
        ESX.TriggerServerCallback('esx_ava_stores:carwash:checkMoney', function(hasEnoughMoney)
            if not hasEnoughMoney then
                ESX.ShowNotification(_('cant_afford'))
                CurrentActionEnabled = true
            else
                local carwash = Config.Stores[CurrentZoneName]
                local particles = {}
                local isWorking = true

                Citizen.CreateThread(function()
                    while isWorking do
                        DisableAllControlActions(0)
                        EnableControlAction(0, 1, true) -- Enable horizontal cam
                        EnableControlAction(0, 2, true) -- Enable vertical cam
                        Citizen.Wait(0)
                    end
                end)

                FreezeEntityPosition(veh, true)
                FreezeEntityPosition(playerPed, true)
                if carwash.Carwash.Particles then
                    local assetName = "scr_carwash"

                    for i = 1, #carwash.Carwash.Particles do
                        RequestNamedPtfxAsset(assetName)
                        UseParticleFxAsset(assetName)

                        while not HasNamedPtfxAssetLoaded(assetName) do Citizen.Wait(10) end

                        local particle = carwash.Carwash.Particles[i]
                        table.insert(particles, StartParticleFxLoopedAtCoord(particle.Name, particle.Coord, (particle.RotX or 270) + 0.0, particle.Heading + 0.0, 0.0, 1.0, 0.0, 0, 0))
                    end
                end

                exports.progressBars:startUI(carwash.Carwash.Duration or 5000, _('carwash_on_cleaning'))
                Citizen.Wait(carwash.Carwash.Duration or 5000)

                WashDecalsFromVehicle(veh, 1.0)
                SetVehicleDirtLevel(veh)

                if #particles > 0 then
                    for i = 1, #particles do
                        if DoesParticleFxLoopedExist(particles[i]) then
                            StopParticleFxLooped(particles[i], 0)
                            RemoveParticleFx(particles[i], 0)
                        end
                    end
                    particles = nil
                end

                isWorking = false
                FreezeEntityPosition(playerPed, false)
                FreezeEntityPosition(veh, false)
                CurrentActionEnabled = true
                ESX.ShowNotification(_('carwash_vehicle_cleaned'))
            end
        end, CurrentZoneName)
    end
end


-- function Utils:StartWashParticle(actualZone)
--     local asset = "scr_carwash"
    
--     for i = 1, #actualZone.particlesStart do
--         local currentParticle = actualZone.particlesStart[i]

--         RequestNamedPtfxAsset(asset)
--         UseParticleFxAssetNextCall(asset)

--         while not HasNamedPtfxAssetLoaded(asset) do
--             Wait(100)
--         end
        
--         actualZone.particlesStart[i].createdParticle = StartParticleFxLoopedAtCoord(currentParticle.particle, currentParticle.pos, currentParticle.xRot, 0.0, 0.0, 1.0, 0, 0, 0)
        
--         if (currentParticle.nextWait > 0) then 
--             Wait(currentParticle.nextWait)
--         end
--     end
-- end

-- function Utils:StopAllParticles(actualZone)
--     for i = 1, #actualZone.particlesStart do
--         local particle = actualZone.particlesStart[i].createdParticle

--         StopParticleFxLooped(particle, 0)
--         RemoveParticleFx(particle, 0)

--         actualZone.particlesStart[i].createdParticle = nil
--     end
-- end