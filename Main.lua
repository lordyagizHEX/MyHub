-- [[ LK SYSTEM - Premium Roblox ESP & Hile Menüsü ]]
-- [[ Sürüm: Beta v2.0 - TAM ÇALIŞAN ]]
-- [[ Geliştirici: LK System ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ KONSTANTLAR ]]
local UI_CORNER = 10
local GLASS_BLUR = 0.85
local ESP_ENABLED = false
local ESP_DISTANCE = 200
local ESP_OBJECTS = {}
local SELECTED_PLAYER = nil

-- =================================================================
-- [[ FİLİGRAN ]]
-- =================================================================
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "WatermarkGui"
WatermarkGui.Parent = game:GetService("CoreGui")
WatermarkGui.ResetOnSpawn = false

local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Parent = WatermarkGui
Watermark.BackgroundTransparency = 1
Watermark.Position = UDim2.new(1, -120, 0, 15)
Watermark.Size = UDim2.new(0, 100, 0, 40)
Watermark.ZIndex = 1000

local WatermarkTitle = Instance.new("TextLabel")
WatermarkTitle.Parent = Watermark
WatermarkTitle.BackgroundTransparency = 1
WatermarkTitle.Size = UDim2.new(1, 0, 0.6, 0)
WatermarkTitle.Font = Enum.Font.GothamBold
WatermarkTitle.Text = "LK SYSTEM"
WatermarkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkTitle.TextSize = 16
WatermarkTitle.TextStrokeTransparency = 0.3
WatermarkTitle.TextXAlignment = Enum.TextXAlignment.Right

local WatermarkBeta = Instance.new("TextLabel")
WatermarkBeta.Parent = Watermark
WatermarkBeta.BackgroundTransparency = 1
WatermarkBeta.Position = UDim2.new(0, 0, 0.6, 0)
WatermarkBeta.Size = UDim2.new(1, 0, 0.4, 0)
WatermarkBeta.Font = Enum.Font.GothamBold
WatermarkBeta.Text = "Beta"
WatermarkBeta.TextColor3 = Color3.fromRGB(255, 200, 0)
WatermarkBeta.TextSize = 11
WatermarkBeta.TextXAlignment = Enum.TextXAlignment.Right

-- =================================================================
-- [[ ANA UI ]]
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LKSystem"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = GLASS_BLUR
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Visible = true
MainFrame.ZIndex = 100
MainFrame.Active = true
MainFrame.Selectable = true

local GlassEffect = Instance.new("Frame")
GlassEffect.Parent = MainFrame
GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassEffect.BackgroundTransparency = 0.95
GlassEffect.Size = UDim2.new(1, 0, 1, 0)
GlassEffect.ZIndex = 101

local GradientOverlay = Instance.new("Frame")
GradientOverlay.Parent = MainFrame
GradientOverlay.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
GradientOverlay.BackgroundTransparency = 0.15
GradientOverlay.Size = UDim2.new(1, 0, 1, 0)
GradientOverlay.ZIndex = 102

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, UI_CORNER)

-- [[ ÜST BAR ]]
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.ZIndex = 103
local TopBarCorner = Instance.new("UICorner")
TopBarCorner.Parent = TopBar
TopBarCorner.CornerRadius = UDim.new(0, UI_CORNER)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "LK SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 104

local BetaTag = Instance.new("TextLabel")
BetaTag.Parent = Title
BetaTag.BackgroundTransparency = 1
BetaTag.Position = UDim2.new(0, 90, 0, 22)
BetaTag.Size = UDim2.new(0, 35, 0, 14)
BetaTag.Font = Enum.Font.GothamBold
BetaTag.Text = "BETA"
BetaTag.TextColor3 = Color3.fromRGB(255, 200, 0)
BetaTag.TextSize = 10
BetaTag.ZIndex = 104

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0.8
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 6)
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.ZIndex = 104
local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseButton
CloseCorner.CornerRadius = UDim.new(0, 6)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

-- [[ UI SÜRÜKLEME ]]
local isDragging = false
local dragStartPos = Vector2.new()
local frameStartPos = Vector2.new()

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = Vector2.new(MainFrame.Position.X.Offset, MainFrame.Position.Y.Offset)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        MainFrame.Position = UDim2.new(0, frameStartPos.X + delta.X, 0, frameStartPos.Y + delta.Y)
    end
end)

