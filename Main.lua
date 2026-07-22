-- ============================================
-- 🔥 LORD HUB V4 - BROOKHAVEN EDITION
-- Dark Hub / Syrox style professional hub
-- ============================================

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local Lighting       = game:GetService("Lighting")

local player = Players.LocalPlayer
local mouse  = player:GetMouse()

-- Fresh-reference helpers (karakter respawn'da bozulmasın)
local function getChar() return player.Character end
local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ============================================
-- 🎨 ANA ÇERÇEVE
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name       = "LordHubV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent     = player.PlayerGui

-- Daha orantılı boyut: 420 × 455
local Main = Instance.new("Frame")
Main.Name             = "Main"
Main.Size             = UDim2.new(0, 420, 0, 455)
Main.Position         = UDim2.new(0.5, -210, 0.5, -227)
Main.BackgroundColor3 = Color3.fromRGB(11, 11, 19)
Main.BorderSizePixel  = 0
Main.Active   = true
Main.Draggable = true
Main.Parent   = ScreenGui

local mainCorner = Instance.new("UICorner", Main)
mainCorner.CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", Main)
mainStroke.Color     = Color3.fromRGB(255, 45, 75)
mainStroke.Thickness = 1.5

-- ─── Başlık çubuğu ─────────────────────────
local TitleBar = Instance.new("Frame")
TitleBar.Size             = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
TitleBar.BorderSizePixel  = 0
TitleBar.Parent = Main
local tbCorner = Instance.new("UICorner", TitleBar)
tbCorner.CornerRadius = UDim.new(0, 10)
-- alt köşeleri kare yap (frame birleştirmek için)
local tbFix = Instance.new("Frame")
tbFix.Size             = UDim2.new(1, 0, 0.5, 0)
tbFix.Position         = UDim2.new(0, 0, 0.5, 0)
tbFix.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
tbFix.BorderSizePixel  = 0
tbFix.Parent = TitleBar

local titleIcon = Instance.new("TextLabel")
titleIcon.Size               = UDim2.new(0, 36, 0, 36)
titleIcon.Position           = UDim2.new(0, 8, 0.5, -18)
titleIcon.Text               = "🔥"
titleIcon.TextSize           = 22
titleIcon.BackgroundTransparency = 1
titleIcon.Parent = TitleBar

local titleName = Instance.new("TextLabel")
titleName.Size           = UDim2.new(0, 180, 0, 22)
titleName.Position       = UDim2.new(0, 46, 0, 7)
titleName.Text           = "LORD HUB V4"
titleName.TextColor3     = Color3.fromRGB(255, 255, 255)
titleName.TextSize       = 16
titleName.Font           = Enum.Font.GothamBold
titleName.TextXAlignment = Enum.TextXAlignment.Left
titleName.BackgroundTransparency = 1
titleName.Parent = TitleBar

local titleSub = Instance.new("TextLabel")
titleSub.Size           = UDim2.new(0, 200, 0, 14)
titleSub.Position       = UDim2.new(0, 46, 0, 27)
titleSub.Text           = "BROOKHAVEN EDITION"
titleSub.TextColor3     = Color3.fromRGB(255, 45, 75)
titleSub.TextSize       = 10
titleSub.Font           = Enum.Font.GothamSemibold
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.BackgroundTransparency = 1
titleSub.Parent = TitleBar

-- Kapat
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.new(0, 26, 0, 26)
CloseBtn.Position         = UDim2.new(1, -34, 0.5, -13)
CloseBtn.Text             = "✕"
CloseBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize         = 13
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 75)
CloseBtn.BorderSizePixel  = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size             = UDim2.new(0, 26, 0, 26)
MinBtn.Position         = UDim2.new(1, -64, 0.5, -13)
MinBtn.Text             = "—"
MinBtn.TextColor3       = Color3.fromRGB(200, 200, 220)
MinBtn.TextSize         = 13
MinBtn.Font             = Enum.Font.GothamBold
MinBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
MinBtn.BorderSizePixel  = 0
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- ─── Tab çubuğu ────────────────────────────
local TabBar = Instance.new("Frame")
TabBar.Size             = UDim2.new(1, 0, 0, 36)
TabBar.Position         = UDim2.new(0, 0, 0, 44)
TabBar.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
TabBar.BorderSizePixel  = 0
TabBar.Parent = Main

