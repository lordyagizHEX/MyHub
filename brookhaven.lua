--[[
  ╔══════════════════════════════════════════════════════════════════╗
  ║        SLAYER HUB — BROOKHAVEN RP  V2                          ║
  ║  ✅ Player Seçme | ✅ Boat Spawn | ✅ Fling                    ║
  ║  ✅ Düz GUI | ✅ Çalışan Fizik                                ║
  ╚══════════════════════════════════════════════════════════════════╝
--]]

-- ── Servisler ───────────────────────────────────────────────────
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer
local pgui = lp.PlayerGui
local cam = Workspace.CurrentCamera

-- Eski GUI temizle
if pgui:FindFirstChild("SlayerHub") then pgui.SlayerHub:Destroy() end

-- ── Boyutlar ──────────────────────────────────────────────────
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp = cam.ViewportSize
local SCALE = isMobile and math.clamp(vp.X / 480, 0.7, 1.25) or 1
local function S(n) return math.floor(n * SCALE) end

-- ── Bağlantılar ──────────────────────────────────────────────
local Connections = {}
local function conn(e, fn, tag)
    local c = e:Connect(fn)
    if tag then
        if Connections[tag] then Connections[tag]:Disconnect() end
        Connections[tag] = c
    end
    return c
end
local function disc(tag)
    if Connections[tag] then Connections[tag]:Disconnect(); Connections[tag] = nil end
end

local function C() return lp.Character end
local function R() local c = C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H() local c = C(); return c and c:FindFirstChildOfClass("Humanoid") end

-- ════════════════════════════════════════════════════════════════
--  RENKLER
-- ════════════════════════════════════════════════════════════════
local COL = {
    BG = Color3.fromRGB(20, 20, 26),
    BG2 = Color3.fromRGB(30, 30, 42),
    ACCENT = Color3.fromRGB(255, 200, 80),
    ACCENT2 = Color3.fromRGB(180, 140, 60),
    TEXT = Color3.fromRGB(255, 255, 255),
    SUB = Color3.fromRGB(150, 150, 170),
    GREEN = Color3.fromRGB(80, 255, 120),
    RED = Color3.fromRGB(255, 60, 60),
    GOLD = Color3.fromRGB(255, 200, 80),
}

-- ════════════════════════════════════════════════════════════════
--  ANA GUI — DÜZ, TEMİZ, KULLANIŞLI
-- ════════════════════════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SlayerHub"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true

local WIN_W = math.min(S(380), vp.X * 0.85)
local WIN_H = math.min(S(460), vp.Y * 0.85)

local win = Instance.new("Frame", sg)
win.Size = UDim2.fromOffset(WIN_W, WIN_H)
win.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
win.BackgroundColor3 = COL.BG
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0, S(10))
do local s = Instance.new("UIStroke", win) s.Color = COL.GOLD; s.Thickness = 1.5; s.Transparency = 0.5 end

-- Başlık
local titleBar = Instance.new("Frame", win)
titleBar.Size = UDim2.new(1, 0, 0, S(44))
titleBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, S(10))

local logo = Instance.new("TextLabel", titleBar)
logo.Size = UDim2.new(1, -S(100), 1, 0)
logo.Position = UDim2.new(0, S(12), 0, 0)
logo.Text = "⚡ SLAYER HUB"
logo.TextSize = S(16)
logo.Font = Enum.Font.GothamBold
logo.TextColor3 = COL.GOLD
logo.BackgroundTransparency = 1
logo.TextXAlignment = Enum.TextXAlignment.Left

local sub = Instance.new("TextLabel", titleBar)
sub.Size = UDim2.new(0, S(80), 1, 0)
sub.Position = UDim2.new(0, S(120), 0, 0)
sub.Text = "by Slayer"
sub.TextSize = S(10)
sub.Font = Enum.Font.Gotham
sub.TextColor3 = COL.SUB
sub.BackgroundTransparency = 1
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextYAlignment = Enum.TextYAlignment.Bottom

