-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA = {}

exports("GetSharedObject", function()
    return AVA
end)

-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

local resourceName<const> = GetCurrentResourceName()
for i = 1, GetNumResourceMetadata(resourceName, "ava_config"), 1 do
    local dataName = GetResourceMetadata(resourceName, "ava_config", i - 1)
    if dataName == "discord_config" then
        AVAConfig.Discord = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1))

    elseif dataName == "debug_prints" then
        AVAConfig.Debug = true

    elseif dataName == "npwd" then
        AVAConfig.NPWD = true

    elseif dataName == "max_characters" then
        local value = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1)) or 0
        if value ~= "null" and tonumber(value) > 0 then
            AVAConfig.MaxChars = tonumber(value)
        else
            print("^3[WARN] max_characters was not valid, value must be a number > 0^0")
        end

    elseif dataName == "max_jobs_count" then
        local value = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1)) or 0
        if value ~= "null" and tonumber(value) > 0 then
            AVAConfig.MaxJobsCount = tonumber(value)
        else
            print("^3[WARN] max_jobs_count was not valid, value must be a number > 0^0")
        end

    elseif dataName == "max_gangs_count" then
        local value = json.decode(GetResourceMetadata(resourceName, "ava_config_extra", i - 1)) or 0
        if value ~= "null" and tonumber(value) > 0 then
            AVAConfig.MaxGangsCount = tonumber(value)
        else
            print("^3[WARN] max_gangs_count was not valid, value must be a number > 0^0")
        end
    end
end

---Print only if AVAConfig.Debug is true
function dprint(...)
    if AVAConfig.Debug then
        print("^3[DEBUG] ^0", ...)
    end
end

dprint([[
Console colors : 
    ^0^ 0 : AvaN0x's Core
    ^1^ 1 : AvaN0x's Core
    ^2^ 2 : AvaN0x's Core
    ^3^ 3 : AvaN0x's Core
    ^4^ 4 : AvaN0x's Core
    ^5^ 5 : AvaN0x's Core
    ^6^ 6 : AvaN0x's Core
    ^7^ 7 : AvaN0x's Core
    ^8^ 8 : AvaN0x's Core
    ^9^ 9 : AvaN0x's Core^0]])

-- Set weapons as items
for weaponName, weapon in pairs(AVAConfig.Weapons) do
    if AVAConfig.Items[weaponName] then
        print("^3[WARN] Weapon named `" .. weaponName .. "` already exists in AVAConfig.Items^0")
    end

    AVAConfig.Items[weaponName] = weapon
end

-----------------------------------------------
--------------- Init principals ---------------
-----------------------------------------------

---Add an ace
---@param principal string
---@param object string
AVA.AddAce = function(principal, object)
    if type(principal) == "string" and type(object) == "string" then
        dprint(("add_ace ^4%s^0 ^5%s^0 allow"):format(principal, object))
        ExecuteCommand(("add_ace %s %s allow"):format(principal, object))
    end
end
AddEventHandler("ava_core:server:add_ace", AVA.AddAce)

---Add a principal and an ace that only this principal have (if specified)
---@param principal string
---@param object string
---@param with_ace boolean "will create an ace with it, under the form of `ace.${principal}"
AVA.AddPrincipal = function(principal, object, with_ace)
    if type(principal) == "string" and type(object) == "string" then
        dprint(("add_principal ^4%s^0 ^5%s^0"):format(principal, object))
        ExecuteCommand(("add_principal %s %s"):format(principal, object))
        if with_ace then
            AVA.AddAce(principal, "ace." .. principal)
        end
    end
end
AddEventHandler("ava_core:server:add_principal", AVA.AddPrincipal)

---Remove a principal
---@param principal string
---@param object string
AVA.RemovePrincipal = function(principal, object)
    if type(principal) == "string" and type(object) == "string" then
        dprint(("remove_principal ^4%s^0 ^5%s^0"):format(principal, object))
        ExecuteCommand(("remove_principal %s %s"):format(principal, object))
    end
end
AddEventHandler("ava_core:server:remove_principal", AVA.RemovePrincipal)

-- if using "snail" instead of "builtin.everyone", then players can do commands and console can't
AVA.AddPrincipal("group.mod", "builtin.everyone", true)

AVA.AddPrincipal("group.admin", "group.mod", true)
AVA.AddAce("group.admin", "command.stop")
AVA.AddAce("group.admin", "command.start")
AVA.AddAce("group.admin", "command.restart")
AVA.AddAce("group.admin", "command.ensure")

AVA.AddPrincipal("group.superadmin", "group.admin", true)
AVA.AddAce("group.superadmin", "command")

-----------------------------------------
--------------- Auto save ---------------
-----------------------------------------

AVA.SaveAll = function()
    AVA.Players.SaveAll()
    AVA.SaveAllJobsAccounts()
    TriggerEvent("ava_core:server:saveAll")
end

if AVAConfig.SaveTimeout then
    local function timeoutSaveAll()
        AVA.SaveAll()
        SetTimeout(AVAConfig.SaveTimeout * 60 * 1000, timeoutSaveAll)
    end
    SetTimeout(AVAConfig.SaveTimeout * 60 * 1000, timeoutSaveAll)
end
-------------------------------------
--------------- Items ---------------
-------------------------------------
AVA.UsableItems = {}

---Register an usable item
---@param itemName any
---@param callback fun(itemName: string, callback: function)
AVA.RegisterUsableItem = function(itemName, callback)
    if type(itemName) == "string" and AVAConfig.Items[itemName]
        and (type(callback) == "function" or (type(callback) == "table" and callback["__cfx_functionReference"] ~= nil)) then
        AVA.UsableItems[itemName] = callback
        AVAConfig.Items[itemName].usable = true

        dprint("Usable item added: ^3" .. itemName .. "^0")
    end
end
exports("RegisterUsableItem", AVA.RegisterUsableItem)

---Get all items data
---@return table
AVA.GetItemsData = function()
    return AVAConfig.Items or {}
end
exports("GetItemsData", AVA.GetItemsData)

---Get all items data
---@param name string
---@return table
AVA.GetItemData = function(name)
    return AVAConfig.Items and AVAConfig.Items[name]
end
exports("GetItemData", AVA.GetItemData)
