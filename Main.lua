--[[
  LORD HUB — MURDER MYSTERY 2  (V4 MOBİL + PC)
  ✅ Bıçak/Silah IŞINLANMADAN atar — sadece döner ve fire eder
  ✅ Şerif Trigger Bot — katili görür görmez ANINDA vurur
  ✅ Kompakt GUI — ekrana sığar
  ✅ Hızlı butonlar SOL ÜSTTE — zıplama tuşunu kapatmaz
--]]

local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local TS       = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris   = game:GetService("Debris")
local lp       = Players.LocalPlayer
local pgui     = lp.PlayerGui
local cam      = workspace.CurrentCamera

if pgui:FindFirstChild("MM2Hub") then pgui.MM2Hub:Destroy() end

-- ── Mobil Algılama ────────────────────────────
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp       = cam.ViewportSize
local SCALE    = isMobile and math.clamp(vp.X / 480, 0.72, 1.1) or 1
local function S(n) return math.floor(n * SCALE) end

-- ── Pencere boyutu (küçültüldü) ───────────────
local W  = isMobile and S(255) or 285
local HH = isMobile and S(370) or 400

-- ── Bağlantı yöneticisi ───────────────────────
local Connections  = {}
local FrameCounter = 0
local FPS          = 60

RS.Heartbeat:Connect(function(dt)
    FPS = math.clamp(1/(dt+0.001),1,144)
    FrameCounter += 1
end)

local function connect(event, fn, tag)
    local c = event:Connect(fn)
    if tag then
        if Connections[tag] then Connections[tag]:Disconnect() end
        Connections[tag] = c
    end
    return c
end
local function disconnect(tag)
    if Connections[tag] then Connections[tag]:Disconnect(); Connections[tag]=nil end
end

-- ── Yardımcılar ──────────────────────────────
local function C()  return lp.Character end
local function R()  local c=C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H()  local c=C(); return c and c:FindFirstChildOfClass("Humanoid") end

local hasDrawing = pcall(function() return Drawing.new end)

-- ── Rol tespiti ──────────────────────────────
local KNIFE_KW = {"knife","mm2knife","sickle","darkblade","elderwood","chrome","godly","uncommon","common","rare","ancient","unique","vintage","legendary"}
local GUN_KW   = {"revolver","gun","sheriff","luger","pistol","magnum"}

