--[[
  LORD HUB — MURDER MYSTERY 2
  En iyi MM2 hilesi | Mobil + PC | Tüm executor
--]]

local Players   = game:GetService("Players")
local RS        = game:GetService("RunService")
local UIS       = game:GetService("UserInputService")
local TS        = game:GetService("TweenService")
local Lighting  = game:GetService("Lighting")
local Debris    = game:GetService("Debris")
local RunS      = RS

local lp   = Players.LocalPlayer
local pgui = lp.PlayerGui

if pgui:FindFirstChild("MM2Hub") then pgui.MM2Hub:Destroy() end

-- ══════════════════════════════════════════
-- YARDIMCILAR
-- ══════════════════════════════════════════
local function C()  return lp.Character end
local function R()  local c=C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H()  local c=C(); return c and c:FindFirstChildOfClass("Humanoid") end

-- ══════════════════════════════════════════
-- PENCERE
-- ══════════════════════════════════════════
local W,HH=310,420

local sg=Instance.new("ScreenGui",pgui)
sg.Name="MM2Hub"; sg.ResetOnSpawn=false; sg.IgnoreGuiInset=true

local win=Instance.new("Frame",sg)
win.Size=UDim2.fromOffset(W,HH); win.Position=UDim2.new(0.5,-W/2,0.5,-HH/2)
win.BackgroundColor3=Color3.fromRGB(10,10,18); win.BorderSizePixel=0
win.Active=true; win.Draggable=true
Instance.new("UICorner",win).CornerRadius=UDim.new(0,10)
do local s=Instance.new("UIStroke",win); s.Color=Color3.fromRGB(30,120,255); s.Thickness=1.5 end

-- Başlık
local bar=Instance.new("Frame",win)
bar.Size=UDim2.new(1,0,0,44); bar.BackgroundColor3=Color3.fromRGB(14,14,26); bar.BorderSizePixel=0
Instance.new("UICorner",bar).CornerRadius=UDim.new(0,10)
local bfix=Instance.new("Frame",bar); bfix.Size=UDim2.new(1,0,0.5,0); bfix.Position=UDim2.new(0,0,0.5,0)
bfix.BackgroundColor3=Color3.fromRGB(14,14,26); bfix.BorderSizePixel=0

local function lbl(p,txt,sz,col,xw,yw,ox,oy,xa,f)
    local l=Instance.new("TextLabel",p); l.Text=txt; l.TextSize=sz or 12
    l.TextColor3=col or Color3.new(1,1,1); l.Font=f or Enum.Font.GothamBold
    l.Size=UDim2.new(xw or 0,ox or 0, yw or 0, oy or 0); l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Left; return l
end

local ico=lbl(bar,"🔪",22,nil,0,44,0,1); ico.Position=UDim2.new(0,8,0,0); ico.TextXAlignment=Enum.TextXAlignment.Center
local tn=lbl(bar,"MM2 HUB",14,nil,0,22,0.55,0); tn.Position=UDim2.new(0,36,0,4)
local ts=lbl(bar,"MURDER MYSTERY 2",8,Color3.fromRGB(30,120,255),0,14,0.55,0); ts.Position=UDim2.new(0,36,0,26)
ts.Font=Enum.Font.GothamSemibold

local function hBtn(txt,col,ox)
    local b=Instance.new("TextButton",bar)
    b.Size=UDim2.fromOffset(24,24); b.Position=UDim2.new(1,ox,0.5,-12)
    b.Text=txt; b.TextSize=11; b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.new(1,1,1); b.BackgroundColor3=col; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5); return b
end
local closeB=hBtn("X",Color3.fromRGB(210,30,50),-7)
local minB  =hBtn("_",Color3.fromRGB(40,40,65),-35)
closeB.MouseButton1Click:Connect(function() win.Visible=false end)
local mini=false
minB.MouseButton1Click:Connect(function()
    mini=not mini
    TS:Create(win,TweenInfo.new(0.18),{Size=mini and UDim2.fromOffset(W,44) or UDim2.fromOffset(W,HH)}):Play()
    minB.Text=mini and "+" or "_"
end)

