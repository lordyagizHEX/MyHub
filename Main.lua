--[[
  LORD HUB V4 — BROOKHAVEN EDİTİON
  Mobil + PC uyumlu | Tüm executor'larda çalışır
--]]

-- ── Servisler ──────────────────────────────────
local Players   = game:GetService("Players")
local RS        = game:GetService("RunService")
local UIS       = game:GetService("UserInputService")
local TS        = game:GetService("TweenService")
local Lighting  = game:GetService("Lighting")
local Debris    = game:GetService("Debris")

local lp   = Players.LocalPlayer
local pgui = lp.PlayerGui

-- ── Yardımcılar ────────────────────────────────
local function C()  return lp.Character end
local function R()  local c=C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H()  local c=C(); return c and c:FindFirstChildOfClass("Humanoid") end

-- ── Eski GUI temizle ───────────────────────────
if pgui:FindFirstChild("LordHub") then pgui.LordHub:Destroy() end

-- ══════════════════════════════════════════════
-- GUI OLUŞTUR
-- ══════════════════════════════════════════════
local sg = Instance.new("ScreenGui")
sg.Name = "LordHub"; sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true; sg.Parent = pgui

-- Ana pencere (küçük, telefon dostu)
local W,H_WIN = 320, 410

local win = Instance.new("Frame", sg)
win.Name = "Win"; win.Size = UDim2.fromOffset(W, H_WIN)
win.Position = UDim2.new(0.5,-W/2, 0.5,-H_WIN/2)
win.BackgroundColor3 = Color3.fromRGB(10,10,18)
win.BorderSizePixel = 0; win.Active = true; win.Draggable = true
Instance.new("UICorner",win).CornerRadius = UDim.new(0,10)
do local s=Instance.new("UIStroke",win); s.Color=Color3.fromRGB(255,35,65); s.Thickness=1.5 end

-- ── Başlık (42px) ──────────────────────────────
local bar = Instance.new("Frame", win)
bar.Size = UDim2.new(1,0,0,42); bar.BackgroundColor3 = Color3.fromRGB(15,15,26)
bar.BorderSizePixel = 0
Instance.new("UICorner",bar).CornerRadius = UDim.new(0,10)
-- alt köşe fix
local bf=Instance.new("Frame",bar); bf.Size=UDim2.new(1,0,0.5,0)
bf.Position=UDim2.new(0,0,0.5,0); bf.BackgroundColor3=Color3.fromRGB(15,15,26)
bf.BorderSizePixel=0

local function tl(p,txt,sz,col,x,y,xw,yw,xa,f)
    local l=Instance.new("TextLabel",p); l.Text=txt; l.TextSize=sz
    l.TextColor3=col or Color3.new(1,1,1); l.Font=f or Enum.Font.GothamBold
    l.Size=UDim2.new(xw or 0,x or 0, yw or 0, y or 0)
    l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    return l
end

local ti=tl(bar,"🔥",20,nil, 0,42, 0,1); ti.Position=UDim2.new(0,8,0,0)
ti.TextXAlignment=Enum.TextXAlignment.Center
local tn=tl(bar,"LORD HUB V4",14,Color3.new(1,1,1), 0,22, 0.6,0)
tn.Position=UDim2.new(0,34,0,5)
local ts=tl(bar,"BROOKHAVEN",9,Color3.fromRGB(255,35,65), 0,14, 0.6,0,nil,Enum.Font.GothamSemibold)
ts.Position=UDim2.new(0,34,0,25)

local function hdrBtn(txt,col,ox)
    local b=Instance.new("TextButton",bar)
    b.Size=UDim2.fromOffset(24,24); b.Position=UDim2.new(1,ox,0.5,-12)
    b.Text=txt; b.TextSize=11; b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=col; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5); return b
end
local closeB = hdrBtn("X",Color3.fromRGB(210,30,50),-7)
local minB   = hdrBtn("_",Color3.fromRGB(45,45,68),-35)
closeB.MouseButton1Click:Connect(function() win.Visible=false end)

local miniState=false
minB.MouseButton1Click:Connect(function()
    miniState=not miniState
    TS:Create(win,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{
        Size=miniState and UDim2.fromOffset(W,42) or UDim2.fromOffset(W,H_WIN)
    }):Play()
    minB.Text=miniState and "+" or "_"
end)

-- ── Tab bar (30px) ─────────────────────────────
local tabBar = Instance.new("Frame", win)
tabBar.Size = UDim2.new(1,0,0,30); tabBar.Position = UDim2.new(0,0,0,42)
tabBar.BackgroundColor3 = Color3.fromRGB(13,13,22); tabBar.BorderSizePixel=0
do local l=Instance.new("UIListLayout",tabBar)
   l.FillDirection=Enum.FillDirection.Horizontal
   l.HorizontalAlignment=Enum.HorizontalAlignment.Center
   l.VerticalAlignment=Enum.VerticalAlignment.Center
   l.Padding=UDim.new(0,2) end

