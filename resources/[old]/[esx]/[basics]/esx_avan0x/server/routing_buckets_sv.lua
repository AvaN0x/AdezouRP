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


RegisterServerEvent("esx_avan0x:addRB")
AddEventHandler("esx_avan0x:addRB", function(name)
    local _source = source
    if name ~= nil then
        if namedRoutingBuckets[name] == nil then
            rbCount = rbCount + 1
            namedRoutingBuckets[name] = rbCount
        end
        SetPlayerRoutingBucket(_source, namedRoutingBuckets[name])
        print(_source .. " is moved in " .. namedRoutingBuckets[name] .. " named '" .. name .. "'")
        print(ESX.DumpTable(namedRoutingBuckets))
    else
        rbCount = rbCount + 1
        SetPlayerRoutingBucket(_source, rbCount)
        print(_source .. " is moved in " .. rbCount)
    end
end)

RegisterServerEvent("esx_avan0x:leaveRB")
AddEventHandler("esx_avan0x:leaveRB", function()
    local _source = source
	SetPlayerRoutingBucket(_source, 0)
    print(_source .. " is moved in 0")
end)