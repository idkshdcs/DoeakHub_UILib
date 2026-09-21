-- =========================================================
-- DOEAK HUB UI LIBRARY | UNIVERSAL FRAMEWORK
-- Version: 3.0.0 | Theme: Obsidian Gray + Silver + Gold
-- Components: Window, Tab, Button, Toggle, Slider, Dropdown,
--             Textbox, Keybind, Label, Divider, Section,
--             Notification, ColorPicker
-- =========================================================

local DoeakLib = {}
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local Players           = game:GetService("Players")
local CoreGui           = game:GetService("CoreGui")

-- =========================================================
-- PARENT AN TOÀN (fix cho Madium)
-- =========================================================
local function getSafeParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end

    local ok2, cg = pcall(function() return CoreGui end)
    if ok2 and cg then
        local ok3 = pcall(function() local t = cg.Name end)
        if ok3 then return cg end
    end

    return Players.LocalPlayer:WaitForChild("PlayerGui")
end
local UIParent = getSafeParent()

-- =========================================================
-- THEME: OBSIDIAN GRAY + SILVER + GOLD
-- =========================================================
local Theme = {
    -- Nền
    MainBG      = Color3.fromRGB(20, 20, 24),
    SidebarBG   = Color3.fromRGB(15, 15, 18),
    ContentBG   = Color3.fromRGB(26, 26, 31),
    ElementBG   = Color3.fromRGB(34, 34, 40),
    ElementHi   = Color3.fromRGB(48, 48, 56),
    ElementSel  = Color3.fromRGB(60, 60, 70),

    -- Viền
    Stroke      = Color3.fromRGB(58, 58, 68),
    StrokeHi    = Color3.fromRGB(90, 90, 105),

    -- Accent
    Accent      = Color3.fromRGB(185, 190, 200),   -- Bạc
    AccentDim   = Color3.fromRGB(140, 145, 155),
    Gold        = Color3.fromRGB(255, 200, 60),    -- Vàng highlight
    Green       = Color3.fromRGB(90, 210, 140),
    Red         = Color3.fromRGB(230, 95, 95),

    -- Chữ
    Text        = Color3.fromRGB(240, 240, 245),
    SubText     = Color3.fromRGB(150, 155, 165),
    Muted       = Color3.fromRGB(100, 105, 115),
}

-- =========================================================
-- HELPER
-- =========================================================
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = type(r) == "number" and UDim.new(0, r) or r
    c.Parent = p
    return c
end
local function round(p)
    return corner(p, UDim.new(1, 0))
end
local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or Theme.Stroke
    s.Thickness = th or 1
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end
local function padding(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0, t or 0)
    u.PaddingBottom = UDim.new(0, b or 0)
    u.PaddingLeft = UDim.new(0, l or 0)
    u.PaddingRight = UDim.new(0, r or 0)
    u.Parent = p
    return u
end
local function gradient(p, colors, rot, transparency)
    local g = Instance.new("UIGradient")
    g.Color = colors
    g.Rotation = rot or 0
    if transparency then g.Transparency = transparency end
    g.Parent = p
    return g
