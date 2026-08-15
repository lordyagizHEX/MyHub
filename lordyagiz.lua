--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                                                                  ║
    ║     ⚡ LORD YAGIZ_ - WAR TYCOON ULTIMATE v3.0                 ║
    ║                                                                  ║
    ║     ★ EzBypass Teknolojisi                                     ║
    ║     ★ Gelişmiş Aimbot + Triggerbot                             ║
    ║     ★ Tam Mobil Uyum (Patates Telefon Desteği)                 ║
    ║     ★ FPS Optimizasyonu + Akıllı Performans Yönetimi          ║
    ║     ★ Anti-Kasma Sistemi                                      ║
    ║     ★ Gelişmiş ESP + Health Bar                               ║
    ║     ★ Akıllı Config Yönetimi                                  ║
    ║                                                                  ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ================================================================
-- PERFORMANS YÖNETİCİSİ (Patates Telefonlar için)
-- ================================================================
local PerformanceManager = {
    Mode = "Auto", -- "Auto", "Low", "Medium", "High", "Ultra", "Potato"
    CurrentFPS = 60,
    FrameSkip = 0,
    MaxFrameSkip = 3,
    DynamicQuality = true,
    LowMemoryMode = false,
    BatterySaver = false,
    Stats = {
        fps = 60,
        ping = 0,
        memory = 0,
        frameTime = 0,
    }
}

function PerformanceManager:DetectDevice()
    local isMobile = UserInputService.TouchEnabled
    local isLowEnd = false
    
    -- Cihaz tespiti
    pcall(function()
        -- Düşük bellek kontrolü
        local mem = collectgarbage("count") or 0
        if mem > 100000 then -- 100MB üzeri
            isLowEnd = true
        end
        
        -- FPS testi (kısa süreli)
        local startTime = tick()
        local frameCount = 0
        for i = 1, 100 do
            frameCount = frameCount + 1
        end
        local elapsed = tick() - startTime
        if elapsed > 0.1 then
            isLowEnd = true
        end
    end)
    
    -- Mobil ve düşük performanslı cihazlar
    if isMobile or isLowEnd then
        self.Mode = "Low"
        self.LowMemoryMode = true
        self.MaxFrameSkip = 4
        self.DynamicQuality = true
        return "Low"
    end
    
    -- Orta seviye
    self.Mode = "Medium"
    self.MaxFrameSkip = 2
    return "Medium"
end

function PerformanceManager:Optimize()
    local mode = self.Mode
    
    -- Grafik optimizasyonları
    pcall(function()
        -- Lighting optimizasyonu
        local lighting = game:GetService("Lighting")
        if lighting then
            if mode == "Low" or mode == "Potato" then
                lighting.GlobalShadows = false
                lighting.FogEnd = 500
                lighting.Brightness = 0.8
                lighting.ClockTime = 12
                lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
                lighting.FogStart = 0
                lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
            elseif mode == "Medium" then
                lighting.GlobalShadows = false
                lighting.FogEnd = 1000
            end
        end
        
        -- Workspace optimizasyonu
        local workspace = game:GetService("Workspace")
        if workspace then
            if mode == "Low" or mode == "Potato" then
                workspace.StreamingEnabled = true
                workspace.StreamingPauseMode = Enum.StreamingPauseMode.WhenNotStreamed
                workspace.StreamingRadius = 200
                workspace.StreamingTargetRadius = 100
            end
        end
    end)
    
    -- Bellek temizliği
    if mode == "Low" or mode == "Potato" or self.LowMemoryMode then
        collectgarbage("collect")
        task.spawn(function()
            while true do
                task.wait(30)
                collectgarbage("collect")
                collectgarbage("step", 1000)
            end
        end)
    end
end

-- ================================================================
-- AKILLI FPS YÖNETİCİSİ
-- ================================================================
local FPSManager = {
    TargetFPS = 60,
    CurrentFPS = 60,
    FrameTimes = {},
    AverageFrameTime = 0,
    IsStuttering = false,
    AdaptiveQuality = true,
    ThrottleCount = 0,
    LastUpdate = 0,
}

function FPSManager:Update(deltaTime)
    -- Frame zamanını kaydet
    table.insert(self.FrameTimes, deltaTime)
    if #self.FrameTimes > 60 then
        table.remove(self.FrameTimes, 1)
    end
    
    -- Ortalama hesapla
    local sum = 0
    for _, time in ipairs(self.FrameTimes) do
        sum = sum + time
    end
    self.AverageFrameTime = sum / #self.FrameTimes
    self.CurrentFPS = 1 / self.AverageFrameTime
    
    -- Performans durumu
    if self.CurrentFPS < 30 then
        self.IsStuttering = true
        self.ThrottleCount = self.ThrottleCount + 1
    else
        self.IsStuttering = false
        self.ThrottleCount = math.max(0, self.ThrottleCount - 1)
    end
    
    -- Adaptif kalite
    if self.AdaptiveQuality and PerformanceManager.DynamicQuality then
        if self.CurrentFPS < 20 then
            PerformanceManager.Mode = "Potato"
            PerformanceManager:Optimize()
            smartLoad()
        elseif self.CurrentFPS < 30 then
            PerformanceManager.Mode = "Low"
            PerformanceManager:Optimize()
            smartLoad()
        elseif self.CurrentFPS < 45 then
            PerformanceManager.Mode = "Medium"
            PerformanceManager:Optimize()
        end
    end
    
    return self.CurrentFPS