-- Tab bar
local tabBar=Instance.new("Frame",win)
tabBar.Size=UDim2.new(1,0,0,30); tabBar.Position=UDim2.new(0,0,0,44)
tabBar.BackgroundColor3=Color3.fromRGB(12,12,22); tabBar.BorderSizePixel=0
do local l=Instance.new("UIListLayout",tabBar); l.FillDirection=Enum.FillDirection.Horizontal
   l.HorizontalAlignment=Enum.HorizontalAlignment.Center
   l.VerticalAlignment=Enum.VerticalAlignment.Center; l.Padding=UDim.new(0,3) end

local CONTENT_H=HH-74
local content=Instance.new("Frame",win)
content.Size=UDim2.new(1,0,0,CONTENT_H); content.Position=UDim2.new(0,0,0,74)
content.BackgroundTransparency=1; content.BorderSizePixel=0

local TABS={"👁 ESP","⚡ Hareket","🗺 Harita","⚙ Ayar"}
local tBtns={};local pages={};local activeTab=0

local function switchTab(i)
    if activeTab==i then return end; activeTab=i
    for j=1,#TABS do
        TS:Create(tBtns[j],TweenInfo.new(0.13),{
            BackgroundColor3=j==i and Color3.fromRGB(30,120,255) or Color3.fromRGB(18,18,30),
            TextColor3      =j==i and Color3.new(1,1,1) or Color3.fromRGB(110,110,150)
        }):Play()
        pages[j].Visible=(j==i)
    end
end

for i,name in ipairs(TABS) do
    local tb=Instance.new("TextButton",tabBar)
    tb.Size=UDim2.fromOffset(68,24); tb.Text=name; tb.TextSize=9
    tb.Font=Enum.Font.GothamSemibold; tb.BorderSizePixel=0
    tb.BackgroundColor3=Color3.fromRGB(18,18,30); tb.TextColor3=Color3.fromRGB(110,110,150)
    Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5); tBtns[i]=tb

    local pg=Instance.new("ScrollingFrame",content)
    pg.Size=UDim2.new(1,0,1,0); pg.BackgroundTransparency=1
    pg.ScrollBarThickness=2; pg.ScrollBarImageColor3=Color3.fromRGB(30,120,255)
    pg.CanvasSize=UDim2.new(0,0,0,0); pg.AutomaticCanvasSize=Enum.AutomaticSize.Y
    pg.Visible=false; pg.BorderSizePixel=0
    do local ul=Instance.new("UIListLayout",pg)
       ul.Padding=UDim.new(0,4); ul.HorizontalAlignment=Enum.HorizontalAlignment.Center
       local pd=Instance.new("UIPadding",pg)
       pd.PaddingTop=UDim.new(0,6); pd.PaddingLeft=UDim.new(0,7); pd.PaddingRight=UDim.new(0,7) end
    pages[i]=pg

    local idx=i
    tb.MouseButton1Click:Connect(function() switchTab(idx) end)
end
switchTab(1)

-- ══════════════════════════════════════════
-- UI BİLEŞENLERİ
-- ══════════════════════════════════════════
local TW=TweenInfo.new(0.15,Enum.EasingStyle.Quad)

local function Sec(pg,txt)
    local f=Instance.new("Frame",pg); f.Size=UDim2.new(1,0,0,18); f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,0,1,0)
    l.Text="  "..txt; l.TextSize=9; l.Font=Enum.Font.GothamBold
    l.TextColor3=Color3.fromRGB(30,120,255); l.TextXAlignment=Enum.TextXAlignment.Left
    l.BackgroundTransparency=1
end

local function Btn(pg,txt,col,cb)
    local b=Instance.new("TextButton",pg)
    b.Size=UDim2.new(1,0,0,34); b.Text=txt; b.TextSize=11
    b.Font=Enum.Font.GothamSemibold; b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=col or Color3.fromRGB(30,120,255); b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    b.MouseButton1Click:Connect(cb)
    b.MouseEnter:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0.3}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0}):Play() end)
    return b
end

