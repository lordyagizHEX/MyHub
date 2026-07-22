--[[
  LORD HUB — MURDER MYSTERY 2  (TAM SÜRÜM)
  Tüm özellikler dahil | Mobil + PC | Tüm executor
--]]

local Players  = game:GetService("Players")
local RS       = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local TS       = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Debris   = game:GetService("Debris")
local lp       = Players.LocalPlayer
local pgui     = lp.PlayerGui
local cam      = workspace.CurrentCamera

if pgui:FindFirstChild("MM2Hub") then pgui.MM2Hub:Destroy() end

-- ── Yardımcılar ────────────────────────────────
local function C()  return lp.Character end
local function R()  local c=C(); return c and c:FindFirstChild("HumanoidRootPart") end
local function H()  local c=C(); return c and c:FindFirstChildOfClass("Humanoid") end

-- ── Drawing API kontrolü ───────────────────────
local hasDrawing = pcall(function() return Drawing.new end)

-- ── Rol tespiti ────────────────────────────────
local KNIFE_KW={"knife","bıçak","mm2knife","sickle","virtual knife"}
local GUN_KW  ={"revolver","gun","sheriff","luger","mm2gun","pistol"}
local function getRole(plr)
    if plr==lp then return "self" end
    local sources={plr.Character,plr:FindFirstChild("Backpack")}
    for _,src in pairs(sources) do
        if not src then continue end
        for _,t in pairs(src:GetChildren()) do
            if t:IsA("Tool") then
                local n=t.Name:lower()
                for _,k in pairs(KNIFE_KW) do if n:find(k) then return "murderer" end end
                for _,g in pairs(GUN_KW)   do if n:find(g) then return "sheriff"  end end
            end
        end
    end
    return "innocent"
end
local RCOL={murderer=Color3.fromRGB(255,50,50),sheriff=Color3.fromRGB(50,130,255),innocent=Color3.fromRGB(80,220,80),unknown=Color3.fromRGB(160,160,160)}
local RTXT={murderer="🔪 KATİL",sheriff="🔫 ŞERİF",innocent="🟢 MASUM",unknown="❔"}

-- ══════════════════════════════════════════════
-- GUI
-- ══════════════════════════════════════════════
local W,HH=320,440
local sg=Instance.new("ScreenGui",pgui)
sg.Name="MM2Hub";sg.ResetOnSpawn=false;sg.IgnoreGuiInset=true

local win=Instance.new("Frame",sg)
win.Size=UDim2.fromOffset(W,HH);win.Position=UDim2.new(0.5,-W/2,0.5,-HH/2)
win.BackgroundColor3=Color3.fromRGB(10,10,18);win.BorderSizePixel=0
win.Active=true;win.Draggable=true
Instance.new("UICorner",win).CornerRadius=UDim.new(0,10)
do local s=Instance.new("UIStroke",win);s.Color=Color3.fromRGB(30,120,255);s.Thickness=1.5 end

-- Başlık
local bar=Instance.new("Frame",win)
bar.Size=UDim2.new(1,0,0,44);bar.BackgroundColor3=Color3.fromRGB(14,14,26);bar.BorderSizePixel=0
Instance.new("UICorner",bar).CornerRadius=UDim.new(0,10)
local bfix=Instance.new("Frame",bar);bfix.Size=UDim2.new(1,0,0.5,0);bfix.Position=UDim2.new(0,0,0.5,0)
bfix.BackgroundColor3=Color3.fromRGB(14,14,26);bfix.BorderSizePixel=0

local function mkL(p,txt,sz,col,xw,yw,ox,oy,xa,f)
    local l=Instance.new("TextLabel",p);l.Text=txt;l.TextSize=sz or 12
    l.TextColor3=col or Color3.new(1,1,1);l.Font=f or Enum.Font.GothamBold
    l.Size=UDim2.new(xw or 0,ox or 0,yw or 0,oy or 0);l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Left;return l
end
local ico=mkL(bar,"🔪",22,nil,0,44,0,1);ico.Position=UDim2.new(0,8,0,0);ico.TextXAlignment=Enum.TextXAlignment.Center
local tn=mkL(bar,"MM2 HUB",14,nil,0,22,0.55,0);tn.Position=UDim2.new(0,36,0,4)
local ts_=mkL(bar,"MURDER MYSTERY 2",8,Color3.fromRGB(30,120,255),0,14,0.55,0,nil,Enum.Font.GothamSemibold)
ts_.Position=UDim2.new(0,36,0,26)

local function hBtn(txt,col,ox)
    local b=Instance.new("TextButton",bar)
    b.Size=UDim2.fromOffset(24,24);b.Position=UDim2.new(1,ox,0.5,-12)
    b.Text=txt;b.TextSize=11;b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=col;b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5);return b
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
tabBar.Size=UDim2.new(1,0,0,30);tabBar.Position=UDim2.new(0,0,0,44)
tabBar.BackgroundColor3=Color3.fromRGB(12,12,22);tabBar.BorderSizePixel=0
do local l=Instance.new("UIListLayout",tabBar)
   l.FillDirection=Enum.FillDirection.Horizontal
   l.HorizontalAlignment=Enum.HorizontalAlignment.Center
   l.VerticalAlignment=Enum.VerticalAlignment.Center;l.Padding=UDim.new(0,2) end

local CONTENT_H=HH-74
local content=Instance.new("Frame",win)
content.Size=UDim2.new(1,0,0,CONTENT_H);content.Position=UDim2.new(0,0,0,74)
content.BackgroundTransparency=1;content.BorderSizePixel=0

local TABS={"👁ESP","🎯Oyun","👥Oyuncu","⚡Karakter","🎨Görsel","⚙Ayar"}
local tBtns={};local pages={};local activeTab=0

