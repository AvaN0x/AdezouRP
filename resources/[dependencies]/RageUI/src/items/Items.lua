---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- created at [24/05/2021 10:02]
---


local ItemsSettings = {
    CheckBox = {
        Textures = {
            "shop_box_blankb", -- 1
            "shop_box_tickb", -- 2
            "shop_box_blank", -- 3
            "shop_box_tick", -- 4
            "shop_box_crossb", -- 5
            "shop_box_cross", -- 6
        },
        X = 380, Y = -6, Width = 50, Height = 50
    },
    Rectangle = {
        Y = 0, Width = 431, Height = 38
    }
}

local function StyleCheckBox(Selected, Checked, Box, BoxSelect, OffSet)
    local CurrentMenu = RageUI.CurrentMenu;
    if OffSet == nil then
        OffSet = 0
    end
    if Selected then
        if Checked then
            Graphics.Sprite("commonmenu", ItemsSettings.CheckBox.Textures[Box], CurrentMenu.X + 380 + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + -6 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 50, 50)
        else
            Graphics.Sprite("commonmenu", ItemsSettings.CheckBox.Textures[1], CurrentMenu.X + 380 + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + -6 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 50, 50)
        end
    else
        if Checked then
            Graphics.Sprite("commonmenu", ItemsSettings.CheckBox.Textures[BoxSelect], CurrentMenu.X + 380 + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + -6 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 50, 50)
        else
            Graphics.Sprite("commonmenu", ItemsSettings.CheckBox.Textures[3], CurrentMenu.X + 380 + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + -6 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 50, 50)
        end
    end
end

---@class Items
Items = {}

---AddButton
---
--- Add items button.
---
---@param Label string
---@param Description string
---@param Style table
---@param Actions fun(onSelected:boolean)
---@param Submenu any
---@public
---@return void
function Items:AddButton(Label, Description, Style, Actions, Submenu)
    local CurrentMenu = RageUI.CurrentMenu
    local Option = RageUI.Options + 1
    if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
        if not Style then Style = {} end
        local Active = CurrentMenu.Index == Option
        RageUI.ItemsSafeZone(CurrentMenu)
        local haveLeftBadge = Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None
        local haveRightBadge = (Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None)
        -- local LeftBadgeOffset = haveLeftBadge and 27 or 0
        local LeftBadgeOffset = haveLeftBadge and 32 or 0
        local RightBadgeOffset = haveRightBadge and 32 or 0
        if Style.Color and Style.Color.BackgroundColor then
            Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + 0 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 431 + CurrentMenu.WidthOffset, 38, Style.Color.BackgroundColor[1], Style.Color.BackgroundColor[2], Style.Color.BackgroundColor[3], Style.Color.BackgroundColor[4])
        end
        if Active then
            if Style.Color and Style.Color.HighLightColor then
                Graphics.Rectangle(CurrentMenu.X, CurrentMenu.Y + 0 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 431 + CurrentMenu.WidthOffset, 38, Style.Color.HighLightColor[1], Style.Color.HighLightColor[2], Style.Color.HighLightColor[3], Style.Color.HighLightColor[4])
            else
                Graphics.Sprite("commonmenu", "gradient_nav", CurrentMenu.X, CurrentMenu.Y + 0 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 431 + CurrentMenu.WidthOffset, 38)
            end
        end
        if not (Style.IsDisabled) then
            if haveLeftBadge then
                if (Style.LeftBadge ~= nil) then
                    local LeftBadge = Style.LeftBadge(Active)
                    Graphics.Sprite(LeftBadge.BadgeDictionary or "commonmenu", LeftBadge.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, LeftBadge.BadgeColour and LeftBadge.BadgeColour.R or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.G or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.B or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.A or 255)
                end
            end
            if haveRightBadge then
                if (Style.RightBadge ~= nil) then
                    local RightBadge = Style.RightBadge(Active)
                    Graphics.Sprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + 385 + CurrentMenu.WidthOffset, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                end
            end
            if Style.RightLabel then
                Graphics.Text(Style.RightLabel, CurrentMenu.X + 420 - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + 4 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, Active and 0 or 245, Active and 0 or 245, Active and 0 or 245, 255, 2)
            end
            Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, Active and 0 or 245, Active and 0 or 245, Active and 0 or 245, 255)
        else
            local RightBadge = RageUI.BadgeStyle.Lock(Active)
            Graphics.Sprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + 385 + CurrentMenu.WidthOffset, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
            Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 163, 159, 148, 255)
        end
        RageUI.ItemOffset = RageUI.ItemOffset + 38
        if (Active) then
            RageUI.ItemsDescription(Description);
            if not (Style.IsDisabled) then
                local Selected = (CurrentMenu.Controls.Select.Active)
                if Actions then
                    Actions(Selected)
                end
                if Selected then
                    Audio.PlaySound(RageUI.Settings.Audio.Select.audioName, RageUI.Settings.Audio.Select.audioRef)
                    if Submenu and Submenu() then
                        RageUI.NextMenu = Submenu
                    end
                end
            end
        end
    end
    RageUI.Options = RageUI.Options + 1
