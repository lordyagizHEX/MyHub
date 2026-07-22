-- ============================================
-- 🔥 LORD HUB V3 - BROOKHAVEN EDITION
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid")
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

-- ============================================
-- 📱 ANA MENÜ
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "LordHubV3"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 500, 0, 550)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = Color3.fromRGB(255, 50, 100)
stroke.Thickness = 2

-- Başlık
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "🔥 LORD HUB V3 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- Kapatma
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
-- 🔘 MENÜ AÇMA BUTONU
-- ============================================

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0.9, 0, 0.8, 0)
toggleBtn.Text = "🔥"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 30
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
toggleBtn.BackgroundTransparency = 0.1

local toggleCorner = Instance.new("UICorner")
toggleCorner.Parent = toggleBtn
toggleCorner.CornerRadius = UDim.new(1, 0)

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ============================================
-- 📋 OYUNCU LİSTESİ (SOL)
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

local listTitle = Instance.new("TextLabel")
listTitle.Parent = leftPanel
listTitle.Size = UDim2.new(1, 0, 0, 35)
listTitle.Text = "👥 Oyuncular"
listTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
listTitle.TextSize = 16
listTitle.Font = Enum.Font.GothamBold
listTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = leftPanel
scrollFrame.Size = UDim2.new(1, 0, 1, -70)
scrollFrame.Position = UDim2.new(0, 0, 0, 35)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 5)

local selectedPlayer = nil
local playerButtons = {}

-- Yenile butonu
local refreshBtn = Instance.new("TextButton")
refreshBtn.Parent = leftPanel
refreshBtn.Size = UDim2.new(1, 0, 0, 30)
refreshBtn.Position = UDim2.new(0, 0, 0.94, 0)
refreshBtn.Text = "🔄 Yenile"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.TextSize = 14
refreshBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)

local refreshCorner = Instance.new("UICorner")
refreshCorner.Parent = refreshBtn
refreshCorner.CornerRadius = UDim.new(0, 6)

-- ============================================
-- 📋 İŞLEMLER (SAĞ)
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

local selectedDisplay = Instance.new("TextLabel")
selectedDisplay.Parent = rightPanel
selectedDisplay.Size = UDim2.new(1, 0, 0, 35)
selectedDisplay.Text = "🎯 Seçili: Yok"
selectedDisplay.TextColor3 = Color3.fromRGB(255, 200, 0)
selectedDisplay.TextSize = 16
selectedDisplay.Font = Enum.Font.GothamBold
selectedDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 60)

-- ============================================
-- 🎯 BUTON OLUŞTURUCU
-- ============================================

local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = rightPanel
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
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
    for _, btn in pairs(playerButtons) do
        btn:Destroy()
    end
    playerButtons = {}
    
    for _, plr in pairs(game.Players:GetPlayers()) do
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
                for _, b in pairs(playerButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                end
                btn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
            end)
            
            table.insert(playerButtons, btn)
        end
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #playerButtons * 40)
end

refreshBtn.MouseButton1Click:Connect(refreshPlayerList)

-- ============================================
-- ⚡ KENDİ ÖZELLİKLERİN (SAĞ TARAF)
-- ============================================

-- 1. UÇUŞ
local flying = false
local flyBodyVel = nil
local flyConn = nil

createButton("🛩️ Uçuş", 0.08, Color3.fromRGB(0, 150, 255), function()
    flying = not flying
    
    if flying then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            flyBodyVel = Instance.new("BodyVelocity")
            flyBodyVel.Parent = char.HumanoidRootPart
            flyBodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
            flyBodyVel.Velocity = Vector3.new(0, 50, 0)
            
            flyConn = runService.Heartbeat:Connect(function()
                if flying and char and char:FindFirstChild("HumanoidRootPart") then
                    flyBodyVel.Velocity = Vector3.new(0, 50, 0)
                end
            end)
        end
        print("✅ Uçuş AÇIK")
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyConn then flyConn:Disconnect() end
        print("❌ Uçuş KAPALI")
    end
end)

