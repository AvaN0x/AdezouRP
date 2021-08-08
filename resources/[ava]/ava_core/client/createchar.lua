-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- inspired by https://github.com/NicooPasPris/nicoo_charcreator

AVA.Player.CreatingChar = false

local CharacterData = {}
local CharacterSkin = {}

local MainMenu = RageUI.CreateMenu("", "Création de personnage", 0, 0, "avaui", "avaui_title_adezou")


---------------------------------------
--------------- Cameras ---------------
---------------------------------------
local bodyCam, faceCam, isCamOnFace = nil, nil, false


local function StartCharCreator()
    -- here I'm using PlayerPedId() instead of a var, in case the player ped model is changed while doing this function

    bodyCam, faceCam, isCamOnFace = nil, nil, false

    DoScreenFadeOut(1000)
    Wait(2000)

    -- init cameras
    DestroyAllCams(true)

    bodyCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.92, -1000.72, -99.01, 0.00, 0.00, 0.00, 30.00, false, 0)
    faceCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.92, -1000.72, -98.45, 0.00, 0.00, 0.00, 10.00, false, 0)
    local zoomCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.99, -998.02, -99.00, 0.00, 0.00, 0.00, 50.00, false, 0)
    PointCamAtCoord(zoomCam, 402.99, -998.02, -99.00)

    SetCamActive(zoomCam, true)
    RenderScriptCams(true, false, 2000, true, true)

    Wait(500)

    -- set player position
    DoScreenFadeIn(2000)
    SetEntityCoords(PlayerPedId(), 405.59, -997.18, -99.00, 0.0, 0.0, 0.0, true)
    SetEntityHeading(PlayerPedId(), 90.00)

    Wait(500)

    -- zoom animation on cameras from zoomCam to bodyCam
    SetCamActiveWithInterp(bodyCam, zoomCam, 5000, true, true)

    -- play anim for player to move on the right place
    while not HasAnimDictLoaded("mp_character_creation@customise@male_a") do
        RequestAnimDict("mp_character_creation@customise@male_a")
        Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 4000, 0, 1, 0, 0, 0)

    Wait(5000)

    -- set precise position to the player
    if #(GetEntityCoords(PlayerPedId()) - vector3(402.89, -996.87, -99.0)) > 0.5 then
        SetEntityCoords(PlayerPedId(), 402.89, -996.87, -99.0, 0.0, 0.0, 0.0, true)
        SetEntityHeading(PlayerPedId(), 173.97)
    end

    Wait(1000)
    FreezeEntityPosition(PlayerPedId(), true)
end


local function ToggleCamOnFace(value)
    if value and not isCamOnFace then
        SetCamActiveWithInterp(faceCam, bodyCam, 2000, true, true)
        isCamOnFace = true
    elseif isCamOnFace then
        SetCamActiveWithInterp(bodyCam, faceCam, 2000, true, true)
        isCamOnFace = false
    end
end

local function StopCharCreator()
    local playerPed = PlayerPedId()
    DoScreenFadeOut(1000)

    Wait(1000)

    RenderScriptCams(false, false, 0, true, true)

    AVA.Player.CreatingChar = false

    EnableAllControlActions(0)

    FreezeEntityPosition(playerPed, false)

    -- SetEntityCoords(playerPed, Config.PlayerSpawn.x, Config.PlayerSpawn.y, Config.PlayerSpawn.z)
    -- SetEntityHeading(playerPed, Config.PlayerSpawn.h)

    Wait(1000)

    DisplayRadar(true)
    DoScreenFadeIn(1000)

    Wait(1000)
    -- TriggerServerEvent('esx_skin:save', Character)
    -- TriggerEvent('skinchanger:loadSkin', Character)

    DestroyAllCams(true)
    -- clear some global variables
    bodyCam, faceCam, isCamOnFace = nil, nil, false
end


-------------------------------------
--------------- MENUS ---------------
-------------------------------------

local function ValidateData()
    local hadError = false
    if not CharacterData.firstname or CharacterData.firstname == ""
        or not CharacterData.lastname or CharacterData.lastname == ""
        or not CharacterData.birthdate or CharacterData.birthdate == "" or not string.find(CharacterData.birthdate, "%d%d/%d%d/%d%d%d%d")
    then
        hadError = true
        AVA.ShowNotification("~r~Les informations sur l'identité de votre personnage ne sont pas valides.", nil, "ava_core_logo", "Date de naissance", nil, nil, "ava_core_logo")
    end
    if CharacterData.selectedOutfit == 0 then
        hadError = true
        AVA.ShowNotification("~r~Vous n'avez pas séléctionné de tenue.", nil, "ava_core_logo", "Vêtements", nil, nil, "ava_core_logo")
    end

    return not hadError