-- Kapat butonu
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.fromOffset(S(28), S(28))
closeBtn.Position = UDim2.new(1, -S(34), 0.5, -S(14))
closeBtn.Text = "✕"
closeBtn.TextSize = S(14)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = COL.RED
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, S(6))
closeBtn.MouseButton1Click:Connect(function() win.Visible = false end)

-- Ana ScrollingFrame
local scroll = Instance.new("ScrollingFrame", win)
scroll.Size = UDim2.new(1, -S(8), 1, -titleBar.Size.Y.Offset - S(8))
scroll.Position = UDim2.new(0, S(4), 0, titleBar.Size.Y.Offset + S(4))
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = S(3)
scroll.ScrollBarImageColor3 = COL.GOLD
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, S(6))
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local pad = Instance.new("UIPadding", scroll)
pad.PaddingTop = UDim.new(0, S(4))
pad.PaddingBottom = UDim.new(0, S(4))

-- ════════════════════════════════════════════════════════════════
--  BİLEŞENLER
-- ════════════════════════════════════════════════════════════════

-- Kategori başlığı
local function category(title)
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1, -S(8), 0, S(28))
    f.BackgroundTransparency = 1
    
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1, 0, 0, S(1.5))
    line.Position = UDim2.new(0, 0, 1, -S(2))
    line.BackgroundColor3 = COL.GOLD
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0, S(140), 1, 0)
    lbl.Position = UDim2.new(0.5, -S(70), 0, 0)
    lbl.Text = title
    lbl.TextSize = S(12)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = COL.GOLD
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    return f
end

-- Buton (Tek satır)
local function button(text, icon, color, callback)
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1, -S(8), 0, S(38))
    f.BackgroundColor3 = COL.BG2
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, S(6))
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = icon .. "  " .. text
    btn.TextSize = S(12)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = COL.TEXT
    btn.TextXAlignment = Enum.TextXAlignment.Center
    
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = color or COL.ACCENT2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = COL.BG2}):Play()
    end)
    return f
end

-- Toggle (Aç/Kapa)
local function toggle(text, icon, default, callback)
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1, -S(8), 0, S(38))
    f.BackgroundColor3 = COL.BG2
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, S(6))
    
    local state = default or false
    
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -S(56), 1, 0)
    lbl.Position = UDim2.new(0, S(8), 0, 0)
    lbl.Text = icon .. "  " .. text
    lbl.TextSize = S(12)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextColor3 = COL.TEXT
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local tog = Instance.new("Frame", f)
    tog.Size = UDim2.fromOffset(S(40), S(22))
    tog.Position = UDim2.new(1, -S(48), 0.5, -S(11))
    tog.BackgroundColor3 = COL.SUB
    tog.BorderSizePixel = 0
    Instance.new("UICorner", tog).CornerRadius = UDim.new(1, 0)
    
    local knob = Instance.new("Frame", tog)
    knob.Size = UDim2.fromOffset(S(16), S(16))
    knob.Position = UDim2.new(0, S(3), 0.5, -S(8))
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    local function setState(v)
        state = v
        if v then
            tog.BackgroundColor3 = COL.GREEN
            knob.Position = UDim2.new(0, S(40) - S(16) - S(3), 0.5, -S(8))
        else
            tog.BackgroundColor3 = COL.SUB
            knob.Position = UDim2.new(0, S(3), 0.5, -S(8))
        end
        callback(v)
    end
    
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseButton1Click:Connect(function() setState(not state) end)
    
    setState(state)
    return f, setState
end

-- Player seçme listesi
local selectedPlayer = nil
local playerListFrame = nil