local function getRole(plr)
    if plr==lp then return "self" end
    for _, src in pairs({plr.Character, plr:FindFirstChild("Backpack")}) do
        if src then
            for _, t in pairs(src:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    for _,k in pairs(KNIFE_KW) do if n:find(k) then return "murderer" end end
                    for _,g in pairs(GUN_KW)   do if n:find(g) then return "sheriff"  end end
                end
            end
        end
    end
    return "innocent"
end

local RCOL = {murderer=Color3.fromRGB(255,50,50), sheriff=Color3.fromRGB(50,130,255), innocent=Color3.fromRGB(80,220,80)}
local RTXT = {murderer="🔪 KATİL", sheriff="🔫 ŞERİF", innocent="🟢 MASUM"}

-- ── Raycast görünürlük ───────────────────────
local function isVisible(from, to)
    local dir  = to - from
    local dist = dir.Magnitude
    if dist < 0.1 then return true end
    local ray = workspace:Raycast(from, dir.Unit*dist, RaycastParams.new())
    if not ray then return true end
    local char = ray.Instance and ray.Instance:FindFirstAncestorOfClass("Model")
    if char then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr.Character==char then return true end
        end
    end
    return false
end

-- ── En yakın hedef ───────────────────────────
local function findNearest(roles, requireVis, maxDist)
    local r=R(); if not r then return nil,math.huge end
    local best,bestD=nil,maxDist or math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local match=false
        for _,ro in pairs(roles) do if getRole(plr)==ro then match=true; break end end
        if not match then continue end
        local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not t then continue end
        -- Ölü oyuncu filtresi
        local hum=plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health<=0 then continue end
        local d=(t.Position-r.Position).Magnitude
        if d<bestD then
            if requireVis then
                if isVisible(r.Position+Vector3.new(0,2,0), t.Position+Vector3.new(0,2,0)) then
                    bestD=d; best=plr
                end
            else bestD=d; best=plr end
        end
    end
    return best,bestD
end

-- ── Hareket tahmini ──────────────────────────
local prevPos={}
local function predictPos(plr, ahead)
    local root=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local cur=root.Position
    local prev=prevPos[plr]
    local vel=prev and (cur-prev)*60 or Vector3.zero
    prevPos[plr]=cur
    return cur + vel*(ahead or 0.06)
end

-- ══════════════════════════════════════════════
-- SALDIRI MOTORU
-- ✅ IŞINLANMA YOK — sadece döner ve ateş eder
-- ══════════════════════════════════════════════
local _targetPlayer = nil
local throwRemote   = nil
local knifeDelay    = 0.08   -- bıçak cooldown (saniye)
local gunDelay      = 0.05   -- silah cooldown
local knifeCooldown = 0
local gunCooldown   = 0

local function findRemote()
    for _,obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n=obj.Name:lower()
            for _,kw in pairs({"throw","attack","swing","stab","hit","slash","fire","shoot"}) do
                if n:find(kw) then return obj end
            end
        end
    end
    return nil
end
local function getThrowRemote()
    if not throwRemote then throwRemote=findRemote() end
    return throwRemote
end

-- ─────────────────────────────────────────────
-- BIÇAK ATIŞ — IŞINLANMA YOK
-- Sadece: 1) Hedefe dön  2) Remote/Tool ateşle
-- ─────────────────────────────────────────────
local function knifeThrow(target, force)
    if not target then return end
    local now=tick()
    if now-knifeCooldown < knifeDelay and not force then return end
    knifeCooldown=now

    local r=R(); if not r then return end
    local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local hum=target.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health<=0 then return end  -- ölü filtresi

    -- Tahminli hedef pozisyonu
    local aimPos = predictPos(target, 0.08) or tRoot.Position

    -- ✅ Sadece dön, IŞINLANMA YOK
    r.CFrame = CFrame.lookAt(r.Position, Vector3.new(aimPos.X, r.Position.Y, aimPos.Z))

    local c=C(); if not c then return end

    -- Eldeki aracı al
    local tool=nil
    for _,t in pairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n=t.Name:lower()
            for _,k in pairs(KNIFE_KW) do if n:find(k) then tool=t; break end end
        end
    end

    -- Global remote dene
    local remote=getThrowRemote()
    if remote then
        pcall(function() remote:FireServer(aimPos) end)
        pcall(function() remote:FireServer(tRoot) end)
        pcall(function() remote:InvokeServer(aimPos) end)
    end

    -- Tool içindeki remote dene
    if tool then
        pcall(function()
            for _,child in pairs(tool:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    pcall(function() child:FireServer(aimPos) end)
                    pcall(function() child:InvokeServer(aimPos) end)
                end
            end
        end)
        -- Mouse simülasyonu
        pcall(function()
            local ms=lp:GetMouse()
            ms.Target=tRoot; ms.Hit=CFrame.new(aimPos)
        end)
        pcall(function() tool:Activate() end)
    end
end

-- ─────────────────────────────────────────────
-- SİLAH ATIŞ — IŞINLANMA YOK  (Trigger Bot)
-- Katili görür görmez ANINDA ateş eder
-- ─────────────────────────────────────────────
local function gunShoot(target, force)
    if not target then return end
    local now=tick()
    if now-gunCooldown < gunDelay and not force then return end
    gunCooldown=now

    local r=R(); if not r then return end
    local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local hum=target.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health<=0 then return end

    local aimPos=predictPos(target,0.04) or tRoot.Position

    -- ✅ Sadece dön, IŞINLANMA YOK
    r.CFrame = CFrame.lookAt(r.Position, Vector3.new(aimPos.X, r.Position.Y, aimPos.Z))

    local c=C(); if not c then return end

    local tool=nil
    for _,t in pairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n=t.Name:lower()
            for _,g in pairs(GUN_KW) do if n:find(g) then tool=t; break end end
        end
    end

    local remote=getThrowRemote()
    if remote then
        pcall(function() remote:FireServer(aimPos) end)
        pcall(function() remote:FireServer(tRoot) end)
    end

    if tool then
        pcall(function()
            for _,child in pairs(tool:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    pcall(function() child:FireServer(aimPos) end)
                    pcall(function() child:InvokeServer(aimPos) end)
                end
            end
        end)
        pcall(function()
            local ms=lp:GetMouse()
            ms.Target=tRoot; ms.Hit=CFrame.new(aimPos)
        end)
        pcall(function() tool:Activate() end)
    end
end

-- ══════════════════════════════════════════════
-- GUI — KOMPAKT, Küçük boyut
-- ══════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name="MM2Hub"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

local win=Instance.new("Frame",sg)
win.Size=UDim2.fromOffset(W,HH)
win.Position = isMobile and UDim2.new(0,S(6),0,S(6)) or UDim2.new(0.5,-W/2,0.5,-HH/2)
win.BackgroundColor3=Color3.fromRGB(10,10,18); win.BorderSizePixel=0
win.Active=true; win.Draggable=true
Instance.new("UICorner",win).CornerRadius=UDim.new(0,5)
do local s=Instance.new("UIStroke",win); s.Color=Color3.fromRGB(30,120,255); s.Thickness=1.2 end

-- Başlık
local barH=S(34)
local bar=Instance.new("Frame",win)
bar.Size=UDim2.new(1,0,0,barH); bar.BackgroundColor3=Color3.fromRGB(14,14,26); bar.BorderSizePixel=0
Instance.new("UICorner",bar).CornerRadius=UDim.new(0,5)
local bfix=Instance.new("Frame",bar); bfix.Size=UDim2.new(1,0,0.5,0); bfix.Position=UDim2.new(0,0,0.5,0)
bfix.BackgroundColor3=Color3.fromRGB(14,14,26); bfix.BorderSizePixel=0

local function mkL(p,txt,sz,col,xw,yw,ox,oy,xa,f)
    local l=Instance.new("TextLabel",p)
    l.Text=txt; l.TextSize=S(sz or 11); l.TextColor3=col or Color3.new(1,1,1)
    l.Font=f or Enum.Font.GothamBold; l.Size=UDim2.new(xw or 0,ox or 0,yw or 0,oy or 0)
    l.BackgroundTransparency=1; l.TextXAlignment=xa or Enum.TextXAlignment.Left
    return l
end

local icoL=mkL(bar,"🔪",18,nil,0,1,0,barH)
icoL.Position=UDim2.new(0,S(6),0,0); icoL.TextXAlignment=Enum.TextXAlignment.Center

mkL(bar,"MM2 HUB V4",S(11),nil,0,S(18),0,0).Position=UDim2.new(0,S(30),0,S(3))
local ts2=mkL(bar,"MURDER MYSTERY 2",S(7),Color3.fromRGB(30,120,255),0,S(12),0,0,nil,Enum.Font.GothamSemibold)
ts2.Position=UDim2.new(0,S(30),0,S(21))

local fpsLbl=mkL(bar,"60 FPS",7,Color3.fromRGB(80,255,120),0,S(12),0,0,Enum.TextXAlignment.Right,Enum.Font.Gotham)
fpsLbl.Size=UDim2.fromOffset(S(48),S(12)); fpsLbl.Position=UDim2.new(1,-S(112),0,S(3))

local function hBtn(txt,col,ox)
    local bSz=isMobile and S(26) or S(20)
    local b=Instance.new("TextButton",bar)
    b.Size=UDim2.fromOffset(bSz,bSz); b.Position=UDim2.new(1,ox,0.5,-bSz/2)
    b.Text=txt; b.TextSize=S(9); b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=col; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,3)
    return b
end
local bSz2=isMobile and S(28) or S(22)
local closeB=hBtn("✕",Color3.fromRGB(210,30,50),-bSz2-S(4))
local minB  =hBtn("—",Color3.fromRGB(40,40,65),-(bSz2*2)-S(8))
closeB.MouseButton1Click:Connect(function() win.Visible=false end)
local mini=false
minB.MouseButton1Click:Connect(function()
    mini=not mini
    TS:Create(win,TweenInfo.new(0.15),{Size=mini and UDim2.fromOffset(W,barH) or UDim2.fromOffset(W,HH)}):Play()
    minB.Text=mini and "+" or "—"
end)

-- Tab barı
local tabBarH=S(26)
local tabBar=Instance.new("Frame",win)
tabBar.Size=UDim2.new(1,0,0,tabBarH); tabBar.Position=UDim2.new(0,0,0,barH)
tabBar.BackgroundColor3=Color3.fromRGB(12,12,22); tabBar.BorderSizePixel=0
do local l=Instance.new("UIListLayout",tabBar)
   l.FillDirection=Enum.FillDirection.Horizontal
   l.HorizontalAlignment=Enum.HorizontalAlignment.Center
   l.VerticalAlignment=Enum.VerticalAlignment.Center
   l.Padding=UDim.new(0,S(2)) end

local TABS={"👁 ESP","🎯 Oyun","🔪 Saldırı","👥 Oyuncu","⚡ Karakter","🎨 Görsel"}
local tBtns={}; local pages={}; local activeTab=0
local CONTENT_H=HH-barH-tabBarH

local content=Instance.new("Frame",win)
content.Size=UDim2.new(1,0,0,CONTENT_H); content.Position=UDim2.new(0,0,0,barH+tabBarH)
content.BackgroundTransparency=1; content.BorderSizePixel=0

local tabW=isMobile and S(36) or S(42)

local function switchTab(i)
    if activeTab==i then return end; activeTab=i
    for j=1,#TABS do
        TS:Create(tBtns[j],TweenInfo.new(0.12),{
            BackgroundColor3=j==i and Color3.fromRGB(30,120,255) or Color3.fromRGB(18,18,30),
            TextColor3      =j==i and Color3.new(1,1,1) or Color3.fromRGB(110,110,150)
        }):Play()
        pages[j].Visible=(j==i)
    end
end

for i,name in ipairs(TABS) do
    local tb=Instance.new("TextButton",tabBar)
    tb.Size=UDim2.fromOffset(tabW,S(20)); tb.Text=name; tb.TextSize=S(6)
    tb.Font=Enum.Font.GothamSemibold; tb.BorderSizePixel=0
    tb.BackgroundColor3=Color3.fromRGB(18,18,30); tb.TextColor3=Color3.fromRGB(110,110,150)
    Instance.new("UICorner",tb).CornerRadius=UDim.new(0,4)
    tBtns[i]=tb

    local pg=Instance.new("ScrollingFrame",content)
    pg.Size=UDim2.new(1,0,1,0); pg.BackgroundTransparency=1
    pg.ScrollBarThickness=isMobile and S(3) or S(2)
    pg.ScrollBarImageColor3=Color3.fromRGB(30,120,255)
    pg.CanvasSize=UDim2.new(0,0,0,0); pg.AutomaticCanvasSize=Enum.AutomaticSize.Y
    pg.Visible=false; pg.BorderSizePixel=0
    do local ul=Instance.new("UIListLayout",pg)
       ul.Padding=UDim.new(0,S(3)); ul.HorizontalAlignment=Enum.HorizontalAlignment.Center
       local pd=Instance.new("UIPadding",pg)
       pd.PaddingTop=UDim.new(0,S(5)); pd.PaddingLeft=UDim.new(0,S(6)); pd.PaddingRight=UDim.new(0,S(6)) end
    pages[i]=pg; local idx=i
    tb.MouseButton1Click:Connect(function() switchTab(idx) end)
end
switchTab(1)

-- UI Bileşenleri
local TW=TweenInfo.new(0.13,Enum.EasingStyle.Quad)
local BTN_H =isMobile and S(38) or S(30)
local TOG_H =isMobile and S(40) or S(32)
local SLI_H =isMobile and S(52) or S(44)
local FONT_S=isMobile and S(11) or S(10)

local function Sec(pg,txt)
    local f=Instance.new("Frame",pg); f.Size=UDim2.new(1,0,0,S(15)); f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,0,1,0)
    l.Text="  "..txt; l.TextSize=S(8); l.Font=Enum.Font.GothamBold
    l.TextColor3=Color3.fromRGB(30,120,255); l.TextXAlignment=Enum.TextXAlignment.Left; l.BackgroundTransparency=1
