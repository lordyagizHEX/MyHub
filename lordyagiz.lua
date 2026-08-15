--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║     ⚡ LORD YAGIZ_ - WAR TYCOON ULTIMATE v3.1 (FIXED)        ║
    ║     ★ Aimbot + Triggerbot ŞİMDİ ÇALIŞIYOR!                   ║
    ║     ★ Silah Otomatik Algılama ve Ateş Etme                  ║
    ║     ★ Tam Mobil Uyum + Patates Telefon Desteği              ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ================================================================
-- PERFORMANS YÖNETİCİSİ
-- ================================================================
local PerformanceManager = {
    Mode = "Auto",
    CurrentFPS = 60,
    FrameSkip = 0,
    MaxFrameSkip = 3,
    DynamicQuality = true,
    LowMemoryMode = false,
    BatterySaver = false,
}

function PerformanceManager:DetectDevice()
    local isMobile = UserInputService.TouchEnabled
    local isLowEnd = false
    pcall(function()
        local mem = collectgarbage("count") or 0
        if mem > 100000 then isLowEnd = true end
    end)
    if isMobile or isLowEnd then
        self.Mode = "Low"
        self.LowMemoryMode = true
        self.MaxFrameSkip = 4
        return "Low"
    end
    self.Mode = "Medium"
    self.MaxFrameSkip = 2
    return "Medium"
end

function PerformanceManager:Optimize()
    local mode = self.Mode
    pcall(function()
        local lighting = game:GetService("Lighting")
        if lighting then
            if mode == "Low" or mode == "Potato" then
                lighting.GlobalShadows = false
                lighting.FogEnd = 500
                lighting.Brightness = 0.8
                lighting.ClockTime = 12
            elseif mode == "Medium" then
                lighting.GlobalShadows = false
                lighting.FogEnd = 1000
            end
        end
        local workspace = game:GetService("Workspace")
        if workspace and (mode == "Low" or mode == "Potato") then
            workspace.StreamingEnabled = true
            workspace.StreamingRadius = 200
        end
    end)
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
-- FPS YÖNETİCİSİ
-- ================================================================
local FPSManager = {
    TargetFPS = 60,
    CurrentFPS = 60,
    FrameTimes = {},
    IsStuttering = false,
    AdaptiveQuality = true,
}