local function createPlayerList()
    if playerListFrame then playerListFrame:Destroy() end
    
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(1, -S(8), 0, S(120))
    f.BackgroundColor3 = COL.BG2
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, S(6))
    playerListFrame = f
    
    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1, 0, 0, S(24))
    title.Text = "🎯 HEDEF OYUNCU"
    title.TextSize = S(11)
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = COL.GOLD
    title.BackgroundTransparency = 1
    
    local list = Instance.new("ScrollingFrame", f)
    list.Size = UDim2.new(1, -S(4), 1, -S(28))
    list.Position = UDim2.new(0, S(2), 0, S(26))
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = S(2)
    list.ScrollBarImageColor3 = COL.GOLD
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local layout2 = Instance.new("UIListLayout", list)
    layout2.Padding = UDim.new(0, S(2))
    
    local selectedLabel = Instance.new("TextLabel", f)
    selectedLabel.Size = UDim2.new(1, 0, 0, S(18))
    selectedLabel.Position = UDim2.new(0, 0, 0, S(100))
    selectedLabel.Text = "Seçili: Hiçbiri"
    selectedLabel.TextSize = S(9)
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextColor3 = COL.SUB
    selectedLabel.BackgroundTransparency = 1
    
    local function refreshList()
        for _, child in pairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        local players = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp then table.insert(players, p) end
        end
        
        if #players == 0 then
            local empty = Instance.new("TextLabel", list)
            empty.Size = UDim2.new(1, 0, 0, S(22))
            empty.Text = "❌ Başka oyuncu yok"
            empty.TextSize = S(10)
            empty.Font = Enum.Font.Gotham
            empty.TextColor3 = COL.SUB
            empty.BackgroundTransparency = 1
            return
        end
        
        for _, plr in pairs(players) do
            local btn = Instance.new("TextButton", list)
            btn.Size = UDim2.new(1, 0, 0, S(26))
            btn.Text = "👤 " .. plr.Name
            btn.TextSize = S(10)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.TextColor3 = COL.TEXT
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, S(4))
            
            local plrRef = plr
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plrRef
                selectedLabel.Text = "Seçili: " .. plrRef.Name
                selectedLabel.TextColor3 = COL.GOLD
                for _, b in pairs(list:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(40, 40, 56)
                    end
                end
                btn.BackgroundColor3 = COL.ACCENT2
            end)
        end
    end
    
    refreshList()
    Players.PlayerAdded:Connect(function() task.wait(0.3); refreshList() end)
    Players.PlayerRemoving:Connect(function() task.wait(0.3); refreshList() end)
    
    return f
end

-- ════════════════════════════════════════════════════════════════
--  BOAT FLING SİSTEMİ
-- ════════════════════════════════════════════════════════════════

local spawnedBoat = nil
local boatSeat = nil
local boatRoot = nil
local boatFlingActive = false

-- Brookhaven Boat Spawn
local function spawnBoat()
    -- Eski tekneyi temizle
    if spawnedBoat then
        pcall(function() spawnedBoat:Destroy() end)
        spawnedBoat = nil
        boatSeat = nil
        boatRoot = nil
    end
    
    -- Remote ile boat spawn (Brookhaven)
    local spawnRemote = ReplicatedStorage:FindFirstChild("VehicleSpawn") or 
                       ReplicatedStorage:FindFirstChild("SpawnVehicle")
    
    if spawnRemote then
        pcall(function()
            spawnRemote:FireServer("Boat", "Speedboat")
        end)
        task.wait(1.5)
    end
    
    -- Spawn olan tekneyi bul
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") and obj.Parent and obj.Parent:IsA("Model") then
            local name = obj.Parent.Name:lower()
            if name:find("boat") or name:find("speed") or name:find("jet") then
                spawnedBoat = obj.Parent
                boatSeat = obj
                boatRoot = obj.Parent:FindFirstChild("HumanoidRootPart") or obj
                break
            end
        end
    end
    
    -- Eğer bulunamadıysa manuel oluştur
    if not spawnedBoat then
        local model = Instance.new("Model", Workspace)
        model.Name = "SlayerBoat"
        
        local hull = Instance.new("Part")
        hull.Size = Vector3.new(10, 2, 4)
        hull.Shape = Enum.PartType.Cylinder
        hull.Material = Enum.Material.Plastic
        hull.Color = Color3.fromRGB(255, 200, 80)
        hull.Anchored = false
        hull.CanCollide = true
        hull.Parent = model
        
        local seat = Instance.new("VehicleSeat")
        seat.Size = Vector3.new(3, 1, 2.5)
        seat.Position = Vector3.new(0, 2, 0)
        seat.MaxSpeed = 300
        seat.Torque = 500000
        seat.Parent = model
        
        spawnedBoat = model
        boatSeat = seat
        boatRoot = hull
        
        -- Suya yakın bir yere koy
        local pos = R()
        if pos then
            model:SetPrimaryPartCFrame(CFrame.new(pos.Position + Vector3.new(0, 2, 10)))
        end
    end
    
    return spawnedBoat