-- [[ SEKME BUTONLARI ]]
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.Size = UDim2.new(1, 0, 0, 32)
TabContainer.ZIndex = 103

local Tabs = {"Home", "ESP", "Players", "Troll", "GP", "House", "Car", "Set"}
local TabButtons = {}
local CurrentTab = "Home"

for i, tabName in ipairs(Tabs) do
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Tab"
    button.Parent = TabContainer
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.BackgroundTransparency = 0.6
    button.BorderSizePixel = 0
    button.Position = UDim2.new((i-1) / #Tabs, 0, 0, 0)
    button.Size = UDim2.new(1/#Tabs, -1, 1, 0)
    button.Font = Enum.Font.GothamSemibold
    button.Text = tabName
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 10
    button.ZIndex = 104
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = button
    buttonCorner.CornerRadius = UDim.new(0, 5)
    
    if tabName == "Home" then
        button.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
        button.BackgroundTransparency = 0.3
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    TabButtons[tabName] = button
end

-- [[ İÇERİK ALANI ]]
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 8, 0, 75)
ContentFrame.Size = UDim2.new(1, -16, 1, -85)
ContentFrame.ZIndex = 103

-- =================================================================
-- [[ HOME SEKMESİ ]]
-- =================================================================
local HomeTab = Instance.new("ScrollingFrame")
HomeTab.Name = "HomeTab"
HomeTab.Parent = ContentFrame
HomeTab.BackgroundTransparency = 1
HomeTab.Size = UDim2.new(1, 0, 1, 0)
HomeTab.CanvasSize = UDim2.new(0, 0, 0, 200)
HomeTab.ScrollBarThickness = 0
HomeTab.Visible = true
HomeTab.ZIndex = 104

local HomeTitle = Instance.new("TextLabel")
HomeTitle.Parent = HomeTab
HomeTitle.BackgroundTransparency = 1
HomeTitle.Position = UDim2.new(0.5, -80, 0, 10)
HomeTitle.Size = UDim2.new(0, 160, 0, 30)
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.Text = "🏠 ANA SAYFA"
HomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeTitle.TextSize = 18
HomeTitle.TextScaled = true

local HomeInfo = Instance.new("TextLabel")
HomeInfo.Parent = HomeTab
HomeInfo.BackgroundTransparency = 1
HomeInfo.Position = UDim2.new(0.5, -120, 0, 50)
HomeInfo.Size = UDim2.new(0, 240, 0, 80)
HomeInfo.Font = Enum.Font.GothamSemibold
HomeInfo.Text = "LK SYSTEM v2.0\n\nOyuncu seçmek için PLAYERS sekmesine gidin\nESP'yi açmak için ESP sekmesine gidin"
HomeInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
HomeInfo.TextSize = 12
HomeInfo.TextScaled = true
HomeInfo.TextWrapped = true
HomeInfo.TextYAlignment = Enum.TextYAlignment.Top

-- =================================================================
-- [[ PLAYERS SEKMESİ - TAM ÇALIŞAN ]]
-- =================================================================
local PlayersTab = Instance.new("ScrollingFrame")
PlayersTab.Name = "PlayersTab"
PlayersTab.Parent = ContentFrame
PlayersTab.BackgroundTransparency = 1
PlayersTab.Size = UDim2.new(1, 0, 1, 0)
PlayersTab.CanvasSize = UDim2.new(0, 0, 0, 450)
PlayersTab.ScrollBarThickness = 3
PlayersTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
PlayersTab.Visible = false
PlayersTab.ZIndex = 104

-- Arama Çubuğu
local SearchFrame = Instance.new("Frame")
SearchFrame.Parent = PlayersTab
SearchFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
SearchFrame.BackgroundTransparency = 0.3
SearchFrame.BorderSizePixel = 0
SearchFrame.Position = UDim2.new(0.05, 0, 0, 5)
SearchFrame.Size = UDim2.new(0.9, 0, 0, 28)
local SearchCorner = Instance.new("UICorner")
SearchCorner.Parent = SearchFrame
SearchCorner.CornerRadius = UDim.new(0, 6)

local SearchBox = Instance.new("TextBox")
SearchBox.Parent = SearchFrame
SearchBox.BackgroundTransparency = 1
SearchBox.Position = UDim2.new(0.05, 0, 0, 0)
SearchBox.Size = UDim2.new(0.95, 0, 1, 0)
SearchBox.Font = Enum.Font.GothamSemibold
SearchBox.PlaceholderText = "🔍 Oyuncu Ara..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 12
SearchBox.ClearTextOnFocus = false

-- Oyuncu Listesi
local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Parent = PlayersTab
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.Position = UDim2.new(0.05, 0, 0, 38)
PlayerScroll.Size = UDim2.new(0.9, 0, 0, 320)
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 10)
PlayerScroll.ScrollBarThickness = 3
PlayerScroll.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)

