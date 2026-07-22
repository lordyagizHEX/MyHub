--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- ============================================
-- 🔥 SCRIPTBLOX API HUB
-- ============================================

local player = game.Players.LocalPlayer
local http = game:GetService("HttpService")

-- Ana GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "ScriptBloxHub"

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 12)

-- Başlık
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "📡 ScriptBlox Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- Kapatma Butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Size = UDim2.new(0, 40, 0, 30)
closeBtn.Position = UDim2.new(0.9, 0, 0.02, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextSize = 20
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Scrollable liste
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = mainFrame
scrollFrame.Size = UDim2.new(1, 0, 0.85, 0)
scrollFrame.Position = UDim2.new(0, 0, 0.15, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 10)

-- Script'leri getir ve listele
local function fetchAndDisplayScripts()
    local success, response = pcall(function()
        return game:HttpGet("https://scriptblox.com/api/script/fetch?universal=1&mode=free&max=20")
    end)
    
    if not success then
        print("❌ Script'ler çekilemedi!")
        return
    end
    
    local data = http:JSONDecode(response)
    
    for _, script in ipairs(data.result.scripts) do
        local btn = Instance.new("TextButton")
        btn.Parent = scrollFrame
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Text = script.title .. " | 👁️ " .. script.views
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.Parent = btn
        btnCorner.CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(function()
            loadScript(script._id)
        end)
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #data.result.scripts * 50)
end

-- Script çalıştırma fonksiyonu
local function loadScript(scriptId)
    local url = "https://scriptblox.com/api/script/raw/" .. scriptId
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        local func, err = loadstring(response)
        if func then
            func()
            print("✅ Script çalıştı!")
        end
    end
end

-- Başlat
fetchAndDisplayScripts()
