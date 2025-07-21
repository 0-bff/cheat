local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("BrainBlox Hub", "Crimson")

local cheats = Main:CreateTab("Cheats")
local misc = Main:CreateTab("Misc")

local player = game.Players.LocalPlayer
local humanoid = nil

-- Atualiza referência ao Humanoid
local function updateHumanoid()
    if player.Character then
        humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    end
end

-- Atualiza sempre que o personagem reaparecer
player.CharacterAdded:Connect(function(char)
    wait(1) -- Espera o personagem carregar
    updateHumanoid()
end)

-- Primeira tentativa
updateHumanoid()

--// WalkSpeed Slider
cheats:CreateSlider("WalkSpeed", 16, 200, function(value)
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

--// JumpPower Slider
cheats:CreateSlider("JumpPower", 50, 300, function(value)
    if humanoid then
        humanoid.JumpPower = value
    end
end)

--// Infinity Jump
local infJumpEnabled = false
cheats:CreateToggle("Infinity Jump", function(state)
    infJumpEnabled = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// Reset Button
misc:CreateButton("Reset Speed/Jump", function()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end)

cheats:Show()
