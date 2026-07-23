--[[
  LORD HUB V5 — MURDER MYSTERY 2  (PROFESYONEL)
  ✅ Katil olduğunda otomatik bıçak fırlatma (TP YOK)
  ✅ Şerif olduğunda otomatik katil vurma
  ✅ Gelişmiş ESP (Kırmızı/Yeşil)
  ✅ Oyuncuları yanına çekip kesme sistemi
  ✅ FPS oyunu kalitesinde performans
  ✅ Modern UI tasarımı
--]]

local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local TS       = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris   = game:GetService("Debris")
local VU       = game:GetService("VirtualUser")
local lp       = Players.LocalPlayer
local pgui     = lp.PlayerGui
local cam      = workspace.CurrentCamera
local mouse    = lp:GetMouse()

if pgui:FindFirstChild("LORDHUBV5") then pgui.LORDHUBV5:Destroy() end

-- ══════════════════════════════════════════════
-- OPTİMİZASYON & PERFORMANS
-- ══════════════════════════════════════════════
local Connections = {}
local FPS = 60
local frameTime = 0
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

RS.Heartbeat:Connect(function(dt)
    frameTime = dt
    FPS = math.clamp(1 / (dt + 0.001), 1, 144)
end)

local function connectEvent(event, fn, tag)
    local c = event:Connect(fn)
    if tag then
        if Connections[tag] then Connections[tag]:Disconnect() end
        Connections[tag] = c
    end
    return c
end

local function disconnectEvent(tag)
    if Connections[tag] then
        Connections[tag]:Disconnect()
        Connections[tag] = nil
    end
end

-- ══════════════════════════════════════════════
-- YARDIMCI FONKSİYONLAR
-- ══════════════════════════════════════════════
local function getCharacter() return lp.Character end
local function getRoot() 
    local c = getCharacter()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHumanoid()
    local c = getCharacter()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getPlayerRole(plr)
    if plr == lp then return "self" end
    local char = plr.Character
    if not char then return "unknown" end
    
    -- Ölü kontrolü
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return "dead" end
    
    -- Elindeki eşyaya göre rol tespiti
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("knife") or name:find("bıçak") or name:find("sickle") or 
               name:find("blade") or name:find("dagger") or name:find("chrome") then
                return "murderer"
            end
            if name:find("gun") or name:find("revolver") or name:find("sheriff") or
               name:find("pistol") or name:find("magnum") or name:find("luger") then
                return "sheriff"
            end
        end
    end
    return "innocent"
end

local function isVisible(from, to)
    local dir = to - from
    local dist = dir.Magnitude
    if dist < 0.1 then return true end
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then table.insert(filter, p.Character) end
    end
    params.FilterDescendantsInstances = filter
    
    local ray = workspace:Raycast(from, dir.Unit * dist, params)
    return not ray
end

local function findNearest(roles, maxDist)
    local root = getRoot()
    if not root then return nil, math.huge end
    
    local best, bestDist = nil, maxDist or math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lp then continue end
        local role = getPlayerRole(plr)
        if role == "dead" then continue end
        
        local match = false
        for _, r in pairs(roles) do
            if role == r then match = true; break end
        end
        if not match then continue end
        
        local tRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not tRoot then continue end
        
        local dist = (tRoot.Position - root.Position).Magnitude
        if dist < bestDist then
            bestDist = dist
            best = plr
        end
    end
    return best, bestDist
end

local function findMurderer()
    return findNearest({"murderer"}, math.huge)
end

local function findInnocents()
    return findNearest({"innocent", "sheriff"}, math.huge)
end

-- ══════════════════════════════════════════════
-- REMOTE BULMA SİSTEMİ
-- ══════════════════════════════════════════════
local throwRemote = nil
local function findThrowRemote()
    if throwRemote then return throwRemote end
    
    local keywords = {"throw", "attack", "swing", "stab", "hit", "slash", "fire", "shoot", "kill", "damage"}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if name:find(kw) then
                    throwRemote = obj
                    return obj
                end
            end
        end
    end
    return nil
end

