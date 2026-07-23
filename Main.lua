--[[
  LORD HUB — MURDER MYSTERY 2  (V4 MOBİL + PC)
  ✅ Işınlanmasız bıçak fırlatma (TP YOK!)
  ✅ Gelişmiş mobil UI — büyük dokunmatik butonlar
  ✅ Kill Aura · Aimbot · Silent Aim · Prediction
  ✅ Rol ESP · Tracer · Crosshair · Coin/Silah ESP
  ✅ Uçuş · Noclip · God Mode · Anti-AFK
  ✅ Bağlantı Yöneticisi · FPS Sayacı · Ekran Boyutu
  V4: TP KALDIRILDI — Sadece Remote/Activate ile saldırır
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

-- ══════════════════════════════════════════════
-- MOBİL ALGILAMA & ÖLÇEKLEME (V4 — Geliştirildi)
-- ══════════════════════════════════════════════
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp       = cam.ViewportSize

-- V4: Daha akıllı ölçek — ekran boyutuna göre dinamik
local function getScale()
    local w = cam.ViewportSize.X
    local h = cam.ViewportSize.Y
    if not isMobile then return 1 end
    -- Küçük telefon (iPhone SE vb): 0.82
    -- Normal telefon (iPhone 14 vb): 1.0
    -- Büyük telefon / tablet: 1.2
    local base = math.min(w, h) / 390
    return math.clamp(base, 0.82, 1.35)
end

local SCALE = getScale()
local function S(n)  return math.floor(n * SCALE) end
local function SP(n) return UDim.new(0, S(n)) end

-- Pencere boyutu — V4: Daha büyük mobilde
local W  = isMobile and S(300) or 324
local HH = isMobile and S(440) or 450

-- ══════════════════════════════════════════════
-- OPTİMİZASYON MOTORU
-- ══════════════════════════════════════════════
local Connections  = {}
local FrameCounter = 0
local FPS          = 60

RS.Heartbeat:Connect(function(dt)
    FPS = math.clamp(1 / (dt + 0.001), 1, 144)
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
    if Connections[tag] then
        Connections[tag]:Disconnect()
        Connections[tag] = nil
    end
end

-- ── Yardımcılar ────────────────────────────────
local function C()  return lp.Character end
local function R()  local c=C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H()  local c=C(); return c and c:FindFirstChildOfClass("Humanoid") end

local hasDrawing = pcall(function() return Drawing.new end)

-- ── Rol tespiti ────────────────────────────────
local KNIFE_KW = {"knife","bıçak","mm2knife","sickle","virtual knife","darkblade","elderwood","chrome","luger knife","candy"}
local GUN_KW   = {"revolver","gun","sheriff","luger","mm2gun","pistol","magnum"}

local function getRole(plr)
    if plr == lp then return "self" end
    for _, src in pairs({plr.Character, plr:FindFirstChild("Backpack")}) do
        if src then
            for _, t in pairs(src:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    for _, k in pairs(KNIFE_KW) do if n:find(k) then return "murderer" end end
                    for _, g in pairs(GUN_KW)   do if n:find(g) then return "sheriff"  end end
                end
            end
        end
    end
    return "innocent"
end

local RCOL = {
    murderer = Color3.fromRGB(255,60,60),
    sheriff  = Color3.fromRGB(60,140,255),
    innocent = Color3.fromRGB(80,230,80),
    unknown  = Color3.fromRGB(160,160,160)
}
local RTXT = {murderer="🔪 KATİL", sheriff="🔫 ŞERİF", innocent="🟢 MASUM", unknown="❔"}

-- ── Görünürlük (raycast) ───────────────────────
local function isVisible(from, to)
    local dir  = to - from
    local dist = dir.Magnitude
    if dist < 0.1 then return true end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local chars = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then table.insert(chars, p.Character) end
    end
    rp.FilterDescendantsInstances = chars
    local ray = workspace:Raycast(from, dir.Unit * dist, rp)
    return not ray
end

-- ── En yakın düşman ────────────────────────────
local function findNearest(roles, requireVis, maxDist)
    local r = R(); if not r then return nil, math.huge end
    local best, bestD = nil, maxDist or math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lp then continue end
        local ch = plr.Character
        if not ch then continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then continue end  -- ölü oyuncuları atla
        local match = false
        for _, ro in pairs(roles) do if getRole(plr) == ro then match=true; break end end
        if not match then continue end
        local t = ch:FindFirstChild("HumanoidRootPart")
        if not t then continue end
        local d = (t.Position - r.Position).Magnitude
        if d < bestD then
            if requireVis then
                if isVisible(r.Position+Vector3.new(0,2,0), t.Position+Vector3.new(0,2,0)) then
                    bestD=d; best=plr
                end
            else
                bestD=d; best=plr
            end
        end
    end
    return best, bestD
end

-- ── Hareket tahmini ────────────────────────────
local prevPos = {}
local function predictPos(plr, ahead)
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local cur  = root.Position
    local prev = prevPos[plr]
    local vel  = prev and (cur - prev) * 60 or Vector3.zero
    prevPos[plr] = cur
    return cur + vel * (ahead or 0.08)
end

-- ══════════════════════════════════════════════
-- SALDIRI AYARLARI (global)
-- ══════════════════════════════════════════════
local killAuraRange       = 25
local killAuraDelay       = 0.08
local _targetPlayer       = nil
local throwRemote         = nil
local throwCooldown       = 0

-- ── OTO SALDIRI DURUMLARI (tuş yok — heartbeat) ──
local autoKnifeOn         = false   -- ⚔️ Oto bıçak at (herkese)
local autoKillMurdererOn  = false   -- 🎯 Sadece katili oto vur

-- Quickbar buton referansları (Tab 3 toggle ile senkron için)
local qKnifeBtnRef        = nil
local qKillBtnRef         = nil

-- Renk sabitleri
local COL_ON  = Color3.fromRGB(20, 200, 80)   -- Açık → yeşil
local COL_OFF_KNIFE = Color3.fromRGB(200,30,30)
local COL_OFF_KILL  = Color3.fromRGB(150,10,10)

local function setAutoKnife(v)
    autoKnifeOn = v
    if qKnifeBtnRef then
        TS:Create(qKnifeBtnRef, TweenInfo.new(0.15), {
            BackgroundColor3 = v and COL_ON or COL_OFF_KNIFE
        }):Play()
        qKnifeBtnRef.Text = v and "⚔️🟢" or "⚔️"
    end
    if v then
        connect(RS.Heartbeat, function()
            if not autoKnifeOn then return end
            local target = _targetPlayer or findNearest({"murderer","innocent","sheriff"}, false, math.huge)
            if not target then return end
            throwAtTarget(target, false)
            task.wait(killAuraDelay)
        end, "autoKnifeHB")
    else
        disconnect("autoKnifeHB")
    end
end

local function setAutoKillMurderer(v)
    autoKillMurdererOn = v
    if qKillBtnRef then
        TS:Create(qKillBtnRef, TweenInfo.new(0.15), {
            BackgroundColor3 = v and COL_ON or COL_OFF_KILL
        }):Play()
        qKillBtnRef.Text = v and "🎯🟢" or "🎯"
    end
    if v then
        connect(RS.Heartbeat, function()
            if not autoKillMurdererOn then return end
            local murderer = _targetPlayer or findNearest({"murderer"}, false, math.huge)
            if not murderer then return end
            throwAtTarget(murderer, false)
            task.wait(killAuraDelay)
        end, "autoKillMurdererHB")
    else
        disconnect("autoKillMurdererHB")
    end
end

-- ────────────────────────────────────────────────────────────────
-- Remote bulma — V4: daha kapsamlı arama
-- ────────────────────────────────────────────────────────────────
local function findRemote()
    local best = nil
    local keywords = {"throw","attack","swing","stab","hit","slash","fire","shoot","kill","damage"}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if n:find(kw) then
                    best = obj
                    break
                end
            end
        end
    end
    return best
end

local function getThrowRemote()
    if not throwRemote then throwRemote = findRemote() end
    return throwRemote
end

-- ════════════════════════════════════════════════════════════════
-- BIRAÇAK FIRLAT — V4: IŞINLANMA YOK!
-- Sadece Remote ateşler ve Tool:Activate() yapar. Konum DEĞİŞMEZ.
-- ════════════════════════════════════════════════════════════════
local function throwAtTarget(target, force)
    if not target then return end
    local now = tick()
    if now - throwCooldown < 0.05 and not force then return end
    throwCooldown = now

    local r = R(); if not r then return end
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end

    -- Hedef öldü mü?
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    if tHum and tHum.Health <= 0 then return end

    -- TP YOK — Sadece yöne bak (pozisyon değişmez)
    local aimPos = predictPos(target, 0.12) or tRoot.Position
    r.CFrame = CFrame.lookAt(r.Position, Vector3.new(aimPos.X, r.Position.Y, aimPos.Z))

    local c = C(); if not c then return end

    -- Eldeki Tool bul
    local tool = nil
    for _, t in pairs(c:GetChildren()) do if t:IsA("Tool") then tool=t; break end end

    -- Remote ateşle
    local remote = getThrowRemote()
    if remote then
        pcall(function() remote:FireServer(aimPos) end)
        pcall(function() remote:FireServer(tRoot)  end)
        pcall(function() remote:InvokeServer(aimPos) end)
    end

    if tool then
        -- Tool içindeki remote
        pcall(function()
            local re = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
            if re then
                if re:IsA("RemoteEvent") then
                    pcall(function() re:FireServer(aimPos) end)
                    pcall(function() re:FireServer(tRoot)  end)
                else
                    pcall(function() re:InvokeServer(aimPos) end)
                end
            end
        end)
        -- Tool:Activate — TP olmadan direkt bıçak ateşi
        pcall(function() tool:Activate() end)
        -- Mouse simülasyonu
        pcall(function()
            local ms = lp:GetMouse()
            ms.Target = tRoot
            ms.Hit = CFrame.new(aimPos)
        end)
    end
end

-- ══════════════════════════════════════════════
-- GUI — ANA ÇERÇEVE
-- ══════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "MM2Hub"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true
sg.DisplayOrder = 999

local win = Instance.new("Frame", sg)
win.Size     = UDim2.fromOffset(W, HH)

-- V4: Mobilde sol alt (baş parmak erişimi), PC'de orta
if isMobile then
    win.Position = UDim2.new(0, 10, 0, 10)
else
    win.Position = UDim2.new(0.5, -W/2, 0.5, -HH/2)
end
win.BackgroundColor3 = Color3.fromRGB(8,8,16)
win.BorderSizePixel  = 0
win.Active = true
win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0,10)

-- Gölge efekti
do
    local shadow = Instance.new("ImageLabel", win)
    shadow.Size = UDim2.new(1,30,1,30)
    shadow.Position = UDim2.new(0,-15,0,-15)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(30,120,255)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
end

do local s=Instance.new("UIStroke",win); s.Color=Color3.fromRGB(30,120,255); s.Thickness=1.5 end

-- ── Başlık barı ────────────────────────────────
local barH = S(42)
local bar  = Instance.new("Frame", win)
bar.Size = UDim2.new(1,0,0,barH)
bar.BackgroundColor3 = Color3.fromRGB(12,12,22); bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,10)
local bfix = Instance.new("Frame", bar)
bfix.Size = UDim2.new(1,0,0.5,0); bfix.Position = UDim2.new(0,0,0.5,0)
bfix.BackgroundColor3 = Color3.fromRGB(12,12,22); bfix.BorderSizePixel = 0

-- Gradient başlık
do
    local grad = Instance.new("UIGradient", bar)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18,18,35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,20))
    }
    grad.Rotation = 90
