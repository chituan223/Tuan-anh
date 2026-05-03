-- ╔══════════════════════════════════════════════════════╗
-- ║          FAM LV MENU - Script by FamLV Code          ║
-- ║              Giao Diện Đẹp - Version 1.0             ║
-- ╚══════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ══════════════════════════════════════
--          CẤU HÌNH CHÍNH
-- ══════════════════════════════════════
local CONFIG = {
    Title = "FAM LV MENU",
    SubTitle = "Script Hub v1.0",
    AccentColor = Color3.fromRGB(120, 80, 255),    -- Tím neon
    AccentColor2 = Color3.fromRGB(0, 200, 255),    -- Xanh cyan
    BgColor = Color3.fromRGB(12, 12, 20),          -- Nền đen
    BgColor2 = Color3.fromRGB(18, 18, 32),         -- Nền panel
    TextColor = Color3.fromRGB(230, 230, 255),
    SubTextColor = Color3.fromRGB(130, 130, 170),
    ToggleOn = Color3.fromRGB(100, 60, 255),
    ToggleOff = Color3.fromRGB(40, 40, 65),
    GlowColor = Color3.fromRGB(120, 80, 255),
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham,
}

-- ══════════════════════════════════════
--          TẠO SCREENGUI
-- ══════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FamLV_Menu"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Gắn vào CoreGui hoặc PlayerGui
local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not success then
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- ══════════════════════════════════════
--          HÀM TIỆN ÍCH
-- ══════════════════════════════════════
local function Tween(obj, props, time, style, dir)
    local info = TweenInfo.new(
        time or 0.3,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    TweenService:Create(obj, info, props):Play()
end

local function CreateCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function CreateStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or CONFIG.AccentColor
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.5
    s.Parent = parent
    return s
end

local function CreateShadow(parent, color, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = color or Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.Position = UDim2.new(0, -(size or 15), 0, -(size or 15))
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

-- ══════════════════════════════════════
--       KHUNG CHÍNH - MAIN FRAME
-- ══════════════════════════════════════
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
MainFrame.BackgroundColor3 = CONFIG.BgColor
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
CreateCorner(MainFrame, 14)
CreateStroke(MainFrame, CONFIG.AccentColor, 1.5, 0.3)
CreateShadow(MainFrame, Color3.fromRGB(80, 40, 200), 40)

-- Nền gradient
local BgGrad = Instance.new("UIGradient")
BgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 10, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 16, 30)),
})
BgGrad.Rotation = 135
BgGrad.Parent = MainFrame

-- ══════════════════════════════════════
--          THANH TIÊU ĐỀ - TOPBAR
-- ══════════════════════════════════════
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundColor3 = Color3.fromRGB(16, 12, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
CreateCorner(TopBar, 14)

-- Fix góc dưới của topbar
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0.5, 0)
TopBarFix.Position = UDim2.new(0, 0, 0.5, 0)
TopBarFix.BackgroundColor3 = Color3.fromRGB(16, 12, 32)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Đường kẻ dưới topbar (gradient accent)
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.Position = UDim2.new(0, 0, 1, -2)
TopLine.BackgroundColor3 = CONFIG.AccentColor
TopLine.BorderSizePixel = 0
TopLine.Parent = TopBar
local TopLineGrad = Instance.new("UIGradient")
TopLineGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.AccentColor),
    ColorSequenceKeypoint.new(0.5, CONFIG.AccentColor2),
    ColorSequenceKeypoint.new(1, CONFIG.AccentColor),
})
TopLineGrad.Parent = TopLine

-- Icon logo
local LogoFrame = Instance.new("Frame")
LogoFrame.Size = UDim2.new(0, 34, 0, 34)
LogoFrame.Position = UDim2.new(0, 12, 0.5, -17)
LogoFrame.BackgroundColor3 = CONFIG.AccentColor
LogoFrame.BorderSizePixel = 0
LogoFrame.Parent = TopBar
CreateCorner(LogoFrame, 8)
local LogoLabel = Instance.new("TextLabel")
LogoLabel.Size = UDim2.new(1, 0, 1, 0)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "FL"
LogoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoLabel.Font = CONFIG.Font
LogoLabel.TextSize = 15
LogoLabel.Parent = LogoFrame

