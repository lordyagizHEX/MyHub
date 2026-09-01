--[[
  ╔══════════════════════════════════════════════════════════════════╗
  ║        SLAYER HUB — BROOKHAVEN RP  V2  (MOBİL + PC)            ║
  ║  Otomatik mobil/PC algılama | Düz Yatay GUI                    ║
  ║  Fly · Speed · Fling · ESP · Car Hack · BoatFling · +50 Özellik ║
  ╚══════════════════════════════════════════════════════════════════╝
--]]

-- ── Servisler ───────────────────────────────────────────────────
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local Replicated = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local pgui = lp.PlayerGui
local cam = workspace.CurrentCamera

-- Eski GUI temizle
if pgui:FindFirstChild("SlayerHub") then pgui.SlayerHub:Destroy() end

-- ── Cihaz Algılama ──────────────────────────────────────────────
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp = cam.ViewportSize
local SCALE = isMobile and math.clamp(vp.X / 480, 0.7, 1.25) or 1
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
local function C() return lp.Character end
local function R() local c = C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H() local c = C(); return c and c:FindFirstChildOfClass("Humanoid") end

local FPS = 60
conn(RS.Heartbeat, function(dt) FPS = math.clamp(1/(dt+0.001),1,144) end)

-- ════════════════════════════════════════════════════════════════
--  RENK PALETİ — Slayer Hub
-- ════════════════════════════════════════════════════════════════
local COL = {
    BG = Color3.fromRGB(20, 20, 26),
    STRIP = Color3.fromRGB(30, 30, 40),
    STRIP_H = Color3.fromRGB(50, 50, 66),
    STRIP_ON = Color3.fromRGB(60, 55, 45),
    ACCENT = Color3.fromRGB(255, 200, 80),
    ACCENT2 = Color3.fromRGB(180, 140, 60),
    TEXT = Color3.fromRGB(255, 250, 240),
    SUBTEXT = Color3.fromRGB(150, 150, 170),
    TOG_OFF = Color3.fromRGB(40, 40, 50),
    TOG_ON = Color3.fromRGB(220, 180, 70),
    KNOB_OFF = Color3.fromRGB(80, 80, 100),
    KNOB_ON = Color3.fromRGB(255, 220, 150),
    CLOSE = Color3.fromRGB(200, 30, 30),
    MIN_BTN = Color3.fromRGB(60, 60, 80),
    GOLD = Color3.fromRGB(255, 200, 80),
    GOLD_DARK = Color3.fromRGB(180, 140, 50),
}

-- ════════════════════════════════════════════════════════════════
--  ANA SCREEN GUI
-- ════════════════════════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SlayerHub"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Boyutlar
local WIN_W = math.min(S(isMobile and 340 or 600), vp.X * 0.9)
local WIN_H = math.min(S(isMobile and 380 or 450), vp.Y * 0.85)
local STRIP_W = S(isMobile and 60 or 68)
local STRIP_H = WIN_H - S(60)
local TITLE_H = S(48)
local SCROLL_W = WIN_W - S(20)

-- Ana pencere
local win = Instance.new("Frame", sg)
win.Size = UDim2.fromOffset(WIN_W, WIN_H)
win.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
win.BackgroundColor3 = COL.BG
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0, S(12))

-- Kenarlık
do local s = Instance.new("UIStroke", win)
    s.Color = COL.GOLD
    s.Thickness = 1.5
    s.Transparency = 0.5
end

-- ════════════════════════════════════════════════════════════════
--  BAŞLIK BAR
-- ════════════════════════════════════════════════════════════════
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, S(12))

local logoTxt = Instance.new("TextLabel", titleBar)
logoTxt.Size = UDim2.new(1, -S(120), 1, 0)
logoTxt.Position = UDim2.new(0, S(14), 0, 0)
logoTxt.Text = "⚡ Slayer Hub"
logoTxt.TextSize = S(18)
logoTxt.Font = Enum.Font.GothamBold
logoTxt.TextColor3 = COL.GOLD
logoTxt.BackgroundTransparency = 1
logoTxt.TextXAlignment = Enum.TextXAlignment.Left