local function Tog(pg,txt,cb)
    local row=Instance.new("TextButton",pg)
    row.Size=UDim2.new(1,0,0,36); row.Text=""
    row.BackgroundColor3=Color3.fromRGB(17,17,28); row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)

    local nl=Instance.new("TextLabel",row)
    nl.Size=UDim2.new(0.72,0,1,0); nl.Position=UDim2.new(0,9,0,0)
    nl.Text=txt; nl.TextSize=11; nl.Font=Enum.Font.GothamSemibold
    nl.TextColor3=Color3.fromRGB(205,205,230); nl.TextXAlignment=Enum.TextXAlignment.Left
    nl.BackgroundTransparency=1

    local bg=Instance.new("Frame",row)
    bg.Size=UDim2.fromOffset(38,19); bg.Position=UDim2.new(1,-46,0.5,-9.5)
    bg.BackgroundColor3=Color3.fromRGB(48,48,65); bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)

    local kn=Instance.new("Frame",bg)
    kn.Size=UDim2.fromOffset(13,13); kn.Position=UDim2.new(0,3,0.5,-6.5)
    kn.BackgroundColor3=Color3.fromRGB(155,155,180); kn.BorderSizePixel=0
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)

    local on=false
    local tw2=TweenInfo.new(0.16)
    local function set(v)
        on=v
        if v then
            TS:Create(bg,tw2,{BackgroundColor3=Color3.fromRGB(30,120,255)}):Play()
            TS:Create(kn,tw2,{Position=UDim2.new(0,22,0.5,-6.5),BackgroundColor3=Color3.new(1,1,1)}):Play()
        else
            TS:Create(bg,tw2,{BackgroundColor3=Color3.fromRGB(48,48,65)}):Play()
            TS:Create(kn,tw2,{Position=UDim2.new(0,3,0.5,-6.5),BackgroundColor3=Color3.fromRGB(155,155,180)}):Play()
        end
        cb(v)
    end
    row.MouseButton1Click:Connect(function() set(not on) end)
    return {set=set,get=function()return on end}
end

local function Sli(pg,txt,mn,mx,def,cb)
    local f=Instance.new("Frame",pg)
    f.Size=UDim2.new(1,0,0,50); f.BackgroundColor3=Color3.fromRGB(17,17,28)
    f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)

    local nl=Instance.new("TextLabel",f); nl.Size=UDim2.new(0.62,0,0,20)
    nl.Position=UDim2.new(0,9,0,4); nl.Text=txt; nl.TextSize=11
    nl.Font=Enum.Font.GothamSemibold; nl.TextColor3=Color3.fromRGB(205,205,230)
    nl.TextXAlignment=Enum.TextXAlignment.Left; nl.BackgroundTransparency=1

    local vl=Instance.new("TextLabel",f); vl.Size=UDim2.new(0.34,0,0,20)
    vl.Position=UDim2.new(0.62,-4,0,4); vl.Text=tostring(def); vl.TextSize=11
    vl.Font=Enum.Font.GothamBold; vl.TextColor3=Color3.fromRGB(30,120,255)
    vl.TextXAlignment=Enum.TextXAlignment.Right; vl.BackgroundTransparency=1

    local tr=Instance.new("Frame",f); tr.Size=UDim2.new(1,-18,0,4)
    tr.Position=UDim2.new(0,9,0,36); tr.BackgroundColor3=Color3.fromRGB(36,36,55)
    tr.BorderSizePixel=0; Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)

    local p0=(def-mn)/(mx-mn)
    local fi=Instance.new("Frame",tr); fi.Size=UDim2.new(p0,0,1,0)
    fi.BackgroundColor3=Color3.fromRGB(30,120,255); fi.BorderSizePixel=0
    Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)

    local kk=Instance.new("Frame",tr); kk.Size=UDim2.fromOffset(11,11)
    kk.AnchorPoint=Vector2.new(0.5,0.5); kk.Position=UDim2.new(p0,0,0.5,0)
    kk.BackgroundColor3=Color3.new(1,1,1); kk.BorderSizePixel=0
    Instance.new("UICorner",kk).CornerRadius=UDim.new(1,0)

    local dr=false
    local function upd(x)
        local p=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local v=math.floor(mn+p*(mx-mn)); vl.Text=tostring(v)
        fi.Size=UDim2.new(p,0,1,0); kk.Position=UDim2.new(p,0,0.5,0); cb(v)
    end
    tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true;upd(i.Position.X) end end)
    kk.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true end end)
    UIS.InputChanged:Connect(function(i) if dr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end)