-- Tên menu
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 0, 24)
TitleLabel.Position = UDim2.new(0, 54, 0, 8)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = CONFIG.Title
TitleLabel.TextColor3 = CONFIG.TextColor
TitleLabel.Font = CONFIG.Font
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar
local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, CONFIG.AccentColor2),
})
TitleGrad.Parent = TitleLabel

local SubTitleLabel = Instance.new("TextLabel")
SubTitleLabel.Size = UDim2.new(0, 200, 0, 16)
SubTitleLabel.Position = UDim2.new(0, 54, 0, 30)
SubTitleLabel.BackgroundTransparency = 1
SubTitleLabel.Text = CONFIG.SubTitle
SubTitleLabel.TextColor3 = CONFIG.SubTextColor
SubTitleLabel.Font = CONFIG.FontLight
SubTitleLabel.TextSize = 12
SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubTitleLabel.Parent = TopBar

-- Nút đóng X
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = CONFIG.Font
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar
CreateCorner(CloseBtn, 8)

-- Nút minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -78, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
MinBtn.Text = "—"
MinBtn.TextColor3 = CONFIG.SubTextColor
MinBtn.Font = CONFIG.Font
MinBtn.TextSize = 13
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar
CreateCorner(MinBtn, 8)

-- ══════════════════════════════════════
--       TAB SIDEBAR (trái)
-- ══════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -52)
Sidebar.Position = UDim2.new(0, 0, 0, 52)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 10, 26)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Đường kẻ phải sidebar
local SidebarLine = Instance.new("Frame")
SidebarLine.Size = UDim2.new(0, 1, 1, 0)
SidebarLine.Position = UDim2.new(1, -1, 0, 0)
SidebarLine.BackgroundColor3 = CONFIG.AccentColor
SidebarLine.BackgroundTransparency = 0.7
SidebarLine.BorderSizePixel = 0
SidebarLine.Parent = Sidebar

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Parent = Sidebar
local TabPad = Instance.new("UIPadding")
TabPad.PaddingTop = UDim.new(0, 10)
TabPad.Parent = Sidebar

-- ══════════════════════════════════════
--       NỘI DUNG PANEL (phải)
-- ══════════════════════════════════════
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -140, 1, -52)
ContentArea.Position = UDim2.new(0, 140, 0, 52)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- ══════════════════════════════════════
--       HỆ THỐNG TAB
-- ══════════════════════════════════════
local Tabs = {}
local ActiveTab = nil
local TabPages = {}

local TabIcons = {
    ["⚡ Combat"] = "⚡",
    ["🚀 Movement"] = "🚀",
    ["👁 ESP"] = "👁",
    ["⚙ Misc"] = "⚙",
    ["ℹ Info"] = "ℹ",
}