local subTxt = Instance.new("TextLabel", titleBar)
subTxt.Size = UDim2.new(0, S(100), 1, 0)
subTxt.Position = UDim2.new(0, S(145), 0, 0)
subTxt.Text = "by Slayer"
subTxt.TextSize = S(11)
subTxt.Font = Enum.Font.Gotham
subTxt.TextColor3 = COL.SUBTEXT
subTxt.BackgroundTransparency = 1
subTxt.TextXAlignment = Enum.TextXAlignment.Left
subTxt.TextYAlignment = Enum.TextYAlignment.Bottom

-- FPS
local fpsLbl = Instance.new("TextLabel", titleBar)
fpsLbl.Size = UDim2.fromOffset(S(70), TITLE_H)
fpsLbl.Position = UDim2.new(1, -S(130), 0, 0)
fpsLbl.Text = "60 FPS"
fpsLbl.TextSize = S(10)
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextColor3 = Color3.fromRGB(80, 255, 120)
fpsLbl.BackgroundTransparency = 1
fpsLbl.TextXAlignment = Enum.TextXAlignment.Right
conn(RS.Heartbeat, function()
    fpsLbl.Text = math.floor(FPS).." FPS"
    fpsLbl.TextColor3 = FPS > 50 and Color3.fromRGB(80, 255, 120)
        or FPS > 30 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(255, 60, 60)
end, "fps")

-- Butonlar
local function hdrBtn(txt, col, ox)
    local bSz = S(isMobile and 32 or 28)
    local b = Instance.new("TextButton", titleBar)
    b.Size = UDim2.fromOffset(bSz, bSz)
    b.Position = UDim2.new(1, ox, 0.5, -bSz/2)
    b.Text = txt
    b.TextSize = S(13)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = col
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, S(6))
    return b
end

local bSz2 = S(isMobile and 34 or 30)
local closeB = hdrBtn("✕", COL.CLOSE, -bSz2 - S(8))
local minB = hdrBtn("—", COL.MIN_BTN, -(bSz2 * 2) - S(14))

closeB.MouseButton1Click:Connect(function() win.Visible = false end)

local minimized = false
minB.MouseButton1Click:Connect(function()
    minimized = not minimized
    TS:Create(win, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
        Size = minimized and UDim2.fromOffset(WIN_W, TITLE_H) or UDim2.fromOffset(WIN_W, WIN_H)
    }):Play()
    minB.Text = minimized and "+" or "—"
end)

-- ════════════════════════════════════════════════════════════════
--  YATAY KAYDIRMA (DÜZ GUI - 90 DERECE DÖNME YOK)
-- ════════════════════════════════════════════════════════════════
local scrollF = Instance.new("ScrollingFrame", win)
scrollF.Size = UDim2.new(1, 0, 1, -TITLE_H)
scrollF.Position = UDim2.new(0, 0, 0, TITLE_H)
scrollF.BackgroundTransparency = 1
scrollF.ScrollBarThickness = isMobile and S(4) or S(3)
scrollF.ScrollBarImageColor3 = COL.GOLD
scrollF.ScrollingDirection = Enum.ScrollingDirection.X
scrollF.CanvasSize = UDim2.new(0, 0, 1, 0)
scrollF.AutomaticCanvasSize = Enum.AutomaticSize.X
scrollF.BorderSizePixel = 0

local hLayout = Instance.new("UIListLayout", scrollF)
hLayout.FillDirection = Enum.FillDirection.Horizontal
hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
hLayout.Padding = UDim.new(0, S(4))

local hPad = Instance.new("UIPadding", scrollF)
hPad.PaddingLeft = UDim.new(0, S(6))
hPad.PaddingRight = UDim.new(0, S(6))
hPad.PaddingTop = UDim.new(0, S(6))
hPad.PaddingBottom = UDim.new(0, S(6))

-- ════════════════════════════════════════════════════════════════
--  ŞERİT BİLEŞENİ (DÜZ METİN - DÖNME YOK)
-- ════════════════════════════════════════════════════════════════
local TW = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

