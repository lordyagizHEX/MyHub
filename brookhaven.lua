--[[
  ╔══════════════════════════════════════════════════════════════════╗
  ║        SLAYER HUB — BROOKHAVEN RP  V2  (MOBİL + PC)            ║
  ║  Otomatik mobil/PC algılama | Dikey şerit GUI                  ║
  ║  Fly · Speed · Fling · ESP · Car Hack · House · Anti-Fling     ║
  ║  God Mode · Noclip · Anti-AFK · Visual FX · +45 Özellik        ║
  ║  ⚙️ Fling Boat V2 — Tekne ile toplu fırlatma                   ║
  ╚══════════════════════════════════════════════════════════════════╝
--]]

-- ── Servisler ───────────────────────────────────────────────────
local Players    = game:GetService("Players")
local RS         = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TS         = game:GetService("TweenService")
local Lighting   = game:GetService("Lighting")
local Debris     = game:GetService("Debris")
local Replicated = game:GetService("ReplicatedStorage")
local lp         = Players.LocalPlayer
local pgui       = lp.PlayerGui
local cam        = workspace.CurrentCamera

-- Eski GUI temizle
if pgui:FindFirstChild("SlayerHub") then pgui.SlayerHub:Destroy() end

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
--  RENK PALETİ — Slayer Hub Altın/Koyu tema
-- ════════════════════════════════════════════════════════════════
local COL = {
    BG        = Color3.fromRGB(20, 20, 26),    -- #14141A
    STRIP     = Color3.fromRGB(30, 30, 40),
    STRIP_H   = Color3.fromRGB(50, 50, 66),
    STRIP_ON  = Color3.fromRGB(60, 55, 45),
    ACCENT    = Color3.fromRGB(255, 200, 80),  -- #FFC850
    ACCENT2   = Color3.fromRGB(180, 140, 60),
    TEXT      = Color3.fromRGB(255, 250, 240),
    SUBTEXT   = Color3.fromRGB(150, 150, 170), -- #9696AA
    TOG_OFF   = Color3.fromRGB(40, 40, 50),
    TOG_ON    = Color3.fromRGB(220, 180, 70),
    KNOB_OFF  = Color3.fromRGB(80, 80, 100),
    KNOB_ON   = Color3.fromRGB(255, 220, 150),
    CLOSE     = Color3.fromRGB(200, 30, 30),   -- Kırmızı
    MIN_BTN   = Color3.fromRGB(60, 60, 80),
    GOLD      = Color3.fromRGB(255, 200, 80),
    GOLD_DARK = Color3.fromRGB(180, 140, 50),
}

-- ════════════════════════════════════════════════════════════════
--  ANA SCREEN GUI — Slayer Hub
-- ════════════════════════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SlayerHub"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Boyutlar (600x450)
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

-- Gölge efekti (hafif glow)
local shadow = Instance.new("Frame", win)
shadow.Size = UDim2.new(1, S(8), 1, S(8))
shadow.Position = UDim2.new(0, -S(4), 0, -S(4))
shadow.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
shadow.BackgroundTransparency = 0.92
shadow.BorderSizePixel = 0
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, S(16))

-- Kenarlık
do local s = Instance.new("UIStroke", win)
    s.Color = COL.GOLD
    s.Thickness = 1.5
    s.Transparency = 0.5
end

-- ════════════════════════════════════════════════════════════════
--  BAŞLIK BAR — Slayer Hub
-- ════════════════════════════════════════════════════════════════
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, S(12))

-- Başlık "Slayer Hub" — Altın sarısı
local logoTxt = Instance.new("TextLabel", titleBar)
logoTxt.Size = UDim2.new(1, -S(120), 1, 0)
logoTxt.Position = UDim2.new(0, S(14), 0, 0)
logoTxt.Text = "⚡ Slayer Hub"
logoTxt.TextSize = S(18)
logoTxt.Font = Enum.Font.GothamBold
logoTxt.TextColor3 = COL.GOLD
logoTxt.BackgroundTransparency = 1
logoTxt.TextXAlignment = Enum.TextXAlignment.Left

-- Alt Başlık "by Slayer" — Gri
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