local function CreateTab(name)
    -- Nút tab bên sidebar
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name
    TabBtn.Size = UDim2.new(1, -16, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 16, 36)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = name
    TabBtn.TextColor3 = CONFIG.SubTextColor
    TabBtn.Font = CONFIG.FontLight
    TabBtn.TextSize = 13
    TabBtn.BorderSizePixel = 0
    TabBtn.Parent = Sidebar
    CreateCorner(TabBtn, 8)

    -- Indicator trái tab
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0.6, 0)
    Indicator.Position = UDim2.new(0, 2, 0.2, 0)
    Indicator.BackgroundColor3 = CONFIG.AccentColor
    Indicator.BackgroundTransparency = 1
    Indicator.BorderSizePixel = 0
    Indicator.Parent = TabBtn
    CreateCorner(Indicator, 4)

    -- Page cho tab
    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "_Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = CONFIG.AccentColor
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Visible = false
    Page.Parent = ContentArea

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.Parent = Page
    local PagePad = Instance.new("UIPadding")
    PagePad.PaddingTop = UDim.new(0, 12)
    PagePad.PaddingLeft = UDim.new(0, 14)
    PagePad.PaddingRight = UDim.new(0, 14)
    PagePad.Parent = Page

    Tabs[name] = { Btn = TabBtn, Page = Page, Indicator = Indicator }
    TabPages[name] = Page

    TabBtn.MouseButton1Click:Connect(function()
        -- Ẩn tất cả tab
        for tName, tData in pairs(Tabs) do
            tData.Page.Visible = false
            Tween(tData.Btn, { BackgroundTransparency = 1, TextColor3 = CONFIG.SubTextColor }, 0.2)
            Tween(tData.Indicator, { BackgroundTransparency = 1 }, 0.2)
            tData.Btn.Font = CONFIG.FontLight
        end
        -- Hiện tab được chọn
        Page.Visible = true
        Tween(TabBtn, { BackgroundTransparency = 0.85, TextColor3 = CONFIG.TextColor }, 0.2)
        Tween(Indicator, { BackgroundTransparency = 0 }, 0.2)
        TabBtn.Font = CONFIG.Font
        ActiveTab = name
    end)

    TabBtn.MouseEnter:Connect(function()
        if ActiveTab ~= name then
            Tween(TabBtn, { BackgroundTransparency = 0.93 }, 0.15)
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if ActiveTab ~= name then
            Tween(TabBtn, { BackgroundTransparency = 1 }, 0.15)
        end
    end)

    return Page
end

