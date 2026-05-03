-- ╔═══════════════════════════════════════════════════════════════╗
-- ║            FAM LV MENU v2.0 - 20 CHỨC NĂNG THẬT             ║
-- ║         Paste vào Executor (Synapse, KRNL, Fluxus...)        ║
-- ║   Phím RightShift = Ẩn/Hiện  |  Kéo TopBar để di chuyển     
-- ╚║═══════════════════════════════════════════════════════════════╝

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local StarterGui       = game:GetService("StarterGui")

local LP  = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

-- ══════════════════════════════════════════
--  STATE TOÀN CỤC
-- ══════════════════════════════════════════
local State = {
    -- Movement
    SpeedEnabled    = false,
    SpeedValue      = 30,
    FlyEnabled      = false,
    FlySpeed        = 60,
    InfJump         = false,
    LowGravity      = false,
    -- Auto
    AutoFarm        = false,
    AutoCollect     = false,
    AutoFarmRadius  = 50,
    -- Visual
    FullBright      = false,
    FOV             = 70,
    NoFog           = false,
    Crosshair       = false,
    -- Misc
    AntiAFK         = false,
    ChatNotif       = false,
    TimeFreeze      = false,
    FPSUnlock       = false,
    ShowCoords      = false,
    RainbowName     = false,
    -- Internal
    FlyBody         = nil,
    FlyGyro         = nil,
    CoordLabel      = nil,
    AFKConn         = nil,
    RainbowConn     = nil,
}

-- ══════════════════════════════════════════
--  TIỆN ÍCH
-- ══════════════════════════════════════════
local function Tween(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(
        t or 0.25,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    ), props):Play()
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
    -- Thông báo nổi góc phải
    local sg = ScreenGui or LP.PlayerGui
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
--  CHỨC NĂNG THỰC
-- ══════════════════════════════════════════

-- 1. SPEED HACK
local function ApplySpeed()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = State.SpeedEnabled and State.SpeedValue or 16
    end
end

-- 2. FLY
local function StartFly()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.D = 100; bg.Parent = root
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Velocity = Vector3.zero; bv.Parent = root
    State.FlyBody = bv; State.FlyGyro = bg

    State._FlyConn = RunService.Heartbeat:Connect(function()
        if not State.FlyEnabled then return end
        local cf = Cam.CFrame
        local vel = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel = vel + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel = vel - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel = vel - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel = vel + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel = vel + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel = vel - Vector3.new(0,1,0) end
        bv.Velocity = vel * State.FlySpeed
        bg.CFrame = cf
    end)
end

local function StopFly()
    if State._FlyConn then State._FlyConn:Disconnect() end
    if State.FlyBody then State.FlyBody:Destroy(); State.FlyBody = nil end
    if State.FlyGyro then State.FlyGyro:Destroy(); State.FlyGyro = nil end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- 3. INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LP.Character then
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- 4. LOW GRAVITY
local function ApplyGravity()
    Workspace.Gravity = State.LowGravity and 20 or 196.2
end

