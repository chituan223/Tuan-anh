-- ╔══════════════════════════════════════════════════╗
-- ║       FAM LV MENU - TIẾNG VIỆT EDITION          ║
-- ║          10 Chức Năng VIP | v2.0                ║
-- ║     Nhấn [RightShift] để ẩn / hiện              ║
-- ╚══════════════════════════════════════════════════╝

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local Workspace      = game:GetService("Workspace")

local LP  = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Gui  = LP:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
--              MÀU SẮC
-- ══════════════════════════════════════
local C = {
    BG       = Color3.fromRGB(9,  9,  16),
    Surface  = Color3.fromRGB(14, 13, 24),
    Card     = Color3.fromRGB(20, 18, 34),
    Accent   = Color3.fromRGB(255, 180, 0),
    AccentD  = Color3.fromRGB(200, 130, 0),
    Green    = Color3.fromRGB(50,  220, 120),
    Red      = Color3.fromRGB(255, 65,  85),
    TxtW     = Color3.fromRGB(235, 230, 255),
    TxtG     = Color3.fromRGB(130, 120, 160),
    Border   = Color3.fromRGB(50,  42,  80),
    ON       = Color3.fromRGB(50,  220, 120),
    OFF      = Color3.fromRGB(50,  45,  75),
}

-- ══════════════════════════════════════
--              TIỆN ÍCH
-- ══════════════════════════════════════
local function tw(obj, props, t, style, dir)
    TweenService:Create(obj, TweenInfo.new(t or .22, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end
local function corner(p, r)  local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 8); c.Parent=p; return c end
local function stroke(p, col, th) local s=Instance.new("UIStroke"); s.Color=col or C.Border; s.Thickness=th or 1; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; s.Parent=p end
local function grad(p, c0, c1, rot) local g=Instance.new("UIGradient"); g.Color=ColorSequence.new(c0,c1); g.Rotation=rot or 0; g.Parent=p end
local function notify(msg)
    local nf = Instance.new("ScreenGui"); nf.ResetOnSpawn=false; nf.Name="FamNotif"; nf.Parent=Gui
    local box = Instance.new("Frame"); box.Size=UDim2.new(0,280,0,46); box.Position=UDim2.new(0.5,-140,0,60); box.BackgroundColor3=C.Card; box.BorderSizePixel=0; box.Parent=nf
    corner(box,10); stroke(box,C.Accent,1.5)
    local bar = Instance.new("Frame"); bar.Size=UDim2.new(0,4,1,0); bar.BackgroundColor3=C.Accent; bar.BorderSizePixel=0; bar.Parent=box; corner(bar,3)
    local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,-14,1,0); lbl.Position=UDim2.new(0,10,0,0); lbl.BackgroundTransparency=1; lbl.Text="⚡  "..msg; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextColor3=C.TxtW; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Parent=box
    box.Position = UDim2.new(0.5,-140,0,-60)
    tw(box, {Position=UDim2.new(0.5,-140,0,20)}, .4, Enum.EasingStyle.Back)
    task.delay(2.2, function() tw(box, {Position=UDim2.new(0.5,-140,0,-70)}, .3, Enum.EasingStyle.Quad, Enum.EasingDirection.In) task.wait(.32); nf:Destroy() end)
end

-- ══════════════════════════════════════
--           SCREEN GUI
-- ══════════════════════════════════════
local SG = Instance.new("ScreenGui"); SG.Name="FamLV_VietMenu"; SG.ResetOnSpawn=false; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.Parent=Gui

-- MAIN FRAME
local MF = Instance.new("Frame"); MF.Name="Main"; MF.Size=UDim2.new(0,520,0,420); MF.Position=UDim2.new(0.5,-260,0.5,-210); MF.BackgroundColor3=C.BG; MF.ClipsDescendants=true; MF.Parent=SG
corner(MF,14); stroke(MF,C.Border,1.5)
grad(MF, Color3.fromRGB(11,9,20), Color3.fromRGB(7,10,18), 135)

