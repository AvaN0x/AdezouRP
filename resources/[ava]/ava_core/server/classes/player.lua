-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

function CreatePlayer(source)
	local self = {}

	self.source = source
    self.name = GetPlayerName(source)
    self.position = vector3(373.87, 325.87, 102.59) -- for tests

    return self
end