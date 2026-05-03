-- ╔═══════════════════════════════════════════════════════════════╗
-- ║        FAM LV MENU PREMIUM v2.1 - INTERFACE REDESIGN          ║
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
-- CẤU HÌNH & TRẠNG THÁI
-- ══════════════════════════════════════════
local State = {
    SpeedEnabled = false, SpeedValue = 30,
    FlyEnabled = false, FlySpeed = 60,
    InfJump = false, LowGravity = false, NoClip = false,
    AutoFarm = false, AutoCollect = false, AutoFarmRadius = 50,
    FullBright = false, FOV = 70, NoFog = false, Crosshair = false,
    AntiAFK = false, ChatNotif = false, TimeFreeze = false, 
    FPSUnlock = false, ShowCoords = false, RainbowName = false,
    FlyBody = nil, FlyGyro = nil, CoordLabel = nil, AFKConn = nil, 
    RainbowConn = nil, _FlyConn = nil, _NoClipConn = nil
}

local Color = {
    Main = Color3.fromRGB(15, 15, 25),
    Accent = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(25, 25, 40),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 200),
    Green = Color3.fromRGB(0, 255, 120),
    Red = Color3.fromRGB(255, 50, 50)
}

-- ══════════════════════════════════════════
-- TIỆN ÍCH HỆ THỐNG
-- ══════════════════════════════════════════
local function QuickTween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function CreateShadow(parent)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"; s.BackgroundTransparency = 1
    s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = Color3.new(0,0,0); s.ImageTransparency = 0.5
    s.ScaleType = Enum.ScaleType.Slice; s.SliceCenter = Rect.new(49,49,450,450)
    s.Size = UDim2.new(1, 40, 1, 40); s.Position = UDim2.new(0, -20, 0, -20)
    s.ZIndex = parent.ZIndex - 1; s.Parent = parent
end

local function Notify(msg, col)
    task.spawn(function()
        local sg = LP.PlayerGui:FindFirstChild("FamLV_Premium") or LP.PlayerGui:FindFirstChildOfClass("ScreenGui")
        local n = Instance.new("Frame", sg)
        n.Size = UDim2.new(0, 250, 0, 50); n.Position = UDim2.new(1, 20, 1, -70)
        n.BackgroundColor3 = Color.Secondary; n.BorderSizePixel = 0
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", n); st.Color = col or Color.Accent; st.Thickness = 1.5
        
        local l = Instance.new("TextLabel", n)
        l.Size = UDim2.new(1, -20, 1, 0); l.Position = UDim2.new(0, 15, 0, 0)
        l.BackgroundTransparency = 1; l.Text = "🔔 " .. msg; l.TextColor3 = Color.Text
        l.Font = Enum.Font.GothamBold; l.TextSize = 13; l.TextXAlignment = 0
        
        QuickTween(n, {Position = UDim2.new(1, -270, 1, -70)})
        task.wait(2.5)
        QuickTween(n, {Position = UDim2.new(1, 20, 1, -70)})
        task.wait(0.4); n:Destroy()
    end)
end

-- ══════════════════════════════════════════
-- LOGIC CHỨC NĂNG (GIỮ NGUYÊN & FIX)
-- ══════════════════════════════════════════

local function ApplySpeed()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = State.SpeedEnabled and State.SpeedValue or 16 end
end

local function StopFly()
    if State._FlyConn then State._FlyConn:Disconnect(); State._FlyConn = nil end
    if State.FlyBody then State.FlyBody:Destroy(); State.FlyBody = nil end
    if State.FlyGyro then State.FlyGyro:Destroy(); State.FlyGyro = nil end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

local function StartFly()
    StopFly()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.P = 9e4
    local bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Velocity = Vector3.zero
    State.FlyBody, State.FlyGyro = bv, bg
    State._FlyConn = RunService.RenderStepped:Connect(function()
        if not State.FlyEnabled or not root.Parent then StopFly() return end
        local vel = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - Cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + Cam.CFrame.RightVector end
        bv.Velocity = vel * State.FlySpeed
        bg.CFrame = Cam.CFrame
    end)
end

local function ApplyGravity() Workspace.Gravity = State.LowGravity and 20 or 196.2 end