-- Kapatma Butonu (✕ Kırmızı)
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
--  YATAY KAYDIRMA (ScrollingFrame)
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
--  ŞERİT (STRIP) BİLEŞENİ
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

    -- Döndürülmüş metin
    local rotF = Instance.new("Frame", f)
    rotF.Size = UDim2.new(0, STRIP_H - S(70), 0, STRIP_W - S(10))
    rotF.Position = UDim2.new(0.5, -(STRIP_H - S(70))/2, 0, S(5))
    rotF.BackgroundTransparency = 1
    rotF.Rotation = 90
    local lbl = Instance.new("TextLabel", rotF)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = label
    lbl.TextSize = S(isMobile and 12 or 11)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = oc.text or COL.TEXT
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextWrapped = false

    -- Alt bölge
    local botH = S(60)
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
            ico2.TextSize = S(15)
            ico2.Font = Enum.Font.GothamBold
            ico2.BackgroundTransparency = 1
            ico2.TextColor3 = oc.icon or COL.SUBTEXT
        end
    else
        local ico = Instance.new("TextLabel", bot)
        ico.Size = UDim2.new(1, 0, 1, 0)
        ico.Text = iconChar or "▶"
        ico.TextSize = S(20)
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
    f.Size = UDim2.fromOffset(S(isMobile and 26 or 22), STRIP_H - S(12))
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(0, S(2), 0.88, 0)
    line.Position = UDim2.new(0.5, -S(1), 0.06, 0)
    line.BackgroundColor3 = COL.GOLD_DARK
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.45
    local rF = Instance.new("Frame", f)
    rF.Size = UDim2.new(0, S(82), 0, S(20))
    rF.Position = UDim2.new(0.5, -S(41), 0.5, -S(10))
    rF.BackgroundTransparency = 1
    rF.Rotation = 90
    local l = Instance.new("TextLabel", rF)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = label
    l.TextSize = S(7)
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = COL.GOLD_DARK
    l.BackgroundTransparency = 1
end

-- ════════════════════════════════════════════════════════════════
--  ⚙️ FLING BOAT V2 SİSTEMİ
-- ════════════════════════════════════════════════════════════════

local boatModel = nil
local boatSeat = nil
local boatRoot = nil
local boatFlingActive = false
local boatTargetPlayers = {}
local boatTargetAll = false

-- Tekne oluşturma
local function spawnBoat()
    -- Var olan tekneyi temizle
    if boatModel then
        pcall(function() boatModel:Destroy() end)
        boatModel = nil
        boatSeat = nil
        boatRoot = nil
    end

    -- Brookhaven'daki tekne spawn remote'u (örnek)
    local remote = ReplicatedStorage:FindFirstChild("Vehicle") or 
                   ReplicatedStorage:FindFirstChild("SpawnVehicle") or
                   ReplicatedStorage:FindFirstChild("VehicleSpawn")

    if remote then
        pcall(function()
            remote:FireServer("Boat", "Jet Ski") -- veya "Speedboat"
        end)
    else
        -- Alternatif: kendi tekne modelimizi oluşturalım
        local boat = Instance.new("Model")
        boat.Name = "SlayerBoat"

        -- Ana gövde
        local hull = Instance.new("Part")
        hull.Size = Vector3.new(12, 3, 5)
        hull.Position = Vector3.new(0, 0, 0)
        hull.Shape = Enum.PartType.Cylinder
        hull.Material = Enum.Material.Plastic
        hull.Color = Color3.fromRGB(255, 200, 80)
        hull.Anchored = false
        hull.CanCollide = true
        hull.Parent = boat

        -- Koltuk
        local seat = Instance.new("VehicleSeat")
        seat.Size = Vector3.new(3, 1.5, 3)
        seat.Position = Vector3.new(0, 2, 0)
        seat.MaxSpeed = 200
        seat.Torque = 500000
        seat.Parent = boat

        boat.Parent = workspace
        boatModel = boat
        boatSeat = seat
        boatRoot = hull
        return boat
    end

    -- Remote ile spawn yapıldıysa, tekneyi bul
    task.wait(1)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") and obj.Parent and obj.Parent:IsA("Model") then
            local name = obj.Parent.Name:lower()
            if name:find("boat") or name:find("jet") or name:find("speed") or name:find("motor") then
                boatModel = obj.Parent
                boatSeat = obj
                boatRoot = obj.Parent:FindFirstChild("HumanoidRootPart") or obj
                break
            end
        end
    end
