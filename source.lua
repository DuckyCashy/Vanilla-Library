local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local CoreGui = (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")

local function GetSafeContainer()
    return (gethui and gethui()) or CoreGui
end

local Vanilla = {
    Flags = {},
    Callbacks = {},
    ConfigFolder = "VanillaConfigs",
    ActiveThemeName = "Dark",
    NotificationLower = false,
    Themes = {
        Dark = {
            Name = "Dark",
            Accent = Color3.fromHex("#18181b"),
            Background = Color3.fromHex("#101010"),
            Outline = Color3.fromHex("#27272a"),
            Text = Color3.fromHex("#FFFFFF"),
            SubText = Color3.fromHex("#a1a1aa"),
            Placeholder = Color3.fromHex("#7a7a7a"),
            Button = Color3.fromHex("#27272a"),
            Icon = Color3.fromHex("#a1a1aa"),
            Element = Color3.fromHex("#18181b")
        }
    }
}

Vanilla.CurrentTheme = Vanilla.Themes.Dark

local function MakeDraggable(topbar, frame)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Vanilla:AddTheme(themeData)
    if not themeData or not themeData.Name then return end
    self.Themes[themeData.Name] = {
        Name = themeData.Name,
        Accent = themeData.Accent or Color3.fromRGB(24, 24, 27),
        Background = themeData.Background or Color3.fromRGB(16, 16, 16),
        Outline = themeData.Outline or Color3.fromRGB(255, 255, 255),
        Text = themeData.Text or Color3.fromRGB(255, 255, 255),
        SubText = themeData.SubText or Color3.fromRGB(160, 160, 170),
        Placeholder = themeData.Placeholder or Color3.fromRGB(122, 122, 122),
        Button = themeData.Button or Color3.fromRGB(82, 82, 91),
        Icon = themeData.Icon or Color3.fromRGB(161, 161, 170),
        Element = themeData.Element or Color3.fromRGB(28, 28, 32)
    }
end

function Vanilla:GetThemes()
    return self.Themes
end

function Vanilla:GetCurrentTheme()
    return self.ActiveThemeName
end

function Vanilla:SetTheme(themeName)
    if self.Themes[themeName] then
        self.ActiveThemeName = themeName
        self.CurrentTheme = self.Themes[themeName]
    end
end

function Vanilla:GetTransparency()
    return self.Window and self.Window.IsTransparent or false
end

function Vanilla:ToggleAcrylic(state)
    if self.Window then
        self.Window.Acrylic = state
    end
end

function Vanilla:SetNotificationLower(state)
    self.NotificationLower = state
end

function Vanilla:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""

    local ScreenGui = GetSafeContainer():FindFirstChild("VanillaNotifyGui")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "VanillaNotifyGui"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = GetSafeContainer()
    end

    local Holder = ScreenGui:FindFirstChild("NotifyHolder")
    if not Holder then
        Holder = Instance.new("Frame")
        Holder.Name = "NotifyHolder"
        Holder.Size = UDim2.new(0, 300, 1, 0)
        Holder.Position = self.NotificationLower and UDim2.new(1, -310, 0, 80) or UDim2.new(1, -310, 0, 20)
        Holder.BackgroundTransparency = 1
        Holder.Parent = ScreenGui

        local Layout = Instance.new("UIListLayout")
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        Layout.Padding = UDim.new(0, 8)
        Layout.Parent = Holder
    end

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 60)
    Card.BackgroundColor3 = self.CurrentTheme.Background
    Card.BorderSizePixel = 0
    Card.Parent = Holder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Card

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = self.CurrentTheme.Outline
    Stroke.Transparency = 0.8
    Stroke.Parent = Card

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Size = UDim2.new(1, -16, 0, 24)
    TitleLabel.Position = UDim2.new(0, 12, 0, 6)
    TitleLabel.TextColor3 = self.CurrentTheme.Text
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Card

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Text = content
    ContentLabel.Size = UDim2.new(1, -16, 0, 24)
    ContentLabel.Position = UDim2.new(0, 12, 0, 28)
    ContentLabel.TextColor3 = self.CurrentTheme.SubText
    ContentLabel.Font = Enum.Font.SourceSans
    ContentLabel.TextSize = 13
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Parent = Card

    task.delay(4, function()
        TweenService:Create(Card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(ContentLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        Card:Destroy()
    end)
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

function Vanilla:CreateWindow(options)
    options = options or {}
    local windowTitle = options.Title or "Vanilla Hub"
    local author = options.Author and (" " .. options.Author) or ""
    local themeName = options.Theme or "Dark"
    local size = options.Size or UDim2.fromOffset(680, 460)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    local sidebarWidth = options.SideBarWidth or 200

    if options.Folder then
        self.ConfigFolder = options.Folder
    end
    if self.Themes[themeName] then
        self:SetTheme(themeName)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanillaWindowGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetSafeContainer()

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = size
    Main.Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    Main.BackgroundColor3 = self.CurrentTheme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = self.CurrentTheme.Outline
    MainStroke.Transparency = 0.85
    MainStroke.Parent = Main
    
    local topbarHeight = (options.Topbar and options.Topbar.Height) or 44
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, topbarHeight)
    TopBar.BackgroundColor3 = self.CurrentTheme.Accent
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = windowTitle .. author
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 14, 0, 0)
    TitleLabel.TextColor3 = self.CurrentTheme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 15
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    MakeDraggable(TopBar, Main)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, sidebarWidth, 1, -(topbarHeight + 10))
    TabContainer.Position = UDim2.new(0, 8, 0, topbarHeight + 5)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Main

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 4)
    TabList.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -(sidebarWidth + 24), 1, -(topbarHeight + 10))
    ContentContainer.Position = UDim2.new(0, sidebarWidth + 14, 0, topbarHeight + 5)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main

    local OpenBtnFrame
    if options.OpenButton and options.OpenButton.Enabled then
        OpenBtnFrame = Instance.new("TextButton")
        OpenBtnFrame.Name = "VanillaOpenButton"
        OpenBtnFrame.Size = UDim2.fromOffset(100, 36)
        OpenBtnFrame.Position = UDim2.new(0, 20, 0.5, -18)
        OpenBtnFrame.BackgroundColor3 = self.CurrentTheme.Background
        OpenBtnFrame.Text = options.OpenButton.Title or "Open Hub"
        OpenBtnFrame.TextColor3 = self.CurrentTheme.Text
        OpenBtnFrame.Font = Enum.Font.SourceSansBold
        OpenBtnFrame.TextSize = 14
        OpenBtnFrame.Visible = false
        OpenBtnFrame.Parent = ScreenGui

        local OpenCorner = Instance.new("UICorner")
        OpenCorner.CornerRadius = options.OpenButton.CornerRadius or UDim.new(0, 8)
        OpenCorner.Parent = OpenBtnFrame

        MakeDraggable(OpenBtnFrame, OpenBtnFrame)
        OpenBtnFrame.MouseButton1Click:Connect(function()
            Main.Visible = true
            OpenBtnFrame.Visible = false
        end)
    end

    local windowObj = setmetatable({
        Gui = ScreenGui,
        Main = Main,
        OpenBtn = OpenBtnFrame,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        ToggleKey = toggleKey,
        IsTransparent = options.Transparent or false,
        Acrylic = options.Acrylic or false,
        ActiveTab = nil
    }, Window)

    Vanilla.Window = windowObj
    return windowObj
