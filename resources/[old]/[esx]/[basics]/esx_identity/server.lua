--=========================================
--==== ESX_IDENTITY BY ARKSEYONET @Ark ====
--========== MODIFIED BY AvaN0x ===========
--========== github.com/AvaN0x ============
--=========================================

--===============================================
--==     Get The Player's Identification       ==
--===============================================
function getIdentity(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if result[1]['firstname'] ~= nil then
      local data = {
        identifier  = result[1]['identifier'],
        firstname  = result[1]['firstname'],
        lastname  = result[1]['lastname'],
        dateofbirth  = result[1]['dateofbirth'],
        sex      = result[1]['sex'],
        height    = result[1]['height']
      }

      callback(data)
    else
      local data = {
        identifier   = '',
        firstname   = '',
        lastname   = '',
        dateofbirth = '',
        sex     = '',
        height     = ''
      }

      callback(data)
    end
  end)
end

TriggerEvent("es:addGroupCommand", "register", "admin", function(source, args, user)
	if args[1] then
		local playerId = tonumber(args[1])

		-- is the argument a number?
		if playerId then
			-- is the number a valid player?
			if GetPlayerName(playerId) then
        TriggerClientEvent('esx_identity:showRegisterIdentity', playerId, {})
			else
				TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "Joueur non connecté." } })
			end
		else
			TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "ID Incorrect." } })
		end
	else
    TriggerClientEvent('esx_identity:showRegisterIdentity', source, {})
	end
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "Insufficient Permissions." } })
end, {help = "Allow the user to make a new registration", params = {{name = "playerId", help = "(optional) player id"}}})




--===============================================
--==    Set The Player's Identification        ==
--===============================================
function setIdentity(identifier, data, callback)
  MySQL.Async.execute("UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier",
    {
      ['@identifier']   = identifier,
      ['@firstname']    = data.firstname,
      ['@lastname']     = data.lastname,
      ['@dateofbirth']  = data.dateofbirth,
      ['@sex']        = data.sex,
      ['@height']       = data.height
    },
  function(done)
    if callback then
      callback(true)
    end
  end)
end

--===============================================
--==  Update The Player's Identification       ==
--===============================================
function updateIdentity(identifier, data, callback)
  MySQL.Async.execute("UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier",
    {
      ['@identifier']   = identifier,
      ['@firstname']    = data.firstname,
      ['@lastname']     = data.lastname,
      ['@dateofbirth']  = data.dateofbirth,
      ['@sex']        = data.sex,
      ['@height']       = data.height
    },
  function(done)
    if callback then
      callback(true)
    end
  end)
end

--===============================================
--==       Server Event Set Identity           ==
--===============================================
RegisterServerEvent('esx_identity:setIdentity')
AddEventHandler('esx_identity:setIdentity', function(data)
  local identifier = GetPlayerIdentifiers(source)[1]
    setIdentity(GetPlayerIdentifiers(source)[1], data, function(callback)
    if callback == true then
      print('Successfully Set Identity For ' .. identifier)
    else
      print('Failed To Set Identity.')
    end
  end)
end)

--===============================================
--==       Player Loaded Event Handler         ==
--===============================================
AddEventHandler('es:playerLoaded', function(source)
  getIdentity(source, function(data)
    if data.firstname == '' then
      TriggerClientEvent('esx_identity:showRegisterIdentity', source)
    else
      print('Successfully Loaded Identity For ' .. data.firstname .. ' ' .. data.lastname)
    end
  end)
end)

