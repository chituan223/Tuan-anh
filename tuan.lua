-- ╔═══════════════════════════════════════════════════╗
-- ║        FAM LV MENU - 20 CHỨC NĂNG THẬT           ║
-- ║            Full VIP Edition v3.0                  ║
-- ║     [RightShift] Ẩn/Hiện  |  Executor Only        ║
-- ╚═══════════════════════════════════════════════════╝

-- ══════════════════════════════════════
--            SERVICES
-- ══════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")
local TeleportService  = game:GetService("TeleportService")

local LP    = Players.LocalPlayer
local Mouse = LP:GetMouse()
local PGui  = LP:WaitForChild("PlayerGui")

local function GetChar() return LP.Character end
local function GetRoot() local c=GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum()  local c=GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════
--         TRẠNG THÁI TOÀN CỤC
-- ══════════════════════════════════════
local _G_FAM = {
    AutoChest     = false,
    AutoFruit     = false,
    AutoCoin      = false,
    AutoFarm      = false,
    AutoQuest     = false,
    KillAura      = false,
    InfJump       = false,
    Noclip        = false,
    Fly           = false,
    AntiAFK       = false,
    ESP           = false,
    HitboxExpand  = false,
    SpinBot       = false,
    GodMode       = false,
    FullBright    = false,
    RemoveFog     = false,
    FlySpeed      = 50,
    SpinSpeed     = 10,
    KillRadius    = 15,
    HitboxSize    = 5,
}

-- ══════════════════════════════════════
--              MÀU SẮC
-- ══════════════════════════════════════
local C = {
    BG      = Color3.fromRGB(8,   8,  15),
    Surface = Color3.fromRGB(13,  12, 22),
    Card    = Color3.fromRGB(18,  16, 32),
    CardHov = Color3.fromRGB(26,  22, 46),
    Acc     = Color3.fromRGB(255, 185, 0),
    AccD    = Color3.fromRGB(190, 130, 0),
    Green   = Color3.fromRGB(40,  220, 110),
    Red     = Color3.fromRGB(255,  60,  80),
    Blue    = Color3.fromRGB(60,  150, 255),
    TxtW    = Color3.fromRGB(240, 235, 255),
    TxtG    = Color3.fromRGB(120, 110, 155),
    Border  = Color3.fromRGB(45,   38,  75),
    ON      = Color3.fromRGB(40,  220, 110),
    OFF     = Color3.fromRGB(45,   40,  70),
}

-- ══════════════════════════════════════
--            TIỆN ÍCH UI
-- ══════════════════════════════════════
local function tw(o,p,t,s,d)
    TweenService:Create(o,TweenInfo.new(t or .2, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out),p):Play()
end
local function corner(p,r) local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r or 8);c.Parent=p;return c end
local function stroke(p,c,th) local s=Instance.new("UIStroke");s.Color=c or C.Border;s.Thickness=th or 1;s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Parent=p;return s end
local function grad(p,a,b,r) local g=Instance.new("UIGradient");g.Color=ColorSequence.new(a,b);g.Rotation=r or 0;g.Parent=p;return g end