local function switchTab(i)
    if activeTab==i then return end;activeTab=i
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
    tb.Size=UDim2.fromOffset(48,24);tb.Text=name;tb.TextSize=8
    tb.Font=Enum.Font.GothamSemibold;tb.BorderSizePixel=0
    tb.BackgroundColor3=Color3.fromRGB(18,18,30);tb.TextColor3=Color3.fromRGB(110,110,150)
    Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5);tBtns[i]=tb

    local pg=Instance.new("ScrollingFrame",content)
    pg.Size=UDim2.new(1,0,1,0);pg.BackgroundTransparency=1
    pg.ScrollBarThickness=2;pg.ScrollBarImageColor3=Color3.fromRGB(30,120,255)
    pg.CanvasSize=UDim2.new(0,0,0,0);pg.AutomaticCanvasSize=Enum.AutomaticSize.Y
    pg.Visible=false;pg.BorderSizePixel=0
    do local ul=Instance.new("UIListLayout",pg)
       ul.Padding=UDim.new(0,4);ul.HorizontalAlignment=Enum.HorizontalAlignment.Center
       local pd=Instance.new("UIPadding",pg)
       pd.PaddingTop=UDim.new(0,6);pd.PaddingLeft=UDim.new(0,7);pd.PaddingRight=UDim.new(0,7) end
    pages[i]=pg;local idx=i
    tb.MouseButton1Click:Connect(function() switchTab(idx) end)
end
switchTab(1)

-- ── UI bileşenleri ─────────────────────────────
local TW=TweenInfo.new(0.15,Enum.EasingStyle.Quad)

local function Sec(pg,txt)
    local f=Instance.new("Frame",pg);f.Size=UDim2.new(1,0,0,18);f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,0,1,0)
    l.Text="  "..txt;l.TextSize=9;l.Font=Enum.Font.GothamBold
    l.TextColor3=Color3.fromRGB(30,120,255);l.TextXAlignment=Enum.TextXAlignment.Left;l.BackgroundTransparency=1
end

local function Btn(pg,txt,col,cb)
    local b=Instance.new("TextButton",pg)
    b.Size=UDim2.new(1,0,0,34);b.Text=txt;b.TextSize=11
    b.Font=Enum.Font.GothamSemibold;b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=col or Color3.fromRGB(30,120,255);b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    b.MouseButton1Click:Connect(cb)
    b.MouseEnter:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0.3}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b,TW,{BackgroundTransparency=0}):Play() end)
    return b
end

local function Tog(pg,txt,cb)
    local row=Instance.new("TextButton",pg)
    row.Size=UDim2.new(1,0,0,36);row.Text=""
    row.BackgroundColor3=Color3.fromRGB(17,17,28);row.BorderSizePixel=0
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,7)
    local nl=Instance.new("TextLabel",row)
    nl.Size=UDim2.new(0.72,0,1,0);nl.Position=UDim2.new(0,9,0,0)
    nl.Text=txt;nl.TextSize=10;nl.Font=Enum.Font.GothamSemibold
    nl.TextColor3=Color3.fromRGB(205,205,230);nl.TextXAlignment=Enum.TextXAlignment.Left;nl.BackgroundTransparency=1
    local bg=Instance.new("Frame",row)
    bg.Size=UDim2.fromOffset(38,19);bg.Position=UDim2.new(1,-46,0.5,-9.5)
    bg.BackgroundColor3=Color3.fromRGB(48,48,65);bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(1,0)
    local kn=Instance.new("Frame",bg)
    kn.Size=UDim2.fromOffset(13,13);kn.Position=UDim2.new(0,3,0.5,-6.5)
    kn.BackgroundColor3=Color3.fromRGB(155,155,180);kn.BorderSizePixel=0
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
    f.Size=UDim2.new(1,0,0,50);f.BackgroundColor3=Color3.fromRGB(17,17,28)
    f.BorderSizePixel=0;Instance.new("UICorner",f).CornerRadius=UDim.new(0,7)
    local nl=Instance.new("TextLabel",f);nl.Size=UDim2.new(0.62,0,0,20)
    nl.Position=UDim2.new(0,9,0,4);nl.Text=txt;nl.TextSize=11
    nl.Font=Enum.Font.GothamSemibold;nl.TextColor3=Color3.fromRGB(205,205,230)
    nl.TextXAlignment=Enum.TextXAlignment.Left;nl.BackgroundTransparency=1
    local vl=Instance.new("TextLabel",f);vl.Size=UDim2.new(0.34,0,0,20)
    vl.Position=UDim2.new(0.62,-4,0,4);vl.Text=tostring(def);vl.TextSize=11
    vl.Font=Enum.Font.GothamBold;vl.TextColor3=Color3.fromRGB(30,120,255)
    vl.TextXAlignment=Enum.TextXAlignment.Right;vl.BackgroundTransparency=1
    local tr=Instance.new("Frame",f);tr.Size=UDim2.new(1,-18,0,4)
    tr.Position=UDim2.new(0,9,0,36);tr.BackgroundColor3=Color3.fromRGB(36,36,55)
    tr.BorderSizePixel=0;Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
    local p0=(def-mn)/(mx-mn)
    local fi=Instance.new("Frame",tr);fi.Size=UDim2.new(p0,0,1,0)
    fi.BackgroundColor3=Color3.fromRGB(30,120,255);fi.BorderSizePixel=0
    Instance.new("UICorner",fi).CornerRadius=UDim.new(1,0)
    local kk=Instance.new("Frame",tr);kk.Size=UDim2.fromOffset(11,11)
    kk.AnchorPoint=Vector2.new(0.5,0.5);kk.Position=UDim2.new(p0,0,0.5,0)
    kk.BackgroundColor3=Color3.new(1,1,1);kk.BorderSizePixel=0
    Instance.new("UICorner",kk).CornerRadius=UDim.new(1,0)
    local dr=false
    local function upd(x)
        local p=math.clamp((x-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        local v=math.floor(mn+p*(mx-mn));vl.Text=tostring(v)
        fi.Size=UDim2.new(p,0,1,0);kk.Position=UDim2.new(p,0,0.5,0);cb(v)
    end
    tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true;upd(i.Position.X) end end)
    kk.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true end end)
    UIS.InputChanged:Connect(function(i) if dr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then upd(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end)
end

-- ══════════════════════════════════════════════
-- TAB 1 — ESP
-- ══════════════════════════════════════════════
local P1=pages[1]
local espObjs={};local espOn=false

local function clearESP()
    for _,o in pairs(espObjs) do pcall(function()o:Destroy()end) end;espObjs={}
end
local function buildESP()
    clearESP()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local char=plr.Character;if not char then continue end
        local head=char:FindFirstChild("Head");if not head then continue end
        local role=getRole(plr);local col=RCOL[role]
        local bill=Instance.new("BillboardGui",head)
        bill.Name="MM2ESP";bill.AlwaysOnTop=true
        bill.Size=UDim2.fromOffset(165,55);bill.StudsOffset=Vector3.new(0,3.8,0)
        local bg=Instance.new("Frame",bill);bg.Size=UDim2.new(1,0,1,0)
        bg.BackgroundColor3=Color3.fromRGB(8,8,14);bg.BackgroundTransparency=0.3;bg.BorderSizePixel=0
        Instance.new("UICorner",bg).CornerRadius=UDim.new(0,6)
        do local st=Instance.new("UIStroke",bg);st.Color=col;st.Thickness=1.2 end
        local rl=Instance.new("TextLabel",bg);rl.Size=UDim2.new(1,0,0.42,0)
        rl.Text=RTXT[role];rl.TextSize=11;rl.Font=Enum.Font.GothamBold
        rl.TextColor3=col;rl.BackgroundTransparency=1
        local nl=Instance.new("TextLabel",bg);nl.Size=UDim2.new(1,0,0.3,0)
        nl.Position=UDim2.new(0,0,0.42,0);nl.Text=plr.Name;nl.TextSize=10
        nl.Font=Enum.Font.Gotham;nl.TextColor3=Color3.new(1,1,1);nl.BackgroundTransparency=1
        local hum=char:FindFirstChildOfClass("Humanoid")
        local hl=Instance.new("TextLabel",bg);hl.Size=UDim2.new(1,0,0.28,0)
        hl.Position=UDim2.new(0,0,0.72,0);hl.TextSize=9;hl.Font=Enum.Font.Gotham
        hl.TextColor3=Color3.fromRGB(100,255,100);hl.BackgroundTransparency=1
        if hum then
            hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
            hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hl.Parent then hl.Text="❤ "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth) end
            end)
        end
        -- Rol değişince yenile
        char.ChildAdded:Connect(function(t) if t:IsA("Tool") and espOn then task.wait(0.1);buildESP() end end)
        char.ChildRemoved:Connect(function(t) if t:IsA("Tool") and espOn then task.wait(0.1);buildESP() end end)
        table.insert(espObjs,bill)
    end