end

-- Fling fonksiyonu (AŞIRI GÜÇLÜ)
local function flingPlayer(target)
    if not target then return end
    local char = target.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- 1. BodyAngularVelocity - Aşırı dönüş
    local bav = Instance.new("BodyAngularVelocity")
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.AngularVelocity = Vector3.new(
        math.random(-99999, 99999),
        math.random(50000, 99999),
        math.random(-99999, 99999)
    )
    bav.Parent = root
    Debris:AddItem(bav, 0.15)
    
    -- 2. BodyVelocity - Aşırı hız
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(
        math.random(-99999, 99999),
        math.random(30000, 99999),
        math.random(-99999, 99999)
    )
    bv.Parent = root
    Debris:AddItem(bv, 0.15)
    
    -- 3. Direct Velocity
    root.AssemblyLinearVelocity = Vector3.new(
        math.random(-99999, 99999),
        math.random(30000, 99999),
        math.random(-99999, 99999)
    )
    root.AssemblyAngularVelocity = Vector3.new(
        math.random(-99999, 99999),
        math.random(-99999, 99999),
        math.random(-99999, 99999)
    )
end

-- Boat Fling (Tekneyi hedefe fırlat)
local function boatFling(target)
    if not spawnedBoat or not boatRoot then
        spawnBoat()
        task.wait(0.5)
        if not spawnedBoat then return end
    end
    
    if not target then return end
    local char = target.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Tekneyi hedefin üzerine ışınla
    local pos = root.Position + Vector3.new(0, 3, 0)
    boatRoot.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(math.random(-30, 30)), math.rad(math.random(0, 360)), math.rad(math.random(-30, 30)))
    
    -- Tekneye aşırı hız ver
    local bv = Instance.new("BodyVelocity", boatRoot)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(
        math.random(-99999, 99999),
        math.random(50000, 99999),
        math.random(-99999, 99999)
    )
    Debris:AddItem(bv, 0.15)
    
    -- Oyuncuyu da fırlat
    flingPlayer(target)
end

-- Tüm oyunculara fling
local function flingAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            flingPlayer(plr)
            task.wait(0.02)
        end
    end
end

-- ════════════════════════════════════════════════════════════════
--  GUI BİLEŞENLERİ
-- ════════════════════════════════════════════════════════════════

category("🚤 BOAT FLING")

-- Boat Spawn
button("🚤 Tekne Spawnla", "🚤", COL.ACCENT2, function()
    spawnBoat()
    local notif = Instance.new("TextLabel", sg)
    notif.Size = UDim2.fromOffset(S(200), S(30))
    notif.Position = UDim2.new(0.5, -S(100), 0.02, 0)
    notif.Text = "✅ Tekne Hazır!"
    notif.TextSize = S(12)
    notif.Font = Enum.Font.GothamBold
    notif.TextColor3 = COL.GREEN
    notif.BackgroundColor3 = COL.BG
    notif.BorderSizePixel = 0
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, S(6))
    task.delay(2, function() notif:Destroy() end)
end)

-- Player Listesi
createPlayerList()

-- Fling Butonları
button("🎯 Hedefe Fling", "🎯", COL.ACCENT2, function()
    if selectedPlayer then
        boatFling(selectedPlayer)
    else
        -- Yakındaki oyuncuyu bul
        local r2 = R()
        if r2 then
            local best, bestD = nil, math.huge
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= lp then
                    local t = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t then
                        local d = (t.Position - r2.Position).Magnitude
                        if d < bestD then bestD = d; best = plr end
                    end
                end
            end
            if best then boatFling(best) end
        end
    end
end)

button("💥 Tüm Oyuncular", "💥", COL.RED, function()
    flingAll()
end)

