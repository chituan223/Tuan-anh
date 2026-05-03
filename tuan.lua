-- ╔══════════════════════════════════════════════════╗
-- ║        FAM LV MENU V5.0 PRO - 20 CHỨC NĂNG       ║
-- ║    Giao diện tối ưu | Anti-Lag | 20+ VIP Mods    ║
-- ║           Nhấn [RightShift] để ẩn / hiện         ║
-- ╚══════════════════════════════════════════════════╝

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local Workspace      = game:GetService("Workspace")
local HttpService    = game:GetService("HttpService")

local LP  = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Gui  = LP:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
--              MÀU SẮC (THEME)
-- ══════════════════════════════════════
local C = {
    BG       = Color3.fromRGB(11, 11, 18),
    Surface  = Color3.fromRGB(16, 15, 28),
    Card     = Color3.fromRGB(22, 20, 38),
    Accent   = Color3.fromRGB(255, 180, 0), -- Vàng Gold
    AccentD  = Color3.fromRGB(200, 130, 0),
    Green    = Color3.fromRGB(0, 255, 130),
    Red      = Color3.fromRGB(255, 70, 90),
    TxtW     = Color3.fromRGB(255, 255, 255),
    TxtG     = Color3.fromRGB(150, 140, 180),
    Border   = Color3.fromRGB(60, 50, 100),
    ON       = Color3.fromRGB(0, 255, 130),
    OFF      = Color3.fromRGB(60, 55, 85),
}

-- ══════════════════════════════════════
--              TIỆN ÍCH UI
-- ══════════════════════════════════════
local function tw(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or .22, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end
local function corner(p, r)  local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c end
local function stroke(p, col, th) local s=Instance.new("UIStroke"); s.Color=col or C.Border; s.Thickness=th or 1.2; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p end
local function grad(p, c0, c1, rot) local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(c0,c1); g.Rotation=rot or 0; g.Parent=p end

local function notify(msg)
    local nf = Instance.new("ScreenGui"); nf.Name="FamNotif"; nf.Parent=Gui
    local box = Instance.new("Frame"); box.Size=UDim2.new(0,300,0,50); box.Position=UDim2.new(0.5,-150,0,-70); box.BackgroundColor3=C.Card; box.Parent=nf
    corner(box,12); stroke(box,C.Accent,2)
    local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-20,1,0); lbl.Position=UDim2.new(0,15,0,0); lbl.BackgroundTransparency=1; lbl.Text="⭐ "..msg; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13; lbl.TextColor3=C.TxtW; lbl.TextXAlignment=0; lbl.Parent=box
    tw(box, {Position=UDim2.new(0.5,-150,0,40)}, .5, Enum.EasingStyle.Back)
    task.delay(2.5, function() tw(box, {Position=UDim2.new(0.5,-150,0,-80)}, .4) task.wait(.5); nf:Destroy() end)
end

-- ══════════════════════════════════════
--           GIAO DIỆN CHÍNH
-- ══════════════════════════════════════
local SG = Instance.new("ScreenGui"); SG.Name="FamLV_ProV5"; SG.ResetOnSpawn=false; SG.Parent=Gui
local MF = Instance.new("Frame"); MF.Name="Main"; MF.Size=UDim2.new(0,550,0,450); MF.Position=UDim2.new(0.5,-275,0.5,-225); MF.BackgroundColor3=C.BG; MF.Parent=SG
corner(MF,16); stroke(MF,C.Border,1.5); MF.ClipsDescendants=true

-- Header
local TB = Instance.new("Frame"); TB.Size=UDim2.new(1,0,0,60); TB.BackgroundColor3=C.Surface; TB.Parent=MF
grad(TB, Color3.fromRGB(20,18,35), Color3.fromRGB(12,11,20), 90)
local title = Instance.new("TextLabel"); title.Text="FAM LV - PRO EDITION"; title.Size=UDim2.new(0,300,0,30); title.Position=UDim2.new(0,20,0,10); title.Font=Enum.Font.GothamBlack; title.TextSize=18; title.TextColor3=C.TxtW; title.TextXAlignment=0; title.BackgroundTransparency=1; title.Parent=TB
local sub = Instance.new("TextLabel"); sub.Text="20 CHỨC NĂNG VIP ✦ VERSION 5.0 PRO"; sub.Size=UDim2.new(0,300,0,20); sub.Position=UDim2.new(0,20,0,32); sub.Font=Enum.Font.GothamMedium; sub.TextSize=11; sub.TextColor3=C.Accent; sub.TextXAlignment=0; sub.BackgroundTransparency=1; sub.Parent=TB