end

-- Tekneyi hedef oyuncuya fırlat
local function flingBoatTarget(target)
    if not boatModel or not boatSeat or not boatRoot then return end
    if not target then return end

    local char = target.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- Tekneyi hedefin üzerine ışınla
    local pos = rootPart.Position + Vector3.new(0, 3, 0)
    boatRoot.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(math.random(-30, 30)), math.rad(math.random(0, 360)), math.rad(math.random(-30, 30)))

    -- Aşırı hız ver (fizik patlaması)
    pcall(function()
        local bv = Instance.new("BodyVelocity", boatRoot)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(
            math.random(-500, 500),
            math.random(300, 800),
            math.random(-500, 500)
        )
        Debris:AddItem(bv, 0.15)

        local bav = Instance.new("BodyAngularVelocity", boatRoot)
        bav.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bav.AngularVelocity = Vector3.new(
            math.random(-5000, 5000),
            math.random(-5000, 5000),
            math.random(-5000, 5000)
        )
        Debris:AddItem(bav, 0.15)
    end)

    -- Oyuncuyu da fırlat (ekstra)
    pcall(function()
        local bv2 = Instance.new("BodyVelocity", rootPart)
        bv2.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv2.Velocity = Vector3.new(
            math.random(-300, 300),
            math.random(200, 600),
            math.random(-300, 300)
        )
        Debris:AddItem(bv2, 0.12)
    end)
end

-- Tüm oyunculara fling
local function flingBoatAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            flingBoatTarget(plr)
            task.wait(0.05)
        end
    end
end

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 1 — KARAKTER
-- ════════════════════════════════════════════════════════════════
makeDivider("⚡ KARAKTER")