local function makeStrip(label, tag, toggleCb, iconChar, overrideColors)
    local oc = overrideColors or {}
    local SBASE = oc.base or COL.STRIP
    local SON = oc.on or COL.STRIP_ON
    local SHOV = oc.hover or COL.STRIP_H

    local f = Instance.new("Frame", scrollF)
    f.Size = UDim2.fromOffset(STRIP_W, STRIP_H - S(12))
    f.BackgroundColor3 = SBASE
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, S(8))
    do local st = Instance.new("UIStroke", f)
        st.Color = oc.stroke or COL.GOLD_DARK
        st.Thickness = 0.8
        st.Transparency = 0.4
    end

    -- NORMAL METİN (90 DERECE DÖNME YOK)
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, 0, 1, -S(60))
    lbl.Position = UDim2.new(0, 0, 0, S(4))
    lbl.Text = label
    lbl.TextSize = S(isMobile and 10 or 11)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = oc.text or COL.TEXT
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true

    -- Alt bölge
    local botH = S(56)
    local bot = Instance.new("Frame", f)
    bot.Size = UDim2.new(1, 0, 0, botH)
    bot.Position = UDim2.new(0, 0, 1, -botH)
    bot.BackgroundTransparency = 1

    local isOn = false
    local knob, bgTog

    if toggleCb then
        local bgW = S(isMobile and 44 or 38)
        local bgH = S(isMobile and 22 or 18)
        local knW = S(isMobile and 15 or 12)
        bgTog = Instance.new("Frame", bot)
        bgTog.Size = UDim2.fromOffset(bgW, bgH)
        bgTog.Position = UDim2.new(0.5, -bgW/2, 0.5, -bgH/2)
        bgTog.BackgroundColor3 = COL.TOG_OFF
        bgTog.BorderSizePixel = 0
        Instance.new("UICorner", bgTog).CornerRadius = UDim.new(1, 0)
        knob = Instance.new("Frame", bgTog)
        knob.Size = UDim2.fromOffset(knW, knW)
        knob.Position = UDim2.new(0, S(3), 0.5, -knW/2)
        knob.BackgroundColor3 = COL.KNOB_OFF
        knob.BorderSizePixel = 0
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        if iconChar then
            local ico2 = Instance.new("TextLabel", bot)
            ico2.Size = UDim2.new(1, 0, 0, S(22))
            ico2.Position = UDim2.new(0, 0, 0, S(2))
            ico2.Text = iconChar
            ico2.TextSize = S(14)
            ico2.Font = Enum.Font.GothamBold
            ico2.BackgroundTransparency = 1
            ico2.TextColor3 = oc.icon or COL.SUBTEXT
        end
    else
        local ico = Instance.new("TextLabel", bot)
        ico.Size = UDim2.new(1, 0, 1, 0)
        ico.Text = iconChar or "▶"
        ico.TextSize = S(18)
        ico.Font = Enum.Font.GothamBold
        ico.TextColor3 = oc.icon or COL.GOLD
        ico.BackgroundTransparency = 1
    end

    -- Tıklama
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseEnter:Connect(function()
        TS:Create(f, TW, {BackgroundColor3 = SHOV}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(f, TW, {BackgroundColor3 = isOn and SON or SBASE}):Play()
    end)

    local function applyState(v)
        isOn = v
        if toggleCb then
            local knW2 = S(isMobile and 15 or 12)
            local bgW2 = S(isMobile and 44 or 38)
            if v then
                TS:Create(bgTog, TW, {BackgroundColor3 = COL.TOG_ON}):Play()
                TS:Create(knob, TW, {Position = UDim2.new(0, bgW2 - knW2 - S(3), 0.5, -knW2/2), BackgroundColor3 = COL.KNOB_ON}):Play()
                TS:Create(f, TW, {BackgroundColor3 = SON}):Play()
                lbl.TextColor3 = oc.icon or COL.GOLD
            else
                TS:Create(bgTog, TW, {BackgroundColor3 = COL.TOG_OFF}):Play()
                TS:Create(knob, TW, {Position = UDim2.new(0, S(3), 0.5, -knW2/2), BackgroundColor3 = COL.KNOB_OFF}):Play()
                TS:Create(f, TW, {BackgroundColor3 = SBASE}):Play()
                lbl.TextColor3 = oc.text or COL.TEXT
            end
            toggleCb(v)
        end
    end
    btn.MouseButton1Click:Connect(function()
        if toggleCb then applyState(not isOn)
        else
            TS:Create(f, TweenInfo.new(0.05), {BackgroundColor3 = SHOV}):Play()
            task.delay(0.12, function()
                TS:Create(f, TW, {BackgroundColor3 = SBASE}):Play()
            end)
        end
    end)
    return {frame = f, set = applyState, get = function() return isOn end, btn = btn, lbl = lbl, tag = tag}
end

local function makeBtnStrip(label, icon, cb, overrideColors)
    local s = makeStrip(label, label, nil, icon, overrideColors)
    s.btn.MouseButton1Click:Connect(cb)
    return s
end

local function makeDivider(label)
    local f = Instance.new("Frame", scrollF)
    f.Size = UDim2.fromOffset(S(isMobile and 30 or 26), STRIP_H - S(12))
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(0, S(2), 0.88, 0)
    line.Position = UDim2.new(0.5, -S(1), 0.06, 0)
    line.BackgroundColor3 = COL.GOLD_DARK
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.45
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0, S(80), 0, S(20))
    lbl.Position = UDim2.new(0.5, -S(40), 0.5, -S(10))
    lbl.Text = label
    lbl.TextSize = S(8)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = COL.GOLD_DARK
    lbl.BackgroundTransparency = 1