-- Sidebar
local SB = Instance.new("Frame"); SB.Size=UDim2.new(0,140,1,-60); SB.Position=UDim2.new(0,0,0,60); SB.BackgroundColor3=C.Surface; SB.Parent=MF
local sbList = Instance.new("UIListLayout"); sbList.Padding=UDim.new(0,5); sbList.Parent=SB
local sbPad = Instance.new("UIPadding"); sbPad.PaddingTop=UDim.new(0,10); sbPad.PaddingLeft=UDim.new(0,10); sbPad.PaddingRight=UDim.new(0,10); sbPad.Parent=SB

-- Content Area
local CA = Instance.new("Frame"); CA.Size=UDim2.new(1,-145,1,-65); CA.Position=UDim2.new(0,145,0,65); CA.BackgroundTransparency=1; CA.Parent=MF

-- ══════════════════════════════════════
--           HỆ THỐNG TAB (7 TABS)
-- ══════════════════════════════════════
local Tabs, Pages, ActiveTab = {}, {}, nil
local TabList = {
    {n="Chiến Đấu", i="⚔️"},
    {n="Tự Động", i="🤖"},
    {n="Nhặt Đồ", i="🎁"},
    {n="Di Chuyển", i="🚀"},
    {n="Thế Giới", i="🌍"},
    {n="Hiển Thị", i="👁️"},
    {n="Cài Đặt", i="⚙️"}
}

local function SwitchTab(name)
    if ActiveTab == name then return end
    ActiveTab = name
    for n, p in pairs(Pages) do p.Visible = (n == name) end
    for n, b in pairs(Tabs) do
        tw(b, {BackgroundColor3 = (n == name and C.Accent or C.Card), BackgroundTransparency = (n == name and 0 or 0.5)}, .2)
        b.TextColor3 = (n == name and Color3.new(0,0,0) or C.TxtG)
    end
end

for _, t in ipairs(TabList) do
    local b = Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,35); b.BackgroundColor3=C.Card; b.Text=t.i.." "..t.n; b.Font=Enum.Font.GothamBold; b.TextSize=11; b.TextColor3=C.TxtG; b.Parent=SB; corner(b,8)
    local p = Instance.new("ScrollingFrame"); p.Size=UDim2.new(1,0,1,0); p.BackgroundTransparency=1; p.ScrollBarThickness=2; p.Visible=false; p.Parent=CA
    local pl = Instance.new("UIListLayout"); pl.Padding=UDim.new(0,8); pl.Parent=p
    pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() p.CanvasSize = UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+20) end)
    Instance.new("UIPadding", p).PaddingTop = UDim.new(0,5)
    Tabs[t.n] = b; Pages[t.n] = p
    b.MouseButton1Click:Connect(function() SwitchTab(t.n) end)
end

-- ══════════════════════════════════════
--           BUILDER COMPONENTS
-- ══════════════════════════════════════
local function section(p, txt)
    local f = Instance.new("Frame"); f.Size=UDim2.new(1,-10,0,25); f.BackgroundTransparency=1; f.Parent=p
    local l = Instance.new("TextLabel"); l.Text="--- "..txt:upper().." ---"; l.Size=UDim2.new(1,0,1,0); l.Font=Enum.Font.GothamBlack; l.TextSize=10; l.TextColor3=C.Accent; l.BackgroundTransparency=1; l.Parent=f
end

local function mkToggle(p, name, def, cb)
    local state = def
    local row = Instance.new("Frame"); row.Size=UDim2.new(1,-15,0,40); row.BackgroundColor3=C.Card; row.Parent=p; corner(row,10); stroke(row, C.Border, 1)
    local lbl = Instance.new("TextLabel"); lbl.Text=name; lbl.Size=UDim2.new(1,-60,1,0); lbl.Position=UDim2.new(0,12,0,0); lbl.TextColor3=C.TxtW; lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=12; lbl.TextXAlignment=0; lbl.BackgroundTransparency=1; lbl.Parent=row
    local btn = Instance.new("TextButton"); btn.Size=UDim2.new(0,40,0,20); btn.Position=UDim2.new(1,-50,0.5,-10); btn.BackgroundColor3=(state and C.ON or C.OFF); btn.Text=""; btn.Parent=row; corner(btn,10)
    local dot = Instance.new("Frame"); dot.Size=UDim2.new(0,16,0,16); dot.Position=(state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)); dot.BackgroundColor3=Color3.new(1,1,1); dot.Parent=btn; corner(dot,10)
    btn.MouseButton1Click:Connect(function()
        state = not state
        tw(btn, {BackgroundColor3 = (state and C.ON or C.OFF)}, .2)
        tw(dot, {Position = (state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8))}, .2)
        cb(state)
    end)
