-- ============================================
-- 🔥 LORD HUB V2 - GELİŞMİŞ HUB
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid")
local mouse = player:GetMouse()

-- ============================================
-- 📱 ANA MENÜ OLUŞTUR
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "LordHubV2"
screenGui.ResetOnSpawn = false

-- Ana Panel (2 sütunlu)
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 700, 0, 550)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 2

-- Başlık
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "🔥 LORD HUB V2 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- Kapatma Butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 40, 0, 30)
closeBtn.Position = UDim2.new(0.93, 0, 0.02, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextSize = 20
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ============================================
-- 🔘 MENÜYÜ AÇMA BUTONU
-- ============================================

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0.9, 0, 0.85, 0)
toggleBtn.Text = "🔥"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 30
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
toggleBtn.BackgroundTransparency = 0.1

local toggleCorner = Instance.new("UICorner")
toggleCorner.Parent = toggleBtn
toggleCorner.CornerRadius = UDim.new(1, 0)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ============================================
-- 📋 SOL TARAF - OYUNCU LİSTESİ
-- ============================================

local leftPanel = Instance.new("Frame")
leftPanel.Parent = mainFrame
leftPanel.Size = UDim2.new(0.4, 0, 1, -45)
leftPanel.Position = UDim2.new(0, 0, 0, 45)
leftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
leftPanel.BackgroundTransparency = 0.3

local leftCorner = Instance.new("UICorner")
leftCorner.Parent = leftPanel
leftCorner.CornerRadius = UDim.new(0, 8)

-- Oyuncu Listesi Başlığı
local listTitle = Instance.new("TextLabel")
listTitle.Parent = leftPanel
listTitle.Size = UDim2.new(1, 0, 0, 35)
listTitle.Text = "👥 Oyuncular"
listTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
listTitle.TextSize = 16
listTitle.Font = Enum.Font.GothamBold
listTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)

-- Scrollable Liste
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = leftPanel
scrollFrame.Size = UDim2.new(1, 0, 1, -35)
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 5)

-- Seçili oyuncu
local selectedPlayer = nil
local playerButtons = {}

-- ============================================
-- 📋 SAĞ TARAF - İŞLEMLER
-- ============================================

local rightPanel = Instance.new("Frame")
rightPanel.Parent = mainFrame
rightPanel.Size = UDim2.new(0.57, 0, 1, -45)
rightPanel.Position = UDim2.new(0.43, 0, 0, 45)
rightPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
rightPanel.BackgroundTransparency = 0.3

local rightCorner = Instance.new("UICorner")
rightCorner.Parent = rightPanel
rightCorner.CornerRadius = UDim.new(0, 8)

-- Seçili oyuncu gösterimi
local selectedDisplay = Instance.new("TextLabel")
selectedDisplay.Parent = rightPanel
selectedDisplay.Size = UDim2.new(1, 0, 0, 35)
selectedDisplay.Text = "🎯 Seçili: Yok"
selectedDisplay.TextColor3 = Color3.fromRGB(255, 200, 0)
selectedDisplay.TextSize = 16
selectedDisplay.Font = Enum.Font.GothamBold
selectedDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)

-- ============================================
-- 🎯 BUTON OLUŞTURUCU (SAĞ TARAF)
-- ============================================

local function createRightButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = rightPanel
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ============================================
-- 👥 OYUNCU LİSTESİNİ YENİLE
-- ============================================

local function refreshPlayerList()
    -- Eski butonları temizle
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    -- Oyuncuları listele
    local players = game.Players:GetPlayers()
    for _, plr in pairs(players) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Parent = scrollFrame
            btn.Size = UDim2.new(0.95, 0, 0, 35)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 14
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.Parent = btn
            btnCorner.CornerRadius = UDim.new(0, 6)
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                selectedDisplay.Text = "🎯 Seçili: " .. plr.Name
                -- Buton rengini değiştir
                for _, b in pairs(playerButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                end
                btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 40)
end

-- Liste yenileme butonu
local refreshBtn = Instance.new("TextButton")
refreshBtn.Parent = leftPanel
refreshBtn.Size = UDim2.new(1, 0, 0, 30)
refreshBtn.Position = UDim2.new(0, 0, 0.94, 0)
refreshBtn.Text = "🔄 Yenile"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.TextSize = 14
refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