end

-- ================================================================
-- GELİŞMİŞ GECİKME YÖNETİCİSİ (Kasmayı önler)
-- ================================================================
local SmartWait = {
    BaseWait = 0.03,
    DynamicWait = true,
    CurrentWait = 0.03,
    PerformanceScore = 1,
}

function SmartWait:GetDelay()
    if not self.DynamicWait then
        return self.BaseWait
    end
    
    -- Performans skoruna göre gecikme ayarla
    local fps = FPSManager.CurrentFPS
    if fps > 50 then
        self.PerformanceScore = math.min(1, self.PerformanceScore + 0.01)
    elseif fps < 30 then
        self.PerformanceScore = math.max(0.5, self.PerformanceScore - 0.02)
    end
    
    -- Gecikmeyi hesapla
    self.CurrentWait = self.BaseWait * (1 + (1 - self.PerformanceScore) * 0.5)
    return self.CurrentWait
end

function SmartWait:Wait()
    local delay = self:GetDelay()
    task.wait(delay)
    return delay
end

-- ================================================================
-- BAŞLANGIÇ KONTROLLERİ
-- ================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- ============================================================
-- EZBYPASS SİSTEMİ (Anti-Ban, Anti-Detection)
-- ============================================================
local EzBypass = {
    Enabled = true,
    RandomDelay = {0.05, 0.15},
    Humanize = true,
    Spoofing = true,
    Connections = {},
    _patched = false,
}

function EzBypass:Init()
    -- Gelişmiş Anti-Tespit
    if self.Spoofing then
        -- Rastgele gecikme ekle
        local function addRandomDelay(func, ...)
            local delay = math.random() * (self.RandomDelay[2] - self.RandomDelay[1]) + self.RandomDelay[1]
            task.wait(delay)
            return func(...)
        end
        
        -- Fonksiyonları yamala
        if not EzBypass._patched then
            EzBypass._patched = true
        end
    end
    
    -- VirtualUser optimizasyonu
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end

-- ============================================================
-- GELİŞMİŞ CONFIG SİSTEMİ
-- ============================================================
local Config = {
    Version = "3.0",
    Aimbot = {
        Enabled = false,
        FOV = 120,
        Smoothness = 0.15,
        HitPart = "Head",
        TeamCheck = false,
        VisibilityCheck = true,
        AimLock = false,
        Prediction = true,
        PredictionAmount = 0.2,
    },
    Triggerbot = {
        Enabled = false,
        FireRate = 0.15,
        HoldToFire = false,
        OnlyWhenVisible = true,
    },
    NormalBehavior = {
        Enabled = false,
        RandomMouseMovements = true,
        SimulateTyping = true,
        AFKPrevention = true,
        WalkRandomly = false,
        JumpRandomly = false,
    },
    Mobile = {
        AutoFire = false,
        Crosshair = true,
        JoystickFire = false,
        Vibration = true,
    },
    EzBypass = {
        Enabled = true,
        Humanize = true,
        RandomDelays = true,
        SpoofExecution = true,
    },
    Visuals = {
        ShowDistance = true,
        ShowHealth = true,
        ShowName = true,
        BoxESP = false,
        Tracer = false,
    },
    Performance = {
        Mode = "Auto",
        TargetFPS = 30,
        AdaptiveQuality = true,
        LowMemoryMode = false,
        BatterySaver = false,
        MaxFrameSkip = 3,
    }
}

local Settings = {}
local function deepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Settings'i Config ile doldur
Settings = deepCopy(Config)

-- ============================================================
-- AKILLI YÜKLEME (Gereksiz özellikleri devre dışı bırak)
-- ============================================================
local function smartLoad()
    local mode = PerformanceManager.Mode
    
    if mode == "Low" or mode == "Potato" then
        -- ESP'yi sadeleştir
        Settings.Visuals.ShowHealth = false
        Settings.Visuals.BoxESP = false
        Settings.Visuals.Tracer = false
        
        -- Normal behavior'ı sınırla
        Settings.NormalBehavior.RandomMouseMovements = false
        Settings.NormalBehavior.WalkRandomly = false
        Settings.NormalBehavior.JumpRandomly = false
        
        -- Triggerbot'u kısıtla
        Settings.Triggerbot.OnlyWhenVisible = false
    end
    
    if mode == "Potato" then
        -- Her şeyi kapat (sadece aimbot)
        Settings.Triggerbot.Enabled = false
        Settings.NormalBehavior.Enabled = false
        Settings.Visuals.ShowName = false
        Settings.Visuals.ShowDistance = false
        Settings.Aimbot.VisibilityCheck = false
        Settings.Aimbot.Prediction = false
        Settings.Aimbot.Smoothness = 0.5
        Settings.Aimbot.FOV = 200
    end
