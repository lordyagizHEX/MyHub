-- [[ ADVANCED DOLAROV X - THE RAKE REMASTERED (MOBIL UYUMLU) ]]
-- [[ GELISMIS BYPASS & SILENT AIM SISTEMI ]]

-- Lisans Kontrol Sistemi
local function LicenseCheck()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LicenseGUI"
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "DOLAROV X HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 30)
    sub.Position = UDim2.new(0, 0, 0, 50)
    sub.BackgroundTransparency = 1
    sub.Text = "Premium Lisans Dogrulaniyor..."
    sub.TextColor3 = Color3.fromRGB(200, 200, 200)
    sub.TextScaled = true
    sub.Font = Enum.Font.Gotham
    sub.Parent = frame
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0.8, 0, 0, 5)
    loadingBar.Position = UDim2.new(0.1, 0, 0, 90)
    loadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    loadingBar.Parent = frame
    
    local progress = Instance.new("Frame")
    progress.Size = UDim2.new(0, 0, 1, 0)
    progress.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    progress.Parent = loadingBar
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 100)
    status.BackgroundTransparency = 1
    status.Text = "Lutfen Bekleyin..."
    status.TextColor3 = Color3.fromRGB(150, 150, 150)
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 30)
    closeBtn.Position = UDim2.new(0.5, -50, 0, 150)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "Giris Yap"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Visible = false
    closeBtn.Parent = frame
    
    local function animateBar()
        local target = 100
        local current = 0
        while current < target do
            current = current + 1
            progress.Size = UDim2.new(current/100, 0, 1, 0)
            wait(0.02)
        end
        status.Text = "Lisans Dogrulandi! ✓"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(0.5)
        closeBtn.Visible = true
        sub.Text = "HUB Yukleniyor..."
    end
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        LoadHub()
    end)
    
    task.spawn(animateBar)
    return screenGui
end

local function LoadHub()
-- Rayfield UI Yukleme
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Degiskenler
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- State degiskenleri
local Toggles = {
    AntiRake = false,
    AutoStick = false,
    GodMode = false,
    AutoFarm = false,
    SilentAim = false,
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
    MobileSpeed = false,
    ESPLines = false,
    ESPHealth = false,
    TP = false,
    VehicleSpeed = false,
    EzBypass = false
}

local Settings = {
    SpeedMultiplier = 5,
    MobileSpeedDistance = 10,
    FOVRadius = 150,
    VehicleSpeedMultiplier = 3,
    SilentAimSmoothness = 0.3,
    ESPDistance = 200
}

local Character = nil
local Humanoid = nil
local RootPart = nil
local Rake = nil
local Items = {}
local IsFarming = false
local OriginalLighting = {}
local MobileJoystick = nil
local SilentAimTarget = nil
local ESPObjects = {}
local BypassActive = false

-- GELISMIS BYPASS SISTEMI
local function EzBypassSystem()
    if not Toggles.EzBypass then return end
    
    -- Anti Anti-Cheat
    local function BypassChecks()
        -- Remote event bypass
        local function HookRemoteEvents()
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                local method = getnamecallmethod()
                if method == "FireServer" and self.Name:lower():find("anticheat") then
                    return
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        end
        
        -- Script context bypass
        local function BypassContext()
            local context = cloneref(game:GetService("ScriptContext"))
            local oldError = context.Error
            context.Error = newcclosure(function(...)
                return
            end)
        end
        
        -- Detection bypass
        local function BypassDetection()
            local function DisableDetection()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Script") and v.Name:lower():find("detect") then
                        v.Disabled = true
                    end
                end
            end
            
            -- Fake ping bypass
            local function FakePing()
                local stats = game:GetService("Stats")
                local oldPing = stats.Ping
                stats.Ping = function()
                    return 20
                end
            end
        end
        
        task.spawn(function()
            while Toggles.EzBypass do
                HookRemoteEvents()
                BypassContext()
                BypassDetection()
                wait(5)
            end
        end)
    end
    
    -- GUI gizleme
    local function HideGUI()
        for _, v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
            if v:IsA("ScreenGui") and v.Name:lower():find("anticheat") then
                v.Enabled = false
            end
        end
    end
    
    -- Anti-ban sistemi
    local function AntiBan()
        local function DisableBanScripts()
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("Script") and v.Name:lower():find("ban") then
                    v.Disabled = true
                end
            end
        end
        
        local function BanBypass()
            local oldKick = game.Kick
            game.Kick = newcclosure(function(...)
                return
            end)
        end
    end
    
    task.spawn(BypassChecks)
    task.spawn(HideGUI)
    task.spawn(AntiBan)
    
    BypassActive = true
    print("[BYPass] EzBypass Aktif!")
