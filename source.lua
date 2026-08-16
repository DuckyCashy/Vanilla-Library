local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local CoreGui = (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")

local function GetSafeContainer()
    return gethui and gethui() or CoreGui
end

local Library = {
    Flags = {},
    Callbacks = {},
    ConfigFolder = "ScriptConfigs",
    CurrentTheme = {
        Background = Color3.fromRGB(20, 20, 24),
        Header = Color3.fromRGB(28, 28, 34),
        Accent = Color3.fromRGB(0, 140, 255),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(150, 150, 165),
        Element = Color3.fromRGB(34, 34, 42),
        Border = Color3.fromRGB(45, 45, 55)
    },
    Themes = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 24),
            Header = Color3.fromRGB(28, 28, 34),
            Accent = Color3.fromRGB(0, 140, 255),
            Text = Color3.fromRGB(240, 240, 245),
            SubText = Color3.fromRGB(150, 150, 165),
            Element = Color3.fromRGB(34, 34, 42),
            Border = Color3.fromRGB(45, 45, 55)
        },
        Midnight = {
            Background = Color3.fromRGB(12, 12, 16),
            Header = Color3.fromRGB(18, 18, 24),
            Accent = Color3.fromRGB(130, 80, 255),
            Text = Color3.fromRGB(240, 240, 255),
            SubText = Color3.fromRGB(130, 130, 150),
            Element = Color3.fromRGB(24, 24, 32),
            Border = Color3.fromRGB(35, 35, 48)
        },
        Crimson = {
            Background = Color3.fromRGB(18, 18, 18),
            Header = Color3.fromRGB(26, 26, 26),
            Accent = Color3.fromRGB(220, 40, 40),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(160, 160, 160),
            Element = Color3.fromRGB(32, 32, 32),
            Border = Color3.fromRGB(48, 48, 48)
        }
    }
}

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

-- Helper: Window Dragging
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

----------------------------------------------------
-- 1. KEY SYSTEM
----------------------------------------------------
function Library.ValidateKey(options)
    options = options or {}
    local validKey = options.Key or "default_key"
    local keyFileName = (options.SavePath or "script_key") .. ".txt"
    local keyLink = options.Link or ""
    
    -- Auto-load saved key
    if options.SaveKey and isfile and isfile(keyFileName) then
        local savedKey = readfile(keyFileName)
        if savedKey == validKey then
            return true
        end
    end

    local keyValidated = false
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemGui"
    ScreenGui.Parent = GetSafeContainer()

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 340, 0, 200)
    Frame.Position = UDim2.new(0.5, -170, 0.5, -100)
    Frame.BackgroundColor3 = Library.CurrentTheme.Background
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = options.Title or "Key Verification"
    Title.TextColor3 = Library.CurrentTheme.Text
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 16
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 36)
    KeyInput.Position = UDim2.new(0, 20, 0, 55)
    KeyInput.BackgroundColor3 = Library.CurrentTheme.Element
    KeyInput.TextColor3 = Library.CurrentTheme.Text
    KeyInput.PlaceholderText = "Enter key..."
    KeyInput.Text = ""
    KeyInput.Font = Enum.Font.SourceSans
    KeyInput.TextSize = 14
    KeyInput.Parent = Frame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = KeyInput

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0, 140, 0, 36)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 105)
    SubmitBtn.BackgroundColor3 = Library.CurrentTheme.Accent
    SubmitBtn.TextColor3 = Library.CurrentTheme.Text
    SubmitBtn.Text = "Submit Key"
    SubmitBtn.Font = Enum.Font.SourceSansBold
    SubmitBtn.TextSize = 14
    SubmitBtn.Parent = Frame

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = SubmitBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0, 140, 0, 36)
    GetKeyBtn.Position = UDim2.new(1, -160, 0, 105)
    GetKeyBtn.BackgroundColor3 = Library.CurrentTheme.Element
    GetKeyBtn.TextColor3 = Library.CurrentTheme.SubText
    GetKeyBtn.Text = "Copy Key Link"
    GetKeyBtn.Font = Enum.Font.SourceSans
    GetKeyBtn.TextSize = 14
    GetKeyBtn.Parent = Frame

    local GetCorner = Instance.new("UICorner")
    GetCorner.CornerRadius = UDim.new(0, 6)
    GetCorner.Parent = GetKeyBtn

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0, 0, 0, 155)
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(245, 80, 80)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextSize = 13
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Parent = Frame

    MakeDraggable(Title, Frame)

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(keyLink)
            StatusLabel.TextColor3 = Color3.fromRGB(80, 245, 80)
            StatusLabel.Text = "Link copied to clipboard!"
        else
            StatusLabel.Text = "Clipboard not supported by executor."
        end
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == validKey then
            if options.SaveKey and writefile then
                writefile(keyFileName, validKey)
            end
            keyValidated = true
            ScreenGui:Destroy()
        else
            StatusLabel.TextColor3 = Color3.fromRGB(245, 80, 80)
            StatusLabel.Text = "Invalid key provided."
        end
    end)

    repeat task.wait() until keyValidated
    return true
