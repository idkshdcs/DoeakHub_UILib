-- =========================================================
-- DOEAK HUB UI LIBRARY | v5.0
-- Full-featured: Animation, Responsive, Theme, Config, Keybind, ColorPicker
-- =========================================================

local DoeakLib = {}
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local Lighting         = game:GetService("Lighting")

local LP = Players.LocalPlayer

-- =========================================================
-- CONFIG
-- =========================================================
local CONFIG = {
    FolderName = "DoeakHub",
    FileName   = "config.json",
    AutoSave   = true,
}

-- =========================================================
-- THEMES
-- =========================================================
local Themes = {
    Obsidian = {
        MainBG = Color3.fromRGB(22, 24, 28),
        Surface = Color3.fromRGB(16, 17, 21),
        ContentBG = Color3.fromRGB(26, 28, 33),
        ElementBG = Color3.fromRGB(34, 37, 43),
        ElementHi = Color3.fromRGB(46, 50, 58),
        ElementSel = Color3.fromRGB(58, 62, 72),
        Stroke = Color3.fromRGB(52, 56, 64),
        StrokeHi = Color3.fromRGB(80, 86, 96),
        Accent = Color3.fromRGB(200, 205, 215),
        AccentBright = Color3.fromRGB(235, 238, 245),
        AccentDim = Color3.fromRGB(140, 146, 158),
        Green = Color3.fromRGB(105, 200, 145),
        Red = Color3.fromRGB(225, 95, 105),
        Text = Color3.fromRGB(240, 242, 246),
        SubText = Color3.fromRGB(160, 165, 175),
        Muted = Color3.fromRGB(100, 105, 115),
    },
    Midnight = {
        MainBG = Color3.fromRGB(15, 15, 25),
        Surface = Color3.fromRGB(10, 10, 18),
        ContentBG = Color3.fromRGB(18, 18, 30),
        ElementBG = Color3.fromRGB(28, 28, 45),
        ElementHi = Color3.fromRGB(40, 40, 65),
        ElementSel = Color3.fromRGB(55, 55, 85),
        Stroke = Color3.fromRGB(45, 45, 70),
        StrokeHi = Color3.fromRGB(70, 70, 110),
        Accent = Color3.fromRGB(140, 120, 255),
        AccentBright = Color3.fromRGB(180, 165, 255),
        AccentDim = Color3.fromRGB(90, 75, 180),
        Green = Color3.fromRGB(105, 200, 145),
        Red = Color3.fromRGB(225, 95, 105),
        Text = Color3.fromRGB(240, 240, 255),
        SubText = Color3.fromRGB(155, 155, 185),
        Muted = Color3.fromRGB(95, 95, 125),
    },
    Blood = {
        MainBG = Color3.fromRGB(20, 10, 12),
        Surface = Color3.fromRGB(12, 6, 8),
        ContentBG = Color3.fromRGB(25, 12, 15),
        ElementBG = Color3.fromRGB(40, 18, 22),
        ElementHi = Color3.fromRGB(55, 25, 30),
        ElementSel = Color3.fromRGB(75, 30, 38),
        Stroke = Color3.fromRGB(70, 25, 30),
        StrokeHi = Color3.fromRGB(110, 40, 50),
        Accent = Color3.fromRGB(230, 60, 80),
        AccentBright = Color3.fromRGB(255, 100, 120),
        AccentDim = Color3.fromRGB(150, 40, 55),
        Green = Color3.fromRGB(105, 200, 145),
        Red = Color3.fromRGB(225, 95, 105),
        Text = Color3.fromRGB(255, 235, 240),
        SubText = Color3.fromRGB(180, 145, 155),
        Muted = Color3.fromRGB(120, 90, 100),
    },
    Silver = {
        MainBG = Color3.fromRGB(220, 222, 228),
        Surface = Color3.fromRGB(200, 203, 212),
        ContentBG = Color3.fromRGB(210, 213, 222),
        ElementBG = Color3.fromRGB(190, 193, 205),
        ElementHi = Color3.fromRGB(175, 178, 192),
        ElementSel = Color3.fromRGB(160, 163, 180),
        Stroke = Color3.fromRGB(150, 153, 168),
        StrokeHi = Color3.fromRGB(120, 123, 140),
        Accent = Color3.fromRGB(70, 75, 95),
        AccentBright = Color3.fromRGB(40, 45, 65),
        AccentDim = Color3.fromRGB(110, 115, 135),
        Green = Color3.fromRGB(80, 180, 120),
        Red = Color3.fromRGB(210, 70, 80),
        Text = Color3.fromRGB(30, 32, 40),
        SubText = Color3.fromRGB(80, 82, 95),
        Muted = Color3.fromRGB(120, 122, 135),
    },
}

-- Active theme
local ThemeName = "Obsidian"
local Theme = Themes[ThemeName]

-- =========================================================
-- GLOBAL FLAGS + CONFIG
-- =========================================================
local Flags = {}
local ConfigCallbacks = {}

-- Đảm bảo folder tồn tại
local function ensureFolder()
    pcall(function()
        if not isfolder(CONFIG.FolderName) then
            makefolder(CONFIG.FolderName)
        end
    end)
end

local function saveConfig()
    ensureFolder()
    local data = {
        _theme = ThemeName,
        flags = Flags,
    }
    pcall(function()
        writefile(CONFIG.FolderName .. "/" .. CONFIG.FileName, HttpService:JSONEncode(data))
    end)
end

local function loadConfig()
    ensureFolder()
    local ok, raw = pcall(function()
        return readfile(CONFIG.FolderName .. "/" .. CONFIG.FileName)
    end)
    if ok and raw then
        local ok2, data = pcall(function()
            return HttpService:JSONDecode(raw)
        end)
        if ok2 and data then
            if data._theme and Themes[data._theme] then
                ThemeName = data._theme
                Theme = Themes[ThemeName]
            end
            if data.flags then
                for k, v in pairs(data.flags) do
                    Flags[k] = v
                end
            end
        end
    end
end

loadConfig()

local function triggerSave()
    if CONFIG.AutoSave then
        task.defer(saveConfig)
    end
end