-- Hệ thống thông báo popup
local notifY = 24
local function notify(msg, col)
    col = col or C.Acc
    local nSG = Instance.new("ScreenGui"); nSG.Name="FamNotif_"..tick(); nSG.ResetOnSpawn=false; nSG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; nSG.Parent=PGui
    local box = Instance.new("Frame"); box.Size=UDim2.new(0,300,0,44); box.Position=UDim2.new(1,-316,0,-50); box.BackgroundColor3=C.Card; box.BorderSizePixel=0; box.ZIndex=100; box.Parent=nSG
    corner(box,10); stroke(box,col,1.5)
    local bar=Instance.new("Frame");bar.Size=UDim2.new(0,3,1,0);bar.BackgroundColor3=col;bar.BorderSizePixel=0;bar.ZIndex=101;bar.Parent=box;corner(bar,2)
    local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,-14,1,0);lb.Position=UDim2.new(0,10,0,0);lb.BackgroundTransparency=1;lb.Text=msg;lb.Font=Enum.Font.GothamBold;lb.TextSize=12;lb.TextColor3=C.TxtW;lb.TextXAlignment=Enum.TextXAlignment.Left;lb.ZIndex=102;lb.TextTruncate=Enum.TextTruncate.AtEnd;lb.Parent=box
    local targetY = notifY; notifY = notifY + 50
    tw(box,{Position=UDim2.new(1,-316,0,targetY)},.35,Enum.EasingStyle.Back)
    task.delay(2.8,function()
        tw(box,{Position=UDim2.new(1,10,0,targetY)},.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        task.wait(.3); nSG:Destroy(); notifY=math.max(24,notifY-50)
    end)
end

-- ══════════════════════════════════════
--            SCREEN GUI
-- ══════════════════════════════════════
if PGui:FindFirstChild("FamLV_Menu") then PGui.FamLV_Menu:Destroy() end
local SG=Instance.new("ScreenGui"); SG.Name="FamLV_Menu"; SG.ResetOnSpawn=false; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.Parent=PGui

-- MAIN FRAME
local MF=Instance.new("Frame"); MF.Name="Main"; MF.Size=UDim2.new(0,570,0,450); MF.Position=UDim2.new(0.5,-285,0.5,-225); MF.BackgroundColor3=C.BG; MF.ClipsDescendants=true; MF.Parent=SG
corner(MF,14); stroke(MF,C.Border,1.5)
grad(MF,Color3.fromRGB(10,8,18),Color3.fromRGB(6,9,16),145)

local topGlow=Instance.new("Frame"); topGlow.Size=UDim2.new(1,0,0,2); topGlow.BackgroundColor3=C.Acc; topGlow.BorderSizePixel=0; topGlow.Parent=MF
grad(topGlow,Color3.fromRGB(20,10,0),C.Acc,0)

-- ══════════════════════════════════════
--           THANH TIÊU ĐỀ
-- ══════════════════════════════════════
local TB=Instance.new("Frame"); TB.Size=UDim2.new(1,0,0,50); TB.BackgroundColor3=C.Surface; TB.BorderSizePixel=0; TB.ZIndex=5; TB.Parent=MF
grad(TB,Color3.fromRGB(15,12,28),Color3.fromRGB(9,8,17),140)

local logoF=Instance.new("Frame"); logoF.Size=UDim2.new(0,36,0,36); logoF.Position=UDim2.new(0,12,0.5,-18); logoF.BackgroundColor3=C.Acc; logoF.ZIndex=6; logoF.Parent=TB; corner(logoF,18)
grad(logoF,C.Acc,C.AccD,135)
local logoL=Instance.new("TextLabel"); logoL.Size=UDim2.new(1,0,1,0); logoL.BackgroundTransparency=1; logoL.Text="F"; logoL.Font=Enum.Font.GothamBlack; logoL.TextSize=20; logoL.TextColor3=Color3.fromRGB(18,8,0); logoL.ZIndex=7; logoL.Parent=logoF

local titleL=Instance.new("TextLabel"); titleL.Size=UDim2.new(0,220,0,22); titleL.Position=UDim2.new(0,56,0,6); titleL.BackgroundTransparency=1; titleL.Text="FAM LV MENU"; titleL.Font=Enum.Font.GothamBlack; titleL.TextSize=16; titleL.TextColor3=C.TxtW; titleL.TextXAlignment=Enum.TextXAlignment.Left; titleL.ZIndex=6; titleL.Parent=TB
local subL=Instance.new("TextLabel"); subL.Size=UDim2.new(0,260,0,14); subL.Position=UDim2.new(0,56,0,27); subL.BackgroundTransparency=1; subL.Text="20 CHỨC NĂNG VIP  ✦  v3.0  ✦  TIẾNG VIỆT"; subL.Font=Enum.Font.Gotham; subL.TextSize=10; subL.TextColor3=C.Acc; subL.TextXAlignment=Enum.TextXAlignment.Left; subL.ZIndex=6; subL.Parent=TB

-- Nút đóng & minimize
local function mkTitleBtn(xOff, bgCol, txt, fontSize)
    local b=Instance.new("TextButton"); b.Size=UDim2.new(0,28,0,28); b.Position=UDim2.new(1,xOff,0.5,-14); b.BackgroundColor3=bgCol; b.Text=txt; b.Font=Enum.Font.GothamBold; b.TextSize=fontSize or 13; b.TextColor3=Color3.fromRGB(255,255,255); b.ZIndex=6; b.Parent=TB; corner(b,6); return b
end
local closeBtn = mkTitleBtn(-40, C.Red, "✕")
local minBtn   = mkTitleBtn(-76, Color3.fromRGB(255,175,25), "−", 17)
closeBtn.TextColor3=Color3.fromRGB(255,255,255)
minBtn.TextColor3=Color3.fromRGB(60,30,0)

closeBtn.MouseButton1Click:Connect(function()
    tw(MF,{Size=UDim2.new(0,570,0,0),Position=UDim2.new(0.5,-285,0.5,0)},.28,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
    task.wait(.3); SG:Destroy()
end)
local minimized=false
minBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    tw(MF,{Size=minimized and UDim2.new(0,570,0,50) or UDim2.new(0,570,0,450)},.3,Enum.EasingStyle.Back)
end)

-- Kéo cửa sổ
local drag,dStart,dPos
TB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;dStart=i.Position;dPos=MF.Position end end)
UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-dStart; MF.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y) end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)

-- ══════════════════════════════════════
--            SIDEBAR
-- ══════════════════════════════════════
local SB=Instance.new("Frame"); SB.Size=UDim2.new(0,136,1,-50); SB.Position=UDim2.new(0,0,0,50); SB.BackgroundColor3=C.Surface; SB.BorderSizePixel=0; SB.ZIndex=3; SB.Parent=MF
grad(SB,Color3.fromRGB(13,11,24),Color3.fromRGB(8,8,15),180)
Instance.new("UIListLayout",SB).Padding=UDim.new(0,3)
local sbPad=Instance.new("UIPadding",SB); sbPad.PaddingTop=UDim.new(0,8); sbPad.PaddingLeft=UDim.new(0,7); sbPad.PaddingRight=UDim.new(0,7)
local div=Instance.new("Frame"); div.Size=UDim2.new(0,1,1,-50); div.Position=UDim2.new(0,136,0,50); div.BackgroundColor3=C.Border; div.BorderSizePixel=0; div.ZIndex=4; div.Parent=MF

-- Content area
local CA=Instance.new("Frame"); CA.Size=UDim2.new(1,-137,1,-50); CA.Position=UDim2.new(0,137,0,50); CA.BackgroundTransparency=1; CA.ClipsDescendants=true; CA.ZIndex=3; CA.Parent=MF

-- ══════════════════════════════════════
--            TAB SYSTEM
-- ══════════════════════════════════════
local TABS={} local PAGES={} local ACTIVE=nil
local TABDEF={
    {n="Nhặt Đồ",   i="🎁"},
    {n="Di Chuyển",  i="🏃"},
    {n="Chiến Đấu",  i="⚔"},
    {n="Hiển Thị",   i="👁"},
    {n="Thế Giới",   i="🌍"},
    {n="Tiện Ích",   i="⚙"},
}
local function switchTab(name)
    if ACTIVE==name then return end; ACTIVE=name
    for n,pg in pairs(PAGES) do pg.Visible=(n==name) end
    for n,b in pairs(TABS) do
        if n==name then
            b.BackgroundTransparency=0; tw(b,{BackgroundColor3=C.Acc},.18)
            b.TextColor3=Color3.fromRGB(20,10,0)
        else
            tw(b,{BackgroundTransparency=1},.18)
            b.TextColor3=C.TxtG
        end
    end
