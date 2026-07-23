--[[
  🔪 LORD HUB V5 — MURDER MYSTERY 2  (PROFESSIONAL)
  ✅ Katil: Otomatik bıçak fırlatma & çevredekileri kesme
  ✅ Şerif: Otomatik katil vurma
  ✅ Profesyonel ESP: Sadece KIRMIZI (katil) & YEŞİL (masum/şerif)
  ✅ Ultra optimize — donma/kasılma yok
  ✅ Gelişmiş mobil/PC UI
  ✅ FPS oyunu kalitesinde hile sistemi
--]]

local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local TS       = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris   = game:GetService("Debris")
local Http     = game:GetService("HttpService")
local lp       = Players.LocalPlayer
local pgui     = lp.PlayerGui
local cam      = workspace.CurrentCamera

if pgui:FindFirstChild("MM2HubV5") then pgui.MM2HubV5:Destroy() end

-- ══════════════════════════════════════════════
-- MOBİL ALGILAMA
-- ══════════════════════════════════════════════
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local vp = cam.ViewportSize

local function getScale()
    local w = cam.ViewportSize.X
    local h = cam.ViewportSize.Y
    if not isMobile then return 1 end
    local base = math.min(w, h) / 390
    return math.clamp(base, 0.80, 1.40)
end

local SCALE = getScale()
local function S(n) return math.floor(n * SCALE) end

-- ══════════════════════════════════════════════
-- ROL TESPİTİ (Hızlı)
-- ══════════════════════════════════════════════
local KNIFE_KW = {"knife","bıçak","mm2knife","sickle","virtual","darkblade","elderwood","chrome","luger","candy","saw","bat"}
local GUN_KW   = {"revolver","gun","sheriff","luger","mm2gun","pistol","magnum"}

local roleCache = {}
local roleCacheTime = 0

