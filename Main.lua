-- ============================================
-- 🔥 LORD HUB - ÖZEL HUB
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid")
local mouse = player:GetMouse()

-- ============================================
-- 📱 MENÜ OLUŞTUR
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "LordHub"
screenGui.ResetOnSpawn = false

-- Ana Panel
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 380, 0, 500)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true

-- Kenarlık
local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 12)

-- Kenarlık çizgisi
local stroke = Instance.new("UIStroke")
stroke.Parent = mainFrame
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 2

-- Başlık
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "🔥 LORD HUB 🔥"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- Kapatma Butonu (Menüyü gizler)
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 40, 0, 30)
closeBtn.Position = UDim2.new(0.9, 0, 0.02, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextSize = 20
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ============================================
-- 🎯 BUTON OLUŞTURUCU
-- ============================================

local function createButton(text, yPos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = mainFrame
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = UDim2.new(0.075, 0, yPos, 0)
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
-- 📋 ANA MENÜ BUTONLARI
-- ============================================

-- Menüyü Açma Butonu (Ekranda kalıcı)
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
                -- BillboardGui
                local bill = Instance.new("BillboardGui")
                bill.Parent = head
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.StudsOffset = Vector3.new(0, 2.5, 0)
                bill.AlwaysOnTop = true
                bill.Name = "ESP_Billboard"
                
                -- İsim ve Sağlık
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
                
                -- Kutu (Box)
                local box = Instance.new("BoxHandleAdornment")
                box.Parent = char
                box.Adornee = char
                box.Size = Vector3.new(4, 6, 2)
                box.Color3 = Color3.fromRGB(0, 150, 255)
                box.Transparency = 0.5
                box.ZIndex = 0
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

createButton("👁️ ESP AÇ/KAPA", 0.15, Color3.fromRGB(0, 150, 255), function()
    espEnabled = not espEnabled
    if espEnabled then
        clearESP()
        createESP()
        -- Yeni oyuncular için
        game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if espEnabled then
                    createESP()
                end
            end)
        end)
        print("✅ ESP AÇIK")
    else
        clearESP()
        print("❌ ESP KAPALI")
    end
end)

-- ============================================
-- 2️⃣ FLY SİSTEMİ
-- ============================================

local flying = false
local flyBodyVel = nil
local flyConnection = nil

