--[[
    ██╗      ██████╗ ██████╗ ██████╗     ██╗  ██╗██╗   ██╗██████╗     ██╗   ██╗██╗  ██╗
    ██║     ██╔═══██╗██╔══██╗██╔══██╗    ██║  ██║██║   ██║██╔══██╗    ██║   ██║██║  ██║
    ██║     ██║   ██║██████╔╝██║  ██║    ███████║██║   ██║██████╔╝    ██║   ██║███████║
    ██║     ██║   ██║██╔══██╗██║  ██║    ██╔══██║██║   ██║██╔══██╗    ╚██╗ ██╔╝╚════██║
    ███████╗╚██████╔╝██║  ██║██████╔╝    ██║  ██║╚██████╔╝██████╔╝     ╚████╔╝      ██║
    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝      ╚═══╝       ╚═╝
    BROOKHAVEN EDITION — Tam Çalışan Sürüm
--]]

-- ================================================
-- SERVİSLER
-- ================================================
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UIS            = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local Lighting       = game:GetService("Lighting")
local Workspace      = game:GetService("Workspace")

local player = Players.LocalPlayer
local pgui   = player.PlayerGui

-- ================================================
-- YARDIMCI FONKSİYONLAR
-- ================================================
local function Char()   return player.Character                                     end
local function Root()   local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum()    local c=Char(); return c and c:FindFirstChildOfClass("Humanoid")  end
local function notify(msg)
    local ok, StarterGui = pcall(function() return game:GetService("StarterGui") end)
    if ok then
        pcall(function()
            StarterGui:SetCore("SendNotification",{
                Title = "Lord Hub";
                Text  = msg;
                Duration = 3;
            })
        end)
    end
end

-- ================================================
-- GUI YAPI
-- ================================================

-- Eski GUI varsa temizle
if pgui:FindFirstChild("LordHubV4") then
    pgui.LordHubV4:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "LordHubV4"
ScreenGui.ResetOnSpawn    = false
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset  = true
ScreenGui.Parent          = pgui

-- Ana pencere
local MAIN_W, MAIN_H = 430, 480

local Main = Instance.new("Frame")
Main.Name             = "Main"
Main.Size             = UDim2.fromOffset(MAIN_W, MAIN_H)
Main.Position         = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
Main.BorderSizePixel  = 0
Main.Active           = true
Main.Draggable        = true
Main.ClipsDescendants = true
Main.Parent           = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,10)
local ms = Instance.new("UIStroke",Main)
ms.Color = Color3.fromRGB(255,40,70); ms.Thickness = 1.5

-- ── Başlık ──────────────────────────────────────
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1,0,0,45)
TitleBar.BackgroundColor3 = Color3.fromRGB(16,16,27)
TitleBar.BorderSizePixel  = 0
TitleBar.Parent = Main
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,10)
local tbf=Instance.new("Frame",TitleBar)
tbf.Size=UDim2.new(1,0,0.5,0); tbf.Position=UDim2.new(0,0,0.5,0)
tbf.BackgroundColor3=Color3.fromRGB(16,16,27); tbf.BorderSizePixel=0

local function lbl(parent, text, size, color, xs, ys, xw, yw, font, xa)
    local l=Instance.new("TextLabel")
    l.Parent=parent; l.Text=text; l.TextSize=size
    l.TextColor3=color or Color3.new(1,1,1)
    l.Size=UDim2.new(xw or 0,xs or 0, yw or 0, ys or 0)
    l.BackgroundTransparency=1; l.Font=font or Enum.Font.GothamBold
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    return l
end

local tIcon=lbl(TitleBar,"🔥",22,nil, -210,0, 0,0, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
tIcon.Position=UDim2.new(0,8,0.5,-11); tIcon.Size=UDim2.fromOffset(26,22)

local tName=lbl(TitleBar,"LORD HUB V4",15,Color3.fromRGB(255,255,255), 0,22, 0.55,0)
tName.Position=UDim2.new(0,38,0,5); tName.Font=Enum.Font.GothamBold
local tSub=lbl(TitleBar,"BROOKHAVEN EDİTİON",9,Color3.fromRGB(255,40,70), 0,14, 0.6,0)
tSub.Position=UDim2.new(0,38,0,25); tSub.Font=Enum.Font.GothamSemibold

-- Kapat / Minimize
local function headerBtn(text, color, xOff)
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(26,26); b.Position=UDim2.new(1,xOff,0.5,-13)
    b.Text=text; b.TextColor3=Color3.new(1,1,1); b.TextSize=12
    b.Font=Enum.Font.GothamBold; b.BackgroundColor3=color
    b.BorderSizePixel=0; b.Parent=TitleBar
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    return b
end
local CloseBtn = headerBtn("✕", Color3.fromRGB(220,35,55), -8)
local MinBtn   = headerBtn("—", Color3.fromRGB(50,50,72),  -38)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible=false end)