end

----------------------------------------------------
-- 2. CONFIG SYSTEM
----------------------------------------------------
function Library:SetConfigFolder(folderName)
    self.ConfigFolder = folderName
    if makefolder and not isfolder(folderName) then
        makefolder(folderName)
    end
end

function Library:SaveConfig(configName)
    if not writefile then return false end
    if makefolder and not isfolder(self.ConfigFolder) then
        makefolder(self.ConfigFolder)
    end
    
    local path = self.ConfigFolder .. "/" .. configName .. ".json"
    local data = HttpService:JSONEncode(self.Flags)
    writefile(path, data)
    return true
end

function Library:LoadConfig(configName)
    if not readfile or not isfile then return false end
    local path = self.ConfigFolder .. "/" .. configName .. ".json"
    
    if isfile(path) then
        local rawData = readfile(path)
        local decoded = HttpService:JSONDecode(rawData)
        
        for flag, value in pairs(decoded) do
            self.Flags[flag] = value
            if self.Callbacks[flag] then
                task.spawn(self.Callbacks[flag], value)
            end
        end
        return true
    end
    return false
end

----------------------------------------------------
-- 3. THEME MANAGEMENT
----------------------------------------------------
function Library:SetTheme(themeData)
    if type(themeData) == "string" and self.Themes[themeData] then
        self.CurrentTheme = self.Themes[themeData]
    elseif type(themeData) == "table" then
        for k, v in pairs(themeData) do
            self.CurrentTheme[k] = v
        end
    end
end

----------------------------------------------------
-- UI WINDOW CREATION
----------------------------------------------------
function Library.CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "Script Hub"

    if options.Theme then
        Library:SetTheme(options.Theme)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = options.GuiName or "MainScriptHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = GetSafeContainer()

    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 520, 0, 360)
    Main.Position = UDim2.new(0.5, -260, 0.5, -180)
    Main.BackgroundColor3 = Library.CurrentTheme.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Library.CurrentTheme.Header
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Text = windowName
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.TextColor3 = Library.CurrentTheme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 15
    Title.BackgroundTransparency = 1
    Title.Parent = TopBar

    MakeDraggable(TopBar, Main)

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 130, 1, -45)
    TabContainer.Position = UDim2.new(0, 8, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Main

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 4)
    TabList.Parent = TabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -150, 1, -45)
    ContentContainer.Position = UDim2.new(0, 142, 0, 40)
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

function Window:CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 30)
    TabButton.BackgroundColor3 = Library.CurrentTheme.Element
    TabButton.TextColor3 = Library.CurrentTheme.SubText
    TabButton.Text = name
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
            TweenService:Create(self.ActiveTab.Button, TweenInfo.new(0.2), {TextColor3 = Library.CurrentTheme.SubText, BackgroundColor3 = Library.CurrentTheme.Element}):Play()
        end
        self.ActiveTab = tabObj
        TabPage.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Library.CurrentTheme.Accent, BackgroundColor3 = Library.CurrentTheme.Header}):Play()
    end)

    if not self.ActiveTab then
        self.ActiveTab = tabObj
        TabPage.Visible = true
        TabButton.TextColor3 = Library.CurrentTheme.Accent
        TabButton.BackgroundColor3 = Library.CurrentTheme.Header
    end

    return tabObj
end

function Tab:AddToggle(options)
    options = options or {}
    local text = options.Name or "Toggle"
    local flag = options.Flag
    local default = options.Default or false
    local callback = options.Callback or function() end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -6, 0, 32)
    ToggleFrame.BackgroundColor3 = Library.CurrentTheme.Element
    ToggleFrame.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.TextColor3 = Library.CurrentTheme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleFrame

    local Box = Instance.new("TextButton")
    Box.Text = ""
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(1, -28, 0.5, -9)
    Box.BackgroundColor3 = default and Library.CurrentTheme.Accent or Library.CurrentTheme.Background
    Box.Parent = ToggleFrame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box

    local state = default
    if flag then 
        Library.Flags[flag] = state
        Library.Callbacks[flag] = function(v)
            state = v
            local targetColor = state and Library.CurrentTheme.Accent or Library.CurrentTheme.Background
            TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            callback(state)
        end
    end

    Box.MouseButton1Click:Connect(function()
        state = not state
        if flag then Library.Flags[flag] = state end
        local targetColor = state and Library.CurrentTheme.Accent or Library.CurrentTheme.Background
        TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        task.spawn(callback, state)
    end)
end

function Tab:AddButton(options)
    options = options or {}
    local text = options.Name or "Button"
    local callback = options.Callback or function() end

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -6, 0, 32)
    Btn.BackgroundColor3 = Library.CurrentTheme.Element
    Btn.TextColor3 = Library.CurrentTheme.Text
    Btn.Text = text
    Btn.Font = Enum.Font.SourceSans
    Btn.TextSize = 14
    Btn.Parent = self.Page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Library.CurrentTheme.Accent}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Library.CurrentTheme.Element}):Play()
        task.spawn(callback)
    end)
end

return Library