-- ── İçerik alanı (338px yükseklik) ────────────
local CONTENT_H = H_WIN - 72
local content = Instance.new("Frame", win)
content.Size = UDim2.new(1,0,0,CONTENT_H); content.Position = UDim2.new(0,0,0,72)
content.BackgroundTransparency=1; content.BorderSizePixel=0

-- ══════════════════════════════════════════════
-- TAB YÖNETİMİ
-- ══════════════════════════════════════════════
local TABS = {"⚡Kendin","👥Oyuncu","🏘Konum","👁Görsel","⚙Ayar"}
local tabBtns={} ; local pages={}
local activeTab=0

local function switchTab(i)
    if activeTab==i then return end
    activeTab=i
    for j=1,#TABS do
        TS:Create(tabBtns[j],TweenInfo.new(0.13),{
            BackgroundColor3 = j==i and Color3.fromRGB(255,35,65) or Color3.fromRGB(18,18,30),
            TextColor3       = j==i and Color3.new(1,1,1) or Color3.fromRGB(120,120,155)
        }):Play()
        pages[j].Visible = (j==i)
    end
end

for i,name in ipairs(TABS) do
    local tb=Instance.new("TextButton",tabBar)
    tb.Size=UDim2.fromOffset(56,24); tb.Text=name; tb.TextSize=8
    tb.Font=Enum.Font.GothamSemibold; tb.BorderSizePixel=0
    tb.BackgroundColor3=Color3.fromRGB(18,18,30)
    tb.TextColor3=Color3.fromRGB(120,120,155)
    Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5)
    tabBtns[i]=tb

    -- Her sayfa: ScrollingFrame
    local pg=Instance.new("ScrollingFrame",content)
    pg.Size=UDim2.new(1,0,1,0); pg.BackgroundTransparency=1
    pg.ScrollBarThickness=2; pg.ScrollBarImageColor3=Color3.fromRGB(255,35,65)
    pg.CanvasSize=UDim2.new(0,0,0,0); pg.AutomaticCanvasSize=Enum.AutomaticSize.Y
    pg.Visible=false; pg.BorderSizePixel=0
    do local l=Instance.new("UIListLayout",pg)
       l.Padding=UDim.new(0,4); l.HorizontalAlignment=Enum.HorizontalAlignment.Center
       Instance.new("UIPadding",pg).PaddingTop=UDim.new(0,6)
       local lp2=pg:FindFirstChildOfClass("UIPadding")
       lp2.PaddingLeft=UDim.new(0,7); lp2.PaddingRight=UDim.new(0,7)
    end
    pages[i]=pg

    local idx=i
    tb.MouseButton1Click:Connect(function() switchTab(idx) end)
end
switchTab(1)

-- ══════════════════════════════════════════════
-- UI ELEMENTLERİ
-- ══════════════════════════════════════════════

local TW = TweenInfo.new(0.15,Enum.EasingStyle.Quad)

-- Bölüm başlığı
local function Sec(pg, txt)
    local f=Instance.new("Frame",pg); f.Size=UDim2.new(1,0,0,16); f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,0,1,0)
    l.Text="  "..txt; l.TextSize=9; l.Font=Enum.Font.GothamBold
    l.TextColor3=Color3.fromRGB(255,35,65); l.TextXAlignment=Enum.TextXAlignment.Left
    l.BackgroundTransparency=1
end

-- Normal buton
local function Btn(pg, txt, col, cb)
    local b=Instance.new("TextButton",pg)
    b.Size=UDim2.new(1,0,0,34); b.Text=txt; b.TextSize=11
    b.Font=Enum.Font.GothamSemibold; b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=col or Color3.fromRGB(255,35,65); b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    b.MouseButton1Click:Connect(cb)
    b.MouseEnter:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0.3}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0}):Play() end)
    return b
end

