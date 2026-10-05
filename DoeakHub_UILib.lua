--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║           DOEAKHUB UI LIBRARY v4.1 — FIXED                  ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════════
--  THEMES
-- ════════════════════════════════════════════════════════════════
local Themes = {
    Dark = {
        Background = Color3.fromRGB(22, 24, 30),
        Surface = Color3.fromRGB(30, 32, 40),
        SurfaceAlt = Color3.fromRGB(38, 40, 48),
        Border = Color3.fromRGB(52, 54, 64),
        Text = Color3.fromRGB(235, 237, 242),
        TextDim = Color3.fromRGB(140, 145, 160),
        Accent = Color3.fromRGB(110, 145, 235),
        AccentDark = Color3.fromRGB(80, 110, 200),
        Success = Color3.fromRGB(120, 195, 140),
        Warning = Color3.fromRGB(225, 180, 110),
        Danger = Color3.fromRGB(220, 115, 125),
        Shadow = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(26, 28, 36),
    },
    Gray = {
        Background = Color3.fromRGB(32, 32, 36),
        Surface = Color3.fromRGB(44, 44, 50),
        SurfaceAlt = Color3.fromRGB(56, 56, 62),
        Border = Color3.fromRGB(78, 78, 88),
        Text = Color3.fromRGB(240, 240, 245),
        TextDim = Color3.fromRGB(155, 155, 168),
        Accent = Color3.fromRGB(155, 160, 180),
        AccentDark = Color3.fromRGB(115, 120, 140),
        Success = Color3.fromRGB(140, 195, 155),
        Warning = Color3.fromRGB(220, 185, 125),
        Danger = Color3.fromRGB(220, 125, 135),
        Shadow = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(26, 26, 30),
    },
    Midnight = {
        Background = Color3.fromRGB(14, 16, 24),
        Surface = Color3.fromRGB(20, 24, 36),
        SurfaceAlt = Color3.fromRGB(28, 32, 48),
        Border = Color3.fromRGB(44, 52, 74),
        Text = Color3.fromRGB(225, 230, 245),
        TextDim = Color3.fromRGB(125, 135, 165),
        Accent = Color3.fromRGB(140, 115, 245),
        AccentDark = Color3.fromRGB(100, 80, 195),
        Success = Color3.fromRGB(105, 215, 155),
        Warning = Color3.fromRGB(235, 195, 105),
        Danger = Color3.fromRGB(235, 105, 125),
        Shadow = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(18, 20, 30),
    },
    Neon = {
        Background = Color3.fromRGB(10, 12, 18),
        Surface = Color3.fromRGB(16, 18, 26),
        SurfaceAlt = Color3.fromRGB(22, 24, 34),
        Border = Color3.fromRGB(44, 190, 205),
        Text = Color3.fromRGB(232, 250, 252),
        TextDim = Color3.fromRGB(125, 175, 190),
        Accent = Color3.fromRGB(60, 215, 195),
        AccentDark = Color3.fromRGB(30, 155, 140),
        Success = Color3.fromRGB(110, 245, 175),
        Warning = Color3.fromRGB(250, 220, 110),
        Danger = Color3.fromRGB(250, 115, 165),
        Shadow = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(12, 14, 22),
    },
    Blood = {
        Background = Color3.fromRGB(20, 12, 14),
        Surface = Color3.fromRGB(28, 16, 20),
        SurfaceAlt = Color3.fromRGB(38, 22, 28),
        Border = Color3.fromRGB(74, 34, 44),
        Text = Color3.fromRGB(240, 225, 228),
        TextDim = Color3.fromRGB(160, 125, 135),
        Accent = Color3.fromRGB(215, 65, 85),
        AccentDark = Color3.fromRGB(160, 40, 60),
        Success = Color3.fromRGB(125, 215, 145),
        Warning = Color3.fromRGB(240, 185, 90),
        Danger = Color3.fromRGB(250, 90, 110),
        Shadow = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(24, 14, 18),
    },
    Light = {
        Background = Color3.fromRGB(248, 249, 252),
        Surface = Color3.fromRGB(255, 255, 255),
        SurfaceAlt = Color3.fromRGB(240, 242, 248),
        Border = Color3.fromRGB(218, 222, 232),
        Text = Color3.fromRGB(32, 36, 48),
        TextDim = Color3.fromRGB(118, 124, 140),
        Accent = Color3.fromRGB(90, 125, 235),
        AccentDark = Color3.fromRGB(60, 95, 205),
        Success = Color3.fromRGB(70, 175, 115),
        Warning = Color3.fromRGB(215, 165, 70),
        Danger = Color3.fromRGB(215, 90, 105),
        Shadow = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(240, 242, 248),
    },
}

local CurrentTheme = "Dark"