end
for i,t in ipairs(TABDEF) do
    local b=Instance.new("TextButton"); b.Size=UDim2.new(1,0,0,36); b.BackgroundColor3=C.Acc; b.BackgroundTransparency=1; b.Text=t.i.."  "..t.n; b.Font=Enum.Font.GothamSemibold; b.TextSize=11; b.TextColor3=C.TxtG; b.TextXAlignment=Enum.TextXAlignment.Left; b.LayoutOrder=i; b.ZIndex=5; b.Parent=SB; corner(b,7)
    local p2=Instance.new("UIPadding",b); p2.PaddingLeft=UDim.new(0,8)
    b.MouseEnter:Connect(function() if ACTIVE~=t.n then tw(b,{BackgroundColor3=Color3.fromRGB(32,26,52),BackgroundTransparency=0},.15) end end)
    b.MouseLeave:Connect(function() if ACTIVE~=t.n then tw(b,{BackgroundTransparency=1},.15) end end)
    local pg=Instance.new("ScrollingFrame"); pg.Size=UDim2.new(1,0,1,0); pg.BackgroundTransparency=1; pg.ScrollBarThickness=3; pg.ScrollBarImageColor3=C.Acc; pg.CanvasSize=UDim2.new(0,0,0,0); pg.Visible=false; pg.ZIndex=3; pg.Parent=CA
    local pgl=Instance.new("UIListLayout",pg); pgl.SortOrder=Enum.SortOrder.LayoutOrder; pgl.Padding=UDim.new(0,7)
    pgl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() pg.CanvasSize=UDim2.new(0,0,0,pgl.AbsoluteContentSize.Y+20) end)
    local pgp=Instance.new("UIPadding",pg); pgp.PaddingTop=UDim.new(0,12); pgp.PaddingLeft=UDim.new(0,12); pgp.PaddingRight=UDim.new(0,14)
    TABS[t.n]=b; PAGES[t.n]=pg
    b.MouseButton1Click:Connect(function() switchTab(t.n) end)
end

-- ══════════════════════════════════════
--       COMPONENT BUILDERS
-- ══════════════════════════════════════
local function mkSection(pg, txt)
    local f=Instance.new("Frame"); f.Size=UDim2.new(1,0,0,22); f.BackgroundTransparency=1; f.Parent=pg
    local ln=Instance.new("Frame"); ln.Size=UDim2.new(1,0,0,1); ln.Position=UDim2.new(0,0,.5,0); ln.BackgroundColor3=C.Border; ln.BorderSizePixel=0; ln.Parent=f
    local lb=Instance.new("TextLabel"); lb.Size=UDim2.new(0,0,1,0); lb.AutomaticSize=Enum.AutomaticSize.X; lb.BackgroundColor3=C.BG; lb.Text="  ▸ "..txt:upper().."  "; lb.Font=Enum.Font.GothamBold; lb.TextSize=10; lb.TextColor3=C.Acc; lb.ZIndex=4; lb.Parent=f
end

local function mkToggle(pg, lbl, desc, default, onCB, offCB)
    local state={v=default or false}
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0, desc and 46 or 40); row.BackgroundColor3=C.Card; row.Parent=pg; corner(row,9); stroke(row,C.Border,1)
    local mainLb=Instance.new("TextLabel"); mainLb.Size=UDim2.new(1,-62,0,22); mainLb.Position=UDim2.new(0,12,0,desc and 4 or 9); mainLb.BackgroundTransparency=1; mainLb.Text=lbl; mainLb.Font=Enum.Font.GothamBold; mainLb.TextSize=12; mainLb.TextColor3=C.TxtW; mainLb.TextXAlignment=Enum.TextXAlignment.Left; mainLb.Parent=row
    if desc then local dl=Instance.new("TextLabel"); dl.Size=UDim2.new(1,-62,0,14); dl.Position=UDim2.new(0,12,0,24); dl.BackgroundTransparency=1; dl.Text=desc; dl.Font=Enum.Font.Gotham; dl.TextSize=10; dl.TextColor3=C.TxtG; dl.TextXAlignment=Enum.TextXAlignment.Left; dl.Parent=row end
    local track=Instance.new("Frame"); track.Size=UDim2.new(0,44,0,24); track.Position=UDim2.new(1,-56,0.5,-12); track.BackgroundColor3=state.v and C.ON or C.OFF; track.Parent=row; corner(track,12)
    local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,18,0,18); thumb.Position=state.v and UDim2.new(1,-21,.5,-9) or UDim2.new(0,3,.5,-9); thumb.BackgroundColor3=Color3.fromRGB(255,255,255); thumb.Parent=track; corner(thumb,9)
    local function upd()
        tw(track,{BackgroundColor3=state.v and C.ON or C.OFF},.2)
        tw(thumb,{Position=state.v and UDim2.new(1,-21,.5,-9) or UDim2.new(0,3,.5,-9)},.22,Enum.EasingStyle.Back)
        if state.v then if onCB then onCB() end else if offCB then offCB() end end
    end
    local tb=Instance.new("TextButton"); tb.Size=UDim2.new(1,0,1,0); tb.BackgroundTransparency=1; tb.Text=""; tb.Parent=row
    tb.MouseButton1Click:Connect(function() state.v=not state.v; upd() end)
    row.MouseEnter:Connect(function() tw(row,{BackgroundColor3=C.CardHov},.15) end)
    row.MouseLeave:Connect(function() tw(row,{BackgroundColor3=C.Card},.15) end)
    return state
end

