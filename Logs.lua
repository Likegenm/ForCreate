local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local function getSystemInfo()
    local executor = "Unknown"
    local pcModel = "Unknown"
    
    if identifyexecutor then
        executor = tostring(identifyexecutor())
    elseif getexecutorname then
        executor = getexecutorname()
    end
    
    pcall(function()
        if syn and syn.request then
            local req = syn.request({Url = "http://ip-api.com/json", Method = "GET"})
            if req.Body then
                local data = game:GetService("HttpService"):JSONDecode(req.Body)
                pcModel = data.countryCode or "Unknown"
            end
        end
    end)
    
    return executor, pcModel
end

local executorName, pcCountry = getSystemInfo()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FullStatsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui
screenGui.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.Parent = screenGui

local rainbowGradient = Instance.new("UIGradient")
rainbowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 130, 238)) 
})
rainbowGradient.Rotation = 45
rainbowGradient.Parent = mainFrame

-- Анимация градиента
spawn(function()
    while true do
        rainbowGradient.Rotation = (rainbowGradient.Rotation + 1) % 360
        RunService.RenderStepped:Wait()
    end
end)

local textContainer = Instance.new("Frame")
textContainer.Size = UDim2.new(0.8, 0, 0.8, 0)
textContainer.Position = UDim2.new(0.1, 0, 0.1, 0)
textContainer.BackgroundTransparency = 1
textContainer.Parent = mainFrame

local labels = {}
local statsList = {
    "Speed", "Jump", "Velocity", "Position", "Ping",
    "Executor", "PC Model", "Roblox Version", "Display Name",
    "Username", "User ID", "Gravity", "FPS"
}

for i, stat in ipairs(statsList) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, (i-1)*35)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = stat .. ": ..."
    label.Parent = textContainer
    labels[stat] = label
end

local lastTime = tick()
local frameCount = 0
local fps = 0

RunService.Heartbeat:Connect(function(deltaTime)
    frameCount = frameCount + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        fps = math.floor(frameCount / (currentTime - lastTime))
        frameCount = 0
        lastTime = currentTime
    end

    labels["Speed"].Text = string.format("Speed: %.2f", humanoid.WalkSpeed)

    labels["Jump"].Text = string.format("Jump: %.2f", humanoid.JumpPower)

    local vel = rootPart.Velocity
    labels["Velocity"].Text = string.format("Velocity: %.2f", vel.Magnitude)

    local pos = rootPart.Position
    labels["Position"].Text = string.format("Position: %.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)

    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    labels["Ping"].Text = string.format("Ping: %d ms", ping)

    labels["Executor"].Text = string.format("Executor: %s", executorName)
 
    labels["PC Model"].Text = string.format("PC Model: %s", pcCountry)

    labels["Roblox Version"].Text = string.format("Roblox: %s", game:GetService("HttpService"):JSONDecode(game:HttpGet("https://clientsettings.roblox.com/v2/client-version")).clientVersion)

    labels["Display Name"].Text = string.format("Display: %s", player.DisplayName)

    labels["Username"].Text = string.format("Username: %s", player.Name)

    labels["User ID"].Text = string.format("User ID: %d", player.UserId)

    labels["Gravity"].Text = string.format("Gravity: %.2f", workspace.Gravity)
    
    labels["FPS"].Text = string.format("FPS: %d", fps)
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Z then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 100, 0, 40)
closeButton.Position = UDim2.new(0.5, -50, 0.95, -50)
closeButton.Text = "CLOSE (Z)"
closeButton.Font = Enum.Font.GothamBlack
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundTransparency = 0.3
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "SYSTEM STATS PANEL"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.GothamBlack
title.TextSize = 32
title.TextStrokeTransparency = 0.3
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = mainFrame
