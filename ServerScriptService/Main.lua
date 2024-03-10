-- Server Main Script
-- Ashton

--Modules--
local utilities = require(script.Parent:WaitForChild("Utilities"))
local mapGen = require(script.Parent:WaitForChild("MapGen"))

--Constants--
local DEFAULT_INCOME = 5

--Create the map--
local origin = workspace:WaitForChild("Origin")
mapGen.CreateGrid(origin.Position, 30)

--Connect Player--
game.Players.PlayerAdded:Connect(function(player)
	local playingValue = Instance.new("BoolValue")
	playingValue.Parent = player
	playingValue.Name = "Playing"
	playingValue.Value = false
	local statsFolder = player:WaitForChild("stats")
	local moneyValue = statsFolder:WaitForChild("money")
	
	playingValue.Changed:Connect(function(value)
		if value then
			coroutine.wrap(function()
				local count = 0
				local MAX_COUNT = 80
				wait(1)
			end)()
		end
	end)
end)

--Connect Player Menu--
utilities["Play"].OnServerEvent:Connect(function(player)
	utilities["Play"]:FireClient(player)
	player:WaitForChild("Playing").Value = true
end)