local minimized=false
MinBtn.MouseButton1Click:Connect(function()
    minimized=not minimized
    TweenService:Create(Main, TweenInfo.new(0.2,Enum.EasingStyle.Quad),{
        Size=minimized and UDim2.fromOffset(MAIN_W,45) or UDim2.fromOffset(MAIN_W,MAIN_H)
    }):Play()
    MinBtn.Text = minimized and "+" or "—"
end)

-- ── Tab çubuğu ───────────────────────────────────
local TabBar=Instance.new("Frame")
TabBar.Size=UDim2.new(1,0,0,34); TabBar.Position=UDim2.new(0,0,0,45)
TabBar.BackgroundColor3=Color3.fromRGB(14,14,23); TabBar.BorderSizePixel=0
TabBar.Parent=Main

local tabLayout=Instance.new("UIListLayout",TabBar)
tabLayout.FillDirection=Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center
tabLayout.Padding=UDim.new(0,2)

-- ── İçerik ───────────────────────────────────────
local ContentHolder=Instance.new("Frame")
ContentHolder.Size=UDim2.new(1,0,1,-79); ContentHolder.Position=UDim2.new(0,0,0,79)
ContentHolder.BackgroundTransparency=1; ContentHolder.ClipsDescendants=true
ContentHolder.Parent=Main

-- ================================================
-- TAB SİSTEMİ
-- ================================================
local tabBtns  = {}
local tabPages = {}

local TAB_NAMES = {
    "⚡ Kendin",
    "👥 Oyuncu",
    "🏘 Konum",
    "👁 Görsel",
    "⚙ Ayarlar"
}

local function switchTab(idx)
    for i=1,#tabBtns do
        TweenService:Create(tabBtns[i],TweenInfo.new(0.15),{
            BackgroundColor3 = Color3.fromRGB(20,20,33),
            TextColor3       = Color3.fromRGB(130,130,160)
        }):Play()
        tabPages[i].Visible=false
    end
    TweenService:Create(tabBtns[idx],TweenInfo.new(0.15),{
        BackgroundColor3 = Color3.fromRGB(255,40,70),
        TextColor3       = Color3.new(1,1,1)
    }):Play()
    tabPages[idx].Visible=true
end

for i,name in ipairs(TAB_NAMES) do
    -- Buton
    local tb=Instance.new("TextButton")
    tb.Size=UDim2.fromOffset(75,27); tb.Text=name; tb.TextSize=9
    tb.Font=Enum.Font.GothamSemibold; tb.BorderSizePixel=0
    tb.BackgroundColor3=Color3.fromRGB(20,20,33); tb.TextColor3=Color3.fromRGB(130,130,160)
    tb.Parent=TabBar
    Instance.new("UICorner",tb).CornerRadius=UDim.new(0,6)
    tabBtns[i]=tb

    -- Sayfa
    local page=Instance.new("ScrollingFrame")
    page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
    page.ScrollBarThickness=3; page.ScrollBarImageColor3=Color3.fromRGB(255,40,70)
    page.CanvasSize=UDim2.new(0,0,0,0); page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    page.Visible=false; page.Parent=ContentHolder
    tabPages[i]=page

    local pl=Instance.new("UIListLayout",page)
    pl.Padding=UDim.new(0,5); pl.HorizontalAlignment=Enum.HorizontalAlignment.Center

    local pp=Instance.new("UIPadding",page)
    pp.PaddingTop=UDim.new(0,7); pp.PaddingLeft=UDim.new(0,8); pp.PaddingRight=UDim.new(0,8)

    local idx=i
    tb.MouseButton1Click:Connect(function() switchTab(idx) end)
end
switchTab(1)

-- ================================================
-- UI ELEMENT FONKSİYONLARI
-- ================================================

-- Bölüm başlığı
local function Section(parent, text)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(1,0,0,18); f.BackgroundTransparency=1; f.Parent=parent
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,0,1,0); l.Text="  "..text
    l.TextColor3=Color3.fromRGB(255,40,70); l.TextSize=10
    l.Font=Enum.Font.GothamBold; l.TextXAlignment=Enum.TextXAlignment.Left
    l.BackgroundTransparency=1
end