-- Viền phát sáng vàng trên cùng
local glow = Instance.new("Frame"); glow.Size=UDim2.new(1,0,0,3); glow.BackgroundColor3=C.Accent; glow.BorderSizePixel=0; glow.Parent=MF
grad(glow, Color3.fromRGB(0,0,0), C.Accent, 0)

-- ══════════════════════════════════════
--            THANH TIÊU ĐỀ
-- ══════════════════════════════════════
local TB = Instance.new("Frame"); TB.Size=UDim2.new(1,0,0,50); TB.BackgroundColor3=C.Surface; TB.BorderSizePixel=0; TB.ZIndex=5; TB.Parent=MF
grad(TB, Color3.fromRGB(16,13,30), Color3.fromRGB(10,9,18), 135)

-- Logo tròn
local logo = Instance.new("Frame"); logo.Size=UDim2.new(0,34,0,34); logo.Position=UDim2.new(0,12,0.5,-17); logo.BackgroundColor3=C.Accent; logo.ZIndex=6; logo.Parent=TB
corner(logo,17)
grad(logo, C.Accent, C.AccentD, 135)
local logoTxt = Instance.new("TextLabel"); logoTxt.Size=UDim2.new(1,0,1,0); logoTxt.BackgroundTransparency=1; logoTxt.Text="F"; logoTxt.Font=Enum.Font.GothamBlack; logoTxt.TextSize=18; logoTxt.TextColor3=Color3.fromRGB(20,10,0); logoTxt.ZIndex=7; logoTxt.Parent=logo

-- Tiêu đề
local title = Instance.new("TextLabel"); title.Size=UDim2.new(0,200,0,22); title.Position=UDim2.new(0,54,0,7); title.BackgroundTransparency=1; title.Text="FAM LV MENU"; title.Font=Enum.Font.GothamBlack; title.TextSize=15; title.TextColor3=C.TxtW; title.TextXAlignment=Enum.TextXAlignment.Left; title.ZIndex=6; title.Parent=TB
local sub = Instance.new("TextLabel"); sub.Size=UDim2.new(0,200,0,14); sub.Position=UDim2.new(0,54,0,27); sub.BackgroundTransparency=1; sub.Text="10 CHỨC NĂNG VIP ✦ v2.0"; sub.Font=Enum.Font.Gotham; sub.TextSize=10; sub.TextColor3=C.Accent; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.ZIndex=6; sub.Parent=TB

-- Nút đóng
local closeBtn = Instance.new("TextButton"); closeBtn.Size=UDim2.new(0,28,0,28); closeBtn.Position=UDim2.new(1,-40,0.5,-14); closeBtn.BackgroundColor3=C.Red; closeBtn.Text="✕"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=12; closeBtn.TextColor3=Color3.fromRGB(255,255,255); closeBtn.ZIndex=6; closeBtn.Parent=TB; corner(closeBtn,6)
closeBtn.MouseButton1Click:Connect(function() SG:Destroy() end)

-- Nút minimize
local minBtn = Instance.new("TextButton"); minBtn.Size=UDim2.new(0,28,0,28); minBtn.Position=UDim2.new(1,-76,0.5,-14); minBtn.BackgroundColor3=Color3.fromRGB(255,180,30); minBtn.Text="−"; minBtn.Font=Enum.Font.GothamBold; minBtn.TextSize=16; minBtn.TextColor3=Color3.fromRGB(80,40,0); minBtn.ZIndex=6; minBtn.Parent=TB; corner(minBtn,6)
local minimized=false
minBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    tw(MF,{Size=minimized and UDim2.new(0,520,0,50) or UDim2.new(0,520,0,420)},.3,Enum.EasingStyle.Back)
end)

-- Kéo cửa sổ
local drag,dragStart,startPos
TB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; dragStart=i.Position; startPos=MF.Position end end)
UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-dragStart; MF.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)

