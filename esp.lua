local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local esp1 = false
local esp2 = {}
local esp3 = Color3.fromRGB(255, 50, 50)
local esp4 = 0.7
local esp5 = {
    ShowNames = true,
    ShowBoxes = true,
    TeamColor = true,
    MaxDistance = 3000
}
local esp6 = nil

function esp7(player)
    if not player.Character then return end
    if esp2[player] then esp8(player) end
    
    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local teamColor = player.Team and player.TeamColor.Color or esp3
    local espColor = esp5.TeamColor and teamColor or esp3
    
    local espTable = {}
    
    if esp5.ShowBoxes then
        local highlight = Instance.new("Highlight")
        highlight.Name = player.Name .. "_ESP"
        highlight.Adornee = character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = espColor
        highlight.FillTransparency = esp4
        highlight.OutlineColor = espColor
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        
        espTable.Highlight = highlight
    end
    
    if esp5.ShowNames then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = player.Name .. "_NameESP"
        billboard.Adornee = rootPart
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = esp5.MaxDistance
        billboard.Enabled = esp5.ShowNames
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = billboard
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = player.Name
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = espColor
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = frame
        
        billboard.Parent = character
        espTable.Billboard = billboard
    end
    
    esp2[player] = espTable
end

function esp8(player)
    if not esp2[player] then return end
    
    local espTable = esp2[player]
    
    if espTable.Highlight then
        espTable.Highlight:Destroy()
    end
    
    if espTable.Billboard then
        espTable.Billboard:Destroy()
    end
    
    esp2[player] = nil
end

function esp9()
    if esp1 then
        if not esp6 then
            esp6 = RunService.Heartbeat:Connect(function()
                for player, espTable in pairs(esp2) do
                    if not player or not player.Parent then
                        esp8(player)
                        continue
                    end
                    
                    local character = player.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then
                        if espTable.Highlight then espTable.Highlight.Enabled = false end
                        if espTable.Billboard then espTable.Billboard.Enabled = false end
                        continue
                    end
                    
                    local rootPart = character.HumanoidRootPart
                    local localChar = localPlayer.Character
                    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
                    
                    if not localRoot then continue end
                    
                    local distance = (rootPart.Position - localRoot.Position).Magnitude
                    local shouldShow = distance <= esp5.MaxDistance
                    
                    if espTable.Highlight then
                        espTable.Highlight.Enabled = shouldShow and esp5.ShowBoxes
                    end
                    
                    if espTable.Billboard then
                        espTable.Billboard.Enabled = shouldShow and esp5.ShowNames
                    end
                end
            end)
        end
    elseif esp6 then
        esp6:Disconnect()
        esp6 = nil
    end
end

function esp10()
    esp1 = not esp1
    
    if esp1 then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                esp7(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            esp7(player)
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            esp8(player)
        end)
        
        esp9()
    else
        for player in pairs(esp2) do
            esp8(player)
        end
        
        if esp6 then
            esp6:Disconnect()
            esp6 = nil
        end
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedESPPanel"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TopBar.BorderSizePixel = 0

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "ESP CONTROL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 150, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(924, 724)
CloseButton.ImageRectSize = Vector2.new(36, 36)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0.5, -12.5)
CloseButton.BackgroundTransparency = 1

TopBar.Parent = MainFrame
Title.Parent = TopBar
CloseButton.Parent = TopBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function esp11(text, size, position)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.AutoButtonColor = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    
    return button
end

local function esp12(text, position, size)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Size = size or UDim2.new(0, 200, 0, 20)
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