-- ════════════════════════════════════════════════════════════════
--  UTILITIES
-- ════════════════════════════════════════════════════════════════
local function create(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        pcall(function() obj[k] = v end)
    end
    obj.Parent = parent
    return obj
end

local function safeColor(c, fallback)
    if typeof(c) == "Color3" then return c end
    if type(c) == "string" then
        local lower = c:lower()
        if lower == "red" then return Color3.fromRGB(220, 115, 125) end
        if lower == "green" then return Color3.fromRGB(120, 195, 140) end
        if lower == "blue" then return Color3.fromRGB(110, 145, 235) end
        if lower == "yellow" then return Color3.fromRGB(225, 180, 110) end
        if lower == "purple" then return Color3.fromRGB(175, 110, 215) end
        if lower == "cyan" then return Color3.fromRGB(100, 210, 215) end
    end
    return fallback or Themes[CurrentTheme].Accent
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function pillCorner(parent)
    return create("UICorner", {CornerRadius = UDim.new(1, 0)}, parent)
end

local function stroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color, Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function padding(parent, top, right, bottom, left)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0), PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0), PaddingLeft = UDim.new(0, left or 0),
    }, parent)
end

local function listLayout(parent, pad, sortOrder)
    return create("UIListLayout", {
        Padding = UDim.new(0, pad or 4),
        SortOrder = sortOrder or Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
    }, parent)
end

local function tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- ════════════════════════════════════════════════════════════════
--  TOP BANNER
-- ════════════════════════════════════════════════════════════════
local TopBanner = {Holder = nil, Active = nil}

local function initTopBanner()
    if TopBanner.Holder then return end
    local gui = CoreGui:FindFirstChild("DoeakUI_TopBanner") or create("ScreenGui", {
        Name = "DoeakUI_TopBanner", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10000,
    }, CoreGui)

    TopBanner.Holder = create("Frame", {
        Name = "Holder",
        Size = UDim2.new(0, 500, 0, 60),
        Position = UDim2.new(0.5, -250, 0, -80),
        BackgroundTransparency = 1,
    }, gui)
end

