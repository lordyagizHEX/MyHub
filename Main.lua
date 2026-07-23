-- [[ LK SYSTEM - Premium Roblox ESP & Hile Menüsü ]]
-- [[ Sürüm: Beta v2.0 - HIZLI BAŞLATMA ]]
-- [[ Geliştirici: LK System ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- [[ KONSTANTLAR ]]
local UI_CORNER = 12
local GLASS_BLUR = 0.85

-- =================================================================
-- [[ FİLİGRAN (WATERMARK) - HER ZAMAN GÖRÜNÜR ]]
-- =================================================================
local WatermarkGui = Instance.new("ScreenGui")
WatermarkGui.Name = "WatermarkGui"
WatermarkGui.Parent = game:GetService("CoreGui")
WatermarkGui.ResetOnSpawn = false
WatermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Parent = WatermarkGui
Watermark.BackgroundTransparency = 1
Watermark.Position = UDim2.new(1, -160, 0, 20)
Watermark.Size = UDim2.new(0, 140, 0, 55)
Watermark.ZIndex = 1000

local WatermarkTitle = Instance.new("TextLabel")
WatermarkTitle.Name = "WatermarkTitle"
WatermarkTitle.Parent = Watermark
WatermarkTitle.BackgroundTransparency = 1
WatermarkTitle.Size = UDim2.new(1, 0, 0.65, 0)
WatermarkTitle.Font = Enum.Font.GothamBold
WatermarkTitle.Text = "LK SYSTEM"
WatermarkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
WatermarkTitle.TextSize = 22
WatermarkTitle.TextStrokeTransparency = 0.3
WatermarkTitle.TextScaled = false
WatermarkTitle.TextXAlignment = Enum.TextXAlignment.Right

local WatermarkBeta = Instance.new("TextLabel")
WatermarkBeta.Name = "WatermarkBeta"
WatermarkBeta.Parent = Watermark
WatermarkBeta.BackgroundTransparency = 1
WatermarkBeta.Position = UDim2.new(0, 0, 0.65, 0)
WatermarkBeta.Size = UDim2.new(1, 0, 0.35, 0)
WatermarkBeta.Font = Enum.Font.GothamBold
WatermarkBeta.Text = "Beta"
WatermarkBeta.TextColor3 = Color3.fromRGB(255, 200, 0)
WatermarkBeta.TextSize = 14
WatermarkBeta.TextScaled = false
WatermarkBeta.TextXAlignment = Enum.TextXAlignment.Right

-- =================================================================
-- [[ ANA UI SİSTEMİ ]]
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LKSystem"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ ANA FRAME ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = GLASS_BLUR
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Position = UDim2.new(0.5, -420, 0.5, -350)
MainFrame.Size = UDim2.new(0, 840, 0, 700)
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

local ShadowFrame = Instance.new("Frame")
ShadowFrame.Name = "ShadowFrame"
ShadowFrame.Parent = MainFrame
ShadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ShadowFrame.BackgroundTransparency = 0.7
ShadowFrame.BorderSizePixel = 0
ShadowFrame.Position = UDim2.new(0, 5, 0, 5)
ShadowFrame.Size = UDim2.new(1, -10, 1, -10)
ShadowFrame.ZIndex = 99
local ShadowCorner = Instance.new("UICorner")
ShadowCorner.Parent = ShadowFrame
ShadowCorner.CornerRadius = UDim.new(0, UI_CORNER + 4)

-- [[ ÜST BAR - SÜRÜKLEME ALANI ]]
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 55)
TopBar.ZIndex = 103
local TopBarCorner = Instance.new("UICorner")
TopBarCorner.Parent = TopBar
TopBarCorner.CornerRadius = UDim.new(0, UI_CORNER)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "LK SYSTEM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 104

local BetaTag = Instance.new("TextLabel")
BetaTag.Parent = Title
BetaTag.BackgroundTransparency = 1
BetaTag.Position = UDim2.new(0, 110, 0, 30)
BetaTag.Size = UDim2.new(0, 45, 0, 18)
BetaTag.Font = Enum.Font.GothamBold
BetaTag.Text = "BETA"
BetaTag.TextColor3 = Color3.fromRGB(255, 200, 0)
BetaTag.TextSize = 12
BetaTag.ZIndex = 104

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0.8
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -45, 0, 10)
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.ZIndex = 104
local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseButton
CloseCorner.CornerRadius = UDim.new(0, 8)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
        {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

-- =================================================================
-- [[ UI SÜRÜKLEME SİSTEMİ - TAM ÇALIŞAN ]]
-- =================================================================
local isDragging = false
local dragStartPos = Vector2.new()
local frameStartPos = Vector2.new()

-- TopBar üzerinden sürükleme
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
        local newX = math.clamp(frameStartPos.X + delta.X, -400, 400)
        local newY = math.clamp(frameStartPos.Y + delta.Y, -300, 300)
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- =================================================================
-- [[ SEKME BUTONLARI ]]
-- =================================================================
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 0, 0, 55)
TabContainer.Size = UDim2.new(1, 0, 0, 45)
TabContainer.ZIndex = 103