-- ══════════════════════════════════════════════
-- SALDIRI SİSTEMİ (TP YOK - SADECE FIRLATMA)
-- ══════════════════════════════════════════════
local throwCooldown = 0
local attackDelay = 0.06

local function throwKnife(target, force)
    if not target then return false end
    local now = tick()
    if now - throwCooldown < attackDelay and not force then return false end
    throwCooldown = now
    
    local root = getRoot()
    if not root then return false end
    
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return false end
    
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    if tHum and tHum.Health <= 0 then return false end
    
    -- Hedefe yönel (TP yok!)
    local aimPos = tRoot.Position
    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(aimPos.X, root.Position.Y, aimPos.Z))
    
    local char = getCharacter()
    if not char then return false end
    
    -- Eldeki tool'u bul
    local tool = nil
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then
            tool = t
            break
        end
    end
    
    -- Remote ateşle
    local remote = findThrowRemote()
    if remote then
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(aimPos)
                remote:FireServer(tRoot)
            else
                remote:InvokeServer(aimPos)
            end
        end)
    end
    
    -- Tool aktivasyonu
    if tool then
        pcall(function()
            -- Tool içindeki remote
            local toolRemote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
            if toolRemote then
                if toolRemote:IsA("RemoteEvent") then
                    toolRemote:FireServer(aimPos)
                    toolRemote:FireServer(tRoot)
                else
                    toolRemote:InvokeServer(aimPos)
                end
            end
            tool:Activate()
        end)
    end
    
    return true
end

-- ══════════════════════════════════════════════
-- OTOMATİK SALDIRI SİSTEMLERİ
-- ══════════════════════════════════════════════
local autoAttackOn = false
local autoAttackTarget = nil

-- Katil olarak oyuncuları yanına çekip kesme
local pullRange = 30
local pullEnabled = false

local function pullPlayer(target)
    if not target then return end
    local root = getRoot()
    if not root then return end
    
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    
    local dist = (tRoot.Position - root.Position).Magnitude
    if dist > pullRange then return end
    
    -- Oyuncuyu yanına çek
    local pullPos = root.Position + (tRoot.Position - root.Position).Unit * 3
    tRoot.CFrame = CFrame.new(pullPos)
    
    -- Bıçak fırlat
    throwKnife(target, true)
end

-- Otomatik saldırı loop'u
local function startAutoAttack()
    if autoAttackOn then return end
    autoAttackOn = true
    
    connectEvent(RS.Heartbeat, function()
        if not autoAttackOn then return end
        
        local role = getPlayerRole(lp)
        local root = getRoot()
        if not root then return end
        
        if role == "murderer" then
            -- Katil: En yakın oyuncuyu bul ve fırlat
            local target = findNearest({"innocent", "sheriff"}, 50)
            if target then
                -- Oyuncuyu yanına çek (pull)
                local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local dist = (tRoot.Position - root.Position).Magnitude
                    if dist < pullRange and pullEnabled then
                        local pullPos = root.Position + (tRoot.Position - root.Position).Unit * 3
                        tRoot.CFrame = CFrame.new(pullPos)
                    end
                end
                throwKnife(target, true)
            end
            
        elseif role == "sheriff" then
            -- Şerif: Katili bul ve vur
            local murderer = findMurderer()
            if murderer then
                throwKnife(murderer, true)
            end
        end
        
    end, "autoAttack")
end

local function stopAutoAttack()
    autoAttackOn = false
    disconnectEvent("autoAttack")
end