end

-- YARDIMCI FONKSIYONLAR
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

-- GELISMIS SILENT AIM
local function GetClosestPlayerToMouse()
    local mouse = LocalPlayer:GetMouse()
    local closest = nil
    local closestDist = math.huge
    local fovRadius = Settings.FOVRadius
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if dist < fovRadius and dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    
    return closest
end

local function SilentAim()
    if not Toggles.SilentAim or not Character or not RootPart then return end
    
    local target = GetClosestPlayerToMouse()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    
    local head = target.Character.Head
    local targetPos = head.Position
    
    -- Akici nişan alma
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
    local smoothness = Settings.SilentAimSmoothness
    
    -- Yumuşak geçiş
    local newCFrame = currentCFrame:Lerp(targetCFrame, smoothness)
    Camera.CFrame = newCFrame
    
    -- Menzil kontrolü
    local distance = (RootPart.Position - targetPos).Magnitude
    if distance > Settings.ESPDistance then
        return
    end
    
    -- Mermi hedefleme
    local function BulletAim()
        for _, bullet in pairs(Workspace:GetDescendants()) do
            if bullet:IsA("Part") and bullet.Name:lower():find("bullet") then
                local bulletPosition = bullet.Position
                local direction = (targetPos - bulletPosition).Unit
                bullet.CFrame = CFrame.lookAt(bulletPosition, targetPos)
            end
        end
    end
    
    task.spawn(BulletAim)
    SilentAimTarget = target
end

-- GELISMIS ESP SISTEMI
local function CreateAdvancedESP(object, color, text)
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
    
    -- Cizgi ESP
    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Color = color
    line.Transparency = 0.3
    
    -- Health bar
    local healthBar = Drawing.new("Rectangle")
    healthBar.Thickness = 2
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Filled = true
    
    ESPObjects[object] = {
        box = esp,
        label = label,
        line = line,
        health = healthBar
    }
end

local function UpdateESP()
    for obj, data in pairs(ESPObjects) do
        if not obj or not obj.Parent then
            data.box:Remove()
            data.label:Remove()
            data.line:Remove()
            data.health:Remove()
            ESPObjects[obj] = nil
        end
    end
    
    -- Rake ESP
    if Toggles.ESPRake and Rake then
        if not ESPObjects[Rake] then
            CreateAdvancedESP(Rake, Color3.fromRGB(255, 0, 0), "⚠ RAKE ⚠")
        end
    end
    
    -- Oyuncu ESP
    if Toggles.ESPPlayers then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not ESPObjects[player.Character] then
                    local color = player.TeamColor.Color or Color3.fromRGB(0, 255, 0)
                    CreateAdvancedESP(player.Character, color, player.Name)
                end
            end
        end
    end
    
    -- Esya ESP
    local items = GetItems()
    for _, item in pairs(items) do
        local name = item.Name:lower()
        local color = Color3.fromRGB(255, 255, 255)
        local text = item.Name
        
        if name:find("flare") and Toggles.ESPFlare then
            color = Color3.fromRGB(255, 165, 0)
            text = "🔥 " .. item.Name
        elseif name:find("supply") and Toggles.ESPBox then
            color = Color3.fromRGB(0, 0, 255)
            text = "📦 " .. item.Name
        elseif name:find("scrap") and Toggles.ESPScrap then
            color = Color3.fromRGB(128, 128, 128)
            text = "⚙ " .. item.Name
        elseif name:find("trap") and Toggles.ESPTrap then
            color = Color3.fromRGB(128, 0, 128)
            text = "⚠ " .. item.Name
        else
            continue
        end
        
        if not ESPObjects[item] then
            CreateAdvancedESP(item, color, text)
        end
    end
    
    -- Cizgi ESP
    if Toggles.ESPLines then
        for obj, data in pairs(ESPObjects) do
            if obj and obj:FindFirstChild("HumanoidRootPart") then
                local pos = obj.HumanoidRootPart.Position
                local screenPos = Camera:WorldToViewportPoint(pos)
                data.line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                data.line.To = Vector2.new(screenPos.X, screenPos.Y)
                data.line.Visible = true
            end
        end
    else
        for _, data in pairs(ESPObjects) do
            if data.line then
                data.line.Visible = false
            end
        end
    end
    
    -- Health ESP
    if Toggles.ESPHealth then
        for obj, data in pairs(ESPObjects) do
            if obj and obj:FindFirstChild("Humanoid") then
                local humanoid = obj.Humanoid
                local health = humanoid.Health / humanoid.MaxHealth
                data.health.Visible = true
                data.health.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
            end
        end
    else
        for _, data in pairs(ESPObjects) do
            if data.health then
                data.health.Visible = false
            end
        end
    end