local function mkSlider(pg, lbl, min_, max_, def, cb)
    local val=def or min_; local drg=false
    local row=Instance.new("Frame"); row.Size=UDim2.new(1,0,0,54); row.BackgroundColor3=C.Card; row.Parent=pg; corner(row,9); stroke(row,C.Border,1)
    local top=Instance.new("Frame"); top.Size=UDim2.new(1,-22,0,26); top.Position=UDim2.new(0,11,0,0); top.BackgroundTransparency=1; top.Parent=row
    local lb=Instance.new("TextLabel"); lb.Size=UDim2.new(.7,0,1,0); lb.BackgroundTransparency=1; lb.Text=lbl; lb.Font=Enum.Font.GothamBold; lb.TextSize=12; lb.TextColor3=C.TxtW; lb.TextXAlignment=Enum.TextXAlignment.Left; lb.Parent=top
    local vl=Instance.new("TextLabel"); vl.Size=UDim2.new(.3,0,1,0); vl.Position=UDim2.new(.7,0,0,0); vl.BackgroundTransparency=1; vl.Text=tostring(val); vl.Font=Enum.Font.GothamBold; vl.TextSize=12; vl.TextColor3=C.Acc; vl.TextXAlignment=Enum.TextXAlignment.Right; vl.Parent=top
    local tr=Instance.new("Frame"); tr.Size=UDim2.new(1,-22,0,6); tr.Position=UDim2.new(0,11,0,36); tr.BackgroundColor3=Color3.fromRGB(36,30,58); tr.Parent=row; corner(tr,3)
    local fi=Instance.new("Frame"); fi.Size=UDim2.new((val-min_)/(max_-min_),0,1,0); fi.BackgroundColor3=C.Acc; fi.Parent=tr; corner(fi,3); grad(fi,C.Acc,C.AccD,0)
    local kn=Instance.new("Frame"); kn.Size=UDim2.new(0,14,0,14); kn.Position=UDim2.new((val-min_)/(max_-min_),-7,.5,-7); kn.BackgroundColor3=Color3.fromRGB(255,255,255); kn.Parent=tr; corner(kn,7)
    local sb=Instance.new("TextButton"); sb.Size=UDim2.new(1,0,1,0); sb.BackgroundTransparency=1; sb.Text=""; sb.Parent=tr
    local function setV(v)
        val=math.clamp(math.floor(v),min_,max_); local p=(val-min_)/(max_-min_)
        tw(fi,{Size=UDim2.new(p,0,1,0)},.06); tw(kn,{Position=UDim2.new(p,-7,.5,-7)},.06)
        vl.Text=tostring(val); if cb then cb(val) end
    end
    sb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end end)
    UserInputService.InputChanged:Connect(function(i) if drg and i.UserInputType==Enum.UserInputType.MouseMovement then setV(min_+math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)*(max_-min_)) end end)
    return {get=function()return val end, set=setV}
end

local function mkButton(pg, lbl, desc, colAcc, cb)
    local ac=colAcc or C.Acc; local ac2=colAcc and colAcc:Lerp(Color3.fromRGB(0,0,0),.25) or C.AccD
    local btn=Instance.new("TextButton"); btn.Size=UDim2.new(1,0,0, desc and 44 or 38); btn.BackgroundColor3=ac; btn.Text=""; btn.ZIndex=3; btn.Parent=pg; corner(btn,9); grad(btn,ac,ac2,140)
    local lb=Instance.new("TextLabel"); lb.Size=UDim2.new(1,-14,0,20); lb.Position=UDim2.new(0,14,0, desc and 5 or 9); lb.BackgroundTransparency=1; lb.Text=lbl; lb.Font=Enum.Font.GothamBold; lb.TextSize=13; lb.TextColor3=Color3.fromRGB(255,255,255); lb.TextXAlignment=Enum.TextXAlignment.Left; lb.ZIndex=4; lb.Parent=btn
    if desc then local dl=Instance.new("TextLabel"); dl.Size=UDim2.new(1,-14,0,14); dl.Position=UDim2.new(0,14,0,24); dl.BackgroundTransparency=1; dl.Text=desc; dl.Font=Enum.Font.Gotham; dl.TextSize=10; dl.TextColor3=Color3.fromRGB(220,220,200); dl.TextXAlignment=Enum.TextXAlignment.Left; dl.ZIndex=4; dl.Parent=btn end
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=ac:Lerp(Color3.fromRGB(255,255,255),.15)},.15) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=ac},.15) end)
    btn.MouseButton1Click:Connect(function()
        tw(btn,{Size=UDim2.new(.97,0,0,desc and 41 or 35)},.08)
        task.wait(.1); tw(btn,{Size=UDim2.new(1,0,0,desc and 44 or 38)},.18,Enum.EasingStyle.Back)
        if cb then cb() end
    end)
end

-- ══════════════════════════════════════════════════════
--   20 CHỨC NĂNG THẬT - CÓ LOOP LIÊN TỤC CHẠY ĐƯỢC
-- ══════════════════════════════════════════════════════

-- ╔═══════════════════════════════╗
-- ║       TAB 1: NHẶT ĐỒ         ║
-- ╚═══════════════════════════════╝
local P1 = PAGES["Nhặt Đồ"]

-- Hàm tìm object theo từ khóa
local function findObjects(keywords, maxDist)
    local root=GetRoot(); if not root then return {} end
    local found={}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n=obj.Name:lower()
            for _, kw in ipairs(keywords) do
                if n:find(kw) then
                    local pos = obj:IsA("Model") and (obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart) and obj:GetModelCFrame().Position or obj.Position
                    if pos then
                        local dist=(root.Position-pos).Magnitude
                        if dist<(maxDist or 999) then
                            table.insert(found,{obj=obj,pos=pos,dist=dist})
                        end
                    end
                    break
                end
            end
        end
    end
    table.sort(found,function(a,b)return a.dist<b.dist end)
    return found
end

-- Hàm tương tác với vật thể (multi-method)
local function interact(obj)
    pcall(function()
        -- Thử ClickDetector
        local cd = obj:FindFirstChildOfClass("ClickDetector") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ClickDetector"))
        if cd then fireclickdetector(cd); return end
        -- Thử ProximityPrompt
        local pp = obj:FindFirstChildOfClass("ProximityPrompt") or (obj.Parent and obj.Parent:FindFirstChildOfClass("ProximityPrompt"))
        if pp then fireproximityprompt(pp); return end
        -- Touch
        local root=GetRoot()
        if root and obj:IsA("BasePart") then
            firetouchinterest(root, obj, 0)
            task.wait(0.05)
            firetouchinterest(root, obj, 1)
        end
    end)
end

-- CHỨC NĂNG 1: Nhặt Rương Tự Động (loop liên tục)
mkSection(P1, "Nhặt Tự Động")
mkToggle(P1, "🎁  Tự Nhặt Rương", "Tự động tìm & nhặt rương liên tục", false,
    function() -- BẬT
        _G_FAM.AutoChest = true
        notify("🎁 Nhặt Rương BẬT", C.Green)
        task.spawn(function()
            while _G_FAM.AutoChest do
                local root = GetRoot()
                if root then
                    local found = findObjects({"chest","ruong","rương","treasure","box","coffer","storage","crate"}, 200)
                    for _, item in ipairs(found) do
                        if not _G_FAM.AutoChest then break end
                        root.CFrame = CFrame.new(item.pos + Vector3.new(0, 3, 0))
                        task.wait(0.15)
                        interact(item.obj)
                        task.wait(0.25)
                    end
                end
                task.wait(0.6)  -- quét lại sau 0.6s
            end
        end)
    end,
    function() -- TẮT
        _G_FAM.AutoChest = false
        notify("🎁 Nhặt Rương TẮT", C.Red)
    end
)