end

local function Btn(pg,txt,col,cb)
    local b=Instance.new("TextButton",pg)
    b.Size=UDim2.new(1,0,0,BTN_H); b.Text=txt; b.TextSize=FONT_S
    b.Font=Enum.Font.GothamSemibold; b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=col or Color3.fromRGB(30,120,255); b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(cb)
    b.MouseEnter:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0.3}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0}):Play() end)
    return b
end

local function Tog(pg,txt,cb)
    local row=Instance.new("TextButton",pg)
    row.Size=UDim2.new(1,0,0,TOG_H); row.Text=""
    row.BackgroundColor3=Color3.fromRGB(17,17,28); row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
    local nl=Instance.new("TextLabel",row)
    nl.Size=UDim2.new(0.74,0,1,0); nl.Position=UDim2.new(0,S(8),0,0)
    nl.Text=txt; nl.TextSize=FONT_S; nl.Font=Enum.Font.GothamSemibold
    nl.TextColor3=Color3.fromRGB(205,205,230); nl.TextXAlignment=Enum.TextXAlignment.Left; nl.BackgroundTransparency=1
    local bgW=isMobile and S(42) or S(34)
    local bgH=isMobile and S(20) or S(17)
    local knW=isMobile and S(14) or S(11)
    local bg=Instance.new("Frame",row)
    bg.Size=UDim2.fromOffset(bgW,bgH); bg.Position=UDim2.new(1,-bgW-S(6),0.5,-bgH/2)
    bg.BackgroundColor3=Color3.fromRGB(48,48,65); bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)
    local kn=Instance.new("Frame",bg)
    kn.Size=UDim2.fromOffset(knW,knW); kn.Position=UDim2.new(0,S(2),0.5,-knW/2)
    kn.BackgroundColor3=Color3.fromRGB(155,155,180); kn.BorderSizePixel=0
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)
    local on=false
    local tw2=TweenInfo.new(0.14)
    local onX=bgW-knW-S(2)
    local function set(v)
        on=v
        if v then
            TS:Create(bg,tw2,{BackgroundColor3=Color3.fromRGB(30,120,255)}):Play()
            TS:Create(kn,tw2,{Position=UDim2.new(0,onX,0.5,-knW/2),BackgroundColor3=Color3.new(1,1,1)}):Play()
        else
            TS:Create(bg,tw2,{BackgroundColor3=Color3.fromRGB(48,48,65)}):Play()
            TS:Create(kn,tw2,{Position=UDim2.new(0,S(2),0.5,-knW/2),BackgroundColor3=Color3.fromRGB(155,155,180)}):Play()
        end
        cb(v)
    end
    row.MouseButton1Click:Connect(function() set(not on) end)
    return {set=set,get=function() return on end}
end