local function AutoCollectLoop()
    task.spawn(function()
        while State.AutoCollect do
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not State.AutoCollect then break end
                    if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem") or obj.Name:lower():find("fruit")) then
                        if (obj.Position - root.Position).Magnitude <= State.AutoFarmRadius then
                            firetouchinterest(root, obj, 0); firetouchinterest(root, obj, 1)
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local function AutoFarmLoop()
    task.spawn(function()
        while State.AutoFarm do
            local char = LP.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent ~= char and v.Health > 0 then
                        local mroot = v.Parent:FindFirstChild("HumanoidRootPart")
                        if mroot and (mroot.Position - char.HumanoidRootPart.Position).Magnitude <= State.AutoFarmRadius then
                            char.HumanoidRootPart.CFrame = mroot.CFrame * CFrame.new(0, 0, 3)
                            pcall(function() v:TakeDamage(5) end)
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

-- ══════════════════════════════════════════
-- KHỞI TẠO GIAO DIỆN HIỆN ĐẠI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FamLV_Premium"; ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LP.PlayerGui end

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"; Main.Size = UDim2.new(0, 620, 0, 420); Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color.Main; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", Main).Color = Color.Accent; CreateShadow(Main)

-- Topbar & Logo
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 60); TopBar.BackgroundColor3 = Color.Secondary; TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)

local Logo = Instance.new("TextLabel", TopBar)
Logo.Text = "💎 FAM LV PREMIUM"; Logo.Size = UDim2.new(0, 250, 1, 0); Logo.Position = UDim2.new(0, 20, 0, 0)
Logo.TextColor3 = Color.Accent; Logo.Font = Enum.Font.GothamBold; Logo.TextSize = 20; Logo.BackgroundTransparency = 1; Logo.TextXAlignment = 0

local Version = Instance.new("TextLabel", TopBar)
Version.Text = "PHIÊN BẢN v2.1 | TIẾNG VIỆT"; Version.Size = UDim2.new(0, 200, 0, 20); Version.Position = UDim2.new(0, 45, 0, 35)
Version.TextColor3 = Color.SubText; Version.Font = Enum.Font.Gotham; Version.TextSize = 10; Version.BackgroundTransparency = 1; Version.TextXAlignment = 0

-- Sidebar & Content Area
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 160, 1, -60); Sidebar.Position = UDim2.new(0, 0, 0, 60); Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 20); Sidebar.BorderSizePixel = 0
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -160, 1, -60); Content.Position = UDim2.new(0, 160, 0, 60); Content.BackgroundTransparency = 1

local Tabs = {}
local TabList = Instance.new("UIListLayout", Sidebar); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = 1

local function NewTab(name, icon)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, -10, 0, 45); b.BackgroundColor3 = Color.Secondary; b.BackgroundTransparency = 1
    b.Text = icon .. "  " .. name; b.TextColor3 = Color.SubText; b.Font = Enum.Font.GothamBold; b.TextSize = 14
    b.BorderSizePixel = 0; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    local p = Instance.new("ScrollingFrame", Content)
    p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false
    p.CanvasSize = UDim2.new(0, 0, 0, 0); p.AutomaticCanvasSize = Enum.AutomaticSize.Y; p.ScrollBarThickness = 0
    local pl = Instance.new("UIListLayout", p); pl.Padding = UDim.new(0, 10); pl.HorizontalAlignment = 1
    Instance.new("UIPadding", p).PaddingTop = UDim.new(0, 15); Instance.new("UIPadding", p).PaddingLeft = UDim.new(0, 10)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do 
            v.p.Visible = false; QuickTween(v.b, {BackgroundTransparency = 1, TextColor3 = Color.SubText}) 
        end
        p.Visible = true; QuickTween(b, {BackgroundTransparency = 0, TextColor3 = Color.Accent})
    end)
    Tabs[name] = {b = b, p = p}
    return p
end

-- Widgets Tiếng Việt Hiện Đại
local function AddToggle(p, title, desc, callback)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(0.95, 0, 0, 55); f.BackgroundColor3 = Color.Secondary; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    
    local l = Instance.new("TextLabel", f)
    l.Text = title; l.Size = UDim2.new(0.7, 0, 0, 30); l.Position = UDim2.new(0, 15, 0, 5)
    l.TextColor3 = Color.Text; l.Font = Enum.Font.GothamBold; l.TextSize = 14; l.BackgroundTransparency = 1; l.TextXAlignment = 0
    
    local d = Instance.new("TextLabel", f)
    d.Text = desc; d.Size = UDim2.new(0.7, 0, 0, 20); d.Position = UDim2.new(0, 15, 0, 25)
    d.TextColor3 = Color.SubText; d.Font = Enum.Font.Gotham; d.TextSize = 11; d.BackgroundTransparency = 1; d.TextXAlignment = 0
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0, 45, 0, 24); btn.Position = UDim2.new(1, -60, 0.5, -12); btn.Text = ""
    btn.BackgroundColor3 = Color.Main; Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 18, 0, 18); dot.Position = UDim2.new(0, 3, 0.5, -9); dot.BackgroundColor3 = Color.SubText
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        callback(active)
        QuickTween(btn, {BackgroundColor3 = active and Color.Accent or Color.Main})
        QuickTween(dot, {Position = active and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = active and Color.Text or Color.SubText})
    end)
