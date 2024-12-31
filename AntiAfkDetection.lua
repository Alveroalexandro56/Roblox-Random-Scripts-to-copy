-- AFK Protection Script
-- Automatically makes the player jump every 17 minutes to avoid AFK kicks.

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

while true do
    wait(1020) -- 17 minutes
    if humanoid then
        humanoid.Jump = true
    end
end