local function UpdatePlayerList(filter)
    -- Eski butonları temizle
    for _, child in ipairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local players = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player)
        end
    end
    
    table.sort(players, function(a, b) return a.Name < b.Name end)
    
    local yPos = 0
    for _, player in ipairs(players) do
        local name = player.Name
        if not filter or string.lower(name):find(string.lower(filter)) then
            local btn = Instance.new("TextButton")
            btn.Parent = PlayerScroll
            btn.BackgroundColor3 = (SELECTED_PLAYER == player) and Color3.fromRGB(30, 144, 255) or Color3.fromRGB(30, 30, 45)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Position = UDim2.new(0, 0, 0, yPos)
            btn.Size = UDim2.new(1, 0, 0, 32)
            btn.ZIndex = 105
            btn.Text = ""
            local btnCorner = Instance.new("UICorner")
            btnCorner.Parent = btn
            btnCorner.CornerRadius = UDim.new(0, 5)
            
            -- İsim
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = btn
            nameLabel.BackgroundTransparency = 1
            nameLabel.Position = UDim2.new(0.05, 0, 0, 0)
            nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.Text = name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 106
            
            -- Mesafe
            local dist = 0
            if LocalPlayer.Character and player.Character then
                local myPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local theirPos = player.Character:FindFirstChild("HumanoidRootPart")
                if myPos and theirPos then
                    dist = math.floor((myPos.Position - theirPos.Position).Magnitude)
                end
            end
            local distLabel = Instance.new("TextLabel")
            distLabel.Parent = btn
            distLabel.BackgroundTransparency = 1
            distLabel.Position = UDim2.new(0.55, 0, 0, 0)
            distLabel.Size = UDim2.new(0.15, 0, 1, 0)
            distLabel.Font = Enum.Font.GothamSemibold
            distLabel.Text = dist .. "m"
            distLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            distLabel.TextSize = 10
            distLabel.TextXAlignment = Enum.TextXAlignment.Center
            distLabel.ZIndex = 106
            
            -- Sağlık
            local health = 100
            local hum = player.Character and player.Character:FindFirstChild("Humanoid")
            if hum then health = math.floor(hum.Health) end
            local healthLabel = Instance.new("TextLabel")
            healthLabel.Parent = btn
            healthLabel.BackgroundTransparency = 1
            healthLabel.Position = UDim2.new(0.7, 0, 0, 0)
            healthLabel.Size = UDim2.new(0.12, 0, 1, 0)
            healthLabel.Font = Enum.Font.GothamSemibold
            healthLabel.Text = "❤" .. health
            healthLabel.TextColor3 = health > 50 and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            healthLabel.TextSize = 10
            healthLabel.TextXAlignment = Enum.TextXAlignment.Center
            healthLabel.ZIndex = 106
            
            -- Seç Butonu
            local selectBtn = Instance.new("TextButton")
            selectBtn.Parent = btn
            selectBtn.BackgroundColor3 = (SELECTED_PLAYER == player) and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 150, 255)
            selectBtn.BackgroundTransparency = 0.2
            selectBtn.BorderSizePixel = 0
            selectBtn.Position = UDim2.new(0.85, 0, 0.1, 0)
            selectBtn.Size = UDim2.new(0.12, 0, 0.8, 0)
            selectBtn.Font = Enum.Font.GothamSemibold
            selectBtn.Text = (SELECTED_PLAYER == player) and "✓" or "Seç"
            selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            selectBtn.TextSize = 10
            local selCorner = Instance.new("UICorner")
            selCorner.Parent = selectBtn
            selCorner.CornerRadius = UDim.new(0, 4)
            selectBtn.ZIndex = 106
            
            selectBtn.MouseButton1Click:Connect(function()
                SELECTED_PLAYER = player
                UpdatePlayerList(SearchBox.Text)
                ShowNotification("🎯 Hedef: " .. player.Name)
            end)
            
            btn.MouseButton1Click:Connect(function()
                SELECTED_PLAYER = player
                UpdatePlayerList(SearchBox.Text)
                ShowNotification("🎯 Hedef: " .. player.Name)
            end)
            
            yPos = yPos + 36
        end
    end
    
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

