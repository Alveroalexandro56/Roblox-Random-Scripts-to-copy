local DataStoreService = game:GetService("DataStoreService")
local bannedPlayersStore = DataStoreService:GetDataStore("BannedPlayers")

-- Function to unban a player
local function unbanPlayer(userId)
	local success, errorMessage = pcall(function()
		bannedPlayersStore:RemoveAsync(tostring(userId))  -- Removes the player's ban from the DataStore
	end)

	if success then
		print("Player " .. userId .. " has been unbanned.")
	else
		warn("Failed to unban player " .. userId .. ": " .. errorMessage)
	end
end

-- Example usage: unban a player with a specific UserId
unbanPlayer(5451364093)  -- Replace with the UserId of the player you want to unban
