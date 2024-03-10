--Events--
--Derek--

--Modules--
local utilities = require(script.Parent:WaitForChild("Utilities"))
local player = nil
game.Players.PlayerAdded:Connect(function(plr)
	player = plr
end)

function countHousing()
	local units = 0
	for i,v in pairs(game.Workspace.Map.Buildings:GetChildren()) do
		if v.Name == "House" then
			units=units+4
		elseif v.Name == "Bigger House" then
			units=units+10
		elseif v.Name == "Tent" then
			units=units+2
		end
	end
	return units
end

local rainPart = game.ReplicatedStorage.Effects.Rain
local snowPart = game.ReplicatedStorage.Effects.Snow

function startEvent(event)
	if event >= 1 and event < 4 then
		-- RAINING
		game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Warning!", "A rainstorm is occuring. Your camp fires may be wiped out. Your citizens prefer shelter during this time.")
		rainPart.Parent = game.Workspace
		wait(30)
		-- CHECK FOR UNHOUSED POPULATION
		local housingUnits = countHousing()
		if player.stats.population.Value > housingUnits then
			local difference = player.stats.population.Value - housingUnits
			player.stats.reputation.Value = player.stats.reputation.Value - difference
			game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Alert!", "Your reputation has gone down due to your lack of shelter in the rain.")
		else
			player.stats.reputation.Value = player.stats.reputation.Value + player.stats.population.Value
			game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Nice!", "You provided enough shelter for the rain! Your reputation has gone up.")
		end
		wait(30)
		rainPart.Parent = game.ReplicatedStorage.Effects
	end
	if event >= 4 and event < 11 then
		-- NEW SETTLERS
		game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Chief!", "A group of new settlers have arrived. They need shelter!")
		player.stats.population.Value = player.stats.population.Value + 3
		for i,v in pairs(game.ReplicatedStorage.Characters.Citizens:GetChildren()) do
			local clone = v:Clone()
			clone.Parent = game.Workspace.NPC
		end
	end
	if event >= 11 and event < 13 then
		-- SNOW STORM
		game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Chief!", "A blizzard is occuring. Campfires will help keep your population warm!")
		snowPart.Parent = game.Workspace
		snowPart.ParticleEmitter.Enabled = true
		-- CHANGE THE GRASS TO SNOW
		game.Workspace.Baseplate.Color = Color3.fromRGB(231, 231, 236)
		game.Workspace.Baseplate.Material = Enum.Material.Snow
		for i,v in pairs(game.Workspace.Map.Tiles:GetChildren()) do
			if v.Name == "Grass" then
				v.Grass.Color = Color3.fromRGB(231, 231, 236)
				v.Grass.Material = Enum.Material.Sand
			end
		end
		wait(30)
		-- CHECK FOR COLD POPULATION
		local campFires = 0
		for i,v in pairs(game.Workspace.Map.Buildings:GetChildren()) do
			if v.Name == "Camp Fire" then
				campFires=campFires+1
			end
		end
		local difference = player.stats.population.Value - (campFires * 6)
		if difference > 1 then
			player.stats.population.Value = player.stats.population.Value - math.floor(difference / 2) 
			player.stats.population.Value = player.stats.population.Value - math.floor(difference / 2) -- kills half of extra population
			game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Alert!", math.floor(difference / 2).. " people have passed away due to the cold! Buy more camp fires to save people in blizzards. Your reputation has gone down.")
		else
			game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Nice!", "Good work! You provided enough camp fires for the blizzard! Your reputation has gone up.")
			player.stats.reputation.Value = player.stats.reputation.Value + player.stats.population.Value
		end
		wait(30)
		game.Workspace.Baseplate.Color = Color3.fromRGB(78, 99, 77)
		game.Workspace.Baseplate.Material = Enum.Material.Grass
		for i,v in pairs(game.Workspace.Map.Tiles:GetChildren()) do
			if v.Name == "Grass" then
				v.Grass.Color = Color3.fromRGB(78, 99, 77)
				v.Grass.Material = Enum.Material.Grass
			end
		end
		snowPart.Parent = game.ReplicatedStorage.Effects
	end
	if event >= 13 and event <= 15 then
		-- DROUGHT
		game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Chief!", "We are suffering a drought! Wells can serve as a water source for 10 people.")
		game.Workspace.Map.Water.Transparency = 1
		wait(30)
		-- POPULATION EFFECT
		local wells = 0
		for i,v in pairs(game.Workspace.Map.Buildings:GetChildren()) do
			if v.Name == "Well" then
				wells=wells+1
			end
		end
		local peopleServed = wells * 10
		local difference = player.stats.population.Value - peopleServed
		if difference > 1 then
			player.stats.population.Value = player.stats.population.Value - math.floor(difference / 2) 
			player.stats.population.Value = player.stats.population.Value - math.floor(difference / 2) 
			game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Alert!", math.floor(difference / 2).. " people have passed away due to the de-hydration! Buy more wells to save people in droughts. Your reputation has gone down.")
		else
			game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Nice!", "Good work! Your wells provided enough water for the drought! Your reputation has gone up.")
			player.stats.reputation.Value = player.stats.reputation.Value + player.stats.population.Value
		end
		wait(30)
		game.Workspace.Map.Water.Transparency = 0.74
	end
	if event > 15 and event < 19 then
		--ATTACK--
		game.ReplicatedStorage.Events.NotifyPlayer:FireClient(player, "Chief!", "We are under attack! Make sure we have sturdy defenses and archers to take out the intruders.")
		for i,v in pairs(game.ReplicatedStorage.Characters.Attackers:GetChildren()) do
			local clone = v:Clone()
			clone.Parent = game.Workspace.NPC
		end
	end
end
utilities["Play"].OnServerEvent:Wait()
startEvent(4)
while wait(math.random(3,5)) do
	local event = math.random(1,15)
	startEvent(event)
end
