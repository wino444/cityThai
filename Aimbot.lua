local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local aimbotEnabled = false

local function findNearestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local function fireGun(targetPosition)
    local character = LocalPlayer.Character
    local gun = character and character:FindFirstChild("Gun")
    if not gun then return end
    
    local shotRemote = gun:FindFirstChild("shot")
    if shotRemote and shotRemote:IsA("RemoteEvent") then
        shotRemote:FireServer(targetPosition)
    end
end
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 120)
mainFrame.Position = UDim2.new(0.05, 0, 0.7, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = mainFrame

local shadow = Instance.new("UIStroke")
shadow.Color = Color3.fromRGB(0, 255, 255)
shadow.Thickness = 2
shadow.Parent = mainFrame

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0, 200, 0, 60)
aimbotButton.Position = UDim2.new(0.5, -100, 0.5, -30)
aimbotButton.BackgroundColor3 = Color3.fromRGB(25, 25, 60)
aimbotButton.TextColor3 = Color3.fromRGB(0, 255, 255)
aimbotButton.Text = "Aimbot: OFF"
aimbotButton.TextSize = 22
aimbotButton.Font = Enum.Font.FredokaOne
aimbotButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = aimbotButton

aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        aimbotButton.Text = "Aimbot: ON"
        aimbotButton.TextColor3 = Color3.fromRGB(255, 0, 255)
        aimbotButton.BackgroundColor3 = Color3.fromRGB(0, 60, 120)
    else
        aimbotButton.Text = "Aimbot: OFF"
        aimbotButton.TextColor3 = Color3.fromRGB(0, 255, 255)
        aimbotButton.BackgroundColor3 = Color3.fromRGB(25, 25, 60)
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local targetPlayer = findNearestPlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            fireGun(targetPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)
