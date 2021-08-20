-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- inspired by https://github.com/NicooPasPris/nicoo_charcreator
AVA.Player.CreatingChar = false

local playerPed = nil
local CharacterData = {}
local CharacterSkin = {}
local SkinMaxVals = {}

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
    RequestCollisionAtCoord(405.59, -997.18, -99.00)
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

    -- TaskLookAtCoord(PlayerPedId(), 405.59, -997.18, -99.00, -1, 0, 4)  -- its left
    -- TaskLookAtCoord(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), -20.0, 0.0, 0.0), -1, 0, 4)
    -- TaskLookAtCoord(PlayerPedId(), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 20.0, 0.0, 0.0), -1, 0, 4)

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

    EnableAllControlActions(0)

    FreezeEntityPosition(playerPed, false)

    -- SetEntityCoords(playerPed, Config.PlayerSpawn.x, Config.PlayerSpawn.y, Config.PlayerSpawn.z)
    -- SetEntityHeading(playerPed, Config.PlayerSpawn.h)

    Wait(1000)

    DisplayRadar(true)
    DoScreenFadeIn(1000)

    -- TriggerServerEvent('esx_skin:save', Character)
    -- TriggerEvent('skinchanger:loadSkin', Character)

    DestroyAllCams(true)
end

-------------------------------------
--------------- MENUS ---------------
-------------------------------------

local function ValidateData()
    local hadError = false
    if not CharacterData.firstname or CharacterData.firstname == "" or not CharacterData.lastname or CharacterData.lastname == "" or not CharacterData.birthdate
        or CharacterData.birthdate == "" or not string.find(CharacterData.birthdate, "%d%d/%d%d/%d%d%d%d") then
        hadError = true
        AVA.ShowNotification("~r~Les informations sur l'identité de votre personnage ne sont pas valides.", nil, "ava_core_logo", "Date de naissance", nil,
            nil, "ava_core_logo")
    end
    if CharacterData.selectedOutfit == 0 then
        hadError = true
        AVA.ShowNotification("~r~Vous n'avez pas séléctionné de tenue.", nil, "ava_core_logo", "Vêtements", nil, nil, "ava_core_logo")
    end

    return not hadError
end

-- don't touch these lists
local MomList = {
    "Hannah",
    "Audrey",
    "Jasmine",
    "Giselle",
    "Amelia",
    "Isabella",
    "Zoe",
    "Ava",
    "Camilla",
    "Violet",
    "Sophia",
    "Evelyn",
    "Nicole",
    "Ashley",
    "Gracie",
    "Brianna",
    "Natalie",
    "Olivia",
    "Elizabeth",
    "Charlotte",
    "Emma",
    "Misty",
}
local MomListId = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45}

local DadList = {
    "Benjamin",
    "Daniel",
    "Joshua",
    "Noah",
    "Andrew",
    "Juan",
    "Alex",
    "Isaac",
    "Evan",
    "Ethan",
    "Vincent",
    "Angel",
    "Diego",
    "Adrian",
    "Gabriel",
    "Michael",
    "Santiago",
    "Kevin",
    "Louis",
    "Samuel",
    "Anthony",
    "John",
    "Niko",
    "Claude",
}
local DadListId = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44}
local MomIndex, DadIndex, Resemblance, SkinTone = 1, 1, 10, 10