-- ══════════════════════════════════════
--          SIDEBAR / TAB
-- ══════════════════════════════════════
local SB = Instance.new("Frame"); SB.Size=UDim2.new(0,130,1,-50); SB.Position=UDim2.new(0,0,0,50); SB.BackgroundColor3=C.Surface; SB.BorderSizePixel=0; SB.ZIndex=3; SB.Parent=MF
grad(SB, Color3.fromRGB(14,12,26), Color3.fromRGB(10,9,18), 180)
local sbList=Instance.new("UIListLayout"); sbList.SortOrder=Enum.SortOrder.LayoutOrder; sbList.Padding=UDim.new(0,4); sbList.Parent=SB
local sbPad=Instance.new("UIPadding"); sbPad.PaddingTop=UDim.new(0,10); sbPad.PaddingLeft=UDim.new(0,7); sbPad.PaddingRight=UDim.new(0,7); sbPad.Parent=SB
local sbDiv=Instance.new("Frame"); sbDiv.Size=UDim2.new(0,1,1,-50); sbDiv.Position=UDim2.new(0,130,0,50); sbDiv.BackgroundColor3=C.Border; sbDiv.BorderSizePixel=0; sbDiv.ZIndex=4; sbDiv.Parent=MF

-- VÙNG NỘI DUNG
local CA = Instance.new("Frame"); CA.Size=UDim2.new(1,-131,1,-50); CA.Position=UDim2.new(0,131,0,50); CA.BackgroundTransparency=1; CA.ClipsDescendants=true; CA.ZIndex=3; CA.Parent=MF

-- ══════════════════════════════════════
--            TAB SYSTEM
-- ══════════════════════════════════════
local Tabs={} local Pages={} local ActiveTab=nil
local TabDefs={
    {name="Nhặt Đồ",   icon="🎁"},
    {name="Di Chuyển",  icon="🏃"},
    {name="Thế Giới",   icon="🌍"},
    {name="Hiển Thị",   icon="👁"},
    {name="Tiện Ích",   icon="⚙"},
}
local function SwitchTab(name)
    if ActiveTab==name then return end; ActiveTab=name
    for n,pg in pairs(Pages) do pg.Visible=(n==name) end
    for n,btn in pairs(Tabs) do
        if n==name then tw(btn,{BackgroundColor3=C.Accent,BackgroundTransparency=0},.2); btn.TextColor3=Color3.fromRGB(20,10,0)
        else tw(btn,{BackgroundColor3=C.BG,BackgroundTransparency=1},.2); btn.TextColor3=C.TxtG end
    end
end
for i,t in ipairs(TabDefs) do
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,38); btn.BackgroundColor3=C.BG; btn.BackgroundTransparency=1; btn.Text=t.icon.."  "..t.name; btn.Font=Enum.Font.GothamSemibold; btn.TextSize=11; btn.TextColor3=C.TxtG; btn.TextXAlignment=Enum.TextXAlignment.Left; btn.LayoutOrder=i; btn.ZIndex=5; btn.Parent=SB; corner(btn,7)
    local p=Instance.new("UIPadding"); p.PaddingLeft=UDim.new(0,8); p.Parent=btn
    btn.MouseEnter:Connect(function() if ActiveTab~=t.name then tw(btn,{BackgroundColor3=Color3.fromRGB(35,28,55),BackgroundTransparency=0},.15) end end)
    btn.MouseLeave:Connect(function() if ActiveTab~=t.name then tw(btn,{BackgroundTransparency=1},.15) end end)
    local pg=Instance.new("ScrollingFrame"); pg.Size=UDim2.new(1,0,1,0); pg.BackgroundTransparency=1; pg.ScrollBarThickness=3; pg.ScrollBarImageColor3=C.Accent; pg.Visible=false; pg.ZIndex=3; pg.Parent=CA
    local pgl=Instance.new("UIListLayout"); pgl.SortOrder=Enum.SortOrder.LayoutOrder; pgl.Padding=UDim.new(0,7); pgl.Parent=pg
    pgl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize=UDim2.new(0,0,0,pgl.AbsoluteContentSize.Y+16) end)
    local pgpad=Instance.new("UIPadding"); pgpad.PaddingTop=UDim.new(0,12); pgpad.PaddingLeft=UDim.new(0,12); pgpad.PaddingRight=UDim.new(0,14); pgpad.Parent=pg
    Tabs[t.name]=btn; Pages[t.name]=pg
    btn.MouseButton1Click:Connect(function() SwitchTab(t.name) end)
