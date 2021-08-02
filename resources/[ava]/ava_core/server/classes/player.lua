-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

function CreatePlayer(source, license, discord, group, discordTag)
	local self = {}

	self.source = source
	self.identifiers = {
        license = license,
        discord = discord
    }
	self.group = group
    self.name = GetPlayerName(source)
    self.discordTag = discordTag
    self.position = vector3(373.87, 325.87, 102.59) -- for tests

    if self.group then
        ExecuteCommand("add_principal identifier." .. self.identifiers.license .. " group." .. self.group)
        dprint("Add principal ^3group." .. self.group .. "^7 to ^3" .. self.identifiers.license .. "^7 (^3" .. self.discordTag .. "^7)")
    end
    
    return self
end