local Outfits = {
    -- Male
    [0] = {
        -- Default outfit
        [0] = {
            outfit = {
                sex = 0,
                torso_1 = 15,
                torso_2 = 0,
                arms = 15,
                arms_2 = 0,
                tshirt_1 = 15,
                tshirt_2 = 0,
                pants_1 = 61,
                pants_2 = 1,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 5,
                shoes_2 = 0,
            },
        },

        [1] = {
            outfit = {
                sex = 0,
                torso_1 = 0,
                torso_2 = 0,
                arms = 19,
                arms_2 = 0,
                tshirt_1 = 5,
                tshirt_2 = 0,
                pants_1 = 62,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 16,
                shoes_2 = 5,
            },
            label = "Tenue short",
        },
        [2] = {
            outfit = {
                sex = 0,
                torso_1 = 0,
                torso_2 = 0,
                arms = 19,
                arms_2 = 0,
                tshirt_1 = 5,
                tshirt_2 = 0,
                pants_1 = 63,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 22,
                shoes_2 = 0,
            },
            label = "Tenue lambda",
        },
        [3] = {
            outfit = {
                sex = 0,
                torso_1 = 7,
                torso_2 = 13,
                arms = 24,
                arms_2 = 0,
                tshirt_1 = 5,
                tshirt_2 = 0,
                pants_1 = 64,
                pants_2 = 2,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 9,
                shoes_2 = 3,
            },
            label = "Tenue jogging",
        },
        [4] = {
            outfit = {
                sex = 0,
                torso_1 = 72,
                torso_2 = 2,
                arms = 24,
                arms_2 = 0,
                tshirt_1 = 13,
                tshirt_2 = 0,
                pants_1 = 48,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 10,
                shoes_2 = 7,
            },
            label = "Tenue homme d'affaire",
        },
        [5] = {
            outfit = {
                sex = 0,
                torso_1 = 167,
                torso_2 = 0,
                arms = 24,
                arms_2 = 0,
                tshirt_1 = 47,
                tshirt_2 = 0,
                pants_1 = 98,
                pants_2 = 1,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 54,
                shoes_2 = 3,
            },
            label = "Tenue hiver",
        },
    },

    -- Female
    [1] = {
        -- Default outfit
        [0] = {
            outfit = {
                sex = 1,
                torso_1 = 15,
                torso_2 = 0,
                arms = 15,
                arms_2 = 0,
                tshirt_1 = 14,
                tshirt_2 = 0,
                pants_1 = 15,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 5,
                shoes_2 = 0,
                glasses_1 = 5,
            },
        },

        [1] = {
            outfit = {
                sex = 1,
                torso_1 = 0,
                torso_2 = 2,
                arms = 0,
                arms_2 = 0,
                tshirt_1 = 14,
                tshirt_2 = 0,
                pants_1 = 25,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 1,
                shoes_2 = 0,
                glasses_1 = 5,
            },
            label = "Tenue short",
        },
        [2] = {
            outfit = {
                sex = 1,
                torso_1 = 2,
                torso_2 = 0,
                arms = 2,
                arms_2 = 0,
                tshirt_1 = 14,
                tshirt_2 = 0,
                pants_1 = 2,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 1,
                shoes_2 = 0,
                glasses_1 = 5,
            },
            label = "Tenue lambda",
        },
        [3] = {
            outfit = {
                sex = 1,
                torso_1 = 4,
                torso_2 = 14,
                arms = 4,
                arms_2 = 0,
                tshirt_1 = 14,
                tshirt_2 = 0,
                pants_1 = 2,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 1,
                shoes_2 = 0,
                glasses_1 = 5,
            },
            label = "Tenue jogging",
        },
        [4] = {
            outfit = {
                sex = 1,
                torso_1 = 7,
                torso_2 = 4,
                arms = 6,
                arms_2 = 0,
                tshirt_1 = 20,
                tshirt_2 = 1,
                pants_1 = 6,
                pants_2 = 0,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 6,
                shoes_2 = 0,
                glasses_1 = 5,
            },
            label = "Tenue femme d'affaire",
        },
        [5] = {
            outfit = {
                sex = 1,
                torso_1 = 64,
                torso_2 = 0,
                arms = 6,
                arms_2 = 0,
                tshirt_1 = 20,
                tshirt_2 = 0,
                pants_1 = 73,
                pants_2 = 5,
                helmet_1 = -1,
                helmet_2 = 0,
                shoes_1 = 8,
                shoes_2 = 0,
                glasses_1 = 5,
            },
            label = "Tenue hiver",
        },
    },
}

local SexList = {"Homme", "Femme"}
MainMenu.Closable = false

local SubMenuIdentity = RageUI.CreateSubMenu(MainMenu, "", "Identité")

local SubMenuHeritage = RageUI.CreateSubMenu(MainMenu, "", "Hérédité")

SubMenuHeritage.Closed = function()
    ToggleCamOnFace(false)
    exports.skinchanger:changes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end

local SubMenuVisage = RageUI.CreateSubMenu(MainMenu, "", "Traits du visage")

SubMenuVisage.EnableMouse = true
SubMenuVisage.Closed = function()
    ToggleCamOnFace(false)
    exports.skinchanger:changes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end

local SubMenuAppearance = RageUI.CreateSubMenu(MainMenu, "", "Apparence")
SubMenuAppearance.EnableMouse = true
SubMenuAppearance.Closed = function()
    ToggleCamOnFace(false)
    exports.skinchanger:changes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end

local SubMenuOutfits = RageUI.CreateSubMenu(MainMenu, "", "Tenues")
local DisplayedOutfit = 0
SubMenuOutfits.Closed = function()
    exports.skinchanger:changes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
    DisplayedOutfit = CharacterData.selectedOutfit
end