end

-- ══════════════════════════════════════════
-- ROL TESPİTİ (MM2)
-- ══════════════════════════════════════════
-- Katil   → Karakterinde bıçak tool var
-- Şerif   → Karakterinde silah tool var
-- Masum   → İkisi de yok

local KNIFE_NAMES = {"Knife","knife","KNIFE","MM2Knife"}
local GUN_NAMES   = {"Revolver","Gun","gun","Sheriff","Luger","MM2Gun"}

local function getRole(plr)
    local char = plr.Character
    if not char then return "unknown" end
    for _,tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n=tool.Name
            for _,k in pairs(KNIFE_NAMES) do if n:lower():find(k:lower()) then return "murderer" end end
            for _,g in pairs(GUN_NAMES)  do if n:lower():find(g:lower()) then return "sheriff"  end end
        end
    end
    -- Backpack'e de bak
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _,tool in pairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n=tool.Name
                for _,k in pairs(KNIFE_NAMES) do if n:lower():find(k:lower()) then return "murderer" end end
                for _,g in pairs(GUN_NAMES)  do if n:lower():find(g:lower()) then return "sheriff"  end end
            end
        end
    end
    return "innocent"
end

local ROLE_COLOR={
    murderer = Color3.fromRGB(255,50,50),
    sheriff  = Color3.fromRGB(50,130,255),
    innocent = Color3.fromRGB(80,220,80),
    unknown  = Color3.fromRGB(160,160,160),
}
local ROLE_LABEL={
    murderer="🔪 KATİL",
    sheriff ="🔫 ŞERİF",
    innocent="🟢 MASUM",
    unknown ="❔ ?",
}

-- ══════════════════════════════════════════
-- TAB 1 — ESP
-- ══════════════════════════════════════════
local P1=pages[1]
local espObjs={}
local espOn=false; local espConn

local function clearESP()
    for _,o in pairs(espObjs) do pcall(function() o:Destroy() end) end
    espObjs={}
end

local function buildESP()
    clearESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local char=plr.Character; if not char then continue end
        local head=char:FindFirstChild("Head"); if not head then continue end

        local role=getRole(plr)
        local col=ROLE_COLOR[role]

        local bill=Instance.new("BillboardGui",head)
        bill.Name="MM2ESP"; bill.AlwaysOnTop=true
        bill.Size=UDim2.fromOffset(160,52); bill.StudsOffset=Vector3.new(0,3.8,0)

        -- Arka plan
        local bg=Instance.new("Frame",bill); bg.Size=UDim2.new(1,0,1,0)
        bg.BackgroundColor3=Color3.fromRGB(8,8,14); bg.BackgroundTransparency=0.35
        bg.BorderSizePixel=0; Instance.new("UICorner",bg).CornerRadius=UDim.new(0,6)
        do local st=Instance.new("UIStroke",bg); st.Color=col; st.Thickness=1.2 end

        -- Rol etiketi
        local rl=Instance.new("TextLabel",bg); rl.Size=UDim2.new(1,0,0.45,0)
        rl.Position=UDim2.new(0,0,0,0); rl.Text=ROLE_LABEL[role]; rl.TextSize=11
        rl.Font=Enum.Font.GothamBold; rl.TextColor3=col; rl.BackgroundTransparency=1

        -- İsim
        local nl=Instance.new("TextLabel",bg); nl.Size=UDim2.new(1,0,0.3,0)
        nl.Position=UDim2.new(0,0,0.43,0); nl.Text=plr.Name; nl.TextSize=10
        nl.Font=Enum.Font.Gotham; nl.TextColor3=Color3.new(1,1,1); nl.BackgroundTransparency=1

        -- HP
        local hum=char:FindFirstChildOfClass("Humanoid")
        local hl=Instance.new("TextLabel",bg); hl.Size=UDim2.new(1,0,0.27,0)
        hl.Position=UDim2.new(0,0,0.73,0); hl.TextSize=9; hl.Font=Enum.Font.Gotham
        hl.TextColor3=Color3.fromRGB(100,255,100); hl.BackgroundTransparency=1
        if hum then
            hl.Text="❤ "..math.floor(hum.Health).." / "..math.floor(hum.MaxHealth)
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hl.Parent then hl.Text="❤ "..math.floor(hum.Health).." / "..math.floor(hum.MaxHealth) end
            end)
        end

        table.insert(espObjs,bill)
    end
