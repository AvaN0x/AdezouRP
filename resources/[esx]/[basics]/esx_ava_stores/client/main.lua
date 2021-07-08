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
        if v.Blip then
            for _, coord in pairs(v.Pos) do
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

        for k, v in pairs(Config.Stores) do
            for _, coord in pairs(v.Pos) do
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