end

local function mkL(p,txt,sz,col,xw,yw,ox,oy,xa,f)
    local l = Instance.new("TextLabel", p)
    l.Text=txt; l.TextSize=S(sz or 12)
    l.TextColor3=col or Color3.new(1,1,1); l.Font=f or Enum.Font.GothamBold
    l.Size=UDim2.new(xw or 0, ox or 0, yw or 0, oy or 0)
    l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    return l
end

local icoL = mkL(bar,"🔪",isMobile and 20 or 18,nil,0,1,0,barH)
icoL.Position = UDim2.new(0,S(10),0,0); icoL.TextXAlignment = Enum.TextXAlignment.Center

mkL(bar,"LORD HUB V4",S(isMobile and 13 or 12),nil,0,S(22),0.55,0).Position = UDim2.new(0,S(42),0,S(5))
local ts2 = mkL(bar,"MURDER MYSTERY 2",S(isMobile and 9 or 8),Color3.fromRGB(30,120,255),0,S(14),0.55,0,nil,Enum.Font.GothamSemibold)
ts2.Position = UDim2.new(0,S(42),0,S(27))

-- FPS etiketi
local fpsLbl = mkL(bar, "60", isMobile and 9 or 8, Color3.fromRGB(80,255,120), 0, S(14), 0.55, 0, nil, Enum.Font.Gotham)
fpsLbl.TextXAlignment = Enum.TextXAlignment.Right
fpsLbl.Size = UDim2.new(0, S(50), 0, S(14))
fpsLbl.Position = UDim2.new(1, -S(isMobile and 115 or 105), 0, S(5))

-- Başlık butonları
local function hBtn(txt, col, ox)
    local b = Instance.new("TextButton", bar)
    local bSz = isMobile and S(32) or S(24)
    b.Size = UDim2.fromOffset(bSz, bSz)
    b.Position = UDim2.new(1, ox, 0.5, -bSz/2)
    b.Text = txt; b.TextSize = S(isMobile and 12 or 10); b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1); b.BackgroundColor3 = col; b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end
local bSz    = isMobile and S(34) or S(26)
local closeB = hBtn("✕", Color3.fromRGB(210,30,50), -bSz-S(6))
local minB   = hBtn("⊟", Color3.fromRGB(35,35,60),  -(bSz*2)-S(12))
closeB.MouseButton1Click:Connect(function() win.Visible = false end)
local mini = false
minB.MouseButton1Click:Connect(function()
    mini = not mini
    TS:Create(win, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = mini and UDim2.fromOffset(W, barH) or UDim2.fromOffset(W, HH)
    }):Play()
    minB.Text = mini and "⊞" or "⊟"
end)

-- ── Tab barı ───────────────────────────────────
local tabBarH = isMobile and S(36) or S(30)
local tabBar  = Instance.new("Frame", win)
tabBar.Size = UDim2.new(1,0,0,tabBarH); tabBar.Position = UDim2.new(0,0,0,barH)
tabBar.BackgroundColor3 = Color3.fromRGB(10,10,20); tabBar.BorderSizePixel = 0
do local l = Instance.new("UIListLayout", tabBar)
   l.FillDirection = Enum.FillDirection.Horizontal
   l.HorizontalAlignment = Enum.HorizontalAlignment.Center
   l.VerticalAlignment   = Enum.VerticalAlignment.Center
   l.Padding = UDim.new(0,S(3)) end

local TABS = {"👁ESP","🎮Oyun","🔪Saldırı","👥Oyuncu","⚡Karakter","🎨Görsel","⚙Ayar"}
local tBtns = {}; local pages = {}; local activeTab = 0

local CONTENT_H = HH - barH - tabBarH
local content = Instance.new("Frame", win)
content.Size = UDim2.new(1,0,0,CONTENT_H)
content.Position = UDim2.new(0,0,0,barH+tabBarH)
content.BackgroundTransparency = 1; content.BorderSizePixel = 0
content.ClipsDescendants = true

local tabW = isMobile and S(42) or S(44)

local function switchTab(i)
    if activeTab == i then return end; activeTab = i
    for j = 1, #TABS do
        TS:Create(tBtns[j], TweenInfo.new(0.15), {
            BackgroundColor3 = j==i and Color3.fromRGB(30,120,255) or Color3.fromRGB(16,16,28),
            TextColor3       = j==i and Color3.new(1,1,1) or Color3.fromRGB(100,100,140)
        }):Play()
        pages[j].Visible = (j==i)
    end
end

for i, name in ipairs(TABS) do
    local tb = Instance.new("TextButton", tabBar)
    tb.Size = UDim2.fromOffset(tabW, isMobile and S(28) or S(22))
    tb.Text = name; tb.TextSize = S(isMobile and 8 or 7)
    tb.Font = Enum.Font.GothamSemibold; tb.BorderSizePixel = 0
    tb.BackgroundColor3 = Color3.fromRGB(16,16,28)
    tb.TextColor3       = Color3.fromRGB(100,100,140)
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,6)
    tBtns[i] = tb

    local pg = Instance.new("ScrollingFrame", content)
    pg.Size = UDim2.new(1,0,1,0); pg.BackgroundTransparency = 1
    pg.ScrollBarThickness = isMobile and 4 or 2
    pg.ScrollBarImageColor3 = Color3.fromRGB(30,120,255)
    pg.CanvasSize = UDim2.new(0,0,0,0); pg.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pg.Visible = false; pg.BorderSizePixel = 0
    pg.ElasticBehavior = Enum.ElasticBehavior.Always  -- iOS tarzı esnek kaydırma
    do local ul = Instance.new("UIListLayout", pg)
       ul.Padding = UDim.new(0, S(5))
       ul.HorizontalAlignment = Enum.HorizontalAlignment.Center
       local pd = Instance.new("UIPadding", pg)
       pd.PaddingTop    = UDim.new(0, S(7))
       pd.PaddingLeft   = UDim.new(0, S(8))
       pd.PaddingRight  = UDim.new(0, S(8))
       pd.PaddingBottom = UDim.new(0, S(10)) end
    pages[i] = pg; local idx = i
    tb.MouseButton1Click:Connect(function() switchTab(idx) end)
