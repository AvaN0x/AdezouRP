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

    ---@class metadata
    ---@field licenses table
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
        end
        return
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
        return false
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
        return false
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
        return false
    end

    ----------------------------------------
    --------------- Licenses ---------------
    ----------------------------------------

    ---Check if a player has a license
    ---@param licenseName string
    ---@return boolean hasLicense
    ---@return table license
    ---@return number index
    self.HasLicense = function(licenseName)
        if type(licenseName) ~= "string" then
            return false
        end

        if type(self.metadata.licenses) == "table" then
            for i = 1, #self.metadata.licenses, 1 do
                if self.metadata.licenses[i].name == licenseName then
                    return true, self.metadata.licenses[i], i
                end
            end
        end
        return false
    end

    ---Add a license to a player if the license exist and if the player does not already have it
    ---@param licenseName string
    ---@return boolean success
    self.AddLicense = function(licenseName)
        local alreadyHasLicense = self.HasLicense(licenseName)

        if not alreadyHasLicense then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            if cfgLicense then
                if type(self.metadata.licenses) ~= "table" then
                    self.metadata.licenses = {}
                end
                self.metadata.licenses[#self.metadata.licenses + 1] = {name = licenseName, points = cfgLicense.hasPoints and cfgLicense.defaultPoints}
                return true
            end
        end
        return false
    end

    ---Remove a license from a player if the player has it
    ---@param licenseName string
    ---@return boolean success
    self.RemoveLicense = function(licenseName)
        local hasLicense, _, index = self.HasLicense(licenseName)

        if hasLicense then
            self.metadata.licenses[index] = nil
            return true
        end
        return false
    end

    ---Get the quantity of points a player have on a license
    ---@param licenseName string
    ---@return boolean hasLicense
    ---@return number points
    self.GetLicensePoints = function(licenseName)
        local hasLicense, license = self.HasLicense(licenseName)

        if hasLicense then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            if cfgLicense and cfgLicense.hasPoints then
                return hasLicense, license.points
            end
        end
        return false
    end

    ---Set quantity of points a player have on a license
    ---@param licenseName string
    ---@param quantity number needs to be less than license defaultPoints
    ---@return boolean success
    self.SetLicensePoints = function(licenseName, quantity)
        local hasLicense, license = self.HasLicense(licenseName)

        if hasLicense and tonumber(quantity) then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            quantity = math.floor(tonumber(quantity))
            if cfgLicense and cfgLicense.hasPoints and quantity >= 0 and quantity <= cfgLicense.defaultPoints then
                license.points = quantity
                return true, license.points
            end
        end
        return false
    end

    ---Remove a quantity of the points a player have on a license
    ---@param licenseName string
    ---@param quantity number if number is above the current quantity of points, the new quantity will be 0
    ---@return boolean success
    self.RemoveLicensePoints = function(licenseName, quantity)
        local hasLicense, license = self.HasLicense(licenseName)

        if hasLicense and tonumber(quantity) then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            quantity = math.floor(tonumber(quantity))
            if cfgLicense and cfgLicense.hasPoints and quantity >= 0 then
                license.points = license.points - quantity
                if license.points < 0 then
                    license.points = 0
                end
                return true, license.points
            end
        end
        return false
    end

    ---Add a quantity of points to a player license
    ---@param licenseName string
    ---@param quantity number if new quantity is above the license defaultPoints, the new quantity will be the license defaultPoints
    ---@return boolean success
    self.AddLicensePoints = function(licenseName, quantity)
        local hasLicense, license = self.HasLicense(licenseName)

        if hasLicense and tonumber(quantity) then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            quantity = math.floor(tonumber(quantity))
            if cfgLicense and cfgLicense.hasPoints and quantity >= 0 then
                license.points = license.points + quantity
                if license.points > cfgLicense.defaultPoints then
                    license.points = cfgLicense.defaultPoints
                end
                return true, license.points
            end
        end
        return false
    end

    ------------------------------------
    --------------- Jobs ---------------
    ------------------------------------

    return self
end