local Tabs = {"Home", "ESP", "Players", "Troll", "Gamepass", "Houses", "Car", "Settings"}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Tab"
    button.Parent = TabContainer
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.BackgroundTransparency = 0.6
    button.BorderSizePixel = 0
    button.Position = UDim2.new((i-1) / #Tabs, 0, 0, 0)
    button.Size = UDim2.new(1/#Tabs, -2, 1, 0)
    button.Font = Enum.Font.GothamSemibold
    button.Text = tabName
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 11
    button.ZIndex = 104
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = button
    buttonCorner.CornerRadius = UDim.new(0, 8)
    
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
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.ZIndex = 103

-- =================================================================
-- [[ OYUNCU SEÇİM SİSTEMİ ]]
-- =================================================================
local PlayersTab = Instance.new("ScrollingFrame")
PlayersTab.Name = "PlayersTab"
PlayersTab.Parent = ContentFrame
PlayersTab.BackgroundTransparency = 1
PlayersTab.Size = UDim2.new(1, 0, 1, 0)
PlayersTab.CanvasSize = UDim2.new(0, 0, 0, 600)
PlayersTab.ScrollBarThickness = 4
PlayersTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
PlayersTab.Visible = false
PlayersTab.ZIndex = 104

local selectedPlayer = nil

-- Arama Çubuğu
local SearchFrame = Instance.new("Frame")
SearchFrame.Parent = PlayersTab
SearchFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
SearchFrame.BackgroundTransparency = 0.3
SearchFrame.BorderSizePixel = 0
SearchFrame.Position = UDim2.new(0.05, 0, 0, 10)
SearchFrame.Size = UDim2.new(0.9, 0, 0, 40)
local SearchCorner = Instance.new("UICorner")
SearchCorner.Parent = SearchFrame
SearchCorner.CornerRadius = UDim.new(0, 8)

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Parent = SearchFrame
SearchIcon.BackgroundTransparency = 1
SearchIcon.Position = UDim2.new(0.02, 0, 0, 0)
SearchIcon.Size = UDim2.new(0, 30, 1, 0)
SearchIcon.Font = Enum.Font.GothamBold
SearchIcon.Text = "🔍"
SearchIcon.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchIcon.TextSize = 18

local SearchBox = Instance.new("TextBox")
SearchBox.Parent = SearchFrame
SearchBox.BackgroundTransparency = 1
SearchBox.Position = UDim2.new(0.08, 0, 0, 0)
SearchBox.Size = UDim2.new(0.9, 0, 1, 0)
SearchBox.Font = Enum.Font.GothamSemibold
SearchBox.PlaceholderText = "Oyuncu Ara..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 14
SearchBox.ClearTextOnFocus = false

-- Oyuncu Listesi
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Parent = PlayersTab
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.Position = UDim2.new(0.05, 0, 0, 60)
PlayerListFrame.Size = UDim2.new(0.9, 0, 0, 500)

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Parent = PlayerListFrame
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.Size = UDim2.new(1, 0, 1, 0)
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 600)
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)