local function Sli(pg,txt,mn,mx,def,cb)
    local f=Instance.new("Frame",pg)
    f.Size=UDim2.new(1,0,0,SLI_H); f.BackgroundColor3=Color3.fromRGB(17,17,28)
    f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
    local nl=Instance.new("TextLabel",f); nl.Size=UDim2.new(0.6,0,0,S(18))
    nl.Position=UDim2.new(0,S(8),0,S(4)); nl.Text=txt; nl.TextSize=FONT_S
    nl.Font=Enum.Font.GothamSemibold; nl.TextColor3=Color3.fromRGB(205,205,230)
    nl.TextXAlignment=Enum.TextXAlignment.Left; nl.BackgroundTransparency=1
    local vl=Instance.new("TextLabel",f); vl.Size=UDim2.new(0.36,0,0,S(18))
    vl.Position=UDim2.new(0.6,-S(4),0,S(4)); vl.Text=tostring(def); vl.TextSize=FONT_S
    vl.Font=Enum.Font.GothamBold; vl.TextColor3=Color3.fromRGB(30,120,255)
    vl.TextXAlignment=Enum.TextXAlignment.Right; vl.BackgroundTransparency=1
    local trH=isMobile and S(5) or S(3)
    local tr=Instance.new("Frame",f); tr.Size=UDim2.new(1,-S(16),0,trH)
    tr.Position=UDim2.new(0,S(8),0,SLI_H-trH-S(7)); tr.BackgroundColor3=Color3.fromRGB(36,36,55)
    tr.BorderSizePixel=0; Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
    local p0=(def-mn)/(mx-mn)
    local fi=Instance.new("Frame",tr); fi.Size=UDim2.new(p0,0,1,0)
    fi.BackgroundColor3=Color3.fromRGB(30,120,255); fi.BorderSizePixel=0
    Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)
    local kkSz=isMobile and S(14) or S(10)
    local kk=Instance.new("Frame",tr); kk.Size=UDim2.fromOffset(kkSz,kkSz)
    kk.AnchorPoint=Vector2.new(0.5,0.5); kk.Position=UDim2.new(p0,0,0.5,0)
    kk.BackgroundColor3=Color3.new(1,1,1); kk.BorderSizePixel=0
    Instance.new("UICorner",kk).CornerRadius=UDim.new(1,0)
    local dr=false
    local function upd(x)
        local p=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local v=math.floor(mn+p*(mx-mn)); vl.Text=tostring(v)
        fi.Size=UDim2.new(p,0,1,0); kk.Position=UDim2.new(p,0,0.5,0); cb(v)
    end
    tr.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dr=true; upd(i.Position.X)
        end
    end)
    kk.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true end
    end)
    UIS.InputChanged:Connect(function(i)
        if dr and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end
    end)
end

local function Lbl(pg,txt)
    local l=Instance.new("TextLabel",pg); l.Size=UDim2.new(1,0,0,S(16))
    l.TextSize=S(8); l.Font=Enum.Font.Gotham; l.BackgroundTransparency=1
    l.TextColor3=Color3.fromRGB(120,120,150); l.Text=txt; return l
end

-- ══════════════════════════════════════════════
-- HIZLI BUTONLAR — SOL ÜST (zıplama tuşunu kapatmaz)
-- ══════════════════════════════════════════════
local qBtnSize=isMobile and S(50) or S(38)
local qBtnGap =isMobile and S(5)  or S(4)
local quickBar=Instance.new("Frame",sg)
quickBar.Size=UDim2.fromOffset(qBtnSize,(qBtnSize+qBtnGap)*4)
-- ✅ SOL ÜSTTE konumlandır
quickBar.Position=UDim2.new(0,S(8),0,S(8))
quickBar.BackgroundTransparency=1

local function makeQBtn(icon,color,yIdx,tooltip,onClick)
    local b=Instance.new("TextButton",quickBar)
    b.Size=UDim2.fromOffset(qBtnSize,qBtnSize)
    b.Position=UDim2.fromOffset(0,yIdx*(qBtnSize+qBtnGap))
    b.Text=icon; b.TextSize=isMobile and S(20) or S(16)
    b.Font=Enum.Font.GothamBold; b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=color; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,isMobile and S(12) or S(8))
    do local s=Instance.new("UIStroke",b); s.Color=Color3.new(1,1,1); s.Thickness=0.8; s.Transparency=0.7 end
    local tip=Instance.new("TextLabel",sg)
    tip.Text=tooltip; tip.TextSize=S(9); tip.Font=Enum.Font.GothamSemibold
    tip.Size=UDim2.fromOffset(S(120),S(24))
    tip.BackgroundColor3=Color3.fromRGB(10,10,20); tip.BorderSizePixel=0
    tip.TextColor3=Color3.new(1,1,1); tip.Visible=false
    Instance.new("UICorner",tip).CornerRadius=UDim.new(0,5)
    do local s=Instance.new("UIStroke",tip); s.Color=color; s.Thickness=1 end
    b.MouseEnter:Connect(function()
        local ap=b.AbsolutePosition
        tip.Position=UDim2.fromOffset(ap.X+qBtnSize+S(6),ap.Y)
        tip.Visible=true
    end)
    b.MouseLeave:Connect(function() tip.Visible=false end)
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then
            TS:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.35}):Play()
            local ap=b.AbsolutePosition
            tip.Position=UDim2.fromOffset(ap.X+qBtnSize+S(6),ap.Y)
            tip.Visible=true; task.delay(1.2,function() tip.Visible=false end)
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then
            TS:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play()
        end
    end)
    b.MouseButton1Click:Connect(onClick)
    return b
end

-- Menü aç/kapat
makeQBtn("🔪",Color3.fromRGB(30,100,220),0,"Menü Aç/Kapat",function()
    win.Visible=not win.Visible
end)

-- Anlık bıçak at (ışınlanma yok)
makeQBtn("⚔️",Color3.fromRGB(180,20,20),1,"Bıçak At (Işınlanma Yok)",function()
    local t=_targetPlayer or findNearest({"murderer","innocent","sheriff"},false,200)
    if t then knifeThrow(t,true) end
end)

-- Anlık silah ateşle (ışınlanma yok)
makeQBtn("🔫",Color3.fromRGB(50,80,200),2,"Silah Ateşle (Işınlanma Yok)",function()
    local t=_targetPlayer or findNearest({"murderer"},false,math.huge)
    if t then gunShoot(t,true) end
end)

-- Katilden kaç
makeQBtn("🏃",Color3.fromRGB(30,120,50),3,"Katilden Kaç",function()
    local r=R(); if not r then return end
    local mur=findNearest({"murderer"},false,math.huge)
    if not mur then return end
    local tRoot=mur.Character and mur.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local diff=r.Position-tRoot.Position
    r.CFrame=CFrame.new(r.Position+diff.Unit*35+Vector3.new(0,5,0))
end)

-- ══════════════════════════════════════════════
-- TAB 1 — ESP
-- ══════════════════════════════════════════════
local P1=pages[1]
local espObjs={}; local espOn=false
local function clearESP()
    for _,o in pairs(espObjs) do pcall(function() o:Destroy() end) end; espObjs={}