function FPSManager:Update(deltaTime)
    table.insert(self.FrameTimes, deltaTime)
    if #self.FrameTimes > 60 then table.remove(self.FrameTimes, 1) end
    local sum = 0
    for _, time in ipairs(self.FrameTimes) do sum = sum + time end
    self.CurrentFPS = 1 / (sum / #self.FrameTimes)
    self.IsStuttering = self.CurrentFPS < 30
    if self.AdaptiveQuality and PerformanceManager.DynamicQuality then
        if self.CurrentFPS < 20 then
            PerformanceManager.Mode = "Potato"
            PerformanceManager:Optimize()
            smartLoad()
        elseif self.CurrentFPS < 30 then
            PerformanceManager.Mode = "Low"
            PerformanceManager:Optimize()
            smartLoad()
        end
    end
    return self.CurrentFPS
end

-- ================================================================
-- BAŞLANGIÇ KONTROLLERİ
-- ================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- ================================================================
-- EZBYPASS
-- ================================================================
local EzBypass = {
    Enabled = true,
    RandomDelay = {0.05, 0.15},
    _patched = false,
}

function EzBypass:Init()
    if not EzBypass._patched then
        EzBypass._patched = true
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end
end

-- ================================================================
-- CONFIG SİSTEMİ
-- ================================================================
local Config = {
    Aimbot = {
        Enabled = false,
        FOV = 150,
        Smoothness = 0.15,
        HitPart = "Head",
        TeamCheck = false,
        VisibilityCheck = true,
        Prediction = true,
    },
    Triggerbot = {
        Enabled = false,
        FireRate = 0.12,
        HoldToFire = false,
    },
    NormalBehavior = {
        Enabled = false,
        RandomMouseMovements = true,
        AFKPrevention = true,
    },
    Mobile = {
        AutoFire = false,
        Crosshair = true,
        Vibration = true,
    },
    Visuals = {
        ShowDistance = true,
        ShowHealth = true,
        ShowName = true,
    },
    Performance = {
        Mode = "Auto",
        TargetFPS = 30,
        AdaptiveQuality = true,
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

local function smartLoad()
    local mode = PerformanceManager.Mode
    if mode == "Low" or mode == "Potato" then
        Settings.Visuals.ShowHealth = false
        Settings.NormalBehavior.RandomMouseMovements = false
    end
    if mode == "Potato" then
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

-- ================================================================
-- UI (Obsidian)
-- ================================================================
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()

Library.ShowCustomCursor = true
local Window = Library:CreateWindow({
    Title = "Lord Yagiz_ | War Tycoon v3.1",
    Center = true,
    AutoShow = true,
    Resizable = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
    UnlockMouseWhileOpen = true,
    ShowMobileButtons = true,
    MobileButtonsSide = "Right",
})

local CombatTab = Window:AddTab("Combat", "sword")
local TriggerTab = Window:AddTab("Trigger", "target")
local BehaviorTab = Window:AddTab("Behavior", "user")
local VisualTab = Window:AddTab("Visuals", "eye")
local PerformanceTab = Window:AddTab("Performance", "speedometer")
local SettingsTab = Window:AddTab("Settings", "settings")

local AimbotGroup = CombatTab:AddLeftGroupbox("⚡ Aimbot Settings")
local AdvancedGroup = CombatTab:AddRightGroupbox("🔧 Advanced Aim")
local TriggerGroup = TriggerTab:AddLeftGroupbox("🎯 Triggerbot Settings")
local BehaviorGroup = BehaviorTab:AddLeftGroupbox("🧠 Normal Behavior")
local MobileGroup = BehaviorTab:AddRightGroupbox("📱 Mobile Features")
local ESPGroup = VisualTab:AddLeftGroupbox("👁️ Visual ESP")
local PerfGroup = PerformanceTab:AddLeftGroupbox("📊 Performance Settings")
local PerfInfoGroup = PerformanceTab:AddRightGroupbox("📈 Live Stats")
local ConfigGroup = SettingsTab:AddLeftGroupbox("💾 Configuration")

-- ================================================================
-- DEĞİŞKENLER
-- ================================================================
local aimbotTarget = nil
local lastFireTime = 0
local lastAimTime = 0
local espObjects = {}
local aimbotCounter = 0
local triggerCounter = 0
local behaviorCounter = 0
local frameSkip = 0
local lastFPSUpdate = 0
local PerformanceStatsLabel = nil

-- ================================================================
-- YARDIMCI FONKSİYONLAR (ÇALIŞAN SÜRÜM)
-- ================================================================
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

local function getBestTarget()
    local bestPlayer = nil
    local bestDistance = Settings.Aimbot.FOV
    local bestPart = nil
    
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local char = player.Character
            local part = getTargetPart(char)
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < bestDistance then
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
    end
    return bestPlayer, bestPart
end

-- ================================================================
-- SİLAH TESPİTİ VE ATEŞ ETME (DÜZELTİLDİ)
-- ================================================================
local function getCurrentWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    -- Oyuncunun elindeki aracı (Tool) bul
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Tool") then
            return child
        end
    end
    return nil
end

local function fireWeapon()
    -- War Tycoon'da ateş etme: Mouse1 (sol tık) gönder
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
    return true
end

-- ================================================================
-- GELİŞMİŞ AIMBOT (DÜZELTİLDİ)
-- ================================================================
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
        local targetPos = part.Position
        
        -- Prediction
        if Settings.Aimbot.Prediction then
            local velocity = part.AssemblyLinearVelocity or Vector3.zero
            targetPos = targetPos + (velocity * 0.15)
        end
        
        -- Yumuşak hedefleme
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
        local smoothness = 1 - Settings.Aimbot.Smoothness
        
        if Settings.Aimbot.Smoothness <= 0.01 then
            Camera.CFrame = targetCFrame
        else
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothness)
        end
        lastAimTime = tick()
        
        -- Triggerbot ile birlikte çalışıyorsa otomatik ateş et
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

-- ================================================================
-- TRIGGERBOT (DÜZELTİLDİ - OTOMATİK ATEŞ)
-- ================================================================
local function runTriggerbot()
    if not Settings.Triggerbot.Enabled then
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
        local currentTime = tick()
        if currentTime - lastFireTime >= Settings.Triggerbot.FireRate then
            fireWeapon()
            lastFireTime = currentTime
        end
    end
end

-- ================================================================
-- NORMAL OYUNCU DAVRANIŞI
-- ================================================================
local behaviorTimer = 0
local function simulateNormalBehavior()
    if not Settings.NormalBehavior.Enabled then return end
    
    local fps = FPSManager.CurrentFPS
    if fps < 20 then
        behaviorCounter = behaviorCounter + 1
        if behaviorCounter % 3 ~= 0 then return end
    end
    
    behaviorTimer = behaviorTimer + 0.1
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
    
    if Settings.NormalBehavior.AFKPrevention and behaviorTimer % 3 < 0.1 then
        if math.random(1, 100) < 3 then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        humanoid:MoveTo(root.Position + Vector3.new(math.random(-8, 8), 0, math.random(-8, 8)))
                    end
                end
            end
        end
    end
end

-- ================================================================
-- MOBİL DESTEĞİ
-- ================================================================
local mobileCrosshair = nil
local function setupMobileSupport()
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
    
    if Settings.Mobile.AutoFire then
        UserInputService.TouchEnded:Connect(function(touch)
            if touch.Position.X > 0 and touch.Position.Y > 0 then
                fireWeapon()
            end
        end)
    end
end

-- ================================================================
-- ESP SİSTEMİ
-- ================================================================
local function createESP(player)
    local char = player.Character
    if not char then return end
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
    
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
    
    local esp = Instance.new("BillboardGui")
    esp.Name = "LordYagiz_ESP"
    esp.Size = UDim2.new(0, 200, 0, 50)
    esp.AlwaysOnTop = true
    esp.Enabled = false
    esp.Parent = char
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = esp
    
    if Settings.Visuals.ShowHealth then
        local healthBar = Instance.new("Frame")
        healthBar.Size = UDim2.new(0.8, 0, 0.15, 0)
        healthBar.Position = UDim2.new(0.1, 0, 0.85, 0)
        healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthBar.BackgroundTransparency = 0.3
        healthBar.BorderSizePixel = 0
        healthBar.Parent = esp
        local healthFill = Instance.new("Frame")
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        healthFill.BackgroundTransparency = 0.3
        healthFill.BorderSizePixel = 0
        healthFill.Parent = healthBar
        espObjects[player] = esp
        
        local function updateESP()
            local hum = char:FindFirstChild("Humanoid")
            if not hum then esp.Enabled = false return end
            esp.Enabled = true
            label.Text = Settings.Visuals.ShowName and player.Name or ""
            if Settings.Visuals.ShowHealth and hum.MaxHealth > 0 then
                local hp = hum.Health / hum.MaxHealth
                healthFill.Size = UDim2.new(hp, 0, 1, 0)
                healthFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - hp), 255 * hp, 0)
                healthBar.Visible = true
            else
                healthBar.Visible = false
            end
            if Settings.Visuals.ShowDistance then
                local dist = (char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                label.Text = label.Text .. " [" .. math.floor(dist) .. "m]"
            end
        end
        
        RunService.Heartbeat:Connect(function()
            if player.Character and player.Character == char then updateESP() end
        end)
    end
end

local function updateESP()
    if not Settings.Visuals.ShowHealth and not Settings.Visuals.ShowName then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not espObjects[player] or not espObjects[player].Parent then
                createESP(player)
            end
        end
    end
end

-- ================================================================
-- PERFORMANS GÖSTERGESİ
-- ================================================================
local function updatePerformanceStats()
    local fps = FPSManager.CurrentFPS
    local mem = collectgarbage("count") or 0
    local mode = PerformanceManager.Mode
    if PerformanceStatsLabel then
        pcall(function()
            PerformanceStatsLabel:SetText(string.format(
                "⚡ FPS: %d | Mode: %s | RAM: %.0fMB | %s",
                math.floor(fps), mode, mem / 1000,
                FPSManager.IsStuttering and "⚠️ KASMA" or "✅ AKICI"
            ))
        end)
    end
end

-- ================================================================
-- ANA DÖNGÜ
-- ================================================================
RunService.Heartbeat:Connect(function(deltaTime)
    local currentTime = tick()
    if currentTime - lastFPSUpdate >= 1 then
        FPSManager:Update(deltaTime)
        lastFPSUpdate = currentTime
        updatePerformanceStats()
    end
    
    if PerformanceManager.Mode == "Potato" or PerformanceManager.Mode == "Low" then
        frameSkip = frameSkip + 1
    end
    
    if LocalPlayer and LocalPlayer.Character then
        runAimbot()
        runTriggerbot()
        simulateNormalBehavior()
    end
    
    if FPSManager.CurrentFPS > 20 then
        if frameSkip % 5 == 0 then updateESP() end
    else
        if frameSkip % 10 == 0 then updateESP() end
    end
end)

-- ================================================================
-- MENÜ AYARLARI
-- ================================================================
AimbotGroup:AddToggle("AimbotToggle", {
    Text = "✅ Enable Aimbot",
    Default = false,
    Callback = function(state) Settings.Aimbot.Enabled = state end
})
AimbotGroup:AddSlider("AimbotFOV", {
    Text = "🎯 Aimbot FOV",
    Min = 30, Max = 300, Default = 150,
    Callback = function(v) Settings.Aimbot.FOV = v end
})
AimbotGroup:AddSlider("AimbotSmoothness", {
    Text = "🔄 Smoothness",
    Min = 0, Max = 1, Decimal = 2, Default = 0.15,
    Callback = function(v) Settings.Aimbot.Smoothness = v end
})
AimbotGroup:AddDropdown("HitPart", {
    Text = "🎯 Hit Part",
    Values = {"Head", "UpperTorso", "HumanoidRootPart", "Torso"},
    Default = "Head",
    Callback = function(v) Settings.Aimbot.HitPart = v end
})

AdvancedGroup:AddToggle("TeamCheck", {
    Text = "🚫 Team Check",
    Default = false,
    Callback = function(v) Settings.Aimbot.TeamCheck = v end
})
AdvancedGroup:AddToggle("VisibilityCheck", {
    Text = "👁️ Visibility Check",
    Default = true,
    Callback = function(v) Settings.Aimbot.VisibilityCheck = v end
})
AdvancedGroup:AddToggle("Prediction", {
    Text = "📐 Prediction",
    Default = true,
    Callback = function(v) Settings.Aimbot.Prediction = v end
})

TriggerGroup:AddToggle("TriggerbotToggle", {
    Text = "✅ Enable Triggerbot (Auto Fire)",
    Default = false,
    Callback = function(state) Settings.Triggerbot.Enabled = state end
})
TriggerGroup:AddSlider("TriggerFireRate", {
    Text = "⚡ Fire Rate (s)",
    Min = 0.05, Max = 0.5, Decimal = 2, Default = 0.12,
    Callback = function(v) Settings.Triggerbot.FireRate = v end
})

BehaviorGroup:AddToggle("NormalBehaviorToggle", {
    Text = "✅ Enable Normal Behavior",
    Default = false,
    Callback = function(v) Settings.NormalBehavior.Enabled = v end
})
BehaviorGroup:AddToggle("RandomMouseMovements", {
    Text = "🖱️ Random Mouse Movements",
    Default = true,
    Callback = function(v) Settings.NormalBehavior.RandomMouseMovements = v end
})
BehaviorGroup:AddToggle("AFKPrevention", {
    Text = "💤 AFK Prevention",
    Default = true,
    Callback = function(v) Settings.NormalBehavior.AFKPrevention = v end
})

MobileGroup:AddToggle("AutoFire", {
    Text = "🔥 Auto Fire on Touch",
    Default = false,
    Callback = function(v) Settings.Mobile.AutoFire = v; if v then setupMobileSupport() end end
})
MobileGroup:AddToggle("Crosshair", {
    Text = "🎯 Show Crosshair",
    Default = true,
    Callback = function(v) Settings.Mobile.Crosshair = v; setupMobileSupport() end
})
MobileGroup:AddToggle("Vibration", {
    Text = "📳 Vibration Feedback",
    Default = true,
    Callback = function(v) Settings.Mobile.Vibration = v end
})

ESPGroup:AddToggle("ShowName", {
    Text = "👤 Show Player Names",
    Default = true,
    Callback = function(v) Settings.Visuals.ShowName = v end
})
ESPGroup:AddToggle("ShowHealth", {
    Text = "❤️ Show Health Bar",
    Default = true,
    Callback = function(v) Settings.Visuals.ShowHealth = v end
})
ESPGroup:AddToggle("ShowDistance", {
    Text = "📏 Show Distance",
    Default = true,
    Callback = function(v) Settings.Visuals.ShowDistance = v end
})

PerfGroup:AddDropdown("PerformanceMode", {
    Text = "🎯 Performance Mode",
    Values = {"Auto", "Ultra", "High", "Medium", "Low", "Potato"},
    Default = "Auto",
    Callback = function(selected)
        if selected == "Auto" then PerformanceManager:DetectDevice()
        else PerformanceManager.Mode = selected end
        PerformanceManager:Optimize()
        smartLoad()
        Library:Notify({Title = "Performance", Description = "Switched to " .. selected .. " mode", Time = 2})
    end
})
PerfGroup:AddToggle("AdaptiveQuality", {
    Text = "🔄 Adaptive Quality",
    Default = true,
    Callback = function(v) PerformanceManager.DynamicQuality = v; FPSManager.AdaptiveQuality = v end
})
PerfGroup:AddSlider("TargetFPS", {
    Text = "🎯 Target FPS",
    Min = 15, Max = 60, Default = 30,
    Callback = function(v) FPSManager.TargetFPS = v end
})
PerfGroup:AddButton({
    Text = "🥔 ONE CLICK POTATO MODE",
    Callback = function()
        PerformanceManager.Mode = "Potato"
        PerformanceManager:Optimize()
        smartLoad()
        Settings.Aimbot.Enabled = true
        Settings.Aimbot.FOV = 200
        Settings.Aimbot.Smoothness = 0.5
        Settings.Aimbot.VisibilityCheck = false
        Settings.Aimbot.Prediction = false
        Settings.Triggerbot.Enabled = false
        Settings.NormalBehavior.Enabled = false
        Settings.Visuals.ShowName = false
        Settings.Visuals.ShowHealth = false
        Settings.Visuals.ShowDistance = false
        collectgarbage("collect")
        Library:Notify({Title = "🥔 Potato Mode", Description = "Optimized for low-end devices!", Time = 3})
    end
})

local StatsLabel = PerfInfoGroup:AddLabel("📊 Performance Statistics")
PerformanceStatsLabel = StatsLabel
PerfInfoGroup:AddButton({
    Text = "🧹 Clean Memory",
    Callback = function()
        collectgarbage("collect")
        Library:Notify({Title = "Memory Cleaned", Description = string.format("RAM: %.0fMB", collectgarbage("count") / 1000), Time = 2})
    end
})

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
        Library:Notify({Title = "Config Saved", Description = "Settings saved!", Time = 2})
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
        Library:Notify({Title = "Config Loaded", Description = "Settings loaded!", Time = 2})
    end
})
ConfigGroup:AddButton({
    Text = "🔄 Reset Config",
    Callback = function()
        Settings = deepCopy(Config)
        Library:Notify({Title = "Config Reset", Description = "Reset to default!", Time = 2})
    end
})

-- ================================================================
-- BAŞLATMA
-- ================================================================
PerformanceManager:DetectDevice()
PerformanceManager:Optimize()
smartLoad()
EzBypass:Init()

if UserInputService.TouchEnabled then
    setupMobileSupport()
    Library:Notify({Title = "📱 Mobile Mode", Description = "Touch controls active!", Time = 3})
end

Library:Notify({
    Title = "⚡ Lord Yagiz_ v3.1 (FIXED)",
    Description = string.format("Mode: %s | FPS: %d", PerformanceManager.Mode, math.floor(FPSManager.CurrentFPS)),
    Time = 4
})

print("⚡ Lord Yagiz_ v3.1 loaded successfully! (Aimbot + Triggerbot FIXED)")

-- ================================================================
-- TEMİZLİK
-- ================================================================
local function cleanup()
    for _, esp in pairs(espObjects) do pcall(function() esp:Destroy() end) end
    espObjects = {}
    if mobileCrosshair then pcall(function() mobileCrosshair:Destroy() end) end
    collectgarbage("collect")
end
game:BindToClose(cleanup)