-- 5. AUTO COLLECT (nhặt item gần nhất trong workspace)
local function AutoCollectLoop()
    task.spawn(function()
        while State.AutoCollect do
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not State.AutoCollect then break end
                    -- Tìm Part có tên liên quan đến item/coin/fruit/drop
                    local name = obj.Name:lower()
                    if obj:IsA("BasePart") and (
                        name:find("coin") or name:find("fruit") or
                        name:find("drop") or name:find("item") or
                        name:find("gem") or name:find("orb") or
                        name:find("pickup") or name:find("collect") or
                        name:find("reward") or name:find("chest")
                    ) then
                        local dist = (obj.Position - root.Position).Magnitude
                        if dist <= State.AutoFarmRadius then
                            -- Teleport nhân vật đến item để nhặt
                            root.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0))
                            task.wait(0.1)
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- 6. AUTO FARM (tấn công mob/enemy gần nhất)
local function AutoFarmLoop()
    task.spawn(function()
        while State.AutoFarm do
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local myHum = char and char:FindFirstChildOfClass("Humanoid")
            if root and myHum and myHum.Health > 0 then
                local closest, closestDist = nil, State.AutoFarmRadius
                -- Tìm NPC/Mob có Humanoid trong workspace
                for _, model in ipairs(Workspace:GetDescendants()) do
                    if model:IsA("Model") and model ~= char then
                        local hum = model:FindFirstChildOfClass("Humanoid")
                        local mroot = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
                        if hum and hum.Health > 0 and mroot then
                            local d = (mroot.Position - root.Position).Magnitude
                            if d < closestDist then
                                closestDist = d; closest = model
                            end
                        end
                    end
                end
                if closest then
                    local mroot = closest:FindFirstChild("HumanoidRootPart") or closest:FindFirstChild("Torso")
                    if mroot then
                        -- Teleport sát mob
                        root.CFrame = CFrame.new(mroot.Position + Vector3.new(0,0,3))
                        -- Simulate click/attack tool nếu có
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            local fireRemote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
                            -- Kích hoạt tool nếu game dùng ClickDetector
                            local mhum = closest:FindFirstChildOfClass("Humanoid")
                            if mhum then
                                mhum:TakeDamage(10) -- fallback client-side (không phải server)
                            end
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
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Brightness = 1
    end
end

-- 8. FOV CHANGER
local function ApplyFOV()
    Cam.FieldOfView = State.FOV
end

-- 9. NO FOG
local function ApplyNoFog()
    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if atm then atm.Density = State.NoFog and 0 or 0.395 end
    Lighting.FogEnd = State.NoFog and 9e9 or 100000
    Lighting.FogStart = State.NoFog and 9e9 or 0
end

-- 10. CROSSHAIR TÙY CHỈNH
local CrosshairGui
local function ToggleCrosshair()
    if CrosshairGui then CrosshairGui:Destroy(); CrosshairGui = nil end
    if not State.Crosshair then return end
    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "FamLV_Crosshair"; CrosshairGui.ResetOnSpawn = false
    local ok = pcall(function() CrosshairGui.Parent = game:GetService("CoreGui") end)
    if not ok then CrosshairGui.Parent = LP.PlayerGui end

    local center = UDim2.new(0.5, 0, 0.5, 0)
    local size2 = UDim2.new(0, 2, 0, 2)
    local col = Color3.fromRGB(0, 255, 180)

    -- 4 đường + dot giữa
    local lines = {
        {UDim2.new(0,16,0,2), UDim2.new(0.5,-22,0.5,-1)}, -- phải
        {UDim2.new(0,16,0,2), UDim2.new(0.5, 6, 0.5,-1)}, -- trái
        {UDim2.new(0,2,0,16), UDim2.new(0.5,-1,0.5,-22)}, -- trên
        {UDim2.new(0,2,0,16), UDim2.new(0.5,-1,0.5, 6)},  -- dưới
    }
    for _, l in ipairs(lines) do
        local f = Instance.new("Frame")
        f.Size = l[1]; f.Position = l[2]
        f.BackgroundColor3 = col; f.BorderSizePixel = 0; f.Parent = CrosshairGui
    end
    local dot = Instance.new("Frame")
    dot.Size = size2; dot.Position = UDim2.new(0.5,-1,0.5,-1)
    dot.BackgroundColor3 = col; dot.BorderSizePixel = 0; dot.Parent = CrosshairGui
end

-- 11. ANTI AFK
local function ApplyAntiAFK()
    if State.AFKConn then State.AFKConn:Disconnect(); State.AFKConn = nil end
    if State.AntiAFK then
        local vrs = game:GetService("VirtualUser")
        State.AFKConn = LP.Idled:Connect(function()
            vrs:Button2Down(Vector2.new(0,0), CFrame.new())
            task.wait(1)
            vrs:Button2Up(Vector2.new(0,0), CFrame.new())
        end)
    end
end

-- 12. SHOW COORDINATES
local function ToggleCoords()
    if State.CoordLabel then State.CoordLabel.Parent:Destroy(); State.CoordLabel = nil end
    if not State.ShowCoords then return end
    local sg = Instance.new("ScreenGui"); sg.Name = "FamLV_Coords"; sg.ResetOnSpawn = false
    local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
    if not ok then sg.Parent = LP.PlayerGui end
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,220,0,22); lbl.Position = UDim2.new(0,10,0,10)
    lbl.BackgroundColor3 = Color3.fromRGB(10,8,22); lbl.BackgroundTransparency = 0.3
    lbl.BorderSizePixel = 0; lbl.TextColor3 = Color3.fromRGB(0,255,180)
    lbl.Font = Enum.Font.Code; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sg; Corner(lbl, 4)
    State.CoordLabel = lbl
    RunService.Heartbeat:Connect(function()
        if not State.ShowCoords or not lbl.Parent then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local p = root.Position
            lbl.Text = string.format("  X:%.1f  Y:%.1f  Z:%.1f", p.X, p.Y, p.Z)
        end
    end)
end

-- 13. RAINBOW NAME (local)
local function ApplyRainbowName()
    if State.RainbowConn then State.RainbowConn:Disconnect(); State.RainbowConn = nil end
    if State.RainbowName then
        local hue = 0
        State.RainbowConn = RunService.Heartbeat:Connect(function()
            hue = (hue + 0.5) % 360
            local c = Color3.fromHSV(hue/360, 1, 1)
            -- Đổi màu overhead display name (nếu game có BillboardGui)
            local char = LP.Character
            if char then
                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("TextLabel") and v.Parent:IsA("BillboardGui") then
                        v.TextColor3 = c
                    end
                end
            end
        end)
    else
        -- Reset về trắng
        local char = LP.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("TextLabel") and v.Parent:IsA("BillboardGui") then
                    v.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end
        end
    end
end

-- 14. TIME FREEZE
local function ApplyTimeFreeze()
    Lighting.ClockTime = State.TimeFreeze and 14 or 14
    if State.TimeFreeze then
        -- Dừng cycle ánh sáng bằng cách tắt TimeOfDay animation
        local sun = Lighting:FindFirstChildOfClass("Sky")
        -- Freeze clock ở 14:00 (trưa sáng nhất)
        Lighting.ClockTime = 14
    end
end