-- CHỨC NĂNG 2: Nhặt Trái Cây / Devil Fruit
mkToggle(P1, "🍎  Tự Nhặt Trái / Devil Fruit", "Tự tìm & nhặt trái trên bản đồ", false,
    function()
        _G_FAM.AutoFruit = true
        notify("🍎 Nhặt Trái BẬT", C.Green)
        task.spawn(function()
            while _G_FAM.AutoFruit do
                local root = GetRoot()
                if root then
                    local found = findObjects({"fruit","trai","trái","devil","df","fruta","kekkai","zoan","logia","paramecia"}, 500)
                    for _, item in ipairs(found) do
                        if not _G_FAM.AutoFruit then break end
                        root.CFrame = CFrame.new(item.pos + Vector3.new(0, 3, 0))
                        task.wait(0.2)
                        interact(item.obj)
                        task.wait(0.3)
                    end
                end
                task.wait(0.8)
            end
        end)
    end,
    function()
        _G_FAM.AutoFruit = false
        notify("🍎 Nhặt Trái TẮT", C.Red)
    end
)

-- CHỨC NĂNG 3: Nhặt Tiền & Drop
mkToggle(P1, "💰  Tự Nhặt Tiền / Drop", "Hút tiền & vật phẩm rơi liên tục", false,
    function()
        _G_FAM.AutoCoin = true
        notify("💰 Nhặt Tiền BẬT", C.Green)
        task.spawn(function()
            while _G_FAM.AutoCoin do
                local root = GetRoot()
                if root then
                    local found = findObjects({"coin","money","gold","drop","beri","bell","gem","crystal","tien","tiền","xu","berry","fragment","piece"}, 150)
                    for _, item in ipairs(found) do
                        if not _G_FAM.AutoCoin then break end
                        root.CFrame = CFrame.new(item.pos + Vector3.new(0,2,0))
                        task.wait(0.1)
                        interact(item.obj)
                        task.wait(0.15)
                    end
                end
                task.wait(0.5)
            end
        end)
    end,
    function()
        _G_FAM.AutoCoin = false
        notify("💰 Nhặt Tiền TẮT", C.Red)
    end
)

mkSection(P1, "Nhặt Nhanh")
mkButton(P1, "⚡  Hút Tất Cả Bán Kính 100m", "Nhặt mọi thứ 1 lần ngay lập tức", C.Blue, function()
    local root=GetRoot(); if not root then notify("❌ Không có nhân vật!",C.Red); return end
    local cnt=0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local dist=(root.Position-obj.Position).Magnitude
            if dist<100 then
                local n=obj.Name:lower()
                if n:find("fruit") or n:find("chest") or n:find("coin") or n:find("drop") or n:find("gold") or n:find("box") or n:find("gem") or n:find("beri") then
                    root.CFrame=CFrame.new(obj.Position+Vector3.new(0,3,0))
                    task.wait(0.1)
                    interact(obj)
                    cnt=cnt+1
                    task.wait(0.08)
                end
            end
        end
    end
    notify("✅ Đã nhặt "..cnt.." vật phẩm!", C.Green)
end)

mkButton(P1, "🗺  Teleport Tới Rương Gần Nhất", "Nhảy ngay đến rương gần nhất", C.Acc, function()
    local root=GetRoot(); if not root then return end
    local found=findObjects({"chest","ruong","rương","treasure","box","crate"},999)
    if #found>0 then
        root.CFrame=CFrame.new(found[1].pos+Vector3.new(0,4,0))
        notify("📦 Đã tới rương: "..found[1].obj.Name, C.Green)
    else notify("❌ Không tìm thấy rương nào!",C.Red) end
end)

-- ╔═══════════════════════════════╗
-- ║     TAB 2: DI CHUYỂN         ║
-- ╚═══════════════════════════════╝
local P2 = PAGES["Di Chuyển"]
mkSection(P2, "Chỉ Số Nhân Vật")

-- CHỨC NĂNG 4: Tốc Độ
mkSlider(P2, "🏃  Tốc Độ Chạy", 16, 300, 16, function(v)
    local h=GetHum(); if h then h.WalkSpeed=v end
end)

-- CHỨC NĂNG 5: Nhảy Cao
mkSlider(P2, "⬆  Lực Nhảy", 50, 500, 50, function(v)
    local h=GetHum(); if h then h.JumpPower=v end
end)

mkSection(P2, "Kỹ Năng")

-- CHỨC NĂNG 6: Nhảy Vô Hạn
mkToggle(P2, "♾  Nhảy Vô Hạn", "Nhảy liên tục không giới hạn", false,
    function()
        _G_FAM.InfJump=true; notify("♾ Nhảy Vô Hạn BẬT",C.Green)
        UserInputService.JumpRequest:Connect(function()
            if _G_FAM.InfJump then local h=GetHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
        end)
    end,
    function() _G_FAM.InfJump=false; notify("♾ Nhảy Vô Hạn TẮT",C.Red) end
)

-- CHỨC NĂNG 7: Bay
local flyConn, flyBV, flyAG
mkToggle(P2, "🦅  Bay (Fly Hack)", "Giữ Space để bay lên, Shift để bay xuống", false,
    function()
        _G_FAM.Fly=true; notify("🦅 Bay BẬT - [Space] lên | [Shift] xuống",C.Green)
        local root=GetRoot(); if not root then return end
        flyBV=Instance.new("BodyVelocity"); flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Velocity=Vector3.new(0,0,0); flyBV.Parent=root
        flyAG=Instance.new("BodyAngularVelocity"); flyAG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyAG.AngularVelocity=Vector3.new(0,0,0); flyAG.Parent=root
        local h=GetHum(); if h then h.PlatformStand=true end
        flyConn = RunService.RenderStepped:Connect(function()
            if not _G_FAM.Fly then return end
            local r=GetRoot(); if not r then return end
            local cam=workspace.CurrentCamera
            local dir=Vector3.new(0,0,0)
            local spd=_G_FAM.FlySpeed
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.new(0,1,0) end
            flyBV.Velocity = dir.Magnitude>0 and dir.Unit*spd or Vector3.new(0,0,0)
        end)
    end,
    function()
        _G_FAM.Fly=false; notify("🦅 Bay TẮT",C.Red)
        if flyConn then flyConn:Disconnect() end
        if flyBV and flyBV.Parent then flyBV:Destroy() end
        if flyAG and flyAG.Parent then flyAG:Destroy() end
        local h=GetHum(); if h then h.PlatformStand=false end
    end
)
mkSlider(P2,"✈  Tốc Độ Bay",10,200,50,function(v) _G_FAM.FlySpeed=v end)

