local Players = game:GetService("Players")
local maxSpeed = 50 -- Change to whatever speed is appropriate for your game
local bannedPlayersStore = game:GetService("DataStoreService"):GetDataStore("BannedPlayers")

-- List of UserIds to exclude from being banned (add your player's UserId here)
local exemptedPlayerIds = {
	[5250899187] = true,  -- Your UserId, exempted from the speed check
}

-- Webhook URL (Replace with your actual webhook URL)
local webhookURL = "https://discord.com/api/webhooks/1323683494387253359/hes29D_9GnIAkzuIaNQwsmIWth8q2nj0pQHbiObL41rIhb-O9P4rhw_gJj0hxzyzAm7q"

-- Function to send a message to Discord webhook
local function sendWebhookMessage(message)
	local HttpService = game:GetService("HttpService")
	local data = {
		content = message
	}

	local jsonData = HttpService:JSONEncode(data)

	pcall(function()
		HttpService:PostAsync(webhookURL, jsonData, Enum.HttpContentType.ApplicationJson)
	end)
end

-- Function to check if the player is banned
local function isPlayerBanned(player)
	local success, result = pcall(function()
		return bannedPlayersStore:GetAsync(tostring(player.UserId))
	end)

	return success and result == true
end

-- Function to check player's speed
local function checkPlayerSpeed(player)
	-- Check if player is banned
	if isPlayerBanned(player) then
		player:Kick("You have been permanently banned for exploiting/hacking.")
		return
	end

	local character = player.Character
	if not character then return end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end

	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- Check if the speed exceeds the limit
	local velocity = humanoidRootPart.AssemblyLinearVelocity
	local speed = velocity.Magnitude

	if speed > maxSpeed then
		-- If the player is in the exempted list, do not ban
		if exemptedPlayerIds[player.UserId] then
			print(player.Name .. " is exempt from the speed check.")
			return
		end

		-- Flag for cheating
		warn(player.Name .. " is moving too fast! Speed: " .. speed)

		-- Send a message to Discord about the banned player
		local message = player.Name .. " has been banned for exploiting/hacking. Speed: " .. speed
		sendWebhookMessage(message)

		-- Permanently ban player by adding to DataStore
		local success, errorMessage = pcall(function()
			bannedPlayersStore:SetAsync(tostring(player.UserId), true)
		end)

		if not success then
			warn("Failed to save ban: " .. errorMessage)
		end

		-- Kick the player with the ban message
		player:Kick("You have been permanently banned for exploiting/hacking.")
	end
end

-- Check player's speed regularly
game:GetService("Players").PlayerAdded:Connect(function(player)
	-- Check if the player is banned before allowing them to join
	if isPlayerBanned(player) then
		player:Kick("You have been permanently banned for exploiting/hacking.")
		return
	end

	player.CharacterAdded:Connect(function(character)
		while true do
			wait(1) -- Check every second
			checkPlayerSpeed(player)
		end
	end)
end)
