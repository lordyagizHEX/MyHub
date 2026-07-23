--[[
  ╔══════════════════════════════════════════════════════════════════╗
  ║        LORD HUB — BROOKHAVEN RP  V2  (MOBİL + PC)              ║
  ║  Otomatik mobil/PC algılama | Dikey şerit GUI                  ║
  ║  Fly · Speed · Fling · ESP · Car Hack · House · Anti-Fling     ║
  ║  God Mode · Noclip · Anti-AFK · Visual FX · +45 Özellik        ║
  ╚══════════════════════════════════════════════════════════════════╝
--]]

-- ── Servisler ───────────────────────────────────────────────────
local Players    = game:GetService("Players")
local RS         = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TS         = game:GetService("TweenService")
local Lighting   = game:GetService("Lighting")
local Debris     = game:GetService("Debris")
local lp         = Players.LocalPlayer
local pgui       = lp.PlayerGui
local cam        = workspace.CurrentCamera

-- Eski GUI temizle
if pgui:FindFirstChild("BKHub") then pgui.BKHub:Destroy() end

-- ── Cihaz Algılama ──────────────────────────────────────────────
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp       = cam.ViewportSize
local SCALE    = isMobile and math.clamp(vp.X / 480, 0.7, 1.25) or 1
local function S(n) return math.floor(n * SCALE) end

-- ── Bağlantı Yöneticisi ─────────────────────────────────────────
local Connections = {}
local function conn(event, fn, tag)
    local c = event:Connect(fn)
    if tag then
        if Connections[tag] then Connections[tag]:Disconnect() end
        Connections[tag] = c
    end
    return c
end
local function disc(tag)
    if Connections[tag] then Connections[tag]:Disconnect(); Connections[tag] = nil end
end

-- ── Temel Yardımcılar ───────────────────────────────────────────
local function C()   return lp.Character end
local function R()   local c = C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H()   local c = C(); return c and c:FindFirstChildOfClass("Humanoid") end

local FPS = 60
conn(RS.Heartbeat, function(dt) FPS = math.clamp(1/(dt+0.001),1,144) end)

-- ════════════════════════════════════════════════════════════════
--  RENK PALETİ — Brookhaven mor/pembe tema
-- ════════════════════════════════════════════════════════════════
local COL = {
    BG        = Color3.fromRGB(24,  3,  19),
    STRIP     = Color3.fromRGB(44,  5,  34),
    STRIP_H   = Color3.fromRGB(120, 18,  92),
    STRIP_ON  = Color3.fromRGB(155, 28, 115),
    ACCENT    = Color3.fromRGB(225, 65, 165),
    ACCENT2   = Color3.fromRGB(150, 18, 110),
    TEXT      = Color3.fromRGB(255, 230, 248),
    SUBTEXT   = Color3.fromRGB(175, 115, 155),
    TOG_OFF   = Color3.fromRGB(58,  18,  48),
    TOG_ON    = Color3.fromRGB(205, 52, 145),
    KNOB_OFF  = Color3.fromRGB(125, 75, 110),
    KNOB_ON   = Color3.fromRGB(255, 220, 245),
    FLING     = Color3.fromRGB(200, 30,  60),   -- Fling vurgu
    FLING_STR = Color3.fromRGB(55,   5,  15),   -- Fling şerit
    CLOSE     = Color3.fromRGB(195, 28,  75),
    MIN_BTN   = Color3.fromRGB(55,  18,  45),
}

-- ════════════════════════════════════════════════════════════════
--  ANA SCREEN GUI
-- ════════════════════════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "BKHub"; sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Boyutlar
local STRIP_W  = S(isMobile and 68 or 72)
local STRIP_H  = S(isMobile and 500 or 520)
local TITLE_H  = S(40)
local SCROLL_W = math.min(math.floor(vp.X * (isMobile and 0.92 or 0.82)), S(900))
local WIN_H    = STRIP_H + TITLE_H + S(12)

-- Ana pencere
local win = Instance.new("Frame", sg)
win.Size      = UDim2.fromOffset(SCROLL_W, WIN_H)
win.Position  = isMobile
    and UDim2.new(0.5,-SCROLL_W/2, 0, S(8))
    or  UDim2.new(0.5,-SCROLL_W/2, 0.5,-WIN_H/2)
win.BackgroundColor3 = COL.BG; win.BorderSizePixel = 0
win.Active = true; win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0, S(10))
do local s=Instance.new("UIStroke",win); s.Color=COL.ACCENT; s.Thickness=1.5 end

-- Başlık barı
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1,0,0,TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(18,2,13); titleBar.BorderSizePixel=0
Instance.new("UICorner",titleBar).CornerRadius=UDim.new(0,S(10))
local tfix=Instance.new("Frame",titleBar); tfix.Size=UDim2.new(1,0,0.5,0)
tfix.Position=UDim2.new(0,0,0.5,0); tfix.BackgroundColor3=Color3.fromRGB(18,2,13); tfix.BorderSizePixel=0

-- Logo
local logoTxt=Instance.new("TextLabel",titleBar)
logoTxt.Size=UDim2.new(0,S(240),1,0); logoTxt.Position=UDim2.new(0,S(12),0,0)
logoTxt.Text="🏠 LORD HUB  ·  Brookhaven RP  V2"
logoTxt.TextSize=S(12); logoTxt.Font=Enum.Font.GothamBold
logoTxt.TextColor3=COL.TEXT; logoTxt.BackgroundTransparency=1
logoTxt.TextXAlignment=Enum.TextXAlignment.Left

-- FPS
local fpsLbl=Instance.new("TextLabel",titleBar)
fpsLbl.Size=UDim2.fromOffset(S(70),TITLE_H); fpsLbl.Position=UDim2.new(1,-S(130),0,0)
fpsLbl.Text="60 FPS"; fpsLbl.TextSize=S(10); fpsLbl.Font=Enum.Font.GothamBold
fpsLbl.TextColor3=Color3.fromRGB(80,255,120); fpsLbl.BackgroundTransparency=1
fpsLbl.TextXAlignment=Enum.TextXAlignment.Right
conn(RS.Heartbeat, function()
    fpsLbl.Text=math.floor(FPS).." FPS"
    fpsLbl.TextColor3 = FPS>50 and Color3.fromRGB(80,255,120)
        or FPS>30 and Color3.fromRGB(255,200,50) or Color3.fromRGB(255,60,60)
end,"fps")

-- Başlık butonları
local function hdrBtn(txt,col,ox)
    local bSz=S(isMobile and 30 or 24)
    local b=Instance.new("TextButton",titleBar)
    b.Size=UDim2.fromOffset(bSz,bSz); b.Position=UDim2.new(1,ox,0.5,-bSz/2)
    b.Text=txt; b.TextSize=S(11); b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=col; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,S(5))
    return b
