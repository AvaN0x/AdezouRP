CurrentWeather = Config.StartWeather
local lastWeather = CurrentWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local timer = 0
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local iem = Config.IEM
local snow = Config.Snow

RegisterNetEvent("vSync:updateWeather")
AddEventHandler("vSync:updateWeather", function(NewWeather, newblackout, newIem, newSnow)
    CurrentWeather = NewWeather
    blackout = newblackout
    iem = newIem
    snow = newSnow
    SetAudioFlag("PlayerOnDLCHeist4Island", iem) -- disable all radios
    ForceSnowPass(snow)
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0)
            Citizen.Wait(15000)
        end
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
        SetArtificialLightsState(blackout)
        SetArtificialLightsStateAffectsVehicles(iem)

        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)
        if lastWeather == "XMAS" or snow then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

RegisterNetEvent("vSync:updateTime")
AddEventHandler("vSync:updateTime", function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

Citizen.CreateThread(function()
    local mathfloor = math.floor
    while true do
        Citizen.Wait(0)
        if GetGameTimer() - 500 > timer then
            local newBaseTime = baseTime + 0.25
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
            end
            baseTime = newBaseTime
            timer = GetGameTimer()
        end

        NetworkOverrideClockTime(--[[hours]] mathfloor(((baseTime + timeOffset) / 60) % 24),
            --[[minutes]] mathfloor((baseTime + timeOffset) % 60),
            --[[seconds]] mathfloor((((baseTime + timeOffset) % 1)) * 60))
    end
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("vSync:requestSync")
end)

Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/weather", _U("help_weathercommand"), { { name = _("help_weathertype"), help = _U("help_availableweather") } })
    TriggerEvent("chat:addSuggestion", "/time", _U("help_timecommand"), { { name = _("help_timehname"), help = _U("help_timeh") }, { name = _("help_timemname"), help = _U("help_timem") } })
    TriggerEvent("chat:addSuggestion", "/freezetime", _U("help_freezecommand"))
    TriggerEvent("chat:addSuggestion", "/freezeweather", _U("help_freezeweathercommand"))
    TriggerEvent("chat:addSuggestion", "/morning", _U("help_morningcommand"))
    TriggerEvent("chat:addSuggestion", "/noon", _U("help_nooncommand"))
    TriggerEvent("chat:addSuggestion", "/evening", _U("help_eveningcommand"))
    TriggerEvent("chat:addSuggestion", "/night", _U("help_nightcommand"))
    TriggerEvent("chat:addSuggestion", "/blackout", _U("help_blackoutcommand"))
    TriggerEvent("chat:addSuggestion", "/iem", _U("help_iemcommand"))
end)

-- Display a notification above the minimap.
function ShowNotification(text, blink)
    if blink == nil then
        blink = false
    end
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(blink, false)
end

RegisterNetEvent("vSync:notify")
AddEventHandler("vSync:notify", function(message, blink)
    ShowNotification(message, blink)
end)
