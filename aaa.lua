local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("BrainBlox Hub", "Crimson")

-- Tabs
local playerTab = Main:CreateTab("Player")
local stealTab = Main:CreateTab("Steal")
local visualsTab = Main:CreateTab("Visuals")
local configTab = Main:CreateTab("Config")

-- Vars
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local humanoid = nil

local infJump = false
update = function()
    if player.Character then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    end
end
player.CharacterAdded:Connect(function() wait(1) update() end)
update()

-- PLAYER
playerTab:CreateSlider("Velocidade", 16, 200, function(v)
    if humanoid then humanoid.WalkSpeed = v end
end)
playerTab:CreateSlider("Pulo", 50, 300, function(v)
    if humanoid then humanoid.JumpPower = v end
end)
playerTab:CreateToggle("Infinity Jump", function(s)
    infJump = s
end)
uis.JumpRequest:Connect(function()
    if infJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- STEAL
stealTab:CreateButton("Teleportar / Avançar", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local root = char.HumanoidRootPart
        -- Tenta posicionar acima do chão pra não colidir
        local dir = root.CFrame.LookVector * 15
        root.CFrame = CFrame.new(root.Position + dir + Vector3.new(0, 5, 0))
    end
end)

-- VISUALS
visualsTab:CreateToggle("ESP (Nome)", function(s)
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local head = plr.Character and plr.Character:FindFirstChild("Head")
            if head then
                local tag = head:FindFirstChild("BrainESP")
                if s and not tag then
                    local gui = Instance.new("BillboardGui", head)
                    gui.Name = "BrainESP"; gui.Size = UDim2.new(0,100,0,40); gui.AlwaysOnTop = true
                    local label = Instance.new("TextLabel", gui)
                    label.Size = UDim2.new(1,0,1,0); label.Text = plr.Name; label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.new(1,0,0)
                elseif not s and tag then
                    tag:Destroy()
                end
            end
        end
    end
end)

visualsTab:CreateToggle("Glow", function(s)
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local glow = plr.Character:FindFirstChild("BrainGlow")
            if s and not glow then
                local hl = Instance.new("Highlight", plr.Character)
                hl.Name = "BrainGlow"; hl.FillColor = Color3.new(1,1,0); hl.OutlineColor = Color3.new(0,0,0)
            elseif not s and glow then
                glow:Destroy()
            end
        end
    end
end)

-- CONFIG
local key = Enum.KeyCode.RightControl
configTab:CreateDropdown("Tecla do Menu", {"RightControl","Insert","F4","F10","Home"}, function(v)
    key = Enum.KeyCode[v]
end)
uis.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == key then
        library:ToggleUI()
    end
end)

-- Mostrar Player por padrão
playerTab:Show()