end

---CheckBox
---@param Label string
---@param Description string
---@param Checked boolean
---@param Style table
---@param Actions fun(onSelected:boolean, IsChecked:boolean)
function Items:CheckBox(Label, Description, Checked, Style, Actions)
    local CurrentMenu = RageUI.CurrentMenu;

    local Option = RageUI.Options + 1
    if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
        if not Style then Style = {} end

        local Active = CurrentMenu.Index == Option;
        local Selected = false;
        local LeftBadgeOffset = ((Style.LeftBadge == RageUI.BadgeStyle.None or Style.LeftBadge == nil) and 0 or 27)
        local RightBadgeOffset = ((Style.RightBadge == RageUI.BadgeStyle.None or Style.RightBadge == nil) and 0 or 32)
        local BoxOffset = 0
        RageUI.ItemsSafeZone(CurrentMenu)

        if (Active) then
            Graphics.Sprite("commonmenu", "gradient_nav", CurrentMenu.X, CurrentMenu.Y + 0 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 431 + CurrentMenu.WidthOffset, 38)
        end

        if (Style.IsDisabled == nil) or not (Style.IsDisabled) then
            if Active then
                Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 0, 0, 0, 255)
            else
                Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 245, 245, 245, 255)
            end
            if Style.LeftBadge ~= nil then
                if Style.LeftBadge ~= RageUI.BadgeStyle.None then
                    local BadgeData = Style.LeftBadge(Active)
                    Graphics.Sprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                end
            end
            if Style.RightBadge ~= nil then
                if Style.RightBadge ~= RageUI.BadgeStyle.None then
                    local BadgeData = Style.RightBadge(Active)
                    Graphics.Sprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X + 385 + CurrentMenu.WidthOffset, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                end
            end
        else
            local LeftBadge = RageUI.BadgeStyle.Lock
            LeftBadgeOffset = ((LeftBadge == RageUI.BadgeStyle.None or LeftBadge == nil) and 0 or 27)

            if Active then
                Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 0, 0, 0, 255)
            else
                Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 163, 159, 148, 255)
            end

            if LeftBadge ~= RageUI.BadgeStyle.None and LeftBadge ~= nil then
                local BadgeData = LeftBadge(Active)
                Graphics.Sprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour.A or 255)
            end
        end

        if (Active) then
            if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                Graphics.Text(Style.RightLabel, CurrentMenu.X + 420 - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + 4 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, 0, 0, 0, 255, 2)
                BoxOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
            end
        else
            if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                Graphics.Text(Style.RightLabel, CurrentMenu.X + 420 - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + 4 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, 245, 245, 245, 255, 2)
                BoxOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
            end
        end

        BoxOffset = RightBadgeOffset + BoxOffset
        if Style.Style ~= nil then
            if Style.Style == 1 then
                StyleCheckBox(Active, Checked, 2, 4, BoxOffset)
            elseif Style.Style == 2 then -- Style == 2 is Times instead of Tick
                StyleCheckBox(Active, Checked, 5, 6, BoxOffset)
            else
                StyleCheckBox(Active, Checked, 2, 4, BoxOffset)
            end
        else
            StyleCheckBox(Active, Checked, 2, 4, BoxOffset)
        end

        if (Active) and (CurrentMenu.Controls.Select.Active) then
            Selected = true;
            Checked = not Checked
            Audio.PlaySound(RageUI.Settings.Audio.Select.audioName, RageUI.Settings.Audio.Select.audioRef)
        end

        if (Active) then
            if Actions then
                Actions(Selected, Checked)
            end
            RageUI.ItemsDescription(Description)
        end

        RageUI.ItemOffset = RageUI.ItemOffset + 38
    end
    RageUI.Options = RageUI.Options + 1
