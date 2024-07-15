-- Define the toggle key
_G.ToggleKey = "Q"

-- Loadstring setup
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local AimlockEnabled = false
local Target = nil

local function getClosestPlayer()
    local closestDistance = math.huge
    local closestPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.Character.HumanoidRootPart.Position
        local direction = (targetPosition - Camera.CFrame.p).unit
        local targetCFrame = CFrame.new(Camera.CFrame.p, Camera.CFrame.p + direction)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 0.1) -- Smoothly aim at the target
    end
end

local function onInputBegan(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode[_G.ToggleKey] then
        AimlockEnabled = not AimlockEnabled
        if AimlockEnabled then
            Target = getClosestPlayer()
        else
            Target = nil
        end
    end
end

UserInputService.InputBegan:Connect(onInputBegan)

RunService.RenderStepped:Connect(function()
    if AimlockEnabled and Target then
        aimAt(Target)
    end
end)