end

-- ══════════════════════════════════════
--       COMPONENT BUILDERS
-- ══════════════════════════════════════
local function section(page, txt)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.Parent=page
    local line=Instance.new("Frame"); line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,.5,0); line.BackgroundColor3=C.Border; line.BorderSizePixel=0; line.Parent=f
    local lb=Instance.new("TextLabel"); lb.Size=UDim2.new(0,0,1,0); lb.AutomaticSize=Enum.AutomaticSize.X; lb.BackgroundColor3=C.BG; lb.Text="  ▸ "..txt:upper().."  "; lb.Font=Enum.Font.GothamBold; lb.TextSize=10; lb.TextColor3=C.Accent; lb.ZIndex=4; lb.Parent=f
end

local function mkToggle(page, lbl, default, cb)
    local s={v=default or false}
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,40); row.BackgroundColor3=C.Card; row.Parent=page; corner(row,9); stroke(row,C.Border,1)
    local lb=Instance.new("TextLabel"); lb.Size=UDim2.new(1,-58,1,0); lb.Position=UDim2.new(0,12,0,0); lb.BackgroundTransparency=1; lb.Text=lbl; lb.Font=Enum.Font.Gotham; lb.TextSize=12; lb.TextColor3=C.TxtW; lb.TextXAlignment=Enum.TextXAlignment.Left; lb.Parent=row
    local track=Instance.new("Frame"); track.Size=UDim2.new(0,42,0,22); track.Position=UDim2.new(1,-54,0.5,-11); track.BackgroundColor3=s.v and C.ON or C.OFF; track.Parent=row; corner(track,11)
    local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,16,0,16); thumb.Position=s.v and UDim2.new(1,-19,.5,-8) or UDim2.new(0,3,.5,-8); thumb.BackgroundColor3=Color3.fromRGB(255,255,255); thumb.Parent=track; corner(thumb,8)
    local status=Instance.new("TextLabel"); status.Size=UDim2.new(0,30,0,14); status.Position=UDim2.new(1,-54,.5,-7-10); status.BackgroundTransparency=1; status.Text=s.v and "BẬT" or "TẮT"; status.Font=Enum.Font.GothamBold; status.TextSize=9; status.TextColor3=s.v and C.ON or C.TxtG; status.Parent=row
    local function upd()
        tw(track,{BackgroundColor3=s.v and C.ON or C.OFF},.2)
        tw(thumb,{Position=s.v and UDim2.new(1,-19,.5,-8) or UDim2.new(0,3,.5,-8)},.2,Enum.EasingStyle.Back)
        status.Text=s.v and "BẬT" or "TẮT"; status.TextColor3=s.v and C.ON or C.TxtG
        if cb then cb(s.v) end
    end
    local tbtn=Instance.new("TextButton"); tbtn.Size=UDim2.new(1,0,1,0); tbtn.BackgroundTransparency=1; tbtn.Text=""; tbtn.Parent=row
    tbtn.MouseButton1Click:Connect(function() s.v=not s.v; upd() end)
    row.MouseEnter:Connect(function() tw(row,{BackgroundColor3=Color3.fromRGB(28,24,46)},.15) end)
    row.MouseLeave:Connect(function() tw(row,{BackgroundColor3=C.Card},.15) end)
    upd(); return s
end