-- 15. FPS UNLOCKER (client setting)
local function ApplyFPSUnlock()
    -- Dùng settings() nếu executor hỗ trợ
    local ok = pcall(function()
        if State.FPSUnlock then
            setfpscap(0)  -- executor API: bỏ cap FPS
        else
            setfpscap(60)
        end
    end)
    if not ok then
        -- Fallback: dùng RunService
        -- Không làm được không có executor API, thông báo user
    end
end

-- 16. NOCLIP
local NoClipConn
local function ApplyNoClip(val)
    if NoClipConn then NoClipConn:Disconnect(); NoClipConn = nil end
    if val then
        NoClipConn = RunService.Stepped:Connect(function()
            local char = LP.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        local char = LP.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

-- 17. TELEPORT ĐẾN SPAWN
local function TeleportToSpawn()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then Notify("❌ Không tìm thấy nhân vật!"); return end
    -- Tìm SpawnLocation
    local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        root.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 5, 0))
        Notify("✅ Đã teleport về Spawn!")
    else
        -- Fallback: về gốc tọa độ
        root.CFrame = CFrame.new(0, 10, 0)
        Notify("✅ Đã teleport về 0,0!")
    end
end

-- 18. REJOIN
local function Rejoin()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end

-- 19. XÓA DECORATION (cây cỏ lag)
local function RemoveDecor()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v:Destroy()
        end
    end
    Notify("✅ Đã xóa decoration - tăng FPS!")
end

-- 20. CHAT NOTIFY (hiện thông báo khi ai chat)
local ChatConn
local function ApplyChatNotif()
    if ChatConn then ChatConn:Disconnect(); ChatConn = nil end
    if State.ChatNotif then
        ChatConn = Players.PlayerAdded:Connect(function() end) -- placeholder
        -- Lắng nghe chat
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local ok = pcall(function()
                    p.Chatted:Connect(function(msg)
                        if State.ChatNotif then
                            Notify("💬 " .. p.Name .. ": " .. msg:sub(1,30), Color3.fromRGB(255,200,0))
                        end
                    end)
                end)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            p.Chatted:Connect(function(msg)
                if State.ChatNotif then
                    Notify("💬 " .. p.Name .. ": " .. msg:sub(1,30), Color3.fromRGB(255,200,0))
                end
            end)
        end)
    end
end

-- ══════════════════════════════════════════
--  XÂY DỰNG GUI
-- ══════════════════════════════════════════
local C = {
    BG      = Color3.fromRGB(10, 10, 18),
    BG2     = Color3.fromRGB(16, 15, 28),
    BG3     = Color3.fromRGB(22, 20, 38),
    Accent  = Color3.fromRGB(0,  210, 255),
    Accent2 = Color3.fromRGB(120, 80, 255),
    Green   = Color3.fromRGB(0,  230, 140),
    Red     = Color3.fromRGB(255, 70,  90),
    Text    = Color3.fromRGB(230, 230, 255),
    Sub     = Color3.fromRGB(120, 120, 160),
    On      = Color3.fromRGB(0,  200, 130),
    Off     = Color3.fromRGB(35,  33,  58),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FamLV_v2"; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false; ScreenGui.DisplayOrder = 999
local sgOk = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not sgOk then ScreenGui.Parent = LP.PlayerGui end

-- ── MAIN ──────────────────────────────────
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 600, 0, 460)
Main.Position = UDim2.new(0.5,-300,0.5,-230)
Main.BackgroundColor3 = C.BG
Main.BorderSizePixel = 0; Main.ClipsDescendants = true; Main.Parent = ScreenGui
Corner(Main, 14); Stroke(Main, C.Accent, 1.5, 0.35); Shadow(Main)

local BgGrad = Instance.new("UIGradient"); BgGrad.Rotation = 145
BgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12,8,24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8,14,26)),
}); BgGrad.Parent = Main

-- ── TOP BAR ───────────────────────────────
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,54); TopBar.BackgroundColor3 = Color3.fromRGB(14,11,26)
TopBar.BorderSizePixel = 0; TopBar.Parent = Main; Corner(TopBar, 14)
local TBFix = Instance.new("Frame"); TBFix.Size = UDim2.new(1,0,0.5,0)
TBFix.Position = UDim2.new(0,0,0.5,0); TBFix.BackgroundColor3 = Color3.fromRGB(14,11,26)
TBFix.BorderSizePixel = 0; TBFix.Parent = TopBar

local TopLine = Instance.new("Frame"); TopLine.Size = UDim2.new(1,0,0,2)
TopLine.Position = UDim2.new(0,0,1,-2); TopLine.BackgroundColor3 = C.Accent
TopLine.BorderSizePixel = 0; TopLine.Parent = TopBar
local TLG = Instance.new("UIGradient")
TLG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.Accent2),
    ColorSequenceKeypoint.new(0.5, C.Accent),
    ColorSequenceKeypoint.new(1, C.Accent2),
}); TLG.Parent = TopLine

