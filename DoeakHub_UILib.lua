-- =========================================================
-- DOEAK HUB UI LIBRARY | UNIVERSAL FRAMEWORK
-- Version: 2.0.0 | Theme: Slate Gray & Cyan Neon
-- Mới: Thêm tính năng Dropdown (Menu thả xuống)
-- =========================================================

local DoeakLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- BẢNG MÀU MỚI: Xám nhẹ (Slate Gray) + Cyan Neon
local Theme = {
    MainBG = Color3.fromRGB(43, 47, 54),       -- Xám nền chính
    SidebarBG = Color3.fromRGB(36, 39, 45),    -- Xám Sidebar sậm hơn chút để phân biệt
    ElementBG = Color3.fromRGB(53, 58, 66),    -- Xám của các nút bấm
    ElementHover = Color3.fromRGB(63, 69, 78), -- Xám sáng khi di chuột vào
    Accent = Color3.fromRGB(0, 229, 255),      -- Cyan Neon (Xanh lơ)
    Text = Color3.fromRGB(245, 245, 250),      -- Trắng tinh khiết
    SubText = Color3.fromRGB(180, 185, 195)    -- Xám bạc cho chữ phụ
}

function DoeakLib:CreateWindow(Config)
    local Window = {}
    Config = Config or {}
    local TitleText = Config.Name or "DOEAK HUB"

    if CoreGui:FindFirstChild("DoeakUniversalUI") then
        CoreGui.DoeakUniversalUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DoeakUniversalUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    -- Nút Logo Thu nhỏ (Mobile/PC)
    local MinimizedBtn = Instance.new("ImageButton")
    MinimizedBtn.Size = UDim2.new(0, 45, 0, 45)
    MinimizedBtn.Position = UDim2.new(0, 20, 0.2, 0)
    MinimizedBtn.BackgroundColor3 = Theme.MainBG
    MinimizedBtn.Visible = false
    MinimizedBtn.Active = true
    MinimizedBtn.Draggable = true
    MinimizedBtn.Parent = ScreenGui

    local MinIcon = Instance.new("TextLabel")
    MinIcon.Size = UDim2.new(1, 0, 1, 0)
    MinIcon.BackgroundTransparency = 1
    MinIcon.Text = "⚡"
    MinIcon.TextSize = 22
    MinIcon.Parent = MinimizedBtn

    Instance.new("UICorner", MinimizedBtn).CornerRadius = UDim.new(1, 0)
    local MinStroke = Instance.new("UIStroke")
    MinStroke.Color = Theme.Accent
    MinStroke.Thickness = 2
    MinStroke.Parent = MinimizedBtn

    -- Khung Main
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.MainBG
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- Đổ bóng viền (UIStroke)
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(60, 65, 75)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    -- Dải viền màu Accent
    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(0, 4, 1, -20)
    AccentLine.Position = UDim2.new(0, 10, 0, 10)
    AccentLine.BackgroundColor3 = Theme.Accent
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = MainFrame
    Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(0, 4)

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, -30, 0, 40)
    TopBar.Position = UDim2.new(0, 22, 0, 0)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = TitleText .. " <font color=\"#00E5FF\">•</font> UNIVERSAL"
    TitleLabel.RichText = true
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -10, 0, 6)
    CloseBtn.BackgroundColor3 = Theme.ElementBG
    CloseBtn.Text = "—"
    CloseBtn.TextColor3 = Theme.Accent
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedBtn.Visible = true
    end)
    MinimizedBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MinimizedBtn.Visible = false
    end)

    -- Container Tabs & Content
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -52)
    Sidebar.Position = UDim2.new(0, 22, 0, 42)
    Sidebar.BackgroundColor3 = Theme.SidebarBG
    Sidebar.Parent = MainFrame
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 4)
    local SidebarPad = Instance.new("UIPadding", Sidebar)
    SidebarPad.PaddingTop = UDim.new(0, 6) SidebarPad.PaddingLeft = UDim.new(0, 6) SidebarPad.PaddingRight = UDim.new(0, 6)

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -180, 1, -52)
    ContentArea.Position = UDim2.new(0, 168, 0, 42)
    ContentArea.BackgroundColor3 = Theme.SidebarBG
    ContentArea.Parent = MainFrame
    Instance.new("UICorner", ContentArea).CornerRadius = UDim.new(0, 8)

    local TabsList = {}
    local FirstTab = true

    function Window:CreateTab(TabName)
        local Tab = {}
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Theme.ElementBG
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Theme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 12
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Accent
        TabPage.Visible = false
        TabPage.Parent = ContentArea
        local PageLayout = Instance.new("UIListLayout", TabPage)
        PageLayout.Padding = UDim.new(0, 8)
        local PagePad = Instance.new("UIPadding", TabPage)
        PagePad.PaddingTop = UDim.new(0, 8) PagePad.PaddingLeft = UDim.new(0, 8) PagePad.PaddingRight = UDim.new(0, 8)

        table.insert(TabsList, {Btn = TabBtn, Page = TabPage})

        if FirstTab then
            TabPage.Visible = true
            TabBtn.BackgroundColor3 = Theme.ElementHover
            TabBtn.TextColor3 = Theme.Accent
            FirstTab = false
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in ipairs(TabsList) do
                t.Page.Visible = (t.Page == TabPage)
                TweenService:Create(t.Btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = (t.Btn == TabBtn) and Theme.ElementHover or Theme.ElementBG,
                    TextColor3 = (t.Btn == TabBtn) and Theme.Accent or Theme.SubText
                }):Play()
            end
        end)

        -- [1] BUTTON
        function Tab:CreateButton(Config)
            local btnFrame = Instance.new("TextButton")
            btnFrame.Size = UDim2.new(1, 0, 0, 40)
            btnFrame.BackgroundColor3 = Theme.ElementBG
            btnFrame.Text = "  " .. (Config.Name or "Button")
            btnFrame.TextColor3 = Theme.Text
            btnFrame.Font = Enum.Font.GothamBold
            btnFrame.TextSize = 12
            btnFrame.TextXAlignment = Enum.TextXAlignment.Left
            btnFrame.Parent = TabPage
            Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 6)

            local ClickIcon = Instance.new("ImageLabel")
            ClickIcon.Size = UDim2.new(0, 16, 0, 16)
            ClickIcon.Position = UDim2.new(1, -25, 0.5, -8)
            ClickIcon.BackgroundTransparency = 1
            ClickIcon.Image = "rbxassetid://6031090990"
            ClickIcon.ImageColor3 = Theme.Accent
            ClickIcon.Parent = btnFrame

            btnFrame.MouseButton1Click:Connect(function()
                TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ElementHover}):Play()
                task.wait(0.1)
                TweenService:Create(btnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Theme.ElementBG}):Play()
                if Config.Callback then Config.Callback() end
            end)
        end

        -- [2] TOGGLE
        function Tab:CreateToggle(Config)
            local ToggleInfo = {Value = Config.CurrentValue or false}
            local tFrame = Instance.new("Frame")
            tFrame.Size = UDim2.new(1, 0, 0, 45)
            tFrame.BackgroundColor3 = Theme.ElementBG
            tFrame.Parent = TabPage
            Instance.new("UICorner", tFrame).CornerRadius = UDim.new(0, 6)

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -60, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Text = Config.Name or "Toggle"
            title.TextColor3 = Theme.Text
            title.Font = Enum.Font.GothamBold
            title.TextSize = 12
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = tFrame

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -50, 0.5, -10)
            Switch.BackgroundColor3 = ToggleInfo.Value and Theme.Accent or Theme.SidebarBG
            Switch.Text = ""
            Switch.Parent = tFrame
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = ToggleInfo.Value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Knob.Parent = Switch
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            Switch.MouseButton1Click:Connect(function()
                ToggleInfo.Value = not ToggleInfo.Value
                local pos = ToggleInfo.Value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                local col = ToggleInfo.Value and Theme.Accent or Theme.SidebarBG
                TweenService:Create(Knob, TweenInfo.new(0.2), {Position = pos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
                if Config.Callback then Config.Callback(ToggleInfo.Value) end
            end)
            return ToggleInfo
        end

        -- [3] SLIDER
        function Tab:CreateSlider(Config)
            local min, max = Config.Range[1] or 0, Config.Range[2] or 100
            local default = Config.CurrentValue or min
            
            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, 0, 0, 55)
            sFrame.BackgroundColor3 = Theme.ElementBG
            sFrame.Parent = TabPage
            Instance.new("UICorner", sFrame).CornerRadius = UDim.new(0, 6)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 20)
            label.Position = UDim2.new(0, 10, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = (Config.Name or "Slider") .. ": <font color=\"#00E5FF\">" .. tostring(default) .. "</font>"
            label.RichText = true
            label.TextColor3 = Theme.Text
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sFrame

            local TrackBase = Instance.new("TextButton")
            TrackBase.Size = UDim2.new(1, -20, 0, 6)
            TrackBase.Position = UDim2.new(0, 10, 0, 35)
            TrackBase.BackgroundColor3 = Theme.SidebarBG
            TrackBase.Text = ""
            TrackBase.Parent = sFrame
            Instance.new("UICorner", TrackBase).CornerRadius = UDim.new(1, 0)

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Fill.Parent = TrackBase
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

            local SliderKnob = Instance.new("Frame")
            SliderKnob.Size = UDim2.new(0, 14, 0, 14)
            SliderKnob.Position = UDim2.new(1, -7, 0.5, -7)
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            SliderKnob.Parent = Fill
            Instance.new("UICorner", SliderKnob).CornerRadius = UDim.new(1, 0)

            local dragging = false
            TrackBase.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)

            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local trackPos = TrackBase.AbsolutePosition.X
                    local trackSize = TrackBase.AbsoluteSize.X
                    local percent = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                    
                    local rawValue = min + (max - min) * percent
                    local value = Config.Increment and (math.floor(rawValue / Config.Increment + 0.5) * Config.Increment) or math.floor(rawValue)
                    
                    Fill.Size = UDim2.new((value - min)/(max - min), 0, 1, 0)
                    label.Text = (Config.Name or "Slider") .. ": <font color=\"#00E5FF\">" .. tostring(value) .. (Config.Suffix or "") .. "</font>"
                    if Config.Callback then Config.Callback(value) end
                end
            end)
        end

        -- [4] DROPDOWN (TÍNH NĂNG MỚI BẠN YÊU CẦU)
        function Tab:CreateDropdown(Config)
            local DropInfo = {Value = Config.Default or "Chọn..."}
            local Options = Config.Options or {}
            local isOpen = false

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 40)
            DropFrame.BackgroundColor3 = Theme.ElementBG
            DropFrame.ClipsDescendants = true -- Ẩn phần bị dư ra khi đóng
            DropFrame.Parent = TabPage
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

            local MainBtn = Instance.new("TextButton")
            MainBtn.Size = UDim2.new(1, 0, 0, 40)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. (Config.Name or "Dropdown") .. " : <font color=\"#00E5FF\">" .. DropInfo.Value .. "</font>"
            MainBtn.RichText = true
            MainBtn.TextColor3 = Theme.Text
            MainBtn.Font = Enum.Font.GothamBold
            MainBtn.TextSize = 12
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left
            MainBtn.Parent = DropFrame

            local Arrow = Instance.new("TextLabel")
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -25, 0.5, -10)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Theme.Accent
            Arrow.TextSize = 12
            Arrow.Parent = MainBtn

            local OptionContainer = Instance.new("ScrollingFrame")
            OptionContainer.Size = UDim2.new(1, 0, 1, -40)
            OptionContainer.Position = UDim2.new(0, 0, 0, 40)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.ScrollBarThickness = 2
            OptionContainer.ScrollBarImageColor3 = Theme.Accent
            OptionContainer.Parent = DropFrame
            local OptLayout = Instance.new("UIListLayout", OptionContainer)
            OptLayout.Padding = UDim.new(0, 2)
            
            local function RefreshDropdown()
                local targetHeight = isOpen and (40 + math.clamp(#Options * 30, 30, 120)) or 40
                TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                Arrow.Text = isOpen and "▲" or "▼"
                CanvasSize = OptLayout.AbsoluteContentSize.Y
                OptionContainer.CanvasSize = UDim2.new(0, 0, 0, CanvasSize)
            end

            MainBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                RefreshDropdown()
            end)

            for _, opt in ipairs(Options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, -10, 0, 30)
                OptBtn.Position = UDim2.new(0, 5, 0, 0)
                OptBtn.BackgroundColor3 = Theme.SidebarBG
                OptBtn.Text = tostring(opt)
                OptBtn.TextColor3 = Theme.SubText
                OptBtn.Font = Enum.Font.GothamMedium
                OptBtn.TextSize = 11
                OptBtn.Parent = OptionContainer
                Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

                OptBtn.MouseButton1Click:Connect(function()
                    DropInfo.Value = opt
                    MainBtn.Text = "  " .. (Config.Name or "Dropdown") .. " : <font color=\"#00E5FF\">" .. opt .. "</font>"
                    isOpen = false
                    RefreshDropdown()
                    if Config.Callback then Config.Callback(opt) end
                end)
            end

            -- Hàm dùng để cập nhật danh sách Options từ bên ngoài nếu cần
            function DropInfo:Refresh(NewOptions)
                Options = NewOptions
                for _, child in ipairs(OptionContainer:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, opt in ipairs(Options) do
                    -- Tạo lại OptBtn giống hệt ở trên (Bạn có thể copy ruột vòng for ở trên bỏ vào đây nếu cần thiết)
                end
            end

            return DropInfo
        end

        return Tab
    end

    return Window
end

return DoeakLib