-- ══════════════════════════════════════
--       TẠO TOGGLE BUTTON
-- ══════════════════════════════════════
local function CreateToggle(page, label, desc, callback)
    local state = false

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 58)
    Row.BackgroundColor3 = CONFIG.BgColor2
    Row.BorderSizePixel = 0
    Row.Parent = page
    CreateCorner(Row, 8)
    CreateStroke(Row, CONFIG.AccentColor, 1, 0.8)

    local LabelTxt = Instance.new("TextLabel")
    LabelTxt.Size = UDim2.new(1, -70, 0, 22)
    LabelTxt.Position = UDim2.new(0, 14, 0, 10)
    LabelTxt.BackgroundTransparency = 1
    LabelTxt.Text = label
    LabelTxt.TextColor3 = CONFIG.TextColor
    LabelTxt.Font = CONFIG.Font
    LabelTxt.TextSize = 13
    LabelTxt.TextXAlignment = Enum.TextXAlignment.Left
    LabelTxt.Parent = Row

    local DescTxt = Instance.new("TextLabel")
    DescTxt.Size = UDim2.new(1, -70, 0, 16)
    DescTxt.Position = UDim2.new(0, 14, 0, 33)
    DescTxt.BackgroundTransparency = 1
    DescTxt.Text = desc or ""
    DescTxt.TextColor3 = CONFIG.SubTextColor
    DescTxt.Font = CONFIG.FontLight
    DescTxt.TextSize = 11
    DescTxt.TextXAlignment = Enum.TextXAlignment.Left
    DescTxt.Parent = Row

    -- Toggle switch
    local ToggleBg = Instance.new("Frame")
    ToggleBg.Size = UDim2.new(0, 44, 0, 24)
    ToggleBg.Position = UDim2.new(1, -58, 0.5, -12)
    ToggleBg.BackgroundColor3 = CONFIG.ToggleOff
    ToggleBg.BorderSizePixel = 0
    ToggleBg.Parent = Row
    CreateCorner(ToggleBg, 12)

    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
    ToggleKnob.Position = UDim2.new(0, 3, 0.5, -9)
    ToggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    ToggleKnob.BorderSizePixel = 0
    ToggleKnob.Parent = ToggleBg
    CreateCorner(ToggleKnob, 9)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
    ToggleBtn.BackgroundTransparency = 1
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Row

    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Tween(ToggleBg, { BackgroundColor3 = CONFIG.ToggleOn }, 0.25)
            Tween(ToggleKnob, { Position = UDim2.new(0, 23, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.25)
            Tween(Row, { BackgroundColor3 = Color3.fromRGB(22, 18, 40) }, 0.2)
        else
            Tween(ToggleBg, { BackgroundColor3 = CONFIG.ToggleOff }, 0.25)
            Tween(ToggleKnob, { Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(200, 200, 220) }, 0.25)
            Tween(Row, { BackgroundColor3 = CONFIG.BgColor2 }, 0.2)
        end
        if callback then callback(state) end
    end)

    Row.MouseEnter:Connect(function()
        Tween(Row, { BackgroundColor3 = Color3.fromRGB(20, 16, 36) }, 0.15)
    end)
    Row.MouseLeave:Connect(function()
        if not state then
            Tween(Row, { BackgroundColor3 = CONFIG.BgColor2 }, 0.15)
        end
    end)
end

-- ══════════════════════════════════════
--       TẠO BUTTON
-- ══════════════════════════════════════
local function CreateButton(page, label, desc, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 46)
    Btn.BackgroundColor3 = CONFIG.BgColor2
    Btn.BorderSizePixel = 0
    Btn.Text = ""
    Btn.Parent = page
    CreateCorner(Btn, 8)
    CreateStroke(Btn, CONFIG.AccentColor, 1, 0.7)

    local LabelTxt = Instance.new("TextLabel")
    LabelTxt.Size = UDim2.new(1, -20, 0, 20)
    LabelTxt.Position = UDim2.new(0, 14, 0, 8)
    LabelTxt.BackgroundTransparency = 1
    LabelTxt.Text = label
    LabelTxt.TextColor3 = CONFIG.TextColor
    LabelTxt.Font = CONFIG.Font
    LabelTxt.TextSize = 13
    LabelTxt.TextXAlignment = Enum.TextXAlignment.Left
    LabelTxt.Parent = Btn

    if desc then
        LabelTxt.Position = UDim2.new(0, 14, 0, 6)
        local DescTxt = Instance.new("TextLabel")
        DescTxt.Size = UDim2.new(1, -20, 0, 14)
        DescTxt.Position = UDim2.new(0, 14, 0, 27)
        DescTxt.BackgroundTransparency = 1
        DescTxt.Text = desc
        DescTxt.TextColor3 = CONFIG.SubTextColor
        DescTxt.Font = CONFIG.FontLight
        DescTxt.TextSize = 11
        DescTxt.TextXAlignment = Enum.TextXAlignment.Left
        DescTxt.Parent = Btn
    end

    -- Arrow icon
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -28, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "›"
    Arrow.TextColor3 = CONFIG.AccentColor
    Arrow.Font = CONFIG.Font
    Arrow.TextSize = 20
    Arrow.Parent = Btn

    Btn.MouseEnter:Connect(function()
        Tween(Btn, { BackgroundColor3 = Color3.fromRGB(22, 18, 42) }, 0.15)
        Tween(Arrow, { TextColor3 = CONFIG.AccentColor2 }, 0.15)
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn, { BackgroundColor3 = CONFIG.BgColor2 }, 0.15)
        Tween(Arrow, { TextColor3 = CONFIG.AccentColor }, 0.15)
    end)
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, { BackgroundColor3 = Color3.fromRGB(30, 24, 58) }, 0.1)
        task.delay(0.15, function()
            Tween(Btn, { BackgroundColor3 = Color3.fromRGB(22, 18, 42) }, 0.15)
        end)
        if callback then callback() end
    end)
end

