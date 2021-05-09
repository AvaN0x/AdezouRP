-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local rbCount = 0
local namedRoutingBuckets = {}

TriggerEvent('es:addGroupCommand', 'rb', 'mod', function(source, args, user)
	if args[1] ~= nil then
		SetPlayerRoutingBucket(source, tonumber(args[1]))
        print(source .. " is in " .. tonumber(args[1]))
    else
        SetPlayerRoutingBucket(source, 0)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)


TriggerEvent('es:addGroupCommand', 'addrb', 'mod', function(source, args, user)
    if args[1] ~= nil then
        if namedRoutingBuckets[args[1]] == nil then
            rbCount = rbCount + 1
            namedRoutingBuckets[args[1]] = rbCount
        end
        SetPlayerRoutingBucket(source, namedRoutingBuckets[args[1]])
        print(source .. " is moved in " .. namedRoutingBuckets[args[1]] .. " named '" .. args[1] .. "'")
        print(ESX.DumpTable(namedRoutingBuckets))
    else
        rbCount = rbCount + 1
        SetPlayerRoutingBucket(source, rbCount)
        print(source .. " is moved in " .. rbCount)
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)

TriggerEvent('es:addGroupCommand', 'leaverb', 'mod', function(source, args, user)
	SetPlayerRoutingBucket(source, 0)
    print(source .. " is moved in " .. 0)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)