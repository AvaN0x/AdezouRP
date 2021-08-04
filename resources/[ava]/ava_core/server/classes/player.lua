-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

function CreatePlayer(source, license, discord, group, name, discordTag, citizenId, playerData)
	local self = {}

	self.source = source
	self.identifiers = {
        license = license,
        discord = discord
    }
	self.group = group
    self.name = name
    self.discordTag = discordTag

    self.citizenId = citizenId

    self.position = playerData.position and json.decode(playerData.position) or AVAConfig.DefaultPlayerData.position
    self.character = playerData.character and json.decode(playerData.character) or nil
    self.skin = playerData.skin and json.decode(playerData.skin) or nil
    self.loadout = playerData.loadout and json.decode(playerData.loadout) or nil
    self.accounts = playerData.accounts and json.decode(playerData.accounts) or nil
    self.status = playerData.status and json.decode(playerData.status) or nil
    self.jobs = playerData.jobs and json.decode(playerData.jobs) or nil
    self.inventory = playerData.inventory and json.decode(playerData.inventory) or nil
    self.metadata = playerData.metadata and json.decode(playerData.metadata) or nil


    self.Logout = function()
        AVA.Players.Logout(self.source)
    end
    self.Save = function()
        AVA.Players.Save(self.source)
    end
    
    return self
end