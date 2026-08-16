-- DOLAROV HUB - THE RAKE REMASTERED (MOBİL UYUMLU)
-- Ana Script

-- Rayfield UI Yükleme
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Değişkenler
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser") -- Mobil için

-- State değişkenleri
local Toggles = {
    AntiRake = false,
    AutoStick = false,
    GodMode = false,
    AutoFarm = false,
    ESPPlayers = false,
    ESPRake = false,
    ESPFlare = false,
    ESPBox = false,
    ESPScrap = false,
    ESPTrap = false,
    FullBright = false,
    ThirdPerson = false,
    Speed = false,
    FallDamage = false,
    InfiniteStamina = false,
    MobileSpeed = false -- Mobil için yeni toggle
}

local Settings = {
    SpeedMultiplier = 5,
    MobileSpeedDistance = 10 -- Mobil için ışınlanma mesafesi
}

local Character = nil
local Humanoid = nil
local RootPart = nil
local Rake = nil
local Items = {}
local IsFarming = false
local OriginalLighting = {}
local MobileJoystick = nil -- Mobil joystick için

-- Yardımcı Fonksiyonlar
local function GetRake()
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name:lower():find("rake") then
            return v
        end
    end
    return nil
end

local function GetItems()
    local items = {}
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Handle") then
            local name = v.Name:lower()
            if name:find("scrap") or name:find("metal") or name:find("flare") or 
               name:find("supply") or name:find("box") or name:find("trap") then
                table.insert(items, v)
            end
        end
    end
    return items
end

local function UpdateCharacter()
    Character = LocalPlayer.Character
    if Character then
        Humanoid = Character:FindFirstChild("Humanoid")
        RootPart = Character:FindFirstChild("HumanoidRootPart")
    end
end

-- Event dinleyicileri
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)
LocalPlayer.CharacterRemoving:Connect(function()
    Character = nil
    Humanoid = nil
    RootPart = nil
end)

-- 1. ANTI-RAKE CHASE
local function AntiRakeChase()
    if not Toggles.AntiRake or not Character or not RootPart or not Rake then return end
    
    local rakePos = Rake:FindFirstChild("HumanoidRootPart")
    if not rakePos then return end
    
    local distance = (RootPart.Position - rakePos.Position).Magnitude
    
    if distance < 40 then
        local direction = (RootPart.Position - rakePos.Position).Unit
        local targetPos = RootPart.Position + direction * 50
        RootPart.CFrame = CFrame.new(targetPos)
    end
end

-- 2. AUTO-STICK ATTACK
local function AutoStickAttack()
    if not Toggles.AutoStick or not Character or not RootPart or not Rake then return end
    
    local rakePos = Rake:FindFirstChild("HumanoidRootPart")
    if not rakePos then return end
    
    local distance = (RootPart.Position - rakePos.Position).Magnitude
    
    if distance < 15 then
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("stick") then
                tool:Activate()
                break
            end
        end
    end
    
    if distance < 8 then
        local direction = (RootPart.Position - rakePos.Position).Unit
        RootPart.CFrame = CFrame.new(RootPart.Position + direction * 60)
    end
end

-- 3. GOD MODE
local function SetupGodMode()
    if not Toggles.GodMode or not Humanoid then return end
    Humanoid.Health = Humanoid.MaxHealth
end

