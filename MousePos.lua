local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MousePosGUI"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 60)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundTransparency = 0.7
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local mouseText = Instance.new("TextLabel")
mouseText.Size = UDim2.new(1, -10, 0, 25)
mouseText.Position = UDim2.new(0, 5, 0, 5)
mouseText.BackgroundTransparency = 1
mouseText.TextColor3 = Color3.fromRGB(255, 255, 255)
mouseText.TextXAlignment = Enum.TextXAlignment.Left
mouseText.Font = Enum.Font.Gotham
mouseText.TextSize = 14
mouseText.Text = "Mouse: 0, 0"
mouseText.Parent = frame

local worldText = Instance.new("TextLabel")
worldText.Size = UDim2.new(1, -10, 0, 25)
worldText.Position = UDim2.new(0, 5, 0, 30)
worldText.BackgroundTransparency = 1
worldText.TextColor3 = Color3.fromRGB(255, 255, 255)
worldText.TextXAlignment = Enum.TextXAlignment.Left
worldText.Font = Enum.Font.Gotham
worldText.TextSize = 14
worldText.Text = "World: 0, 0, 0"
worldText.Parent = frame

game:GetService("RunService").RenderStepped:Connect(function()
    local mouse = player:GetMouse()

    mouseText.Text = string.format("Mouse: %d, %d", mouse.X, mouse.Y)

    local hit = mouse.Hit
    if hit then
        worldText.Text = string.format("World: %.1f, %.1f, %.1f", hit.X, hit.Y, hit.Z)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        local mouse = player:GetMouse()
        local hit = mouse.Hit
        
        if hit then
            local posString = string.format("Vector3.new(%.1f, %.1f, %.1f)", hit.X, hit.Y, hit.Z)
            
            pcall(function()
                setclipboard(posString)
            end)

            local originalColor = frame.BackgroundColor3
            frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            
            task.wait(0.2)
            
            frame.BackgroundColor3 = originalColor
            
            print("Скопировано: " .. posString)
        end
    end
end)

local dragging = false
local dragStart, frameStart

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            frameStart.X.Scale,
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