-- Toggle switch
local function Tog(pg, txt, cb)
    local row=Instance.new("TextButton",pg)
    row.Size=UDim2.new(1,0,0,36); row.Text=""
    row.BackgroundColor3=Color3.fromRGB(17,17,28); row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)

    local nl=Instance.new("TextLabel",row)
    nl.Size=UDim2.new(0.72,0,1,0); nl.Position=UDim2.new(0,9,0,0)
    nl.Text=txt; nl.TextSize=11; nl.Font=Enum.Font.GothamSemibold
    nl.TextColor3=Color3.fromRGB(205,205,230); nl.TextXAlignment=Enum.TextXAlignment.Left
    nl.BackgroundTransparency=1

    local bg=Instance.new("Frame",row)
    bg.Size=UDim2.fromOffset(38,19); bg.Position=UDim2.new(1,-46,0.5,-9.5)
    bg.BackgroundColor3=Color3.fromRGB(48,48,65); bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)

    local kn=Instance.new("Frame",bg)
    kn.Size=UDim2.fromOffset(13,13); kn.Position=UDim2.new(0,3,0.5,-6.5)
    kn.BackgroundColor3=Color3.fromRGB(155,155,180); kn.BorderSizePixel=0
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)

    local on=false
    local tw2=TweenInfo.new(0.16,Enum.EasingStyle.Quad)
    local function set(v)
        on=v
        if v then
            TS:Create(bg, tw2,{BackgroundColor3=Color3.fromRGB(255,35,65)}):Play()
            TS:Create(kn, tw2,{Position=UDim2.new(0,22,0.5,-6.5),BackgroundColor3=Color3.new(1,1,1)}):Play()
        else
            TS:Create(bg, tw2,{BackgroundColor3=Color3.fromRGB(48,48,65)}):Play()
            TS:Create(kn, tw2,{Position=UDim2.new(0,3,0.5,-6.5),BackgroundColor3=Color3.fromRGB(155,155,180)}):Play()
        end
        cb(v)
    end
    row.MouseButton1Click:Connect(function() set(not on) end)
    return {set=set,get=function()return on end}
end

-- Slider
local function Sli(pg, txt, mn, mx, def, cb)
    local f=Instance.new("Frame",pg)
    f.Size=UDim2.new(1,0,0,50); f.BackgroundColor3=Color3.fromRGB(17,17,28)
    f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)

    local nl=Instance.new("TextLabel",f); nl.Size=UDim2.new(0.62,0,0,20)
    nl.Position=UDim2.new(0,9,0,4); nl.Text=txt; nl.TextSize=11
    nl.Font=Enum.Font.GothamSemibold; nl.TextColor3=Color3.fromRGB(205,205,230)
    nl.TextXAlignment=Enum.TextXAlignment.Left; nl.BackgroundTransparency=1

    local vl=Instance.new("TextLabel",f); vl.Size=UDim2.new(0.34,0,0,20)
    vl.Position=UDim2.new(0.62,-4,0,4); vl.Text=tostring(def); vl.TextSize=11
    vl.Font=Enum.Font.GothamBold; vl.TextColor3=Color3.fromRGB(255,35,65)
    vl.TextXAlignment=Enum.TextXAlignment.Right; vl.BackgroundTransparency=1

    local tr=Instance.new("Frame",f); tr.Size=UDim2.new(1,-18,0,4)
    tr.Position=UDim2.new(0,9,0,36); tr.BackgroundColor3=Color3.fromRGB(36,36,55)
    tr.BorderSizePixel=0; Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)

    local p0=(def-mn)/(mx-mn)
    local fi=Instance.new("Frame",tr); fi.Size=UDim2.new(p0,0,1,0)
    fi.BackgroundColor3=Color3.fromRGB(255,35,65); fi.BorderSizePixel=0
    Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)

    local kn=Instance.new("Frame",tr); kn.Size=UDim2.fromOffset(11,11)
    kn.AnchorPoint=Vector2.new(0.5,0.5); kn.Position=UDim2.new(p0,0,0.5,0)
    kn.BackgroundColor3=Color3.new(1,1,1); kn.BorderSizePixel=0
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)

    local dr=false
    local function upd(x)
        local p=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local v=math.floor(mn+p*(mx-mn)); vl.Text=tostring(v)
        fi.Size=UDim2.new(p,0,1,0); kn.Position=UDim2.new(p,0,0.5,0); cb(v)
    end
    tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true;upd(i.Position.X) end end)
    kn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true end end)
    UIS.InputChanged:Connect(function(i) if dr and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end)
end

-- ══════════════════════════════════════════════
-- TAB 1 — KENDİN
-- ══════════════════════════════════════════════
local P1=pages[1]
Sec(P1,"HAREKET")
Sli(P1,"🏃 Hız",16,300,16,function(v) local h=H(); if h then h.WalkSpeed=v end end)
Sli(P1,"⬆️ Zıplama Gücü",50,500,50,function(v)
    local h=H(); if not h then return end
    pcall(function() h.JumpPower=v end)
    pcall(function() h.JumpHeight=v/5.5 end)
end)

Sec(P1,"ÖZELLİKLER")

