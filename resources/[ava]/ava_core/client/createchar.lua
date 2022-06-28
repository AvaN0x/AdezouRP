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

local MainMenu = RageUI.CreateMenu("", GetString("create_char_menu_title"), 0, 0, "avaui", "avaui_title_adezou")

---------------------------------------
--------------- Cameras ---------------
---------------------------------------
local bodyCam, faceCam, isCamOnFace = nil, nil, false
local lookAtCoordLeft, lookAtCoordRight, lookAtCoordFront = nil, nil, nil

local function StartCharCreator()
    bodyCam, faceCam, isCamOnFace = nil, nil, false

    DoScreenFadeOut(1000)
    Wait(2000)

    -- init cameras
    DestroyAllCams(true)

    bodyCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.92, -1000.72, -99.01, 0.00, 0.00, 0.00, 30.00, false, 0)
    faceCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.92, -1000.72, -98.45, 0.00, 0.00, 0.00, 10.00, false, 0)
    local zoomCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.99, -998.02, -99.00, 0.00, 0.00, 0.00, 50.00,
        false, 0)
    PointCamAtCoord(zoomCam, 402.99, -998.02, -99.00)

    SetCamActive(zoomCam, true)
    RenderScriptCams(true, false, 2000, true, true)

    Wait(500)

    -- set player position
    DoScreenFadeIn(2000)
    RequestCollisionAtCoord(405.59, -997.18, -99.00)
    SetEntityCoords(playerPed, 405.59, -997.18, -99.00, 0.0, 0.0, 0.0, true)
    SetEntityHeading(playerPed, 90.00)

    Wait(500)

    -- zoom animation on cameras from zoomCam to bodyCam
    SetCamActiveWithInterp(bodyCam, zoomCam, 5000, true, true)

    -- play anim for player to move on the right place
    while not HasAnimDictLoaded("mp_character_creation@customise@male_a") do
        RequestAnimDict("mp_character_creation@customise@male_a")
        Wait(10)
    end
    TaskPlayAnim(playerPed, "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 4000, 0, 1, 0, 0, 0)
    RemoveAnimDict("mp_character_creation@customise@male_a")

    Wait(5000)

    -- set precise position to the player
    if #(GetEntityCoords(playerPed) - vector3(402.89, -996.87, -99.0)) > 0.5 then
        SetEntityCoords(playerPed, 402.89, -996.87, -99.0, 0.0, 0.0, 0.0, true)
        SetEntityHeading(playerPed, 173.97)
    end

    Wait(1000)
    FreezeEntityPosition(playerPed, true)

    lookAtCoordLeft, lookAtCoordRight, lookAtCoordFront = GetOffsetFromEntityInWorldCoords(playerPed, 1.2, 0.5, 0.7),
        GetOffsetFromEntityInWorldCoords(playerPed, -1.2, 0.5, 0.7),
        GetOffsetFromEntityInWorldCoords(playerPed, 0, 0.5, 0.7)
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
    TaskClearLookAt(playerPed)

    Wait(1000)

    DisplayRadar(true)
    DoScreenFadeIn(1000)

    DestroyAllCams(true)
end

-------------------------------------
--------------- MENUS ---------------
-------------------------------------

local function ValidateData()
    local hadError = false
    if not CharacterData.firstname or CharacterData.firstname == "" or not CharacterData.lastname or
        CharacterData.lastname == "" or not CharacterData.birthdate
        or CharacterData.birthdate == "" or not AVA.Utils.IsDateValid(CharacterData.birthdate) then
        hadError = true
        AVA.ShowNotification(GetString("create_char_data_not_valid"), nil, "ava_core_logo",
            GetString("create_char_data_not_valid_title"), nil, nil,
            "ava_core_logo")
    end
    if CharacterData.selectedOutfit == 0 then
        hadError = true
        AVA.ShowNotification(GetString("create_char_did_not_select_outfit"), nil, "ava_core_logo",
            GetString("create_char_data_not_valid_title"), nil, nil,
            "ava_core_logo")
    end

    return not hadError
end

-- don't touch these lists
local MotherList = {
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
local MotherListId = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45 }

local FatherList = {
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
local FatherListId = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44 }
local MotherIndex, FatherIndex, Resemblance, SkinTone = 1, 1, 10, 10

local Outfits = {
    -- Male
    [0] = {
        -- Default outfit
        [0] = {
            outfit = {
                gender = 0,
                tops = 15,
                tops_txd = 0,
                torso = 15,
                torso_txd = 0,
                undershirt = 15,
                undershirt_txd = 0,
                leg = 61,
                leg_txd = 1,
                hats = -1,
                hats_txd = 0,
                shoes = 5,
                shoes_txd = 0,
            },
        },

        [1] = {
            outfit = {
                gender = 0,
                tops = 0,
                tops_txd = 1,
                torso = 0,
                torso_txd = 0,
                undershirt = 15,
                undershirt_txd = 0,
                leg = 62,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 16,
                shoes_txd = 5,
            },
            label = GetString("outfit_short_tshirt"),
        },
        [2] = {
            outfit = {
                gender = 0,
                tops = 0,
                tops_txd = 5,
                torso = 0,
                torso_txd = 0,
                undershirt = 15,
                undershirt_txd = 0,
                leg = 63,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 22,
                shoes_txd = 0,
            },
            label = GetString("outfit_lambda"),
        },
        [3] = {
            outfit = {
                gender = 0,
                tops = 7,
                tops_txd = 13,
                torso = 6,
                torso_txd = 0,
                undershirt = 5,
                undershirt_txd = 0,
                leg = 64,
                leg_txd = 2,
                hats = -1,
                hats_txd = 0,
                shoes = 9,
                shoes_txd = 3,
            },
            label = GetString("outfit_jogging"),
        },
        [4] = {
            outfit = {
                gender = 0,
                tops = 72,
                tops_txd = 2,
                torso = 6,
                torso_txd = 0,
                undershirt = 13,
                undershirt_txd = 0,
                leg = 48,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 10,
                shoes_txd = 7,
            },
            label = GetString("outfit_businessman"),
        },
        [5] = {
            outfit = {
                gender = 0,
                tops = 167,
                tops_txd = 0,
                torso = 6,
                torso_txd = 0,
                undershirt = 47,
                undershirt_txd = 0,
                leg = 98,
                leg_txd = 1,
                hats = -1,
                hats_txd = 0,
                shoes = 54,
                shoes_txd = 3,
            },
            label = GetString("outfit_winter"),
        },
    },

    -- Female
    [1] = {
        -- Default outfit
        [0] = {
            outfit = {
                gender = 1,
                tops = 15,
                tops_txd = 0,
                torso = 15,
                torso_txd = 0,
                undershirt = 14,
                undershirt_txd = 0,
                leg = 15,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 5,
                shoes_txd = 0,
                glasses = -1,
                glasses_txd = 0,
            },
        },

        [1] = {
            outfit = {
                gender = 1,
                tops = 0,
                tops_txd = 2,
                torso = 0,
                torso_txd = 0,
                undershirt = 14,
                undershirt_txd = 0,
                leg = 25,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 1,
                shoes_txd = 0,
                glasses = -1,
                glasses_txd = 0,
            },
            label = GetString("outfit_short_tshirt"),
        },
        [2] = {
            outfit = {
                gender = 1,
                tops = 2,
                tops_txd = 0,
                torso = 2,
                torso_txd = 0,
                undershirt = 14,
                undershirt_txd = 0,
                leg = 2,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 1,
                shoes_txd = 0,
                glasses = -1,
                glasses_txd = 0,
            },
            label = GetString("outfit_lambda"),
        },
        [3] = {
            outfit = {
                gender = 1,
                tops = 4,
                tops_txd = 14,
                torso = 4,
                torso_txd = 0,
                undershirt = 14,
                undershirt_txd = 0,
                leg = 2,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 1,
                shoes_txd = 0,
                glasses = -1,
                glasses_txd = 0,
            },
            label = GetString("outfit_jogging"),
        },
        [4] = {
            outfit = {
                gender = 1,
                tops = 7,
                tops_txd = 4,
                torso = 6,
                torso_txd = 0,
                undershirt = 20,
                undershirt_txd = 1,
                leg = 6,
                leg_txd = 0,
                hats = -1,
                hats_txd = 0,
                shoes = 6,
                shoes_txd = 0,
                glasses = -1,
                glasses_txd = 0,
            },
            label = GetString("outfit_businesswoman"),
        },
        [5] = {
            outfit = {
                gender = 1,
                tops = 64,
                tops_txd = 0,
                torso = 6,
                torso_txd = 0,
                undershirt = 20,
                undershirt_txd = 0,
                leg = 73,
                leg_txd = 5,
                hats = -1,
                hats_txd = 0,
                shoes = 8,
                shoes_txd = 0,
                glasses = -1,
                glasses_txd = 0,
            },
            label = GetString("outfit_winter"),
        },
    },
}

local SexList = { GetString("create_char_sex_man"), GetString("create_char_sex_woman") }
MainMenu.Closable = false

local SubMenuIdentity = RageUI.CreateSubMenu(MainMenu, "", GetString("menu_title_identity"))

local SubMenuHeritage = RageUI.CreateSubMenu(MainMenu, "", GetString("menu_title_heritage"))
SubMenuHeritage:AddInstructionButton({ GetControlGroupInstructionalButton(2, 14, 0), GetString("turn_face") })
SubMenuHeritage.Closed = function()
    ToggleCamOnFace(false)
    TaskClearLookAt(playerPed)
    exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end

local SubMenuFace = RageUI.CreateSubMenu(MainMenu, "", GetString("menu_title_face"))
SubMenuFace.EnableMouse = true
SubMenuFace:AddInstructionButton({ GetControlGroupInstructionalButton(2, 14, 0), GetString("turn_face") })
SubMenuFace.Closed = function()
    ToggleCamOnFace(false)
    TaskClearLookAt(playerPed)
    exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end

local SubMenuAppearance = RageUI.CreateSubMenu(MainMenu, "", GetString("menu_title_appearance"))
SubMenuAppearance:AddInstructionButton({ GetControlGroupInstructionalButton(2, 14, 0), GetString("turn_face") })
SubMenuAppearance.EnableMouse = true
SubMenuAppearance.Closed = function()
    ToggleCamOnFace(false)
    TaskClearLookAt(playerPed)
    exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
end

local SubMenuOutfits = RageUI.CreateSubMenu(MainMenu, "", GetString("menu_title_outfits"))
local DisplayedOutfit = 0
SubMenuOutfits.Closed = function()
    exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][CharacterData.selectedOutfit].outfit)
    DisplayedOutfit = CharacterData.selectedOutfit