end

-- Rol değişince ESP yenile (tool equip/unequip)
local function watchRoles()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local char=plr.Character; if not char then continue end
        char.ChildAdded:Connect(function(c)
            if c:IsA("Tool") and espOn then task.wait(0.1); buildESP() end
        end)
        char.ChildRemoved:Connect(function(c)
            if c:IsA("Tool") and espOn then task.wait(0.1); buildESP() end
        end)
    end
end

Sec(P1,"OYUNCU ESP")

Tog(P1,"👁️ Rol ESP  (Katil=🔴 Şerif=🔵 Masum=🟢)",function(on)
    espOn=on
    if on then
        buildESP(); watchRoles()
        espConn=RS.Heartbeat:Connect(function()
            -- Her 3 saniyede yenile (rol değişimini yakala)
        end)
    else
        clearESP()
        if espConn then espConn:Disconnect();espConn=nil end
    end
end)

Btn(P1,"🔄 ESP Yenile",Color3.fromRGB(25,25,40),function() if espOn then buildESP() end end)

-- ── Katil yaklaşma uyarısı ──────────────
local alertOn=false; local alertConn
local alertFrame=Instance.new("Frame",sg)
alertFrame.Size=UDim2.new(0.5,0,0,40); alertFrame.Position=UDim2.new(0.25,0,0,60)
alertFrame.BackgroundColor3=Color3.fromRGB(200,20,20); alertFrame.BackgroundTransparency=0.15
alertFrame.BorderSizePixel=0; alertFrame.Visible=false
Instance.new("UICorner",alertFrame).CornerRadius=UDim.new(0,8)
local alertLbl=Instance.new("TextLabel",alertFrame); alertLbl.Size=UDim2.new(1,0,1,0)
alertLbl.Text="⚠️  KATİL YAKLAŞIYOR!"; alertLbl.TextSize=14
alertLbl.Font=Enum.Font.GothamBold; alertLbl.TextColor3=Color3.new(1,1,1); alertLbl.BackgroundTransparency=1

Sec(P1,"UYARI SİSTEMİ")
Tog(P1,"⚠️ Katil Yaklaşma Uyarısı  (15 studs)",function(on)
    alertOn=on
    if on then
        alertConn=RS.Heartbeat:Connect(function()
            local r=R(); if not r then return end
            local found=false
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                local role=getRole(plr)
                if role=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t and (t.Position-r.Position).Magnitude<15 then
                        found=true; break
                    end
                end
            end
            alertFrame.Visible=found
        end)
    else
        if alertConn then alertConn:Disconnect();alertConn=nil end
        alertFrame.Visible=false
    end
end)

-- ── Coin ESP ──────────────────────────────
local coinESPObjs={}
local coinOn=false; local coinConn

local function clearCoinESP()
    for _,o in pairs(coinESPObjs) do pcall(function() o:Destroy() end) end coinESPObjs={}
end

local function buildCoinESP()
    clearCoinESP()
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if obj:IsA("BasePart") and (n:find("coin") or n=="credit" or n=="gem") then
            local bill=Instance.new("BillboardGui",obj)
            bill.Name="CoinESP"; bill.AlwaysOnTop=true
            bill.Size=UDim2.fromOffset(60,22); bill.StudsOffset=Vector3.new(0,2,0)
            local l=Instance.new("TextLabel",bill); l.Size=UDim2.new(1,0,1,0)
            l.Text="💰 COIN"; l.TextSize=10; l.Font=Enum.Font.GothamBold
            l.TextColor3=Color3.fromRGB(255,215,0); l.BackgroundTransparency=1
            table.insert(coinESPObjs,bill)
        end
    end
end

Sec(P1,"COIN & SİLAH ESP")
Tog(P1,"💰 Coin ESP  (Tüm coinleri gör)",function(on)
    coinOn=on
    if on then
        buildCoinESP()
        coinConn=workspace.DescendantAdded:Connect(function(obj)
            local n=obj.Name:lower()
            if obj:IsA("BasePart") and (n:find("coin") or n=="credit" or n=="gem") then
                task.wait(0.05); buildCoinESP()
            end
        end)
    else
        clearCoinESP()
        if coinConn then coinConn:Disconnect();coinConn=nil end
    end
end)

