-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Government = {
    TaxePercentage = 0.2
}

---Apply taxes to an amount and return the amount without the taxes
---@param amount number the amount to tax
---@param source string|nil source (optional)
---@return number the amount without the taxes
local applyTaxes = function(amount, source)
    if type(amount) ~= "number" then
        print("^1[ERROR] ^0Amount is not a number! (" .. type(amount) .. ")")
        return amount
    end

    local govAccounts = exports.ava_core:GetJobAccounts("government")
    if not govAccounts then
        print("^1[ERROR] ^0Couldn't find the government account!")
        return amount
    end

    local tax = math.ceil(amount * Config.Government.TaxePercentage)
    govAccounts.addAccountBalance("bank", tax)

    if source then
        local jobLabel = exports.ava_core:GetJobLabel(source)
        if jobLabel ~= "" then
            TriggerEvent("ava_logs:server:log", { "job:government", "taxes", "amount:" .. tax, "job:" .. source })
        else
            TriggerEvent("ava_logs:server:log", { "job:government", "taxes", "amount:" .. tax, "source:" .. source })
        end
    else
        TriggerEvent("ava_logs:server:log", { "job:government", "taxes", "amount:" .. tax })
    end

    return amount - tax
end
exports("applyTaxes", applyTaxes)