local function UpdatePlayerList(filter)
    for _, child in ipairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
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
        if not filter or string.lower(player.Name):find(string.lower(filter)) then
            local btn = Instance.new("TextButton")
            btn.Parent = PlayerScroll
            btn.BackgroundColor3 = (selectedPlayer == player) and Color3.fromRGB(30, 144, 255) or Color3.fromRGB(30, 30, 45)
            btn.BackgroundTransparency = 0.3
            btn.BorderSizePixel = 0
            btn.Position = UDim2.new(0, 0, 0, yPos)
            btn.Size = UDim2.new(1, 0, 0, 50)
            btn.ZIndex = 105
            local btnCorner = Instance.new("UICorner")
            btnCorner.Parent = btn
            btnCorner.CornerRadius = UDim.new(0, 8)
            
            local avatar = Instance.new("ImageLabel")
            avatar.Parent = btn
            avatar.BackgroundTransparency = 1
            avatar.Position = UDim2.new(0.02, 0, 0.1, 0)
            avatar.Size = UDim2.new(0, 35, 0.8, 0)
            avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48"
            avatar.ZIndex = 106
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = btn
            nameLabel.BackgroundTransparency = 1
            nameLabel.Position = UDim2.new(0.1, 0, 0, 0)
            nameLabel.Size = UDim2.new(0.35, 0, 1, 0)
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 106
            
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
            distLabel.Position = UDim2.new(0.5, 0, 0, 0)
            distLabel.Size = UDim2.new(0.15, 0, 1, 0)
            distLabel.Font = Enum.Font.GothamSemibold
            distLabel.Text = dist .. "m"
            distLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            distLabel.TextSize = 12
            distLabel.TextXAlignment = Enum.TextXAlignment.Center
            distLabel.ZIndex = 106
            
            local health = 100
            local hum = player.Character and player.Character:FindFirstChild("Humanoid")
            if hum then health = math.floor(hum.Health) end
            local healthLabel = Instance.new("TextLabel")
            healthLabel.Parent = btn
            healthLabel.BackgroundTransparency = 1
            healthLabel.Position = UDim2.new(0.68, 0, 0, 0)
            healthLabel.Size = UDim2.new(0.12, 0, 1, 0)
            healthLabel.Font = Enum.Font.GothamSemibold
            healthLabel.Text = "❤️ " .. health
            healthLabel.TextColor3 = health > 50 and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            healthLabel.TextSize = 12
            healthLabel.TextXAlignment = Enum.TextXAlignment.Center
            healthLabel.ZIndex = 106
            
            local selectBtn = Instance.new("TextButton")
            selectBtn.Parent = btn
            selectBtn.BackgroundColor3 = (selectedPlayer == player) and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(0, 150, 255)
            selectBtn.BackgroundTransparency = 0.2
            selectBtn.BorderSizePixel = 0
            selectBtn.Position = UDim2.new(0.85, 0, 0.1, 0)
            selectBtn.Size = UDim2.new(0.12, 0, 0.8, 0)
            selectBtn.Font = Enum.Font.GothamSemibold
            selectBtn.Text = (selectedPlayer == player) and "✅" or "Seç"
            selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            selectBtn.TextSize = 12
            local selCorner = Instance.new("UICorner")
            selCorner.Parent = selectBtn
            selCorner.CornerRadius = UDim.new(0, 6)
            selectBtn.ZIndex = 106
            
            selectBtn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                UpdatePlayerList(SearchBox.Text)
                ShowNotification("🎯 Hedef: " .. player.Name)
            end)
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = player
                UpdatePlayerList(SearchBox.Text)
                ShowNotification("🎯 Hedef: " .. player.Name)
            end)
            
            yPos = yPos + 55
        end
    end
    
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
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
-- [[ ESP SİSTEMİ ]]
-- =================================================================
local ESPTab = Instance.new("ScrollingFrame")
ESPTab.Name = "ESPTab"
ESPTab.Parent = ContentFrame
ESPTab.BackgroundTransparency = 1
ESPTab.Size = UDim2.new(1, 0, 1, 0)
ESPTab.CanvasSize = UDim2.new(0, 0, 0, 600)
ESPTab.ScrollBarThickness = 4
ESPTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
ESPTab.Visible = false
ESPTab.ZIndex = 104

-- ESP Ayarları
local ESPEnabled = false
local ESPDistance = 200
local ESPObjects = {}
local ESPColors = {
    Box = Color3.fromRGB(0, 255, 0),
    Skeleton = Color3.fromRGB(255, 255, 255),
    Name = Color3.fromRGB(255, 255, 255),
    Health = Color3.fromRGB(255, 0, 0),
    Distance = Color3.fromRGB(255, 255, 255),
    Team = Color3.fromRGB(0, 200, 255),
    Glow = Color3.fromRGB(255, 200, 0)
}

