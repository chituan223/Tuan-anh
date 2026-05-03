-- ╔═══════════════════════════════════════════════════════════════╗
-- ║        FAM LV MENU v2.0 - 20 CHỨC NĂNG (FIXED FULL)           ║
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
-- STATE TOÀN CỤC
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

-- ══════════════════════════════════════════
-- TIỆN ÍCH
-- ══════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function Corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c
end

local function Stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(0,210,255)
    s.Thickness = th or 1; s.Transparency = tr or 0.5; s.Parent = p; return s
end

local function Shadow(p)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"; s.BackgroundTransparency = 1
    s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = Color3.fromRGB(0,0,0); s.ImageTransparency = 0.55
    s.ScaleType = Enum.ScaleType.Slice; s.SliceCenter = Rect.new(49,49,450,450)
    s.Size = UDim2.new(1,46,1,46); s.Position = UDim2.new(0,-23,0,-23)
    s.ZIndex = p.ZIndex - 1; s.Parent = p; return s
end

local function Notify(msg, color)
    local sg = LP.PlayerGui:FindFirstChild("FamLV_v2") or LP.PlayerGui:FindFirstChildOfClass("ScreenGui")
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 240, 0, 44)
    n.Position = UDim2.new(1, 10, 1, -60)
    n.BackgroundColor3 = Color3.fromRGB(16,14,30)
    n.BorderSizePixel = 0; n.Parent = sg
    Corner(n, 8); Stroke(n, color or Color3.fromRGB(0,200,255), 1, 0.4)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,-16,1,0); lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = msg
    lbl.TextColor3 = Color3.fromRGB(220,220,255); lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = n
    Tween(n, {Position = UDim2.new(1,-254,1,-60)}, 0.4, Enum.EasingStyle.Back)
    task.delay(2.5, function()
        Tween(n, {Position = UDim2.new(1,10,1,-60)}, 0.3)
        task.delay(0.35, function() n:Destroy() end)
    end)
end

-- ══════════════════════════════════════════
-- CHỨC NĂNG THỰC
-- ══════════════════════════════════════════

-- 1. SPEED
local function ApplySpeed()
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = State.SpeedEnabled and State.SpeedValue or 16 end
    end
end

-- 2. FLY
local function StartFly()
    StopFly()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.P = 9e4; bg.Parent = root
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Velocity = Vector3.zero; bv.Parent = root
    State.FlyBody = bv; State.FlyGyro = bg
    
    State._FlyConn = RunService.RenderStepped:Connect(function()
        if not State.FlyEnabled or not root.Parent then StopFly() return end
        local vel = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - Cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - Cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + Cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0,1,0) end
        bv.Velocity = vel * State.FlySpeed
        bg.CFrame = Cam.CFrame
    end)
end

function StopFly()
    if State._FlyConn then State._FlyConn:Disconnect(); State._FlyConn = nil end
    if State.FlyBody then State.FlyBody:Destroy(); State.FlyBody = nil end
    if State.FlyGyro then State.FlyGyro:Destroy(); State.FlyGyro = nil end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

-- 3. INF JUMP
UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- 4. GRAVITY
local function ApplyGravity() Workspace.Gravity = State.LowGravity and 20 or 196.2 end