button("☄️ Süper Fling", "☄️", Color3.fromRGB(180, 50, 50), function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp then
            flingPlayer(plr)
            task.wait(0.01)
        end
    end
end)

-- Otomatik Fling Toggle
toggle("🔄 Otomatik Fling", "🔄", false, function(on)
    if on then
        boatFlingActive = true
        conn(RS.Heartbeat, function()
            if not boatFlingActive then return end
            local r2 = R()
            if not r2 then return end
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= lp then
                    local t = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t and (t.Position - r2.Position).Magnitude < 40 then
                        flingPlayer(plr)
                        task.wait(0.05)
                    end
                end
            end
        end, "autoFling")
    else
        boatFlingActive = false
        disc("autoFling")
    end
end)

category("⚡ KARAKTER")

-- Speed Toggle
toggle("⚡ Speed Hack", "⚡", false, function(on)
    if on then
        conn(RS.Heartbeat, function()
            local h = H()
            if h then h.WalkSpeed = 80 end
        end, "speed")
    else
        disc("speed")
        local h = H()
        if h then h.WalkSpeed = 16 end
    end
end)

-- Super Jump
toggle("🦘 Süper Zıplama", "🦘", false, function(on)
    if on then
        conn(RS.Heartbeat, function()
            local h = H()
            if h then
                pcall(function() h.JumpPower = 200 end)
                pcall(function() h.JumpHeight = 50 end)
            end
        end, "sjump")
    else
        disc("sjump")
        local h = H()
        if h then
            pcall(function() h.JumpPower = 50 end)
            pcall(function() h.JumpHeight = 7.2 end)
        end
    end
end)

-- Fly Toggle
local flyOn = false
local fV, fG, fCon
toggle("🛩️ Uçuş Modu", "🛩️", false, function(on)
    flyOn = on
    local r2 = R()
    if on and r2 then
        fG = Instance.new("BodyGyro", r2)
        fG.MaxTorque = Vector3.new(9e8, 9e8, 9e8)
        fG.P = 9e4
        fV = Instance.new("BodyVelocity", r2)
        fV.MaxForce = Vector3.new(9e8, 9e8, 9e8)
        fV.Velocity = Vector3.zero
        fCon = RS.Heartbeat:Connect(function()
            local rt = R()
            if not(flyOn and rt) then
                if fCon then fCon:Disconnect() end
                return
            end
            local d = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d = d + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d = d - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d = d - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d = d + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
            local spd = UIS:IsKeyDown(Enum.KeyCode.LeftControl) and 220 or 95
            fV.Velocity = d.Magnitude > 0 and d.Unit * spd or Vector3.zero
            fG.CFrame = cam.CFrame
        end)
    else
        if fCon then fCon:Disconnect(); fCon = nil end
        pcall(function() if fV then fV:Destroy() end end)
        fV = nil
        pcall(function() if fG then fG:Destroy() end end)
        fG = nil
    end
end)

-- God Mode
toggle("🛡️ God Mode", "🛡️", false, function(on)
    local h = H()
    if not h then return end
    if on then
        h.MaxHealth = math.huge
        h.Health = math.huge
        conn(h.HealthChanged, function()
            if h and h.Parent then h.Health = math.huge end
        end, "god")
    else
        disc("god")
        pcall(function() h.MaxHealth = 100; h.Health = 100 end)
    end
end)

category("👁️ GÖRSEL")