end
switchTab(1)

-- ══════════════════════════════════════════════
-- UI BİLEŞENLERİ — V4: Büyütülmüş dokunmatik alanlar
-- ══════════════════════════════════════════════
local TW     = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
local BTN_H  = isMobile and S(50) or S(36)
local TOG_H  = isMobile and S(52) or S(38)
local SLI_H  = isMobile and S(68) or S(54)
local FONT_S = isMobile and S(13) or S(11)
local SEC_S  = isMobile and S(10) or S(9)

local function Sec(pg, txt)
    local f = Instance.new("Frame", pg); f.Size = UDim2.new(1,0,0,S(22)); f.BackgroundTransparency=1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,1,0)
    l.Text = "  ▸ "..txt; l.TextSize = S(9)
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = Color3.fromRGB(30,120,255)
    l.TextXAlignment=Enum.TextXAlignment.Left; l.BackgroundTransparency=1
    -- Alt çizgi
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1,0,0,1); line.Position = UDim2.new(0,0,1,-1)
    line.BackgroundColor3 = Color3.fromRGB(30,120,255); line.BackgroundTransparency = 0.7
    line.BorderSizePixel = 0
end

local function Btn(pg, txt, col, cb)
    local b = Instance.new("TextButton", pg)
    b.Size = UDim2.new(1,0,0,BTN_H); b.Text=txt; b.TextSize=FONT_S
    b.Font = Enum.Font.GothamSemibold; b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3 = col or Color3.fromRGB(30,120,255); b.BorderSizePixel=0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,9)
    b.MouseButton1Click:Connect(cb)
    -- Hover/basma animasyonu
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            TS:Create(b,TW,{BackgroundTransparency=0.35, Size=UDim2.new(0.97,0,0,BTN_H)}):Play()
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            TS:Create(b,TW,{BackgroundTransparency=0, Size=UDim2.new(1,0,0,BTN_H)}):Play()
        end
    end)
    return b
end

local function Tog(pg, txt, cb)
    local row = Instance.new("TextButton", pg)
    row.Size = UDim2.new(1,0,0,TOG_H); row.Text=""
    row.BackgroundColor3 = Color3.fromRGB(15,15,26); row.BorderSizePixel=0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,9)

    -- Hover efekti
    row.MouseEnter:Connect(function()
        TS:Create(row,TW,{BackgroundColor3=Color3.fromRGB(20,20,34)}):Play()
    end)
    row.MouseLeave:Connect(function()
        TS:Create(row,TW,{BackgroundColor3=Color3.fromRGB(15,15,26)}):Play()
    end)

    local nl = Instance.new("TextLabel", row)
    nl.Size = UDim2.new(0.70,0,1,0); nl.Position = UDim2.new(0,S(10),0,0)
    nl.Text = txt; nl.TextSize = FONT_S; nl.Font = Enum.Font.GothamSemibold
    nl.TextColor3 = Color3.fromRGB(210,210,235); nl.TextXAlignment=Enum.TextXAlignment.Left
    nl.TextWrapped=true; nl.BackgroundTransparency=1

    -- Toggle switch (daha büyük mobilde)
    local bgW = isMobile and S(52) or S(40)
    local bgH = isMobile and S(26) or S(20)
    local knW = isMobile and S(18) or S(14)
    local bg  = Instance.new("Frame", row)
    bg.Size = UDim2.fromOffset(bgW, bgH); bg.Position = UDim2.new(1,-bgW-S(7),0.5,-bgH/2)
    bg.BackgroundColor3 = Color3.fromRGB(44,44,62); bg.BorderSizePixel=0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)
    local kn = Instance.new("Frame", bg)
    kn.Size = UDim2.fromOffset(knW,knW); kn.Position = UDim2.new(0,S(4),0.5,-knW/2)
    kn.BackgroundColor3 = Color3.fromRGB(145,145,170); kn.BorderSizePixel=0
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    local on  = false
    local tw2 = TweenInfo.new(0.18, Enum.EasingStyle.Back)
    local onX = bgW - knW - S(4)
    local function set(v)
        on=v
        if v then
            TS:Create(bg,tw2,{BackgroundColor3=Color3.fromRGB(30,120,255)}):Play()
            TS:Create(kn,tw2,{Position=UDim2.new(0,onX,0.5,-knW/2), BackgroundColor3=Color3.new(1,1,1)}):Play()
        else
            TS:Create(bg,tw2,{BackgroundColor3=Color3.fromRGB(44,44,62)}):Play()
            TS:Create(kn,tw2,{Position=UDim2.new(0,S(4),0.5,-knW/2), BackgroundColor3=Color3.fromRGB(145,145,170)}):Play()
        end
        cb(v)
    end
    row.MouseButton1Click:Connect(function() set(not on) end)
    return {set=set, get=function() return on end}
end

local function Sli(pg, txt, mn, mx, def, cb)
    local f = Instance.new("Frame", pg)
    f.Size = UDim2.new(1,0,0,SLI_H); f.BackgroundColor3=Color3.fromRGB(15,15,26)
    f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,9)
    local nl = Instance.new("TextLabel", f); nl.Size=UDim2.new(0.60,0,0,S(22))
    nl.Position=UDim2.new(0,S(10),0,S(5)); nl.Text=txt; nl.TextSize=FONT_S
    nl.Font=Enum.Font.GothamSemibold; nl.TextColor3=Color3.fromRGB(210,210,235)
    nl.TextXAlignment=Enum.TextXAlignment.Left; nl.BackgroundTransparency=1
    local vl = Instance.new("TextLabel", f); vl.Size=UDim2.new(0.35,0,0,S(22))
    vl.Position=UDim2.new(0.60,-S(4),0,S(5)); vl.Text=tostring(def); vl.TextSize=FONT_S
    vl.Font=Enum.Font.GothamBold; vl.TextColor3=Color3.fromRGB(30,120,255)
    vl.TextXAlignment=Enum.TextXAlignment.Right; vl.BackgroundTransparency=1
    local trH = isMobile and S(8) or S(5)  -- V4: Daha kalın slider çubuğu (mobil)
    local tr = Instance.new("Frame", f); tr.Size=UDim2.new(1,-S(20),0,trH)
    tr.Position=UDim2.new(0,S(10),0,SLI_H-trH-S(12)); tr.BackgroundColor3=Color3.fromRGB(32,32,50)
    tr.BorderSizePixel=0; Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
    local p0=(def-mn)/(mx-mn)
    local fi = Instance.new("Frame",tr); fi.Size=UDim2.new(p0,0,1,0)
    fi.BackgroundColor3=Color3.fromRGB(30,120,255); fi.BorderSizePixel=0
    Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)
    -- Gradient dolgu
    do local g=Instance.new("UIGradient",fi)
       g.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(50,140,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(20,90,220))}
    end
    -- V4: Daha büyük sürükleme noktası (mobil parmak için)
    local kkSz = isMobile and S(22) or S(13)
    local kk = Instance.new("Frame",tr); kk.Size=UDim2.fromOffset(kkSz,kkSz)
    kk.AnchorPoint=Vector2.new(0.5,0.5); kk.Position=UDim2.new(p0,0,0.5,0)
    kk.BackgroundColor3=Color3.new(1,1,1); kk.BorderSizePixel=0
    Instance.new("UICorner",kk).CornerRadius=UDim.new(1,0)
    do local s=Instance.new("UIStroke",kk); s.Color=Color3.fromRGB(30,120,255); s.Thickness=1.5 end
    local dr=false
    local function upd(x)
        local p=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local v=math.floor(mn+p*(mx-mn)); vl.Text=tostring(v)
        fi.Size=UDim2.new(p,0,1,0); kk.Position=UDim2.new(p,0,0.5,0); cb(v)
    end
    -- V4: Genişletilmiş dokunmatik alan (daha kolay yakalama)
    local touchZone = Instance.new("Frame",f)
    touchZone.Size=UDim2.new(1,-S(20),0,isMobile and S(36) or S(24))
    touchZone.Position=UDim2.new(0,S(10),0,SLI_H-trH-S(12)-(isMobile and S(14) or S(10)))
    touchZone.BackgroundTransparency=1; touchZone.ZIndex=kk.ZIndex+1

    local function beginDrag(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            dr=true; upd(i.Position.X)
        end
    end
    touchZone.InputBegan:Connect(beginDrag)
    tr.InputBegan:Connect(beginDrag)
    kk.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then dr=true end
    end)
    UIS.InputChanged:Connect(function(i)
        if dr and (i.UserInputType==Enum.UserInputType.MouseMovement
                or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then dr=false end
    end)
end

local function StatusLbl(pg, text)
    local l = Instance.new("TextLabel", pg)
    l.Size = UDim2.new(1,0,0,S(22)); l.TextSize=S(isMobile and 10 or 9)
    l.Font=Enum.Font.Gotham; l.BackgroundTransparency=1
    l.TextColor3=Color3.fromRGB(110,110,145); l.Text=text
    return l
end

-- ══════════════════════════════════════════════
-- MOBİL HIZLI BUTONLAR — V4: Optimize edilmiş
-- ══════════════════════════════════════════════
local quickBar   = Instance.new("Frame", sg)
local qBtnSize   = isMobile and S(60) or S(48)
local qBtnGap    = isMobile and S(8)  or S(5)
local qCount     = 4

quickBar.Size     = UDim2.fromOffset(qBtnSize, (qBtnSize+qBtnGap)*qCount)
quickBar.Position = UDim2.new(1,-qBtnSize-S(10), 0.5, -((qBtnSize+qBtnGap)*qCount)/2)
quickBar.BackgroundTransparency = 1
quickBar.Visible  = true

local function makeQuickBtn(icon, color, yIdx, tooltip, onClick)
    local b = Instance.new("TextButton", quickBar)
    b.Size = UDim2.fromOffset(qBtnSize, qBtnSize)
    b.Position = UDim2.fromOffset(0, yIdx * (qBtnSize + qBtnGap))
    b.Text = icon; b.TextSize = isMobile and S(24) or S(19)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = color; b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, isMobile and S(16) or S(11))
    do local s=Instance.new("UIStroke",b); s.Color=Color3.new(1,1,1); s.Thickness=1.2; s.Transparency=0.6 end

    -- Tooltip
    local tip = Instance.new("TextLabel", sg)
    tip.Text = tooltip; tip.TextSize = S(isMobile and 11 or 10); tip.Font = Enum.Font.GothamSemibold
    tip.Size = UDim2.fromOffset(S(140), S(28))
    tip.BackgroundColor3 = Color3.fromRGB(8,8,18); tip.BorderSizePixel=0
    tip.TextColor3 = Color3.new(1,1,1); tip.Visible = false
    Instance.new("UICorner",tip).CornerRadius=UDim.new(0,7)
    do local s=Instance.new("UIStroke",tip); s.Color=color; s.Thickness=1.2 end

    b.MouseEnter:Connect(function()
        local absPos = b.AbsolutePosition
        tip.Position = UDim2.fromOffset(absPos.X - S(148), absPos.Y + qBtnSize/2 - S(14))
        tip.Visible = true
    end)
    b.MouseLeave:Connect(function() tip.Visible=false end)

    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then
            TS:Create(b, TweenInfo.new(0.08), {BackgroundTransparency=0.4, Size=UDim2.fromOffset(qBtnSize-S(4),qBtnSize-S(4))}):Play()
            b.Position = UDim2.fromOffset(S(2), yIdx*(qBtnSize+qBtnGap)+S(2))
            local absPos = b.AbsolutePosition
            tip.Position = UDim2.fromOffset(absPos.X - S(148), absPos.Y)
            tip.Visible = true
            task.delay(1.5, function() tip.Visible=false end)
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.Touch then
            TS:Create(b, TweenInfo.new(0.12), {BackgroundTransparency=0, Size=UDim2.fromOffset(qBtnSize,qBtnSize)}):Play()
            b.Position = UDim2.fromOffset(0, yIdx*(qBtnSize+qBtnGap))
        end
    end)
    b.MouseButton1Click:Connect(onClick)
    return b