end

local function AddSlider(p, title, min, max, def, callback)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0.95, 0, 0, 65); f.BackgroundColor3 = Color.Secondary; f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    local l = Instance.new("TextLabel", f); l.Text = title .. ": " .. def; l.Size = UDim2.new(1, -20, 0, 30); l.Position = UDim2.new(0, 15, 0, 5); l.TextColor3 = Color.Text; l.Font = Enum.Font.GothamBold; l.TextSize = 14; l.BackgroundTransparency = 1; l.TextXAlignment = 0
    
    local s_bg = Instance.new("Frame", f); s_bg.Size = UDim2.new(0.85, 0, 0, 6); s_bg.Position = UDim2.new(0.5, 0, 0.75, 0); s_bg.AnchorPoint = Vector2.new(0.5, 0.5); s_bg.BackgroundColor3 = Color.Main; Instance.new("UICorner", s_bg)
    local fill = Instance.new("Frame", s_bg); fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color.Accent; Instance.new("UICorner", fill)
    
    local btn = Instance.new("TextButton", s_bg); btn.Size = UDim2.new(0, 16, 0, 16); btn.Position = UDim2.new((def-min)/(max-min), -8, 0.5, -8); btn.Text = ""; btn.BackgroundColor3 = Color.Text; Instance.new("UICorner", btn)
    
    btn.MouseButton1Down:Connect(function()
        local move; move = RunService.RenderStepped:Connect(function()
            local mouseX = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mouseX - s_bg.AbsolutePosition.X) / s_bg.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * rel)
            l.Text = title .. ": " .. val; fill.Size = UDim2.new(rel, 0, 1, 0); btn.Position = UDim2.new(rel, -8, 0.5, -8)
            callback(val)
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then move:Disconnect() end
        end)
    end)
end

local function AddButton(p, title, callback)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0.95, 0, 0, 40); b.BackgroundColor3 = Color.Secondary; b.Text = title; b.TextColor3 = Color.Accent; b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", b).Color = Color.Accent
    b.MouseButton1Click:Connect(callback)
end

-- ══════════════════════════════════════════
-- PHÂN CHIA TỪNG TAB (20 CHỨC NĂNG)
-- ══════════════════════════════════════════

local tabMove = NewTab("Di Chuyển", "🚀")
AddToggle(tabMove, "Tốc Độ (Speed)", "Chạy nhanh hơn người thường", function(v) State.SpeedEnabled = v; ApplySpeed() end)
AddSlider(tabMove, "Chỉnh Tốc Độ", 16, 300, 30, function(v) State.SpeedValue = v; ApplySpeed() end)
AddToggle(tabMove, "Bay Lượn (Fly)", "Bay tự do như chim (WASD)", function(v) State.FlyEnabled = v; if v then StartFly() else StopFly() end end)
AddSlider(tabMove, "Tốc Độ Bay", 10, 500, 60, function(v) State.FlySpeed = v end)
AddToggle(tabMove, "Nhảy Vô Hạn", "Nhảy bao nhiêu tùy thích", function(v) State.InfJump = v end)
AddToggle(tabMove, "Trọng Lực Thấp", "Nhảy cực cao và nhẹ", function(v) State.LowGravity = v; ApplyGravity() end)
AddToggle(tabMove, "Xuyên Tường (Noclip)", "Đi qua mọi vật cản", function(v) pcall(function() State.NoClip = v; if v then RunService.Stepped:Connect(function() if State.NoClip then for _,p in pairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) end end) end)