-- ══════════════════════════════════════
--       TẠO SLIDER
-- ══════════════════════════════════════
local function CreateSlider(page, label, min, max, default, callback)
    local value = default or min

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 62)
    Row.BackgroundColor3 = CONFIG.BgColor2
    Row.BorderSizePixel = 0
    Row.Parent = page
    CreateCorner(Row, 8)
    CreateStroke(Row, CONFIG.AccentColor, 1, 0.8)

    local LabelTxt = Instance.new("TextLabel")
    LabelTxt.Size = UDim2.new(0.7, 0, 0, 20)
    LabelTxt.Position = UDim2.new(0, 14, 0, 8)
    LabelTxt.BackgroundTransparency = 1
    LabelTxt.Text = label
    LabelTxt.TextColor3 = CONFIG.TextColor
    LabelTxt.Font = CONFIG.Font
    LabelTxt.TextSize = 13
    LabelTxt.TextXAlignment = Enum.TextXAlignment.Left
    LabelTxt.Parent = Row

    local ValTxt = Instance.new("TextLabel")
    ValTxt.Size = UDim2.new(0.3, -14, 0, 20)
    ValTxt.Position = UDim2.new(0.7, 0, 0, 8)
    ValTxt.BackgroundTransparency = 1
    ValTxt.Text = tostring(value)
    ValTxt.TextColor3 = CONFIG.AccentColor2
    ValTxt.Font = CONFIG.Font
    ValTxt.TextSize = 13
    ValTxt.TextXAlignment = Enum.TextXAlignment.Right
    ValTxt.Parent = Row

    -- Track
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -28, 0, 6)
    Track.Position = UDim2.new(0, 14, 0, 40)
    Track.BackgroundColor3 = Color3.fromRGB(30, 28, 50)
    Track.BorderSizePixel = 0
    Track.Parent = Row
    CreateCorner(Track, 3)

    local Fill = Instance.new("Frame")
    local fillPct = (value - min) / (max - min)
    Fill.Size = UDim2.new(fillPct, 0, 1, 0)
    Fill.BackgroundColor3 = CONFIG.AccentColor
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    CreateCorner(Fill, 3)
    local FillGrad = Instance.new("UIGradient")
    FillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.AccentColor),
        ColorSequenceKeypoint.new(1, CONFIG.AccentColor2),
    })
    FillGrad.Parent = Fill

    -- Knob
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(fillPct, -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.ZIndex = 5
    Knob.Parent = Track
    CreateCorner(Knob, 7)

    local Drag = Instance.new("TextButton")
    Drag.Size = UDim2.new(1, 0, 1, 0)
    Drag.BackgroundTransparency = 1
    Drag.Text = ""
    Drag.ZIndex = 10
    Drag.Parent = Track

    local dragging = false
    Drag.MouseButton1Down:Connect(function()
        dragging = true
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            local trackPos = Track.AbsolutePosition
            local trackSize = Track.AbsoluteSize
            local rel = math.clamp((mouse.X - trackPos.X) / trackSize.X, 0, 1)
            value = math.floor(min + (max - min) * rel)
            ValTxt.Text = tostring(value)
            Tween(Fill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.05)
            Tween(Knob, { Position = UDim2.new(rel, -7, 0.5, -7) }, 0.05)
            if callback then callback(value) end
        end
    end)
end

-- ══════════════════════════════════════
--       TẠO LABEL / HEADER
-- ══════════════════════════════════════
local function CreateHeader(page, text)
    local Hdr = Instance.new("Frame")
    Hdr.Size = UDim2.new(1, 0, 0, 24)
    Hdr.BackgroundTransparency = 1
    Hdr.Parent = page

    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0.5, 0)
    Line.BackgroundColor3 = CONFIG.AccentColor
    Line.BackgroundTransparency = 0.8
    Line.BorderSizePixel = 0
    Line.Parent = Hdr

    local Txt = Instance.new("TextLabel")
    Txt.Size = UDim2.new(0, 0, 1, 0)
    Txt.AutomaticSize = Enum.AutomaticSize.X
    Txt.Position = UDim2.new(0, 0, 0, 0)
    Txt.BackgroundColor3 = CONFIG.BgColor
    Txt.Text = "  " .. text .. "  "
    Txt.TextColor3 = CONFIG.AccentColor2
    Txt.Font = CONFIG.Font
    Txt.TextSize = 11
    Txt.BorderSizePixel = 0
    Txt.Parent = Hdr
