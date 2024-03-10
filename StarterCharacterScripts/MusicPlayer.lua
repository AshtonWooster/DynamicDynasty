--Background Music--
--Tanner

--Variables
local musicFolder = game.SoundService.BackgroundMusic
local availableMusic = musicFolder:GetChildren()
local currentTrack = game.SoundService.CurrentTrack

--Code
--local rand = Random.new()
--rand.NextNumber()
while true do
	local randomTrack = availableMusic[math.random(1, #availableMusic)]
	--currentTrack.Value = "..."
	currentTrack.Value = randomTrack.Name
	
	wait(0.5)
	randomTrack:Play()
	--currentTrack.Value = randomTrack.Name
	--randomTrack.Volume = bgvolume
	randomTrack.Ended:Wait()
end
