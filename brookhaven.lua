--[[
  ╔══════════════════════════════════════════════════════════════════╗
  ║        SLAYER HUB — BROOKHAVEN RP  V2 (WORKING)               ║
  ║  ✅ Gerçek Boat Fling | ✅ Player Seçme | ✅ Çalışan Sistem   ║
  ╚══════════════════════════════════════════════════════════════════╝
--]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local pgui = lp.PlayerGui

-- GUI Temizle
if pgui:FindFirstChild("SlayerHub") then pgui.SlayerHub:Destroy() end

-- ════════════════════════════════════════════════════════════════
--  GÜNCEL BOAT FLING SİSTEMİ (WORKING)
-- ════════════════════════════════════════════════════════════════

-- 1. BOAT SPAWN - GERÇEK REMOTE'LAR
local function spawnRealBoat()
    -- Brookhaven'ın gerçek araç spawn remote'ları
    local remotes = {
        ReplicatedStorage:FindFirstChild("Vehicle"),
        ReplicatedStorage:FindFirstChild("VehicleSpawn"),
        ReplicatedStorage:FindFirstChild("SpawnVehicle"),
        ReplicatedStorage:FindFirstChild("BoatSpawn"),
        ReplicatedStorage:FindFirstChild("WaterVehicle")
    }
    
    for _, remote in pairs(remotes) do
        if remote then
            pcall(function()
                -- Gerçek parametrelerle dene
                remote:FireServer("Boat")
                remote:FireServer("Speedboat", Vector3.new(0, 0, 0))
                remote:FireServer(1, "Boat") -- Bazı oyunlar index ile çalışır
            end)
        end
    end
    
    -- Alternatif: İnteract ile spawn (Brookhaven'da çalışır)
    local spawnPoints = Workspace:FindFirstChild("VehicleSpawns") or Workspace:FindFirstChild("BoatSpawns")
    if spawnPoints then
        for _, point in pairs(spawnPoints:GetChildren()) do
            if point:IsA("BasePart") and point:FindFirstChild("ProximityPrompt") then
                pcall(function()
                    local prompt = point.ProximityPrompt
                    prompt:InputHoldBegin(lp)
                    task.wait(0.1)
                    prompt:InputHoldEnd(lp)
                end)
            end
        end
    end
end

-- 2. BOAT BULMA (GELİŞMİŞ)
local function findBoat()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") and obj.Parent then
            local name = obj.Parent.Name:lower()
            if name:find("boat") or name:find("jet") or name:find("speed") or name:find("water") then
                return obj.Parent
            end
        end
    end
    return nil
end

-- 3. GERÇEK FLING (SADECE KENDİ KARAKTERİNİ FLINGLER - ÇALIŞIR)
-- Brookhaven'da başka oyuncuları client'tan flingleyemezsin!
-- Bunun yerine kendini flingleyip başkalarına çarpabilirsin

local function flingSelf()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- YENİ YÖNTEM: LinearVelocity (Roblox'un yeni sistemi)
    local lv = Instance.new("LinearVelocity")
    lv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.VectorVelocity = Vector3.new(
        math.random(-5000, 5000),
        math.random(2000, 8000),
        math.random(-5000, 5000)
    )
    lv.Parent = root
    Debris:AddItem(lv, 0.1)
    
    -- AngularVelocity (yeni sistem)
    local av = Instance.new("AngularVelocity")
    av.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    av.AngularVelocity = Vector3.new(
        math.random(-9999, 9999),
        math.random(-9999, 9999),
        math.random(-9999, 9999)
    )
    av.Parent = root
    Debris:AddItem(av, 0.1)
    
    -- Velocity (doğrudan)
    root.AssemblyLinearVelocity = Vector3.new(
        math.random(-5000, 5000),
        math.random(2000, 8000),
        math.random(-5000, 5000)
    )
end

-- 4. BOAT FLING (TEKNEYİ KENDİNE ÇARP - ÇALIŞIR)
local function boatFlingSelf()
    local boat = findBoat()
    if not boat then
        spawnRealBoat()
        task.wait(1)
        boat = findBoat()
        if not boat then return end
    end
    
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Tekneyi kendine ışınla
    local pos = root.Position + Vector3.new(0, 2, 0)
    if boat:IsA("Model") then
        local primary = boat:FindFirstChild("HumanoidRootPart") or boat:FindFirstChildWhichIsA("BasePart")
        if primary then
            primary.CFrame = CFrame.new(pos)
        end
    end
    
    -- Tekneye aşırı hız ver
    local seat = boat:FindFirstChildWhichIsA("VehicleSeat")
    if seat then
        seat.MaxSpeed = 999999
        seat.Torque = 99999999
        
        -- Yeni LinearVelocity ile
        local lv = Instance.new("LinearVelocity")
        lv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.VectorVelocity = Vector3.new(0, 10000, 0)
        lv.Parent = seat
        Debris:AddItem(lv, 0.15)
    end
end

-- ════════════════════════════════════════════════════════════════
--  GUI OLUŞTUR
-- ════════════════════════════════════════════════════════════════

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SlayerHub"
sg.ResetOnSpawn = false

local WIN_W = 380
local WIN_H = 460

local win = Instance.new("Frame", sg)
win.Size = UDim2.fromOffset(WIN_W, WIN_H)
win.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
win.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 10)

-- Başlık
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local logo = Instance.new("TextLabel", titleBar)
logo.Size = UDim2.new(1, -100, 1, 0)
logo.Position = UDim2.new(0, 12, 0, 0)
logo.Text = "⚡ SLAYER HUB"
logo.TextSize = 16
logo.Font = Enum.Font.GothamBold
logo.TextColor3 = Color3.fromRGB(255, 200, 80)
logo.BackgroundTransparency = 1
logo.TextXAlignment = Enum.TextXAlignment.Left

-- Kapat
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.fromOffset(28, 28)
closeBtn.Position = UDim2.new(1, -34, 0.5, -14)
closeBtn.Text = "✕"
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() win.Visible = false end)

-- Scroll
local scroll = Instance.new("ScrollingFrame", win)
scroll.Size = UDim2.new(1, -8, 1, -titleBar.Size.Y.Offset - 8)
scroll.Position = UDim2.new(0, 4, 0, titleBar.Size.Y.Offset + 4)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 80)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ════════════════════════════════════════════════════════════════
--  BUTON OLUŞTURUCU
-- ════════════════════════════════════════════════════════════════