end

-- ══════════════════════════════════════
--       KHỞI TẠO CÁC TAB
-- ══════════════════════════════════════
local CombatPage  = CreateTab("⚡ Combat")
local MovePage    = CreateTab("🚀 Movement")
local EspPage     = CreateTab("👁 ESP")
local MiscPage    = CreateTab("⚙ Misc")
local InfoPage    = CreateTab("ℹ Info")

-- ══════════════════════════════════════
--       NỘI DUNG COMBAT TAB
-- ══════════════════════════════════════
CreateHeader(CombatPage, "AIMBOT")
CreateToggle(CombatPage, "Aimbot", "Tự động ngắm mục tiêu", function(v)
    -- _G.AimbotEnabled = v
    print("[FamLV] Aimbot:", v)
end)
CreateToggle(CombatPage, "Silent Aim", "Bắn trúng không nhìn thấy", function(v)
    print("[FamLV] Silent Aim:", v)
end)
CreateSlider(CombatPage, "FOV Size", 50, 500, 150, function(v)
    print("[FamLV] FOV:", v)
end)
CreateHeader(CombatPage, "COMBAT")
CreateToggle(CombatPage, "Infinite Ammo", "Đạn vô hạn", function(v)
    print("[FamLV] Inf Ammo:", v)
end)
CreateToggle(CombatPage, "No Recoil", "Không giật súng", function(v)
    print("[FamLV] No Recoil:", v)
end)
CreateSlider(CombatPage, "Damage Multiplier", 1, 10, 1, function(v)
    print("[FamLV] Damage x" .. v)
end)

-- ══════════════════════════════════════
--       NỘI DUNG MOVEMENT TAB
-- ══════════════════════════════════════
CreateHeader(MovePage, "DI CHUYỂN")
CreateToggle(MovePage, "Speed Hack", "Tăng tốc độ nhân vật", function(v)
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v and 50 or 16 end
    end
end)
CreateSlider(MovePage, "Walk Speed", 16, 200, 16, function(v)
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)
CreateToggle(MovePage, "Fly Hack", "Bay tự do", function(v)
    print("[FamLV] Fly:", v)
end)
CreateSlider(MovePage, "Fly Speed", 10, 300, 60, function(v)
    print("[FamLV] Fly Speed:", v)
end)
CreateHeader(MovePage, "KHÁC")
CreateToggle(MovePage, "No Clip", "Xuyên tường", function(v)
    print("[FamLV] NoClip:", v)
end)
CreateToggle(MovePage, "Infinite Jump", "Nhảy vô hạn", function(v)
    _G.InfJump = v
    if v then
        UserInputService.JumpRequest:Connect(function()
            if _G.InfJump and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end)

-- ══════════════════════════════════════
--       NỘI DUNG ESP TAB
-- ══════════════════════════════════════
CreateHeader(EspPage, "ESP PLAYER")
CreateToggle(EspPage, "Player ESP", "Hiện box người chơi", function(v)
    print("[FamLV] Player ESP:", v)
end)
CreateToggle(EspPage, "Name ESP", "Hiện tên người chơi", function(v)
    print("[FamLV] Name ESP:", v)
end)
CreateToggle(EspPage, "Health ESP", "Hiện máu người chơi", function(v)
    print("[FamLV] Health ESP:", v)
end)
CreateToggle(EspPage, "Distance ESP", "Hiện khoảng cách", function(v)
    print("[FamLV] Distance ESP:", v)
end)
CreateHeader(EspPage, "CHIME/CẢNH BÁO")
CreateToggle(EspPage, "Radar", "Mini radar", function(v)
    print("[FamLV] Radar:", v)
end)

-- ══════════════════════════════════════
--       NỘI DUNG MISC TAB
-- ══════════════════════════════════════
CreateHeader(MiscPage, "TIỆN ÍCH")
CreateToggle(MiscPage, "Anti AFK", "Không bị kick AFK", function(v)
    print("[FamLV] Anti AFK:", v)
end)
CreateToggle(MiscPage, "Auto Farm", "Farm tự động", function(v)
    print("[FamLV] Auto Farm:", v)
end)
CreateButton(MiscPage, "Rejoin Server", "Vào lại server hiện tại", function()
    local id = game.PlaceId
    game:GetService("TeleportService"):Teleport(id, LocalPlayer)
end)
CreateButton(MiscPage, "Xóa Map", "Xóa toàn bộ BasePart trong Workspace", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
            v:Destroy()
        end
    end
end)
CreateHeader(MiscPage, "CÀI ĐẶT UI")
CreateToggle(MiscPage, "Rainbow Theme", "Đổi màu cầu vồng", function(v)
    if v then
        task.spawn(function()
            local hue = 0
            while v do
                hue = (hue + 1) % 360
                local c = Color3.fromHSV(hue/360, 0.8, 1)
                TopLine.BackgroundColor3 = c
                LogoFrame.BackgroundColor3 = c
                task.wait(0.03)
            end
        end)
    end
end)

-- ══════════════════════════════════════
--       NỘI DUNG INFO TAB
-- ══════════════════════════════════════
local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(1, 0, 0, 100)
InfoFrame.BackgroundColor3 = CONFIG.BgColor2
InfoFrame.BorderSizePixel = 0
InfoFrame.Parent = InfoPage
CreateCorner(InfoFrame, 8)
CreateStroke(InfoFrame, CONFIG.AccentColor, 1, 0.6)

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -20, 1, -20)
InfoText.Position = UDim2.new(0, 10, 0, 10)
InfoText.BackgroundTransparency = 1
InfoText.Text = "🎮  FAM LV MENU\n\nVersion: 1.0.0\nMade by: FamLV Code\nDiscord: discord.gg/famlv\n\nGame: " .. game.Name
InfoText.TextColor3 = CONFIG.TextColor
InfoText.Font = CONFIG.FontLight
InfoText.TextSize = 12
InfoText.TextXAlignment = Enum.TextXAlignment.Left
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.Parent = InfoFrame

