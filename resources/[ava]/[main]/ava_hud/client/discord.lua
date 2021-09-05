-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Citizen.CreateThread(function()
    -- set discord app id
    SetDiscordAppId(746634986093805619)

    -- set the large image
    SetDiscordRichPresenceAsset("logo1024")
    SetDiscordRichPresenceAssetText(GetString("rich_presence_asset_text"))

    -- set the small image
    -- SetDiscordRichPresenceAssetSmall('logo1024')
    -- SetDiscordRichPresenceAssetSmallText('This is a small icon with text')

    SetDiscordRichPresenceAction(0, GetString("rich_presence_button_one"), GetString("rich_presence_button_one_link"))
    SetDiscordRichPresenceAction(1, GetString("rich_presence_button_two"), GetString("rich_presence_button_two_link"))

    SetRichPresence(GetString("rich_presence_player_count", -1))

    TriggerServerEvent("ava_hud:server:requestPlayerCount")
end)

RegisterNetEvent("ava_hud:client:playerCount", function(count)
    SetRichPresence(GetString("rich_presence_player_count", count))
end)
