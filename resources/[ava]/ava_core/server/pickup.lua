-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Items = AVAConfig.Items
local pickups = {}

---Create an object pickup
---@param coords vector4
---@param itemName string
---@param quantity integer
---@return id string
AVA.CreatePickup = function(coords, itemName, quantity)
    local cfgItem = Items[itemName]
    if not cfgItem or quantity <= 0 then
        return nil
    end
    local propHash = GetHashKey(cfgItem.model and cfgItem.model or "hei_prop_hei_paper_bag")
    local object = CreateObject(propHash, coords.x, coords.y, coords.z, true, true, false)

    Citizen.CreateThread(function()
        while not DoesEntityExist(object) do
            Wait(0)
        end

        if DoesEntityExist(object) and not pickups[object] then
            dprint("Created pickup (" .. tostring(object) .. ") : " .. itemName .. " x" .. quantity)
            SetEntityHeading(coords.w)
            pickups[tostring(object)] = { itemName = itemName, itemLabel = cfgItem.label, quantity = quantity,
                coords = coords.xyz, beeingPickedUp = false }
            local entity = Entity(object)
            entity.state:set("label", cfgItem.label .. " x" .. AVA.Utils.FormatNumber(quantity), true)
            entity.state:set("id", tostring(object), true)

            -- Pickup statebag have to be added at the end, so the handler client side can detect it when label and id are set and not before
            entity.state:set("pickup", true, true)
            Wait(2000)
            FreezeEntityPosition(object, true)
        end
    end)
end
exports("CreatePickup", AVA.CreatePickup)

AVA.RegisterServerCallback("ava_core:server:pickup", function(source, id)
    local hasPickedUp = false
    if pickups[id] and not pickups[id].beeingPickedUp then
        pickups[id].beeingPickedUp = true
        local pickup = pickups[id]

        local src = source
        local aPlayer = AVA.Players.GetPlayer(src)

        if aPlayer then
            local inventory = aPlayer.getInventory()
            local canTake = inventory.canTake(pickup.itemName)
            if canTake > 0 then
                local playerPed = GetPlayerPed(src)
                if playerPed then
                    local playerCoords = GetEntityCoords(playerPed)
                    -- Player should not pickup an object that is too far away
                    if #(pickup.coords - playerCoords) < 3.0 then
                        hasPickedUp = true
                        if canTake >= pickup.quantity then
                            inventory.addItem(pickup.itemName, pickup.quantity)
                            TriggerEvent("ava_logs:server:log",
                                { "citizenid:" .. aPlayer.citizenId, "pickup", "item:" .. pickup.itemName,
                                    pickup.quantity })

                            -- Remove prop
                            DeleteEntity(tonumber(id))
                            -- Remove it from the array
                            pickups[id] = nil
                        else
                            inventory.addItem(pickup.itemName, canTake)
                            TriggerEvent("ava_logs:server:log",
                                { "citizenid:" .. aPlayer.citizenId, "pickup", "item:" .. pickup.itemName, canTake })

                            pickups[id].quantity = pickup.quantity - canTake
                            Entity(tonumber(id)).state:set("label",
                                pickup.itemLabel .. " x" .. AVA.Utils.FormatNumber(pickups[id].quantity), true)
                        end
                    end
                end
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("not_enough_place"))
            end
        end

        -- If haven't been removed
        if pickups[id] then
            pickups[id].beeingPickedUp = false
        end
    end
    return hasPickedUp
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for object, _ in pairs(pickups) do
            DeleteEntity(tonumber(object))
        end
        pickups = {}
    end
end)

-- NetworkGetEntityFromNetworkId
-- NetworkGetNetworkIdFromEntity