end

-- Hızlı Buton 0: Menü Aç/Kapat
makeQuickBtn("🔪", Color3.fromRGB(30,100,220), 0, "Menü Aç/Kapat", function()
    win.Visible = not win.Visible
end)

-- Hızlı Buton 1: OTO BIÇAK — toggle (yeşil=açık kırmızı=kapalı)
local qKnife = makeQuickBtn("⚔️", COL_OFF_KNIFE, 1, "Oto Bıçak At Aç/Kapat", function()
    setAutoKnife(not autoKnifeOn)
end)
qKnifeBtnRef = qKnife

-- Hızlı Buton 2: OTO KATİL VUR — toggle
local qKill = makeQuickBtn("🎯", COL_OFF_KILL, 2, "Oto Katil Vur Aç/Kapat", function()
    setAutoKillMurderer(not autoKillMurdererOn)
end)
qKillBtnRef = qKill

-- Hızlı Buton 3: Katilden Kaç
makeQuickBtn("🏃", Color3.fromRGB(20,130,50), 3, "Katilden Kaç", function()
    local r = R(); if not r then return end
    local murderer = findNearest({"murderer"}, false, math.huge)
    if not murderer then return end
    local tRoot = murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local diff = r.Position - tRoot.Position
    r.CFrame = CFrame.new(r.Position + diff.Unit*40 + Vector3.new(0,8,0))
end)

-- ══════════════════════════════════════════════
-- TAB 1 — ESP
-- ══════════════════════════════════════════════
local P1 = pages[1]
local espObjs = {}; local espOn = false

local function clearESP()
    for _, o in pairs(espObjs) do pcall(function() o:Destroy() end) end; espObjs={}
end
local function buildESP()
    clearESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local char=plr.Character; if not char then continue end
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health<=0 then continue end  -- ölüleri gösterme
        local head=char:FindFirstChild("Head"); if not head then continue end
        local role=getRole(plr); local col=RCOL[role]
        local bill=Instance.new("BillboardGui",head)
        bill.Name="MM2ESP"; bill.AlwaysOnTop=true
        bill.Size=UDim2.fromOffset(S(180),S(65)); bill.StudsOffset=Vector3.new(0,4.2,0)
        local bg=Instance.new("Frame",bill); bg.Size=UDim2.new(1,0,1,0)
        bg.BackgroundColor3=Color3.fromRGB(6,6,12); bg.BackgroundTransparency=0.25; bg.BorderSizePixel=0
        Instance.new("UICorner",bg).CornerRadius=UDim.new(0,8)
        do local st=Instance.new("UIStroke",bg); st.Color=col; st.Thickness=1.5 end
        local r2=R()
        local distStr=r2 and (" ["..math.floor((head.Position-r2.Position).Magnitude).."m]") or ""
        local rl=Instance.new("TextLabel",bg); rl.Size=UDim2.new(1,0,0.38,0)
        rl.Text=RTXT[role]..distStr; rl.TextSize=S(11); rl.Font=Enum.Font.GothamBold
        rl.TextColor3=col; rl.BackgroundTransparency=1
        local nl=Instance.new("TextLabel",bg); nl.Size=UDim2.new(1,0,0.31,0)
        nl.Position=UDim2.new(0,0,0.38,0); nl.Text=plr.Name; nl.TextSize=S(10)
        nl.Font=Enum.Font.Gotham; nl.TextColor3=Color3.new(1,1,1); nl.BackgroundTransparency=1
        if hum then
            local hl=Instance.new("TextLabel",bg); hl.Size=UDim2.new(1,0,0.31,0)
            hl.Position=UDim2.new(0,0,0.69,0); hl.TextSize=S(9); hl.Font=Enum.Font.Gotham
            hl.TextColor3=Color3.fromRGB(100,255,100); hl.BackgroundTransparency=1
            hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hl.Parent then hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth) end
            end)
        end
        char.ChildAdded:Connect(function(t)   if t:IsA("Tool") and espOn then task.wait(0.1); buildESP() end end)
        char.ChildRemoved:Connect(function(t) if t:IsA("Tool") and espOn then task.wait(0.1); buildESP() end end)
        table.insert(espObjs, bill)
    end
end

Sec(P1,"ROL ESP")
Tog(P1,"👁️ Rol ESP  (Katil🔴 Şerif🔵 Masum🟢)", function(on)
    espOn=on; if on then buildESP() else clearESP() end
end)
Btn(P1,"🔄 ESP Yenile", Color3.fromRGB(20,20,36), function() if espOn then buildESP() end end)

-- Tracer
local tracerLines = {}
local function clearTracers()
    for _, l in pairs(tracerLines) do pcall(function() l.Visible=false; l:Remove() end) end; tracerLines={}
end
local function buildTracers()
    clearTracers()
    if not hasDrawing then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local role=getRole(plr)
        if role~="murderer" and role~="sheriff" then continue end
        local root=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local sp,vis=cam:WorldToViewportPoint(root.Position)
        if not vis then continue end
        local line=Drawing.new("Line")
        line.From=Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y-20)
        line.To=Vector2.new(sp.X,sp.Y)
        line.Color=role=="murderer" and Color3.fromRGB(255,60,60) or Color3.fromRGB(60,140,255)
        line.Thickness=isMobile and 3 or 2; line.Visible=true
        table.insert(tracerLines,line)
    end
end

Sec(P1,"TRACER & CROSSHAIR")
Tog(P1,"📏 Tracer  (Katile/Şerife çizgi)", function(on)
    if on and hasDrawing then
        connect(RS.Heartbeat, function() buildTracers() end, "tracer")
    else clearTracers(); disconnect("tracer") end
end)