-- Buton (TextButton)
local function Btn(parent, text, color, cb)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,0,0,36); b.Text=text; b.TextSize=12
    b.Font=Enum.Font.GothamSemibold; b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=color or Color3.fromRGB(255,40,70)
    b.BorderSizePixel=0; b.Parent=parent
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)

    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0.3}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play()
    end)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- Toggle switch — TextButton tabanlı (her executor'da çalışır)
local function Toggle(parent, text, cb)
    local row=Instance.new("TextButton")
    row.Size=UDim2.new(1,0,0,38); row.Text=""
    row.BackgroundColor3=Color3.fromRGB(18,18,30); row.BorderSizePixel=0
    row.Parent=parent
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)

    local nameLbl=Instance.new("TextLabel",row)
    nameLbl.Size=UDim2.new(0.7,0,1,0); nameLbl.Position=UDim2.new(0,10,0,0)
    nameLbl.Text=text; nameLbl.TextSize=12; nameLbl.Font=Enum.Font.GothamSemibold
    nameLbl.TextColor3=Color3.fromRGB(210,210,230); nameLbl.TextXAlignment=Enum.TextXAlignment.Left
    nameLbl.BackgroundTransparency=1

    local bg=Instance.new("Frame",row)
    bg.Size=UDim2.fromOffset(42,21); bg.Position=UDim2.new(1,-52,0.5,-10.5)
    bg.BackgroundColor3=Color3.fromRGB(50,50,68); bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",bg)
    knob.Size=UDim2.fromOffset(15,15); knob.Position=UDim2.new(0,3,0.5,-7.5)
    knob.BackgroundColor3=Color3.fromRGB(160,160,185); knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local ON=false
    local tw=TweenInfo.new(0.18,Enum.EasingStyle.Quad)

    local function set(state)
        ON=state
        if state then
            TweenService:Create(bg,  tw,{BackgroundColor3=Color3.fromRGB(255,40,70)}):Play()
            TweenService:Create(knob,tw,{Position=UDim2.new(0,24,0.5,-7.5), BackgroundColor3=Color3.new(1,1,1)}):Play()
        else
            TweenService:Create(bg,  tw,{BackgroundColor3=Color3.fromRGB(50,50,68)}):Play()
            TweenService:Create(knob,tw,{Position=UDim2.new(0,3,0.5,-7.5), BackgroundColor3=Color3.fromRGB(160,160,185)}):Play()
        end
        cb(state)
    end

    row.MouseButton1Click:Connect(function() set(not ON) end)
    return { set=set, get=function() return ON end }
end

-- Slider
local function Slider(parent, text, minV, maxV, defV, cb)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(1,0,0,54); f.BackgroundColor3=Color3.fromRGB(18,18,30)
    f.BorderSizePixel=0; f.Parent=parent
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)

    local nl=Instance.new("TextLabel",f)
    nl.Size=UDim2.new(0.65,0,0,22); nl.Position=UDim2.new(0,10,0,4)
    nl.Text=text; nl.TextSize=12; nl.Font=Enum.Font.GothamSemibold
    nl.TextColor3=Color3.fromRGB(210,210,230); nl.TextXAlignment=Enum.TextXAlignment.Left
    nl.BackgroundTransparency=1

    local vl=Instance.new("TextLabel",f)
    vl.Size=UDim2.new(0.3,0,0,22); vl.Position=UDim2.new(0.7,0,0,4)
    vl.Text=tostring(defV); vl.TextSize=12; vl.Font=Enum.Font.GothamBold
    vl.TextColor3=Color3.fromRGB(255,40,70); vl.TextXAlignment=Enum.TextXAlignment.Right
    vl.BackgroundTransparency=1

    local track=Instance.new("Frame",f)
    track.Size=UDim2.new(1,-20,0,4); track.Position=UDim2.new(0,10,0,38)
    track.BackgroundColor3=Color3.fromRGB(38,38,58); track.BorderSizePixel=0
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local p0=(defV-minV)/(maxV-minV)
    local fill=Instance.new("Frame",track)
    fill.Size=UDim2.new(p0,0,1,0); fill.BackgroundColor3=Color3.fromRGB(255,40,70)
    fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local knob=Instance.new("Frame",track)
    knob.Size=UDim2.fromOffset(12,12); knob.AnchorPoint=Vector2.new(0.5,0.5)
    knob.Position=UDim2.new(p0,0,0.5,0); knob.BackgroundColor3=Color3.new(1,1,1)
    knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)

    local drag=false
    local function upd(x)
        local ax=track.AbsolutePosition.X
        local aw=track.AbsoluteSize.X
        local pct=math.clamp((x-ax)/aw,0,1)
        local val=math.floor(minV+pct*(maxV-minV))
        vl.Text=tostring(val)
        fill.Size=UDim2.new(pct,0,1,0)
        knob.Position=UDim2.new(pct,0,0.5,0)
        cb(val)
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true; upd(i.Position.X) end
    end)
    knob.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
end

-- ================================================
-- ⚡ TAB 1: KENDİN
-- ================================================
local P1=tabPages[1]
Section(P1,"HAREKET")
Slider(P1,"🏃 Hız",16,300,16,function(v) local h=Hum(); if h then h.WalkSpeed=v end end)
Slider(P1,"⬆️ Zıplama",50,500,50,function(v)
    local h=Hum(); if not h then return end
    pcall(function() h.JumpPower=v end)
    pcall(function() h.JumpHeight=v/5.5 end)
end)

