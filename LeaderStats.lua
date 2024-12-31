-- DataStore Service
local DataStoreService = game:GetService("DataStoreService")
local playerStatsStore = DataStoreService:GetDataStore("PlayerStatsStore")

game.Players.PlayerAdded:Connect(function(player)
    -- Create leaderstats folder to hold the stats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    -- Create Kills stat
    local kills = Instance.new("IntValue")
    kills.Name = "Kills"
    kills.Parent = leaderstats

    -- Create Deaths stat
    local deaths = Instance.new("IntValue")
    deaths.Name = "Deaths"
    deaths.Parent = leaderstats

    -- Load saved stats from DataStore
    local savedKills = playerStatsStore:GetAsync(player.UserId .. "_Kills")
    local savedDeaths = playerStatsStore:GetAsync(player.UserId .. "_Deaths")

    -- Set values to saved or default (0)
    kills.Value = savedKills or 0
    deaths.Value = savedDeaths or 0

    -- Set up death event (to increase death count)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid").Died:Connect(function()
            deaths.Value = deaths.Value + 1
        end)
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    -- Get leaderstats for kills and deaths
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local kills = leaderstats:FindFirstChild("Kills")
        local deaths = leaderstats:FindFirstChild("Deaths")
        
        -- Save the kills and deaths to DataStore
        if kills and deaths then
            pcall(function()
                playerStatsStore:SetAsync(player.UserId .. "_Kills", kills.Value)
                playerStatsStore:SetAsync(player.UserId .. "_Deaths", deaths.Value)
            end)
        end
    end
end)

-- Example function to update kills when a player kills another player
-- This could be triggered by your combat system when one player kills another
local function playerKills(killerPlayer)
    local kills = killerPlayer:FindFirstChild("leaderstats"):FindFirstChild("Kills")
    if kills then
        kills.Value = kills.Value + 1
    end
end