-- ══════════════════════════════════════════════
-- ESP SİSTEMİ (KIRMIZI / YEŞİL)
-- ══════════════════════════════════════════════
local espEnabled = false
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function createESP(plr)
    if plr == lp then return end
    
    local char = plr.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local role = getPlayerRole(plr)
    local isMurderer = role == "murderer"
    local color = isMurderer and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
    local roleText = isMurderer and "🔴 KATİL" or "🟢 MASUM"
    
    local bill = Instance.new("BillboardGui", head)
    bill.Name = "ESP_V5"
    bill.AlwaysOnTop = true
    bill.Size = UDim2.fromOffset(200, 70)
    bill.StudsOffset = Vector3.new(0, 3.5, 0)
    bill.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Arka plan
    local bg = Instance.new("Frame", bill)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.4
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    
    -- Çerçeve (renkli)
    local stroke = Instance.new("UIStroke", bg)
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    -- İsim
    local nameLabel = Instance.new("TextLabel", bg)
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Rol
    local roleLabel = Instance.new("TextLabel", bg)
    roleLabel.Size = UDim2.new(1, 0, 0.35, 0)
    roleLabel.Position = UDim2.new(0, 0, 0.4, 0)
    roleLabel.Text = roleText
    roleLabel.TextColor3 = color
    roleLabel.TextSize = 12
    roleLabel.Font = Enum.Font.GothamSemibold
    roleLabel.BackgroundTransparency = 1
    roleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Can
    local healthLabel = Instance.new("TextLabel", bg)
    healthLabel.Size = UDim2.new(1, 0, 0.25, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.75, 0)
    healthLabel.Text = "❤️ " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
    healthLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    healthLabel.TextSize = 10
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Can değişimini takip et
    hum:GetPropertyChangedSignal("Health"):Connect(function()
        if healthLabel.Parent then
            healthLabel.Text = "❤️ " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
        end
    end)
    
    -- Mesafe güncellemesi
    local root = getRoot()
    if root then
        local distLabel = Instance.new("TextLabel", bg)
        distLabel.Size = UDim2.new(1, 0, 0.25, 0)
        distLabel.Position = UDim2.new(0, 0, 0.75, 0)
        distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        distLabel.TextSize = 10
        distLabel.Font = Enum.Font.Gotham
        distLabel.BackgroundTransparency = 1
        distLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        connectEvent(RS.Heartbeat, function()
            if distLabel.Parent and root and head then
                local dist = (head.Position - root.Position).Magnitude
                distLabel.Text = math.floor(dist) .. "m"
            end
        end, "dist_" .. plr.Name)
    end
    
    table.insert(espObjects, bill)
end

local function buildESP()
    clearESP()
    if not espEnabled then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        createESP(plr)
    end
end

local function toggleESP(on)
    espEnabled = on
    if on then
        buildESP()
        connectEvent(Players.PlayerAdded, function() task.wait(0.1); buildESP() end, "espAdd")
        connectEvent(Players.PlayerRemoving, function() task.wait(0.1); buildESP() end, "espRemove")
        connectEvent(workspace.DescendantAdded, function(obj)
            if obj:IsA("Tool") or obj.Name == "Head" then
                task.wait(0.05)
                if espEnabled then buildESP() end
            end
        end, "espTool")
    else
        clearESP()
        disconnectEvent("espAdd")
        disconnectEvent("espRemove")
        disconnectEvent("espTool")
    end
end

-- ══════════════════════════════════════════════
-- MODERN UI
-- ══════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "LORDHUBV5"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999

local function getScale()
    local w, h = cam.ViewportSize.X, cam.ViewportSize.Y
    local base = isMobile and math.min(w, h) / 390 or 1
    return math.clamp(base, 0.8, 1.3)
end

local SCALE = getScale()
local function S(n) return math.floor(n * SCALE) end

-- Ana Pencere
local win = Instance.new("Frame", sg)
win.Size = UDim2.fromOffset(isMobile and 340 or 400, isMobile and 500 or 550)
win.Position = UDim2.new(0.5, -win.Size.X.Offset/2, 0.5, -win.Size.Y.Offset/2)
win.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
win.BackgroundTransparency = 0.05
win.BorderSizePixel = 0
win.ClipsDescendants = true
win.Active = true
win.Draggable = true

Instance.new("UICorner", win).CornerRadius = UDim.new(0, 16)

-- Arka plan efekti
local bgEffect = Instance.new("ImageLabel", win)
bgEffect.Size = UDim2.new(1, 0, 1, 0)
bgEffect.BackgroundTransparency = 1
bgEffect.Image = "rbxassetid://1316045217"
bgEffect.ImageColor3 = Color3.fromRGB(30, 80, 200)
bgEffect.ImageTransparency = 0.85
bgEffect.ScaleType = Enum.ScaleType.Slice
bgEffect.SliceCenter = Rect.new(10, 10, 118, 118)

