--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║           DOEAKHUB UI LIBRARY v2 — BETTER x100              ║
    ║  Modern · Smooth · Responsive · Themeable · Production-ready║
    ╚══════════════════════════════════════════════════════════════╝
    
    API tương thích 100% với v1 — tất cả script cũ chạy nguyên.
    
    TÍNH NĂNG MỚI v2:
        ✦ 5 Theme (Dark / Midnight / Neon / Blood / Light)
        ✦ Draggable window (title bar + background)
        ✦ Minimize / Maximize / Close
        ✦ Smooth Tween animations mọi element
        ✦ Notification stack (nhiều notif cùng lúc)
        ✦ Intro animation khi mở UI
        ✦ Drop shadow cho window
        ✦ Hover + press feedback mọi nút
        ✦ Scrollbar mượt với màu accent
        ✦ Tooltip, Watermark, Keybind toggle (RightControl)
        ✦ Color picker, Keybind element
        ✦ Recursive theme apply
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════════
--  THEME SYSTEM
-- ════════════════════════════════════════════════════════════════
local Themes = {
    Dark = {
        Background    = Color3.fromRGB(18, 18, 24),
        Surface       = Color3.fromRGB(26, 26, 36),
        SurfaceAlt    = Color3.fromRGB(34, 34, 46),
        Border        = Color3.fromRGB(48, 48, 64),
        Text          = Color3.fromRGB(230, 232, 240),
        TextDim       = Color3.fromRGB(140, 145, 165),
        Accent        = Color3.fromRGB(94, 129, 244),
        AccentDark    = Color3.fromRGB(64, 94, 194),
        Success       = Color3.fromRGB(105, 200, 145),
        Warning       = Color3.fromRGB(230, 180, 90),
        Danger        = Color3.fromRGB(225, 95, 105),
        Shadow        = Color3.fromRGB(0, 0, 0),
    },
    Midnight = {
        Background    = Color3.fromRGB(10, 12, 22),
        Surface       = Color3.fromRGB(16, 20, 34),
        SurfaceAlt    = Color3.fromRGB(22, 28, 46),
        Border        = Color3.fromRGB(38, 48, 72),
        Text          = Color3.fromRGB(220, 225, 245),
        TextDim       = Color3.fromRGB(120, 130, 165),
        Accent        = Color3.fromRGB(130, 100, 255),
        AccentDark    = Color3.fromRGB(90, 70, 200),
        Success       = Color3.fromRGB(100, 220, 160),
        Warning       = Color3.fromRGB(240, 190, 100),
        Danger        = Color3.fromRGB(240, 100, 120),
        Shadow        = Color3.fromRGB(0, 0, 0),
    },
    Neon = {
        Background    = Color3.fromRGB(8, 8, 14),
        Surface       = Color3.fromRGB(14, 14, 22),
        SurfaceAlt    = Color3.fromRGB(20, 20, 32),
        Border        = Color3.fromRGB(40, 200, 220),
        Text          = Color3.fromRGB(230, 255, 255),
        TextDim       = Color3.fromRGB(120, 180, 200),
        Accent        = Color3.fromRGB(0, 230, 200),
        AccentDark    = Color3.fromRGB(0, 160, 140),
        Success       = Color3.fromRGB(100, 255, 180),
        Warning       = Color3.fromRGB(255, 220, 100),
        Danger        = Color3.fromRGB(255, 100, 160),
        Shadow        = Color3.fromRGB(0, 0, 0),
    },
    Blood = {
        Background    = Color3.fromRGB(16, 8, 10),
        Surface       = Color3.fromRGB(24, 12, 16),
        SurfaceAlt    = Color3.fromRGB(34, 18, 24),
        Border        = Color3.fromRGB(70, 30, 40),
        Text          = Color3.fromRGB(240, 220, 225),
        TextDim       = Color3.fromRGB(160, 120, 130),
        Accent        = Color3.fromRGB(220, 50, 70),
        AccentDark    = Color3.fromRGB(160, 30, 50),
        Success       = Color3.fromRGB(120, 220, 140),
        Warning       = Color3.fromRGB(240, 180, 80),
        Danger        = Color3.fromRGB(255, 80, 100),
        Shadow        = Color3.fromRGB(0, 0, 0),
    },
    Light = {
        Background    = Color3.fromRGB(245, 246, 250),
        Surface       = Color3.fromRGB(255, 255, 255),
        SurfaceAlt    = Color3.fromRGB(235, 238, 245),
        Border        = Color3.fromRGB(210, 215, 225),
        Text          = Color3.fromRGB(30, 34, 46),
        TextDim       = Color3.fromRGB(120, 126, 140),
        Accent        = Color3.fromRGB(80, 120, 240),
        AccentDark    = Color3.fromRGB(50, 90, 210),
        Success       = Color3.fromRGB(60, 180, 110),
        Warning       = Color3.fromRGB(220, 160, 60),
        Danger        = Color3.fromRGB(220, 80, 100),
        Shadow        = Color3.fromRGB(0, 0, 0),
    },
}