-- 2. ESP
local espEnabled = false
local espObjects = {}

local function createESP()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            if head then
                local bill = Instance.new("BillboardGui")
                bill.Parent = head
                bill.Size = UDim2.new(0, 200, 0, 40)
                bill.StudsOffset = Vector3.new(0, 2.5, 0)
                bill.AlwaysOnTop = true
                bill.Name = "ESP_Billboard"
                
                local label = Instance.new("TextLabel")
                label.Parent = bill
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                label.TextSize = 16
                label.Font = Enum.Font.GothamBold
                label.TextStrokeTransparency = 0.3
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                
                local box = Instance.new("BoxHandleAdornment")
                box.Parent = char
                box.Adornee = char
                box.Size = Vector3.new(4, 6, 2)
                box.Color3 = Color3.fromRGB(255, 50, 100)
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

createButton("👁️ ESP", 0.18, Color3.fromRGB(150, 0, 200), function()
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

-- 3. TELEPORT
createButton("📦 Teleport", 0.28, Color3.fromRGB(0, 200, 255), function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = selectedPlayer.Character.HumanoidRootPart
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            print("✅ " .. selectedPlayer.Name .. "'e ışınlandın!")
        end
    else
        print("❌ Geçerli bir oyuncu seç!")
    end
end)

-- 4. BRING
createButton("📥 Bring", 0.38, Color3.fromRGB(255, 200, 0), function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = selectedPlayer.Character.HumanoidRootPart
        if character and character:FindFirstChild("HumanoidRootPart") then
            targetRoot.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 3)
            print("✅ " .. selectedPlayer.Name .. " getirildi!")
        end
    else
        print("❌ Geçerli bir oyuncu seç!")
    end
end)

-- 5. KILL
createButton("💀 Kill", 0.48, Color3.fromRGB(255, 0, 0), function()
    if selectedPlayer and selectedPlayer.Character then
        local hum = selectedPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.Health = 0
            print("💀 " .. selectedPlayer.Name .. " öldürüldü!")
        end
    else
        print("❌ Geçerli bir oyuncu seç!")
    end
end)

-- 6. FLING
createButton("💥 Fling", 0.58, Color3.fromRGB(255, 100, 0), function()
    if selectedPlayer and selectedPlayer.Character then
        local root = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = Instance.new("BodyVelocity")
            vel.Parent = root
            vel.MaxForce = Vector3.new(400000, 400000, 400000)
            vel.Velocity = Vector3.new(math.random(-150, 150), math.random(100, 300), math.random(-150, 150))
            task.wait(0.5)
            vel:Destroy()
            print("💥 " .. selectedPlayer.Name .. " fırlatıldı!")
        end
    else
        print("❌ Geçerli bir oyuncu seç!")
    end
end)

-- 7. KILL ALL
createButton("💀 Kill All", 0.68, Color3.fromRGB(200, 0, 0), function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hum = plr.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                hum.Health = 0
            end
        end
    end
    print("💀 Herkes öldürüldü!")
end)

-- 8. FLING ALL
createButton("💥 Fling All", 0.78, Color3.fromRGB(200, 50, 0), function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = Instance.new("BodyVelocity")
                vel.Parent = root
                vel.MaxForce = Vector3.new(400000, 400000, 400000)
                vel.Velocity = Vector3.new(math.random(-200, 200), math.random(150, 400), math.random(-200, 200))
                task.wait(0.1)
                vel:Destroy()
            end
        end
    end
    print("💥 Herkes fırlatıldı!")
end)