end
local bSz=S(isMobile and 32 or 26)
local closeB=hdrBtn("✕",COL.CLOSE,-bSz-S(6))
local minB  =hdrBtn("—",COL.MIN_BTN,-(bSz*2)-S(12))
closeB.MouseButton1Click:Connect(function() win.Visible=false end)
local minimized=false
minB.MouseButton1Click:Connect(function()
    minimized=not minimized
    TS:Create(win,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{
        Size=minimized and UDim2.fromOffset(SCROLL_W,TITLE_H) or UDim2.fromOffset(SCROLL_W,WIN_H)
    }):Play(); minB.Text=minimized and "+" or "—"
end)

-- Yatay kaydırma
local scrollF=Instance.new("ScrollingFrame",win)
scrollF.Size=UDim2.new(1,0,1,-TITLE_H); scrollF.Position=UDim2.new(0,0,0,TITLE_H)
scrollF.BackgroundTransparency=1
scrollF.ScrollBarThickness=isMobile and S(4) or S(3)
scrollF.ScrollBarImageColor3=COL.ACCENT
scrollF.ScrollingDirection=Enum.ScrollingDirection.X
scrollF.CanvasSize=UDim2.new(0,0,1,0); scrollF.AutomaticCanvasSize=Enum.AutomaticSize.X
scrollF.BorderSizePixel=0
local hLayout=Instance.new("UIListLayout",scrollF)
hLayout.FillDirection=Enum.FillDirection.Horizontal
hLayout.VerticalAlignment=Enum.VerticalAlignment.Center
hLayout.Padding=UDim.new(0,S(4))
local hPad=Instance.new("UIPadding",scrollF)
hPad.PaddingLeft=UDim.new(0,S(6)); hPad.PaddingRight=UDim.new(0,S(6))
hPad.PaddingTop=UDim.new(0,S(6));  hPad.PaddingBottom=UDim.new(0,S(6))

-- ════════════════════════════════════════════════════════════════
--  ŞERİT (STRIP) BİLEŞENİ
--  Renk parametresiyle fling şeritleri kırmızı olabilir
-- ════════════════════════════════════════════════════════════════
local TW = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

local function makeStrip(label, tag, toggleCb, iconChar, overrideColors)
    local oc    = overrideColors or {}
    local SBASE = oc.base  or COL.STRIP
    local SON   = oc.on    or COL.STRIP_ON
    local SHOV  = oc.hover or COL.STRIP_H

    local f=Instance.new("Frame",scrollF)
    f.Size=UDim2.fromOffset(STRIP_W, STRIP_H-S(12))
    f.BackgroundColor3=SBASE; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,S(8))
    do local st=Instance.new("UIStroke",f); st.Color=oc.stroke or COL.ACCENT2; st.Thickness=0.8; st.Transparency=0.5 end

    -- Döndürülmüş metin
    local rotF=Instance.new("Frame",f)
    rotF.Size=UDim2.new(0,STRIP_H-S(70),0,STRIP_W-S(10))
    rotF.Position=UDim2.new(0.5,-(STRIP_H-S(70))/2,0,S(5))
    rotF.BackgroundTransparency=1; rotF.Rotation=90
    local lbl=Instance.new("TextLabel",rotF)
    lbl.Size=UDim2.new(1,0,1,0); lbl.Text=label
    lbl.TextSize=S(isMobile and 12 or 11); lbl.Font=Enum.Font.GothamBold
    lbl.TextColor3=oc.text or COL.TEXT; lbl.BackgroundTransparency=1
    lbl.TextXAlignment=Enum.TextXAlignment.Center; lbl.TextWrapped=false

    -- Alt bölge
    local botH=S(60)
    local bot=Instance.new("Frame",f)
    bot.Size=UDim2.new(1,0,0,botH); bot.Position=UDim2.new(0,0,1,-botH)
    bot.BackgroundTransparency=1

    local isOn=false
    local knob, bgTog

    if toggleCb then
        local bgW=S(isMobile and 44 or 38); local bgH=S(isMobile and 22 or 18)
        local knW=S(isMobile and 15 or 12)
        bgTog=Instance.new("Frame",bot)
        bgTog.Size=UDim2.fromOffset(bgW,bgH); bgTog.Position=UDim2.new(0.5,-bgW/2,0.5,-bgH/2)
        bgTog.BackgroundColor3=COL.TOG_OFF; bgTog.BorderSizePixel=0
        Instance.new("UICorner",bgTog).CornerRadius=UDim.new(1,0)
        knob=Instance.new("Frame",bgTog)
        knob.Size=UDim2.fromOffset(knW,knW); knob.Position=UDim2.new(0,S(3),0.5,-knW/2)
        knob.BackgroundColor3=COL.KNOB_OFF; knob.BorderSizePixel=0
        Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
        if iconChar then
            local ico2=Instance.new("TextLabel",bot); ico2.Size=UDim2.new(1,0,0,S(22))
            ico2.Position=UDim2.new(0,0,0,S(2)); ico2.Text=iconChar; ico2.TextSize=S(15)
            ico2.Font=Enum.Font.GothamBold; ico2.BackgroundTransparency=1
            ico2.TextColor3=oc.icon or COL.SUBTEXT
        end
    else
        local ico=Instance.new("TextLabel",bot)
        ico.Size=UDim2.new(1,0,1,0); ico.Text=iconChar or "▶"; ico.TextSize=S(20)
        ico.Font=Enum.Font.GothamBold; ico.TextColor3=oc.icon or COL.ACCENT
        ico.BackgroundTransparency=1
    end

    -- Tıklama
    local btn=Instance.new("TextButton",f)
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""
    btn.MouseEnter:Connect(function() TS:Create(f,TW,{BackgroundColor3=SHOV}):Play() end)
    btn.MouseLeave:Connect(function() TS:Create(f,TW,{BackgroundColor3=isOn and SON or SBASE}):Play() end)

    local function applyState(v)
        isOn=v
        if toggleCb then
            local knW2=S(isMobile and 15 or 12); local bgW2=S(isMobile and 44 or 38)
            if v then
                TS:Create(bgTog,TW,{BackgroundColor3=COL.TOG_ON}):Play()
                TS:Create(knob,TW,{Position=UDim2.new(0,bgW2-knW2-S(3),0.5,-knW2/2),BackgroundColor3=COL.KNOB_ON}):Play()
                TS:Create(f,TW,{BackgroundColor3=SON}):Play()
                lbl.TextColor3=oc.icon or COL.ACCENT
            else
                TS:Create(bgTog,TW,{BackgroundColor3=COL.TOG_OFF}):Play()
                TS:Create(knob,TW,{Position=UDim2.new(0,S(3),0.5,-knW2/2),BackgroundColor3=COL.KNOB_OFF}):Play()
                TS:Create(f,TW,{BackgroundColor3=SBASE}):Play()
                lbl.TextColor3=oc.text or COL.TEXT
            end
            toggleCb(v)
        end
    end
    btn.MouseButton1Click:Connect(function()
        if toggleCb then applyState(not isOn)
        else
            TS:Create(f,TweenInfo.new(0.05),{BackgroundColor3=SHOV}):Play()
            task.delay(0.12,function() TS:Create(f,TW,{BackgroundColor3=SBASE}):Play() end)
        end
    end)
    return {frame=f, set=applyState, get=function() return isOn end, btn=btn, lbl=lbl, tag=tag}
