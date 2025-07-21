local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("BrainBlox Hub", "Crimson")

-- Tabs na ordem ideal
local playerTab = Main:CreateTab("Player")
local aimTab = Main:CreateTab("Aim")
local visualsTab = Main:CreateTab("Visuals")
local configTab = Main:CreateTab("Config")

-- Vars
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local humanoid
local infJumpEnabled = false
local fovCircle = nil
local toggleKey = Enum.KeyCode.RightControl
local aimbotEnabled = false
local aimbotStrength = 1
local aimbotFOV = 100
local aimbotColor = Color3.fromRGB(255, 0, 0)

-- Atualiza Humanoid
local function updateHumanoid()
    if player.Character then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    end
end
player.CharacterAdded:Connect(function() wait(1) updateHumanoid() end)
updateHumanoid()

--// PLAYER
playerTab:CreateSlider("Velocidade", 16, 200, function(val)
    if humanoid then humanoid.WalkSpeed = val end
end)

playerTab:CreateSlider("Pulo", 50, 300, function(val)
    if humanoid then humanoid.JumpPower = val end
end)

playerTab:CreateToggle("Infinity Jump", function(state)
    infJumpEnabled = state
end)

uis.JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// AIM (com tudo fixado)
aimTab:CreateToggle("Ativar Aimbot", function(state)
    aimbotEnabled = state
end)

aimTab:CreateSlider("FOV do Aimbot", 50, 300, function(val)
    aimbotFOV = val
    if fovCircle then fovCircle.Radius = val end
end)

aimTab:CreateSlider("Força do Aimbot", 1, 10, function(val)
    aimbotStrength = val
end)

aimTab:CreateColorPicker("Cor do Aimbot/FOV", Color3.fromRGB(255, 0, 0), function(color)
    aimbotColor = color
    if fovCircle then fovCircle.Color = color end
end)

aimTab:CreateToggle("FOV Visível", function(state)
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
end)

run.RenderStepped:Connect(function()
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

--// VISUALS (opcional, só base)
visualsTab:CreateToggle("ESP (Nome)", function(state)
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
end)

visualsTab:CreateToggle("Glow", function(state)
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
end)

--// CONFIG
configTab:CreateDropdown("Tecla do Menu", {"RightControl", "Insert", "F4", "F10", "Home"}, function(selected)
    toggleKey = Enum.KeyCode[selected]
end)

uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == toggleKey then
        library:ToggleUI()
    end
end)

-- Mostrar a aba principal primeiro
playerTab:Show()