-- Uçuş
local flyOn=false; local fVel,fGyr,fConn
Tog(P1,"🛩️ Uçuş  (WASD + Space / Shift)",function(on)
    flyOn=on; local r=R()
    if on and r then
        fGyr=Instance.new("BodyGyro",r); fGyr.MaxTorque=Vector3.new(9e8,9e8,9e8); fGyr.P=9e4
        fVel=Instance.new("BodyVelocity",r); fVel.MaxForce=Vector3.new(9e8,9e8,9e8); fVel.Velocity=Vector3.zero
        fConn=RS.Heartbeat:Connect(function()
            local rt=R(); if not (flyOn and rt) then if fConn then fConn:Disconnect() end return end
            local cam=workspace.CurrentCamera; local d=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then d+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.new(0,1,0) end
            fVel.Velocity=d.Magnitude>0 and d.Unit*70 or Vector3.zero
            fGyr.CFrame=workspace.CurrentCamera.CFrame
        end)
    else
        if fConn then fConn:Disconnect();fConn=nil end
        pcall(function() if fVel then fVel:Destroy() end end); fVel=nil
        pcall(function() if fGyr then fGyr:Destroy() end end); fGyr=nil
    end
end)

-- Noclip
local ncOn=false; local ncConn
Tog(P1,"🌫️ Noclip  (Duvardan geç)",function(on)
    ncOn=on
    if on then
        ncConn=RS.Stepped:Connect(function()
            local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end)
    else
        if ncConn then ncConn:Disconnect();ncConn=nil end
        local c=C(); if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end)

-- Sonsuz zıplama
local ijConn
Tog(P1,"🚀 Sonsuz Zıplama",function(on)
    if on then
        ijConn=UIS.JumpRequest:Connect(function()
            local h=H(); if h and h.FloorMaterial==Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else if ijConn then ijConn:Disconnect();ijConn=nil end end
end)

-- God mode
local godConn
Tog(P1,"🛡️ God Mode",function(on)
    local h=H(); if not h then return end
    if on then
        h.MaxHealth=math.huge; h.Health=math.huge
        godConn=h.HealthChanged:Connect(function() if h and h.Parent then h.Health=math.huge end end)
    else
        if godConn then godConn:Disconnect();godConn=nil end
        pcall(function() h.MaxHealth=100; h.Health=100 end)
    end
end)

-- Anti-AFK
local afkConn
Tog(P1,"💤 Anti-AFK",function(on)
    if on then
        local vu=game:GetService("VirtualUser")
        afkConn=RS.Heartbeat:Connect(function()
            vu:Button2Down(Vector2.zero,workspace.CurrentCamera.CFrame)
            vu:Button2Up(Vector2.zero,workspace.CurrentCamera.CFrame)
        end)
    else if afkConn then afkConn:Disconnect();afkConn=nil end end
end)

-- Invisible
Tog(P1,"👻 Karakter Gizle",function(on)
    local c=C(); if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=on and 1 or 0 end
    end
end)

Sec(P1,"ANLIK")
Btn(P1,"☁️ Havaya Zıpla",Color3.fromRGB(55,55,82),function()
    local r=R(); if r then r.CFrame=r.CFrame+Vector3.new(0,60,0) end
end)
Btn(P1,"🔄 Respawn",Color3.fromRGB(55,55,82),function() lp:LoadCharacter() end)

-- ══════════════════════════════════════════════
-- TAB 2 — OYUNCU
-- ══════════════════════════════════════════════
local P2=pages[2]

Sec(P2,"OYUNCU LİSTESİ")

-- Seçili oyuncu label
local selLbl=Instance.new("TextLabel",P2)
selLbl.Size=UDim2.new(1,0,0,20); selLbl.Text="🎯 Seçili: Yok"
selLbl.TextColor3=Color3.fromRGB(255,35,65); selLbl.TextSize=11
selLbl.Font=Enum.Font.GothamSemibold; selLbl.BackgroundTransparency=1

-- Liste çerçevesi (ScrollingFrame — sadece burada kullan)
local listSF=Instance.new("ScrollingFrame",P2)
listSF.Size=UDim2.new(1,0,0,130); listSF.BackgroundColor3=Color3.fromRGB(13,13,21)
listSF.BorderSizePixel=0; listSF.ScrollBarThickness=2
listSF.ScrollBarImageColor3=Color3.fromRGB(255,35,65)
listSF.CanvasSize=UDim2.new(0,0,0,0)  -- manuel ayarlanacak
Instance.new("UICorner",listSF).CornerRadius=UDim.new(0,7)

local selPlayer=nil; local pBtns={}

local function refreshList()
    -- Eski butonları sil
    for _,b in pairs(pBtns) do pcall(function() b:Destroy() end) end
    pBtns={}

    local plrs={}
    for _,p in pairs(Players:GetPlayers()) do
        if p~=lp then table.insert(plrs,p) end
    end

    if #plrs==0 then
        -- Boş mesaj
        local nl=Instance.new("TextLabel",listSF)
        nl.Size=UDim2.new(1,0,0,30); nl.Position=UDim2.fromOffset(0,4)
        nl.Text="Sunucuda başka oyuncu yok"; nl.TextSize=10
        nl.Font=Enum.Font.Gotham; nl.TextColor3=Color3.fromRGB(120,120,150)
        nl.BackgroundTransparency=1
        table.insert(pBtns,nl)
        listSF.CanvasSize=UDim2.new(0,0,0,38)
        return
    end

    for i,plr in ipairs(plrs) do
        local y=(i-1)*33
        local b=Instance.new("TextButton",listSF)
        b.Size=UDim2.new(1,-8,0,28); b.Position=UDim2.fromOffset(4, y+3)
        b.Text="  👤 "..plr.Name; b.TextSize=11
        b.Font=Enum.Font.GothamSemibold; b.TextXAlignment=Enum.TextXAlignment.Left
        b.TextColor3=Color3.fromRGB(200,200,225); b.BackgroundColor3=Color3.fromRGB(20,20,32)
        b.BorderSizePixel=0
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)

        local pr=plr  -- closure için
        b.MouseButton1Click:Connect(function()
            selPlayer=pr
            selLbl.Text="🎯 Seçili: "..pr.Name
            for _,x in pairs(pBtns) do
                if x:IsA("TextButton") then
                    x.BackgroundColor3=Color3.fromRGB(20,20,32)
                    x.TextColor3=Color3.fromRGB(200,200,225)
                end
            end
            b.BackgroundColor3=Color3.fromRGB(255,35,65)
            b.TextColor3=Color3.new(1,1,1)
        end)
        table.insert(pBtns,b)
    end
    listSF.CanvasSize=UDim2.new(0,0,0,#plrs*33+6)
end

Btn(P2,"🔄 Oyuncuları Yenile",Color3.fromRGB(35,35,55),refreshList)

Sec(P2,"OYUNCU İŞLEMLERİ")

Btn(P2,"📦 Teleport Et  (→ Oyuncuya git)",Color3.fromRGB(0,115,200),function()
    if not selPlayer then return end
    local r=R(); local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r and t then r.CFrame=t.CFrame+Vector3.new(3,2,0) end
end)

Btn(P2,"📥 Yanına Getir  (Oyuncuyu çek)",Color3.fromRGB(160,115,0),function()
    if not selPlayer then return end
    local r=R(); local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r and t then t.CFrame=r.CFrame+Vector3.new(3,0,0) end
end)

Btn(P2,"💀 Öldür",Color3.fromRGB(185,18,18),function()
    if not selPlayer then return end
    local h=selPlayer.Character and selPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Health=0 end
end)

Btn(P2,"💥 Fling  (Yatay fırlat)",Color3.fromRGB(195,65,0),function()
    if not selPlayer then return end
    local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=Vector3.new(math.random(-600,600),math.random(300,600),math.random(-600,600))
    Debris:AddItem(v,0.2)
end)

Btn(P2,"🪂 Havaya Fırlat  (Up fling)",Color3.fromRGB(80,80,185),function()
    if not selPlayer then return end
    local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge); v.Velocity=Vector3.new(0,1400,0)
    Debris:AddItem(v,0.15)
end)