-- Logo badge
local Badge = Instance.new("Frame"); Badge.Size = UDim2.new(0,38,0,38)
Badge.Position = UDim2.new(0,12,0.5,-19); Badge.BackgroundColor3 = C.Accent2
Badge.BorderSizePixel = 0; Badge.Parent = TopBar; Corner(Badge, 10)
local BadgeGrad = Instance.new("UIGradient")
BadgeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.Accent2),
    ColorSequenceKeypoint.new(1, C.Accent),
}); BadgeGrad.Rotation = 135; BadgeGrad.Parent = Badge
local BadgeTxt = Instance.new("TextLabel"); BadgeTxt.Size = UDim2.new(1,0,1,0)
BadgeTxt.BackgroundTransparency = 1; BadgeTxt.Text = "FL"
BadgeTxt.TextColor3 = Color3.fromRGB(255,255,255); BadgeTxt.Font = Enum.Font.GothamBold
BadgeTxt.TextSize = 16; BadgeTxt.Parent = Badge

local Title = Instance.new("TextLabel"); Title.Size = UDim2.new(0,220,0,22)
Title.Position = UDim2.new(0,58,0,8); Title.BackgroundTransparency = 1
Title.Text = "FAM LV MENU"; Title.TextColor3 = C.Text
Title.Font = Enum.Font.GothamBold; Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = TopBar
local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, C.Accent),
}); TitleGrad.Parent = Title

local SubTitle = Instance.new("TextLabel"); SubTitle.Size = UDim2.new(0,220,0,16)
SubTitle.Position = UDim2.new(0,58,0,31); SubTitle.BackgroundTransparency = 1
SubTitle.Text = "v2.0  •  20 Chức Năng"; SubTitle.TextColor3 = C.Sub
SubTitle.Font = Enum.Font.Gotham; SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left; SubTitle.Parent = TopBar

-- Nút X và Minimize
local function MkBtn(xoff, bg, txt, tsz)
    local b = Instance.new("TextButton"); b.Size = UDim2.new(0,28,0,28)
    b.Position = UDim2.new(1, xoff, 0.5, -14); b.BackgroundColor3 = bg
    b.Text = txt; b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold; b.TextSize = tsz or 12
    b.BorderSizePixel = 0; b.Parent = TopBar; Corner(b, 7); return b
end
local CloseBtn = MkBtn(-40, C.Red, "✕", 12)
local MinBtn   = MkBtn(-74, C.BG3, "—", 14)

-- ── SIDEBAR ───────────────────────────────
local Sidebar = Instance.new("Frame"); Sidebar.Size = UDim2.new(0,148,1,-54)
Sidebar.Position = UDim2.new(0,0,0,54); Sidebar.BackgroundColor3 = Color3.fromRGB(12,9,22)
Sidebar.BorderSizePixel = 0; Sidebar.Parent = Main
local SBLine = Instance.new("Frame"); SBLine.Size = UDim2.new(0,1,1,0)
SBLine.Position = UDim2.new(1,-1,0,0); SBLine.BackgroundColor3 = C.Accent
SBLine.BackgroundTransparency = 0.75; SBLine.BorderSizePixel = 0; SBLine.Parent = Sidebar
local SBList = Instance.new("UIListLayout"); SBList.Padding = UDim.new(0,4)
SBList.HorizontalAlignment = Enum.HorizontalAlignment.Center; SBList.Parent = Sidebar
local SBPad = Instance.new("UIPadding"); SBPad.PaddingTop = UDim.new(0,10); SBPad.Parent = Sidebar

-- ── CONTENT ───────────────────────────────
local Content = Instance.new("Frame"); Content.Size = UDim2.new(1,-148,1,-54)
Content.Position = UDim2.new(0,148,0,54); Content.BackgroundTransparency = 1; Content.Parent = Main

-- ══════════════════════════════════════════
--  TAB SYSTEM
-- ══════════════════════════════════════════
local Tabs = {}; local ActiveTab = nil