-- Başlık
local header = Instance.new("Frame", win)
header.Size = UDim2.new(1, 0, 0, S(60))
header.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -S(40), 1, 0)
title.Position = UDim2.new(0, S(20), 0, 0)
title.Text = "🔥 LORD HUB V5"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = S(isMobile and 18 or 22)
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local subTitle = Instance.new("TextLabel", header)
subTitle.Size = UDim2.new(1, -S(40), 0, S(20))
subTitle.Position = UDim2.new(0, S(20), 0, S(35))
subTitle.Text = "PROFESSIONAL MURDER MYSTERY 2"
subTitle.TextColor3 = Color3.fromRGB(100, 180, 255)
subTitle.TextSize = S(isMobile and 9 or 11)
subTitle.Font = Enum.Font.GothamSemibold
subTitle.BackgroundTransparency = 1
subTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Kapat butonu
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.fromOffset(S(36), S(36))
closeBtn.Position = UDim2.new(1, -S(44), 0, S(12))
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = S(16)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 50)
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    win.Visible = not win.Visible
    quickBar.Visible = not quickBar.Visible
end)

-- İçerik
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, 0, 1, -S(60))
content.Position = UDim2.new(0, 0, 0, S(60))
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = isMobile and 3 or 2
content.ScrollBarImageColor3 = Color3.fromRGB(30, 120, 255)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ClipsDescendants = false

local padding = Instance.new("UIPadding", content)
padding.PaddingLeft = UDim.new(0, S(10))
padding.PaddingRight = UDim.new(0, S(10))
padding.PaddingTop = UDim.new(0, S(10))
padding.PaddingBottom = UDim.new(0, S(10))

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, S(8))
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ══════════════════════════════════════════════
-- UI BİLEŞENLERİ
-- ══════════════════════════════════════════════
local function Section(text)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, S(30))
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "▸ " .. text
    label.TextColor3 = Color3.fromRGB(30, 120, 255)
    label.TextSize = S(12)
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local line = Instance.new("Frame", frame)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
end

local function Button(text, color, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, 0, 0, S(isMobile and 50 or 40))
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = S(isMobile and 14 or 12)
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 80, 200)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    -- Hover efekti
    local hoverTween = TS:Create(btn, TweenInfo.new(0.15), {
        BackgroundTransparency = 0.3,
        Size = UDim2.new(0.97, 0, 0, S(isMobile and 50 or 40))
    })
    local leaveTween = TS:Create(btn, TweenInfo.new(0.15), {
        BackgroundTransparency = 0,
        Size = UDim2.new(1, 0, 0, S(isMobile and 50 or 40))
    })
    
    btn.MouseEnter:Connect(function() hoverTween:Play() end)
    btn.MouseLeave:Connect(function() leaveTween:Play() end)
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

