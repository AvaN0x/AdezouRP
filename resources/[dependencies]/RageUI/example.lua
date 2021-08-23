---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- created at [24/05/2021 10:02]
---

-- local MainMenu = RageUI.CreateMenu("", "SUBTITLE", 0, 0, "casinoui_lucky_wheel", "casinoui_lucky_wheel");
local MainMenu = RageUI.CreateMenu("", "SUBTITLE", 0, 0, "avaui", "avaui_title_adezou");
MainMenu.Closed = function()
    print("MainMenu closed")
end

local SubMenu = RageUI.CreateSubMenu(MainMenu, "", "SubTitle")
local SubSubMenu = RageUI.CreateSubMenu(SubMenu, "", "SubSubTitle")
local SubMenuHeritage = RageUI.CreateSubMenu(MainMenu, "", "Check some heritages things")
SubMenuHeritage.EnableMouse = true;
SubMenuHeritage.Closable = false;
local RightBadgesSubMenu = RageUI.CreateSubMenu(MainMenu, "", "RightBadges SubMenu")
local ColorsSubMenu = RageUI.CreateSubMenu(MainMenu, "", "Colors SubMenu")

local Checked = false;
local ListIndex = 1;
local List2Index = 1;
local List3Index = 1;

local MumList = { "Hannah", "Audrey", "Jasmine", "Giselle", "Amelia", "Isabella", "Zoe", "Ava", "Camilla", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma", "Misty" };
local DadList = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", "John", "Niko", "Claude" };
local MumIndex, DadIndex = 1, 1



local GridX, GridY = 0, 0



local SecondMainMenu = RageUI.CreateMenu("", "SecondMainMenu", 0, 0, "arcadeui_race_car", "arcadeui_race_car");


local minColorIndex, colorIndex = 1, 1
local percent = 0.5

local sliderTest1 = 1
local sliderTest2 = 1
local sliderTest3 = 1
local sliderTest4 = 1
local sliderTest5 = 1
local sliderTest6 = 1
function RageUI.PoolMenus:Example()
	MainMenu:IsVisible(function(Items)
        
        Items:AddSeparator("Separator")
        Items:AddButton("AdezouRP", nil, { LeftBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end, RightBadge = function() return {BadgeDictionary = "avaui", BadgeTexture = "avaui_logo_menu"} end }, function(onSelected) end)

        Items:AddSeparator("Separator")
        Items:AddButton("Heritage", "Heritage.", { RightLabel = "→→→" }, function(onSelected)
            if onSelected then
                print("onSelected")
            end
        end, SubMenuHeritage)
        
        Items:AddSeparator("Separator")
		Items:AddButton("Sub Menu", "Sub Menu", { RightLabel = "→→→" }, function(onSelected)
        end, SubMenu)
        Items:AddSeparator("Bread Separator")
		Items:AddButton("~r~Bread", "", { RightLabel = "~r~100 $" }, function(onSelected) end)
		Items:AddButton("~g~Bread", "", { RightLabel = "~g~100 $" }, function(onSelected) end)
		Items:AddButton("~b~Bread", "", { RightLabel = "~b~100 $" }, function(onSelected) end)
		Items:AddButton("~y~Bread", "", { RightLabel = "~y~100 $" }, function(onSelected) end)
		Items:AddButton("~p~Bread", "", { RightLabel = "~p~100 $" }, function(onSelected) end)
		Items:AddButton("~c~Bread", "", { RightLabel = "~c~100 $" }, function(onSelected) end)
		Items:AddButton("~m~Bread", "", { RightLabel = "~m~100 $" }, function(onSelected) end)
		Items:AddButton("~u~Bread", "", { RightLabel = "~u~100 $" }, function(onSelected) end)
		Items:AddButton("~o~Bread", "", { RightLabel = "~o~100 $" }, function(onSelected) end)

		Items:AddButton("SecondMainMenu", "SecondMainMenu", { RightLabel = "→→→", RightBadge = function() return {BadgeDictionary = "mpcarhud", BadgeTexture = "vehicle_card_icons_flag_france"} end }, function(onSelected)

        end, SecondMainMenu)
		Items:AddButton("Hello world", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tempus malesuada nulla, rhoncus vestibulum odio efficitur eu. Donec ac vehicula tellus. Vestibulum eu nunc eget tellus varius convallis. Suspendisse commodo rhoncus urna in luctus. Nulla laoreet est in risus auctor dignissim. Cras sit amet nulla risus. Quisque eu lacus quis nulla viverra molestie. \nCras feugiat, purus consequat.", {}, function(onSelected, onActive)
            if onSelected then
                print("onSelected")
            end
		end)
		Items:AddList("List", { 1, 2, 3 }, ListIndex, nil, nil, function(Index, onSelected, onListChange)
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
			end
        end)
        Items:AddList("List Items", 100, List3Index, nil, {}, function(Index, onSelected, onListChange)
            if (onListChange) then
				List3Index = Index;
			end
        end)
        Items:AddSeparator("Test separator")
        Items:AddButton("All right badges", "Get a view of all right badges", { IsDisabled = Checked, RightLabel = "→→→" }, function(onSelected)
        end, RightBadgesSubMenu)
        Items:AddButton("Colors", "Get a view of all colors", { RightLabel = "→→→" }, function(onSelected)
        end, ColorsSubMenu)
        Items:AddSeparator("Separator")

	end)

	SecondMainMenu:IsVisible(function(Items)
		-- Items
		Items:AddButton("Nothing", nil, {}, function(onSelected)

        end)
	end)

	SubMenu:IsVisible(function(Items)
		-- Items
		Items:AddButton("Hello world", "Hello world.", nil, function(onSelected)

		end, SubSubMenu)
	end)

	SubSubMenu:IsVisible(function(Items)
		-- Items
		Items:AddButton("Sub Hello world", nil, nil, function(onSelected)
            if onSelected then
                RageUI.GoBack()
            end
		end)
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

        Items:AddButton("Nose", nil, nil, function(onSelected)
		end)
        Items:AddButton("Test Color", nil, {}, function(onSelected)
		end)
        Items:AddButton("Test percent", nil, {}, function(onSelected)
		end)
        
        Items:Slider("test", sliderTest1, 20, "description test", false, { IsDisabled = true }, function(Selected, Active, OnListChange, SliderIndex)
            if OnListChange then
                print(Selected, Active, OnListChange, SliderIndex)
                sliderTest1 = SliderIndex
            end
        end)
        Items:Slider("test2", sliderTest2, 20, "description test", false, { IsDisabled = false }, function(Selected, Active, OnListChange, SliderIndex)
            if OnListChange then
                print(Selected, Active, OnListChange, SliderIndex)
                sliderTest2 = SliderIndex
            end
        end)

        Items:SliderHeritage("testheritage", sliderTest4, "description test", function(Selected, Active, OnListChange, SliderIndex, Percent)
            if OnListChange then
                print(Selected, Active, OnListChange, SliderIndex, Percent)
                sliderTest4 = SliderIndex
            end
        end)

        Items:AddButton("~g~Valider", nil, { Color = { BackgroundColor = RageUI.ItemsColour.Pink, HighLightColor = RageUI.ItemsColour.YellowLight} }, function(onSelected)
            if onSelected then
                -- RageUI.Visible(SubMenuHeritage, false)
                RageUI.GoBack()
            end
		end)
    end, function()
		-- Panels
        Panels:Grid(GridX, GridY, "Haut", "Bas", "Gauche", "Droite", function(X, Y, CharacterX, CharacterY)
			GridX = X;
			GridY = Y;
            print(GridX, GridY, CharacterX, CharacterY)
		end, 3)

        Panels:ColourPanel("Couleur", RageUI.PanelColour.HairCut, minColorIndex, colorIndex, function(MinimumIndex, CurrentIndex)
            minColorIndex = MinimumIndex
            colorIndex = CurrentIndex
            print(RageUI.PanelColour.HairCut[colorIndex][1], RageUI.PanelColour.HairCut[colorIndex][2], RageUI.PanelColour.HairCut[colorIndex][3])
        end, 4)

        Panels:PercentagePanel(percent, nil, nil, nil, function(Percent)
            percent = Percent
            print(math.floor(percent * 10))
        end, 5)
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

	ColorsSubMenu:IsVisible(function(Items)
        Items:AddButton("None", "RageUI.BadgeStyle.None", { IsDisabled = false, RightBadge = RageUI.BadgeStyle.None }, function(onSelected) end)
        Items:AddButton("PureWhite", "PureWhite", { Color = { BackgroundColor = RageUI.ItemsColour.PureWhite, HighLightColor = RageUI.ItemsColour.PureWhite } })
        Items:AddButton("White", "White", { Color = { BackgroundColor = RageUI.ItemsColour.White, HighLightColor = RageUI.ItemsColour.White } })
        Items:AddButton("Black", "Black", { Color = { BackgroundColor = RageUI.ItemsColour.Black, HighLightColor = RageUI.ItemsColour.Black } })
        Items:AddButton("Grey", "Grey", { Color = { BackgroundColor = RageUI.ItemsColour.Grey, HighLightColor = RageUI.ItemsColour.Grey } })
        Items:AddButton("GreyLight", "GreyLight", { Color = { BackgroundColor = RageUI.ItemsColour.GreyLight, HighLightColor = RageUI.ItemsColour.GreyLight } })
        Items:AddButton("GreyDark", "GreyDark", { Color = { BackgroundColor = RageUI.ItemsColour.GreyDark, HighLightColor = RageUI.ItemsColour.GreyDark } })
        Items:AddButton("Red", "Red", { Color = { BackgroundColor = RageUI.ItemsColour.Red, HighLightColor = RageUI.ItemsColour.Red } })
        Items:AddButton("RedLight", "RedLight", { Color = { BackgroundColor = RageUI.ItemsColour.RedLight, HighLightColor = RageUI.ItemsColour.RedLight } })
        Items:AddButton("RedDark", "RedDark", { Color = { BackgroundColor = RageUI.ItemsColour.RedDark, HighLightColor = RageUI.ItemsColour.RedDark } })
        Items:AddButton("Blue", "Blue", { Color = { BackgroundColor = RageUI.ItemsColour.Blue, HighLightColor = RageUI.ItemsColour.Blue } })
        Items:AddButton("BlueLight", "BlueLight", { Color = { BackgroundColor = RageUI.ItemsColour.BlueLight, HighLightColor = RageUI.ItemsColour.BlueLight } })
        Items:AddButton("BlueDark", "BlueDark", { Color = { BackgroundColor = RageUI.ItemsColour.BlueDark, HighLightColor = RageUI.ItemsColour.BlueDark } })
        Items:AddButton("Yellow", "Yellow", { Color = { BackgroundColor = RageUI.ItemsColour.Yellow, HighLightColor = RageUI.ItemsColour.Yellow } })
        Items:AddButton("YellowLight", "YellowLight", { Color = { BackgroundColor = RageUI.ItemsColour.YellowLight, HighLightColor = RageUI.ItemsColour.YellowLight } })
        Items:AddButton("YellowDark", "YellowDark", { Color = { BackgroundColor = RageUI.ItemsColour.YellowDark, HighLightColor = RageUI.ItemsColour.YellowDark } })
        Items:AddButton("Orange", "Orange", { Color = { BackgroundColor = RageUI.ItemsColour.Orange, HighLightColor = RageUI.ItemsColour.Orange } })
        Items:AddButton("OrangeLight", "OrangeLight", { Color = { BackgroundColor = RageUI.ItemsColour.OrangeLight, HighLightColor = RageUI.ItemsColour.OrangeLight } })
        Items:AddButton("OrangeDark", "OrangeDark", { Color = { BackgroundColor = RageUI.ItemsColour.OrangeDark, HighLightColor = RageUI.ItemsColour.OrangeDark } })
        Items:AddButton("Green", "Green", { Color = { BackgroundColor = RageUI.ItemsColour.Green, HighLightColor = RageUI.ItemsColour.Green } })
        Items:AddButton("GreenLight", "GreenLight", { Color = { BackgroundColor = RageUI.ItemsColour.GreenLight, HighLightColor = RageUI.ItemsColour.GreenLight } })
        Items:AddButton("GreenDark", "GreenDark", { Color = { BackgroundColor = RageUI.ItemsColour.GreenDark, HighLightColor = RageUI.ItemsColour.GreenDark } })
        Items:AddButton("Purple", "Purple", { Color = { BackgroundColor = RageUI.ItemsColour.Purple, HighLightColor = RageUI.ItemsColour.Purple } })
        Items:AddButton("PurpleLight", "PurpleLight", { Color = { BackgroundColor = RageUI.ItemsColour.PurpleLight, HighLightColor = RageUI.ItemsColour.PurpleLight } })
        Items:AddButton("PurpleDark", "PurpleDark", { Color = { BackgroundColor = RageUI.ItemsColour.PurpleDark, HighLightColor = RageUI.ItemsColour.PurpleDark } })
        Items:AddButton("Pink", "Pink", { Color = { BackgroundColor = RageUI.ItemsColour.Pink, HighLightColor = RageUI.ItemsColour.Pink } })
        Items:AddButton("RadarHealth", "RadarHealth", { Color = { BackgroundColor = RageUI.ItemsColour.RadarHealth, HighLightColor = RageUI.ItemsColour.RadarHealth } })
        Items:AddButton("RadarArmour", "RadarArmour", { Color = { BackgroundColor = RageUI.ItemsColour.RadarArmour, HighLightColor = RageUI.ItemsColour.RadarArmour } })
        Items:AddButton("RadarDamage", "RadarDamage", { Color = { BackgroundColor = RageUI.ItemsColour.RadarDamage, HighLightColor = RageUI.ItemsColour.RadarDamage } })
        Items:AddButton("NetPlayer1", "NetPlayer1", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer1, HighLightColor = RageUI.ItemsColour.NetPlayer1 } })
        Items:AddButton("NetPlayer2", "NetPlayer2", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer2, HighLightColor = RageUI.ItemsColour.NetPlayer2 } })
        Items:AddButton("NetPlayer3", "NetPlayer3", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer3, HighLightColor = RageUI.ItemsColour.NetPlayer3 } })
        Items:AddButton("NetPlayer4", "NetPlayer4", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer4, HighLightColor = RageUI.ItemsColour.NetPlayer4 } })
        Items:AddButton("NetPlayer5", "NetPlayer5", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer5, HighLightColor = RageUI.ItemsColour.NetPlayer5 } })
        Items:AddButton("NetPlayer6", "NetPlayer6", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer6, HighLightColor = RageUI.ItemsColour.NetPlayer6 } })
        Items:AddButton("NetPlayer7", "NetPlayer7", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer7, HighLightColor = RageUI.ItemsColour.NetPlayer7 } })
        Items:AddButton("NetPlayer8", "NetPlayer8", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer8, HighLightColor = RageUI.ItemsColour.NetPlayer8 } })
        Items:AddButton("NetPlayer9", "NetPlayer9", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer9, HighLightColor = RageUI.ItemsColour.NetPlayer9 } })
        Items:AddButton("NetPlayer10", "NetPlayer10", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer10, HighLightColor = RageUI.ItemsColour.NetPlayer10 } })
        Items:AddButton("NetPlayer11", "NetPlayer11", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer11, HighLightColor = RageUI.ItemsColour.NetPlayer11 } })
        Items:AddButton("NetPlayer12", "NetPlayer12", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer12, HighLightColor = RageUI.ItemsColour.NetPlayer12 } })
        Items:AddButton("NetPlayer13", "NetPlayer13", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer13, HighLightColor = RageUI.ItemsColour.NetPlayer13 } })
        Items:AddButton("NetPlayer14", "NetPlayer14", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer14, HighLightColor = RageUI.ItemsColour.NetPlayer14 } })
        Items:AddButton("NetPlayer15", "NetPlayer15", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer15, HighLightColor = RageUI.ItemsColour.NetPlayer15 } })
        Items:AddButton("NetPlayer16", "NetPlayer16", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer16, HighLightColor = RageUI.ItemsColour.NetPlayer16 } })
        Items:AddButton("NetPlayer17", "NetPlayer17", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer17, HighLightColor = RageUI.ItemsColour.NetPlayer17 } })
        Items:AddButton("NetPlayer18", "NetPlayer18", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer18, HighLightColor = RageUI.ItemsColour.NetPlayer18 } })
        Items:AddButton("NetPlayer19", "NetPlayer19", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer19, HighLightColor = RageUI.ItemsColour.NetPlayer19 } })
        Items:AddButton("NetPlayer20", "NetPlayer20", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer20, HighLightColor = RageUI.ItemsColour.NetPlayer20 } })
        Items:AddButton("NetPlayer21", "NetPlayer21", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer21, HighLightColor = RageUI.ItemsColour.NetPlayer21 } })
        Items:AddButton("NetPlayer22", "NetPlayer22", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer22, HighLightColor = RageUI.ItemsColour.NetPlayer22 } })
        Items:AddButton("NetPlayer23", "NetPlayer23", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer23, HighLightColor = RageUI.ItemsColour.NetPlayer23 } })
        Items:AddButton("NetPlayer24", "NetPlayer24", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer24, HighLightColor = RageUI.ItemsColour.NetPlayer24 } })
        Items:AddButton("NetPlayer25", "NetPlayer25", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer25, HighLightColor = RageUI.ItemsColour.NetPlayer25 } })
        Items:AddButton("NetPlayer26", "NetPlayer26", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer26, HighLightColor = RageUI.ItemsColour.NetPlayer26 } })
        Items:AddButton("NetPlayer27", "NetPlayer27", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer27, HighLightColor = RageUI.ItemsColour.NetPlayer27 } })
        Items:AddButton("NetPlayer28", "NetPlayer28", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer28, HighLightColor = RageUI.ItemsColour.NetPlayer28 } })
        Items:AddButton("NetPlayer29", "NetPlayer29", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer29, HighLightColor = RageUI.ItemsColour.NetPlayer29 } })
        Items:AddButton("NetPlayer30", "NetPlayer30", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer30, HighLightColor = RageUI.ItemsColour.NetPlayer30 } })
        Items:AddButton("NetPlayer31", "NetPlayer31", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer31, HighLightColor = RageUI.ItemsColour.NetPlayer31 } })
        Items:AddButton("NetPlayer32", "NetPlayer32", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer32, HighLightColor = RageUI.ItemsColour.NetPlayer32 } })
        Items:AddButton("SimpleBlipDefault", "SimpleBlipDefault", { Color = { BackgroundColor = RageUI.ItemsColour.SimpleBlipDefault, HighLightColor = RageUI.ItemsColour.SimpleBlipDefault } })
        Items:AddButton("MenuBlue", "MenuBlue", { Color = { BackgroundColor = RageUI.ItemsColour.MenuBlue, HighLightColor = RageUI.ItemsColour.MenuBlue } })
        Items:AddButton("MenuGreyLight", "MenuGreyLight", { Color = { BackgroundColor = RageUI.ItemsColour.MenuGreyLight, HighLightColor = RageUI.ItemsColour.MenuGreyLight } })
        Items:AddButton("MenuBlueExtraDark", "MenuBlueExtraDark", { Color = { BackgroundColor = RageUI.ItemsColour.MenuBlueExtraDark, HighLightColor = RageUI.ItemsColour.MenuBlueExtraDark } })
        Items:AddButton("MenuYellow", "MenuYellow", { Color = { BackgroundColor = RageUI.ItemsColour.MenuYellow, HighLightColor = RageUI.ItemsColour.MenuYellow } })
        Items:AddButton("MenuYellowDark", "MenuYellowDark", { Color = { BackgroundColor = RageUI.ItemsColour.MenuYellowDark, HighLightColor = RageUI.ItemsColour.MenuYellowDark } })
        Items:AddButton("MenuGreen", "MenuGreen", { Color = { BackgroundColor = RageUI.ItemsColour.MenuGreen, HighLightColor = RageUI.ItemsColour.MenuGreen } })
        Items:AddButton("MenuGrey", "MenuGrey", { Color = { BackgroundColor = RageUI.ItemsColour.MenuGrey, HighLightColor = RageUI.ItemsColour.MenuGrey } })
        Items:AddButton("MenuGreyDark", "MenuGreyDark", { Color = { BackgroundColor = RageUI.ItemsColour.MenuGreyDark, HighLightColor = RageUI.ItemsColour.MenuGreyDark } })
        Items:AddButton("MenuHighlight", "MenuHighlight", { Color = { BackgroundColor = RageUI.ItemsColour.MenuHighlight, HighLightColor = RageUI.ItemsColour.MenuHighlight } })
        Items:AddButton("MenuStandard", "MenuStandard", { Color = { BackgroundColor = RageUI.ItemsColour.MenuStandard, HighLightColor = RageUI.ItemsColour.MenuStandard } })
        Items:AddButton("MenuDimmed", "MenuDimmed", { Color = { BackgroundColor = RageUI.ItemsColour.MenuDimmed, HighLightColor = RageUI.ItemsColour.MenuDimmed } })
        Items:AddButton("MenuExtraDimmed", "MenuExtraDimmed", { Color = { BackgroundColor = RageUI.ItemsColour.MenuExtraDimmed, HighLightColor = RageUI.ItemsColour.MenuExtraDimmed } })
        Items:AddButton("BriefTitle", "BriefTitle", { Color = { BackgroundColor = RageUI.ItemsColour.BriefTitle, HighLightColor = RageUI.ItemsColour.BriefTitle } })
        Items:AddButton("MidGreyMp", "MidGreyMp", { Color = { BackgroundColor = RageUI.ItemsColour.MidGreyMp, HighLightColor = RageUI.ItemsColour.MidGreyMp } })
        Items:AddButton("NetPlayer1Dark", "NetPlayer1Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer1Dark, HighLightColor = RageUI.ItemsColour.NetPlayer1Dark } })
        Items:AddButton("NetPlayer2Dark", "NetPlayer2Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer2Dark, HighLightColor = RageUI.ItemsColour.NetPlayer2Dark } })
        Items:AddButton("NetPlayer3Dark", "NetPlayer3Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer3Dark, HighLightColor = RageUI.ItemsColour.NetPlayer3Dark } })
        Items:AddButton("NetPlayer4Dark", "NetPlayer4Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer4Dark, HighLightColor = RageUI.ItemsColour.NetPlayer4Dark } })
        Items:AddButton("NetPlayer5Dark", "NetPlayer5Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer5Dark, HighLightColor = RageUI.ItemsColour.NetPlayer5Dark } })
        Items:AddButton("NetPlayer6Dark", "NetPlayer6Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer6Dark, HighLightColor = RageUI.ItemsColour.NetPlayer6Dark } })
        Items:AddButton("NetPlayer7Dark", "NetPlayer7Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer7Dark, HighLightColor = RageUI.ItemsColour.NetPlayer7Dark } })
        Items:AddButton("NetPlayer8Dark", "NetPlayer8Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer8Dark, HighLightColor = RageUI.ItemsColour.NetPlayer8Dark } })
        Items:AddButton("NetPlayer9Dark", "NetPlayer9Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer9Dark, HighLightColor = RageUI.ItemsColour.NetPlayer9Dark } })
        Items:AddButton("NetPlayer10Dark", "NetPlayer10Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer10Dark, HighLightColor = RageUI.ItemsColour.NetPlayer10Dark } })
        Items:AddButton("NetPlayer11Dark", "NetPlayer11Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer11Dark, HighLightColor = RageUI.ItemsColour.NetPlayer11Dark } })
        Items:AddButton("NetPlayer12Dark", "NetPlayer12Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer12Dark, HighLightColor = RageUI.ItemsColour.NetPlayer12Dark } })
        Items:AddButton("NetPlayer13Dark", "NetPlayer13Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer13Dark, HighLightColor = RageUI.ItemsColour.NetPlayer13Dark } })
        Items:AddButton("NetPlayer14Dark", "NetPlayer14Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer14Dark, HighLightColor = RageUI.ItemsColour.NetPlayer14Dark } })
        Items:AddButton("NetPlayer15Dark", "NetPlayer15Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer15Dark, HighLightColor = RageUI.ItemsColour.NetPlayer15Dark } })
        Items:AddButton("NetPlayer16Dark", "NetPlayer16Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer16Dark, HighLightColor = RageUI.ItemsColour.NetPlayer16Dark } })
        Items:AddButton("NetPlayer17Dark", "NetPlayer17Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer17Dark, HighLightColor = RageUI.ItemsColour.NetPlayer17Dark } })
        Items:AddButton("NetPlayer18Dark", "NetPlayer18Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer18Dark, HighLightColor = RageUI.ItemsColour.NetPlayer18Dark } })
        Items:AddButton("NetPlayer19Dark", "NetPlayer19Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer19Dark, HighLightColor = RageUI.ItemsColour.NetPlayer19Dark } })
        Items:AddButton("NetPlayer20Dark", "NetPlayer20Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer20Dark, HighLightColor = RageUI.ItemsColour.NetPlayer20Dark } })
        Items:AddButton("NetPlayer21Dark", "NetPlayer21Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer21Dark, HighLightColor = RageUI.ItemsColour.NetPlayer21Dark } })
        Items:AddButton("NetPlayer22Dark", "NetPlayer22Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer22Dark, HighLightColor = RageUI.ItemsColour.NetPlayer22Dark } })
        Items:AddButton("NetPlayer23Dark", "NetPlayer23Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer23Dark, HighLightColor = RageUI.ItemsColour.NetPlayer23Dark } })
        Items:AddButton("NetPlayer24Dark", "NetPlayer24Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer24Dark, HighLightColor = RageUI.ItemsColour.NetPlayer24Dark } })
        Items:AddButton("NetPlayer25Dark", "NetPlayer25Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer25Dark, HighLightColor = RageUI.ItemsColour.NetPlayer25Dark } })
        Items:AddButton("NetPlayer26Dark", "NetPlayer26Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer26Dark, HighLightColor = RageUI.ItemsColour.NetPlayer26Dark } })
        Items:AddButton("NetPlayer27Dark", "NetPlayer27Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer27Dark, HighLightColor = RageUI.ItemsColour.NetPlayer27Dark } })
        Items:AddButton("NetPlayer28Dark", "NetPlayer28Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer28Dark, HighLightColor = RageUI.ItemsColour.NetPlayer28Dark } })
        Items:AddButton("NetPlayer29Dark", "NetPlayer29Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer29Dark, HighLightColor = RageUI.ItemsColour.NetPlayer29Dark } })
        Items:AddButton("NetPlayer30Dark", "NetPlayer30Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer30Dark, HighLightColor = RageUI.ItemsColour.NetPlayer30Dark } })
        Items:AddButton("NetPlayer31Dark", "NetPlayer31Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer31Dark, HighLightColor = RageUI.ItemsColour.NetPlayer31Dark } })
        Items:AddButton("NetPlayer32Dark", "NetPlayer32Dark", { Color = { BackgroundColor = RageUI.ItemsColour.NetPlayer32Dark, HighLightColor = RageUI.ItemsColour.NetPlayer32Dark } })
        Items:AddButton("Bronze", "Bronze", { Color = { BackgroundColor = RageUI.ItemsColour.Bronze, HighLightColor = RageUI.ItemsColour.Bronze } })
        Items:AddButton("Silver", "Silver", { Color = { BackgroundColor = RageUI.ItemsColour.Silver, HighLightColor = RageUI.ItemsColour.Silver } })
        Items:AddButton("Gold", "Gold", { Color = { BackgroundColor = RageUI.ItemsColour.Gold, HighLightColor = RageUI.ItemsColour.Gold } })
        Items:AddButton("Platinum", "Platinum", { Color = { BackgroundColor = RageUI.ItemsColour.Platinum, HighLightColor = RageUI.ItemsColour.Platinum } })
        Items:AddButton("Gang1", "Gang1", { Color = { BackgroundColor = RageUI.ItemsColour.Gang1, HighLightColor = RageUI.ItemsColour.Gang1 } })
        Items:AddButton("Gang2", "Gang2", { Color = { BackgroundColor = RageUI.ItemsColour.Gang2, HighLightColor = RageUI.ItemsColour.Gang2 } })
        Items:AddButton("Gang3", "Gang3", { Color = { BackgroundColor = RageUI.ItemsColour.Gang3, HighLightColor = RageUI.ItemsColour.Gang3 } })
        Items:AddButton("Gang4", "Gang4", { Color = { BackgroundColor = RageUI.ItemsColour.Gang4, HighLightColor = RageUI.ItemsColour.Gang4 } })
        Items:AddButton("SameCrew", "SameCrew", { Color = { BackgroundColor = RageUI.ItemsColour.SameCrew, HighLightColor = RageUI.ItemsColour.SameCrew } })
        Items:AddButton("Freemode", "Freemode", { Color = { BackgroundColor = RageUI.ItemsColour.Freemode, HighLightColor = RageUI.ItemsColour.Freemode } })
        Items:AddButton("PauseBg", "PauseBg", { Color = { BackgroundColor = RageUI.ItemsColour.PauseBg, HighLightColor = RageUI.ItemsColour.PauseBg } })
        Items:AddButton("Friendly", "Friendly", { Color = { BackgroundColor = RageUI.ItemsColour.Friendly, HighLightColor = RageUI.ItemsColour.Friendly } })
        Items:AddButton("Enemy", "Enemy", { Color = { BackgroundColor = RageUI.ItemsColour.Enemy, HighLightColor = RageUI.ItemsColour.Enemy } })
        Items:AddButton("Location", "Location", { Color = { BackgroundColor = RageUI.ItemsColour.Location, HighLightColor = RageUI.ItemsColour.Location } })
        Items:AddButton("Pickup", "Pickup", { Color = { BackgroundColor = RageUI.ItemsColour.Pickup, HighLightColor = RageUI.ItemsColour.Pickup } })
        Items:AddButton("PauseSingleplayer", "PauseSingleplayer", { Color = { BackgroundColor = RageUI.ItemsColour.PauseSingleplayer, HighLightColor = RageUI.ItemsColour.PauseSingleplayer } })
        Items:AddButton("FreemodeDark", "FreemodeDark", { Color = { BackgroundColor = RageUI.ItemsColour.FreemodeDark, HighLightColor = RageUI.ItemsColour.FreemodeDark } })
        Items:AddButton("InactiveMission", "InactiveMission", { Color = { BackgroundColor = RageUI.ItemsColour.InactiveMission, HighLightColor = RageUI.ItemsColour.InactiveMission } })
        Items:AddButton("Damage", "Damage", { Color = { BackgroundColor = RageUI.ItemsColour.Damage, HighLightColor = RageUI.ItemsColour.Damage } })
        Items:AddButton("PinkLight", "PinkLight", { Color = { BackgroundColor = RageUI.ItemsColour.PinkLight, HighLightColor = RageUI.ItemsColour.PinkLight } })
        Items:AddButton("PmMitemHighlight", "PmMitemHighlight", { Color = { BackgroundColor = RageUI.ItemsColour.PmMitemHighlight, HighLightColor = RageUI.ItemsColour.PmMitemHighlight } })
        Items:AddButton("ScriptVariable", "ScriptVariable", { Color = { BackgroundColor = RageUI.ItemsColour.ScriptVariable, HighLightColor = RageUI.ItemsColour.ScriptVariable } })
        Items:AddButton("Yoga", "Yoga", { Color = { BackgroundColor = RageUI.ItemsColour.Yoga, HighLightColor = RageUI.ItemsColour.Yoga } })
        Items:AddButton("Tennis", "Tennis", { Color = { BackgroundColor = RageUI.ItemsColour.Tennis, HighLightColor = RageUI.ItemsColour.Tennis } })
        Items:AddButton("Golf", "Golf", { Color = { BackgroundColor = RageUI.ItemsColour.Golf, HighLightColor = RageUI.ItemsColour.Golf } })
        Items:AddButton("ShootingRange", "ShootingRange", { Color = { BackgroundColor = RageUI.ItemsColour.ShootingRange, HighLightColor = RageUI.ItemsColour.ShootingRange } })
        Items:AddButton("FlightSchool", "FlightSchool", { Color = { BackgroundColor = RageUI.ItemsColour.FlightSchool, HighLightColor = RageUI.ItemsColour.FlightSchool } })
        Items:AddButton("NorthBlue", "NorthBlue", { Color = { BackgroundColor = RageUI.ItemsColour.NorthBlue, HighLightColor = RageUI.ItemsColour.NorthBlue } })
        Items:AddButton("SocialClub", "SocialClub", { Color = { BackgroundColor = RageUI.ItemsColour.SocialClub, HighLightColor = RageUI.ItemsColour.SocialClub } })
        Items:AddButton("PlatformBlue", "PlatformBlue", { Color = { BackgroundColor = RageUI.ItemsColour.PlatformBlue, HighLightColor = RageUI.ItemsColour.PlatformBlue } })
        Items:AddButton("PlatformGreen", "PlatformGreen", { Color = { BackgroundColor = RageUI.ItemsColour.PlatformGreen, HighLightColor = RageUI.ItemsColour.PlatformGreen } })
        Items:AddButton("PlatformGrey", "PlatformGrey", { Color = { BackgroundColor = RageUI.ItemsColour.PlatformGrey, HighLightColor = RageUI.ItemsColour.PlatformGrey } })
        Items:AddButton("FacebookBlue", "FacebookBlue", { Color = { BackgroundColor = RageUI.ItemsColour.FacebookBlue, HighLightColor = RageUI.ItemsColour.FacebookBlue } })
        Items:AddButton("IngameBg", "IngameBg", { Color = { BackgroundColor = RageUI.ItemsColour.IngameBg, HighLightColor = RageUI.ItemsColour.IngameBg } })
        Items:AddButton("Darts", "Darts", { Color = { BackgroundColor = RageUI.ItemsColour.Darts, HighLightColor = RageUI.ItemsColour.Darts } })
        Items:AddButton("Waypoint", "Waypoint", { Color = { BackgroundColor = RageUI.ItemsColour.Waypoint, HighLightColor = RageUI.ItemsColour.Waypoint } })
        Items:AddButton("Michael", "Michael", { Color = { BackgroundColor = RageUI.ItemsColour.Michael, HighLightColor = RageUI.ItemsColour.Michael } })
        Items:AddButton("Franklin", "Franklin", { Color = { BackgroundColor = RageUI.ItemsColour.Franklin, HighLightColor = RageUI.ItemsColour.Franklin } })
        Items:AddButton("Trevor", "Trevor", { Color = { BackgroundColor = RageUI.ItemsColour.Trevor, HighLightColor = RageUI.ItemsColour.Trevor } })
        Items:AddButton("GolfP1", "GolfP1", { Color = { BackgroundColor = RageUI.ItemsColour.GolfP1, HighLightColor = RageUI.ItemsColour.GolfP1 } })
        Items:AddButton("GolfP2", "GolfP2", { Color = { BackgroundColor = RageUI.ItemsColour.GolfP2, HighLightColor = RageUI.ItemsColour.GolfP2 } })
        Items:AddButton("GolfP3", "GolfP3", { Color = { BackgroundColor = RageUI.ItemsColour.GolfP3, HighLightColor = RageUI.ItemsColour.GolfP3 } })
        Items:AddButton("GolfP4", "GolfP4", { Color = { BackgroundColor = RageUI.ItemsColour.GolfP4, HighLightColor = RageUI.ItemsColour.GolfP4 } })
        Items:AddButton("WaypointLight", "WaypointLight", { Color = { BackgroundColor = RageUI.ItemsColour.WaypointLight, HighLightColor = RageUI.ItemsColour.WaypointLight } })
        Items:AddButton("WaypointDark", "WaypointDark", { Color = { BackgroundColor = RageUI.ItemsColour.WaypointDark, HighLightColor = RageUI.ItemsColour.WaypointDark } })
        Items:AddButton("PanelLight", "PanelLight", { Color = { BackgroundColor = RageUI.ItemsColour.PanelLight, HighLightColor = RageUI.ItemsColour.PanelLight } })
        Items:AddButton("MichaelDark", "MichaelDark", { Color = { BackgroundColor = RageUI.ItemsColour.MichaelDark, HighLightColor = RageUI.ItemsColour.MichaelDark } })
        Items:AddButton("FranklinDark", "FranklinDark", { Color = { BackgroundColor = RageUI.ItemsColour.FranklinDark, HighLightColor = RageUI.ItemsColour.FranklinDark } })
        Items:AddButton("TrevorDark", "TrevorDark", { Color = { BackgroundColor = RageUI.ItemsColour.TrevorDark, HighLightColor = RageUI.ItemsColour.TrevorDark } })
        Items:AddButton("ObjectiveRoute", "ObjectiveRoute", { Color = { BackgroundColor = RageUI.ItemsColour.ObjectiveRoute, HighLightColor = RageUI.ItemsColour.ObjectiveRoute } })
        Items:AddButton("PausemapTint", "PausemapTint", { Color = { BackgroundColor = RageUI.ItemsColour.PausemapTint, HighLightColor = RageUI.ItemsColour.PausemapTint } })
        Items:AddButton("PauseDeselect", "PauseDeselect", { Color = { BackgroundColor = RageUI.ItemsColour.PauseDeselect, HighLightColor = RageUI.ItemsColour.PauseDeselect } })
        Items:AddButton("PmWeaponsPurchasable", "PmWeaponsPurchasable", { Color = { BackgroundColor = RageUI.ItemsColour.PmWeaponsPurchasable, HighLightColor = RageUI.ItemsColour.PmWeaponsPurchasable } })
        Items:AddButton("PmWeaponsLocked", "PmWeaponsLocked", { Color = { BackgroundColor = RageUI.ItemsColour.PmWeaponsLocked, HighLightColor = RageUI.ItemsColour.PmWeaponsLocked } })
        Items:AddButton("ScreenBg", "ScreenBg", { Color = { BackgroundColor = RageUI.ItemsColour.ScreenBg, HighLightColor = RageUI.ItemsColour.ScreenBg } })
        Items:AddButton("Chop", "Chop", { Color = { BackgroundColor = RageUI.ItemsColour.Chop, HighLightColor = RageUI.ItemsColour.Chop } })
        Items:AddButton("PausemapTintHalf", "PausemapTintHalf", { Color = { BackgroundColor = RageUI.ItemsColour.PausemapTintHalf, HighLightColor = RageUI.ItemsColour.PausemapTintHalf } })
        Items:AddButton("NorthBlueOfficial", "NorthBlueOfficial", { Color = { BackgroundColor = RageUI.ItemsColour.NorthBlueOfficial, HighLightColor = RageUI.ItemsColour.NorthBlueOfficial } })
        Items:AddButton("ScriptVariable2", "ScriptVariable2", { Color = { BackgroundColor = RageUI.ItemsColour.ScriptVariable2, HighLightColor = RageUI.ItemsColour.ScriptVariable2 } })
        Items:AddButton("H", "H", { Color = { BackgroundColor = RageUI.ItemsColour.H, HighLightColor = RageUI.ItemsColour.H } })
        Items:AddButton("HDark", "HDark", { Color = { BackgroundColor = RageUI.ItemsColour.HDark, HighLightColor = RageUI.ItemsColour.HDark } })
        Items:AddButton("T", "T", { Color = { BackgroundColor = RageUI.ItemsColour.T, HighLightColor = RageUI.ItemsColour.T } })
        Items:AddButton("TDark", "TDark", { Color = { BackgroundColor = RageUI.ItemsColour.TDark, HighLightColor = RageUI.ItemsColour.TDark } })
        Items:AddButton("HShard", "HShard", { Color = { BackgroundColor = RageUI.ItemsColour.HShard, HighLightColor = RageUI.ItemsColour.HShard } })
        Items:AddButton("ControllerMichael", "ControllerMichael", { Color = { BackgroundColor = RageUI.ItemsColour.ControllerMichael, HighLightColor = RageUI.ItemsColour.ControllerMichael } })
        Items:AddButton("ControllerFranklin", "ControllerFranklin", { Color = { BackgroundColor = RageUI.ItemsColour.ControllerFranklin, HighLightColor = RageUI.ItemsColour.ControllerFranklin } })
        Items:AddButton("ControllerTrevor", "ControllerTrevor", { Color = { BackgroundColor = RageUI.ItemsColour.ControllerTrevor, HighLightColor = RageUI.ItemsColour.ControllerTrevor } })
        Items:AddButton("ControllerChop", "ControllerChop", { Color = { BackgroundColor = RageUI.ItemsColour.ControllerChop, HighLightColor = RageUI.ItemsColour.ControllerChop } })
        Items:AddButton("VideoEditorVideo", "VideoEditorVideo", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorVideo, HighLightColor = RageUI.ItemsColour.VideoEditorVideo } })
        Items:AddButton("VideoEditorAudio", "VideoEditorAudio", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorAudio, HighLightColor = RageUI.ItemsColour.VideoEditorAudio } })
        Items:AddButton("VideoEditorText", "VideoEditorText", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorText, HighLightColor = RageUI.ItemsColour.VideoEditorText } })
        Items:AddButton("HbBlue", "HbBlue", { Color = { BackgroundColor = RageUI.ItemsColour.HbBlue, HighLightColor = RageUI.ItemsColour.HbBlue } })
        Items:AddButton("HbYellow", "HbYellow", { Color = { BackgroundColor = RageUI.ItemsColour.HbYellow, HighLightColor = RageUI.ItemsColour.HbYellow } })
        Items:AddButton("VideoEditorScore", "VideoEditorScore", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorScore, HighLightColor = RageUI.ItemsColour.VideoEditorScore } })
        Items:AddButton("VideoEditorAudioFadeout", "VideoEditorAudioFadeout", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorAudioFadeout, HighLightColor = RageUI.ItemsColour.VideoEditorAudioFadeout } })
        Items:AddButton("VideoEditorTextFadeout", "VideoEditorTextFadeout", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorTextFadeout, HighLightColor = RageUI.ItemsColour.VideoEditorTextFadeout } })
        Items:AddButton("VideoEditorScoreFadeout", "VideoEditorScoreFadeout", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorScoreFadeout, HighLightColor = RageUI.ItemsColour.VideoEditorScoreFadeout } })
        Items:AddButton("HeistBackground", "HeistBackground", { Color = { BackgroundColor = RageUI.ItemsColour.HeistBackground, HighLightColor = RageUI.ItemsColour.HeistBackground } })
        Items:AddButton("VideoEditorAmbient", "VideoEditorAmbient", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorAmbient, HighLightColor = RageUI.ItemsColour.VideoEditorAmbient } })
        Items:AddButton("VideoEditorAmbientFadeout", "VideoEditorAmbientFadeout", { Color = { BackgroundColor = RageUI.ItemsColour.VideoEditorAmbientFadeout, HighLightColor = RageUI.ItemsColour.VideoEditorAmbientFadeout } })
        Items:AddButton("Gb", "Gb", { Color = { BackgroundColor = RageUI.ItemsColour.Gb, HighLightColor = RageUI.ItemsColour.Gb } })
        Items:AddButton("G", "G", { Color = { BackgroundColor = RageUI.ItemsColour.G, HighLightColor = RageUI.ItemsColour.G } })
        Items:AddButton("B", "B", { Color = { BackgroundColor = RageUI.ItemsColour.B, HighLightColor = RageUI.ItemsColour.B } })
        Items:AddButton("LowFlow", "LowFlow", { Color = { BackgroundColor = RageUI.ItemsColour.LowFlow, HighLightColor = RageUI.ItemsColour.LowFlow } })
        Items:AddButton("LowFlowDark", "LowFlowDark", { Color = { BackgroundColor = RageUI.ItemsColour.LowFlowDark, HighLightColor = RageUI.ItemsColour.LowFlowDark } })
        Items:AddButton("G1", "G1", { Color = { BackgroundColor = RageUI.ItemsColour.G1, HighLightColor = RageUI.ItemsColour.G1 } })
        Items:AddButton("G2", "G2", { Color = { BackgroundColor = RageUI.ItemsColour.G2, HighLightColor = RageUI.ItemsColour.G2 } })
        Items:AddButton("G3", "G3", { Color = { BackgroundColor = RageUI.ItemsColour.G3, HighLightColor = RageUI.ItemsColour.G3 } })
        Items:AddButton("G4", "G4", { Color = { BackgroundColor = RageUI.ItemsColour.G4, HighLightColor = RageUI.ItemsColour.G4 } })
        Items:AddButton("G5", "G5", { Color = { BackgroundColor = RageUI.ItemsColour.G5, HighLightColor = RageUI.ItemsColour.G5 } })
        Items:AddButton("G6", "G6", { Color = { BackgroundColor = RageUI.ItemsColour.G6, HighLightColor = RageUI.ItemsColour.G6 } })
        Items:AddButton("G7", "G7", { Color = { BackgroundColor = RageUI.ItemsColour.G7, HighLightColor = RageUI.ItemsColour.G7 } })
        Items:AddButton("G8", "G8", { Color = { BackgroundColor = RageUI.ItemsColour.G8, HighLightColor = RageUI.ItemsColour.G8 } })
        Items:AddButton("G9", "G9", { Color = { BackgroundColor = RageUI.ItemsColour.G9, HighLightColor = RageUI.ItemsColour.G9 } })
        Items:AddButton("G10", "G10", { Color = { BackgroundColor = RageUI.ItemsColour.G10, HighLightColor = RageUI.ItemsColour.G10 } })
        Items:AddButton("G11", "G11", { Color = { BackgroundColor = RageUI.ItemsColour.G11, HighLightColor = RageUI.ItemsColour.G11 } })
        Items:AddButton("G12", "G12", { Color = { BackgroundColor = RageUI.ItemsColour.G12, HighLightColor = RageUI.ItemsColour.G12 } })
        Items:AddButton("G13", "G13", { Color = { BackgroundColor = RageUI.ItemsColour.G13, HighLightColor = RageUI.ItemsColour.G13 } })
        Items:AddButton("G14", "G14", { Color = { BackgroundColor = RageUI.ItemsColour.G14, HighLightColor = RageUI.ItemsColour.G14 } })
        Items:AddButton("G15", "G15", { Color = { BackgroundColor = RageUI.ItemsColour.G15, HighLightColor = RageUI.ItemsColour.G15 } })
        Items:AddButton("Adversary", "Adversary", { Color = { BackgroundColor = RageUI.ItemsColour.Adversary, HighLightColor = RageUI.ItemsColour.Adversary } })
        Items:AddButton("DegenRed", "DegenRed", { Color = { BackgroundColor = RageUI.ItemsColour.DegenRed, HighLightColor = RageUI.ItemsColour.DegenRed } })
        Items:AddButton("DegenYellow", "DegenYellow", { Color = { BackgroundColor = RageUI.ItemsColour.DegenYellow, HighLightColor = RageUI.ItemsColour.DegenYellow } })
        Items:AddButton("DegenGreen", "DegenGreen", { Color = { BackgroundColor = RageUI.ItemsColour.DegenGreen, HighLightColor = RageUI.ItemsColour.DegenGreen } })
        Items:AddButton("DegenCyan", "DegenCyan", { Color = { BackgroundColor = RageUI.ItemsColour.DegenCyan, HighLightColor = RageUI.ItemsColour.DegenCyan } })
        Items:AddButton("DegenBlue", "DegenBlue", { Color = { BackgroundColor = RageUI.ItemsColour.DegenBlue, HighLightColor = RageUI.ItemsColour.DegenBlue } })
        Items:AddButton("DegenMagenta", "DegenMagenta", { Color = { BackgroundColor = RageUI.ItemsColour.DegenMagenta, HighLightColor = RageUI.ItemsColour.DegenMagenta } })
        Items:AddButton("Stunt1", "Stunt1", { Color = { BackgroundColor = RageUI.ItemsColour.Stunt1, HighLightColor = RageUI.ItemsColour.Stunt1 } })
        Items:AddButton("Stunt2", "Stunt2", { Color = { BackgroundColor = RageUI.ItemsColour.Stunt2, HighLightColor = RageUI.ItemsColour.Stunt2 } })
    end)
end

Keys.Register("F4", "F4", "Test", function()
	RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
end)

-- Keys.Register("F5", "F5", "Test", function()
-- 	RageUI.Visible(SecondMainMenu, not RageUI.Visible(SecondMainMenu))
-- end)