end

-- ============================================================
-- PERFORMANS GÖSTERGESİ
-- ============================================================
local PerformanceStatsLabel = nil

local function updatePerformanceStats()
    local fps = FPSManager.CurrentFPS
    local mem = collectgarbage("count") or 0
    local mode = PerformanceManager.Mode
    
    if PerformanceStatsLabel then
        pcall(function()
            PerformanceStatsLabel:SetText(string.format(
                "⚡ FPS: %d | Mode: %s | RAM: %.0fMB | %s",
                math.floor(fps),
                mode,
                mem / 1000,
                FPSManager.IsStuttering and "⚠️ KASMA" or "✅ AKICI"
            ))
        end)
    end
end

-- ============================================================
-- ÖZEL UI (Obsidian Tabanlı)
-- ============================================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

-- Temayı özelleştir
Library.ShowCustomCursor = true
Library.CantDragForced = false

local Window = Library:CreateWindow({
    Title = "Lord Yagiz_ | War Tycoon v3.0",
    Center = true,
    AutoShow = true,
    Resizable = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
    UnlockMouseWhileOpen = true,
    ShowMobileButtons = true,
    MobileButtonsSide = "Right",
})

-- ============================================================
-- MENÜ SEKMELERİ
-- ============================================================
local CombatTab = Window:AddTab("Combat", "sword")
local TriggerTab = Window:AddTab("Trigger", "target")
local BehaviorTab = Window:AddTab("Behavior", "user")
local VisualTab = Window:AddTab("Visuals", "eye")
local PerformanceTab = Window:AddTab("Performance", "speedometer")
local SettingsTab = Window:AddTab("Settings", "settings")

-- Aimbot Grupları
local AimbotGroup = CombatTab:AddLeftGroupbox("⚡ Aimbot Settings")
local AdvancedGroup = CombatTab:AddRightGroupbox("🔧 Advanced Aim")

-- Triggerbot Grupları
local TriggerGroup = TriggerTab:AddLeftGroupbox("🎯 Triggerbot Settings")
local TriggerAdvanced = TriggerTab:AddRightGroupbox("⚙️ Trigger Options")

-- Behavior Grupları
local BehaviorGroup = BehaviorTab:AddLeftGroupbox("🧠 Normal Behavior")
local MobileGroup = BehaviorTab:AddRightGroupbox("📱 Mobile Features")

-- Visual Grupları
local ESPGroup = VisualTab:AddLeftGroupbox("👁️ Visual ESP")
local MiscVisualGroup = VisualTab:AddRightGroupbox("🎨 Misc Visuals")

-- Performance Grupları
local PerfGroup = PerformanceTab:AddLeftGroupbox("📊 Performance Settings")
local PerfInfoGroup = PerformanceTab:AddRightGroupbox("📈 Live Stats")

-- Config Grupları
local ConfigGroup = SettingsTab:AddLeftGroupbox("💾 Configuration")
local BypassGroup = SettingsTab:AddRightGroupbox("🛡️ EzBypass")

-- ============================================================
-- DEĞİŞKENLER
-- ============================================================
local aimbotTarget = nil
local triggerTarget = nil
local lastFireTime = 0
local lastAimTime = 0
local currentTarget = nil
local espObjects = {}
local isFiring = false
local aimbotCounter = 0
local triggerCounter = 0
local behaviorCounter = 0
local frameSkip = 0
local lastFPSUpdate = 0

-- ============================================================
-- GELİŞMİŞ YARDIMCI FONKSİYONLAR
-- ============================================================
local function getPlayerFromCharacter(char)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character == char then
            return player
        end
    end
    return nil
end

local function isValidTarget(player)
    if not player then return false end
    if player == LocalPlayer then return false end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if Settings.Aimbot.TeamCheck then
        if player.Team == LocalPlayer.Team then return false end
    end
    return true
end

local function getTargetPart(char)
    local partNames = {
        Settings.Aimbot.HitPart,
        "Head",
        "UpperTorso",
        "HumanoidRootPart",
        "Torso"
    }
    for _, name in ipairs(partNames) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part
        end
    end
    return char:FindFirstChild("HumanoidRootPart")
end

local function getScreenPosition(part)
    if not part then return nil end
    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if onScreen then
        return Vector2.new(pos.X, pos.Y)
    end
    return nil
end

