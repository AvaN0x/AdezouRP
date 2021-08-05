---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- created at [24/05/2021 10:02]
---

-- local MainMenu = RageUI.CreateMenu("", "SUBTITLE", 0, 0, "casinoui_lucky_wheel", "casinoui_lucky_wheel");
local MainMenu = RageUI.CreateMenu("", "SUBTITLE", 0, 0, "avaui", "avaui_title_adezou");

local SubMenu = RageUI.CreateSubMenu(MainMenu, "", "SubTitle")
local SubSubMenu = RageUI.CreateSubMenu(SubMenu, "", "SubSubTitle")
local SubMenuHeritage = RageUI.CreateSubMenu(MainMenu, "", "Check some heritages things")
SubMenuHeritage.EnableMouse = true;
-- SubMenuHeritage.Closable = false;
local RightBadgesSubMenu = RageUI.CreateSubMenu(MainMenu, "", "RightBadges SubMenu")

local Checked = false;
local ListIndex = 1;
local List2Index = 1;

local MumList = { "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Misty" };
local DadList = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", "John", "Niko", "Claude" };
local MumIndex, DadIndex = 1, 1

local GridX, GridY = 0, 0



local SecondMainMenu = RageUI.CreateMenu("", "SecondMainMenu", 0, 0, "arcadeui_race_car", "arcadeui_race_car");