end

-- ════════════════════════════════════════════════════════════════
--  ⚙️ BOAT FLING SİSTEMİ (DÜZELTİLMİŞ)
-- ════════════════════════════════════════════════════════════════

local boatFlingActive = false
local boatFlingLoop = nil

-- Aşırı Fizik Fling Fonksiyonu
local function superFling(target)
    if not target then return end
    local char = target.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Aşırı yüksek hız ve dönüş uygula
    pcall(function()
        -- BodyAngularVelocity - Aşırı dönüş
        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(
            math.random(-99999, 99999),
            math.random(50000, 99999),
            math.random(-99999, 99999)
        )
        bav.Parent = root
        Debris:AddItem(bav, 0.15)
        
        -- BodyVelocity - Aşırı hız
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(
            math.random(-99999, 99999),
            math.random(50000, 99999),
            math.random(-99999, 99999)
        )
        bv.Parent = root
        Debris:AddItem(bv, 0.15)
        
        -- Doğrudan Velocity (AssemblyLinearVelocity)
        root.AssemblyLinearVelocity = Vector3.new(
            math.random(-99999, 99999),
            math.random(50000, 99999),
            math.random(-99999, 99999)
        )
        
        root.AssemblyAngularVelocity = Vector3.new(
            math.random(-99999, 99999),
            math.random(-99999, 99999),
            math.random(-99999, 99999)
        )
    end)
end

-- Tüm oyunculara Fling
local function flingAllPlayers()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            superFling(plr)
            task.wait(0.02)
        end
    end
end

-- Yakındaki oyuncuyu bul
local function getNearestPlayer()
    local r2 = R()
    if not r2 then return nil end
    local best, bestD = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            local t = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if t then
                local d = (t.Position - r2.Position).Magnitude
                if d < bestD then bestD = d; best = plr end
            end
        end
    end
    return best
end

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 1 — KARAKTER
-- ════════════════════════════════════════════════════════════════
makeDivider("⚡ KARAKTER")

-- Speed
makeStrip("⚡ SPEED", "speed", function(on)
    if on then
        conn(RS.Heartbeat, function()
            local h = H()
            if h then h.WalkSpeed = 80 end
        end, "speed")
    else
        disc("speed")
        local h = H()
        if h then h.WalkSpeed = 16 end
    end
end, "⚡")