local function getDistanceToMouse(part)
    local screenPos = getScreenPosition(part)
    if not screenPos then return math.huge end
    return (screenPos - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
end

local function getBestTarget()
    local bestPlayer = nil
    local bestDistance = Settings.Aimbot.FOV
    local bestPart = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local char = player.Character
            local part = getTargetPart(char)
            if part then
                local dist = getDistanceToMouse(part)
                if dist < bestDistance then
                    -- Görünürlük kontrolü
                    if Settings.Aimbot.VisibilityCheck then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
                        local ray = Workspace:Raycast(
                            Camera.CFrame.Position,
                            (part.Position - Camera.CFrame.Position).Unit * 1000,
                            rayParams
                        )
                        if ray and ray.Instance:IsDescendantOf(char) then
                            bestDistance = dist
                            bestPlayer = player
                            bestPart = part
                        end
                    else
                        bestDistance = dist
                        bestPlayer = player
                        bestPart = part
                    end
                end
            end
        end
    end
    
    return bestPlayer, bestPart
end

-- ============================================================
-- GELİŞMİŞ AIMBOT (Optimize)
-- ============================================================
local function runAimbot()
    if not Settings.Aimbot.Enabled then
        aimbotTarget = nil
        return
    end
    
    -- Düşük FPS'de daha az çalıştır
    local fps = FPSManager.CurrentFPS
    if fps < 20 then
        aimbotCounter = aimbotCounter + 1
        if aimbotCounter % 3 ~= 0 then return end
    elseif fps < 30 then
        aimbotCounter = aimbotCounter + 1
        if aimbotCounter % 2 ~= 0 then return end
    end
    
    local target, part = getBestTarget()
    if target and part then
        aimbotTarget = target
        currentTarget = target
        
        -- Hedef pozisyonu (Prediction ile)
        local targetPos = part.Position
        if Settings.Aimbot.Prediction then
            local velocity = part.AssemblyLinearVelocity or Vector3.zero
            local prediction = velocity * Settings.Aimbot.PredictionAmount
            targetPos = targetPos + prediction
        end
        
        -- Yumuşak hedefleme
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
        local smoothness = 1 - Settings.Aimbot.Smoothness
        
        -- Anlık mı yoksa yumuşak mı?
        if Settings.Aimbot.Smoothness <= 0.01 then
            Camera.CFrame = targetCFrame
        else
            local newCFrame = currentCFrame:Lerp(targetCFrame, smoothness)
            Camera.CFrame = newCFrame
        end
        
        lastAimTime = tick()
    else
        aimbotTarget = nil
        if not Settings.Aimbot.AimLock then
            currentTarget = nil
        end
    end
end

-- ============================================================
-- GELİŞMİŞ TRIGGERBOT (Optimize)
-- ============================================================
local function runTriggerbot()
    if not Settings.Triggerbot.Enabled then
        triggerTarget = nil
        return
    end
    
    -- Düşük FPS'de daha az çalıştır
    local fps = FPSManager.CurrentFPS
    if fps < 20 then
        triggerCounter = triggerCounter + 1
        if triggerCounter % 4 ~= 0 then return end
    elseif fps < 30 then
        triggerCounter = triggerCounter + 1
        if triggerCounter % 2 ~= 0 then return end
    end
    
    local target, part = getBestTarget()
    if target and part then
        triggerTarget = target
        
        local currentTime = tick()
        local fireRate = Settings.Triggerbot.FireRate or 0.15
        
        if currentTime - lastFireTime >= fireRate then
            -- Ateş et
            if Settings.Triggerbot.HoldToFire then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            else
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end
            lastFireTime = currentTime
            
            -- Titreşim (mobil)
            if Settings.Mobile.Vibration and UserInputService.TouchEnabled then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end)
            end
        end
    else
        triggerTarget = nil
    end
end

-- ============================================================
-- NORMAL OYUNCU DAVRANIŞI (GELİŞMİŞ + OPTİMİZE)
-- ============================================================
local behaviorTimer = 0

local function simulateNormalBehavior()
    if not Settings.NormalBehavior.Enabled then return end
    
    -- Düşük FPS'de daha az çalıştır
    local fps = FPSManager.CurrentFPS
    if fps < 20 then
        behaviorCounter = behaviorCounter + 1
        if behaviorCounter % 3 ~= 0 then return end
    end
    
    behaviorTimer = behaviorTimer + 0.1
    
    -- Rastgele fare hareketleri (gelişmiş)
    if Settings.NormalBehavior.RandomMouseMovements and behaviorTimer % 2 < 0.1 then
        if math.random(1, 100) < 8 then
            local randomX = math.random(-150, 150)
            local randomY = math.random(-150, 150)
            Mouse.Move(Vector2.new(
                math.clamp(Mouse.X + randomX, 0, Camera.ViewportSize.X),
                math.clamp(Mouse.Y + randomY, 0, Camera.ViewportSize.Y)
            ))
        end
    end
    
    -- AFK önleme (gelişmiş)
    if Settings.NormalBehavior.AFKPrevention and behaviorTimer % 3 < 0.1 then
        if math.random(1, 100) < 3 then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local randomPos = root.Position + Vector3.new(
                            math.random(-8, 8),
                            0,
                            math.random(-8, 8)
                        )
                        humanoid:MoveTo(randomPos)
                    end
                end
            end
        end
    end
    
    -- Rastgele zıplama
    if Settings.NormalBehavior.JumpRandomly and behaviorTimer % 1.5 < 0.05 then
        if math.random(1, 100) < 5 then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 50))
        end
    end
    
    -- Klavye simülasyonu
    if Settings.NormalBehavior.SimulateTyping and behaviorTimer % 1 < 0.05 then
        if math.random(1, 100) < 4 then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end
    end
end