end

-- Buton şeridi (togglesız)
local function makeBtnStrip(label, icon, cb, overrideColors)
    local s=makeStrip(label, label, nil, icon, overrideColors)
    s.btn.MouseButton1Click:Connect(cb)
    return s
end

-- Kategori ayıracı
local function makeDivider(label)
    local f=Instance.new("Frame",scrollF)
    f.Size=UDim2.fromOffset(S(isMobile and 26 or 22),STRIP_H-S(12))
    f.BackgroundTransparency=1; f.BorderSizePixel=0
    local line=Instance.new("Frame",f); line.Size=UDim2.new(0,S(2),0.88,0)
    line.Position=UDim2.new(0.5,-S(1),0.06,0)
    line.BackgroundColor3=COL.ACCENT2; line.BorderSizePixel=0; line.BackgroundTransparency=0.45
    local rF=Instance.new("Frame",f); rF.Size=UDim2.new(0,S(82),0,S(20))
    rF.Position=UDim2.new(0.5,-S(41),0.5,-S(10)); rF.BackgroundTransparency=1; rF.Rotation=90
    local l=Instance.new("TextLabel",rF); l.Size=UDim2.new(1,0,1,0); l.Text=label
    l.TextSize=S(7); l.Font=Enum.Font.GothamBold; l.TextColor3=COL.ACCENT2; l.BackgroundTransparency=1
end

-- ════════════════════════════════════════════════════════════════
--  FLING MOTORU — Brookhaven Uyumlu
--  BodyVelocity + BodyForce kombinasyonu, Debris ile temizleme
--  pcall ile korunmuş, crash yok
-- ════════════════════════════════════════════════════════════════

-- Fling modu ayarları
local FLING_POWER  = 300   -- Temel güç (değiştirilebilir)
local FLING_UP     = 250   -- Yukarı bileşen
local FLING_SPIN   = 800   -- Dönüş momenti

-- Tek oyuncuya fling uygula (ana fonksiyon)
local function doFling(target, power, upPow, spinPow)
    power   = power   or FLING_POWER
    upPow   = upPow   or FLING_UP
    spinPow = spinPow or FLING_SPIN

    if not target or not target.Character then return false end
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return false end

    -- Hız yönü: self → target (ya da rastgele)
    local r2   = R()
    local dir
    if r2 then
        dir = (tRoot.Position - r2.Position)
        dir = dir.Magnitude > 0.1 and dir.Unit or Vector3.new(math.random()-0.5,0,math.random()-0.5).Unit
    else
        dir = Vector3.new(math.random()-0.5, 0, math.random()-0.5).Unit
    end

    -- BodyVelocity — ana itme
    pcall(function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity  = dir * power + Vector3.new(0, upPow, 0)
        bv.Parent    = tRoot
        Debris:AddItem(bv, 0.12)
    end)

    -- BodyAngularVelocity — dönüş (Brookhaven'da ragdoll etkisi)
    pcall(function()
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque   = Vector3.new(1e9, 1e9, 1e9)
        bav.AngularVelocity = Vector3.new(
            math.random(-spinPow, spinPow),
            math.random(-spinPow, spinPow),
            math.random(-spinPow, spinPow)
        )
        bav.Parent = tRoot
        Debris:AddItem(bav, 0.12)
    end)

    return true
end

-- Tüm oyunculara fling
local function doFlingAll(power, up, spin)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            doFling(plr, power, up, spin)
            task.wait(0.02)
        end
    end
end

-- Seçili oyuncu değişkeni
local selPlayer = nil

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 1 — KARAKTER
-- ════════════════════════════════════════════════════════════════
makeDivider("KARAKTERi")

-- Speed
makeStrip("⚡ SPEED\nHACK","speed",function(on)
    if on then
        conn(RS.Heartbeat,function() local h=H(); if h then h.WalkSpeed=80 end end,"speed")
    else disc("speed"); local h=H(); if h then h.WalkSpeed=16 end end
end,"⚡")

-- Süper Zıplama
makeStrip("🦘 SÜPER\nZIPLAMA","sjump",function(on)
    if on then
        conn(RS.Heartbeat,function()
            local h=H(); if not h then return end
            pcall(function() h.JumpPower=200 end); pcall(function() h.JumpHeight=50 end)
        end,"sjump")
    else disc("sjump")
        local h=H(); if not h then return end
        pcall(function() h.JumpPower=50 end); pcall(function() h.JumpHeight=7.2 end)
    end
end,"🦘")

-- Sonsuz Zıplama
makeStrip("♾️ SONSUZ\nZIPLAMA","infJump",function(on)
    if on then
        conn(UIS.JumpRequest,function()
            local h=H(); if h and h.FloorMaterial==Enum.Material.Air then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end,"infJump")
    else disc("infJump") end
end,"♾️")

-- Uçuş
local flyOn=false; local fV,fG,fCon
makeStrip("🛩️ UÇUŞ\nMODU","fly",function(on)
    flyOn=on; local r2=R()
    if on and r2 then
        fG=Instance.new("BodyGyro",r2); fG.MaxTorque=Vector3.new(9e8,9e8,9e8); fG.P=9e4
        fV=Instance.new("BodyVelocity",r2); fV.MaxForce=Vector3.new(9e8,9e8,9e8); fV.Velocity=Vector3.zero
        fCon=RS.Heartbeat:Connect(function()
            local rt=R(); if not(flyOn and rt) then if fCon then fCon:Disconnect() end; return end
            local d=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then d+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.new(0,1,0) end
            local spd=UIS:IsKeyDown(Enum.KeyCode.LeftControl) and 220 or 95
            fV.Velocity=d.Magnitude>0 and d.Unit*spd or Vector3.zero; fG.CFrame=cam.CFrame
        end)
    else
        if fCon then fCon:Disconnect(); fCon=nil end
        pcall(function() if fV then fV:Destroy() end end); fV=nil
        pcall(function() if fG then fG:Destroy() end end); fG=nil
    end
end,"🛩️")

-- Noclip
local ncOn=false
makeStrip("👻 NO\nCLİP","noclip",function(on)
    ncOn=on
    if on then
        conn(RS.Stepped,function()
            local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end,"noclip")
    else disc("noclip")
        local c=C(); if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end,"👻")

-- God Mode
makeStrip("🛡️ GOD\nMODE","god",function(on)
    local h=H(); if not h then return end
    if on then
        h.MaxHealth=math.huge; h.Health=math.huge
        conn(h.HealthChanged,function() if h and h.Parent then h.Health=math.huge end end,"god")
    else disc("god"); pcall(function() h.MaxHealth=100; h.Health=100 end) end
end,"🛡️")

-- Görünmez
makeStrip("🫥 GÖRÜN\nMEZ","invis",function(on)
    local c=C(); if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=on and 1 or 0 end
    end
end,"🫥")

-- Anti-AFK
makeStrip("🟢 ANTİ\nAFK","afk",function(on)
    if on then local vu=game:GetService("VirtualUser")
        conn(RS.Heartbeat,function() vu:Button2Down(Vector2.zero,cam.CFrame); vu:Button2Up(Vector2.zero,cam.CFrame) end,"afk")
    else disc("afk") end
end,"🟢")

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 2 — GÖRSEL EFEKTLER
-- ════════════════════════════════════════════════════════════════
makeDivider("GÖRSEL")

local oA=Lighting.Ambient; local oOA=Lighting.OutdoorAmbient
local oB=Lighting.Brightness; local oGS=Lighting.GlobalShadows; local oCT=Lighting.ClockTime

makeStrip("💡 FULL\nBRIGHT","fb",function(on)
    if on then
        Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=999999
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness=oB; Lighting.ClockTime=oCT; Lighting.GlobalShadows=oGS
        Lighting.Ambient=oA; Lighting.OutdoorAmbient=oOA; Lighting.FogEnd=1000
    end
end,"💡")

makeStrip("🌙 GECE\nMODU","night",function(on)
    if on then Lighting.ClockTime=0; Lighting.Ambient=Color3.fromRGB(20,20,60); Lighting.OutdoorAmbient=Color3.fromRGB(10,10,40)
    else Lighting.ClockTime=oCT; Lighting.Ambient=oA; Lighting.OutdoorAmbient=oOA end
end,"🌙")

makeStrip("🌈 RAIN\nBOW","rainbow",function(on)
    if on then local t2=0
        conn(RS.Heartbeat,function(dt)
            t2=t2+dt; local c=C(); if not c then return end
            local col=Color3.fromHSV((t2*0.3)%1,1,1)
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color=col end end
        end,"rainbow")
    else disc("rainbow")
        local c=C(); if c then for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.Color=Color3.fromRGB(163,162,165) end) end end end
    end
end,"🌈")