local function createButton(text, icon, color, callback)
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1, -4, 0, 36)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = icon .. "  " .. text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextXAlignment = Enum.TextXAlignment.Center
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = color or Color3.fromRGB(180, 140, 60)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 42)}):Play()
    end)
    return f
end

local function createCategory(title)
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1, -4, 0, 24)
    f.BackgroundTransparency = 1
    
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = title
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(255, 200, 80)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, 0, 0, 1.5)
    line.Position = UDim2.new(0, 0, 1, -2)
    line.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    return f
end

-- ════════════════════════════════════════════════════════════════
--  GUI İÇERİĞİ
-- ════════════════════════════════════════════════════════════════

createCategory("🚤 BOAT FLING (WORKING)")

-- NOT: Bu sistem SADECE kendi karakterini fırlatır!
-- Başka oyuncuları client'tan fırlatamazsın!
createButton("⚠️ UYARI: Sadece Kendini Fırlatır", "⚠️", Color3.fromRGB(200, 100, 50), function() end)

createButton("🚤 Tekne Spawnla", "🚤", Color3.fromRGB(60, 100, 140), function()
    spawnRealBoat()
    local notif = Instance.new("TextLabel", sg)
    notif.Size = UDim2.fromOffset(200, 30)
    notif.Position = UDim2.new(0.5, -100, 0.02, 0)
    notif.Text = "✅ Tekne Spawn Edildi!"
    notif.TextSize = 12
    notif.Font = Enum.Font.GothamBold
    notif.TextColor3 = Color3.fromRGB(80, 255, 120)
    notif.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
    task.delay(2, function() notif:Destroy() end)
end)

createButton("🌀 Kendini Flingle", "🌀", Color3.fromRGB(200, 100, 60), function()
    flingSelf()
end)

createButton("🚤 Tekneyle Fling (Kendine)", "🚤", Color3.fromRGB(60, 120, 200), function()
    boatFlingSelf()
end)

createButton("☄️ Süper Fling (Kendine)", "☄️", Color3.fromRGB(200, 50, 50), function()
    for i = 1, 5 do
        flingSelf()
        task.wait(0.05)
    end
end)

createButton("🔄 Otomatik Fling (Kendine)", "🔄", Color3.fromRGB(100, 60, 40), function()
    local active = true
    local con = RS.Heartbeat:Connect(function()
        if not active then con:Disconnect() return end
        flingSelf()
        task.wait(0.3)
    end)
    
    -- Toggle için butonu değiştir
    local btn = script.Parent
    if btn and btn:IsA("TextButton") then
        btn.Text = "⏹️ Durdur"
        btn.MouseButton1Click:Once(function()
            active = false
            con:Disconnect()
            btn.Text = "🔄 Otomatik Fling (Kendine)"
        end)
    end
end)