end

---AddSeparator
---
--- Add separator
---
---@param Label string
---@public
---@return void
function Items:AddSeparator(Label)
    local CurrentMenu = RageUI.CurrentMenu
    local Option = RageUI.Options + 1
    if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
        local Active = CurrentMenu.Index == Option;
        if (Label ~= nil) then
            Graphics.Text(Label, CurrentMenu.X + 0 + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 200), CurrentMenu.Y + 0 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 245, 245, 245, 255, 1)
        end
        RageUI.ItemOffset = RageUI.ItemOffset + 38
        if (Active) then
            if (RageUI.LastControl) then
                CurrentMenu.Index = Option - 1
                if (CurrentMenu.Index < 1) then
                    CurrentMenu.Index = RageUI.CurrentMenu.Options
                end
            else
                CurrentMenu.Index = Option + 1
            end
            RageUI.ItemsDescription(nil)
        end
    end
    RageUI.Options = RageUI.Options + 1
end

---AddList
---@param Label string
---@param Items table<any, any>
---@param Index number
---@param Style table<any, any>
---@param Description string
---@param Actions fun(Index:number, onSelected:boolean, onListChange:boolean))
---@param Submenu any
function Items:AddList(Label, Items, Index, Description, Style, Actions, Submenu)
    local CurrentMenu = RageUI.CurrentMenu;

    local Option = RageUI.Options + 1
    if CurrentMenu and CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
        if not Style then Style = {} end

        local Active = CurrentMenu.Index == Option;
        local onListChange = false;
        RageUI.ItemsSafeZone(CurrentMenu)
        local LeftBadgeOffset = ((Style.LeftBadge == RageUI.BadgeStyle.None or Style.LeftBadge == nil) and 0 or 27)
        local RightBadgeOffset = ((Style.RightBadge == RageUI.BadgeStyle.None or Style.RightBadge == nil) and 0 or 32)
        local RightOffset = 0
        local ListText = (type(Items[Index]) == "table") and string.format("← %s →", Items[Index].Name) or string.format("← %s →", Items[Index]) or "NIL"

        if (Active) then
            Graphics.Sprite("commonmenu", "gradient_nav", CurrentMenu.X, CurrentMenu.Y + 0 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 431 + CurrentMenu.WidthOffset, 38)
        end

        if (not Style.IsDisabled) then
            if Active then
                if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                    Graphics.Text(Style.RightLabel, CurrentMenu.X + 420 - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + 4 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, 0, 0, 0, 255, 2)
                    RightOffset = Graphics.MeasureStringWidth(Style.RightLabel, 0, 0.35)
                end
            else
                if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                    RightOffset = Graphics.MeasureStringWidth(Style.RightLabel, 0, 0.35)
                    Graphics.Text(Style.RightLabel, CurrentMenu.X + 420 - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + 4 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, 245, 245, 245, 255, 2)
                end
            end
        end
        RightOffset = RightBadgeOffset * 1.3 + RightOffset
        if (not Style.IsDisabled) then
            if (Active) then
                Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 0, 0, 0, 255)
                Graphics.Text(ListText, CurrentMenu.X + 403 + 15 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, 0, 0, 0, 255, 2)
            else
                Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 245, 245, 245, 255)
                Graphics.Text(ListText, CurrentMenu.X + 403 + 15 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, 245, 245, 245, 255, 2)
            end
        else
            Graphics.Text(Label, CurrentMenu.X + 8 + LeftBadgeOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.33, 163, 159, 148, 255)
            Graphics.Text(ListText, CurrentMenu.X + 403 + 15 + CurrentMenu.WidthOffset, CurrentMenu.Y + 3 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, 0.35, 163, 159, 148, 255, 2)
        end

        if type(Style) == "table" then
            if Style.Enabled == true or Style.Enabled == nil then
                if type(Style) == 'table' then
                    if Style.LeftBadge ~= nil then
                        if Style.LeftBadge ~= RageUI.BadgeStyle.None then
                            local BadgeData = Style.LeftBadge(Active)
                            Graphics.Sprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                        end
                    end

                    if Style.RightBadge ~= nil then
                        if Style.RightBadge ~= RageUI.BadgeStyle.None then
                            local BadgeData = Style.RightBadge(Active)
                            Graphics.Sprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X + 385 + CurrentMenu.WidthOffset, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                        end
                    end
                end
            else
                local LeftBadge = RageUI.BadgeStyle.Lock
                if LeftBadge ~= RageUI.BadgeStyle.None and LeftBadge ~= nil then
                    local BadgeData = LeftBadge(Active)
                    Graphics.Sprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + -2 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 40, 40, 0, BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour.A or 255)
                end
            end
        else
            error("UICheckBox Style is not a `table`")
        end

        RageUI.ItemOffset = RageUI.ItemOffset + 38

        if (Active) then
            RageUI.ItemsDescription(Description);
            if (not Style.IsDisabled) then
                if (CurrentMenu.Controls.Left.Active) and not (CurrentMenu.Controls.Right.Active) then
                    Index = Index - 1
                    if Index < 1 then
                        Index = #Items
                    end
                    onListChange = true
                    Audio.PlaySound(RageUI.Settings.Audio.LeftRight.audioName, RageUI.Settings.Audio.LeftRight.audioRef)
                elseif (CurrentMenu.Controls.Right.Active) and not (CurrentMenu.Controls.Left.Active) then
                    Index = Index + 1
                    if Index > #Items then
                        Index = 1
                    end
                    onListChange = true
                    Audio.PlaySound(RageUI.Settings.Audio.LeftRight.audioName, RageUI.Settings.Audio.LeftRight.audioRef)
                end
                local Selected = (CurrentMenu.Controls.Select.Active)
                if Actions then
                    Actions(Index, Selected, onListChange, Active)
                end
                if (Selected) then
                    Audio.PlaySound(RageUI.Settings.Audio.Select.audioName, RageUI.Settings.Audio.Select.audioRef)
                    if Submenu ~= nil and type(Submenu) == "table" then
                        RageUI.NextMenu = Submenu[Index]
                    end
                end
            end
        end
    end
    RageUI.Options = RageUI.Options + 1
