DATASTORE_SERVICE = game:GetService("DataStoreService")
DATABASE = DATASTORE_SERVICE:GetDataStore("DYNAMIC_DYNASTY")

function playerAdded(player)
	
	-- Create stats folder
	local statsFolder = Instance.new("Folder")
	statsFolder.Name = "stats"
	
	-- Create player stats
	local moneyV = Instance.new("NumberValue", statsFolder)
	moneyV.Name = "money"
	moneyV.Value = 0
	
	local reputationV = Instance.new("NumberValue", statsFolder)
	reputationV.Name = "reputation"
	reputationV.Value = 0
	
	local populationV = Instance.new("NumberValue", statsFolder)
	populationV.Name = "population"
	populationV.Value = 0
	
	-- LOAD DATA
	local data = DATABASE:GetAsync(player.UserId)
	if data then
		print("found some data")
		statsFolder.money.Value = data.money
		--statsFolder.population.Value = data.population
		--statsFolder.reputation.Value = data.reputation
	else
		print("no data loaded")
	end
	
	statsFolder.Parent = player
	repeat wait() until game.Workspace:FindFirstChild(player.Name)
	player.Character.Humanoid.JumpPower = 0
	player.Character.Humanoid.WalkSpeed = 0
end

function saveData(player)
	local data = {
		money = player.stats.money.Value,
		population = player.stats.population.Value,
		reputation = player.stats.reputation.Value
	}

	DATABASE:SetAsync(player.UserId, data)
	print("saved data")
end

function playerRemoved(player)
	saveData(player)
end


game.Players.PlayerAdded:Connect(playerAdded)
game.Players.PlayerRemoving:Connect(playerRemoved)
game.ReplicatedStorage.Events.SaveData.Event:Connect(saveData)