local function getRole(plr)
    if plr == lp then return "self" end
    local now = tick()
    if roleCache[plr] and now - roleCacheTime < 0.3 then
        return roleCache[plr]
    end
    
    local ch = plr.Character
    if not ch then return "unknown" end
    
    -- Önce eldeki tool'a bak
    for _, t in pairs(ch:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            for _, k in pairs(KNIFE_KW) do if n:find(k) then roleCache[plr] = "murderer"; roleCacheTime = now; return "murderer" end end
            for _, g in pairs(GUN_KW) do if n:find(g) then roleCache[plr] = "sheriff"; roleCacheTime = now; return "sheriff" end end
        end
    end
    
    -- Backpack'e bak
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, t in pairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                for _, k in pairs(KNIFE_KW) do if n:find(k) then roleCache[plr] = "murderer"; roleCacheTime = now; return "murderer" end end
                for _, g in pairs(GUN_KW) do if n:find(g) then roleCache[plr] = "sheriff"; roleCacheTime = now; return "sheriff" end end
            end
        end
    end
    
    roleCache[plr] = "innocent"
    roleCacheTime = now
    return "innocent"
end

-- ══════════════════════════════════════════════
-- OPTİMİZE EDİLMİŞ CONNECTION YÖNETİMİ
-- ══════════════════════════════════════════════
local Connections = {}
local function connect(event, fn, tag)
    if tag and Connections[tag] then
        pcall(function() Connections[tag]:Disconnect() end)
        Connections[tag] = nil
    end
    local c = event:Connect(fn)
    if tag then Connections[tag] = c end
    return c
end
local function disconnect(tag)
    if Connections[tag] then
        pcall(function() Connections[tag]:Disconnect() end)
        Connections[tag] = nil
    end
end

-- ══════════════════════════════════════════════
-- YARDIMCI FONKSİYONLAR
-- ══════════════════════════════════════════════
local function C() return lp.Character end
local function R() local c = C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H() local c = C(); return c and c:FindFirstChildOfClass("Humanoid") end

-- Görünürlük kontrolü (optimize)
local function isVisible(from, to)
    local dir = to - from
    local dist = dir.Magnitude
    if dist < 0.5 then return true end
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then table.insert(filter, p.Character) end
    end
    rp.FilterDescendantsInstances = filter
    local ray = workspace:Raycast(from, dir.Unit * dist, rp)
    return not ray
end

-- En yakın hedef bul
local function findNearest(roles, requireVis, maxDist)
    local root = R()
    if not root then return nil, math.huge end
    local best, bestD = nil, maxDist or math.huge
    local rootPos = root.Position
    local rootY = rootPos.Y
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lp then continue end
        local ch = plr.Character
        if not ch then continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then continue end
        local tRoot = ch:FindFirstChild("HumanoidRootPart")
        if not tRoot then continue end
        
        local role = getRole(plr)
        local match = false
        for _, r in pairs(roles) do if role == r then match = true; break end end
        if not match then continue end
        
        local d = (tRoot.Position - rootPos).Magnitude
        if d < bestD and d < maxDist then
            if requireVis then
                if isVisible(rootPos + Vector3.new(0, 2, 0), tRoot.Position + Vector3.new(0, 2, 0)) then
                    bestD = d; best = plr
                end
            else
                bestD = d; best = plr
            end
        end
    end
    return best, bestD
end

-- ══════════════════════════════════════════════
-- REMOTE BULMA (Geliştirilmiş)
-- ══════════════════════════════════════════════
local throwRemote = nil
local remoteCache = {}

local function findThrowRemote()
    if throwRemote then return throwRemote end
    
    local keywords = {"throw","attack","swing","stab","hit","slash","fire","shoot","kill","damage","activate"}
    
    -- Önce karakterdeki tool'u kontrol et
    local ch = C()
    if ch then
        for _, t in pairs(ch:GetChildren()) do
            if t:IsA("Tool") then
                for _, child in pairs(t:GetDescendants()) do
                    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                        throwRemote = child
                        return throwRemote
                    end
                end
            end
        end
    end
    
    -- Global ara
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if n:find(kw) then
                    throwRemote = obj
                    return throwRemote
                end
            end
        end
    end
    
    return nil
end

-- ══════════════════════════════════════════════
-- ANA SALDIRI SİSTEMİ (ULTRA HIZLI)
-- ══════════════════════════════════════════════
local attackCooldown = 0
local attackDelay = 0.06
local attackRange = 30

-- Hedef pozisyon tahmini (daha hassas)
local prevPositions = {}
local function predictPosition(plr, ahead)
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local cur = root.Position
    local prev = prevPositions[plr]
    local vel = prev and (cur - prev) * 60 or Vector3.zero
    prevPositions[plr] = cur
    return cur + vel * (ahead or 0.1)
end

-- Bıçak fırlat / saldır (TP YOK!)
local function attackTarget(target, force)
    if not target then return end
    local now = tick()
    if now - attackCooldown < attackDelay and not force then return end
    attackCooldown = now
    
    local root = R()
    if not root then return end
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    if tHum and tHum.Health <= 0 then return end
    
    -- Hedef pozisyonu tahmin et
    local aimPos = predictPosition(target, 0.08) or tRoot.Position
    
    -- Sadece yöne bak (TP YOK!)
    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(aimPos.X, root.Position.Y, aimPos.Z))
    
    local ch = C()
    if not ch then return end
    
    -- Eldeki tool'u bul
    local tool = nil
    for _, t in pairs(ch:GetChildren()) do
        if t:IsA("Tool") then
            tool = t
            break
        end
    end
    
    -- Remote event'leri bul ve ateşle
    local remote = findThrowRemote()
    if remote then
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(aimPos)
                remote:FireServer(tRoot)
                remote:FireServer(target.Character)
            else
                remote:InvokeServer(aimPos)
            end
        end)
    end
    
    -- Tool içindeki remote'lar
    if tool then
        for _, child in pairs(tool:GetDescendants()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                pcall(function()
                    if child:IsA("RemoteEvent") then
                        child:FireServer(aimPos)
                        child:FireServer(tRoot)
                    else
                        child:InvokeServer(aimPos)
                    end
                end)
            end
        end
        pcall(function() tool:Activate() end)
    end
    
    -- Mouse simülasyonu
    pcall(function()
        local ms = lp:GetMouse()
        if ms then
            ms.Target = tRoot
            ms.Hit = CFrame.new(aimPos)
        end
    end)
end

-- ══════════════════════════════════════════════
-- OTOMATİK SALDIRI SİSTEMLERİ (PROFESSIONAL)
-- ══════════════════════════════════════════════
local autoAttackEnabled = false
local autoAttackMode = "all" -- "all", "murderer", "sheriff"

-- Katil modu: Çevredeki tüm oyunculara otomatik saldır
local function murdererAutoAttack()
    local root = R()
    if not root then return end
    
    local targets = {}
    local rootPos = root.Position
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lp then continue end
        local ch = plr.Character
        if not ch then continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then continue end
        local tRoot = ch:FindFirstChild("HumanoidRootPart")
        if not tRoot then continue end
        
        local d = (tRoot.Position - rootPos).Magnitude
        if d < attackRange then
            -- Görünürlük kontrolü
            if isVisible(rootPos + Vector3.new(0, 2, 0), tRoot.Position + Vector3.new(0, 2, 0)) then
                table.insert(targets, {plr = plr, dist = d, root = tRoot})
            end
        end
    end
    
    -- Mesafeye göre sırala (en yakın önce)
    table.sort(targets, function(a, b) return a.dist < b.dist end)
    
    -- En yakın hedefe saldır
    if #targets > 0 then
        attackTarget(targets[1].plr, false)
    end
end

-- Şerif modu: Katili otomatik vur
local function sheriffAutoAttack()
    local murderer = findNearest({"murderer"}, true, attackRange * 1.5)
    if murderer then
        attackTarget(murderer, false)
    end
end

-- ══════════════════════════════════════════════
-- ESP SİSTEMİ (Sadece KIRMIZI & YEŞİL)
-- ══════════════════════════════════════════════
local espEnabled = false
local espObjects = {}

local function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function buildESP()
    clearESP()
    if not espEnabled then return end
    
    local root = R()
    local rootPos = root and root.Position or Vector3.zero
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == lp then continue end
        local ch = plr.Character
        if not ch then continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then continue end
        local head = ch:FindFirstChild("Head")
        if not head then continue end
        
        local role = getRole(plr)
        
        -- Sadece KIRMIZI (katil) veya YEŞİL (masum/şerif)
        local color
        local roleText
        if role == "murderer" then
            color = Color3.fromRGB(255, 30, 30)
            roleText = "🔪 KATİL"
        elseif role == "sheriff" then
            color = Color3.fromRGB(50, 255, 50)
            roleText = "🔫 ŞERİF"
        else
            color = Color3.fromRGB(50, 255, 50)
            roleText = "👤 MASUM"
        end
        
        local bill = Instance.new("BillboardGui", head)
        bill.Name = "ESP_V5"
        bill.AlwaysOnTop = true
        bill.Size = UDim2.fromOffset(S(170), S(55))
        bill.StudsOffset = Vector3.new(0, 3.5, 0)
        
        local bg = Instance.new("Frame", bill)
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.3
        bg.BorderSizePixel = 0
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
        
        local stroke = Instance.new("UIStroke", bg)
        stroke.Color = color
        stroke.Thickness = 2
        
        -- İsim
        local nameLbl = Instance.new("TextLabel", bg)
        nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
        nameLbl.Position = UDim2.new(0, 0, 0, 0)
        nameLbl.Text = plr.Name
        nameLbl.TextSize = S(11)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextColor3 = color
        nameLbl.BackgroundTransparency = 1
        
        -- Rol
        local roleLbl = Instance.new("TextLabel", bg)
        roleLbl.Size = UDim2.new(1, 0, 0.5, 0)
        roleLbl.Position = UDim2.new(0, 0, 0.5, 0)
        roleLbl.Text = roleText
        roleLbl.TextSize = S(9)
        roleLbl.Font = Enum.Font.GothamSemibold
        roleLbl.TextColor3 = color
        roleLbl.BackgroundTransparency = 1
        
        table.insert(espObjects, bill)
    end
end

-- ══════════════════════════════════════════════
-- PROFESYONEL UI
-- ══════════════════════════════════════════════
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "MM2HubV5"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999

-- Ana Pencere
local W = isMobile and S(320) or 340
local HH = isMobile and S(480) or 480

local win = Instance.new("Frame", sg)
win.Size = UDim2.fromOffset(W, HH)
if isMobile then
    win.Position = UDim2.new(0, 8, 0, 8)
else
    win.Position = UDim2.new(0.5, -W/2, 0.5, -HH/2)
end
win.BackgroundColor3 = Color3.fromRGB(6, 6, 16)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 12)