end

function Window:Toggle()
    self.Main.Visible = not self.Main.Visible
    if self.OpenBtn then
        self.OpenBtn.Visible = not self.Main.Visible
    end
end

function Window:ToggleTransparency(state)
    self.IsTransparent = state
    self.Main.BackgroundTransparency = state and 0.35 or 0
end

function Window:SetToggleKey(key)
    self.ToggleKey = key
end

function Window:Tab(options)
    options = options or {}
    local tabTitle = options.Title or "Tab"

    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = Vanilla.CurrentTheme.Element
    TabButton.TextColor3 = Vanilla.CurrentTheme.SubText
    TabButton.Text = tabTitle
    TabButton.Font = Enum.Font.SourceSans
    TabButton.TextSize = 14
    TabButton.Parent = self.TabContainer

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = TabButton

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 2
    TabPage.Parent = self.ContentContainer

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 6)
    PageList.Parent = TabPage

    local tabObj = setmetatable({
        Button = TabButton,
        Page = TabPage,
        Window = self
    }, Tab)

    TabButton.MouseButton1Click:Connect(function()
        if self.ActiveTab then
            self.ActiveTab.Page.Visible = false
            TweenService:Create(self.ActiveTab.Button, TweenInfo.new(0.2), {TextColor3 = Vanilla.CurrentTheme.SubText, BackgroundColor3 = Vanilla.CurrentTheme.Element}):Play()
        end
        self.ActiveTab = tabObj
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Vanilla.CurrentTheme.Text, BackgroundColor3 = Vanilla.CurrentTheme.Button}):Play()
    end)

    if not self.ActiveTab then
        self.ActiveTab = tabObj
        TabPage.Visible = true
        TabButton.TextColor3 = Vanilla.CurrentTheme.Text
        TabButton.BackgroundColor3 = Vanilla.CurrentTheme.Button
    end

    return tabObj