-- 5. AUTO COLLECT
local function AutoCollectLoop()
    task.spawn(function()
        while State.AutoCollect do
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not State.AutoCollect then break end
                    if obj:IsA("BasePart") then
                        local name = obj.Name:lower()
                        if name:find("coin") or name:find("fruit") or name:find("drop") or name:find("item") or name:find("gem") then
                            if (obj.Position - root.Position).Magnitude <= State.AutoFarmRadius then
                                firetouchinterest(root, obj, 0)
                                firetouchinterest(root, obj, 1)
                            end
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- 6. AUTO FARM
local function AutoFarmLoop()
    task.spawn(function()
        while State.AutoFarm do
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("Humanoid") and v.Parent ~= char and v.Health > 0 then
                        local mroot = v.Parent:FindFirstChild("HumanoidRootPart")
                        if mroot and (mroot.Position - root.Position).Magnitude <= State.AutoFarmRadius then
                            root.CFrame = mroot.CFrame * CFrame.new(0,0,3)
                            -- Giả lập đánh (Tùy game cần remote)
                            pcall(function() v:TakeDamage(5) end)
                        end
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

-- 7. FULLBRIGHT
local function ApplyFullBright()
    if State.FullBright then
        Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70); Lighting.Brightness = 1
    end
end

-- 8. FOV
local function ApplyFOV() Cam.FieldOfView = State.FOV end

-- 9. NO FOG
local function ApplyNoFog()
    Lighting.FogEnd = State.NoFog and 9e9 or 100000
end

-- 10. CROSSHAIR
local CrosshairGui
local function ToggleCrosshair()
    if CrosshairGui then CrosshairGui:Destroy(); CrosshairGui = nil end
    if not State.Crosshair then return end
    CrosshairGui = Instance.new("ScreenGui", LP.PlayerGui)
    local center = Instance.new("Frame", CrosshairGui)
    center.Size = UDim2.new(0,4,0,4); center.Position = UDim2.new(0.5,-2,0.5,-2)
    center.BackgroundColor3 = Color3.new(0,1,0); center.BorderSizePixel = 0
end

-- 11. ANTI AFK
local function ApplyAntiAFK()
    if State.AFKConn then State.AFKConn:Disconnect() end
    if State.AntiAFK then
        State.AFKConn = LP.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    end
end

-- 12. COORDINATES
local function ToggleCoords()
    if State.CoordLabel then State.CoordLabel.Parent:Destroy(); State.CoordLabel = nil end
    if not State.ShowCoords then return end
    local sg = Instance.new("ScreenGui", LP.PlayerGui)
    local lbl = Instance.new("TextLabel", sg)
    lbl.Size = UDim2.new(0,200,0,30); lbl.Position = UDim2.new(0,10,0,10)
    lbl.BackgroundTransparency = 0.5; lbl.BackgroundColor3 = Color3.new(0,0,0)
    lbl.TextColor3 = Color3.new(1,1,1); State.CoordLabel = lbl
    RunService.RenderStepped:Connect(function()
        if State.CoordLabel and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LP.Character.HumanoidRootPart.Position
            lbl.Text = string.format("X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)
        end
    end)
end

-- 13. RAINBOW NAME
local function ApplyRainbowName()
    if State.RainbowConn then State.RainbowConn:Disconnect() end
    if State.RainbowName then
        State.RainbowConn = RunService.Heartbeat:Connect(function()
            local char = LP.Character
            if char and char:FindFirstChild("Head") then
                local bbg = char.Head:FindFirstChildOfClass("BillboardGui")
                if bbg then
                    local txt = bbg:FindFirstChildOfClass("TextLabel")
                    if txt then txt.TextColor3 = Color3.fromHSV(tick()%5/5, 1, 1) end
                end
            end
        end)
    end
end

-- 14. TIME FREEZE
local function ApplyTimeFreeze()
    task.spawn(function()
        while State.TimeFreeze do
            Lighting.ClockTime = 14
            task.wait(1)
        end
    end)
end

-- 15. FPS UNLOCK
local function ApplyFPSUnlock()
    if setfpscap then setfpscap(State.FPSUnlock and 999 or 60) end
end

-- 16. NOCLIP
local function ApplyNoClip(v)
    State.NoClip = v
    if State._NoClipConn then State._NoClipConn:Disconnect() end
    if v then
        State._NoClipConn = RunService.Stepped:Connect(function()
            if LP.Character then
                for _, part in ipairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end
end

-- 17. TELEPORT SPAWN
local function TeleportToSpawn()
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn and LP.Character then
        LP.Character:MoveTo(spawn.Position)
    end
end

-- 18. REJOIN
local function Rejoin()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end

-- 19. REMOVE LAG
local function RemoveDecor()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled = false end
    end
end

-- 20. CHAT NOTIFY
local function ApplyChatNotif()
    for _, p in ipairs(Players:GetPlayers()) do
        p.Chatted:Connect(function(msg)
            if State.ChatNotif then Notify(p.Name..": "..msg, Color3.new(1,1,0)) end
        end)
    end
end

-- ══════════════════════════════════════════
-- GUI RENDER (FULL)
-- ══════════════════════════════════════════
local C = {
    BG = Color3.fromRGB(10, 10, 18), BG2 = Color3.fromRGB(16, 15, 28), BG3 = Color3.fromRGB(22, 20, 38),
    Accent = Color3.fromRGB(0, 210, 255), Accent2 = Color3.fromRGB(120, 80, 255),
    Green = Color3.fromRGB(0, 230, 140), Red = Color3.fromRGB(255, 70, 90),
    Text = Color3.fromRGB(230, 230, 255), Sub = Color3.fromRGB(120, 120, 160),
    On = Color3.fromRGB(0, 200, 130), Off = Color3.fromRGB(35, 33, 58),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FamLV_v2"; ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LP.PlayerGui end

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 460); Main.Position = UDim2.new(0.5,-300,0.5,-230)
Main.BackgroundColor3 = C.BG; Main.BorderSizePixel = 0; Main.ClipsDescendants = true
Corner(Main, 14); Stroke(Main, C.Accent, 1.5, 0.35); Shadow(Main)

-- TopBar
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1,0,0,54); TopBar.BackgroundColor3 = Color3.fromRGB(14,11,26); TopBar.BorderSizePixel = 0
Corner(TopBar, 14)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "FAM LV MENU V2.0"; Title.Size = UDim2.new(0,200,1,0); Title.Position = UDim2.new(0,20,0,0)
Title.TextColor3 = C.Text; Title.Font = Enum.Font.GothamBold; Title.TextSize = 18; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

-- Sidebar & Content
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,150,1,-54); Sidebar.Position = UDim2.new(0,0,0,54); Sidebar.BackgroundColor3 = Color3.fromRGB(12,9,22); Sidebar.BorderSizePixel = 0
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-150,1,-54); Content.Position = UDim2.new(0,150,0,54); Content.BackgroundTransparency = 1