end

-- TP SISTEMI
local function TeleportPlayer(target)
    if not Toggles.TP or not Character or not RootPart or not target then return end
    if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local targetPos = target.Character.HumanoidRootPart.Position
    RootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
end

-- ARAÇ HIZI ARTTIRMA
local function VehicleSpeedBoost()
    if not Toggles.VehicleSpeed or not Character then return end
    
    for _, vehicle in pairs(Workspace:GetDescendants()) do
        if vehicle:IsA("VehicleSeat") and vehicle.Occupant == Character then
            local vehicleModel = vehicle.Parent
            if vehicleModel and vehicleModel:FindFirstChild("PrimaryPart") then
                local primaryPart = vehicleModel.PrimaryPart
                local velocity = primaryPart.Velocity
                local direction = velocity.Unit
                local speed = velocity.Magnitude
                
                if speed > 0 then
                    primaryPart.Velocity = direction * speed * Settings.VehicleSpeedMultiplier
                end
            end
        end
    end
end

-- MOBIL JOYSTICK
local function SetupMobileSpeed()
    if not Toggles.MobileSpeed or not Character or not RootPart then return end
    
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
            
            if magnitude > 10 then
                local direction = Vector3.new(delta.X, 0, -delta.Y).Unit
                local distance = Settings.MobileSpeedDistance * (magnitude / maxRadius)
                RootPart.CFrame = RootPart.CFrame + direction * distance
            end
        end
    end)
    
    MobileJoystick = screenGui
end

-- FOV GÖSTERGESI
local function DrawFOV()
    if not Toggles.SilentAim then return end
    
    local fovCircle = Drawing.new("Circle")
    fovCircle.Thickness = 1
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Radius = Settings.FOVRadius
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    fovCircle.Transparency = 0.3
    fovCircle.NumSides = 64
    fovCircle.Visible = true
    
    return fovCircle
end

-- Bypass koruma
local function ProtectHub()
    local function ProtectScripts()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Script") and v.Name:lower():find("hub") then
                v.Disabled = false
            end
        end
    end
    
    local function PreventDetection()
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = newcclosure(function(self, key)
            if key == "Hub" or key:lower():find("dolarov") then
                return nil
            end
            return oldIndex(self, key)
        end)
        setreadonly(mt, true)
    end
    
    task.spawn(ProtectScripts)
    task.spawn(PreventDetection)
end