local tabBarLayout = Instance.new("UIListLayout")
tabBarLayout.FillDirection         = Enum.FillDirection.Horizontal
tabBarLayout.HorizontalAlignment   = Enum.HorizontalAlignment.Center
tabBarLayout.VerticalAlignment     = Enum.VerticalAlignment.Center
tabBarLayout.Padding               = UDim.new(0, 3)
tabBarLayout.Parent = TabBar

-- ─── İçerik alanı ──────────────────────────
local ContentArea = Instance.new("Frame")
ContentArea.Size             = UDim2.new(1, 0, 1, -80)
ContentArea.Position         = UDim2.new(0, 0, 0, 80)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main

-- ============================================
-- 🔲 TAB SİSTEMİ
-- ============================================

local tabButtons = {}
local tabPages   = {}
local activeTabIndex = 1

local TAB_NAMES = {"⚡ Kendin", "👥 Oyuncu", "👁 Görsel", "⚙ Ayarlar"}

local function switchTab(idx)
    for i = 1, #tabButtons do
        tabButtons[i].BackgroundColor3 = Color3.fromRGB(22, 22, 36)
        tabButtons[i].TextColor3       = Color3.fromRGB(140, 140, 170)
        tabPages[i].Visible            = false
    end
    tabButtons[idx].BackgroundColor3 = Color3.fromRGB(255, 45, 75)
    tabButtons[idx].TextColor3       = Color3.fromRGB(255, 255, 255)
    tabPages[idx].Visible            = true
    activeTabIndex = idx
end

for i, name in ipairs(TAB_NAMES) do
    -- Tab butonu
    local tb = Instance.new("TextButton")
    tb.Size             = UDim2.new(0, 88, 0, 28)
    tb.Text             = name
    tb.TextSize         = 10
    tb.Font             = Enum.Font.GothamSemibold
    tb.BackgroundColor3 = Color3.fromRGB(22, 22, 36)
    tb.TextColor3       = Color3.fromRGB(140, 140, 170)
    tb.BorderSizePixel  = 0
    tb.Parent           = TabBar
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
    tabButtons[i] = tb

    -- İçerik sayfası
    local page = Instance.new("ScrollingFrame")
    page.Size                = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness  = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 45, 75)
    page.CanvasSize          = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible             = false
    page.Parent              = ContentArea
    tabPages[i] = page

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding              = UDim.new(0, 6)
    pageLayout.HorizontalAlignment  = Enum.HorizontalAlignment.Center
    pageLayout.Parent = page

    local pagePad = Instance.new("UIPadding")
    pagePad.PaddingTop   = UDim.new(0, 8)
    pagePad.PaddingLeft  = UDim.new(0, 10)
    pagePad.PaddingRight = UDim.new(0, 10)
    pagePad.Parent = page

    local idx = i
    tb.MouseButton1Click:Connect(function() switchTab(idx) end)
end

switchTab(1)

-- ============================================
-- 🔘 UI ELEMENT YARDIMCILARI
-- ============================================

local TWINFO = TweenInfo.new(0.18, Enum.EasingStyle.Quad)

-- Bölüm başlığı
local function sectionLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size                = UDim2.new(1, 0, 0, 20)
    lbl.Text                = text
    lbl.TextColor3          = Color3.fromRGB(255, 45, 75)
    lbl.TextSize            = 10
    lbl.Font                = Enum.Font.GothamBold
    lbl.TextXAlignment      = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = parent
end