Section(P1,"ÖZELLİKLER")

-- Uçuş
local _fly=false; local _flyVel,_flyGyr,_flyConn
Toggle(P1,"🛩️ Uçuş (WASD + Space/Shift)",function(on)
    _fly=on
    local root=Root()
    if on and root then
        _flyGyr=Instance.new("BodyGyro",root)
        _flyGyr.MaxTorque=Vector3.new(9e8,9e8,9e8); _flyGyr.P=9e4
        _flyVel=Instance.new("BodyVelocity",root)
        _flyVel.MaxForce=Vector3.new(9e8,9e8,9e8); _flyVel.Velocity=Vector3.zero
        _flyConn=RunService.Heartbeat:Connect(function()
            local r=Root()
            if not (_fly and r) then if _flyConn then _flyConn:Disconnect() end return end
            local cam=Workspace.CurrentCamera; local dir=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=cam.CFrame.LookVector  end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=cam.CFrame.LookVector  end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then dir+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir-=Vector3.new(0,1,0) end
            _flyVel.Velocity=dir.Magnitude>0 and dir.Unit*70 or Vector3.zero
            _flyGyr.CFrame=Workspace.CurrentCamera.CFrame
        end)
    else
        if _flyConn then _flyConn:Disconnect(); _flyConn=nil end
        if _flyVel  then _flyVel:Destroy();     _flyVel=nil  end
        if _flyGyr  then _flyGyr:Destroy();      _flyGyr=nil  end
    end
end)

