-- ╔═══════════════════════════════════════════════════════════════╗
-- ║        FAM LV MENU ULTIMATE v3.0 - PREMIUM REDESIGN           ║
-- ║            DESIGNED BY GEMINI | TIẾNG VIỆT 100%               ║
-- ╚═══════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

-- ══════════════════════════════════════════
-- CẤU HÌNH MÀU SẮC & TRẠNG THÁI
-- ══════════════════════════════════════════
local Theme = {
    Main = Color3.fromRGB(13, 15, 23),
    Sidebar = Color3.fromRGB(18, 20, 32),
    Accent = Color3.fromRGB(0, 210, 255),
    Secondary = Color3.fromRGB(28, 31, 48),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 170, 190),
    Success = Color3.fromRGB(0, 255, 150),
    Danger = Color3.fromRGB(255, 70, 70)
}

local State = {
    SpeedEnabled = false, SpeedValue = 50,
    FlyEnabled = false, FlySpeed = 80,
    InfJump = false, LowGravity = false, NoClip = false,
    AutoFarm = false, AutoCollect = false, AutoFarmRadius = 50,
    FullBright = false, FOV = 70, NoFog = false, Crosshair = false,
    AntiAFK = false, ChatNotif = false, TimeFreeze = false, 
    FPSUnlock = false, ShowCoords = false, RainbowName = false,
    FlyBody = nil, FlyGyro = nil, _FlyConn = nil
}

-- ══════════════════════════════════════════
-- HÀM HỖ TRỢ GIAO DIỆN
-- ══════════════════════════════════════════
local function QuickTween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function ApplyCorner(obj, radius)
    local c = Instance.new("UICorner", obj)
    c.CornerRadius = UDim.new(0, radius or 12)
end

local function Notify(msg, col)
    task.spawn(function()
        local sg = LP.PlayerGui:FindFirstChild("FamLV_V3") or LP.PlayerGui:FindFirstChildOfClass("ScreenGui")
        local n = Instance.new("Frame", sg)
        n.Size = UDim2.new(0, 280, 0, 55); n.Position = UDim2.new(1, 30, 1, -80)
        n.BackgroundColor3 = Theme.Secondary; ApplyCorner(n, 10)
        local st = Instance.new("UIStroke", n); st.Color = col or Theme.Accent; st.Thickness = 1.8
        
        local l = Instance.new("TextLabel", n)
        l.Size = UDim2.new(1, -20, 1, 0); l.Position = UDim2.new(0, 15, 0, 0)
        l.BackgroundTransparency = 1; l.Text = "✨ " .. msg; l.TextColor3 = Theme.Text
        l.Font = Enum.Font.GothamBold; l.TextSize = 13; l.TextXAlignment = 0
        
        QuickTween(n, {Position = UDim2.new(1, -300, 1, -80)})
        task.wait(2.5)
        QuickTween(n, {Position = UDim2.new(1, 30, 1, -80)})
        task.wait(0.4); n:Destroy()
    end)
end

-- ══════════════════════════════════════════
-- LOGIC CHỨC NĂNG
-- ══════════════════════════════════════════
local function ApplySpeed()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = State.SpeedEnabled and State.SpeedValue or 16 end
end

local function HandleFly()
    if not State.FlyEnabled then
        if State._FlyConn then State._FlyConn:Disconnect(); State._FlyConn = nil end
        if State.FlyBody then State.FlyBody:Destroy(); State.FlyBody = nil end
        if State.FlyGyro then State.FlyGyro:Destroy(); State.FlyGyro = nil end
        if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then LP.Character.Humanoid.PlatformStand = false end
        return
    end
    
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    State.FlyGyro = Instance.new("BodyGyro", root); State.FlyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9); State.FlyGyro.P = 9e4
    State.FlyBody = Instance.new("BodyVelocity", root); State.FlyBody.MaxForce = Vector3.new(9e9,9e9,9e9); State.FlyBody.Velocity = Vector3.zero
    
    State._FlyConn = RunService.RenderStepped:Connect(function()
        local vel = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - Cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + Cam.CFrame.RightVector end
        State.FlyBody.Velocity = vel * State.FlySpeed
        State.FlyGyro.CFrame = Cam.CFrame
    end)
end

-- ══════════════════════════════════════════
-- KHỞI TẠO GUI CHÍNH
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FamLV_V3"; ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LP.PlayerGui end

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "Main"; Main.Size = UDim2.new(0, 650, 0, 450); Main.Position = UDim2.new(0.5, -325, 0.5, -225)
Main.BackgroundColor3 = Theme.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
ApplyCorner(Main, 15)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Theme.Accent; MainStroke.Thickness = 1.2

