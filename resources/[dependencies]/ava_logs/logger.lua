-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

log = function(text)
    local fileName = string.format("logs/%s.log", os.date("%Y-%m-%d"))
    local data = string.format("[%s] [%-20s] %s\r\n",
        os.date("%X"),
        (GetInvokingResource() or GetCurrentResourceName()):sub(0, 20),
        type(text) == "table" and table.concat(text, " ") or text)

    local content = LoadResourceFile(GetCurrentResourceName(), fileName) or ""
    SaveResourceFile(GetCurrentResourceName(), fileName, content .. data, -1)
end
exports("log", log)
AddEventHandler("ava_logs:server:log", log)