makeStrip("🌁 SİSİ\nKALDIR","fog",function(on)
    Lighting.FogEnd=on and 999999 or 1000; Lighting.FogStart=on and 999990 or 0
end,"🌁")

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 3 — ESP
-- ════════════════════════════════════════════════════════════════
makeDivider("ESP")

local espObjs={}
local function clearESP() for _,o in pairs(espObjs) do pcall(function() o:Destroy() end) end; espObjs={} end
local function buildESP()
    clearESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local char=plr.Character; if not char then continue end
        local head=char:FindFirstChild("Head"); if not head then continue end
        local r2=R()
        local dist=r2 and math.floor((head.Position-r2.Position).Magnitude) or 0
        local hum=char:FindFirstChildOfClass("Humanoid")
        local bill=Instance.new("BillboardGui",head)
        bill.Name="BKEsp"; bill.AlwaysOnTop=true
        bill.Size=UDim2.fromOffset(S(165),S(56)); bill.StudsOffset=Vector3.new(0,3.5,0)
        local bg=Instance.new("Frame",bill); bg.Size=UDim2.new(1,0,1,0)
        bg.BackgroundColor3=Color3.fromRGB(10,4,8); bg.BackgroundTransparency=0.22; bg.BorderSizePixel=0
        Instance.new("UICorner",bg).CornerRadius=UDim.new(0,S(6))
        do local st=Instance.new("UIStroke",bg); st.Color=COL.ACCENT; st.Thickness=1.2 end
        local rl=Instance.new("TextLabel",bg); rl.Size=UDim2.new(1,0,0.45,0)
        rl.Text="👤 "..plr.Name.." ["..dist.."m]"; rl.TextSize=S(10); rl.Font=Enum.Font.GothamBold
        rl.TextColor3=COL.ACCENT; rl.BackgroundTransparency=1
        if hum then
            local hl=Instance.new("TextLabel",bg); hl.Size=UDim2.new(1,0,0.3,0)
            hl.Position=UDim2.new(0,0,0.45,0); hl.TextSize=S(9); hl.Font=Enum.Font.Gotham
            hl.TextColor3=Color3.fromRGB(100,255,100); hl.BackgroundTransparency=1
            hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hl.Parent then hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth) end
            end)
        end
        local tl=Instance.new("TextLabel",bg); tl.Size=UDim2.new(1,0,0.25,0)
        tl.Position=UDim2.new(0,0,0.75,0); tl.TextSize=S(8); tl.Font=Enum.Font.Gotham
        tl.TextColor3=COL.SUBTEXT; tl.BackgroundTransparency=1
        tl.Text="🏠 "..(plr.Team and plr.Team.Name or "Takımsız")
        table.insert(espObjs,bill)
    end
end

makeStrip("👁️ OYUNCU\nESP","esp",function(on)
    if on then buildESP()
        conn(RS.Heartbeat,function()
            for _,o in pairs(espObjs) do if not(o and o.Parent) then clearESP(); buildESP(); break end end
        end,"espWatch")
    else clearESP(); disc("espWatch") end
end,"👁️")

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 4 — ARAÇ SİSTEMLERİ
-- ════════════════════════════════════════════════════════════════
makeDivider("ARAÇ")

-- Araç Hız
local boostedCars={}
makeStrip("🚗 ARAÇ\nHIZI","carhack",function(on)
    if on then
        conn(RS.Heartbeat,function()
            local r2=R(); if not r2 then return end
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") and not boostedCars[obj] then
                    if (obj.Position-r2.Position).Magnitude<22 then
                        pcall(function() obj.MaxSpeed=200; obj.Torque=250000 end)
                        boostedCars[obj]=true
                    end
                end
            end
        end,"carhack")
    else disc("carhack")
        for s,_ in pairs(boostedCars) do pcall(function() s.MaxSpeed=60; s.Torque=10000 end) end
        boostedCars={}
    end
end,"🚗")

-- Araç Fling — araçtaki sürücüyü/yolcuyu fırlat
makeStrip("🚀 ARAÇ\nFLİNG","carFling",function(on)
    if on then
        conn(RS.Heartbeat,function()
            local r2=R(); if not r2 then return end
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
                    local occ=obj.Occupant
                    if occ and (obj.Position-r2.Position).Magnitude<35 then
                        local occRoot=occ.Parent and occ.Parent:FindFirstChild("HumanoidRootPart")
                        if occRoot then
                            pcall(function()
                                local bv=Instance.new("BodyVelocity",occRoot)
                                bv.MaxForce=Vector3.new(1e9,1e9,1e9)
                                bv.Velocity=Vector3.new(math.random(-250,250),500,math.random(-250,250))
                                Debris:AddItem(bv,0.12)
                            end)
                        end
                    end
                end
            end
        end,"carFling")
    else disc("carFling") end
end,"🚀")