createButton("🛩️ UÇUŞ AÇ/KAPA", 0.28, Color3.fromRGB(150, 50, 200), function()
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
            
            -- WASD kontrolleri
            local uis = game:GetService("UserInputService")
            uis.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if not flying then return end
                
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
-- 3️⃣ FLING SİSTEMİ (Kişiyi Fırlat)
-- ============================================

local flingTarget = nil

createButton("💥 FLING (TIKLA KİŞİYE)", 0.41, Color3.fromRGB(255, 100, 0), function()
    print("🎯 Fling yapmak için bir oyuncuya tıkla!")
    
    mouse.Button1Down:Connect(function()
        local target = mouse.Target
        if target then
            local char = target.Parent
            while char and not char:FindFirstChild("Humanoid") do
                char = char.Parent
            end
            
            if char and char:FindFirstChild("Humanoid") then
                local targetPlayer = game.Players:GetPlayerFromCharacter(char)
                if targetPlayer and targetPlayer ~= player then
                    flingTarget = targetPlayer
                    
                    -- Fling işlemi
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local vel = Instance.new("BodyVelocity")
                        vel.Parent = rootPart
                        vel.MaxForce = Vector3.new(400000, 400000, 400000)
                        vel.Velocity = Vector3.new(0, 200, 0) + (rootPart.Position - character.HumanoidRootPart.Position).Unit * 150
                        
                        task.wait(0.5)
                        vel:Destroy()
                        
                        print("💥 " .. targetPlayer.Name .. " fırlatıldı!")
                    end
                end
            end
        end
    end)
end)

-- ============================================
-- 4️⃣ GEMİ İLE YOK ETME SİSTEMİ
-- ============================================

local vehicleMode = false

createButton("🚗 GEMİ MODU AÇ/KAPA", 0.54, Color3.fromRGB(200, 50, 50), function()
    vehicleMode = not vehicleMode
    
    if vehicleMode then
        print("🚗 Gemi Modu AÇIK! Bir oyuncuya tıkla ve gemi fırlat!")
        
        mouse.Button1Down:Connect(function()
            if not vehicleMode then return end
            
            local target = mouse.Target
            if target then
                local char = target.Parent
                while char and not char:FindFirstChild("Humanoid") do
                    char = char.Parent
                end
                
                if char and char:FindFirstChild("Humanoid") then
                    local targetPlayer = game.Players:GetPlayerFromCharacter(char)
                    if targetPlayer and targetPlayer ~= player then
                        -- Gemi oluştur (basit bir küp)
                        local vehicle = Instance.new("Part")
                        vehicle.Parent = workspace
                        vehicle.Size = Vector3.new(10, 3, 5)
                        vehicle.Position = character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
                        vehicle.Material = Enum.Material.Neon
                        vehicle.Color = Color3.fromRGB(255, 0, 0)
                        vehicle.Anchored = false
                        
                        -- Gemiye hız ver
                        local vel = Instance.new("BodyVelocity")
                        vel.Parent = vehicle
                        vel.MaxForce = Vector3.new(400000, 400000, 400000)
                        vel.Velocity = (char.HumanoidRootPart.Position - vehicle.Position).Unit * 200 + Vector3.new(0, 50, 0)
                        
                        -- Gemi hedefe çarpsın
                        local connection
                        connection = game:GetService("RunService").Heartbeat:Connect(function()
                            if vehicle and char and char:FindFirstChild("HumanoidRootPart") then
                                local dist = (vehicle.Position - char.HumanoidRootPart.Position).Magnitude
                                if dist < 15 then
                                    -- Çarpma efekti
                                    local explosion = Instance.new("Explosion")
                                    explosion.Parent = workspace
                                    explosion.Position = char.HumanoidRootPart.Position
                                    explosion.BlastRadius = 20
                                    explosion.BlastPressure = 100000
                                    
                                    char.Humanoid.Health = 0
                                    vehicle:Destroy()
                                    connection:Disconnect()
                                    print("💀 " .. targetPlayer.Name .. " gemi ile yok edildi!")
                                end
                            end
                        end)
                        
                        -- 5 saniye sonra gemi kaybolsun
                        task.wait(5)
                        if vehicle then
                            vehicle:Destroy()
                            if connection then connection:Disconnect() end
                        end
                    end
                end
            end
        end)
    else
        print("❌ Gemi Modu KAPALI")
    end
end)

-- ============================================
-- 5️⃣ HIZ + ZIPLAMA AYARLARI
-- ============================================

createButton("🏃 HIZ 50 / NORMAL", 0.67, Color3.fromRGB(30, 144, 255), function()
    if humanoid.WalkSpeed == 16 then
        humanoid.WalkSpeed = 50
        print("✅ Hız 50")
    else
        humanoid.WalkSpeed = 16
        print("✅ Hız Normal")
    end
end)

createButton("⬆️ ZIPLA 80 / NORMAL", 0.80, Color3.fromRGB(0, 200, 100), function()
    if humanoid.JumpPower == 50 then
        humanoid.JumpPower = 80
        print("✅ Zıplama 80")
    else
        humanoid.JumpPower = 50
        print("✅ Zıplama Normal")
    end
end)

-- ============================================
-- 📋 BAŞLATMA MESAJI
-- ============================================

print("🔥 LORD HUB YÜKLENDİ!")
print("📌 Menüyü açmak için sağ alttaki 🔥 butonuna tıkla")
print("📌 Menüyü kapatmak için ✕ butonuna tıkla")
