# DpEmotes 🏋️

Emotes / Animations for FiveM with human, animal and prop support 🐩

# Available in:

* Brazilian Portuguese 🇧🇷

* Czech 🇨🇿

* Danish 🇩🇰

* Dutch 🇳🇱

* English 🇬🇧

* Finnish 🇫🇮

* French 🇫🇷

* German 🇩🇪

* Italian 🇮🇹

* Polish 🇵🇱

* Spanish 🇪🇸

* Swedish 🇸🇪

All languages were either translated using Google Translate or contributed by you, the community. 

If you happen to find any incorrect translations or would like to add more languages, please feel free to provide an "issue" with the correct / additional translations.

Languages can be selected and/or added in config.lua.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Ragdoll 🥴

* To enable ragdoll, change `RagdollEnabled = false,` to true in config.lua.

* To change which key is responsible for ragdoll, `RagdollKeybind = 303` is currently set to `U` by default., -- Get the button number [here](https://docs.fivem.net/game-references/controls/)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Menu Keybind 🎛️

**Important Note:**

The keybind uses RegisterKeyMapping. By default, the server owner configured keybind in the *initial* config.lua will be the default key, however once the keybind is set for a user, it'll stay with this new value. Editing the config keybind will change it for new players only.

* Menu key:* F5

F3 and F4 clash with [Menyoo](https://github.com/MAFINS/MenyooSP) and controllers 🎮

Server owners can change this in the `config.lua`;

```lua
MenuKeybind = 'F5', -- Get the button string here https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
```

Alternatively, the player base can set their own menu keybind to open DpEmotes

```lua
Esc > settings > keybinds > fivem > dpemotes
```

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Keybinds and SQL 🎛️

The original dpemotes uses mysql-async which was then changed to ghmattimysql. Unfortunately, they are no longer maintained. 

To use the SQL features, install the [oxmysql](https://github.com/overextended/oxmysql) resource. If you do not want to use the SQL features, comment out the `oxmysql` region in fxmanifest.lua.


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Screenshots 📸



| | | |
|-|-|-|
| <img src="screenshots/menu.jpg" width="250"> | <img src="screenshots/umbrella.jpg" width="250"> | <img src="screenshots/flag1.jpg" width="250"> |
| <img src="screenshots/flag2.jpg" width="250"> | <img src="screenshots/flag3.jpg" width="250"> | <img src="screenshots/flag4.jpg" width="250"> |
| <img src="screenshots/flag5.jpg" width="250"> | <img src="screenshots/flag6.jpg" width="250"> | <img src="screenshots/flag7.jpg" width="250"> |
| <img src="screenshots/flag8.jpg" width="250"> | <img src="screenshots/flag9.jpg" width="250"> | <img src="screenshots/carry1.jpg" width="250">|
| <img src="screenshots/carry2.jpg" width="250"> | <img src="screenshots/carrybig.jpg" width="250"> | <img src="screenshots/carrysmall.jpg" width="250"> |
| <img src="screenshots/hostage.jpg" width="250">| <img src="screenshots/pigback.jpg" width="250">| <img src="screenshots/cb_before.jpg" width="250"> | 
| <img src="screenshots/cp_after.jpg" width="250"> 



-----------------------------------------------------------------------------------------------------------------------------------------------------


# Installation Instructions ⚙️:

* add DpEmotes to your `server.cfg`

* [Enforce gamebuild to latest build](https://forum.cfx.re/t/tutorial-forcing-gamebuild-to-casino-cayo-perico-or-tuners-update/4784977) for all emotes and props to work correctly

* start dpemotes


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Shared emotes 👩🏻‍❤️‍💋‍👨🏼

Emotes will work with either `SyncOffset` or `Attachto`.

- If it is with `SyncOffsetFront` or `SyncOffsetSide`, then the offset used is the one of the emote the player started.<br/>
For example, if player one starts the emote `handshake` which has `SyncOffsetFront`, then player one will have the `SyncOffsetFront` but not the other player.


- If it is with `Attachto`, then it'll either be player one's data used for attaching, or the player two's data.<br/>
For example, if player one start the emote carry, then the other player will be attached but not the player one because Attachto is set in `carry2` and not `carry`.<br/>
- If player one starts the emote `carry2`, then player one will be attached and not the other player.
it's the player who start the animation who will in most cases be moved


*Special case, if both emote have the `Attachto` then only the player who started the emote will be attached.*

You can find a list of ped bones to attach the other player here: [Ped Bones](https://wiki.rage.mp/index.php?title=Bones)

Using the website provided above, enter the bone ID, ie `1356` and not 111, which is the Bone Index.




-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


# Add-Ons 🛠️

* Fixed an issue with the clipboard and adds textures to paper (/e clipboard)

* Changes umbrella texture to black (/e umbrella)

# Optional Add-Ons 🛠️

* Adds textures to the mugshot prop (/e mugshot)

* Retextured protest sign (can be changed using Texture Toolkit: https://www.gta5-mods.com/tools/texture-toolkit)

**Grab it here:** 

[Add-Ons For DpEmotes](https://github.com/TayMcKenzieNZ/addonsfordpemotes)


--------------------------------------------------------


# Additional Instructions ⚙️

- [Please check the fivem forum thread](https://forum.fivem.net/t/dpemotes-356ish-emotes-usable-while-walking-props-and-more/843105)

- [Read my Menyoo To DpEmotes Tutorial](https://forum.cfx.re/t/how-to-menyoo-to-dpemotes-conversion-streaming-custom-add-on-props/4775018)



----------------------

# Police Badge 👮

- Custom LSPD police badge by [LSPDFR member Sam](https://www.lcpdfr.com/downloads/gta5mods/misc/23386-lspd-police-badge/)

- LSPD reskinned badge by [GTA5Mods user Sladus_Slawonkus](https://www.gta5-mods.com/misc/lspd-police-badge-replace-sladus_slawonkus)


----------------------

# FAQs 🗨️

**Q: Why do some emotes not work with females?**

**A:** Blame Rockstar Games. I've done my best to replicate animations to work with females, however some male scenarios have sound effects and particles, of which I am unfamiliar with and syncing particles is out of my expertise.

----------------------

**Q: Why do some emotes not work at all?**

**A:** Check the Installation Instructions above as you need to be on the highest FiveM gamebuild.

----------------------

**Q: Why do I see particle effects but other players don't?**

**A:** Dullpear and I can't figure out how to sync particles. If you know how, feel free to inform me.

----------------------

**Q: I bought this script off someone and notice it had a lot of the same animations. Can you help me?**

**A:** You got scammed and that's your fault. Dpemotes is and always will be **FREE**.

----------------------

**Q: Can I add my own emotes to this?**

**A:** Of course, see my in depth [tutorial](https://forum.cfx.re/t/how-to-menyoo-to-dpemotes-conversion/4775018) for using Menyoo and converting them to work with dpemotes.

You may sell ***custom made*** animations, however the menu must remain free.

----------------------

**Q: I bought a pack of custom animations, how can I add them to your fork of dpemotes?**

**A:** Usually the person who created them will provide code snippets for adding animations to dpemotes. If for whatever reason they haven't, you should contact them.

We have however added code to hopefully make it a lot easier to add shared emotes.

----------------------

**Q: How do I reset the SQL keybinds?**

**A:** No idea, but apparently only the server owner can 🤷🏻‍♂️ Google exist; Maybe contact the creator.

----------------------

**Q: How do Shared Emotes work?**

**A:** Please see the Shared Emotes section of this ReadMe for more information.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Credits 🤝

This script is where it is today because of the amazing contributions made by the following people: 

- Thank you to [Tigerle](https://forum.cfx.re/u/tigerle_studios) for providing the additional code required to make Shared Emotes work

- Thank you to [SMGMissy](https://forum.cfx.re/u/smgmissy/) for assisting with custom pride flags and how to stream them

- Thank you to [MissSnowie](https://www.gta5-mods.com/users/MissySnowie) for the custom poses and emotes

- A huge thank you to [Kibook](https://github.com/kibook) for the addition of the Animal Emotes sub menu

- Thank you to [AvaN0x](https://github.com/AvaN0x) for reformatting and assisting with code and additional features

- Thank you to you, the community for being patient, showing love and appreciation, and for providing translations.

You pay a big role in keeping this script alive and we could not do it without you 🙏