-- 4. EXPERIMENTAL AUTOFARM
local function AutoFarm()
    if not Toggles.AutoFarm or IsFarming or not Character or not RootPart then return end
    
    IsFarming = true
    
    task.spawn(function()
        while Toggles.AutoFarm and Character and RootPart do
            if Rake then
                local rakePos = Rake:FindFirstChild("HumanoidRootPart")
                if rakePos and (RootPart.Position - rakePos.Position).Magnitude < 30 then
                    local direction = (RootPart.Position - rakePos.Position).Unit
                    RootPart.CFrame = CFrame.new(RootPart.Position + direction * 50)
                    task.wait(0.5)
                end
            end
            
            local items = GetItems()
            if #items > 0 then
                local closestItem = nil
                local closestDist = math.huge
                
                for _, item in pairs(items) do
                    local itemPos = item:FindFirstChild("Handle")
                    if itemPos then
                        local dist = (RootPart.Position - itemPos.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestItem = item
                        end
                    end
                end
                
                if closestItem then
                    local itemPos = closestItem:FindFirstChild("Handle")
                    if itemPos then
                        RootPart.CFrame = CFrame.new(itemPos.Position + Vector3.new(0, 2, 0))
                        task.wait(0.3)
                        RootPart.CFrame = CFrame.new(itemPos.Position)
                        task.wait(0.1)
                    end
                end
            end
            
            task.wait(0.2)
        end
        IsFarming = false
    end)
end

-- 5. ESP 2.0 UI
local ESPObjects = {}
local function CreateESP(object, color, text)
    if not object or not object:FindFirstChild("HumanoidRootPart") then return end
    
    local esp = Drawing.new("Box")
    esp.Thickness = 2
    esp.Color = color
    esp.Transparency = 0.5
    esp.Filled = false
    
    local label = Drawing.new("Text")
    label.Text = text
    label.Color = color
    label.Size = 12
    label.Center = true
    
    ESPObjects[object] = {box = esp, label = label}
end

local function UpdateESP()
    for obj, data in pairs(ESPObjects) do
        if not obj or not obj.Parent then
            data.box:Remove()
            data.label:Remove()
            ESPObjects[obj] = nil
        end
    end
    
    if Toggles.ESPRake and Rake then
        if not ESPObjects[Rake] then
            CreateESP(Rake, Color3.fromRGB(255, 0, 0), "RAKE")
        end
    end
    
    if Toggles.ESPPlayers then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not ESPObjects[player.Character] then
                    CreateESP(player.Character, Color3.fromRGB(0, 255, 0), player.Name)
                end
            end
        end
    end
    
    local items = GetItems()
    for _, item in pairs(items) do
        local name = item.Name:lower()
        local color = Color3.fromRGB(255, 255, 255)
        local text = item.Name
        
        if name:find("flare") and Toggles.ESPFlare then
            color = Color3.fromRGB(255, 165, 0)
        elseif name:find("supply") and Toggles.ESPBox then
            color = Color3.fromRGB(0, 0, 255)
        elseif name:find("scrap") and Toggles.ESPScrap then
            color = Color3.fromRGB(128, 128, 128)
        elseif name:find("trap") and Toggles.ESPTrap then
            color = Color3.fromRGB(128, 0, 128)
        else
            continue
        end
        
        if not ESPObjects[item] then
            CreateESP(item, color, text)
        end
    end
end

-- 6. FULL BRIGHTNESS
local function ToggleFullBright()
    if Toggles.FullBright then
        OriginalLighting = {
            Brightness = Lighting.Brightness,
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            FogEnd = Lighting.FogEnd
        }
        Lighting.Brightness = 10
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.FogEnd = 10000
    else
        Lighting.Brightness = OriginalLighting.Brightness or 1
        Lighting.Ambient = OriginalLighting.Ambient or Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient or Color3.fromRGB(127, 127, 127)
        Lighting.FogEnd = OriginalLighting.FogEnd or 100000
    end
end

-- 7. THIRD PERSON
local function ToggleThirdPerson()
    if Toggles.ThirdPerson then
        Camera.CameraType = Enum.CameraType.Follow
        Camera.CameraSubject = Character
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end

-- 8. MOBİL SPEED (Dokunmatik Kontrol)
local function SetupMobileSpeed()
    if not Toggles.MobileSpeed or not Character or not RootPart then return end
    
    -- Mobil joystick oluştur
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MobileSpeedGUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 150)
    frame.Position = UDim2.new(0, 20, 0, -75)
    frame.AnchorPoint = Vector2.new(0, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = screenGui
    
    local joystick = Instance.new("Frame")
    joystick.Size = UDim2.new(0, 50, 0, 50)
    joystick.Position = UDim2.new(0.5, -25, 0.5, -25)
    joystick.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    joystick.BorderSizePixel = 0
    joystick.Parent = frame
    
    local isDragging = false
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPos = input.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            joystick.Position = UDim2.new(0.5, -25, 0.5, -25)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startPos
            local magnitude = delta.Magnitude
            local maxRadius = 50
            
            if magnitude > maxRadius then
                delta = delta.Unit * maxRadius
            end
            
            joystick.Position = UDim2.new(0.5, delta.X - 25, 0.5, delta.Y - 25)
            
            -- Işınlanma işlemi
            if magnitude > 10 then
                local direction = Vector3.new(delta.X, 0, -delta.Y).Unit
                local distance = Settings.MobileSpeedDistance * (magnitude / maxRadius)
                RootPart.CFrame = RootPart.CFrame + direction * distance
            end
        end
    end)
end

-- 9. DELETE FALL DAMAGE
local function SetupFallDamage()
    if Toggles.FallDamage and Humanoid then
        Humanoid.FallDamage = 0
    else
        Humanoid.FallDamage = 100
    end