end

-- don't touch these lists
local MomList = { "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Misty" }
local MomListId = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45 }

local DadList = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", "John", "Niko", "Claude" }
local DadListId = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44 }
local MomIndex, DadIndex, Resemblance, SkinTone = 1, 1, 10, 10


local Outfits = {
    -- Male
    [0] = {
        -- Default outfit
        [0] = {
            outfit = {sex = 0, torso_1 = 15, torso_2 = 0, arms = 15, arms_2 = 0, tshirt_1 = 15, tshirt_2 = 0, pants_1 = 61, pants_2 = 1, helmet_1 = -1, helmet_2 = 0, shoes_1 = 5, shoes_2 = 0 }
        },

        --! test outfits
        [1] = {
            outfit = {sex = 0, torso_1 = 25, torso_2 = 0, arms = 5, arms_2 = 0, tshirt_1 = 10, tshirt_2 = 0, pants_1 = 21, pants_2 = 1, helmet_1 = -1, helmet_2 = 0, shoes_1 = 52, shoes_2 = 0 },
            label = "Tenue lambda"
        },
        [2] = {
            outfit = {sex = 0, torso_1 = 255, torso_2 = 0, arms = 5, arms_2 = 0, tshirt_1 = 10, tshirt_2 = 0, pants_1 = 21, pants_2 = 1, helmet_1 = -1, helmet_2 = 0, shoes_1 = 52, shoes_2 = 0 },
            label = "Tenue 2"
        }
    },

    -- Female
    [1] = {
        -- Default outfit
        [0] = {
            outfit = {sex = 1, torso_1 = 15, torso_2 = 0, arms = 15, arms_2 = 0, tshirt_1 = 14, tshirt_2 = 0, pants_1 = 15, pants_2 = 0, helmet_1 = -1, helmet_2 = 0, shoes_1 = 5, shoes_2 = 0, glasses_1 = 5 }
        },

        --! test outfits
        [1] = {
            outfit = {sex = 1, torso_1 = 25, torso_2 = 0, arms = 5, arms_2 = 0, tshirt_1 = 12, tshirt_2 = 0, pants_1 = 55, pants_2 = 0, helmet_1 = -1, helmet_2 = 0, shoes_1 = 58, shoes_2 = 0, glasses_1 = 5 },
            label = "Tenue lambda"
        },
        [2] = {
            outfit = {sex = 1, torso_1 = 255, torso_2 = 0, arms = 5, arms_2 = 0, tshirt_1 = 12, tshirt_2 = 0, pants_1 = 55, pants_2 = 0, helmet_1 = -1, helmet_2 = 0, shoes_1 = 58, shoes_2 = 0, glasses_1 = 5 },
            label = "Tenue 2"
        }
    }
}

local SexList = {"Homme", "Femme"}
MainMenu.Closable = false
MainMenu.Closed = function()
    print("MainMenu closed")
    print("CharacterData", json.encode(CharacterData))
    StopCharCreator()
end
local SubMenuIdentity = RageUI.CreateSubMenu(MainMenu, "", "Identité")

local SubMenuHeritage = RageUI.CreateSubMenu(MainMenu, "", "Hérédité")

SubMenuHeritage.Closed = function()
	ToggleCamOnFace(false)
    exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end


local SubMenuVisage = RageUI.CreateSubMenu(MainMenu, "", "Traits du visage")

SubMenuVisage.Closed = function()
	ToggleCamOnFace(false)
    exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end


local SubMenuAppearance = RageUI.CreateSubMenu(MainMenu, "", "Apparence")

SubMenuAppearance.Closed = function()
	ToggleCamOnFace(false)
    exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end

local SubMenuOutfits = RageUI.CreateSubMenu(MainMenu, "", "Tenues")
local DisplayedOutfit = 0
SubMenuOutfits.Closed = function()
    exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
    DisplayedOutfit = CharacterData.selectedOutfit
end


