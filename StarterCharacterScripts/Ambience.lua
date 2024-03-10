--Ambience Script--
--Derek--
local player = game.Players.LocalPlayer
local rainPart = game.ReplicatedStorage.Effects.Rain
local snowPart = game.ReplicatedStorage.Effects.Snow
local sounds = player.PlayerGui.ScreenGui.Effects

game.Workspace:WaitForChild("Map")
game.Workspace.Map:WaitForChild("Water")

function eventUpdate()
	if rainPart.Parent == game.Workspace then
		sounds.Raining:Play()
	else
		sounds.Raining:Stop()
	end
	if snowPart.Parent == game.Workspace then
		sounds.Blizzard:Play()
	else
		sounds.Blizzard:Stop()
	end
end

rainPart.AncestryChanged:Connect(eventUpdate)
snowPart.AncestryChanged:Connect(eventUpdate)
game.Workspace.Map.Water:GetPropertyChangedSignal("Transparency"):Connect(eventUpdate)
