local player = nil

game.Players.PlayerAdded:Connect(function(plr)
	player = plr
end)

while wait(30) do
	numOfFarms = 0
	merchants = 0
	for i,v in pairs(game.Workspace.Map.Buildings:GetChildren()) do
		if v.Name == "Farm" then
			v.MoneyEmitter.ParticleEmitter.Enabled = true
			v.MoneyEmitter.BillboardGui.Enabled = true
			numOfFarms=numOfFarms+1
		end
		if v.Name == "Market" then
			v.MoneyEmitter.ParticleEmitter.Enabled = true
			v.MoneyEmitter.BillboardGui.Enabled = true
			merchants=merchants+1
		end
	end
	local totalToAdd = (20 * numOfFarms) + (35 * merchants)
	player.stats.money.Value = player.stats.money.Value + totalToAdd
	wait(1)
	for i,v in pairs(game.Workspace.Map.Buildings:GetChildren()) do
		if v.Name == "Farm" then
			v.MoneyEmitter.ParticleEmitter.Enabled = false
			v.MoneyEmitter.BillboardGui.Enabled = false
		end
		if v.Name == "Market" then
			v.MoneyEmitter.ParticleEmitter.Enabled = false
			v.MoneyEmitter.BillboardGui.Enabled = false
		end
	end
end
