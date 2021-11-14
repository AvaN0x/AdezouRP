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

    self.getPercent = function()
        -- 10000 / 1000 can be max 100
        return self.value / 100
    end

    self.checkValue = function(max)
        if self.value > (max or 10000) then
            self.value = (max or 10000)
        elseif self.value < 0 then
            self.value = 0
        end
    end
    -- First call to checkValue(), to be sure that the value is correct at init
    self.checkValue(10500)

    self.set = function(value)
        self.value = value
        self.checkValue()

        return self.value
    end

    self.add = function(value)
        -- Real max is 10500 for 105% (Only with addition and when actual value is above 98%)
        -- can be used for eaten too much or drinked too much
        if self.value > 9800 then
            self.value = self.value + value
            self.checkValue(10500)
        else
            self.value = self.value + value
            self.checkValue()
        end

        return self.value
    end

    self.remove = function(value)
        self.value = self.value - value
        self.checkValue()

        return self.value
    end

    self.update = function()
        self.value = self.value + self.updateAddition
        if self.value < 0 then
            self.value = 0
        end

        return self.value
    end

    return self
end
