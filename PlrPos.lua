local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerPosGUI"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 80)
frame.BackgroundTransparency = 0.7
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local posText = Instance.new("TextLabel")
posText.Size = UDim2.new(1, -10, 0, 40)
posText.Position = UDim2.new(0, 5, 0, 5)
posText.BackgroundTransparency = 1
posText.TextColor3 = Color3.fromRGB(255, 255, 255)
posText.TextXAlignment = Enum.TextXAlignment.Left
posText.Font = Enum.Font.Gotham
posText.TextSize = 14
posText.TextWrapped = true
posText.Text = "Position: 0, 0, 0"
posText.Parent = frame

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, -10, 0, 30)
copyButton.Position = UDim2.new(0, 5, 0, 50)
copyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Text = "📋 COPY POSITION"
copyButton.Font = Enum.Font.GothamBold
copyButton.TextSize = 14
copyButton.Parent = frame

RunService.Heartbeat:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        posText.Text = string.format("Position:\nX: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
    end
end)

local function copyPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        local posString = string.format("Vector3.new(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)

        pcall(function()
            setclipboard(posString)
        end)

        copyButton.Text = "✅ COPIED!"
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Вывод в консоль
        print("Скопировано: " .. posString)

        task.wait(1)
        copyButton.Text = "📋 COPY POSITION"
        copyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
    end
end

copyButton.MouseButton1Click:Connect(copyPosition)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        copyPosition()
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

player.CharacterAdded:Connect(function()
    task.wait(0.5)
end)