end
local function buildESP()
    clearESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local char=plr.Character; if not char then continue end
        local head=char:FindFirstChild("Head"); if not head then continue end
        local role=getRole(plr); local col=RCOL[role] or Color3.fromRGB(160,160,160)
        local bill=Instance.new("BillboardGui",head)
        bill.Name="MM2ESP"; bill.AlwaysOnTop=true
        bill.Size=UDim2.fromOffset(S(155),S(52)); bill.StudsOffset=Vector3.new(0,3.5,0)
        local bg=Instance.new("Frame",bill); bg.Size=UDim2.new(1,0,1,0)
        bg.BackgroundColor3=Color3.fromRGB(8,8,14); bg.BackgroundTransparency=0.28; bg.BorderSizePixel=0
        Instance.new("UICorner",bg).CornerRadius=UDim.new(0,5)
        do local st=Instance.new("UIStroke",bg); st.Color=col; st.Thickness=1.1 end
        local r2=R()
        local dist=r2 and math.floor((head.Position-r2.Position).Magnitude) or 0
        local rl=Instance.new("TextLabel",bg); rl.Size=UDim2.new(1,0,0.42,0)
        rl.Text=(RTXT[role] or "❔").."  ["..dist.."m]"; rl.TextSize=S(9); rl.Font=Enum.Font.GothamBold
        rl.TextColor3=col; rl.BackgroundTransparency=1
        local nl=Instance.new("TextLabel",bg); nl.Size=UDim2.new(1,0,0.3,0)
        nl.Position=UDim2.new(0,0,0.42,0); nl.Text=plr.Name; nl.TextSize=S(9)
        nl.Font=Enum.Font.Gotham; nl.TextColor3=Color3.new(1,1,1); nl.BackgroundTransparency=1
        local hum=char:FindFirstChildOfClass("Humanoid")
        local hl=Instance.new("TextLabel",bg); hl.Size=UDim2.new(1,0,0.28,0)
        hl.Position=UDim2.new(0,0,0.72,0); hl.TextSize=S(8); hl.Font=Enum.Font.Gotham
        hl.TextColor3=Color3.fromRGB(100,255,100); hl.BackgroundTransparency=1
        if hum then
            hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hl.Parent then hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth) end
            end)
        end
        table.insert(espObjs,bill)
    end
end

Sec(P1,"ROL ESP")
Tog(P1,"👁 Rol ESP (Katil/Şerif/Masum)",function(on)
    espOn=on; if on then buildESP() else clearESP() end
end)
Btn(P1,"🔄 ESP Yenile",Color3.fromRGB(22,22,38),function() if espOn then buildESP() end end)

-- Coin ESP
local coinESP={}
local function clearCoinESP() for _,o in pairs(coinESP) do pcall(function() o:Destroy() end) end; coinESP={} end
local function buildCoinESP()
    clearCoinESP()
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if obj:IsA("BasePart") and (n:find("coin") or n=="credit" or n=="gem") then
            local bill=Instance.new("BillboardGui",obj)
            bill.Name="CoinESP"; bill.AlwaysOnTop=true
            bill.Size=UDim2.fromOffset(S(50),S(18)); bill.StudsOffset=Vector3.new(0,2.5,0)
            local l=Instance.new("TextLabel",bill); l.Size=UDim2.new(1,0,1,0)
            l.Text="💰"; l.TextSize=S(13); l.Font=Enum.Font.GothamBold
            l.TextColor3=Color3.fromRGB(255,215,0); l.BackgroundTransparency=1
            table.insert(coinESP,bill)
        end
    end
end

local wESP={}
local function clearWESP() for _,o in pairs(wESP) do pcall(function() o:Destroy() end) end; wESP={} end
local function buildWESP()
    clearWESP()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower(); local isk,isg=false,false
            for _,k in pairs(KNIFE_KW) do if n:find(k) then isk=true; break end end
            for _,g in pairs(GUN_KW)   do if n:find(g) then isg=true; break end end
            if isk or isg then
                local h2=obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                if h2 then
                    local bill=Instance.new("BillboardGui",h2); bill.Name="WEsp"; bill.AlwaysOnTop=true
                    bill.Size=UDim2.fromOffset(S(65),S(18)); bill.StudsOffset=Vector3.new(0,2.5,0)
                    local l=Instance.new("TextLabel",bill); l.Size=UDim2.new(1,0,1,0)
                    l.Text=isk and "🔪 BIÇAK" or "🔫 SİLAH"; l.TextSize=S(9); l.Font=Enum.Font.GothamBold
                    l.TextColor3=isk and Color3.fromRGB(255,80,80) or Color3.fromRGB(80,150,255)
                    l.BackgroundTransparency=1; table.insert(wESP,bill)
                end
            end
        end
    end
end

Sec(P1,"COIN & SİLAH ESP")
Tog(P1,"💰 Coin ESP",function(on)
    if on then buildCoinESP()
        connect(workspace.DescendantAdded,function() task.wait(0.1); if on then buildCoinESP() end end,"coinESP")
    else clearCoinESP(); disconnect("coinESP") end
end)
Tog(P1,"🔪 Silah ESP (Yerdeki bıçak/silah)",function(on) if on then buildWESP() else clearWESP() end end)

-- Katil uyarısı
local alertF=Instance.new("Frame",sg)
alertF.Size=UDim2.new(0.65,0,0,S(36)); alertF.Position=UDim2.new(0.175,0,0,S(52))
alertF.BackgroundColor3=Color3.fromRGB(200,20,20); alertF.BackgroundTransparency=0.18
alertF.BorderSizePixel=0; alertF.Visible=false
Instance.new("UICorner",alertF).CornerRadius=UDim.new(0,7)
local alertTxt=Instance.new("TextLabel",alertF); alertTxt.Size=UDim2.new(1,0,1,0)
alertTxt.Text="⚠️  KATİL YAKLAŞIYOR!"; alertTxt.TextSize=S(13)
alertTxt.Font=Enum.Font.GothamBold; alertTxt.TextColor3=Color3.new(1,1,1); alertTxt.BackgroundTransparency=1

local alertDist=15
Sec(P1,"UYARI")
Tog(P1,"⚠️ Katil Uyarısı (Otomatik)",function(on)
    if on then
        connect(RS.Heartbeat,function()
            local r=R(); if not r then return end; local found=false
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t and (t.Position-r.Position).Magnitude<alertDist then found=true; break end
                end
            end
            alertF.Visible=found
        end,"alert")
    else disconnect("alert"); alertF.Visible=false end
end)
Sli(P1,"⚠️ Uyarı Mesafesi",5,80,15,function(v) alertDist=v end)