-- Araç Kaldır (tüm araçları sil)
makeBtnStrip("🗑️ ARAÇLARI\nKALDIR","🗑️",function()
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if obj:IsA("Model") and (n:find("car") or n:find("vehicle") or n:find("truck") or n:find("bus")) then
            pcall(function() obj:Destroy() end)
        end
    end
end)

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 5 — FLİNG SİSTEMLERİ
-- ════════════════════════════════════════════════════════════════
makeDivider("FLİNG")

-- Ortak fling renk teması (kırmızı)
local FCLR = {
    base   = Color3.fromRGB(50,  4, 12),
    on     = Color3.fromRGB(130, 15, 35),
    hover  = Color3.fromRGB(180, 22, 50),
    stroke = Color3.fromRGB(220, 40, 70),
    text   = Color3.fromRGB(255, 210, 220),
    icon   = Color3.fromRGB(255, 80, 110),
}

-- ── 1. SEÇİLİ OYUNCU FLİNG ──────────────────────────────────────
-- (selPlayer değişkenini kullanır, oyuncu seçimi için oyuncu listesini kullan)
makeBtnStrip("🌀 SEÇİLİ\nFLİNG","🌀",function()
    if not selPlayer then
        -- Yakındaki oyuncuyu otomatik seç
        local r2=R(); if not r2 then return end
        local best,bestD=nil,math.huge
        for _,plr in pairs(Players:GetPlayers()) do
            if plr==lp then continue end
            local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if t then local d=(t.Position-r2.Position).Magnitude; if d<bestD then bestD=d; best=plr end end
        end
        selPlayer=best
    end
    doFling(selPlayer, FLING_POWER, FLING_UP, FLING_SPIN)
end,FCLR)

-- ── 2. TÜM OYUNCULAR FLİNG ──────────────────────────────────────
makeBtnStrip("💥 HERKESİ\nFLİNG","💥",function()
    doFlingAll(FLING_POWER, FLING_UP, FLING_SPIN)
end,FCLR)

-- ── 3. SÜPER FLİNG (AŞIRI GÜÇ) ──────────────────────────────────
makeBtnStrip("☄️ SÜPER\nFLİNG","☄️",function()
    doFlingAll(1200, 800, 2000)
end,FCLR)

-- ── 4. YALNIZCA YUKARI FLİNG (Straight Up) ──────────────────────
makeBtnStrip("🆙 YUKARI\nFLİNG","🆙",function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local tRoot=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            pcall(function()
                local bv=Instance.new("BodyVelocity",tRoot)
                bv.MaxForce=Vector3.new(0,1e9,0)
                bv.Velocity=Vector3.new(0,1800,0)
                Debris:AddItem(bv,0.1)
            end)
            task.wait(0.02)
        end
    end
end,FCLR)

-- ── 5. OTOMATİK FLİNG (Yakın oyuncuları sürekli fırlat) ──────────
makeStrip("🔁 OTOMAT\nFLİNG","autoFling",function(on)
    if on then
        conn(RS.Heartbeat,function()
            local r2=R(); if not r2 then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if t and (t.Position-r2.Position).Magnitude<40 then
                    doFling(plr,350,280,900)
                end
            end
        end,"autoFling")
    else disc("autoFling") end
end,"🔁",FCLR)

-- ── 6. DOKUNMA FLİNG (Bana dokunan fırlar) ─────────────────────
makeStrip("👊 DOKUN\nFLİNG","touchFling",function(on)
    if on then
        conn(RS.Heartbeat,function()
            local c=C(); if not c then return end
            local r2=R(); if not r2 then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if t and (t.Position-r2.Position).Magnitude<5 then
                    doFling(plr,500,400,1200)
                end
            end
        end,"touchFling")
    else disc("touchFling") end
end,"👊",FCLR)