local chLines={}
Tog(P1,"➕ Crosshair  (Ekrana nişangah)", function(on)
    for _, l in pairs(chLines) do pcall(function() l.Visible=false; l:Remove() end) end; chLines={}
    if on and hasDrawing then
        local cx,cy=cam.ViewportSize.X/2, cam.ViewportSize.Y/2
        local sz,gap,thick=15,6,isMobile and 2.5 or 1.8
        local defs={{Vector2.new(cx-sz,cy),Vector2.new(cx-gap,cy)},
                    {Vector2.new(cx+gap,cy),Vector2.new(cx+sz,cy)},
                    {Vector2.new(cx,cy-sz),Vector2.new(cx,cy-gap)},
                    {Vector2.new(cx,cy+gap),Vector2.new(cx,cy+sz)}}
        for _, d in pairs(defs) do
            local l=Drawing.new("Line"); l.From=d[1]; l.To=d[2]
            l.Color=Color3.new(1,1,1); l.Thickness=thick; l.Visible=true
            table.insert(chLines,l)
        end
    end
end)

-- Coin ESP
local coinESP={}
local function clearCoinESP() for _,o in pairs(coinESP) do pcall(function() o:Destroy() end) end; coinESP={} end
local function buildCoinESP()
    clearCoinESP()
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if obj:IsA("BasePart") and (n:find("coin") or n=="credit" or n=="gem" or n:find("gold")) then
            local bill=Instance.new("BillboardGui",obj)
            bill.Name="CoinESP"; bill.AlwaysOnTop=true
            bill.Size=UDim2.fromOffset(S(60),S(22)); bill.StudsOffset=Vector3.new(0,2.5,0)
            local l=Instance.new("TextLabel",bill); l.Size=UDim2.new(1,0,1,0)
            l.Text="💰 KOİN"; l.TextSize=S(10); l.Font=Enum.Font.GothamBold
            l.TextColor3=Color3.fromRGB(255,215,0); l.BackgroundTransparency=1
            table.insert(coinESP,bill)
        end
    end
end

Sec(P1,"COIN & SİLAH ESP")
Tog(P1,"💰 Coin ESP", function(on)
    if on then buildCoinESP()
        connect(workspace.DescendantAdded, function() task.wait(0.1); if on then buildCoinESP() end end, "coinESP")
    else clearCoinESP(); disconnect("coinESP") end
end)

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
                    bill.Size=UDim2.fromOffset(S(75),S(22)); bill.StudsOffset=Vector3.new(0,2.5,0)
                    local l=Instance.new("TextLabel",bill); l.Size=UDim2.new(1,0,1,0)
                    l.Text=isk and "🔪 BIÇAK" or "🔫 SİLAH"; l.TextSize=S(10); l.Font=Enum.Font.GothamBold
                    l.TextColor3=isk and Color3.fromRGB(255,80,80) or Color3.fromRGB(80,150,255)
                    l.BackgroundTransparency=1; table.insert(wESP,bill)
                end
            end
        end
    end
end
Tog(P1,"🔪 Silah ESP  (Yerdeki bıçak/silah)", function(on) if on then buildWESP() else clearWESP() end end)
Btn(P1,"🔄 Silah ESP Yenile", Color3.fromRGB(20,20,36), buildWESP)

-- Uyarı HUD
local alertF=Instance.new("Frame",sg)
alertF.Size=UDim2.new(0.72,0,0,S(42)); alertF.Position=UDim2.new(0.14,0,0,S(60))
alertF.BackgroundColor3=Color3.fromRGB(200,20,20); alertF.BackgroundTransparency=0.15
alertF.BorderSizePixel=0; alertF.Visible=false
Instance.new("UICorner",alertF).CornerRadius=UDim.new(0,10)
do local s=Instance.new("UIStroke",alertF); s.Color=Color3.fromRGB(255,80,80); s.Thickness=1.5 end
local alertTxt=Instance.new("TextLabel",alertF); alertTxt.Size=UDim2.new(1,0,1,0)
alertTxt.Text="⚠️  KATİL YAKLAŞIYOR!"; alertTxt.TextSize=S(isMobile and 15 or 13)
alertTxt.Font=Enum.Font.GothamBold; alertTxt.TextColor3=Color3.new(1,1,1); alertTxt.BackgroundTransparency=1

local alertDist=15
Sec(P1,"UYARI")
Tog(P1,"⚠️ Katil Uyarısı  (Otomatik mesafe)", function(on)
    if on then
        connect(RS.Heartbeat, function()
            local r=R(); if not r then return end
            local found=false
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t and (t.Position-r.Position).Magnitude<alertDist then
                        found=true; break
                    end
                end
            end
            if found ~= alertF.Visible then alertF.Visible=found end
        end,"alert")
    else disconnect("alert"); alertF.Visible=false end
end)
Sli(P1,"⚠️ Uyarı Mesafesi",5,80,15,function(v) alertDist=v end)

