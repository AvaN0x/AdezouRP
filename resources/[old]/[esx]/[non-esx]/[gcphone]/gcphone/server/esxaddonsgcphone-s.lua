
ESX                       = nil
local PhoneNumbers        = {}

-- PhoneNumbers = {
--   ambulance = {
--     type  = "ambulance",
--     sources = {
--        ['1'] = true
--     }
--   }
-- }

TriggerEvent('esx:getSharedObject', function(obj)
  ESX = obj
end)

function notifyAlertSMS (number, alert, listSrc)
  if PhoneNumbers[number] ~= nil then
    local messText = alert.message
    if (messText == '%posrealtime%') then
      messText = 'GPS Live Position'
    end
    local mess = 'From #' .. alert.numero  .. ' : ' .. messText
    if alert.coords ~= nil then
      mess = mess .. ' ' .. alert.coords.x .. ', ' .. alert.coords.y 
    end
    for k, _ in pairs(listSrc) do
      local targetPlayer = tonumber(k)
      getPhoneNumber(targetPlayer, function (n)
        if n ~= nil then
          TriggerEvent('gcPhone:_internalAddMessage', number, n, mess, 0, function (smsMess)
            TriggerClientEvent('gcPhone:receiveMessage', targetPlayer, smsMess)
            if alert.source then
              TriggerClientEvent('gcPhone:receiveLivePosition', targetPlayer, alert.source, Config.ShareRealtimeGPSDefaultTimeInMs, alert.numero, (messText == '%posrealtime%' and 1 or 2), alert.coords or nil)
            end
          end)
        end
      end)
    end
  end
end

AddEventHandler('esx_phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
  print('= INFO = Registered number for ' .. number .. ' => ' .. type)
	local hideNumber    = hideNumber    or false
	local hidePosIfAnon = hidePosIfAnon or false

	PhoneNumbers[number] = {
		type          = type,
    sources       = {},
    alerts        = {}
	}
end)



AddEventHandler('esx:setJob', function(source, job, lastJob)
  if PhoneNumbers[lastJob.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:removeSource', lastJob.name, source)
  end

  if PhoneNumbers[job.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:addSource', job.name, source)
  end
end)

AddEventHandler('esx:setJob2', function(source, job2, lastJob2)
  if PhoneNumbers[lastJob2.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:removeSource', lastJob2.name, source)
  end

  if PhoneNumbers[job2.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:addSource', job2.name, source)
  end
end)

AddEventHandler('esx_addons_gcphone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('esx_addons_gcphone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(number, message)
    local sourcePlayer = tonumber(source)
    if PhoneNumbers[number] ~= nil then
      getPhoneNumber(source, function (phone) 
        notifyAlertSMS(number, {
          message = message,
          numero = phone,
          source = sourcePlayer
        }, PhoneNumbers[number].sources)
      end)
    end
end)

RegisterServerEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function (number, message, coords)
  local sourcePlayer = tonumber(source)
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
        source = sourcePlayer
      }, PhoneNumbers[number].sources)
    end)
  else
    print('= WARNING = Trying to call an unregistered service => numero : ' .. number)
  end
end)


AddEventHandler('esx:playerLoaded', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)

  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)

    local phoneNumber = result[1].phone_number
    xPlayer.set('phoneNumber', phoneNumber)

    if PhoneNumbers[xPlayer.job.name] ~= nil then
      TriggerEvent('esx_addons_gcphone:addSource', xPlayer.job.name, source)
    end
    if PhoneNumbers[xPlayer.job2.name] ~= nil then
      TriggerEvent('esx_addons_gcphone:addSource', xPlayer.job2.name, source)
    end

  end)

end)


AddEventHandler('esx:playerDropped', function(source)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  if PhoneNumbers[xPlayer.job.name] ~= nil then
    TriggerEvent('esx_addons_gcphone:removeSource', xPlayer.job.name, source)
  end
end)


function getPhoneNumber (source, callback) 
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer == nil then
    callback(nil)
  end
  MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier',{
    ['@identifier'] = xPlayer.identifier
  }, function(result)
    callback(result[1].phone_number)
  end)
end



RegisterServerEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(number, message, _, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
        source = source,
      }, PhoneNumbers[number].sources)
    end)
  else
    print('esx_phone:send | Appels sur un service non enregistre => numero : ' .. number)
  end
end)

RegisterServerEvent('esx_phone:sendEmergency')
AddEventHandler('esx_phone:sendEmergency', function(number, message, _, coords)
  if PhoneNumbers[number] ~= nil then
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = 911,
        source = source,
      }, PhoneNumbers[number].sources)
  else
    print('esx_phone:send | Appels sur un service non enregistre => numero : ' .. number)
  end
end)