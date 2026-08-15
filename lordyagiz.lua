--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║     ⚡ LORD YAGIZ_ - WAR TYCOON ULTIMATE v5.1                ║
    ║     ★ Kaydırılabilir Menü (SCROLLABLE)                      ║
    ║     ★ Sınırsız Mesafe Aimbot + Otomatik Sıkma               ║
    ║     ★ Gelişmiş ESP + Config Sistemi                         ║
    ║     ★ Tüm Özellikler Tek Ekranda                           ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ================================================================
-- GÜVENLİ BAŞLANGIÇ
-- ================================================================
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.5)

-- ================================================================
-- SERVİSLER
-- ================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- ================================================================
-- CONFIG SİSTEMİ
-- ================================================================
local Config = {
    Version = "5.1",
    Aimbot = {
        Enabled = false,
        FOV = 999999,
        Smoothness = 0.08,
        HitPart = "Head",
        Silent = false,
        AimLock = true,
        AutoSwitch = true,
        VisibleCheck = false,
        TeamCheck = false,
        Prediction = true,
    },
    Triggerbot = {
        Enabled = false,
        FireRate = 0.08,
        AutoFire = true,
        HoldToFire = false,
    },
    ESP = {
        Enabled = true,
        ShowName = true,
        ShowHealth = true,
        ShowDistance = true,
        ShowBox = true,
        ShowTracer = true,
        ShowHeadDot = true,
        ColorEnemy = Color3.fromRGB(255, 0, 0),
        ColorFriend = Color3.fromRGB(0, 255, 0),
        ColorTarget = Color3.fromRGB(255, 255, 0),
    },
    Mobile = {
        ShowHUD = true,
        Crosshair = true,
        AutoFireTouch = false,
    },
    Performance = {
        Mode = "Auto",
        ESPQuality = "High",
    }
}

local Settings = {}
local function deepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then copy[k] = deepCopy(v) else copy[k] = v end
    end
    return copy
end
Settings = deepCopy(Config)

-- ================================================================
-- KAYDIRILABİLİR MENÜ (SCROLLABLE)
-- ================================================================
local Menu = {
    Gui = nil,
    Frame = nil,
    ScrollingFrame = nil,
    Buttons = {},
    Visible = false,
}

