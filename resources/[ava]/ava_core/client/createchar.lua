-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- inspired by https://github.com/NicooPasPris/nicoo_charcreator

AVA.Player.CreatingChar = false

local MainMenu = RageUI.CreateMenu("", "Création de personnage", 0, 0, "avaui", "avaui_title_adezou");

local SexList = {"Homme", "Femme"}
local CharacterData = {}

---------------------------------------
--------------- Cameras ---------------
---------------------------------------

-- CAM + Spawn
local Camera = {
	face = {x = 402.92, y = -1000.72, z = -98.45, fov = 10.00},
	body = {x = 402.92, y = -1000.72, z = -99.01, fov = 30.00},
}

local cam, cam2, cam3, camSkin, isCameraActive = nil, nil, nil, nil, nil


local function StartCharCreator()
    local playerPed = PlayerPedId()

    DoScreenFadeOut(1000)
    Citizen.Wait(2000)
    DestroyAllCams(true)

    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera.body.x, Camera.body.y, Camera.body.z, 0.00, 0.00, 0.00, Camera.body.fov, false, 0)
    SetCamActive(cam2, true)
    RenderScriptCams(true, false, 2000, true, true)

    Citizen.Wait(500)

    DoScreenFadeIn(2000)
    SetEntityCoords(playerPed, 405.59, -997.18, -99.00, 0.0, 0.0, 0.0, true)
    SetEntityHeading(playerPed, 90.00)

    -- TriggerEvent('skinchanger:loadSkin', {sex = 0})
    -- changeGender(1)
    Citizen.Wait(500)

    cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.99, -998.02, -99.00, 0.00, 0.00, 0.00, 50.00, false, 0)
    PointCamAtCoord(cam3, 402.99, -998.02, -99.00)
    SetCamActiveWithInterp(cam2, cam3, 5000, true, true)

    while not HasAnimDictLoaded("mp_character_creation@customise@male_a") do
        RequestAnimDict("mp_character_creation@customise@male_a")
        Wait(10)
    end
    TaskPlayAnim(playerPed, "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 4000, 0, 1, 0, 0, 0)

    Citizen.Wait(5000)

    if #(GetEntityCoords(playerPed) - vector3(402.89, -996.87, -99.0)) > 0.5 then
        SetEntityCoords(playerPed, 402.89, -996.87, -99.0, 0.0, 0.0, 0.0, true)
        SetEntityHeading(playerPed, 173.97)
    end

    Citizen.Wait(1000)
    FreezeEntityPosition(playerPed, true)
end

local function StopCharCreator()
    local playerPed = GetPlayerPed(-1)
    DoScreenFadeOut(1000)

    Wait(1000)

    SetCamActive(camSkin,  false)

    RenderScriptCams(false,  false,  0,  true,  true)

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
end


-------------------------------------
--------------- MENUS ---------------
-------------------------------------
local SubMenuIdentity = RageUI.CreateSubMenu(MainMenu, "", "Identité")
MainMenu.InstructionalButtons = {
    {"~INPUT_FRONTEND_RT~", "Droite"},
    {"~INPUT_FRONTEND_LT~", "Gauche"}
}
MainMenu.Closable = false
MainMenu.Closed = function()
    print("MainMenu closed")
    print("CharacterData", json.encode(CharacterData))
    StopCharCreator()
end

function RageUI.PoolMenus:AvaCoreCreateChar()
	MainMenu:IsVisible(function(Items)
        -- Items:AddButton("AdezouRP", nil, { LeftBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end, RightBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end }, function(onSelected) end)
        
        Items:AddList("Sexe", SexList, CharacterData.sexIndex, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				CharacterData.sexIndex = Index;
                TriggerEvent('skinchanger:loadDefaultModel', CharacterData.sexIndex == 0, function()
                    print("load default skin")
                    -- TriggerEvent('skinchanger:loadSkin', DefaultSkin.Male)
                    -- TriggerEvent('skinchanger:loadSkin', DefaultSkin.FemaleTriggerEvent('skinchanger:loadSkin', AVA.Player.Data.skin))
                end)
			end
        end)

        Items:AddButton("Identité", "", { RightLabel = "→→→" }, nil, SubMenuIdentity)

        Items:AddButton("Hérédité", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                print("onSelected")
            end
        end, SubMenuHeritage)

        Items:AddButton("Traits du visage", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                print("onSelected")
            end
        end, SubMenuVisage)

        Items:AddButton("Apparence", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                print("onSelected")
            end
        end, SubMenuAppearance)

        Items:AddButton("Vêtements", "", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                print("onSelected")
            end
        end, SubMenuClothes)


        Items:AddButton("Sauvegarder et valider", nil, { Color = { BackgroundColor = RageUI.ItemsColour.MenuYellow, HighLightColor = RageUI.ItemsColour.PmMitemHighlight } }, function(onSelected)
            if onSelected then
                RageUI.CloseAll()
            end
		end)
	end)

    SubMenuIdentity:IsVisible(function(Items)
        Items:AddButton("Prénom", nil, { RightLabel = CharacterData.firstname }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre prénom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterData.firstname = result
                end
            end
        end)
        Items:AddButton("Nom", nil, { RightLabel = CharacterData.lastname }, function(onSelected)
            if onSelected then
                local result = AVA.KeyboardInput("Entrez votre nom (50 caractères max.)", "", 50)
                if result and result ~= "" then
                    CharacterData.lastname = result
                end
            end
        end)
        Items:AddButton("Date de naissance", nil, { RightLabel = CharacterData.birthdate }, function(onSelected)
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
    Citizen.CreateThread(function()
        while AVA.Player.CreatingChar == true do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
    end)
    DisplayRadar(false)
    StartCharCreator()
    
    CharacterData = {
        firstname = "",
        lastname = "",
        sexIndex = 1,
        birthdate = ""
    }
    
    Citizen.Wait(100)
    RageUI.CloseAll()
    RageUI.Visible(MainMenu, true)
end)

