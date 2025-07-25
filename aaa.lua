local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/PPHUD/main/Library.lua'))()
local Flags = Library.Flags

-- Criação da Janela
local Window = Library:Window({
   Text = "BrainBlox Hub"
})

---------------------------------------------------------
-- PLAYER TAB
---------------------------------------------------------
local PlayerTab = Window:Tab({ Text = "Player" })
local PlayerSection = PlayerTab:Section({ Text = "Movimentação" })

local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local humanoid
local infJump = false

local function updateHumanoid()
    if player.Character then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    end
end
player.CharacterAdded:Connect(function() wait(1) updateHumanoid() end)
updateHumanoid()

PlayerSection:Slider({
    Text = "Velocidade",
    Minimum = 16,
    Default = 16,
    Maximum = 200,
    Callback = function(val)
        if humanoid then humanoid.WalkSpeed = val end
    end
})

PlayerSection:Slider({
    Text = "Pulo",
    Minimum = 50,
    Default = 50,
    Maximum = 300,
    Callback = function(val)
        if humanoid then humanoid.JumpPower = val end
    end
})

PlayerSection:Check({
    Text = "Infinity Jump",
    Callback = function(state)
        infJump = state
    end
})

uis.JumpRequest:Connect(function()
    if infJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

---------------------------------------------------------
-- AIM TAB
---------------------------------------------------------
local AimTab = Window:Tab({ Text = "Aim" })
local AimSection = AimTab:Section({ Text = "Aimbot" })

local aimbotEnabled = false
local aimbotFOV = 100
local aimbotStrength = 1
local aimbotColor = Color3.fromRGB(255, 0, 0)
local fovCircle

AimSection:Check({
    Text = "Ativar Aimbot",
    Callback = function(state)
        aimbotEnabled = state
    end
})

AimSection:Slider({
    Text = "FOV",
    Minimum = 50,
    Default = 100,
    Maximum = 300,
    Callback = function(val)
        aimbotFOV = val
        if fovCircle then fovCircle.Radius = val end
    end
})

AimSection:Slider({
    Text = "Força",
    Minimum = 1,
    Default = 1,
    Maximum = 10,
    Callback = function(val)
        aimbotStrength = val
    end
})

AimSection:Button({
    Text = "Cor do FOV",
    Callback = function()
        aimbotColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
        if fovCircle then fovCircle.Color = aimbotColor end
    end
})

AimSection:Check({
    Text = "FOV Visível",
    Callback = function(state)
        if state then
            fovCircle = Drawing.new("Circle")
            fovCircle.Visible = true
            fovCircle.Filled = false
            fovCircle.Thickness = 2
            fovCircle.Color = aimbotColor
            fovCircle.Transparency = 0.5
            fovCircle.Radius = aimbotFOV
            fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
        else
            if fovCircle then
                fovCircle:Remove()
                fovCircle = nil
            end
        end
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled and player and player.Character then
        local cam = workspace.CurrentCamera
        local closest = nil
        local shortest = aimbotFOV

        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local pos, onScreen = cam:WorldToViewportPoint(plr.Character.Head.Position)
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)).Magnitude
                if onScreen and dist < shortest then
                    closest = plr
                    shortest = dist
                end
            end
        end

        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            local head = closest.Character.Head.Position
            local look = (head - cam.CFrame.Position).Unit
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, cam.CFrame.Position + look), aimbotStrength / 100)
        end
    end
end)

---------------------------------------------------------
-- VISUALS TAB
---------------------------------------------------------
local VisualTab = Window:Tab({ Text = "Visuals" })
local VisualSection = VisualTab:Section({ Text = "ESP & Glow" })

VisualSection:Check({
    Text = "ESP (Nome)",
    Callback = function(state)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player then
                local char = plr.Character
                if char and char:FindFirstChild("Head") then
                    if state then
                        local tag = Instance.new("BillboardGui", char.Head)
                        tag.Name = "BrainESP"
                        tag.Size = UDim2.new(0,100,0,40)
                        tag.AlwaysOnTop = true
                        local text = Instance.new("TextLabel", tag)
                        text.Size = UDim2.new(1,0,1,0)
                        text.Text = plr.Name
                        text.TextColor3 = Color3.new(1,0,0)
                        text.BackgroundTransparency = 1
                    else
                        local esp = char.Head:FindFirstChild("BrainESP")
                        if esp then esp:Destroy() end
                    end
                end
            end
        end
    end
})

VisualSection:Check({
    Text = "Glow",
    Callback = function(state)
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                if state then
                    local hl = Instance.new("Highlight", plr.Character)
                    hl.Name = "BrainGlow"
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                else
                    local hl = plr.Character:FindFirstChild("BrainGlow")
                    if hl then hl:Destroy() end
                end
            end
        end
    end
})