end

Sec(P1,"ROL ESP")
Tog(P1,"👁️ Rol ESP  (Katil🔴 Şerif🔵 Masum🟢)",function(on) espOn=on; if on then buildESP() else clearESP() end end)
Btn(P1,"🔄 ESP Yenile",Color3.fromRGB(22,22,38),function() if espOn then buildESP() end end)

-- Tracer çizgileri
local tracerLines={};local tracerOn=false;local tracerConn
local function clearTracers() for _,l in pairs(tracerLines) do pcall(function()l.Visible=false;l:Remove()end) end;tracerLines={} end
local function buildTracers()
    clearTracers()
    if not hasDrawing then return end
    for _,plr in pairs(Players:GetPlayers()) do
        if plr==lp then continue end
        local role=getRole(plr)
        if role~="murderer" and role~="sheriff" then continue end
        local root=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local sp,vis=cam:WorldToViewportPoint(root.Position)
        if not vis then continue end
        local line=Drawing.new("Line")
        line.From=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y-20)
        line.To  =Vector2.new(sp.X,sp.Y)
        line.Color=role=="murderer" and Color3.fromRGB(255,50,50) or Color3.fromRGB(50,130,255)
        line.Thickness=1.8;line.Visible=true
        table.insert(tracerLines,line)
    end
end

Sec(P1,"TRACER & CROSSHAIR")
Tog(P1,"📏 Tracer  (Katile/Şerife çizgi)",function(on)
    tracerOn=on
    if on and hasDrawing then
        tracerConn=RS.Heartbeat:Connect(function() buildTracers() end)
    else
        clearTracers()
        if tracerConn then tracerConn:Disconnect();tracerConn=nil end
    end
end)

-- Crosshair
local chLines={};local chOn=false;local chConn
local function buildCH()
    for _,l in pairs(chLines) do pcall(function()l.Visible=false;l:Remove()end) end;chLines={}
    if not hasDrawing then return end
    local cx,cy=cam.ViewportSize.X/2,cam.ViewportSize.Y/2
    local sz,gap,thick=14,5,1.8
    local defs={
        {Vector2.new(cx-sz,cy),Vector2.new(cx-gap,cy)},
        {Vector2.new(cx+gap,cy),Vector2.new(cx+sz,cy)},
        {Vector2.new(cx,cy-sz),Vector2.new(cx,cy-gap)},
        {Vector2.new(cx,cy+gap),Vector2.new(cx,cy+sz)},
    }
    for _,d in pairs(defs) do
        local l=Drawing.new("Line");l.From=d[1];l.To=d[2]
        l.Color=Color3.new(1,1,1);l.Thickness=thick;l.Visible=true
        table.insert(chLines,l)
    end