function RageUI.PoolMenus:AvaCoreCreateChar()
	MainMenu:IsVisible(function(Items)
        -- Items:AddButton("AdezouRP", nil, { LeftBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end, RightBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end }, function(onSelected) end)

        Items:AddList("Sexe", SexList, CharacterData.sexIndex + 1, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				CharacterData.sexIndex = Index - 1
                CharacterData.selectedOutfit = 0
                exports.skinchanger:reset()
                exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][0].outfit)
                MomIndex, DadIndex, Resemblance, SkinTone = 1, 1, 10, 10
			end
        end)

        Items:AddButton("Identité", "", { RightLabel = "→→→" }, nil, SubMenuIdentity)

        Items:AddButton("Hérédité", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][0].outfit)
            end
        end, SubMenuHeritage)

        Items:AddButton("Traits du visage", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][0].outfit)
            end
        end, SubMenuVisage)

        Items:AddButton("Apparence", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][0].outfit)
            end
        end, SubMenuAppearance)

        Items:AddButton("Tenues", "", { RightLabel = "→→→" }, nil, SubMenuOutfits)


        Items:AddButton("Sauvegarder et valider", nil, { Color = { BackgroundColor = RageUI.ItemsColour.MenuYellow, HighLightColor = RageUI.ItemsColour.PmMitemHighlight } }, function(onSelected)
            if onSelected and ValidateData() then
                RageUI.CloseAll()
            end
		end)
	end)

    SubMenuIdentity:IsVisible(function(Items)
        Items:AddButton("Prénom", "(50 caractères max.)", { RightLabel = CharacterData.firstname }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre prénom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterData.firstname = result
                end
            end
        end)
        Items:AddButton("Nom", "(50 caractères max.)", { RightLabel = CharacterData.lastname }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre nom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterData.lastname = result
                end
            end
        end)
        Items:AddButton("Date de naissance", "Format de date : jj/mm/aaaa\nExemple : 15/08/2020", { RightLabel = CharacterData.birthdate }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre date de naissance (jj/mm/aaaa)", "", 10)
                if result and result ~= "" then
                    if string.find(result, "%d%d/%d%d/%d%d%d%d") then
                        CharacterData.birthdate = result
                    else
                        AVA.ShowNotification("Le format de date spécifié n'est pas le bon.", nil, "ava_core_logo", "Date de naissance", nil, nil, "ava_core_logo")
                    end
                end
            end
        end)
    end)

    SubMenuHeritage:IsVisible(function(Items)
        Items:Heritage(MomIndex, DadIndex)
        Items:AddList("Mère", MomList, MomIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
				MomIndex = Index
                exports.skinchanger:change("mom", MomListId[MomIndex])
			end
        end)
        Items:AddList("Père", DadList, DadIndex, nil, {}, function(Index, onSelected, onListChange)
            if onListChange then
				DadIndex = Index
                exports.skinchanger:change("dad", DadListId[DadIndex])
			end
        end)
        Items:SliderHeritage("Ressemblance", Resemblance, "Déterminez qui de votre père ou de votre mère a le plus d'influence sur la couleur de votre peau.", function(Selected, Active, OnListChange, SliderIndex, Percent)
            if OnListChange then
                Resemblance = SliderIndex
                exports.skinchanger:change("face_md_weight", Percent)
            end
        end)
        Items:SliderHeritage("Couleur de peau", SkinTone, "Déterminez de quel parent vous tenez le plus.", function(Selected, Active, OnListChange, SliderIndex, Percent)
            if OnListChange then
                SkinTone = SliderIndex
                exports.skinchanger:change("skin_md_weight", Percent)
            end
        end)
    end)

    SubMenuVisage:IsVisible(function(Items)

    end, function(Panels)

    end)
    SubMenuAppearance:IsVisible(function(Items)

    end, function(Panels)

    end)

    SubMenuOutfits:IsVisible(function(Items)
        for i = 1, #Outfits[CharacterData.sexIndex], 1 do
            Items:AddButton(Outfits[CharacterData.sexIndex][i].label or "Tenue",
                "Ceci est une tenue par défaut.\nElle pourra être changée par la suite dans un magasin de vêtements",
                { RightBadge = (CharacterData.selectedOutfit == i and RageUI.BadgeStyle.Clothes or nil) },
                function(onSelected, onEntered)
                    if onEntered and DisplayedOutfit ~= i then
                        DisplayedOutfit = i
                        exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][DisplayedOutfit].outfit)
                    end
                    if onSelected then
                        CharacterData.selectedOutfit = i
                    end
                end)
        end
    end)


end


-------------------------------------
--------------- Event ---------------
-------------------------------------


RegisterNetEvent("ava_core:client:createChar", function()
    if AVA.Player.CreatingChar then
        return
    end
    AVA.Player.CreatingChar = true

    while not AVA.Player.HasSpawned do Wait(10) end

    CharacterData = {
        firstname = "",
        lastname = "",
        sexIndex = 0,
        birthdate = "",
        selectedOutfit = 0
    }

    exports.skinchanger:reset()
    CharacterSkin = exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
    MomIndex, DadIndex, Resemblance, SkinTone, DisplayedOutfit = 1, 1, 10, 10, 0

    Citizen.CreateThread(function()
        while AVA.Player.CreatingChar do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 245, true) -- T for chat
        end
    end)

    DisplayRadar(false)

    Wait(100)

    StartCharCreator()

    Wait(100)
    RageUI.CloseAll()
    RageUI.Visible(MainMenu, true)
end)


