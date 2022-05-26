-- TODO REDO


RegisterNetEvent('ava_dealer:serverSold', function(itemName, price, count)
    if not Config.DrugPrices[itemName] then return end

    -- TODO REDO, PRICE IS REALLY NOT SECURE
    local src = source

    --! Really bad security
    if price < 0 or price > 3000 then return end

    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()

    if inventory.canRemoveItem(itemName, count) then
        inventory.removeItem(itemName, count)
        inventory.addItem('dirtycash', count * price)
    end
end)

exports.ava_core:RegisterServerCallback('ava_dealer:serverGetDrugCount', function(source)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()

    local drugs = {}
    for k, itemName in pairs(Config.DrugItems) do
        drugs[itemName] = inventory.getItemQuantity(itemName) or 0
    end

    return drugs
end)


exports.ava_core:RegisterServerCallback('ava_dealer:serveraskCanStart', function(source, cb)
    -- local cops = exports.ava_jobs:getCountInService("lspd")
    -- return cops > 0
    return true
end)

RegisterNetEvent('ava_dealer:servercallCops', function()
    local src = source
    local srcCoords = GetEntityCoords(GetPlayerPed(src))

    exports.ava_jobs:sendMessageToJob("lspd", {
        message = "Une personne suspecte a été aperçue proche de cette position.",
        location = vector3(srcCoords.x + math.random(-20, 20), srcCoords.y + math.random(-20, 20), srcCoords.z + math.random(-5, 5)),
    })
end)