local function mkSlider(page, lbl, min, max, default, cb)
    local val=default or min; local draggingS=false
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,54); row.BackgroundColor3=C.Card; row.Parent=page; corner(row,9); stroke(row,C.Border,1)
    local top=Instance.new("Frame"); top.Size=UDim2.new(1,-24,0,26); top.Position=UDim2.new(0,12,0,0); top.BackgroundTransparency=1; top.Parent=row
    local lb=Instance.new("TextLabel"); lb.Size=UDim2.new(.7,0,1,0); lb.BackgroundTransparency=1; lb.Text=lbl; lb.Font=Enum.Font.Gotham; lb.TextSize=12; lb.TextColor3=C.TxtW; lb.TextXAlignment=Enum.TextXAlignment.Left; lb.Parent=top
    local vl=Instance.new("TextLabel"); vl.Size=UDim2.new(.3,0,1,0); vl.Position=UDim2.new(.7,0,0,0); vl.BackgroundTransparency=1; vl.Text=tostring(val); vl.Font=Enum.Font.GothamBold; vl.TextSize=12; vl.TextColor3=C.Accent; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=top
    local track=Instance.new("Frame"); track.Size=UDim2.new(1,-24,0,6); track.Position=UDim2.new(0,12,0,36); track.BackgroundColor3=Color3.fromRGB(38,32,60); track.Parent=row; corner(track,3)
    local fill=Instance.new("Frame"); fill.Size=UDim2.new((val-min)/(max-min),0,1,0); fill.BackgroundColor3=C.Accent; fill.Parent=track; corner(fill,3)
    grad(fill, C.Accent, C.AccentD, 0)
    local knob=Instance.new("Frame"); knob.Size=UDim2.new(0,14,0,14); knob.Position=UDim2.new((val-min)/(max-min),-7,.5,-7); knob.BackgroundColor3=Color3.fromRGB(255,255,255); knob.Parent=track; corner(knob,7)
    local sb=Instance.new("TextButton"); sb.Size=UDim2.new(1,0,1,0); sb.BackgroundTransparency=1; sb.Text=""; sb.Parent=track
    local function setV(v) val=math.clamp(math.floor(v),min,max); local p=(val-min)/(max-min); tw(fill,{Size=UDim2.new(p,0,1,0)},.05); tw(knob,{Position=UDim2.new(p,-7,.5,-7)},.05); vl.Text=tostring(val); if cb then cb(val) end end
    sb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingS=true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingS=false end end)
    UserInputService.InputChanged:Connect(function(i) if draggingS and i.UserInputType==Enum.UserInputType.MouseMovement then local p=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1); setV(min+p*(max-min)) end end)
    return {Get=function()return val end, Set=setV}
end

local function mkButton(page, lbl, sub_, cb)
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0,42); btn.BackgroundColor3=C.Accent; btn.Text=""; btn.ZIndex=3; btn.Parent=page; corner(btn,9)
    grad(btn, C.Accent, C.AccentD, 135)
    local lb=Instance.new("TextLabel"); lb.Size=UDim2.new(1,0,0,22); lb.Position=UDim2.new(0,14,0,4); lb.BackgroundTransparency=1; lb.Text=lbl; lb.Font=Enum.Font.GothamBold; lb.TextSize=13; lb.TextColor3=Color3.fromRGB(20,10,0); lb.TextXAlignment=Enum.TextXAlignment.Left; lb.ZIndex=4; lb.Parent=btn
    if sub_ then local s=Instance.new("TextLabel"); s.Size=UDim2.new(1,0,0,14); s.Position=UDim2.new(0,14,0,24); s.BackgroundTransparency=1; s.Text=sub_; s.Font=Enum.Font.Gotham; s.TextSize=10; s.TextColor3=Color3.fromRGB(80,50,0); s.TextXAlignment=Enum.TextXAlignment.Left; s.ZIndex=4; s.Parent=btn end
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=Color3.fromRGB(255,200,30)},.15) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.Accent},.15) end)
    btn.MouseButton1Click:Connect(function() tw(btn,{Size=UDim2.new(.97,0,0,39)},.1); task.wait(.1); tw(btn,{Size=UDim2.new(1,0,0,42)},.15,Enum.EasingStyle.Back); if cb then cb() end end)
end

-- ══════════════════════════════════════════════════
--         10 CHỨC NĂNG VIP - TIẾNG VIỆT
-- ══════════════════════════════════════════════════

-- ▸ TAB 1: NHẶT ĐỒ
local P1 = Pages["Nhặt Đồ"]
section(P1, "Chức Năng Nhặt Tự Động")