-- ── 7. ORBİTAL FLİNG (Daire çizip fırlat) ───────────────────────
local orbitalOn=false; local orbCount=0
makeStrip("🌐 ORBİTAL\nFLİNG","orbital",function(on)
    orbitalOn=on
    if on then
        conn(RS.Heartbeat,function(dt)
            local r2=R(); if not r2 or not orbitalOn then return end
            orbCount=orbCount+dt*3
            for i,plr in ipairs(Players:GetPlayers()) do
                if plr==lp then continue end
                local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if t then
                    local angle=orbCount+(i-1)*(math.pi*2/math.max(#Players:GetPlayers()-1,1))
                    local radius=12
                    local targetPos=r2.Position+Vector3.new(math.cos(angle)*radius,2,math.sin(angle)*radius)
                    pcall(function()
                        local bv=Instance.new("BodyPosition",t)
                        bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.P=5000; bv.D=500
                        bv.Position=targetPos
                        Debris:AddItem(bv,0.05)
                    end)
                end
            end
        end,"orbital")

        -- 6 saniye sonra herkesi fırlat
        task.delay(6,function()
            if orbitalOn then
                doFlingAll(600,500,1500)
                orbitalOn=false; disc("orbital")
            end
        end)
    else disc("orbital"); orbCount=0 end
end,"🌐",FCLR)

-- ── 8. ANTİ-FLİNG (Kendini koruma) ─────────────────────────────
makeStrip("🧲 ANTİ\nFLİNG","antiFling",function(on)
    if on then
        local r2=R(); if not r2 then return end
        -- BodyPosition ile yerimizi sabitle
        conn(RS.Heartbeat,function()
            local rt=R(); if not rt then return end
            -- Yüksek hız algıla → sıfırla
            local vel=rt.AssemblyLinearVelocity
            if vel.Magnitude>80 then
                pcall(function()
                    local bp=Instance.new("BodyPosition",rt)
                    bp.MaxForce=Vector3.new(1e9,1e9,1e9); bp.P=8000; bp.D=1000
                    bp.Position=rt.Position
                    Debris:AddItem(bp,0.08)
                    local bav=Instance.new("BodyAngularVelocity",rt)
                    bav.MaxTorque=Vector3.new(1e9,1e9,1e9); bav.AngularVelocity=Vector3.zero
                    Debris:AddItem(bav,0.08)
                end)
            end
        end,"antiFling")
    else disc("antiFling") end
end,"🧲",FCLR)

-- ── 9. ARAÇ FLING (Seçili oyuncuya araçla çarp) ─────────────────
makeBtnStrip("🚗 ARAÇLA\nFLİNG","🚗",function()
    -- En yakın VehicleSeat'i bul, Occupant varsa fırlat
    local r2=R(); if not r2 then return end
    local best,bestD=nil,math.huge
    for _,seat in pairs(workspace:GetDescendants()) do
        if (seat:IsA("VehicleSeat") or seat:IsA("Seat")) then
            local d=(seat.Position-r2.Position).Magnitude
            if d<bestD then bestD=d; best=seat end
        end
    end
    if best then
        pcall(function()
            local bv=Instance.new("BodyVelocity",best)
            bv.MaxForce=Vector3.new(1e9,1e9,1e9)
            -- Seçili oyuncuya doğru fırlat
            local dir2=Vector3.new(1,0.6,0)
            if selPlayer then
                local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
                if t then dir2=((t.Position-best.Position).Unit+Vector3.new(0,0.4,0)) end
            end
            bv.Velocity=dir2*400
            Debris:AddItem(bv,0.3)
        end)
    end
end,FCLR)

-- ── 10. FLING GÜCÜ ARTTIR / AZALT ───────────────────────────────
-- (Şerit olarak gösterme, sağ kenara buton ekle)
local flingPowerLbl
do
    local f=Instance.new("Frame",scrollF)
    f.Size=UDim2.fromOffset(STRIP_W,STRIP_H-S(12))
    f.BackgroundColor3=FCLR.base; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,S(8))
    do local st=Instance.new("UIStroke",f); st.Color=FCLR.stroke; st.Thickness=0.8; st.Transparency=0.5 end

    local rotF=Instance.new("Frame",f); rotF.Size=UDim2.new(0,STRIP_H-S(70),0,STRIP_W-S(10))
    rotF.Position=UDim2.new(0.5,-(STRIP_H-S(70))/2,0,S(5)); rotF.BackgroundTransparency=1; rotF.Rotation=90
    local lbl2=Instance.new("TextLabel",rotF); lbl2.Size=UDim2.new(1,0,1,0); lbl2.Text="⚙️ FLİNG\nGÜCÜ"
    lbl2.TextSize=S(isMobile and 12 or 11); lbl2.Font=Enum.Font.GothamBold
    lbl2.TextColor3=FCLR.text; lbl2.BackgroundTransparency=1; lbl2.TextXAlignment=Enum.TextXAlignment.Center

    local botH=S(60)
    flingPowerLbl=Instance.new("TextLabel",f)
    flingPowerLbl.Size=UDim2.fromOffset(STRIP_W,S(22))
    flingPowerLbl.Position=UDim2.new(0,0,1,-botH+S(4))
    flingPowerLbl.Text="300"; flingPowerLbl.TextSize=S(14); flingPowerLbl.Font=Enum.Font.GothamBold
    flingPowerLbl.TextColor3=FCLR.icon; flingPowerLbl.BackgroundTransparency=1

    local upBtn=Instance.new("TextButton",f); upBtn.Size=UDim2.fromOffset(S(28),S(22))
    upBtn.Position=UDim2.new(0.5,-S(14),1,-botH+S(28)); upBtn.Text="▲"; upBtn.TextSize=S(11)
    upBtn.Font=Enum.Font.GothamBold; upBtn.TextColor3=Color3.new(1,1,1)
    upBtn.BackgroundColor3=Color3.fromRGB(180,22,50); upBtn.BorderSizePixel=0
    Instance.new("UICorner",upBtn).CornerRadius=UDim.new(0,S(4))
    upBtn.MouseButton1Click:Connect(function()
        FLING_POWER=math.min(FLING_POWER+50,2000); FLING_UP=math.min(FLING_UP+40,1500)
        flingPowerLbl.Text=tostring(FLING_POWER)
    end)

    local dnBtn=Instance.new("TextButton",f); dnBtn.Size=UDim2.fromOffset(S(28),S(22))
    dnBtn.Position=UDim2.new(0.5,-S(14),1,-S(12)); dnBtn.Text="▼"; dnBtn.TextSize=S(11)
    dnBtn.Font=Enum.Font.GothamBold; dnBtn.TextColor3=Color3.new(1,1,1)
    dnBtn.BackgroundColor3=Color3.fromRGB(100,10,25); dnBtn.BorderSizePixel=0
    Instance.new("UICorner",dnBtn).CornerRadius=UDim.new(0,S(4))
    dnBtn.MouseButton1Click:Connect(function()
        FLING_POWER=math.max(FLING_POWER-50,50); FLING_UP=math.max(FLING_UP-40,50)
        flingPowerLbl.Text=tostring(FLING_POWER)
    end)
end

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 6 — OYUNCU SEÇİM PANELİ
--  (Fling hedefi seçmek için)
-- ════════════════════════════════════════════════════════════════
makeDivider("HEDEF")

-- Oyuncu listesi şeridi (genişletilmiş)
do
    local f=Instance.new("Frame",scrollF)
    f.Size=UDim2.fromOffset(STRIP_W*2+S(4),STRIP_H-S(12))  -- 2x genişlik
    f.BackgroundColor3=COL.STRIP; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,S(8))
    do local st=Instance.new("UIStroke",f); st.Color=COL.ACCENT2; st.Thickness=0.8; st.Transparency=0.4 end

    local titleL=Instance.new("TextLabel",f); titleL.Size=UDim2.new(1,0,0,S(26))
    titleL.Position=UDim2.new(0,0,0,S(4)); titleL.Text="🎯 HEDEF SEÇ"
    titleL.TextSize=S(11); titleL.Font=Enum.Font.GothamBold
    titleL.TextColor3=COL.ACCENT; titleL.BackgroundTransparency=1

    local selLbl=Instance.new("TextLabel",f); selLbl.Size=UDim2.new(1,0,0,S(20))
    selLbl.Position=UDim2.new(0,0,0,S(28)); selLbl.Text="Seçili: Yok"
    selLbl.TextSize=S(9); selLbl.Font=Enum.Font.GothamSemibold
    selLbl.TextColor3=COL.SUBTEXT; selLbl.BackgroundTransparency=1

    local listSF=Instance.new("ScrollingFrame",f)
    listSF.Size=UDim2.new(1,-S(6),1,-S(106)); listSF.Position=UDim2.new(0,S(3),0,S(52))
    listSF.BackgroundTransparency=1; listSF.BorderSizePixel=0
    listSF.ScrollBarThickness=S(3); listSF.ScrollBarImageColor3=COL.ACCENT
    listSF.CanvasSize=UDim2.new(0,0,0,0); listSF.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local ll=Instance.new("UIListLayout",listSF)
    ll.Padding=UDim.new(0,S(3)); ll.HorizontalAlignment=Enum.HorizontalAlignment.Center

    local pBtns={}
    local function refreshList()
        for _,b in pairs(pBtns) do pcall(function() b:Destroy() end) end; pBtns={}
        local plrs={}; for _,p in pairs(Players:GetPlayers()) do if p~=lp then table.insert(plrs,p) end end
        if #plrs==0 then
            local nl=Instance.new("TextLabel",listSF); nl.Size=UDim2.new(1,0,0,S(24))
            nl.Text="Başka oyuncu yok"; nl.TextSize=S(9); nl.Font=Enum.Font.Gotham
            nl.TextColor3=COL.SUBTEXT; nl.BackgroundTransparency=1; table.insert(pBtns,nl); return
        end
        for _,plr in pairs(plrs) do
            local r2=R()
            local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            local dist=r2 and t and math.floor((t.Position-r2.Position).Magnitude) or "?"
            local b=Instance.new("TextButton",listSF)
            b.Size=UDim2.new(1,0,0,S(28)); b.Text="👤 "..plr.Name.."  ["..dist.."m]"
            b.TextSize=S(9); b.Font=Enum.Font.GothamSemibold
            b.TextXAlignment=Enum.TextXAlignment.Left
            b.TextColor3=COL.TEXT; b.BackgroundColor3=Color3.fromRGB(38,5,28); b.BorderSizePixel=0
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,S(5))
            local pl2=plr
            b.MouseButton1Click:Connect(function()
                selPlayer=pl2; selLbl.Text="Seçili: "..pl2.Name
                selLbl.TextColor3=COL.ACCENT
                for _,x in pairs(pBtns) do if x:IsA("TextButton") then x.BackgroundColor3=Color3.fromRGB(38,5,28) end end
                b.BackgroundColor3=COL.ACCENT2
            end)
            table.insert(pBtns,b)
        end
    end
    refreshList()

    -- Listele / Fling butonları (alt bölge)
    local botBtnH=S(22); local botY=STRIP_H-S(12)-S(54)
    local function smallBtn(txt,col2,x,w2,cb2)
        local b2=Instance.new("TextButton",f)
        b2.Size=UDim2.fromOffset(w2,botBtnH); b2.Position=UDim2.fromOffset(x,botY)
        b2.Text=txt; b2.TextSize=S(9); b2.Font=Enum.Font.GothamBold
        b2.TextColor3=Color3.new(1,1,1); b2.BackgroundColor3=col2; b2.BorderSizePixel=0
        Instance.new("UICorner",b2).CornerRadius=UDim.new(0,S(4))
        b2.MouseButton1Click:Connect(cb2)
    end
    local hw=math.floor((STRIP_W*2-S(8))/3)
    smallBtn("🔄 Yenile",Color3.fromRGB(40,8,30),S(4),hw,refreshList)
    smallBtn("🌀 Fling",Color3.fromRGB(160,15,35),S(4)+hw+S(2),hw,function()
        doFling(selPlayer,FLING_POWER,FLING_UP,FLING_SPIN)
    end)
    smallBtn("☄️ Süper",Color3.fromRGB(200,20,50),S(4)+(hw+S(2))*2,hw,function()
        doFling(selPlayer,1200,800,2000)
    end)

    -- Altta ışınlan + takip
    local function smallBtn2(txt,col2,x,w2,cb2)
        local b2=Instance.new("TextButton",f)
        b2.Size=UDim2.fromOffset(w2,botBtnH); b2.Position=UDim2.fromOffset(x,botY+botBtnH+S(3))
        b2.Text=txt; b2.TextSize=S(9); b2.Font=Enum.Font.GothamBold
        b2.TextColor3=Color3.new(1,1,1); b2.BackgroundColor3=col2; b2.BorderSizePixel=0
        Instance.new("UICorner",b2).CornerRadius=UDim.new(0,S(4))
        b2.MouseButton1Click:Connect(cb2)
    end
    local hw2=math.floor((STRIP_W*2-S(8))/2)
    smallBtn2("📍 Işınlan",Color3.fromRGB(30,8,50),S(4),hw2,function()
        local r2=R(); if not r2 or not selPlayer then return end
        local t=selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
        if t then r2.CFrame=CFrame.new(t.Position+Vector3.new(3,1,0)) end
    end)
    smallBtn2("🏃 Takip",Color3.fromRGB(20,30,80),S(4)+hw2+S(2),hw2,function()
        local followActive=false
        if followActive then disc("plrFollow"); return end
        conn(RS.Heartbeat,function()
            local r2=R(); if not r2 then return end
            local t=selPlayer and selPlayer.Character and selPlayer.Character:FindFirstChild("HumanoidRootPart")
            if t and (t.Position-r2.Position).Magnitude>5 then
                r2.CFrame=CFrame.new(t.Position+Vector3.new(3,0,3))
            end
        end,"plrFollow")
    end)

    Players.PlayerAdded:Connect(function() task.wait(0.5); refreshList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.1); refreshList() end)