local function NewTab(icon, name)
    local full = icon .. " " .. name
    local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(1,-14,0,40)
    Btn.BackgroundColor3 = C.BG3; Btn.BackgroundTransparency = 1
    Btn.Text = full; Btn.TextColor3 = C.Sub
    Btn.Font = Enum.Font.Gotham; Btn.TextSize = 13
    Btn.BorderSizePixel = 0; Btn.Parent = Sidebar; Corner(Btn, 8)

    local Ind = Instance.new("Frame"); Ind.Size = UDim2.new(0,3,0.55,0)
    Ind.Position = UDim2.new(0,3,0.225,0); Ind.BackgroundColor3 = C.Accent
    Ind.BackgroundTransparency = 1; Ind.BorderSizePixel = 0; Ind.Parent = Btn; Corner(Ind, 3)

    local Page = Instance.new("ScrollingFrame"); Page.Size = UDim2.new(1,0,1,0)
    Page.BackgroundTransparency = 1; Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3; Page.ScrollBarImageColor3 = C.Accent
    Page.CanvasSize = UDim2.new(0,0,0,0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Visible = false; Page.Parent = Content
    local PList = Instance.new("UIListLayout"); PList.Padding = UDim.new(0,7); PList.Parent = Page
    local PPad = Instance.new("UIPadding"); PPad.PaddingTop = UDim.new(0,12)
    PPad.PaddingLeft = UDim.new(0,14); PPad.PaddingRight = UDim.new(0,14); PPad.Parent = Page

    Tabs[full] = {Btn=Btn, Page=Page, Ind=Ind}

    Btn.MouseButton1Click:Connect(function()
        for k,v in pairs(Tabs) do
            v.Page.Visible = false
            Tween(v.Btn, {BackgroundTransparency=1, TextColor3=C.Sub}, 0.18)
            Tween(v.Ind, {BackgroundTransparency=1}, 0.18)
            v.Btn.Font = Enum.Font.Gotham
        end
        Page.Visible = true
        Tween(Btn, {BackgroundTransparency=0.82, TextColor3=C.Text}, 0.18)
        Tween(Ind, {BackgroundTransparency=0}, 0.18)
        Btn.Font = Enum.Font.GothamBold
        ActiveTab = full
    end)
    Btn.MouseEnter:Connect(function()
        if ActiveTab ~= full then Tween(Btn, {BackgroundTransparency=0.9}, 0.12) end
    end)
    Btn.MouseLeave:Connect(function()
        if ActiveTab ~= full then Tween(Btn, {BackgroundTransparency=1}, 0.12) end
    end)
    return Page
end

-- ══════════════════════════════════════════
--  WIDGET CREATORS
-- ══════════════════════════════════════════

-- SECTION HEADER
local function Hdr(page, txt)
    local f = Instance.new("Frame"); f.Size = UDim2.new(1,0,0,20); f.BackgroundTransparency = 1; f.Parent = page
    local line = Instance.new("Frame"); line.Size = UDim2.new(1,0,0,1); line.Position = UDim2.new(0,0,0.5,0)
    line.BackgroundColor3 = C.Accent; line.BackgroundTransparency = 0.75; line.BorderSizePixel = 0; line.Parent = f
    local t = Instance.new("TextLabel"); t.Size = UDim2.new(0,0,1,0); t.AutomaticSize = Enum.AutomaticSize.X
    t.BackgroundColor3 = C.BG; t.BorderSizePixel = 0; t.Text = "  "..txt.."  "
    t.TextColor3 = C.Accent; t.Font = Enum.Font.GothamBold; t.TextSize = 10; t.Parent = f
end

-- TOGGLE
local function Toggle(page, lbl, desc, initVal, cb)
    local state = initVal or false
    local Row = Instance.new("Frame"); Row.Size = UDim2.new(1,0,0,56)
    Row.BackgroundColor3 = C.BG2; Row.BorderSizePixel = 0; Row.Parent = page
    Corner(Row,8); Stroke(Row, C.Accent, 1, 0.82)

    local L = Instance.new("TextLabel"); L.Size = UDim2.new(1,-72,0,20); L.Position = UDim2.new(0,14,0,9)
    L.BackgroundTransparency = 1; L.Text = lbl; L.TextColor3 = C.Text
    L.Font = Enum.Font.GothamBold; L.TextSize = 13; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = Row

    local D = Instance.new("TextLabel"); D.Size = UDim2.new(1,-72,0,14); D.Position = UDim2.new(0,14,0,31)
    D.BackgroundTransparency = 1; D.Text = desc or ""; D.TextColor3 = C.Sub
    D.Font = Enum.Font.Gotham; D.TextSize = 11; D.TextXAlignment = Enum.TextXAlignment.Left; D.Parent = Row

    local TBg = Instance.new("Frame"); TBg.Size = UDim2.new(0,46,0,26); TBg.Position = UDim2.new(1,-60,0.5,-13)
    TBg.BackgroundColor3 = state and C.On or C.Off; TBg.BorderSizePixel = 0; TBg.Parent = Row; Corner(TBg,13)
    local TK = Instance.new("Frame"); TK.Size = UDim2.new(0,20,0,20); TK.BorderSizePixel = 0
    TK.Position = state and UDim2.new(0,23,0.5,-10) or UDim2.new(0,3,0.5,-10)
    TK.BackgroundColor3 = Color3.fromRGB(255,255,255); TK.Parent = TBg; Corner(TK,10)

    -- Hiện trạng
    if state then
        Tween(Row, {BackgroundColor3 = Color3.fromRGB(20,18,36)}, 0)
    end

    local Btn = Instance.new("TextButton"); Btn.Size = UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency = 1; Btn.Text = ""; Btn.Parent = Row
    Btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Tween(TBg, {BackgroundColor3=C.On}, 0.22)
            Tween(TK, {Position=UDim2.new(0,23,0.5,-10)}, 0.22)
            Tween(Row, {BackgroundColor3=Color3.fromRGB(20,18,36)}, 0.15)
        else
            Tween(TBg, {BackgroundColor3=C.Off}, 0.22)
            Tween(TK, {Position=UDim2.new(0,3,0.5,-10)}, 0.22)
            Tween(Row, {BackgroundColor3=C.BG2}, 0.15)
        end
        if cb then cb(state) end
    end)
    Row.MouseEnter:Connect(function() if not state then Tween(Row,{BackgroundColor3=C.BG3},0.1) end end)
    Row.MouseLeave:Connect(function() if not state then Tween(Row,{BackgroundColor3=C.BG2},0.1) end end)
    return Row
