-- Heads Up Display Scripts
-- Derek

TWEEN_SERVICE = game:GetService("TweenService")

local player = game.Players.LocalPlayer
local statsFolder = player:WaitForChild("stats")
local ui = player.PlayerGui.ScreenGui.HUD

function updateHUD()
	ui.Stats.Money.Text = "MONEY: $"..statsFolder.money.Value
	ui.Stats.Population.Text = "POPULATION: "..statsFolder.population.Value
	ui.Stats.Reputation.Text = "REPUTATION: "..statsFolder.reputation.Value
end

function moneyChanged()
	-- ADD SOUND SCRIPT HERE
	--local selectedTool = script.Parent

	--Sound variable 
	player.PlayerGui.ScreenGui.HUD.Sound:Play()
	
	updateHUD() -- keep this
end

function notifyPlayer(title, desc)
	local ui = player.PlayerGui.ScreenGui.Notification.Frame
	ui.Visible = false
	ui.Title.Text = title
	ui.Desc.Text = desc
	local pos1 = UDim2.new(0.5, -150, -1, 0)
	local pos2 = UDim2.new(0.5, -150, 0.05, 0)
	
	ui.Position = pos1
	ui.Visible = true
	local tween1 = TWEEN_SERVICE:Create(ui, TweenInfo.new(1, Enum.EasingStyle.Quad), {Position = pos2})
	tween1:Play()
	
	wait(10)
	local tween2 = TWEEN_SERVICE:Create(ui, TweenInfo.new(1, Enum.EasingStyle.Quad), {Position = pos1})
	tween2:Play()
end

statsFolder.money:GetPropertyChangedSignal("Value"):Connect(moneyChanged)
statsFolder.population:GetPropertyChangedSignal("Value"):Connect(updateHUD)
statsFolder.reputation:GetPropertyChangedSignal("Value"):Connect(updateHUD)
game.ReplicatedStorage.Events.NotifyPlayer.OnClientEvent:Connect(notifyPlayer)
updateHUD() -- for stats at beginning