local function esp13(text, value, position, callback)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 0, 25)
    toggle.BackgroundTransparency = 1
    toggle.Position = position
    
    local label = esp12(text, UDim2.new(0, 0, 0, 0), UDim2.new(0.7, 0, 1, 0))
    label.Parent = toggle
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 25)
    button.Position = UDim2.new(0.8, -50, 0, 0)
    button.BackgroundColor3 = value and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
    button.Text = value and "ON" or "OFF"
    button.TextColor3 = value and Color3.new(1,1,1) or Color3.fromRGB(220, 220, 220)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.AutoButtonColor = true
    button.Parent = toggle
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        local newValue = not value
        button.BackgroundColor3 = newValue and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
        button.Text = newValue and "ON" or "OFF"
        callback(newValue)
    end)
    
    return toggle
end

local function esp14(min, max, value, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 30)
    slider.BackgroundTransparency = 1
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 8)
    track.Position = UDim2.new(0, 0, 0.5, -4)
    track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    track.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    fill.BorderSizePixel = 0
    fill.Parent = track
    
    local corner2 = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(0.5, 0)
    corner2.Parent = fill
    
    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new((value - min) / (max - min), -10, 0.5, -10)
    handle.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    handle.Text = ""
    handle.Parent = slider
    
    local corner3 = Instance.new("UICorner")
    corner3.CornerRadius = UDim.new(0.5, 0)
    corner3.Parent = handle
    
    track.Parent = slider
    
    local dragging = false
    handle.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * pos
            fill.Size = UDim2.new(pos, 0, 1, 0)
            handle.Position = UDim2.new(pos, -10, 0.5, -10)
            callback(math.floor(value))
        end
    end)
    
    return slider
end

local EspToggle = esp11(esp1 and "ESP: ON" or "ESP: OFF", UDim2.new(0, 120, 0, 35), UDim2.new(0.5, -60, 0.1, 0))
EspToggle.BackgroundColor3 = esp1 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
EspToggle.Parent = ContentFrame

local DistanceLabel = esp12("Max Distance: " .. esp5.MaxDistance .. " studs", UDim2.new(0, 0, 0.3, 0), UDim2.new(1, 0, 0, 20))
DistanceLabel.Parent = ContentFrame

local DistanceSlider = esp14(100, 3000, esp5.MaxDistance, function(value)
    esp5.MaxDistance = value
    DistanceLabel.Text = "Max Distance: " .. value .. " studs"
    esp9()
end)
DistanceSlider.Position = UDim2.new(0, 0, 0.4, 0)
DistanceSlider.Parent = ContentFrame

local ShowNamesToggle = esp13("Show Names", esp5.ShowNames, UDim2.new(0, 0, 0.6, 0), function(value)
    esp5.ShowNames = value
    for player, espTable in pairs(esp2) do
        if espTable.Billboard then
            espTable.Billboard.Enabled = value
        end
    end
end)
ShowNamesToggle.Parent = ContentFrame

local ShowBoxesToggle = esp13("Show Boxes", esp5.ShowBoxes, UDim2.new(0, 0, 0.75, 0), function(value)
    esp5.ShowBoxes = value
    for player, espTable in pairs(esp2) do
        if espTable.Highlight then
            espTable.Highlight.Enabled = value
        end
    end
end)
ShowBoxesToggle.Parent = ContentFrame

local TeamColorToggle = esp13("Team Color", esp5.TeamColor, UDim2.new(0, 0, 0.9, 0), function(value)
    esp5.TeamColor = value
    for player in pairs(esp2) do
        esp8(player)
        esp7(player)
    end
end)
TeamColorToggle.Parent = ContentFrame

EspToggle.MouseButton1Click:Connect(function()
    esp10()
    EspToggle.Text = esp1 and "ESP: ON" or "ESP: OFF"
    EspToggle.BackgroundColor3 = esp1 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if esp1 then esp10() end
end)

local dragging
local dragInput
local dragStart
local startPos

local function esp15(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X, 
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        esp15(input)
    end
end)

ScreenGui.Destroying:Connect(function()
    if esp1 then esp10() end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        esp10()
        EspToggle.Text = esp1 and "ESP: ON" or "ESP: OFF"
        EspToggle.BackgroundColor3 = esp1 and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(60, 60, 80)
    end
end)

MainFrame.Parent = ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