-- =========================================================
-- PARENT
-- =========================================================
local function getSafeParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end
    local ok2, cg = pcall(function() return CoreGui end)
    if ok2 and cg then
        local ok3 = pcall(function() local _ = cg.Name end)
        if ok3 then return cg end
    end
    return LP:WaitForChild("PlayerGui")
end
local UIParent = getSafeParent()

-- =========================================================
-- UTILS
-- =========================================================
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = type(r) == "number" and UDim.new(0, r) or r
    c.Parent = p; return c
end
local function round(p) return corner(p, UDim.new(1, 0)) end

local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or Theme.Stroke
    s.Thickness = th or 1
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p; return s
end

local function padding(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft = UDim.new(0, l or 0)
    u.PaddingRight = UDim.new(0, r or 0)
    u.Parent = p; return u
end

local function gradient(p, colors, rot, transparency)
    local g = Instance.new("UIGradient")
    g.Color = colors
    g.Rotation = rot or 0
    if transparency then g.Transparency = transparency end
    g.Parent = p; return g
end

local function tween(o, t, props, style, dir)
    local tw = TweenService:Create(
        o,
        TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    )
    tw:Play()
    return tw
end

local function addShadow(parent, size, radius)
    local s = Instance.new("Frame")
    s.Name = "_Shadow"
    s.Size = UDim2.new(1, size or 12, 1, size or 12)
    s.Position = UDim2.new(0, -(size or 12)/2, 0, -(size or 12)/2)
    s.BackgroundColor3 = Color3.new(0, 0, 0)
    s.BackgroundTransparency = 0.75
    s.BorderSizePixel = 0
    s.ZIndex = -10
    s.Parent = parent
    if radius then corner(s, radius) end
    return s
end

-- Ripple effect cho button
local function createRipple(btn, clickX, clickY)
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Theme.AccentBright
    ripple.BackgroundTransparency = 0.7
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, clickX, 0, clickY)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BorderSizePixel = 0
    ripple.ZIndex = 2
    ripple.Parent = btn
    round(ripple)
    
    local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
    tween(ripple, 0.5, {
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    task.delay(0.5, function()
        pcall(function() ripple:Destroy() end)
    end)
end

-- =========================================================
-- GLASS EFFECT (cho window)
-- =========================================================
local function addGlass(parent)
    local noise = Instance.new("ImageLabel")
    noise.Name = "_Glass"
    noise.Size = UDim2.new(1, 0, 1, 0)
    noise.BackgroundTransparency = 1
    noise.Image = "rbxassetid://9968344105"
    noise.ImageTransparency = 0.92
    noise.ImageColor3 = Color3.new(1, 1, 1)
    noise.ScaleType = Enum.ScaleType.Tile
    noise.TileSize = UDim2.new(0, 200, 0, 200)
    noise.ZIndex = 0
    noise.Parent = parent
    return noise
end

-- =========================================================
-- NOTIFICATION QUEUE
-- =========================================================
local NotifyHolder
local NotifyQueue = {}
local NotifyProcessing = false

local function processNotify()
    if NotifyProcessing then return end
    if #NotifyQueue == 0 then return end
    NotifyProcessing = true
    
    local n = table.remove(NotifyQueue, 1)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 62)
    frame.BackgroundColor3 = Theme.ElementBG
    frame.BorderSizePixel = 0
    frame.Parent = NotifyHolder
    corner(frame, 10)
    local ns = stroke(frame, n.color or Theme.Accent, 1.5, 0.15)
    gradient(frame, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.ElementHi),
        ColorSequenceKeypoint.new(1, Theme.ElementBG),
    }, 45)
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -14)
    accent.Position = UDim2.new(0, 6, 0, 7)
    accent.BackgroundColor3 = n.color or Theme.Accent
    accent.BorderSizePixel = 0
    accent.Parent = frame
    corner(accent, 3)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 16, 0, 8)
    icon.BackgroundTransparency = 1
    icon.Text = n.icon or "●"
    icon.TextColor3 = n.color or Theme.Accent
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 16
    icon.Parent = frame
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -70, 0, 20)
    t.Position = UDim2.new(0, 48, 0, 10)
    t.BackgroundTransparency = 1
    t.Text = n.title or "Notification"
    t.TextColor3 = Theme.Text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = frame
    
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -70, 0, 16)
    d.Position = UDim2.new(0, 48, 0, 32)
    d.BackgroundTransparency = 1
    d.Text = n.content or ""
    d.TextColor3 = Theme.SubText
    d.Font = Enum.Font.Gotham
    d.TextSize = 10
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = frame
    
    frame.Position = UDim2.new(1, 40, 0, 0)
    tween(frame, 0.4, {Position = UDim2.new(0, 0, 0, 0)})
    
    task.delay(n.duration or 3, function()
        tween(frame, 0.35, {
            Position = UDim2.new(1, 40, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        tween(ns, 0.35, {Transparency = 1})
        tween(t, 0.35, {TextTransparency = 1})
        tween(d, 0.35, {TextTransparency = 1})
        tween(accent, 0.35, {BackgroundTransparency = 1})
        task.wait(0.4)
        pcall(function() frame:Destroy() end)
        NotifyProcessing = false
        processNotify()
    end)
end

local function Notify(title, content, color, duration, icon)
    table.insert(NotifyQueue, {
        title = title, content = content,
        color = color or Theme.Accent,
        duration = duration or 3,
        icon = icon,
    })
    processNotify()
end

DoeakLib.Notify = Notify

-- =========================================================
-- WINDOW
-- =========================================================
function DoeakLib:CreateWindow(Config)
    Config = Config or {}
    local Window = {}
    local TitleText = Config.Name or "DOEAK HUB"
    local SubtitleText = Config.Subtitle or "Universal Framework"
    local AuthorText = Config.Author
    
    local baseSize = Config.Size or UDim2.new(0, 640, 0, 440)
    
    -- Cleanup old
    for _, name in ipairs({"DoeakUniversalUI", "DoeakNotifyHolder"}) do
        local old = UIParent:FindFirstChild(name)
        if old then pcall(function() old:Destroy() end) end
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DoeakUniversalUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 100
    pcall(function() ScreenGui.Parent = UIParent end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LP:WaitForChild("PlayerGui")
    end
    
    -- Notify holder
    NotifyHolder = Instance.new("Frame")
    NotifyHolder.Name = "DoeakNotifyHolder"
    NotifyHolder.Size = UDim2.new(0, 340, 1, 0)
    NotifyHolder.Position = UDim2.new(1, -360, 0, 20)
    NotifyHolder.BackgroundTransparency = 1
    NotifyHolder.ZIndex = 999
    NotifyHolder.Parent = ScreenGui
    
    local NotifyLayout = Instance.new("UIListLayout")
    NotifyLayout.Parent = NotifyHolder
    NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    NotifyLayout.Padding = UDim.new(0, 8)
    
    -- ===== FLOATING RESTORE =====
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 52, 0, 52)
    MinBtn.Position = UDim2.new(0, 24, 0.4, 0)
    MinBtn.BackgroundColor3 = Theme.Surface
    MinBtn.Text = "⚡"
    MinBtn.TextSize = 24
    MinBtn.TextColor3 = Theme.AccentBright
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.Visible = false
    MinBtn.Active = true
    MinBtn.Draggable = true
    MinBtn.Parent = ScreenGui
    round(MinBtn)
    stroke(MinBtn, Theme.AccentDim, 2, 0.1)
    gradient(MinBtn, ColorSequence.new(Theme.ElementHi, Theme.Surface), 45)
    
    -- ===== MAIN FRAME =====
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = baseSize
    MainFrame.Position = UDim2.new(0.5, -baseSize.X.Offset/2, 0.5, -baseSize.Y.Offset/2)
    MainFrame.BackgroundColor3 = Theme.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    corner(MainFrame, 14)
    stroke(MainFrame, Theme.StrokeHi, 1.5, 0.4)
    gradient(MainFrame, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.MainBG),
        ColorSequenceKeypoint.new(1, Theme.Surface),
    }, 45)
    addShadow(MainFrame, 12, 18)
    addGlass(MainFrame)
    
    -- Responsive UIScale
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = MainFrame
    
    local function updateScale()
        local viewport = workspace.CurrentCamera.ViewportSize
        local scale = math.min(viewport.X / 1280, viewport.Y / 800)
        scale = math.clamp(scale, 0.55, 1.0)
        uiScale.Scale = scale
    end
    updateScale()
    
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    
    -- ===== HEADER =====
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, -24, 0, 58)
    Header.Position = UDim2.new(0, 12, 0, 12)
    Header.BackgroundColor3 = Theme.Surface
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    corner(Header, 10)
    stroke(Header, Theme.Stroke, 1, 0.5)
    gradient(Header, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.ElementHi),
        ColorSequenceKeypoint.new(0.5, Theme.Surface),
        ColorSequenceKeypoint.new(1, Theme.ElementHi),
    }, 15)
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, -16)
    accentBar.Position = UDim2.new(0, 6, 0, 8)
    accentBar.BackgroundColor3 = Theme.AccentBright
    accentBar.BorderSizePixel = 0
    accentBar.Parent = Header
    corner(accentBar, 4)
    gradient(accentBar, ColorSequence.new(Theme.AccentBright, Theme.AccentDim), 90)
    
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -170, 0, 22)
    TitleLbl.Position = UDim2.new(0, 22, 0, 9)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = TitleText .. "  <font color=\"#EBEEF5\">◆</font>  <font color=\"#A0A5AF\">UNIVERSAL</font>"
    TitleLbl.RichText = true
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextSize = 15
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Header
    
    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size = UDim2.new(1, -170, 0, 14)
    SubLbl.Position = UDim2.new(0, 22, 0, 32)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = SubtitleText .. (AuthorText and ("  •  by " .. AuthorText) or "")
    SubLbl.TextColor3 = Theme.SubText
    SubLbl.TextSize = 10
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left
    SubLbl.Parent = Header
    
    local BtnMin = Instance.new("TextButton")
    BtnMin.Size = UDim2.new(0, 28, 0, 28)
    BtnMin.Position = UDim2.new(1, -70, 0.5, -14)
    BtnMin.BackgroundColor3 = Theme.ElementBG
    BtnMin.Text = "—"
    BtnMin.TextColor3 = Theme.Text
    BtnMin.TextSize = 13
    BtnMin.Font = Enum.Font.GothamBold
    BtnMin.AutoButtonColor = false
    BtnMin.Parent = Header
    corner(BtnMin, 6)
    local minBS = stroke(BtnMin, Theme.Stroke, 1, 0.4)
    
    local BtnClose = Instance.new("TextButton")
    BtnClose.Size = UDim2.new(0, 28, 0, 28)
    BtnClose.Position = UDim2.new(1, -36, 0.5, -14)
    BtnClose.BackgroundColor3 = Theme.ElementBG
    BtnClose.Text = "✕"
    BtnClose.TextColor3 = Theme.Text
    BtnClose.TextSize = 13
    BtnClose.Font = Enum.Font.GothamBold
    BtnClose.AutoButtonColor = false
    BtnClose.Parent = Header
    corner(BtnClose, 6)
    local closeBS = stroke(BtnClose, Theme.Stroke, 1, 0.4)
    
    BtnClose.MouseEnter:Connect(function()
        tween(BtnClose, 0.15, {BackgroundColor3 = Theme.Red})
        tween(closeBS, 0.15, {Color = Theme.Red, Transparency = 0})
    end)
    BtnClose.MouseLeave:Connect(function()
        tween(BtnClose, 0.15, {BackgroundColor3 = Theme.ElementBG})
        tween(closeBS, 0.15, {Color = Theme.Stroke, Transparency = 0.4})
    end)
    BtnMin.MouseEnter:Connect(function()
        tween(BtnMin, 0.15, {BackgroundColor3 = Theme.AccentDim})
    end)
    BtnMin.MouseLeave:Connect(function()
        tween(BtnMin, 0.15, {BackgroundColor3 = Theme.ElementBG})
    end)
    
    -- Close animation
    BtnClose.MouseButton1Click:Connect(function()
        tween(MainFrame, 0.25, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.28)
        ScreenGui:Destroy()
    end)
    
    BtnMin.MouseButton1Click:Connect(function()
        -- Fade out rồi hide
        tween(MainFrame, 0.2, {BackgroundTransparency = 1})
        MainFrame.Visible = false
        MinBtn.Visible = true
    end)
    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MainFrame.BackgroundTransparency = 0
        tween(MainFrame, 0.2, {BackgroundTransparency = 0})
        MinBtn.Visible = false
    end)
    
    -- Open animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    tween(MainFrame, 0.45, {
        Size = baseSize,
        Position = UDim2.new(0.5, -baseSize.X.Offset/2, 0.5, -baseSize.Y.Offset/2)
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- ===== SIDEBAR =====
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 172, 1, -94)
    Sidebar.Position = UDim2.new(0, 12, 0, 82)
    Sidebar.BackgroundColor3 = Theme.Surface
    Sidebar.BorderSizePixel = 0
    Sidebar.ClipsDescendants = true
    Sidebar.ScrollingEnabled = true
    Sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
    Sidebar.ScrollBarThickness = 4
    Sidebar.ScrollBarImageColor3 = Theme.AccentDim
    Sidebar.ScrollBarImageTransparency = 0.4
    Sidebar.ElasticBehavior = Enum.ElasticBehavior.Never
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = MainFrame
    corner(Sidebar, 10)
    stroke(Sidebar, Theme.Stroke, 1, 0.5)
    
    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Parent = Sidebar
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Padding = UDim.new(0, 5)
    padding(Sidebar, 8, 8, 8, 16)
    
    local function updateSidebarCanvas()
        local h = SideLayout.AbsoluteContentSize.Y
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, h + 24)
    end
    SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSidebarCanvas)
    task.defer(updateSidebarCanvas)
    
    -- ===== CONTENT =====
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -208, 1, -94)
    Content.Position = UDim2.new(0, 196, 0, 82)
    Content.BackgroundColor3 = Theme.ContentBG
    Content.BorderSizePixel = 0
    Content.ClipsDescendants = true
    Content.Parent = MainFrame
    corner(Content, 10)
    stroke(Content, Theme.Stroke, 1, 0.5)
    padding(Content, 10, 10, 10, 10)
    
    -- ===== TAB SYSTEM =====
    local TabsList = {}
    local FirstTab = true
    
    function Window:CreateTab(TabName, TabIcon)
        local Tab = {}
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundColor3 = Theme.ElementBG
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = "  " .. (TabIcon or "◈") .. "   " .. TabName
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.TextTruncate = Enum.TextTruncate.AtEnd
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = Sidebar
        corner(TabBtn, 8)
        local btnStroke = stroke(TabBtn, Theme.Stroke, 1, 0.5)
        
        local Accent = Instance.new("Frame")
        Accent.Size = UDim2.new(0, 3, 0, 0)
        Accent.Position = UDim2.new(0, 0, 0.5, 0)
        Accent.AnchorPoint = Vector2.new(0, 0.5)
        Accent.BackgroundColor3 = Theme.AccentBright
        Accent.BorderSizePixel = 0
        Accent.Parent = TabBtn
        corner(Accent, 3)
        gradient(Accent, ColorSequence.new(Theme.AccentBright, Theme.AccentDim), 90)
        
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ClipsDescendants = true
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Theme.AccentDim
        TabPage.ScrollBarImageTransparency = 0.3
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.ScrollingDirection = Enum.ScrollingDirection.Y
        TabPage.ElasticBehavior = Enum.ElasticBehavior.Never
        TabPage.Visible = false
        TabPage.Parent = Content
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = TabPage
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        padding(TabPage, 4, 16, 4, 8)
        
        table.insert(TabsList, {Btn = TabBtn, Page = TabPage, Accent = Accent, Stroke = btnStroke})
        task.defer(updateSidebarCanvas)
        
        if FirstTab then
            TabPage.Visible = true
            TabPage.BackgroundTransparency = 1
            TabBtn.BackgroundColor3 = Theme.ElementHi
            TabBtn.TextColor3 = Theme.AccentBright
            Accent.Size = UDim2.new(0, 3, 0, 22)
            tween(btnStroke, 0.2, {Color = Theme.AccentDim, Transparency = 0.2})
            FirstTab = false
        end
        
        TabBtn.MouseEnter:Connect(function()
            if not TabPage.Visible then
                tween(TabBtn, 0.15, {BackgroundColor3 = Theme.ElementHi})
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not TabPage.Visible then
                tween(TabBtn, 0.15, {BackgroundColor3 = Theme.ElementBG})
            end
        end)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(TabsList) do
                local active = (t.Page == TabPage)
                if active and not t.Page.Visible then
                    t.Page.Visible = true
                    t.Page.BackgroundTransparency = 1
                    tween(t.Page, 0.2, {BackgroundTransparency = 1})
                elseif not active and t.Page.Visible then
                    t.Page.Visible = false
                end
                tween(t.Btn, 0.22, {
                    BackgroundColor3 = active and Theme.ElementHi or Theme.ElementBG,
                    TextColor3 = active and Theme.AccentBright or Theme.SubText,
                })
                tween(t.Accent, 0.22, {
                    Size = active and UDim2.new(0, 3, 0, 22) or UDim2.new(0, 3, 0, 0)
                })
                tween(t.Stroke, 0.22, {
                    Color = active and Theme.AccentDim or Theme.Stroke,
                    Transparency = active and 0.2 or 0.5,
                })
            end
        end)
        
        -- ============ SECTION ============
        function Tab:CreateSection(Text)
            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, -8, 0, 32)
            sec.BackgroundTransparency = 1
            sec.Parent = TabPage
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0.5, 0)
            line.BackgroundColor3 = Theme.Stroke
            line.BorderSizePixel = 0
            line.Parent = sec
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0, 200, 1, 0)
            lbl.Position = UDim2.new(0, 4, 0, 0)
            lbl.BackgroundColor3 = Theme.ContentBG
            lbl.Text = "  " .. Text
            lbl.TextColor3 = Theme.AccentBright
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = sec
            return sec
        end
        
        -- ============ LABEL ============
        function Tab:CreateLabel(Text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -8, 0, 24)
            lbl.BackgroundTransparency = 1
            lbl.Text = Text
            lbl.TextColor3 = Theme.SubText
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = TabPage
            return lbl
        end
        
        -- ============ PARAGRAPH ============
        function Tab:CreateParagraph(Config)
            Config = Config or {}
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 70)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.Parent = TabPage
            corner(frame, 8)
            stroke(frame, Theme.Stroke, 1, 0.4)
            
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -20, 0, 18)
            t.Position = UDim2.new(0, 12, 0, 8)
            t.BackgroundTransparency = 1
            t.Text = Config.Title or "Paragraph"
            t.TextColor3 = Theme.Text
            t.Font = Enum.Font.GothamBold
            t.TextSize = 12
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.Parent = frame
            
            local c = Instance.new("TextLabel")
            c.Size = UDim2.new(1, -20, 0, 40)
            c.Position = UDim2.new(0, 12, 0, 26)
            c.BackgroundTransparency = 1
            c.Text = Config.Content or ""
            c.TextColor3 = Theme.SubText
            c.Font = Enum.Font.Gotham
            c.TextSize = 10
            c.TextWrapped = true
            c.TextXAlignment = Enum.TextXAlignment.Left
            c.TextYAlignment = Enum.TextYAlignment.Top
            c.Parent = frame
            return frame
        end
        
        -- ============ BUTTON ============
        function Tab:CreateButton(Config)
            Config = Config or {}
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 42)
            btn.BackgroundColor3 = Theme.ElementBG
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ClipsDescendants = true
            btn.Parent = TabPage
            corner(btn, 8)
            local btnStroke = stroke(btn, Theme.Stroke, 1, 0.4)
            gradient(btn, ColorSequence.new(Theme.ElementHi, Theme.ElementBG), 90)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -50, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = Config.Name or "Button"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.ZIndex = 3
            lbl.Parent = btn
            
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 30, 1, 0)
            arrow.Position = UDim2.new(1, -36, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "›"
            arrow.TextColor3 = Theme.AccentBright
            arrow.TextSize = 18
            arrow.Font = Enum.Font.GothamBold
            arrow.ZIndex = 3
            arrow.Parent = btn
            
            btn.MouseEnter:Connect(function()
                tween(btn, 0.15, {BackgroundColor3 = Theme.ElementHi})
                tween(btnStroke, 0.15, {Color = Theme.AccentDim, Transparency = 0.2})
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, 0.15, {BackgroundColor3 = Theme.ElementBG})
                tween(btnStroke, 0.15, {Color = Theme.Stroke, Transparency = 0.4})
            end)
            
            btn.MouseButton1Click:Connect(function()
                local mouse = UserInputService:GetMouseLocation()
                local relX = mouse.X - btn.AbsolutePosition.X
                local relY = mouse.Y - btn.AbsolutePosition.Y
                createRipple(btn, relX, relY)
                pcall(function() if Config.Callback then Config.Callback() end end)
            end)
            return btn
        end
        
        -- ============ TOGGLE ============
        function Tab:CreateToggle(Config)
            Config = Config or {}
            local flag = Config.Flag
            local state = Config.CurrentValue or false
            if flag and Flags[flag] ~= nil then state = Flags[flag] end
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 48)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -80, 0, 18)
            lbl.Position = UDim2.new(0, 14, 0, 8)
            lbl.BackgroundTransparency = 1
            lbl.Text = Config.Name or "Toggle"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = frame
            
            if Config.Description then
                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -80, 0, 14)
                desc.Position = UDim2.new(0, 14, 0, 26)
                desc.BackgroundTransparency = 1
                desc.Text = Config.Description
                desc.TextColor3 = Theme.Muted
                desc.Font = Enum.Font.Gotham
                desc.TextSize = 9
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.TextTruncate = Enum.TextTruncate.AtEnd
                desc.Parent = frame
            end
            
            local switch = Instance.new("TextButton")
            switch.Size = UDim2.new(0, 44, 0, 22)
            switch.Position = UDim2.new(1, -56, 0.5, -11)
            switch.BackgroundColor3 = state and Theme.Green or Theme.ElementHi
            switch.Text = ""
            switch.AutoButtonColor = false
            switch.Parent = frame
            round(switch)
            local swStroke = stroke(switch, state and Theme.Green or Theme.Stroke, 1, 0.3)
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 18, 0, 18)
            knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            knob.BackgroundColor3 = Color3.fromRGB(245, 248, 252)
            knob.BorderSizePixel = 0
            knob.Parent = switch
            round(knob)
            stroke(knob, Color3.fromRGB(200, 205, 215), 1, 0.6)
            
            frame.MouseEnter:Connect(function()
                tween(frame, 0.15, {BackgroundColor3 = Theme.ElementHi})
                tween(fStroke, 0.15, {Color = Theme.StrokeHi})
            end)
            frame.MouseLeave:Connect(function()
                tween(frame, 0.15, {BackgroundColor3 = Theme.ElementBG})
                tween(fStroke, 0.15, {Color = Theme.Stroke})
            end)
            
            local function setState(v, skipCallback)
                state = v
                if flag then Flags[flag] = v end
                tween(knob, 0.22, {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
                tween(switch, 0.22, {BackgroundColor3 = state and Theme.Green or Theme.ElementHi})
                tween(swStroke, 0.22, {Color = state and Theme.Green or Theme.Stroke})
                if not skipCallback then
                    pcall(function() if Config.Callback then Config.Callback(state) end end)
                end
                triggerSave()
            end
            
            switch.MouseButton1Click:Connect(function()
                setState(not state)
            end)
            
            -- Restore state nếu có config
            if flag and Flags[flag] ~= nil and Flags[flag] ~= state then
                task.defer(function() setState(Flags[flag], false) end)
            end
            
            return {
                Value = state,
                Set = function(self, v) setState(v) end,
                Flag = flag,
            }
        end
        
        -- ============ SLIDER ============
        function Tab:CreateSlider(Config)
            Config = Config or {}
            local min, max = Config.Range[1] or 0, Config.Range[2] or 100
            local default = Config.CurrentValue or min
            local suffix = Config.Suffix or ""
            local inc = Config.Increment
            local flag = Config.Flag
            if flag and Flags[flag] ~= nil then default = Flags[flag] end
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 60)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 20)
            lbl.Position = UDim2.new(0, 14, 0, 6)
            lbl.BackgroundTransparency = 1
            lbl.Text = (Config.Name or "Slider") .. ": <font color=\"#EBEEF5\">" .. tostring(default) .. suffix .. "</font>"
            lbl.RichText = true
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local trackBtn = Instance.new("TextButton")
            trackBtn.Size = UDim2.new(1, -28, 0, 8)
            trackBtn.Position = UDim2.new(0, 14, 0, 38)
            trackBtn.BackgroundColor3 = Theme.Surface
            trackBtn.Text = ""
            trackBtn.AutoButtonColor = false
            trackBtn.Parent = frame
            round(trackBtn)
            stroke(trackBtn, Theme.Stroke, 1, 0.3)
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = trackBtn
            round(fill)
            gradient(fill, ColorSequence.new{
                ColorSequenceKeypoint.new(0, Theme.AccentDim),
                ColorSequenceKeypoint.new(0.5, Theme.Accent),
                ColorSequenceKeypoint.new(1, Theme.AccentBright),
            }, 0)
            
            local head = Instance.new("Frame")
            head.Size = UDim2.new(0, 16, 0, 16)
            head.Position = UDim2.new(1, -8, 0.5, -8)
            head.BackgroundColor3 = Color3.fromRGB(248, 250, 253)
            head.BorderSizePixel = 0
            head.Parent = fill
            round(head)
            stroke(head, Theme.AccentBright, 2, 0)
            
            local sliderData = {
                track = trackBtn, fill = fill, head = head, label = lbl,
                name = Config.Name or "Slider", min = min, max = max,
                inc = inc, suffix = suffix, flag = flag,
                callback = Config.Callback,
            }
            
            trackBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    _G._activeSlider = sliderData
                    -- update ngay
                    local mx = UserInputService:GetMouseLocation().X
                    local tx = trackBtn.AbsolutePosition.X
                    local tw = trackBtn.AbsoluteSize.X
                    if tw > 0 then
                        local pct = math.clamp((mx - tx) / tw, 0, 1)
                        local raw = min + (max - min) * pct
                        local value
                        if inc and inc < 1 then
                            value = tonumber(string.format("%.2f", math.floor(raw / inc + 0.5) * inc))
                        elseif inc then
                            value = math.floor(raw / inc + 0.5) * inc
                        else
                            value = math.floor(raw)
                        end
                        fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                        lbl.Text = (Config.Name or "Slider") .. ": <font color=\"#EBEEF5\">" .. tostring(value) .. suffix .. "</font>"
                        if flag then Flags[flag] = value end
                        pcall(function() if Config.Callback then Config.Callback(value) end end)
                        triggerSave()
                    end
                end
            end)
            
            trackBtn.MouseEnter:Connect(function()
                tween(head, 0.15, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -9, 0.5, -9)})
            end)
            trackBtn.MouseLeave:Connect(function()
                tween(head, 0.15, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)})
            end)
            
            return {
                Set = function(self, v)
                    local pct = math.clamp((v - min) / (max - min), 0, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    lbl.Text = (Config.Name or "Slider") .. ": <font color=\"#EBEEF5\">" .. tostring(v) .. suffix .. "</font>"
                    if flag then Flags[flag] = v end
                    triggerSave()
                end,
                Value = default,
                Flag = flag,
            }
        end
        
        -- ============ DROPDOWN ============
        function Tab:CreateDropdown(Config)
            Config = Config or {}
            local Options = Config.Options or {}
            local current = Config.Default or (Options[1] or "None")
            local flag = Config.Flag
            if flag and Flags[flag] ~= nil then current = Flags[flag] end
            local isOpen = false
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 44)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)
            
            local mainBtn = Instance.new("TextButton")
            mainBtn.Size = UDim2.new(1, 0, 0, 44)
            mainBtn.BackgroundTransparency = 1
            mainBtn.Text = ""
            mainBtn.AutoButtonColor = false
            mainBtn.Parent = frame
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -50, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.RichText = true
            lbl.Text = (Config.Name or "Dropdown") .. ": <font color=\"#EBEEF5\">" .. current .. "</font>"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextTruncate = Enum.TextTruncate.AtEnd
            lbl.Parent = mainBtn
            
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 30, 1, 0)
            arrow.Position = UDim2.new(1, -36, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = Theme.AccentBright
            arrow.TextSize = 11
            arrow.Font = Enum.Font.GothamBold
            arrow.Parent = mainBtn
            
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, -12, 0, 0)
            scroll.Position = UDim2.new(0, 6, 0, 44)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.ScrollBarThickness = 3
            scroll.ScrollBarImageColor3 = Theme.AccentDim
            scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.Parent = frame
            local sLayout = Instance.new("UIListLayout")
            sLayout.Parent = scroll
            sLayout.Padding = UDim.new(0, 3)
            
            local function setOpen(open)
                isOpen = open
                local h = open and math.clamp(44 + #Options * 32 + 10, 44, 200) or 44
                tween(frame, 0.25, {Size = UDim2.new(1, -8, 0, h)})
                arrow.Text = open and "▲" or "▼"
            end
            
            mainBtn.MouseButton1Click:Connect(function()
                setOpen(not isOpen)
            end)
            
            local function makeOption(opt)
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.BackgroundColor3 = Theme.Surface
                optBtn.Text = "  " .. tostring(opt)
                optBtn.TextColor3 = Theme.SubText
                optBtn.Font = Enum.Font.GothamMedium
                optBtn.TextSize = 11
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.AutoButtonColor = false
                optBtn.Parent = scroll
                corner(optBtn, 6)
                
                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, 0.15, {BackgroundColor3 = Theme.ElementHi, TextColor3 = Theme.AccentBright})
                end)
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, 0.15, {BackgroundColor3 = Theme.Surface, TextColor3 = Theme.SubText})
                end)
                optBtn.MouseButton1Click:Connect(function()
                    current = opt
                    lbl.Text = (Config.Name or "Dropdown") .. ": <font color=\"#EBEEF5\">" .. opt .. "</font>"
                    if flag then Flags[flag] = opt end
                    setOpen(false)
                    pcall(function() if Config.Callback then Config.Callback(opt) end end)
                    triggerSave()
                end)
            end
            
            for _, opt in ipairs(Options) do makeOption(opt) end
            
            return {
                Value = current,
                Flag = flag,
                Refresh = function(self, newOptions)
                    Options = newOptions
                    for _, c in ipairs(scroll:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(Options) do makeOption(opt) end
                end,
                Set = function(self, val)
                    current = val
                    lbl.Text = (Config.Name or "Dropdown") .. ": <font color=\"#EBEEF5\">" .. val .. "</font>"
                    if flag then Flags[flag] = val end
                    triggerSave()
                end,
            }
        end
        
        -- ============ TEXTBOX ============
        function Tab:CreateTextbox(Config)
            Config = Config or {}
            local flag = Config.Flag
            local default = Config.Default or ""
            if flag and Flags[flag] ~= nil then default = Flags[flag] end
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 46)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)
            
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -20, 1, -12)
            box.Position = UDim2.new(0, 10, 0, 6)
            box.BackgroundTransparency = 1
            box.Text = default
            box.PlaceholderText = Config.Placeholder or "Nhập..."
            box.PlaceholderColor3 = Theme.Muted
            box.TextColor3 = Theme.Text
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.ClearTextOnFocus = false
            box.Parent = frame
            
            box.Focused:Connect(function()
                tween(fStroke, 0.2, {Color = Theme.AccentBright, Transparency = 0.1})
            end)
            box.FocusLost:Connect(function()
                tween(fStroke, 0.2, {Color = Theme.Stroke, Transparency = 0.4})
                if flag then Flags[flag] = box.Text end
                pcall(function() if Config.Callback then Config.Callback(box.Text) end end)
                triggerSave()
            end)
            
            return {
                Value = default,
                Flag = flag,
                Set = function(self, text)
                    box.Text = text
                    if flag then Flags[flag] = text end
                    triggerSave()
                end,
                Box = box,
            }
        end
        
        -- ============ KEYBIND (default Ctrl) ============
        function Tab:CreateKeybind(Config)
            Config = Config or {}
            local flag = Config.Flag
            local default = Config.Default or Enum.KeyCode.LeftControl
            local current = default
            if flag and Flags[flag] ~= nil then
                local ok, kc = pcall(function() return Enum.KeyCode[Flags[flag]] end)
                if ok and kc then current = kc end
            end
            local listening = false
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 46)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -100, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = Config.Name or "Keybind"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(0, 88, 0, 28)
            keyBtn.Position = UDim2.new(1, -100, 0.5, -14)
            keyBtn.BackgroundColor3 = Theme.Surface
            keyBtn.Text = current.Name
            keyBtn.TextColor3 = Theme.AccentBright
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.TextSize = 11
            keyBtn.AutoButtonColor = false
            keyBtn.Parent = frame
            corner(keyBtn, 6)
            stroke(keyBtn, Theme.Stroke, 1, 0.3)
            
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "Nhấn phím..."
                keyBtn.TextColor3 = Theme.Gold or Theme.AccentBright
            end)
            
            UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        current = input.KeyCode
                        keyBtn.Text = current.Name
                        keyBtn.TextColor3 = Theme.AccentBright
                        listening = false
                        if flag then Flags[flag] = current.Name end
                        pcall(function() if Config.Callback then Config.Callback(current) end end)
                        triggerSave()
                    end
                    return
                end
                -- Trigger callback
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == current then
                    pcall(function() if Config.OnPressed then Config.OnPressed() end end)
                end
            end)
            
            return {
                Value = current,
                Flag = flag,
                Set = function(self, kc)
                    if typeof(kc) == "EnumItem" then
                        current = kc
                    elseif type(kc) == "string" then
                        local ok, e = pcall(function() return Enum.KeyCode[kc] end)
                        if ok then current = e end
                    end
                    keyBtn.Text = current.Name
                    if flag then Flags[flag] = current.Name end
                    triggerSave()
                end,
            }
        end
        
        -- ============ COLORPICKER (gray palette) ============
        function Tab:CreateColorPicker(Config)
            Config = Config or {}
            local flag = Config.Flag
            local default = Config.Default or Color3.fromRGB(180, 185, 195)
            if flag and Flags[flag] then
                local c = Flags[flag]
                if type(c) == "table" and c.r then
                    default = Color3.new(c.r, c.g, c.b)
                end
            end
            
            -- Gray palette - các sắc thái xám đẹp
            local GrayPalette = {
                Color3.fromRGB(245, 245, 250), -- white
                Color3.fromRGB(220, 222, 228), -- light
                Color3.fromRGB(200, 205, 215), -- silver
                Color3.fromRGB(180, 185, 195), -- platinum
                Color3.fromRGB(160, 165, 175), -- gray
                Color3.fromRGB(140, 146, 158), -- middle
                Color3.fromRGB(120, 125, 135), -- graphite
                Color3.fromRGB(100, 105, 115), -- dark gray
                Color3.fromRGB(80, 85, 95),    -- charcoal
                Color3.fromRGB(60, 65, 75),    -- dark charcoal
                Color3.fromRGB(40, 45, 55),    -- obsidian
                Color3.fromRGB(25, 28, 35),    -- near black
                Color3.fromRGB(15, 15, 20),    -- black
            }
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 56)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)
            
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -90, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = Config.Name or "Color"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame
            
            local preview = Instance.new("TextButton")
            preview.Size = UDim2.new(0, 52, 0, 32)
            preview.Position = UDim2.new(1, -64, 0.5, -16)
            preview.BackgroundColor3 = default
            preview.Text = ""
            preview.AutoButtonColor = false
            preview.Parent = frame
            corner(preview, 6)
            stroke(preview, Theme.StrokeHi, 1.5, 0)
            
            -- Popup picker
            local popup = Instance.new("Frame")
            popup.Size = UDim2.new(0, 220, 0, 220)
            popup.BackgroundColor3 = Theme.Surface
            popup.BorderSizePixel = 0
            popup.Visible = false
            popup.ZIndex = 10
            popup.Parent = ScreenGui
            corner(popup, 10)
            stroke(popup, Theme.StrokeHi, 1.5, 0.3)
            addShadow(popup, 10, 14)
            
            local popTitle = Instance.new("TextLabel")
            popTitle.Size = UDim2.new(1, -20, 0, 22)
            popTitle.Position = UDim2.new(0, 10, 0, 8)
            popTitle.BackgroundTransparency = 1
            popTitle.Text = Config.Name or "Chọn màu"
            popTitle.TextColor3 = Theme.Text
            popTitle.Font = Enum.Font.GothamBold
            popTitle.TextSize = 12
            popTitle.TextXAlignment = Enum.TextXAlignment.Left
            popTitle.Parent = popup
            
            -- Gray palette swatches
            local swatchGrid = Instance.new("Frame")
            swatchGrid.Size = UDim2.new(1, -20, 0, 100)
            swatchGrid.Position = UDim2.new(0, 10, 0, 36)
            swatchGrid.BackgroundTransparency = 1
            swatchGrid.Parent = popup
            
            local gridLayout = Instance.new("UIGridLayout")
            gridLayout.Parent = swatchGrid
            gridLayout.CellSize = UDim2.new(0, 28, 0, 28)
            gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
            
            local currentColor = default
            
            local function applyColor(c)
                currentColor = c
                preview.BackgroundColor3 = c
                if flag then
                    Flags[flag] = {r = c.R, g = c.G, b = c.B}
                end
                pcall(function() if Config.Callback then Config.Callback(c) end end)
                triggerSave()
            end
            
            for _, color in ipairs(GrayPalette) do
                local sw = Instance.new("TextButton")
                sw.BackgroundColor3 = color
                sw.Text = ""
                sw.AutoButtonColor = false
                sw.Parent = swatchGrid
                corner(sw, 6)
                local swStroke = stroke(sw, Theme.StrokeHi, 1, 0.5)
                
                sw.MouseEnter:Connect(function()
                    tween(swStroke, 0.15, {Color = Theme.AccentBright, Transparency = 0})
                end)
                sw.MouseLeave:Connect(function()
                    tween(swStroke, 0.15, {Color = Theme.StrokeHi, Transparency = 0.5})
                end)
                sw.MouseButton1Click:Connect(function()
                    applyColor(color)
                    popup.Visible = false
                end)
            end
            
            -- Custom RGB sliders
            local rgbFrame = Instance.new("Frame")
            rgbFrame.Size = UDim2.new(1, -20, 0, 60)
            rgbFrame.Position = UDim2.new(0, 10, 0, 144)
            rgbFrame.BackgroundTransparency = 1
            rgbFrame.Parent = popup
            
            local function makeRGBSlider(y, label, colorCh)
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0, 20, 0, 18)
                lbl.Position = UDim2.new(0, 0, 0, y)
                lbl.BackgroundTransparency = 1
                lbl.Text = label
                lbl.TextColor3 = Theme.SubText
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 11
                lbl.Parent = rgbFrame
                
                local bar = Instance.new("TextButton")
                bar.Size = UDim2.new(1, -30, 0, 12)
                bar.Position = UDim2.new(0, 26, 0, y + 3)
                bar.BackgroundColor3 = Theme.ElementBG
                bar.Text = ""
                bar.AutoButtonColor = false
                bar.Parent = rgbFrame
                corner(bar, 6)
                
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = Theme.Accent
                fill.BorderSizePixel = 0
                fill.Parent = bar
                corner(fill, 6)
                
                return bar, fill
            end
            
            local rBar = makeRGBSlider(0, "R", "r")
            local gBar = makeRGBSlider(20, "G", "g")
            local bBar = makeRGBSlider(40, "B", "b")
            
            preview.MouseButton1Click:Connect(function()
                popup.Visible = not popup.Visible
                local pos = preview.AbsolutePosition
                popup.Position = UDim2.new(0, pos.X - 160, 0, pos.Y + 40)
            end)
            
            return {
                Value = default,
                Flag = flag,
                Set = function(self, c)
                    applyColor(c)
                end,
            }
        end
        
        -- ============ DIVIDER ============
        function Tab:CreateDivider()
            local d = Instance.new("Frame")
            d.Size = UDim2.new(1, -8, 0, 1)
            d.BackgroundColor3 = Theme.Stroke
            d.BorderSizePixel = 0
            d.Parent = TabPage
            return d
        end
        
        return Tab
    end
    
    -- ===== WINDOW METHODS =====
    function Window:SetTheme(themeName)
        if not Themes[themeName] then return end
        ThemeName = themeName
        Theme = Themes[themeName]
        triggerSave()
        Notify("Theme", "Đã đổi theme: " .. themeName, Theme.Accent, 2, "🎨")
    end
    
    function Window:SaveConfig()
        saveConfig()
        Notify("Config", "Đã lưu config", Theme.Green, 2, "💾")
    end
    
    function Window:LoadConfig()
        loadConfig()
        Notify("Config", "Đã load config", Theme.Green, 2, "📂")
    end
    
    function Window:GetFlags()
        return Flags
    end
    
    function Window:Notify(title, content, color, duration)
        Notify(title, content, color, duration)
    end
    
    return Window