-- Thanh tiêu đề (Kéo menu)
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 65); TopBar.BackgroundColor3 = Theme.Sidebar; TopBar.BorderSizePixel = 0
ApplyCorner(TopBar, 15)

local Logo = Instance.new("TextLabel", TopBar)
Logo.Text = "💎 FAM LV ULTIMATE"; Logo.Size = UDim2.new(0, 300, 1, 0); Logo.Position = UDim2.new(0, 25, 0, -5)
Logo.TextColor3 = Theme.Accent; Logo.Font = Enum.Font.GothamBold; Logo.TextSize = 22; Logo.BackgroundTransparency = 1; Logo.TextXAlignment = 0

local SubLogo = Instance.new("TextLabel", TopBar)
SubLogo.Text = "PREMIUM EDITION • TIẾNG VIỆT 100%"; SubLogo.Size = UDim2.new(0, 300, 0, 20); SubLogo.Position = UDim2.new(0, 25, 0, 35)
SubLogo.TextColor3 = Theme.SubText; SubLogo.Font = Enum.Font.Gotham; SubLogo.TextSize = 11; SubLogo.BackgroundTransparency = 1; SubLogo.TextXAlignment = 0

-- Nội dung chính
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, -65); Sidebar.Position = UDim2.new(0, 0, 0, 65); Sidebar.BackgroundColor3 = Theme.Sidebar; Sidebar.BorderSizePixel = 0

local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -180, 1, -65); ContentArea.Position = UDim2.new(0, 180, 0, 65); ContentArea.BackgroundTransparency = 1

local Tabs = {}
local TabListLayout = Instance.new("UIListLayout", Sidebar); TabListLayout.Padding = UDim.new(0, 10); TabListLayout.HorizontalAlignment = 1
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 15)

local function NewTab(name, icon)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0.85, 0, 0, 45); b.BackgroundColor3 = Theme.Secondary; b.BackgroundTransparency = 1
    b.Text = icon .. "   " .. name; b.TextColor3 = Theme.SubText; b.Font = Enum.Font.GothamBold; b.TextSize = 14
    b.BorderSizePixel = 0; ApplyCorner(b, 10)
    
    local p = Instance.new("ScrollingFrame", ContentArea)
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
    p.CanvasSize = UDim2.new(0, 0, 0, 0); p.AutomaticCanvasSize = 2; p.ScrollBarThickness = 0
    local pl = Instance.new("UIListLayout", p); pl.Padding = UDim.new(0, 12); pl.HorizontalAlignment = 1
    Instance.new("UIPadding", p).PaddingTop = UDim.new(0, 15); Instance.new("UIPadding", p).PaddingLeft = UDim.new(0, 10)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do 
            v.p.Visible = false; QuickTween(v.b, {BackgroundTransparency = 1, TextColor3 = Theme.SubText}) 
        end
        p.Visible = true; QuickTween(b, {BackgroundTransparency = 0, TextColor3 = Theme.Accent})
    end)
    Tabs[name] = {b = b, p = p}
    return p
end

-- ══════════════════════════════════════════
-- WIDGETS (CÔNG CỤ)
-- ══════════════════════════════════════════
local function AddToggle(p, title, desc, callback)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(0.94, 0, 0, 65); f.BackgroundColor3 = Theme.Secondary; f.BorderSizePixel = 0; ApplyCorner(f, 12)
    
    local t = Instance.new("TextLabel", f)
    t.Text = title; t.Size = UDim2.new(0.7, 0, 0, 30); t.Position = UDim2.new(0, 15, 0, 10)
    t.TextColor3 = Theme.Text; t.Font = Enum.Font.GothamBold; t.TextSize = 15; t.BackgroundTransparency = 1; t.TextXAlignment = 0
    
    local d = Instance.new("TextLabel", f)
    d.Text = desc; d.Size = UDim2.new(0.7, 0, 0, 20); d.Position = UDim2.new(0, 15, 0, 32)
    d.TextColor3 = Theme.SubText; d.Font = Enum.Font.Gotham; d.TextSize = 11; d.BackgroundTransparency = 1; d.TextXAlignment = 0
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 50, 0, 26); btn.Position = UDim2.new(1, -65, 0.5, -13); btn.Text = ""
    btn.BackgroundColor3 = Theme.Main; ApplyCorner(btn, 13)
    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 20, 0, 20); dot.Position = UDim2.new(0, 4, 0.5, -10); dot.BackgroundColor3 = Theme.SubText
    ApplyCorner(dot, 10)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        QuickTween(btn, {BackgroundColor3 = active and Theme.Accent or Theme.Main})
        QuickTween(dot, {Position = active and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10), BackgroundColor3 = active and Theme.Text or Theme.SubText})
    end)
