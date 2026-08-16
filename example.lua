local Vanilla = loadstring(game:HttpGet("https://raw.githubusercontent.com/duckycashy/Vanilla-Library/main/Source.lua"))()
local UserInputService = game:GetService("UserInputService")

-- Theme Configuration
Vanilla:AddTheme({
    Name = "Dark",
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#101010"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
})

-- Window Creation
local Window = Vanilla:CreateWindow({
    Title   = "My Script Hub",
    Author  = "by you",
    Folder  = "myhub",
    Theme   = "Dark",
    Acrylic = true,
    Transparent = true,
    Size    = UDim2.fromOffset(680, 460),
    ToggleKey  = Enum.KeyCode.RightShift,
    SideBarWidth = 200,
    Topbar = { Height = 44 },
    OpenButton = { Title = "My Hub", Enabled = true },
})

-- Main Tab
local MainTab = Window:Tab({ Title = "Main" })

-- Settings Tab
local ThemeTab = Window:Tab({ Title = "Settings" })

ThemeTab:Dropdown({
    Title  = "Theme",
    Values = (function()
        local names = {}
        for name in pairs(Vanilla:GetThemes()) do
            table.insert(names, name)
        end
        table.sort(names)
        return names
    end)(),
    Value    = Vanilla:GetCurrentTheme(),
    Callback = function(selected)
        Vanilla:SetTheme(selected)
    end,
})

ThemeTab:Toggle({
    Title = "Acrylic",
    Value = Vanilla:GetTransparency(),
    Callback = function()
        local isOn = Window.Acrylic
        Vanilla:ToggleAcrylic(not isOn)
    end,
})

ThemeTab:Toggle({
    Title = "Transparent",
    Value = Vanilla:GetTransparency(),
    Callback = function(state)
        Window:ToggleTransparency(state)
    end
})

local currentKey = Enum.KeyCode.RightShift

ThemeTab:Keybind({
    Title = "Toggle UI Key",
    Value = currentKey,
    Callback = function(v)
        currentKey = (typeof(v) == "EnumItem") and v or Enum.KeyCode[v]
        Window:SetToggleKey(currentKey)
    end,
})

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == currentKey then
        Window:Toggle()
    end
end)

-- Notifications
Vanilla:Notify({
    Title = "PlayerHub",
    Content = "Welcome to PlayerHub!",
})

Vanilla:SetNotificationLower(true)