end

---Heritage
---@param Mum number
---@param Dad number
function Items:Heritage(Mum, Dad)
    local CurrentMenu = RageUI.CurrentMenu;
    if CurrentMenu then
        if Mum < 0 or Mum > 21 then
            Mum = 0
        end
        if Dad < 0 or Dad > 23 then
            Dad = 0
        end
        if Mum == 21 then
            Mum = "special_female_" .. (tonumber(string.sub(Mum, 2, 2)) - 1)
        else
            Mum = "female_" .. Mum
        end
        if Dad >= 21 then
            Dad = "special_male_" .. (tonumber(string.sub(Dad, 2, 2)) - 1)
        else
            Dad = "male_" .. Dad
        end
        Graphics.Sprite("pause_menu_pages_char_mom_dad", "mumdadbg", CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 431 + (CurrentMenu.WidthOffset / 1), 228)
        Graphics.Sprite("char_creator_portraits", Dad, CurrentMenu.X + 195 + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 228, 228)
        Graphics.Sprite("char_creator_portraits", Mum, CurrentMenu.X + 25 + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 228, 228)
        RageUI.ItemOffset = RageUI.ItemOffset + 228
    end
end





---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---@type table
local SettingsSlider = {
    Background = { X = 250, Y = 14.5, Width = 150, Height = 9 },
    Slider = { X = 250, Y = 14.5, Width = 75, Height = 9 },
    Divider = { X = 323.5, Y = 9, Width = 2.5, Height = 20 },
    LeftArrow = { Dictionary = "commonmenutu", Texture = "arrowleft", X = 235, Y = 11.5, Width = 15, Height = 15 },
    RightArrow = { Dictionary = "commonmenutu", Texture = "arrowright", X = 400, Y = 11.5, Width = 15, Height = 15 },
}