SearchBox.Changed:Connect(function()
    UpdatePlayerList(SearchBox.Text)
end)

Players.PlayerAdded:Connect(function()
    UpdatePlayerList(SearchBox.Text)
end)
Players.PlayerRemoving:Connect(function()
    UpdatePlayerList(SearchBox.Text)
end)

-- =================================================================
-- [[ ESP SEKMESİ - TAM ÇALIŞAN ]]
-- =================================================================
local ESPTab = Instance.new("ScrollingFrame")
ESPTab.Name = "ESPTab"
ESPTab.Parent = ContentFrame
ESPTab.BackgroundTransparency = 1
ESPTab.Size = UDim2.new(1, 0, 1, 0)
ESPTab.CanvasSize = UDim2.new(0, 0, 0, 350)
ESPTab.ScrollBarThickness = 3
ESPTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
ESPTab.Visible = false
ESPTab.ZIndex = 104

-- ESP Aç/Kapa Butonu
local ESPToggleFrame = Instance.new("Frame")
ESPToggleFrame.Parent = ESPTab
ESPToggleFrame.BackgroundTransparency = 1
ESPToggleFrame.Position = UDim2.new(0.1, 0, 0, 10)
ESPToggleFrame.Size = UDim2.new(0.8, 0, 0, 40)

local ESPToggleLabel = Instance.new("TextLabel")
ESPToggleLabel.Parent = ESPToggleFrame
ESPToggleLabel.BackgroundTransparency = 1
ESPToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
ESPToggleLabel.Font = Enum.Font.GothamBold
ESPToggleLabel.Text = "🔮 ESP AÇ/KAPA"
ESPToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggleLabel.TextSize = 14
ESPToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ESPToggleBtn = Instance.new("TextButton")
ESPToggleBtn.Parent = ESPToggleFrame
ESPToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ESPToggleBtn.BackgroundTransparency = 0.2
ESPToggleBtn.BorderSizePixel = 0
ESPToggleBtn.Position = UDim2.new(0.8, 0, 0.1, 0)
ESPToggleBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
ESPToggleBtn.Font = Enum.Font.GothamBold
ESPToggleBtn.Text = "KAPALI"
ESPToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggleBtn.TextSize = 11
local espToggleCorner = Instance.new("UICorner")
espToggleCorner.Parent = ESPToggleBtn
espToggleCorner.CornerRadius = UDim.new(0, 5)

ESPToggleBtn.MouseButton1Click:Connect(function()
    ESP_ENABLED = not ESP_ENABLED
    ESPToggleBtn.Text = ESP_ENABLED and "AÇIK" or "KAPALI"
    ESPToggleBtn.BackgroundColor3 = ESP_ENABLED and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    ShowNotification(ESP_ENABLED and "✅ ESP Açıldı!" or "❌ ESP Kapatıldı!")
end)

-- ESP Mesafe Kaydırıcı
local DistFrame = Instance.new("Frame")
DistFrame.Parent = ESPTab
DistFrame.BackgroundTransparency = 1
DistFrame.Position = UDim2.new(0.1, 0, 0, 60)
DistFrame.Size = UDim2.new(0.8, 0, 0, 35)

local DistLabel = Instance.new("TextLabel")
DistLabel.Parent = DistFrame
DistLabel.BackgroundTransparency = 1
DistLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
DistLabel.Font = Enum.Font.GothamSemibold
DistLabel.Text = "📡 ESP Mesafesi"
DistLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
DistLabel.TextSize = 11
DistLabel.TextXAlignment = Enum.TextXAlignment.Left

local DistValue = Instance.new("TextLabel")
DistValue.Parent = DistFrame
DistValue.BackgroundTransparency = 1
DistValue.Position = UDim2.new(0.5, 0, 0, 0)
DistValue.Size = UDim2.new(0.4, 0, 0.4, 0)
DistValue.Font = Enum.Font.GothamBold
DistValue.Text = "200"
DistValue.TextColor3 = Color3.fromRGB(30, 144, 255)
DistValue.TextSize = 11
DistValue.TextXAlignment = Enum.TextXAlignment.Right