end
Tog(P1,"➕ Crosshair  (Ekrana nişangah)",function(on)
    chOn=on
    if on and hasDrawing then
        buildCH()
        chConn=RS.Heartbeat:Connect(function() buildCH() end)
    else
        for _,l in pairs(chLines) do pcall(function()l.Visible=false;l:Remove()end) end;chLines={}
        if chConn then chConn:Disconnect();chConn=nil end
    end
end)

-- Coin ESP
local coinESP={};local coinESPOn=false;local coinConn2
local function clearCoinESP() for _,o in pairs(coinESP) do pcall(function()o:Destroy()end) end;coinESP={} end
local function buildCoinESP()
    clearCoinESP()
    for _,obj in pairs(workspace:GetDescendants()) do
        local n=obj.Name:lower()
        if obj:IsA("BasePart") and(n:find("coin") or n=="credit" or n=="gem") then
            local bill=Instance.new("BillboardGui",obj)
            bill.Name="CoinESP";bill.AlwaysOnTop=true
            bill.Size=UDim2.fromOffset(55,20);bill.StudsOffset=Vector3.new(0,2.5,0)
            local l=Instance.new("TextLabel",bill);l.Size=UDim2.new(1,0,1,0)
            l.Text="💰";l.TextSize=14;l.Font=Enum.Font.GothamBold
            l.TextColor3=Color3.fromRGB(255,215,0);l.BackgroundTransparency=1
            table.insert(coinESP,bill)
        end
    end
end

Sec(P1,"COIN & SİLAH ESP")
Tog(P1,"💰 Coin ESP",function(on)
    coinESPOn=on
    if on then
        buildCoinESP()
        coinConn2=workspace.DescendantAdded:Connect(function() task.wait(0.1);if coinESPOn then buildCoinESP() end end)
    else
        clearCoinESP();if coinConn2 then coinConn2:Disconnect();coinConn2=nil end
    end
end)

-- Weapon ESP
local wESP={};local function clearWESP() for _,o in pairs(wESP) do pcall(function()o:Destroy()end) end;wESP={} end
local function buildWESP()
    clearWESP()
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            local isk=false;local isg=false
            for _,k in pairs(KNIFE_KW) do if n:find(k) then isk=true;break end end
            for _,g in pairs(GUN_KW)   do if n:find(g) then isg=true;break end end
            if isk or isg then
                local h2=obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                if h2 then
                    local bill=Instance.new("BillboardGui",h2)
                    bill.Name="WEsp";bill.AlwaysOnTop=true
                    bill.Size=UDim2.fromOffset(70,20);bill.StudsOffset=Vector3.new(0,2.5,0)
                    local l=Instance.new("TextLabel",bill);l.Size=UDim2.new(1,0,1,0)
                    l.Text=isk and "🔪 BIÇAK" or "🔫 SİLAH";l.TextSize=10
                    l.Font=Enum.Font.GothamBold
                    l.TextColor3=isk and Color3.fromRGB(255,80,80) or Color3.fromRGB(80,150,255)
                    l.BackgroundTransparency=1;table.insert(wESP,bill)
                end
            end
        end
    end
end
Tog(P1,"🔪 Silah ESP  (Yerdeki bıçak/silah)",function(on) if on then buildWESP() else clearWESP() end end)
Btn(P1,"🔄 Silah ESP Yenile",Color3.fromRGB(22,22,38),buildWESP)

-- Uyarı HUD
local alertF=Instance.new("Frame",sg)
alertF.Size=UDim2.new(0.5,0,0,38);alertF.Position=UDim2.new(0.25,0,0,56)
alertF.BackgroundColor3=Color3.fromRGB(200,20,20);alertF.BackgroundTransparency=0.18
alertF.BorderSizePixel=0;alertF.Visible=false
Instance.new("UICorner",alertF).CornerRadius=UDim.new(0,8)
local alertTxt=Instance.new("TextLabel",alertF);alertTxt.Size=UDim2.new(1,0,1,0)
alertTxt.Text="⚠️  KATİL YAKLAŞIYOR!";alertTxt.TextSize=13
alertTxt.Font=Enum.Font.GothamBold;alertTxt.TextColor3=Color3.new(1,1,1);alertTxt.BackgroundTransparency=1

local alertC
Sec(P1,"UYARI")
Tog(P1,"⚠️ Katil Uyarısı  (15 studs)",function(on)
    if on then
        alertC=RS.Heartbeat:Connect(function()
            local r=R();if not r then return end
            local found=false
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t and(t.Position-r.Position).Magnitude<15 then found=true;break end
                end
            end
            alertF.Visible=found
        end)
    else
        if alertC then alertC:Disconnect();alertC=nil end;alertF.Visible=false
    end
end)

-- ══════════════════════════════════════════════
-- TAB 2 — OYUN İÇİ
-- ══════════════════════════════════════════════
local P2=pages[2]

-- Auto Coin
Sec(P2,"OTOMATİK")
local autoCoinC;local autoCoinOn=false
Tog(P2,"💰 Auto Coin Topla  (Otomatik ışın)",function(on)
    autoCoinOn=on
    if on then
        autoCoinC=RS.Heartbeat:Connect(function()
            local r=R();if not r then return end
            local best,bestD=nil,math.huge
            for _,obj in pairs(workspace:GetDescendants()) do
                local n=obj.Name:lower()
                if obj:IsA("BasePart") and(n:find("coin") or n=="credit") then
                    local d=(obj.Position-r.Position).Magnitude
                    if d<bestD then bestD=d;best=obj end
                end
            end
            if best and bestD<80 then
                r.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0))
            end
        end)
    else if autoCoinC then autoCoinC:Disconnect();autoCoinC=nil end end
end)