local refreshCorner = Instance.new("UICorner")
refreshCorner.Parent = refreshBtn
refreshCorner.CornerRadius = UDim.new(0, 6)

refreshBtn.MouseButton1Click:Connect(refreshPlayerList)

-- ============================================
-- 1️⃣ ESP SİSTEMİ
-- ============================================

local espEnabled = false
local espObjects = {}

local function createESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChild("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local bill = Instance.new("BillboardGui")
                bill.Parent = head
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.StudsOffset = Vector3.new(0, 2.5, 0)
                bill.AlwaysOnTop = true
                bill.Name = "ESP_Billboard"
                
                local label = Instance.new("TextLabel")
                label.Parent = bill
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name .. " ❤️ " .. math.floor(humanoid.Health)
                label.TextColor3 = humanoid.Health > 50 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                label.TextSize = 16
                label.Font = Enum.Font.GothamBold
                label.TextStrokeTransparency = 0.5
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                
                local box = Instance.new("BoxHandleAdornment")
                box.Parent = char
                box.Adornee = char
                box.Size = Vector3.new(4, 6, 2)
                box.Color3 = Color3.fromRGB(0, 150, 255)
                box.Transparency = 0.5
                box.AlwaysOnTop = true
                box.Name = "ESP_Box"
                
                table.insert(espObjects, bill)
                table.insert(espObjects, box)
            end
        end
    end
end

local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

-- ============================================
-- 2️⃣ FLY SİSTEMİ
-- ============================================

local flying = false
local flyBodyVel = nil
local flyConnection = nil

-- ============================================
-- 3️⃣ FLING / BOAT / KILL / BRING / TELEPORT
-- ============================================

local function getTargetChar()
    if not selectedPlayer or not selectedPlayer.Character then
        print("❌ Geçerli bir oyuncu seç!")
        return nil
    end
    return selectedPlayer.Character
end

-- Teleport
createRightButton("📦 Teleport Et", 0.10, Color3.fromRGB(0, 150, 255), function()
    local targetChar = getTargetChar()
    if targetChar and character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        print("✅ " .. selectedPlayer.Name .. "'e ışınlandın!")
    end
end)

-- Bring (Oyuncuyu yanına çek)
createRightButton("📥 Bring (Çek)", 0.20, Color3.fromRGB(255, 200, 0), function()
    local targetChar = getTargetChar()
    if targetChar and character and character:FindFirstChild("HumanoidRootPart") then
        targetChar.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 3)
        print("✅ " .. selectedPlayer.Name .. " getirildi!")
    end
end)

-- Kill
createRightButton("💀 Kill (Öldür)", 0.30, Color3.fromRGB(255, 0, 0), function()
    local targetChar = getTargetChar()
    if targetChar then
        local hum = targetChar:FindFirstChild("Humanoid")
        if hum then
            hum.Health = 0
            print("💀 " .. selectedPlayer.Name .. " öldürüldü!")
        end
    end
end)

-- Fling (Fırlat)
createRightButton("💥 Fling (Fırlat)", 0.40, Color3.fromRGB(255, 100, 0), function()
    local targetChar = getTargetChar()
    if targetChar then
        local root = targetChar:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = Instance.new("BodyVelocity")
            vel.Parent = root
            vel.MaxForce = Vector3.new(400000, 400000, 400000)
            vel.Velocity = Vector3.new(0, 200, 0) + Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
            task.wait(0.5)
            vel:Destroy()
            print("💥 " .. selectedPlayer.Name .. " fırlatıldı!")
        end
    end
end)

-- ============================================
-- 🚗 BOAT (GEMİ) SİSTEMİ
-- ============================================