end

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 7 — EV / DÜNYA
-- ════════════════════════════════════════════════════════════════
makeDivider("DÜNYA")

makeStrip("💡 TÜM\nIŞIKLAR","lights",function(on)
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled=on; if on then obj.Range=60; obj.Brightness=5 end
        end
    end
end,"💡")

makeStrip("🏚️ DUVAR\nŞEFFAF","walls",function(on)
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if obj:IsA("BasePart") and (n:find("wall") or n:find("fence") or n:find("barrier")) then
            obj.Transparency=on and 0.9 or 0; obj.CanCollide=not on
        end
    end
end,"🏚️")

makeStrip("🚪 KAPILARI\nKALDIR","doors",function(on)
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if obj:IsA("BasePart") and (n:find("door") or n:find("kap") or n:find("gate")) then
            obj.Transparency=on and 1 or 0; obj.CanCollide=not on
        end
    end
end,"🚪")

-- Anında spawn TP
makeBtnStrip("⭐ SPAWN'A\nISINLAN","⭐",function()
    local r2=R(); if not r2 then return end
    local sp=workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildWhichIsA("SpawnLocation",true)
    if sp then r2.CFrame=sp.CFrame+Vector3.new(0,5,0) end
end)

makeBtnStrip("☁️ HAVAYA\nZIPLA","☁️",function()
    local r2=R(); if r2 then r2.CFrame=r2.CFrame+Vector3.new(0,80,0) end
end)

makeBtnStrip("🔄 HIZLI\nRESPAWN","🔄",function() lp:LoadCharacter() end)

makeBtnStrip("🎥 KAMERA\nSIFIRLA","🎥",function()
    cam.CameraType=Enum.CameraType.Custom; cam.FieldOfView=70
end)

-- ════════════════════════════════════════════════════════════════
--  MOBİL HIZLI BUTONLAR (Sağ taraf)
-- ════════════════════════════════════════════════════════════════
local quickBar=Instance.new("Frame",sg)
local qSz=S(isMobile and 54 or 42); local qGap=S(5)
quickBar.Size=UDim2.fromOffset(qSz,(qSz+qGap)*6)
quickBar.Position=UDim2.new(1,-qSz-S(8),0.5,-((qSz+qGap)*6)/2)
quickBar.BackgroundTransparency=1

local function qBtn(icon,col,idx,tip,fn)
    local b=Instance.new("TextButton",quickBar)
    b.Size=UDim2.fromOffset(qSz,qSz); b.Position=UDim2.fromOffset(0,idx*(qSz+qGap))
    b.Text=icon; b.TextSize=S(isMobile and 20 or 16); b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=col; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,S(isMobile and 12 or 9))
    do local s=Instance.new("UIStroke",b); s.Color=Color3.new(1,1,1); s.Thickness=0.8; s.Transparency=0.65 end
    local tipL=Instance.new("TextLabel",sg); tipL.Text=tip; tipL.TextSize=S(10)
    tipL.Font=Enum.Font.GothamSemibold; tipL.Size=UDim2.fromOffset(S(120),S(24))
    tipL.BackgroundColor3=COL.BG; tipL.BorderSizePixel=0; tipL.TextColor3=COL.TEXT; tipL.Visible=false
    Instance.new("UICorner",tipL).CornerRadius=UDim.new(0,S(5))
    do local s=Instance.new("UIStroke",tipL); s.Color=col; s.Thickness=1 end
    b.MouseEnter:Connect(function() tipL.Position=UDim2.fromOffset(b.AbsolutePosition.X-S(128),b.AbsolutePosition.Y); tipL.Visible=true end)
    b.MouseLeave:Connect(function() tipL.Visible=false end)
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then
            TS:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.4}):Play()
            tipL.Position=UDim2.fromOffset(b.AbsolutePosition.X-S(128),b.AbsolutePosition.Y)
            tipL.Visible=true; task.delay(1.5,function() tipL.Visible=false end)
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then TS:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0}):Play() end
    end)
    b.MouseButton1Click:Connect(fn)
    return b
