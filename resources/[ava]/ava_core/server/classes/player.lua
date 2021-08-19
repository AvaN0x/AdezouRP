-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function CreatePlayer(src, license, discord, group, name, discordTag, citizenId, playerData)
    ---@class aPlayer
    local self = {}

    self.src = src
    self.identifiers = {license = license, discord = discord}
    self.group = group
    self.name = name
    self.discordTag = discordTag

    self.citizenId = citizenId

    self.position = playerData.position and json.decode(playerData.position) or AVAConfig.DefaultPlayerData.position
    ---@class character
    ---@field firstname string
    ---@field lastname string
    ---@field sex number
    ---@field birthdate string
    self.character = playerData.character and json.decode(playerData.character) or {}
    ---@type skin
    self.skin = playerData.skin and json.decode(playerData.skin) or {}
    self.loadout = playerData.loadout and json.decode(playerData.loadout) or {}
    ---@class accounts
    ---@field bank number
    self.accounts = playerData.accounts and json.decode(playerData.accounts) or {}
    self.status = playerData.status and json.decode(playerData.status) or {}
    self.jobs = playerData.jobs and json.decode(playerData.jobs) or {}
    ---@class inventory
    self.inventory = CreateInventory(self.src, playerData.inventory and json.decode(playerData.inventory) or {}, AVAConfig.InventoryMaxWeight)
    self.metadata = playerData.metadata and json.decode(playerData.metadata) or {}

    self.Logout = function()
        return AVA.Players.Logout(self.src)
    end
    self.Save = function()
        return AVA.Players.Save(self.src)
    end

    ---Get player discord tag if possible, else it will return the name
    ---@return string
    self.GetDiscordTag = function()
        return self.discordTag or self.name
    end

    -----------------------------------------
    --------------- Inventory ---------------
    -----------------------------------------
    ---Get player inventory
    ---@return inventory
    self.GetInventory = function()
        return self.inventory
    end

    self.UseItem = function(itemName)
        AVA.Players.UseItem(self.src, itemName)
    end

    ----------------------------------------
    --------------- Accounts ---------------
    ----------------------------------------

    ---Get the account for a specified player account, if the player does not have the account, it will create it en return it
    ---@param accountName string
    ---@return integer
    self.GetAccountMoney = function(accountName)
        if type(accountName) ~= "string" then
            return
        end

        for i = 1, #self.accounts, 1 do
            if self.accounts[i].name == accountName then
                return self.accounts[i]
            end
        end

        if AVAConfig.Accounts[accountName] then
            account = {name = accountName, balance = 0}

            self.accounts[#self.accounts + 1] = account
            return account
        else
            return nil
        end
    end

    ---Set the balance of a player account
    ---@param accountName string
    ---@param balance number
    ---@return boolean accountExist
    self.SetAccountMoney = function(accountName, balance)
        if type(balance) ~= "number" or balance <= 0 then
            return
        end
        local account = self.GetAccountMoney(accountName)
        if account then
            account.balance = math.floor(balance)
            return true
        end
    end

    ---Add money to the balance of a player account
    ---@param accountName string
    ---@param balance number
    ---@return boolean accountExist
    self.AddAccountMoney = function(accountName, balance)
        if type(balance) ~= "number" or balance <= 0 then
            return
        end
        local account = self.GetAccountMoney(accountName)
        if account then
            account.balance = account.balance + math.floor(balance)
            return true
        end
    end

    ---Remove money from the balance of a player account
    ---@param accountName string
    ---@param balance number
    ---@return boolean accountExist
    self.RemoveAccountMoney = function(accountName, balance)
        if type(balance) ~= "number" or balance <= 0 then
            return
        end
        local account = self.GetAccountMoney(accountName)
        if account then
            account.balance = account.balance - math.floor(balance)
            return true
        end
    end

    ------------------------------------
    --------------- Jobs ---------------
    ------------------------------------

    return self
end