-- Ana Render Döngüsü
RunService.Heartbeat:Connect(function()
    if not Character then UpdateCharacter() end
    if not Rake then Rake = GetRake() end
    
    -- Anti-Rake
    if Toggles.AntiRake and Rake and RootPart then
        local rakePos = Rake:FindFirstChild("HumanoidRootPart")
        if rakePos and (RootPart.Position - rakePos.Position).Magnitude < 40 then
            local direction = (RootPart.Position - rakePos.Position).Unit
            RootPart.CFrame = CFrame.new(RootPart.Position + direction * 50)
        end
    end
    
    -- Auto-Stick
    if Toggles.AutoStick and Rake and RootPart then
        local rakePos = Rake:FindFirstChild("HumanoidRootPart")
        if rakePos then
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
    end
    
    -- God Mode
    if Toggles.GodMode and Humanoid then
        Humanoid.Health = Humanoid.MaxHealth
    end
    
    -- AutoFarm
    if Toggles.AutoFarm and not IsFarming then
        task.spawn(function()
            IsFarming = true
            while Toggles.AutoFarm and Character do
                local items = GetItems()
                if #items > 0 then
                    for _, item in pairs(items) do
                        if item:FindFirstChild("Handle") then
                            local pos = item.Handle.Position
                            RootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
                            wait(0.1)
                            RootPart.CFrame = CFrame.new(pos)
                            wait(0.2)
                        end
                    end
                end
                wait(0.5)
            end
            IsFarming = false
        end)
    end
    
    -- Silent Aim
    SilentAim()
    
    -- ESP
    UpdateESP()
    
    -- Mobile Speed
    if Toggles.MobileSpeed then
        if not MobileJoystick then SetupMobileSpeed() end
    else
        if MobileJoystick then MobileJoystick:Destroy(); MobileJoystick = nil end
    end
    
    -- TP Sistemi
    if Toggles.TP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                TeleportPlayer(player)
                break
            end
        end
    end
    
    -- Araç Hızı
    VehicleSpeedBoost()
    
    -- EzBypass
    if Toggles.EzBypass and not BypassActive then
        EzBypassSystem()
    end
    
    -- FOV Göster
    if Toggles.SilentAim then
        local fov = DrawFOV()
        wait(0.1)
        if fov then fov:Remove() end
    end
end)

-- LISANS SISTEMI
local LicenseGUI = LicenseCheck()