function RageUI.PoolMenus:Example()
	MainMenu:IsVisible(function(Items)
        
        Items:AddButton("AdezouRP", nil, { LeftBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end, RightBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end }, function(onSelected) end)

        Items:AddButton("Heritage", "Heritage.", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                print("onSelected")
            end
        end, SubMenuHeritage)

		Items:AddButton("Sub Menu", "Sub Menu", { RightLabel = "→→→" }, function(onSelected)
        end, SubMenu)

		Items:AddButton("SecondMainMenu", "SecondMainMenu", { RightLabel = "→→→", RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "vehicle_card_icons_flag_france"} end }, function(onSelected)

        end, SecondMainMenu)
		Items:AddButton("Hello world", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tempus malesuada nulla, rhoncus vestibulum odio efficitur eu. Donec ac vehicula tellus. Vestibulum eu nunc eget tellus varius convallis. Suspendisse commodo rhoncus urna in luctus. Nulla laoreet est in risus auctor dignissim. Cras sit amet nulla risus. Quisque eu lacus quis nulla viverra molestie. \nCras feugiat, purus consequat.", {}, function(onSelected, onActive)
            if onSelected then
                print("onSelected")
            end
		end)
		Items:AddList("List", { 1, 2, 3 }, ListIndex, nil, {}, function(Index, onSelected, onListChange)
			if (onListChange) then
				ListIndex = Index;
			end
		end)
		Items:AddSeparator("Separator")
		Items:CheckBox("Hello", "Descriptions", Checked, { Style = 2 }, function(onSelected, IsChecked) -- Style == 2 is Times instead of Tick
			if (onSelected) then
				Checked = IsChecked
			end
		end)
        Items:AddList("List Items", { "Yes", "No", "Maybe ?", "Money" }, List2Index, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				List2Index = Index;
                print(ListIndex)
			end
        end)
        -- Items:AddSeparator("Separator")
        Items:AddButton("All right badges", "Get a view of all right badges", { IsDisabled = Checked, RightLabel = "→→→" }, function(onSelected)
        end, RightBadgesSubMenu)

	end, function(Panels)
	end)

	SecondMainMenu:IsVisible(function(Items)
		-- Items
		Items:AddButton("Nothing", nil, {}, function(onSelected)

        end)
	end, function()
		-- Panels
	end)

	SubMenu:IsVisible(function(Items)
		-- Items
		Items:AddButton("Hello world", "Hello world.", { IsDisabled = false }, function(onSelected)

		end, SubSubMenu)
	end, function()
		-- Panels
	end)

	SubSubMenu:IsVisible(function(Items)
		-- Items
		Items:AddButton("Sub Hello world", "Sub Hello world.", { IsDisabled = false }, function(onSelected)
            if onSelected then
                RageUI.GoBack()
            end
		end)
	end, function()
		-- Panels
	end)

    
	SubMenuHeritage:IsVisible(function(Items)
		-- Items
        Items:Heritage(MumIndex, DadIndex)
        Items:AddList("Mum", MumList, MumIndex, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				MumIndex = Index;
			end
        end)
        Items:AddList("Dad", DadList, DadIndex, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				DadIndex = Index;
			end
        end)

        Items:AddButton("Nose", nil, { IsDisabled = false }, function(onSelected)
		end)
    end, function()
		-- Panels
        Panels:Grid(GridX, GridY, "Top", "Bottom", "Left", "Right", function(X, Y, CharacterX, CharacterY)
			GridX = X;
			GridY = Y;
            print(GridX, GridY, CharacterX, CharacterY)
		end, 3)

	end)


	RightBadgesSubMenu:IsVisible(function(Items)
		-- Items
        Items:AddButton("None", "RageUI.BadgeStyle.None", { IsDisabled = false, RightBadge = RageUI.BadgeStyle.None }, function(onSelected) end)
        Items:AddButton("BronzeMedal", "RageUI.BadgeStyle.BronzeMedal", { RightBadge = RageUI.BadgeStyle.BronzeMedal, LeftBadge= RageUI.BadgeStyle.BronzeMedal }, function(onSelected) end)
        Items:AddButton("GoldMedal", "RageUI.BadgeStyle.GoldMedal", { RightBadge = RageUI.BadgeStyle.GoldMedal, LeftBadge= RageUI.BadgeStyle.GoldMedal }, function(onSelected) end)
        Items:AddButton("SilverMedal", "RageUI.BadgeStyle.SilverMedal", { RightBadge = RageUI.BadgeStyle.SilverMedal, LeftBadge= RageUI.BadgeStyle.SilverMedal }, function(onSelected) end)
        Items:AddButton("Alert", "RageUI.BadgeStyle.Alert", { RightBadge = RageUI.BadgeStyle.Alert, LeftBadge= RageUI.BadgeStyle.Alert }, function(onSelected) end)
        Items:AddButton("Crown", "RageUI.BadgeStyle.Crown", { RightBadge = RageUI.BadgeStyle.Crown, LeftBadge= RageUI.BadgeStyle.Crown }, function(onSelected) end)
        Items:AddButton("Ammo", "RageUI.BadgeStyle.Ammo", { RightBadge = RageUI.BadgeStyle.Ammo, LeftBadge= RageUI.BadgeStyle.Ammo }, function(onSelected) end)
        Items:AddButton("Armour", "RageUI.BadgeStyle.Armour", { RightBadge = RageUI.BadgeStyle.Armour, LeftBadge= RageUI.BadgeStyle.Armour }, function(onSelected) end)
        Items:AddButton("Barber", "RageUI.BadgeStyle.Barber", { RightBadge = RageUI.BadgeStyle.Barber, LeftBadge= RageUI.BadgeStyle.Barber }, function(onSelected) end)
        Items:AddButton("Clothes", "RageUI.BadgeStyle.Clothes", { RightBadge = RageUI.BadgeStyle.Clothes, LeftBadge= RageUI.BadgeStyle.Clothes }, function(onSelected) end)
        Items:AddButton("Franklin", "RageUI.BadgeStyle.Franklin", { RightBadge = RageUI.BadgeStyle.Franklin, LeftBadge= RageUI.BadgeStyle.Franklin }, function(onSelected) end)
        Items:AddButton("Bike", "RageUI.BadgeStyle.Bike", { RightBadge = RageUI.BadgeStyle.Bike, LeftBadge= RageUI.BadgeStyle.Bike }, function(onSelected) end)
        Items:AddButton("Car", "RageUI.BadgeStyle.Car", { RightBadge = RageUI.BadgeStyle.Car, LeftBadge= RageUI.BadgeStyle.Car }, function(onSelected) end)
        Items:AddButton("Boat", "RageUI.BadgeStyle.Boat", { RightBadge = RageUI.BadgeStyle.Boat, LeftBadge= RageUI.BadgeStyle.Boat }, function(onSelected) end)
        Items:AddButton("Heli", "RageUI.BadgeStyle.Heli", { RightBadge = RageUI.BadgeStyle.Heli, LeftBadge= RageUI.BadgeStyle.Heli }, function(onSelected) end)
        Items:AddButton("Plane", "RageUI.BadgeStyle.Plane", { RightBadge = RageUI.BadgeStyle.Plane, LeftBadge= RageUI.BadgeStyle.Plane }, function(onSelected) end)
        Items:AddButton("BoatPickup", "RageUI.BadgeStyle.BoatPickup", { RightBadge = RageUI.BadgeStyle.BoatPickup, LeftBadge= RageUI.BadgeStyle.BoatPickup }, function(onSelected) end)
        Items:AddButton("Card", "RageUI.BadgeStyle.Card", { RightBadge = RageUI.BadgeStyle.Card, LeftBadge= RageUI.BadgeStyle.Card }, function(onSelected) end)
        Items:AddButton("Gun", "RageUI.BadgeStyle.Gun", { RightBadge = RageUI.BadgeStyle.Gun, LeftBadge= RageUI.BadgeStyle.Gun }, function(onSelected) end)
        Items:AddButton("Heart", "RageUI.BadgeStyle.Heart", { RightBadge = RageUI.BadgeStyle.Heart, LeftBadge= RageUI.BadgeStyle.Heart }, function(onSelected) end)
        Items:AddButton("Makeup", "RageUI.BadgeStyle.Makeup", { RightBadge = RageUI.BadgeStyle.Makeup, LeftBadge= RageUI.BadgeStyle.Makeup }, function(onSelected) end)
        Items:AddButton("Mask", "RageUI.BadgeStyle.Mask", { RightBadge = RageUI.BadgeStyle.Mask, LeftBadge= RageUI.BadgeStyle.Mask }, function(onSelected) end)
        Items:AddButton("Michael", "RageUI.BadgeStyle.Michael", { RightBadge = RageUI.BadgeStyle.Michael, LeftBadge= RageUI.BadgeStyle.Michael }, function(onSelected) end)
        Items:AddButton("Star", "RageUI.BadgeStyle.Star", { RightBadge = RageUI.BadgeStyle.Star, LeftBadge= RageUI.BadgeStyle.Star }, function(onSelected) end)
        Items:AddButton("Tattoo", "RageUI.BadgeStyle.Tattoo", { RightBadge = RageUI.BadgeStyle.Tattoo, LeftBadge= RageUI.BadgeStyle.Tattoo }, function(onSelected) end)
        Items:AddButton("Trevor", "RageUI.BadgeStyle.Trevor", { RightBadge = RageUI.BadgeStyle.Trevor, LeftBadge= RageUI.BadgeStyle.Trevor }, function(onSelected) end)
        Items:AddButton("Lock", "RageUI.BadgeStyle.Lock", { RightBadge = RageUI.BadgeStyle.Lock, LeftBadge= RageUI.BadgeStyle.Lock }, function(onSelected) end)
        Items:AddButton("Tick", "RageUI.BadgeStyle.Tick", { RightBadge = RageUI.BadgeStyle.Tick, LeftBadge= RageUI.BadgeStyle.Tick }, function(onSelected) end)
        Items:AddButton("Key", "RageUI.BadgeStyle.Key", { RightBadge = RageUI.BadgeStyle.Key, LeftBadge= RageUI.BadgeStyle.Key }, function(onSelected) end)
        Items:AddButton("Coke", "RageUI.BadgeStyle.Coke", { RightBadge = RageUI.BadgeStyle.Coke, LeftBadge= RageUI.BadgeStyle.Coke }, function(onSelected) end)
        Items:AddButton("Heroin", "RageUI.BadgeStyle.Heroin", { RightBadge = RageUI.BadgeStyle.Heroin, LeftBadge= RageUI.BadgeStyle.Heroin }, function(onSelected) end)
        Items:AddButton("Meth", "RageUI.BadgeStyle.Meth", { RightBadge = RageUI.BadgeStyle.Meth, LeftBadge= RageUI.BadgeStyle.Meth }, function(onSelected) end)
        Items:AddButton("Weed", "RageUI.BadgeStyle.Weed", { RightBadge = RageUI.BadgeStyle.Weed, LeftBadge= RageUI.BadgeStyle.Weed }, function(onSelected) end)
        Items:AddButton("Package", "RageUI.BadgeStyle.Package", { RightBadge = RageUI.BadgeStyle.Package, LeftBadge= RageUI.BadgeStyle.Package }, function(onSelected) end)
        Items:AddButton("Cash", "RageUI.BadgeStyle.Cash", { RightBadge = RageUI.BadgeStyle.Cash, LeftBadge= RageUI.BadgeStyle.Cash }, function(onSelected) end)
        Items:AddButton("RP", "RageUI.BadgeStyle.RP", { RightBadge = RageUI.BadgeStyle.RP, LeftBadge= RageUI.BadgeStyle.RP }, function(onSelected) end)
        Items:AddButton("LSPD", "RageUI.BadgeStyle.LSPD", { RightBadge = RageUI.BadgeStyle.LSPD, LeftBadge= RageUI.BadgeStyle.LSPD }, function(onSelected) end)
        Items:AddButton("Vagos", "RageUI.BadgeStyle.Vagos", { RightBadge = RageUI.BadgeStyle.Vagos, LeftBadge= RageUI.BadgeStyle.Vagos }, function(onSelected) end)
        Items:AddButton("Bikers", "RageUI.BadgeStyle.Bikers", { RightBadge = RageUI.BadgeStyle.Bikers, LeftBadge= RageUI.BadgeStyle.Bikers }, function(onSelected) end)
        Items:AddButton("Badbeat", "RageUI.BadgeStyle.Badbeat", { RightBadge = RageUI.BadgeStyle.Badbeat, LeftBadge= RageUI.BadgeStyle.Badbeat }, function(onSelected) end)
        Items:AddButton("CashingOut", "RageUI.BadgeStyle.CashingOut", { RightBadge = RageUI.BadgeStyle.CashingOut, LeftBadge= RageUI.BadgeStyle.CashingOut }, function(onSelected) end)
        Items:AddButton("FullHouse", "RageUI.BadgeStyle.FullHouse", { RightBadge = RageUI.BadgeStyle.FullHouse, LeftBadge= RageUI.BadgeStyle.FullHouse }, function(onSelected) end)
        Items:AddButton("HighRoller", "RageUI.BadgeStyle.HighRoller", { RightBadge = RageUI.BadgeStyle.HighRoller, LeftBadge= RageUI.BadgeStyle.HighRoller }, function(onSelected) end)
        Items:AddButton("HouseKeeping", "RageUI.BadgeStyle.HouseKeeping", { RightBadge = RageUI.BadgeStyle.HouseKeeping, LeftBadge= RageUI.BadgeStyle.HouseKeeping }, function(onSelected) end)
        Items:AddButton("LooseCheng", "RageUI.BadgeStyle.LooseCheng", { RightBadge = RageUI.BadgeStyle.LooseCheng, LeftBadge= RageUI.BadgeStyle.LooseCheng }, function(onSelected) end)
        Items:AddButton("LuckyLucky", "RageUI.BadgeStyle.LuckyLucky", { RightBadge = RageUI.BadgeStyle.LuckyLucky, LeftBadge= RageUI.BadgeStyle.LuckyLucky }, function(onSelected) end)
        Items:AddButton("PlayToWin", "RageUI.BadgeStyle.PlayToWin", { RightBadge = RageUI.BadgeStyle.PlayToWin, LeftBadge= RageUI.BadgeStyle.PlayToWin }, function(onSelected) end)
        Items:AddButton("StraightFlush", "RageUI.BadgeStyle.StraightFlush", { RightBadge = RageUI.BadgeStyle.StraightFlush, LeftBadge= RageUI.BadgeStyle.StraightFlush }, function(onSelected) end)
        Items:AddButton("StrongArmTactics", "RageUI.BadgeStyle.StrongArmTactics", { RightBadge = RageUI.BadgeStyle.StrongArmTactics, LeftBadge= RageUI.BadgeStyle.StrongArmTactics }, function(onSelected) end)
        Items:AddButton("TopPair", "RageUI.BadgeStyle.TopPair", { RightBadge = RageUI.BadgeStyle.TopPair, LeftBadge= RageUI.BadgeStyle.TopPair }, function(onSelected) end)

        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "vehicle_card_icons_flag_france"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "vehicle_card_icons_acceleration"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "vehicle_card_icons_speed"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "vehicle_card_icons_flag_usa"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "vehicle_card_icons_braking"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "transport_bicycle_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "transport_bike_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "transport_boat_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "transport_car_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "transport_heli_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "transport_plane_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "commonmenu", BadgeTexture = "common_medal"} end }, function(onSelected) end)

        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_audio_1"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_audio_2"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_audio_3"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_audio_inactive"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_audio_mute"} end }, function(onSelected) end)
        
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_female_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_male_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_deaths_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_globe_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_kd_icon"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpleaderboard", BadgeTexture = "leaderboard_players_icon"} end }, function(onSelected) end)

        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mprpsymbol", BadgeTexture = "rp"} end }, function(onSelected) end)

        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_am_fire_exting"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_am_jerrycan"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_am_loudhailer"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_am_parachute"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_ex_molotov"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_meleelasso_01"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_bat"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_crowbar"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_fireaxe"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_gclub"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_hammer"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_knife_01"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_nightstick"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_shovel"} end }, function(onSelected) end)
        Items:AddButton("Custom", nil, { RightBadge = function() return {BadgeDictionary = "mpweaponsunusedfornow", BadgeTexture = "w_me_wrench"} end }, function(onSelected) end)
        
    end, function()
		-- Panels
	end)
end

Keys.Register("F4", "F4", "Test", function()
	RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
end)
