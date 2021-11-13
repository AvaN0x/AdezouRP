-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- Maximum is 10000 (for 100 percent and 2 digit, 100.00)
---@return aStatus
function CreateStatus(name, value)
    ---@class aStatus
    local self = {}

    self.name = name
    self.value = value or 0
    self.updateAddition = AVAConfig.Status[self.name].update

    self.update = function()
        local newValue = self.value + self.updateAddition
        if newValue < 0 then
            newValue = 0
        end
        self.value = newValue

        return self.value
    end

    self.getPercent = function()
        -- 10000 / 1000 can be max 100
        return self.value / 100
    end

    return self
end