Btn(P2,"🌀 Spin  (Döndür 3sn)",Color3.fromRGB(105,0,185),function()
    if not selPlayer then return end
    local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local av=Instance.new("BodyAngularVelocity",t)
    av.MaxTorque=Vector3.new(math.huge,math.huge,math.huge); av.AngularVelocity=Vector3.new(0,300,0)
    Debris:AddItem(av,3)
end)

Btn(P2,"🔫 Çek  (Sana doğru çeker)",Color3.fromRGB(0,145,105),function()
    if not selPlayer then return end
    local r=R(); local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (r and t) then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=(r.Position-t.Position).Unit*350
    Debris:AddItem(v,0.15)
end)

Btn(P2,"💣 Patlat  (Explosion)",Color3.fromRGB(155,50,0),function()
    if not selPlayer then return end
    local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not t then return end
    local e=Instance.new("Explosion",workspace); e.Position=t.Position
    e.BlastRadius=30; e.BlastPressure=900000
end)

Btn(P2,"🚤 Boat Attack  (Gemi saldırı)",Color3.fromRGB(145,20,20),function()
    if not selPlayer then return end
    local r=R(); local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (r and t) then return end
    local boat=Instance.new("Part",workspace)
    boat.Size=Vector3.new(10,3,5); boat.Position=r.Position+Vector3.new(0,35,0)
    boat.Material=Enum.Material.Neon; boat.Color=Color3.fromRGB(255,0,0); boat.Anchored=false
    local bv=Instance.new("BodyVelocity",boat)
    bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    bv.Velocity=(t.Position-boat.Position).Unit*230+Vector3.new(0,45,0)
    local conn; conn=RS.Heartbeat:Connect(function()
        if not(boat and boat.Parent) then conn:Disconnect();return end
        local tgt=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not tgt then boat:Destroy();conn:Disconnect();return end
        if (boat.Position-tgt.Position).Magnitude<13 then
            local e=Instance.new("Explosion",workspace); e.Position=tgt.Position
            e.BlastRadius=25; e.BlastPressure=800000
            boat:Destroy(); conn:Disconnect()
        end
    end)
    Debris:AddItem(boat,8)
end)