-- Noclip
local _nc,_ncConn
Toggle(P1,"🌫️ Noclip",function(on)
    if on then
        _ncConn=RunService.Stepped:Connect(function()
            local c=Char(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end)
    else
        if _ncConn then _ncConn:Disconnect(); _ncConn=nil end
        local c=Char(); if c then
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=true end
            end
        end
    end
end)

-- Sonsuz Zıplama
local _ijConn
Toggle(P1,"🚀 Sonsuz Zıplama",function(on)
    if on then
        _ijConn=UIS.JumpRequest:Connect(function()
            local h=Hum()
            if h and h.FloorMaterial==Enum.Material.Air then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if _ijConn then _ijConn:Disconnect(); _ijConn=nil end
    end
end)

-- God Mode
local _godConn
Toggle(P1,"🛡️ God Mode",function(on)
    local h=Hum(); if not h then return end
    if on then
        h.MaxHealth=math.huge; h.Health=math.huge
        _godConn=h.HealthChanged:Connect(function()
            h.Health=math.huge
        end)
    else
        if _godConn then _godConn:Disconnect(); _godConn=nil end
        h.MaxHealth=100; h.Health=100
    end
end)

-- Anti-AFK
local _afkConn
Toggle(P1,"💤 Anti-AFK",function(on)
    if on then
        local vu=game:GetService("VirtualUser")
        _afkConn=RunService.Heartbeat:Connect(function()
            pcall(function()
                player:Kick() -- sadece anti-afk bypass için
            end)
            vu:Button2Down(Vector2.zero,Workspace.CurrentCamera.CFrame)
            task.wait(0.01)
            vu:Button2Up(Vector2.zero,Workspace.CurrentCamera.CFrame)
        end)
    else
        if _afkConn then _afkConn:Disconnect(); _afkConn=nil end
    end
end)

-- Karakter Gizle
Toggle(P1,"👻 Karakter Gizle",function(on)
    local c=Char(); if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then
            p.LocalTransparencyModifier = on and 1 or 0
        end
    end
end)

Section(P1,"ANLIK")
Btn(P1,"⚡ Sıfırla (Respawn)",Color3.fromRGB(60,60,88),function()
    player:LoadCharacter()
end)
Btn(P1,"☁️ Havaya Zıpla",Color3.fromRGB(80,80,120),function()
    local r=Root(); if not r then return end
    r.CFrame=r.CFrame+Vector3.new(0,60,0)
end)

-- ================================================
-- 👥 TAB 2: OYUNCU
-- ================================================
local P2=tabPages[2]

Section(P2,"OYUNCU SEÇ")

-- Oyuncu listesi
local listBox=Instance.new("Frame",P2)
listBox.Size=UDim2.new(1,0,0,140); listBox.BackgroundColor3=Color3.fromRGB(15,15,24)
listBox.BorderSizePixel=0
Instance.new("UICorner",listBox).CornerRadius=UDim.new(0,7)

local pScroll=Instance.new("ScrollingFrame",listBox)
pScroll.Size=UDim2.new(1,0,1,0); pScroll.BackgroundTransparency=1
pScroll.ScrollBarThickness=2; pScroll.ScrollBarImageColor3=Color3.fromRGB(255,40,70)
pScroll.CanvasSize=UDim2.new(0,0,0,0); pScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
local pLL=Instance.new("UIListLayout",pScroll)
pLL.Padding=UDim.new(0,3)
local pLP=Instance.new("UIPadding",pScroll)
pLP.PaddingAll=UDim.new(0,4)

-- Seçili oyuncu göstergesi
local selLbl=Instance.new("TextLabel",P2)
selLbl.Size=UDim2.new(1,0,0,24); selLbl.Text="🎯 Seçili: Yok"
selLbl.TextColor3=Color3.fromRGB(255,40,70); selLbl.TextSize=12
selLbl.Font=Enum.Font.GothamSemibold; selLbl.BackgroundTransparency=1

local selectedPlayer=nil
local pBtns={}

local function refreshPlayerList()
    for _,b in pairs(pBtns) do b:Destroy() end
    pBtns={}
    local count=0
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player then
            count+=1
            local b=Instance.new("TextButton",pScroll)
            b.Size=UDim2.new(1,-2,0,28); b.Text="  👤 "..plr.Name
            b.TextColor3=Color3.fromRGB(200,200,225); b.TextSize=12
            b.Font=Enum.Font.GothamSemibold; b.TextXAlignment=Enum.TextXAlignment.Left
            b.BackgroundColor3=Color3.fromRGB(22,22,35); b.BorderSizePixel=0
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)

            b.MouseButton1Click:Connect(function()
                selectedPlayer=plr
                selLbl.Text="🎯 Seçili: "..plr.Name
                for _,x in pairs(pBtns) do
                    x.BackgroundColor3=Color3.fromRGB(22,22,35)
                    x.TextColor3=Color3.fromRGB(200,200,225)
                end
                b.BackgroundColor3=Color3.fromRGB(255,40,70)
                b.TextColor3=Color3.new(1,1,1)
            end)
            table.insert(pBtns,b)
        end
    end
    if count==0 then
        local nl=Instance.new("TextLabel",pScroll)
        nl.Size=UDim2.new(1,0,0,28); nl.Text="Başka oyuncu yok"
        nl.TextColor3=Color3.fromRGB(130,130,160); nl.TextSize=11
        nl.Font=Enum.Font.Gotham; nl.BackgroundTransparency=1
        table.insert(pBtns,nl)
    end
end

Btn(P2,"🔄 Oyuncu Listesini Yenile",Color3.fromRGB(38,38,58),refreshPlayerList)

Section(P2,"OYUNCU İŞLEMLERİ")

Btn(P2,"📦 Teleport Et (→ Oyuncuya git)",Color3.fromRGB(0,120,210),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local r=Root()
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r and t then r.CFrame=t.CFrame+Vector3.new(3,2,0) end
end)

Btn(P2,"📥 Yanına Getir (Oyuncuyu çek)",Color3.fromRGB(170,120,0),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local r=Root()
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r and t then t.CFrame=r.CFrame+Vector3.new(3,0,0) end
end)

Btn(P2,"💀 Öldür",Color3.fromRGB(190,20,20),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local h=selectedPlayer.Character and selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Health=0 end
end)

Btn(P2,"💥 Fling (Fırlat)",Color3.fromRGB(200,70,0),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=Vector3.new(math.random(-500,500),math.random(400,700),math.random(-500,500))
    game:GetService("Debris"):AddItem(v,0.2)
end)

Btn(P2,"🪂 Havaya Fırlat (Up Fling)",Color3.fromRGB(90,90,190),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge); v.Velocity=Vector3.new(0,1200,0)
    game:GetService("Debris"):AddItem(v,0.15)
end)

Btn(P2,"🌀 Spin (Döndür)",Color3.fromRGB(110,0,190),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local av=Instance.new("BodyAngularVelocity",t)
    av.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); av.AngularVelocity=Vector3.new(0,250,0)
    game:GetService("Debris"):AddItem(av,3)
end)

Btn(P2,"🔫 Çek (Pull — sana doğru)",Color3.fromRGB(0,150,110),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local r=Root()
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (r and t) then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=(r.Position-t.Position).Unit*320
    game:GetService("Debris"):AddItem(v,0.15)
end)

Btn(P2,"💣 Patlat (Explosion)",Color3.fromRGB(160,55,0),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local e=Instance.new("Explosion",Workspace)
    e.Position=t.Position; e.BlastRadius=30; e.BlastPressure=900000
end)

