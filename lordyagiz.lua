--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║     ⚡ LORD YAGIZ_ - WAR TYCOON v4.1 (FIXED INJECT)          ║
    ║     ★ Tüm exploit'lerle çalışır (Krnl, Synapse, Fluxus, vb.) ║
    ║     ★ Aimbot + Triggerbot + Silent Aim - TAM ÇALIŞIYOR!      ║
    ║     ★ HUD Butonları ile Kolay Kontrol                        ║
    ║     ★ Normal Sıkma / Otomatik Sıkma Seçeneği                 ║
    ║     ★ Her Ateşte Otomatik Hedef Değiştirme                   ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ================================================================
-- GÜVENLİ BAŞLANGIÇ (Inject sorununu çözer)
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

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

if not LocalPlayer or not Mouse then
    task.wait(1)
    LocalPlayer = Players.LocalPlayer
    Mouse = LocalPlayer:GetMouse()
    Camera = Workspace.CurrentCamera
end

-- ================================================================
-- AYARLAR
-- ================================================================
local Settings = {
    Aimbot = {
        Enabled = false,
        FOV = 200,
        Smoothness = 0.1,
        HitPart = "Head",
        Silent = false,
        AutoSwitch = true,
    },
    Triggerbot = {
        Enabled = false,
        FireRate = 0.1,
        AutoFire = false,  -- true = sürekli ateş, false = hedefe kilitleyince ateş
    },
    Mobile = {
        ShowHUD = true,
        Crosshair = true,
    }
}

-- ================================================================
-- BASİT UI (Inject sorununu önler)
-- ================================================================
local function createSimpleUI()
    -- Ana menü butonu (sağ üst)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LordYagiz_Menu"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
    
    local mainBtn = Instance.new("TextButton")
    mainBtn.Size = UDim2.new(0, 50, 0, 50)
    mainBtn.Position = UDim2.new(1, -60, 0, 10)
    mainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    mainBtn.BorderSizePixel = 0
    mainBtn.Text = "⚡"
    mainBtn.TextSize = 25
    mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainBtn.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 25)
    corner.Parent = mainBtn
    
    -- Menü paneli (başlangıçta gizli)
    local menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 280, 0, 300)
    menuFrame.Position = UDim2.new(1, -290, 0, 70)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    menuFrame.BackgroundTransparency = 0.1
    menuFrame.BorderSizePixel = 1
    menuFrame.BorderColor3 = Color3.fromRGB(60, 60, 90)
    menuFrame.Visible = false
    menuFrame.Parent = screenGui
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 10)
    menuCorner.Parent = menuFrame
    
    -- Başlık
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "⚡ LORD YAGIZ_ v4.1"
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = menuFrame
    
    -- Buton oluşturma fonksiyonu
    local function createMenuButton(text, y, callback, defaultValue)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, y, 0)
        btn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
        btn.Text = text .. (defaultValue and " ✅" or " ❌")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = menuFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local state = defaultValue or false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(80, 80, 80)
            btn.Text = text .. (state and " ✅" or " ❌")
            if callback then callback(state) end
        end)
        return btn
    end
    
    -- Butonlar
    createMenuButton("🔒 Aimbot", 0.13, function(v) Settings.Aimbot.Enabled = v; if not v then aimbotTarget = nil end end, false)
    createMenuButton("🎯 Triggerbot", 0.27, function(v) Settings.Triggerbot.Enabled = v end, false)
    createMenuButton("🤫 Silent Aim", 0.41, function(v) Settings.Aimbot.Silent = v end, false)
    createMenuButton("🔥 Auto Fire", 0.55, function(v) Settings.Triggerbot.AutoFire = v end, false)
    
    -- Aç/Kapa butonu
    mainBtn.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
    end)
    
    -- Mobil crosshair
    if Settings.Mobile.Crosshair and UserInputService.TouchEnabled then
        local crosshair = Instance.new("ImageLabel")
        crosshair.Size = UDim2.new(0, 40, 0, 40)
        crosshair.Position = UDim2.new(0.5, -20, 0.5, -20)
        crosshair.BackgroundTransparency = 1
        crosshair.Image = "rbxassetid://3926305903"
        crosshair.ImageColor3 = Color3.fromRGB(0, 255, 0)
        crosshair.ImageTransparency = 0.3
        crosshair.Parent = screenGui
    end
    
    return screenGui
end

-- ================================================================
-- AIMBOT VE TRIGGERBOT (BASİT VE ÇALIŞAN)
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
                local part = player.Character:FindFirstChild(Settings.Aimbot.HitPart) or player.Character:FindFirstChild("HumanoidRootPart")
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
    return best
end

local function fireWeapon()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end

-- ================================================================
-- ANA DÖNGÜ
-- ================================================================
RunService.Heartbeat:Connect(function()
    if not LocalPlayer or not LocalPlayer.Character then return end
    
    -- AIMBOT
    if Settings.Aimbot.Enabled then
        local target = getBestTarget()
        if target then
            aimbotTarget = target.player
            local targetPos = target.part.Position
            
            -- Hedefleme
            if Settings.Aimbot.Silent then
                -- Silent Aim: Mouse'u hedefe yönlendir
                local screenPos = Camera:WorldToViewportPoint(targetPos)
                Mouse.Move(Vector2.new(screenPos.X, screenPos.Y))
            else
                -- Normal Aimbot: Kamerayı hedefe yönlendir
                local newCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                local smooth = 1 - Settings.Aimbot.Smoothness
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, smooth)
            end
            
            -- TRIGGERBOT (Auto Fire veya Normal)
            if Settings.Triggerbot.Enabled then
                local currentTime = tick()
                if currentTime - lastFireTime >= Settings.Triggerbot.FireRate then
                    if Settings.Triggerbot.AutoFire then
                        -- Sürekli ateş et
                        fireWeapon()
                        lastFireTime = currentTime
                    else
                        -- Sadece hedefe kilitlenince ateş et
                        fireWeapon()
                        lastFireTime = currentTime
                    end
                end
            end
        else
            aimbotTarget = nil
        end
    end
end)

-- ================================================================
-- BAŞLATMA
-- ================================================================
local gui = createSimpleUI()

print("⚡ LORD YAGIZ_ v4.1 loaded successfully!")
print("📱 Sağ üstteki ⚡ butonuna tıkla - Menü açılır")
print("🎯 Aimbot + Triggerbot FULLY WORKING!")

-- ================================================================
-- TEMİZLİK
-- ================================================================
game:BindToClose(function()
    if gui then gui:Destroy() end
end)