-- Silah ESP (yerde düşen bıçak/silah)
local weaponESPObjs={}
local function clearWeaponESP()
    for _,o in pairs(weaponESPObjs) do pcall(function() o:Destroy() end) end weaponESPObjs={}
end
local function buildWeaponESP()
    clearWeaponESP()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            local isKnife = n:find("knife") or n:find("bıçak")
            local isGun   = n:find("gun") or n:find("revolver") or n:find("luger") or n:find("sheriff")
            if isKnife or isGun then
                local handle=obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                if handle then
                    local bill=Instance.new("BillboardGui",handle)
                    bill.Name="WeaponESP"; bill.AlwaysOnTop=true
                    bill.Size=UDim2.fromOffset(80,22); bill.StudsOffset=Vector3.new(0,2.5,0)
                    local l=Instance.new("TextLabel",bill); l.Size=UDim2.new(1,0,1,0)
                    l.Text=isKnife and "🔪 BIÇAK" or "🔫 SİLAH"
                    l.TextSize=10; l.Font=Enum.Font.GothamBold
                    l.TextColor3=isKnife and Color3.fromRGB(255,80,80) or Color3.fromRGB(80,150,255)
                    l.BackgroundTransparency=1
                    table.insert(weaponESPObjs,bill)
                end
            end
        end
    end
end

Tog(P1,"🔪 Bıçak / Silah ESP  (Yerde düşen)",function(on)
    if on then buildWeaponESP() else clearWeaponESP() end
end)
Btn(P1,"🔄 Silah ESP Yenile",Color3.fromRGB(25,25,40),buildWeaponESP)

-- ══════════════════════════════════════════
-- TAB 2 — HAREKET
-- ══════════════════════════════════════════
local P2=pages[2]
Sec(P2,"HAREKET")
Sli(P2,"🏃 Hız",16,250,16,function(v) local h=H(); if h then h.WalkSpeed=v end end)
Sli(P2,"⬆️ Zıplama",50,400,50,function(v)
    local h=H(); if not h then return end
    pcall(function() h.JumpPower=v end)
    pcall(function() h.JumpHeight=v/5 end)
end)

-- Uçuş
local flyOn=false;local fV,fG,fC
Tog(P2,"🛩️ Uçuş  (WASD + Space/Shift)",function(on)
    flyOn=on; local r=R()
    if on and r then
        fG=Instance.new("BodyGyro",r); fG.MaxTorque=Vector3.new(9e8,9e8,9e8); fG.P=9e4
        fV=Instance.new("BodyVelocity",r); fV.MaxForce=Vector3.new(9e8,9e8,9e8); fV.Velocity=Vector3.zero
        fC=RS.Heartbeat:Connect(function()
            local rt=R(); if not(flyOn and rt) then if fC then fC:Disconnect() end return end
            local cam=workspace.CurrentCamera; local d=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then d+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.new(0,1,0) end
            fV.Velocity=d.Magnitude>0 and d.Unit*75 or Vector3.zero
            fG.CFrame=workspace.CurrentCamera.CFrame
        end)
    else
        if fC then fC:Disconnect();fC=nil end
        pcall(function() if fV then fV:Destroy() end end); fV=nil
        pcall(function() if fG then fG:Destroy() end end); fG=nil
    end
end)

-- Noclip
local ncOn=false;local ncC
Tog(P2,"🌫️ Noclip  (Duvardan geç)",function(on)
    ncOn=on
    if on then
        ncC=RS.Stepped:Connect(function()
            local c=C(); if not c then return end
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end)
    else
        if ncC then ncC:Disconnect();ncC=nil end
        local c=C(); if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end)