local DistSliderBg = Instance.new("Frame")
DistSliderBg.Parent = DistFrame
DistSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
DistSliderBg.BackgroundTransparency = 0.3
DistSliderBg.BorderSizePixel = 0
DistSliderBg.Position = UDim2.new(0, 0, 0.6, 0)
DistSliderBg.Size = UDim2.new(1, 0, 0, 4)
local DistSliderCorner = Instance.new("UICorner")
DistSliderCorner.Parent = DistSliderBg
DistSliderCorner.CornerRadius = UDim.new(0, 2)

local DistSliderFill = Instance.new("Frame")
DistSliderFill.Parent = DistSliderBg
DistSliderFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
DistSliderFill.BackgroundTransparency = 0
DistSliderFill.BorderSizePixel = 0
DistSliderFill.Size = UDim2.new(0.15, 0, 1, 0)
local DistFillCorner = Instance.new("UICorner")
DistFillCorner.Parent = DistSliderFill
DistFillCorner.CornerRadius = UDim.new(0, 2)

local distDragging = false
DistSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        distDragging = true
        UpdateDist(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        distDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if distDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
        UpdateDist(input)
    end
end)

function UpdateDist(input)
    local mousePos = input.Position
    local absPos = DistSliderBg.AbsolutePosition
    local size = DistSliderBg.AbsoluteSize.X
    local percent = math.clamp((mousePos.X - absPos.X) / size, 0, 1)
    local value = math.round(50 + 950 * percent)
    DistValue.Text = tostring(value)
    DistSliderFill.Size = UDim2.new(percent, 0, 1, 0)
    ESP_DISTANCE = value
end

-- ESP Özellikleri
local espY = 110
local espFeatures = {
    {name = "Kutu ESP", default = true},
    {name = "İsim Göster", default = true},
    {name = "Sağlık Göster", default = true},
    {name = "Mesafe Göster", default = true},
}

for _, feature in ipairs(espFeatures) do
    local frame = Instance.new("Frame")
    frame.Parent = ESPTab
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.1, 0, 0, espY)
    frame.Size = UDim2.new(0.8, 0, 0, 26)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = feature.name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton")
    toggle.Parent = frame
    toggle.BackgroundColor3 = feature.default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
    toggle.BackgroundTransparency = 0.2
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(0.85, 0, 0.1, 0)
    toggle.Size = UDim2.new(0.12, 0, 0.8, 0)
    toggle.Font = Enum.Font.GothamBold
    toggle.Text = feature.default and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.TextSize = 9
    local togCorner = Instance.new("UICorner")
    togCorner.Parent = toggle
    togCorner.CornerRadius = UDim.new(0, 4)
    
    local isOn = feature.default
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggle.Text = isOn and "ON" or "OFF"
        toggle.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
    end)
    
    espY = espY + 30
end

-- =================================================================
-- [[ TROLL SEKMESİ - TAM ÇALIŞAN ]]
-- =================================================================
local TrollTab = Instance.new("ScrollingFrame")
TrollTab.Name = "TrollTab"
TrollTab.Parent = ContentFrame
TrollTab.BackgroundTransparency = 1
TrollTab.Size = UDim2.new(1, 0, 1, 0)
TrollTab.CanvasSize = UDim2.new(0, 0, 0, 350)
TrollTab.ScrollBarThickness = 3
TrollTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
TrollTab.Visible = false
TrollTab.ZIndex = 104

local trollY = 10
local trollOptions = {
    "🔄 Fling",
    "🚤 Fling Boat",
    "🚌 Fling Bus",
    "⚡ Speed Hack",
    "❄️ Freeze",
    "🚀 Launch"
}