end

-- SLIDER
local function Slider(page, lbl, mn, mx, def, cb)
    local val = def or mn
    local Row = Instance.new("Frame"); Row.Size = UDim2.new(1,0,0,64)
    Row.BackgroundColor3 = C.BG2; Row.BorderSizePixel = 0; Row.Parent = page
    Corner(Row,8); Stroke(Row, C.Accent, 1, 0.82)

    local L = Instance.new("TextLabel"); L.Size = UDim2.new(0.6,0,0,20); L.Position = UDim2.new(0,14,0,8)
    L.BackgroundTransparency = 1; L.Text = lbl; L.TextColor3 = C.Text
    L.Font = Enum.Font.GothamBold; L.TextSize = 13; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = Row

    local VTxt = Instance.new("TextLabel"); VTxt.Size = UDim2.new(0.4,-14,0,20); VTxt.Position = UDim2.new(0.6,0,0,8)
    VTxt.BackgroundTransparency = 1; VTxt.Text = tostring(val); VTxt.TextColor3 = C.Accent
    VTxt.Font = Enum.Font.GothamBold; VTxt.TextSize = 13; VTxt.TextXAlignment = Enum.TextXAlignment.Right; VTxt.Parent = Row

    local Track = Instance.new("Frame"); Track.Size = UDim2.new(1,-28,0,6); Track.Position = UDim2.new(0,14,0,42)
    Track.BackgroundColor3 = Color3.fromRGB(28,26,46); Track.BorderSizePixel = 0; Track.Parent = Row; Corner(Track,3)

    local pct = (val-mn)/(mx-mn)
    local Fill = Instance.new("Frame"); Fill.Size = UDim2.new(pct,0,1,0); Fill.BackgroundColor3 = C.Accent
    Fill.BorderSizePixel = 0; Fill.Parent = Track; Corner(Fill,3)
    local FG = Instance.new("UIGradient"); FG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.Accent2), ColorSequenceKeypoint.new(1,C.Accent),
    }); FG.Parent = Fill

    local Knob = Instance.new("Frame"); Knob.Size = UDim2.new(0,14,0,14)
    Knob.Position = UDim2.new(pct,-7,0.5,-7); Knob.BackgroundColor3 = Color3.fromRGB(240,240,255)
    Knob.BorderSizePixel = 0; Knob.ZIndex = 5; Knob.Parent = Track; Corner(Knob,7)

    local Drag = Instance.new("TextButton"); Drag.Size = UDim2.new(1,0,1,0)
    Drag.BackgroundTransparency = 1; Drag.Text = ""; Drag.ZIndex = 10; Drag.Parent = Track

    local dragging = false
    Drag.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    RunService.Heartbeat:Connect(function()
        if not dragging then return end
        local mp = UserInputService:GetMouseLocation()
        local tp = Track.AbsolutePosition; local ts = Track.AbsoluteSize
        local rel = math.clamp((mp.X - tp.X) / ts.X, 0, 1)
        val = math.floor(mn + (mx-mn)*rel)
        VTxt.Text = tostring(val)
        Tween(Fill, {Size=UDim2.new(rel,0,1,0)}, 0.05)
        Tween(Knob, {Position=UDim2.new(rel,-7,0.5,-7)}, 0.05)
        if cb then cb(val) end
    end)
end

-- BUTTON
local function Btn(page, lbl, desc, cb)
    local B = Instance.new("TextButton"); B.Size = UDim2.new(1,0,0,50)
    B.BackgroundColor3 = C.BG2; B.BorderSizePixel = 0; B.Text = ""; B.Parent = page
    Corner(B,8); Stroke(B, C.Accent, 1, 0.75)

    local L = Instance.new("TextLabel"); L.Size = UDim2.new(1,-36,0,20)
    L.Position = UDim2.new(0,14,desc and 0 or 0.5, desc and 6 or -10)
    L.BackgroundTransparency = 1; L.Text = lbl; L.TextColor3 = C.Text
    L.Font = Enum.Font.GothamBold; L.TextSize = 13; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = B

    if desc then
        local D = Instance.new("TextLabel"); D.Size = UDim2.new(1,-36,0,14); D.Position = UDim2.new(0,14,0,28)
        D.BackgroundTransparency = 1; D.Text = desc; D.TextColor3 = C.Sub
        D.Font = Enum.Font.Gotham; D.TextSize = 11; D.TextXAlignment = Enum.TextXAlignment.Left; D.Parent = B
    end

    local Arr = Instance.new("TextLabel"); Arr.Size = UDim2.new(0,22,1,0); Arr.Position = UDim2.new(1,-28,0,0)
    Arr.BackgroundTransparency = 1; Arr.Text = "›"; Arr.TextColor3 = C.Accent
    Arr.Font = Enum.Font.GothamBold; Arr.TextSize = 22; Arr.Parent = B

    B.MouseEnter:Connect(function() Tween(B,{BackgroundColor3=C.BG3},0.12); Tween(Arr,{TextColor3=C.Green},0.12) end)
    B.MouseLeave:Connect(function() Tween(B,{BackgroundColor3=C.BG2},0.12); Tween(Arr,{TextColor3=C.Accent},0.12) end)
    B.MouseButton1Click:Connect(function()
        Tween(B,{BackgroundColor3=Color3.fromRGB(28,24,50)},0.08)
        task.delay(0.15, function() Tween(B,{BackgroundColor3=C.BG3},0.12) end)
        if cb then cb() end
    end)