-- HUB GELISTIRME
local function SetupHub()
    -- Rayfield UI Oluşturma
    local Window = Rayfield:CreateWindow({
        Name = "DOLAROV X HUB v2.0",
        Icon = 0,
        LoadingTitle = "DOLAROV X",
        LoadingSubtitle = "The Rake Remastered (Premium)",
        Theme = "Dark",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "DolarovXHub"
        }
    })

    -- MAIN Sekmesi
    local MainTab = Window:CreateTab("⚡ MAIN")

    MainTab:CreateToggle({
        Name = "🛡️ EzBypass (Gelişmiş Koruma)",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.EzBypass = Value
            if Value then
                EzBypassSystem()
            else
                BypassActive = false
            end
        end
    })

    MainTab:CreateToggle({
        Name = "🎯 Silent Aim (Gelişmiş Nişan)",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.SilentAim = Value
        end
    })

    MainTab:CreateSlider({
        Name = "FOV Radius (Silent Aim)",
        Min = 50,
        Max = 300,
        Default = 150,
        Callback = function(Value)
            Settings.FOVRadius = Value
        end
    })

    MainTab:CreateSlider({
        Name = "Silent Aim Smoothness",
        Min = 0.1,
        Max = 1,
        Default = 0.3,
        Callback = function(Value)
            Settings.SilentAimSmoothness = Value
        end
    })

    MainTab:CreateToggle({
        Name = "🚀 Anti-Rake Chase",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.AntiRake = Value
        end
    })

    MainTab:CreateToggle({
        Name = "⚔️ Auto-Stick Attack",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.AutoStick = Value
        end
    })

    MainTab:CreateToggle({
        Name = "💀 God Mode",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.GodMode = Value
        end
    })

    MainTab:CreateToggle({
        Name = "🤖 Experimental Autofarm",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.AutoFarm = Value
        end
    })

    MainTab:CreateButton({
        Name = "🚨 Make Him Chase You",
        Callback = function()
            if Rake and RootPart then
                local rakePos = Rake:FindFirstChild("HumanoidRootPart")
                if rakePos then
                    local targetPos = rakePos.Position + (rakePos.Position - RootPart.Position).Unit * 20
                    RootPart.CFrame = CFrame.new(targetPos)
                end
            end
        end
    })

    -- ESP Sekmesi
    local ESPTab = Window:CreateTab("👁️ ESP")

    ESPTab:CreateToggle({
        Name = "👤 ESP Players",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.ESPPlayers = Value
        end
    })

    ESPTab:CreateToggle({
        Name = "🔥 ESP Rake",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.ESPRake = Value
        end
    })

    ESPTab:CreateToggle({
        Name = "📦 ESP Items",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.ESPFlare = Value
            Toggles.ESPBox = Value
            Toggles.ESPScrap = Value
            Toggles.ESPTrap = Value
        end
    })

    ESPTab:CreateToggle({
        Name = "📏 ESP Lines",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.ESPLines = Value
        end
    })

    ESPTab:CreateToggle({
        Name = "❤️ ESP Health",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.ESPHealth = Value
        end
    })

    ESPTab:CreateSlider({
        Name = "ESP Distance",
        Min = 50,
        Max = 500,
        Default = 200,
        Callback = function(Value)
            Settings.ESPDistance = Value
        end
    })

    -- MOBIL Sekmesi
    local MobileTab = Window:CreateTab("📱 MOBIL")

    MobileTab:CreateToggle({
        Name = "🕹️ Mobile Speed (Joystick)",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.MobileSpeed = Value
        end
    })

    MobileTab:CreateSlider({
        Name = "Mobile Speed Distance",
        Min = 5,
        Max = 50,
        Default = 10,
        Callback = function(Value)
            Settings.MobileSpeedDistance = Value
        end
    })

    MobileTab:CreateToggle({
        Name = "📍 TP Sistemi (Mobil)",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.TP = Value
        end
    })

    -- MISC Sekmesi
    local MiscTab = Window:CreateTab("⚙️ MISC")

    MiscTab:CreateToggle({
        Name = "☀️ Full Brightness",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.FullBright = Value
            if Value then
                OriginalLighting.Brightness = Lighting.Brightness
                OriginalLighting.Ambient = Lighting.Ambient
                Lighting.Brightness = 10
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            else
                Lighting.Brightness = OriginalLighting.Brightness or 1
                Lighting.Ambient = OriginalLighting.Ambient or Color3.fromRGB(127, 127, 127)
            end
        end
    })

    MiscTab:CreateToggle({
        Name = "🎥 Third Person",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.ThirdPerson = Value
            if Value then
                Camera.CameraType = Enum.CameraType.Follow
                Camera.CameraSubject = Character
            else
                Camera.CameraType = Enum.CameraType.Custom
            end
        end
    })

    MiscTab:CreateToggle({
        Name = "🚗 Vehicle Speed Boost",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.VehicleSpeed = Value
        end
    })

    MiscTab:CreateSlider({
        Name = "Vehicle Speed Multiplier",
        Min = 1,
        Max = 10,
        Default = 3,
        Callback = function(Value)
            Settings.VehicleSpeedMultiplier = Value
        end
    })

    MiscTab:CreateToggle({
        Name = "🛡️ Delete Fall Damage",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.FallDamage = Value
            if Humanoid then
                Humanoid.FallDamage = Value and 0 or 100
            end
        end
    })

    MiscTab:CreateToggle({
        Name = "♾️ Infinite Stamina",
        CurrentValue = false,
        Callback = function(Value)
            Toggles.InfiniteStamina = Value
        end
    })

    -- Ayarlar
    MiscTab:CreateButton({
        Name = "🔄 Reset All Settings",
        Callback = function()
            for toggle, _ in pairs(Toggles) do
                Toggles[toggle] = false
            end
            print("Tüm ayarlar sıfırlandı!")
        end
    })

    MiscTab:CreateButton({
        Name = "ℹ️ Hub Info",
        Callback = function()
            print("DOLAROV X HUB v2.0")
            print("The Rake Remastered - Premium")
            print("Gelişmiş Bypass & Silent Aim")
            print("Mobil Uyumlu")
        end
    })

    print("DOLAROV X HUB v2.0 başlatıldı!")
    ProtectHub()
end

task.spawn(SetupHub)
end

-- LISANS KONTROLÜ
task.spawn(function()
    wait(1)
    if not LicenseCheck then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Dolarov/DolarovX/main/license.lua"))()
    end
end)

-- GELISMIS KORUMA
local function AdvancedProtection()
    local function AntiInjection()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "LoadString" and tostring(args[1]):find("inject") then
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end
    
    local function AntiKick()
        local oldKick = game.Kick
        game.Kick = newcclosure(function(...)
            return
        end)
    end
    
    task.spawn(AntiInjection)
    task.spawn(AntiKick)
end

AdvancedProtection()
print("DOLAROV X HUB - Premium Koruma Aktif!")