-- CHỨC NĂNG 1: Nhặt Rương
local autoChestOn = false
local chestThread
mkToggle(P1, "🎁  Tự Động Nhặt Rương", false, function(v)
    autoChestOn = v
    if v then
        notify("🎁 Nhặt Rương: BẬT")
        chestThread = task.spawn(function()
            while autoChestOn do
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not autoChestOn then break end
                    local name = obj.Name:lower()
                    if (name:find("chest") or name:find("ruong") or name:find("rương") or name:find("treasure") or name:find("box")) and obj:IsA("BasePart") then
                        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (LP.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            if dist < 60 then
                                LP.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0,3,0))
                                task.wait(0.2)
                                local touch = obj:FindFirstChild("TouchInterest") or obj
                                if touch then
                                    fireclickdetector(obj) -- executor only
                                end
                                task.wait(0.3)
                            end
                        end
                    end
                end
                task.wait(1.5)
            end
        end)
    else
        notify("🎁 Nhặt Rương: TẮT")
    end
end)

-- CHỨC NĂNG 2: Nhặt Trái (Fam LV)
local autoFruitOn = false
mkToggle(P1, "🍎  Tự Động Nhặt Trái", false, function(v)
    autoFruitOn = v
    if v then
        notify("🍎 Nhặt Trái: BẬT")
        task.spawn(function()
            while autoFruitOn do
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not autoFruitOn then break end
                    local name = obj.Name:lower()
                    if (name:find("fruit") or name:find("trai") or name:find("trái") or name:find("apple") or name:find("devil")) and obj:IsA("BasePart") then
                        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (LP.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            if dist < 120 then
                                LP.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0,4,0))
                                task.wait(0.35)
                                fireclickdetector(obj)
                                task.wait(0.2)
                            end
                        end
                    end
                end
                task.wait(1.2)
            end
        end)
    else
        notify("🍎 Nhặt Trái: TẮT")
    end
end)

-- CHỨC NĂNG 3: Nhặt Tiền / Drop
local autoCoinOn = false
mkToggle(P1, "💰  Tự Động Nhặt Tiền / Drop", false, function(v)
    autoCoinOn = v
    if v then
        notify("💰 Nhặt Tiền: BẬT")
        task.spawn(function()
            while autoCoinOn do
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if not autoCoinOn then break end
                    local n = obj.Name:lower()
                    if (n:find("coin") or n:find("money") or n:find("gold") or n:find("drop") or n:find("tien") or n:find("tiền") or n:find("beri")) and obj:IsA("BasePart") then
                        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                            local dist=(LP.Character.HumanoidRootPart.Position-obj.Position).Magnitude
                            if dist<80 then
                                LP.Character.HumanoidRootPart.CFrame=CFrame.new(obj.Position+Vector3.new(0,3,0))
                                task.wait(0.2)
                            end
                        end
                    end
                end
                task.wait(0.8)
            end
        end)
    else
        notify("💰 Nhặt Tiền: TẮT")
    end
end)

mkButton(P1, "📍  Nhặt Tất Cả Trong Vùng (50m)", "Quét & nhặt đồ bán kính 50 studs", function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = LP.Character.HumanoidRootPart
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local dist=(root.Position-obj.Position).Magnitude
            if dist<50 then
                local n=obj.Name:lower()
                if n:find("fruit") or n:find("chest") or n:find("coin") or n:find("drop") or n:find("box") then
                    root.CFrame=CFrame.new(obj.Position+Vector3.new(0,3,0))
                    task.wait(0.15); count=count+1
                end
            end
        end
    end
    notify("✅ Đã nhặt "..count.." vật phẩm!")
end)

-- ▸ TAB 2: DI CHUYỂN
local P2 = Pages["Di Chuyển"]
section(P2, "Tốc Độ & Nhảy")

-- CHỨC NĂNG 4: Tốc Độ Chạy
mkSlider(P2, "🏃  Tốc Độ Chạy", 16, 250, 16, function(v)
    local c = LP.Character or LP.CharacterAdded:Wait()
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed=v end
end)

-- CHỨC NĂNG 5: Nhảy Cao
mkSlider(P2, "⬆  Lực Nhảy", 50, 400, 50, function(v)
    local c = LP.Character or LP.CharacterAdded:Wait()
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower=v end
end)