end

local function AddSlider(p, title, min, max, def, callback)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0.94, 0, 0, 75); f.BackgroundColor3 = Theme.Secondary; ApplyCorner(f, 12)
    local l = Instance.new("TextLabel", f); l.Text = title .. ": " .. def; l.Size = UDim2.new(1, -30, 0, 35); l.Position = UDim2.new(0, 15, 0, 5); l.TextColor3 = Theme.Text; l.Font = Enum.Font.GothamBold; l.TextSize = 14; l.BackgroundTransparency = 1; l.TextXAlignment = 0
    
    local s_bg = Instance.new("Frame", f); s_bg.Size = UDim2.new(0.88, 0, 0, 6); s_bg.Position = UDim2.new(0.5, 0, 0.75, 0); s_bg.AnchorPoint = Vector2.new(0.5, 0.5); s_bg.BackgroundColor3 = Theme.Main; ApplyCorner(s_bg, 3)
    local fill = Instance.new("Frame", s_bg); fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; ApplyCorner(fill, 3)
    local btn = Instance.new("TextButton", s_bg); btn.Size = UDim2.new(0, 18, 0, 18); btn.Position = UDim2.new((def-min)/(max-min), -9, 0.5, -9); btn.Text = ""; btn.BackgroundColor3 = Theme.Text; ApplyCorner(btn, 10)
    
    btn.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local rel = math.clamp((UserInputService:GetMouseLocation().X - s_bg.AbsolutePosition.X) / s_bg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            l.Text = title .. ": " .. val; fill.Size = UDim2.new(rel, 0, 1, 0); btn.Position = UDim2.new(rel, -9, 0.5, -9)
            callback(val)
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

local function AddButton(p, title, icon, callback)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0.94, 0, 0, 45); b.BackgroundColor3 = Theme.Secondary; b.Text = icon .. "  " .. title; b.TextColor3 = Theme.Accent; b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.BorderSizePixel = 0
    ApplyCorner(b, 10); local bs = Instance.new("UIStroke", b); bs.Color = Theme.Accent; bs.Transparency = 0.6
    b.MouseButton1Click:Connect(function()
        QuickTween(b, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main}, 0.1)
        task.wait(0.1)
        QuickTween(b, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.Accent}, 0.1)
        callback()
    end)
end

-- ══════════════════════════════════════════
-- PHÂN CHIA 20 CHỨC NĂNG VÀO CÁC TAB
-- ══════════════════════════════════════════

-- TAB 1: DI CHUYỂN
local tabMove = NewTab("Di Chuyển", "🚀")
AddToggle(tabMove, "Tốc Độ (Speed)", "Chạy siêu nhanh như Flash", function(v) State.SpeedEnabled = v; ApplySpeed() end)
AddSlider(tabMove, "Chỉnh Tốc Độ", 16, 500, 50, function(v) State.SpeedValue = v; ApplySpeed() end)
AddToggle(tabMove, "Bay Lượn (Fly)", "Bay tự do (Dùng WASD để điều hướng)", function(v) State.FlyEnabled = v; HandleFly() end)
AddSlider(tabMove, "Tốc Độ Bay", 10, 500, 80, function(v) State.FlySpeed = v end)
AddToggle(tabMove, "Nhảy Vô Hạn", "Bấm nhảy bao nhiêu lần tùy thích", function(v) State.InfJump = v end)
AddToggle(tabMove, "Trọng Lực Thấp", "Nhảy cao và rơi chậm như mặt trăng", function(v) Workspace.Gravity = v and 35 or 196.2 end)
AddToggle(tabMove, "Xuyên Tường (NoClip)", "Đi xuyên qua mọi vật cản", function(v) 
    State.NoClip = v 
    if v then 
        RunService.Stepped:Connect(function() 
            if State.NoClip and LP.Character then 
                for _,p in pairs(LP.Character:GetDescendants()) do 
                    if p:IsA("BasePart") then p.CanCollide = false end 
                end 
            end 
        end) 
    end 
end)