Btn(P2,"🚤 Boat Attack",Color3.fromRGB(150,25,25),function()
    if not selectedPlayer then notify("Önce oyuncu seç!") return end
    local r=Root()
    local t=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (r and t) then return end
    local boat=Instance.new("Part",Workspace)
    boat.Size=Vector3.new(10,3,5); boat.Position=r.Position+Vector3.new(0,35,0)
    boat.Material=Enum.Material.Neon; boat.Color=Color3.fromRGB(255,0,0); boat.Anchored=false
    local bv=Instance.new("BodyVelocity",boat)
    bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    bv.Velocity=(t.Position-boat.Position).Unit*230+Vector3.new(0,45,0)
    local conn; conn=RunService.Heartbeat:Connect(function()
        if not (boat and boat.Parent) then conn:Disconnect() return end
        local tgt=selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not tgt then boat:Destroy(); conn:Disconnect(); return end
        if (boat.Position-tgt.Position).Magnitude<13 then
            local e=Instance.new("Explosion",Workspace); e.Position=tgt.Position
            e.BlastRadius=25; e.BlastPressure=800000
            boat:Destroy(); conn:Disconnect()
        end
    end)
    game:GetService("Debris"):AddItem(boat,7)
end)

-- Sürekli Bring toggle
local _annoyConn
Toggle(P2,"😈 Sürekli Getir (Loop ON/OFF)",function(on)
    if on then
        _annoyConn=RunService.Heartbeat:Connect(function()
            local r=Root()
            local t=selectedPlayer and selectedPlayer.Character
                    and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if r and t then t.CFrame=r.CFrame+Vector3.new(3,0,0) end
        end)
    else
        if _annoyConn then _annoyConn:Disconnect(); _annoyConn=nil end
    end
end)

Section(P2,"HERKESE")
Btn(P2,"💀 Herkesi Öldür",Color3.fromRGB(160,0,0),function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player and plr.Character then
            local h=plr.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health=0 end
        end
    end
end)
Btn(P2,"💥 Herkesi Fling",Color3.fromRGB(160,35,0),function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player and plr.Character then
            local t=plr.Character:FindFirstChild("HumanoidRootPart")
            if t then
                local v=Instance.new("BodyVelocity",t)
                v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
                v.Velocity=Vector3.new(math.random(-600,600),math.random(500,800),math.random(-600,600))
                game:GetService("Debris"):AddItem(v,0.08)
            end
        end
    end
end)

-- ================================================
-- 🏘 TAB 3: BROOKHAVEN KONUM
-- ================================================
local P3=tabPages[3]

-- Brookhaven harita koordinatları (yaklaşık)
local LOCATIONS = {
    {name="🏠 Spawn",          pos=Vector3.new(0,  5,  0)},
    {name="🏦 Banka",          pos=Vector3.new(200,5, -50)},
    {name="🏥 Hastane",        pos=Vector3.new(-180,5, 60)},
    {name="👮 Polis Karakolu", pos=Vector3.new(80, 5, 200)},
    {name="🏫 Okul",           pos=Vector3.new(-80,5, -200)},
    {name="🎬 Sinema",         pos=Vector3.new(300,5, 150)},
    {name="⛽ Benzinlik",      pos=Vector3.new(-300,5,-150)},
    {name="🌳 Park",           pos=Vector3.new(-50,5, 100)},
    {name="🏟 Stadyum",        pos=Vector3.new(400,5, 0)},
    {name="🏖 Plaj",           pos=Vector3.new(0,  2, 400)},
    {name="⛪ Kilise",         pos=Vector3.new(-250,5,250)},
    {name="🚒 İtfaiye",        pos=Vector3.new(150,5,-250)},
    {name="🛒 Market",         pos=Vector3.new(-150,5,300)},
    {name="🍔 Fast Food",      pos=Vector3.new(250,5, 250)},
    {name="✈️ Havalimanı",     pos=Vector3.new(600,5, 0)},
}

Section(P3,"BROOKHAVEN KONUMLARI")

-- Konum butonlarını 2 sütun ızgara olarak göster
local gridFrame=Instance.new("Frame",P3)
gridFrame.Size=UDim2.new(1,0,0, math.ceil(#LOCATIONS/2)*42+6)
gridFrame.BackgroundTransparency=1; gridFrame.BorderSizePixel=0

local gridLayout=Instance.new("UIGridLayout",gridFrame)
gridLayout.CellSize=UDim2.new(0.5,-4,0,36)
gridLayout.CellPadding=UDim2.new(0,4,0,4)
gridLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center

for _,loc in ipairs(LOCATIONS) do
    local b=Instance.new("TextButton",gridFrame)
    b.Text=loc.name; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
    b.TextColor3=Color3.fromRGB(210,210,230)
    b.BackgroundColor3=Color3.fromRGB(22,22,36); b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    local pos=loc.pos
    b.MouseButton1Click:Connect(function()
        local r=Root(); if not r then return end
        r.CFrame=CFrame.new(pos+Vector3.new(0,5,0))
        notify("Teleport: "..loc.name)
    end)
    b.MouseEnter:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(255,40,70)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(22,22,36)}):Play()
    end)
end

Section(P3,"KOORDİNAT TELEPORT")
-- Manuel koordinat (X / Z)
local coordRow=Instance.new("Frame",P3)
coordRow.Size=UDim2.new(1,0,0,36); coordRow.BackgroundTransparency=1; coordRow.BorderSizePixel=0
local crL=Instance.new("UIListLayout",coordRow)
crL.FillDirection=Enum.FillDirection.Horizontal; crL.Padding=UDim.new(0,4)