-- Fullbright
toggle("💡 Fullbright", "💡", false, function(on)
    if on then
        Lighting.Brightness = 10
        Lighting.ClockTime = 14
        Lighting.FogEnd = 999999
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

-- ESP
local espObjs = {}
toggle("👁️ Oyuncu ESP", "👁️", false, function(on)
    if on then
        local function buildESP()
            for _, o in pairs(espObjs) do pcall(function() o:Destroy() end) end
            espObjs = {}
            for _, plr in pairs(Players:GetPlayers()) do
                if plr == lp then continue end
                local char = plr.Character
                if not char then continue end
                local head = char:FindFirstChild("Head")
                if not head then continue end
                local r2 = R()
                local dist = r2 and math.floor((head.Position - r2.Position).Magnitude) or 0
                local bill = Instance.new("BillboardGui", head)
                bill.Name = "SlayerESP"
                bill.AlwaysOnTop = true
                bill.Size = UDim2.fromOffset(S(140), S(30))
                bill.StudsOffset = Vector3.new(0, 3, 0)
                local bg = Instance.new("Frame", bill)
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
                bg.BackgroundTransparency = 0.3
                bg.BorderSizePixel = 0
                Instance.new("UICorner", bg).CornerRadius = UDim.new(0, S(4))
                do local s = Instance.new("UIStroke", bg)
                    s.Color = COL.GOLD
                    s.Thickness = 1
                end
                local lbl = Instance.new("TextLabel", bg)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.Text = plr.Name .. " [" .. dist .. "m]"
                lbl.TextSize = S(9)
                lbl.Font = Enum.Font.GothamBold
                lbl.TextColor3 = COL.GOLD
                lbl.BackgroundTransparency = 1
                table.insert(espObjs, bill)
            end
        end
        buildESP()
        conn(RS.Heartbeat, function()
            for _, o in pairs(espObjs) do
                if not(o and o.Parent) then
                    for _, o2 in pairs(espObjs) do pcall(function() o2:Destroy() end) end
                    espObjs = {}
                    buildESP()
                    break
                end
            end
        end, "espWatch")
    else
        for _, o in pairs(espObjs) do pcall(function() o:Destroy() end) end
        espObjs = {}
        disc("espWatch")
    end
end)

category("🌍 DÜNYA")

button("⭐ Spawn'a Işınlan", "⭐", COL.ACCENT2, function()
    local r2 = R()
    if not r2 then return end
    local sp = Workspace:FindFirstChild("SpawnLocation") or Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if sp then r2.CFrame = sp.CFrame + Vector3.new(0, 5, 0) end
end)

button("☁️ Havaya Zıpla", "☁️", COL.ACCENT2, function()
    local r2 = R()
    if r2 then r2.CFrame = r2.CFrame + Vector3.new(0, 80, 0) end
end)

button("🔄 Respawn", "🔄", COL.ACCENT2, function()
    lp:LoadCharacter()
end)

-- ════════════════════════════════════════════════════════════════
--  KLAVYE KISAYOLLARI
-- ════════════════════════════════════════════════════════════════
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        win.Visible = not win.Visible
    elseif i.KeyCode == Enum.KeyCode.F7 then
        if selectedPlayer then boatFling(selectedPlayer) else flingAll() end
    elseif i.KeyCode == Enum.KeyCode.F8 then
        flingAll()
    end
end)

-- ════════════════════════════════════════════════════════════════
--  BAŞLANGIÇ BİLDİRİMİ
-- ════════════════════════════════════════════════════════════════
local notif = Instance.new("Frame", sg)
notif.Size = UDim2.fromOffset(S(300), S(40))
notif.Position = UDim2.new(0.5, -S(150), 1, S(10))
notif.BackgroundColor3 = COL.BG
notif.BorderSizePixel = 0
Instance.new("UICorner", notif).CornerRadius = UDim.new(0, S(8))
do local s = Instance.new("UIStroke", notif) s.Color = COL.GOLD; s.Thickness = 1.5 end

local nl = Instance.new("TextLabel", notif)
nl.Size = UDim2.new(1, -S(12), 1, 0)
nl.Position = UDim2.new(0, S(6), 0, 0)
nl.Text = "⚡ SLAYER HUB V2 — Hazır!\nF7=Fling  F8=Tüm Fling  RightShift=Menü"
nl.TextSize = S(10)
nl.Font = Enum.Font.GothamSemibold
nl.TextColor3 = COL.TEXT
nl.BackgroundTransparency = 1
nl.TextWrapped = true

TS:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -S(150), 1, -S(50))}):Play()
task.delay(4, function()
    TS:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -S(150), 1, S(10))}):Play()
    task.delay(0.5, function() notif:Destroy() end)
end)

print("⚡ SLAYER HUB V2 — Brookhaven RP | Hazır!")
print("Kısayollar: RightShift=Menü | F7=Hedef Fling | F8=Tüm Fling")