---Slider
---@param Label string
---@param SliderIndex number
---@param SliderMax number
---@param Description string
---@param Divider boolean
---@param Callback function
function Items:Slider(Label, SliderIndex, SliderMax, Description, Divider, Style, Callback)
    ---@type table
    local CurrentMenu = RageUI.CurrentMenu;

    if CurrentMenu ~= nil then
        if not Style then Style = {} end

        local Items = {}
        for i = 1, SliderMax do
            table.insert(Items, i)
        end
        ---@type number
        local Option = RageUI.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

            ---@type number
            local Selected = CurrentMenu.Index == Option

            ---@type boolean
            local LeftArrowHovered, RightArrowHovered = false, false

            RageUI.ItemsSafeZone(CurrentMenu)

            local Hovered = false;
            local LeftBadgeOffset = ((Style.LeftBadge == RageUI.BadgeStyle.None or tonumber(Style.LeftBadge) == nil) and 0 or 27)
            local RightBadgeOffset = ((Style.RightBadge == RageUI.BadgeStyle.None or tonumber(Style.RightBadge) == nil) and 0 or 32)
            local RightOffset = 0

            if Selected then
                Graphics.Sprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                LeftArrowHovered = Graphics.IsMouseInBounds(CurrentMenu.X + SettingsSlider.LeftArrow.X + CurrentMenu.SafeZoneSize.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsSlider.LeftArrow.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsSlider.LeftArrow.Width, SettingsSlider.LeftArrow.Height)
                RightArrowHovered = Graphics.IsMouseInBounds(CurrentMenu.X + SettingsSlider.RightArrow.X + CurrentMenu.SafeZoneSize.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsSlider.RightArrow.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsSlider.RightArrow.Width, SettingsSlider.RightArrow.Height)

                RageUI.ItemsDescription(Description)
            end
            if not (Style.IsDisabled) then
                if Selected then
                    if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                        Graphics.Text(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 0, 0, 0, 255, 2)
                        RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                    end
                else
                    if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                        RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                        Graphics.Text(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
                    end
                end
            end
            RightOffset = RightOffset + RightBadgeOffset
            if not (Style.IsDisabled) then
                if Selected then
                    Graphics.Text(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)

                    Graphics.Sprite((Style.LeftArrow and Style.LeftArrow.Dictionary or SettingsSlider.LeftArrow.Dictionary), (Style.LeftArrow and Style.LeftArrow.Texture or SettingsSlider.LeftArrow.Texture), CurrentMenu.X + (Style.LeftArrow and Style.LeftArrow.X or SettingsSlider.LeftArrow.X) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + (Style.LeftArrow and Style.LeftArrow.Y or SettingsSlider.LeftArrow.Y) + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, (Style.LeftArrow and Style.LeftArrow.Width or SettingsSlider.LeftArrow.Width), (Style.LeftArrow and Style.LeftArrow.Height or SettingsSlider.LeftArrow.Height), 0, 0, 0, 0, 255)
                    Graphics.Sprite((Style.RightArrow and Style.RightArrow.Dictionary or SettingsSlider.RightArrow.Dictionary), (Style.RightArrow and Style.RightArrow.Texture or SettingsSlider.RightArrow.Texture), CurrentMenu.X + (Style.RightArrow and Style.RightArrow.X or SettingsSlider.RightArrow.X) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + (Style.RightArrow and Style.RightArrow.Y or SettingsSlider.RightArrow.Y) + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, (Style.RightArrow and Style.RightArrow.Width or SettingsSlider.RightArrow.Width), (Style.RightArrow and Style.RightArrow.Height or SettingsSlider.RightArrow.Height), 0, 0, 0, 0, 255)
                else
                    Graphics.Text(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)

                    if Style.ShowWhenNotSelected then
                        Graphics.Sprite((Style.LeftArrow and Style.LeftArrow.Dictionary or SettingsSlider.LeftArrow.Dictionary), (Style.LeftArrow and Style.LeftArrow.Texture or SettingsSlider.LeftArrow.Texture), CurrentMenu.X + (Style.LeftArrow and Style.LeftArrow.X or SettingsSlider.LeftArrow.X) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + (Style.LeftArrow and Style.LeftArrow.Y or SettingsSlider.LeftArrow.Y) + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, (Style.LeftArrow and Style.LeftArrow.Width or SettingsSlider.LeftArrow.Width), (Style.LeftArrow and Style.LeftArrow.Height or SettingsSlider.LeftArrow.Height), 0, 255, 255, 255, 255)
                        Graphics.Sprite((Style.RightArrow and Style.RightArrow.Dictionary or SettingsSlider.RightArrow.Dictionary), (Style.RightArrow and Style.RightArrow.Texture or SettingsSlider.RightArrow.Texture), CurrentMenu.X + (Style.RightArrow and Style.RightArrow.X or SettingsSlider.RightArrow.X) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + (Style.RightArrow and Style.RightArrow.Y or SettingsSlider.RightArrow.Y) + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, (Style.RightArrow and Style.RightArrow.Width or SettingsSlider.RightArrow.Width), (Style.RightArrow and Style.RightArrow.Height or SettingsSlider.RightArrow.Height), 0, 255, 255, 255, 255)
                    end
                end
            else
                Graphics.Text(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)

                if Selected then
                    Graphics.Sprite((Style.LeftArrow and Style.LeftArrow.Dictionary or SettingsSlider.LeftArrow.Dictionary), (Style.LeftArrow and Style.LeftArrow.Texture or SettingsSlider.LeftArrow.Texture), CurrentMenu.X + (Style.LeftArrow and Style.LeftArrow.X or SettingsSlider.LeftArrow.X) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + (Style.LeftArrow and Style.LeftArrow.Y or SettingsSlider.LeftArrow.Y) + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, (Style.LeftArrow and Style.LeftArrow.Width or SettingsSlider.LeftArrow.Width), (Style.LeftArrow and Style.LeftArrow.Height or SettingsSlider.LeftArrow.Height), 163, 159, 148, 255)
                    Graphics.Sprite((Style.RightArrow and Style.RightArrow.Dictionary or SettingsSlider.RightArrow.Dictionary), (Style.RightArrow and Style.RightArrow.Texture or SettingsSlider.RightArrow.Texture), CurrentMenu.X + (Style.RightArrow and Style.RightArrow.X or SettingsSlider.RightArrow.X) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + (Style.RightArrow and Style.RightArrow.Y or SettingsSlider.RightArrow.Y) + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, (Style.RightArrow and Style.RightArrow.Width or SettingsSlider.RightArrow.Width), (Style.RightArrow and Style.RightArrow.Height or SettingsSlider.RightArrow.Height), 163, 159, 148, 255)
                end
            end
            
            if type(Style) == "table" then
                if not (Style.IsDisabled) then
                    if type(Style) == 'table' then
                        if Style.LeftBadge ~= nil then
                            if Style.LeftBadge ~= RageUI.BadgeStyle.None and tonumber(Style.LeftBadge) ~= nil then
                                Graphics.Sprite(RageUI.GetBadgeDictionary(Style.LeftBadge, Selected), RageUI.GetBadgeTexture(Style.LeftBadge, Selected), CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, RageUI.GetBadgeColour(Style.LeftBadge, Selected))
                            end
                        end
                        if Style.RightBadge ~= nil then
                            if Style.RightBadge ~= RageUI.BadgeStyle.None and tonumber(Style.RightBadge) ~= nil then
                                Graphics.Sprite(RageUI.GetBadgeDictionary(Style.RightBadge, Selected), RageUI.GetBadgeTexture(Style.RightBadge, Selected), CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RageUI.GetBadgeColour(Style.RightBadge, Selected))
                            end
                        end
                    end
                else
                    ---@type table
                    local LeftBadge = RageUI.BadgeStyle.Lock
                    ---@type number
                    local LeftBadgeOffset = ((LeftBadge == RageUI.BadgeStyle.None or tonumber(LeftBadge) == nil) and 0 or 27)
                    if LeftBadge ~= RageUI.BadgeStyle.None and tonumber(LeftBadge) ~= nil then
                        Graphics.Sprite(RageUI.GetBadgeDictionary(LeftBadge, Selected), RageUI.GetBadgeTexture(LeftBadge, Selected), CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, nil, CheckBoxLockBadgeColor(Selected))
                    end
                end
            end

            Graphics.Rectangle(CurrentMenu.X + SettingsSlider.Background.X + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsSlider.Background.Width, SettingsSlider.Background.Height, 4, 32, 57, 255)
            Graphics.Rectangle(CurrentMenu.X + SettingsSlider.Slider.X + (((SettingsSlider.Background.Width - SettingsSlider.Slider.Width) / (#Items - 1)) * (SliderIndex - 1)) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.Slider.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsSlider.Slider.Width, SettingsSlider.Slider.Height, 57, 116, 200, 255)

            if Divider then
                Graphics.Rectangle(CurrentMenu.X + SettingsSlider.Divider.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsSlider.Divider.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsSlider.Divider.Width, SettingsSlider.Divider.Height, 245, 245, 245, 255)
            end

            RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height

            if Selected and (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) and not (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) then
                SliderIndex = SliderIndex - 1

                if SliderIndex < 1 then
                    SliderIndex = #Items
                end

                Audio.PlaySound(RageUI.Settings.Audio.LeftRight.audioName, RageUI.Settings.Audio.LeftRight.audioRef)
            elseif Selected and (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) and not (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) then
                SliderIndex = SliderIndex + 1
                if SliderIndex > #Items then
                    SliderIndex = 1
                end

                Audio.PlaySound(RageUI.Settings.Audio.LeftRight.audioName, RageUI.Settings.Audio.LeftRight.audioRef)
            end

            local Active = CurrentMenu.Controls.Select.Active or ((Hovered and CurrentMenu.Controls.Click.Active) and (not LeftArrowHovered and not RightArrowHovered))
            if Selected and Active then
                Audio.PlaySound(RageUI.Settings.Audio.Select.audioName, RageUI.Settings.Audio.Select.audioRef)
            end
            
            if not Style.IsDisabled and Callback then
                Callback(Selected, (Active and Selected), SliderIndex)
            end
        end

        RageUI.Options = RageUI.Options + 1
    end
end



---SliderHeritage
---@param Label string
---@param SliderIndex number
---@param Description string
---@param Callback function
function Items:SliderHeritage(Label, SliderIndex, Description, Callback)
    local Style = {
        ShowWhenNotSelected = true,
        LeftArrow = { Dictionary = "mpleaderboard", Texture = "leaderboard_female_icon", X = 215, Y = 0, Width = 40, Height = 40 },
        RightArrow = { Dictionary = "mpleaderboard", Texture = "leaderboard_male_icon", X = 395, Y = 0, Width = 40, Height = 40 }
    }

    self:Slider(Label, SliderIndex, 20, Description, true, Style, function(selected, active, sliderIndex, percent)
        if Callback then
            print(sliderIndex, percent)
            local percent = (sliderIndex or 0) * 5
            Callback(selected, active, sliderIndex, percent)
        end
    end)
end