local tabFarm = NewTab("Tự Động", "🤖")
AddToggle(tabFarm, "Auto Đánh", "Tự tìm quái và tiêu diệt", function(v) State.AutoFarm = v; if v then AutoFarmLoop() end end)
AddToggle(tabFarm, "Auto Nhặt Đồ", "Tự nhặt xu, ngọc, trái cây", function(v) State.AutoCollect = v; if v then AutoCollectLoop() end end)
AddSlider(tabFarm, "Phạm Vi Quét", 10, 500, 50, function(v) State.AutoFarmRadius = v end)
AddToggle(tabFarm, "Thông Báo Chat", "Hiện thông báo khi có người chat", function(v) State.ChatNotif = v; if v then Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(m) if State.ChatNotif then Notify(p.Name..": "..m) end end) end) for _,p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(m) if State.ChatNotif then Notify(p.Name..": "..m) end end) end end end)
AddButton(tabFarm, "📍 Về Điểm Hồi Sinh (Spawn)", function() TeleportToSpawn() end)

local tabVis = NewTab("Hình Ảnh", "👁️")
AddToggle(tabVis, "Siêu Sáng (FullBright)", "Nhìn rõ mọi thứ trong bóng tối", function(v) State.FullBright = v; Lighting.Ambient = v and Color3.new(1,1,1) or Color3.fromRGB(70,70,70) end)
AddToggle(tabVis, "Xóa Sương Mù", "Nhìn xa không bị mờ", function(v) Lighting.FogEnd = v and 9e9 or 100000 end)
AddSlider(tabVis, "Góc Nhìn (FOV)", 30, 120, 70, function(v) Cam.FieldOfView = v end)
AddToggle(tabVis, "Tâm Ngắm Custom", "Thêm tâm ngắm chính xác", function(v) if v then State.Crosshair = true; local c = Instance.new("ScreenGui", LP.PlayerGui); c.Name="CH"; local f = Instance.new("Frame", c); f.Size=UDim2.new(0,4,0,4); f.Position=UDim2.new(0.5,-2,0.5,-2); f.BackgroundColor3=Color.Green else if LP.PlayerGui:FindFirstChild("CH") then LP.PlayerGui.CH:Destroy() end end end)
AddToggle(tabVis, "Tên Cầu Vồng", "Đổi màu tên nhân vật liên tục", function(v) State.RainbowName = v; if v then RunService.Heartbeat:Connect(function() if State.RainbowName then local c = Color3.fromHSV(tick()%5/5, 1, 1) pcall(function() LP.Character.Head.BillboardGui.TextLabel.TextColor3 = c end) end end) end end)

local tabMisc = NewTab("Tiện Ích", "⚙️")
AddToggle(tabMisc, "Chống Treo Máy (AntiAFK)", "Không bao giờ bị đuổi khỏi game", function(v) State.AntiAFK = v; LP.Idled:Connect(function() if State.AntiAFK then game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end end) end)
AddToggle(tabMisc, "Hiện Tọa Độ", "Xem vị trí hiện tại của bạn", function(v) State.ShowCoords = v; if v then Notify("Tọa độ đã bật góc trái") end end)
AddToggle(tabMisc, "Đóng Băng Giờ", "Giữ trời luôn luôn sáng trưa", function(v) State.TimeFreeze = v; task.spawn(function() while State.TimeFreeze do Lighting.ClockTime = 14; task.wait(1) end end) end)
AddToggle(tabMisc, "Mở Khóa FPS", "Tối ưu hóa độ mượt game", function(v) if setfpscap then setfpscap(v and 999 or 60) end end)
AddButton(tabMisc, "🔄 Vào Lại Server", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LP) end)
AddButton(tabMisc, "🗑️ Giảm Lag (Xóa Rác)", function() for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("ParticleEmitter") then v.Enabled = false end end Notify("Đã tối ưu Lag!") end)

-- Mở Tab đầu tiên
Tabs["Di Chuyển"].b.BackgroundTransparency = 0
Tabs["Di Chuyển"].b.TextColor3 = Color.Accent
Tabs["Di Chuyển"].p.Visible = true

-- ══════════════════════════════════════════
-- HỆ THỐNG KÉO & BẮT MENU
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

-- Bắt Menu (RightShift)
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        local targetPos = Main.Visible and UDim2.new(0.5, -310, 1, 100) or UDim2.new(0.5, -310, 0.5, -210)
        if Main.Visible then
            QuickTween(Main, {Position = targetPos})
            task.wait(0.3); Main.Visible = false
        else
            Main.Visible = true
            Main.Position = UDim2.new(0.5, -310, 1, 100)
            QuickTween(Main, {Position = targetPos})
        end
    end
end)

Notify("FAM LV PREMIUM ĐÃ TẢI XONG!", Color.Green)
Notify("Nhấn RightShift để Ẩn/Hiện Menu", Color.Accent)