section(P2, "Khả Năng Đặc Biệt")

-- CHỨC NĂNG 6: Nhảy Vô Hạn
local infJump = false
mkToggle(P2, "♾  Nhảy Vô Hạn", false, function(v)
    infJump = v
    if v then
        notify("♾ Nhảy Vô Hạn: BẬT")
        UserInputService.JumpRequest:Connect(function()
            if infJump then
                local c = LP.Character
                if c then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end
        end)
    else notify("♾ Nhảy Vô Hạn: TẮT") end
end)

-- Noclip
mkToggle(P2, "👻  Noclip (Xuyên Tường)", false, function(v)
    notify(v and "👻 Noclip: BẬT" or "👻 Noclip: TẮT")
    RunService.Stepped:Connect(function()
        if v and LP.Character then
            for _, p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end
    end)
end)

mkButton(P2, "🏠  Teleport Về Spawn", "Về điểm hồi sinh ban đầu", function()
    local c=LP.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame=CFrame.new(0,10,0)
        notify("🏠 Đã teleport về Spawn!")
    end
end)

-- ▸ TAB 3: THẾ GIỚI
local P3 = Pages["Thế Giới"]
section(P3, "Ánh Sáng & Thời Gian")

-- CHỨC NĂNG 7: Toàn Sáng
mkToggle(P3, "☀  Toàn Sáng (Full Bright)", false, function(v)
    local L=game:GetService("Lighting")
    if v then
        L.Brightness=10; L.ClockTime=14
        L.FogEnd=100000; L.GlobalShadows=false
        L.Ambient=Color3.fromRGB(255,255,255)
        notify("☀ Toàn Sáng: BẬT")
    else
        L.Brightness=1; L.ClockTime=10
        L.FogEnd=10000; L.GlobalShadows=true
        L.Ambient=Color3.fromRGB(100,100,100)
        notify("☀ Toàn Sáng: TẮT")
    end
end)

section(P3, "Thời Tiết")
mkButton(P3, "🌅  Bình Minh (6 giờ)", nil, function()
    game:GetService("Lighting").ClockTime=6
    notify("🌅 Bình Minh")
end)
mkButton(P3, "☀  Ban Ngày (12 giờ)", nil, function()
    game:GetService("Lighting").ClockTime=12
    notify("☀ Ban Ngày")
end)
mkButton(P3, "🌙  Ban Đêm (0 giờ)", nil, function()
    game:GetService("Lighting").ClockTime=0
    notify("🌙 Ban Đêm")
end)

-- ▸ TAB 4: HIỂN THỊ
local P4 = Pages["Hiển Thị"]
section(P4, "ESP Người Chơi")

-- CHỨC NĂNG 8: ESP Box
local espActive = false
local espObjects = {}
mkToggle(P4, "🔲  ESP Hộp Người Chơi", false, function(v)
    espActive = v
    if not v then
        for _, h in pairs(espObjects) do if h and h.Parent then h:Destroy() end end
        espObjects={}
        notify("🔲 ESP: TẮT")
        return
    end
    notify("🔲 ESP: BẬT")
    task.spawn(function()
        while espActive do
            -- dọn ESP cũ
            for _, h in pairs(espObjects) do if h and h.Parent then h:Destroy() end end
            espObjects={}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr~=LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local root=plr.Character.HumanoidRootPart
                    local bb=Instance.new("BillboardGui"); bb.Size=UDim2.new(0,4,0,6); bb.StudsOffset=Vector3.new(0,3,0); bb.Adornee=root; bb.AlwaysOnTop=true; bb.Parent=root
                    local lbl=Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,0,20); lbl.BackgroundTransparency=1; lbl.Text=plr.Name; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextColor3=C.Accent; lbl.TextStrokeTransparency=0; lbl.Parent=bb
                    local hpText=Instance.new("TextLabel"); hpText.Size=UDim2.new(1,0,0,14); hpText.Position=UDim2.new(0,0,1,0); hpText.BackgroundTransparency=1
                    local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                    hpText.Text=hum and ("❤ "..math.floor(hum.Health)) or ""; hpText.Font=Enum.Font.Gotham; hpText.TextSize=10; hpText.TextColor3=C.Green; hpText.TextStrokeTransparency=0; hpText.Parent=bb
                    table.insert(espObjects, bb)
                end
            end
            task.wait(1)
        end
    end)