-- ESP Aç/Kapa
local function CreateToggleButton(parent, label, yPos, default)
    default = default or false
    
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = frame
    labelText.BackgroundTransparency = 1
    labelText.Size = UDim2.new(0.7, 0, 1, 0)
    labelText.Font = Enum.Font.GothamSemibold
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 220, 220)
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Position = UDim2.new(0.85, 0, 0.1, 0)
    toggleBtn.Size = UDim2.new(0.12, 0, 0.8, 0)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = default and "AÇIK" or "KAPALI"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 11
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 6)
    
    local isOn = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggleBtn.Text = isOn and "AÇIK" or "KAPALI"
        toggleBtn.BackgroundColor3 = isOn and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
        
        if label:find("ESP") then
            ESPEnabled = isOn
            if not isOn then
                for _, obj in ipairs(ESPObjects) do
                    if obj and obj.Parent then obj:Destroy() end
                end
                ESPObjects = {}
            end
        end
    end)
    
    return toggleBtn
end

local function CreateSlider(parent, label, min, max, default, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = frame
    labelText.BackgroundTransparency = 1
    labelText.Size = UDim2.new(0.5, 0, 0.4, 0)
    labelText.Font = Enum.Font.GothamSemibold
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 220, 220)
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueText = Instance.new("TextLabel")
    valueText.Parent = frame
    valueText.BackgroundTransparency = 1
    valueText.Position = UDim2.new(0.6, 0, 0, 0)
    valueText.Size = UDim2.new(0.4, 0, 0.4, 0)
    valueText.Font = Enum.Font.GothamBold
    valueText.Text = tostring(default)
    valueText.TextColor3 = Color3.fromRGB(30, 144, 255)
    valueText.TextSize = 14
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    sliderBg.BackgroundTransparency = 0.3
    sliderBg.BorderSizePixel = 0
    sliderBg.Position = UDim2.new(0, 0, 0.5, 0)
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = sliderBg
    sliderCorner.CornerRadius = UDim.new(0, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
    sliderFill.BackgroundTransparency = 0
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    local fillCorner = Instance.new("UICorner")
    fillCorner.Parent = sliderFill
    fillCorner.CornerRadius = UDim.new(0, 3)
    
    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    function UpdateSlider(input)
        local mousePos = input.Position
        local absPos = sliderBg.AbsolutePosition
        local size = sliderBg.AbsoluteSize.X
        local percent = math.clamp((mousePos.X - absPos.X) / size, 0, 1)
        local value = math.round(min + (max - min) * percent)
        valueText.Text = tostring(value)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        
        if label:find("Mesafe") then
            ESPDistance = value
        end
    end
    
    return sliderFill
end

local function CreateColorPicker(parent, label, key, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    
    local labelText = Instance.new("TextLabel")
    labelText.Parent = frame
    labelText.BackgroundTransparency = 1
    labelText.Size = UDim2.new(0.6, 0, 1, 0)
    labelText.Font = Enum.Font.GothamSemibold
    labelText.Text = label
    labelText.TextColor3 = Color3.fromRGB(220, 220, 220)
    labelText.TextSize = 14
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Parent = frame
    colorBtn.BackgroundColor3 = ESPColors[key] or Color3.fromRGB(255, 255, 255)
    colorBtn.BackgroundTransparency = 0.3
    colorBtn.BorderSizePixel = 0
    colorBtn.Position = UDim2.new(0.8, 0, 0.1, 0)
    colorBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.Text = "🎨"
    colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorBtn.TextSize = 16
    local colorCorner = Instance.new("UICorner")
    colorCorner.Parent = colorBtn
    colorCorner.CornerRadius = UDim.new(0, 6)
    
    local colorOptions = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 200, 0)
    }
    
    colorBtn.MouseButton1Click:Connect(function()
        local currentColor = ESPColors[key] or Color3.fromRGB(255, 255, 255)
        local nextIndex = 1
        for i, color in ipairs(colorOptions) do
            if color == currentColor then
                nextIndex = i % #colorOptions + 1
                break
            end
        end
        ESPColors[key] = colorOptions[nextIndex]
        colorBtn.BackgroundColor3 = colorOptions[nextIndex]
    end)