-- ══════════════════════════════════════════════
-- TAB 2 — OYUN İÇİ
-- ══════════════════════════════════════════════
local P2=pages[2]
Sec(P2,"OTOMATİK")
Tog(P2,"💰 Auto Coin Topla (Otomatik ışın)",function(on)
    if on then
        connect(RS.Heartbeat,function()
            local r=R(); if not r then return end
            local best,bestD=nil,math.huge
            for _,obj in pairs(workspace:GetDescendants()) do
                local n=obj.Name:lower()
                if obj:IsA("BasePart") and (n:find("coin") or n=="credit") then
                    local d=(obj.Position-r.Position).Magnitude
                    if d<bestD then bestD=d; best=obj end
                end
            end
            if best and bestD<80 then r.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0)) end
        end,"autoCoin")
    else disconnect("autoCoin") end
end)

Sec(P2,"TEK TUŞ")
Btn(P2,"🔪 Bıçağa Işınlan",Color3.fromRGB(30,30,50),function()
    local r=R(); if not r then return end
    local best,bestD=nil,math.huge
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower(); local isk=false
            for _,k in pairs(KNIFE_KW) do if n:find(k) then isk=true; break end end
            if isk then local h2=obj:FindFirstChild("Handle")
                if h2 then local d=(h2.Position-r.Position).Magnitude; if d<bestD then bestD=d; best=h2 end end end
        end
    end
    if best then r.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0)) end
end)
Btn(P2,"🔫 Silaha Işınlan",Color3.fromRGB(30,30,50),function()
    local r=R(); if not r then return end
    local best,bestD=nil,math.huge
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower(); local isg=false
            for _,g in pairs(GUN_KW) do if n:find(g) then isg=true; break end end
            if isg then local h2=obj:FindFirstChild("Handle")
                if h2 then local d=(h2.Position-r.Position).Magnitude; if d<bestD then bestD=d; best=h2 end end end
        end
    end
    if best then r.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0)) end
end)

Sec(P2,"KAÇIŞ")
Tog(P2,"🏃 Katilden Kaç (Otomatik)",function(on)
    if on then
        connect(RS.Heartbeat,function()
            local r=R(); if not r then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t then
                        local diff=r.Position-t.Position
                        if diff.Magnitude<25 then r.CFrame=CFrame.new(r.Position+diff.Unit*28+Vector3.new(0,5,0)) end
                    end; break
                end
            end
        end,"flee")
    else disconnect("flee") end
end)
Sec(P2,"KORUMA")
Tog(P2,"🛡️ Respawn Koruması",function(on)
    if on then
        local h=H(); if not h then return end
        connect(h.Died,function() task.wait(0.4); lp:LoadCharacter() end,"respawn")
    else disconnect("respawn") end
end)

-- ══════════════════════════════════════════════
-- TAB 3 — SALDIRI (YENİDEN YAZILDI)
-- ══════════════════════════════════════════════
local P3=pages[3]

Sec(P3,"BIÇAK AYARLARI")
Sli(P3,"⚡ Bıçak Hızı (ms)",20,500,80,function(v) knifeDelay=v/1000 end)
Sli(P3,"⭕ Kill Aura Menzili",3,80,25,function(v)
    -- kill aura menzili güncellenir (aşağıda kullanılır)
    _G.killAuraRange = v
end)
if not _G.killAuraRange then _G.killAuraRange=25 end

-- ─────────────────────────────────────────────
-- OTO BIÇAK — IŞINLANMA YOK
-- Sadece döner, uzaktan remote atar
-- ─────────────────────────────────────────────
Sec(P3,"OTO BIÇAK (IŞINLANMASIZ)")
local autoKnifeStatus=Lbl(P3,"Durum: Kapalı")
Tog(P3,"🔪 Oto Bıçak At (Işınlanma Yok)",function(on)
    autoKnifeStatus.Text=on and "Durum: Aktif 🟢" or "Durum: Kapalı"
    if on then
        connect(RS.Heartbeat,function()
            local c=C(); if not c then return end
            -- Eldeki bıçağı kontrol et
            local hasKnife=false
            for _,t in pairs(c:GetChildren()) do
                if t:IsA("Tool") then
                    local n=t.Name:lower()
                    for _,k in pairs(KNIFE_KW) do if n:find(k) then hasKnife=true; break end end
                end
            end
            if not hasKnife then return end
            local target=_targetPlayer or findNearest({"innocent","sheriff","murderer"},false,math.huge)
            if not target or target==lp then return end
            knifeThrow(target,false)  -- ✅ IŞINLANMA YOK
        end,"autoKnife")
    else disconnect("autoKnife") end
end)

-- ─────────────────────────────────────────────
-- ŞERİF TRIGGER BOT — IŞINLANMA YOK
-- Katili görür görmez ANINDA ateş eder
-- Trigger gibi çalışır, yaklaşma yok
-- ─────────────────────────────────────────────
Sec(P3,"ŞERİF TRIGGER BOT (IŞINLANMASIZ)")
local triggerStatus=Lbl(P3,"Durum: Kapalı")
local triggerMaxDist=600  -- mesafe sınırı yok gibi

Tog(P3,"🔫 Şerif Trigger Bot (Katil Görününce Vur)",function(on)
    triggerStatus.Text=on and "Durum: Aktif 🔴 — Katil görününce ANINDA ateş!" or "Durum: Kapalı"
    if on then
        connect(RS.Heartbeat,function()
            local c=C(); if not c then return end
            -- Elde silah var mı?
            local hasSilah=false
            for _,t in pairs(c:GetChildren()) do
                if t:IsA("Tool") then
                    local n=t.Name:lower()
                    for _,g in pairs(GUN_KW) do if n:find(g) then hasSilah=true; break end end
                end
            end
            if not hasSilah then return end
            -- Katili gör → anında ateş (görünürlük kontrolü)
            local murderer=findNearest({"murderer"},true,triggerMaxDist)
            if not murderer then return end
            gunShoot(murderer,true)  -- ✅ IŞINLANMA YOK, ANINDA ATEŞ
        end,"triggerBot")
    else disconnect("triggerBot") end
end)

Sli(P3,"🔫 Trigger Menzili",10,1000,600,function(v) triggerMaxDist=v end)

-- Kill Aura (bıçak, ışınlanmasız)
Sec(P3,"KILL AURA")
local killAuraStatus=Lbl(P3,"Kill Aura: Kapalı")
Tog(P3,"💀 Kill Aura (Menzildeki herkesi vur)",function(on)
    killAuraStatus.Text=on and "Kill Aura: Aktif 🔴" or "Kill Aura: Kapalı"
    if on then
        connect(RS.Heartbeat,function()
            local r=R(); if not r then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                local tRoot=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not tRoot then continue end
                local dist=(tRoot.Position-r.Position).Magnitude
                if dist<=(_G.killAuraRange or 25) then
                    knifeThrow(plr,true)  -- ✅ IŞINLANMA YOK
                    task.wait(knifeDelay); break
                end
            end
        end,"killAura")
    else disconnect("killAura") end
end)