function RageUI.PoolMenus:AvaCoreCreateChar()
    MainMenu:IsVisible(function(Items)
        -- Items:AddButton("AdezouRP", nil, { LeftBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end, RightBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end }, function(onSelected) end)

        Items:AddList("Sexe", SexList, CharacterData.sexIndex + 1, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.sexIndex = Index - 1
                CharacterData.Visage = {}
                CharacterData.Appearance = {}
                CharacterData.selectedOutfit = 0
                MomIndex, DadIndex, Resemblance, SkinTone = 1, 1, 10, 10
                exports.skinchanger:reset()
                CharacterSkin = exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][0].outfit)
                SkinMaxVals = exports.skinchanger:GetMaxVals()
                playerPed = PlayerPedId()
            end
        end)

        Items:AddButton("Identité", "", {RightLabel = "→→→"}, nil, SubMenuIdentity)

        Items:AddButton("Hérédité", "", {RightLabel = "→→→"}, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.skinchanger:changes(Outfits[CharacterData.sexIndex][0].outfit)
                playerPed = PlayerPedId()
            end
        end, SubMenuHeritage)

        Items:AddButton("Traits du visage", "", {RightLabel = "→→→"}, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.skinchanger:changes(Outfits[CharacterData.sexIndex][0].outfit)
                playerPed = PlayerPedId()
            end
        end, SubMenuVisage)

        Items:AddButton("Apparence", "", {RightLabel = "→→→"}, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.skinchanger:changes(Outfits[CharacterData.sexIndex][0].outfit)
                playerPed = PlayerPedId()
            end
        end, SubMenuAppearance)

        Items:AddButton("Tenues", "", {RightLabel = "→→→"}, nil, SubMenuOutfits)

        Items:AddButton("Sauvegarder et valider", nil,
            {Color = {BackgroundColor = RageUI.ItemsColour.MenuYellow, HighLightColor = RageUI.ItemsColour.PmMitemHighlight}}, function(onSelected)
                if onSelected and ValidateData() then
                    RageUI.CloseAll()
                end
            end)
    end)

    SubMenuIdentity:IsVisible(function(Items)
        Items:AddButton("Prénom", "(50 caractères max.)", {RightLabel = CharacterData.firstname}, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre prénom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterData.firstname = result
                end
            end
        end)
        Items:AddButton("Nom", "(50 caractères max.)", {RightLabel = CharacterData.lastname}, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre nom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterData.lastname = result
                end
            end
        end)
        Items:AddButton("Date de naissance", "Format de date : jj/mm/aaaa\nExemple : 15/08/2020", {RightLabel = CharacterData.birthdate}, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre date de naissance (jj/mm/aaaa)", "", 10)
                if result and result ~= "" then
                    if string.find(result, "%d%d/%d%d/%d%d%d%d") then
                        CharacterData.birthdate = result
                    else
                        AVA.ShowNotification("Le format de date spécifié n'est pas le bon.", nil, "ava_core_logo", "Date de naissance", nil, nil,
                            "ava_core_logo")
                    end
                end
            end
        end)
    end)

    SubMenuHeritage:IsVisible(function(Items)
        Items:Heritage(MomIndex, DadIndex)
        Items:AddList("Mère", MomList, MomIndex, "Choisissez votre mère.", {}, function(Index, onSelected, onListChange)
            if onListChange then
                MomIndex = Index
                exports.skinchanger:change("mom", MomListId[MomIndex])
            end
        end)
        Items:AddList("Père", DadList, DadIndex, "Choisissez votre père.", {}, function(Index, onSelected, onListChange)
            if onListChange then
                DadIndex = Index
                exports.skinchanger:change("dad", DadListId[DadIndex])
            end
        end)
        Items:SliderHeritage("Ressemblance", Resemblance, "Déterminez de quel parent vous tenez le plus.",
            function(Selected, Active, OnListChange, SliderIndex, Percent)
                if OnListChange then
                    Resemblance = SliderIndex
                    exports.skinchanger:change("face_md_weight", Percent)
                end
            end)
        Items:SliderHeritage("Couleur de peau", SkinTone,
            "Déterminez qui de votre père ou de votre mère a le plus d'influence sur la couleur de votre peau.",
            function(Selected, Active, OnListChange, SliderIndex, Percent)
                if OnListChange then
                    SkinTone = SliderIndex
                    exports.skinchanger:change("skin_md_weight", Percent)
                end
            end)
    end)

    SubMenuVisage:IsVisible(function(Items)
        Items:AddButton("Bas du front", "Modifiez votre visage")
        Items:AddButton("Yeux", "Modifiez votre visage")
        Items:AddButton("Nez", "Modifiez votre visage")
        Items:AddButton("Arête du nez", "Modifiez votre visage")
        Items:AddButton("Bout du nez", "Modifiez votre visage")
        Items:AddButton("Pommettes", "Modifiez votre visage")
        Items:AddButton("Joues", "Modifiez votre visage")
        Items:AddButton("Lèvres", "Modifiez votre visage")
        Items:AddButton("Mâchoire", "Modifiez votre visage")
        Items:AddButton("Profil menton", "Modifiez votre visage")
        Items:AddButton("Forme du menton", "Modifiez votre visage")
        Items:AddButton("Largeur du cou", "Modifiez votre visage")
    end, function(Panels)
        Panels:Grid(CharacterData.Visage.ForeHeadX or 0.5, CharacterData.Visage.ForeHeadY or 0.5, "Haut", "Bas", "Intérieur", "Extérieur",
            function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.ForeHeadX = X
                CharacterData.Visage.ForeHeadY = Y
                exports.skinchanger:changesNoApply({eyebrows_6 = CharacterX * 100, eyebrows_5 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 6, CharacterX) -- eyebrows_5
                SetPedFaceFeature(playerPed, 7, CharacterY) -- eyebrows_6
            end, 1)

        Panels:GridHorizontal(CharacterData.Visage.Eyes or 0.5, "Plissés", "Ouverts", function(X, _, CharacterX)
            CharacterData.Visage.Eyes = X
            exports.skinchanger:changeNoApply("eye_squint", (1 - CharacterX) * 100)
            SetPedFaceFeature(playerPed, 11, (1 - CharacterX)) -- eye_squint
        end, 2)

        Panels:Grid(CharacterData.Visage.NoseX or 0.5, CharacterData.Visage.NoseY or 0.5, "Relevé", "Bas", "Fin", "Epais",
            function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.NoseX = X
                CharacterData.Visage.NoseY = Y
                exports.skinchanger:changesNoApply({nose_1 = CharacterX * 100, nose_2 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 0, CharacterX) -- nose_1
                SetPedFaceFeature(playerPed, 1, CharacterY) -- nose_2
            end, 3)

        Panels:Grid(CharacterData.Visage.NoseBoneX or 0.5, CharacterData.Visage.NoseBoneY or 0.5, "Saillante", "Incurvée", "Courte", "Longue",
            function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.NoseBoneX = X
                CharacterData.Visage.NoseBoneY = Y
                exports.skinchanger:changesNoApply({nose_3 = (1 - CharacterX) * 100, nose_4 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 2, (1 - CharacterX)) -- nose_3
                SetPedFaceFeature(playerPed, 3, CharacterY) -- nose_4
            end, 4)

        Panels:Grid(CharacterData.Visage.NosePeakX or 0.5, CharacterData.Visage.NosePeakY or 0.5, "Bout vers le haut", "Bout vers le bas", "Cassé\ngauche",
            "Cassé\ndroite", function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.NosePeakX = X
                CharacterData.Visage.NosePeakY = Y
                exports.skinchanger:changesNoApply({nose_6 = (1 - CharacterX) * 100, nose_5 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 5, (1 - CharacterX)) -- nose_6
                SetPedFaceFeature(playerPed, 4, CharacterY) -- nose_5
            end, 5)

        Panels:Grid(CharacterData.Visage.CheekBoneX or 0.5, CharacterData.Visage.CheekBoneY or 0.5, "Haut", "Bas", "Intérieur", "Extérieur",
            function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.CheekBoneX = X
                CharacterData.Visage.CheekBoneY = Y
                exports.skinchanger:changesNoApply({cheeks_2 = CharacterX * 100, cheeks_1 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 9, CharacterX) -- cheeks_2
                SetPedFaceFeature(playerPed, 8, CharacterY) -- cheeks_1
            end, 6)

        Panels:GridHorizontal(CharacterData.Visage.Cheek or 0.5, "Emacié", "Bouffi", function(X, _, CharacterX)
            CharacterData.Visage.Cheek = X
            exports.skinchanger:changeNoApply("cheeks_3", (1 - CharacterX) * 100)
            SetPedFaceFeature(playerPed, 10, (1 - CharacterX)) -- cheeks_3
        end, 7)

        Panels:GridHorizontal(CharacterData.Visage.Lips or 0.5, "Minces", "Epaisses", function(X, _, CharacterX)
            CharacterData.Visage.Lips = X
            exports.skinchanger:changeNoApply("lip_thickness", (1 - CharacterX) * 100)
            SetPedFaceFeature(playerPed, 12, (1 - CharacterX)) -- lip_thickness
        end, 8)

        Panels:Grid(CharacterData.Visage.JawX or 0.5, CharacterData.Visage.JawY or 0.5, "Ronde", "Carrée", "Etroite", "Large",
            function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.JawX = X
                CharacterData.Visage.JawY = Y
                exports.skinchanger:changesNoApply({jaw_1 = CharacterX * 100, jaw_2 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 13, CharacterX) -- jaw_1
                SetPedFaceFeature(playerPed, 14, CharacterY) -- jaw_2
            end, 9)

        Panels:Grid(CharacterData.Visage.ChinX or 0.5, CharacterData.Visage.ChinY or 0.5, "Haut", "Bas", "Intérieur", "Extérieur",
            function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.ChinX = X
                CharacterData.Visage.ChinY = Y
                exports.skinchanger:changesNoApply({chin_2 = CharacterX * 100, chin_1 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 16, CharacterX) -- chin_2
                SetPedFaceFeature(playerPed, 15, CharacterY) -- chin_1
            end, 10)

        Panels:Grid(CharacterData.Visage.ChinShapeX or 0.5, CharacterData.Visage.ChinShapeY or 0.5, "Arrondi", "Fossette", "Carré", "Pointu",
            function(X, Y, CharacterX, CharacterY)
                CharacterData.Visage.ChinShapeX = X
                CharacterData.Visage.ChinShapeY = Y
                exports.skinchanger:changesNoApply({chin_3 = (1 - CharacterX) * 100, chin_4 = CharacterY * 100})
                SetPedFaceFeature(playerPed, 17, (1 - CharacterX)) -- chin_3
                SetPedFaceFeature(playerPed, 18, CharacterY) -- chin_4
            end, 11)

        Panels:GridHorizontal(CharacterData.Visage.Neck or 0.5, "Mince", "Epais", function(X, _, CharacterX)
            CharacterData.Visage.Neck = X
            exports.skinchanger:changeNoApply("neck_thickness", CharacterX * 100)
            SetPedFaceFeature(playerPed, 19, CharacterX) -- lip_thickness
        end, 12)
    end)

    SubMenuAppearance:IsVisible(function(Items)
        Items:AddList("Coiffure", (SkinMaxVals.hair_1 or -1) + 1, CharacterData.Appearance.HairCutIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.HairCutIndex = Index

                    CharacterSkin.hair_1 = Index - 1
                    exports.skinchanger:changeNoApply("hair_1", Index - 1)
                    SetPedComponentVariation(playerPed, 2, CharacterSkin.hair_1, CharacterSkin.hair_2, 2)
                    -- SkinMaxVals.hair_2 = GetNumberOfPedTextureVariations(playerPed, 2, CharacterSkin.hair_1) - 1
                end
            end)
        Items:AddList("Sourcils", (SkinMaxVals.eyebrows_1 or -1) + 1, CharacterData.Appearance.EyeBrowsIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.EyeBrowsIndex = Index

                    CharacterSkin.eyebrows_1 = Index - 1
                    exports.skinchanger:changeNoApply("eyebrows_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 2, CharacterSkin.eyebrows_1, (CharacterSkin.eyebrows_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Pilosité faciale", (SkinMaxVals.beard_1 or -1) + 1, CharacterData.Appearance.BeardIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.BeardIndex = Index

                    CharacterSkin.beard_1 = Index - 1
                    exports.skinchanger:changeNoApply("beard_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 1, CharacterSkin.beard_1, (CharacterSkin.beard_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Problèmes peau", (SkinMaxVals.blemishes_1 or -1) + 1, CharacterData.Appearance.BlemishesIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.BlemishesIndex = Index

                    CharacterSkin.blemishes_1 = Index - 1
                    exports.skinchanger:changeNoApply("blemishes_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 0, CharacterSkin.blemishes_1, (CharacterSkin.blemishes_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Signes de vieillissement", (SkinMaxVals.age_1 or -1) + 1, CharacterData.Appearance.SkinAgingIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.SkinAgingIndex = Index

                    CharacterSkin.age_1 = Index - 1
                    exports.skinchanger:changeNoApply("age_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 3, CharacterSkin.age_1, (CharacterSkin.age_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Teint", (SkinMaxVals.complexion_1 or -1) + 1, CharacterData.Appearance.ComplexionIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.ComplexionIndex = Index

                    CharacterSkin.complexion_1 = Index - 1
                    exports.skinchanger:changeNoApply("complexion_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 6, CharacterSkin.complexion_1, (CharacterSkin.complexion_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Taches cutanées", (SkinMaxVals.moles_1 or -1) + 1, CharacterData.Appearance.MolesIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.MolesIndex = Index

                    CharacterSkin.moles_1 = Index - 1
                    exports.skinchanger:changeNoApply("moles_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 9, CharacterSkin.moles_1, (CharacterSkin.moles_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Aspect de la peau", (SkinMaxVals.sun_1 or -1) + 1, CharacterData.Appearance.SkinDamageIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.SkinDamageIndex = Index

                    CharacterSkin.sun_1 = Index - 1
                    exports.skinchanger:changeNoApply("sun_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 7, CharacterSkin.sun_1, (CharacterSkin.sun_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Couleur des yeux", (SkinMaxVals.eye_color or -1) + 1, CharacterData.Appearance.EyeColorIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.EyeColorIndex = Index

                    CharacterSkin.eye_color = Index - 1
                    exports.skinchanger:changeNoApply("eye_color", Index - 1)
                    SetPedEyeColor(playerPed, CharacterSkin.eye_color, 0, 1)
                end
            end)
        Items:AddList("Maquilage yeux", (SkinMaxVals.makeup_1 or -1) + 1, CharacterData.Appearance.EyeMakeupIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.EyeMakeupIndex = Index

                    CharacterSkin.makeup_1 = Index - 1
                    exports.skinchanger:changeNoApply("makeup_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 4, CharacterSkin.makeup_1, (CharacterSkin.makeup_2 / 100) + 0.0)
                end
            end)
        Items:AddList("Rouge à lèvres", (SkinMaxVals.lipstick_1 or -1) + 1, CharacterData.Appearance.LipstickIndex or 1, "Changez votre apparence.", {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.LipstickIndex = Index

                    CharacterSkin.lipstick_1 = Index - 1
                    exports.skinchanger:changeNoApply("lipstick_1", Index - 1)
                    SetPedHeadOverlay(playerPed, 8, CharacterSkin.lipstick_1, (CharacterSkin.lipstick_2 / 100) + 0.0)
                end
            end)

    end, function(Panels)
        if CharacterSkin.hair_1 ~= 0 then
            Panels:ColourPanel("Couleur", RageUI.PanelColour.HairCut, CharacterData.Appearance.HairColorMin or 1, CharacterData.Appearance.HairColorIndex or 1,
                function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.HairColorMin = MinimumIndex
                    CharacterData.Appearance.HairColorIndex = CurrentIndex

                    CharacterSkin.hair_color_1 = CurrentIndex - 1
                    exports.skinchanger:changeNoApply("hair_color_1", CurrentIndex - 1)
                    SetPedHairColor(playerPed, CharacterSkin.hair_color_1, CharacterSkin.hair_color_2)
                end, 1)
            Panels:ColourPanel("Couleur des mèches", RageUI.PanelColour.HairCut, CharacterData.Appearance.HairColor2Min or 1,
                CharacterData.Appearance.HairColor2Index or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.HairColor2Min = MinimumIndex
                    CharacterData.Appearance.HairColor2Index = CurrentIndex

                    CharacterSkin.hair_color_2 = CurrentIndex - 1
                    exports.skinchanger:changeNoApply("hair_color_2", CurrentIndex - 1)
                    SetPedHairColor(playerPed, CharacterSkin.hair_color_1, CharacterSkin.hair_color_2)
                end, 1)
        end

        Panels:PercentagePanel(CharacterData.Appearance.EyeBrowsOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.EyeBrowsOpacity = Percent

            CharacterSkin.eyebrows_2 = Percent * 100
            exports.skinchanger:changeNoApply("eyebrows_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 2, CharacterSkin.eyebrows_1, (CharacterSkin.eyebrows_2 / 100) + 0.0)
        end, 2)
        if CharacterSkin.eyebrows_2 > 0 then
            Panels:ColourPanel("Couleur", RageUI.PanelColour.HairCut, CharacterData.Appearance.EyeBrowsColorMin or 1,
                CharacterData.Appearance.EyeBrowsColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.EyeBrowsColorMin = MinimumIndex
                    CharacterData.Appearance.EyeBrowsColorIndex = CurrentIndex

                    CharacterSkin.eyebrows_3 = CurrentIndex - 1
                    exports.skinchanger:changeNoApply("eyebrows_3", CurrentIndex - 1)
                    SetPedHeadOverlayColor(playerPed, 2, 1, CharacterSkin.eyebrows_3, CharacterSkin.eyebrows_4)
                end, 2)
        end

        Panels:PercentagePanel(CharacterData.Appearance.BodyHairsOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.BodyHairsOpacity = Percent

            CharacterSkin.beard_2 = Percent * 100
            exports.skinchanger:changeNoApply("beard_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 1, CharacterSkin.beard_1, (CharacterSkin.beard_2 / 100) + 0.0)
        end, 3)
        if CharacterSkin.beard_2 > 0 then
            Panels:ColourPanel("Couleur", RageUI.PanelColour.HairCut, CharacterData.Appearance.BodyHairsColorMin or 1,
                CharacterData.Appearance.BodyHairsColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.BodyHairsColorMin = MinimumIndex
                    CharacterData.Appearance.BodyHairsColorIndex = CurrentIndex

                    CharacterSkin.beard_3 = CurrentIndex - 1
                    exports.skinchanger:changeNoApply("beard_3", CurrentIndex - 1)
                    SetPedHeadOverlayColor(playerPed, 1, 1, CharacterSkin.beard_3, CharacterSkin.beard_4)
                end, 3)
        end

        Panels:PercentagePanel(CharacterData.Appearance.BlemishesOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.BlemishesOpacity = Percent

            CharacterSkin.blemishes_2 = Percent * 100
            exports.skinchanger:changeNoApply("blemishes_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 0, CharacterSkin.blemishes_1, (CharacterSkin.blemishes_2 / 100) + 0.0)
        end, 4)

        Panels:PercentagePanel(CharacterData.Appearance.SkinAgingOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.SkinAgingOpacity = Percent

            CharacterSkin.age_2 = Percent * 100
            exports.skinchanger:changeNoApply("age_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 3, CharacterSkin.age_1, (CharacterSkin.age_2 / 100) + 0.0)
        end, 5)

        Panels:PercentagePanel(CharacterData.Appearance.ComplexionOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.ComplexionOpacity = Percent

            CharacterSkin.complexion_2 = Percent * 100
            exports.skinchanger:changeNoApply("complexion_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 6, CharacterSkin.complexion_1, (CharacterSkin.complexion_2 / 100) + 0.0)
        end, 6)

        Panels:PercentagePanel(CharacterData.Appearance.MolesOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.MolesOpacity = Percent

            CharacterSkin.moles_2 = Percent * 100
            exports.skinchanger:changeNoApply("moles_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 9, CharacterSkin.moles_1, (CharacterSkin.moles_2 / 100) + 0.0)
        end, 7)

        Panels:PercentagePanel(CharacterData.Appearance.SkinDamageOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.SkinDamageOpacity = Percent

            CharacterSkin.sun_2 = Percent * 100
            exports.skinchanger:changeNoApply("sun_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 7, CharacterSkin.sun_1, (CharacterSkin.sun_2 / 100) + 0.0)
        end, 8)

        Panels:PercentagePanel(CharacterData.Appearance.EyeMakeupOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.EyeMakeupOpacity = Percent

            CharacterSkin.makeup_2 = Percent * 100
            exports.skinchanger:changeNoApply("makeup_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 4, CharacterSkin.makeup_1, (CharacterSkin.makeup_2 / 100) + 0.0)
        end, 10)
        if CharacterSkin.makeup_2 > 0 then
            -- TODO update PanelColour list of colours to a valid one
            Panels:ColourPanel("Couleur", RageUI.PanelColour.HairCut, CharacterData.Appearance.EyeMakeupColorMin or 1,
                CharacterData.Appearance.EyeMakeupColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.EyeMakeupColorMin = MinimumIndex
                    CharacterData.Appearance.EyeMakeupColorIndex = CurrentIndex

                    CharacterSkin.makeup_3 = CurrentIndex - 1
                    exports.skinchanger:changeNoApply("makeup_3", CurrentIndex - 1)
                    SetPedHeadOverlayColor(playerPed, 4, 2, CharacterSkin.makeup_3, CharacterSkin.makeup_4)
                end, 10)
            -- TODO update PanelColour list of colours to a valid one
            Panels:ColourPanel("Couleur 2", RageUI.PanelColour.HairCut, CharacterData.Appearance.EyeMakeupColor2Min or 1,
                CharacterData.Appearance.EyeMakeupColor2Index or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.EyeMakeupColor2Min = MinimumIndex
                    CharacterData.Appearance.EyeMakeupColor2Index = CurrentIndex

                    CharacterSkin.makeup_4 = CurrentIndex - 1
                    exports.skinchanger:changeNoApply("makeup_4", CurrentIndex - 1)
                    SetPedHeadOverlayColor(playerPed, 4, 2, CharacterSkin.makeup_3, CharacterSkin.makeup_4)
                end, 10)
        end

        Panels:PercentagePanel(CharacterData.Appearance.LipstickOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.LipstickOpacity = Percent

            CharacterSkin.lipstick_2 = Percent * 100
            exports.skinchanger:changeNoApply("lipstick_2", Percent * 100)
            SetPedHeadOverlay(playerPed, 8, CharacterSkin.lipstick_1, (CharacterSkin.lipstick_2 / 100) + 0.0)
        end, 11)
        if CharacterSkin.lipstick_2 > 0 then
            -- TODO update PanelColour list of colours to a valid one
            Panels:ColourPanel("Couleur", RageUI.PanelColour.HairCut, CharacterData.Appearance.LipstickColorMin or 1,
                CharacterData.Appearance.LipstickColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.LipstickColorMin = MinimumIndex
                    CharacterData.Appearance.LipstickColorIndex = CurrentIndex

                    CharacterSkin.lipstick_3 = CurrentIndex - 1
                    exports.skinchanger:changeNoApply("lipstick_3", CurrentIndex - 1)
                    SetPedHeadOverlayColor(playerPed, 8, 1, CharacterSkin.lipstick_3, CharacterSkin.lipstick_4)
                end, 11)
        end
    end)

    SubMenuOutfits:IsVisible(function(Items)
        for i = 1, #Outfits[CharacterData.sexIndex], 1 do
            Items:AddButton(Outfits[CharacterData.sexIndex][i].label or "Tenue",
                "Ceci est une tenue par défaut.\nElle pourra être changée par la suite dans un magasin de vêtements",
                {RightBadge = (CharacterData.selectedOutfit == i and RageUI.BadgeStyle.Clothes or nil)}, function(onSelected, onEntered)
                    if onEntered and DisplayedOutfit ~= i then
                        DisplayedOutfit = i
                        exports.skinchanger:changes(Outfits[CharacterData.sexIndex][DisplayedOutfit].outfit)
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

    while not AVA.Player.HasSpawned do
        Wait(10)
    end

    RageUI.CloseAll()

    CharacterData = {firstname = "", lastname = "", sexIndex = 0, birthdate = "", selectedOutfit = 0, Visage = {}, Appearance = {}}

    exports.skinchanger:reset()
    CharacterSkin = exports.skinchanger:loadSkin(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
    Wait(0)
    SkinMaxVals = exports.skinchanger:GetMaxVals()

    MomIndex, DadIndex, Resemblance, SkinTone, DisplayedOutfit = 1, 1, 10, 10, 0

    Citizen.CreateThread(function()
        while AVA.Player.CreatingChar do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 245, true) -- T for chat
            EnableControlAction(2, 239, true) -- INPUT_CURSOR_X needed for RageUI panels
            EnableControlAction(2, 240, true) -- INPUT_CURSOR_Y needed for RageUI panels
        end
    end)

    DisplayRadar(false)

    Wait(100)

    StartCharCreator()

    playerPed = PlayerPedId()
    Wait(100)
    RageUI.CloseAll()
    RageUI.Visible(MainMenu, true)
end)

MainMenu.Closed = function()
    print("MainMenu closed")
    dprint("CharacterData", json.encode(CharacterData, {indent = true}))

    StopCharCreator()
    AVA.Player.CreatingChar = false
    CharacterSkin = exports.skinchanger:getSkin()
    TriggerServerEvent("ava_core:server:createdPlayer", {
        firstname = CharacterData.firstname,
        lastname = CharacterData.lastname,
        birthdate = CharacterData.birthdate,
        sex = CharacterData.sexIndex,
    }, CharacterSkin)

    -- clear some global variables
    bodyCam, faceCam, isCamOnFace = nil, nil, false
    CharacterSkin = nil
    CharacterData = nil
    playerPed = nil
    SkinMaxVals = nil
end

----------------------------------------
--------------- Cutscene ---------------
----------------------------------------

local function setPedData(ped, i)
    if i == 1 then
        SetPedHeadBlendData(ped, 21, 21, 21, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 57, 0, 2) -- hairs
        SetPedComponentVariation(ped, 3, 0, 0, 2) -- arms
        SetPedComponentVariation(ped, 4, 22, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 6, 0, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- tshirt_1
        SetPedComponentVariation(ped, 11, 260, 12, 2) -- torso
        SetPedHairColor(ped, 10, 21)
    elseif i == 2 then
        SetPedHeadBlendData(ped, 39, 39, 39, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 5, 4, 2) -- hairs
        SetPedComponentVariation(ped, 3, 1, 0, 2) -- arms
        SetPedComponentVariation(ped, 4, 10, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 10, 0, 2) -- shoes
        SetPedComponentVariation(ped, 7, 11, 2, 2) -- chain
        SetPedComponentVariation(ped, 8, 13, 6, 2) -- tshirt_1
        SetPedComponentVariation(ped, 11, 10, 0, 2) -- torso
        SetPedHairColor(ped, 35, 21)
    elseif i == 3 then
        SetPedHeadBlendData(ped, 34, 34, 34, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 1, 4, 2) -- hairs
        SetPedComponentVariation(ped, 3, 1, 0, 2) -- arms
        SetPedComponentVariation(ped, 4, 0, 1, 2) -- pants
        SetPedComponentVariation(ped, 6, 7, 4, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 16, 0, 2) -- tshirt_1
        SetPedComponentVariation(ped, 11, 6, 0, 2) -- torso
        SetPedHairColor(ped, 30, 21)
    elseif i == 4 then
        SetPedHeadBlendData(ped, 14, 14, 14, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 5, 3, 2) -- hairs
        SetPedComponentVariation(ped, 3, 5, 0, 2) -- arms
        SetPedComponentVariation(ped, 4, 15, 3, 2) -- pants
        SetPedComponentVariation(ped, 6, 7, 2, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- tshirt_1
        SetPedComponentVariation(ped, 11, 78, 3, 2) -- torso
        SetPedHairColor(ped, 10, 21)
    elseif i == 5 then
        SetPedHeadBlendData(ped, 39, 39, 39, 2, 2, 2, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 68, 0, 2) -- hairs
        SetPedComponentVariation(ped, 3, 0, 0, 2) -- arms
        SetPedComponentVariation(ped, 4, 12, 5, 2) -- pants
        SetPedComponentVariation(ped, 6, 6, 2, 2) -- shoes
        SetPedComponentVariation(ped, 7, 4, 3, 2) -- chain
        SetPedComponentVariation(ped, 8, 3, 0, 2) -- tshirt
        SetPedComponentVariation(ped, 11, 79, 2, 2) -- torso
        SetPedHairColor(ped, 10, 21)
    elseif i == 6 then
        SetPedHeadBlendData(ped, 27, 27, 27, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 7, 3, 2) -- hairs
        SetPedComponentVariation(ped, 3, 0, 0, 2) -- arms
        SetPedComponentVariation(ped, 4, 12, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 5, 2, 2) -- shoes
        SetPedComponentVariation(ped, 7, 5, 3, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- tshirt_1
        SetPedComponentVariation(ped, 11, 80, 2, 2) -- torso
        SetPedHairColor(ped, 29, 31)
    elseif i == 7 then
        SetPedHeadBlendData(ped, 33, 33, 33, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 73, 0, 2) -- hairs
        SetPedComponentVariation(ped, 3, 12, 0, 2) -- arms
        SetPedComponentVariation(ped, 4, 27, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 15, 3, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- tshirt_1
        SetPedComponentVariation(ped, 11, 283, 7, 2) -- torso
        SetPedHairColor(ped, 62, 0)
    end
    SetPedComponentVariation(ped, 1, 0, 0, 2) -- mask
    SetPedComponentVariation(ped, 5, 0, 0, 2) -- bags
    SetPedComponentVariation(ped, 9, 0, 0, 2) -- bproof
    SetPedComponentVariation(ped, 10, 0, 0, 2) -- decals
    ClearPedProp(ped, 0)
    ClearPedProp(ped, 1)
    ClearPedProp(ped, 2)
    ClearPedProp(ped, 3)
    ClearPedProp(ped, 4)
    ClearPedProp(ped, 5)
    ClearPedProp(ped, 6)
    ClearPedProp(ped, 7)
    ClearPedProp(ped, 8)
end

RegisterNetEvent("ava_core:client:joinCutScene", function()
    AVA.Player.CreatingChar = true
    DoScreenFadeOut(250)
    Wait(250)
    local playerPed = PlayerPedId()
    local isFemale = IsPedModel(playerPed, "mp_f_freemode_01")
    PrepareMusicEvent("FM_INTRO_START")
    TriggerMusicEvent("FM_INTRO_START")

    if isFemale then
        RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 103, 8)
    else
        RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 31, 8)
    end
    if CanRequestAssetsForCutsceneEntity() then
        if isFemale then
            SetCutsceneEntityStreamingFlags("MP_Female_Character", 0, 1);
        else
            SetCutsceneEntityStreamingFlags("MP_Male_Character", 0, 1);
        end
    end
    while not HasCutsceneLoaded() do
        Wait(10)
    end

    AVA.RequestModel("mp_f_freemode_01")
    AVA.RequestModel("mp_m_freemode_01")

    if isFemale then
        RegisterEntityForCutscene(0, "MP_Male_Character", 3, GetHashKey("mp_m_freemode_01"), 0)
        RegisterEntityForCutscene(playerPed, "MP_Female_Character", 0, 0, 0)
    else
        RegisterEntityForCutscene(playerPed, "MP_Male_Character", 0, 0, 0)
        RegisterEntityForCutscene(0, "MP_Female_Character", 3, GetHashKey("mp_f_freemode_01"), 0)
    end

    local peds = {}
    for i = 1, 7, 1 do
        SetCutsceneEntityStreamingFlags(("MP_Plane_Passenger_%d"):format(i), 0, 1)
        if i == 1 or i == 4 or i == 6 then
            peds[i] = CreatePed(26, GetHashKey("mp_m_freemode_01"), -1117.778, -1557.625, 3.3819, 0.0, 0, 0)
        else
            peds[i] = CreatePed(26, GetHashKey("mp_f_freemode_01"), -1117.778, -1557.625, 3.3819, 0.0, 0, 0)
        end
        if not IsEntityDead(peds[i]) then
            setPedData(peds[i], i)
            FinalizeHeadBlend(peds[i])
            RegisterEntityForCutscene(peds[i], ("MP_Plane_Passenger_%d"):format(i), 0, 0, 64)
        end
    end

    -- load scene to avoid texture missing
    NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0) -- tennis field

    -- START the custscene
    StartCutscene(4)
    DoScreenFadeIn(250)

    -- wait for the player to be close enough to the airport to load textures of it
    Wait(21420)
    if isFemale then
        -- load scene to avoid texture missing
        -- this is only needed if the player is a female
        -- I did not managed to figure out why
        NewLoadSceneStartSphere(-1042.89, -2746.54, 20.0, 1000, 0) -- airport
    end

    -- plane is on the floor, we remove peds and stop the music
    Wait(10000)

    for i = 1, 7, 1 do
        DeleteEntity(peds[i])
    end
    PrepareMusicEvent("AC_STOP")
    TriggerMusicEvent("AC_STOP")

    -- stop the scene right before Lamar comes, do it while the screen is faded out
    Wait(6120)
    DoScreenFadeOut(1000)
    Wait(1200)
    StopCutsceneImmediately()
    Wait(570)
    DoScreenFadeIn(1000)

    -- Teleport player back to its position
    AVA.Player.CreatingChar = false
    if AVA.Player.Data.position then
        SetEntityCoords(playerPed, AVA.Player.Data.position)
        SetEntityHeading(playerPed, 0.0)
    end
end)
