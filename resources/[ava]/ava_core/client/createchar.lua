-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- inspired by https://github.com/NicooPasPris/nicoo_charcreator

AVA.Player.CreatingChar = false

local CharacterIdentity = {}
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
-- don't touch these lists
local MomList = { "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Misty" }
local MomListId = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45 }

local DadList = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", "John", "Niko", "Claude" }
local DadListId = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44 }
local MomIndex, DadIndex = 1, 1

local DefaultSkin = {
    -- Male
    [0] = {sex = 0, mom = MomListId[1], dad = DadListId[1], torso_1 = 15, torso_2 = 0, arms = 15, arms_2 = 0, tshirt_1 = 15, tshirt_2 = 0, pants_1 = 61, pants_2 = 1, helmet_1 = -1, helmet_2 = 0, shoes_1 = 5, shoes_2 = 0 },
    
    -- Female
    [1] = {sex = 1, mom = MomListId[1], dad = DadListId[1], torso_1 = 15, torso_2 = 0, arms = 15, arms_2 = 0, tshirt_1 = 14, tshirt_2 = 0, pants_1 = 15, pants_2 = 0, helmet_1 = -1, helmet_2 = 0, shoes_1 = 5, shoes_2 = 0, glasses_1 = 5 }
}

local SexList = {"Homme", "Femme"}
MainMenu.Closable = false
MainMenu.Closed = function()
    print("MainMenu closed")
    print("CharacterIdentity", json.encode(CharacterIdentity))
    StopCharCreator()
end
local SubMenuIdentity = RageUI.CreateSubMenu(MainMenu, "", "Identité")

local SubMenuHeritage = RageUI.CreateSubMenu(MainMenu, "", "Hérédité")

SubMenuHeritage.Closed = function()
	ToggleCamOnFace(false)
end

function RageUI.PoolMenus:AvaCoreCreateChar()
	MainMenu:IsVisible(function(Items)
        -- Items:AddButton("AdezouRP", nil, { LeftBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end, RightBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end }, function(onSelected) end)

        Items:AddList("Sexe", SexList, CharacterIdentity.sexIndex + 1, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				CharacterIdentity.sexIndex = Index - 1
                exports.skinchanger:reset()
                CharacterSkin = exports.skinchanger:loadSkin(DefaultSkin[CharacterIdentity.sexIndex])
                MomIndex, DadIndex = 1, 1
			end
        end)

        Items:AddButton("Identité", "", { RightLabel = "→→→" }, nil, SubMenuIdentity)

        Items:AddButton("Hérédité", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
            end
        end, SubMenuHeritage)

        Items:AddButton("Traits du visage", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then

            end
        end, SubMenuVisage)

        Items:AddButton("Apparence", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then

            end
        end, SubMenuAppearance)

        Items:AddButton("Vêtements", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then

            end
        end, SubMenuClothes)


        Items:AddButton("Sauvegarder et valider", nil, { Color = { BackgroundColor = RageUI.ItemsColour.MenuYellow, HighLightColor = RageUI.ItemsColour.PmMitemHighlight } }, function(onSelected)
            if onSelected then
                RageUI.CloseAll()
            end
		end)
	end)

    SubMenuIdentity:IsVisible(function(Items)
        Items:AddButton("Prénom", nil, { RightLabel = CharacterIdentity.firstname }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre prénom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterIdentity.firstname = result
                end
            end
        end)
        Items:AddButton("Nom", nil, { RightLabel = CharacterIdentity.lastname }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre nom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterIdentity.lastname = result
                end
            end
        end)
        Items:AddButton("Date de naissance", nil, { RightLabel = CharacterIdentity.birthdate }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre date de naissance (jj/mm/aaaa)", "", 10)
                if result and result ~= "" then
                    if string.find(result, "%d%d/%d%d/%d%d%d%d") then
                        CharacterIdentity.birthdate = result
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
            if (onListChange) then
				MomIndex = Index
                CharacterSkin = exports.skinchanger:change("mom", MomListId[MomIndex])
			end
        end)
        Items:AddList("Père", DadList, DadIndex, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				DadIndex = Index
                CharacterSkin = exports.skinchanger:change("dad", DadListId[DadIndex])
			end
        end)


    end, function()



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

    CharacterIdentity = {
        firstname = "",
        lastname = "",
        sexIndex = 0,
        birthdate = ""
    }
    
    exports.skinchanger:reset()
    CharacterSkin = exports.skinchanger:loadSkin(DefaultSkin[CharacterIdentity.sexIndex])
    MomIndex, DadIndex = 1, 1

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


