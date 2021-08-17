-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function CreatePlayer(src, license, discord, group, name, discordTag, citizenId, playerData)
    local self = {}

    self.src = src
    self.identifiers = {license = license, discord = discord}
    self.group = group
    self.name = name
    self.discordTag = discordTag

    self.citizenId = citizenId

    self.position = playerData.position and json.decode(playerData.position) or AVAConfig.DefaultPlayerData.position
    self.character = playerData.character and json.decode(playerData.character) or {}
    self.skin = playerData.skin and json.decode(playerData.skin) or {}
    self.loadout = playerData.loadout and json.decode(playerData.loadout) or {}
    self.accounts = playerData.accounts and json.decode(playerData.accounts) or {}
    self.status = playerData.status and json.decode(playerData.status) or {}
    self.jobs = playerData.jobs and json.decode(playerData.jobs) or {}
    self.inventory = CreateInventory(self.src, playerData.inventory and json.decode(playerData.inventory) or {},
        AVAConfig.InventoryMaxWeight)
    self.metadata = playerData.metadata and json.decode(playerData.metadata) or {}

    self.Logout = function()
        AVA.Players.Logout(self.src)
    end
    self.Save = function()
        AVA.Players.Save(self.src)
    end

    -----------------------------------------
    --------------- Inventory ---------------
    -----------------------------------------

    self.GetInventory = function()
        return self.inventory
    end

    return self
end