createRightButton("🚤 Boat (Gemi Fırlat)", 0.50, Color3.fromRGB(200, 50, 50), function()
    local targetChar = getTargetChar()
    if not targetChar then return end
    
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    -- Gemi oluştur
    local boat = Instance.new("Part")
    boat.Parent = workspace
    boat.Size = Vector3.new(12, 4, 6)
    boat.Position = character.HumanoidRootPart.Position + Vector3.new(0, 20, 0)
    boat.Material = Enum.Material.Neon
    boat.Color = Color3.fromRGB(255, 0, 0)
    boat.Anchored = false
    boat.Name = "Boat_Attack"
    
    local boatCorner = Instance.new("SpecialMesh")
    boatCorner.Parent = boat
    boatCorner.MeshType = Enum.MeshType.FileMesh
    boatCorner.MeshId = "rbxassetid://7408735455" -- Tekne görünümü
    
    -- Gemiye hız ver
    local vel = Instance.new("BodyVelocity")
    vel.Parent = boat
    vel.MaxForce = Vector3.new(400000, 400000, 400000)
    vel.Velocity = (targetRoot.Position - boat.Position).Unit * 250 + Vector3.new(0, 50, 0)
    
    -- Gemi hedefe çarpsın
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if boat and targetRoot and targetChar and targetChar:FindFirstChild("Humanoid") then
            local dist = (boat.Position - targetRoot.Position).Magnitude
            if dist < 15 then
                -- Patlama efekti
                local explosion = Instance.new("Explosion")
                explosion.Parent = workspace
                explosion.Position = targetRoot.Position
                explosion.BlastRadius = 25
                explosion.BlastPressure = 150000
                
                targetChar.Humanoid.Health = 0
                boat:Destroy()
                connection:Disconnect()
                print("🚤 " .. selectedPlayer.Name .. " gemi ile yok edildi!")
            end
        end
    end)
    
    -- 5 saniye sonra temizle
    task.wait(5)
    if boat then
        boat:Destroy()
        if connection then connection:Disconnect() end
    end
end)

-- ============================================
-- ⚡ HIZ / ZIPLAMA AYARLARI
-- ============================================

createRightButton("🏃 Hız: 16/50", 0.62, Color3.fromRGB(30, 144, 255), function()
    if humanoid.WalkSpeed == 16 then
        humanoid.WalkSpeed = 50
    else
        humanoid.WalkSpeed = 16
    end
end)

createRightButton("⬆️ Zıplama: 50/80", 0.72, Color3.fromRGB(0, 200, 100), function()
    if humanoid.JumpPower == 50 then
        humanoid.JumpPower = 80
    else
        humanoid.JumpPower = 50
    end
end)

-- ============================================
-- 👁️ ESP / UÇUŞ BUTONLARI (SAĞ TARAF)
-- ============================================

createRightButton("👁️ ESP Aç/Kapa", 0.82, Color3.fromRGB(150, 0, 200), function()
    espEnabled = not espEnabled
    if espEnabled then
        clearESP()
        createESP()
        game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if espEnabled then createESP() end
            end)
        end)
        print("✅ ESP AÇIK")
    else
        clearESP()
        print("❌ ESP KAPALI")
    end
end)

createRightButton("🛩️ Uçuş Aç/Kapa", 0.92, Color3.fromRGB(0, 200, 255), function()
    flying = not flying
    
    if flying then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            flyBodyVel = Instance.new("BodyVelocity")
            flyBodyVel.Parent = char.HumanoidRootPart
            flyBodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
            flyBodyVel.Velocity = Vector3.new(0, 50, 0)
            
            flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if flying and char and char:FindFirstChild("HumanoidRootPart") then
                    flyBodyVel.Velocity = Vector3.new(0, 50, 0)
                end
            end)
            
            local uis = game:GetService("UserInputService")
            uis.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed or not flying then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                if input.KeyCode == Enum.KeyCode.W then
                    root.CFrame = root.CFrame + root.CFrame.LookVector * 2
                elseif input.KeyCode == Enum.KeyCode.S then
                    root.CFrame = root.CFrame - root.CFrame.LookVector * 2
                elseif input.KeyCode == Enum.KeyCode.A then
                    root.CFrame = root.CFrame - root.CFrame.RightVector * 2
                elseif input.KeyCode == Enum.KeyCode.D then
                    root.CFrame = root.CFrame + root.CFrame.RightVector * 2
                end
            end)
        end
        print("✅ UÇUŞ AÇIK")
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyConnection then flyConnection:Disconnect() end
        print("❌ UÇUŞ KAPALI")
    end
end)

-- ============================================
-- 🎯 OYUNCU EKLEME/ÇIKARMA OTOMATİK
-- ============================================

game.Players.PlayerAdded:Connect(function()
    refreshPlayerList()
end)

game.Players.PlayerRemoving:Connect(function()
    refreshPlayerList()
end)

-- ============================================
-- 📋 BAŞLAT
-- ============================================

refreshPlayerList()
print("🔥 LORD HUB V2 YÜKLENDİ!")
print("📌 Menüyü açmak için sağ alttaki 🔥 butonuna tıkla")