local function input(parent, placeholder)
    local b=Instance.new("TextBox",parent)
    b.Size=UDim2.new(0.3,0,1,0); b.PlaceholderText=placeholder
    b.Text=""; b.TextSize=12; b.Font=Enum.Font.Gotham
    b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=Color3.fromRGB(22,22,36)
    b.BorderSizePixel=0; b.PlaceholderColor3=Color3.fromRGB(100,100,130)
    b.ClearTextOnFocus=false
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    return b
end

local xBox=input(coordRow,"X")
local zBox=input(coordRow,"Z")
local goBtn=Instance.new("TextButton",coordRow)
goBtn.Size=UDim2.new(0.35,0,1,0); goBtn.Text="🚀 Git"
goBtn.TextSize=12; goBtn.Font=Enum.Font.GothamSemibold
goBtn.TextColor3=Color3.new(1,1,1); goBtn.BackgroundColor3=Color3.fromRGB(255,40,70)
goBtn.BorderSizePixel=0
Instance.new("UICorner",goBtn).CornerRadius=UDim.new(0,6)
goBtn.MouseButton1Click:Connect(function()
    local x=tonumber(xBox.Text); local z=tonumber(zBox.Text)
    if x and z then
        local r=Root(); if r then r.CFrame=CFrame.new(x,10,z) end
    end
end)

Section(P3,"ARAÇ")
Btn(P3,"🚗 Aracı Sil (Yakınındaki)",Color3.fromRGB(150,30,30),function()
    local r=Root(); if not r then return end
    for _,v in pairs(Workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") then
            if (v.Position-r.Position).Magnitude<30 then
                v.Parent:Destroy()
                notify("Araç silindi!")
                break
            end
        end
    end
end)
Btn(P3,"🪑 Araçtan Çıkar",Color3.fromRGB(60,60,90),function()
    local h=Hum(); if h then h.Sit=false end
end)

-- ================================================
-- 👁 TAB 4: GÖRSEL
-- ================================================
local P4=tabPages[4]

-- ESP — önce fonksiyon tanımla, sonra toggle
local espObjs={}
local function clearESP()
    for _,o in pairs(espObjs) do if o and o.Parent then o:Destroy() end end
    espObjs={}
end
local function buildESP()
    clearESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player and plr.Character then
            local head=plr.Character:FindFirstChild("Head")
            if not head then continue end
            local bill=Instance.new("BillboardGui",head)
            bill.Name="LordESP"; bill.Size=UDim2.fromOffset(160,48)
            bill.StudsOffset=Vector3.new(0,3.5,0); bill.AlwaysOnTop=true

            local nl=Instance.new("TextLabel",bill)
            nl.Size=UDim2.new(1,0,0.55,0); nl.Text=plr.Name
            nl.TextColor3=Color3.fromRGB(255,255,50); nl.TextSize=13
            nl.Font=Enum.Font.GothamBold; nl.TextStrokeTransparency=0
            nl.TextStrokeColor3=Color3.fromRGB(0,0,0); nl.BackgroundTransparency=1

            local hl=Instance.new("TextLabel",bill)
            hl.Size=UDim2.new(1,0,0.45,0); hl.Position=UDim2.new(0,0,0.55,0)
            hl.TextColor3=Color3.fromRGB(100,255,100); hl.TextSize=10
            hl.Font=Enum.Font.Gotham; hl.TextStrokeTransparency=0
            hl.TextStrokeColor3=Color3.fromRGB(0,0,0); hl.BackgroundTransparency=1

            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hl.Text="HP: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                hum:GetPropertyChangedSignal("Health"):Connect(function()
                    if hl.Parent then
                        hl.Text="HP: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                    end
                end)
            end
            table.insert(espObjs,bill)
        end
    end
end

Section(P4,"ESP & ALGILAMA")
Toggle(P4,"👁️ Oyuncu ESP (İsim + HP)",function(on)
    if on then buildESP() else clearESP() end
end)

Btn(P4,"🔄 ESP'yi Yenile",Color3.fromRGB(40,40,62),function()
    buildESP(); notify("ESP yenilendi")
end)

