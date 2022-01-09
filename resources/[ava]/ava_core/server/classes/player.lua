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
    self.phoneNumber = playerData.phone_number or nil

    ---@class metadata
    ---@field licenses table
    self.metadata = playerData.metadata and json.decode(playerData.metadata) or {}

    self.lastSaveTime = nil

    self.set = function(key, value)
        self[key] = value
    end

    self.login = function()
        return AVA.Players.Login(self.src)
    end

    self.logout = function(...)
        return AVA.Players.Logout(self.src, ...)
    end

    self.save = function()
        return AVA.Players.Save(self.src)
    end

    ---Get player discord tag if possible, else it will return the name
    ---@return string
    self.getDiscordTag = function()
        return self.discordTag or self.name
    end

    ---Get player character name if possible, else it will return the name
    ---@return string
    self.getCharacterName = function()
        return (self.character and self.character.firstname and self.character.lastname) and ("%s %s"):format(self.character.firstname, self.character.lastname)
                   or self.name
    end

    -----------------------------------------
    --------------- Inventory ---------------
    -----------------------------------------

    ---Get player inventory
    ---@return inventory
    self.getInventory = function()
        return self.inventory
    end

    self.useItem = function(itemName)
        AVA.Players.UseItem(self.src, itemName)
    end

    ----------------------------------------
    --------------- Accounts ---------------
    ----------------------------------------

    ---Get all player accounts
    ---@return table
    self.getAccounts = function()
        return self.accounts or {}
    end

    ---Get the account for a specified player account, if the player does not have the account, it will create it en return it
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

    ---Get the balance of a player account
    ---@param accountName string
    ---@return number balance
    self.getAccountBalance = function(accountName)
        local account = self.getAccount(accountName)
        if account then
            return account.balance
        end
        return 0
    end

    ---Set the balance of a player account
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
            return true
        end
        return false
    end

    ---Add money to the balance of a player account
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
            return true
        end
        return false
    end

    ---Remove money from the balance of a player account
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
            return true
        end
        return false
    end

    ----------------------------------------
    --------------- Licenses ---------------
    ----------------------------------------

    ---Get all player licenses
    ---@return table
    self.getLicenses = function()
        return self.metadata and self.metadata.licenses or {}
    end

    ---Check if a player has a license
    ---@param licenseName string
    ---@return boolean hasLicense
    ---@return table license
    ---@return number index
    self.hasLicense = function(licenseName)
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
    self.addLicense = function(licenseName)
        local alreadyHasLicense = self.hasLicense(licenseName)

        if not alreadyHasLicense then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            if cfgLicense then
                if type(self.metadata.licenses) ~= "table" then
                    self.metadata.licenses = {}
                end
                self.metadata.licenses[#self.metadata.licenses + 1] = {
                    name = licenseName,
                    points = cfgLicense.hasPoints and (cfgLicense.defaultPoints or cfgLicense.maxPoints),
                }
                return true
            end
        end
        return false
    end

    ---Remove a license from a player if the player has it
    ---@param licenseName string
    ---@return boolean success
    self.removeLicense = function(licenseName)
        local hasLicense, _, index = self.hasLicense(licenseName)

        if hasLicense then
            table.remove(self.metadata.licenses, index)
            return true
        end
        return false
    end

    ---Get the quantity of points a player have on a license
    ---@param licenseName string
    ---@return boolean hasLicense
    ---@return number points
    self.getLicensePoints = function(licenseName)
        local hasLicense, license = self.hasLicense(licenseName)

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
    ---@param quantity number needs to be less than license maxPoints
    ---@return boolean success
    self.setLicensePoints = function(licenseName, quantity)
        local hasLicense, license = self.hasLicense(licenseName)

        if hasLicense and tonumber(quantity) then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            quantity = math.floor(tonumber(quantity))
            if cfgLicense and cfgLicense.hasPoints and quantity >= 0 and quantity <= cfgLicense.maxPoints then
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
    self.removeLicensePoints = function(licenseName, quantity)
        local hasLicense, license = self.hasLicense(licenseName)

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
    ---@param quantity number if new quantity is above the license maxPoints, the new quantity will be the license maxPoints
    ---@return boolean success
    self.addLicensePoints = function(licenseName, quantity)
        local hasLicense, license = self.hasLicense(licenseName)

        if hasLicense and tonumber(quantity) then
            local cfgLicense = AVAConfig.Licenses[licenseName]
            quantity = math.floor(tonumber(quantity))
            if cfgLicense and cfgLicense.hasPoints and quantity >= 0 then
                license.points = license.points + quantity
                if license.points > cfgLicense.maxPoints then
                    license.points = cfgLicense.maxPoints
                end
                return true, license.points
            end
        end
        return false
    end

    ------------------------------------
    --------------- Jobs ---------------
    ------------------------------------

    ---Get all player jobs
    ---@return table
    self.getJobs = function()
        return self.jobs
    end

    ---Get all player jobs with all under grades that the player is ace allowed
    ---@return table
    self.getJobsClientData = function()
        local data = {}
        local count = 0
        for i = 1, #self.jobs, 1 do
            local job<const> = self.jobs[i]
            local cfgJob<const> = AVAConfig.Jobs[job.name]
            if cfgJob then
                local jobData = {
                    name = job.name,
                    grade = job.grade,
                    label = cfgJob.label,
                    isGang = job.isGang,
                    underGrades = {},
                    gradeLabel = nil,
                    canManage = nil,
                }
                local countUnderGrades = 0
                for j = 1, #cfgJob.grades do
                    local grade<const> = cfgJob.grades[j]
                    if grade.name == job.grade then
                        jobData.gradeLabel = grade.label
                        if grade.manage then
                            jobData.canManage = true
                        end
                        break
                    else
                        countUnderGrades = countUnderGrades + 1
                        jobData.underGrades[countUnderGrades] = grade.name
                    end
                end
                count = count + 1
                data[count] = jobData
            end
        end

        return data
    end

    ---Trigger client event with updated jobs data
    ---and save data on database
    local function savePlayerJobs()
        TriggerClientEvent("ava_core:client:playerUpdatedData", self.src, {jobs = self.getJobsClientData()})
        AVA.Players.SavePlayerJobs(self.src)
    end

    ---Check if a player has a job
    ---@param jobName string
    ---@return boolean hasJob
    ---@return table job
    ---@return number index
    self.hasJob = function(jobName)
        if type(jobName) ~= "string" then
            return false
        end

        if type(self.jobs) == "table" then
            for i = 1, #self.jobs, 1 do
                if self.jobs[i].name == jobName then
                    return true, self.jobs[i], i
                end
            end
        end
        return false
    end

    ---Can the player be added another job
    ---@return boolean canAdd
    ---@return number "count of jobs that can be added"
    self.canAddAnotherJob = function()
        -- local playerJobCount = #self.jobs
        -- if self.hasJob("unemployed") then
        --     playerJobCount = playerJobCount - 1
        -- end

        local playerJobCount = 0

        for i = 1, #self.jobs, 1 do
            -- job unemployed do not have to be accounted
            if not self.jobs[i].isGang and self.jobs[i].name ~= "unemployed" then
                playerJobCount = playerJobCount + 1
            end
        end

        local canAdd<const> = playerJobCount < AVAConfig.MaxJobsCount
        if canAdd then
            return canAdd, playerJobCount - AVAConfig.MaxJobsCount
        end
        return false
    end

    ---Can the player be added another gang
    ---@return boolean canAdd
    ---@return number "count of gangs that can be added"
    self.canAddAnotherGang = function()
        local playerGangCount = 0

        for i = 1, #self.jobs, 1 do
            if self.jobs[i].isGang then
                playerGangCount = playerGangCount + 1
            end
        end

        local canAdd<const> = playerGangCount < AVAConfig.MaxGangsCount
        if canAdd then
            return canAdd, playerGangCount - AVAConfig.MaxGangsCount
        end
        return false
    end

    ---Add a job to a player if the job exist, if the player already have this job, it will update it's grade
    ---@param jobName string
    ---@param gradeName? string "if not specified it will take the first available grade"
    ---@return boolean success
    ---@return string grade "final grade added"
    self.addJob = function(jobName, gradeName)
        local cfgJob = AVAConfig.Jobs[jobName]
        if cfgJob then
            local alreadyHasJob, job = self.hasJob(jobName)
            if not gradeName then
                gradeName = cfgJob.grades[1].name
            end

            if alreadyHasJob then
                if job.grade ~= gradeName and AVA.GradeExistForJob(jobName, gradeName) then
                    AVA.RemovePrincipal("player." .. self.src, "job." .. jobName .. ".grade." .. job.grade)
                    AVA.AddPrincipal("player." .. self.src, "job." .. jobName .. ".grade." .. gradeName)
                    job.grade = gradeName

                    savePlayerJobs()
                    return true, gradeName
                end
            else
                if AVA.GradeExistForJob(jobName, gradeName) then
                    -- we remove unemployed job as it is supposed to stay only if the player has no jobs
                    if jobName ~= "unemployed" then
                        local isUnemployed, unemployedJob, unemployedIndex = self.hasJob("unemployed")

                        if isUnemployed then
                            AVA.RemovePrincipal("player." .. self.src, "job.unemployed.grade." .. unemployedJob.grade)
                            table.remove(self.jobs, unemployedIndex)

                            TriggerClientEvent("ava_core:client:jobRemoved", self.src, "unemployed")
                        end
                    end

                    AVA.AddPrincipal("player." .. self.src, "job." .. jobName .. ".grade." .. gradeName)
                    self.jobs[#self.jobs + 1] = {name = jobName, grade = gradeName, isGang = cfgJob.isGang}

                    savePlayerJobs()
                    return true, gradeName
                end
            end
        end
        return false
    end

    ---Remove a job from a player if the player has it
    ---@param jobName string
    ---@return boolean success
    self.removeJob = function(jobName)
        local hasJob, job, index = self.hasJob(jobName)

        if hasJob then
            AVA.RemovePrincipal("player." .. self.src, "job." .. jobName .. ".grade." .. job.grade)
            table.remove(self.jobs, index)
            TriggerClientEvent("ava_core:client:jobRemoved", self.src, jobName)

            savePlayerJobs()
            return true
        end
        return false
    end

    ---------------------------------------
    --------------- WEAPONS ---------------
    ---------------------------------------

    ---Get all player weapons
    ---@return table
    self.getWeapons = function()
        return self.loadout
    end

    ---Check if a player has a weapon
    ---@param weapon string|number
    ---@return boolean hasWeapon
    ---@return table weapon data
    ---@return number index
    self.hasWeapon = function(weapon)
        if type(weapon) ~= "string" and type(weapon) ~= "number" then
            return false
        end
        local weaponHash = type(weapon) == "number" and weapon or tonumber(GetHashKey(weapon))
        for i = 1, #self.loadout do
            if self.loadout[i] and self.loadout[i].hash == weaponHash then
                return true, self.loadout[i], i
            end
        end
        return false
    end

    self.addWeapon = function(weaponName)
        if type(weaponName) ~= "string" then
            return false
        end

        local cfgWeapon<const> = AVAConfig.Weapons[weaponName]
        -- if we can remove one item, then the player has the weapon
        if cfgWeapon and self.getInventory().canRemoveItem(weaponName, 1) then
            local playerPed = GetPlayerPed(self.src)
            if playerPed then
                local weaponHash = GetHashKey(weaponName)
                local hasWeapon, weapon, weaponIndex = self.hasWeapon(weaponName)
                if hasWeapon then
                    GiveWeaponToPed(playerPed, weaponHash, 0, false, false)

                    if weapon.components then
                        -- TODO weapon components
                    end

                    TriggerClientEvent("ava_core:client:weaponAdded", self.src, weaponHash)
                else
                    GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
                    self.loadout[#self.loadout + 1] = {hash = tonumber(weaponHash)}

                    TriggerClientEvent("ava_core:client:weaponAdded", self.src, weaponHash)
                end

                return true
            end
        end
        return false
    end

    self.removeWeapon = function(weaponName, newItemQuantity)
        if type(weaponName) ~= "string" then
            return false
        end

        local cfgWeapon<const> = AVAConfig.Weapons[weaponName]
        if cfgWeapon then
            local playerPed = GetPlayerPed(self.src)
            if playerPed then
                local weaponHash = GetHashKey(weaponName)
                local hasWeapon, weapon, weaponIndex = self.hasWeapon(weaponHash)
                if cfgWeapon.type == "throwable" then
                    TriggerClientEvent("ava_core:client:updateAmmoTypeCount", self.src, cfgWeapon.ammoType and GetHashKey(cfgWeapon.ammoType) or weaponHash,
                        newItemQuantity)
                    if newItemQuantity == 0 then
                        RemoveWeaponFromPed(playerPed, weaponHash)
                        if hasWeapon then
                            self.loadout[weaponIndex] = nil -- remove weapon from loadout ?
                        end
                    end
                    return true
                end

                RemoveWeaponFromPed(playerPed, weaponHash)
                if hasWeapon then
                    -- TODO give components back as items ?
                    self.loadout[weaponIndex] = nil -- remove weapon from loadout ?
                    return true
                end
            end
        end
        return false
    end

    return self
end
