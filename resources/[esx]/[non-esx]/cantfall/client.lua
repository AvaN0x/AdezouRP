ESX                  = nil
oldX, oldY, oldZ = 0, 0, 0
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    Citizen.Wait(500)
    local health = GetEntityHealth(PlayerPedId())
    if health > 0 then
        SetEntityInvincible(GetPlayerPed(-1),true)
        Citizen.Wait(30000)
        SetEntityInvincible(GetPlayerPed(-1),false)
    end
end)

--[[
Citizen.CreateThread(function()
    Citizen.Wait(10000)
	local entity = PlayerPedId()
	while true do
    	Citizen.Wait(1000)
    	x, y, z = table.unpack(GetEntityCoords(entity, true))
    	local retval, groundZ = GetGroundZFor_3dCoord(x, y, z, 0)
    	if groundZ == 0 then
            if oldX ~= 0 and oldY ~= 0 and oldZ ~= 0 then
                SetEntityInvincible(GetPlayerPed(-1),true)
    		    SetEntityCoords(GetPlayerPed(-1), oldX, oldY, oldZ)
                SetEntityInvincible(GetPlayerPed(-1),false)
            end
    	else
            oldX, oldY, oldZ = x, y, z
    	end
  end
end)
]]--