local Players = game:GetService("Players")

-- Function to create a highlight for a player's torso
local function createHighlight(player)
    local character = player.Character
    if not character then return end
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not torso then return end

    -- Create a highlight and make it visible to everyone
    local highlight = Instance.new("Highlight")
    highlight.Adornee = torso
    highlight.FillColor = Color3.new(1, 0, 0) -- Red color
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 1
    highlight.Parent = torso
end

-- Function to handle new characters
local function onCharacterAdded(character)
    local player = Players:GetPlayerFromCharacter(character)
    if player then
        createHighlight(player)
    end
end

-- Connect to player events
Players.PlayerAdded:Connect(function(player)
    if player.Character then
        createHighlight(player)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end)

-- Handle already-existing players when the game starts
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        createHighlight(player)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end