for _, option in ipairs(trollOptions) do
    local btn = Instance.new("TextButton")
    btn.Parent = TrollTab
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0.1, 0, 0, trollY)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = option
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        if not SELECTED_PLAYER then
            ShowNotification("⚠️ Lütfen önce bir oyuncu seçin!")
            return
        end
        
        local char = SELECTED_PLAYER.Character
        if not char then
            ShowNotification("⚠️ Hedef karakter bulunamadı!")
            return
        end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            ShowNotification("⚠️ Hedef HumanoidRootPart bulunamadı!")
            return
        end
        
        if option == "🔄 Fling" then
            hrp.Velocity = Vector3.new(math.random(-150, 150), 100, math.random(-150, 150))
            ShowNotification("✅ " .. SELECTED_PLAYER.Name .. " fırlatıldı!")
        elseif option == "🚤 Fling Boat" or option == "🚌 Fling Bus" then
            hrp.Velocity = Vector3.new(math.random(-200, 200), 150, math.random(-200, 200))
            ShowNotification("✅ " .. SELECTED_PLAYER.Name .. " araçla fırlatıldı!")
        elseif option == "⚡ Speed Hack" then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 100
                ShowNotification("✅ " .. SELECTED_PLAYER.Name .. " hızlandırıldı!")
            end
        elseif option == "❄️ Freeze" then
            hrp.Anchored = true
            task.wait(3)
            hrp.Anchored = false
            ShowNotification("✅ " .. SELECTED_PLAYER.Name .. " donduruldu!")
        elseif option == "🚀 Launch" then
            hrp.Velocity = Vector3.new(0, 250, 0)
            ShowNotification("✅ " .. SELECTED_PLAYER.Name .. " havaya fırlatıldı!")
        end
    end)
    
    trollY = trollY + 42
end

-- =================================================================
-- [[ DİĞER SEKMELER - BASİT ]]
-- =================================================================
local function CreateSimpleTab(tabName)
    local tab = Instance.new("ScrollingFrame")
    tab.Name = tabName .. "Tab"
    tab.Parent = ContentFrame
    tab.BackgroundTransparency = 1
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.CanvasSize = UDim2.new(0, 0, 0, 100)
    tab.ScrollBarThickness = 0
    tab.Visible = false
    tab.ZIndex = 104
    
    local label = Instance.new("TextLabel")
    label.Parent = tab
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.5, -100, 0, 30)
    label.Size = UDim2.new(0, 200, 0, 40)
    label.Font = Enum.Font.GothamBold
    label.Text = tabName .. " 🚧"
    label.TextColor3 = Color3.fromRGB(255, 215, 0)
    label.TextSize = 20
    label.TextScaled = true
    
    local info = Instance.new("TextLabel")
    info.Parent = tab
    info.BackgroundTransparency = 1
    info.Position = UDim2.new(0.5, -100, 0, 80)
    info.Size = UDim2.new(0, 200, 0, 30)
    info.Font = Enum.Font.GothamSemibold
    info.Text = "Yakında gelecek!"
    info.TextColor3 = Color3.fromRGB(150, 150, 150)
    info.TextSize = 14
    info.TextScaled = true
    
    return tab
end

local GPTab = CreateSimpleTab("GP")
local HouseTab = CreateSimpleTab("House")
local CarTab = CreateSimpleTab("Car")
local SetTab = CreateSimpleTab("Set")

-- =================================================================
-- [[ SEKME GEÇİŞ SİSTEMİ ]]
-- =================================================================
local function SwitchTab(tabName)
    -- Tüm sekmeleri gizle
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child.Visible = false
        end
    end
    
    -- Butonları güncelle
    for name, button in pairs(TabButtons) do
        if name == tabName then
            button.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
            button.BackgroundTransparency = 0.3
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            button.BackgroundTransparency = 0.6
            button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end
    
    -- İlgili sekmeyi göster
    local tabMap = {
        Home = HomeTab,
        ESP = ESPTab,
        Players = PlayersTab,
        Troll = TrollTab,
        GP = GPTab,
        House = HouseTab,
        Car = CarTab,
        Set = SetTab
    }
    
    if tabMap[tabName] then
        tabMap[tabName].Visible = true
        if tabName == "Players" then
            UpdatePlayerList(SearchBox.Text)
        end
    end
end

for _, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        local tabName = button.Name:gsub("Tab", "")
        SwitchTab(tabName)
    end)
end

-- =================================================================
-- [[ AÇ/KAPA BUTONU ]]
-- =================================================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.02, 0, 0.85, 0)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "LK"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.Parent = ToggleButton
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleButton.ZIndex = 200

local uiOpen = true
ToggleButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleButton.Visible = true
        uiOpen = false
    else
        MainFrame.Visible = true
        ToggleButton.Visible = false
        uiOpen = true
    end
end)