-- Katil Takip (kamera kilidi)
local camLockC;local camLockOn=false
Tog(P2,"🎥 Katil Takip  (Kamerayı katile kilitle)",function(on)
    camLockOn=on
    if on then
        camLockC=RS.Heartbeat:Connect(function()
            if not camLockOn then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t then
                        cam.CameraType=Enum.CameraType.Scriptable
                        local r=R()
                        if r then cam.CFrame=CFrame.lookAt(cam.CFrame.Position,t.Position) end
                    end
                    break
                end
            end
        end)
    else
        if camLockC then camLockC:Disconnect();camLockC=nil end
        cam.CameraType=Enum.CameraType.Custom
    end
end)

-- Silaha Teleport
Sec(P2,"TEK TUŞ")
Btn(P2,"🔪 Bıçağa Işınlan  (Yerdeki bıçak)",Color3.fromRGB(30,30,50),function()
    local r=R();if not r then return end
    local best,bestD=nil,math.huge
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            local isk=false
            for _,k in pairs(KNIFE_KW) do if n:find(k) then isk=true;break end end
            if isk then
                local h2=obj:FindFirstChild("Handle")
                if h2 then
                    local d=(h2.Position-r.Position).Magnitude
                    if d<bestD then bestD=d;best=h2 end
                end
            end
        end
    end
    if best then r.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0)) end
end)

Btn(P2,"🔫 Silaha Işınlan  (Yerdeki silah)",Color3.fromRGB(30,30,50),function()
    local r=R();if not r then return end
    local best,bestD=nil,math.huge
    for _,obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local n=obj.Name:lower()
            local isg=false
            for _,g in pairs(GUN_KW) do if n:find(g) then isg=true;break end end
            if isg then
                local h2=obj:FindFirstChild("Handle")
                if h2 then
                    local d=(h2.Position-r.Position).Magnitude
                    if d<bestD then bestD=d;best=h2 end
                end
            end
        end
    end
    if best then r.CFrame=CFrame.new(best.Position+Vector3.new(0,3,0)) end
end)

-- Katilden Kaç
local fleeC;local fleeOn=false
Sec(P2,"KAÇIŞ")
Tog(P2,"🏃 Katilden Kaç  (Otomatik uzaklaş)",function(on)
    fleeOn=on
    if on then
        fleeC=RS.Heartbeat:Connect(function()
            local r=R();if not r then return end
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                if getRole(plr)=="murderer" then
                    local t=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t then
                        local diff=(r.Position-t.Position)
                        if diff.Magnitude<25 then
                            local away=diff.Unit*28+Vector3.new(0,5,0)
                            r.CFrame=CFrame.new(r.Position+away)
                        end
                    end
                    break
                end
            end
        end)
    else if fleeC then fleeC:Disconnect();fleeC=nil end end
end)

-- Respawn Koruması
local respC
Sec(P2,"KORUMA")
Tog(P2,"🛡️ Respawn Koruması  (Ölünce hemen kalk)",function(on)
    if on then
        local h=H();if not h then return end
        respC=h.Died:Connect(function() task.wait(0.4);lp:LoadCharacter() end)
    else if respC then respC:Disconnect();respC=nil end end
end)

-- Sahte Lag
local lagOn=false;local lagC;local savedCF
Tog(P2,"💫 Sahte Lag  (Zor vurulursun)",function(on)
    lagOn=on
    if on then
        local tick_=0
        lagC=RS.Heartbeat:Connect(function(dt)
            tick_=tick_+dt
            local r=R();if not r then return end
            if tick_%0.12 < dt then
                savedCF=r.CFrame
            elseif tick_%0.12 > 0.06 and savedCF then
                r.CFrame=savedCF
            end
        end)
    else if lagC then lagC:Disconnect();lagC=nil end end
end)

-- ── Otomatik Silah / Bıçak Atma ───────────────
Sec(P2,"OTOMATİK SALDIRI")
local autoThrowC;local autoThrowOn=false

-- Hedef (Oyuncu sekmesinden ayarlanır)
local _targetPlayer=nil  -- oyuncu sekmesinden set edilecek

local function findThrowRemote()
    -- MM2'de farklı obfuscated isimler olabilir, hepsini dene
    for _,obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n=obj.Name:lower()
            if n:find("throw") or n:find("attack") or n:find("swing") or n:find("stab") or n:find("hit") or n:find("slash") then
                return obj
            end
        end
    end
    return nil
end

Tog(P2,"🔪 Oto Bıçak At  (Hedefe sürekli at)",function(on)
    autoThrowOn=on
    if on then
        autoThrowC=RS.Heartbeat:Connect(function()
            if not autoThrowOn then return end
            local r=R();if not r then return end
            -- Karakter içindeki bıçağı bul
            local c=C();if not c then return end
            local knife=nil
            for _,t in pairs(c:GetChildren()) do
                if t:IsA("Tool") then
                    local n=t.Name:lower()
                    for _,k in pairs(KNIFE_KW) do if n:find(k) then knife=t;break end end
                end
            end
            if not knife then return end

            -- Hedef
            local target=_targetPlayer or (function()
                -- Hedef yoksa en yakın oyuncuyu seç
                local best,bestD=nil,math.huge
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr==lp then continue end
                    local t2=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    if t2 then
                        local d=(t2.Position-r.Position).Magnitude
                        if d<bestD then bestD=d;best=plr end
                    end
                end
                return best
            end)()

            if not target then return end
            local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if not tRoot then return end

            -- RemoteEvent dene
            local remote=findThrowRemote()
            if remote then
                pcall(function() remote:FireServer(tRoot.Position) end)
            end

            -- Alternatif: Tool activate + mouse target
            pcall(function()
                if knife.Activated then knife.Activated:Fire() end
            end)
            pcall(function()
                local ms=lp:GetMouse()
                if ms then ms.Target=tRoot end
            end)
            -- Hızlı devre için kısa bekle
            task.wait(0.1)
        end)
    else if autoThrowC then autoThrowC:Disconnect();autoThrowC=nil end end
end)