-- Sonsuz zıplama
local ijC
Tog(P2,"🚀 Sonsuz Zıplama",function(on)
    if on then
        ijC=UIS.JumpRequest:Connect(function()
            local h=H(); if h and h.FloorMaterial==Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else if ijC then ijC:Disconnect();ijC=nil end end
end)

Sec(P2,"KORUMA")
-- God mode
local godC
Tog(P2,"🛡️ God Mode  (Ölümsüzlük)",function(on)
    local h=H(); if not h then return end
    if on then
        h.MaxHealth=math.huge; h.Health=math.huge
        godC=h.HealthChanged:Connect(function() if h and h.Parent then h.Health=math.huge end end)
    else
        if godC then godC:Disconnect();godC=nil end
        pcall(function() h.MaxHealth=100; h.Health=100 end)
    end
end)

-- Anti-AFK
local afkC
Tog(P2,"💤 Anti-AFK",function(on)
    if on then
        local vu=game:GetService("VirtualUser")
        afkC=RS.Heartbeat:Connect(function()
            vu:Button2Down(Vector2.zero,workspace.CurrentCamera.CFrame)
            vu:Button2Up(Vector2.zero,workspace.CurrentCamera.CFrame)
        end)
    else if afkC then afkC:Disconnect();afkC=nil end end
end)

Sec(P2,"ANLIK")
Btn(P2,"☁️ Havaya Zıpla",Color3.fromRGB(30,30,50),function()
    local r=R(); if r then r.CFrame=r.CFrame+Vector3.new(0,55,0) end
end)
Btn(P2,"🔄 Respawn",Color3.fromRGB(30,30,50),function() lp:LoadCharacter() end)
Btn(P2,"👻 Karakter Gizle",Color3.fromRGB(30,30,50),function()
    local c=C(); if not c then return end
    for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=1 end end
end)

-- ══════════════════════════════════════════
-- TAB 3 — HARİTA / GÖRSEL
-- ══════════════════════════════════════════
local P3=pages[3]
Sec(P3,"GÖRSEL")

local oA=Lighting.Ambient; local oO=Lighting.OutdoorAmbient
local oB=Lighting.Brightness; local oS=Lighting.GlobalShadows; local oCT=Lighting.ClockTime

Tog(P3,"💡 Fullbright  (Karanlıkta gör)",function(on)
    if on then
        Lighting.Brightness=10; Lighting.ClockTime=14; Lighting.FogEnd=100000
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255); Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness=oB; Lighting.ClockTime=oCT; Lighting.GlobalShadows=oS
        Lighting.Ambient=oA; Lighting.OutdoorAmbient=oO
    end
end)

Tog(P3,"🌙 Gece Modu",function(on)
    Lighting.ClockTime=on and 0 or oCT
    Lighting.Ambient=on and Color3.fromRGB(20,20,50) or oA
end)

Tog(P3,"🌁 Sisi Kaldır",function(on)
    Lighting.FogEnd=on and 999999 or 1000
    Lighting.FogStart=on and 999990 or 0
end)

Sec(P3,"HARİTA KONUMLARI")
-- MM2 haritasında klasik spawns
local locs={
    {"🏠 Spawn", Vector3.new(0,10,0)},
    {"🔫 Silah Noktası", Vector3.new(0,10,30)},
    {"🏃 Kaçış Yolu", Vector3.new(50,10,50)},
    {"🔝 Çatı", Vector3.new(0,40,0)},
}

