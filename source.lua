local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local CoreGui = (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")

local function GetSafeContainer()
    return (gethui and gethui()) or CoreGui
end

local Linoria = {
    Flags = {},
    Callbacks = {},
    Theme = {
        Background = Color3.fromRGB(15, 15, 15),
        MainFrame = Color3.fromRGB(20, 20, 20),
        Groupbox = Color3.fromRGB(24, 24, 24),
        Header = Color3.fromRGB(12, 12, 12),
        Outline = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(0, 230, 255),
        Text = Color3.fromRGB(220, 220, 220),
        SubText = Color3.fromRGB(150, 150, 150)
    }
}

local function MakeDraggable(topbar, frame)
    local dragging, dragInput, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Groupbox = {}
Groupbox.__index = Groupbox

function Linoria:CreateWindow(options)
    options = options or {}
    local windowTitle = options.Title or "Linoria | Game Name"
    local size = options.Size or UDim2.fromOffset(560, 520)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LinoriaUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetSafeContainer()

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = size
    Main.Position = UDim2.new(0.5, -size.X.Offset / 2, 0.5, -size.Y.Offset / 2)
    Main.BackgroundColor3 = self.Theme.MainFrame
    Main.BorderColor3 = self.Theme.Outline
    Main.BorderSizePixel = 1
    Main.Parent = ScreenGui

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 24)
    TopBar.BackgroundColor3 = self.Theme.Header
    TopBar.BorderColor3 = self.Theme.Outline
    TopBar.BorderSizePixel = 1
    TopBar.Parent = Main

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = windowTitle
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 8, 0, 0)
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.TextSize = 13
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = TopBar

    MakeDraggable(TopBar, Main)

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -16, 0, 22)
    TabContainer.Position = UDim2.new(0, 8, 0, 30)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Main

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -16, 1, -60)
    ContentContainer.Position = UDim2.new(0, 8, 0, 54)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main

    return setmetatable({
        Gui = ScreenGui,
        Main = Main,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        ActiveTab = nil
    }, Window)
end

function Window:AddTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 70, 1, 0)
    TabButton.BackgroundColor3 = Linoria.Theme.Header
    TabButton.BorderColor3 = Linoria.Theme.Outline
    TabButton.BorderSizePixel = 1
    TabButton.Text = name
    TabButton.TextColor3 = Linoria.Theme.SubText
    TabButton.Font = Enum.Font.Code
    TabButton.TextSize = 12
    TabButton.Parent = self.TabContainer

    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = self.ContentContainer

    local LeftContainer = Instance.new("ScrollingFrame")
    LeftContainer.Size = UDim2.new(0.49, 0, 1, 0)
    LeftContainer.Position = UDim2.new(0, 0, 0, 0)
    LeftContainer.BackgroundTransparency = 1
    LeftContainer.ScrollBarThickness = 2
    LeftContainer.Parent = Page

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Padding = UDim.new(0, 6)
    LeftLayout.Parent = LeftContainer

    local RightContainer = Instance.new("ScrollingFrame")
    RightContainer.Size = UDim2.new(0.49, 0, 1, 0)
    RightContainer.Position = UDim2.new(0.51, 0, 0, 0)
    RightContainer.BackgroundTransparency = 1
    RightContainer.ScrollBarThickness = 2
    RightContainer.Parent = Page

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.Padding = UDim.new(0, 6)
    RightLayout.Parent = RightContainer

    local tabObj = setmetatable({
        Button = TabButton,
        Page = Page,
        Left = LeftContainer,
        Right = RightContainer,
        Window = self
    }, Tab)

    TabButton.MouseButton1Click:Connect(function()
        if self.ActiveTab then
            self.ActiveTab.Page.Visible = false
            self.ActiveTab.Button.TextColor3 = Linoria.Theme.SubText
            self.ActiveTab.Button.BorderColor3 = Linoria.Theme.Outline
        end
        self.ActiveTab = tabObj
        Page.Visible = true
        TabButton.TextColor3 = Linoria.Theme.Text
        TabButton.BorderColor3 = Linoria.Theme.Accent
    end)

    if not self.ActiveTab then
        self.ActiveTab = tabObj
        Page.Visible = true
        TabButton.TextColor3 = Linoria.Theme.Text
        TabButton.BorderColor3 = Linoria.Theme.Accent
    end

    return tabObj
end

function Tab:AddLeftGroupbox(title) return self:CreateGroupbox(self.Left, title) end
function Tab:AddRightGroupbox(title) return self:CreateGroupbox(self.Right, title) end