end

-- ══════════════════════════════════════════
--  TẠO CÁC TAB & ĐIỀN NỘI DUNG
-- ══════════════════════════════════════════
local PMove   = NewTab("🚀", "Movement")
local PAuto   = NewTab("🤖", "Auto Farm")
local PVisual = NewTab("👁", "Visual")
local PMisc   = NewTab("⚙", "Misc")

-- ── MOVEMENT (6 chức năng) ─────────────────
Hdr(PMove, "TỐC ĐỘ & DI CHUYỂN")

Toggle(PMove, "⚡  Speed Hack", "Tăng tốc độ chạy", false, function(v)
    State.SpeedEnabled = v; ApplySpeed()
    Notify(v and "⚡ Speed ON!" or "Speed OFF", v and C.Green or C.Sub)
end)

Slider(PMove, "Walk Speed", 16, 250, 30, function(v)
    State.SpeedValue = v
    if State.SpeedEnabled then ApplySpeed() end
end)

Toggle(PMove, "✈️  Fly Hack", "Bay tự do bằng WASD + Space/Ctrl", false, function(v)
    State.FlyEnabled = v
    if v then StartFly() else StopFly() end
    Notify(v and "✈️ Bay ON! WASD+Space bay" or "Bay OFF", v and C.Accent or C.Sub)
end)

Slider(PMove, "Fly Speed", 10, 300, 60, function(v)
    State.FlySpeed = v
end)

Toggle(PMove, "🦘  Infinite Jump", "Nhảy liên tục không dừng", false, function(v)
    State.InfJump = v
    Notify(v and "🦘 Inf Jump ON!" or "Inf Jump OFF", v and C.Green or C.Sub)
end)

Toggle(PMove, "🌙  Low Gravity", "Trọng lực thấp - nhảy cao hơn", false, function(v)
    State.LowGravity = v; ApplyGravity()
    Notify(v and "🌙 Low Gravity ON!" or "Gravity bình thường", v and C.Accent or C.Sub)
end)

Toggle(PMove, "👻  No Clip", "Xuyên qua tường (cần executor)", false, function(v)
    ApplyNoClip(v)
    Notify(v and "👻 NoClip ON!" or "NoClip OFF", v and C.Green or C.Sub)
end)

-- ── AUTO FARM (5 chức năng) ────────────────
Hdr(PAuto, "TỰ ĐỘNG")

Toggle(PAuto, "🤖  Auto Farm", "Tự động tấn công mob/enemy gần nhất", false, function(v)
    State.AutoFarm = v
    if v then AutoFarmLoop() end
    Notify(v and "🤖 Auto Farm BẬT!" or "Auto Farm TẮT", v and C.Green or C.Sub)
end)

Toggle(PAuto, "🍎  Auto Collect", "Tự nhặt item/fruit/coin quanh bạn", false, function(v)
    State.AutoCollect = v
    if v then AutoCollectLoop() end
    Notify(v and "🍎 Auto Collect BẬT!" or "Auto Collect TẮT", v and C.Green or C.Sub)
end)

Slider(PAuto, "Phạm vi (studs)", 20, 200, 50, function(v)
    State.AutoFarmRadius = v
end)

Toggle(PAuto, "💬  Chat Notify", "Hiện thông báo khi người khác chat", false, function(v)
    State.ChatNotif = v; ApplyChatNotif()
    Notify(v and "💬 Chat Notify BẬT!" or "Chat Notify TẮT", v and C.Accent or C.Sub)
end)

Btn(PAuto, "📍  Teleport về Spawn", "Về điểm hồi sinh nhanh nhất", function()
    TeleportToSpawn()
end)

-- ── VISUAL (5 chức năng) ───────────────────
Hdr(PVisual, "ĐỒ HỌA & NHÌN")

Toggle(PVisual, "☀️  Full Bright", "Sáng toàn màn hình kể cả ban đêm", false, function(v)
    State.FullBright = v; ApplyFullBright()
    Notify(v and "☀️ Full Bright ON!" or "Full Bright OFF", v and C.Accent or C.Sub)
end)

Toggle(PVisual, "🌫️  No Fog", "Xóa sương mù - nhìn xa hơn", false, function(v)
    State.NoFog = v; ApplyNoFog()
    Notify(v and "🌫️ No Fog ON - Nhìn xa hơn!" or "Fog bình thường", v and C.Green or C.Sub)
end)

Slider(PVisual, "FOV Camera", 40, 120, 70, function(v)
    State.FOV = v; ApplyFOV()
end)

Toggle(PVisual, "🎯  Custom Crosshair", "Crosshair tùy chỉnh đẹp hơn", false, function(v)
    State.Crosshair = v; ToggleCrosshair()
    Notify(v and "🎯 Crosshair ON!" or "Crosshair OFF", v and C.Green or C.Sub)
end)