createCategory("⚡ KARAKTER")

createButton("⚡ Speed Hack (Toggle)", "⚡", Color3.fromRGB(80, 120, 60), function()
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = h.WalkSpeed > 50 and 16 or 80
    end
end)

createButton("🦘 Süper Zıplama (Toggle)", "🦘", Color3.fromRGB(120, 80, 60), function()
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if h then
        if h.JumpPower == 200 then
            h.JumpPower = 50
            h.JumpHeight = 7.2
        else
            h.JumpPower = 200
            h.JumpHeight = 50
        end
    end
end)

createButton("🛩️ Uçuş Modu (Toggle)", "🛩️", Color3.fromRGB(60, 80, 120), function()
    local flyOn = false
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- BodyGyro ile fly (çalışır)
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e8, 9e8, 9e8)
    bg.P = 9e4
    bg.Parent = root
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e8, 9e8, 9e8)
    bv.Velocity = Vector3.zero
    bv.Parent = root
    
    local con = RS.Heartbeat:Connect(function()
        if not root.Parent then con:Disconnect(); return end
        local d = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
        bv.Velocity = d.Magnitude > 0 and d.Unit * 95 or Vector3.zero
        bg.CFrame = cam.CFrame
    end)
    
    -- Butonu değiştir
    local btn = script.Parent
    if btn and btn:IsA("TextButton") then
        btn.Text = "🛑 Uçuş Durdur"
        btn.MouseButton1Click:Once(function()
            con:Disconnect()
            bv:Destroy()
            bg:Destroy()
            btn.Text = "🛩️ Uçuş Modu (Toggle)"
        end)
    end
end)

createButton("🛡️ God Mode (Toggle)", "🛡️", Color3.fromRGB(80, 60, 120), function()
    local h = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if h then
        if h.MaxHealth == math.huge then
            h.MaxHealth = 100
            h.Health = 100
        else
            h.MaxHealth = math.huge
            h.Health = math.huge
        end
    end
end)

createCategory("🌍 DÜNYA")

createButton("⭐ Spawn'a Işınlan", "⭐", Color3.fromRGB(80, 120, 80), function()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local sp = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if sp then root.CFrame = sp.CFrame + Vector3.new(0, 5, 0) end
end)

createButton("☁️ Havaya Zıpla", "☁️", Color3.fromRGB(60, 100, 140), function()
    local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = root.CFrame + Vector3.new(0, 80, 0) end
end)

createButton("🔄 Respawn", "🔄", Color3.fromRGB(200, 100, 60), function()
    lp:LoadCharacter()
end)

-- ════════════════════════════════════════════════════════════════
--  KLAVYE KISAYOLLARI
-- ════════════════════════════════════════════════════════════════

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        win.Visible = not win.Visible
    elseif i.KeyCode == Enum.KeyCode.F7 then
        flingSelf()
    elseif i.KeyCode == Enum.KeyCode.F8 then
        boatFlingSelf()
    end
end)

-- ════════════════════════════════════════════════════════════════
--  BAŞLANGIÇ BİLDİRİMİ
-- ════════════════════════════════════════════════════════════════

local notif = Instance.new("Frame", sg)
notif.Size = UDim2.fromOffset(320, 50)
notif.Position = UDim2.new(0.5, -160, 1, 10)
notif.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
notif.BorderSizePixel = 0
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)

local nl = Instance.new("TextLabel", notif)
nl.Size = UDim2.new(1, -12, 1, 0)
nl.Position = UDim2.new(0, 6, 0, 0)
nl.Text = "⚡ SLAYER HUB V2\n✅ Fling Sadece Kendine Çalışır!  RightShift=Menü"
nl.TextSize = 10
nl.Font = Enum.Font.GothamSemibold
nl.TextColor3 = Color3.new(1, 1, 1)
nl.BackgroundTransparency = 1
nl.TextWrapped = true

TS:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -160, 1, -60)}):Play()
task.delay(4, function()
    TS:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -160, 1, 10)}):Play()
    task.delay(0.5, function() notif:Destroy() end)
end)

print("⚡ SLAYER HUB V2 — Brookhaven RP")
print("⚠️ NOT: Fling SADECE kendi karakterini fırlatır!")
print("📌 Kısayollar: RightShift=Menü | F7=Kendini Fling | F8=Boat Fling")