-- CHỨC NĂNG 8: Noclip
local noclipConn
mkToggle(P2, "👻  Xuyên Tường (Noclip)", "Đi xuyên qua mọi vật thể", false,
    function()
        _G_FAM.Noclip=true; notify("👻 Noclip BẬT",C.Green)
        noclipConn=RunService.Stepped:Connect(function()
            if not _G_FAM.Noclip then return end
            local c=GetChar(); if not c then return end
            for _, p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=false end
            end
        end)
    end,
    function()
        _G_FAM.Noclip=false; notify("👻 Noclip TẮT",C.Red)
        if noclipConn then noclipConn:Disconnect() end
    end
)

mkSection(P2, "Teleport")
mkButton(P2,"🏠  Về Spawn (0,0,0)","Teleport về trung tâm bản đồ",C.Acc,function()
    local r=GetRoot(); if r then r.CFrame=CFrame.new(0,20,0); notify("🏠 Đã về Spawn!",C.Green) end
end)
mkButton(P2,"👆  Lên Cao (Sky)",nil,C.Blue,function()
    local r=GetRoot(); if r then r.CFrame=CFrame.new(r.Position+Vector3.new(0,200,0)); notify("☁ Đã bay lên cao!",C.Blue) end
end)

-- ╔═══════════════════════════════╗
-- ║     TAB 3: CHIẾN ĐẤU         ║
-- ╚═══════════════════════════════╝
local P3 = PAGES["Chiến Đấu"]
mkSection(P3, "Tấn Công Tự Động")

-- CHỨC NĂNG 9: Auto Farm NPC (Kill Aura)
mkToggle(P3, "⚔  Kill Aura (Giết NPC Tự Động)", "Tự đánh mọi NPC trong vòng bán kính", false,
    function()
        _G_FAM.KillAura=true; notify("⚔ Kill Aura BẬT",C.Green)
        task.spawn(function()
            while _G_FAM.KillAura do
                local root=GetRoot()
                if root then
                    local nearest,nearDist,nearHRP=nil,math.huge,nil
                    for _,obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj~=GetChar() then
                            local hum=obj:FindFirstChildOfClass("Humanoid")
                            local hrp=obj:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health>0 and not Players:GetPlayerFromCharacter(obj) then
                                local d=(root.Position-hrp.Position).Magnitude
                                if d<_G_FAM.KillRadius and d<nearDist then
                                    nearDist=d; nearest=obj; nearHRP=hrp
                                end
                            end
                        end
                    end
                    if nearHRP then
                        -- Teleport sát & tương tác tool
                        root.CFrame=CFrame.new(nearHRP.Position+Vector3.new(0,1.5,2.5))
                        local tool=GetChar() and GetChar():FindFirstChildOfClass("Tool")
                        if tool then
                            -- Kích hoạt tool qua remote
                            for _, v in ipairs(tool:GetDescendants()) do
                                if v:IsA("RemoteEvent") then pcall(function() v:FireServer(nearHRP.Position) end) end
                            end
                            -- Simulate click
                            local hitbox=nearHRP
                            pcall(function()
                                local uis=UserInputService
                                local inputObj=InputObject.new and InputObject.new() -- executor
                                tool:Activate()
                            end)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end,
    function() _G_FAM.KillAura=false; notify("⚔ Kill Aura TẮT",C.Red) end
)
mkSlider(P3,"🎯  Bán Kính Kill Aura",5,100,15,function(v) _G_FAM.KillRadius=v end)

-- CHỨC NĂNG 10: Auto Farm (Teleport Tới NPC Gần Nhất)
mkToggle(P3, "🤖  Auto Farm NPC", "Tự động tìm & tấn công NPC gần nhất", false,
    function()
        _G_FAM.AutoFarm=true; notify("🤖 Auto Farm BẬT",C.Green)
        task.spawn(function()
            while _G_FAM.AutoFarm do
                local root=GetRoot()
                if root then
                    local best,bestD=nil,math.huge
                    for _,obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj~=GetChar() then
                            local hum=obj:FindFirstChildOfClass("Humanoid")
                            local hrp=obj:FindFirstChild("HumanoidRootPart")
                            if hum and hrp and hum.Health>0 and not Players:GetPlayerFromCharacter(obj) then
                                local d=(root.Position-hrp.Position).Magnitude
                                if d<bestD then bestD=d; best=hrp end
                            end
                        end
                    end
                    if best then
                        root.CFrame=CFrame.new(best.Position+Vector3.new(0,1.5,3))
                        task.wait(0.15)
                        -- Kích tool
                        local char=GetChar()
                        if char then
                            local tool=char:FindFirstChildOfClass("Tool")
                            if tool then
                                pcall(function() tool:Activate() end)
                                for _,v in ipairs(tool:GetDescendants()) do
                                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                                        pcall(function() v:FireServer() end)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.4)
            end
        end)
    end,
    function() _G_FAM.AutoFarm=false; notify("🤖 Auto Farm TẮT",C.Red) end
)

mkSection(P3, "Mở Rộng Hitbox")

