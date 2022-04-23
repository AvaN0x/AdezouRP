-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
CoreJobs = exports.ava_core:GetJobsData()
CoreItems = exports.ava_core:GetItemsData()

-- #region services
local jobsServices = {}

RegisterNetEvent("ava_jobs:server:setService", function(jobName, state)
    local src = source
    if not jobsServices[jobName] then
        jobsServices[jobName] = {}
    end
    jobsServices[jobName][tostring(src)] = state and true or nil
    print(src, jobName, state, jobsServices[jobName][tostring(src)])
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    for jobName, v in pairs(jobsServices) do
        if v[source] ~= nil then
            jobsServices[jobName][tostring(src)] = nil
        end
    end
end)

---Get count of players in service
---@param jobName string
---@return number count
function getCountInService(jobName)
    local count = 0
    local debugString = ""
    if CoreJobs[jobName] and jobsServices[jobName] then
        local ace = "ace.job." .. jobName .. ".main"
        for _, playerSrc in ipairs(GetPlayers()) do
            if IsPlayerAceAllowed(playerSrc, ace) and jobsServices[jobName][tostring(playerSrc)] ~= nil then
                count = count + 1
                debugString = debugString .. tostring(playerSrc) .. " "
            end
        end
    end
    exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_dev", "asked for count of " .. jobName,
        "ID des joueurs : " .. debugString .. "\ncount value : `" .. count .. "`", 0xF2A53F)
    return count
end

exports("getCountInService", getCountInService)

---Check if a player is in service
---@param source any
---@param job string
---@return boolean
function isInService(source, jobName)
    return (CoreJobs[jobName] and jobsServices[jobName]) and jobsServices[jobName][tostring(source)] == true or false
end

exports("isInService", isInService)
-- #endregion

----------------
-- Job Center --
----------------
-- #region job center
RegisterNetEvent("ava_jobs:server:job_center:unsubscribe", function()
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)

    local playerJobs = aPlayer.getJobs()
    for i = 1, #playerJobs do
        if playerJobs[i].name == "unemployed" or playerJobs[i].grade == "tempworker" then
            aPlayer.removeJob(playerJobs[i].name)
        end
    end
    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_center_successfully_unsubscribed"))
end)

RegisterNetEvent("ava_jobs:server:job_center:subscribe", function(index)
    local src = source
    if index == nil then
        return
    end
    local job = Config.JobCenter.JobList[index]
    if not job then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("error_happened"))
        return
    end
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer.hasJob(job.JobName) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_center_already_has_job"))
        return
    end

    local playerJobs = aPlayer.getJobs()
    -- we stop here if the player already has a job that is not a tempworker job
    if job.JobName == "unemployed" then
        -- normal is not tempworker
        local normalJobCount = 0
        for i = 1, #playerJobs do
            if playerJobs[i].grade ~= "tempworker" then
                normalJobCount = normalJobCount + 1
            end
        end
        if normalJobCount > 0 then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_center_cannot_subscribe_to_unmployement_has_job"))
            return
        end
    end

    for i = 1, #playerJobs do
        if playerJobs[i].grade == "tempworker" then
            aPlayer.removeJob(playerJobs[i].name)
        end
    end

    if not aPlayer.canAddAnotherJob() then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_center_job_limit"))
        return
    end

    local jobAdded = aPlayer.addJob(job.JobName)
    if not jobAdded then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_center_could_not_add_job"))
        return
    end

    if job.JobName == "unemployed" then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_center_subscribed_to_unemployment"))
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_center_engaged"))
    end
end)
-- #endregion