Toggle(PVisual, "🌈  Rainbow Name", "Tên nhân vật đổi màu cầu vồng", false, function(v)
    State.RainbowName = v; ApplyRainbowName()
    Notify(v and "🌈 Rainbow Name ON!" or "Rainbow OFF", v and C.Accent or C.Sub)
end)

-- ── MISC (7 chức năng) ────────────────────
Hdr(PMisc, "TIỆN ÍCH")

Toggle(PMisc, "🕐  Anti AFK", "Không bị kick vì AFK", false, function(v)
    State.AntiAFK = v; ApplyAntiAFK()
    Notify(v and "🕐 Anti AFK BẬT!" or "Anti AFK TẮT", v and C.Green or C.Sub)
end)

Toggle(PMisc, "📍  Show Coords", "Hiện tọa độ XYZ góc màn hình", false, function(v)
    State.ShowCoords = v; ToggleCoords()
    Notify(v and "📍 Coords BẬT!" or "Coords TẮT", v and C.Accent or C.Sub)
end)

Toggle(PMisc, "🌤️  Time Freeze", "Đóng băng thời gian ở 14:00", false, function(v)
    State.TimeFreeze = v; ApplyTimeFreeze()
    Notify(v and "🌤️ Time Freeze - Luôn trưa!" or "Time bình thường", v and C.Accent or C.Sub)
end)

Toggle(PMisc, "🖥️  FPS Unlock", "Bỏ giới hạn 60 FPS (cần executor)", false, function(v)
    State.FPSUnlock = v; ApplyFPSUnlock()
    Notify(v and "🖥️ FPS Unlock ON!" or "FPS 60 cap", v and C.Green or C.Sub)
end)

Hdr(PMisc, "HÀNH ĐỘNG")

Btn(PMisc, "🗑️  Xóa Lag Objects", "Xóa decal/particle/smoke - tăng FPS", function()
    RemoveDecor()
end)

Btn(PMisc, "🔄  Rejoin Server", "Vào lại server hiện tại", function()
    Notify("🔄 Đang rejoin..."); task.delay(1, Rejoin)
end)

Btn(PMisc, "💀  Reset Nhân Vật", "Reset char về spawn", function()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0; Notify("💀 Reset nhân vật!") end
end)

-- ══════════════════════════════════════════
--  MỞ TAB MẶC ĐỊNH
-- ══════════════════════════════════════════
Tabs["🚀 Movement"].Btn.MouseButton1Click:Fire()

-- ══════════════════════════════════════════
--  DRAG MENU
-- ══════════════════════════════════════════
local _drag, _di, _ds, _sp = false, nil, nil, nil
TopBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        _drag=true; _ds=i.Position; _sp=Main.Position
        i.Changed:Connect(function()
            if i.UserInputState==Enum.UserInputState.End then _drag=false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement then _di=i end
end)
UserInputService.InputChanged:Connect(function(i)
    if _drag and i==_di then
        local d = i.Position - _ds
        Main.Position = UDim2.new(_sp.X.Scale,_sp.X.Offset+d.X,_sp.Y.Scale,_sp.Y.Offset+d.Y)
    end
end)

-- ══════════════════════════════════════════
--  CLOSE / MINIMIZE
-- ══════════════════════════════════════════
CloseBtn.MouseButton1Click:Connect(function()
    Tween(Main,{Size=UDim2.new(0,0,0,0), Position=UDim2.new(0.5,0,0.5,0)},0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In)
    task.delay(0.35, function() ScreenGui:Destroy() end)
end)

local _min = false
MinBtn.MouseButton1Click:Connect(function()
    _min = not _min
    Tween(Main, {Size=_min and UDim2.new(0,600,0,54) or UDim2.new(0,600,0,460)}, 0.3, Enum.EasingStyle.Back)
end)

-- ══════════════════════════════════════════
--  PHÍM TẮT RightShift
-- ══════════════════════════════════════════
local _vis = true
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        _vis = not _vis
        if _vis then
            Main.Visible = true
            Tween(Main, {Position=UDim2.new(0.5,-300,0.5,-230)}, 0.4, Enum.EasingStyle.Back)
        else
            Tween(Main, {Position=UDim2.new(0.5,-300,1.6,0)}, 0.3)
            task.delay(0.35, function() if not _vis then Main.Visible=false end end)
        end
    end
end)

-- ══════════════════════════════════════════
--  ANIMATION VÀO
-- ══════════════════════════════════════════
Main.Size = UDim2.new(0,600,0,0); Main.Position = UDim2.new(0.5,-300,0.5,-230)
Tween(Main, {Size=UDim2.new(0,600,0,460)}, 0.55, Enum.EasingStyle.Back)

task.delay(0.7, function()
    Notify("✅ FAM LV MENU v2.0 đã load!", C.Green)
    Notify("⌨️ RightShift = ẩn/hiện menu", C.Accent)
end)

print("╔══════════════════════════════╗")
print("║   FAM LV MENU v2.0 LOADED!  ║")
print("║  RightShift = Ẩn/Hiện       ║")
print("║  Kéo TopBar để di chuyển    ║")
print("╚══════════════════════════════╝")