-- Loop bring toggle
local annoyConn
Tog(P2,"😈 Sürekli Getir  (Loop ON/OFF)",function(on)
    if on then
        annoyConn=RS.Heartbeat:Connect(function()
            local r=R(); local t=selPlayer and selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
            if r and t then t.CFrame=r.CFrame+Vector3.new(3,0,0) end
        end)
    else if annoyConn then annoyConn:Disconnect();annoyConn=nil end end
end)

Sec(P2,"HERKESE")
Btn(P2,"💀 Herkesi Öldür",Color3.fromRGB(160,0,0),function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=lp and p.Character then
            local h=p.Character:FindFirstChildOfClass("Humanoid"); if h then h.Health=0 end
        end
    end
end)
Btn(P2,"💥 Herkesi Fling",Color3.fromRGB(155,30,0),function()
    for _,p in pairs(Players:GetPlayers()) do
        if p~=lp and p.Character then
            local t=p.Character:FindFirstChild("HumanoidRootPart"); if not t then continue end
            local v=Instance.new("BodyVelocity",t)
            v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
            v.Velocity=Vector3.new(math.random(-700,700),math.random(500,900),math.random(-700,700))
            Debris:AddItem(v,0.07)
        end
    end
end)

-- ══════════════════════════════════════════════
-- TAB 3 — KONUM (Brookhaven)
-- ══════════════════════════════════════════════
local P3=pages[3]

Sec(P3,"BROOKHAVEN KONUMLARI")

-- 2'li ızgara (iki buton yan yana)
local LOCS={
    {"🏠 Spawn",         Vector3.new(0,5,0)},
    {"🏦 Banka",         Vector3.new(200,5,-50)},
    {"🏥 Hastane",       Vector3.new(-180,5,60)},
    {"👮 Polis",         Vector3.new(80,5,200)},
    {"🏫 Okul",          Vector3.new(-80,5,-200)},
    {"🎬 Sinema",        Vector3.new(300,5,150)},
    {"⛽ Benzinlik",     Vector3.new(-300,5,-150)},
    {"🌳 Park",          Vector3.new(-50,5,100)},
    {"🏖 Plaj",          Vector3.new(0,2,400)},
    {"✈️ Havalimanı",   Vector3.new(600,5,0)},
    {"⛪ Kilise",        Vector3.new(-250,5,250)},
    {"🚒 İtfaiye",       Vector3.new(150,5,-250)},
    {"🛒 Market",        Vector3.new(-150,5,300)},
    {"🍔 Fast Food",     Vector3.new(250,5,250)},
    {"🏟 Stadyum",       Vector3.new(400,5,100)},
    {"🏕 Orman",         Vector3.new(-400,5,-300)},
}

