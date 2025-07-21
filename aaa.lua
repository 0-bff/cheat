local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("BrainBlox Hub", "Crimson")

-- Tabs organizadas
local playerTab = Main:CreateTab("Player")
local stealTab = Main:CreateTab("Steal")
local visualsTab = Main:CreateTab("Visuals")
local configTab = Main:CreateTab("Config")

-- Variáveis
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local humanoid

-- Atualiza humanoid
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

local infJumpEnabled = false
playerTab:CreateToggle("Infinity Jump", function(state)
    infJumpEnabled = state
end)

uis.JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// STEAL
stealTab:CreateButton("Teleportar Pra Frente", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        root.CFrame = root.CFrame + (root.CFrame.LookVector * 10)
    end
end)

--// VISUALS (opcional)
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
local toggleKey = Enum.KeyCode.RightControl
configTab:CreateDropdown("Tecla do Menu", {"RightControl", "Insert", "F4", "F10", "Home"}, function(selected)
    toggleKey = Enum.KeyCode[selected]
end)

uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == toggleKey then
        library:ToggleUI()
    end
end)

-- Mostrar Player primeiro
playerTab:Show()