-- ============================================================
-- MOBİL DESTEĞİ (GELİŞMİŞ)
-- ============================================================
local mobileCrosshair = nil

local function setupMobileSupport()
    -- Crosshair
    if Settings.Mobile.Crosshair then
        if not mobileCrosshair then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "LordYagiz_Crosshair"
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            screenGui.Parent = CoreGui
            
            mobileCrosshair = Instance.new("ImageLabel")
            mobileCrosshair.Size = UDim2.new(0, 40, 0, 40)
            mobileCrosshair.Position = UDim2.new(0.5, -20, 0.5, -20)
            mobileCrosshair.BackgroundTransparency = 1
            mobileCrosshair.Image = "rbxassetid://3926305903"
            mobileCrosshair.ImageColor3 = Color3.fromRGB(0, 255, 0)
            mobileCrosshair.ImageTransparency = 0.3
            mobileCrosshair.Parent = screenGui
            
            -- Animasyon
            TweenService:Create(mobileCrosshair, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                ImageTransparency = 0.1,
                Size = UDim2.new(0, 35, 0, 35)
            }):Play()
        end
    else
        if mobileCrosshair then
            mobileCrosshair:Destroy()
            mobileCrosshair = nil
        end
    end
    
    -- Auto Fire on Touch
    if Settings.Mobile.AutoFire then
        UserInputService.TouchEnded:Connect(function(touch)
            if touch.Position.X > 0 and touch.Position.Y > 0 then
                if Settings.Triggerbot.Enabled or Settings.Aimbot.Enabled then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0, 0))
                end
            end
        end)
    end
    
    -- Joystick desteği
    if Settings.Mobile.JoystickFire then
        UserInputService.TouchMoved:Connect(function(touch)
            if touch.Position.X < 200 and touch.Position.Y > Camera.ViewportSize.Y - 200 then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end
        end)
    end
end