-- Süper Zıplama
makeStrip("🦘 S.ZIPLAMA", "sjump", function(on)
    if on then
        conn(RS.Heartbeat, function()
            local h = H()
            if not h then return end
            pcall(function() h.JumpPower = 200 end)
            pcall(function() h.JumpHeight = 50 end)
        end, "sjump")
    else
        disc("sjump")
        local h = H()
        if not h then return end
        pcall(function() h.JumpPower = 50 end)
        pcall(function() h.JumpHeight = 7.2 end)
    end
end, "🦘")

-- Uçuş
local flyOn = false
local fV, fG, fCon
makeStrip("🛩️ UÇUŞ", "fly", function(on)
    flyOn = on
    local r2 = R()
    if on and r2 then
        fG = Instance.new("BodyGyro", r2)
        fG.MaxTorque = Vector3.new(9e8, 9e8, 9e8)
        fG.P = 9e4
        fV = Instance.new("BodyVelocity", r2)
        fV.MaxForce = Vector3.new(9e8, 9e8, 9e8)
        fV.Velocity = Vector3.zero
        fCon = RS.Heartbeat:Connect(function()
            local rt = R()
            if not(flyOn and rt) then
                if fCon then fCon:Disconnect() end
                return
            end
            local d = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
            local spd = UIS:IsKeyDown(Enum.KeyCode.LeftControl) and 220 or 95
            fV.Velocity = d.Magnitude > 0 and d.Unit * spd or Vector3.zero
            fG.CFrame = cam.CFrame
        end)
    else
        if fCon then fCon:Disconnect(); fCon = nil end
        pcall(function() if fV then fV:Destroy() end end)
        fV = nil
        pcall(function() if fG then fG:Destroy() end end)
        fG = nil
    end
end, "🛩️")

-- Noclip
local ncOn = false
makeStrip("👻 NOCLIP", "noclip", function(on)
    ncOn = on
    if on then
        conn(RS.Stepped, function()
            local c = C()
            if not c then return end
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end, "noclip")
    else
        disc("noclip")
        local c = C()
        if c then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end, "👻")

-- God Mode
makeStrip("🛡️ GOD", "god", function(on)
    local h = H()
    if not h then return end
    if on then
        h.MaxHealth = math.huge
        h.Health = math.huge
        conn(h.HealthChanged, function()
            if h and h.Parent then h.Health = math.huge end
        end, "god")
    else
        disc("god")
        pcall(function() h.MaxHealth = 100; h.Health = 100 end)
    end
end, "🛡️")

-- Anti-AFK
makeStrip("🟢 ANTIAFK", "afk", function(on)
    if on then
        local vu = game:GetService("VirtualUser")
        conn(RS.Heartbeat, function()
            vu:Button2Down(Vector2.zero, cam.CFrame)
            vu:Button2Up(Vector2.zero, cam.CFrame)
        end, "afk")
    else
        disc("afk")
    end
end, "🟢")

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 2 — BOAT FLING (DÜZELTİLMİŞ)
-- ════════════════════════════════════════════════════════════════
makeDivider("🚤 BOAT FLING")

-- Boat Fling renk teması
local FLING_CLR = {
    base = Color3.fromRGB(40, 20, 30),
    on = Color3.fromRGB(80, 30, 50),
    hover = Color3.fromRGB(100, 40, 60),
    stroke = Color3.fromRGB(255, 100, 80),
    text = Color3.fromRGB(255, 220, 210),
    icon = Color3.fromRGB(255, 100, 80),
}

-- Tekli Fling (Yakındaki oyuncuya)
makeBtnStrip("🎯 TEK FLING", "🎯", function()
    local target = getNearestPlayer()
    if target then
        superFling(target)
    end
end, FLING_CLR)

-- Tüm Oyunculara Fling
makeBtnStrip("💥 HERKES FLING", "💥", function()
    flingAllPlayers()
end, FLING_CLR)

-- Süper Fling (Aşırı güç)
makeBtnStrip("☄️ SÜPER FLING", "☄️", function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            superFling(plr)
            task.wait(0.01)
        end
    end
end, FLING_CLR)

