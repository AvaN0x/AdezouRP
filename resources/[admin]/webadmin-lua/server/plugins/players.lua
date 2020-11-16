-- Page details
local PAGE_NAME = "players"
local PAGE_TITLE = "Players"
local PAGE_ICON = "users"

-- Sidebar badge controls
local SHOW_PAGE_BADGE = true
local PAGE_BADGE_TYPE = "primary"

MAXPLAYER = 10

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
nbPlayer = 0

function CommonActions(FAQ)
    return FAQ.Nodes(
        {
            FAQ.Button("secondary", FAQ.TextIcon("first-aid") .. "Heal", {}),
            FAQ.Button("danger", FAQ.TextIcon("user-times") .. "Kick", {}),
            FAQ.Button("danger",  FAQ.TextIcon("user-slash") .."Ban", {})
        }, " ")
end

function CreateCard(FAQ, data)
    local xPlayer = ESX.GetPlayerFromId(data.user)
    local usercard = FAQ.UserCard(
        GetPlayerName(data.user),
        FAQ.TextIcon("id-card") .. "NULL", {
        {
            FAQ.TextIcon("user-tag") .. " Identifier",
            xPlayer and xPlayer.identifier or GetPlayerIdentifiers(data.user)[1]
        },
        {
            FAQ.TextIcon("car") .. " Cars",
            FAQ.Nodes({
                FAQ.Table(
                    {"#", "Plate", "Location", "Actions"},
                    {
                        {plate = "53YKU341", location = "garage_pillbox"},
                        {plate = "71XEC277", location = "garage_pillbox"}
                    },
                    function(row, n)
                        return {n, row.plate, row.location, FAQ.Nodes({
                            FAQ.Button("secondary", FAQ.TextIcon("truck-pickup") .. "Out of pound", {})
                        }, " ")}
                    end,
                    "table-sm",
                    "light"
                )
            }, "")
        },
        {
            "Actions",
            CommonActions(FAQ)
        }
    })
    return usercard
end

function CreatePage(FAQ, data, add)
    -- print(ESX.DumpTable(data))
    if(data.user ~= nil) then
        add(CreateCard(FAQ, data))
    end

    if not data.page then data.page = 1 else data.page = tonumber(data.page) end
    local players = {}
    local count = 0
    for _, playerId in ipairs(GetPlayers()) do
        count = count + 1
        if tonumber(playerId) > (data.page - 1) * MAXPLAYER and tonumber(playerId) <= data.page * MAXPLAYER then
            local xPlayer = ESX.GetPlayerFromId(playerId)
            table.insert(players,
            {
                i = playerId,
                id = xPlayer and xPlayer.identifier or GetPlayerIdentifiers(playerId)[1],
                sname = GetPlayerName(playerId),
                rpname = identity and (identity.firstname .. " " .. identity.lastname) or "NULL",
                ping = GetPlayerPing(playerId),
                group = xPlayer and xPlayer.getGroup() or "connect"
            })
        end
    end
    nbPlayer = count
    table.sort(players, function(a, b) return a.i < b.i end)

    local table = FAQ.Table(
        {"#", "Identifier", "Steam Name", "RP Name", "Actions", "Ping", ""},
        players,
        function (row)
            local sname = row.sname
            if row.group ~= "user" and (row.group == "superadmin" or row.group == "admin") then
                sname = FAQ.Nodes({row.sname, " ", FAQ.Badge("primary", {FAQ.TextIcon("star"), "Admin"})})
            elseif row.group ~= "user" and row.group == "mod" then
                sname = FAQ.Nodes({row.sname, " ", FAQ.Badge("warning", {FAQ.TextIcon("star"), "Mod"})})
            elseif row.group == "connect" then
                sname = FAQ.Nodes({row.sname, " ", FAQ.Badge("danger", {"Connecting"})})
            end
            return {row.i, row.id, sname, row.rpname, CommonActions(FAQ), row.ping, FAQ.Node("a", {href=FAQ.GenerateDataUrl("player", {user=row.i})}, FAQ.Button("primary", "Details", {}))}
        end
    )
    add(table)

    add(FAQ.GeneratePaginator(PAGE_NAME, data.page, nbPlayer // MAXPLAYER))

    return true, "ok"
end

Citizen.CreateThread(function()
    local PAGE_ACTIVE = false
    local FAQ = exports['webadmin-lua']:getFactory()
    exports['webadmin']:registerPluginOutlet("nav/sideList", function(data)
        if not exports['webadmin']:isInRole("webadmin."..PAGE_NAME..".view") then return "" end
        local _PAGE_ACTIVE = PAGE_ACTIVE PAGE_ACTIVE = false
        return FAQ.SidebarOption(PAGE_NAME, PAGE_ICON, PAGE_TITLE, SHOW_PAGE_BADGE and nbPlayer .. "/64" or false, PAGE_BADGE_TYPE, _PAGE_ACTIVE)
    end)
    exports['webadmin']:registerPluginPage(PAGE_NAME, function(data)
        if not exports['webadmin']:isInRole("webadmin."..PAGE_NAME..".view") then return "" end
        PAGE_ACTIVE = true
        return FAQ.Nodes({
            FAQ.PageTitle(PAGE_TITLE),
            FAQ.BuildPage(CreatePage, data),
        })
    end)
end)
