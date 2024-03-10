-- NPC Handler
-- Derek
local MaxInc = 60
local npcFolder = Instance.new("Folder", game.Workspace)
npcFolder.Name = "NPC"

local plr = nil
local population = 0

local function updatePopulation()
	if plr.stats.population.Value < population then
		-- people have died
		local difference = population - plr.stats.population.Value
		local NPCS = game.Workspace.NPC:GetChildren()
		for i = 1, difference do
			NPCS[i].Head.Death:Play()
		end
		wait(2)
		for i = 1, difference do
			NPCS[i]:Destroy()
		end
	end
	population = plr.stats.population.Value
end

game.Players.PlayerAdded:Connect(function(player)
	player:WaitForChild("stats")
	player.stats:WaitForChild("population")
	plr = player
	player.stats.population:GetPropertyChangedSignal("Value"):Connect(updatePopulation)
end)