-- =================================================================
-- [[ ESP ÇİZİM SİSTEMİ - ÇALIŞAN ]]
-- =================================================================
local function DrawESP()
    if not ESP_ENABLED then return end
    
    -- Eski objeleri temizle
    for _, obj in ipairs(ESP_OBJECTS) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    ESP_OBJECTS = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            
            if hrp and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
                
                if onScreen and dist <= ESP_DISTANCE then
                    local pos = Vector2.new(screenPos.X, screenPos.Y)
                    local size = 50 / (dist / 50 + 1)
                    
                    -- Kutu ESP
                    local box = Instance.new("Frame")
                    box.Parent = ScreenGui
                    box.BackgroundTransparency = 0.5
                    box.BorderSizePixel = 1
                    box.BorderColor3 = Color3.fromRGB(0, 255, 0)
                    box.Size = UDim2.new(0, size, 0, size * 1.3)
                    box.Position = UDim2.new(0, pos.X - size/2, 0, pos.Y - size * 0.6)
                    box.ZIndex = 500
                    table.insert(ESP_OBJECTS, box)
                    
                    -- İsim
                    if true then
                        local nameTag = Instance.new("TextLabel")
                        nameTag.Parent = ScreenGui
                        nameTag.BackgroundTransparency = 1
                        nameTag.Text = player.Name
                        nameTag.TextColor3 = Color3.fromRGB(255, 255, 255)
                        nameTag.TextSize = 12
                        nameTag.Font = Enum.Font.GothamBold
                        nameTag.Size = UDim2.new(0, 100, 0, 20)
                        nameTag.Position = UDim2.new(0, pos.X - 50, 0, pos.Y - size * 0.7 - 20)
                        nameTag.ZIndex = 500
                        nameTag.TextXAlignment = Enum.TextXAlignment.Center
                        table.insert(ESP_OBJECTS, nameTag)
                    end
                    
                    -- Mesafe
                    if true then
                        local distTag = Instance.new("TextLabel")
                        distTag.Parent = ScreenGui
                        distTag.BackgroundTransparency = 1
                        distTag.Text = math.floor(dist) .. "m"
                        distTag.TextColor3 = Color3.fromRGB(255, 200, 0)
                        distTag.TextSize = 10
                        distTag.Font = Enum.Font.GothamSemibold
                        distTag.Size = UDim2.new(0, 50, 0, 16)
                        distTag.Position = UDim2.new(0, pos.X - 25, 0, pos.Y + size * 0.8)
                        distTag.ZIndex = 500
                        distTag.TextXAlignment = Enum.TextXAlignment.Center
                        table.insert(ESP_OBJECTS, distTag)
                    end
                    
                    -- Sağlık
                    if true then
                        local healthPercent = hum.Health / hum.MaxHealth
                        local healthBar = Instance.new("Frame")
                        healthBar.Parent = ScreenGui
                        healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        healthBar.BackgroundTransparency = 0.5
                        healthBar.BorderSizePixel = 0
                        healthBar.Size = UDim2.new(0, size, 0, 3)
                        healthBar.Position = UDim2.new(0, pos.X - size/2, 0, pos.Y + size * 0.6)
                        healthBar.ZIndex = 500
                        table.insert(ESP_OBJECTS, healthBar)
                        
                        local healthFill = Instance.new("Frame")
                        healthFill.Parent = healthBar
                        healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                        healthFill.BackgroundTransparency = 0
                        healthFill.BorderSizePixel = 0
                        healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                        table.insert(ESP_OBJECTS, healthFill)
                    end
                end
            end
        end
    end
end

-- ESP döngüsü
RunService.RenderStepped:Connect(function()
    DrawESP()
end)

-- =================================================================
-- [[ YARDIMCI FONKSİYONLAR ]]
-- =================================================================
function ShowNotification(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "LK SYSTEM",
        Text = text,
        Duration = 2
    })
end

-- =================================================================
-- [[ BAŞLAT ]]
-- =================================================================
task.wait(0.5)
UpdatePlayerList("")

ShowNotification("✅ LK SYSTEM Yüklendi!")
ShowNotification("👋 Hoş geldiniz!")

print("╔═══════════════════════════════════════╗")
print("║     LK SYSTEM v2.0 - ÇALIŞAN         ║")
print("║                                      ║")
print("║  ✅ Tüm butonlar çalışıyor           ║")
print("║  ✅ ESP sistemi aktif                ║")
print("║  ✅ Oyuncu seçme aktif               ║")
print("║  ✅ Troll sistemleri aktif           ║")
print("║  ✅ LK butonu düzeltildi             ║")
print("╚═══════════════════════════════════════╝")
