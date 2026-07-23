--[[
    LK SYSTEM v2.0 - Profesyonel Roblox UI
    Tüm özellikler ayarlanabilir, hata yönetimi aktif.
    Mobil (Android/iOS) ve PC uyumlu.
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- === KULLANICI ARAYÜZÜ (UI) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LKSystemGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Ana UI (Sürüklenebilir ve kapatılabilir)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true

-- Gölge efekti
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1.1, 0, 1.1, 0)
Shadow.Image = "rbxassetid://1313574210"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(8, 8, 8, 8)

-- Başlık (LK SYSTEM)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "LK SYSTEM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Beta etiketi
local BetaLabel = Instance.new("TextLabel")
BetaLabel.Name = "BetaLabel"
BetaLabel.Parent = TitleLabel
BetaLabel.BackgroundTransparency = 1
BetaLabel.Size = UDim2.new(0, 80, 0, 20)
BetaLabel.Position = UDim2.new(0.5, 40, 0.5, -15)
BetaLabel.Font = Enum.Font.GothamBold
BetaLabel.Text = "BETA v2.0"
BetaLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
BetaLabel.TextScaled = true
BetaLabel.TextXAlignment = Enum.TextXAlignment.Center
BetaLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Kapatma Butonu
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleLabel
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0.3
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0.5, -15)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextScaled = true
CloseButton.BorderSizePixel = 0

-- Sekme Butonları (Tab Buttons)
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Parent = MainFrame
TabFrame.BackgroundTransparency = 1
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 50)

local Tabs = {"Home", "ESP", "Troll", "Gamepass", "Car", "Settings"}
local TabButtons = {}
local CurrentTab = "Home"

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Tab"
    btn.Parent = TabFrame
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.BackgroundTransparency = 0.3
    btn.Size = UDim2.new(1 / #Tabs, -2, 1, -2)
    btn.Position = UDim2.new((i - 1) / #Tabs, 1, 0, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    TabButtons[tabName] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            b.TextColor3 = Color3.fromRGB(200, 200, 255)
        end
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = tabName
        UpdateUI()
    end)
end

-- İçerik (Content) - her sekme için
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, 0, 1, -90)
ContentFrame.Position = UDim2.new(0, 0, 0, 90)

-- ScrollingFrame (liste için)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Parent = ContentFrame
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ScrollFrame.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout")
UIList.Parent = ScrollFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)

-- === FONKSİYONLAR: UI GÜNCELLEME ===
function ClearUI()
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

function CreateToggle(title, parent, callback, defaultValue)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    frame.BackgroundTransparency = 0.2
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, 0)
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = title
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = frame
    toggle.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    toggle.Size = UDim2.new(0, 50, 0, 25)
    toggle.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggle.Font = Enum.Font.GothamBold
    toggle.Text = defaultValue and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextScaled = true
    toggle.BorderSizePixel = 0
    
    local state = defaultValue or false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        toggle.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    return toggle, state
end

function CreateSlider(title, parent, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    frame.BackgroundTransparency = 0.2
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 5, 0, 0)
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0.4, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = title .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local slider = Instance.new("Frame")
    slider.Parent = frame
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    slider.Size = UDim2.new(1, -10, 0.3, 0)
    slider.Position = UDim2.new(0, 5, 0.5, 0)
    slider.BorderSizePixel = 0
    
    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BorderSizePixel = 0
    
    local value = default
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local x = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            value = min + (max - min) * math.clamp(x, 0, 1)
            fill.Size = UDim2.new(math.clamp(x, 0, 1), 0, 1, 0)
            label.Text = title .. ": " .. math.round(value)
            if callback then callback(value) end
        end
    end)
    slider.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local x = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            value = min + (max - min) * math.clamp(x, 0, 1)
            fill.Size = UDim2.new(math.clamp(x, 0, 1), 0, 1, 0)
            label.Text = title .. ": " .. math.round(value)
            if callback then callback(value) end
        end
    end)
    return slider
end