local SBList = Instance.new("UIListLayout", Sidebar); SBList.Padding = UDim.new(0,5)

local Tabs = {}
local function NewTab(name)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1,0,0,40); b.Text = name; b.BackgroundColor3 = C.BG3; b.TextColor3 = C.Sub
    b.BorderSizePixel = 0; Corner(b, 0)
    
    local p = Instance.new("ScrollingFrame", Content)
    p.Size = UDim2.new(1,0,1,0); p.BackgroundTransparency = 1; p.Visible = false
    p.CanvasSize = UDim2.new(0,0,2,0); p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0,10)
    Instance.new("UIPadding", p).PaddingLeft = UDim.new(0,10)
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.p.Visible = false; v.b.TextColor3 = C.Sub end
        p.Visible = true; b.TextColor3 = C.Accent
    end)
    Tabs[name] = {b=b, p=p}
    return p
end

-- Helper Widgets
local function AddToggle(p, name, desc, cb)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(0.95, 0, 0, 50); f.BackgroundColor3 = C.BG2; Corner(f, 8)
    local l = Instance.new("TextLabel", f)
    l.Text = name; l.Size = UDim2.new(0.7,0,1,0); l.Position = UDim2.new(0,10,0,0)
    l.TextColor3 = C.Text; l.BackgroundTransparency = 1; l.TextXAlignment = 0
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0,40,0,20); btn.Position = UDim2.new(1,-50,0.5,-10); btn.Text = ""
    btn.BackgroundColor3 = C.Off; Corner(btn, 10)
    btn.MouseButton1Click:Connect(function()
        local s = btn.BackgroundColor3 == C.Off
        btn.BackgroundColor3 = s and C.On or C.Off
        cb(s)
    end)
end