-- CHỨC NĂNG 11: Hitbox Expander
mkToggle(P3, "📦  Phóng To Hitbox Enemy", "Làm to hộp va chạm của kẻ địch", false,
    function()
        _G_FAM.HitboxExpand=true; notify("📦 Hitbox Expander BẬT",C.Green)
        task.spawn(function()
            while _G_FAM.HitboxExpand do
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr~=LP and plr.Character then
                        local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.Size=Vector3.new(_G_FAM.HitboxSize,_G_FAM.HitboxSize,_G_FAM.HitboxSize) end
                    end
                end
                -- NPC hitbox
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) and obj~=GetChar() then
                        local hum=obj:FindFirstChildOfClass("Humanoid")
                        local hrp=obj:FindFirstChild("HumanoidRootPart")
                        if hum and hrp then hrp.Size=Vector3.new(_G_FAM.HitboxSize,_G_FAM.HitboxSize,_G_FAM.HitboxSize) end
                    end
                end
                task.wait(0.5)
            end
        end)
    end,
    function() _G_FAM.HitboxExpand=false; notify("📦 Hitbox Expander TẮT",C.Red) end
)
mkSlider(P3,"📐  Kích Thước Hitbox",3,30,5,function(v) _G_FAM.HitboxSize=v end)

-- CHỨC NĂNG 12: Spin Bot
mkToggle(P3, "🌀  Spin Bot", "Nhân vật quay liên tục khi đánh", false,
    function()
        _G_FAM.SpinBot=true; notify("🌀 SpinBot BẬT",C.Green)
        task.spawn(function()
            local angle=0
            while _G_FAM.SpinBot do
                local root=GetRoot()
                if root then
                    angle=angle+_G_FAM.SpinSpeed
                    root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(angle),0)
                end
                task.wait(0.03)
            end
        end)
    end,
    function() _G_FAM.SpinBot=false; notify("🌀 SpinBot TẮT",C.Red) end
)
mkSlider(P3,"💫  Tốc Độ Quay",5,50,10,function(v) _G_FAM.SpinSpeed=v end)

-- ╔═══════════════════════════════╗
-- ║     TAB 4: HIỂN THỊ          ║
-- ╚═══════════════════════════════╝
local P4 = PAGES["Hiển Thị"]
local espObjects={}

mkSection(P4, "ESP Người Chơi")

-- CHỨC NĂNG 13: ESP Tên + Máu
mkToggle(P4, "🔲  ESP Người Chơi", "Hiện tên, máu, khoảng cách người chơi", false,
    function()
        _G_FAM.ESP=true; notify("🔲 ESP BẬT",C.Green)
        task.spawn(function()
            while _G_FAM.ESP do
                -- dọn cũ
                for _,h in pairs(espObjects) do pcall(function() h:Destroy() end) end
                espObjects={}
                local root=GetRoot()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr~=LP and plr.Character then
                        local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
                        local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                        if hrp and hum then
                            local dist=root and math.floor((root.Position-hrp.Position).Magnitude) or 0
                            local bb=Instance.new("BillboardGui"); bb.Size=UDim2.new(0,5,0,7); bb.StudsOffset=Vector3.new(0,3.5,0); bb.Adornee=hrp; bb.AlwaysOnTop=true; bb.Parent=hrp
                            -- Tên
                            local nameL=Instance.new("TextLabel"); nameL.Size=UDim2.new(1,0,0,18); nameL.BackgroundTransparency=1; nameL.Text="[ "..plr.Name.." ]"; nameL.Font=Enum.Font.GothamBold; nameL.TextSize=13; nameL.TextColor3=C.Acc; nameL.TextStrokeTransparency=0.4; nameL.Parent=bb
                            -- Máu
                            local hpL=Instance.new("TextLabel"); hpL.Size=UDim2.new(1,0,0,14); hpL.Position=UDim2.new(0,0,1,0); hpL.BackgroundTransparency=1
                            local hp=math.floor(hum.Health); local maxHp=math.floor(hum.MaxHealth)
                            local hpColor=hp>maxHp*.6 and C.Green or (hp>maxHp*.3 and C.Acc or C.Red)
                            hpL.Text="❤ "..hp.."/"..maxHp.."  📏 "..dist.."m"; hpL.Font=Enum.Font.Gotham; hpL.TextSize=10; hpL.TextColor3=hpColor; hpL.TextStrokeTransparency=0.4; hpL.Parent=bb
                            table.insert(espObjects,bb)
                        end
                    end
                end
                task.wait(0.5)
            end
            for _,h in pairs(espObjects) do pcall(function() h:Destroy() end) end
            espObjects={}
        end)
    end,
    function()
        _G_FAM.ESP=false; notify("🔲 ESP TẮT",C.Red)
        for _,h in pairs(espObjects) do pcall(function() h:Destroy() end) end
        espObjects={}
    end
)

-- CHỨC NĂNG 14: God Mode
mkSection(P4, "Nhân Vật")
mkToggle(P4, "💛  God Mode (Bất Tử)", "Tự hồi máu về tối đa liên tục", false,
    function()
        _G_FAM.GodMode=true; notify("💛 God Mode BẬT",C.Acc)
        task.spawn(function()
            while _G_FAM.GodMode do
                local h=GetHum()
                if h then h.Health=h.MaxHealth end
                task.wait(0.1)
            end
        end)
    end,
    function() _G_FAM.GodMode=false; notify("💛 God Mode TẮT",C.Red) end
)

-- ╔═══════════════════════════════╗
-- ║     TAB 5: THẾ GIỚI          ║
-- ╚═══════════════════════════════╝
local P5 = PAGES["Thế Giới"]
mkSection(P5, "Ánh Sáng")

local origLight={B=Lighting.Brightness,CT=Lighting.ClockTime,FE=Lighting.FogEnd,GS=Lighting.GlobalShadows,AM=Lighting.Ambient}

-- CHỨC NĂNG 15: Full Bright
mkToggle(P5, "☀  Toàn Sáng (Full Bright)", "Làm sáng toàn bộ bản đồ", false,
    function()
        _G_FAM.FullBright=true; notify("☀ Full Bright BẬT",C.Acc)
        Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=1e6; Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    end,
    function()
        _G_FAM.FullBright=false; notify("☀ Full Bright TẮT",C.Red)
        Lighting.Brightness=origLight.B; Lighting.ClockTime=origLight.CT; Lighting.FogEnd=origLight.FE
        Lighting.GlobalShadows=origLight.GS; Lighting.Ambient=origLight.AM
    end
)