-- 9. BOAT ATTACK
createButton("🚤 Boat Attack", 0.88, Color3.fromRGB(200, 50, 50), function()
    if selectedPlayer and selectedPlayer.Character then
        local targetRoot = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetRoot and character and character:FindFirstChild("HumanoidRootPart") then
            local boat = Instance.new("Part")
            boat.Parent = workspace
            boat.Size = Vector3.new(10, 3, 5)
            boat.Position = character.HumanoidRootPart.Position + Vector3.new(0, 25, 0)
            boat.Material = Enum.Material.Neon
            boat.Color = Color3.fromRGB(255, 0, 0)
            boat.Anchored = false
            boat.Name = "Boat_Attack"
            
            local vel = Instance.new("BodyVelocity")
            vel.Parent = boat
            vel.MaxForce = Vector3.new(400000, 400000, 400000)
            vel.Velocity = (targetRoot.Position - boat.Position).Unit * 200 + Vector3.new(0, 50, 0)
            
            local connection
            connection = runService.Heartbeat:Connect(function()
                if boat and targetRoot and selectedPlayer.Character then
                    local dist = (boat.Position - targetRoot.Position).Magnitude
                    if dist < 15 then
                        local explosion = Instance.new("Explosion")
                        explosion.Parent = workspace
                        explosion.Position = targetRoot.Position
                        explosion.BlastRadius = 20
                        explosion.BlastPressure = 100000
                        selectedPlayer.Character:FindFirstChild("Humanoid").Health = 0
                        boat:Destroy()
                        connection:Disconnect()
                        print("🚤 " .. selectedPlayer.Name .. " gemi ile yok edildi!")
                    end
                end
            end)
            
            task.wait(5)
            if boat then
                boat:Destroy()
                if connection then connection:Disconnect() end
            end
        end
    else
        print("❌ Geçerli bir oyuncu seç!")
    end
end)

-- ============================================
-- ⚡ HIZ VE ZIPLAMA (SAĞ ÜST KÖŞE KÜÇÜK)
-- ============================================

local speedBtn = Instance.new("TextButton")
speedBtn.Parent = rightPanel
speedBtn.Size = UDim2.new(0.4, 0, 0, 30)
speedBtn.Position = UDim2.new(0.05, 0, 0.95, 0)
speedBtn.Text = "🏃 16"
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.TextSize = 12
speedBtn.BackgroundColor3 = Color3.fromRGB(30, 144, 255)

local speedCorner = Instance.new("UICorner")
speedCorner.Parent = speedBtn
speedCorner.CornerRadius = UDim.new(0, 6)

speedBtn.MouseButton1Click:Connect(function()
    if humanoid.WalkSpeed == 16 then
        humanoid.WalkSpeed = 50
        speedBtn.Text = "🏃 50"
    else
        humanoid.WalkSpeed = 16
        speedBtn.Text = "🏃 16"
    end
end)

local jumpBtn = Instance.new("TextButton")
jumpBtn.Parent = rightPanel
jumpBtn.Size = UDim2.new(0.4, 0, 0, 30)
jumpBtn.Position = UDim2.new(0.55, 0, 0.95, 0)
jumpBtn.Text = "⬆️ 50"
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.TextSize = 12
jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

local jumpCorner = Instance.new("UICorner")
jumpCorner.Parent = jumpBtn
jumpCorner.CornerRadius = UDim.new(0, 6)

jumpBtn.MouseButton1Click:Connect(function()
    if humanoid.JumpPower == 50 then
        humanoid.JumpPower = 80
        jumpBtn.Text = "⬆️ 80"
    else
        humanoid.JumpPower = 50
        jumpBtn.Text = "⬆️ 50"
    end
end)

-- ============================================
-- 🔄 OTOMATİK YENİLEME
-- ============================================

game.Players.PlayerAdded:Connect(refreshPlayerList)
game.Players.PlayerRemoving:Connect(refreshPlayerList)

-- ============================================
-- 📋 BAŞLAT
-- ============================================

refreshPlayerList()
print("🔥 LORD HUB V3 YÜKLENDİ!")
print("📌 Menüyü açmak için sağ alttaki 🔥 butonuna tıkla")
print("📌 Bir oyuncu seçip işlem yapabilirsin!")
