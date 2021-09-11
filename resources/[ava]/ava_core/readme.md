# ava_core resource

⚠ **The file `lua_intellisense.lua` is completely useless for this script, I only use it for lua intellisense with exports**

## Permissions

All permissions are made thanks to the FiveM ace/principals system and roles of player on a said discord. For it to work you will need a canvar (`avan0x_bot_token`) with your bot token

Example :

```lua
set avan0x_bot_token "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```

## Discord Whitelist

This whitelist need to be enabled through a convar (`ava_core_discord_whitelist`) in your `server.cfg`
> It will need the bot token to work

Example :

```lua
set ava_core_discord_whitelist 'yes'
```

## Discord config

The config with player needed roles for permissions and whitelist are situated in the `fxmanifest.lua` of `ava_core` (`ava_core/fxmanifest.lua`)

Example :

```lua
my_data 'discord_config' {
    -- id of you discord server/guild
    GuildId = "743525702157992018",
    -- the roles that will mark a player as whitelisted (one of them is needed, not all of them)
    Whitelist = {
        "743525702531547228" -- citizen
    },
    -- the ace group of a player that will be given if this player have a certain role
    Ace = {
        { ace = "superadmin", role = "743525702531547234" }, -- superadmin
        { ace = "admin", role = "835276464865542195" }, -- admin
        { ace = "mod", role = "743525702531547231" } -- mod
    }
}
```

## Jobs

The default job is `unemployed`, this job is removed when the player get added a new job.
**Do not remove or rename this job !**