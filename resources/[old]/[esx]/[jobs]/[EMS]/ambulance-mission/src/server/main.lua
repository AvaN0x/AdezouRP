ESX = nil

Wrapper.TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Wrapper.RegisterNetEvent('blargleambulance:finishLevel')
Wrapper.AddEventHandler('blargleambulance:finishLevel', function(levelFinished)
    local totalFromAI = Config.Formulas.moneyPerLevel(levelFinished)
    local total = nil
    TriggerEvent('esx_statejob:getTaxed', 'society_ems', totalFromAI, function(toSociety)
        total = toSociety
    end)

    local playerMoney  = math.floor(total / 100 * 60)
    local societyMoney = math.floor(total / 100 * 40)
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ems', function(account)
        societyAccount = account
    end)

    ESX.GetPlayerFromId(source).addMoney(playerMoney)
    if societyAccount ~= nil then
        societyAccount.addMoney(societyMoney)
    end

    TriggerClientEvent('esx:showNotification', source, _U('add_money', societyMoney, playerMoney))
end)