-- OTOMATİK FLİNG (Toggle)
makeStrip("🔄 OTOMATİK", "autoFling", function(on)
    if on then
        boatFlingActive = true
        conn(RS.Heartbeat, function()
            if not boatFlingActive then return end
            local r2 = R()
            if not r2 then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= lp then
                    local t = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t and (t.Position - r2.Position).Magnitude < 50 then
                        superFling(plr)
                        task.wait(0.05)
                    end
                end
            end
        end, "autoFling")
    else
        boatFlingActive = false
        disc("autoFling")
    end
end, "🔄", FLING_CLR)

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 3 — GÖRSEL
-- ════════════════════════════════════════════════════════════════
makeDivider("🎨 GÖRSEL")

local oA = Lighting.Ambient
local oOA = Lighting.OutdoorAmbient
local oB = Lighting.Brightness
local oGS = Lighting.GlobalShadows
local oCT = Lighting.ClockTime

makeStrip("💡 FULLBRIGHT", "fb", function(on)
    if on then
        Lighting.Brightness = 10
        Lighting.ClockTime = 14
        Lighting.FogEnd = 999999
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = oB
        Lighting.ClockTime = oCT
        Lighting.GlobalShadows = oGS
        Lighting.Ambient = oA
        Lighting.OutdoorAmbient = oOA
        Lighting.FogEnd = 1000
    end
end, "💡")

makeStrip("🌙 GECE", "night", function(on)
    if on then
        Lighting.ClockTime = 0
        Lighting.Ambient = Color3.fromRGB(20, 20, 60)
        Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 40)
    else
        Lighting.ClockTime = oCT
        Lighting.Ambient = oA
        Lighting.OutdoorAmbient = oOA
    end
end, "🌙")

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 4 — ESP
-- ════════════════════════════════════════════════════════════════
makeDivider("👁️ ESP")

local espObjs = {}
local function clearESP()
    for _, o in pairs(espObjs) do
        pcall(function() o:Destroy() end)
    end
    espObjs = {}
end

local function buildESP()
    clearESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lp then continue end
        local char = plr.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end
        local r2 = R()
        local dist = r2 and math.floor((head.Position - r2.Position).Magnitude) or 0
        local hum = char:FindFirstChildOfClass("Humanoid")
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "SlayerEsp"
        bill.AlwaysOnTop = true
        bill.Size = UDim2.fromOffset(S(165), S(56))
        bill.StudsOffset = Vector3.new(0, 3.5, 0)
        local bg = Instance.new("Frame", bill)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
        bg.BackgroundTransparency = 0.2
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, S(6))
        do local st = Instance.new("UIStroke", bg)
            st.Color = COL.GOLD
            st.Thickness = 1.2
        end
        local rl = Instance.new("TextLabel", bg)
        rl.Size = UDim2.new(1, 0, 0.45, 0)
        rl.Text = "👤 " .. plr.Name .. " [" .. dist .. "m]"
        rl.TextSize = S(10)
        rl.Font = Enum.Font.GothamBold
        rl.TextColor3 = COL.GOLD
        rl.BackgroundTransparency = 1
        if hum then
            local hl = Instance.new("TextLabel", bg)
            hl.Size = UDim2.new(1, 0, 0.3, 0)
            hl.Position = UDim2.new(0, 0, 0.45, 0)
            hl.TextSize = S(9)
            hl.Font = Enum.Font.Gotham
            hl.TextColor3 = Color3.fromRGB(100, 255, 100)
            hl.BackgroundTransparency = 1
            hl.Text = "❤ " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hl.Parent then
                    hl.Text = "❤ " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                end
            end)
        end
        table.insert(espObjs, bill)
    end
end

makeStrip("👁️ ESP", "esp", function(on)
    if on then
        buildESP()
        conn(RS.Heartbeat, function()
            for _, o in pairs(espObjs) do
                if not(o and o.Parent) then
                    clearESP()
                    buildESP()
                    break
                end
            end
        end, "espWatch")
    else
        clearESP()
        disc("espWatch")
    end
end, "👁️")

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 5 — DÜNYA
-- ════════════════════════════════════════════════════════════════
makeDivider("🌍 DÜNYA")

makeBtnStrip("⭐ SPAWN", "⭐", function()
    local r2 = R()
    if not r2 then return end
    local sp = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if sp then r2.CFrame = sp.CFrame + Vector3.new(0, 5, 0) end
end)