-------------
-- Harvest --
-------------
-- #region Harvest
exports.ava_core:RegisterServerCallback("ava_jobs:canPickUp", function(source, jobName, zoneName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local result = false
    local job = Config.Jobs[jobName]
    local zone = job.FieldZones[zoneName]
    if zone then
        local inventory = aPlayer.getInventory()
        for k, item in ipairs(zone.Items) do
            if inventory.canTake(item.name) > 0 then
                result = true
                break
            end
        end
    end
    return result
end)

RegisterNetEvent("ava_jobs:server:pickUp", function(jobName, zoneName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local job = Config.Jobs[jobName]
    local zone = job.FieldZones[zoneName]
    if zone then
        local inventory = aPlayer.getInventory()
        for k, item in ipairs(zone.Items) do
            local canTake = inventory.canTake(item.name)
            if canTake > 0 then
                inventory.addItem(item.name, (canTake > item.quantity and item.quantity or canTake))
            end
        end
    end
end)
-- #endregion

---------------
-- TREATMENT --
---------------
-- #region TREATMENT
local playersProcessing = {}

local function canCarryAll(source, items)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local inventory = aPlayer.getInventory()
    for i = 1, #items, 1 do
        print(inventory.canAddItem(items[i].name, items[i].quantity), items[i].name, items[i].quantity)
        if not inventory.canAddItem(items[i].name, items[i].quantity) then
            TriggerClientEvent("ava_core:client:ShowNotification", source, GetString("process_cant_carry"))
            return false
        end
    end
    return true
end

local function hasEnoughItems(source, items)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local inventory = aPlayer.getInventory()
    local result = {}
    for i = 1, #items, 1 do
        local item = items[i]
        local invItem = inventory.getItem(item.name)
        if invItem.quantity < item.quantity then
            local cfgItem = CoreItems[item.name]
            table.insert(result, (item.quantity - invItem.quantity) .. " " .. (cfgItem and cfgItem.label or item.name))
        end
    end
    if result[1] then
        TriggerClientEvent("ava_core:client:ShowNotification", source, GetString("process_not_enough", table.concat(result, "~s~, ~g~")))
        return false
    else
        return true
    end
end

local function hasKey(source, keyName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local inventory = aPlayer.getInventory()
    local hasOne = inventory.canRemoveItem(keyName, 1)
    if not hasOne then
        TriggerClientEvent("ava_core:client:ShowNotification", source, GetString("dont_have_keychain"))
    end
    return hasOne
end

exports.ava_core:RegisterServerCallback("ava_jobs:canprocess", function(source, process, jobName)
    if not playersProcessing[source] then
        local job = Config.Jobs[jobName]
        if job and (job.isIllegal ~= true or not process.NeedKey or hasKey(source, job.KeyName)) and hasEnoughItems(source, process.ItemsGive)
            and canCarryAll(source, process.ItemsGet) then
            return true
        end
    else
        print(("%s attempted to exploit processing!"):format(GetPlayerIdentifiers(source)[1]))
    end
    return false
end)

RegisterNetEvent("ava_jobs:server:process", function(process)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()
    playersProcessing[src] = true
    Wait(process.Delay)
    for i = 1, #process.ItemsGive, 1 do
        inventory.removeItem(process.ItemsGive[i].name, process.ItemsGive[i].quantity)
    end
    for i = 1, #process.ItemsGet, 1 do
        inventory.addItem(process.ItemsGet[i].name, process.ItemsGet[i].quantity)
    end
    playersProcessing[src] = nil
end)

function CancelProcessing(playerID)
    if playersProcessing[playerID] then
        playersProcessing[playerID] = nil
    end
end

RegisterNetEvent("ava_jobs:server:cancelProcessing", function()
    CancelProcessing(source)
end)

AddEventHandler("playerDropped", function()
    CancelProcessing(source)
end)

RegisterNetEvent("ava_core:server:playerDeath", function()
    CancelProcessing(source)
end)
-- #endregion

-------------
-- selling --
-------------
-- #region selling
RegisterNetEvent("ava_jobs:server:sellItems", function(jobName, zoneName, item, count)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return end

    local inventory = aPlayer.getInventory()
    local job = Config.Jobs[jobName]
    local zone = job.SellZones[zoneName]
    if not zone then return end

    local hasJob, aJob = aPlayer.hasJob(jobName)
    if not hasJob then return end

    if inventory.canRemoveItem(item, count) then
        local price = nil
        for k, v in ipairs(zone.Items) do
            if v.name == item then
                price = v.price
                break
            end
        end
        if price == nil then
            return
        end
        local total = exports.ava_jobs:applyTaxes(tonumber(count) * tonumber(price), jobName)

        local playerMoney, societyMoney

        -- if he is a tempworker, he must earn less than the society
        if aJob.grade == "tempworker" then
            playerMoney = math.floor(total * 0.2)
            societyMoney = math.floor(total * 0.4)

            -- The rest of the money goes towards the government
            local govAccounts = exports.ava_core:GetJobAccounts("government")
            if govAccounts then
                govAccounts.addAccountBalance("bank", total - (playerMoney + societyMoney))
            end
        else
            playerMoney = math.floor(total * 0.6)
            societyMoney = math.floor(total * 0.4)
        end

        inventory.removeItem(item, count)
        local accounts = exports.ava_core:GetJobAccounts(jobName)
        if accounts then
            accounts.addAccountBalance("bank", societyMoney)
        end
        inventory.addItem("cash", playerMoney)
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("have_earned", exports.ava_core:FormatNumber(playerMoney)))
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("comp_earned", exports.ava_core:FormatNumber(societyMoney)))
    end
end)

exports.ava_core:RegisterServerCallback("ava_jobs:getSellElements", function(source, jobName, zoneName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local inventory = aPlayer.getInventory()
    local job = Config.Jobs[jobName]
    local zone = job.SellZones[zoneName]
    if zone then
        local elements = {}
        for k, item in pairs(zone.Items) do
            local invItem = inventory.getItem(item.name)
            local cfgItem = CoreItems[item.name]
            if cfgItem then
                table.insert(elements, {
                    itemLabel = cfgItem.label,
                    label = GetString("sell_label", cfgItem.label, invItem.quantity),
                    desc = item.desc,
                    price = item.price,
                    name = item.name,
                    owned = invItem.quantity,
                })
            end
        end
        return elements
    end
    return nil
end)
-- #endregion

------------
-- buying --
------------
-- #region buying
RegisterNetEvent("ava_jobs:server:buyItem", function(jobName, zoneName, item, count)
    local src = source
    local job = Config.Jobs[jobName]
    local zone = job and job.BuyZones[zoneName]

    if zone and zone.Items then
        local aPlayer = exports.ava_core:GetPlayer(src)
        local inventory = aPlayer.getInventory()

        if not inventory.canAddItem(item, count) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("buy_cant_carry"))
        else
            local price = nil
            local isDirtyMoney = nil
            for k, v in ipairs(zone.Items) do
                if v.name == item then
                    price = v.price
                    isDirtyMoney = v.isDirtyMoney
                    break
                end
            end
            if price == nil then
                return
            end
            local totalprice = tonumber(count) * tonumber(price)

            if isDirtyMoney then
                if inventory.canRemoveItem("dirtycash", totalprice) then
                    inventory.removeItem("dirtycash", totalprice)
                    inventory.addItem(item, count)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("buy_cant_afford_dirty"))
                end
            else
                exports.ava_jobs:applyTaxes(totalPrice, jobName)
                if inventory.canRemoveItem("cash", totalprice) then
                    inventory.removeItem("cash", totalprice)
                    inventory.addItem(item, count)
                else
                    TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("buy_cant_afford"))
                end

            end
        end
    else
        print(("%s attempted to exploit buying!"):format(GetPlayerIdentifiers(src)[1]))
    end
