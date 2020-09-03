RegisterServerEvent('putIn')
AddEventHandler('putIn', function(name,label,entering,inside,ipl,isSingle,isRoom,isGateway,roommenu,price)

local _source = source

MySQL.Async.execute('INSERT INTO properties (name,label,entering,`exit`,inside,outside,ipls,is_single,is_room,is_gateway,room_menu,price) VALUES (@name,@label,@entering,@exit,@inside,@outside,@ipl,@isSingle,@isRoom,@isGateway,@roommenu,@price)',
	{
		['@name'] = label..name,
		['@label'] = label,
		['@entering'] = entering,
		['@exit'] = inside,
		['@inside'] = inside,
		['@outside'] = entering,
		['@ipl'] = ipl,
		['@isSingle'] = isSingle,
		['@isRoom'] = isRoom,
		['@isGateway'] = isGateway,
		['@roommenu'] = roommenu,
		['@price'] = price

	}, function (rowsChanged)
		TriggerClientEvent('esx:showNotification', _source, 'Nom:'..name..'\nRue:'..label..'\nPrix:'..price)
	end)
end)