local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("BrainBlox Hub", "Crimson")

-- Tabs
local playerTab = Main:CreateTab("Player")
local visualsTab = Main:CreateTab("Visuals")
local configTab = Main:CreateTab("Config")

-- Variáveis úteis
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local humanoid
local infJumpEnabled = false
local fovCircle = nil
local espEnabled = false
local glowEnabled = false

-- Atualiza humanoid sempre
local function updateHumanoid()
    if player.Character then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    end
end

player.CharacterAdded:Connect(function()
    wait(1)
    updateHumanoid()
end)

updateHumanoid()

-- // PLAYER TAB

-- Speed
playerTab:CreateSlider("Velocidade", 16, 200, function(val)
    if humanoid then humanoid.WalkSpeed = val end
end)

-- JumpPower
playerTab:CreateSlider("Pulo", 50, 300, function(val)
    if humanoid then humanoid.JumpPower = val end
end)

-- Infinity Jump (melhorado)
playerTab:CreateToggle("Infinity Jump", function(state)
    infJumpEnabled = state
end)

uis.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character and humanoid then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- // VISUALS TAB

-- ESP básico (nome sobre a cabeça)
function toggleESP(state)
    espEnabled = state
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

visualsTab:CreateToggle("ESP", toggleESP)

-- FOV Circle
visualsTab:CreateToggle("FOV", function(state)
    if state then
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = true
        fovCircle.Radius = 100
        fovCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
        fovCircle.Thickness = 2
        fovCircle.Color = Color3.fromRGB(0, 255, 0)
        fovCircle.Transparency = 0.5
    else
        if fovCircle then
            fovCircle:Remove()
            fovCircle = nil
        end
    end
end)

-- Glow (Highlight dos jogadores)
visualsTab:CreateToggle("Glow", function(state)
    glowEnabled = state
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char then
                if state then
                    local hl = Instance.new("Highlight", char)
                    hl.Name = "BrainGlow"
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                else
                    local hl = char:FindFirstChild("BrainGlow")
                    if hl then hl:Destroy() end
                end
            end
        end
    end
end)

-- // CONFIG TAB

-- Trocar tecla de abrir/fechar menu
local toggleKey = Enum.KeyCode.RightControl
configTab:CreateDropdown("Tecla do menu", {"RightControl", "Insert", "F4", "F10", "Home"}, function(selected)
    toggleKey = Enum.KeyCode[selected]
end)

uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == toggleKey then
        library:ToggleUI()
    end
end)

-- Mostrar o primeiro menu
playerTab:Show()