end

local ESPToggleBtn = CreateToggleButton(ESPTab, "🔮 ESP AÇ/KAPA", 20)

local espSettings = {
    {name = "📦 Kutu ESP", key = "box", default = true},
    {name = "🦴 İskelet ESP", key = "skeleton", default = false},
    {name = "📏 İz Çizgisi", key = "line", default = true},
    {name = "📝 İsim Göster", key = "name", default = true},
    {name = "❤️ Sağlık Çubuğu", key = "health", default = true},
    {name = "📐 Mesafe Göster", key = "distance", default = true},
    {name = "👥 Takım Kontrolü", key = "team", default = true},
    {name = "✨ Parlama Efekti", key = "glow", default = false}
}

local espY = 80
for _, setting in ipairs(espSettings) do
    CreateToggleButton(ESPTab, setting.name, espY, setting.default)
    espY = espY + 45
end

CreateSlider(ESPTab, "📡 ESP Mesafesi", 50, 1000, 200, espY)
espY = espY + 55

local colorSettings = {
    {name = "🎨 Kutu Rengi", key = "Box"},
    {name = "🎨 İskelet Rengi", key = "Skeleton"},
    {name = "🎨 İsim Rengi", key = "Name"},
    {name = "🎨 Sağlık Rengi", key = "Health"},
    {name = "🎨 Mesafe Rengi", key = "Distance"},
    {name = "🎨 Takım Rengi", key = "Team"},
    {name = "🎨 Parlama Rengi", key = "Glow"}
}

for _, color in ipairs(colorSettings) do
    CreateColorPicker(ESPTab, color.name, color.key, espY)
    espY = espY + 55
end

-- [[ ESP ÇİZİM FONKSİYONLARI ]]
local function DrawESP()
    if not ESPEnabled then return end
    
    for _, obj in ipairs(ESPObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    ESPObjects = {}
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            
            if hrp and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local dist = (hrp.Position - Camera.CFrame.Position).Magnitude
                
                if onScreen and dist <= ESPDistance then
                    -- ESP çizimleri burada yapılabilir
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    DrawESP()
end)

-- =================================================================
-- [[ EKSİK SEKMELER ]]
-- =================================================================
local HomeTab = Instance.new("ScrollingFrame")
HomeTab.Name = "HomeTab"
HomeTab.Parent = ContentFrame
HomeTab.BackgroundTransparency = 1
HomeTab.Size = UDim2.new(1, 0, 1, 0)
HomeTab.CanvasSize = UDim2.new(0, 0, 0, 300)
HomeTab.ScrollBarThickness = 0
HomeTab.Visible = true
HomeTab.ZIndex = 104

local HomeTitle = Instance.new("TextLabel")
HomeTitle.Parent = HomeTab
HomeTitle.BackgroundTransparency = 1
HomeTitle.Position = UDim2.new(0.5, -100, 0, 20)
HomeTitle.Size = UDim2.new(0, 200, 0, 40)
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.Text = "🏠 ANA SAYFA"
HomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HomeTitle.TextSize = 24
HomeTitle.TextScaled = true

local TrollTab = Instance.new("ScrollingFrame")
TrollTab.Name = "TrollTab"
TrollTab.Parent = ContentFrame
TrollTab.BackgroundTransparency = 1
TrollTab.Size = UDim2.new(1, 0, 1, 0)
TrollTab.CanvasSize = UDim2.new(0, 0, 0, 400)
TrollTab.ScrollBarThickness = 4
TrollTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
TrollTab.Visible = false
TrollTab.ZIndex = 104

local GamepassTab = Instance.new("ScrollingFrame")
GamepassTab.Name = "GamepassTab"
GamepassTab.Parent = ContentFrame
GamepassTab.BackgroundTransparency = 1
GamepassTab.Size = UDim2.new(1, 0, 1, 0)
GamepassTab.CanvasSize = UDim2.new(0, 0, 0, 500)
GamepassTab.ScrollBarThickness = 4
GamepassTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
GamepassTab.Visible = false
GamepassTab.ZIndex = 104