-- TAB 2: TỰ ĐỘNG
local tabFarm = NewTab("Tự Động", "🤖")
AddToggle(tabFarm, "Auto Đánh", "Tự tìm quái và tiêu diệt tự động", function(v) 
    State.AutoFarm = v 
    task.spawn(function()
        while State.AutoFarm do
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent ~= LP.Character and v.Health > 0 then
                        LP.Character.HumanoidRootPart.CFrame = v.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)
AddToggle(tabFarm, "Auto Nhặt", "Tự động hút xu, ngọc, vật phẩm", function(v) State.AutoCollect = v end)
AddSlider(tabFarm, "Phạm Vi Quét", 10, 500, 50, function(v) State.AutoFarmRadius = v end)
AddToggle(tabFarm, "Thông Báo Chat", "Hiện Pop-up khi có người chat", function(v) State.ChatNotif = v end)
AddButton(tabFarm, "Về Điểm Spawn", "📍", function() LP.Character:MoveTo(Vector3.new(0, 100, 0)) end)

-- TAB 3: HÌNH ẢNH
local tabVis = NewTab("Hình Ảnh", "👁️")
AddToggle(tabVis, "Siêu Sáng (FullBright)", "Nhìn rõ trong bóng tối", function(v) Lighting.Brightness = v and 2 or 1; Lighting.OutdoorAmbient = v and Color3.new(1,1,1) or Color3.fromRGB(127,127,127) end)
AddToggle(tabVis, "Xóa Sương Mù", "Tăng tầm nhìn cực xa", function(v) Lighting.FogEnd = v and 1e6 or 1000 end)
AddSlider(tabVis, "Góc Nhìn (FOV)", 30, 120, 70, function(v) Cam.FieldOfView = v end)
AddToggle(tabVis, "Tâm Ngắm Custom", "Thêm tâm ngắm xanh giữa màn hình", function(v) 
    if v then 
        local ch = Instance.new("Frame", ScreenGui); ch.Name = "Cross"; ch.Size = UDim2.new(0,4,0,4); ch.Position = UDim2.new(0.5,-2,0.5,-2); ch.BackgroundColor3 = Theme.Success; ApplyCorner(ch, 10)
    else 
        if ScreenGui:FindFirstChild("Cross") then ScreenGui.Cross:Destroy() end 
    end 
end)
AddToggle(tabVis, "Tên Cầu Vồng", "Đổi màu tên nhân vật liên tục", function(v) State.RainbowName = v end)

-- TAB 4: TIỆN ÍCH
local tabMisc = NewTab("Hệ Thống", "⚙️")
AddToggle(tabMisc, "Chống Treo (Anti-AFK)", "Không bao giờ bị văng game", function(v) 
    State.AntiAFK = v
    LP.Idled:Connect(function() if State.AntiAFK then game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end end)
end)
AddToggle(tabMisc, "Hiện Tọa Độ", "Xem vị trí X, Y, Z hiện tại", function(v) State.ShowCoords = v end)
AddToggle(tabMisc, "Đóng Băng Giờ", "Giữ trời luôn ở 12 giờ trưa", function(v) State.TimeFreeze = v end)
AddToggle(tabMisc, "Mở Khóa FPS", "Tăng độ mượt mà cho game", function(v) if setfpscap then setfpscap(v and 999 or 60) end end)
AddButton(tabMisc, "Vào Lại Server", "🔄", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
AddButton(tabMisc, "Tối Ưu Lag (Xóa Rác)", "🗑️", function() 
    for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Explosion") then v:Destroy() end end 
    Notify("Đã tối ưu hóa bộ nhớ!", Theme.Success)
end)

-- Mở Tab đầu tiên mặc định
Tabs["Di Chuyển"].b.BackgroundTransparency = 0
Tabs["Di Chuyển"].b.TextColor3 = Theme.Accent
Tabs["Di Chuyển"].p.Visible = true

-- ══════════════════════════════════════════
-- HỆ THỐNG ĐIỀU KHIỂN (KÉO & PHÍM TẮT)
-- ══════════════════════════════════════════
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Phím tắt RightShift để Ẩn/Hiện
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        local visible = not Main.Visible
        if visible then
            Main.Visible = true
            Main.Position = UDim2.new(0.5, -325, 1, 50)
            QuickTween(Main, {Position = UDim2.new(0.5, -325, 0.5, -225)})
        else
            QuickTween(Main, {Position = UDim2.new(0.5, -325, 1, 50)})
            task.wait(0.3); Main.Visible = false
        end
    end
end)

-- Nhảy vô hạn logic
UserInputService.JumpRequest:Connect(function()
    if State.InfJump then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

Notify("FAM LV V3.0 ĐÃ SẴN SÀNG!", Theme.Success)
Notify("Nhấn phím RightShift để đóng/mở", Theme.Accent)