function Tab:CreateGroupbox(parentContainer, title)
    local Group = Instance.new("Frame")
    Group.Size = UDim2.new(1, 0, 0, 20)
    Group.AutomaticSize = Enum.AutomaticSize.Y
    Group.BackgroundColor3 = Linoria.Theme.Groupbox
    Group.BorderColor3 = Linoria.Theme.Outline
    Group.BorderSizePixel = 1
    Group.Parent = parentContainer

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 18)
    Header.BackgroundColor3 = Linoria.Theme.Header
    Header.BorderColor3 = Linoria.Theme.Outline
    Header.BorderSizePixel = 1
    Header.Parent = Group

    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 1)
    AccentLine.Position = UDim2.new(0, 0, 1, -1)
    AccentLine.BackgroundColor3 = Linoria.Theme.Accent
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = Header

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 6, 0, 0)
    TitleLabel.TextColor3 = Linoria.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.Code
    TitleLabel.TextSize = 12
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -10, 0, 0)
    Container.Position = UDim2.new(0, 5, 0, 22)
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.BackgroundTransparency = 1
    Container.Parent = Group

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 4)
    Layout.Parent = Container

    local Padding = Instance.new("UIPadding")
    Padding.PaddingBottom = UDim.new(0, 5)
    Padding.Parent = Container

    return setmetatable({ Frame = Group, Container = Container }, Groupbox)
end

function Groupbox:AddToggle(flag, options)
    options = options or {}
    local text = options.Text or "Toggle"
    local default = options.Default or false
    local color = options.Color or Linoria.Theme.Accent
    local callback = options.Callback or function() end

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 16)
    Row.BackgroundTransparency = 1
    Row.Parent = self.Container

    local Box = Instance.new("TextButton")
    Box.Text = ""
    Box.Size = UDim2.new(0, 10, 0, 10)
    Box.Position = UDim2.new(0, 0, 0.5, -5)
    Box.BackgroundColor3 = default and color or Linoria.Theme.MainFrame
    Box.BorderColor3 = Linoria.Theme.Outline
    Box.BorderSizePixel = 1
    Box.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(1, -15, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.TextColor3 = Linoria.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.BackgroundTransparency = 1
    Label.Parent = Row

    local state = default
    Linoria.Flags[flag] = state

    Box.MouseButton1Click:Connect(function()
        state = not state
        Linoria.Flags[flag] = state
        Box.BackgroundColor3 = state and color or Linoria.Theme.MainFrame
        task.spawn(callback, state)
    end)

    local toggleObj = { Row = Row }

    function toggleObj:AddColorPicker(cpFlag, cpOptions)
        cpOptions = cpOptions or {}
        local cpDefault = cpOptions.Default or Color3.fromRGB(255, 255, 255)
        Linoria.Flags[cpFlag] = cpDefault

        local CPBtn = Instance.new("TextButton")
        CPBtn.Text = ""
        CPBtn.Size = UDim2.new(0, 16, 0, 10)
        CPBtn.Position = UDim2.new(1, -16, 0.5, -5)
        CPBtn.BackgroundColor3 = cpDefault
        CPBtn.BorderColor3 = Linoria.Theme.Outline
        CPBtn.BorderSizePixel = 1
        CPBtn.Parent = Row

        return toggleObj
    end

    return toggleObj
end

function Groupbox:AddSlider(flag, options)
    options = options or {}
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local suffix = options.Suffix or ""
    local color = options.Color or Linoria.Theme.Accent
    local callback = options.Callback or function() end

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 24)
    Row.BackgroundTransparency = 1
    Row.Parent = self.Container

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(1, 0, 0, 11)
    Label.TextColor3 = Linoria.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.BackgroundTransparency = 1
    Label.Parent = Row

    local SliderBar = Instance.new("TextButton")
    SliderBar.Text = ""
    SliderBar.Size = UDim2.new(1, 0, 0, 11)
    SliderBar.Position = UDim2.new(0, 0, 0, 12)
    SliderBar.BackgroundColor3 = Linoria.Theme.MainFrame
    SliderBar.BorderColor3 = Linoria.Theme.Outline
    SliderBar.BorderSizePixel = 1
    SliderBar.Parent = Row

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = color
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBar

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Text = string.format("%d%s/%d%s", default, suffix, max, suffix)
    ValueLabel.Size = UDim2.new(1, 0, 1, 0)
    ValueLabel.TextColor3 = Linoria.Theme.Text
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 10
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Parent = SliderBar

    local function Update(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValueLabel.Text = string.format("%d%s/%d%s", val, suffix, max, suffix)
        Linoria.Flags[flag] = val
        task.spawn(callback, val)
    end

    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function Groupbox:AddDropdown(flag, options)
    options = options or {}
    local text = options.Text or "Dropdown"
    local values = options.Values or {}
    local default = options.Default or values[1] or ""

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 26)
    Row.BackgroundTransparency = 1
    Row.Parent = self.Container

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(1, 0, 0, 11)
    Label.TextColor3 = Linoria.Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.BackgroundTransparency = 1
    Label.Parent = Row

    local DropBtn = Instance.new("TextButton")
    DropBtn.Text = tostring(default) .. "  ▼"
    DropBtn.Size = UDim2.new(1, 0, 0, 14)
    DropBtn.Position = UDim2.new(0, 0, 0, 12)
    DropBtn.BackgroundColor3 = Linoria.Theme.MainFrame
    DropBtn.BorderColor3 = Linoria.Theme.Outline
    DropBtn.BorderSizePixel = 1
    DropBtn.TextColor3 = Linoria.Theme.Text
    DropBtn.Font = Enum.Font.Code
    DropBtn.TextSize = 10
    DropBtn.Parent = Row

    return DropBtn
end

return Linoria