-- CHỨC NĂNG 16: Remove Fog
mkToggle(P5, "🌫  Xóa Sương Mù", "Loại bỏ hoàn toàn fog trong game", false,
    function()
        _G_FAM.RemoveFog=true; notify("🌫 Remove Fog BẬT",C.Green)
        Lighting.FogEnd=1e9; Lighting.FogStart=1e9
        for _,v in ipairs(Lighting:GetChildren()) do if v:IsA("FogEffect") or v:IsA("Atmosphere") then v.Density=0 end end
    end,
    function()
        _G_FAM.RemoveFog=false; notify("🌫 Remove Fog TẮT",C.Red)
        Lighting.FogEnd=origLight.FE
    end
)

mkSection(P5, "Thời Gian")
mkButton(P5,"🌅  Bình Minh",nil,Color3.fromRGB(255,140,60),function() Lighting.ClockTime=6; notify("🌅 Bình Minh") end)
mkButton(P5,"☀  Buổi Trưa",nil,Color3.fromRGB(255,200,50),function() Lighting.ClockTime=12; notify("☀ Buổi Trưa") end)
mkButton(P5,"🌆  Buổi Chiều",nil,Color3.fromRGB(230,130,40),function() Lighting.ClockTime=18; notify("🌆 Buổi Chiều") end)
mkButton(P5,"🌙  Ban Đêm",nil,Color3.fromRGB(60,80,160),function() Lighting.ClockTime=0; notify("🌙 Ban Đêm") end)

-- ╔═══════════════════════════════╗
-- ║     TAB 6: TIỆN ÍCH          ║
-- ╚═══════════════════════════════╝
local P6 = PAGES["Tiện Ích"]
mkSection(P6, "Hỗ Trợ")

-- CHỨC NĂNG 17: Anti AFK
mkToggle(P6, "⏰  Chống AFK", "Không bị kick do đứng yên", false,
    function()
        _G_FAM.AntiAFK=true; notify("⏰ Anti AFK BẬT",C.Green)
        LP.Idled:Connect(function()
            if _G_FAM.AntiAFK then
                local vu=game:GetService("VirtualUser")
                vu:CaptureController(); vu:ClickButton2(Vector2.new())
            end
        end)
    end,
    function() _G_FAM.AntiAFK=false; notify("⏰ Anti AFK TẮT",C.Red) end
)

-- CHỨC NĂNG 18: Auto Quest / NPC Talk
mkToggle(P6, "📜  Auto Quest (Talk NPC)", "Tự tương tác NPC nhận quest", false,
    function()
        _G_FAM.AutoQuest=true; notify("📜 Auto Quest BẬT",C.Green)
        task.spawn(function()
            while _G_FAM.AutoQuest do
                local root=GetRoot()
                if root then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if not _G_FAM.AutoQuest then break end
                        local n=obj.Name:lower()
                        if n:find("npc") or n:find("quest") or n:find("mission") or n:find("nhiem") or n:find("nhiệm") then
                            local hrp=obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist=(root.Position-hrp.Position).Magnitude
                                if dist<10 then interact(obj) end
                            end
                        end
                    end
                end
                task.wait(1.5)
            end
        end)
    end,
    function() _G_FAM.AutoQuest=false; notify("📜 Auto Quest TẮT",C.Red) end
)

mkSection(P6, "Thông Tin")

-- CHỨC NĂNG 19: Copy User ID + Info
mkButton(P6,"📋  Copy UserID","Sao chép ID người chơi của bạn",C.Blue,function()
    local id=tostring(LP.UserId)
    pcall(function() setclipboard(id) end)
    notify("📋 UserID: "..id.." ✓ (Đã sao chép!)",C.Blue)
end)

mkButton(P6,"👥  Xem Server Info","Hiện số người & PlaceID hiện tại",C.Acc,function()
    local cnt=#Players:GetPlayers()
    local pid=game.PlaceId
    notify("👥 "..cnt.." người | Place: "..pid,C.Acc)
end)

-- CHỨC NĂNG 20: Rejoin / Teleport Server
mkSection(P6, "Server")
mkButton(P6,"🔄  Rejoin Server","Vào lại server hiện tại nhanh",C.Green,function()
    notify("🔄 Đang rejoin...",C.Green)
    task.wait(0.8); TeleportService:Teleport(game.PlaceId,LP)
end)
mkButton(P6,"🎲  Server Mới (Random)","Chuyển sang server khác ngẫu nhiên",Color3.fromRGB(150,60,255),function()
    notify("🎲 Đang chuyển server...",Color3.fromRGB(180,80,255))
    task.wait(0.8)
    pcall(function()
        local servers={}
        for _,v in ipairs(game:GetService("HttpService"):JSONDecode(
            game:GetService("HttpService"):GetAsync("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=10")
        ).data) do table.insert(servers,v) end
        if #servers>0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId,servers[math.random(#servers)].id,LP)
        end
    end)
end)

-- ══════════════════════════════════════
--       ANIMATION MỞ + TAB MẶC ĐỊNH
-- ══════════════════════════════════════
MF.Size=UDim2.new(0,570,0,0); MF.Position=UDim2.new(0.5,-285,0.5,0)
tw(MF,{Size=UDim2.new(0,570,0,450),Position=UDim2.new(0.5,-285,0.5,-225)},.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
task.wait(0.15); switchTab("Nhặt Đồ")
task.wait(0.5); notify("✅  FAM LV MENU v3.0 đã tải xong!", C.Green)

-- PHÍM TẮT TOGGLE [RightShift]
local menuOpen=true
UserInputService.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        menuOpen=not menuOpen
        if menuOpen then
            MF.Visible=true
            tw(MF,{Size=UDim2.new(0,570,0,450),Position=UDim2.new(0.5,-285,0.5,-225)},.35,Enum.EasingStyle.Back)
        else
            tw(MF,{Size=UDim2.new(0,570,0,0),Position=UDim2.new(0.5,-285,0.5,0)},.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
            task.wait(.24); MF.Visible=false
        end
    end
end)

-- Auto respawn char ref
LP.CharacterAdded:Connect(function(c)
    Char=c
    -- tắt noclip khi respawn tránh bug
    _G_FAM.Noclip=false
end)

warn("✅ [FAM LV MENU v3.0] 20 Chức Năng VIP | RightShift ẩn/hiện")