-- Toggle switch
local function makeToggle(parent, label, callback)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 33)
    row.BorderSizePixel  = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size                = UDim2.new(0.68, 0, 1, 0)
    lbl.Position            = UDim2.new(0, 12, 0, 0)
    lbl.Text                = label
    lbl.TextColor3          = Color3.fromRGB(215, 215, 235)
    lbl.TextSize            = 13
    lbl.Font                = Enum.Font.GothamSemibold
    lbl.TextXAlignment      = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = row

    local bg = Instance.new("Frame")
    bg.Size             = UDim2.new(0, 44, 0, 22)
    bg.Position         = UDim2.new(1, -56, 0.5, -11)
    bg.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    bg.BorderSizePixel  = 0
    bg.Parent = row
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 16, 0, 16)
    knob.Position         = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(170, 170, 190)
    knob.BorderSizePixel  = 0
    knob.Parent = bg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local enabled = false

    local function set(state)
        enabled = state
        if state then
            TweenService:Create(bg,   TWINFO, {BackgroundColor3 = Color3.fromRGB(255, 45, 75)}):Play()
            TweenService:Create(knob, TWINFO, {Position = UDim2.new(0, 25, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        else
            TweenService:Create(bg,   TWINFO, {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}):Play()
            TweenService:Create(knob, TWINFO, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.fromRGB(170,170,190)}):Play()
        end
        callback(state)
    end

    row.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            set(not enabled)
        end
    end)

    return { set = set, get = function() return enabled end }
end

-- Düz buton
local function makeButton(parent, label, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 45, 75)
    btn.Text             = label
    btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    btn.TextSize         = 13
    btn.Font             = Enum.Font.GothamSemibold
    btn.BorderSizePixel  = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TWINFO, {BackgroundTransparency = 0.25}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TWINFO, {BackgroundTransparency = 0}):Play()
    end)
    return btn
end

