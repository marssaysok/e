-- Define the toggle key and smoothness
_G.ToggleKey = _G.ToggleKey or "Q"
_G.Smoothness = _G.Smoothness or 0.1  -- Default smoothness

-- Loadstring setup
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local AimlockEnabled = false
local Target = nil

local function getMouseTarget()
    local mouse = LocalPlayer:GetMouse()
    local target = mouse.Target
    if target and target.Parent and Players:FindFirstChild(target.Parent.Name) then
        return Players[target.Parent.Name]
    end
    return nil
end

local function aimAt(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = target.Character.HumanoidRootPart.Position
        local direction = (targetPosition - Camera.CFrame.p).unit
        local targetCFrame = CFrame.new(Camera.CFrame.p, Camera.CFrame.p + direction)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.Smoothness) -- Smoothly aim at the target
    end
end

local function onInputBegan(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode[_G.ToggleKey] then
        AimlockEnabled = not AimlockEnabled
        if AimlockEnabled then
            Target = getMouseTarget()
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