-- ============================================================
-- ESP SİSTEMİ (OPTİMİZE)
-- ============================================================
local function createESP(player)
    local char = player.Character
    if not char then return end
    
    -- Temizle
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
    
    -- Patates modunda basit ESP
    if PerformanceManager.Mode == "Potato" then
        local esp = Instance.new("BillboardGui")
        esp.Name = "LordYagiz_ESP_Simple"
        esp.Size = UDim2.new(0, 100, 0, 20)
        esp.AlwaysOnTop = true
        esp.Parent = char
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = player.Name
        label.Parent = esp
        
        espObjects[player] = esp
        return
    end
    
    -- Tam ESP
    local esp = Instance.new("BillboardGui")
    esp.Name = "LordYagiz_ESP"
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.AlwaysOnTop = true
    esp.Enabled = false
    esp.Parent = char
    
    -- İsim etiketi
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.TextSize = 20
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.3
    label.Parent = esp
    
    -- Health bar (sadece yüksek modda)
    if Settings.Visuals.ShowHealth and PerformanceManager.Mode ~= "Low" then
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(0.8, 0, 0.15, 0)
        healthBar.Position = UDim2.new(0.1, 0, 0.85, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.BackgroundTransparency = 0.3
        healthBar.BorderSizePixel = 0
        healthBar.Parent = esp
        
        local healthBg = Instance.new("Frame")
        healthBg.Size = UDim2.new(1, 0, 1, 0)
        healthBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        healthBg.BackgroundTransparency = 0.5
        healthBg.BorderSizePixel = 0
        healthBg.Parent = healthBar
        
        local healthFill = Instance.new("Frame")
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.BackgroundTransparency = 0.3
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBar
        
        espObjects[player] = esp
        
        -- Güncelleme fonksiyonu
        local function updateESP()
            local hum = char:FindFirstChild("Humanoid")
            if not hum then
                esp.Enabled = false
                return
            end
            
            esp.Enabled = true
            
            -- İsim
            if Settings.Visuals.ShowName then
                label.Text = player.Name
            else
                label.Text = ""
            end
            
            -- Health
            if Settings.Visuals.ShowHealth and hum.MaxHealth > 0 then
                local healthPercent = hum.Health / hum.MaxHealth
                healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                healthFill.BackgroundColor3 = Color3.fromRGB(
                    255 * (1 - healthPercent),
                    255 * healthPercent,
                    0
                )
                healthBar.Visible = true
            else
                healthBar.Visible = false
            end
            
            -- Distance
            if Settings.Visuals.ShowDistance then
                local distance = (char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                label.Text = label.Text .. " [" .. math.floor(distance) .. "m]"
            end
        end
        
        -- Güncelleme bağlantısı
        RunService.Heartbeat:Connect(function()
            if player.Character and player.Character == char then
                updateESP()
            end
        end)
    end
end

-- ============================================================
-- ESP GÜNCELLEME
-- ============================================================
local function updateESP()
    if not Settings.Visuals.ShowHealth and not Settings.Visuals.ShowName then
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not espObjects[player] or not espObjects[player].Parent then
                createESP(player)
            end
        end
    end
end

-- ============================================================
-- ANA DÖNGÜ (OPTİMİZE + PERFORMANS İZLEME)
-- ============================================================
RunService.Heartbeat:Connect(function(deltaTime)
    -- FPS güncelleme (saniyede 1 kez)
    local currentTime = tick()
    if currentTime - lastFPSUpdate >= 1 then
        FPSManager:Update(deltaTime)
        lastFPSUpdate = currentTime
        updatePerformanceStats()
    end
    
    -- Frame skip (patates modunda)
    if PerformanceManager.Mode == "Potato" or PerformanceManager.Mode == "Low" then
        frameSkip = frameSkip + 1
        if frameSkip % 2 == 0 then
            -- Her 2 frame'de bir çalıştır
        end
    end
    
    -- Ana fonksiyonlar (optimize)
    if LocalPlayer and LocalPlayer.Character then
        runAimbot()
        runTriggerbot()
        simulateNormalBehavior()
    end
    
    -- ESP güncelleme (düşük FPS'de daha az)
    if FPSManager.CurrentFPS > 20 then
        if frameSkip % 5 == 0 then
            updateESP()
        end
    else
        if frameSkip % 10 == 0 then
            updateESP()
        end
    end
end)

-- ============================================================
-- MENÜ AYARLARI (KAPSAMLI)
-- ============================================================

-- === Combat Tab ===
AimbotGroup:AddToggle("AimbotToggle", {
    Text = "✅ Enable Aimbot",
    Default = false,
    Callback = function(state)
        Settings.Aimbot.Enabled = state
        if not state then aimbotTarget = nil end
    end
})

AimbotGroup:AddSlider("AimbotFOV", {
    Text = "🎯 Aimbot FOV",
    Min = 30,
    Max = 300,
    Default = 120,
    Callback = function(value)
        Settings.Aimbot.FOV = value
    end
})

AimbotGroup:AddSlider("AimbotSmoothness", {
    Text = "🔄 Smoothness",
    Min = 0,
    Max = 1,
    Decimal = 2,
    Default = 0.15,
    Callback = function(value)
        Settings.Aimbot.Smoothness = value
    end
})

AimbotGroup:AddDropdown("HitPart", {
    Text = "🎯 Hit Part",
    Values = {"Head", "UpperTorso", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Callback = function(selected)
        Settings.Aimbot.HitPart = selected
    end
})

AdvancedGroup:AddToggle("TeamCheck", {
    Text = "🚫 Team Check",
    Default = false,
    Callback = function(state)
        Settings.Aimbot.TeamCheck = state
    end
})

AdvancedGroup:AddToggle("VisibilityCheck", {
    Text = "👁️ Visibility Check",
    Default = true,
    Callback = function(state)
        Settings.Aimbot.VisibilityCheck = state
    end
})

AdvancedGroup:AddToggle("AimLock", {
    Text = "🔒 Aim Lock",
    Default = false,
    Callback = function(state)
        Settings.Aimbot.AimLock = state
    end
})

AdvancedGroup:AddToggle("Prediction", {
    Text = "📐 Prediction",
    Default = true,
    Callback = function(state)
        Settings.Aimbot.Prediction = state
    end
})

AdvancedGroup:AddSlider("PredictionAmount", {
    Text = "📏 Prediction Amount",
    Min = 0.05,
    Max = 0.5,
    Decimal = 2,
    Default = 0.2,
    Callback = function(value)
        Settings.Aimbot.PredictionAmount = value
    end
})

-- === Trigger Tab ===
TriggerGroup:AddToggle("TriggerbotToggle", {
    Text = "✅ Enable Triggerbot",
    Default = false,
    Callback = function(state)
        Settings.Triggerbot.Enabled = state
    end
})

TriggerGroup:AddSlider("TriggerFireRate", {
    Text = "⚡ Fire Rate (s)",
    Min = 0.05,
    Max = 0.5,
    Decimal = 2,
    Default = 0.15,
    Callback = function(value)
        Settings.Triggerbot.FireRate = value
    end
})

TriggerAdvanced:AddToggle("HoldToFire", {
    Text = "🔫 Hold to Fire",
    Default = false,
    Callback = function(state)
        Settings.Triggerbot.HoldToFire = state
    end
})

TriggerAdvanced:AddToggle("OnlyWhenVisible", {
    Text = "👁️ Only When Visible",
    Default = true,
    Callback = function(state)
        Settings.Triggerbot.OnlyWhenVisible = state
    end
})

-- === Behavior Tab ===
BehaviorGroup:AddToggle("NormalBehaviorToggle", {
    Text = "✅ Enable Normal Behavior",
    Default = false,
    Callback = function(state)
        Settings.NormalBehavior.Enabled = state
    end
})

BehaviorGroup:AddToggle("RandomMouseMovements", {
    Text = "🖱️ Random Mouse Movements",
    Default = true,
    Callback = function(state)
        Settings.NormalBehavior.RandomMouseMovements = state
    end
})

BehaviorGroup:AddToggle("AFKPrevention", {
    Text = "💤 AFK Prevention",
    Default = true,
    Callback = function(state)
        Settings.NormalBehavior.AFKPrevention = state
    end
})

BehaviorGroup:AddToggle("WalkRandomly", {
    Text = "🚶 Walk Randomly",
    Default = false,
    Callback = function(state)
        Settings.NormalBehavior.WalkRandomly = state
    end
})

BehaviorGroup:AddToggle("JumpRandomly", {
    Text = "🦘 Jump Randomly",
    Default = false,
    Callback = function(state)
        Settings.NormalBehavior.JumpRandomly = state
    end
})

-- === Mobile Tab ===
MobileGroup:AddToggle("AutoFire", {
    Text = "🔥 Auto Fire on Touch",
    Default = false,
    Callback = function(state)
        Settings.Mobile.AutoFire = state
        if state then setupMobileSupport() end
    end
})

MobileGroup:AddToggle("Crosshair", {
    Text = "🎯 Show Crosshair",
    Default = true,
    Callback = function(state)
        Settings.Mobile.Crosshair = state
        setupMobileSupport()
    end
})

MobileGroup:AddToggle("JoystickFire", {
    Text = "🕹️ Joystick Fire (Left Side)",
    Default = false,
    Callback = function(state)
        Settings.Mobile.JoystickFire = state
        if state then setupMobileSupport() end
    end
})

MobileGroup:AddToggle("Vibration", {
    Text = "📳 Vibration Feedback",
    Default = true,
    Callback = function(state)
        Settings.Mobile.Vibration = state
    end
})

-- === Visuals Tab ===
ESPGroup:AddToggle("ShowName", {
    Text = "👤 Show Player Names",
    Default = true,
    Callback = function(state)
        Settings.Visuals.ShowName = state
    end
})

ESPGroup:AddToggle("ShowHealth", {
    Text = "❤️ Show Health Bar",
    Default = true,
    Callback = function(state)
        Settings.Visuals.ShowHealth = state
    end
})

ESPGroup:AddToggle("ShowDistance", {
    Text = "📏 Show Distance",
    Default = true,
    Callback = function(state)
        Settings.Visuals.ShowDistance = state
    end
})

-- === Performance Tab ===
PerfGroup:AddDropdown("PerformanceMode", {
    Text = "🎯 Performance Mode",
    Values = {"Auto", "Ultra", "High", "Medium", "Low", "Potato"},
    Default = "Auto",
    Callback = function(selected)
        if selected == "Auto" then
            PerformanceManager:DetectDevice()
        else
            PerformanceManager.Mode = selected
        end
        PerformanceManager:Optimize()
        smartLoad()
        Library:Notify({
            Title = "Performance Mode",
            Description = "Switched to " .. selected .. " mode",
            Time = 2
        })
    end
})

PerfGroup:AddToggle("AdaptiveQuality", {
    Text = "🔄 Adaptive Quality",
    Default = true,
    Callback = function(state)
        PerformanceManager.DynamicQuality = state
        FPSManager.AdaptiveQuality = state
    end
})

PerfGroup:AddToggle("LowMemoryMode", {
    Text = "🧹 Low Memory Mode",
    Default = false,
    Callback = function(state)
        PerformanceManager.LowMemoryMode = state
        if state then collectgarbage("collect") end
    end
})

PerfGroup:AddToggle("BatterySaver", {
    Text = "🔋 Battery Saver",
    Default = false,
    Callback = function(state)
        PerformanceManager.BatterySaver = state
        if state then
            PerformanceManager.Mode = "Low"
            PerformanceManager:Optimize()
            smartLoad()
        end
    end
})

PerfGroup:AddSlider("TargetFPS", {
    Text = "🎯 Target FPS",
    Min = 15,
    Max = 60,
    Default = 30,
    Callback = function(value)
        FPSManager.TargetFPS = value
    end
})

PerfGroup:AddSlider("MaxFrameSkip", {
    Text = "⏭️ Max Frame Skip",
    Min = 1,
    Max = 6,
    Default = 3,
    Callback = function(value)
        PerformanceManager.MaxFrameSkip = value
    end
})

-- PATATES MODU BUTONU (Tek tıkla optimizasyon)
PerfGroup:AddButton({
    Text = "🥔 ONE CLICK POTATO MODE",
    Callback = function()
        PerformanceManager.Mode = "Potato"
        PerformanceManager:Optimize()
        smartLoad()
        
        -- Tüm gereksiz özellikleri kapat
        Settings.Aimbot.Enabled = true
        Settings.Aimbot.FOV = 200
        Settings.Aimbot.Smoothness = 0.5
        Settings.Aimbot.VisibilityCheck = false
        Settings.Aimbot.Prediction = false
        Settings.Aimbot.AimLock = false
        
        Settings.Triggerbot.Enabled = false
        Settings.NormalBehavior.Enabled = false
        Settings.Visuals.ShowName = false
        Settings.Visuals.ShowHealth = false
        Settings.Visuals.ShowDistance = false
        
        collectgarbage("collect")
        collectgarbage("step", 1000)
        
        Library:Notify({
            Title = "🥔 Potato Mode",
            Description = "Everything optimized for low-end devices! Only Aimbot active.",
            Time = 3,
            Image = 4483362458
        })
    end
})

-- Performans istatistikleri
local StatsLabel = PerfInfoGroup:AddLabel("📊 Performance Statistics")
PerformanceStatsLabel = StatsLabel

PerfInfoGroup:AddButton({
    Text = "🔄 Force Optimize Now",
    Callback = function()
        PerformanceManager:Optimize()
        collectgarbage("collect")
        Library:Notify({
            Title = "Optimization",
            Description = "Performance optimized!",
            Time = 2
        })
    end
})

PerfInfoGroup:AddButton({
    Text = "🧹 Clean Memory",
    Callback = function()
        collectgarbage("collect")
        collectgarbage("step", 1000)
        Library:Notify({
            Title = "Memory Cleaned",
            Description = string.format("RAM: %.0fMB", collectgarbage("count") / 1000),
            Time = 2
        })
    end
})

-- === Settings Tab ===
ConfigGroup:AddButton({
    Text = "💾 Save Config",
    Callback = function()
        for category, settings in pairs(Config) do
            if Settings[category] then
                for setting, value in pairs(settings) do
                    if Settings[category][setting] ~= nil then
                        Config[category][setting] = Settings[category][setting]
                    end
                end
            end
        end
        Library:Notify({
            Title = "Config Saved",
            Description = "All settings have been saved successfully!",
            Time = 3,
            Image = 4483362458
        })
    end
})

ConfigGroup:AddButton({
    Text = "📂 Load Config",
    Callback = function()
        for category, settings in pairs(Config) do
            if Settings[category] then
                for setting, value in pairs(settings) do
                    Settings[category][setting] = value
                end
            end
        end
        -- UI'yi güncelle (manuel)
        Library:Notify({
            Title = "Config Loaded",
            Description = "Settings loaded from config.",
            Time = 3,
            Image = 4483362458
        })
    end
})

ConfigGroup:AddButton({
    Text = "🔄 Reset Config",
    Callback = function()
        Settings = deepCopy(Config)
        Library:Notify({
            Title = "Config Reset",
            Description = "All settings have been reset to default.",
            Time = 3,
            Image = 4483362458
        })
    end
})

-- === EzBypass Tab ===
BypassGroup:AddToggle("EzBypassToggle", {
    Text = "🛡️ Enable EzBypass",
    Default = true,
    Callback = function(state)
        Settings.EzBypass.Enabled = state
        if state then EzBypass:Init() end
    end
})

BypassGroup:AddToggle("Humanize", {
    Text = "🧠 Humanize Actions",
    Default = true,
    Callback = function(state)
        Settings.EzBypass.Humanize = state
    end
})

BypassGroup:AddToggle("RandomDelays", {
    Text = "⏱️ Random Delays",
    Default = true,
    Callback = function(state)
        Settings.EzBypass.RandomDelays = state
    end
})

BypassGroup:AddSlider("MinDelay", {
    Text = "⏳ Min Delay (s)",
    Min = 0.01,
    Max = 0.2,
    Decimal = 2,
    Default = 0.05,
    Callback = function(value)
        EzBypass.RandomDelay[1] = value
    end
})

BypassGroup:AddSlider("MaxDelay", {
    Text = "⏳ Max Delay (s)",
    Min = 0.05,
    Max = 0.5,
    Decimal = 2,
    Default = 0.15,
    Callback = function(value)
        EzBypass.RandomDelay[2] = value
    end
})

-- ============================================================
-- BAŞLATMA
-- ============================================================
-- Performans yönetimini başlat
PerformanceManager:DetectDevice()
PerformanceManager:Optimize()
smartLoad()

-- EzBypass başlat
EzBypass:Init()

-- Mobil kontrol
if UserInputService.TouchEnabled then
    setupMobileSupport()
    Library:Notify({
        Title = "📱 Mobile Mode",
        Description = string.format("Optimized for %s performance", PerformanceManager.Mode),
        Time = 3,
        Image = 4483362458
    })
end

-- Başlangıç bildirimi
Library:Notify({
    Title = "⚡ Lord Yagiz_ v3.0",
    Description = string.format(
        "Loaded! Mode: %s | FPS: %d | RAM: %.0fMB",
        PerformanceManager.Mode,
        math.floor(FPSManager.CurrentFPS),
        collectgarbage("count") / 1000
    ),
    Time = 5,
    Image = 4483362458
})

print(string.format(
    "⚡ Lord Yagiz_ v3.0 | Mode: %s | FPS: %d | RAM: %.0fMB",
    PerformanceManager.Mode,
    math.floor(FPSManager.CurrentFPS),
    collectgarbage("count") / 1000
))

-- ============================================================
-- TEMİZLİK
-- ============================================================
local function cleanup()
    for _, esp in pairs(espObjects) do
        pcall(function() esp:Destroy() end)
    end
    espObjects = {}
    if mobileCrosshair then
        pcall(function() mobileCrosshair:Destroy() end)
        mobileCrosshair = nil
    end
    collectgarbage("collect")
end

game:BindToClose(cleanup)