-- Glow efekti
local glow = Instance.new("ImageLabel", win)
glow.Size = UDim2.new(1, 40, 1, 40)
glow.Position = UDim2.new(0, -20, 0, -20)
glow.BackgroundTransparency = 1
glow.ZIndex = -1
glow.Image = "rbxassetid://1316045217"
glow.ImageColor3 = Color3.fromRGB(255, 50, 50)
glow.ImageTransparency = 0.6
glow.ScaleType = Enum.ScaleType.Slice
glow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Başlık
local barH = S(44)
local bar = Instance.new("Frame", win)
bar.Size = UDim2.new(1, 0, 0, barH)
bar.BackgroundColor3 = Color3.fromRGB(10, 10, 22)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 12)

local titleLbl = Instance.new("TextLabel", bar)
titleLbl.Size = UDim2.new(1, -S(100), 1, 0)
titleLbl.Position = UDim2.new(0, S(12), 0, 0)
titleLbl.Text = "🔪 LORD HUB V5"
titleLbl.TextSize = S(isMobile and 15 or 14)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.BackgroundTransparency = 1

-- FPS
local fpsLbl = Instance.new("TextLabel", bar)
fpsLbl.Size = UDim2.fromOffset(S(60), S(20))
fpsLbl.Position = UDim2.new(1, -S(70), 0.5, -S(10))
fpsLbl.Text = "60 FPS"
fpsLbl.TextSize = S(10)
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextColor3 = Color3.fromRGB(50, 255, 50)
fpsLbl.BackgroundTransparency = 1

