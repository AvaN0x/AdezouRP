-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

if IsDuplicityVersion() then
    -- Server side

    -- Cancel non command messages
    if GetConvar("ava_core_disable_chat", "false") ~= "false" then
        Citizen.CreateThread(function()
            while GetResourceState("chat") ~= "started" do Wait(50) end

            exports.chat:registerMessageHook(function(source, message, cbs)
                local src = source
                cbs.cancel()
            end)
        end)
    end

else
    -- Client side

end
