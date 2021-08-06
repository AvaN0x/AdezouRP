-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- inspired by https://github.com/NicooPasPris/nicoo_charcreator

AVA.Player.CreatingChar = false

local MainMenu = RageUI.CreateMenu("", "Création de personnage", 0, 0, "avaui", "avaui_title_adezou");

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
    Citizen.Wait(4000) 
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

    Citizen.Wait(100)
    RageUI.Visible(MainMenu, true)

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
MainMenu.Closable = false
MainMenu.Closed = function()
    print("MainMenu closed")
    StopCharCreator()
end

function RageUI.PoolMenus:AvaCoreCreateChar()
	MainMenu:IsVisible(function(Items)
        Items:AddButton("AdezouRP", nil, { LeftBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end, RightBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end }, function(onSelected) end)

        Items:AddButton("Sauvegarder et valider", nil, { Color = { BackgroundColor = RageUI.ItemsColour.OrangeDark, HighLightColor = RageUI.ItemsColour.OrangeLight } }, function(onSelected)
            if onSelected then
                RageUI.CloseAll()
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
end)