local function AddSlider(p, name, min, max, def, cb)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(0.95,0,0,60); f.BackgroundColor3 = C.BG2; Corner(f,8)
    local l = Instance.new("TextLabel", f); l.Text = name.." ["..def.."]"; l.Size = UDim2.new(1,0,0,30); l.TextColor3 = C.Text; l.BackgroundTransparency = 1
    local s = Instance.new("Frame", f); s.Size = UDim2.new(0.8,0,0,4); s.Position = UDim2.new(0.1,0,0.7,0); s.BackgroundColor3 = C.BG3
    local btn = Instance.new("TextButton", s); btn.Size = UDim2.new(0,10,0,20); btn.Position = UDim2.new(0.5,0,0.5,-10); btn.Text = ""
    btn.MouseButton1Down:Connect(function()
        local conn; conn = RunService.RenderStepped:Connect(function()
            local m = UserInputService:GetMouseLocation().X
            local rel = math.clamp((m - s.AbsolutePosition.X)/s.AbsoluteSize.X, 0, 1)
            btn.Position = UDim2.new(rel, -5, 0.5, -10)
            local val = math.floor(min + (max-min)*rel)
            l.Text = name.." ["..val.."]"
            cb(val)
            if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then conn:Disconnect() end
        end)
    end)
end

local function AddBtn(p, name, cb)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(0.95,0,0,40); b.BackgroundColor3 = C.BG3; b.Text = name; b.TextColor3 = C.Accent; Corner(b,8)
    b.MouseButton1Click:Connect(cb)
end

-- ══════════════════════════════════════════
-- FILL TABS (20 FUNCTIONS)
-- ══════════════════════════════════════════
local t1 = NewTab("Movement")
AddToggle(t1, "Speed Hack", "", function(v) State.SpeedEnabled = v; ApplySpeed() end)
AddSlider(t1, "Speed Value", 16, 300, 30, function(v) State.SpeedValue = v; ApplySpeed() end)
AddToggle(t1, "Fly Hack", "", function(v) State.FlyEnabled = v; if v then StartFly() else StopFly() end end)
AddSlider(t1, "Fly Speed", 10, 500, 60, function(v) State.FlySpeed = v end)
AddToggle(t1, "Infinite Jump", "", function(v) State.InfJump = v end)
AddToggle(t1, "Low Gravity", "", function(v) State.LowGravity = v; ApplyGravity() end)
AddToggle(t1, "No Clip", "", function(v) ApplyNoClip(v) end)

local t2 = NewTab("Auto")
AddToggle(t2, "Auto Farm", "", function(v) State.AutoFarm = v; if v then AutoFarmLoop() end end)
AddToggle(t2, "Auto Collect", "", function(v) State.AutoCollect = v; if v then AutoCollectLoop() end end)
AddSlider(t2, "Radius", 10, 500, 50, function(v) State.AutoFarmRadius = v end)
AddToggle(t2, "Chat Notify", "", function(v) State.ChatNotif = v; ApplyChatNotif() end)
AddBtn(t2, "TP Spawn", function() TeleportToSpawn() end)

local t3 = NewTab("Visual")
AddToggle(t3, "Full Bright", "", function(v) State.FullBright = v; ApplyFullBright() end)
AddToggle(t3, "No Fog", "", function(v) State.NoFog = v; ApplyNoFog() end)
AddSlider(t3, "FOV", 30, 120, 70, function(v) State.FOV = v; ApplyFOV() end)
AddToggle(t3, "Crosshair", "", function(v) State.Crosshair = v; ToggleCrosshair() end)
AddToggle(t3, "Rainbow Name", "", function(v) State.RainbowName = v; ApplyRainbowName() end)

local t4 = NewTab("Misc")
AddToggle(t4, "Anti AFK", "", function(v) State.AntiAFK = v; ApplyAntiAFK() end)
AddToggle(t4, "Show Coords", "", function(v) State.ShowCoords = v; ToggleCoords() end)
AddToggle(t4, "Time Freeze", "", function(v) State.TimeFreeze = v; ApplyTimeFreeze() end)
AddToggle(t4, "FPS Unlock", "", function(v) State.FPSUnlock = v; ApplyFPSUnlock() end)
AddBtn(t4, "Rejoin", function() Rejoin() end)
AddBtn(t4, "Clear Lag", function() RemoveDecor() end)

-- Default Tab
Tabs["Movement"].b.TextColor3 = C.Accent
Tabs["Movement"].p.Visible = true

-- Drag & Toggle Menu
local dragging, dragInput, dragStart, startPos
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

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then Main.Visible = not Main.Visible end
end)

Notify("FAM LV V2 LOADED!", C.Green)