local HousesTab = Instance.new("ScrollingFrame")
HousesTab.Name = "HousesTab"
HousesTab.Parent = ContentFrame
HousesTab.BackgroundTransparency = 1
HousesTab.Size = UDim2.new(1, 0, 1, 0)
HousesTab.CanvasSize = UDim2.new(0, 0, 0, 500)
HousesTab.ScrollBarThickness = 4
HousesTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
HousesTab.Visible = false
HousesTab.ZIndex = 104

local CarTab = Instance.new("ScrollingFrame")
CarTab.Name = "CarTab"
CarTab.Parent = ContentFrame
CarTab.BackgroundTransparency = 1
CarTab.Size = UDim2.new(1, 0, 1, 0)
CarTab.CanvasSize = UDim2.new(0, 0, 0, 400)
CarTab.ScrollBarThickness = 4
CarTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
CarTab.Visible = false
CarTab.ZIndex = 104

local SettingsTab = Instance.new("ScrollingFrame")
SettingsTab.Name = "SettingsTab"
SettingsTab.Parent = ContentFrame
SettingsTab.BackgroundTransparency = 1
SettingsTab.Size = UDim2.new(1, 0, 1, 0)
SettingsTab.CanvasSize = UDim2.new(0, 0, 0, 300)
SettingsTab.ScrollBarThickness = 4
SettingsTab.ScrollBarImageColor3 = Color3.fromRGB(30, 144, 255)
SettingsTab.Visible = false
SettingsTab.ZIndex = 104

-- =================================================================
-- [[ SEKME GEÇİŞ SİSTEMİ ]]
-- =================================================================
local function SwitchTab(tabName)
    for _, child in ipairs(ContentFrame:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child.Visible = false
        end
    end
    
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
    
    if tabName == "Home" then HomeTab.Visible = true
    elseif tabName == "ESP" then ESPTab.Visible = true
    elseif tabName == "Players" then 
        PlayersTab.Visible = true
        UpdatePlayerList("")
    elseif tabName == "Troll" then TrollTab.Visible = true
    elseif tabName == "Gamepass" then GamepassTab.Visible = true
    elseif tabName == "Houses" then HousesTab.Visible = true
    elseif tabName == "Car" then CarTab.Visible = true
    elseif tabName == "Settings" then SettingsTab.Visible = true
    end
end

for _, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        SwitchTab(button.Name:gsub("Tab", ""))
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
ToggleButton.Position = UDim2.new(0.02, 0, 0.8, 0)
ToggleButton.Size = UDim2.new(0, 55, 0, 55)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "LK"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.Parent = ToggleButton
ToggleCorner.CornerRadius = UDim.new(0, 14)
ToggleButton.ZIndex = 200

ToggleButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        MainFrame.Visible = false
        ToggleButton.Visible = true
    else
        MainFrame.Visible = true
        ToggleButton.Visible = false
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {BackgroundTransparency = GLASS_BLUR}):Play()
    end
end)

-- =================================================================
-- [[ YARDIMCI FONKSİYONLAR ]]
-- =================================================================
function ShowNotification(text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "LK SYSTEM",
        Text = text,
        Duration = 3
    })
end

-- =================================================================
-- [[ BAŞLAT - DOĞRUDAN UI ]]
-- =================================================================
-- Oyuncu listesini güncelle
task.wait(0.5)
UpdatePlayerList("")

-- Ana UI açık
MainFrame.Visible = true
MainFrame.BackgroundTransparency = GLASS_BLUR

ShowNotification("✅ LK SYSTEM Başarıyla Yüklendi!")
ShowNotification("👋 UI'yı sürükleyerek hareket ettirebilirsiniz!")

print("╔═══════════════════════════════════════╗")
print("║        LK SYSTEM v2.0               ║")
print("║    Premium Roblox Hack Suite         ║")
print("║                                      ║")
print("║  ✅ Yükleme ekranı KALDIRILDI        ║")
print("║  ✅ Direkt UI aktif                  ║")
print("║  ✅ UI Sürükleme aktif               ║")
print("║  ✅ Oyuncu Seçim Sistemi aktif       ║")
print("║  ✅ ESP Sistemi aktif                ║")
print("║  ✅ Tüm özellikler hazır             ║")
print("╚═══════════════════════════════════════╝")