end)

exports.ava_core:RegisterServerCallback("ava_jobs:GetBuyElements", function(source, jobName, zoneName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local inventory = aPlayer.getInventory()
    local job = Config.Jobs[jobName]
    local zone = job.BuyZones[zoneName]
    if zone then
        local items = {}
        local count = 0
        for k, v in pairs(zone.Items) do
            local cfgItem = CoreItems[v.name]
            if cfgItem then
                count = count + 1
                items[count] = {
                    label = cfgItem.label,
                    desc = cfgItem.description,
                    noIcon = cfgItem.noIcon,
                    price = v.price,
                    name = v.name,
                    maxCanTake = inventory.canTake(v.name),
                    isDirtyMoney = v.isDirtyMoney,
                }
            end
        end
        return items
    end
end)
-- #endregion

-------------------
-- JOBS SPECIFIC --
-------------------

exports.ava_core:RegisterServerCallback("ava_jobs:server:getVehicleInfos", function(source, vehicleNet, plate)
    local src = source
    local res = { plate = plate }

    if vehicleNet then
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
        if DoesEntityExist(vehicle) then
            local entityState = Entity(vehicle)

            if entityState.state.rentalVehicle then
                res.owner = GetString("vehicle_owner_rental")
            elseif entityState.state.drivingTestVehicle then
                res.owner = GetString("vehicle_owner_drivingschool")
            end
        end
    end

    if not res.owner then
        res.owner = exports.ava_garages:GetVehicleOwnerLabel(plate)
        if res.owner == "" then
            res.owner = GetString("vehicle_owner_unknown")
        end
    end

    return res
end)



----------------
-- JOBS ITEMS --
----------------

-- #region WINEMAKER
RegisterNetEvent("ava_jobs:UseBox")
AddEventHandler("ava_jobs:UseBox", function(source, itembox, item)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local inventory = aPlayer.getInventory()
    if not inventory.canAddItem(item, 6) or not inventory.canAddItem("woodenbox", 1) then
        TriggerClientEvent("ava_core:client:ShowNotification", source, GetString("buy_cant_carry"))
    else
        inventory.removeItem(itembox, 1)
        inventory.addItem(item, 6)
        inventory.addItem("woodenbox", 1)
    end
end)
exports.ava_core:RegisterUsableItem("winebox", function(source)
    TriggerEvent("ava_jobs:UseBox", source, "winebox", "wine")
end)
exports.ava_core:RegisterUsableItem("grapejuicebox", function(source)
    TriggerEvent("ava_jobs:UseBox", source, "grapejuicebox", "grapejuice")
end)
exports.ava_core:RegisterUsableItem("champagnebox", function(source)
    TriggerEvent("ava_jobs:UseBox", source, "champagnebox", "champagne")
end)
exports.ava_core:RegisterUsableItem("luxurywinebox", function(source)
    TriggerEvent("ava_jobs:UseBox", source, "luxurywinebox", "luxurywine")
end)
-- #endregion