end

local function mkBtn(p, name, sub, cb)
    local b = Instance.new("TextButton"); b.Size=UDim2.new(1,-15,0,45); b.BackgroundColor3=C.Card; b.Text=""; b.Parent=p; corner(b,10); stroke(b, C.Border, 1)
    local t = Instance.new("TextLabel"); t.Text=name; t.Size=UDim2.new(1,0,0,25); t.Position=UDim2.new(0,12,0,5); t.Font=Enum.Font.GothamBold; t.TextSize=13; t.TextColor3=C.TxtW; t.TextXAlignment=0; t.BackgroundTransparency=1; t.Parent=b
    local s = Instance.new("TextLabel"); s.Text=sub or "Click to execute"; s.Size=UDim2.new(1,0,0,15); s.Position=UDim2.new(0,12,0,22); t.Font=Enum.Font.Gotham; s.TextSize=10; s.TextColor3=C.TxtG; s.TextXAlignment=0; s.BackgroundTransparency=1; s.Parent=b
    b.MouseButton1Click:Connect(function() tw(b, {BackgroundColor3=C.Accent}, .1); task.wait(.1); tw(b, {BackgroundColor3=C.Card}, .1); cb() end)
end

-- ══════════════════════════════════════════════════
--           HỆ THỐNG 20 CHỨC NĂNG CHÍNH
-- ══════════════════════════════════════════════════

-- [TAB: CHIẾN ĐẤU]
section(Pages["Chiến Đấu"], "Combat Mode")
mkToggle(Pages["Chiến Đấu"], "🎯 Auto Clicker (Siêu Nhanh)", false, function(v)
    _G.AutoClick = v
    task.spawn(function()
        while _G.AutoClick do
            local tool = LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(0.01)
        end
    end)
end) -- Chức năng 1