-- ══════════════════════════════════════════════
-- TAB 2 — OYUN İÇİ
-- ══════════════════════════════════════════════
local P2=pages[2]
Sec(P2,"OTOMATİK")
Tog(P2,"💰 Auto Coin Topla  (Otomatik ışın)", function(on)
    if on then
        connect(RS.Heartbeat, function()
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

Tog(P2,"🎥 Katil Takip  (Kamerayı katile kilitle)", function(on)
    if on then
        connect(RS.Heartbeat, function()
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t then
                        cam.CameraType=Enum.CameraType.Scriptable
                        local r=R(); if r then cam.CFrame=CFrame.lookAt(cam.CFrame.Position,t.Position) end
                    end; break
                end
            end
        end,"camLock")
    else disconnect("camLock"); cam.CameraType=Enum.CameraType.Custom end
end)

Sec(P2,"TEK TUŞ")
Btn(P2,"🔪 Bıçağa Işınlan", Color3.fromRGB(25,25,42), function()
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

Btn(P2,"🔫 Silaha Işınlan", Color3.fromRGB(25,25,42), function()
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

Btn(P2,"🎯 Katile Işınlan  (Tam arkasına)", Color3.fromRGB(140,30,30), function()
    local r=R(); if not r then return end
    local best=findNearest({"murderer"},false,math.huge)
    if best then
        local t=best.Character:FindFirstChild("HumanoidRootPart")
        if t then r.CFrame=t.CFrame*CFrame.new(0,0,4) end
    end
end)

Sec(P2,"KAÇIŞ")
Tog(P2,"🏃 Katilden Kaç  (Otomatik uzaklaş)", function(on)
    if on then
        connect(RS.Heartbeat, function()
            local r=R(); if not r then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t then
                        local diff=r.Position-t.Position
                        if diff.Magnitude<25 then r.CFrame=CFrame.new(r.Position+diff.Unit*30+Vector3.new(0,6,0)) end
                    end; break
                end
            end
        end,"flee")
    else disconnect("flee") end
end)

Sec(P2,"KORUMA")
Tog(P2,"🛡️ Respawn Koruması", function(on)
    if on then
        local h=H(); if not h then return end
        connect(h.Died, function() task.wait(0.4); lp:LoadCharacter() end,"respawn")
    else disconnect("respawn") end
end)

local savedCF
Tog(P2,"💫 Sahte Lag  (Zor vurulursun)", function(on)
    if on then
        local tick_=0
        connect(RS.Heartbeat, function(dt)
            tick_=tick_+dt; local r=R(); if not r then return end
            if tick_%0.12<dt then savedCF=r.CFrame
            elseif tick_%0.12>0.06 and savedCF then r.CFrame=savedCF end
        end,"fakelag")
    else disconnect("fakelag") end
end)

-- ══════════════════════════════════════════════
-- TAB 3 — SALDIRI  (V4: TP TAMAMEN KALDIRILDI)
-- ══════════════════════════════════════════════
local P3=pages[3]

Sec(P3,"AYARLAR  (⚠️ TP YOK — Sadece fırlatır)")
Sli(P3,"⭕ Kill Aura Menzili",3,80,25,function(v) killAuraRange=v end)
local delayTxt=StatusLbl(P3,"Saldırı Hızı: 80ms")
Sli(P3,"⚡ Saldırı Hızı (ms)",20,500,80,function(v) killAuraDelay=v/1000; delayTxt.Text="Saldırı Hızı: "..v.."ms" end)

-- Işınlanma yok bildirimi
local noTpLbl = Instance.new("TextLabel", P3)
noTpLbl.Size = UDim2.new(1,0,0,S(30))
noTpLbl.BackgroundColor3 = Color3.fromRGB(10,40,10); noTpLbl.BorderSizePixel=0
Instance.new("UICorner",noTpLbl).CornerRadius=UDim.new(0,8)
noTpLbl.Text = "✅ V4: Işınlanma (TP) tamamen kaldırıldı"
noTpLbl.TextSize = S(9); noTpLbl.Font = Enum.Font.GothamSemibold
noTpLbl.TextColor3 = Color3.fromRGB(80,255,100); noTpLbl.BackgroundTransparency=0.5

Sec(P3,"OTO SALDIRI  (Tuşa basmana gerek yok!)")

-- Durum etiketi — quickbar ile senkron
local autoStatusLbl = Instance.new("TextLabel", P3)
autoStatusLbl.Size = UDim2.new(1,0,0,S(28))
autoStatusLbl.BackgroundColor3 = Color3.fromRGB(8,8,18); autoStatusLbl.BorderSizePixel=0
Instance.new("UICorner",autoStatusLbl).CornerRadius=UDim.new(0,8)
autoStatusLbl.TextSize=S(9); autoStatusLbl.Font=Enum.Font.GothamSemibold
autoStatusLbl.BackgroundTransparency=0.4; autoStatusLbl.TextWrapped=true
local function updateAutoStatus()
    local parts = {}
    if autoKnifeOn       then table.insert(parts,"⚔️ Oto Bıçak: AKTİF") end
    if autoKillMurdererOn then table.insert(parts,"🎯 Oto Katil: AKTİF") end
    if #parts == 0 then
        autoStatusLbl.Text="⬛ Oto saldırı kapalı"; autoStatusLbl.TextColor3=Color3.fromRGB(120,120,150)
    else
        autoStatusLbl.Text=table.concat(parts,"  |  "); autoStatusLbl.TextColor3=Color3.fromRGB(80,255,100)
    end
end
updateAutoStatus()

-- Toggle — ⚔️ Oto Bıçak At (quickbar ⚔️ ile senkron)
local autoKnifeTog = Tog(P3,"⚔️ Oto Bıçak At  (Kendiliğinden fırlatır, TP yok)", function(on)
    setAutoKnife(on)
    updateAutoStatus()
end)

-- Toggle — 🎯 Oto Katil Vur (quickbar 🎯 ile senkron)
local autoKillTog = Tog(P3,"🎯 Oto Katil Vur  (Katil gördüğünde otomatik vurur)", function(on)
    setAutoKillMurderer(on)
    updateAutoStatus()
end)

-- Quickbar butonları Tab 3 toggle ile ters yönde de güncellensin
local _origSetAutoKnife = setAutoKnife
setAutoKnife = function(v)
    _origSetAutoKnife(v)
    if autoKnifeTog then autoKnifeTog.set(v) end
    updateAutoStatus()
end

local _origSetAutoKill = setAutoKillMurderer
setAutoKillMurderer = function(v)
    _origSetAutoKill(v)
    if autoKillTog then autoKillTog.set(v) end
    updateAutoStatus()
end

Tog(P3,"🔫 Oto Silah At  (Şerif ateşi — TP yok)", function(on)
    if on then
        connect(RS.Heartbeat, function()
            local c=C(); if not c then return end
            local hasGun=false
            for _,t in pairs(c:GetChildren()) do
                if t:IsA("Tool") then
                    local n=t.Name:lower()
                    for _,g in pairs(GUN_KW) do if n:find(g) then hasGun=true; break end end
                end
            end
            if not hasGun then return end
            local target=_targetPlayer or findNearest({"murderer"},false,math.huge)
            if not target then return end
            throwAtTarget(target,false)
            task.wait(killAuraDelay)
        end,"autoGun")
    else disconnect("autoGun") end
end)

Sec(P3,"KATİL VUR")

Sec(P3,"KILL AURA")
local killAuraStatus=StatusLbl(P3,"Kill Aura: Kapalı")
Tog(P3,"💀 Kill Aura  (Menzildeki herkesi vur — TP YOK)", function(on)
    killAuraStatus.Text=on and "Kill Aura: Aktif 🔴" or "Kill Aura: Kapalı"
    if on then
        connect(RS.Heartbeat, function()
            local r=R(); if not r then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                local ch=plr.Character; if not ch then continue end
                local tHum=ch:FindFirstChildOfClass("Humanoid")
                if tHum and tHum.Health<=0 then continue end
                local tRoot=ch:FindFirstChild("HumanoidRootPart")
                if not tRoot then continue end
                local dist=(tRoot.Position-r.Position).Magnitude
                if dist<=killAuraRange then
                    -- TP YOK — Sadece remote ateşle
                    throwAtTarget(plr,true)
                    task.wait(killAuraDelay); break
                end
            end
        end,"killAura")
    else disconnect("killAura") end
end)

Sec(P3,"ANI SALDIRI")
Btn(P3,"⚡ Hedefi Anında Vur  (TP YOK — Sadece bıçak)", Color3.fromRGB(180,20,20), function()
    local target=_targetPlayer or findNearest({"murderer","innocent","sheriff"},false,math.huge)
    if target then throwAtTarget(target,true) end
    -- TP YOK!
end)
Btn(P3,"🗡️ Katili Anında Vur  (TP YOK)", Color3.fromRGB(140,10,10), function()
    local murderer=findNearest({"murderer"},false,math.huge)
    if not murderer then return end
    throwAtTarget(murderer,true)  -- TP YOK — Eskisi: r.CFrame=tRoot.CFrame*CFrame.new(0,0,3)
end)
Btn(P3,"🔄 Remote Sıfırla", Color3.fromRGB(20,20,36), function() throwRemote=nil; getThrowRemote() end)

Sec(P3,"AİMBOT")
Tog(P3,"🎯 Aimbot  (Hedefe kamera kilidi)", function(on)
    if on then
        connect(RS.Heartbeat, function()
            local r=R(); if not r then return end
            local target=_targetPlayer or findNearest({"murderer"},true,math.huge)
            if not target then target=findNearest({"innocent","sheriff","murderer"},true,math.huge) end
            if not target then return end
            local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not tRoot then return end
            local aimPos=predictPos(target,0.06) or tRoot.Position
            cam.CFrame=CFrame.lookAt(cam.CFrame.Position,aimPos)
        end,"aimbot")
    else disconnect("aimbot") end
end)

Tog(P3,"🤫 Silent Aim  (Yön gizli kilidi — TP YOK)", function(on)
    if on then
        connect(RS.Heartbeat, function()
            local r=R(); if not r then return end
            local target=_targetPlayer or findNearest({"murderer","innocent","sheriff"},true,200)
            if not target then return end
            local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not tRoot then return end
            -- Sadece yüz döndür, pozisyon değiştirme
            r.CFrame=CFrame.lookAt(r.Position,Vector3.new(tRoot.Position.X,r.Position.Y,tRoot.Position.Z))
        end,"silentAim")
    else disconnect("silentAim") end
end)

-- ══════════════════════════════════════════════
-- TAB 4 — OYUNCU
-- ══════════════════════════════════════════════
local P4=pages[4]
local selPlr=nil
local selLbl=Instance.new("TextLabel",P4)
selLbl.Size=UDim2.new(1,0,0,S(26)); selLbl.Text="🎯 Seçili: Yok"
selLbl.TextColor3=Color3.fromRGB(30,120,255); selLbl.TextSize=FONT_S
selLbl.Font=Enum.Font.GothamSemibold; selLbl.BackgroundTransparency=1

Sec(P4,"OYUNCU LİSTESİ")
local rowH = isMobile and S(46) or S(36)
local listSF=Instance.new("ScrollingFrame",P4)
listSF.Size=UDim2.new(1,0,0,isMobile and S(180) or S(150))
listSF.BackgroundColor3=Color3.fromRGB(11,11,19); listSF.BorderSizePixel=0
listSF.ScrollBarThickness=isMobile and 4 or 2
listSF.ScrollBarImageColor3=Color3.fromRGB(30,120,255); listSF.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",listSF).CornerRadius=UDim.new(0,9)

local pBtns={}
local function refreshList()
    for _,b in pairs(pBtns) do pcall(function() b:Destroy() end) end; pBtns={}
    local plrs={}
    for _,p in pairs(Players:GetPlayers()) do if p~=lp then table.insert(plrs,p) end end
    if #plrs==0 then
        local nl=Instance.new("TextLabel",listSF)
        nl.Size=UDim2.new(1,0,0,S(34)); nl.Position=UDim2.fromOffset(0,S(5))
        nl.Text="Başka oyuncu yok"; nl.TextSize=FONT_S; nl.Font=Enum.Font.Gotham
        nl.TextColor3=Color3.fromRGB(110,110,145); nl.BackgroundTransparency=1
        table.insert(pBtns,nl); listSF.CanvasSize=UDim2.new(0,0,0,S(44)); return
    end
    for i,plr in ipairs(plrs) do
        local y=(i-1)*rowH
        local role=getRole(plr); local col=RCOL[role]
        local r2=R()
        local distStr=r2 and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            and (" ["..math.floor((plr.Character.HumanoidRootPart.Position-r2.Position).Magnitude).."m]") or ""
        local b=Instance.new("TextButton",listSF)
        b.Size=UDim2.new(1,-S(10),0,rowH-S(5)); b.Position=UDim2.fromOffset(S(5),y+S(4))
        b.Text="  "..RTXT[role].."  "..plr.Name..distStr; b.TextSize=FONT_S
        b.Font=Enum.Font.GothamSemibold; b.TextXAlignment=Enum.TextXAlignment.Left
        b.TextColor3=col; b.BackgroundColor3=Color3.fromRGB(16,16,28); b.BorderSizePixel=0
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
        local pr=plr
        b.MouseButton1Click:Connect(function()
            selPlr=pr; _targetPlayer=pr
            selLbl.Text="🎯 Seçili: "..pr.Name.."  ("..RTXT[role]..")"
            selLbl.TextColor3=col
            for _,x in pairs(pBtns) do if x:IsA("TextButton") then x.BackgroundColor3=Color3.fromRGB(16,16,28) end end
            b.BackgroundColor3=Color3.fromRGB(30,120,255)
        end)
        table.insert(pBtns,b)
    end
    listSF.CanvasSize=UDim2.new(0,0,0,#plrs*rowH+S(8))
end

Btn(P4,"🔄 Listeyi Yenile", Color3.fromRGB(20,20,36), refreshList)
Sec(P4,"OYUNCU İŞLEMLERİ")
Btn(P4,"📦 Oyuncuya Işınlan", Color3.fromRGB(20,20,36), function()
    if not selPlr then return end
    local r=R(); local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart")
    if r and t then r.CFrame=t.CFrame+Vector3.new(3,2,0) end
end)
Btn(P4,"💥 Oyuncuyu Fling", Color3.fromRGB(140,30,30), function()
    if not selPlr then return end
    local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart"); if not t then return end
    local v=Instance.new("BodyVelocity",t); v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=Vector3.new(math.random(-700,700),math.random(400,700),math.random(-700,700)); Debris:AddItem(v,0.2)
end)
Btn(P4,"🪂 Havaya Fırlat", Color3.fromRGB(50,50,180), function()
    if not selPlr then return end
    local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart"); if not t then return end
    local v=Instance.new("BodyVelocity",t); v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=Vector3.new(0,1600,0); Debris:AddItem(v,0.15)
end)
Tog(P4,"🏃 Oyuncu Takip", function(on)
    if on then
        connect(RS.Heartbeat, function()
            local r=R(); if not r then return end
            local t=selPlr and selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart")
            if t and (t.Position-r.Position).Magnitude>5 then r.CFrame=CFrame.new(t.Position+Vector3.new(3,0,0)) end
        end,"follow")
    else disconnect("follow") end
end)
Btn(P4,"🎯 Saldırı Hedefi Yap", Color3.fromRGB(30,120,255), function() if selPlr then _targetPlayer=selPlr end end)
Btn(P4,"❌ Hedefi Temizle", Color3.fromRGB(20,20,36), function()
    _targetPlayer=nil; selPlr=nil
    selLbl.Text="🎯 Seçili: Yok"; selLbl.TextColor3=Color3.fromRGB(30,120,255)
end)

-- ══════════════════════════════════════════════
-- TAB 5 — KARAKTER
-- ══════════════════════════════════════════════
local P5=pages[5]
Sec(P5,"HAREKET")
Sli(P5,"🏃 Hız",16,350,16,function(v) local h=H(); if h then h.WalkSpeed=v end end)
Sli(P5,"⬆️ Zıplama",50,500,50,function(v)
    local h=H(); if not h then return end
    pcall(function() h.JumpPower=v end); pcall(function() h.JumpHeight=v/5 end)
end)
Sli(P5,"🎥 FOV",50,140,70,function(v) cam.FieldOfView=v end)

local flyOn=false; local fV,fG,fC2
local flySpeed=75
Sli(P5,"✈️ Uçuş Hızı",10,200,75,function(v) flySpeed=v end)

Tog(P5,"🛩️ Uçuş  (WASD + Space/Shift)", function(on)
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
            fV.Velocity=d.Magnitude>0 and d.Unit*flySpeed or Vector3.zero; fG.CFrame=cam.CFrame
        end)
    else
        if fC2 then fC2:Disconnect(); fC2=nil end
        pcall(function() if fV then fV:Destroy() end end); fV=nil
        pcall(function() if fG then fG:Destroy() end end); fG=nil
    end
end)

-- Mobil uçuş butonları (V4: Daha büyük, daha erişilebilir)
if isMobile then
    Sec(P5,"UÇUŞ TUŞLARI (MOBİL)")
    -- 3x2 grid uçuş kontrolleri
    local flyCtrlFrame=Instance.new("Frame",P5)
    flyCtrlFrame.Size=UDim2.new(1,0,0,S(100)); flyCtrlFrame.BackgroundTransparency=1

    local function flyBtn(txt,col,xPct,yPct,fn)
        local bW=S(88); local bH=S(42)
        local b=Instance.new("TextButton",flyCtrlFrame)
        b.Size=UDim2.fromOffset(bW,bH)
        b.Position=UDim2.new(xPct,-bW/2,yPct,-bH/2)
        b.Text=txt; b.TextSize=S(12); b.Font=Enum.Font.GothamBold
        b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=col; b.BorderSizePixel=0
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)
        local conn
        b.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then
                TS:Create(b,TW,{BackgroundTransparency=0.35}):Play()
                conn=RS.Heartbeat:Connect(fn)
            end
        end)
        b.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then
                TS:Create(b,TW,{BackgroundTransparency=0}):Play()
                if conn then conn:Disconnect(); conn=nil end
            end
        end)
        return b
    end
    local fc=Color3.fromRGB(30,60,145)
    flyBtn("⬆️ Yukarı",fc,0.25,0.25,function() local r=R(); if r and fV then r.CFrame=r.CFrame+Vector3.new(0,2,0) end end)
    flyBtn("⬇️ Aşağı",fc,0.75,0.25,function() local r=R(); if r and fV then r.CFrame=r.CFrame+Vector3.new(0,-2,0) end end)
    flyBtn("⏩ İleri",fc,0.25,0.78,function() if fV then fV.Velocity=cam.CFrame.LookVector*flySpeed end end)
    flyBtn("⏪ Geri",fc,0.75,0.78,function() if fV then fV.Velocity=-cam.CFrame.LookVector*flySpeed end end)
end

local ncOn=false
Tog(P5,"🌫️ Noclip", function(on)
    ncOn=on
    if on then
        connect(RS.Stepped, function()
            local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end,"noclip")
    else
        disconnect("noclip")
        local c=C(); if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end)

Tog(P5,"🚀 Sonsuz Zıplama", function(on)
    if on then
        connect(UIS.JumpRequest, function()
            local h=H(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end,"infiniteJump")
    else disconnect("infiniteJump") end
end)

Sec(P5,"KORUMA")
Tog(P5,"🛡️ God Mode", function(on)
    local h=H(); if not h then return end
    if on then
        h.MaxHealth=math.huge; h.Health=math.huge
        connect(h.HealthChanged, function() if h and h.Parent then h.Health=math.huge end end,"god")
    else disconnect("god"); pcall(function() h.MaxHealth=100; h.Health=100 end) end
end)

Tog(P5,"💤 Anti-AFK", function(on)
    if on then
        local vu=game:GetService("VirtualUser")
        connect(RS.Heartbeat, function() vu:Button2Down(Vector2.zero,cam.CFrame); vu:Button2Up(Vector2.zero,cam.CFrame) end,"antiAfk")
    else disconnect("antiAfk") end
end)

Sec(P5,"KİŞİSEL")
Tog(P5,"👻 Görünmez  (Karakter gizle)", function(on)
    local c=C(); if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=on and 1 or 0 end
    end
end)

Sec(P5,"ANLIK")
Btn(P5,"☁️ Havaya Zıpla",Color3.fromRGB(22,22,40),function() local r=R(); if r then r.CFrame=r.CFrame+Vector3.new(0,60,0) end end)
Btn(P5,"🔄 Respawn",Color3.fromRGB(22,22,40),function() lp:LoadCharacter() end)

-- ══════════════════════════════════════════════
-- TAB 6 — GÖRSEL
-- ══════════════════════════════════════════════
local P6=pages[6]
local oA=Lighting.Ambient; local oO=Lighting.OutdoorAmbient
local oB=Lighting.Brightness; local oS=Lighting.GlobalShadows; local oCT=Lighting.ClockTime

Sec(P6,"ORTAM")
Tog(P6,"💡 Fullbright  (Karanlıkta gör)", function(on)
    if on then
        Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness=oB; Lighting.ClockTime=oCT; Lighting.GlobalShadows=oS
        Lighting.Ambient=oA; Lighting.OutdoorAmbient=oO
    end
end)
Tog(P6,"🌙 Gece Modu", function(on)
    Lighting.ClockTime=on and 0 or oCT; Lighting.Ambient=on and Color3.fromRGB(20,20,50) or oA
end)
Tog(P6,"🌁 Sisi Kaldır", function(on)
    Lighting.FogEnd=on and 999999 or 1000; Lighting.FogStart=on and 999990 or 0
end)

Sec(P6,"KARAKTER")
Tog(P6,"🌈 Chams  (Gökkuşağı renk)", function(on)
    if on then
        local t2=0
        connect(RS.Heartbeat, function(dt)
            t2=t2+dt; local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color=Color3.fromHSV((t2*0.4)%1,1,1) end end
        end,"chams")
    else disconnect("chams") end
end)

-- ══════════════════════════════════════════════
-- TAB 7 — AYAR
-- ══════════════════════════════════════════════
local P7=pages[7]

Sec(P7,"SİSTEM BİLGİSİ")
local optFrame=Instance.new("Frame",P7); optFrame.Size=UDim2.new(1,0,0,S(110))
optFrame.BackgroundColor3=Color3.fromRGB(12,12,22); optFrame.BorderSizePixel=0
Instance.new("UICorner",optFrame).CornerRadius=UDim.new(0,9)
local optLbl=Instance.new("TextLabel",optFrame)
optLbl.Size=UDim2.new(1,-S(16),1,0); optLbl.Position=UDim2.new(0,S(8),0,0)
optLbl.TextSize=S(isMobile and 10 or 9); optLbl.Font=Enum.Font.Gotham; optLbl.BackgroundTransparency=1
optLbl.TextXAlignment=Enum.TextXAlignment.Left; optLbl.TextColor3=Color3.fromRGB(180,180,210)
optLbl.TextWrapped=true

connect(RS.Heartbeat, function()
    local conCount=0; for _ in pairs(Connections) do conCount+=1 end
    optLbl.Text=string.format(
        "Cihaz: %s\nFPS: %.0f  |  Ölçek: %.2f\nBağlantılar: %d  |  Drawing: %s\nEkran: %.0fx%.0f\nV4: TP Kaldırıldı ✅",
        isMobile and "📱 Mobil" or "💻 PC",
        FPS, SCALE,
        conCount,
        hasDrawing and "✅" or "❌",
        cam.ViewportSize.X, cam.ViewportSize.Y)
end,"optStats")

Sec(P7,"KLAVYE KISAYOLLARI  (PC)")
local ki=Instance.new("Frame",P7); ki.Size=UDim2.new(1,0,0,S(88))
ki.BackgroundColor3=Color3.fromRGB(12,12,22); ki.BorderSizePixel=0
Instance.new("UICorner",ki).CornerRadius=UDim.new(0,9)
local kl=Instance.new("TextLabel",ki)
kl.Size=UDim2.new(1,-S(16),1,0); kl.Position=UDim2.new(0,S(8),0,0)
kl.Text="RightShift → Menü Aç/Kapat\nDelete → Kapat  |  Insert → Aç\nF → Bıçak At (TP YOK)\nG → Katili Vur (TP YOK)"
kl.TextSize=S(isMobile and 11 or 10); kl.Font=Enum.Font.Gotham; kl.TextColor3=Color3.fromRGB(180,180,210)
kl.TextWrapped=true; kl.TextXAlignment=Enum.TextXAlignment.Left; kl.BackgroundTransparency=1

Sec(P7,"MOBİL HIZLI BUTONLAR")
local mbInfo=Instance.new("Frame",P7); mbInfo.Size=UDim2.new(1,0,0,S(90))
mbInfo.BackgroundColor3=Color3.fromRGB(12,12,22); mbInfo.BorderSizePixel=0
Instance.new("UICorner",mbInfo).CornerRadius=UDim.new(0,9)
local mbTxt=Instance.new("TextLabel",mbInfo)
mbTxt.Size=UDim2.new(1,-S(16),1,0); mbTxt.Position=UDim2.new(0,S(8),0,0)
mbTxt.Text="Sağ taraftaki butonlar:\n🔪 Menü Aç/Kapat\n⚔️ Bıçak At (TP Yok!)\n🎯 Katili Vur (TP Yok!)\n🏃 Katilden Kaç"
mbTxt.TextSize=S(isMobile and 11 or 10); mbTxt.Font=Enum.Font.Gotham; mbTxt.TextColor3=Color3.fromRGB(180,180,210)
mbTxt.TextWrapped=true; mbTxt.TextXAlignment=Enum.TextXAlignment.Left; mbTxt.BackgroundTransparency=1

Sec(P7,"HIZLI TEMİZLE")
Btn(P7,"🗑️ Tüm ESP Kapat", Color3.fromRGB(20,20,36), function()
    clearESP(); clearCoinESP(); clearWESP(); clearTracers()
    for _,l in pairs(chLines) do pcall(function() l.Visible=false; l:Remove() end) end; chLines={}
    alertF.Visible=false
end)
Btn(P7,"🔌 Tüm Bağlantıları Kes", Color3.fromRGB(100,20,20), function()
    for tag,c in pairs(Connections) do pcall(function() c:Disconnect() end); Connections[tag]=nil end
end)
Btn(P7,"🔄 Oyuncu Listesi Yenile", Color3.fromRGB(20,20,36), refreshList)
Btn(P7,"🎥 Kamerayı Sıfırla", Color3.fromRGB(20,20,36), function()
    cam.CameraType=Enum.CameraType.Custom; cam.FieldOfView=70
end)

Sec(P7,"HAKKINDA")
local ab=Instance.new("Frame",P7); ab.Size=UDim2.new(1,0,0,S(115))
ab.BackgroundColor3=Color3.fromRGB(12,12,22); ab.BorderSizePixel=0
Instance.new("UICorner",ab).CornerRadius=UDim.new(0,9)
local al=Instance.new("TextLabel",ab)
al.Size=UDim2.new(1,-S(16),1,0); al.Position=UDim2.new(0,S(8),0,0); al.TextSize=S(isMobile and 10 or 9)
al.Font=Enum.Font.Gotham; al.TextColor3=Color3.fromRGB(170,170,205)
al.TextWrapped=true; al.BackgroundTransparency=1; al.TextXAlignment=Enum.TextXAlignment.Left
al.Text="🔪 LORD HUB V4 — MOBİL + PC\n\n✅ V4: Işınlanma (TP) tamamen kaldırıldı\n✅ Bıçak sadece Remote/Activate ile ateş eder\n✅ Rol ESP · Tracer · Crosshair · Coin/Silah ESP\n✅ Kill Aura · Aimbot · Silent Aim · Prediction\n✅ Uçuş · Noclip · God Mode · Anti-AFK"

-- ══════════════════════════════════════════════
-- FPS & KLAVYE — V4
-- ══════════════════════════════════════════════
connect(RS.Heartbeat, function()
    local fps = math.floor(FPS)
    fpsLbl.Text = fps.." FPS"
    fpsLbl.TextColor3 = fps>50 and Color3.fromRGB(80,255,120) or fps>30 and Color3.fromRGB(255,200,50) or Color3.fromRGB(255,60,60)
end,"fpsUpdate")

-- PC klavye kısayolları — V4: TP YOK
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then win.Visible=not win.Visible
    elseif i.KeyCode==Enum.KeyCode.Delete  then win.Visible=false
    elseif i.KeyCode==Enum.KeyCode.Insert  then win.Visible=true
    elseif i.KeyCode==Enum.KeyCode.F then
        -- F: Bıçak at — TP YOK
        local target=_targetPlayer or findNearest({"murderer","innocent","sheriff"},false,200)
        if target then throwAtTarget(target,true) end
    elseif i.KeyCode==Enum.KeyCode.G then
        -- G: Katili vur — TP YOK (Eskiden TP yapıyordu, artık yapmıyor)
        local murderer=findNearest({"murderer"},false,math.huge)
        if murderer then throwAtTarget(murderer,true) end
        -- NOT: r.CFrame=tRoot.CFrame*CFrame.new(0,0,3) — KALDIRILDI!
    end
end)

-- Karakter yenilenince sıfırla
lp.CharacterAdded:Connect(function(char)
    task.wait(0.8); flyOn=false
    if fC2 then fC2:Disconnect(); fC2=nil end
    pcall(function() if fV then fV:Destroy() end end); fV=nil
    pcall(function() if fG then fG:Destroy() end end); fG=nil
    if ncOn then
        connect(RS.Stepped, function()
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end,"noclip")
    end
    if espOn then task.wait(1); buildESP() end
    throwRemote=nil; prevPos={}
end)

Players.PlayerAdded:Connect(function()   task.wait(0.5); refreshList(); if espOn then buildESP() end end)
Players.PlayerRemoving:Connect(function() task.wait(0.1); refreshList(); if espOn then buildESP() end end)

refreshList()

local deviceTxt = isMobile and
    string.format("📱 Mobil mod aktif! Ölçek: %.2f | Ekran: %.0fx%.0f", SCALE, cam.ViewportSize.X, cam.ViewportSize.Y)
    or "💻 PC mod aktif! F=Bıçak At (TP Yok)  G=Katili Vur (TP Yok)"

print("[LORD HUB V4] Hazır! "..deviceTxt)
print("[LORD HUB V4] TP KALDIRILDI — Bıçak artık ışınlanmaz, sadece fırlatır!")
