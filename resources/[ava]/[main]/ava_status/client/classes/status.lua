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

    self.set = function(value)
        if type(value) == "number" and value > 0 then
            self.value = value
        end

        return self.value
    end

    self.add = function(value)
        if type(value) == "number" and value > 0 then
            self.value = self.value + value
        end

        return self.value
    end

    self.remove = function(value)
        if type(value) == "number" and value > 0 then
            self.value = self.value - value
            if self.value < 0 then
                self.value = 0
            end
        end

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
