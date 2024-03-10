-- Client Settings 
-- Tanner

--Modules--
local utilities = require(script.Parent:WaitForChild("Utilities"))
local mouseController = require(script.Parent:WaitForChild("Mouse"))
local guiManip = require(script.Parent:WaitForChild("GuiManip"))

--Objects--
local player = game.Players.LocalPlayer
local screen = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
local frame = screen:WaitForChild("Settings"):WaitForChild("Settings")

local move = frame:WaitForChild("Move")
local close = frame:WaitForChild("Close")
local open = screen:WaitForChild("Settings"):WaitForChild("Open")

local currentTrack = game.SoundService.BackgroundMusic:WaitForChild(game.SoundService.CurrentTrack.Value)
local backgrounddown = frame:WaitForChild("BackgroundDown")
local backgroundup = frame:WaitForChild("BackgroundUp")

local sfx = player.PlayerGui.ScreenGui.HUD.Sound
local sfxdown = frame:WaitForChild("SFXDown")
local sfxup = frame:WaitForChild("SFXUp")

local blizzard = player.PlayerGui.ScreenGui.Effects.Blizzard
local outdoor = player.PlayerGui.ScreenGui.Effects["Outdoor Ambience"]
local raining = player.PlayerGui.ScreenGui.Effects.Raining
local ambiencedown = frame:WaitForChild("AmbienceDown")
local ambienceup = frame:WaitForChild("AmbienceUp")



--Set Up Move--
guiManip.ConnectMove(move)

--Connect Close--
close.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		frame.Visible = false
		mouseController.click()
	end
end)

--Connect Open--
open.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		frame.Visible = not frame.Visible
		mouseController.click()
	end
end)

--Background Volume Down--
backgrounddown.InputEnded:Connect(function(input, processed)
	if processed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if currentTrack.Volume > 0 then
			currentTrack.Volume = currentTrack.Volume - 0.1
		end
		mouseController.click()
	end
end)

--Background Volume Up--
backgroundup.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if currentTrack.Volume < 1 then
			currentTrack.Volume = currentTrack.Volume + 0.1
		end
		mouseController.click()
	end
end)

--Money Sound Down--
sfxdown.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if sfx.Volume > 0 then
			sfx.Volume = sfx.Volume - 0.1
		end
		mouseController.click()
	end
end)

--Money Sound Up--
sfxup.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if sfx.Volume < 1 then
			sfx.Volume = sfx.Volume + 0.1
		end
		mouseController.click()
	end
end)

--Ambience Sound Down--
ambiencedown.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if blizzard.Volume > 0 then
			blizzard.Volume = blizzard.Volume - 0.1
			raining.Volume = raining.Volume - 0.2
			outdoor.Volume = outdoor.Volume - 0.002
		end
		mouseController.click()
	end
end)

--Ambience Sound Up--
ambienceup.InputEnded:Connect(function(input, processed)
	if processed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if blizzard.Volume < 1 then
			blizzard.Volume = blizzard.Volume + 0.1
			raining.Volume = raining.Volume + 0.2
			outdoor.Volume = outdoor.Volume + 0.002
		end
		mouseController.click()
	end
end)
