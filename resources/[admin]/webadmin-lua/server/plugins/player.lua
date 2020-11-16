local PAGE_NAME = "player"
local PAGE_TITLE = "Player Detail"
local PAGE_ICON = "user"

MAXVEHICLES = 5

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
nbCars = 0

function CreatePage(FAQ, data, add)
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
    add(usercard)
    return true, "ok"
end

Citizen.CreateThread(function()
    local FAQ = exports['webadmin-lua']:getFactory()
    exports['webadmin']:registerPluginPage(PAGE_NAME, function(data) --[[E]]--
        if not exports['webadmin']:isInRole("webadmin."..PAGE_NAME..".view") then return "" end
        return FAQ.Nodes({ --[[R]]--
            FAQ.PageTitle(PAGE_TITLE),
            FAQ.BuildPage(CreatePage, data), --[[R]]--
        })
    end)
end)
