local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("BrainBlox Hub", "Crimson")

local cheats = Main:CreateTab("Cheats")
local misc = Main:CreateTab("Misc")

--// Speed Slider
cheats:CreateSlider("WalkSpeed", 16, 200, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

--// JumpPower Slider
cheats:CreateSlider("JumpPower", 50, 300, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

--// Infinity Jump Toggle
local infJumpEnabled = false

cheats:CreateToggle("Infinity Jump", function(state)
    infJumpEnabled = state
end)

-- Infinity Jump Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Exemplo extra no tab Misc
misc:CreateButton("Reset Velocidade", function()
    local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end)

cheats:Show()