end

-- 10. INFINITE STAMINA
local function SetupInfiniteStamina()
    if Toggles.InfiniteStamina and Humanoid then
        Humanoid.Stamina.Value = Humanoid.Stamina.MaxValue
    end
end

-- 11. MAKE HIM CHASE YOU
local function MakeHimChaseYou()
    if not Character or not RootPart or not Rake then return end
    
    local rakePos = Rake:FindFirstChild("HumanoidRootPart")
    if not rakePos then return end
    
    local targetPos = rakePos.Position + (rakePos.Position - RootPart.Position).Unit * 20
    RootPart.CFrame = CFrame.new(targetPos)
end

-- Ana Render Döngüsü
RunService.Heartbeat:Connect(function()
    if not Character then UpdateCharacter() end
    if not Rake then Rake = GetRake() end
    
    AntiRakeChase()
    AutoStickAttack()
    SetupGodMode()
    SetupInfiniteStamina()
    UpdateESP()
    
    -- Mobil Speed aktifse joystick'i göster/gizle
    if Toggles.MobileSpeed then
        if not MobileJoystick then SetupMobileSpeed() end
    else
        if MobileJoystick then MobileJoystick:Destroy(); MobileJoystick = nil end
    end
end)

-- Rayfield UI Oluşturma
local Window = Rayfield:CreateWindow({
    Name = "DOLAROV HUB",
    Icon = 0,
    LoadingTitle = "DOLAROV HUB",
    LoadingSubtitle = "The Rake Remastered (Mobil)",
    Theme = "Dark",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DolarovHub"
    }
})

-- MAIN Sekmesi
local MainTab = Window:CreateTab("MAIN")

MainTab:CreateToggle({
    Name = "Anti-Rake Chase",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.AntiRake = Value
    end
})

MainTab:CreateButton({
    Name = "Make Him Chase You",
    Callback = MakeHimChaseYou
})

MainTab:CreateToggle({
    Name = "Experimental Autofarm",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.AutoFarm = Value
        if Value then
            AutoFarm()
        else
            IsFarming = false
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto-Stick Attack",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.AutoStick = Value
    end
})

MainTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.GodMode = Value
        if Value then
            SetupGodMode()
        end
    end
})

-- MISC Sekmesi
local MiscTab = Window:CreateTab("MISC")

MiscTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ESPPlayers = Value
        if not Value then
            for obj, data in pairs(ESPObjects) do
                data.box:Remove()
                data.label:Remove()
            end
            ESPObjects = {}
        end
    end
})

MiscTab:CreateToggle({
    Name = "ESP Rake",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ESPRake = Value
        if not Value and ESPObjects[Rake] then
            ESPObjects[Rake].box:Remove()
            ESPObjects[Rake].label:Remove()
            ESPObjects[Rake] = nil
        end
    end
})

MiscTab:CreateToggle({
    Name = "ESP Flare Gun",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ESPFlare = Value
    end
})

MiscTab:CreateToggle({
    Name = "Supply Box ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ESPBox = Value
    end
})

MiscTab:CreateToggle({
    Name = "Scrap ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ESPScrap = Value
    end
})

MiscTab:CreateToggle({
    Name = "Trap ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ESPTrap = Value
    end
})

MiscTab:CreateToggle({
    Name = "Full Brightness",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.FullBright = Value
        ToggleFullBright()
    end
})

MiscTab:CreateToggle({
    Name = "Enable Third Person",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ThirdPerson = Value
        ToggleThirdPerson()
    end
})

-- MOBİL SPEED (Klavye yerine dokunmatik)
MiscTab:CreateToggle({
    Name = "Mobile Speed (Joystick)",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.MobileSpeed = Value
        if Value then
            SetupMobileSpeed()
        else
            if MobileJoystick then 
                MobileJoystick:Destroy() 
                MobileJoystick = nil 
            end
        end
    end
})

MiscTab:CreateSlider({
    Name = "Mobile Speed Distance",
    Min = 5,
    Max = 30,
    Default = 10,
    Callback = function(Value)
        Settings.MobileSpeedDistance = Value
    end
})

MiscTab:CreateToggle({
    Name = "Delete Fall Damage",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.FallDamage = Value
        SetupFallDamage()
    end
})

MiscTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.InfiniteStamina = Value
        SetupInfiniteStamina()
    end
})

-- Başlangıç kontrolleri
UpdateCharacter()
Rake = GetRake()

print("DOLAROV HUB - The Rake Remastered (MOBİL UYUMLU) başlatıldı!")