-- Slider
local function makeSlider(parent, label, minV, maxV, defaultV, callback)
    local container = Instance.new("Frame")
    container.Size             = UDim2.new(1, 0, 0, 56)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 33)
    container.BorderSizePixel  = 0
    container.Parent = parent
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size           = UDim2.new(0.65, 0, 0, 24)
    nameLbl.Position       = UDim2.new(0, 12, 0, 5)
    nameLbl.Text           = label
    nameLbl.TextColor3     = Color3.fromRGB(215, 215, 235)
    nameLbl.TextSize       = 13
    nameLbl.Font           = Enum.Font.GothamSemibold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.BackgroundTransparency = 1
    nameLbl.Parent = container

    local valLbl = Instance.new("TextLabel")
    valLbl.Size           = UDim2.new(0.3, -12, 0, 24)
    valLbl.Position       = UDim2.new(0.7, 0, 0, 5)
    valLbl.Text           = tostring(defaultV)
    valLbl.TextColor3     = Color3.fromRGB(255, 45, 75)
    valLbl.TextSize       = 13
    valLbl.Font           = Enum.Font.GothamBold
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.BackgroundTransparency = 1
    valLbl.Parent = container

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, -24, 0, 5)
    track.Position         = UDim2.new(0, 12, 0, 38)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    track.BorderSizePixel  = 0
    track.Parent = container
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local pct0 = (defaultV - minV) / (maxV - minV)

    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new(pct0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 45, 75)
    fill.BorderSizePixel  = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size             = UDim2.new(0, 13, 0, 13)
    knob.AnchorPoint      = Vector2.new(0.5, 0.5)
    knob.Position         = UDim2.new(pct0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel  = 0
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local currentVal = defaultV

    local function update(x)
        local abs   = track.AbsolutePosition.X
        local width = track.AbsoluteSize.X
        local p     = math.clamp((x - abs) / width, 0, 1)
        currentVal  = math.floor(minV + p * (maxV - minV))
        valLbl.Text = tostring(currentVal)
        fill.Size   = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        callback(currentVal)
    end

    knob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    track.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; update(inp.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            update(inp.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- ============================================
-- ⚡ TAB 1 — KENDİN
-- ============================================

local selfPage = tabPages[1]

sectionLabel(selfPage, "  HAREKET")

-- Hız slider (16–250)
makeSlider(selfPage, "🏃 Hız", 16, 250, 16, function(v)
    local h = getHum()
    if h then h.WalkSpeed = v end
end)

-- Zıplama slider (50–500)
makeSlider(selfPage, "⬆️ Zıplama Gücü", 50, 500, 50, function(v)
    local h = getHum()
    if h then
        -- Eski & yeni Roblox API desteği
        pcall(function() h.JumpPower  = v end)
        pcall(function() h.JumpHeight = v / 6 end)
    end
end)

sectionLabel(selfPage, "  ÖZELLİKLER")

-- Uçuş (WASD + Space/Shift ile kontrol)
local flying = false
local flyVel, flyGyro, flyConn

makeToggle(selfPage, "🛩️ Uçuş (WASD ile)", function(state)
    flying = state
    local root = getRoot()
    if state and root then
        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(9e8, 9e8, 9e8)
        flyGyro.P         = 9e4
        flyGyro.Parent    = root

        flyVel = Instance.new("BodyVelocity")
        flyVel.MaxForce = Vector3.new(9e8, 9e8, 9e8)
        flyVel.Velocity = Vector3.zero
        flyVel.Parent   = root

        flyConn = RunService.Heartbeat:Connect(function()
            local r = getRoot()
            if not flying or not r then
                flyConn:Disconnect(); return
            end
            local cam = workspace.CurrentCamera
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector  end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
            flyVel.Velocity = dir.Magnitude > 0 and dir.Unit * 65 or Vector3.zero
            flyGyro.CFrame  = cam.CFrame
        end)
    else
        if flyConn  then flyConn:Disconnect();   flyConn  = nil end
        if flyVel   then flyVel:Destroy();        flyVel   = nil end
        if flyGyro  then flyGyro:Destroy();       flyGyro  = nil end
    end
end)

-- Noclip
local noclipConn

makeToggle(selfPage, "🌫️ Noclip", function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            local c = getChar()
            if not c then return end
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
        local c = getChar()
        if c then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = true end
            end
        end
    end
end)

-- Sonsuz Zıplama
local infJumpConn

makeToggle(selfPage, "🚀 Sonsuz Zıplama", function(state)
    if state then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local h = getHum()
            if h and h.FloorMaterial == Enum.Material.Air then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    end
end)

-- God Mode
makeToggle(selfPage, "🛡️ God Mode", function(state)
    local h = getHum()
    if not h then return end
    if state then
        h.MaxHealth = math.huge
        h.Health    = math.huge
    else
        h.MaxHealth = 100
        h.Health    = 100
    end
end)

-- Anti-AFK
local afkConn

makeToggle(selfPage, "💤 Anti-AFK", function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        afkConn = RunService.Heartbeat:Connect(function()
            vu:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
            vu:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
        end)
    else
        if afkConn then afkConn:Disconnect(); afkConn = nil end
    end
end)

-- ============================================
-- 👥 TAB 2 — OYUNCU
-- ============================================

local playerPage = tabPages[2]

sectionLabel(playerPage, "  OYUNCU SEÇ")

-- Oyuncu listesi kutusu
local listBox = Instance.new("Frame")
listBox.Size             = UDim2.new(1, 0, 0, 145)
listBox.BackgroundColor3 = Color3.fromRGB(17, 17, 28)
listBox.BorderSizePixel  = 0
listBox.Parent = playerPage
Instance.new("UICorner", listBox).CornerRadius = UDim.new(0, 8)

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size                = UDim2.new(1, 0, 1, 0)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness  = 2
playerScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 45, 75)
playerScroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerScroll.Parent = listBox

local plrLayout = Instance.new("UIListLayout")
plrLayout.Padding = UDim.new(0, 3)
plrLayout.Parent  = playerScroll

local plrPad = Instance.new("UIPadding")
plrPad.PaddingAll = UDim.new(0, 5)
plrPad.Parent     = playerScroll

-- Seçili oyuncu label
local selLabel = Instance.new("TextLabel")
selLabel.Size                = UDim2.new(1, 0, 0, 26)
selLabel.Text                = "🎯 Seçili: Yok"
selLabel.TextColor3          = Color3.fromRGB(255, 45, 75)
selLabel.TextSize            = 12
selLabel.Font                = Enum.Font.GothamSemibold
selLabel.BackgroundTransparency = 1
selLabel.Parent = playerPage

local selectedPlayer = nil
local plrBtns        = {}

local function refreshPlayers()
    for _, b in pairs(plrBtns) do b:Destroy() end
    plrBtns = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size             = UDim2.new(1, -4, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
            btn.Text             = "  " .. plr.Name
            btn.TextColor3       = Color3.fromRGB(210, 210, 230)
            btn.TextSize         = 12
            btn.Font             = Enum.Font.GothamSemibold
            btn.TextXAlignment   = Enum.TextXAlignment.Left
            btn.BorderSizePixel  = 0
            btn.Parent = playerScroll
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                selLabel.Text  = "🎯 Seçili: " .. plr.Name
                for _, b in pairs(plrBtns) do
                    b.BackgroundColor3 = Color3.fromRGB(26, 26, 40)
                    b.TextColor3       = Color3.fromRGB(210, 210, 230)
                end
                btn.BackgroundColor3 = Color3.fromRGB(255, 45, 75)
                btn.TextColor3       = Color3.fromRGB(255, 255, 255)
            end)

            table.insert(plrBtns, btn)
        end
    end
end

makeButton(playerPage, "🔄 Oyuncuları Yenile", Color3.fromRGB(45, 45, 68), refreshPlayers)

sectionLabel(playerPage, "  OYUNCU İŞLEMLERİ")

makeButton(playerPage, "📦 Teleport Et", Color3.fromRGB(0, 130, 220), function()
    if not selectedPlayer then return end
    local root   = getRoot()
    local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and target then
        root.CFrame = target.CFrame + Vector3.new(0, 4, 3)
    end
end)

makeButton(playerPage, "📥 Yanına Getir", Color3.fromRGB(190, 140, 0), function()
    if not selectedPlayer then return end
    local root   = getRoot()
    local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and target then
        target.CFrame = root.CFrame + Vector3.new(3, 0, 0)
    end
end)

makeButton(playerPage, "💀 Öldür", Color3.fromRGB(200, 25, 25), function()
    if not selectedPlayer then return end
    local h = selectedPlayer.Character and selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Health = 0 end
end)

makeButton(playerPage, "💥 Fling", Color3.fromRGB(215, 75, 0), function()
    if not selectedPlayer then return end
    local root = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local vel = Instance.new("BodyVelocity")
        vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        vel.Velocity  = Vector3.new(math.random(-400,400), math.random(300,600), math.random(-400,400))
        vel.Parent    = root
        task.wait(0.2)
        vel:Destroy()
    end
end)

-- Sürekli Teleport (rahatsız et)
local annoyConn

makeToggle(playerPage, "😈 Sürekli Teleport (Loop)", function(state)
    if state then
        annoyConn = RunService.Heartbeat:Connect(function()
            local root   = getRoot()
            local target = selectedPlayer and selectedPlayer.Character
                           and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root and target then
                target.CFrame = root.CFrame + Vector3.new(2, 0, 2)
            end
        end)
    else
        if annoyConn then annoyConn:Disconnect(); annoyConn = nil end
    end
end)

makeButton(playerPage, "🚤 Boat Attack", Color3.fromRGB(160, 30, 30), function()
    if not selectedPlayer then return end
    local root   = getRoot()
    local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (root and target) then return end

    local boat = Instance.new("Part")
    boat.Size     = Vector3.new(10, 3, 5)
    boat.Position = root.Position + Vector3.new(0, 30, 0)
    boat.Material = Enum.Material.Neon
    boat.Color    = Color3.fromRGB(255, 0, 0)
    boat.Anchored = false
    boat.Name     = "LordBoat"
    boat.Parent   = workspace

    local vel = Instance.new("BodyVelocity")
    vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    vel.Velocity  = (target.Position - boat.Position).Unit * 220 + Vector3.new(0, 40, 0)
    vel.Parent    = boat

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not boat or not boat.Parent then conn:Disconnect(); return end
        local tgt = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not tgt then boat:Destroy(); conn:Disconnect(); return end
        if (boat.Position - tgt.Position).Magnitude < 14 then
            local exp = Instance.new("Explosion")
            exp.Position     = tgt.Position
            exp.BlastRadius  = 20
            exp.BlastPressure = 500000
            exp.Parent       = workspace
            local h = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
            boat:Destroy()
            conn:Disconnect()
        end
    end)

    task.delay(6, function()
        if boat and boat.Parent then boat:Destroy() end
        if conn then conn:Disconnect() end
    end)
end)

makeButton(playerPage, "💣 Patlat (Explosion)", Color3.fromRGB(180, 60, 0), function()
    if not selectedPlayer then return end
    local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not target then return end
    local exp = Instance.new("Explosion")
    exp.Position      = target.Position
    exp.BlastRadius   = 30
    exp.BlastPressure = 999999
    exp.Parent        = workspace
end)

makeButton(playerPage, "🌀 Spin (Döndür)", Color3.fromRGB(120, 0, 200), function()
    if not selectedPlayer then return end
    local root = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local bg = Instance.new("BodyAngularVelocity")
    bg.MaxTorque     = Vector3.new(math.huge, math.huge, math.huge)
    bg.AngularVelocity = Vector3.new(0, 200, 0)
    bg.Parent        = root
    task.wait(3)
    bg:Destroy()
end)

makeButton(playerPage, "🔫 Çek (Pull)", Color3.fromRGB(0, 160, 120), function()
    if not selectedPlayer then return end
    local root   = getRoot()
    local target = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (root and target) then return end
    -- Seçili oyuncuyu hızla kendine doğru çek
    local vel = Instance.new("BodyVelocity")
    vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    vel.Velocity  = (root.Position - target.Position).Unit * 300
    vel.Parent    = target
    task.wait(0.15)
    vel:Destroy()
end)

makeButton(playerPage, "🪂 Havaya Fırlat", Color3.fromRGB(100, 100, 200), function()
    if not selectedPlayer then return end
    local root = selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local vel = Instance.new("BodyVelocity")
    vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    vel.Velocity  = Vector3.new(0, 900, 0)
    vel.Parent    = root
    task.wait(0.25)
    vel:Destroy()
end)

sectionLabel(playerPage, "  HERKESE")

makeButton(playerPage, "💀 Herkesi Öldür", Color3.fromRGB(170, 0, 0), function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local h = plr.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end
end)

makeButton(playerPage, "💥 Herkesi Fling", Color3.fromRGB(170, 35, 0), function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = Instance.new("BodyVelocity")
                vel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                vel.Velocity  = Vector3.new(math.random(-500,500), math.random(400,700), math.random(-500,500))
                vel.Parent    = root
                task.wait(0.08)
                vel:Destroy()
            end
        end
    end
end)

-- ============================================
-- 👁 TAB 3 — GÖRSEL
-- ============================================

local visualPage = tabPages[3]

sectionLabel(visualPage, "  ESP")

local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espObjects = {}
end

local function buildESP()
    clearESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if not head then continue end

            local bill = Instance.new("BillboardGui")
            bill.Name        = "LordESP"
            bill.Size        = UDim2.new(0, 170, 0, 50)
            bill.StudsOffset = Vector3.new(0, 3.5, 0)
            bill.AlwaysOnTop = true
            bill.Parent      = head

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size                = UDim2.new(1, 0, 0.55, 0)
            nameLbl.Text                = plr.Name
            nameLbl.TextColor3          = Color3.fromRGB(255, 255, 50)
            nameLbl.TextSize            = 14
            nameLbl.Font                = Enum.Font.GothamBold
            nameLbl.TextStrokeTransparency = 0
            nameLbl.TextStrokeColor3    = Color3.fromRGB(0,0,0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Parent = bill

            local hpLbl = Instance.new("TextLabel")
            hpLbl.Size             = UDim2.new(1, 0, 0.45, 0)
            hpLbl.Position         = UDim2.new(0, 0, 0.55, 0)
            hpLbl.TextColor3       = Color3.fromRGB(100, 255, 100)
            hpLbl.TextSize         = 11
            hpLbl.Font             = Enum.Font.Gotham
            hpLbl.TextStrokeTransparency = 0
            hpLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            hpLbl.BackgroundTransparency = 1
            hpLbl.Parent = bill

            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hpLbl.Text = "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                -- canlı HP güncellemesi
                hum:GetPropertyChangedSignal("Health"):Connect(function()
                    if hpLbl.Parent then
                        hpLbl.Text = "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                    end
                end)
            end

            table.insert(espObjects, bill)
        end
    end
end

makeToggle(visualPage, "👁️ Player ESP (İsim + HP)", function(state)
    if state then buildESP() else clearESP() end
end)

sectionLabel(visualPage, "  ORTAM")

-- Fullbright
local origAmbient    = Lighting.Ambient
local origOutdoor    = Lighting.OutdoorAmbient
local origBrightness = Lighting.Brightness
local origShadows    = Lighting.GlobalShadows
local origClock      = Lighting.ClockTime

makeToggle(visualPage, "💡 Fullbright", function(state)
    if state then
        Lighting.Brightness      = 10
        Lighting.ClockTime       = 14
        Lighting.FogEnd          = 100000
        Lighting.GlobalShadows   = false
        Lighting.Ambient         = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient  = Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness      = origBrightness
        Lighting.ClockTime       = origClock
        Lighting.GlobalShadows   = origShadows
        Lighting.Ambient         = origAmbient
        Lighting.OutdoorAmbient  = origOutdoor
    end
end)

-- Gece Modu
makeToggle(visualPage, "🌙 Gece Modu", function(state)
    if state then
        Lighting.ClockTime = 0
        Lighting.Ambient   = Color3.fromRGB(30, 30, 70)
    else
        Lighting.ClockTime = origClock
        Lighting.Ambient   = origAmbient
    end
end)

sectionLabel(visualPage, "  KARAKTER")

-- Chams
local chamsConn

makeToggle(visualPage, "🌈 Chams (Gökkuşağı)", function(state)
    if state then
        local t = 0
        chamsConn = RunService.Heartbeat:Connect(function(dt)
            t += dt
            local c = getChar()
            if c then
                for _, p in pairs(c:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.Color = Color3.fromHSV((t * 0.4) % 1, 1, 1)
                    end
                end
            end
        end)
    else
        if chamsConn then chamsConn:Disconnect(); chamsConn = nil end
        local c = getChar()
        if c then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Color = Color3.fromRGB(163, 162, 165) -- varsayılan
                end
            end
        end
    end
end)

-- Karakter Gizle
makeToggle(visualPage, "👻 Karakteri Gizle", function(state)
    local c = getChar()
    if c then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("Decal") then
                p.LocalTransparencyModifier = state and 1 or 0
            end
        end
    end
end)

-- ============================================
-- ⚙️ TAB 4 — AYARLAR
-- ============================================

local settingsPage = tabPages[4]

sectionLabel(settingsPage, "  KLAVYE KISA YOLLARI")

local keysFrame = Instance.new("Frame")
keysFrame.Size             = UDim2.new(1, 0, 0, 68)
keysFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 33)
keysFrame.BorderSizePixel  = 0
keysFrame.Parent = settingsPage
Instance.new("UICorner", keysFrame).CornerRadius = UDim.new(0, 8)

local keysLbl = Instance.new("TextLabel")
keysLbl.Size             = UDim2.new(1, -20, 1, 0)
keysLbl.Position         = UDim2.new(0, 10, 0, 0)
keysLbl.Text             = "RightShift → Menüyü Aç / Kapat\nDelete     → Menüyü Kapat\nInsert     → Menüyü Aç"
keysLbl.TextColor3       = Color3.fromRGB(190, 190, 215)
keysLbl.TextSize         = 12
keysLbl.Font             = Enum.Font.Gotham
keysLbl.TextXAlignment   = Enum.TextXAlignment.Left
keysLbl.TextWrapped      = true
keysLbl.BackgroundTransparency = 1
keysLbl.Parent = keysFrame

sectionLabel(settingsPage, "  HAKKINDA")

local aboutFrame = Instance.new("Frame")
aboutFrame.Size             = UDim2.new(1, 0, 0, 90)
aboutFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 33)
aboutFrame.BorderSizePixel  = 0
aboutFrame.Parent = settingsPage
Instance.new("UICorner", aboutFrame).CornerRadius = UDim.new(0, 8)

local aboutLbl = Instance.new("TextLabel")
aboutLbl.Size             = UDim2.new(1, -20, 1, 0)
aboutLbl.Position         = UDim2.new(0, 10, 0, 0)
aboutLbl.Text             = "🔥 LORD HUB V4\nBROOKHAVEN EDITION\n\nDark Hub / Syrox tarzı profesyonel hub\nUçuş · Noclip · Sonsuz Zıplama · ESP · Chams"
aboutLbl.TextColor3       = Color3.fromRGB(180, 180, 210)
aboutLbl.TextSize         = 12
aboutLbl.Font             = Enum.Font.Gotham
aboutLbl.TextWrapped      = true
aboutLbl.TextYAlignment   = Enum.TextYAlignment.Center
aboutLbl.BackgroundTransparency = 1
aboutLbl.Parent = aboutFrame

makeButton(settingsPage, "🔄 Scripti Yeniden Başlat", Color3.fromRGB(50, 50, 75), function()
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui.Name == "LordHubV4" then gui:Destroy() end
    end
    -- Executor'dan tekrar yükle
end)

-- ============================================
-- 🔘 ARAMA / KAPAMA BUTONU (Sol kenar)
-- ============================================

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size             = UDim2.new(0, 46, 0, 46)
toggleBtn.Position         = UDim2.new(0, 12, 0.5, -23)
toggleBtn.Text             = "🔥"
toggleBtn.TextSize         = 22
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 45, 75)
toggleBtn.BorderSizePixel  = 0
toggleBtn.Parent = ScreenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local togStroke = Instance.new("UIStroke", toggleBtn)
togStroke.Color     = Color3.fromRGB(255,255,255)
togStroke.Thickness = 1

toggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- ─── Klavye kısayolları ─────────────────────
UserInputService.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    elseif inp.KeyCode == Enum.KeyCode.Delete then
        Main.Visible = false
    elseif inp.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = true
    end
end)

-- ─── Minimize ──────────────────────────────
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = minimized
            and UDim2.new(0, 420, 0, 44)
            or  UDim2.new(0, 420, 0, 455)
    }):Play()
    MinBtn.Text = minimized and "+" or "—"
end)

-- ============================================
-- 🔄 BAŞLAT
-- ============================================

refreshPlayers()
Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)

-- Karakter respawn'da fly/noclip durumunu düzelt
player.CharacterAdded:Connect(function(char)
    task.wait(0.5) -- karakter yüklenmesini bekle
    if flying then
        flying = false -- temiz başlat
    end
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = RunService.Stepped:Connect(function()
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
end)

print("🔥 LORD HUB V4 - BROOKHAVEN EDITION YÜKLENDİ!")
print("📌 RightShift → Menüyü aç/kapat")
print("📌 Sol kenardaki 🔥 butonuna da tıklayabilirsin")