-- Aimbot / Silent Aim
Sec(P3,"AİMBOT")
Tog(P3,"🎯 Aimbot (Hedefe kamera kilidi)",function(on)
    if on then
        connect(RS.Heartbeat,function()
            local r=R(); if not r then return end
            local target=_targetPlayer or findNearest({"murderer"},true,math.huge)
            if not target then return end
            local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not tRoot then return end
            local aimPos=predictPos(target,0.05) or tRoot.Position
            cam.CFrame=CFrame.lookAt(cam.CFrame.Position,aimPos)
        end,"aimbot")
    else disconnect("aimbot") end
end)
Tog(P3,"🤫 Silent Aim (Gizli yön kilidi)",function(on)
    if on then
        connect(RS.Heartbeat,function()
            local r=R(); if not r then return end
            local target=_targetPlayer or findNearest({"murderer","innocent","sheriff"},true,200)
            if not target then return end
            local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not tRoot then return end
            r.CFrame=CFrame.lookAt(r.Position,Vector3.new(tRoot.Position.X,r.Position.Y,tRoot.Position.Z))
        end,"silentAim")
    else disconnect("silentAim") end
end)
Btn(P3,"🔄 Remote Sıfırla",Color3.fromRGB(22,22,38),function() throwRemote=nil; getThrowRemote() end)

-- ══════════════════════════════════════════════
-- TAB 4 — OYUNCU
-- ══════════════════════════════════════════════
local P4=pages[4]
local selPlr=nil
local selLbl=Instance.new("TextLabel",P4)
selLbl.Size=UDim2.new(1,0,0,S(20)); selLbl.Text="🎯 Seçili: Yok"
selLbl.TextColor3=Color3.fromRGB(30,120,255); selLbl.TextSize=FONT_S
selLbl.Font=Enum.Font.GothamSemibold; selLbl.BackgroundTransparency=1

Sec(P4,"OYUNCU LİSTESİ")
local listSF=Instance.new("ScrollingFrame",P4)
listSF.Size=UDim2.new(1,0,0,isMobile and S(140) or S(120))
listSF.BackgroundColor3=Color3.fromRGB(13,13,21); listSF.BorderSizePixel=0
listSF.ScrollBarThickness=isMobile and S(3) or S(2)
listSF.ScrollBarImageColor3=Color3.fromRGB(30,120,255); listSF.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",listSF).CornerRadius=UDim.new(0,6)

