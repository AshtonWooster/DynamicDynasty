-- Place Item Functions
-- Derek

function placeItem(player, tile, modelName, rotation)
	local model = game.ReplicatedStorage.Placements:FindFirstChild(tile.Name):FindFirstChild(modelName)
	if player.stats.money.Value >= model.Price.Value then
		--player.Character:FindFirstChild(modelName):Destroy()
		player.stats.money.Value = player.stats.money.Value - model.Price.Value
		local modelClone = model:Clone()
		modelClone:SetPrimaryPartCFrame(tile.PrimaryPart.CFrame * CFrame.Angles(0,math.rad(rotation),0))
		modelClone.Parent = tile.Parent.Parent:WaitForChild("Buildings")
		modelClone:WaitForChild("Tile").Value = tile
		tile.Object.Value = modelClone
	end
end

function sellItem(player, tile)
	local val = tile:WaitForChild("Object")
	local model = val.Value
	local price = model:WaitForChild("Price").Value
	
	val.Value:Destroy()
	val.Value = nil
	player.stats.money.Value = player.stats.money.Value + math.floor(price * .80)
end

function buyItem(player, modelName)
	local model = game.ReplicatedStorage.Placements:FindFirstChild(modelName)
	local price = model.Price.Value
	if player.stats.money.Value >= price then
		player.stats.money.Value = player.stats.money.Value - price
		local tool = Instance.new("Tool")
		tool.Name = modelName
		tool.CanBeDropped = false
		tool.RequiresHandle = false
		tool.Parent = player.Backpack
	end
end

game.ReplicatedStorage.Events.PlaceItem.OnServerEvent:Connect(placeItem)
game.ReplicatedStorage.Events.SellItem.OnServerEvent:Connect(sellItem)
game.ReplicatedStorage.Events.PurchaseItem.OnServerEvent:Connect(buyItem)