makeBtnStrip("☁️ HAVAYA", "☁️", function()
    local r2 = R()
    if r2 then r2.CFrame = r2.CFrame + Vector3.new(0, 80, 0) end
end)

makeBtnStrip("🔄 RESPAWN", "🔄", function()
    lp:LoadCharacter()
end)

-- ════════════════════════════════════════════════════════════════
--  MOBİL HIZLI BUTONLAR
-- ════════════════════════════════════════════════════════════════
local quickBar = Instance.new("Frame", sg)
local qSz = S(isMobile and 54 or 42)
local qGap = S(5)
quickBar.Size = UDim2.fromOffset(qSz, (qSz + qGap) * 6)
quickBar.Position = UDim2.new(1, -qSz - S(8), 0.5, -((qSz + qGap) * 6) / 2)
quickBar.BackgroundTransparency = 1

local function qBtn(icon, col, idx, tip, fn)
    local b = Instance.new("TextButton", quickBar)
    b.Size = UDim2.fromOffset(qSz, qSz)
    b.Position = UDim2.fromOffset(0, idx * (qSz + qGap))
    b.Text = icon
    b.TextSize = S(isMobile and 20 or 16)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = col
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, S(isMobile and 12 or 9))
    do local s = Instance.new("UIStroke", b)
        s.Color = Color3.new(1, 1, 1)
        s.Thickness = 0.8
        s.Transparency = 0.65
    end
    local tipL = Instance.new("TextLabel", sg)
    tipL.Text = tip
    tipL.TextSize = S(10)
    tipL.Font = Enum.Font.GothamSemibold
    tipL.Size = UDim2.fromOffset(S(120), S(24))
    tipL.BackgroundColor3 = COL.BG
    tipL.BorderSizePixel = 0
    tipL.TextColor3 = COL.TEXT
    tipL.Visible = false
    Instance.new("UICorner", tipL).CornerRadius = UDim.new(0, S(5))
    do local s = Instance.new("UIStroke", tipL)
        s.Color = col
        s.Thickness = 1
    end
    b.MouseEnter:Connect(function()
        tipL.Position = UDim2.fromOffset(b.AbsolutePosition.X - S(128), b.AbsolutePosition.Y)
        tipL.Visible = true
    end)
    b.MouseLeave:Connect(function() tipL.Visible = false end)
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            TS:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
            tipL.Position = UDim2.fromOffset(b.AbsolutePosition.X - S(128), b.AbsolutePosition.Y)
            tipL.Visible = true
            task.delay(1.5, function() tipL.Visible = false end)
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            TS:Create(b, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
        end
    end)
    b.MouseButton1Click:Connect(fn)
    return b
end

qBtn("🏠", Color3.fromRGB(60, 50, 30), 0, "Menü", function()
    win.Visible = not win.Visible
end)

qBtn("⚡", Color3.fromRGB(70, 55, 30), 1, "Speed", function()
    local h = H()
    if not h then return end
    h.WalkSpeed = h.WalkSpeed > 50 and 16 or 80
end)

qBtn("🛩️", Color3.fromRGB(50, 40, 60), 2, "Uçuş", function()
    flyOn = not flyOn
    if flyOn then
        local r2 = R()
        if not r2 then return end
        fG = Instance.new("BodyGyro", r2)
        fG.MaxTorque = Vector3.new(9e8, 9e8, 9e8)
        fG.P = 9e4
        fV = Instance.new("BodyVelocity", r2)
        fV.MaxForce = Vector3.new(9e8, 9e8, 9e8)
        fV.Velocity = Vector3.zero
        fCon = RS.Heartbeat:Connect(function()
            local rt = R()
            if not(flyOn and rt) then
                if fCon then fCon:Disconnect() end
                return
            end
            local d = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
            fV.Velocity = d.Magnitude > 0 and d.Unit * 95 or Vector3.zero
            fG.CFrame = cam.CFrame
        end)
    else
        if fCon then fCon:Disconnect(); fCon = nil end
        pcall(function() if fV then fV:Destroy() end end)
        fV = nil
        pcall(function() if fG then fG:Destroy() end end)
        fG = nil
    end
end)