Tog(P2,"🔫 Oto Silah At  (Hedefe sürekli ateş)",function(on)
    -- Şerif silahı için aynı mantık
    local c2=RS.Heartbeat:Connect(function()
        if not on then return end
        local r=R();if not r then return end
        local c=C();if not c then return end
        local gun=nil
        for _,t in pairs(c:GetChildren()) do
            if t:IsA("Tool") then
                local n=t.Name:lower()
                for _,g in pairs(GUN_KW) do if n:find(g) then gun=t;break end end
            end
        end
        if not gun then return end
        local target=_targetPlayer
        if not target then
            local best,bestD=nil,math.huge
            for _,plr in pairs(Players:GetPlayers()) do
                if plr==lp then continue end
                local t2=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if t2 then local d=(t2.Position-r.Position).Magnitude; if d<bestD then bestD=d;best=plr end end
            end
            target=best
        end
        if not target then return end
        local tRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not tRoot then return end
        local remote=findThrowRemote()
        if remote then pcall(function() remote:FireServer(tRoot.Position) end) end
        pcall(function() if gun.Activated then gun.Activated:Fire() end end)
        task.wait(0.15)
    end)
    if not on and c2 then c2:Disconnect() end
end)

-- ══════════════════════════════════════════════
-- TAB 3 — OYUNCU
-- ══════════════════════════════════════════════
local P3=pages[3]

-- Seçili oyuncu
local selPlr=nil
local selLbl=Instance.new("TextLabel",P3)
selLbl.Size=UDim2.new(1,0,0,20);selLbl.Text="🎯 Seçili: Yok"
selLbl.TextColor3=Color3.fromRGB(30,120,255);selLbl.TextSize=11
selLbl.Font=Enum.Font.GothamSemibold;selLbl.BackgroundTransparency=1

-- Oyuncu listesi
Sec(P3,"OYUNCU LİSTESİ  (Role renkli)")
local listSF=Instance.new("ScrollingFrame",P3)
listSF.Size=UDim2.new(1,0,0,140);listSF.BackgroundColor3=Color3.fromRGB(13,13,21)
listSF.BorderSizePixel=0;listSF.ScrollBarThickness=2
listSF.ScrollBarImageColor3=Color3.fromRGB(30,120,255);listSF.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",listSF).CornerRadius=UDim.new(0,7)

