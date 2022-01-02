-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterUsableItem("radio", function(src)
    print(src, "use radio")
    TriggerClientEvent("Radio.Set", src, true)
    TriggerClientEvent("Radio.Toggle", src)
end)