-- Kapat
local closeBtn = Instance.new("TextButton", bar)
closeBtn.Size = UDim2.fromOffset(S(28), S(28))
closeBtn.Position = UDim2.new(1, -S(34), 0.5, -S(14))
closeBtn.Text = "✕"
closeBtn.TextSize = S(12)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 40)
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function() win.Visible = false end)

-- İçerik
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, 0, 1, -barH - S(10))
content.Position = UDim2.new(0, 0, 0, barH + S(5))
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = isMobile and 4 or 2
content.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ElasticBehavior = Enum.ElasticBehavior.Always

local function mkSection(parent, title)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -S(12), 0, S(26))
    f.BackgroundTransparency = 1
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.Text = "▸ " .. title
    l.TextSize = S(10)
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = Color3.fromRGB(255, 60, 60)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    return f
end

local function mkToggle(parent, text, default, callback)
    local btnH = isMobile and S(48) or S(38)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, btnH)
    btn.Text = ""
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 26)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, S(10), 0, 0)
    lbl.Text = text
    lbl.TextSize = S(11)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextColor3 = Color3.fromRGB(200, 200, 230)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    
    local swW = isMobile and S(48) or S(38)
    local swH = isMobile and S(24) or S(19)
    local sw = Instance.new("Frame", btn)
    sw.Size = UDim2.fromOffset(swW, swH)
    sw.Position = UDim2.new(1, -swW - S(8), 0.5, -swH/2)
    sw.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    sw.BorderSizePixel = 0
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)
    
    local dot = Instance.new("Frame", sw)
    local dotS = isMobile and S(16) or S(13)
    dot.Size = UDim2.fromOffset(dotS, dotS)
    dot.Position = UDim2.new(0, S(3), 0.5, -dotS/2)
    dot.BackgroundColor3 = Color3.fromRGB(150, 150, 180)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local state = default or false
    local dotOnX = swW - dotS - S(3)
    
    local function setState(v)
        state = v
        if v then
            TS:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
            TS:Create(dot, TweenInfo.new(0.15), {Position = UDim2.new(0, dotOnX, 0.5, -dotS/2), BackgroundColor3 = Color3.new(1, 1, 1)}):Play()
        else
            TS:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}):Play()
            TS:Create(dot, TweenInfo.new(0.15), {Position = UDim2.new(0, S(3), 0.5, -dotS/2), BackgroundColor3 = Color3.fromRGB(150, 150, 180)}):Play()
        end
        callback(v)
    end
    
    btn.MouseButton1Click:Connect(function() setState(not state) end)
    return {set = setState, get = function() return state end}