end

-- =========================================================
-- SLIDER GLOBAL INPUT (dùng chung cho mọi slider)
-- =========================================================
UserInputService.InputChanged:Connect(function(input)
    local s = _G._activeSlider
    if not s then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local mx = UserInputService:GetMouseLocation().X
        local tx = s.track.AbsolutePosition.X
        local tw = s.track.AbsoluteSize.X
        if tw <= 0 then return end
        local pct = math.clamp((mx - tx) / tw, 0, 1)
        local raw = s.min + (s.max - s.min) * pct
        local value
        if s.inc and s.inc < 1 then
            value = tonumber(string.format("%.2f", math.floor(raw / s.inc + 0.5) * s.inc))
        elseif s.inc then
            value = math.floor(raw / s.inc + 0.5) * s.inc
        else
            value = math.floor(raw)
        end
        s.fill.Size = UDim2.new((value - s.min) / (s.max - s.min), 0, 1, 0)
        s.label.Text = s.name .. ": <font color=\"#EBEEF5\">" .. tostring(value) .. (s.suffix or "") .. "</font>"
        if s.flag then Flags[s.flag] = value end
        pcall(function() if s.callback then s.callback(value) end end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if _G._activeSlider then
            triggerSave()
            _G._activeSlider = nil
        end
    end
end)

return DoeakLib