local function topBanner(title, text, color, duration, icon)
    initTopBanner()
    local t = Themes[CurrentTheme]
    color = safeColor(color, t.Accent)
    duration = duration or 3
    icon = icon or "◆"

    if TopBanner.Active and TopBanner.Active.Parent then
        TopBanner.Active:Destroy()
    end

    local banner = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = t.Surface,
        BackgroundTransparency = 0.03,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, TopBanner.Holder)
    corner(banner, 14)
    stroke(banner, t.Border, 1, 0.3)

    local strip = create("Frame", {
        Size = UDim2.new(0, 5, 1, -16), Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = color, BorderSizePixel = 0,
    }, banner)
    pillCorner(strip)

    local iconBg = create("Frame", {
        Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 24, 0, 13),
        BackgroundColor3 = color, BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
    }, banner)
    pillCorner(iconBg)
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Text = icon, TextColor3 = color, TextSize = 16,
        Font = Enum.Font.GothamBold,
    }, iconBg)

    create("TextLabel", {
        Size = UDim2.new(1, -160, 0, 18), Position = UDim2.new(0, 70, 0, 12),
        BackgroundTransparency = 1, Text = title, TextColor3 = t.Text,
        TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, banner)

    create("TextLabel", {
        Size = UDim2.new(1, -160, 0, 18), Position = UDim2.new(0, 70, 0, 30),
        BackgroundTransparency = 1, Text = text, TextColor3 = t.TextDim,
        TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, banner)

    local timerLabel = create("TextLabel", {
        Size = UDim2.new(0, 60, 0, 20), Position = UDim2.new(1, -76, 0, 10),
        BackgroundTransparency = 1, Text = string.format("%.1fs", duration),
        TextColor3 = color, TextSize = 12, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, banner)

    local progressBg = create("Frame", {
        Size = UDim2.new(1, -32, 0, 3), Position = UDim2.new(0, 16, 1, -12),
        BackgroundColor3 = t.SurfaceAlt, BorderSizePixel = 0,
        BackgroundTransparency = 0.3,
    }, banner)
    pillCorner(progressBg)

    local progress = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = color, BorderSizePixel = 0,
    }, progressBg)
    pillCorner(progress)

    tween(TopBanner.Holder, 0.4, {
        Position = UDim2.new(0.5, -250, 0, 16),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    tween(progress, duration, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear)

    TopBanner.Active = banner
    task.spawn(function()
        local startTime = tick()
        while tick() - startTime < duration do
            if not banner.Parent then return end
            local remaining = math.max(0, duration - (tick() - startTime))
            timerLabel.Text = string.format("%.1fs", remaining)
            task.wait(0.05)
        end
    end)

    task.delay(duration, function()
        if not banner.Parent then return end
        if TopBanner.Active ~= banner then return end
        tween(banner, 0.35, {BackgroundTransparency = 1}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        for _, c in ipairs(banner:GetDescendants()) do
            if c:IsA("TextLabel") then
                tween(c, 0.35, {TextTransparency = 1})
            end
            if c:IsA("UIStroke") then
                tween(c, 0.35, {Transparency = 1})
            end
        end
        tween(TopBanner.Holder, 0.4, {
            Position = UDim2.new(0.5, -250, 0, -80),
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.45)
        if banner.Parent then banner:Destroy() end
    end)
end

-- ════════════════════════════════════════════════════════════════
--  TOAST NOTIFICATIONS
-- ════════════════════════════════════════════════════════════════
local Notifications = {Holder = nil}

local function initNotifications()
    if Notifications.Holder then return end
    local gui = CoreGui:FindFirstChild("DoeakUI_Notify") or create("ScreenGui", {
        Name = "DoeakUI_Notify", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 9999,
    }, CoreGui)

    Notifications.Holder = create("Frame", {
        Name = "Holder", Size = UDim2.new(0, 320, 1, -40),
        Position = UDim2.new(1, -340, 0, 20), BackgroundTransparency = 1,
    }, gui)
    listLayout(Notifications.Holder, 8)
end

local function notify(title, text, color, duration, icon)
    initNotifications()
    local t = Themes[CurrentTheme]
    color = safeColor(color, t.Accent)
    duration = duration or 4
    icon = icon or "★"

    local notif = create("Frame", {
        Size = UDim2.new(1, 0, 0, 66),
        BackgroundColor3 = t.Surface, BackgroundTransparency = 0.05,
        BorderSizePixel = 0, ClipsDescendants = true,
    }, Notifications.Holder)
    corner(notif, 12)
    stroke(notif, t.Border, 1, 0.35)

    local bar = create("Frame", {
        Size = UDim2.new(0, 4, 1, -16), Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = color, BorderSizePixel = 0,
    }, notif)
    pillCorner(bar)

    local iconBg = create("Frame", {
        Size = UDim2.new(0, 34, 0, 34), Position = UDim2.new(0, 20, 0, 16),
        BackgroundColor3 = color, BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
    }, notif)
    pillCorner(iconBg)
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Text = icon, TextColor3 = color, TextSize = 16,
        Font = Enum.Font.GothamBold,
    }, iconBg)

    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 18), Position = UDim2.new(0, 64, 0, 14),
        BackgroundTransparency = 1, Text = title, TextColor3 = t.Text,
        TextSize = 13, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, notif)

    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 26), Position = UDim2.new(0, 64, 0, 32),
        BackgroundTransparency = 1, Text = text, TextColor3 = t.TextDim,
        TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, notif)

    local progress = create("Frame", {
        Size = UDim2.new(1, -16, 0, 2), Position = UDim2.new(0, 8, 1, -5),
        BackgroundColor3 = color, BorderSizePixel = 0,
    }, notif)
    pillCorner(progress)
    tween(progress, duration, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)

    notif.Position = UDim2.new(1, 40, 0, 0)
    tween(notif, 0.4, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(duration, function()
        tween(notif, 0.3, {Position = UDim2.new(1, 40, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        notif:Destroy()
    end)
end

-- ════════════════════════════════════════════════════════════════
--  LIBRARY
-- ════════════════════════════════════════════════════════════════
local Lib = {}
Lib.__index = Lib
Lib.Notify = notify
Lib.Banner = topBanner

function Lib:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Lib)
    self.Config = config
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true
    self.Minimized = false

    local t = Themes[CurrentTheme]
    self.Theme = t

    local guiName = "DoeakUI_" .. tostring(config.Name or "Window")
    local existing = CoreGui:FindFirstChild(guiName)
    if existing then existing:Destroy() end

    self.Gui = create("ScreenGui", {
        Name = guiName, ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100, IgnoreGuiInset = true,
    }, CoreGui)

    local winSize = config.Size or UDim2.new(0, 700, 0, 480)

    self.Main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -winSize.X.Offset/2, 0.5, -winSize.Y.Offset/2),
        BackgroundColor3 = t.Background, BorderSizePixel = 0,
        ClipsDescendants = true,
    }, self.Gui)
    corner(self.Main, 16)
    self.MainStroke = stroke(self.Main, t.Border, 1.2, 0.3)

    create("ImageLabel", {
        Size = UDim2.new(1, 80, 1, 80), Position = UDim2.new(0, -40, 0, -40),
        BackgroundTransparency = 1, Image = "rbxassetid://1316045217",
        ImageColor3 = t.Shadow, ImageTransparency = 0.55,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = -1,
    }, self.Main)

    tween(self.Main, 0.5, {
        Size = winSize,
        Position = UDim2.new(0.5, -winSize.X.Offset/2, 0.5, -winSize.Y.Offset/2),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Title bar
    self.TitleBar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = t.Surface, BorderSizePixel = 0,
    }, self.Main)
    corner(self.TitleBar, 16)

    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = t.Border, BorderSizePixel = 0,
        BackgroundTransparency = 0.5,
    }, self.TitleBar)

    local iconDot = create("Frame", {
        Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 20, 0, 21),
        BackgroundColor3 = t.Accent, BorderSizePixel = 0,
    }, self.TitleBar)
    pillCorner(iconDot)

    self.TitleLabel = create("TextLabel", {
        Size = UDim2.new(0.5, -60, 0, 20), Position = UDim2.new(0, 38, 0, 10),
        BackgroundTransparency = 1, Text = config.Name or "DoeakUI",
        TextColor3 = t.Text, TextSize = 14, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.TitleBar)

    create("TextLabel", {
        Size = UDim2.new(0.5, -60, 0, 16), Position = UDim2.new(0, 38, 0, 28),
        BackgroundTransparency = 1, Text = config.Subtitle or ("by " .. (config.Author or "Doeak")),
        TextColor3 = t.TextDim, TextSize = 11, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.TitleBar)

    local function makeCtrl(text, xOff, hoverColor)
        local b = create("TextButton", {
            Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, xOff, 0, 11),
            BackgroundColor3 = t.SurfaceAlt, BackgroundTransparency = 0.5,
            BorderSizePixel = 0, Text = text, TextColor3 = t.TextDim,
            TextSize = 14, Font = Enum.Font.GothamBold, AutoButtonColor = false,
        }, self.TitleBar)
        pillCorner(b)
        b.MouseEnter:Connect(function()
            tween(b, 0.15, {BackgroundTransparency = 0, TextColor3 = t.Text})
        end)
        b.MouseLeave:Connect(function()
            tween(b, 0.15, {BackgroundTransparency = 0.5, TextColor3 = t.TextDim})
        end)
        return b
    end

    self.CloseBtn = makeCtrl("✕", -40, t.Danger)
    self.MinBtn = makeCtrl("—", -72, t.Warning)

    self.CloseBtn.MouseButton1Click:Connect(function() self:Hide() end)
    self.MinBtn.MouseButton1Click:Connect(function() self:ToggleMinimize() end)

    create("TextLabel", {
        Size = UDim2.new(0, 100, 0, 14), Position = UDim2.new(1, -190, 0, 18),
        BackgroundTransparency = 1, Text = "v4.1",
        TextColor3 = t.TextDim, TextSize = 10,
        Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right,
        TextTransparency = 0.5,
    }, self.TitleBar)

    -- Sidebar
    local SIDEBAR_W = 150
    self.Sidebar = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, SIDEBAR_W, 1, -74),
        Position = UDim2.new(1, -SIDEBAR_W - 8, 0, 58),
        BackgroundColor3 = t.Sidebar, BorderSizePixel = 0,
    }, self.Main)
    corner(self.Sidebar, 10)
    listLayout(self.Sidebar, 5)
    padding(self.Sidebar, 10, 8, 10, 8)

    local sbHeader = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
        Text = "MENU", TextColor3 = t.TextDim, TextSize = 9,
        Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
    }, self.Sidebar)
    sbHeader.LayoutOrder = 0

    -- Content
    self.Content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -SIDEBAR_W - 24, 1, -82),
        Position = UDim2.new(0, 10, 0, 58),
        BackgroundTransparency = 1, ClipsDescendants = true,
    }, self.Main)

    -- Status bar
    self.StatusBar = create("Frame", {
        Size = UDim2.new(1, -SIDEBAR_W - 24, 0, 24),
        Position = UDim2.new(0, 10, 1, -30),
        BackgroundColor3 = t.Surface, BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
    }, self.Main)
    corner(self.StatusBar, 8)

    -- FIXED status dot
    local statusDot = create("Frame", {
        Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 12, 0.5, -3),
        BackgroundColor3 = t.Success, BorderSizePixel = 0,
    }, self.StatusBar)
    pillCorner(statusDot)

    self.StatusLabel = create("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 26, 0, 0),
        BackgroundTransparency = 1,
        Text = "Ready · Alt to toggle",
        TextColor3 = t.TextDim, TextSize = 10, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.StatusBar)

    self.ClockLabel = create("TextLabel", {
        Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(1, -68, 0, 0),
        BackgroundTransparency = 1, Text = "",
        TextColor3 = t.TextDim, TextSize = 10, Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
    }, self.StatusBar)

    task.spawn(function()
        while self.Gui and self.Gui.Parent do
            local ok = pcall(function()
                self.ClockLabel.Text = os.date("%H:%M:%S")
            end)
            if not ok then break end
            task.wait(1)
        end
    end)

    -- Drag
    local dragging, dragStart, startPos
    local function startDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = self.Main.Position
    end
    local function updateDrag(input)
        if not dragging then return end
        local delta = input.Position - dragStart
        self.Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then startDrag(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then updateDrag(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
            self:Toggle()
        end
    end)

    -- Methods
    function self:SetStatus(text)
        self.StatusLabel.Text = text
    end

    function self:SetTheme(name)
        if not Themes[name] then return end
        CurrentTheme = name
        self.Theme = Themes[name]
        self:ApplyTheme()
    end

    function self:ApplyTheme()
        local old = t
        local th = self.Theme
        local function apply(obj)
            if not obj or not obj.Parent then return end
            for _, c in ipairs(obj:GetDescendants()) do
                if c:IsA("Frame") or c:IsA("TextButton") or c:IsA("TextLabel") or c:IsA("TextBox") then
                    if c.BackgroundColor3 == old.Background then c.BackgroundColor3 = th.Background
                    elseif c.BackgroundColor3 == old.Surface then c.BackgroundColor3 = th.Surface
                    elseif c.BackgroundColor3 == old.SurfaceAlt then c.BackgroundColor3 = th.SurfaceAlt
                    elseif c.BackgroundColor3 == old.Sidebar then c.BackgroundColor3 = th.Sidebar
                    elseif c.BackgroundColor3 == old.Accent then c.BackgroundColor3 = th.Accent end
                end
                if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then
                    if c.TextColor3 == old.Text then c.TextColor3 = th.Text
                    elseif c.TextColor3 == old.TextDim then c.TextColor3 = th.TextDim
                    elseif c.TextColor3 == old.Accent then c.TextColor3 = th.Accent end
                end
                if c:IsA("UIStroke") and c.Color == old.Border then c.Color = th.Border end
            end
        end
        apply(self.Gui)
        t = th
    end

    function self:Show()
        self.Visible = true
        self.Gui.Enabled = true
        tween(self.Main, 0.4, {Size = winSize}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    function self:Hide()
        self.Visible = false
        tween(self.Main, 0.25, {Size = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.25)
        self.Gui.Enabled = false
    end

    function self:Toggle()
        if self.Visible then self:Hide() else self:Show() end
    end

    function self:ToggleMinimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            self._saved = self.Main.Size
            tween(self.Main, 0.3, {Size = UDim2.new(winSize.X.Scale, winSize.X.Offset, 0, 50)},
                Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            tween(self.Main, 0.35, {Size = self._saved or winSize},
                Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end

    function self:Destroy() self.Gui:Destroy() end

    return self
end

-- ════════════════════════════════════════════════════════════════
--  TAB
-- ════════════════════════════════════════════════════════════════
function Lib:CreateTab(name, icon)
    local t = self.Theme
    local tab = {}
    tab.Name = name
    tab.Elements = {}
    tab.Order = 0

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = t.SurfaceAlt, BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Text = "  " .. (icon or "◈") .. "   " .. name,
        TextColor3 = t.TextDim, TextSize = 12,
        Font = Enum.Font.GothamMedium, AutoButtonColor = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.Sidebar)
    corner(btn, 8)
    btn.LayoutOrder = #self.Tabs + 1

    local indicator = create("Frame", {
        Size = UDim2.new(0, 3, 0.55, 0), Position = UDim2.new(0, 0, 0.225, 0),
        BackgroundColor3 = t.Accent, BorderSizePixel = 0,
        BackgroundTransparency = 1,
    }, btn)
    pillCorner(indicator)

    local container = create("ScrollingFrame", {
        Name = "TabContent_" .. name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = t.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, self.Content)
    listLayout(container, 5)
    padding(container, 0, 8, 0, 0)

    btn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            tween(btn, 0.15, {BackgroundTransparency = 0.4, TextColor3 = t.Text})
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            tween(btn, 0.15, {BackgroundTransparency = 0.7, TextColor3 = t.TextDim})
        end
    end)
    btn.MouseButton1Click:Connect(function()
        for _, tb in ipairs(self.Tabs) do
            tween(tb.Button, 0.2, {BackgroundTransparency = 0.7, TextColor3 = t.TextDim})
            tween(tb.Indicator, 0.2, {BackgroundTransparency = 1})
            tb.Container.Visible = false
        end
        tween(btn, 0.2, {BackgroundTransparency = 0.1, TextColor3 = t.Text})
        tween(indicator, 0.25, {BackgroundTransparency = 0})
        container.Visible = true
        self.ActiveTab = tab
        if self.SetStatus then self:SetStatus("Tab: " .. name) end
    end)

    tab.Button = btn
    tab.Indicator = indicator
    tab.Container = container

    function tab:AddElement(elem)
        self.Order = self.Order + 1
        elem.Frame.LayoutOrder = self.Order
        elem.Frame.Parent = self.Container
        table.insert(self.Elements, elem)
        return elem
    end

    function tab:CreateSection(title)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {Size = UDim2.new(1, -8, 0, 28), BackgroundTransparency = 1})
        create("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1, Text = title,
            TextColor3 = t2.TextDim, TextSize = 10,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)
        create("Frame", {
            Size = UDim2.new(1, -12, 0, 1), Position = UDim2.new(0, 6, 1, -4),
            BackgroundColor3 = t2.Border, BorderSizePixel = 0,
            BackgroundTransparency = 0.6,
        }, frame)
        self:AddElement({Frame = frame, Type = "Section"})
        return frame
    end

    function tab:CreateLabel(text)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {Size = UDim2.new(1, -8, 0, 22), BackgroundTransparency = 1})
        local lbl = create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Text = text, TextColor3 = t2.TextDim, TextSize = 12,
            Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
        }, frame)
        local api = {Frame = frame, Type = "Label"}
        function api:Set(txt) lbl.Text = tostring(txt) end
        function api:Text() return lbl.Text end
        api.Text = lbl.Text
        self:AddElement(api)
        return api
    end

    function tab:CreateParagraph(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 84),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.6)

        create("TextLabel", {
            Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 14, 0, 8),
            BackgroundTransparency = 1, Text = config.Title or "Title",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local body = create("TextLabel", {
            Size = UDim2.new(1, -24, 0, 48), Position = UDim2.new(0, 14, 0, 30),
            BackgroundTransparency = 1, Text = config.Content or "",
            TextColor3 = t2.TextDim, TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true,
        }, frame)

        local api = {Frame = frame, Type = "Paragraph"}
        function api:Set(txt) body.Text = tostring(txt) end
        function api:Update(txt) body.Text = tostring(txt) end
        api.Content = body.Text
        api.Text = body.Text
        self:AddElement(api)
        return api
    end

    function tab:CreateButton(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("TextButton", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.15,
            BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.5)

        local label = create("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = config.Name or "Button",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local arrow = create("TextLabel", {
            Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -34, 0.5, -12),
            BackgroundColor3 = t2.SurfaceAlt, BackgroundTransparency = 0.5,
            BorderSizePixel = 0, Text = "›", TextColor3 = t2.TextDim,
            TextSize = 14, Font = Enum.Font.GothamBold,
        }, frame)
        pillCorner(arrow)

        frame.MouseEnter:Connect(function()
            tween(frame, 0.18, {BackgroundTransparency = 0, BackgroundColor3 = t2.SurfaceAlt})
            tween(arrow, 0.18, {BackgroundTransparency = 0, TextColor3 = t2.Accent})
        end)
        frame.MouseLeave:Connect(function()
            tween(frame, 0.18, {BackgroundTransparency = 0.15, BackgroundColor3 = t2.Surface})
            tween(arrow, 0.18, {BackgroundTransparency = 0.5, TextColor3 = t2.TextDim})
        end)
        frame.MouseButton1Click:Connect(function()
            if config.Callback then task.spawn(config.Callback) end
        end)

        local api = {Frame = frame, Type = "Button"}
        function api:SetText(txt) label.Text = tostring(txt) end
        self:AddElement(api)
        return api
    end

    function tab:CreateToggle(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.5)

        create("TextLabel", {
            Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = config.Name or "Toggle",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local switchBg = create("Frame", {
            Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -56, 0, 9),
            BackgroundColor3 = t2.SurfaceAlt, BorderSizePixel = 0,
        }, frame)
        pillCorner(switchBg)

        local knob = create("Frame", {
            Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = t2.TextDim, BorderSizePixel = 0,
        }, switchBg)
        pillCorner(knob)

        local state = config.CurrentValue or false
        local function update(anim)
            local target = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
            local bg = state and t2.Accent or t2.SurfaceAlt
            local knobBg = state and Color3.new(1,1,1) or t2.TextDim
            if anim then
                tween(switchBg, 0.22, {BackgroundColor3 = bg})
                tween(knob, 0.22, {Position = target, BackgroundColor3 = knobBg},
                    Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                switchBg.BackgroundColor3 = bg
                knob.Position = target
                knob.BackgroundColor3 = knobBg
            end
        end
        update(false)

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                update(true)
                if config.Callback then task.spawn(config.Callback, state) end
            end
        end)

        local api = {Frame = frame, Type = "Toggle", Flag = config.Flag}
        function api:Set(v) state = v; update(true); if config.Callback then task.spawn(config.Callback, v) end end
        function api:Get() return state end
        self:AddElement(api)
        return api
    end

    function tab:CreateSlider(config)
        local t2 = Themes[CurrentTheme]
        local min = config.Min or 0
        local max = config.Max or 100
        local val = math.clamp(config.Default or min, min, max)

        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 52),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.5)

        create("TextLabel", {
            Size = UDim2.new(0.7, -12, 0, 20), Position = UDim2.new(0, 16, 0, 6),
            BackgroundTransparency = 1, Text = config.Name or "Slider",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local valLabel = create("TextLabel", {
            Size = UDim2.new(0.3, -16, 0, 20), Position = UDim2.new(0.7, 0, 0, 6),
            BackgroundTransparency = 1, Text = tostring(val),
            TextColor3 = t2.Accent, TextSize = 12, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, frame)

        local track = create("Frame", {
            Size = UDim2.new(1, -32, 0, 4), Position = UDim2.new(0, 16, 0, 36),
            BackgroundColor3 = t2.SurfaceAlt, BorderSizePixel = 0,
        }, frame)
        pillCorner(track)

        local fill = create("Frame", {
            Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = t2.Accent, BorderSizePixel = 0,
        }, track)
        pillCorner(fill)

        local knob = create("Frame", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new((val - min) / (max - min), 0, 0.5, -7),
            BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 2,
        }, track)
        pillCorner(knob)

        local dragging = false
        local function setFromInput(input)
            local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            val = math.floor(min + (max - min) * relX + 0.5)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            knob.Position = UDim2.new(relX, 0, 0.5, -7)
            valLabel.Text = tostring(val)
            if config.Callback then task.spawn(config.Callback, val) end
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromInput(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then setFromInput(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)

        local api = {Frame = frame, Type = "Slider", Flag = config.Flag}
        function api:Set(v)
            v = math.clamp(v, min, max); val = v
            local rel = (v - min) / (max - min)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, -7)
            valLabel.Text = tostring(v)
            if config.Callback then task.spawn(config.Callback, v) end
        end
        function api:Get() return val end
        self:AddElement(api)
        return api
    end

    function tab:CreateDropdown(config)
        local t2 = Themes[CurrentTheme]
        local options = config.Options or {}
        local current = config.CurrentOption or (options[1] and {options[1]} or {})
        local opened = false

        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.15,
            BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 5,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.5)

        local header = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, ZIndex = 5,
        }, frame)

        create("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = config.Name or "Dropdown",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
        }, header)

        local arrow = create("TextLabel", {
            Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -40, 0, 0),
            BackgroundTransparency = 1, Text = "▾", TextColor3 = t2.TextDim,
            TextSize = 13, Font = Enum.Font.GothamBold, ZIndex = 5,
        }, header)

        local listFrame = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6),
            BackgroundColor3 = t2.SurfaceAlt, BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false, ZIndex = 10,
        }, frame)
        corner(listFrame, 10)
        stroke(listFrame, t2.Border, 1, 0.3)
        listLayout(listFrame, 3)
        padding(listFrame, 6, 6, 6, 6)

        local function makeItem(opt)
            local item = create("TextButton", {
                Size = UDim2.new(1, -12, 0, 28),
                BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.5,
                BorderSizePixel = 0, Text = tostring(opt),
                TextColor3 = t2.TextDim, TextSize = 12,
                Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false, ZIndex = 10,
            }, listFrame)
            corner(item, 6)
            padding(item, 0, 0, 0, 10)
            item.MouseEnter:Connect(function()
                tween(item, 0.1, {BackgroundTransparency = 0, TextColor3 = t2.Text})
            end)
            item.MouseLeave:Connect(function()
                tween(item, 0.1, {BackgroundTransparency = 0.5, TextColor3 = t2.TextDim})
            end)
            item.MouseButton1Click:Connect(function()
                current = {tostring(opt)}
                opened = false
                tween(listFrame, 0.2, {Size = UDim2.new(1, 0, 0, 0)})
                task.wait(0.2)
                listFrame.Visible = false
                tween(arrow, 0.2, {Rotation = 0})
                if config.Callback then task.spawn(config.Callback, tostring(opt)) end
            end)
        end

        for _, opt in ipairs(options) do makeItem(opt) end

        header.MouseButton1Click:Connect(function()
            opened = not opened
            if opened then
                listFrame.Visible = true
                listFrame.Size = UDim2.new(1, 0, 0, 0)
                local h = math.min(#options * 34 + 12, 200)
                tween(listFrame, 0.22, {Size = UDim2.new(1, 0, 0, h)},
                    Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                tween(arrow, 0.2, {Rotation = 180})
            else
                tween(listFrame, 0.18, {Size = UDim2.new(1, 0, 0, 0)})
                task.wait(0.18)
                listFrame.Visible = false
                tween(arrow, 0.2, {Rotation = 0})
            end
        end)

        local api = {Frame = frame, Type = "Dropdown", Flag = config.Flag}
        function api:Refresh(newOptions)
            options = newOptions or options
            for _, c in ipairs(listFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for _, opt in ipairs(options) do makeItem(opt) end
        end
        function api:Get() return current[1] end
        self:AddElement(api)
        return api
    end

    function tab:CreateTextbox(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.5)

        create("TextLabel", {
            Size = UDim2.new(0.4, -12, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = config.Name or "Input",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local box = create("TextBox", {
            Size = UDim2.new(0.6, -22, 0, 28), Position = UDim2.new(0.4, 6, 0, 6),
            BackgroundColor3 = t2.SurfaceAlt, BackgroundTransparency = 0.3,
            BorderSizePixel = 0, Text = config.CurrentText or "",
            PlaceholderText = config.PlaceholderText or "Type...",
            PlaceholderColor3 = t2.TextDim, TextColor3 = t2.Text,
            TextSize = 12, Font = Enum.Font.Gotham,
            ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)
        corner(box, 8)
        padding(box, 0, 0, 0, 12)

        box.FocusLost:Connect(function()
            if config.Callback then task.spawn(config.Callback, box.Text) end
            if config.RemoveTextAfterFocusLost then box.Text = "" end
        end)

        local api = {Frame = frame, Type = "Textbox", Flag = config.Flag}
        function api:Set(txt) box.Text = tostring(txt) end
        function api:Get() return box.Text end
        self:AddElement(api)
        return api
    end

    function tab:CreateKeybind(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.5)

        create("TextLabel", {
            Size = UDim2.new(1, -110, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = config.Name or "Keybind",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local keyBtn = create("TextButton", {
            Size = UDim2.new(0, 74, 0, 26), Position = UDim2.new(1, -88, 0, 7),
            BackgroundColor3 = t2.SurfaceAlt, BackgroundTransparency = 0.3,
            BorderSizePixel = 0, Text = tostring(config.CurrentKeybind or "None"),
            TextColor3 = t2.Accent, TextSize = 11,
            Font = Enum.Font.GothamBold, AutoButtonColor = false,
        }, frame)
        pillCorner(keyBtn)

        local listening = false
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyBtn.Text = "..."
        end)
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not listening then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                keyBtn.Text = input.KeyCode.Name
                if config.Callback then task.spawn(config.Callback, input.KeyCode) end
            end
        end)

        local api = {Frame = frame, Type = "Keybind", Flag = config.Flag}
        self:AddElement(api)
        return api
    end

    function tab:CreateColorPicker(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface, BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
        })
        corner(frame, 10)
        stroke(frame, t2.Border, 1, 0.5)

        create("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1, Text = config.Name or "Color",
            TextColor3 = t2.Text, TextSize = 12, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local colorBox = create("TextButton", {
            Size = UDim2.new(0, 42, 0, 24), Position = UDim2.new(1, -58, 0, 8),
            BackgroundColor3 = config.Default or t2.Accent,
            BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        }, frame)
        pillCorner(colorBox)

        colorBox.MouseButton1Click:Connect(function()
            local palette = {
                Color3.fromRGB(110, 145, 235), Color3.fromRGB(120, 195, 140),
                Color3.fromRGB(220, 115, 125), Color3.fromRGB(225, 180, 110),
                Color3.fromRGB(175, 110, 215), Color3.fromRGB(100, 210, 215),
            }
            local idx = 1
            for i, c in ipairs(palette) do
                if c == colorBox.BackgroundColor3 then idx = i break end
            end
            idx = idx % #palette + 1
            colorBox.BackgroundColor3 = palette[idx]
            if config.Callback then task.spawn(config.Callback, palette[idx]) end
        end)

        local api = {Frame = frame, Type = "ColorPicker", Flag = config.Flag}
        function api:Set(c) colorBox.BackgroundColor3 = c end
        function api:Get() return colorBox.BackgroundColor3 end
        self:AddElement(api)
        return api
    end

    if #self.Tabs == 0 then
        btn.BackgroundTransparency = 0.1
        btn.TextColor3 = t.Text
        indicator.BackgroundTransparency = 0
        container.Visible = true
        self.ActiveTab = tab
    else
        container.Visible = false
    end

    table.insert(self.Tabs, tab)
    return tab
end

-- ════════════════════════════════════════════════════════════════
--  BOOT
-- ════════════════════════════════════════════════════════════════
topBanner("DoeakHub UI v4.1", "Loaded — Alt để ẩn/hiện UI", Color3.fromRGB(120, 195, 140), 3, "★")
print("[DoeakUI v4.1] Loaded — Alt to toggle UI")

return Lib