local function Toggle(text, defaultValue, callback)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, S(isMobile and 50 or 42))
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, S(12), 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextSize = S(isMobile and 13 or 11)
    label.Font = Enum.Font.GothamSemibold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local switchBg = Instance.new("Frame", frame)
    local swW, swH = S(50), S(26)
    switchBg.Size = UDim2.fromOffset(swW, swH)
    switchBg.Position = UDim2.new(1, -swW - S(10), 0.5, -swH/2)
    switchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    switchBg.BorderSizePixel = 0
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", switchBg)
    local knW = S(18)
    knob.Size = UDim2.fromOffset(knW, knW)
    knob.Position = UDim2.new(0, S(4), 0.5, -knW/2)
    knob.BackgroundColor3 = Color3.fromRGB(150, 150, 180)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local isOn = defaultValue or false
    
    local function setState(on)
        isOn = on
        local color = on and Color3.fromRGB(30, 200, 80) or Color3.fromRGB(50, 50, 70)
        local knobColor = on and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 180)
        local knobPos = on and UDim2.new(0, swW - knW - S(4), 0.5, -knW/2) or UDim2.new(0, S(4), 0.5, -knW/2)
        
        TS:Create(switchBg, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        TS:Create(knob, TweenInfo.new(0.15), {
            Position = knobPos,
            BackgroundColor3 = knobColor
        }):Play()
        
        callback(on)
    end
    
    frame.MouseButton1Click:Connect(function() setState(not isOn) end)
    
    setState(defaultValue or false)
    
    return {
        set = setState,
        get = function() return isOn end
    }
end

local function Slider(text, min, max, default, callback)
    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1, 0, 0, S(isMobile and 60 or 50))
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.6, 0, 0, S(22))
    label.Position = UDim2.new(0, S(12), 0, S(4))
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextSize = S(isMobile and 13 or 11)
    label.Font = Enum.Font.GothamSemibold
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0.3, 0, 0, S(22))
    valueLabel.Position = UDim2.new(0.6, 0, 0, S(4))
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(30, 180, 255)
    valueLabel.TextSize = S(isMobile and 13 or 11)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, -S(20), 0, S(6))
    sliderBg.Position = UDim2.new(0, S(10), 0, S(40))
    sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    sliderBg.BorderSizePixel = 0
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", sliderBg)
    local knobSize = S(18)
    knob.Size = UDim2.fromOffset(knobSize, knobSize)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local isDragging = false
    local value = default
    
    local function updateValue(x)
        local p = math.clamp((x - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + p * (max - min))
        valueLabel.Text = tostring(value)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        callback(value)
    end
    
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateValue(input.Position.X)
        end
    end
    
    sliderBg.InputBegan:Connect(startDrag)
    knob.InputBegan:Connect(startDrag)
    
    UIS.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                          input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input.Position.X)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end

-- ══════════════════════════════════════════════
-- AYARLAR & DURUM
-- ══════════════════════════════════════════════
local attackRange = 40
local pullEnabled = true

-- Rol durumunu göster
local statusFrame = Instance.new("Frame", content)
statusFrame.Size = UDim2.new(1, 0, 0, S(50))
statusFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
statusFrame.BackgroundTransparency = 0.5
statusFrame.BorderSizePixel = 0
Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 10)

local statusText = Instance.new("TextLabel", statusFrame)
statusText.Size = UDim2.new(1, -S(20), 1, 0)
statusText.Position = UDim2.new(0, S(10), 0, 0)
statusText.Text = "🔍 Rol: Bekleniyor..."
statusText.TextColor3 = Color3.fromRGB(200, 200, 255)
statusText.TextSize = S(isMobile and 14 or 12)
statusText.Font = Enum.Font.GothamBold
statusText.BackgroundTransparency = 1
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.TextWrapped = true

-- Rol takibi
connectEvent(RS.Heartbeat, function()
    local role = getPlayerRole(lp)
    local emoji = role == "murderer" and "🔪" or role == "sheriff" and "🔫" or "👤"
    local color = role == "murderer" and Color3.fromRGB(255, 50, 50) or 
                  role == "sheriff" and Color3.fromRGB(50, 150, 255) or
                  Color3.fromRGB(100, 255, 100)
    local text = emoji .. " " .. string.upper(role) .. (role == "murderer" and " - OTOMATİK SALDIRI AKTİF!" or 
                  role == "sheriff" and " - KATİL AVI AKTİF!" or " - BEKLEME MODU")
    statusText.Text = text
    statusText.TextColor3 = color
end, "statusUpdate")

-- ══════════════════════════════════════════════
-- OTOMATİK SALDIRI AYARLARI
-- ══════════════════════════════════════════════
Section("⚔️ OTOMATİK SALDIRI")

Button("🔥 OTOMATİK SALDIRIYI BAŞLAT", Color3.fromRGB(30, 200, 80), function()
    startAutoAttack()
end)

Button("⏹️ SALDIRIYI DURDUR", Color3.fromRGB(200, 30, 50), function()
    stopAutoAttack()
end)

Toggle("👥 Oyuncuları Yanına Çek", true, function(on)
    pullEnabled = on
end)

Slider("🎯 Saldırı Menzili", 10, 80, 40, function(value)
    attackRange = value
end)

Section("🎯 HEDEF SEÇİMİ")