local gridF=Instance.new("Frame",P3)
gridF.Size=UDim2.new(1,0,0,math.ceil(#locs/2)*38+4); gridF.BackgroundTransparency=1; gridF.BorderSizePixel=0
local gl2=Instance.new("UIGridLayout",gridF)
gl2.CellSize=UDim2.new(0.5,-3,0,32); gl2.CellPadding=UDim2.new(0,4,0,4)
gl2.HorizontalAlignment=Enum.HorizontalAlignment.Center

for _,loc in ipairs(locs) do
    local b=Instance.new("TextButton",gridF)
    b.Text=loc[1]; b.TextSize=10; b.Font=Enum.Font.GothamSemibold
    b.TextColor3=Color3.fromRGB(200,200,225); b.BackgroundColor3=Color3.fromRGB(20,20,33)
    b.BorderSizePixel=0; Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    local pos=loc[2]
    b.MouseButton1Click:Connect(function()
        local r=R(); if r then r.CFrame=CFrame.new(pos) end
    end)
    b.MouseEnter:Connect(function() TS:Create(b,TW,{BackgroundColor3=Color3.fromRGB(30,120,255)}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b,TW,{BackgroundColor3=Color3.fromRGB(20,20,33)}):Play() end)
end

-- ══════════════════════════════════════════
-- TAB 4 — AYARLAR
-- ══════════════════════════════════════════
local P4=pages[4]
Sec(P4,"KLAVYE KISAYOLLARI")
local ki=Instance.new("Frame",P4); ki.Size=UDim2.new(1,0,0,52)
ki.BackgroundColor3=Color3.fromRGB(15,15,24); ki.BorderSizePixel=0
Instance.new("UICorner",ki).CornerRadius=UDim.new(0,7)
local kl=Instance.new("TextLabel",ki)
kl.Size=UDim2.new(1,-14,1,0); kl.Position=UDim2.new(0,7,0,0)
kl.Text="RightShift → Aç/Kapat\nDelete → Kapat   |   Insert → Aç"
kl.TextSize=10; kl.Font=Enum.Font.Gotham; kl.TextColor3=Color3.fromRGB(180,180,210)
kl.TextWrapped=true; kl.TextXAlignment=Enum.TextXAlignment.Left; kl.BackgroundTransparency=1

Sec(P4,"HIZLI TEMİZLE")
Btn(P4,"🗑️ Tüm ESP Kapat",Color3.fromRGB(30,30,50),function()
    clearESP(); clearCoinESP(); clearWeaponESP()
    alertFrame.Visible=false
end)

Sec(P4,"HAKKINDA")
local ab=Instance.new("Frame",P4); ab.Size=UDim2.new(1,0,0,72)
ab.BackgroundColor3=Color3.fromRGB(15,15,24); ab.BorderSizePixel=0
Instance.new("UICorner",ab).CornerRadius=UDim.new(0,7)
local al=Instance.new("TextLabel",ab)
al.Size=UDim2.new(1,-14,1,0); al.Position=UDim2.new(0,7,0,0); al.TextSize=10
al.Font=Enum.Font.Gotham; al.TextColor3=Color3.fromRGB(170,170,205)
al.TextWrapped=true; al.BackgroundTransparency=1; al.TextXAlignment=Enum.TextXAlignment.Left
al.Text="🔪 MM2 HUB — Murder Mystery 2 Hilesi\n\nRol ESP → Katil/Şerif/Masumu görürsün\nCoin ESP → Tüm coinler görünür\nUyarı → Katil yaklaşınca bildirim alırsın\nMobil + PC uyumlu"

-- ══════════════════════════════════════════
-- TOGGLE BUTONU (her zaman görünür)
-- ══════════════════════════════════════════
local togB=Instance.new("TextButton",sg)
togB.Size=UDim2.fromOffset(40,40); togB.Position=UDim2.new(0,8,0.5,-20)
togB.Text="🔪"; togB.TextSize=18; togB.BackgroundColor3=Color3.fromRGB(30,120,255)
togB.BorderSizePixel=0
Instance.new("UICorner",togB).CornerRadius=UDim.new(1,0)
do local s=Instance.new("UIStroke",togB); s.Color=Color3.new(1,1,1); s.Thickness=1 end
togB.MouseButton1Click:Connect(function() win.Visible=not win.Visible end)

-- Klavye kısayolları
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then win.Visible=not win.Visible
    elseif i.KeyCode==Enum.KeyCode.Delete  then win.Visible=false
    elseif i.KeyCode==Enum.KeyCode.Insert  then win.Visible=true end
end)

-- Karakter yenilenince
lp.CharacterAdded:Connect(function(char)
    task.wait(0.8)
    flyOn=false
    if fC then fC:Disconnect();fC=nil end
    pcall(function() if fV then fV:Destroy() end end); fV=nil
    pcall(function() if fG then fG:Destroy() end end); fG=nil
    if ncOn then
        if ncC then ncC:Disconnect() end
        ncC=RS.Stepped:Connect(function()
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end)
    end
    if espOn then task.wait(1); buildESP(); watchRoles() end
end)

Players.PlayerAdded:Connect(function()   task.wait(0.5); if espOn then buildESP(); watchRoles() end end)
Players.PlayerRemoving:Connect(function() task.wait(0.1); if espOn then buildESP() end end)

print("[MM2 HUB] Yüklendi! RightShift = aç/kapat")