end
local function tween(obj, t, props, style, dir)
    local ti = TweenInfo.new(
        t,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    local tw = TweenService:Create(obj, ti, props)
    tw:Play()
    return tw
end

-- =========================================================
-- NOTIFICATION SYSTEM
-- =========================================================
local NotifyHolder = Instance.new("Frame")
NotifyHolder.Name = "NotifyHolder"
NotifyHolder.Size = UDim2.new(0, 300, 1, 0)
NotifyHolder.Position = UDim2.new(1, -320, 0, 0)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.ZIndex = 999

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Parent = NotifyHolder
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifyLayout.Padding = UDim.new(0, 8)

local function Notify(title, text, color, duration)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 56)
    n.BackgroundColor3 = Theme.ElementBG
    n.BorderSizePixel = 0
    n.Parent = NotifyHolder
    corner(n, 10)
    local ns = stroke(n, color or Theme.Accent, 1.5, 0.2)

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, -14)
    accent.Position = UDim2.new(0, 6, 0, 7)
    accent.BackgroundColor3 = color or Theme.Accent
    accent.BorderSizePixel = 0
    accent.Parent = n
    corner(accent, 3)

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -24, 0, 18)
    t.Position = UDim2.new(0, 16, 0, 8)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Theme.Text
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = n

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -24, 0, 16)
    d.Position = UDim2.new(0, 16, 0, 28)
    d.BackgroundTransparency = 1
    d.Text = text or ""
    d.TextColor3 = Theme.SubText
    d.Font = Enum.Font.Gotham
    d.TextSize = 10
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = n

    -- Slide-in
    n.Position = UDim2.new(1, 20, 0, 0)
    tween(n, 0.35, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    task.delay(duration or 3, function()
        tween(n, 0.3, {
            Position = UDim2.new(1, 20, 0, 0),
            BackgroundTransparency = 1
        }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        tween(ns, 0.3, {Transparency = 1})
        tween(t, 0.3, {TextTransparency = 1})
        tween(d, 0.3, {TextTransparency = 1})
        tween(accent, 0.3, {BackgroundTransparency = 1})
        task.wait(0.35)
        n:Destroy()
    end)
end

DoeakLib.Notify = Notify

-- =========================================================
-- WINDOW
-- =========================================================
function DoeakLib:CreateWindow(Config)
    Config = Config or {}
    local Window = {}
    local TitleText = Config.Name or "DOEAK HUB"
    local SubtitleText = Config.Subtitle or "Universal Framework v3"
    local AuthorText = Config.Author

    -- Clear cũ
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
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Notify holder attach
    NotifyHolder.Parent = ScreenGui

    -- ===== FLOATING RESTORE BUTTON =====
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 52, 0, 52)
    MinBtn.Position = UDim2.new(0, 24, 0.4, 0)
    MinBtn.BackgroundColor3 = Theme.SidebarBG
    MinBtn.Text = "⚡"
    MinBtn.TextSize = 24
    MinBtn.TextColor3 = Theme.Gold
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.AutoButtonColor = false
    MinBtn.Visible = false
    MinBtn.Active = true
    MinBtn.Draggable = true
    MinBtn.Parent = ScreenGui
    round(MinBtn)
    local minStroke = stroke(MinBtn, Theme.AccentDim, 2, 0.1)
    gradient(MinBtn, ColorSequence.new(Theme.ElementBG, Theme.SidebarBG), 45)

    -- ===== MAIN FRAME =====
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 620, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
    MainFrame.BackgroundColor3 = Theme.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    corner(MainFrame, 14)
    local mainStroke = stroke(MainFrame, Theme.StrokeHi, 1.5, 0.35)
    gradient(MainFrame,
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 28)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 19)),
        }, 45)

    -- Drop shadow giả (viền mờ bên ngoài)
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 8, 1, 8)
    Shadow.Position = UDim2.new(0, -4, 0, -4)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.7
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    corner(Shadow, 18)

    -- ===== HEADER =====
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, -24, 0, 56)
    Header.Position = UDim2.new(0, 12, 0, 12)
    Header.BackgroundColor3 = Theme.SidebarBG
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    corner(Header, 10)
    local headerStroke = stroke(Header, Theme.Stroke, 1, 0.5)
    gradient(Header,
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 38)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 32, 38)),
        }, 15)

    -- Accent bar
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, -16)
    accentBar.Position = UDim2.new(0, 6, 0, 8)
    accentBar.BackgroundColor3 = Theme.Gold
    accentBar.BorderSizePixel = 0
    accentBar.Parent = Header
    corner(accentBar, 4)
    gradient(accentBar,
        ColorSequence.new{
            ColorSequenceKeypoint.new(0, Theme.Gold),
            ColorSequenceKeypoint.new(1, Theme.Accent),
        }, 90)

    -- Title
    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, -160, 0, 22)
    TitleLbl.Position = UDim2.new(0, 22, 0, 8)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = TitleText .. "  <font color=\"#FFC83C\">◆</font>  <font color=\"#B9BEC8\">UNIVERSAL</font>"
    TitleLbl.RichText = true
    TitleLbl.TextColor3 = Theme.Text
    TitleLbl.TextSize = 15
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    TitleLbl.Parent = Header

    local SubLbl = Instance.new("TextLabel")
    SubLbl.Size = UDim2.new(1, -160, 0, 14)
    SubLbl.Position = UDim2.new(0, 22, 0, 30)
    SubLbl.BackgroundTransparency = 1
    SubLbl.Text = SubtitleText .. (AuthorText and (" • by " .. AuthorText) or "")
    SubLbl.TextColor3 = Theme.SubText
    SubLbl.TextSize = 10
    SubLbl.Font = Enum.Font.Gotham
    SubLbl.TextXAlignment = Enum.TextXAlignment.Left
    SubLbl.Parent = Header

    -- Nút minimize
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

    -- Nút close
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

    -- Hover effects
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

    BtnClose.MouseButton1Click:Connect(function()
        tween(MainFrame, 0.25, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
        task.wait(0.26)
        ScreenGui:Destroy()
    end)
    BtnMin.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinBtn.Visible = true
    end)
    MinBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MinBtn.Visible = false
    end)

    -- ===== SIDEBAR =====
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -92)
    Sidebar.Position = UDim2.new(0, 12, 0, 80)
    Sidebar.BackgroundColor3 = Theme.SidebarBG
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame
    corner(Sidebar, 10)
    stroke(Sidebar, Theme.Stroke, 1, 0.5)

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Parent = Sidebar
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Padding = UDim.new(0, 5)
    padding(Sidebar, 8, 8, 8, 8)

    -- Footer info trong sidebar
    local FootFrame = Instance.new("Frame")
    FootFrame.Size = UDim2.new(1, 0, 0, 40)
    FootFrame.BackgroundColor3 = Theme.ElementBG
    FootFrame.BorderSizePixel = 0
    FootFrame.Parent = Sidebar
    corner(FootFrame, 8)
    local footStroke = stroke(FootFrame, Theme.Stroke, 1, 0.5)

    local FootLbl = Instance.new("TextLabel")
    FootLbl.Size = UDim2.new(1, -16, 1, 0)
    FootLbl.Position = UDim2.new(0, 8, 0, 0)
    FootLbl.BackgroundTransparency = 1
    FootLbl.Text = "v3.0 • Slate Edition"
    FootLbl.TextColor3 = Theme.Muted
    FootLbl.Font = Enum.Font.GothamMedium
    FootLbl.TextSize = 10
    FootLbl.TextXAlignment = Enum.TextXAlignment.Left
    FootLbl.Parent = FootFrame

    -- ===== CONTENT =====
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -196, 1, -92)
    Content.Position = UDim2.new(0, 184, 0, 80)
    Content.BackgroundColor3 = Theme.ContentBG
    Content.BorderSizePixel = 0
    Content.Parent = MainFrame
    corner(Content, 10)
    stroke(Content, Theme.Stroke, 1, 0.5)

    local ContentPad = padding(Content, 10, 10, 10, 10)

    -- ===== TAB SYSTEM =====
    local TabsList = {}
    local FirstTab = true
    local TabCounter = 0

    function Window:CreateTab(TabName, TabIcon)
        TabCounter = TabCounter + 1
        local Tab = {}
        local id = TabCounter

        -- Tab button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundColor3 = Theme.ElementBG
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = "  " .. (TabIcon or "◈") .. "   " .. TabName
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 12
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = Sidebar
        corner(TabBtn, 8)

        -- Accent bar bên trái
        local Accent = Instance.new("Frame")
        Accent.Size = UDim2.new(0, 3, 0, 0)
        Accent.Position = UDim2.new(0, 0, 0.5, 0)
        Accent.AnchorPoint = Vector2.new(0, 0.5)
        Accent.BackgroundColor3 = Theme.Gold
        Accent.BorderSizePixel = 0
        Accent.Parent = TabBtn
        corner(Accent, 3)
        gradient(Accent,
            ColorSequence.new{
                ColorSequenceKeypoint.new(0, Theme.Gold),
                ColorSequenceKeypoint.new(1, Theme.Accent),
            }, 90)

        -- Page
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.ScrollBarImageTransparency = 0.4
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = false
        TabPage.Parent = Content
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = TabPage
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        padding(TabPage, 4, 12, 0, 4)

        table.insert(TabsList, {Btn = TabBtn, Page = TabPage, Accent = Accent})

        -- Active first tab
        if FirstTab then
            TabPage.Visible = true
            TabBtn.BackgroundColor3 = Theme.ElementHi
            TabBtn.TextColor3 = Theme.Accent
            Accent.Size = UDim2.new(0, 3, 0, 22)
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
                t.Page.Visible = active
                tween(t.Btn, 0.22, {
                    BackgroundColor3 = active and Theme.ElementHi or Theme.ElementBG,
                    TextColor3 = active and Theme.Accent or Theme.SubText,
                })
                tween(t.Accent, 0.22, {
                    Size = active and UDim2.new(0, 3, 0, 22) or UDim2.new(0, 3, 0, 0)
                })
            end
        end)

        -- ====================================================
        -- [1] SECTION (Tiêu đề nhóm)
        -- ====================================================
        function Tab:CreateSection(Text)
            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, -8, 0, 30)
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
            lbl.TextColor3 = Theme.Gold
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = sec

            return sec
        end

        -- ====================================================
        -- [2] LABEL
        -- ====================================================
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

        -- ====================================================
        -- [3] BUTTON
        -- ====================================================
        function Tab:CreateButton(Config)
            Config = Config or {}
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 42)
            btn.BackgroundColor3 = Theme.ElementBG
            btn.BorderSizePixel = 0
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.Parent = TabPage
            corner(btn, 8)
            local btnStroke = stroke(btn, Theme.Stroke, 1, 0.4)

            -- Text
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -50, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = Config.Name or "Button"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = btn

            -- Icon arrow
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 30, 1, 0)
            arrow.Position = UDim2.new(1, -36, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "›"
            arrow.TextColor3 = Theme.Accent
            arrow.TextSize = 18
            arrow.Font = Enum.Font.GothamBold
            arrow.Parent = btn

            btn.MouseEnter:Connect(function()
                tween(btn, 0.15, {BackgroundColor3 = Theme.ElementHi})
                tween(btnStroke, 0.15, {Color = Theme.Accent, Transparency = 0.2})
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, 0.15, {BackgroundColor3 = Theme.ElementBG})
                tween(btnStroke, 0.15, {Color = Theme.Stroke, Transparency = 0.4})
            end)

            btn.MouseButton1Click:Connect(function()
                tween(btn, 0.08, {BackgroundColor3 = Theme.ElementSel})
                task.wait(0.08)
                tween(btn, 0.12, {BackgroundColor3 = Theme.ElementHi})
                pcall(function() if Config.Callback then Config.Callback() end end)
            end)

            return btn
        end

        -- ====================================================
        -- [4] TOGGLE
        -- ====================================================
        function Tab:CreateToggle(Config)
            Config = Config or {}
            local state = Config.CurrentValue or false

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 48)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -80, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = Config.Name or "Toggle"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame

            if Config.Description then
                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -80, 0, 14)
                desc.Position = UDim2.new(0, 14, 1, -18)
                desc.BackgroundTransparency = 1
                desc.Text = Config.Description
                desc.TextColor3 = Theme.Muted
                desc.Font = Enum.Font.Gotham
                desc.TextSize = 9
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Parent = frame
            end

            local switch = Instance.new("TextButton")
            switch.Size = UDim2.new(0, 44, 0, 22)
            switch.Position = UDim2.new(1, -56, 0.5, -11)
            switch.BackgroundColor3 = state and Theme.Green or Theme.ElementBG
            switch.Text = ""
            switch.AutoButtonColor = false
            switch.Parent = frame
            round(switch)
            local swStroke = stroke(switch, state and Theme.Green or Theme.Stroke, 1, 0.3)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 18, 0, 18)
            knob.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            knob.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
            knob.BorderSizePixel = 0
            knob.Parent = switch
            round(knob)

            frame.MouseEnter:Connect(function()
                tween(frame, 0.15, {BackgroundColor3 = Theme.ElementHi})
                tween(fStroke, 0.15, {Color = Theme.StrokeHi})
            end)
            frame.MouseLeave:Connect(function()
                tween(frame, 0.15, {BackgroundColor3 = Theme.ElementBG})
                tween(fStroke, 0.15, {Color = Theme.Stroke})
            end)

            switch.MouseButton1Click:Connect(function()
                state = not state
                tween(knob, 0.22, {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
                tween(switch, 0.22, {BackgroundColor3 = state and Theme.Green or Theme.ElementBG})
                tween(swStroke, 0.22, {Color = state and Theme.Green or Theme.Stroke})
                pcall(function() if Config.Callback then Config.Callback(state) end end)
            end)

            return {
                Value = state,
                Set = function(self, v)
                    state = v
                    tween(knob, 0.22, {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)})
                    tween(switch, 0.22, {BackgroundColor3 = state and Theme.Green or Theme.ElementBG})
                    tween(swStroke, 0.22, {Color = state and Theme.Green or Theme.Stroke})
                    pcall(function() if Config.Callback then Config.Callback(state) end end)
                end
            }
        end

        -- ====================================================
        -- [5] SLIDER
        -- ====================================================
        function Tab:CreateSlider(Config)
            Config = Config or {}
            local min, max = Config.Range[1] or 0, Config.Range[2] or 100
            local default = Config.CurrentValue or min
            local suffix = Config.Suffix or ""
            local inc = Config.Increment

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
            lbl.Text = (Config.Name or "Slider") .. ": <font color=\"#FFC83C\">" .. tostring(default) .. suffix .. "</font>"
            lbl.RichText = true
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame

            local track = Instance.new("TextButton")
            track.Size = UDim2.new(1, -28, 0, 6)
            track.Position = UDim2.new(0, 14, 0, 38)
            track.BackgroundColor3 = Theme.SidebarBG
            track.Text = ""
            track.AutoButtonColor = false
            track.Parent = frame
            round(track)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            fill.BorderSizePixel = 0
            fill.Parent = track
            round(fill)
            gradient(fill,
                ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Theme.AccentDim),
                    ColorSequenceKeypoint.new(0.5, Theme.Accent),
                    ColorSequenceKeypoint.new(1, Theme.Gold),
                }, 0)

            local head = Instance.new("Frame")
            head.Size = UDim2.new(0, 14, 0, 14)
            head.Position = UDim2.new(1, -7, 0.5, -7)
            head.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
            head.BorderSizePixel = 0
            head.Parent = fill
            round(head)
            local hStroke = stroke(head, Theme.Gold, 2, 0)

            local dragging = false
            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mx = UserInputService:GetMouseLocation().X
                    local tx = track.AbsolutePosition.X
                    local tw = track.AbsoluteSize.X
                    if tw <= 0 then return end
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
                    lbl.Text = (Config.Name or "Slider") .. ": <font color=\"#FFC83C\">" .. tostring(value) .. suffix .. "</font>"
                    pcall(function() if Config.Callback then Config.Callback(value) end end)
                end
            end)

            return {
                Set = function(self, v)
                    local pct = math.clamp((v - min) / (max - min), 0, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    lbl.Text = (Config.Name or "Slider") .. ": <font color=\"#FFC83C\">" .. tostring(v) .. suffix .. "</font>"
                end
            }
        end

        -- ====================================================
        -- [6] DROPDOWN
        -- ====================================================
        function Tab:CreateDropdown(Config)
            Config = Config or {}
            local Options = Config.Options or {}
            local current = Config.Default or (Options[1] or "None")
            local isOpen = false

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 46)
            frame.BackgroundColor3 = Theme.ElementBG
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            frame.Parent = TabPage
            corner(frame, 8)
            local fStroke = stroke(frame, Theme.Stroke, 1, 0.4)

            local mainBtn = Instance.new("TextButton")
            mainBtn.Size = UDim2.new(1, 0, 0, 46)
            mainBtn.BackgroundTransparency = 1
            mainBtn.Text = ""
            mainBtn.AutoButtonColor = false
            mainBtn.Parent = frame

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -50, 1, 0)
            lbl.Position = UDim2.new(0, 14, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.RichText = true
            lbl.Text = (Config.Name or "Dropdown") .. ": <font color=\"#FFC83C\">" .. current .. "</font>"
            lbl.TextColor3 = Theme.Text
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = mainBtn

            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 30, 1, 0)
            arrow.Position = UDim2.new(1, -36, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = Theme.Accent
            arrow.TextSize = 11
            arrow.Font = Enum.Font.GothamBold
            arrow.Parent = mainBtn

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size = UDim2.new(1, -12, 0, 0)
            scroll.Position = UDim2.new(0, 6, 0, 46)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel = 0
            scroll.ScrollBarThickness = 3
            scroll.ScrollBarImageColor3 = Theme.Accent
            scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            scroll.Parent = frame
            local sLayout = Instance.new("UIListLayout")
            sLayout.Parent = scroll
            sLayout.Padding = UDim.new(0, 3)

            local function setOpen(open)
                isOpen = open
                local h = open and math.clamp(46 + #Options * 33 + 10, 46, 220) or 46
                tween(frame, 0.25, {Size = UDim2.new(1, -8, 0, h)})
                arrow.Text = open and "▲" or "▼"
            end

            mainBtn.MouseButton1Click:Connect(function()
                setOpen(not isOpen)
            end)

            for _, opt in ipairs(Options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = Theme.SidebarBG
                optBtn.Text = "  " .. tostring(opt)
                optBtn.TextColor3 = Theme.SubText
                optBtn.Font = Enum.Font.GothamMedium
                optBtn.TextSize = 11
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.AutoButtonColor = false
                optBtn.Parent = scroll
                corner(optBtn, 6)

                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, 0.15, {BackgroundColor3 = Theme.ElementHi, TextColor3 = Theme.Accent})
                end)
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, 0.15, {BackgroundColor3 = Theme.SidebarBG, TextColor3 = Theme.SubText})
                end)

                optBtn.MouseButton1Click:Connect(function()
                    current = opt
                    lbl.Text = (Config.Name or "Dropdown") .. ": <font color=\"#FFC83C\">" .. opt .. "</font>"
                    setOpen(false)
                    pcall(function() if Config.Callback then Config.Callback(opt) end end)
                end)
            end

            return {
                Value = current,
                Refresh = function(self, newOptions)
                    Options = newOptions
                    for _, c in ipairs(scroll:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(Options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, 0, 0, 30)
                        optBtn.BackgroundColor3 = Theme.SidebarBG
                        optBtn.Text = "  " .. tostring(opt)
                        optBtn.TextColor3 = Theme.SubText
                        optBtn.Font = Enum.Font.GothamMedium
                        optBtn.TextSize = 11
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.AutoButtonColor = false
                        optBtn.Parent = scroll
                        corner(optBtn, 6)
                        optBtn.MouseButton1Click:Connect(function()
                            current = opt
                            lbl.Text = (Config.Name or "Dropdown") .. ": <font color=\"#FFC83C\">" .. opt .. "</font>"
                            setOpen(false)
                            pcall(function() if Config.Callback then Config.Callback(opt) end end)
                        end)
                    end
                end
            }
        end

        -- ====================================================
        -- [7] TEXTBOX
        -- ====================================================
        function Tab:CreateTextbox(Config)
            Config = Config or {}
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
            box.Text = Config.Default or ""
            box.PlaceholderText = Config.Placeholder or "Nhập..."
            box.PlaceholderColor3 = Theme.Muted
            box.TextColor3 = Theme.Text
            box.Font = Enum.Font.Gotham
            box.TextSize = 12
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.ClearTextOnFocus = false
            box.Parent = frame

            box.Focused:Connect(function()
                tween(fStroke, 0.2, {Color = Theme.Accent, Transparency = 0.1})
            end)
            box.FocusLost:Connect(function()
                tween(fStroke, 0.2, {Color = Theme.Stroke, Transparency = 0.4})
                pcall(function() if Config.Callback then Config.Callback(box.Text) end end)
            end)

            return box
        end

        -- ====================================================
        -- [8] KEYBIND
        -- ====================================================
        function Tab:CreateKeybind(Config)
            Config = Config or {}
            local key = Config.Default or "None"
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
            keyBtn.Size = UDim2.new(0, 78, 0, 28)
            keyBtn.Position = UDim2.new(1, -90, 0.5, -14)
            keyBtn.BackgroundColor3 = Theme.SidebarBG
            keyBtn.Text = key
            keyBtn.TextColor3 = Theme.Accent
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.TextSize = 11
            keyBtn.AutoButtonColor = false
            keyBtn.Parent = frame
            corner(keyBtn, 6)
            stroke(keyBtn, Theme.Stroke, 1, 0.3)

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                keyBtn.TextColor3 = Theme.Gold
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if gp or not listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode.Name
                    keyBtn.Text = key
                    keyBtn.TextColor3 = Theme.Accent
                    listening = false
                    pcall(function() if Config.Callback then Config.Callback(key) end end)
                    if Config.OnPressed and key == input.KeyCode.Name then Config.OnPressed() end
                end
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == key then
                    pcall(function() if Config.OnPressed then Config.OnPressed() end end)
                end
            end)

            return keyBtn
        end

        -- ====================================================
        -- [9] DIVIDER
        -- ====================================================
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

    return Window
end

return DoeakLib
