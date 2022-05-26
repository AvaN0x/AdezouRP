-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function CreateJobAccounts(name, accounts)
    ---@class aJobAccounts
    local self = {}

    self.name = name
    self.accounts = accounts or {}
    self.modified = false

    self.save = function()
        return AVA.SaveJobAccounts(self)
    end

    ---Get all accounts
    ---@return table
    self.getAccounts = function()
        return self.accounts
    end

    local function updatePlayersAccountsData(accountName, accountBalance)
        local ace = "job." .. self.name .. ".manage"
        for _, playerSrc in ipairs(GetPlayers()) do
            if IsPlayerAceAllowed(playerSrc, ace) then
                TriggerClientEvent("ava_core:client:updateAccountData", playerSrc, self.name, accountName, accountBalance)
            end
        end
    end

    ---Get the account for a specified account, if the job does not have the account, it will create it en return it
    ---@param accountName string
    ---@return integer
    self.getAccount = function(accountName)
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

    ---Get the balance of a job account
    ---@param accountName string
    ---@return number balance
    self.getAccountBalance = function(accountName)
        local account = self.getAccount(accountName)
        if account then
            return account.balance
        end
        return 0
    end

    ---Set the balance of a job account
    ---@param accountName string
    ---@param balance number
    ---@return boolean accountExist
    self.setAccountBalance = function(accountName, balance)
        if type(balance) ~= "number" or balance <= 0 then
            return
        end
        local account = self.getAccount(accountName)
        if account then
            account.balance = math.floor(balance)
            updatePlayersAccountsData(account.name, account.balance)
            self.modified = true
            return true
        end
        return false
    end

    ---Add money to the balance of a job account
    ---@param accountName string
    ---@param balance number
    ---@return boolean accountExist
    self.addAccountBalance = function(accountName, balance)
        if type(balance) ~= "number" or balance <= 0 then
            return
        end
        local account = self.getAccount(accountName)
        if account then
            account.balance = account.balance + math.floor(balance)
            updatePlayersAccountsData(account.name, account.balance)
            self.modified = true
            return true
        end
        return false
    end

    ---Remove money from the balance of a job account
    ---@param accountName string
    ---@param balance number
    ---@return boolean accountExist
    self.removeAccountBalance = function(accountName, balance)
        if type(balance) ~= "number" or balance <= 0 then
            return
        end
        local account = self.getAccount(accountName)
        if account then
            account.balance = account.balance - math.floor(balance)
            updatePlayersAccountsData(account.name, account.balance)
            self.modified = true
            return true
        end
        return false
    end

    return self
end