-- Çift kolon ızgara frame
local gridOuter=Instance.new("Frame",P3)
gridOuter.Size=UDim2.new(1,0,0, math.ceil(#LOCS/2)*38+4)
gridOuter.BackgroundTransparency=1; gridOuter.BorderSizePixel=0
local gl=Instance.new("UIGridLayout",gridOuter)
gl.CellSize=UDim2.new(0.5,-3,0,32); gl.CellPadding=UDim2.new(0,4,0,4)
gl.HorizontalAlignment=Enum.HorizontalAlignment.Center

for _,loc in ipairs(LOCS) do
    local pos=loc[2]
    local b=Instance.new("TextButton",gridOuter)
    b.Text=loc[1]; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
    b.TextColor3=Color3.fromRGB(205,205,230); b.BackgroundColor3=Color3.fromRGB(20,20,33)
    b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(function()
        local r=R(); if r then r.CFrame=CFrame.new(pos+Vector3.new(0,5,0)) end
    end)
    b.MouseEnter:Connect(function() TS:Create(b,TW,{BackgroundColor3=Color3.fromRGB(255,35,65)}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b,TW,{BackgroundColor3=Color3.fromRGB(20,20,33)}):Play() end)
end

Sec(P3,"KOORDİNAT TELEPORT")

-- X kutusu
local xRow=Instance.new("Frame",P3); xRow.Size=UDim2.new(1,0,0,32); xRow.BackgroundTransparency=1
xRow.BorderSizePixel=0
local xrl=Instance.new("UIListLayout",xRow); xrl.FillDirection=Enum.FillDirection.Horizontal
xrl.VerticalAlignment=Enum.VerticalAlignment.Center; xrl.Padding=UDim.new(0,4)

local function mkBox(p,ph)
    local b=Instance.new("TextBox",p); b.Size=UDim2.new(0.28,0,1,0)
    b.PlaceholderText=ph; b.Text=""; b.TextSize=11; b.Font=Enum.Font.Gotham
    b.TextColor3=Color3.new(1,1,1); b.PlaceholderColor3=Color3.fromRGB(100,100,130)
    b.BackgroundColor3=Color3.fromRGB(20,20,33); b.BorderSizePixel=0
    b.ClearTextOnFocus=false; Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    return b
end

local xBox=mkBox(xRow,"X"); local zBox=mkBox(xRow,"Z")
local goB=Instance.new("TextButton",xRow); goB.Size=UDim2.new(0.38,0,1,0)
goB.Text="🚀 Teleport"; goB.TextSize=10; goB.Font=Enum.Font.GothamSemibold
goB.TextColor3=Color3.new(1,1,1); goB.BackgroundColor3=Color3.fromRGB(255,35,65)
goB.BorderSizePixel=0; Instance.new("UICorner",goB).CornerRadius=UDim.new(0,6)
goB.MouseButton1Click:Connect(function()
    local x=tonumber(xBox.Text); local z=tonumber(zBox.Text)
    if x and z then local r=R(); if r then r.CFrame=CFrame.new(x,10,z) end end
end)

Sec(P3,"ARAÇ")
Btn(P3,"🚗 Yakındaki Aracı Sil",Color3.fromRGB(145,25,25),function()
    local r=R(); if not r then return end
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") and (v.Position-r.Position).Magnitude<30 then
            v.Parent:Destroy(); break
        end
    end
end)
Btn(P3,"🪑 Araçtan İn",Color3.fromRGB(55,55,82),function()
    local h=H(); if h then h.Sit=false end
end)

-- ══════════════════════════════════════════════
-- TAB 4 — GÖRSEL
-- ══════════════════════════════════════════════
local P4=pages[4]

-- ESP fonksiyonları (önce tanımla, sonra toggle)
local espObj={}
local function clearESP()
    for _,o in pairs(espObj) do pcall(function() o:Destroy() end) end espObj={}
end
local function buildESP()
    clearESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=lp and plr.Character then
            local head=plr.Character:FindFirstChild("Head"); if not head then continue end
            local bill=Instance.new("BillboardGui",head)
            bill.Name="LHubESP"; bill.Size=UDim2.fromOffset(150,44)
            bill.StudsOffset=Vector3.new(0,3.5,0); bill.AlwaysOnTop=true

            local nl=Instance.new("TextLabel",bill); nl.Size=UDim2.new(1,0,0.55,0)
            nl.Text=plr.Name; nl.TextSize=12; nl.Font=Enum.Font.GothamBold
            nl.TextColor3=Color3.fromRGB(255,255,50); nl.TextStrokeTransparency=0
            nl.TextStrokeColor3=Color3.fromRGB(0,0,0); nl.BackgroundTransparency=1

            local hl=Instance.new("TextLabel",bill); hl.Size=UDim2.new(1,0,0.45,0)
            hl.Position=UDim2.new(0,0,0.55,0); hl.TextSize=9; hl.Font=Enum.Font.Gotham
            hl.TextColor3=Color3.fromRGB(100,255,100); hl.TextStrokeTransparency=0
            hl.TextStrokeColor3=Color3.fromRGB(0,0,0); hl.BackgroundTransparency=1

            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hl.Text="HP:"..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
                hum:GetPropertyChangedSignal("Health"):Connect(function()
                    if hl.Parent then hl.Text="HP:"..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth) end
                end)
            end
            table.insert(espObj,bill)
        end
    end
end

Sec(P4,"ESP")
Tog(P4,"👁️ Player ESP  (İsim + HP)",function(on)
    if on then buildESP() else clearESP() end
end)
Btn(P4,"🔄 ESP Yenile",Color3.fromRGB(35,35,55),function() buildESP() end)

Sec(P4,"KARAKTER")
local chConn
Tog(P4,"🌈 Chams  (Gökkuşağı renk)",function(on)
    if on then
        local t=0; chConn=RS.Heartbeat:Connect(function(dt)
            t+=dt; local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.Color=Color3.fromHSV((t*0.4)%1,1,1) end
            end
        end)
    else if chConn then chConn:Disconnect();chConn=nil end end
end)

Tog(P4,"👻 Karakter Gizle  (Yerel)",function(on)
    local c=C(); if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=on and 1 or 0 end
    end
end)

Sec(P4,"ORTAM")
local oA=Lighting.Ambient; local oO=Lighting.OutdoorAmbient
local oB=Lighting.Brightness; local oS=Lighting.GlobalShadows; local oCl=Lighting.ClockTime

Tog(P4,"💡 Fullbright",function(on)
    if on then
        Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness=oB; Lighting.ClockTime=oCl; Lighting.GlobalShadows=oS
        Lighting.Ambient=oA; Lighting.OutdoorAmbient=oO
    end
end)

Tog(P4,"🌙 Gece Modu",function(on)
    Lighting.ClockTime=on and 0 or oCl
    Lighting.Ambient=on and Color3.fromRGB(20,20,55) or oA
    Lighting.OutdoorAmbient=on and Color3.fromRGB(20,20,55) or oO
end)

Tog(P4,"🌁 Sisi Kaldır",function(on)
    Lighting.FogEnd=on and 999999 or 1000; Lighting.FogStart=on and 999990 or 0
end)

-- ══════════════════════════════════════════════
-- TAB 5 — AYARLAR
-- ══════════════════════════════════════════════
local P5=pages[5]

Sec(P5,"KLAVYE KISAYOLLARI")
local ki=Instance.new("Frame",P5); ki.Size=UDim2.new(1,0,0,52)
ki.BackgroundColor3=Color3.fromRGB(15,15,24); ki.BorderSizePixel=0
Instance.new("UICorner",ki).CornerRadius=UDim.new(0,7)
local kl=Instance.new("TextLabel",ki); kl.Size=UDim2.new(1,-14,1,0)
kl.Position=UDim2.new(0,7,0,0); kl.Text="RightShift → Aç/Kapat\nDelete → Kapat   |   Insert → Aç"
kl.TextSize=10; kl.Font=Enum.Font.Gotham; kl.TextColor3=Color3.fromRGB(180,180,210)
kl.TextWrapped=true; kl.TextXAlignment=Enum.TextXAlignment.Left; kl.BackgroundTransparency=1

Sec(P5,"HIZLI EYLEMLER")
Btn(P5,"🗑️ ESP Temizle",Color3.fromRGB(35,35,55),clearESP)
Btn(P5,"🔄 Oyuncu Listesini Yenile",Color3.fromRGB(35,35,55),refreshList)

Sec(P5,"HAKKINDA")
local ab=Instance.new("Frame",P5); ab.Size=UDim2.new(1,0,0,62)
ab.BackgroundColor3=Color3.fromRGB(15,15,24); ab.BorderSizePixel=0
Instance.new("UICorner",ab).CornerRadius=UDim.new(0,7)
local al=Instance.new("TextLabel",ab); al.Size=UDim2.new(1,-14,1,0)
al.Position=UDim2.new(0,7,0,0); al.TextSize=10; al.Font=Enum.Font.Gotham
al.TextColor3=Color3.fromRGB(170,170,205); al.TextWrapped=true; al.BackgroundTransparency=1
al.TextXAlignment=Enum.TextXAlignment.Left
al.Text="🔥 LORD HUB V4 — BROOKHAVEN EDİTİON\n\nTablar: Kendin · Oyuncu · Konum · Görsel · Ayarlar\nMobil + PC uyumlu. Tüm executor'larda çalışır."

-- ══════════════════════════════════════════════
-- AÇMA/KAPAMA BUTONU (her zaman görünür)
-- ══════════════════════════════════════════════
local togB=Instance.new("TextButton",sg)
togB.Size=UDim2.fromOffset(40,40); togB.Position=UDim2.new(0,8,0.5,-20)
togB.Text="🔥"; togB.TextSize=18; togB.BackgroundColor3=Color3.fromRGB(255,35,65)
togB.BorderSizePixel=0
Instance.new("UICorner",togB).CornerRadius=UDim.new(1,0)
do local s=Instance.new("UIStroke",togB); s.Color=Color3.new(1,1,1); s.Thickness=1 end
togB.MouseButton1Click:Connect(function() win.Visible=not win.Visible end)

-- Klavye kısayolları
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then win.Visible=not win.Visible
    elseif i.KeyCode==Enum.KeyCode.Delete  then win.Visible=false
    elseif i.KeyCode==Enum.KeyCode.Insert  then win.Visible=true end
end)

-- Karakter yenilenince connection'ları düzelt
lp.CharacterAdded:Connect(function(char)
    task.wait(1)
    flyOn=false
    if fConn then fConn:Disconnect();fConn=nil end
    pcall(function() if fVel then fVel:Destroy() end end); fVel=nil
    pcall(function() if fGyr then fGyr:Destroy() end end); fGyr=nil

    if ncOn then
        if ncConn then ncConn:Disconnect() end
        ncConn=RS.Stepped:Connect(function()
            for _,p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end)
    end
end)

-- Oyuncu listesini otomatik güncelle
Players.PlayerAdded:Connect(function() task.wait(1); refreshList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.3); refreshList() end)

-- Başlat
refreshList()
print("[LORD HUB V4] Yüklendi! RightShift = aç/kapat")