local pBtns={}
local function refreshList()
    for _,b in pairs(pBtns) do pcall(function() b:Destroy() end) end; pBtns={}
    local plrs={}
    for _,p in pairs(Players:GetPlayers()) do if p~=lp then table.insert(plrs,p) end end
    if #plrs==0 then
        local nl=Instance.new("TextLabel",listSF); nl.Size=UDim2.new(1,0,0,S(26))
        nl.Position=UDim2.fromOffset(0,S(4)); nl.Text="Başka oyuncu yok"
        nl.TextSize=FONT_S; nl.Font=Enum.Font.Gotham
        nl.TextColor3=Color3.fromRGB(120,120,150); nl.BackgroundTransparency=1
        table.insert(pBtns,nl); listSF.CanvasSize=UDim2.new(0,0,0,S(32)); return
    end
    local rowH=isMobile and S(36) or S(29)
    for i,plr in ipairs(plrs) do
        local y=(i-1)*rowH
        local role=getRole(plr); local col=RCOL[role] or Color3.fromRGB(160,160,160)
        local r2=R()
        local distStr=r2 and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            and (" ["..math.floor((plr.Character.HumanoidRootPart.Position-r2.Position).Magnitude).."m]") or ""
        local b=Instance.new("TextButton",listSF)
        b.Size=UDim2.new(1,-S(6),0,rowH-S(3)); b.Position=UDim2.fromOffset(S(3),y+S(2))
        b.Text="  "..(RTXT[role] or "❔").."  "..plr.Name..distStr; b.TextSize=FONT_S
        b.Font=Enum.Font.GothamSemibold; b.TextXAlignment=Enum.TextXAlignment.Left
        b.TextColor3=col; b.BackgroundColor3=Color3.fromRGB(18,18,30); b.BorderSizePixel=0
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
        local pr=plr
        b.MouseButton1Click:Connect(function()
            selPlr=pr; _targetPlayer=pr
            selLbl.Text="🎯 Seçili: "..pr.Name.."  ("..(RTXT[role] or "?")..")"
            selLbl.TextColor3=col
            for _,x in pairs(pBtns) do if x:IsA("TextButton") then x.BackgroundColor3=Color3.fromRGB(18,18,30) end end
            b.BackgroundColor3=Color3.fromRGB(30,120,255)
        end)
        table.insert(pBtns,b)
    end
    listSF.CanvasSize=UDim2.new(0,0,0,#plrs*rowH+S(5))
end

Btn(P4,"🔄 Listeyi Yenile",Color3.fromRGB(22,22,38),refreshList)
Sec(P4,"OYUNCU İŞLEMLERİ")
Btn(P4,"📦 Oyuncuya Işınlan",Color3.fromRGB(22,22,38),function()
    if not selPlr then return end
    local r=R(); local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart")
    if r and t then r.CFrame=t.CFrame+Vector3.new(3,2,0) end
end)
Btn(P4,"💥 Fling",Color3.fromRGB(140,30,30),function()
    if not selPlr then return end
    local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart"); if not t then return end
    local v=Instance.new("BodyVelocity",t); v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=Vector3.new(math.random(-700,700),math.random(400,700),math.random(-700,700)); Debris:AddItem(v,0.2)
end)
Tog(P4,"🏃 Oyuncu Takip",function(on)
    if on then
        connect(RS.Heartbeat,function()
            local r=R(); if not r then return end
            local t=selPlr and selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart")
            if t and (t.Position-r.Position).Magnitude>5 then r.CFrame=CFrame.new(t.Position+Vector3.new(3,0,0)) end
        end,"follow")
    else disconnect("follow") end
end)
Btn(P4,"🎯 Saldırı Hedefi Yap",Color3.fromRGB(30,120,255),function() if selPlr then _targetPlayer=selPlr end end)
Btn(P4,"❌ Hedefi Temizle",Color3.fromRGB(22,22,38),function()
    _targetPlayer=nil; selPlr=nil
    selLbl.Text="🎯 Seçili: Yok"; selLbl.TextColor3=Color3.fromRGB(30,120,255)
end)

-- ══════════════════════════════════════════════
-- TAB 5 — KARAKTER
-- ══════════════════════════════════════════════
local P5=pages[5]
Sec(P5,"HAREKET")
Sli(P5,"🏃 Hız",16,300,16,function(v) local h=H(); if h then h.WalkSpeed=v end end)
Sli(P5,"⬆️ Zıplama",50,500,50,function(v)
    local h=H(); if not h then return end
    pcall(function() h.JumpPower=v end); pcall(function() h.JumpHeight=v/5 end)
end)
Sli(P5,"🎥 FOV",50,130,70,function(v) cam.FieldOfView=v end)

local flyOn=false; local fV,fG,fC2
Tog(P5,"🛩️ Uçuş (WASD + Space/Shift)",function(on)
    flyOn=on; local r=R()
    if on and r then
        fG=Instance.new("BodyGyro",r); fG.MaxTorque=Vector3.new(9e8,9e8,9e8); fG.P=9e4
        fV=Instance.new("BodyVelocity",r); fV.MaxForce=Vector3.new(9e8,9e8,9e8); fV.Velocity=Vector3.zero
        fC2=RS.Heartbeat:Connect(function()
            local rt=R(); if not(flyOn and rt) then if fC2 then fC2:Disconnect() end; return end
            local d=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then d+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.new(0,1,0) end
            fV.Velocity=d.Magnitude>0 and d.Unit*80 or Vector3.zero; fG.CFrame=cam.CFrame
        end)
    else
        if fC2 then fC2:Disconnect(); fC2=nil end
        pcall(function() if fV then fV:Destroy() end end); fV=nil
        pcall(function() if fG then fG:Destroy() end end); fG=nil
    end
end)

local ncOn=false
Tog(P5,"🌫️ Noclip",function(on)
    ncOn=on
    if on then
        connect(RS.Stepped,function()
            local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end,"noclip")
    else
        disconnect("noclip")
        local c=C(); if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end)
Tog(P5,"🚀 Sonsuz Zıplama",function(on)
    if on then
        connect(UIS.JumpRequest,function()
            local h=H(); if h and h.FloorMaterial==Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end,"infJump")
    else disconnect("infJump") end
end)

Sec(P5,"KORUMA")
Tog(P5,"🛡️ God Mode",function(on)
    local h=H(); if not h then return end
    if on then
        h.MaxHealth=math.huge; h.Health=math.huge
        connect(h.HealthChanged,function() if h and h.Parent then h.Health=math.huge end end,"god")
    else disconnect("god"); pcall(function() h.MaxHealth=100; h.Health=100 end) end
end)
Tog(P5,"💤 Anti-AFK",function(on)
    if on then
        local vu=game:GetService("VirtualUser")
        connect(RS.Heartbeat,function() vu:Button2Down(Vector2.zero,cam.CFrame); vu:Button2Up(Vector2.zero,cam.CFrame) end,"afk")
    else disconnect("afk") end
end)
Sec(P5,"KİŞİSEL")
Tog(P5,"👻 Görünmez",function(on)
    local c=C(); if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=on and 1 or 0 end
    end
end)
Btn(P5,"☁️ Havaya Zıpla",Color3.fromRGB(25,25,42),function() local r=R(); if r then r.CFrame=r.CFrame+Vector3.new(0,60,0) end end)
Btn(P5,"🔄 Respawn",Color3.fromRGB(25,25,42),function() lp:LoadCharacter() end)

-- ══════════════════════════════════════════════
-- TAB 6 — GÖRSEL
-- ══════════════════════════════════════════════
local P6=pages[6]
local oA=Lighting.Ambient; local oO=Lighting.OutdoorAmbient
local oB=Lighting.Brightness; local oS=Lighting.GlobalShadows; local oCT=Lighting.ClockTime
Sec(P6,"ORTAM")
Tog(P6,"💡 Fullbright",function(on)
    if on then
        Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness=oB; Lighting.ClockTime=oCT; Lighting.GlobalShadows=oS
        Lighting.Ambient=oA; Lighting.OutdoorAmbient=oO
    end
end)
Tog(P6,"🌙 Gece Modu",function(on)
    Lighting.ClockTime=on and 0 or oCT; Lighting.Ambient=on and Color3.fromRGB(20,20,50) or oA
end)
Tog(P6,"🌁 Sisi Kaldır",function(on)
    Lighting.FogEnd=on and 999999 or 1000; Lighting.FogStart=on and 999990 or 0
end)
Sec(P6,"KARAKTER")
Tog(P6,"🌈 Chams (Gökkuşağı)",function(on)
    if on then
        local t2=0
        connect(RS.Heartbeat,function(dt)
            t2=t2+dt; local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color=Color3.fromHSV((t2*0.4)%1,1,1) end end
        end,"chams")
    else disconnect("chams") end
end)
Btn(P6,"🔄 Kamerayı Sıfırla",Color3.fromRGB(22,22,38),function() cam.CameraType=Enum.CameraType.Custom; cam.FieldOfView=70 end)

-- ══════════════════════════════════════════════
-- FPS GÜNCELLE + KLAVYE
-- ══════════════════════════════════════════════
connect(RS.Heartbeat,function()
    fpsLbl.Text=math.floor(FPS).." FPS"
    fpsLbl.TextColor3=FPS>50 and Color3.fromRGB(80,255,120) or FPS>30 and Color3.fromRGB(255,200,50) or Color3.fromRGB(255,60,60)
end,"fpsUpdate")

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then win.Visible=not win.Visible
    elseif i.KeyCode==Enum.KeyCode.Delete  then win.Visible=false
    elseif i.KeyCode==Enum.KeyCode.Insert  then win.Visible=true
    elseif i.KeyCode==Enum.KeyCode.F then
        local t=_targetPlayer or findNearest({"murderer","innocent","sheriff"},false,200)
        if t then knifeThrow(t,true) end   -- ✅ ışınlanma yok
    elseif i.KeyCode==Enum.KeyCode.G then
        local m=findNearest({"murderer"},false,math.huge)
        if m then gunShoot(m,true) end     -- ✅ ışınlanma yok
    end
end)

lp.CharacterAdded:Connect(function(char)
    task.wait(0.8); flyOn=false
    if fC2 then fC2:Disconnect(); fC2=nil end
    pcall(function() if fV then fV:Destroy() end end); fV=nil
    pcall(function() if fG then fG:Destroy() end end); fG=nil
    if ncOn then
        connect(RS.Stepped,function()
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end,"noclip")
    end
    if espOn then task.wait(1); buildESP() end
    throwRemote=nil; prevPos={}
end)

Players.PlayerAdded:Connect(function()   task.wait(0.5); refreshList(); if espOn then buildESP() end end)
Players.PlayerRemoving:Connect(function() task.wait(0.1); refreshList(); if espOn then buildESP() end end)

refreshList()
print("[MM2 HUB V4] Hazır! | F=Bıçak(ışınlanma yok) | G=Silah Trigger | RightShift=Menü")
