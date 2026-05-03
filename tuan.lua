-- ╔═══════════════════════════════════════════════════════════════╗
-- ║        FAM LV MENU V4.0 - PHIÊN BẢN SIÊU GỌN (LITE)           ║
-- ║            AUTO NHẶT RƯƠNG + ĐÓNG/MỞ CỰC NHANH                ║
-- ╚═══════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- ══════════════════════════════════════════
-- CẤU HÌNH & TRẠNG THÁI
-- ══════════════════════════════════════════
local Theme = {
    Main = Color3.fromRGB(15, 15, 20),
    Accent = Color3.fromRGB(255, 50, 50), -- Màu đỏ chiến thần
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(25, 25, 30)
}

local State = {
    Speed = 50, SpeedOn = false,
    Fly = 80, FlyOn = false,
    AutoChest = false, AutoFarm = false,
    InfJump = false, Noclip = false
}

-- ══════════════════════════════════════════
-- HÀM LOGIC (NHẶT RƯƠNG & BAY)
-- ══════════════════════════════════════════
local function Notify(txt)
    print("[FAM LV]: " .. txt)
end

-- Auto Nhặt Rương (Dò tìm vật phẩm có tên "Chest" hoặc "Rương")
task.spawn(function()
    while task.wait(0.5) do
        if State.AutoChest and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("chest") or v.Name:lower():find("rương")) then
                    if State.AutoChest then
                        LP.Character.HumanoidRootPart.CFrame = v.CFrame
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end)

-- ══════════════════════════════════════════
-- GIAO DIỆN SIÊU GỌN
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui", LP.PlayerGui)
ScreenGui.Name = "FamLV_V4"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 320)
Main.Position = UDim2.new(0.5, -225, 0.5, -160)
Main.BackgroundColor3 = Theme.Main
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Theme.Accent

-- Thanh Tiêu Đề
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Theme.Secondary
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel", Header)
Title.Text = "🔥 FAM LV V4.0 LITE"; Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.TextColor3 = Theme.Accent; Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

-- Nút Đóng (X)
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Text = "X"; CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Theme.Accent; CloseBtn.TextColor3 = Theme.Text; CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Khu vực chức năng (Scrolling)
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -60); Scroll.Position = UDim2.new(0, 10, 0, 50)
Scroll.BackgroundTransparency = 1; Scroll.CanvasSize = UDim2.new(0, 0, 2, 0); Scroll.ScrollBarThickness = 2

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8); Layout.HorizontalAlignment = 1

-- ══════════════════════════════════════════
-- WIDGET TẠO NÚT
-- ══════════════════════════════════════════
local function AddToggle(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 40); btn.BackgroundColor3 = Theme.Secondary
    btn.Text = name .. " : OFF"; btn.TextColor3 = Theme.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 13
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and " : ON" or " : OFF")
        btn.TextColor3 = active and Theme.Accent or Theme.Text
        callback(active)
    end)
end

-- ══════════════════════════════════════════
-- DANH SÁCH CHỨC NĂNG (BẢN HACK THẬT)
-- ══════════════════════════════════════════

-- 1. Auto Nhặt Rương
AddToggle("💰 AUTO NHẶT RƯƠNG", function(v) State.AutoChest = v end)

-- 2. Tốc độ chạy
AddToggle("⚡ TỐC ĐỘ (SPEED)", function(v) 
    State.SpeedOn = v
    RunService.Stepped:Connect(function()
        if State.SpeedOn and LP.Character and LP.Character:FindFirstChild("Humanoid") then
            LP.Character.Humanoid.WalkSpeed = 100
        else
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed = 16 end
        end
    end)
end)

-- 3. Bay tự do
AddToggle("🕊️ BAY (FLY)", function(v)
    State.FlyOn = v
    if v then
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Name = "FamFly"
        task.spawn(function()
            while State.FlyOn do
                bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

-- 4. Nhảy vô hạn
AddToggle("🦘 NHẢY VÔ HẠN", function(v) State.InfJump = v end)
UserInputService.JumpRequest:Connect(function()
    if State.InfJump then LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- 5. Xuyên tường
AddToggle("👻 XUYÊN TƯỜNG", function(v)
    State.Noclip = v
    RunService.Stepped:Connect(function()
        if State.Noclip and LP.Character then
            for _, p in pairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

-- 6. Full Sáng
AddToggle("💡 FULL SÁNG", function(v) game:GetService("Lighting").Brightness = v and 2 or 1 end)

-- 7. Reset Nhân Vật
local ResBtn = Instance.new("TextButton", Scroll)
ResBtn.Size = UDim2.new(0.95, 0, 0, 40); ResBtn.Text = "💀 RESET NHÂN VẬT"; ResBtn.BackgroundColor3 = Color3.fromRGB(50,0,0)
ResBtn.TextColor3 = Theme.Text; Instance.new("UICorner", ResBtn)
ResBtn.MouseButton1Click:Connect(function() LP.Character:BreakJoints() end)

-- ══════════════════════════════════════════
-- ĐIỀU KHIỂN MENU
-- ══════════════════════════════════════════

-- Kéo thả menu (Drag)
local dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = i.Position; startPos = Main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragStart = nil end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Ẩn/Hiện bằng phím RightShift
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

Notify("Bản V4.0 LITE đã sẵn sàng! Nhấn RightShift để ẩn/hiện.")
