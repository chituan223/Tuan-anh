-- ╔══════════════════════════════════════════════════╗
-- ║        FAM LV MENU V5.0 PRO - ULTIMATE           ║
-- ║    Giao diện: Gold Luxury | Mode: Real Hack      ║
-- ║    Phím tắt: RightShift | Tính năng: Minimize    ║
-- ╚══════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Cấu hình màu sắc VIP
local Theme = {
    Main = Color3.fromRGB(15, 15, 25),
    Accent = Color3.fromRGB(255, 215, 0), -- Gold
    Text = Color3.fromRGB(255, 255, 255),
    Dark = Color3.fromRGB(10, 10, 15),
    Green = Color3.fromRGB(0, 255, 127)
}

-- ══════════════════════════════════════
--             HỆ THỐNG UI GỐC
-- ══════════════════════════════════════
local SG = Instance.new("ScreenGui")
SG.Name = "FamLV_Pro_V5"
SG.IgnoreGuiInset = true
SG.ResetOnSpawn = false
SG.Parent = LP:WaitForChild("PlayerGui")

-- Nút Thu Nhỏ (Minimize Icon) - LUÔN TỒN TẠI
local MiniBtn = Instance.new("TextButton")
MiniBtn.Name = "FamMiniIcon"
MiniBtn.Size = UDim2.new(0, 50, 0, 50)
MiniBtn.Position = UDim2.new(0, 20, 0.5, -25)
MiniBtn.BackgroundColor3 = Theme.Main
MiniBtn.Text = "FAM"
MiniBtn.TextColor3 = Theme.Accent
MiniBtn.Font = Enum.Font.GothamBlack
MiniBtn.TextSize = 14
MiniBtn.Visible = false -- Chỉ hiện khi menu đóng
MiniBtn.Parent = SG
local mc = Instance.new("UICorner", MiniBtn); mc.CornerRadius = UDim.new(1, 0)
local ms = Instance.new("UIStroke", MiniBtn); ms.Color = Theme.Accent; ms.Thickness = 2

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Main
MainFrame.BorderSizePixel = 0
MainFrame.Parent = SG
local rc = Instance.new("UICorner", MainFrame); rc.CornerRadius = UDim.new(0, 12)
local rs = Instance.new("UIStroke", MainFrame); rs.Color = Theme.Accent; rs.Thickness = 1.5

-- Sidebar & Content
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Theme.Dark
Sidebar.Parent = MainFrame

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -170, 1, -60)
Container.Position = UDim2.new(0, 165, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.CanvasSize = UDim2.new(0,0,2.5,0) -- Đủ chỗ cho 20+ chức năng
Container.Parent = MainFrame
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)
Instance.new("UIPadding", Container).PaddingLeft = UDim.new(0,5)

-- Tiêu đề
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Text = "FAM LV MENU V5.0 PRO EDITION"
Header.Font = Enum.Font.GothamBlack
Header.TextColor3 = Theme.Accent
Header.TextSize = 20
Header.BackgroundColor3 = Theme.Dark
Header.Parent = MainFrame

-- ══════════════════════════════════════
--           HÀM TẠO CHỨC NĂNG
-- ══════════════════════════════════════
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Theme.Text
    btn.TextSize = 12
    btn.Parent = Container
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

local function CreateToggle(text, def, callback)
    local state = def
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = Container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Text = "  " .. text
    label.TextColor3 = Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamMedium
    label.BackgroundTransparency = 1
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -45, 0.5, -10)
    btn.BackgroundColor3 = state and Theme.Green or Color3.fromRGB(60, 60, 60)
    btn.Text = ""
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Theme.Green or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

-- ══════════════════════════════════════
--          CÁC CHỨC NĂNG HACK THẬT
-- ══════════════════════════════════════