local pBtns={}
local function refreshList()
    for _,b in pairs(pBtns) do pcall(function()b:Destroy()end) end;pBtns={}
    local plrs={}
    for _,p in pairs(Players:GetPlayers()) do if p~=lp then table.insert(plrs,p) end end
    if #plrs==0 then
        local nl=Instance.new("TextLabel",listSF)
        nl.Size=UDim2.new(1,0,0,28);nl.Position=UDim2.fromOffset(0,4)
        nl.Text="Başka oyuncu yok";nl.TextSize=10;nl.Font=Enum.Font.Gotham
        nl.TextColor3=Color3.fromRGB(120,120,150);nl.BackgroundTransparency=1
        table.insert(pBtns,nl);listSF.CanvasSize=UDim2.new(0,0,0,36);return
    end
    for i,plr in ipairs(plrs) do
        local y=(i-1)*33
        local role=getRole(plr);local col=RCOL[role]
        local b=Instance.new("TextButton",listSF)
        b.Size=UDim2.new(1,-8,0,28);b.Position=UDim2.fromOffset(4,y+3)
        b.Text="  "..RTXT[role].."  "..plr.Name;b.TextSize=10
        b.Font=Enum.Font.GothamSemibold;b.TextXAlignment=Enum.TextXAlignment.Left
        b.TextColor3=col;b.BackgroundColor3=Color3.fromRGB(18,18,30);b.BorderSizePixel=0
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
        local pr=plr
        b.MouseButton1Click:Connect(function()
            selPlr=pr;_targetPlayer=pr
            selLbl.Text="🎯 Seçili: "..pr.Name.."  ("..RTXT[role]..")"
            selLbl.TextColor3=col
            for _,x in pairs(pBtns) do
                if x:IsA("TextButton") then x.BackgroundColor3=Color3.fromRGB(18,18,30) end
            end
            b.BackgroundColor3=Color3.fromRGB(30,120,255)
        end)
        table.insert(pBtns,b)
    end
    listSF.CanvasSize=UDim2.new(0,0,0,#plrs*33+6)
end

Btn(P3,"🔄 Listeyi Yenile",Color3.fromRGB(22,22,38),refreshList)

Sec(P3,"OYUNCU İŞLEMLERİ")
Btn(P3,"📦 Oyuncuya Işınlan",Color3.fromRGB(22,22,38),function()
    if not selPlr then return end
    local r=R();local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart")
    if r and t then r.CFrame=t.CFrame+Vector3.new(3,2,0) end
end)

Btn(P3,"💥 Oyuncuyu Fling",Color3.fromRGB(140,30,30),function()
    if not selPlr then return end
    local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart");if not t then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    v.Velocity=Vector3.new(math.random(-700,700),math.random(400,700),math.random(-700,700))
    Debris:AddItem(v,0.2)
end)

Btn(P3,"🪂 Havaya Fırlat",Color3.fromRGB(60,60,180),function()
    if not selPlr then return end
    local t=selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart");if not t then return end
    local v=Instance.new("BodyVelocity",t)
    v.MaxForce=Vector3.new(math.huge,math.huge,math.huge);v.Velocity=Vector3.new(0,1600,0)
    Debris:AddItem(v,0.15)
end)

-- Oyuncu Takip
local followC;local followOn=false
Tog(P3,"🏃 Oyuncu Takip  (Seçili oyuncuyu izle)",function(on)
    followOn=on
    if on then
        followC=RS.Heartbeat:Connect(function()
            local r=R();if not r then return end
            local t=selPlr and selPlr.Character and selPlr.Character:FindFirstChild("HumanoidRootPart")
            if t and(t.Position-r.Position).Magnitude>5 then
                r.CFrame=CFrame.new(t.Position+Vector3.new(3,0,0))
            end
        end)
    else if followC then followC:Disconnect();followC=nil end end
end)

Btn(P3,"🎯 Bu Oyuncuyu Saldırı Hedefi Yap",Color3.fromRGB(30,120,255),function()
    if selPlr then _targetPlayer=selPlr end
end)

-- ══════════════════════════════════════════════
-- TAB 4 — KARAKTER
-- ══════════════════════════════════════════════
local P4=pages[4]
Sec(P4,"HAREKET")
Sli(P4,"🏃 Hız",16,300,16,function(v) local h=H();if h then h.WalkSpeed=v end end)
Sli(P4,"⬆️ Zıplama",50,500,50,function(v)
    local h=H();if not h then return end
    pcall(function() h.JumpPower=v end)
    pcall(function() h.JumpHeight=v/5 end)
end)
Sli(P4,"🎥 FOV",50,130,70,function(v) cam.FieldOfView=v end)

-- Uçuş
local flyOn=false;local fV,fG,fC2
Tog(P4,"🛩️ Uçuş  (WASD + Space/Shift)",function(on)
    flyOn=on;local r=R()
    if on and r then
        fG=Instance.new("BodyGyro",r);fG.MaxTorque=Vector3.new(9e8,9e8,9e8);fG.P=9e4
        fV=Instance.new("BodyVelocity",r);fV.MaxForce=Vector3.new(9e8,9e8,9e8);fV.Velocity=Vector3.zero
        fC2=RS.Heartbeat:Connect(function()
            local rt=R();if not(flyOn and rt)then if fC2 then fC2:Disconnect()end;return end
            local d=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then d+=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then d-=cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then d-=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then d+=cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then d+=Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d-=Vector3.new(0,1,0) end
            fV.Velocity=d.Magnitude>0 and d.Unit*75 or Vector3.zero
            fG.CFrame=cam.CFrame
        end)
    else
        if fC2 then fC2:Disconnect();fC2=nil end
        pcall(function() if fV then fV:Destroy()end end);fV=nil
        pcall(function() if fG then fG:Destroy()end end);fG=nil
    end
end)

-- Noclip
local ncOn=false;local ncC
Tog(P4,"🌫️ Noclip",function(on)
    ncOn=on
    if on then
        ncC=RS.Stepped:Connect(function()
            local c=C();if not c then return end
            for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end)
    else
        if ncC then ncC:Disconnect();ncC=nil end
        local c=C();if c then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
    end
end)

-- Sonsuz Zıplama
local ijC
Tog(P4,"🚀 Sonsuz Zıplama",function(on)
    if on then
        ijC=UIS.JumpRequest:Connect(function()
            local h=H();if h and h.FloorMaterial==Enum.Material.Air then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else if ijC then ijC:Disconnect();ijC=nil end end
end)

Sec(P4,"KORUMA")
-- God Mode
local godC
Tog(P4,"🛡️ God Mode",function(on)
    local h=H();if not h then return end
    if on then
        h.MaxHealth=math.huge;h.Health=math.huge
        godC=h.HealthChanged:Connect(function() if h and h.Parent then h.Health=math.huge end end)
    else
        if godC then godC:Disconnect();godC=nil end
        pcall(function() h.MaxHealth=100;h.Health=100 end)
    end
end)

Tog(P4,"💤 Anti-AFK",function(on)
    if on then
        local vu=game:GetService("VirtualUser")
        RS.Heartbeat:Connect(function()
            if on then vu:Button2Down(Vector2.zero,cam.CFrame);vu:Button2Up(Vector2.zero,cam.CFrame) end
        end)
    end
end)

Sec(P4,"KİŞİSEL")
-- Invisible
Tog(P4,"👻 Görünmez  (Karakter gizle)",function(on)
    local c=C();if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") or p:IsA("Decal") then p.LocalTransparencyModifier=on and 1 or 0 end
    end
end)

-- Sprint (E tuşu)
local sprintC
Tog(P4,"⚡ Sprint Tuşu  (E basılı = koş)",function(on)
    if on then
        sprintC=RS.Heartbeat:Connect(function()
            local h=H();if not h then return end
            if UIS:IsKeyDown(Enum.KeyCode.E) then
                h.WalkSpeed=math.min(h.WalkSpeed+2,60)
            end
        end)
    else if sprintC then sprintC:Disconnect();sprintC=nil end end
end)

Sec(P4,"ANLIK")
Btn(P4,"☁️ Havaya Zıpla",Color3.fromRGB(25,25,42),function()
    local r=R();if r then r.CFrame=r.CFrame+Vector3.new(0,60,0) end
end)
Btn(P4,"🔄 Respawn",Color3.fromRGB(25,25,42),function() lp:LoadCharacter() end)

-- ══════════════════════════════════════════════
-- TAB 5 — GÖRSEL
-- ══════════════════════════════════════════════
local P5=pages[5]
local oA=Lighting.Ambient;local oO=Lighting.OutdoorAmbient
local oB=Lighting.Brightness;local oS=Lighting.GlobalShadows;local oCT=Lighting.ClockTime

Sec(P5,"ORTAM")
Tog(P5,"💡 Fullbright  (Karanlıkta gör)",function(on)
    if on then
        Lighting.Brightness=10;Lighting.ClockTime=14;Lighting.FogEnd=100000
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(255,255,255);Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness=oB;Lighting.ClockTime=oCT;Lighting.GlobalShadows=oS
        Lighting.Ambient=oA;Lighting.OutdoorAmbient=oO
    end
end)
Tog(P5,"🌙 Gece Modu",function(on)
    Lighting.ClockTime=on and 0 or oCT
    Lighting.Ambient=on and Color3.fromRGB(20,20,50) or oA
end)
Tog(P5,"🌁 Sisi Kaldır",function(on)
    Lighting.FogEnd=on and 999999 or 1000;Lighting.FogStart=on and 999990 or 0
end)

Sec(P5,"KARAKTER")
local chamsC
Tog(P5,"🌈 Chams  (Gökkuşağı renk)",function(on)
    if on then
        local t2=0
        chamsC=RS.Heartbeat:Connect(function(dt)
            t2=t2+dt;local c=C();if not c then return end
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then p.Color=Color3.fromHSV((t2*0.4)%1,1,1) end
            end
        end)
    else if chamsC then chamsC:Disconnect();chamsC=nil end end
end)

-- ══════════════════════════════════════════════
-- TAB 6 — AYAR
-- ══════════════════════════════════════════════
local P6=pages[6]
Sec(P6,"KLAVYE KISAYOLLARI")
local ki=Instance.new("Frame",P6);ki.Size=UDim2.new(1,0,0,55)
ki.BackgroundColor3=Color3.fromRGB(15,15,24);ki.BorderSizePixel=0
Instance.new("UICorner",ki).CornerRadius=UDim.new(0,7)
local kl=Instance.new("TextLabel",ki)
kl.Size=UDim2.new(1,-14,1,0);kl.Position=UDim2.new(0,7,0,0)
kl.Text="RightShift → Aç/Kapat\nDelete → Kapat  |  Insert → Aç\nE (basılı) → Sprint"
kl.TextSize=10;kl.Font=Enum.Font.Gotham;kl.TextColor3=Color3.fromRGB(180,180,210)
kl.TextWrapped=true;kl.TextXAlignment=Enum.TextXAlignment.Left;kl.BackgroundTransparency=1

Sec(P6,"HIZLI TEMİZLE")
Btn(P6,"🗑️ Tüm ESP Kapat",Color3.fromRGB(22,22,38),function()
    clearESP();clearCoinESP();clearWESP();clearTracers()
    for _,l in pairs(chLines) do pcall(function()l.Visible=false;l:Remove()end) end;chLines={}
    alertF.Visible=false
end)
Btn(P6,"🔄 Oyuncu Listesi Yenile",Color3.fromRGB(22,22,38),refreshList)
Btn(P6,"🎥 Kamerayı Sıfırla",Color3.fromRGB(22,22,38),function()
    cam.CameraType=Enum.CameraType.Custom;cam.FieldOfView=70
end)

Sec(P6,"HAKKINDA")
local ab=Instance.new("Frame",P6);ab.Size=UDim2.new(1,0,0,82)
ab.BackgroundColor3=Color3.fromRGB(15,15,24);ab.BorderSizePixel=0
Instance.new("UICorner",ab).CornerRadius=UDim.new(0,7)
local al=Instance.new("TextLabel",ab)
al.Size=UDim2.new(1,-14,1,0);al.Position=UDim2.new(0,7,0,0);al.TextSize=9
al.Font=Enum.Font.Gotham;al.TextColor3=Color3.fromRGB(170,170,205)
al.TextWrapped=true;al.BackgroundTransparency=1;al.TextXAlignment=Enum.TextXAlignment.Left
al.Text="🔪 MM2 HUB — TAM SÜRÜM\n\n✅ Rol ESP · Tracer · Crosshair · Coin ESP · Silah ESP\n✅ Auto Coin · Katil Takip · Silaha Işınlan · Katilden Kaç\n✅ Oto Bıçak/Silah At · Oyuncu Listesi · Takip · Fling\n✅ Uçuş · Noclip · God · Sprint · FOV · Chams · Fullbright"

-- ══════════════════════════════════════════════
-- TOGGLE BUTONU
-- ══════════════════════════════════════════════
local togBtn=Instance.new("TextButton",sg)
togBtn.Size=UDim2.fromOffset(40,40);togBtn.Position=UDim2.new(0,8,0.5,-20)
togBtn.Text="🔪";togBtn.TextSize=18;togBtn.BackgroundColor3=Color3.fromRGB(30,120,255)
togBtn.BorderSizePixel=0
Instance.new("UICorner",togBtn).CornerRadius=UDim.new(1,0)
do local s=Instance.new("UIStroke",togBtn);s.Color=Color3.new(1,1,1);s.Thickness=1 end
togBtn.MouseButton1Click:Connect(function() win.Visible=not win.Visible end)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.RightShift then win.Visible=not win.Visible
    elseif i.KeyCode==Enum.KeyCode.Delete  then win.Visible=false
    elseif i.KeyCode==Enum.KeyCode.Insert  then win.Visible=true end
end)

-- Karakter yenilenince
lp.CharacterAdded:Connect(function(char)
    task.wait(0.8);flyOn=false
    if fC2 then fC2:Disconnect();fC2=nil end
    pcall(function() if fV then fV:Destroy()end end);fV=nil
    pcall(function() if fG then fG:Destroy()end end);fG=nil
    if ncOn then
        if ncC then ncC:Disconnect()end
        ncC=RS.Stepped:Connect(function()
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
        end)
    end
    if espOn then task.wait(1);buildESP() end
end)

Players.PlayerAdded:Connect(function()   task.wait(0.5);refreshList();if espOn then buildESP() end end)
Players.PlayerRemoving:Connect(function() task.wait(0.1);refreshList();if espOn then buildESP() end end)

refreshList()
print("[MM2 HUB TAM] Hazır! RightShift = aç/kapat")
