
# Lưu script vào file để bạn tải về
script_code = r'''-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║           FAM LV MENU - TIẾNG VIỆT EDITION v3.0                     ║
-- ║              10 CHỨC NĂNG VIP | HACK THẬT 100%                      ║
-- ║        Nhấn [RightShift] để ẩn / hiện | [Delete] để đóng           ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")
local Gui = LP:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════════════════
--                         MÀU SẮC & THEME
-- ═══════════════════════════════════════════════════════════════════════
local C = {
    BG = Color3.fromRGB(6, 6, 12),
    Surface = Color3.fromRGB(12, 11, 22),
    Card = Color3.fromRGB(18, 16, 32),
    Accent = Color3.fromRGB(255, 185, 0),
    AccentD = Color3.fromRGB(220, 140, 0),
    Green = Color3.fromRGB(0, 255, 130),
    Red = Color3.fromRGB(255, 60, 80),
    Blue = Color3.fromRGB(80, 160, 255),
    Purple = Color3.fromRGB(180, 100, 255),
    TxtW = Color3.fromRGB(240, 238, 255),
    TxtG = Color3.fromRGB(140, 135, 170),
    Border = Color3.fromRGB(55, 48, 90),
    ON = Color3.fromRGB(0, 255, 130),
    OFF = Color3.fromRGB(45, 40, 70),
    Dark = Color3.fromRGB(8, 7, 15),
}

-- ═══════════════════════════════════════════════════════════════════════
--                         TIỆN ÍCH GIAO DIỆN
-- ═══════════════════════════════════════════════════════════════════════
local function tw(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or .25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or C.Border
    s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function grad(p, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rot or 0
    g.Parent = p
    return g
end

-- ═══════════════════════════════════════════════════════════════════════
--                         HỆ THỐNG THÔNG BÁO
-- ═══════════════════════════════════════════════════════════════════════
local NotifQueue = {}
local NotifActive = false

local function notify(msg, icon, color)
    icon = icon or "⚡"
    color = color or C.Accent
    table.insert(NotifQueue, {msg = msg, icon = icon, color = color})
    if NotifActive then return end
    NotifActive = true
    
    task.spawn(function()
        while #NotifQueue > 0 do
            local data = table.remove(NotifQueue, 1)
            local nf = Instance.new("ScreenGui")
            nf.ResetOnSpawn = false
            nf.Name = "FamNotif"
            nf.Parent = Gui
            
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 320, 0, 52)
            box.Position = UDim2.new(0.5, -160, 0, -70)
            box.BackgroundColor3 = C.Card
            box.BorderSizePixel = 0
            box.Parent = nf
            corner(box, 12)
            stroke(box, color, 1.5)
            
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 4, 1, 0)
            bar.BackgroundColor3 = color
            bar.BorderSizePixel = 0
            bar.Parent = box
            corner(bar, 3)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = data.icon .. "  " .. data.msg
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 13
            lbl.TextColor3 = C.TxtW
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = box
            
            local prog = Instance.new("Frame")
            prog.Size = UDim2.new(1, 0, 0, 2)
            prog.Position = UDim2.new(0, 0, 1, -2)
            prog.BackgroundColor3 = color
            prog.BorderSizePixel = 0
            prog.Parent = box
            
            tw(box, {Position = UDim2.new(0.5, -160, 0, 25)}, 0.45, Enum.EasingStyle.Back)
            tw(prog, {Size = UDim2.new(0, 0, 0, 2)}, 2.5, Enum.EasingStyle.Linear)
            
            task.wait(2.5)
            tw(box, {Position = UDim2.new(0.5, -160, 0, -80)}, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.wait(0.4)
            nf:Destroy()
        end
        NotifActive = false
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
--                         SCREEN GUI CHÍNH
-- ═══════════════════════════════════════════════════════════════════════
local SG = Instance.new("ScreenGui")
SG.Name = "FamLV_VietMenu_v3"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = Gui

-- MAIN FRAME
local MF = Instance.new("Frame")
MF.Name = "Main"
MF.Size = UDim2.new(0, 580, 0, 460)
MF.Position = UDim2.new(0.5, -290, 0.5, -230)
MF.BackgroundColor3 = C.BG
MF.ClipsDescendants = true
MF.Parent = SG
corner(MF, 16)
stroke(MF, C.Border, 1.5)
grad(MF, Color3.fromRGB(10, 8, 20), Color3.fromRGB(6, 5, 12), 135)

-- Glow top
local glowTop = Instance.new("Frame")
glowTop.Size = UDim2.new(1, 0, 0, 2)
glowTop.BackgroundColor3 = C.Accent
glowTop.BorderSizePixel = 0
glowTop.Parent = MF
grad(glowTop, C.Accent, Color3.fromRGB(0, 0, 0), 90)

-- ═══════════════════════════════════════════════════════════════════════
--                         THANH TIÊU ĐỀ
-- ═══════════════════════════════════════════════════════════════════════
local TB = Instance.new("Frame")
TB.Size = UDim2.new(1, 0, 0, 56)
TB.BackgroundColor3 = C.Surface
TB.BorderSizePixel = 0
TB.ZIndex = 5
TB.Parent = MF
grad(TB, Color3.fromRGB(16, 14, 30), Color3.fromRGB(10, 9, 18), 135)

-- Logo
local logo = Instance.new("Frame")
logo.Size = UDim2.new(0, 38, 0, 38)
logo.Position = UDim2.new(0, 14, 0.5, -19)
logo.BackgroundColor3 = C.Accent
logo.ZIndex = 6
logo.Parent = TB
corner(logo, 19)
grad(logo, C.Accent, C.AccentD, 135)

local logoTxt = Instance.new("TextLabel")
logoTxt.Size = UDim2.new(1, 0, 1, 0)
logoTxt.BackgroundTransparency = 1
logoTxt.Text = "F"
logoTxt.Font = Enum.Font.GothamBlack
logoTxt.TextSize = 20
logoTxt.TextColor3 = Color3.fromRGB(20, 10, 0)
logoTxt.ZIndex = 7
logoTxt.Parent = logo

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 220, 0, 24)
title.Position = UDim2.new(0, 60, 0, 8)
title.BackgroundTransparency = 1
title.Text = "FAM LV MENU"
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextColor3 = C.TxtW
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = TB

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(0, 220, 0, 16)
sub.Position = UDim2.new(0, 60, 0, 30)
sub.BackgroundTransparency = 1
sub.Text = "10 CHỨC NĂNG VIP ✦ v3.0"
sub.Font = Enum.Font.Gotham
sub.TextSize = 11
sub.TextColor3 = C.Accent
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.ZIndex = 6
sub.Parent = TB

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -42, 0.5, -15)
closeBtn.BackgroundColor3 = C.Red
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.ZIndex = 6
closeBtn.Parent = TB
corner(closeBtn, 8)

closeBtn.MouseButton1Click:Connect(function()
    tw(MF, {Size = UDim2.new(0, 580, 0, 0), Position = UDim2.new(0.5, -290, 0.5, 0)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    task.wait(0.35)
    SG:Destroy()
end)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -80, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 185, 30)
minBtn.Text = "−"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(80, 45, 0)
minBtn.ZIndex = 6
minBtn.Parent = TB
corner(minBtn, 8)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(MF, {Size = minimized and UDim2.new(0, 580, 0, 56) or UDim2.new(0, 580, 0, 460)}, 0.35, Enum.EasingStyle.Back)
end)

-- Drag
local drag, dragStart, startPos
TB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStart = i.Position
        startPos = MF.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

-- ═══════════════════════════════════════════════════════════════════════
--                         SIDEBAR / TABS
-- ═══════════════════════════════════════════════════════════════════════
local SB = Instance.new("Frame")
SB.Size = UDim2.new(0, 145, 1, -56)
SB.Position = UDim2.new(0, 0, 0, 56)
SB.BackgroundColor3 = C.Surface
SB.BorderSizePixel = 0
SB.ZIndex = 3
SB.Parent = MF
grad(SB, Color3.fromRGB(14, 12, 28), Color3.fromRGB(10, 9, 18), 180)

local sbList = Instance.new("UIListLayout")
sbList.SortOrder = Enum.SortOrder.LayoutOrder
sbList.Padding = UDim.new(0, 5)
sbList.Parent = SB

local sbPad = Instance.new("UIPadding")
sbPad.PaddingTop = UDim.new(0, 12)
sbPad.PaddingLeft = UDim.new(0, 10)
sbPad.PaddingRight = UDim.new(0, 10)
sbPad.Parent = SB

local sbDiv = Instance.new("Frame")
sbDiv.Size = UDim2.new(0, 1, 1, -56)
sbDiv.Position = UDim2.new(0, 145, 0, 56)
sbDiv.BackgroundColor3 = C.Border
sbDiv.BorderSizePixel = 0
sbDiv.ZIndex = 4
sbDiv.Parent = MF

-- Content area
local CA = Instance.new("Frame")
CA.Size = UDim2.new(1, -146, 1, -56)
CA.Position = UDim2.new(0, 146, 0, 56)
CA.BackgroundTransparency = 1
CA.ClipsDescendants = true
CA.ZIndex = 3
CA.Parent = MF

-- ═══════════════════════════════════════════════════════════════════════
--                         TAB SYSTEM
-- ═══════════════════════════════════════════════════════════════════════
local Tabs = {}
local Pages = {}
local ActiveTab = nil

local TabDefs = {
    {name = "Nhặt Đồ", icon = "🎁", order = 1},
    {name = "Di Chuyển", icon = "🏃", order = 2},
    {name = "Combat", icon = "⚔", order = 3},
    {name = "ESP", icon = "👁", order = 4},
    {name = "Tiện Ích", icon = "⚙", order = 5},
}

local function SwitchTab(name)
    if ActiveTab == name then return end
    ActiveTab = name
    for n, pg in pairs(Pages) do pg.Visible = (n == name) end
    for n, btn in pairs(Tabs) do
        if n == name then
            tw(btn, {BackgroundColor3 = C.Accent, BackgroundTransparency = 0}, 0.2)
            btn.TextColor3 = Color3.fromRGB(20, 10, 0)
        else
            tw(btn, {BackgroundColor3 = C.BG, BackgroundTransparency = 1}, 0.2)
            btn.TextColor3 = C.TxtG
        end
    end
end

for i, t in ipairs(TabDefs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.BackgroundColor3 = C.BG
    btn.BackgroundTransparency = 1
    btn.Text = t.icon .. "  " .. t.name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextColor3 = C.TxtG
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = t.order
    btn.ZIndex = 5
    btn.Parent = SB
    corner(btn, 9)
    
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 10)
    p.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if ActiveTab ~= t.name then
            tw(btn, {BackgroundColor3 = Color3.fromRGB(35, 30, 55), BackgroundTransparency = 0}, 0.15)
        end
    end)
    btn.MouseLeave:Connect(function()
        if ActiveTab ~= t.name then
            tw(btn, {BackgroundTransparency = 1}, 0.15)
        end
    end)
    
    local pg = Instance.new("ScrollingFrame")
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.ScrollBarThickness = 4
    pg.ScrollBarImageColor3 = C.Accent
    pg.Visible = false
    pg.ZIndex = 3
    pg.Parent = CA
    
    local pgl = Instance.new("UIListLayout")
    pgl.SortOrder = Enum.SortOrder.LayoutOrder
    pgl.Padding = UDim.new(0, 8)
    pgl.Parent = pg
    pgl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pg.CanvasSize = UDim2.new(0, 0, 0, pgl.AbsoluteContentSize.Y + 20)
    end)
    
    local pgpad = Instance.new("UIPadding")
    pgpad.PaddingTop = UDim.new(0, 14)
    pgpad.PaddingLeft = UDim.new(0, 14)
    pgpad.PaddingRight = UDim.new(0, 16)
    pgpad.Parent = pg
    
    Tabs[t.name] = btn
    Pages[t.name] = pg
    btn.MouseButton1Click:Connect(function() SwitchTab(t.name) end)
end

-- ═══════════════════════════════════════════════════════════════════════
--                         COMPONENT BUILDERS
-- ═══════════════════════════════════════════════════════════════════════
local function section(page, txt)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.Parent = page
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = C.Border
    line.BorderSizePixel = 0
    line.Parent = f
    
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(0, 0, 1, 0)
    lb.AutomaticSize = Enum.AutomaticSize.X
    lb.BackgroundColor3 = C.BG
    lb.Text = "  ▸ " .. txt:upper() .. "  "
    lb.Font = Enum.Font.GothamBold
    lb.TextSize = 10
    lb.TextColor3 = C.Accent
    lb.ZIndex = 4
    lb.Parent = f
end

local function mkToggle(page, lbl, default, cb)
    local s = {v = default or false}
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = C.Card
    row.Parent = page
    corner(row, 10)
    stroke(row, C.Border, 1)
    
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -65, 1, 0)
    lb.Position = UDim2.new(0, 14, 0, 0)
    lb.BackgroundTransparency = 1
    lb.Text = lbl
    lb.Font = Enum.Font.Gotham
    lb.TextSize = 12
    lb.TextColor3 = C.TxtW
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = row
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 46, 0, 24)
    track.Position = UDim2.new(1, -58, 0.5, -12)
    track.BackgroundColor3 = s.v and C.ON or C.OFF
    track.Parent = row
    corner(track, 12)
    
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 18, 0, 18)
    thumb.Position = s.v and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Parent = track
    corner(thumb, 9)
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 36, 0, 14)
    status.Position = UDim2.new(1, -58, 0.5, -20)
    status.BackgroundTransparency = 1
    status.Text = s.v and "BẬT" or "TẮT"
    status.Font = Enum.Font.GothamBold
    status.TextSize = 9
    status.TextColor3 = s.v and C.ON or C.TxtG
    status.Parent = row
    
    local function upd()
        tw(track, {BackgroundColor3 = s.v and C.ON or C.OFF}, 0.2)
        tw(thumb, {Position = s.v and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.2, Enum.EasingStyle.Back)
        status.Text = s.v and "BẬT" or "TẮT"
        status.TextColor3 = s.v and C.ON or C.TxtG
        if cb then cb(s.v) end
    end
    
    local tbtn = Instance.new("TextButton")
    tbtn.Size = UDim2.new(1, 0, 1, 0)
    tbtn.BackgroundTransparency = 1
    tbtn.Text = ""
    tbtn.Parent = row
    tbtn.MouseButton1Click:Connect(function()
        s.v = not s.v
        upd()
    end)
    
    row.MouseEnter:Connect(function() tw(row, {BackgroundColor3 = Color3.fromRGB(28, 24, 48)}, 0.15) end)
    row.MouseLeave:Connect(function() tw(row, {BackgroundColor3 = C.Card}, 0.15) end)
    
    upd()
    return s
end

local function mkSlider(page, lbl, min, max, default, cb)
    local val = default or min
    local draggingS = false
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 58)
    row.BackgroundColor3 = C.Card
    row.Parent = page
    corner(row, 10)
    stroke(row, C.Border, 1)
    
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, -28, 0, 28)
    top.Position = UDim2.new(0, 14, 0, 0)
    top.BackgroundTransparency = 1
    top.Parent = row
    
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(0.65, 0, 1, 0)
    lb.BackgroundTransparency = 1
    lb.Text = lbl
    lb.Font = Enum.Font.Gotham
    lb.TextSize = 12
    lb.TextColor3 = C.TxtW
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = top
    
    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(0.35, 0, 1, 0)
    vl.Position = UDim2.new(0.65, 0, 0, 0)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(val)
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 13
    vl.TextColor3 = C.Accent
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.Parent = top
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -28, 0, 7)
    track.Position = UDim2.new(0, 14, 0, 38)
    track.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
    track.Parent = row
    corner(track, 3)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = C.Accent
    fill.Parent = track
    corner(fill, 3)
    grad(fill, C.Accent, C.AccentD, 0)
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new((val - min) / (max - min), -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = track
    corner(knob, 8)
    
    local sb = Instance.new("TextButton")
    sb.Size = UDim2.new(1, 0, 1, 0)
    sb.BackgroundTransparency = 1
    sb.Text = ""
    sb.Parent = track
    
    local function setV(v)
        val = math.clamp(math.floor(v), min, max)
        local p = (val - min) / (max - min)
        tw(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.05)
        tw(knob, {Position = UDim2.new(p, -8, 0.5, -8)}, 0.05)
        vl.Text = tostring(val)
        if cb then cb(val) end
    end
    
    sb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingS = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then draggingS = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if draggingS and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            setV(min + p * (max - min))
        end
    end)
    
    return {Get = function() return val end, Set = setV}
end

local function mkButton(page, lbl, sub_, cb, accent)
    accent = accent or C.Accent
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 46)
    btn.BackgroundColor3 = accent
    btn.Text = ""
    btn.ZIndex = 3
    btn.Parent = page
    corner(btn, 10)
    grad(btn, accent, Color3.fromRGB(math.max(accent.R * 255 - 40, 0), math.max(accent.G * 255 - 40, 0), math.max(accent.B * 255 - 40, 0)), 135)
    
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, 0, 0, 24)
    lb.Position = UDim2.new(0, 14, 0, 5)
    lb.BackgroundTransparency = 1
    lb.Text = lbl
    lb.Font = Enum.Font.GothamBold
    lb.TextSize = 13
    lb.TextColor3 = Color3.fromRGB(20, 10, 0)
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.ZIndex = 4
    lb.Parent = btn
    
    if sub_ then
        local s = Instance.new("TextLabel")
        s.Size = UDim2.new(1, 0, 0, 14)
        s.Position = UDim2.new(0, 14, 0, 26)
        s.BackgroundTransparency = 1
        s.Text = sub_
        s.Font = Enum.Font.Gotham
        s.TextSize = 10
        s.TextColor3 = Color3.fromRGB(80, 50, 0)
        s.TextXAlignment = Enum.TextXAlignment.Left
        s.ZIndex = 4
        s.Parent = btn
    end
    
    btn.MouseEnter:Connect(function() tw(btn, {BackgroundColor3 = Color3.fromRGB(255, 205, 40)}, 0.15) end)
    btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = accent}, 0.15) end)
    btn.MouseButton1Click:Connect(function()
        tw(btn, {Size = UDim2.new(0.97, 0, 0, 43)}, 0.1)
        task.wait(0.1)
        tw(btn, {Size = UDim2.new(1, 0, 0, 46)}, 0.15, Enum.EasingStyle.Back)
        if cb then cb() end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════════════
--          10 CHỨC NĂNG VIP - HACK THẬT 100% - TIẾNG VIỆT
-- ═══════════════════════════════════════════════════════════════════════
-- ═══════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════
-- TAB 1: NHẶT ĐỒ (2 chức năng)
-- ═══════════════════════════════════════════════════════════════════════
local P1 = Pages["Nhặt Đồ"]
section(P1, "Tự Động Nhặt Đồ")

-- ===== CHỨC NĂNG 1: AUTO NHẶT RƯƠNG =====
local autoChestOn = false

mkToggle(P1, "🎁  Auto Nhặt Rương (Chest)", false, function(v)
    autoChestOn = v
    if v then
        notify("🎁 Auto Nhặt Rương: BẬT", "🎁", C.Green)
        
        task.spawn(function()
            while autoChestOn do
                local char = LP.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not autoChestOn then break end
                        local name = obj.Name:lower()
                        if (name:find("chest") or name:find("ruong") or name:find("rương") or 
                            name:find("treasure") or name:find("goldchest") or name:find("diamondchest")) then
                            if obj:IsA("BasePart") or obj:IsA("Model") then
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if part and part.Parent then
                                    local dist = (root.Position - part.Position).Magnitude
                                    if dist < 100 then
                                        root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                                        task.wait(0.15)
                                        
                                        -- Cách 1: Fire ProximityPrompt
                                        pcall(function()
                                            for _, child in pairs(obj:GetDescendants()) do
                                                if child:IsA("ProximityPrompt") then
                                                    fireproximityprompt(child)
                                                end
                                            end
                                        end)
                                        
                                        -- Cách 2: Fire TouchInterest
                                        pcall(function()
                                            if part:FindFirstChild("TouchInterest") then
                                                firetouchinterest(root, part, 0)
                                                task.wait(0.05)
                                                firetouchinterest(root, part, 1)
                                            end
                                        end)
                                        
                                        -- Cách 3: Fire ClickDetector
                                        pcall(function()
                                            local cd = obj:FindFirstChildOfClass("ClickDetector")
                                            if cd then fireclickdetector(cd) end
                                        end)
                                        
                                        task.wait(0.3)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.8)
            end
        end)
    else
        notify("🎁 Auto Nhặt Rương: TẮT", "🎁", C.Red)
    end
end)

-- ===== CHỨC NĂNG 2: AUTO NHẶT TRÁI ÁC QUỶ =====
local autoFruitOn = false

mkToggle(P1, "🍎  Auto Nhặt Trái Ác Quỷ", false, function(v)
    autoFruitOn = v
    if v then
        notify("🍎 Auto Nhặt Trái: BẬT", "🍎", C.Green)
        
        task.spawn(function()
            while autoFruitOn do
                local char = LP.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not autoFruitOn then break end
                        local name = obj.Name:lower()
                        
                        -- Detect fruit bằng nhiều pattern
                        if (name:find("fruit") or name:find("trai") or name:find("trái") or name:find("devil") or
                            name:find("bomu") or name:find("mera") or name:find("suna") or name:find("gura") or 
                            name:find("pika") or name:find("magu") or name:find("tori") or name:find("dragon") or
                            name:find("phoenix") or name:find("quake") or name:find("string") or name:find("dough") or
                            name:find("venom") or name:find("shadow") or name:find("control") or name:find("spirit") or
                            name:find("leopard") or name:find("mammoth") or name:find("t-rex") or name:find("kitsune")) then
                            
                            if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Tool") then
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    local dist = (root.Position - part.Position).Magnitude
                                    if dist < 150 then
                                        notify("🍎 Phát hiện Trái: " .. obj.Name, "🍎", C.Accent)
                                        root.CFrame = CFrame.new(part.Position + Vector3.new(0, 4, 0))
                                        task.wait(0.2)
                                        
                                        pcall(function()
                                            for _, child in pairs(obj:GetDescendants()) do
                                                if child:IsA("ProximityPrompt") then
                                                    fireproximityprompt(child)
                                                end
                                            end
                                        end)
                                        
                                        pcall(function()
                                            if obj:IsA("Tool") then
                                                LP.Character.Humanoid:EquipTool(obj)
                                            end
                                        end)
                                        
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(1.0)
            end
        end)
    else
        notify("🍎 Auto Nhặt Trái: TẮT", "🍎", C.Red)
    end
end)

mkButton(P1, "📍  Nhặt Tất Cả Trong Vùng", "Teleport & nhặt đồ bán kính 100m", function()
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        notify("❌ Không tìm thấy nhân vật!", "❌", C.Red)
        return
    end
    
    local root = char.HumanoidRootPart
    local count = 0
    local items = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < 100 then
                local n = obj.Name:lower()
                if n:find("fruit") or n:find("chest") or n:find("coin") or n:find("drop") or 
                   n:find("box") or n:find("money") or n:find("gold") or n:find("beli") then
                    table.insert(items, obj)
                end
            end
        end
    end
    
    for _, item in ipairs(items) do
        if item and item.Parent then
            root.CFrame = CFrame.new(item.Position + Vector3.new(0, 3, 0))
            
            pcall(function()
                if item:FindFirstChild("TouchInterest") then
                    firetouchinterest(root, item, 0)
                    task.wait(0.05)
                    firetouchinterest(root, item, 1)
                end
            end)
            
            pcall(function()
                for _, child in pairs(item:GetDescendants()) do
                    if child:IsA("ProximityPrompt") then
                        fireproximityprompt(child)
                    end
                end
            end)
            
            count = count + 1
            task.wait(0.12)
        end
    end
    
    notify("✅ Đã nhặt " .. count .. " vật phẩm!", "✅", C.Green)
end)

-- ═══════════════════════════════════════════════════════════════════════
-- TAB 2: DI CHUYỂN (3 chức năng)
-- ═══════════════════════════════════════════════════════════════════════
local P2 = Pages["Di Chuyển"]
section(P2, "Tốc Độ & Nhảy")

-- ===== CHỨC NĂNG 3: SPEED HACK =====
mkSlider(P2, "🏃  Tốc Độ Chạy", 16, 500, 16, function(v)
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)

-- ===== CHỨC NĂNG 4: JUMP POWER =====
mkSlider(P2, "⬆  Lực Nhảy", 50, 500, 50, function(v)
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = v end
    end
end)

section(P2, "Khả Năng Đặc Biệt")

-- ===== CHỨC NĂNG 5: FLY / BAY =====
local flyOn = false
local flyConn
local flySpeed = 50

mkToggle(P2, "🚀  Fly / Bay Tự Do", false, function(v)
    flyOn = v
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        notify("❌ Không tìm thấy nhân vật!", "❌", C.Red)
        return
    end
    
    if v then
        notify("🚀 Fly: BẬT (WASD + Space/Shift)", "🚀", C.Green)
        
        local root = char.HumanoidRootPart
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = root
        bv.Name = "FamFlyVelocity"
        
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = root.CFrame
        bg.Parent = root
        bg.Name = "FamFlyGyro"
        
        flyConn = RunService.RenderStepped:Connect(function()
            if not flyOn then return end
            local cam = Workspace.CurrentCamera
            local dir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
            
            if dir.Magnitude > 0 then
                bv.Velocity = dir.Unit * flySpeed
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
            
            bg.CFrame = cam.CFrame
        end)
    else
        notify("🚀 Fly: TẮT", "🚀", C.Red)
        if flyConn then flyConn:Disconnect() end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("FamFlyVelocity")
            local bg = root:FindFirstChild("FamFlyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end)

mkSlider(P2, "🚀  Tốc Độ Bay", 10, 200, 50, function(v)
    flySpeed = v
end)

-- ═══════════════════════════════════════════════════════════════════════
-- TAB 3: COMBAT (2 chức năng)
-- ═══════════════════════════════════════════════════════════════════════
local P3 = Pages["Combat"]
section(P3, "Auto Farm & Combat")

-- ===== CHỨC NĂNG 6: AUTO FARM NPC =====
local autoFarmOn = false

mkToggle(P3, "⚔  Auto Farm NPC Gần Nhất", false, function(v)
    autoFarmOn = v
    if v then
        notify("⚔ Auto Farm: BẬT", "⚔", C.Green)
        
        task.spawn(function()
            while autoFarmOn do
                local char = LP.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                    local root = char.HumanoidRootPart
                    local nearest, nearDist = nil, math.huge
                    
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj ~= char then
                            local npcHum = obj:FindFirstChildOfClass("Humanoid")
                            local npcHRP = obj:FindFirstChild("HumanoidRootPart")
                            
                            if npcHum and npcHRP and npcHum.Health > 0 then
                                local isPlayer = false
                                for _, plr in pairs(Players:GetPlayers()) do
                                    if plr.Character == obj then isPlayer = true; break end
                                end
                                
                                if not isPlayer then
                                    local d = (root.Position - npcHRP.Position).Magnitude
                                    if d < nearDist and d < 300 then
                                        nearDist = d
                                        nearest = {hrp = npcHRP, hum = npcHum, model = obj}
                                    end
                                end
                            end
                        end
                    end
                    
                    if nearest and nearDist < 300 then
                        root.CFrame = CFrame.new(nearest.hrp.Position + Vector3.new(0, 2, 3))
                        task.wait(0.1)
                        
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then
                            pcall(function() tool:Activate() end)
                            
                            pcall(function()
                                for _, rem in pairs(tool:GetDescendants()) do
                                    if rem:IsA("RemoteEvent") then
                                        rem:FireServer(nearest.hrp.Position, nearest.model)
                                    elseif rem:IsA("RemoteFunction") then
                                        pcall(function() rem:InvokeServer(nearest.hrp.Position) end)
                                    end
                                end
                            end)
                        end
                        
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new(0, 0))
                        end)
                    end
                end
                task.wait(0.25)
            end
        end)
    else
        notify("⚔ Auto Farm: TẮT", "⚔", C.Red)
    end
end)

-- ===== CHỨC NĂNG 7: AUTO CLICK SIÊU NHANH =====
local autoClickOn = false

mkToggle(P3, "👆  Auto Click Siêu Nhanh", false, function(v)
    autoClickOn = v
    if v then
        notify("👆 Auto Click: BẬT", "👆", C.Green)
        
        task.spawn(function()
            while autoClickOn do
                local char = LP.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        pcall(function() tool:Activate() end)
                    end
                    
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:Button1Down(Vector2.new(0, 0))
                        task.wait(0.05)
                        VirtualUser:Button1Up(Vector2.new(0, 0))
                    end)
                end
                task.wait(0.08)
            end
        end)
    else
        notify("👆 Auto Click: TẮT", "👆", C.Red)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════
-- TAB 4: ESP (2 chức năng)
-- ═══════════════════════════════════════════════════════════════════════
local P4 = Pages["ESP"]
section(P4, "ESP Người Chơi")

-- ===== CHỨC NĂNG 8: ESP NGƯỜI CHƠI =====
local espPlayerOn = false
local espPlayerObjects = {}

mkToggle(P4, "🔲  ESP Người Chơi (Tên + HP + K/cách)", false, function(v)
    espPlayerOn = v
    if not v then
        for _, h in pairs(espPlayerObjects) do
            if h and h.Parent then h:Destroy() end
        end
        espPlayerObjects = {}
        notify("🔲 ESP Player: TẮT", "🔲", C.Red)
        return
    end
    
    notify("🔲 ESP Player: BẬT", "🔲", C.Green)
    
    task.spawn(function()
        while espPlayerOn do
            for _, h in pairs(espPlayerObjects) do
                if h and h.Parent then h:Destroy() end
            end
            espPlayerObjects = {}
            
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local root = plr.Character.HumanoidRootPart
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    
                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0, 120, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 3.5, 0)
                    bb.Adornee = root
                    bb.AlwaysOnTop = true
                    bb.Parent = root
                    
                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1, 0, 1, 0)
                    bg.BackgroundColor3 = C.Dark
                    bg.BackgroundTransparency = 0.3
                    bg.BorderSizePixel = 0
                    bg.Parent = bb
                    corner(bg, 6)
                    
                    local nameLbl = Instance.new("TextLabel")
                    nameLbl.Size = UDim2.new(1, 0, 0, 18)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.Text = "👤 " .. plr.Name
                    nameLbl.Font = Enum.Font.GothamBold
                    nameLbl.TextSize = 11
                    nameLbl.TextColor3 = C.Accent
                    nameLbl.TextStrokeTransparency = 0.5
                    nameLbl.Parent = bg
                    
                    local hpLbl = Instance.new("TextLabel")
                    hpLbl.Size = UDim2.new(1, 0, 0, 14)
                    hpLbl.Position = UDim2.new(0, 0, 0, 18)
                    hpLbl.BackgroundTransparency = 1
                    hpLbl.Text = hum and ("❤ " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)) or "❤ ???"
                    hpLbl.Font = Enum.Font.Gotham
                    hpLbl.TextSize = 10
                    hpLbl.TextColor3 = C.Green
                    hpLbl.TextStrokeTransparency = 0.5
                    hpLbl.Parent = bg
                    
                    local distLbl = Instance.new("TextLabel")
                    distLbl.Size = UDim2.new(1, 0, 0, 14)
                    distLbl.Position = UDim2.new(0, 0, 0, 32)
                    distLbl.BackgroundTransparency = 1
                    local dist = myRoot and math.floor((myRoot.Position - root.Position).Magnitude) or "?"
                    distLbl.Text = "📏 " .. dist .. " studs"
                    distLbl.Font = Enum.Font.Gotham
                    distLbl.TextSize = 9
                    distLbl.TextColor3 = C.TxtG
                    distLbl.TextStrokeTransparency = 0.5
                    distLbl.Parent = bg
                    
                    table.insert(espPlayerObjects, bb)
                end
            end
            task.wait(1.5)
        end
    end)
end)

section(P4, "ESP Vật Phẩm")

-- ===== CHỨC NĂNG 9: ESP TRÁI ÁC QUỶ =====
local espFruitOn = false
local espFruitObjects = {}

mkToggle(P4, "🍎  ESP Trái Ác Quỷ", false, function(v)
    espFruitOn = v
    if not v then
        for _, h in pairs(espFruitObjects) do
            if h and h.Parent then h:Destroy() end
        end
        espFruitObjects = {}
        notify("🍎 ESP Trái: TẮT", "🍎", C.Red)
        return
    end
    
    notify("🍎 ESP Trái: BẬT", "🍎", C.Green)
    
    task.spawn(function()
        while espFruitOn do
            for _, h in pairs(espFruitObjects) do
                if h and h.Parent then h:Destroy() end
            end
            espFruitObjects = {}
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if (name:find("fruit") or name:find("trai") or name:find("trái") or name:find("devil") or
                    name:find("bomu") or name:find("mera") or name:find("suna") or name:find("gura") or
                    name:find("pika") or name:find("magu") or name:find("tori") or name:find("dragon") or
                    name:find("phoenix") or name:find("quake") or name:find("string") or name:find("dough") or
                    name:find("venom") or name:find("shadow") or name:find("control") or name:find("spirit") or
                    name:find("leopard") or name:find("mammoth") or name:find("t-rex") or name:find("kitsune")) then
                    
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 30)
                        bb.StudsOffset = Vector3.new(0, 2, 0)
                        bb.Adornee = part
                        bb.AlwaysOnTop = true
                        bb.Parent = part
                        
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = "🍎 " .. obj.Name
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 12
                        lbl.TextColor3 = C.Purple
                        lbl.TextStrokeTransparency = 0
                        lbl.Parent = bb
                        
                        table.insert(espFruitObjects, bb)
                    end
                end
            end
            task.wait(3)
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════
-- TAB 5: TIỆN ÍCH (1 chức năng)
-- ═══════════════════════════════════════════════════════════════════════
local P5 = Pages["Tiện Ích"]
section(P5, "Hỗ Trợ Chơi Game")

-- ===== CHỨC NĂNG 10: ANTI AFK =====
local antiAFK = false

mkToggle(P5, "⏰  Chống AFK Tự Động", false, function(v)
    antiAFK = v
    if v then
        notify("⏰ Anti AFK: BẬT", "⏰", C.Green)
        
        LP.Idled:Connect(function()
            if antiAFK then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    else
        notify("⏰ Anti AFK: TẮT", "⏰", C.Red)
    end
end)

section(P5, "Thông Tin & Khác")

mkButton(P5, "📋  Sao Chép User ID", "Copy UserID của bạn", function()
    local id = tostring(LP.UserId)
    pcall(function() setclipboard(id) end)
    notify("📋 UserID: " .. id .. " (đã copy!)", "📋", C.Blue)
end)

mkButton(P5, "🔄  Rejoin Server", "Vào lại server hiện tại", function()
    notify("🔄 Đang rejoin...", "🔄", C.Blue)
    task.wait(1)
    TeleportService:Teleport(game.PlaceId, LP)
end)

mkButton(P5, "☀  Full Bright", "Bật sáng toàn bản đồ", function()
    Lighting.Brightness = 10
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    notify("☀ Full Bright: BẬT", "☀", C.Green)
end, C.Blue)

-- ═══════════════════════════════════════════════════════════════════════
--      ANIMATION MỞ + TAB MẶC ĐỊNH
-- ═══════════════════════════════════════════════════════════════════════
MF.Size = UDim2.new(0, 580, 0, 0)
MF.Position = UDim2.new(0.5, -290, 0.5, 0)
tw(MF, {Size = UDim2.new(0, 580, 0, 460), Position = UDim2.new(0.5, -290, 0.5, -230)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
task.wait(0.1)
SwitchTab("Nhặt Đồ")
task.wait(0.5)
notify("🟡 FAM LV MENU v3.0 đã tải! RightShift để ẩn/hiện", "🟡", C.Accent)

-- TOGGLE PHÍM
local menuOpen = true
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        menuOpen = not menuOpen
        if menuOpen then
            MF.Visible = true
            tw(MF, {Size = UDim2.new(0, 580, 0, 460), Position = UDim2.new(0.5, -290, 0.5, -230)}, 0.35, Enum.EasingStyle.Back)
        else
            tw(MF, {Size = UDim2.new(0, 580, 0, 0), Position = UDim2.new(0.5, -290, 0.5, 0)}, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.wait(0.27)
            MF.Visible = false
        end
    elseif inp.KeyCode == Enum.KeyCode.Delete then
        SG:Destroy()
    end
end)

print("✅ [FAM LV MENU v3.0] 10 Chức Năng VIP đã sẵn sàng! | RightShift để bật/tắt | Delete để đóng")