end)

mkToggle(P4, "📏  Hiển Thị Khoảng Cách", false, function(v) notify(v and "📏 Khoảng Cách: BẬT" or "📏 Khoảng Cách: TẮT") end)

-- ▸ TAB 5: TIỆN ÍCH
local P5 = Pages["Tiện Ích"]
section(P5, "Hỗ Trợ Chơi Game")

-- CHỨC NĂNG 9: Anti AFK
local antiAFK = false
mkToggle(P5, "⏰  Chống AFK Tự Động", false, function(v)
    antiAFK = v
    notify(v and "⏰ Anti AFK: BẬT" or "⏰ Anti AFK: TẮT")
    if v then
        LP.Idled:Connect(function()
            if antiAFK then
                local vu=game:GetService("VirtualUser")
                vu:CaptureController(); vu:ClickButton2(Vector2.new())
            end
        end)
    end
end)

-- CHỨC NĂNG 10: Auto Farm cơ bản (tự tấn công NPC gần nhất)
local autoFarmOn = false
mkToggle(P5, "⚔  Tự Đánh NPC Gần Nhất", false, function(v)
    autoFarmOn = v
    if v then
        notify("⚔ Auto Farm: BẬT")
        task.spawn(function()
            while autoFarmOn do
                local c = LP.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    local root = c.HumanoidRootPart
                    local nearest, nearDist = nil, math.huge
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj~=c then
                            local hum=obj:FindFirstChildOfClass("Humanoid")
                            local hrp=obj:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health>0 and not Players:GetPlayerFromCharacter(obj) then
                                local d=(root.Position-hrp.Position).Magnitude
                                if d<nearDist then nearDist=d; nearest=hrp end
                            end
                        end
                    end
                    if nearest and nearDist<200 then
                        root.CFrame=CFrame.new(nearest.Position+Vector3.new(0,2,3))
                        task.wait(0.1)
                        -- Simulate tool activation
                        local tool=c:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            local re=tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
                            if re then pcall(function() re:FireServer() end) end
                        end
                    end
                end
                task.wait(0.4)
            end
        end)
    else notify("⚔ Auto Farm: TẮT") end
end)

section(P5, "Thông Tin & Khác")
mkButton(P5, "📋  Sao Chép User ID", "Copy UserID của bạn", function()
    local id=tostring(LP.UserId)
    pcall(function() setclipboard(id) end)
    notify("📋 UserID: "..id.." (đã copy!)")
end)
mkButton(P5, "🔄  Rejoin Server", "Vào lại server hiện tại", function()
    notify("🔄 Đang rejoin...")
    task.wait(1)
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end)

-- ══════════════════════════════════════
--      ANIMATION MỞ + TAB MẶC ĐỊNH
-- ══════════════════════════════════════
MF.Size=UDim2.new(0,520,0,0); MF.Position=UDim2.new(0.5,-260,0.5,0)
tw(MF, {Size=UDim2.new(0,520,0,420), Position=UDim2.new(0.5,-260,0.5,-210)}, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
task.wait(0.1); SwitchTab("Nhặt Đồ")
task.wait(0.5); notify("🟡 FAM LV MENU đã tải! RightShift để ẩn/hiện")

-- TOGGLE PHÍM
local menuOpen=true
UserInputService.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        menuOpen=not menuOpen
        if menuOpen then
            MF.Visible=true
            tw(MF,{Size=UDim2.new(0,520,0,420),Position=UDim2.new(0.5,-260,0.5,-210)},.35,Enum.EasingStyle.Back)
        else
            tw(MF,{Size=UDim2.new(0,520,0,0),Position=UDim2.new(0.5,-260,0.5,0)},.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
            task.wait(.27); MF.Visible=false
        end
    end
end)

print("✅ [FAM LV MENU] 10 Chức Năng VIP đã sẵn sàng! | RightShift để bật/tắt")