end

qBtn("🏠",Color3.fromRGB(115,18,85),0,"Menü Aç/Kapat",function() win.Visible=not win.Visible end)
qBtn("⚡",Color3.fromRGB(155,18,95),1,"Speed",function()
    local h=H(); if not h then return end; h.WalkSpeed=h.WalkSpeed>50 and 16 or 80
end)
qBtn("🛩️",Color3.fromRGB(95,8,75),2,"Uçuş",function()
    flyOn=not flyOn
    if flyOn then
        local r2=R(); if not r2 then return end
        fG=Instance.new("BodyGyro",r2); fG.MaxTorque=Vector3.new(9e8,9e8,9e8); fG.P=9e4
        fV=Instance.new("BodyVelocity",r2); fV.MaxForce=Vector3.new(9e8,9e8,9e8); fV.Velocity=Vector3.zero
        fCon=RS.Heartbeat:Connect(function()
            local rt=R(); if not(flyOn and rt) then if fCon then fCon:Disconnect() end; return end
            local d=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then d+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.new(0,1,0) end
            fV.Velocity=d.Magnitude>0 and d.Unit*95 or Vector3.zero; fG.CFrame=cam.CFrame
        end)
    else
        if fCon then fCon:Disconnect(); fCon=nil end
        pcall(function() if fV then fV:Destroy() end end); fV=nil
        pcall(function() if fG then fG:Destroy() end end); fG=nil
    end
end)
qBtn("🌀",Color3.fromRGB(180,15,35),3,"En Yakına Fling",function()
    local r2=R(); if not r2 then return end
    local best,bestD=nil,math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if t then local d=(t.Position-r2.Position).Magnitude; if d<bestD then bestD=d; best=plr end end
    end
    if best then doFling(best,FLING_POWER,FLING_UP,FLING_SPIN) end
end)
qBtn("💥",Color3.fromRGB(160,12,28),4,"Herkesi Fling",function()
    doFlingAll(FLING_POWER,FLING_UP,FLING_SPIN)
end)
qBtn("🛡️",Color3.fromRGB(75,8,60),5,"God Mode",function()
    local h=H(); if not h then return end; h.MaxHealth=math.huge; h.Health=math.huge
end)

-- ════════════════════════════════════════════════════════════════
--  PC KLAVYE KISAYOLLARI
-- ════════════════════════════════════════════════════════════════
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if     i.KeyCode==Enum.KeyCode.RightShift then win.Visible=not win.Visible
    elseif i.KeyCode==Enum.KeyCode.Delete     then win.Visible=false
    elseif i.KeyCode==Enum.KeyCode.Insert     then win.Visible=true
    elseif i.KeyCode==Enum.KeyCode.F5 then
        local h=H(); if h then h.WalkSpeed=h.WalkSpeed>50 and 16 or 80 end
    elseif i.KeyCode==Enum.KeyCode.F6 then
        flyOn=not flyOn
        if not flyOn then
            if fCon then fCon:Disconnect(); fCon=nil end
            pcall(function() if fV then fV:Destroy() end end); fV=nil
            pcall(function() if fG then fG:Destroy() end end); fG=nil
        end
    elseif i.KeyCode==Enum.KeyCode.F7 then
        -- Yakındaki oyuncuya hızlı fling
        local r2=R(); if not r2 then return end
        local best,bestD=nil,math.huge
        for _,plr in pairs(Players:GetPlayers()) do
            if plr==lp then continue end
            local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if t then local d=(t.Position-r2.Position).Magnitude; if d<bestD then bestD=d; best=plr end end
        end
        if best then doFling(best,FLING_POWER,FLING_UP,FLING_SPIN) end
    elseif i.KeyCode==Enum.KeyCode.F8 then
        -- Tüm oyuncular fling
        doFlingAll(FLING_POWER,FLING_UP,FLING_SPIN)
    end
end)

-- ════════════════════════════════════════════════════════════════
--  KARAKTER YENİLENME
-- ════════════════════════════════════════════════════════════════
lp.CharacterAdded:Connect(function(char)
    task.wait(0.8); flyOn=false
    if fCon then fCon:Disconnect(); fCon=nil end
    pcall(function() if fV then fV:Destroy() end end); fV=nil
    pcall(function() if fG then fG:Destroy() end end); fG=nil
    if ncOn then
        conn(RS.Stepped,function()
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end,"noclip")
    end
end)

-- ════════════════════════════════════════════════════════════════
--  BAŞLANGIÇ BİLDİRİMİ
-- ════════════════════════════════════════════════════════════════
local notifF=Instance.new("Frame",sg)
notifF.Size=UDim2.fromOffset(S(320),S(58))
notifF.Position=UDim2.new(0.5,-S(160),1,S(10))
notifF.BackgroundColor3=COL.BG; notifF.BorderSizePixel=0
Instance.new("UICorner",notifF).CornerRadius=UDim.new(0,S(10))
do local s=Instance.new("UIStroke",notifF); s.Color=COL.ACCENT; s.Thickness=1.5 end
local nl=Instance.new("TextLabel",notifF); nl.Size=UDim2.new(1,-S(12),1,0)
nl.Position=UDim2.new(0,S(6),0,0); nl.TextSize=S(11); nl.Font=Enum.Font.GothamSemibold
nl.TextColor3=COL.TEXT; nl.BackgroundTransparency=1; nl.TextWrapped=true
nl.Text="🏠 LORD HUB V2 — Brookhaven RP\n✅ Hazır!  "..(isMobile and "📱 Mobil" or "💻 PC")
      .."  |  RightShift=Menü  F7=Fling  F8=HerkesFling"

TS:Create(notifF,TweenInfo.new(0.5,Enum.EasingStyle.Quart),{Position=UDim2.new(0.5,-S(160),1,-S(72))}):Play()
task.delay(5,function()
    TS:Create(notifF,TweenInfo.new(0.5,Enum.EasingStyle.Quart),{Position=UDim2.new(0.5,-S(160),1,S(10))}):Play()
    task.delay(0.6,function() notifF:Destroy() end)
end)

print("🏠 LORD HUB V2 — Brookhaven RP | Hazır!")
print("Klavye: RightShift=Menü | F5=Speed | F6=Uçuş | F7=Fling | F8=HerkesFling")