function Menu:Create()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LordYagiz_Ultimate"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    self.Gui = screenGui
    
    -- Ana Buton (sol üst)
    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(0, 55, 0, 55)
    mainBtn.Position = UDim2.new(0, 10, 0, 10)
    mainBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    mainBtn.BorderSizePixel = 2
    mainBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
    mainBtn.Text = "⚡"
    mainBtn.TextSize = 28
    mainBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
    mainBtn.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 28)
    mainCorner.Parent = mainBtn
    
    -- Animasyon
    TweenService:Create(mainBtn, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 65)
    }):Play()
    
    -- ANA MENÜ FRAME
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 500)
    frame.Position = UDim2.new(0, 10, 0, 75)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(60, 60, 120)
    frame.Visible = false
    frame.Parent = screenGui
    self.Frame = frame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    -- KAYDIRMA ÇERÇEVESİ (SCROLLING FRAME)
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 200)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600) -- İçerik yüksekliği
    scrollFrame.Parent = frame
    self.ScrollingFrame = scrollFrame
    
    -- İçerik konteyneri
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 600)
    container.BackgroundTransparency = 1
    container.Parent = scrollFrame
    
    -- Başlık
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "⚡ LORD YAGIZ_ v5.1"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = container
    
    -- Alt başlık
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 25)
    subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "🔥 War Tycoon Ultimate - Scrollable Menu"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
    subtitle.TextSize = 13
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = container
    
    -- Buton oluşturma fonksiyonu
    local function createToggle(text, y, default, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 38)
        btn.Position = UDim2.new(0.05, 0, y, 0)
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 80)
        btn.Text = text .. (default and " ✅" or " ❌")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 15
        btn.Font = Enum.Font.GothamBold
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        -- Hover efekti
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = btn.BackgroundColor3 + Color3.fromRGB(20, 20, 20)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = btn.BackgroundColor3 - Color3.fromRGB(20, 20, 20)
            }):Play()
        end)
        
        local state = default or false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 80)
            btn.Text = text .. (state and " ✅" or " ❌")
            if callback then callback(state) end
        end)
        table.insert(self.Buttons, btn)
        return btn
    end
    
    -- Bölüm başlıkları
    local function createSection(text, y)
        local section = Instance.new("TextLabel")
        section.Size = UDim2.new(0.9, 0, 0, 25)
        section.Position = UDim2.new(0.05, 0, y, 0)
        section.BackgroundTransparency = 1
        section.Text = text
        section.TextColor3 = Color3.fromRGB(200, 200, 255)
        section.TextSize = 14
        section.Font = Enum.Font.GothamBold
        section.TextXAlignment = Enum.TextXAlignment.Left
        section.Parent = container
        return section
    end
    
    -- === COMBAT BÖLÜMÜ ===
    createSection("⚔️ COMBAT", 0.12)
    
    createToggle("🔒 AIMBOT", 0.20, false, function(v) Settings.Aimbot.Enabled = v end)
    createToggle("🎯 TRIGGERBOT", 0.30, false, function(v) Settings.Triggerbot.Enabled = v end)
    createToggle("🔥 AUTO FIRE", 0.40, true, function(v) Settings.Triggerbot.AutoFire = v end)
    createToggle("🤫 SILENT AIM", 0.50, false, function(v) Settings.Aimbot.Silent = v end)
    createToggle("🔒 AIM LOCK", 0.60, true, function(v) Settings.Aimbot.AimLock = v end)
    createToggle("🔄 AUTO SWITCH", 0.70, true, function(v) Settings.Aimbot.AutoSwitch = v end)
    
    -- === ESP BÖLÜMÜ ===
    createSection("👁️ ESP", 0.82)
    
    createToggle("👁️ ESP", 0.90, true, function(v) Settings.ESP.Enabled = v end)
    createToggle("👤 SHOW NAME", 1.00, true, function(v) Settings.ESP.ShowName = v end)
    createToggle("❤️ SHOW HEALTH", 1.10, true, function(v) Settings.ESP.ShowHealth = v end)
    createToggle("📏 SHOW DISTANCE", 1.20, true, function(v) Settings.ESP.ShowDistance = v end)
    createToggle("📦 SHOW BOX", 1.30, true, function(v) Settings.ESP.ShowBox = v end)
    
    -- === MOBİL BÖLÜMÜ ===
    createSection("📱 MOBILE", 1.42)
    
    createToggle("📱 HUD BUTTONS", 1.50, true, function(v) Settings.Mobile.ShowHUD = v end)
    createToggle("🎯 CROSSHAIR", 1.60, true, function(v) Settings.Mobile.Crosshair = v end)
    createToggle("🔥 TOUCH FIRE", 1.70, false, function(v) Settings.Mobile.AutoFireTouch = v end)
    
    -- === CONFIG BÖLÜMÜ ===
    createSection("💾 CONFIG", 1.82)
    
    -- Config butonları
    local function createConfigButton(text, y, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.28, 0, 0, 32)
        btn.Position = UDim2.new(0.05 + (y % 3) * 0.32, 0, 1.90 + math.floor(y / 3) * 0.12, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.Parent = container
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        return btn
    end
    
    createConfigButton("💾 SAVE", 0, function()
        for category, settings in pairs(Config) do
            if Settings[category] then
                for setting, value in pairs(settings) do
                    Config[category][setting] = Settings[category][setting]
                end
            end
        end
        print("⚡ Config Saved!")
    end)
    
    createConfigButton("📂 LOAD", 1, function()
        for category, settings in pairs(Config) do
            if Settings[category] then
                for setting, value in pairs(settings) do
                    Settings[category][setting] = value
                end
            end
        end
        print("⚡ Config Loaded!")
    end)
    
    createConfigButton("🔄 RESET", 2, function()
        Settings = deepCopy(Config)
        print("⚡ Config Reset!")
    end)
    
    -- Canvas boyutunu güncelle
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    
    -- Aç/Kapa
    mainBtn.MouseButton1Click:Connect(function()
        self.Visible = not self.Visible
        frame.Visible = self.Visible
    end)
end

-- ================================================================
-- ESP SİSTEMİ
-- ================================================================
local ESP = {
    Objects = {},
}

function ESP:Update()
    if not Settings.ESP.Enabled then
        for _, obj in pairs(self.Objects) do
            if obj then pcall(function() obj:Destroy() end) end
        end
        self.Objects = {}
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    if not self.Objects[player] then
                        self.Objects[player] = self:CreateESP(player)
                    end
                end
            end
        end
    end
end

function ESP:CreateESP(player)
    local char = player.Character
    local isTarget = (player == aimbotTarget)
    local color = isTarget and Settings.ESP.ColorTarget or 
                  (player.Team == LocalPlayer.Team and Settings.ESP.ColorFriend or Settings.ESP.ColorEnemy)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.AlwaysOnTop = true
    billboard.Adornee = char
    billboard.Parent = char
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = billboard
    
    -- İsim
    if Settings.ESP.ShowName then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 25)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = color
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.3
        nameLabel.Parent = frame
    end
    
    -- Can Barı
    if Settings.ESP.ShowHealth then
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(0.8, 0, 0, 10)
        healthBar.Position = UDim2.new(0.1, 0, 0.3, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        healthBar.BorderSizePixel = 0
        healthBar.Parent = frame
        
        local healthFill = Instance.new("Frame")
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.BackgroundColor3 = color
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBar
        
        task.spawn(function()
            while billboard and billboard.Parent do
                task.wait(0.1)
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.MaxHealth > 0 then
                    local hp = hum.Health / hum.MaxHealth
                    healthFill.Size = UDim2.new(hp, 0, 1, 0)
                    healthFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
                end
            end
        end)
    end
    
    -- Mesafe
    if Settings.ESP.ShowDistance then
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0, 20)
        distLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = ""
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 12
        distLabel.Font = Enum.Font.Gotham
        distLabel.Parent = frame
        
        task.spawn(function()
            while billboard and billboard.Parent do
                task.wait(0.2)
                local root = char:FindFirstChild("HumanoidRootPart")
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root and myRoot then
                    local dist = (root.Position - myRoot.Position).Magnitude
                    distLabel.Text = math.floor(dist) .. "m"
                end
            end
        end)
    end
    
    -- Kutu
    if Settings.ESP.ShowBox then
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 60, 0, 80)
        box.Position = UDim2.new(0.5, -30, 0.3, 0)
        box.BackgroundTransparency = 0.8
        box.BackgroundColor3 = color
        box.BorderSizePixel = 1
        box.BorderColor3 = color
        box.Parent = frame
    end
    
    return billboard
