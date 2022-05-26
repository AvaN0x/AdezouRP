-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-- TODO set hours somewhere else, maybe get them from txadmin?
local rebootHours = { '01', '07', '13', '19' } -- minus 1

local function checkClockForRebootEvent()
    SetTimeout(1000, function()
        local currentTime <const> = os.date('%H:%M:%S', os.time())

        -- for _, hour in ipairs(rebootHours) do
        for i = 1, #rebootHours, 1 do
            local hour = rebootHours[i]

            -- If hour matches, check minutes and seconds
            if currentTime:find("^" .. hour) then
                if currentTime == hour .. ':40:00' then
                    ExecuteCommand('weather rain')
                    ExecuteCommand('freezeweather')
                elseif currentTime == hour .. ':48:00' then
                    ExecuteCommand('weather thunder')
                    -- GetClockHours() is client sided
                    ExecuteCommand('freezetime')
                elseif currentTime == hour .. ':57:00' then
                    ExecuteCommand('time 23 0')
                    ExecuteCommand('blackout')
                    ExecuteCommand('weather halloween')
                elseif currentTime == hour .. ':59:40' then
                    exports.ava_core:SaveEverything()
                end

                break
            end
        end

        -- Infinite timeout
        checkClockForRebootEvent()
    end)
end

checkClockForRebootEvent()
