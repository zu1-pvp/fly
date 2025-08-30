local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

local flying = false
local flySpeed = 50
local flyControls = {
    Forward = Enum.KeyCode.W,
    Backward = Enum.KeyCode.S,
    Left = Enum.KeyCode.A,
    Right = Enum.KeyCode.D,
    Up = Enum.KeyCode.Space,
    Down = Enum.KeyCode.LeftControl
}

local THEME = {
    Background = Color3.fromRGB(30, 30, 40),
    Button = Color3.fromRGB(60, 60, 80),
    ButtonHover = Color3.fromRGB(80, 80, 100),
    Text = Color3.fromRGB(220, 220, 220),
    Accent = Color3.fromRGB(100, 150, 255),
    AccentHover = Color3.fromRGB(120, 170, 255)
}

function fly1()
    if flying then return end
    flying = true
    
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.P = 1000
    bodyVelocity.Parent = character.HumanoidRootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = character.HumanoidRootPart.CFrame
    bodyGyro.Parent = character.HumanoidRootPart
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying or not bodyVelocity or not bodyGyro then
            flyConnection:Disconnect()
            return
        end
        
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        
        local camera = workspace.CurrentCamera
        local lookVector = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector
        local upVector = camera.CFrame.UpVector
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(flyControls.Forward) then
            moveDirection = moveDirection + lookVector
        end
        if UserInputService:IsKeyDown(flyControls.Backward) then
            moveDirection = moveDirection - lookVector
        end
        
        if UserInputService:IsKeyDown(flyControls.Left) then
            moveDirection = moveDirection - rightVector
        end
        if UserInputService:IsKeyDown(flyControls.Right) then
            moveDirection = moveDirection + rightVector
        end
        
        if UserInputService:IsKeyDown(flyControls.Up) then
            moveDirection = moveDirection + upVector
        end
        if UserInputService:IsKeyDown(flyControls.Down) then
            moveDirection = moveDirection - upVector
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        end
        
        bodyVelocity.Velocity = moveDirection
        
        bodyGyro.CFrame = CFrame.new(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + mouse.Hit.LookVector)
    end)
    
    return true
end

function fly2()
    flying = false
    
    local character = localPlayer.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, obj in ipairs(root:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                    obj:Destroy()
                end
            end
        end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    return true
end

function fly3()
    if flying then
        fly2()
        return false
    else
        fly1()
        return true
    end
end

function fly4(text, size, position)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = THEME.Button
    button.TextColor3 = THEME.Text
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = THEME.ButtonHover
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = THEME.Button
    end)
    
    return button
end

function fly5(text, position, size)
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Size = size or UDim2.new(0, 200, 0, 30)
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = THEME.Text
    label.TextXAlignment = Enum.TextXAlignment.Center
    return label
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControlPanel"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 140)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundColor3 = THEME.Button
TopBar.BorderSizePixel = 0

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "FLY CONTROL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextColor3 = THEME.Text
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(924, 724)
CloseButton.ImageRectSize = Vector2.new(36, 36)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -25, 0.5, -10)
CloseButton.BackgroundTransparency = 1

local SpeedLabel = fly5("Speed: " .. flySpeed, UDim2.new(0.5, -40, 0.2, 0), UDim2.new(0, 80, 0, 20))
SpeedLabel.Parent = MainFrame

local DecreaseButton = fly4("-", UDim2.new(0, 30, 0, 25), UDim2.new(0.2, 0, 0.4, 0))
DecreaseButton.Parent = MainFrame

local IncreaseButton = fly4("+", UDim2.new(0, 30, 0, 25), UDim2.new(0.8, -30, 0.4, 0))
IncreaseButton.Parent = MainFrame

local FlyToggleButton = fly4("Fly", UDim2.new(0, 80, 0, 30), UDim2.new(0.5, -40, 0.7, 0))
FlyToggleButton.BackgroundColor3 = THEME.Accent
FlyToggleButton.Parent = MainFrame

FlyToggleButton.MouseEnter:Connect(function()
    FlyToggleButton.BackgroundColor3 = THEME.AccentHover
end)

FlyToggleButton.MouseLeave:Connect(function()
    FlyToggleButton.BackgroundColor3 = THEME.Accent
end)

local StatusLabel = fly5("Status: Not Flying", UDim2.new(0.5, -60, 0.9, 0), UDim2.new(0, 120, 0, 15))
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.Parent = MainFrame

TopBar.Parent = MainFrame
Title.Parent = TopBar
CloseButton.Parent = TopBar
MainFrame.Parent = ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

IncreaseButton.MouseButton1Click:Connect(function()
    flySpeed = math.min(flySpeed + 5, 200)
    SpeedLabel.Text = "Speed: " .. flySpeed
end)

DecreaseButton.MouseButton1Click:Connect(function()
    flySpeed = math.max(flySpeed - 5, 5)
    SpeedLabel.Text = "Speed: " .. flySpeed
end)

FlyToggleButton.MouseButton1Click:Connect(function()
    local success = fly3()
    if success then
        FlyToggleButton.Text = "Unfly"
        StatusLabel.Text = "Status: Flying"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        FlyToggleButton.Text = "Fly"
        StatusLabel.Text = "Status: Not Flying"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    if flying then fly2() end
end)

local dragging
local dragInput
local dragStart
local startPos

function fly6(input)
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
        fly6(input)
    end
end)

ScreenGui.Destroying:Connect(function()
    if flying then fly2() end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        local success = fly3()
        if success then
            FlyToggleButton.Text = "Unfly"
            StatusLabel.Text = "Status: Flying"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            FlyToggleButton.Text = "Fly"
            StatusLabel.Text = "Status: Not Flying"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)