end

local function mkButton(parent, text, color, callback)
    local btnH = isMobile and S(46) or S(36)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, btnH)
    btn.Text = text
    btn.TextSize = S(11)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = color or Color3.fromRGB(255, 50, 50)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ══════════════════════════════════════════════
-- ANA MENÜ İÇERİĞİ
-- ══════════════════════════════════════════════
local padding = Instance.new("UIPadding", content)
padding.PaddingTop = UDim.new(0, S(5))
padding.PaddingLeft = UDim.new(0, S(6))
padding.PaddingRight = UDim.new(0, S(6))
local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, S(4))
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ==== BÖLÜM 1: OTOMATİK SALDIRI ====
mkSection(content, "⚔️ OTOMATİK SALDIRI")

local autoToggle = mkToggle(content, "🔴 Katil Modu (Otomatik fırlat)", false, function(v)
    autoAttackEnabled = v
    if v then
        local role = getRole(lp)
        if role == "murderer" then
            connect(RS.Heartbeat, function()
                if autoAttackEnabled then murdererAutoAttack() end
            end, "autoAttack")
        elseif role == "sheriff" then
            connect(RS.Heartbeat, function()
                if autoAttackEnabled then sheriffAutoAttack() end
            end, "autoAttack")
        end
    else
        disconnect("autoAttack")
    end
end)

local statusLbl = Instance.new("TextLabel", content)
statusLbl.Size = UDim2.new(1, 0, 0, S(24))
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "⏳ Rol bekleniyor..."
statusLbl.TextSize = S(10)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextColor3 = Color3.fromRGB(150, 150, 180)

-- Rol kontrolü
connect(RS.Heartbeat, function()
    local role = getRole(lp)
    if role == "murderer" then
        statusLbl.Text = "🔪 KATİL MODU: Çevredekileri otomatik kesiyor!"
        statusLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
    elseif role == "sheriff" then
        statusLbl.Text = "🔫 ŞERİF MODU: Katili otomatik vuruyor!"
        statusLbl.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        statusLbl.Text = "👤 MASUM: Katil olana kadar bekle..."
        statusLbl.TextColor3 = Color3.fromRGB(150, 150, 180)
    end
end, "roleStatus")

-- Menzil ayarı
local rangeLabel = Instance.new("TextLabel", content)
rangeLabel.Size = UDim2.new(1, 0, 0, S(22))
rangeLabel.BackgroundTransparency = 1
rangeLabel.Text = "📏 Saldırı Menzili: 30"
rangeLabel.TextSize = S(10)
rangeLabel.Font = Enum.Font.Gotham
rangeLabel.TextColor3 = Color3.fromRGB(180, 180, 210)