end

-- ================================================================
-- AIMBOT + TRIGGERBOT
-- ================================================================
local aimbotTarget = nil
local lastFireTime = 0

local function getBestTarget()
    local best = nil
    local bestDist = Settings.Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                if not Settings.Aimbot.TeamCheck or player.Team ~= LocalPlayer.Team then
                    local part = player.Character:FindFirstChild(Settings.Aimbot.HitPart) or 
                                 player.Character:FindFirstChild("HumanoidRootPart")
                    if part then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                            if dist < bestDist then
                                bestDist = dist
                                best = {player = player, part = part}
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function fireWeapon()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end

-- ANA DÖNGÜ
RunService.Heartbeat:Connect(function()
    if not LocalPlayer or not LocalPlayer.Character then return end
    
    -- AIMBOT
    if Settings.Aimbot.Enabled then
        local target = getBestTarget()
        if target then
            aimbotTarget = target.player
            local targetPos = target.part.Position
            
            if Settings.Aimbot.Prediction then
                local vel = target.part.AssemblyLinearVelocity or Vector3.zero
                targetPos = targetPos + (vel * 0.12)
            end
            
            if Settings.Aimbot.Silent then
                local screenPos = Camera:WorldToViewportPoint(targetPos)
                Mouse.Move(Vector2.new(screenPos.X, screenPos.Y))
            else
                local newCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                local smooth = 1 - Settings.Aimbot.Smoothness
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, smooth)
            end
            
            -- TRIGGERBOT
            if Settings.Triggerbot.Enabled then
                local currentTime = tick()
                if currentTime - lastFireTime >= Settings.Triggerbot.FireRate then
                    fireWeapon()
                    lastFireTime = currentTime
                end
            end
        else
            aimbotTarget = nil
        end
    end
    
    -- ESP
    ESP:Update()
end)

-- ================================================================
-- MOBİL DESTEĞİ
-- ================================================================
if UserInputService.TouchEnabled then
    UserInputService.TouchEnded:Connect(function(touch)
        if Settings.Mobile.AutoFireTouch then
            fireWeapon()
        end
    end)
end

-- ================================================================
-- BAŞLATMA
-- ================================================================
Menu:Create()

print("⚡ LORD YAGIZ_ v5.1 ULTRA loaded successfully!")
print("📱 Sol üstteki ⚡ butonuna tıkla - KAYDIRILABİLİR Menü açılır")
print("🎯 Sınırsız mesafe Aimbot + Otomatik sıkma aktif!")
print("👁️ Gelişmiş ESP sistemi çalışıyor!")
print("💾 Config sistemi ile ayarlarını kaydedebilirsin!")

-- ================================================================
-- TEMİZLİK
-- ================================================================
game:BindToClose(function()
    if Menu.Gui then Menu.Gui:Destroy() end
    for _, obj in pairs(ESP.Objects) do
        pcall(function() obj:Destroy() end)
    end
end)