-- ══════════════════════════════════════
--       MỞ TAB MẶC ĐỊNH
-- ══════════════════════════════════════
Tabs["⚡ Combat"].Btn.MouseButton1Click:Fire()

-- ══════════════════════════════════════
--       KÉO MENU (DRAG)
-- ══════════════════════════════════════
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ══════════════════════════════════════
--       PHÍM TẮT - HIDE/SHOW
-- ══════════════════════════════════════
local menuVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        if menuVisible then
            MainFrame.Visible = true
            Tween(MainFrame, { Position = UDim2.new(0.5, -280, 0.5, -210) }, 0.35, Enum.EasingStyle.Back)
        else
            Tween(MainFrame, { Position = UDim2.new(0.5, -280, 1.5, 0) }, 0.3, Enum.EasingStyle.Quart)
            task.delay(0.35, function()
                if not menuVisible then MainFrame.Visible = false end
            end)
        end
    end
end)

-- Nút đóng
CloseBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, { Position = UDim2.new(0.5, -280, 1.5, 0) }, 0.3)
    task.delay(0.35, function()
        ScreenGui:Destroy()
    end)
end)

-- Nút minimize
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Tween(MainFrame, { Size = UDim2.new(0, 560, 0, 52) }, 0.3, Enum.EasingStyle.Quart)
    else
        Tween(MainFrame, { Size = UDim2.new(0, 560, 0, 420) }, 0.3, Enum.EasingStyle.Back)
    end
end)

-- ══════════════════════════════════════
--       ANIMATION MỞ CỬA
-- ══════════════════════════════════════
MainFrame.Position = UDim2.new(0.5, -280, -0.5, 0)
Tween(MainFrame, { Position = UDim2.new(0.5, -280, 0.5, -210) }, 0.6, Enum.EasingStyle.Back)

print("[FamLV] Menu loaded! Nhấn RightShift để ẩn/hiện")