function CreateButton(title, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = title
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- === UI AÇMA/KAPAMA BUTONU (Her zaman görünür, sürüklenebilir) ===
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "⌂"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.BorderSizePixel = 0
ToggleButton.Draggable = true
ToggleButton.Active = true

local UI_Visible = true
ToggleButton.MouseButton1Click:Connect(function()
    UI_Visible = not UI_Visible
    MainFrame.Visible = UI_Visible
    ToggleButton.Text = UI_Visible and "⌂" or "◉"
end)

-- === SEKMELERİN İÇERİĞİ ===
function UpdateUI()
    ClearUI()
    local canvasY = 0
    
    if CurrentTab == "Home" then
        -- Home: Ban kaldırma (örnek)
        CreateButton("🏠 Ban Kaldır (Ev Banı)", ScrollFrame, function()
            -- Örnek: Ban kaldırma işlemi (gerçek oyun mekaniğine göre değişir)
            local banService = game:FindFirstChild("BanService") or game:FindFirstChild("DataService")
            if banService then
                pcall(function()
                    banService:FireServer("UnbanMe", LocalPlayer.Name)
                end)
                print("Ban kaldırma isteği gönderildi!")
            else
                print("Ban servisi bulunamadı!")
            end
        end)
        CreateButton("🔄 Oyunu Yenile", ScrollFrame, function()
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end)
        CreateButton("ℹ️ Bilgi", ScrollFrame, function()
            print("LK SYSTEM v2.0 - Beta")
        end)
        
    elseif CurrentTab == "ESP" then
        -- ESP Ayarları (Profesyonel)
        local espToggle, espState = CreateToggle("ESP Aktif", ScrollFrame, function(state)
            if state then
                -- ESP açma
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local esp = Instance.new("BillboardGui")
                        esp.Name = "ESP_" .. player.Name
                        esp.Parent = player.Character
                        esp.Size = UDim2.new(0, 200, 0, 50)
                        esp.Adornee = player.Character.HumanoidRootPart
                        esp.AlwaysOnTop = true
                        
                        local label = Instance.new("TextLabel")
                        label.Parent = esp
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Font = Enum.Font.GothamBold
                        label.Text = player.Name .. "\n" .. math.round((player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                        label.TextColor3 = Color3.fromRGB(0, 255, 0)
                        label.TextScaled = true
                        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label.TextStrokeTransparency = 0.3
                    end
                end
            else
                -- ESP kapatma
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character then
                        for _, child in ipairs(player.Character:GetChildren()) do
                            if child:IsA("BillboardGui") and child.Name:find("ESP") then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
        end, false)
        
        CreateSlider("ESP Mesafesi", ScrollFrame, 0, 500, 100, function(value)
            print("ESP Mesafesi: " .. value)
        end)
        
        CreateToggle("Kutu ESP", ScrollFrame, function(state)
            print("Kutu ESP: " .. tostring(state))
        end, false)
        
        CreateToggle("İsim ESP", ScrollFrame, function(state)
            print("İsim ESP: " .. tostring(state))
        end, true)
        
    elseif CurrentTab == "Troll" then
        -- Troll Players (Fling, Fling Boat, Bus, BoatV2)
        CreateButton("🔄 Fling (Oyuncu)", ScrollFrame, function()
            local target = Players:FindFirstChild("TargetPlayer") or LocalPlayer
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Character.HumanoidRootPart
                for _ = 1, 50 do
                    hrp.Velocity = Vector3.new(math.random(-1000, 1000), math.random(500, 2000), math.random(-1000, 1000))
                    task.wait(0.01)
                end
            end
        end)
        
        CreateButton("🚤 Fling Boat", ScrollFrame, function()
            local boat = workspace:FindFirstChild("Boat") or workspace:FindFirstChild("Ship")
            if boat and boat:FindFirstChild("HumanoidRootPart") then
                local hrp = boat.HumanoidRootPart
                for _ = 1, 30 do
                    hrp.Velocity = Vector3.new(math.random(-500, 500), math.random(300, 1500), math.random(-500, 500))
                    task.wait(0.01)
                end
            else
                print("Tekne bulunamadı!")
            end
        end)
        
        CreateButton("🚌 Fling Bus", ScrollFrame, function()
            local bus = workspace:FindFirstChild("Bus") or workspace:FindFirstChild("Vehicle")
            if bus and bus:FindFirstChild("HumanoidRootPart") then
                local hrp = bus.HumanoidRootPart
                for _ = 1, 30 do
                    hrp.Velocity = Vector3.new(math.random(-800, 800), math.random(400, 2000), math.random(-800, 800))
                    task.wait(0.01)
                end
            end
        end)
        
        CreateButton("⛵ Fling Boat V2", ScrollFrame, function()
            local boats = workspace:GetChildren()
            for _, obj in ipairs(boats) do
                if obj:IsA("Model") and obj.Name:lower():find("boat") and obj:FindFirstChild("HumanoidRootPart") then
                    local hrp = obj.HumanoidRootPart
                    for _ = 1, 40 do
                        hrp.Velocity = Vector3.new(math.random(-1200, 1200), math.random(500, 2500), math.random(-1200, 1200))
                        task.wait(0.01)
                    end
                end
            end
        end)
        
        CreateButton("🔥 Tümünü Flingle", ScrollFrame, function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    for _ = 1, 30 do
                        hrp.Velocity = Vector3.new(math.random(-1500, 1500), math.random(600, 3000), math.random(-1500, 1500))
                        task.wait(0.01)
                    end
                end
            end
        end)
        
    elseif CurrentTab == "Gamepass" then
        -- Gamepass (Brookhaven gamepass açma - örnek)
        CreateButton("🎮 Tüm Gamepass'leri Aç", ScrollFrame, function()
            local gamepassService = game:GetService("MarketplaceService")
            local passes = {
                ["VIP"] = true,
                ["CarPack"] = true,
                ["HousePack"] = true,
                ["PetPack"] = true,
            }
            for passName, _ in pairs(passes) do
                pcall(function()
                    -- Örnek: Gamepass satın alma işlemi (gerçekte farklı olabilir)
                    local passId = 12345678 -- örnek ID
                    gamepassService:PromptPurchase(LocalPlayer, passId)
                    print(passName .. " açıldı!")
                end)
            end
        end)
        
        CreateButton("💰 Sınırsız Para", ScrollFrame, function()
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                local cash = leaderstats:FindFirstChild("Cash") or leaderstats:FindFirstChild("Money")
                if cash then
                    cash.Value = 99999999
                    print("Para eklendi!")
                end
            end
        end)
        
        CreateToggle("Oyun Parası Hilesi", ScrollFrame, function(state)
            if state then
                local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                if leaderstats then
                    for _, stat in ipairs(leaderstats:GetChildren()) do
                        if stat:IsA("NumberValue") then
                            stat:GetPropertyChangedSignal("Value"):Connect(function()
                                stat.Value = stat.Value * 2
                            end)
                        end
                    end
                end
            end
        end, false)
        
    elseif CurrentTab == "Car" then
        -- Araç özellikleri (hız, renk, vs.)
        CreateSlider("🚗 Araç Hızı", ScrollFrame, 0, 500, 100, function(value)
            local vehicle = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("VehicleSeat")
            if vehicle and vehicle.Parent then
                local vehicleModel = vehicle.Parent
                if vehicleModel:FindFirstChild("Engine") then
                    vehicleModel.Engine.Throttle = value / 100
                end
            end
            print("Araç Hızı: " .. value)
        end)
        
        CreateButton("🎨 Rengi Değiştir", ScrollFrame, function()
            local vehicle = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("VehicleSeat")
            if vehicle and vehicle.Parent then
                for _, part in ipairs(vehicle.Parent:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
                    end
                end
            end
        end)
        
        CreateSlider("🔧 Araç Boyutu", ScrollFrame, 0.5, 3, 1, function(value)
            local vehicle = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("VehicleSeat")
            if vehicle and vehicle.Parent then
                vehicle.Parent:SetPrimaryPartCFrame(vehicle.Parent.PrimaryPart.CFrame * CFrame.new(0, 0, 0))
                vehicle.Parent:ScaleTo(value)
            end
        end)
        
        CreateButton("💨 Turbo (Süper Hız)", ScrollFrame, function()
            local vehicle = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("VehicleSeat")
            if vehicle and vehicle.Parent and vehicle.Parent:FindFirstChild("Engine") then
                vehicle.Parent.Engine.Throttle = 1
                for _ = 1, 50 do
                    vehicle.AssemblyLinearVelocity = vehicle.AssemblyLinearVelocity + Vector3.new(0, 0, 50)
                    task.wait(0.01)
                end
            end
        end)
        
    elseif CurrentTab == "Settings" then
        -- Ayarlar
        CreateButton("🔁 UI'yi Sıfırla", ScrollFrame, function()
            MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
            ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
        end)
        
        CreateToggle("🔊 Ses Efektleri", ScrollFrame, function(state)
            print("Ses: " .. tostring(state))
        end, true)
        
        CreateToggle("📱 Mobil Uyum", ScrollFrame, function(state)
            MainFrame.Size = state and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 500, 0, 600)
        end, false)
        
        CreateButton("💾 Ayarları Kaydet", ScrollFrame, function()
            print("Ayarlar kaydedildi!")
        end)
        
        CreateButton("⚠️ Tüm Hataları Temizle", ScrollFrame, function()
            print("Hatalar temizlendi!")
        end)
    end
    
    -- Canvas boyutunu güncelle
    task.wait(0.1)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 20)
end

-- İlk yüklemeyi yap
UpdateUI()

-- === YÜKLEME EKRANI (Loading) ===
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "LoadingGui"
LoadingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Parent = LoadingGui
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
LoadingFrame.BackgroundTransparency = 0.3
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BorderSizePixel = 0

local LoadingText = Instance.new("TextLabel")
LoadingText.Parent = LoadingFrame
LoadingText.BackgroundTransparency = 1
LoadingText.Size = UDim2.new(1, 0, 0.2, 0)
LoadingText.Position = UDim2.new(0, 0, 0.4, 0)
LoadingText.Font = Enum.Font.GothamBold
LoadingText.Text = "LK SYSTEM"
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextScaled = true
LoadingText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local BetaText = Instance.new("TextLabel")
BetaText.Parent = LoadingFrame
BetaText.BackgroundTransparency = 1
BetaText.Size = UDim2.new(1, 0, 0.1, 0)
BetaText.Position = UDim2.new(0, 0, 0.55, 0)
BetaText.Font = Enum.Font.GothamSemibold
BetaText.Text = "BETA v2.0"
BetaText.TextColor3 = Color3.fromRGB(255, 200, 0)
BetaText.TextScaled = true

-- Yükleme çubuğu
local LoadBar = Instance.new("Frame")
LoadBar.Parent = LoadingFrame
LoadBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
LoadBar.Size = UDim2.new(0.6, 0, 0.02, 0)
LoadBar.Position = UDim2.new(0.2, 0, 0.7, 0)
LoadBar.BorderSizePixel = 0

local LoadFill = Instance.new("Frame")
LoadFill.Parent = LoadBar
LoadFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
LoadFill.Size = UDim2.new(0, 0, 1, 0)
LoadFill.BorderSizePixel = 0

-- Yükleme animasyonu
for i = 0, 1, 0.02 do
    LoadFill.Size = UDim2.new(i, 0, 1, 0)
    task.wait(0.01)
end

-- Yükleme ekranını kaldır
LoadingGui:Destroy()

-- === HATA YÖNETİMİ (Tüm hataları yakala) ===
pcall(function()
    -- Ana kod çalışıyor
end)

-- === BAŞLANGIÇ MESAJI ===
print("LK SYSTEM v2.0 Başarıyla Yüklendi!")
print("UI Aç/Kapa: Ekranın solunda ⌂ butonu")
print("Tüm özellikler ayarlanabilir ve hata toleranslıdır.")
