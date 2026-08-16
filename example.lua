local Vanilla = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/Vanilla/main/Source.lua"))()

local Window = Vanilla:CreateWindow({
    Title = "Vanilla UI",
    Size = UDim2.fromOffset(580, 520)
})

-- Top Tabs
local LegitTab = Window:AddTab("Legit")
local VisualsTab = Window:AddTab("Visuals")
local RageTab = Window:AddTab("Rage")
local MiscTab = Window:AddTab("Miscellaneous")
local SettingsTab = Window:AddTab("Settings")

----------------------------------------------------
-- LEFT COLUMN
----------------------------------------------------
local EnemyESP = VisualsTab:AddLeftGroupbox("Enemy ESP")

EnemyESP:AddToggle("Nametags", { Text = "Nametags", Default = true, Color = Color3.fromRGB(0, 200, 255) })
    :AddColorPicker("NametagsColor", { Default = Color3.fromRGB(255, 255, 255) })

EnemyESP:AddToggle("DisplayDistance", { Text = "Display Distance", Default = true, Color = Color3.fromRGB(0, 200, 255) })

EnemyESP:AddToggle("Boxes", { Text = "Boxes", Default = true, Color = Color3.fromRGB(0, 200, 255) })
    :AddColorPicker("BoxesColor", { Default = Color3.fromRGB(255, 255, 255) })

EnemyESP:AddToggle("Healthbars", { Text = "Healthbars", Default = true, Color = Color3.fromRGB(0, 200, 255) })
    :AddColorPicker("HealthbarsColor", { Default = Color3.fromRGB(180, 200, 255) })

EnemyESP:AddToggle("OffscreenArrows", { Text = "Offscreen Arrows", Default = true, Color = Color3.fromRGB(0, 200, 255) })
    :AddColorPicker("ArrowsColor", { Default = Color3.fromRGB(255, 0, 255) })

local LocalGroup = VisualsTab:AddLeftGroupbox("Local")

LocalGroup:AddToggle("GunChams", { Text = "Gun Chams", Default = true, Color = Color3.fromRGB(0, 255, 0) })
    :AddColorPicker("GunChamsColor", { Default = Color3.fromRGB(130, 0, 255) })
LocalGroup:AddSlider("GunChamsTrans", { Text = "Gun Chams Transparency", Min = 0, Max = 100, Default = 33, Suffix = "%", Color = Color3.fromRGB(0, 255, 0) })

LocalGroup:AddToggle("HandChams", { Text = "Hand Chams", Default = true, Color = Color3.fromRGB(0, 255, 0) })
    :AddColorPicker("HandChamsColor", { Default = Color3.fromRGB(130, 0, 255) })
LocalGroup:AddSlider("HandChamsTrans", { Text = "Hand Chams Transparency", Min = 0, Max = 100, Default = 33, Suffix = "%", Color = Color3.fromRGB(0, 255, 0) })

LocalGroup:AddToggle("VisLocal", { Text = "Visualize LocalPlayer", Default = true, Color = Color3.fromRGB(0, 255, 0) })
    :AddColorPicker("VisLocalColor", { Default = Color3.fromRGB(130, 0, 255) })
LocalGroup:AddSlider("LocalTrans", { Text = "LocalPlayer Transparency", Min = 0, Max = 100, Default = 78, Suffix = "%", Color = Color3.fromRGB(0, 255, 0) })

LocalGroup:AddDropdown("CharModel", { Text = "Selected Character Model", Values = {"Toga (Custom)", "Default"}, Default = "Toga (Custom)" })

----------------------------------------------------
-- RIGHT COLUMN
----------------------------------------------------
local Crosshair = VisualsTab:AddRightGroupbox("Crosshair")

Crosshair:AddToggle("EnableCrosshair", { Text = "Enable Crosshair", Default = true, Color = Color3.fromRGB(0, 200, 255) })
    :AddColorPicker("CrosshairColor", { Default = Color3.fromRGB(150, 0, 255) })
Crosshair:AddToggle("AttachMouse", { Text = "Attach to Mouse", Default = true, Color = Color3.fromRGB(0, 200, 255) })
Crosshair:AddSlider("CrosshairSize", { Text = "Crosshair Size", Min = 0, Max = 100, Default = 7, Suffix = "px", Color = Color3.fromRGB(0, 230, 255) })
Crosshair:AddSlider("CrosshairSpacing", { Text = "Crosshair Spacing", Min = 0, Max = 20, Default = 2, Suffix = "px", Color = Color3.fromRGB(0, 230, 255) })

local RenderGroup = VisualsTab:AddRightGroupbox("Render")

RenderGroup:AddToggle("ColorCorr", { Text = "Color Correction", Default = true, Color = Color3.fromRGB(0, 255, 0) })
    :AddColorPicker("CorrColor", { Default = Color3.fromRGB(180, 180, 240) })
RenderGroup:AddSlider("Brightness", { Text = "Brightness", Min = 0, Max = 100, Default = 0, Suffix = "%", Color = Color3.fromRGB(0, 255, 0) })
RenderGroup:AddSlider("Contrast", { Text = "Contrast", Min = 0, Max = 100, Default = 0, Suffix = "%", Color = Color3.fromRGB(0, 255, 0) })
RenderGroup:AddSlider("Saturation", { Text = "Saturation", Min = 0, Max = 100, Default = 65, Suffix = "%", Color = Color3.fromRGB(0, 255, 0) })
RenderGroup:AddSlider("Intensity", { Text = "Intensity", Min = 0, Max = 40, Default = 12, Color = Color3.fromRGB(0, 255, 0) })