-- Manuel hedef seçme
local targetList = Instance.new("ScrollingFrame", content)
targetList.Size = UDim2.new(1, 0, 0, S(isMobile and 120 or 100))
targetList.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
targetList.BackgroundTransparency = 0.5
targetList.BorderSizePixel = 0
targetList.ScrollBarThickness = isMobile and 3 or 2
targetList.ScrollBarImageColor3 = Color3.fromRGB(30, 120, 255)
Instance.new("UICorner", targetList).CornerRadius = UDim.new(0, 10)

local targetButtons = {}

local function refreshTargetList()
    for _, btn in pairs(targetButtons) do
        pcall(function() btn:Destroy() end)
    end
    targetButtons = {}
    
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            local btn = Instance.new("TextButton", targetList)
            btn.Size = UDim2.new(1, -S(10), 0, S(30))
            btn.Position = UDim2.new(0, S(5), 0, y)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = S(isMobile and 12 or 10)
            btn.Font = Enum.Font.GothamSemibold
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            btn.MouseButton1Click:Connect(function()
                autoAttackTarget = plr
                for _, b in pairs(targetButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                end
                btn.BackgroundColor3 = Color3.fromRGB(30, 120, 255)
            end)
            
            table.insert(targetButtons, btn)
            y = y + S(34)
        end
    end
    
    targetList.CanvasSize = UDim2.new(0, 0, 0, y + S(10))
end

refreshTargetList()

Button("🔄 Oyuncu Listesini Yenile", Color3.fromRGB(30, 80, 200), function()
    refreshTargetList()
end)

-- ══════════════════════════════════════════════
-- ESP AYARLARI
-- ══════════════════════════════════════════════
Section("👁️ ESP SİSTEMİ")

Toggle("🔴 KIRMIZI / YEŞİL ESP", true, function(on)
    toggleESP(on)
end)

Button("🔄 ESP'Yİ YENİLE", Color3.fromRGB(30, 80, 200), function()
    if espEnabled then buildESP() end
end)

-- ══════════════════════════════════════════════
-- KARAKTER AYARLARI
-- ══════════════════════════════════════════════
Section("⚡ KARAKTER AYARLARI")

Slider("🏃 Hız", 16, 350, 16, function(value)
    local hum = getHumanoid()
    if hum then hum.WalkSpeed = value end
end)

Slider("⬆️ Zıplama Gücü", 50, 500, 50, function(value)
    local hum = getHumanoid()
    if hum then
        pcall(function() hum.JumpPower = value end)
        pcall(function() hum.JumpHeight = value / 5 end)
    end
end)

Toggle("🚀 Sonsuz Zıplama", false, function(on)
    if on then
        connectEvent(UIS.JumpRequest, function()
            local hum = getHumanoid()
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end, "infiniteJump")
    else
        disconnectEvent("infiniteJump")
    end
end)

Toggle("🛡️ God Mode", false, function(on)
    local hum = getHumanoid()
    if not hum then return end
    
    if on then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        connectEvent(hum.HealthChanged, function()
            if hum and hum.Parent then hum.Health = math.huge end
        end, "godMode")
    else
        disconnectEvent("godMode")
        pcall(function()
            hum.MaxHealth = 100
            hum.Health = 100
        end)
    end
end)

Toggle("💤 Anti-AFK", false, function(on)
    if on then
        connectEvent(RS.Heartbeat, function()
            VU:Button2Down(Vector2.zero, cam.CFrame)
            VU:Button2Up(Vector2.zero, cam.CFrame)
        end, "antiAfk")
    else
        disconnectEvent("antiAfk")
    end
end)

Button("🔄 Respawn", Color3.fromRGB(200, 150, 50), function()
    lp:LoadCharacter()
end)

-- ══════════════════════════════════════════════
-- GÖRSEL AYARLAR
-- ══════════════════════════════════════════════
Section("🎨 GÖRSEL AYARLAR")

Toggle("💡 Fullbright", false, function(on)
    if on then
        Lighting.Brightness = 10
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000
        Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    end
end)

Slider("🎥 FOV", 50, 120, 70, function(value)
    cam.FieldOfView = value
end)

-- ══════════════════════════════════════════════
-- HIZLI BUTONLAR (MOBİL)
-- ══════════════════════════════════════════════
local quickBar = Instance.new("Frame", sg)
quickBar.Size = UDim2.fromOffset(S(70), S(280))
quickBar.Position = UDim2.new(1, -S(85), 0.5, -S(140))
quickBar.BackgroundTransparency = 1
quickBar.Visible = true

local quickButtons = {}

local function createQuickButton(icon, color, tooltip, callback, yPos)
    local btn = Instance.new("TextButton", quickBar)
    btn.Size = UDim2.fromOffset(S(60), S(60))
    btn.Position = UDim2.fromOffset(0, yPos or 0)
    btn.Text = icon
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = S(isMobile and 24 or 20)
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, S(12))
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    
    -- Tooltip
    local tip = Instance.new("TextLabel", sg)
    tip.Text = tooltip
    tip.TextColor3 = Color3.new(1, 1, 1)
    tip.TextSize = S(10)
    tip.Font = Enum.Font.GothamSemibold
    tip.Size = UDim2.fromOffset(S(120), S(28))
    tip.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    tip.BorderSizePixel = 0
    tip.Visible = false
    Instance.new("UICorner", tip).CornerRadius = UDim.new(0, 6)
    
    btn.MouseEnter:Connect(function()
        local abs = btn.AbsolutePosition
        tip.Position = UDim2.fromOffset(abs.X - S(130), abs.Y + S(16))
        tip.Visible = true
    end)
    btn.MouseLeave:Connect(function()
        tip.Visible = false
    end)
    
    btn.MouseButton1Click:Connect(callback)
    
    return btn