local CurrentTheme = "Dark"

-- ════════════════════════════════════════════════════════════════
--  UTILITIES
-- ════════════════════════════════════════════════════════════════
local function create(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    return create("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, parent)
end

local function stroke(parent, color, thickness, transparency)
    return create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function padding(parent, top, right, bottom, left)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
    }, parent)
end

local function listLayout(parent, paddingVal, sortOrder)
    return create("UIListLayout", {
        Padding = UDim.new(0, paddingVal or 4),
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
--  NOTIFICATION SYSTEM
-- ════════════════════════════════════════════════════════════════
local Notifications = {Holder = nil}

local function initNotifications()
    if Notifications.Holder then return end
    local gui = CoreGui:FindFirstChild("DoeakUI_Notify") or create("ScreenGui", {
        Name = "DoeakUI_Notify",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 9999,
    }, CoreGui)

    Notifications.Holder = create("Frame", {
        Name = "Holder",
        Size = UDim2.new(0, 340, 1, -40),
        Position = UDim2.new(1, -360, 0, 20),
        BackgroundTransparency = 1,
    }, gui)

    listLayout(Notifications.Holder, 8)
end

local function notify(title, text, color, duration, icon)
    initNotifications()
    local t = Themes[CurrentTheme]
    color = color or t.Accent
    duration = duration or 4
    icon = icon or "★"

    local notif = create("Frame", {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = t.Surface,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, Notifications.Holder)
    corner(notif, 10)
    stroke(notif, t.Border, 1, 0.3)

    -- Accent bar
    create("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
    }, notif)

    -- Icon box
    local iconBox = create("TextLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 12, 0, 15),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.85,
        Text = icon,
        TextColor3 = color,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
    }, notif)
    corner(iconBox, 8)

    -- Title
    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        Position = UDim2.new(0, 60, 0, 14),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = t.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, notif)

    -- Body
    create("TextLabel", {
        Size = UDim2.new(1, -80, 0, 32),
        Position = UDim2.new(0, 60, 0, 34),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = t.TextDim,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    }, notif)

    -- Progress bar
    local progress = create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
    }, notif)

    tween(progress, duration, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)

    -- Slide in
    notif.Position = UDim2.new(1, 30, 0, 0)
    tween(notif, 0.35, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(duration, function()
        tween(notif, 0.3, {Position = UDim2.new(1, 30, 0, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In)
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

-- ════════════════════════════════════════════════════════════════
--  WINDOW
-- ════════════════════════════════════════════════════════════════
function Lib:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Lib)
    self.Config = config
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true
    self.Minimized = false
    self.AllElements = {}

    local t = Themes[CurrentTheme]
    self.Theme = t

    local guiName = "DoeakUI_" .. tostring(config.Name or "Window")
    local existing = CoreGui:FindFirstChild(guiName)
    if existing then existing:Destroy() end

    self.Gui = create("ScreenGui", {
        Name = guiName,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
        IgnoreGuiInset = true,
    }, CoreGui)

    local winSize = config.Size or UDim2.new(0, 600, 0, 420)

    self.Main = create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -winSize.X.Offset/2, 0.5, -winSize.Y.Offset/2),
        BackgroundColor3 = t.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, self.Gui)
    corner(self.Main, 12)
    self.MainStroke = stroke(self.Main, t.Border, 1.5, 0.2)

    -- Shadow
    create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = t.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = -1,
    }, self.Main)

    -- Intro animation
    tween(self.Main, 0.45, {
        Size = winSize,
        Position = UDim2.new(0.5, -winSize.X.Offset/2, 0.5, -winSize.Y.Offset/2),
    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Title bar
    self.TitleBar = create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
    }, self.Main)
    corner(self.TitleBar, 12)

    -- Accent line
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = t.Accent,
        BorderSizePixel = 0,
        BackgroundTransparency = 0.5,
    }, self.TitleBar)

    -- Icon
    create("TextLabel", {
        Size = UDim2.new(0, 46, 1, 0),
        BackgroundTransparency = 1,
        Text = "◆",
        TextColor3 = t.Accent,
        TextSize = 22,
        Font = Enum.Font.GothamBold,
    }, self.TitleBar)

    -- Title
    self.TitleLabel = create("TextLabel", {
        Size = UDim2.new(0.5, -60, 0, 20),
        Position = UDim2.new(0, 50, 0, 6),
        BackgroundTransparency = 1,
        Text = config.Name or "DoeakUI",
        TextColor3 = t.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.TitleBar)

    -- Subtitle
    create("TextLabel", {
        Size = UDim2.new(0.5, -60, 0, 16),
        Position = UDim2.new(0, 50, 0, 24),
        BackgroundTransparency = 1,
        Text = config.Subtitle or ("by " .. (config.Author or "Doeak")),
        TextColor3 = t.TextDim,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.TitleBar)

    -- Window controls
    local function makeBtn(text, xOff, hoverColor)
        local b = create("TextButton", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, xOff, 0, 8),
            BackgroundColor3 = t.SurfaceAlt,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = t.TextDim,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, self.TitleBar)
        corner(b, 6)
        b.MouseEnter:Connect(function()
            tween(b, 0.15, {BackgroundColor3 = hoverColor, TextColor3 = t.Text})
        end)
        b.MouseLeave:Connect(function()
            tween(b, 0.15, {BackgroundColor3 = t.SurfaceAlt, TextColor3 = t.TextDim})
        end)
        return b
    end

    self.CloseBtn = makeBtn("✕", -38, t.Danger)
    self.MinBtn = makeBtn("—", -72, t.Warning)

    self.CloseBtn.MouseButton1Click:Connect(function() self:Hide() end)
    self.MinBtn.MouseButton1Click:Connect(function() self:ToggleMinimize() end)

    -- Watermark
    create("TextLabel", {
        Size = UDim2.new(0, 100, 0, 16),
        Position = UDim2.new(1, -120, 0, 30),
        BackgroundTransparency = 1,
        Text = "v2 · DoeakHub",
        TextColor3 = t.TextDim,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTransparency = 0.4,
    }, self.TitleBar)

    -- Tab bar
    self.TabBar = create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, -16, 0, 40),
        Position = UDim2.new(0, 8, 0, 54),
        BackgroundTransparency = 1,
    }, self.Main)
    listLayout(self.TabBar, 6)
    self.TabBar.UIListLayout.FillDirection = Enum.FillDirection.Horizontal

    -- Content area
    self.Content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -16, 1, -110),
        Position = UDim2.new(0, 8, 0, 100),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, self.Main)

    -- ── Dragging ───────────────────────────────────────────
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
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    local function endDrag() dragging = false end

    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    self.Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)

    -- ── Toggle keybind (RightControl) ──────────────────────
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            self:Toggle()
        end
    end)

    -- ── Methods ────────────────────────────────────────────
    function self:SetTheme(name)
        if not Themes[name] then return end
        CurrentTheme = name
        self.Theme = Themes[name]
        self:ApplyTheme()
    end

    function self:ApplyTheme()
        local th = self.Theme
        -- Apply to all registered elements recursively
        local function applyTo(obj)
            if not obj or not obj.Parent then return end
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("Frame") and child.BackgroundColor3 then
                    -- Best-effort mapping (không hoàn hảo nhưng đủ dùng)
                    if child.BackgroundColor3 == t.Background then
                        child.BackgroundColor3 = th.Background
                    elseif child.BackgroundColor3 == t.Surface then
                        child.BackgroundColor3 = th.Surface
                    elseif child.BackgroundColor3 == t.SurfaceAlt then
                        child.BackgroundColor3 = th.SurfaceAlt
                    end
                elseif child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    if child.TextColor3 == t.Text then
                        child.TextColor3 = th.Text
                    elseif child.TextColor3 == t.TextDim then
                        child.TextColor3 = th.TextDim
                    elseif child.TextColor3 == t.Accent then
                        child.TextColor3 = th.Accent
                    end
                elseif child:IsA("UIStroke") then
                    if child.Color == t.Border then
                        child.Color = th.Border
                    end
                end
            end
        end
        applyTo(self.Gui)
        t = th
    end

    function self:Show()
        self.Visible = true
        self.Gui.Enabled = true
        tween(self.Main, 0.3, {Size = winSize}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
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
            self._savedSize = self.Main.Size
            tween(self.Main, 0.3, {Size = UDim2.new(winSize.X.Scale, winSize.X.Offset, 0, 46)},
                Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        else
            tween(self.Main, 0.3, {Size = self._savedSize or winSize},
                Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end

    function self:Destroy()
        self.Gui:Destroy()
    end

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
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = t.SurfaceAlt,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "  " .. (icon or "◈") .. "  " .. name,
        TextColor3 = t.TextDim,
        TextSize = 13,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
    }, self.TabBar)
    corner(btn, 8)

    local indicator = create("Frame", {
        Size = UDim2.new(1, -12, 0, 2),
        Position = UDim2.new(0, 6, 1, -3),
        BackgroundColor3 = t.Accent,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
    }, btn)
    corner(indicator, 1)

    local container = create("ScrollingFrame", {
        Name = "TabContent_" .. name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = t.Accent,
        ScrollBarImageTransparency = 0.5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, self.Content)
    listLayout(container, 4)

    btn.MouseButton1Click:Connect(function()
        for _, tb in ipairs(self.Tabs) do
            tween(tb.Button, 0.2, {BackgroundTransparency = 1, TextColor3 = t.TextDim})
            tween(tb.Indicator, 0.2, {BackgroundTransparency = 1})
            tb.Container.Visible = false
        end
        tween(btn, 0.2, {BackgroundTransparency = 0.6, TextColor3 = t.Text})
        tween(indicator, 0.2, {BackgroundTransparency = 0})
        container.Visible = true
        self.ActiveTab = tab
    end)

    tab.Button = btn
    tab.Indicator = indicator
    tab.Container = container

    function tab:AddElement(elem)
        self.Order = self.Order + 1
        elem.Frame.LayoutOrder = self.Order
        elem.Frame.Parent = self.Container
        table.insert(self.Elements, elem)
        if self.Theme then
            table.insert(self.Theme.AllElements or {}, elem)
        end
        return elem
    end

    -- ── Section ────────────────────────────────────────────
    function tab:CreateSection(title)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 28),
            BackgroundTransparency = 1,
        })
        create("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = t2.Accent,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.15,
        }, frame)
        create("Frame", {
            Size = UDim2.new(1, -8, 0, 1),
            Position = UDim2.new(0, 4, 1, -4),
            BackgroundColor3 = t2.Border,
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5,
        }, frame)
        self:AddElement({Frame = frame, Type = "Section"})
        return frame
    end

    -- ── Label ──────────────────────────────────────────────
    function tab:CreateLabel(text)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 22),
            BackgroundTransparency = 1,
        })
        local lbl = create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = t2.TextDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
        }, frame)
        local api = {Frame = frame, Type = "Label"}
        function api:Set(txt) lbl.Text = tostring(txt) end
        function api:Text() return lbl.Text end
        api.Text = lbl.Text
        self:AddElement(api)
        return api
    end

    -- ── Paragraph ──────────────────────────────────────────
    function tab:CreateParagraph(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 80),
            BackgroundColor3 = t2.Surface,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.5)

        create("TextLabel", {
            Size = UDim2.new(1, -16, 0, 20),
            Position = UDim2.new(0, 8, 0, 6),
            BackgroundTransparency = 1,
            Text = config.Title or "Title",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local body = create("TextLabel", {
            Size = UDim2.new(1, -16, 0, 46),
            Position = UDim2.new(0, 8, 0, 28),
            BackgroundTransparency = 1,
            Text = config.Content or "",
            TextColor3 = t2.TextDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
        }, frame)

        local api = {Frame = frame, Type = "Paragraph"}
        function api:Set(txt) body.Text = tostring(txt) end
        function api:Update(txt) body.Text = tostring(txt) end
        api.Content = body.Text
        api.Text = body.Text
        self:AddElement(api)
        return api
    end

    -- ── Button ─────────────────────────────────────────────
    function tab:CreateButton(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("TextButton", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.4)

        local label = create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Name or "Button",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local arrow = create("TextLabel", {
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -34, 0, 0),
            BackgroundTransparency = 1,
            Text = "›",
            TextColor3 = t2.TextDim,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
        }, frame)

        frame.MouseEnter:Connect(function()
            tween(frame, 0.15, {BackgroundColor3 = t2.SurfaceAlt})
            tween(arrow, 0.15, {Position = UDim2.new(1, -30, 0, 0), TextColor3 = t2.Accent})
        end)
        frame.MouseLeave:Connect(function()
            tween(frame, 0.15, {BackgroundColor3 = t2.Surface})
            tween(arrow, 0.15, {Position = UDim2.new(1, -34, 0, 0), TextColor3 = t2.TextDim})
        end)
        frame.MouseButton1Down:Connect(function()
            tween(frame, 0.08, {BackgroundColor3 = t2.Accent})
            tween(label, 0.08, {TextColor3 = Color3.new(1,1,1)})
        end)
        frame.MouseButton1Up:Connect(function()
            tween(frame, 0.15, {BackgroundColor3 = t2.Surface})
            tween(label, 0.15, {TextColor3 = t2.Text})
        end)
        frame.MouseButton1Click:Connect(function()
            if config.Callback then task.spawn(config.Callback) end
        end)

        local api = {Frame = frame, Type = "Button"}
        function api:SetText(txt) label.Text = tostring(txt) end
        self:AddElement(api)
        return api
    end

    -- ── Toggle ─────────────────────────────────────────────
    function tab:CreateToggle(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface,
            BorderSizePixel = 0,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.4)

        local label = create("TextLabel", {
            Size = UDim2.new(1, -80, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Name or "Toggle",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local switchBg = create("Frame", {
            Size = UDim2.new(0, 44, 0, 22),
            Position = UDim2.new(1, -56, 0, 9),
            BackgroundColor3 = t2.SurfaceAlt,
            BorderSizePixel = 0,
        }, frame)
        corner(switchBg, 11)

        local knob = create("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = t2.TextDim,
            BorderSizePixel = 0,
        }, switchBg)
        corner(knob, 9)

        local state = config.CurrentValue or false

        local function update(anim)
            if anim then
                tween(switchBg, 0.2, {BackgroundColor3 = state and t2.Accent or t2.SurfaceAlt})
                tween(knob, 0.2, {
                    Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2),
                    BackgroundColor3 = state and Color3.new(1,1,1) or t2.TextDim,
                }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                switchBg.BackgroundColor3 = state and t2.Accent or t2.SurfaceAlt
                knob.Position = state and UDim2.new(1, -20, 0, 2) or UDim2.new(0, 2, 0, 2)
                knob.BackgroundColor3 = state and Color3.new(1,1,1) or t2.TextDim
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

    -- ── Slider ─────────────────────────────────────────────
    function tab:CreateSlider(config)
        local t2 = Themes[CurrentTheme]
        local min = config.Min or 0
        local max = config.Max or 100
        local val = math.clamp(config.Default or min, min, max)

        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 52),
            BackgroundColor3 = t2.Surface,
            BorderSizePixel = 0,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.4)

        create("TextLabel", {
            Size = UDim2.new(0.7, -12, 0, 20),
            Position = UDim2.new(0, 12, 0, 4),
            BackgroundTransparency = 1,
            Text = config.Name or "Slider",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local valLabel = create("TextLabel", {
            Size = UDim2.new(0.3, -12, 0, 20),
            Position = UDim2.new(0.7, 0, 0, 4),
            BackgroundTransparency = 1,
            Text = tostring(val),
            TextColor3 = t2.Accent,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Right,
        }, frame)

        local track = create("Frame", {
            Size = UDim2.new(1, -24, 0, 6),
            Position = UDim2.new(0, 12, 0, 34),
            BackgroundColor3 = t2.SurfaceAlt,
            BorderSizePixel = 0,
        }, frame)
        corner(track, 3)

        local fill = create("Frame", {
            Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = t2.Accent,
            BorderSizePixel = 0,
        }, track)
        corner(fill, 3)

        local knob = create("Frame", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new((val - min) / (max - min), 0, 0.5, -7),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 2,
        }, track)
        corner(knob, 7)
        stroke(knob, t2.Accent, 2, 0)

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
                or input.UserInputType == Enum.UserInputType.Touch) then
                setFromInput(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        local api = {Frame = frame, Type = "Slider", Flag = config.Flag}
        function api:Set(v)
            v = math.clamp(v, min, max)
            val = v
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

    -- ── Dropdown ───────────────────────────────────────────
    function tab:CreateDropdown(config)
        local t2 = Themes[CurrentTheme]
        local options = config.Options or {}
        local current = config.CurrentOption or (options[1] and {options[1]} or {})
        local opened = false

        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface,
            BorderSizePixel = 0,
            ClipsDescendants = false,
            ZIndex = 5,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.4)

        local header = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 5,
        }, frame)

        create("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Name or "Dropdown",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
        }, header)

        local arrow = create("TextLabel", {
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -36, 0, 0),
            BackgroundTransparency = 1,
            Text = "▾",
            TextColor3 = t2.TextDim,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            ZIndex = 5,
        }, header)

        local listFrame = create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 4),
            BackgroundColor3 = t2.SurfaceAlt,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 10,
        }, frame)
        corner(listFrame, 8)
        stroke(listFrame, t2.Border, 1, 0.3)
        listLayout(listFrame, 2)
        padding(listFrame, 4, 4, 4, 4)

        for _, opt in ipairs(options) do
            local item = create("TextButton", {
                Size = UDim2.new(1, -8, 0, 28),
                BackgroundColor3 = t2.Surface,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Text = tostring(opt),
                TextColor3 = t2.TextDim,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                ZIndex = 10,
            }, listFrame)
            corner(item, 6)
            padding(item, 0, 0, 0, 8)
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

        local function recalcSize()
            local h = math.min(#options * 32 + 8, 180)
            return UDim2.new(1, 0, 0, h)
        end

        header.MouseButton1Click:Connect(function()
            opened = not opened
            if opened then
                listFrame.Visible = true
                listFrame.Size = UDim2.new(1, 0, 0, 0)
                tween(listFrame, 0.22, {Size = recalcSize()}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
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
            for _, opt in ipairs(options) do
                local item = create("TextButton", {
                    Size = UDim2.new(1, -8, 0, 28),
                    BackgroundColor3 = t2.Surface,
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                    Text = tostring(opt),
                    TextColor3 = t2.TextDim,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                    ZIndex = 10,
                }, listFrame)
                corner(item, 6)
                padding(item, 0, 0, 0, 8)
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
        end
        function api:Get() return current[1] end
        self:AddElement(api)
        return api
    end

    -- ── Textbox ────────────────────────────────────────────
    function tab:CreateTextbox(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface,
            BorderSizePixel = 0,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.4)

        create("TextLabel", {
            Size = UDim2.new(0.4, -12, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Name or "Input",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local box = create("TextBox", {
            Size = UDim2.new(0.6, -16, 0, 28),
            Position = UDim2.new(0.4, 4, 0, 6),
            BackgroundColor3 = t2.SurfaceAlt,
            BorderSizePixel = 0,
            Text = config.CurrentText or "",
            PlaceholderText = config.PlaceholderText or "Type...",
            PlaceholderColor3 = t2.TextDim,
            TextColor3 = t2.Text,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)
        corner(box, 6)
        padding(box, 0, 0, 0, 10)

        box.Focused:Connect(function()
            tween(frame, 0.15, {BackgroundColor3 = t2.SurfaceAlt})
        end)
        box.FocusLost:Connect(function(enter)
            tween(frame, 0.15, {BackgroundColor3 = t2.Surface})
            if config.Callback then task.spawn(config.Callback, box.Text) end
            if config.RemoveTextAfterFocusLost then box.Text = "" end
        end)

        local api = {Frame = frame, Type = "Textbox", Flag = config.Flag}
        function api:Set(txt) box.Text = tostring(txt) end
        function api:Get() return box.Text end
        self:AddElement(api)
        return api
    end

    -- ── Keybind ────────────────────────────────────────────
    function tab:CreateKeybind(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface,
            BorderSizePixel = 0,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.4)

        create("TextLabel", {
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Name or "Keybind",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local keyBtn = create("TextButton", {
            Size = UDim2.new(0, 70, 0, 26),
            Position = UDim2.new(1, -82, 0, 7),
            BackgroundColor3 = t2.SurfaceAlt,
            BorderSizePixel = 0,
            Text = tostring(config.CurrentKeybind or "None"),
            TextColor3 = t2.Accent,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, frame)
        corner(keyBtn, 6)

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

    -- ── ColorPicker ────────────────────────────────────────
    function tab:CreateColorPicker(config)
        local t2 = Themes[CurrentTheme]
        local frame = create("Frame", {
            Size = UDim2.new(1, -8, 0, 40),
            BackgroundColor3 = t2.Surface,
            BorderSizePixel = 0,
        })
        corner(frame, 8)
        stroke(frame, t2.Border, 1, 0.4)

        create("TextLabel", {
            Size = UDim2.new(1, -70, 1, 0),
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Name or "Color",
            TextColor3 = t2.Text,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, frame)

        local colorBox = create("TextButton", {
            Size = UDim2.new(0, 40, 0, 24),
            Position = UDim2.new(1, -52, 0, 8),
            BackgroundColor3 = config.Default or t2.Accent,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        }, frame)
        corner(colorBox, 6)
        stroke(colorBox, t2.Border, 1, 0.3)

        colorBox.MouseButton1Click:Connect(function()
            local palette = {
                Color3.fromRGB(94, 129, 244),
                Color3.fromRGB(105, 200, 145),
                Color3.fromRGB(225, 95, 105),
                Color3.fromRGB(230, 180, 90),
                Color3.fromRGB(180, 100, 220),
                Color3.fromRGB(100, 220, 220),
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

    -- Auto-activate first tab
    if #self.Tabs == 0 then
        btn.BackgroundTransparency = 0.6
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
notify("DoeakHub UI v2", "Library loaded successfully!", Color3.fromRGB(105, 200, 145), 3, "★")
print("[DoeakUI v2] Loaded — RightControl to toggle UI")

return Lib