-- Speed
makeStrip("⚡ SPEED\nHACK", "speed", function(on)
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
makeStrip("🦘 SÜPER\nZIPLAMA", "sjump", function(on)
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

-- Sonsuz Zıplama
makeStrip("♾️ SONSUZ\nZIPLAMA", "infJump", function(on)
    if on then
        conn(UIS.JumpRequest, function()
            local h = H()
            if h and h.FloorMaterial == Enum.Material.Air then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end, "infJump")
    else
        disc("infJump")
    end
end, "♾️")

-- Uçuş
local flyOn = false
local fV, fG, fCon
makeStrip("🛩️ UÇUŞ\nMODU", "fly", function(on)
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
makeStrip("👻 NO\nCLİP", "noclip", function(on)
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
makeStrip("🛡️ GOD\nMODE", "god", function(on)
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

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 2 — FLING BOAT V2 (ANA ÖZELLİK)
-- ════════════════════════════════════════════════════════════════
makeDivider("🚤 FLING BOAT V2")

-- Fling Boat renk teması (Altın/Mavi)
local BOAT_CLR = {
    base   = Color3.fromRGB(20, 25, 40),
    on     = Color3.fromRGB(40, 50, 70),
    hover  = Color3.fromRGB(60, 70, 90),
    stroke = Color3.fromRGB(255, 200, 80),
    text   = Color3.fromRGB(255, 250, 240),
    icon   = Color3.fromRGB(255, 200, 80),
}

-- Tekne Hazırla
makeBtnStrip("🚤 TEKNE\nHAZIRLA", "🚤", function()
    spawnBoat()
    -- Bildirim
    local notif = Instance.new("TextLabel", sg)
    notif.Size = UDim2.fromOffset(S(250), S(36))
    notif.Position = UDim2.new(0.5, -S(125), 0.02, 0)
    notif.Text = "✅ Tekne Hazır!"
    notif.TextSize = S(12)
    notif.Font = Enum.Font.GothamBold
    notif.TextColor3 = COL.GOLD
    notif.BackgroundColor3 = COL.BG
    notif.BorderSizePixel = 0
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, S(8))
    do local s = Instance.new("UIStroke", notif)
        s.Color = COL.GOLD
        s.Thickness = 1
    end
    task.delay(2, function()
        TS:Create(notif, TweenInfo.new(0.4), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        task.delay(0.5, function() notif:Destroy() end)
    end)
end, BOAT_CLR)

-- Hedef Seç (Dropdown) — Tüm Oyuncular veya Seçili
local targetMode = "All" -- "All" veya "Selected"
local selectedTarget = nil

-- Hedef seçim şeridi
do
    local f = Instance.new("Frame", scrollF)
    f.Size = UDim2.fromOffset(STRIP_W * 1.8, STRIP_H - S(12))
    f.BackgroundColor3 = BOAT_CLR.base
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, S(8))
    do local st = Instance.new("UIStroke", f)
        st.Color = BOAT_CLR.stroke
        st.Thickness = 0.8
        st.Transparency = 0.4
    end

    local titleL = Instance.new("TextLabel", f)
    titleL.Size = UDim2.new(1, 0, 0, S(26))
    titleL.Position = UDim2.new(0, 0, 0, S(4))
    titleL.Text = "🎯 FLING HEDEFİ"
    titleL.TextSize = S(11)
    titleL.Font = Enum.Font.GothamBold
    titleL.TextColor3 = BOAT_CLR.icon
    titleL.BackgroundTransparency = 1

    local selLbl = Instance.new("TextLabel", f)
    selLbl.Size = UDim2.new(1, 0, 0, S(20))
    selLbl.Position = UDim2.new(0, 0, 0, S(28))
    selLbl.Text = "Hedef: Tüm Oyuncular"
    selLbl.TextSize = S(9)
    selLbl.Font = Enum.Font.GothamSemibold
    selLbl.TextColor3 = COL.SUBTEXT
    selLbl.BackgroundTransparency = 1

    -- Butonlar: All / Seçili
    local function smallBtn(txt, col, x, w, cb)
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.fromOffset(w, S(22))
        b.Position = UDim2.fromOffset(x, S(52))
        b.Text = txt
        b.TextSize = S(9)
        b.Font = Enum.Font.GothamBold
        b.TextColor3 = Color3.new(1, 1, 1)
        b.BackgroundColor3 = col
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, S(4))
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local btnW = math.floor((STRIP_W * 1.8 - S(8)) / 2)
    smallBtn("🌍 Tüm Oyuncular", Color3.fromRGB(40, 50, 70), S(4), btnW, function()
        targetMode = "All"
        selectedTarget = nil
        selLbl.Text = "Hedef: Tüm Oyuncular"
        selLbl.TextColor3 = COL.GOLD
    end)

    smallBtn("🎯 Seçili", Color3.fromRGB(70, 40, 60), S(4) + btnW + S(2), btnW, function()
        targetMode = "Selected"
        -- Yakındaki oyuncuyu otomatik seç
        local r2 = R()
        if r2 then
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
            selectedTarget = best
            if best then
                selLbl.Text = "Hedef: " .. best.Name
                selLbl.TextColor3 = COL.GOLD
            else
                selLbl.Text = "Hedef: Yok (oyuncu bulunamadı)"
                selLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end
    end)

    -- Oyuncu listesi (ScrollingFrame)
    local listSF = Instance.new("ScrollingFrame", f)
    listSF.Size = UDim2.new(1, -S(6), 1, -S(108))
    listSF.Position = UDim2.new(0, S(3), 0, S(78))
    listSF.BackgroundTransparency = 1
    listSF.BorderSizePixel = 0
    listSF.ScrollBarThickness = S(3)
    listSF.ScrollBarImageColor3 = COL.GOLD
    listSF.CanvasSize = UDim2.new(0, 0, 0, 0)
    listSF.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ll = Instance.new("UIListLayout", listSF)
    ll.Padding = UDim.new(0, S(3))
    ll.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local pBtns = {}
    local function refreshPlayerList()
        for _, b in pairs(pBtns) do pcall(function() b:Destroy() end) end
        pBtns = {}
        local plrs = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then table.insert(plrs, p) end
        end
        if #plrs == 0 then
            local nl = Instance.new("TextLabel", listSF)
            nl.Size = UDim2.new(1, 0, 0, S(24))
            nl.Text = "Başka oyuncu yok"
            nl.TextSize = S(9)
            nl.Font = Enum.Font.Gotham
            nl.TextColor3 = COL.SUBTEXT
            nl.BackgroundTransparency = 1
            table.insert(pBtns, nl)
            return
        end
        for _, plr in pairs(plrs) do
            local b = Instance.new("TextButton", listSF)
            b.Size = UDim2.new(1, 0, 0, S(26))
            b.Text = "👤 " .. plr.Name
            b.TextSize = S(9)
            b.Font = Enum.Font.GothamSemibold
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.TextColor3 = COL.TEXT
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            b.BorderSizePixel = 0
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, S(4))
            local pl2 = plr
            b.MouseButton1Click:Connect(function()
                selectedTarget = pl2
                targetMode = "Selected"
                selLbl.Text = "Hedef: " .. pl2.Name
                selLbl.TextColor3 = COL.GOLD
                for _, x in pairs(pBtns) do
                    if x:IsA("TextButton") then
                        x.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                    end
                end
                b.BackgroundColor3 = COL.GOLD_DARK
            end)
            table.insert(pBtns, b)
        end
    end
    refreshPlayerList()

    Players.PlayerAdded:Connect(function() task.wait(0.5); refreshPlayerList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.1); refreshPlayerList() end)
end

-- Fling Boat Aktifleştir (Toggle)
makeStrip("🔥 FLING\nBOAT", "flingBoat", function(on)
    boatFlingActive = on
    if on then
        -- Önce tekne yoksa oluştur
        if not boatModel then spawnBoat() end
        if not boatModel then return end

        conn(RS.Heartbeat, function()
            if not boatFlingActive then return end
            if not boatModel or not boatRoot then return end

            if targetMode == "All" then
                -- Tüm oyunculara sırayla fling
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= lp then
                        flingBoatTarget(plr)
                        task.wait(0.03)
                    end
                end
            else
                -- Seçili oyuncu
                if selectedTarget then
                    flingBoatTarget(selectedTarget)
                else
                    -- Yakındaki oyuncuyu bul
                    local r2 = R()
                    if r2 then
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
                        if best then
                            selectedTarget = best
                            flingBoatTarget(best)
                        end
                    end
                end
            end
        end, "flingBoatLoop")
    else
        disc("flingBoatLoop")
    end
end, "🔥", BOAT_CLR)

-- Tek Fling (Tek seferlik)
makeBtnStrip("💥 TEK\nFLİNG", "💥", function()
    if not boatModel then spawnBoat() end
    if not boatModel then return end

    if targetMode == "All" then
        flingBoatAll()
    elseif selectedTarget then
        flingBoatTarget(selectedTarget)
    else
        -- Yakındaki oyuncu
        local r2 = R()
        if r2 then
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
            if best then flingBoatTarget(best) end
        end
    end
end, BOAT_CLR)

-- Süper Fling (Aşırı güç)
makeBtnStrip("☄️ SÜPER\nFLİNG", "☄️", function()
    if not boatModel then spawnBoat() end
    if not boatModel then return end

    -- Aşırı güç versiyonu
    local function superFling(target)
        if not target then return end
        local char = target.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        -- Tekneyi hedefe ışınla
        local pos = rootPart.Position + Vector3.new(0, 5, 0)
        boatRoot.CFrame = CFrame.new(pos)

        -- Çok yüksek hız
        pcall(function()
            local bv = Instance.new("BodyVelocity", boatRoot)
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.new(
                math.random(-1000, 1000),
                math.random(800, 1500),
                math.random(-1000, 1000)
            )
            Debris:AddItem(bv, 0.2)
        end)

        -- Oyuncuyu da fırlat
        pcall(function()
            local bv2 = Instance.new("BodyVelocity", rootPart)
            bv2.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv2.Velocity = Vector3.new(
                math.random(-600, 600),
                math.random(500, 1000),
                math.random(-600, 600)
            )
            Debris:AddItem(bv2, 0.15)
        end)
    end

    if targetMode == "All" then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= lp then
                superFling(plr)
                task.wait(0.05)
            end
        end
    elseif selectedTarget then
        superFling(selectedTarget)
    end
end, BOAT_CLR)

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 3 — GÖRSEL EFEKTLER
-- ════════════════════════════════════════════════════════════════
makeDivider("🎨 GÖRSEL")

local oA = Lighting.Ambient
local oOA = Lighting.OutdoorAmbient
local oB = Lighting.Brightness
local oGS = Lighting.GlobalShadows
local oCT = Lighting.ClockTime

makeStrip("💡 FULL\nBRIGHT", "fb", function(on)
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

makeStrip("🌙 GECE\nMODU", "night", function(on)
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

makeStrip("👁️ OYUNCU\nESP", "esp", function(on)
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
--  BÖLÜM 5 — ARAÇ
-- ════════════════════════════════════════════════════════════════
makeDivider("🚗 ARAÇ")

local boostedCars = {}
makeStrip("🚗 ARAÇ\nHIZI", "carhack", function(on)
    if on then
        conn(RS.Heartbeat, function()
            local r2 = R()
            if not r2 then return end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") and not boostedCars[obj] then
                    if (obj.Position - r2.Position).Magnitude < 22 then
                        pcall(function()
                            obj.MaxSpeed = 200
                            obj.Torque = 250000
                        end)
                        boostedCars[obj] = true
                    end
                end
            end
        end, "carhack")
    else
        disc("carhack")
        for s, _ in pairs(boostedCars) do
            pcall(function() s.MaxSpeed = 60; s.Torque = 10000 end)
        end
        boostedCars = {}
    end
end, "🚗")

-- ════════════════════════════════════════════════════════════════
--  BÖLÜM 6 — DÜNYA
-- ════════════════════════════════════════════════════════════════
makeDivider("🌍 DÜNYA")

makeBtnStrip("⭐ SPAWN'A\nISINLAN", "⭐", function()
    local r2 = R()
    if not r2 then return end
    local sp = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if sp then r2.CFrame = sp.CFrame + Vector3.new(0, 5, 0) end
end)

makeBtnStrip("☁️ HAVAYA\nZIPLA", "☁️", function()
    local r2 = R()
    if r2 then r2.CFrame = r2.CFrame + Vector3.new(0, 80, 0) end
end)

makeBtnStrip("🔄 HIZLI\nRESPAWN", "🔄", function()
    lp:LoadCharacter()
end)

-- ════════════════════════════════════════════════════════════════
--  MOBİL HIZLI BUTONLAR (Sağ taraf)
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

qBtn("🏠", Color3.fromRGB(60, 50, 30), 0, "Menü Aç/Kapat", function()
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

qBtn("🚤", Color3.fromRGB(30, 50, 80), 3, "Fling Boat", function()
    if not boatModel then spawnBoat() end
    if targetMode == "All" then
        flingBoatAll()
    elseif selectedTarget then
        flingBoatTarget(selectedTarget)
    end
end)

qBtn("💥", Color3.fromRGB(80, 30, 30), 4, "Herkesi Fling", function()
    if not boatModel then spawnBoat() end
    flingBoatAll()
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
        if not boatModel then spawnBoat() end
        if targetMode == "All" then
            flingBoatAll()
        elseif selectedTarget then
            flingBoatTarget(selectedTarget)
        end
    end
end)

-- ════════════════════════════════════════════════════════════════
--  KARAKTER YENİLENME
-- ════════════════════════════════════════════════════════════════
lp.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    flyOn = false
    if fCon then fCon:Disconnect(); fCon = nil end
    pcall(function() if fV then fV:Destroy() end end)
    fV = nil
    pcall(function() if fG then fG:Destroy() end end)
    fG = nil
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
notifF.Size = UDim2.fromOffset(S(340), S(58))
notifF.Position = UDim2.new(0.5, -S(170), 1, S(10))
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
         "  |  RightShift=Menü  F7=FlingBoat"

TS:Create(notifF, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -S(170), 1, -S(72))}):Play()
task.delay(5, function()
    TS:Create(notifF, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, -S(170), 1, S(10))}):Play()
    task.delay(0.6, function() notifF:Destroy() end)
end)

print("⚡ SLAYER HUB V2 — Brookhaven RP | Hazır!")
print("Klavye: RightShift=Menü | F5=Speed | F6=Uçuş | F7=FlingBoat")