-- 1. Kill Aura (Quét Magnitude thực tế)
CreateToggle("⚔️ Kill Aura (Radius 30)", false, function(v)
    _G.KillAura = v
    task.spawn(function()
        while _G.KillAura do
            for _, enemy in pairs(Workspace:GetDescendants()) do
                if enemy:IsA("Humanoid") and enemy.Parent ~= LP.Character and enemy.Health > 0 then
                    local root = enemy.Parent:FindFirstChild("HumanoidRootPart")
                    if root and (root.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 30 then
                        pcall(function()
                            local tool = LP.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- 2. Speed Hack (Tác động thẳng WalkSpeed)
CreateButton("⚡ Speed Hack (80)", function()
    LP.Character.Humanoid.WalkSpeed = 80
end)

-- 3. Jump Power
CreateButton("🚀 Jump Power (100)", function()
    LP.Character.Humanoid.JumpPower = 100
end)

-- 4. Fly Mode (Sử dụng BodyVelocity)
CreateToggle("✈️ Real Fly Mode", false, function(v)
    if v then
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bv.Name = "FamFlyV5"
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        task.spawn(function()
            while v and LP.Character:FindFirstChild("HumanoidRootPart") do
                bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- 5. No Clip (Can thiệp Stepped)
CreateToggle("👻 No Clip (Xuyên Tường)", false, function(v)
    _G.Noclip = v
    RunService.Stepped:Connect(function()
        if _G.Noclip then
            for _, p in pairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

-- 6. ESP Box
CreateToggle("🔳 ESP Box (Show Players)", false, function(v)
    _G.ESP = v
    while _G.ESP do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character.HumanoidRootPart:FindFirstChild("Box") then
                    local b = Instance.new("BoxHandleAdornment", p.Character.HumanoidRootPart)
                    b.Name = "Box"; b.Size = Vector3.new(4, 6, 1); b.AlwaysOnTop = true; b.ZIndex = 5
                    b.Transparency = 0.5; b.Color3 = Theme.Accent; b.Adornee = p.Character.HumanoidRootPart
                end
            end
        end
        task.wait(1)
        if not _G.ESP then
            for _, p in pairs(Players:GetPlayers()) do
                pcall(function() p.Character.HumanoidRootPart.Box:Destroy() end)
            end
        end
    end
end)

-- 7. Infinite Jump
_G.InfJump = true
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump then LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
CreateToggle("🦘 Infinite Jump", true, function(v) _G.InfJump = v end)

-- 8. Auto Clicker
CreateToggle("🖱️ Auto Clicker (Fast)", false, function(v)
    _G.Click = v
    task.spawn(function()
        while _G.Click do
            local t = LP.Character:FindFirstChildOfClass("Tool")
            if t then t:Activate() end
            task.wait(0.01)
        end
    end)
end)

-- 9. Full Bright
CreateButton("☀️ Full Bright", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
end)

-- 10. Auto Farm Level (Dạng cơ bản - Cần chỉnh theo game)
CreateToggle("🚜 Auto Farm Level (Basic)", false, function(v)
    _G.AutoFarm = v
    notify("Auto Farm: " .. tostring(v))
end)

-- 11. Bypassing Anti-Cheat (Simple)
CreateButton("🛡️ Bypass Basic Detection", function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and self.Name == "RemoteEvent_Check" then
            return nil
        end
        return old(self, ...)
    end)
end)

-- 12-20: Các chức năng bổ sung khác
CreateButton("🏰 Teleport to SafeZone", function() LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0) end)
CreateButton("🌊 No Shadows", function() Lighting.GlobalShadows = false end)
CreateButton("🌫️ Anti-Fog", function() Lighting.FogEnd = 9e9 end)
CreateButton("🔄 Reset Character", function() LP.Character.Humanoid.Health = 0 end)
CreateButton("👀 Low Graphics", function() for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end end end)
CreateButton("🎮 Fix Lag UI", function() SG.Enabled = not SG.Enabled; task.wait(0.1); SG.Enabled = true end)
CreateButton("🎭 Invisible Mode (Client)", function() for _,v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = 0.5 end end end)
CreateButton("🧪 Gravity 50 (Moon)", function() Workspace.Gravity = 50 end)
CreateButton("🧪 Gravity Normal", function() Workspace.Gravity = 196.2 end)

-- ══════════════════════════════════════
--         HỆ THỐNG ĐIỀU KHIỂN MENU
-- ══════════════════════════════════════

-- Hàm Thu Nhỏ / Mở Lại (Minimize)
local function ToggleMenu()
    if MainFrame.Visible then
        -- Thu nhỏ
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        MiniBtn.Visible = true
    else
        -- Mở lại
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0,0,0,0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 420)}):Play()
        MiniBtn.Visible = false
    end
end

-- Click vào icon "FAM" để hiện lại
MiniBtn.MouseButton1Click:Connect(ToggleMenu)

-- Phím tắt RightShift để đóng/mở nhanh
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        ToggleMenu()
    end
end)

-- Kéo thả Menu (Draggable)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Thông báo khởi động
local function notify(txt)
    print("[FAM V5 PRO]: " .. txt)
end
notify("LOADED SUCCESSFULLY!")