-- Chams toggle
local _chamsConn
Toggle(P4,"🌈 Chams (Gökkuşağı Karakter)",function(on)
    if on then
        local t2=0
        _chamsConn=RunService.Heartbeat:Connect(function(dt)
            t2+=dt; local c=Char(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Color=Color3.fromHSV((t2*0.4)%1,1,1)
                end
            end
        end)
    else
        if _chamsConn then _chamsConn:Disconnect(); _chamsConn=nil end
    end
end)

Section(P4,"ORTAM")

-- Orijinal değerleri kaydet
local _oAmb  = Lighting.Ambient
local _oOut  = Lighting.OutdoorAmbient
local _oBri  = Lighting.Brightness
local _oShad = Lighting.GlobalShadows
local _oClock= Lighting.ClockTime

Toggle(P4,"💡 Fullbright",function(on)
    if on then
        Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness=_oBri; Lighting.ClockTime=_oClock
        Lighting.GlobalShadows=_oShad; Lighting.Ambient=_oAmb
        Lighting.OutdoorAmbient=_oOut
    end
end)

Toggle(P4,"🌙 Gece Modu",function(on)
    Lighting.ClockTime   = on and 0   or _oClock
    Lighting.Ambient     = on and Color3.fromRGB(25,25,60) or _oAmb
    Lighting.OutdoorAmbient = on and Color3.fromRGB(25,25,60) or _oOut
end)

Toggle(P4,"🌁 Sis Kaldır",function(on)
    Lighting.FogEnd   = on and 999999 or 1000
    Lighting.FogStart = on and 999990 or 0
end)

-- ================================================
-- ⚙️ TAB 5: AYARLAR
-- ================================================
local P5=tabPages[5]
Section(P5,"KLAVYE KISAYOLLARI")

local function infoBox(parent,text)
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,58); f.BackgroundColor3=Color3.fromRGB(16,16,26)
    f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,-16,1,0); l.Position=UDim2.new(0,8,0,0)
    l.Text=text; l.TextSize=11; l.Font=Enum.Font.Gotham
    l.TextColor3=Color3.fromRGB(185,185,215); l.TextWrapped=true
    l.TextXAlignment=Enum.TextXAlignment.Left; l.BackgroundTransparency=1
end

infoBox(P5,"RightShift  →  Menüyü Aç / Kapat\nDelete      →  Menüyü Kapat\nInsert      →  Menüyü Aç")

Section(P5,"HAKKINDA")
infoBox(P5,"🔥 LORD HUB V4  —  BROOKHAVEN EDİTİON\n\nTablar: Kendin · Oyuncu · Konum · Görsel · Ayarlar\nTüm özellikler: Uçuş, Noclip, ESP, Teleport...")

Section(P5,"HIZLI EYLEMLER")
Btn(P5,"🗑️ Tüm ESP'yi Temizle",Color3.fromRGB(40,40,62),function()
    clearESP(); notify("ESP temizlendi")
end)
Btn(P5,"🔄 Arayüzü Yeniden Yükle",Color3.fromRGB(40,40,62),function()
    if pgui:FindFirstChild("LordHubV4") then pgui.LordHubV4:Destroy() end
    -- executor'dan tekrar çalıştır
end)

-- ================================================
-- 🔘 AÇMA/KAPAMA BUTONU (Sol kenar, her zaman görünür)
-- ================================================
local ToggleBtn=Instance.new("TextButton",ScreenGui)
ToggleBtn.Size=UDim2.fromOffset(44,44); ToggleBtn.Position=UDim2.new(0,10,0.5,-22)
ToggleBtn.Text="🔥"; ToggleBtn.TextSize=20
ToggleBtn.BackgroundColor3=Color3.fromRGB(255,40,70); ToggleBtn.BorderSizePixel=0
Instance.new("UICorner",ToggleBtn).CornerRadius=UDim.new(1,0)
local ts2=Instance.new("UIStroke",ToggleBtn); ts2.Color=Color3.new(1,1,1); ts2.Thickness=1
ToggleBtn.MouseButton1Click:Connect(function() Main.Visible=not Main.Visible end)

-- ── Klavye kısayolları ───────────────────────────
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        Main.Visible=not Main.Visible
    elseif inp.KeyCode==Enum.KeyCode.Delete then
        Main.Visible=false
    elseif inp.KeyCode==Enum.KeyCode.Insert then
        Main.Visible=true
    end
end)

-- ── Karakter yenilenince bağlantıları düzelt ─────
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    -- Noclip yeniden bağla
    if _ncConn then
        _ncConn:Disconnect()
        _ncConn=RunService.Stepped:Connect(function()
            for _,p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end)
    end
    -- Fly temizle
    _fly=false
    if _flyConn then _flyConn:Disconnect(); _flyConn=nil end
    if _flyVel  then pcall(function() _flyVel:Destroy() end); _flyVel=nil end
    if _flyGyr  then pcall(function() _flyGyr:Destroy() end); _flyGyr=nil end
end)

-- ── Otomatik oyuncu takibi ───────────────────────
Players.PlayerAdded:Connect(function() task.wait(1); refreshPlayerList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.2); refreshPlayerList() end)

-- ── Başlangıç ────────────────────────────────────
refreshPlayerList()
notify("🔥 Lord Hub V4 Yüklendi!")
print("[LORD HUB V4] Yüklendi. RightShift = aç/kapat")