end

function Tab:Dropdown(options)
    options = options or {}
    local title = options.Title or "Dropdown"
    local values = options.Values or {}
    local currentValue = options.Value or values[1] or ""
    local callback = options.Callback or function() end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 36)
    Frame.BackgroundColor3 = Vanilla.CurrentTheme.Element
    Frame.ClipsDescendants = true
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = title
    Label.Size = UDim2.new(0.5, 0, 0, 36)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextColor3 = Vanilla.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local SelectedBtn = Instance.new("TextButton")
    SelectedBtn.Text = tostring(currentValue)
    SelectedBtn.Size = UDim2.new(0.45, 0, 0, 26)
    SelectedBtn.Position = UDim2.new(0.52, 0, 0, 5)
    SelectedBtn.BackgroundColor3 = Vanilla.CurrentTheme.Button
    SelectedBtn.TextColor3 = Vanilla.CurrentTheme.Text
    SelectedBtn.Font = Enum.Font.SourceSans
    SelectedBtn.TextSize = 13
    SelectedBtn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = SelectedBtn

    local isOpen = false
    SelectedBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        Frame.Size = isOpen and UDim2.new(1, -6, 0, 36 + (#values * 28)) or UDim2.new(1, -6, 0, 36)
    end)

    for i, val in ipairs(values) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Text = tostring(val)
        ItemBtn.Size = UDim2.new(1, -20, 0, 24)
        ItemBtn.Position = UDim2.new(0, 10, 0, 36 + ((i - 1) * 28))
        ItemBtn.BackgroundColor3 = Vanilla.CurrentTheme.Background
        ItemBtn.TextColor3 = Vanilla.CurrentTheme.SubText
        ItemBtn.Font = Enum.Font.SourceSans
        ItemBtn.TextSize = 13
        ItemBtn.Parent = Frame

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 4)
        ItemCorner.Parent = ItemBtn

        ItemBtn.MouseButton1Click:Connect(function()
            currentValue = val
            SelectedBtn.Text = tostring(val)
            isOpen = false
            Frame.Size = UDim2.new(1, -6, 0, 36)
            task.spawn(callback, val)
        end)
    end
end

function Tab:Toggle(options)
    options = options or {}
    local title = options.Title or "Toggle"
    local state = options.Value or false
    local callback = options.Callback or function() end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 36)
    Frame.BackgroundColor3 = Vanilla.CurrentTheme.Element
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = title
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextColor3 = Vanilla.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Box = Instance.new("TextButton")
    Box.Text = ""
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(1, -28, 0.5, -9)
    Box.BackgroundColor3 = state and Vanilla.CurrentTheme.Button or Vanilla.CurrentTheme.Background
    Box.Parent = Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box

    Box.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = state and Vanilla.CurrentTheme.Button or Vanilla.CurrentTheme.Background}):Play()
        task.spawn(callback, state)
    end)
end

function Tab:Keybind(options)
    options = options or {}
    local title = options.Title or "Keybind"
    local currentKey = options.Value or Enum.KeyCode.RightShift
    local callback = options.Callback or function() end

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -6, 0, 36)
    Frame.BackgroundColor3 = Vanilla.CurrentTheme.Element
    Frame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Text = title
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextColor3 = Vanilla.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Text = typeof(currentKey) == "EnumItem" and currentKey.Name or tostring(currentKey)
    KeyBtn.Size = UDim2.new(0.35, -10, 0, 26)
    KeyBtn.Position = UDim2.new(0.65, 0, 0.5, -13)
    KeyBtn.BackgroundColor3 = Vanilla.CurrentTheme.Button
    KeyBtn.TextColor3 = Vanilla.CurrentTheme.Text
    KeyBtn.Font = Enum.Font.SourceSans
    KeyBtn.TextSize = 13
    KeyBtn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = KeyBtn

    local listening = false
    KeyBtn.MouseButton1Click:Connect(function()
        listening = true
        KeyBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            currentKey = input.KeyCode
            KeyBtn.Text = currentKey.Name
            task.spawn(callback, currentKey)
        end
    end)
end

return Vanilla