end

local function TurnHead()
    if (IsDisabledControlPressed(0, 205)) then -- INPUT_FRONTEND_LB
        TaskLookAtCoord(playerPed, lookAtCoordLeft, 2000, 0, 2)
    elseif (IsDisabledControlPressed(0, 206)) then -- INPUT_FRONTEND_RB
        TaskLookAtCoord(playerPed, lookAtCoordRight, 2000, 0, 2)
    else
        TaskLookAtCoord(playerPed, lookAtCoordFront, 2000, 0, 2)
    end
end

function RageUI.PoolMenus:AvaCoreCreateChar()
    MainMenu:IsVisible(function(Items)
        Items:AddList(GetString("create_char_gender"), SexList, CharacterData.sexIndex + 1, nil, {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.sexIndex = Index - 1
                    CharacterData.Face = {}
                    CharacterData.Appearance = {}
                    CharacterData.selectedOutfit = 0
                    MotherIndex, FatherIndex, Resemblance, SkinTone = 1, 1, 10, 10
                    exports.ava_mp_peds:reset()
                    CharacterSkin = exports.ava_mp_peds:setPlayerSkin(Outfits[CharacterData.sexIndex][0].outfit)
                    SkinMaxVals = exports.ava_mp_peds:getMaxValues()
                    playerPed = PlayerPedId()
                end
            end)

        Items:AddButton(GetString("menu_title_identity"), "", { RightLabel = "→→→" }, nil, SubMenuIdentity)

        Items:AddButton(GetString("menu_title_heritage"), "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][0].outfit)
                playerPed = PlayerPedId()
            end
        end, SubMenuHeritage)

        Items:AddButton(GetString("menu_title_face"), "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][0].outfit)
                playerPed = PlayerPedId()
            end
        end, SubMenuFace)

        Items:AddButton(GetString("menu_title_appearance"), "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                ToggleCamOnFace(true)
                exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][0].outfit)
                playerPed = PlayerPedId()
            end
        end, SubMenuAppearance)

        Items:AddButton(GetString("menu_title_outfits"), "", { RightLabel = "→→→" }, nil, SubMenuOutfits)

        Items:AddButton(GetString("create_char_save_and_submit"), nil,
            { Color = { BackgroundColor = RageUI.ItemsColour.MenuYellow,
                HighLightColor = RageUI.ItemsColour.PmMitemHighlight } }, function(onSelected)
            if onSelected and ValidateData() then
                RageUI.CloseAllInternal()
            end
        end)
    end)

    SubMenuIdentity:IsVisible(function(Items)
        Items:AddButton(GetString("identity_firstname"), GetString("50_char_max"),
            { RightLabel = CharacterData.firstname }
            , function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput(GetString("identity_firstname_input"), "", 50)
                if result and result ~= "" then
                    CharacterData.firstname = result
                end
            end
        end)
        Items:AddButton(GetString("identity_lastname"), GetString("50_char_max"), { RightLabel = CharacterData.lastname }
            , function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput(GetString("identity_lastname_input"), "", 50)
                if result and result ~= "" then
                    CharacterData.lastname = result
                end
            end
        end)
        Items:AddButton(GetString("birthdate"), GetString("birthdate_subtitle"), { RightLabel = CharacterData.birthdate }
            , function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput(GetString("birthday_input"), "", 10)
                if result and result ~= "" then
                    if not string.find(result, "%d%d?/%d%d?/%d%d%d%d") then
                        AVA.ShowNotification(GetString("birthday_format_is_not_the_right_one"), nil, "ava_core_logo",
                            GetString("birthdate"), nil, nil,
                            "ava_core_logo")
                    elseif not AVA.Utils.IsDateValid(result) then
                        AVA.ShowNotification(GetString("birthday_not_valid"), nil, "ava_core_logo",
                            GetString("birthdate"), nil, nil, "ava_core_logo")
                    else
                        CharacterData.birthdate = result
                    end
                end
            end
        end)
    end)

    SubMenuHeritage:IsVisible(function(Items)
        TurnHead()

        Items:Heritage(MotherIndex - 1, FatherIndex - 1)
        Items:AddList(GetString("mother"), MotherList, MotherIndex, GetString("mother_subtitle"), {},
            function(Index, onSelected, onListChange)
                if onListChange then
                    MotherIndex = Index
                    exports.ava_mp_peds:setPlayerSkin({ mother = MotherListId[MotherIndex] })
                end
            end)
        Items:AddList(GetString("father"), FatherList, FatherIndex, GetString("father_subtitle"), {},
            function(Index, onSelected, onListChange)
                if onListChange then
                    FatherIndex = Index
                    exports.ava_mp_peds:setPlayerSkin({ father = FatherListId[FatherIndex] })
                end
            end)
        Items:SliderHeritage(GetString("resemblance"), Resemblance, GetString("resemblance_subtitle"),
            function(Selected, Active, OnListChange, SliderIndex, Percent)
                if OnListChange then
                    Resemblance = SliderIndex
                    exports.ava_mp_peds:setPlayerSkin({ shape_mix = Percent })
                end
            end)
        Items:SliderHeritage(GetString("skin_tone"), SkinTone, GetString("skin_tone_subtitle"),
            function(Selected, Active, OnListChange, SliderIndex, Percent)
                if OnListChange then
                    SkinTone = SliderIndex
                    exports.ava_mp_peds:setPlayerSkin({ skin_mix = Percent })
                end
            end)
    end)

    SubMenuFace:IsVisible(function(Items)
        TurnHead()

        Items:AddButton(GetString("forehead"), GetString("edit_your_face"))
        Items:AddButton(GetString("eyes"), GetString("edit_your_face"))
        Items:AddButton(GetString("nose"), GetString("edit_your_face"))
        Items:AddButton(GetString("nosebone"), GetString("edit_your_face"))
        Items:AddButton(GetString("nosepeak"), GetString("edit_your_face"))
        Items:AddButton(GetString("cheekbone"), GetString("edit_your_face"))
        Items:AddButton(GetString("cheek"), GetString("edit_your_face"))
        Items:AddButton(GetString("lips"), GetString("edit_your_face"))
        Items:AddButton(GetString("jaw"), GetString("edit_your_face"))
        Items:AddButton(GetString("chin"), GetString("edit_your_face"))
        Items:AddButton(GetString("chinshape"), GetString("edit_your_face"))
        Items:AddButton(GetString("neck"), GetString("edit_your_face"))
    end, function(Panels)
        Panels:Grid(CharacterData.Face.ForeHeadX or 0.5, CharacterData.Face.ForeHeadY or 0.5, GetString("top"),
            GetString("bottom"), GetString("inside"),
            GetString("outside"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.ForeHeadX = X
                CharacterData.Face.ForeHeadY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ eyebrow_forward = CharacterX * 100,
                    eyebrow_high = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 7, CharacterX) -- eyebrow_forward
                SetPedFaceFeature(playerPed, 6, CharacterY) -- eyebrow_high
            end, 1)

        Panels:GridHorizontal(CharacterData.Face.Eyes or 0.5, GetString("eyes_pleated"), GetString("eyes_open"),
            function(X, _, CharacterX)
                CharacterData.Face.Eyes = X
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ eyes_openning = (1 - CharacterX) * 100 })
                SetPedFaceFeature(playerPed, 11, (1 - CharacterX)) -- eyes_openning
            end, 2)

        Panels:Grid(CharacterData.Face.NoseX or 0.5, CharacterData.Face.NoseY or 0.5, GetString("top"),
            GetString("bottom"), GetString("thin"),
            GetString("thick"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.NoseX = X
                CharacterData.Face.NoseY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ nose_width = CharacterX * 100,
                    nose_peak_hight = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 0, CharacterX) -- nose_width
                SetPedFaceFeature(playerPed, 1, CharacterY) -- nose_peak_hight
            end, 3)

        Panels:Grid(CharacterData.Face.NoseBoneX or 0.5, CharacterData.Face.NoseBoneY or 0.5, GetString("nosebone_top"),
            GetString("nosebone_bottom"),
            GetString("nosebone_right"), GetString("nosebone_left"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.NoseBoneX = X
                CharacterData.Face.NoseBoneY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ nose_peak_lenght = (1 - CharacterX) * 100,
                    nose_bone_high = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 2, (1 - CharacterX)) -- nose_peak_lenght
                SetPedFaceFeature(playerPed, 3, CharacterY) -- nose_bone_high
            end, 4)

        Panels:Grid(CharacterData.Face.NosePeakX or 0.5, CharacterData.Face.NosePeakY or 0.5, GetString("nosepeak_top"),
            GetString("nosepeak_bottom"),
            GetString("nosepeak_right"), GetString("nosepeak_left"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.NosePeakX = X
                CharacterData.Face.NosePeakY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ nose_bone_twist = CharacterX * -100,
                    nose_peak_lowering = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 5, CharacterX * -1) -- nose_bone_twist
                SetPedFaceFeature(playerPed, 4, CharacterY) -- nose_peak_lowering
            end, 5)

        Panels:Grid(CharacterData.Face.CheekBoneX or 0.5, CharacterData.Face.CheekBoneY or 0.5, GetString("top"),
            GetString("bottom"), GetString("inside"),
            GetString("outside"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.CheekBoneX = X
                CharacterData.Face.CheekBoneY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ cheeks_bone_width = CharacterX * 100,
                    cheeks_bone_high = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 9, CharacterX) -- cheeks_bone_width
                SetPedFaceFeature(playerPed, 8, CharacterY) -- cheeks_bone_high
            end, 6)

        Panels:GridHorizontal(CharacterData.Face.Cheek or 0.5, GetString("cheek_left"), GetString("cheek_right"),
            function(X, _, CharacterX)
                CharacterData.Face.Cheek = X
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ cheeks_width = (1 - CharacterX) * 100 })
                SetPedFaceFeature(playerPed, 10, (1 - CharacterX)) -- cheeks_width
            end, 7)

        Panels:GridHorizontal(CharacterData.Face.Lips or 0.5, GetString("lips_left"), GetString("lips_right"),
            function(X, _, CharacterX)
                CharacterData.Face.Lips = X
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ lips_thickness = (1 - CharacterX) * 100 })
                SetPedFaceFeature(playerPed, 12, (1 - CharacterX)) -- lips_thickness
            end, 8)

        Panels:Grid(CharacterData.Face.JawX or 0.5, CharacterData.Face.JawY or 0.5, GetString("jaw_top"),
            GetString("jaw_bottom"), GetString("jaw_right"),
            GetString("jaw_left"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.JawX = X
                CharacterData.Face.JawY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ jaw_bone_width = CharacterX * 100,
                    jaw_bone_back_lenght = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 13, CharacterX) -- jaw_bone_width
                SetPedFaceFeature(playerPed, 14, CharacterY) -- jaw_bone_back_lenght
            end, 9)

        Panels:Grid(CharacterData.Face.ChinX or 0.5, CharacterData.Face.ChinY or 0.5, GetString("top"),
            GetString("bottom"), GetString("inside"),
            GetString("outside"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.ChinX = X
                CharacterData.Face.ChinY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ chin_bone_lenght = CharacterX * 100,
                    chin_bone_lowering = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 16, CharacterX) -- chin_bone_lenght
                SetPedFaceFeature(playerPed, 15, CharacterY) -- chin_bone_lowering
            end, 10)

        Panels:Grid(CharacterData.Face.ChinShapeX or 0.5, CharacterData.Face.ChinShapeY or 0.5,
            GetString("chinshape_top"), GetString("chinshape_bottom"),
            GetString("chinshape_right"), GetString("chinshape_left"), function(X, Y, CharacterX, CharacterY)
                CharacterData.Face.ChinShapeX = X
                CharacterData.Face.ChinShapeY = Y
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ chin_bone_width = (1 - CharacterX) * 100,
                    chin_hole = CharacterY * 100 })
                SetPedFaceFeature(playerPed, 17, (1 - CharacterX)) -- chin_bone_width
                SetPedFaceFeature(playerPed, 18, CharacterY) -- chin_hole
            end, 11)

        Panels:GridHorizontal(CharacterData.Face.Neck or 0.5, GetString("thin"), GetString("thick"),
            function(X, _, CharacterX)
                CharacterData.Face.Neck = X
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ neck_thickness = CharacterX * 100 })
                SetPedFaceFeature(playerPed, 19, CharacterX) -- lips_thickness
            end, 12)
    end)

    SubMenuAppearance:IsVisible(function(Items)
        TurnHead()

        Items:AddList(GetString("hair"), (SkinMaxVals.hair or -1) + 1, CharacterData.Appearance.HairCutIndex or 1,
            GetString("change_your_appearance"), {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.HairCutIndex = Index

                    CharacterSkin.hair = Index - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ hair = Index - 1 })
                    exports.ava_mp_peds:reloadPedOverlays(playerPed)
                    SetPedComponentVariation(playerPed, 2, CharacterSkin.hair, CharacterSkin.hair_txd, 2)
                    SkinMaxVals.hair_txd = GetNumberOfPedTextureVariations(playerPed, 2, CharacterSkin.hair) - 1
                end
            end)
        Items:AddList(GetString("eyebrows"), (SkinMaxVals.eyebrows or -1) + 1,
            CharacterData.Appearance.EyeBrowsIndex or 1, GetString("change_your_appearance"),
            {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.Appearance.EyeBrowsIndex = Index

                CharacterSkin.eyebrows = Index - 1
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ eyebrows = Index - 1 })
                SetPedHeadOverlay(playerPed, 2, CharacterSkin.eyebrows, (CharacterSkin.eyebrows_op / 100) + 0.0)
            end
        end)
        Items:AddList(GetString("beard"), (SkinMaxVals.beard or -1) + 1, CharacterData.Appearance.BeardIndex or 1,
            GetString("change_your_appearance"), {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.BeardIndex = Index

                    CharacterSkin.beard = Index - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ beard = Index - 1 })
                    SetPedHeadOverlay(playerPed, 1, CharacterSkin.beard, (CharacterSkin.beard_op / 100) + 0.0)
                end
            end)
        Items:AddList(GetString("blemishes"), (SkinMaxVals.blemishes or -1) + 1,
            CharacterData.Appearance.BlemishesIndex or 1,
            GetString("change_your_appearance"), {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.Appearance.BlemishesIndex = Index

                CharacterSkin.blemishes = Index - 1
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ blemishes = Index - 1 })
                SetPedHeadOverlay(playerPed, 0, CharacterSkin.blemishes, (CharacterSkin.blemishes_op / 100) + 0.0)
            end
        end)
        Items:AddList(GetString("age"), (SkinMaxVals.ageing or -1) + 1, CharacterData.Appearance.SkinAgingIndex or 1,
            GetString("change_your_appearance"), {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.SkinAgingIndex = Index

                    CharacterSkin.ageing = Index - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ ageing = Index - 1 })
                    SetPedHeadOverlay(playerPed, 3, CharacterSkin.ageing, (CharacterSkin.ageing_op / 100) + 0.0)
                end
            end)
        Items:AddList(GetString("complexion"), (SkinMaxVals.complexion or -1) + 1,
            CharacterData.Appearance.ComplexionIndex or 1,
            GetString("change_your_appearance"), {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.Appearance.ComplexionIndex = Index

                CharacterSkin.complexion = Index - 1
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ complexion = Index - 1 })
                SetPedHeadOverlay(playerPed, 6, CharacterSkin.complexion, (CharacterSkin.complexion_op / 100) + 0.0)
            end
        end)
        Items:AddList(GetString("moles"), (SkinMaxVals.moles or -1) + 1, CharacterData.Appearance.MolesIndex or 1,
            GetString("change_your_appearance"), {},
            function(Index, onSelected, onListChange)
                if (onListChange) then
                    CharacterData.Appearance.MolesIndex = Index

                    CharacterSkin.moles = Index - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ moles = Index - 1 })
                    SetPedHeadOverlay(playerPed, 9, CharacterSkin.moles, (CharacterSkin.moles_op / 100) + 0.0)
                end
            end)
        Items:AddList(GetString("sun"), (SkinMaxVals.sundamage or -1) + 1, CharacterData.Appearance.SkinDamageIndex or 1
            , GetString("change_your_appearance"),
            {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.Appearance.SkinDamageIndex = Index

                CharacterSkin.sundamage = Index - 1
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ sundamage = Index - 1 })
                SetPedHeadOverlay(playerPed, 7, CharacterSkin.sundamage, (CharacterSkin.sundamage_op / 100) + 0.0)
            end
        end)
        Items:AddList(GetString("eyes_color"), (SkinMaxVals.eyes_color or -1) + 1,
            CharacterData.Appearance.EyeColorIndex or 1,
            GetString("change_your_appearance"), {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.Appearance.EyeColorIndex = Index

                CharacterSkin.eyes_color = Index - 1
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ eyes_color = Index - 1 })
                SetPedEyeColor(playerPed, CharacterSkin.eyes_color, 0, 1)
            end
        end)
        Items:AddList(GetString("makeup"), (SkinMaxVals.makeup or -1) + 1, CharacterData.Appearance.EyeMakeupIndex or 1,
            GetString("change_your_appearance"),
            {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.Appearance.EyeMakeupIndex = Index

                CharacterSkin.makeup = Index - 1
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ makeup = Index - 1 })
                SetPedHeadOverlay(playerPed, 4, CharacterSkin.makeup, (CharacterSkin.makeup_op / 100) + 0.0)
            end
        end)
        Items:AddList(GetString("lipstick"), (SkinMaxVals.lipstick or -1) + 1,
            CharacterData.Appearance.LipstickIndex or 1, GetString("change_your_appearance"),
            {}, function(Index, onSelected, onListChange)
            if (onListChange) then
                CharacterData.Appearance.LipstickIndex = Index

                CharacterSkin.lipstick = Index - 1
                exports.ava_mp_peds:editPlayerSkinWithoutApplying({ lipstick = Index - 1 })
                SetPedHeadOverlay(playerPed, 8, CharacterSkin.lipstick, (CharacterSkin.lipstick_op / 100) + 0.0)
            end
        end)

    end, function(Panels)
        if CharacterSkin.hair ~= 0 then
            Panels:ColourPanel(GetString("color"), RageUI.PanelColour.HairCut, CharacterData.Appearance.HairColorMin or 1
                ,
                CharacterData.Appearance.HairColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.HairColorMin = MinimumIndex
                    CharacterData.Appearance.HairColorIndex = CurrentIndex

                    CharacterSkin.hair_main_color = CurrentIndex - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ hair_main_color = CurrentIndex - 1 })
                    exports.ava_mp_peds:reloadPedOverlays(playerPed)
                    SetPedHairColor(playerPed, CharacterSkin.hair_main_color, CharacterSkin.hair_scnd_color)
                end, 1)
            Panels:ColourPanel(GetString("wicks_color"), RageUI.PanelColour.HairCut,
                CharacterData.Appearance.HairColor2Min or 1,
                CharacterData.Appearance.HairColor2Index or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.HairColor2Min = MinimumIndex
                    CharacterData.Appearance.HairColor2Index = CurrentIndex

                    CharacterSkin.hair_scnd_color = CurrentIndex - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ hair_scnd_color = CurrentIndex - 1 })
                    exports.ava_mp_peds:reloadPedOverlays(playerPed)
                    SetPedHairColor(playerPed, CharacterSkin.hair_main_color, CharacterSkin.hair_scnd_color)
                end, 1)
        end

        Panels:PercentagePanel(CharacterData.Appearance.EyeBrowsOpacity or 0.5, nil, nil, nil, function(Percent)
            CharacterData.Appearance.EyeBrowsOpacity = Percent

            CharacterSkin.eyebrows_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ eyebrows_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 2, CharacterSkin.eyebrows, (CharacterSkin.eyebrows_op / 100) + 0.0)
        end, 2)
        if CharacterSkin.eyebrows_op > 0 then
            Panels:ColourPanel(GetString("color"), RageUI.PanelColour.HairCut,
                CharacterData.Appearance.EyeBrowsColorMin or 1,
                CharacterData.Appearance.EyeBrowsColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.EyeBrowsColorMin = MinimumIndex
                    CharacterData.Appearance.EyeBrowsColorIndex = CurrentIndex

                    CharacterSkin.eyebrows_color = CurrentIndex - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ eyebrows_color = CurrentIndex - 1 })
                    SetPedHeadOverlayColor(playerPed, 2, 1, CharacterSkin.eyebrows_color, CharacterSkin.eyebrows_4)
                end, 2)
        end

        Panels:PercentagePanel(CharacterData.Appearance.BodyHairsOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.BodyHairsOpacity = Percent

            CharacterSkin.beard_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ beard_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 1, CharacterSkin.beard, (CharacterSkin.beard_op / 100) + 0.0)
        end, 3)
        if CharacterSkin.beard_op > 0 then
            Panels:ColourPanel(GetString("color"), RageUI.PanelColour.HairCut,
                CharacterData.Appearance.BodyHairsColorMin or 1,
                CharacterData.Appearance.BodyHairsColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.BodyHairsColorMin = MinimumIndex
                    CharacterData.Appearance.BodyHairsColorIndex = CurrentIndex

                    CharacterSkin.beard_color = CurrentIndex - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ beard_color = CurrentIndex - 1 })
                    SetPedHeadOverlayColor(playerPed, 1, 1, CharacterSkin.beard_color, CharacterSkin.beard_4)
                end, 3)
        end

        Panels:PercentagePanel(CharacterData.Appearance.BlemishesOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.BlemishesOpacity = Percent

            CharacterSkin.blemishes_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ blemishes_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 0, CharacterSkin.blemishes, (CharacterSkin.blemishes_op / 100) + 0.0)
        end, 4)

        Panels:PercentagePanel(CharacterData.Appearance.SkinAgingOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.SkinAgingOpacity = Percent

            CharacterSkin.ageing_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ ageing_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 3, CharacterSkin.ageing, (CharacterSkin.ageing_op / 100) + 0.0)
        end, 5)

        Panels:PercentagePanel(CharacterData.Appearance.ComplexionOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.ComplexionOpacity = Percent

            CharacterSkin.complexion_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ complexion_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 6, CharacterSkin.complexion, (CharacterSkin.complexion_op / 100) + 0.0)
        end, 6)

        Panels:PercentagePanel(CharacterData.Appearance.MolesOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.MolesOpacity = Percent

            CharacterSkin.moles_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ moles_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 9, CharacterSkin.moles, (CharacterSkin.moles_op / 100) + 0.0)
        end, 7)

        Panels:PercentagePanel(CharacterData.Appearance.SkinDamageOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.SkinDamageOpacity = Percent

            CharacterSkin.sundamage_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ sundamage_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 7, CharacterSkin.sundamage, (CharacterSkin.sundamage_op / 100) + 0.0)
        end, 8)

        Panels:PercentagePanel(CharacterData.Appearance.EyeMakeupOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.EyeMakeupOpacity = Percent

            CharacterSkin.makeup_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ makeup_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 4, CharacterSkin.makeup, (CharacterSkin.makeup_op / 100) + 0.0)
        end, 10)
        if CharacterSkin.makeup_op > 0 then
            -- TODO update PanelColour list of colours to a valid one
            Panels:ColourPanel(GetString("color"), RageUI.PanelColour.Makeup,
                CharacterData.Appearance.EyeMakeupColorMin or 1,
                CharacterData.Appearance.EyeMakeupColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.EyeMakeupColorMin = MinimumIndex
                    CharacterData.Appearance.EyeMakeupColorIndex = CurrentIndex

                    CharacterSkin.makeup_main_color = CurrentIndex - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ makeup_main_color = CurrentIndex - 1 })
                    SetPedHeadOverlayColor(playerPed, 4, 2, CharacterSkin.makeup_main_color,
                        CharacterSkin.makeup_scnd_color)
                end, 10)
            -- TODO update PanelColour list of colours to a valid one
            Panels:ColourPanel("Couleur 2", RageUI.PanelColour.Makeup, CharacterData.Appearance.EyeMakeupColor2Min or 1,
                CharacterData.Appearance.EyeMakeupColor2Index or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.EyeMakeupColor2Min = MinimumIndex
                    CharacterData.Appearance.EyeMakeupColor2Index = CurrentIndex

                    CharacterSkin.makeup_scnd_color = CurrentIndex - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ makeup_scnd_color = CurrentIndex - 1 })
                    SetPedHeadOverlayColor(playerPed, 4, 2, CharacterSkin.makeup_main_color,
                        CharacterSkin.makeup_scnd_color)
                end, 10)
        end

        Panels:PercentagePanel(CharacterData.Appearance.LipstickOpacity or 0.0, nil, nil, nil, function(Percent)
            CharacterData.Appearance.LipstickOpacity = Percent

            CharacterSkin.lipstick_op = Percent * 100
            exports.ava_mp_peds:editPlayerSkinWithoutApplying({ lipstick_op = Percent * 100 })
            SetPedHeadOverlay(playerPed, 8, CharacterSkin.lipstick, (CharacterSkin.lipstick_op / 100) + 0.0)
        end, 11)
        if CharacterSkin.lipstick_op > 0 then
            -- TODO update PanelColour list of colours to a valid one
            Panels:ColourPanel(GetString("color"), RageUI.PanelColour.Makeup,
                CharacterData.Appearance.LipstickColorMin or 1,
                CharacterData.Appearance.LipstickColorIndex or 1, function(MinimumIndex, CurrentIndex)
                    CharacterData.Appearance.LipstickColorMin = MinimumIndex
                    CharacterData.Appearance.LipstickColorIndex = CurrentIndex

                    CharacterSkin.lipstick_color = CurrentIndex - 1
                    exports.ava_mp_peds:editPlayerSkinWithoutApplying({ lipstick_color = CurrentIndex - 1 })
                    SetPedHeadOverlayColor(playerPed, 8, 1, CharacterSkin.lipstick_color,
                        CharacterSkin.lipstick_scnd_color)
                end, 11)
        end
    end)

    SubMenuOutfits:IsVisible(function(Items)
        for i = 1, #Outfits[CharacterData.sexIndex], 1 do
            Items:AddButton(Outfits[CharacterData.sexIndex][i].label or GetString("outfit"), GetString("outfit_subtitle")
                ,
                { RightBadge = (CharacterData.selectedOutfit == i and RageUI.BadgeStyle.Clothes or nil) },
                function(onSelected, onEntered)
                    if onEntered and DisplayedOutfit ~= i then
                        DisplayedOutfit = i
                        exports.ava_mp_peds:setPlayerClothes(Outfits[CharacterData.sexIndex][DisplayedOutfit].outfit)
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
    AVA.Player.Loaded = false

    -- If player did not already spawned, then we have to do it here
    if not AVA.Player.HasSpawned then
        exports.spawnmanager:spawnPlayer({
            x = 405.59,
            y = -997.18,
            z = -99.00,
            heading = 0.0,
            model = GetHashKey('mp_m_freemode_01'),
            skipFade = false
        })
        while not AVA.Player.HasSpawned do
            Wait(10)
        end

        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end

    RageUI.CloseAll()

    CharacterData = { firstname = "", lastname = "", sexIndex = 0, birthdate = "", selectedOutfit = 0, Face = {},
        Appearance = {} }

    exports.ava_mp_peds:reset()
    CharacterSkin = exports.ava_mp_peds:setPlayerSkin(Outfits[0][0].outfit)
    exports.ava_mp_peds:reloadPedOverlays(PlayerPedId())
    SkinMaxVals = exports.ava_mp_peds:getMaxValues()

    MotherIndex, FatherIndex, Resemblance, SkinTone, DisplayedOutfit = 1, 1, 10, 10, 0

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

    playerPed = PlayerPedId()
    StartCharCreator()

    SkinMaxVals = exports.ava_mp_peds:getMaxValues()
    Wait(100)
    RageUI.CloseAll()
    RageUI.Visible(MainMenu, true)
end)

MainMenu.Closed = function()
    print("MainMenu closed")
    dprint("CharacterData", json.encode(CharacterData, { indent = true }))

    StopCharCreator()
    AVA.Player.CreatingChar = false
    CharacterSkin = exports.ava_mp_peds:getPlayerCurrentSkin()

    local mugshot = exports.MugShotBase64:GetMugShotBase64(PlayerPedId())
    TriggerServerEvent("ava_core:server:createdPlayer", {
        firstname = CharacterData.firstname,
        lastname = CharacterData.lastname,
        birthdate = CharacterData.birthdate,
        sex = CharacterData.sexIndex,
        mugshot = mugshot,
    }, CharacterSkin)

    -- clear some global variables
    bodyCam, faceCam, isCamOnFace = nil, nil, false
    lookAtCoordLeft, lookAtCoordRight, lookAtCoordFront = nil, nil, nil
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
        SetPedComponentVariation(ped, 3, 0, 0, 2) -- torso
        SetPedComponentVariation(ped, 4, 22, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 6, 0, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- undershirt
        SetPedComponentVariation(ped, 11, 260, 12, 2) -- tops
        SetPedHairColor(ped, 10, 21)
    elseif i == 2 then
        SetPedHeadBlendData(ped, 39, 39, 39, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 5, 4, 2) -- hairs
        SetPedComponentVariation(ped, 3, 1, 0, 2) -- torso
        SetPedComponentVariation(ped, 4, 10, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 10, 0, 2) -- shoes
        SetPedComponentVariation(ped, 7, 11, 2, 2) -- chain
        SetPedComponentVariation(ped, 8, 13, 6, 2) -- undershirt
        SetPedComponentVariation(ped, 11, 10, 0, 2) -- tops
        SetPedHairColor(ped, 35, 21)
    elseif i == 3 then
        SetPedHeadBlendData(ped, 34, 34, 34, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 1, 4, 2) -- hairs
        SetPedComponentVariation(ped, 3, 1, 0, 2) -- torso
        SetPedComponentVariation(ped, 4, 0, 1, 2) -- pants
        SetPedComponentVariation(ped, 6, 7, 4, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 16, 0, 2) -- undershirt
        SetPedComponentVariation(ped, 11, 6, 0, 2) -- tops
        SetPedHairColor(ped, 30, 21)
    elseif i == 4 then
        SetPedHeadBlendData(ped, 14, 14, 14, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 5, 3, 2) -- hairs
        SetPedComponentVariation(ped, 3, 5, 0, 2) -- torso
        SetPedComponentVariation(ped, 4, 15, 3, 2) -- pants
        SetPedComponentVariation(ped, 6, 7, 2, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- undershirt
        SetPedComponentVariation(ped, 11, 78, 3, 2) -- tops
        SetPedHairColor(ped, 10, 21)
    elseif i == 5 then
        SetPedHeadBlendData(ped, 39, 39, 39, 2, 2, 2, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 68, 0, 2) -- hairs
        SetPedComponentVariation(ped, 3, 0, 0, 2) -- torso
        SetPedComponentVariation(ped, 4, 12, 5, 2) -- pants
        SetPedComponentVariation(ped, 6, 6, 2, 2) -- shoes
        SetPedComponentVariation(ped, 7, 4, 3, 2) -- chain
        SetPedComponentVariation(ped, 8, 3, 0, 2) -- tshirt
        SetPedComponentVariation(ped, 11, 79, 2, 2) -- tops
        SetPedHairColor(ped, 10, 21)
    elseif i == 6 then
        SetPedHeadBlendData(ped, 27, 27, 27, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 7, 3, 2) -- hairs
        SetPedComponentVariation(ped, 3, 0, 0, 2) -- torso
        SetPedComponentVariation(ped, 4, 12, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 5, 2, 2) -- shoes
        SetPedComponentVariation(ped, 7, 5, 3, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- undershirt
        SetPedComponentVariation(ped, 11, 80, 2, 2) -- tops
        SetPedHairColor(ped, 29, 31)
    elseif i == 7 then
        SetPedHeadBlendData(ped, 33, 33, 33, 0, 0, 0, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 2, 73, 0, 2) -- hairs
        SetPedComponentVariation(ped, 3, 12, 0, 2) -- torso
        SetPedComponentVariation(ped, 4, 27, 0, 2) -- pants
        SetPedComponentVariation(ped, 6, 15, 3, 2) -- shoes
        SetPedComponentVariation(ped, 7, 0, 0, 2) -- chain
        SetPedComponentVariation(ped, 8, 15, 0, 2) -- undershirt
        SetPedComponentVariation(ped, 11, 283, 7, 2) -- tops
        SetPedHairColor(ped, 62, 0)
    end
    SetPedComponentVariation(ped, 1, 0, 0, 2) -- mask
    SetPedComponentVariation(ped, 5, 0, 0, 2) -- bags
    SetPedComponentVariation(ped, 9, 0, 0, 2) -- bodyarmor
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
