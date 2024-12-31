-- Combined Game Features Script

-- Services
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

-- Day/Night Cycle
local function startDayNightCycle()
    local dayLength = 600 -- Length of a day in seconds
    while true do
        for i = 0, 24, 0.1 do
            Lighting.ClockTime = i
            wait(dayLength / 240) -- Adjust wait to complete the cycle in the desired time
        end
    end
end

-- Start the day/night cycle in a coroutine to avoid blocking other features
coroutine.wrap(startDayNightCycle)()

-- Additional Features Placeholder
-- Add more features below as needed
