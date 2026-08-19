-- [[ ADVANCED DOLAROV X - THE RAKE REMASTERED (MOBIL UYUMLU) ]]
-- [[ GELISMIS BYPASS & SILENT AIM SISTEMI ]]
-- [[ TAM KOD - CALISAN VERSIYON ]]

-- Lisans Kontrol Sistemi
local function LicenseCheck()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LicenseGUI"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
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
            task.wait(0.02)
        end
        status.Text = "Lisans Dogrulandi! ✓"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(0.5)
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
    local success, Rayfield = pcall(function()
        return loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
    end)
    
    if not success then
        print("Rayfield yuklenemedi, alternatif UI kullaniliyor...")
        LoadAlternativeUI()
        return
    end

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
        EzBypass = false,
        Fly = false,
        Noclip = false,
        ESPItems = false
    }

    local Settings = {
        SpeedMultiplier = 5,
        MobileSpeedDistance = 10,
        FOVRadius = 150,
        VehicleSpeedMultiplier = 3,
        SilentAimSmoothness = 0.3,
        ESPDistance = 200,
        FlySpeed = 50
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
    local FlyConnections = {}
    local NoclipConnections = {}

    -- YARDIMCI FONKSIYONLAR
    local function GetRake()
        for _, v in pairs(Workspace:GetChildren()) do
            if v:IsA("Model") and v.Name and v.Name:lower():find("rake") then
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

    -- GELISMIS BYPASS SISTEMI
    local function EzBypassSystem()
        if not Toggles.EzBypass then return end
        
        local function BypassChecks()
            -- Remote event bypass
            pcall(function()
                local mt = getrawmetatable(game)
                if mt then
                    local oldNamecall = mt.__namecall
                    setreadonly(mt, false)
                    mt.__namecall = function(self, ...)
                        local method = getnamecallmethod()
                        if method == "FireServer" and self.Name and self.Name:lower():find("anticheat") then
                            return
                        end
                        return oldNamecall(self, ...)
                    end
                    setreadonly(mt, true)
                end
            end)
            
            -- Script disable
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Script") and v.Name and v.Name:lower():find("detect") then
                        v.Disabled = true
                    end
                end
            end)
        end
        
        -- Kick bypass
        pcall(function()
            local oldKick = game.Kick
            game.Kick = function(...) return end
        end)
        
        task.spawn(function()
            while Toggles.EzBypass do
                BypassChecks()
                task.wait(5)
            end
        end)
        
        BypassActive = true
        print("[BYPASS] EzBypass Aktif!")
    end

    -- SILENT AIM
    local function GetClosestPlayerToMouse()
        local mouse = LocalPlayer:GetMouse()
        if not mouse then return nil end
        
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
        
        -- Akici nisan alma
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
        local smoothness = Settings.SilentAimSmoothness
        
        pcall(function()
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, smoothness)
        end)
        
        -- Mermi hedefleme
        pcall(function()
            for _, bullet in pairs(Workspace:GetDescendants()) do
                if bullet:IsA("Part") and bullet.Name and bullet.Name:lower():find("bullet") then
                    bullet.CFrame = CFrame.lookAt(bullet.Position, targetPos)
                end
            end
        end)
        
        SilentAimTarget = target
    end

    -- ESP SISTEMI
    local function CreateAdvancedESP(object, color, text)
        if not object then return end
        
        pcall(function()
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
            
            local line = Drawing.new("Line")
            line.Thickness = 1
            line.Color = color
            line.Transparency = 0.3
            
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
        end)
    end

    local function UpdateESP()
        for obj, data in pairs(ESPObjects) do
            if not obj or not obj.Parent then
                pcall(function()
                    data.box:Remove()
                    data.label:Remove()
                    data.line:Remove()
                    data.health:Remove()
                end)
                ESPObjects[obj] = nil
            end
        end
        
        if not Toggles.ESPPlayers and not Toggles.ESPRake and not Toggles.ESPItems then
            return
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
                        local color = Color3.fromRGB(0, 255, 0)
                        CreateAdvancedESP(player.Character, color, player.Name)
                    end
                end
            end
        end
        
        -- Item ESP
        if Toggles.ESPItems then
            local items = GetItems()
            for _, item in pairs(items) do
                if not ESPObjects[item] then
                    CreateAdvancedESP(item, Color3.fromRGB(255, 255, 0), item.Name)
                end
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

    -- FLY SISTEMI
    local function ToggleFly()
        if not Toggles.Fly then
            for _, conn in pairs(FlyConnections) do
                pcall(function() conn:Disconnect() end)
            end
            FlyConnections = {}
            return
        end
        
        if not RootPart then return end
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e8, 9e8, 9e8)
        bodyGyro.P = 9e4
        bodyGyro.Parent = RootPart
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e8, 9e8, 9e8)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.Parent = RootPart
        
        local flyCon = RunService.Heartbeat:Connect(function()
            if not Toggles.Fly or not RootPart then
                pcall(function()
                    bodyVelocity:Destroy()
                    bodyGyro:Destroy()
                end)
                flyCon:Disconnect()
                return
            end
            
            local direction = Vector3.zero
            local forward = Camera.CFrame.LookVector
            local right = Camera.CFrame.RightVector
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            local speed = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 200 or 50
            
            if direction.Magnitude > 0 then
                bodyVelocity.Velocity = direction.Unit * speed
            else
                bodyVelocity.Velocity = Vector3.zero
            end
            
            bodyGyro.CFrame = Camera.CFrame
        end)
        
        FlyConnections = {flyCon}
    end

    -- NOCLIP SISTEMI
    local function ToggleNoclip()
        if not Toggles.Noclip then
            for _, conn in pairs(NoclipConnections) do
                pcall(function() conn:Disconnect() end)
            end
            NoclipConnections = {}
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            return
        end
        
        local noclipCon = RunService.Stepped:Connect(function()
            if not Character then return end
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        NoclipConnections = {noclipCon}
    end

    -- MOBIL JOYSTICK
    local function SetupMobileSpeed()
        if not Toggles.MobileSpeed or not Character or not RootPart then return end
        
        -- Eski joysticki temizle
        if MobileJoystick then
            pcall(function() MobileJoystick:Destroy() end)
            MobileJoystick = nil
        end
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "MobileSpeedGUI"
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        screenGui.ResetOnSpawn = false
        
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
                
                if magnitude > 10 and RootPart then
                    local direction = Vector3.new(delta.X, 0, -delta.Y).Unit
                    local distance = Settings.MobileSpeedDistance * (magnitude / maxRadius)
                    pcall(function()
                        RootPart.CFrame = RootPart.CFrame + direction * distance
                    end)
                end
            end
        end)
        
        MobileJoystick = screenGui
    end

    -- AUTOFARM
    local function StartAutoFarm()
        if not Toggles.AutoFarm or IsFarming or not Character or not RootPart then return end
        
        IsFarming = true
        task.spawn(function()
            while Toggles.AutoFarm and Character and RootPart do
                local items = GetItems()
                if #items > 0 then
                    for _, item in pairs(items) do
                        if item:FindFirstChild("Handle") then
                            local pos = item.Handle.Position
                            pcall(function()
                                RootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
                                task.wait(0.1)
                                RootPart.CFrame = CFrame.new(pos)
                                task.wait(0.2)
                            end)
                        end
                    end
                end
                task.wait(0.5)
            end
            IsFarming = false
        end)
    end

    -- ANA RENDER DONGGUSU
    RunService.Heartbeat:Connect(function()
        if not Character then UpdateCharacter() end
        if not Rake then Rake = GetRake() end
        
        -- Anti-Rake
        if Toggles.AntiRake and Rake and RootPart then
            local rakePos = Rake:FindFirstChild("HumanoidRootPart")
            if rakePos and (RootPart.Position - rakePos.Position).Magnitude < 40 then
                local direction = (RootPart.Position - rakePos.Position).Unit
                pcall(function()
                    RootPart.CFrame = CFrame.new(RootPart.Position + direction * 50)
                end)
            end
        end
        
        -- Auto-Stick
        if Toggles.AutoStick and Rake and RootPart and Character then
            local rakePos = Rake:FindFirstChild("HumanoidRootPart")
            if rakePos then
                local distance = (RootPart.Position - rakePos.Position).Magnitude
                if distance < 15 then
                    for _, tool in pairs(Character:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name and tool.Name:lower():find("stick") then
                            pcall(function() tool:Activate() end)
                            break
                        end
                    end
                end
                if distance < 8 then
                    local direction = (RootPart.Position - rakePos.Position).Unit
                    pcall(function()
                        RootPart.CFrame = CFrame.new(RootPart.Position + direction * 60)
                    end)
                end
            end
        end
        
        -- God Mode
        if Toggles.GodMode and Humanoid then
            Humanoid.Health = Humanoid.MaxHealth
        end
        
        -- Infinite Stamina
        if Toggles.InfiniteStamina and Humanoid and Humanoid:FindFirstChild("Stamina") then
            Humanoid.Stamina.Value = Humanoid.Stamina.MaxValue
        end
        
        -- Fall Damage
        if Toggles.FallDamage and Humanoid then
            Humanoid.FallDamage = 0
        end
        
        -- Speed
        if Toggles.Speed and Humanoid then
            Humanoid.WalkSpeed = 80
        elseif Humanoid and not Toggles.Speed then
            Humanoid.WalkSpeed = 16
        end
        
        -- Silent Aim
        SilentAim()
        
        -- ESP
        UpdateESP()
        
        -- Mobile Speed
        if Toggles.MobileSpeed then
            if not MobileJoystick then SetupMobileSpeed() end
        else
            if MobileJoystick then
                pcall(function() MobileJoystick:Destroy() end)
                MobileJoystick = nil
            end
        end
        
        -- TP Sistemi
        if Toggles.TP then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = player.Character.HumanoidRootPart.Position
                    pcall(function()
                        RootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                    end)
                    break
                end
            end
        end
        
        -- Vehicle Speed
        if Toggles.VehicleSpeed and Character then
            pcall(function()
                for _, vehicle in pairs(Workspace:GetDescendants()) do
                    if vehicle:IsA("VehicleSeat") and vehicle.Occupant == Character then
                        local vehicleModel = vehicle.Parent
                        if vehicleModel and vehicleModel:FindFirstChild("PrimaryPart") then
                            local primaryPart = vehicleModel.PrimaryPart
                            local velocity = primaryPart.Velocity
                            local speed = velocity.Magnitude
                            if speed > 0 then
                                primaryPart.Velocity = velocity.Unit * speed * Settings.VehicleSpeedMultiplier
                            end
                        end
                    end
                end
            end)
        end
        
        -- EzBypass
        if Toggles.EzBypass and not BypassActive then
            EzBypassSystem()
        end
        
        -- Fly
        if Toggles.Fly then
            ToggleFly()
        end
        
        -- Noclip
        if Toggles.Noclip then
            ToggleNoclip()
        end
    end)

    -- ALTERNATIF UI
    function LoadAlternativeUI()
        print("Alternatif UI yukleniyor...")
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "DolarovHub"
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        screenGui.ResetOnSpawn = false
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 500, 0, 500)
        mainFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        mainFrame.BorderSizePixel = 2
        mainFrame.BorderColor3 = Color3.fromRGB(200, 50, 50)
        mainFrame.Parent = screenGui
        mainFrame.Active = true
        mainFrame.Draggable = true
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.BackgroundTransparency = 1
        title.Text = "DOLAROV X HUB"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextScaled = true
        title.Font = Enum.Font.GothamBold
        title.Parent = mainFrame
        
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Size = UDim2.new(1, 0, 1, -60)
        scrollFrame.Position = UDim2.new(0, 0, 0, 55)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.Parent = mainFrame
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = scrollFrame
        layout.Padding = UDim.new(0, 5)
        
        local function CreateButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 250, 0, 40)
            btn.Position = UDim2.new(0.5, -125, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.Parent = scrollFrame
            btn.MouseButton1Click:Connect(callback)
            return btn
        end
        
        local function CreateToggle(text, toggleVar, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 250, 0, 40)
            frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            frame.Parent = scrollFrame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.Parent = frame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
            toggleBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleBtn.Text = "KAPALI"
            toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleBtn.TextSize = 12
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Parent = frame
            
            toggleBtn.MouseButton1Click:Connect(function()
                toggleVar = not toggleVar
                if toggleVar then
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                    toggleBtn.Text = "ACIK"
                else
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    toggleBtn.Text = "KAPALI"
                end
                callback(toggleVar)
            end)
            
            return toggleBtn
        end
        
        -- Butonlar
        local toggleStates = {}
        
        CreateButton("🛡️ EzBypass", function()
            Toggles.EzBypass = not Toggles.EzBypass
            print("EzBypass: " .. tostring(Toggles.EzBypass))
        end)
        
        CreateButton("🎯 Silent Aim", function()
            Toggles.SilentAim = not Toggles.SilentAim
            print("Silent Aim: " .. tostring(Toggles.SilentAim))
        end)
        
        CreateButton("🚀 Anti-Rake", function()
            Toggles.AntiRake = not Toggles.AntiRake
            print("Anti-Rake: " .. tostring(Toggles.AntiRake))
        end)
        
        CreateButton("⚔️ Auto-Stick", function()
            Toggles.AutoStick = not Toggles.AutoStick
            print("Auto-Stick: " .. tostring(Toggles.AutoStick))
        end)
        
        CreateButton("💀 God Mode", function()
            Toggles.GodMode = not Toggles.GodMode
            print("God Mode: " .. tostring(Toggles.GodMode))
        end)
        
        CreateButton("🤖 AutoFarm", function()
            Toggles.AutoFarm = not Toggles.AutoFarm
            if Toggles.AutoFarm then
                StartAutoFarm()
            else
                IsFarming = false
            end
            print("AutoFarm: " .. tostring(Toggles.AutoFarm))
        end)
        
        CreateButton("🛩️ Fly", function()
            Toggles.Fly = not Toggles.Fly
            print("Fly: " .. tostring(Toggles.Fly))
        end)
        
        CreateButton("👻 Noclip", function()
            Toggles.Noclip = not Toggles.Noclip
            print("Noclip: " .. tostring(Toggles.Noclip))
        end)
        
        CreateButton("👁️ ESP", function()
            Toggles.ESPPlayers = not Toggles.ESPPlayers
            Toggles.ESPRake = Toggles.ESPPlayers
            Toggles.ESPItems = Toggles.ESPPlayers
            print("ESP: " .. tostring(Toggles.ESPPlayers))
        end)
        
        CreateButton("♾️ Infinite Stamina", function()
            Toggles.InfiniteStamina = not Toggles.InfiniteStamina
            print("Infinite Stamina: " .. tostring(Toggles.InfiniteStamina))
        end)
        
        CreateButton("🔄 Reset All", function()
            for k in pairs(Toggles) do
                Toggles[k] = false
            end
            print("Tum ayarlar sifirlandi!")
        end)
        
        CreateButton("❌ Kapat", function()
            screenGui:Destroy()
        end)
    end

    -- HUB ANA MENU
    local function SetupHub()
        -- Rayfield UI Olusturma
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
            Name = "🛡️ EzBypass (Gelismis Koruma)",
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
            Name = "🎯 Silent Aim (Gelismis Nisan)",
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
            Name = "♾️ Infinite Stamina",
            CurrentValue = false,
            Callback = function(Value)
                Toggles.InfiniteStamina = Value
            end
        })

        MainTab:CreateToggle({
            Name = "🛡️ No Fall Damage",
            CurrentValue = false,
            Callback = function(Value)
                Toggles.FallDamage = Value
            end
        })

        MainTab:CreateToggle({
            Name = "⚡ Speed Hack",
            CurrentValue = false,
            Callback = function(Value)
                Toggles.Speed = Value
            end
        })

        MainTab:CreateToggle({
            Name = "🛩️ Fly Mode",
            CurrentValue = false,
            Callback = function(Value)
                Toggles.Fly = Value
            end
        })

        MainTab:CreateToggle({
            Name = "👻 Noclip",
            CurrentValue = false,
            Callback = function(Value)
                Toggles.Noclip = Value
            end
        })

        MainTab:CreateToggle({
            Name = "🤖 Experimental Autofarm",
            CurrentValue = false,
            Callback = function(Value)
                Toggles.AutoFarm = Value
                if Value then
                    StartAutoFarm()
                else
                    IsFarming = false
                end
            end
        })

        MainTab:CreateButton({
            Name = "🚨 Make Him Chase You",
            Callback = function()
                if Rake and RootPart then
                    local rakePos = Rake:FindFirstChild("HumanoidRootPart")
                    if rakePos then
                        local targetPos = rakePos.Position + (rakePos.Position - RootPart.Position).Unit * 20
                        pcall(function()
                            RootPart.CFrame = CFrame.new(targetPos)
                        end)
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
                Toggles.ESPItems = Value
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
                if Value and Character then
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

        MiscTab:CreateButton({
            Name = "🔄 Reset All Settings",
            Callback = function()
                for toggle, _ in pairs(Toggles) do
                    Toggles[toggle] = false
                end
                print("Tum ayarlar sifirlandi!")
            end
        })

        MiscTab:CreateButton({
            Name = "ℹ️ Hub Info",
            Callback = function()
                print("DOLAROV X HUB v2.0")
                print("The Rake Remastered - Premium")
                print("Gelismis Bypass & Silent Aim")
                print("Mobil Uyumlu")
            end
        })

        print("DOLAROV X HUB v2.0 baslatildi!")
    end

    -- Hub'i baslat
    pcall(function()
        SetupHub()
    end)
end

-- LISANS KONTROLUNU BASLAT
task.spawn(function()
    task.wait(0.5)
    LicenseCheck()
end)

print("DOLAROV X HUB - Yukleniyor...")
print("Premium Lisans Kontrol Ediliyor...")