qBtn("💥", Color3.fromRGB(80, 30, 30), 3, "Herkes Fling", function()
    flingAllPlayers()
end)

qBtn("🎯", Color3.fromRGB(60, 30, 50), 4, "Tek Fling", function()
    local target = getNearestPlayer()
    if target then superFling(target) end
end)

qBtn("🛡️", Color3.fromRGB(50, 30, 60), 5, "God Mode", function()
    local h = H()
    if not h then return end
    h.MaxHealth = math.huge
    h.Health = math.huge
end)

-- ════════════════════════════════════════════════════════════════
--  PC KLAVYE KISAYOLLARI
-- ════════════════════════════════════════════════════════════════
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        win.Visible = not win.Visible
    elseif i.KeyCode == Enum.KeyCode.Delete then
        win.Visible = false
    elseif i.KeyCode == Enum.KeyCode.Insert then
        win.Visible = true
    elseif i.KeyCode == Enum.KeyCode.F5 then
        local h = H()
        if h then h.WalkSpeed = h.WalkSpeed > 50 and 16 or 80 end
    elseif i.KeyCode == Enum.KeyCode.F6 then
        flyOn = not flyOn
        if not flyOn then
            if fCon then fCon:Disconnect(); fCon = nil end
            pcall(function() if fV then fV:Destroy() end end)
            fV = nil
            pcall(function() if fG then fG:Destroy() end end)
            fG = nil
        end
    elseif i.KeyCode == Enum.KeyCode.F7 then
        flingAllPlayers()
    elseif i.KeyCode == Enum.KeyCode.F8 then
        local target = getNearestPlayer()
        if target then superFling(target) end
    end
end)

-- ════════════════════════════════════════════════════════════════
--  KARAKTER YENİLENME
-- ════════════════════════════════════════════════════════════════
lp.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    flyOn = false
    boatFlingActive = false
    if fCon then fCon:Disconnect(); fCon = nil end
    pcall(function() if fV then fV:Destroy() end end)
    fV = nil
    pcall(function() if fG then fG:Destroy() end end)
    fG = nil
    disc("autoFling")
    if ncOn then
        conn(RS.Stepped, function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end, "noclip")
    end
end)

-- ════════════════════════════════════════════════════════════════
--  BAŞLANGIÇ BİLDİRİMİ
-- ════════════════════════════════════════════════════════════════
local notifF = Instance.new("Frame", sg)
notifF.Size = UDim2.fromOffset(S(320), S(56))
notifF.Position = UDim2.new(0.5, -S(160), 1, S(10))
notifF.BackgroundColor3 = COL.BG
notifF.BorderSizePixel = 0
Instance.new("UICorner", notifF).CornerRadius = UDim.new(0, S(10))
do local s = Instance.new("UIStroke", notifF)
    s.Color = COL.GOLD
    s.Thickness = 1.5
end
local nl = Instance.new("TextLabel", notifF)
nl.Size = UDim2.new(1, -S(12), 1, 0)
nl.Position = UDim2.new(0, S(6), 0, 0)
nl.TextSize = S(11)
nl.Font = Enum.Font.GothamSemibold
nl.TextColor3 = COL.TEXT
nl.BackgroundTransparency = 1
nl.TextWrapped = true
nl.Text = "⚡ SLAYER HUB V2 — Brookhaven RP\n✅ Hazır!  " .. (isMobile and "📱 Mobil" or "💻 PC") ..
         "  |  F7=Tüm Fling  F8=Tek Fling"

TS:Create(notifF, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -S(160), 1, -S(70))}):Play()
task.delay(5, function()
    TS:Create(notifF, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -S(160), 1, S(10))}):Play()
    task.delay(0.6, function() notifF:Destroy() end)
end)

print("⚡ SLAYER HUB V2 — Brookhaven RP | Hazır!")
print("Klavye: RightShift=Menü | F5=Speed | F6=Uçuş | F7=Tüm Fling | F8=Tek Fling")