end

-- Menü Aç/Kapat
createQuickButton("☰", Color3.fromRGB(30, 80, 200), "Menü", function()
    win.Visible = not win.Visible
end, 0)

-- Otomatik Saldırı Başlat
createQuickButton("⚔️", Color3.fromRGB(30, 200, 80), "Saldırı Başlat", function()
    startAutoAttack()
end, S(70))

-- Otomatik Saldırı Durdur
createQuickButton("⏹️", Color3.fromRGB(200, 30, 50), "Saldırı Durdur", function()
    stopAutoAttack()
end, S(140))

-- ESP Aç/Kapat
createQuickButton("👁️", Color3.fromRGB(100, 100, 200), "ESP", function()
    toggleESP(not espEnabled)
end, S(210))

-- ══════════════════════════════════════════════
-- KLAVYE KISAYOLLARI
-- ══════════════════════════════════════════════
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        win.Visible = not win.Visible
        quickBar.Visible = not quickBar.Visible
    elseif input.KeyCode == Enum.KeyCode.Delete then
        win.Visible = false
        quickBar.Visible = false
    elseif input.KeyCode == Enum.KeyCode.Insert then
        win.Visible = true
        quickBar.Visible = true
    elseif input.KeyCode == Enum.KeyCode.F then
        if autoAttackOn then
            stopAutoAttack()
        else
            startAutoAttack()
        end
    elseif input.KeyCode == Enum.KeyCode.E then
        toggleESP(not espEnabled)
    end
end)

-- ══════════════════════════════════════════════
-- OYUNCU EKLEME/ÇIKARMA
-- ══════════════════════════════════════════════
Players.PlayerAdded:Connect(function()
    task.wait(0.3)
    refreshTargetList()
    if espEnabled then buildESP() end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    refreshTargetList()
    if espEnabled then buildESP() end
end)

lp.CharacterAdded:Connect(function()
    task.wait(1)
    if espEnabled then buildESP() end
    refreshTargetList()
end)

-- ══════════════════════════════════════════════
-- BAŞLANGIÇ
-- ══════════════════════════════════════════════
print("🔥 LORD HUB V5 YÜKLENDİ!")
print("📌 KATİL: Otomatik bıçak fırlatma + Oyuncuları çekme")
print("📌 ŞERİF: Otomatik katil vurma")
print("📌 Kısayollar: F=Saldırı, E=ESP, RightShift=Menü")
print("📌 TP KALDIRILDI - Sadece fırlatma sistemi aktif!")