local function createSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, 0, 0, isMobile and S(60) or S(48))
    f.BackgroundColor3 = Color3.fromRGB(12, 12, 26)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.6, 0, 0, S(20))
    lbl.Position = UDim2.new(0, S(10), 0, S(4))
    lbl.Text = text
    lbl.TextSize = S(10)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextColor3 = Color3.fromRGB(200, 200, 230)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    
    local valLbl = Instance.new("TextLabel", f)
    valLbl.Size = UDim2.new(0.35, 0, 0, S(20))
    valLbl.Position = UDim2.new(0.6, 0, 0, S(4))
    valLbl.Text = tostring(default)
    valLbl.TextSize = S(10)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.BackgroundTransparency = 1
    
    local trH = isMobile and S(6) or S(4)
    local tr = Instance.new("Frame", f)
    tr.Size = UDim2.new(1, -S(20), 0, trH)
    tr.Position = UDim2.new(0, S(10), 0, isMobile and S(44) or S(36))
    tr.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    tr.BorderSizePixel = 0
    Instance.new("UICorner", tr).CornerRadius = UDim.new(1, 0)
    
    local p = (default - min) / (max - min)
    local fill = Instance.new("Frame", tr)
    fill.Size = UDim2.new(p, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local knobS = isMobile and S(20) or S(14)
    local knob = Instance.new("Frame", tr)
    knob.Size = UDim2.fromOffset(knobS, knobS)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(p, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", knob)
    stroke.Color = Color3.fromRGB(255, 50, 50)
    stroke.Thickness = 1.5
    
    local dragging = false
    
    local function update(x)
        local p = math.clamp((x - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + p * (max - min))
        valLbl.Text = tostring(v)
        fill.Size = UDim2.new(p, 0, 1, 0)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        callback(v)
    end
    
    local function onInputBegan(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(i.Position.X)
        end
    end
    
    tr.InputBegan:Connect(onInputBegan)
    knob.InputBegan:Connect(onInputBegan)
    
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i.Position.X)
        end
    end)
    
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return f
end

createSlider(content, "Menzil", 5, 60, 30, function(v)
    attackRange = v
    rangeLabel.Text = "📏 Saldırı Menzili: " .. v
end)

-- ==== BÖLÜM 2: ESP ====
mkSection(content, "👁️ ESP SİSTEMİ")

local espToggle = mkToggle(content, "🔴🔵 ESP Aç (Kırmızı/Yeşil)", false, function(v)
    espEnabled = v
    if v then
        buildESP()
        connect(RS.Heartbeat, function()
            if espEnabled then buildESP() end
        end, "espUpdate")
    else
        disconnect("espUpdate")
        clearESP()
    end
end)

mkButton(content, "🔄 ESP Yenile", Color3.fromRGB(30, 30, 50), function()
    if espEnabled then buildESP() end
end)

-- ==== BÖLÜM 3: ANI SALDIRI ====
mkSection(content, "⚡ ANI SALDIRI")

mkButton(content, "🎯 Hedefe Saldır (TP YOK)", Color3.fromRGB(200, 40, 40), function()
    local target = findNearest({"murderer", "sheriff", "innocent"}, false, 200)
    if target then attackTarget(target, true) end
end)

mkButton(content, "🔪 Katili Vur", Color3.fromRGB(220, 30, 30), function()
    local murderer = findNearest({"murderer"}, false, 200)
    if murderer then attackTarget(murderer, true) end
end)

-- ==== BÖLÜM 4: KARAKTER ====
mkSection(content, "⚡ KARAKTER")

local flyToggle = mkToggle(content, "🛩️ Uçuş Modu", false, function(v)
    if v then
        local root = R()
        if root then
            local bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(9e8, 9e8, 9e8)
            bg.P = 9e4
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(9e8, 9e8, 9e8)
            bv.Velocity = Vector3.zero
            
            connect(RS.Heartbeat, function()
                local rt = R()
                if not rt or not flyToggle.get() then return end
                local dir = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                if dir.Magnitude > 0 then
                    bv.Velocity = dir.Unit * 75
                else
                    bv.Velocity = Vector3.zero
                end
                bg.CFrame = cam.CFrame
            end, "fly")
        end
    else
        disconnect("fly")
        local root = R()
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                    v:Destroy()
                end
            end
        end
    end
end)

mkToggle(content, "🚀 Sonsuz Zıplama", false, function(v)
    if v then
        connect(UIS.JumpRequest, function()
            local h = H()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end, "infJump")
    else
        disconnect("infJump")
    end
end)

mkToggle(content, "🛡️ God Mode", false, function(v)
    local h = H()
    if not h then return end
    if v then
        h.MaxHealth = math.huge
        h.Health = math.huge
        connect(h.HealthChanged, function()
            if h and h.Parent then h.Health = math.huge end
        end, "god")
    else
        disconnect("god")
        pcall(function() h.MaxHealth = 100; h.Health = 100 end)
    end
end)

-- ==== BÖLÜM 5: AYARLAR ====
mkSection(content, "⚙️ AYARLAR")

mkButton(content, "🗑️ Tüm Bağlantıları Temizle", Color3.fromRGB(40, 40, 60), function()
    for tag, c in pairs(Connections) do
        pcall(function() c:Disconnect() end)
        Connections[tag] = nil
    end
    clearESP()
    print("[LORD V5] Tüm bağlantılar temizlendi")
end)

mkButton(content, "🔄 Remote Sıfırla", Color3.fromRGB(40, 40, 60), function()
    throwRemote = nil
    remoteCache = {}
    print("[LORD V5] Remote sıfırlandı")
end)

-- Bilgi
local infoLbl = Instance.new("TextLabel", content)
infoLbl.Size = UDim2.new(1, 0, 0, S(60))
infoLbl.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
infoLbl.BorderSizePixel = 0
Instance.new("UICorner", infoLbl).CornerRadius = UDim.new(0, 8)
infoLbl.Text = "🔪 LORD HUB V5\n✅ Işınlanma YOK - Sadece fırlatma\n✅ Katil: Otomatik çevre temizliği\n✅ Şerif: Otomatik katil avı"
infoLbl.TextSize = S(10)
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextColor3 = Color3.fromRGB(180, 180, 210)
infoLbl.TextWrapped = true

-- ══════════════════════════════════════════════
-- MOBİL HIZLI BUTONLAR
-- ══════════════════════════════════════════════
local qBar = Instance.new("Frame", sg)
qBar.Size = UDim2.fromOffset(S(56), S(56) * 4 + S(10) * 3)
qBar.Position = UDim2.new(1, -S(66), 0.5, -(S(56) * 4 + S(10) * 3) / 2)
qBar.BackgroundTransparency = 1

local function qBtn(icon, color, y, callback)
    local b = Instance.new("TextButton", qBar)
    b.Size = UDim2.fromOffset(S(56), S(56))
    b.Position = UDim2.fromOffset(0, y * (S(56) + S(10)))
    b.Text = icon
    b.TextSize = S(22)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, S(12))
    
    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.5
    
    b.MouseButton1Click:Connect(callback)
    return b
end

qBtn("🔪", Color3.fromRGB(200, 40, 40), 0, function()
    win.Visible = not win.Visible
end)

qBtn("⚔️", Color3.fromRGB(180, 30, 30), 1, function()
    autoToggle.set(not autoToggle.get())
end)

qBtn("🎯", Color3.fromRGB(220, 50, 50), 2, function()
    local murderer = findNearest({"murderer"}, false, 200)
    if murderer then attackTarget(murderer, true) end
end)

qBtn("🏃", Color3.fromRGB(40, 160, 40), 3, function()
    local root = R()
    if not root then return end
    local murderer = findNearest({"murderer"}, false, 200)
    if murderer then
        local tRoot = murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            local diff = root.Position - tRoot.Position
            root.CFrame = CFrame.new(root.Position + diff.Unit * 50 + Vector3.new(0, 10, 0))
        end
    end
end)

-- ══════════════════════════════════════════════
-- KLAVYE KISAYOLLARI
-- ══════════════════════════════════════════════
UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        win.Visible = not win.Visible
    elseif i.KeyCode == Enum.KeyCode.F then
        local target = findNearest({"murderer", "sheriff", "innocent"}, false, 200)
        if target then attackTarget(target, true) end
    elseif i.KeyCode == Enum.KeyCode.G then
        local murderer = findNearest({"murderer"}, false, 200)
        if murderer then attackTarget(murderer, true) end
    end
end)

-- ══════════════════════════════════════════════
-- KARAKTER YENİLENMESİ
-- ══════════════════════════════════════════════
lp.CharacterAdded:Connect(function()
    task.wait(1)
    if espEnabled then buildESP() end
    throwRemote = nil
    prevPositions = {}
end)

-- ══════════════════════════════════════════════
-- BAŞLAT
-- ══════════════════════════════════════════════
connect(RS.Heartbeat, function()
    local fps = math.floor(1 / (RS.Heartbeat:Wait() or 0.016))
    fpsLbl.Text = fps .. " FPS"
    fpsLbl.TextColor3 = fps > 50 and Color3.fromRGB(50, 255, 50) or fps > 30 and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(255, 50, 50)
end, "fps")

print("🔪 LORD HUB V5 YÜKLENDİ!")
print("✅ Katil: Otomatik fırlatma & kesme")
print("✅ Şerif: Otomatik katil vurma")
print("✅ ESP: Kırmızı (Katil) / Yeşil (Diğer)")
print("✅ TP YOK - Sadece Remote/Activate")