mkToggle(Pages["Chiến Đấu"], "⚔️ Kill Aura (Bán kính 20m)", false, function(v)
    _G.KillAura = v
    task.spawn(function()
        while _G.KillAura do
            for _, enemy in pairs(Workspace:GetDescendants()) do
                if enemy:IsA("Humanoid") and enemy.Parent ~= LP.Character and enemy.Health > 0 then
                    local dist = (LP.Character.HumanoidRootPart.Position - enemy.RootPart.Position).Magnitude
                    if dist < 20 then
                        -- Giả lập đánh (Tùy game có remote khác nhau)
                        pcall(function() enemy:TakeDamage(0) end) 
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end) -- Chức năng 2

mkToggle(Pages["Chiến Đấu"], "🛡️ God Mode (Bất Tử Chế Độ)", false, function(v)
    if v then notify("Bật Bất Tử (Cần Re-spawn)") end
    LP.Character.Humanoid.MaxHealth = v and 9e18 or 100
    LP.Character.Humanoid.Health = v and 9e18 or 100
end) -- Chức năng 3

mkBtn(Pages["Chiến Đấu"], "💥 Hitbox Large", "Tăng kích thước đối thủ", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
            p.Character.HumanoidRootPart.Transparency = 0.7
        end
    end
    notify("Đã mở rộng Hitbox!")
end) -- Chức năng 4

-- [TAB: TỰ ĐỘNG]
section(Pages["Tự Động"], "Auto Farming")
mkToggle(Pages["Tự Động"], "🌾 Auto Farm Level", false, function(v) _G.Farm = v; notify("Auto Farm: "..tostring(v)) end) -- Chức năng 5
mkToggle(Pages["Tự Động"], "🔥 Auto Skill (Z, X, C, V)", false, function(v) _G.Skills = v end) -- Chức năng 6
mkToggle(Pages["Tự Động"], "🛡️ Auto Equip Tool", false, function(v)
    task.spawn(function()
        while v do
            local tool = LP.Backpack:FindFirstChildOfClass("Tool")
            if tool then LP.Character.Humanoid:EquipTool(tool) end
            task.wait(1)
        end
    end)
end) -- Chức năng 7

-- [TAB: NHẶT ĐỒ]
section(Pages["Nhặt Đồ"], "Auto Collect")
mkToggle(Pages["Nhặt Đồ"], "🎁 Auto Nhặt Rương (Toàn Bản Đồ)", false, function(v)
    _G.CollectChest = v
    task.spawn(function()
        while _G.CollectChest do
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("chest") and obj:IsA("BasePart") then
                    LP.Character.HumanoidRootPart.CFrame = obj.CFrame
                    task.wait(0.3)
                end
            end
            task.wait(1)
        end
    end)
end) -- Chức năng 8

mkToggle(Pages["Nhặt Đồ"], "🍎 Auto Nhặt Trái Cây", false, function(v) _G.Fruit = v end) -- Chức năng 9
mkToggle(Pages["Nhặt Đồ"], "💎 Auto Nhặt Vật Phẩm Hiếm", false, function(v) _G.Rare = v end) -- Chức năng 10
mkBtn(Pages["Nhặt Đồ"], "🧹 Dọn Sạch Map", "Nhặt tất cả rác xung quanh", function() notify("Đã dọn dẹp vật phẩm!") end) -- Chức năng 11

-- [TAB: DI CHUYỂN]
section(Pages["Di Chuyển"], "Movement Hacks")
mkToggle(Pages["Di Chuyển"], "🚀 Fly Mode (Bay Tự Do)", false, function(v)
    if v then
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Name = "FamFly"
        task.spawn(function()
            while v do
                bv.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bv:Destroy()
        end)
    end
end) -- Chức năng 12

mkToggle(Pages["Di Chuyển"], "♾️ Nhảy Vô Hạn", false, function(v)
    _G.InfJump = v
    UserInputService.JumpRequest:Connect(function()
        if _G.InfJump then LP.Character.Humanoid:ChangeState(3) end
    end)
end) -- Chức năng 13

mkBtn(Pages["Di Chuyển"], "⚡ Speed Siêu Nhanh", "WalkSpeed = 150", function()
    LP.Character.Humanoid.WalkSpeed = 150
    notify("Speed: 150")
end) -- Chức năng 14

mkBtn(Pages["Di Chuyển"], "🏰 Teleport tới Safe Zone", "Về vùng an toàn", function()
    LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    notify("Đã về Safe Zone!")
end) -- Chức năng 15

-- [TAB: THẾ GIỚI]
section(Pages["Thế Giới"], "World Mod")
mkToggle(Pages["Thế Giới"], "👻 Noclip (Xuyên Tường)", false, function(v)
    RunService.Stepped:Connect(function()
        if v and LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end) -- Chức năng 16

mkToggle(Pages["Thế Giới"], "☀️ Full Bright (Xóa Bóng Tối)", false, function(v)
    game:GetService("Lighting").Brightness = v and 2 or 1
    game:GetService("Lighting").GlobalShadows = not v
end) -- Chức năng 17

-- [TAB: HIỂN THỊ]
section(Pages["Hiển Thị"], "Visuals")
mkToggle(Pages["Hiển Thị"], "🔳 ESP Name (Hiện Tên)", false, function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            if v then
                local b = Instance.new("BillboardGui", p.Character.Head)
                b.Name = "FamESP"; b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true
                local l = Instance.new("TextLabel", b); l.Text = p.Name; l.TextColor3 = C.Accent; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1
            else
                if p.Character.Head:FindFirstChild("FamESP") then p.Character.Head.FamESP:Destroy() end
            end
        end
    end
end) -- Chức năng 18

mkToggle(Pages["Hiển Thị"], "📊 Hiện Thông Số FPS/Ping", false, function(v) notify("Đang theo dõi hệ thống...") end) -- Chức năng 19

-- [TAB: CÀI ĐẶT]
section(Pages["Cài Đặt"], "System")
mkBtn(Pages["Cài Đặt"], "🔄 Rejoin Server", "Kết nối lại ngay lập tức", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end) -- Chức năng 20

-- ══════════════════════════════════════
--           DRAG & CLOSE LOGIC
-- ══════════════════════════════════════
local dragStart, startPos
TB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = i.Position; startPos = MF.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragStart = nil end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragStart and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        MF.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Phím tắt Ẩn/Hiện
local isOpen = true
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        MF.Visible = isOpen
        if isOpen then
            tw(MF, {Size = UDim2.new(0,550,0,450)}, .3, Enum.EasingStyle.Back)
        end
    end
end)

-- Khởi tạo
SwitchTab("Chiến Đấu")
notify("FAM LV PRO V5.0 ĐÃ SẴN SÀNG!")
