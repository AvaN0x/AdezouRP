-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local IsDead = false
local isUsingPropStore = false

AddEventHandler("ava_core:client:playerIsDead", function(isDead)
    IsDead = isDead
end)

local function LoadInteracts()
    for model, data in pairs(Config.PropStores) do
        exports.ava_interact:addModel(model, {
            offset = data.offset.xyz,
            event = "ava_stores:client:interactPropStores",
            canInteract = function(entity)
                return not isUsingPropStore
            end,
        })
    end
end

Citizen.CreateThread(function()
    LoadInteracts()
end)
AddEventHandler("onResourceStart", function(resource)
    if resource == "ava_interact" then
        LoadInteracts()
    end
end)

local function PlayAnimWithPropStore(storeEntity, model, prop)
    local propStore = Config.PropStores[model]
    local playerPed = PlayerPedId()


    if propStore.type == "vending" then
        local interactOffset = propStore.playerOffset or vector3(0.0, -0.97, 0.05)
        local coords = GetOffsetFromEntityInWorldCoords(storeEntity, interactOffset.x, interactOffset.y, interactOffset.z)

        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`)

        -- Move player to coords
        TaskTurnPedToFaceEntity(playerPed, storeEntity, -1)
        TaskGoStraightToCoord(playerPed, coords.x, coords.y, coords.z, 10.0, 10, GetEntityHeading(storeEntity), 0.5)

        -- 0x7D8F4411 is TaskGoStraightToCoord
        while GetScriptTaskStatus(playerPed, 0x7D8F4411) ~= 7 do
            Wait(10)
        end
        TaskTurnPedToFaceEntity(playerPed, storeEntity, -1)

        -- Player is at the vending machine

        exports.ava_core:RequestAnimDict("mini@sprunk")
        exports.ava_core:RequestModel(prop)
        RequestAmbientAudioBank("VENDING_MACHINE")
        -- Play sound
        HintAmbientAudioBank("VENDING_MACHINE", 0, -1)

        Wait(1000)
        -- Play animation
        TaskPlayAnim(playerPed, "mini@sprunk", "plyr_buy_drink_pt1", 8.0, 5.0, -1, true, 1, 0, 0, 0)
        RemoveAnimDict("mini@sprunk")

        Wait(2500)
        -- Create can
        local canEntity = exports.ava_core:SpawnObject(prop, coords)
        SetEntityAsMissionEntity(canEntity, true, true)
        SetEntityProofs(canEntity, false, true, false, false, false, false, false, false)
        AttachEntityToEntity(canEntity, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true
            ,
            true, false, false, 2, true)
        SetModelAsNoLongerNeeded(prop)

        -- Wait a bit and stop animation
        Wait(2000)

        ClearPedTasks(playerPed)
        ReleaseAmbientAudioBank()
        if DoesEntityExist(canEntity) then
            DetachEntity(canEntity, true, true)
            DeleteEntity(canEntity)
        end
    end


    isUsingPropStore = false
end

local function InteractWithPropStore(entity, model)
    if not exports.ava_core:canOpenMenu() then return end
    local propStore = Config.PropStores[model]
    isUsingPropStore = true

    local items = exports.ava_core:TriggerServerCallback("ava_stores:getStoreItems", 1, model)

    local elements = {}
    local count = 0
    for i = 1, #items do
        local item = items[i]
        count = count + 1
        elements[count] = {
            label = item.label,
            rightLabel = item.price > 0 and
                GetString("store_item_right_label", "", exports.ava_core:FormatNumber(item.price)),
            leftBadge = not item.noIcon and function()
                return { BadgeDictionary = "ava_items", BadgeTexture = item.name }
            end or nil,
            price = item.price,
            name = item.name,
            desc = item.desc,
        }
    end

    if count > 0 then
        RageUI.CloseAll()
        local hasValidatedPurchase = false

        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.OpenTempMenu(GetString("prop_store"), function(Items)
            for i = 1, #elements do
                local element = elements[i]
                Items:AddButton(element.label, element.desc,
                    { RightLabel = element.rightLabel, LeftBadge = element.leftBadge }, function(onSelected)
                    if onSelected then
                        if exports.ava_core:TriggerServerCallback("ava_stores:server:buyAtPropStore", model,
                            element.name) then
                            -- Get the prop matching the item if found, else default to prop_ld_can_01b
                            local prop = `prop_ld_can_01b`
                            if propStore.Items then
                                for i = 1, #propStore.Items do
                                    local item = propStore.Items[i]
                                    if item.name == element.name and item.prop then
                                        prop = item.prop
                                        break
                                    end
                                end
                            end

                            hasValidatedPurchase = true
                            RageUI.CloseAllInternal()
                            PlayAnimWithPropStore(entity, model, prop)
                        else
                            RageUI.CloseAllInternal()
                        end
                    end
                end)
            end
        end, function()
            if not hasValidatedPurchase then
                isUsingPropStore = false
            end
            FreezeEntityPosition(PlayerPedId(), false)
        end)

    else
        exports.ava_core:ShowNotification(GetString("nothing_can_buy"))
        isUsingPropStore = false
    end
end

AddEventHandler("ava_stores:client:interactPropStores", function(entity, data, model)
    if not IsDead and not isUsingPropStore then
        if Config.PropStores[model] then
            InteractWithPropStore(entity, model)
        end
    end
end)
