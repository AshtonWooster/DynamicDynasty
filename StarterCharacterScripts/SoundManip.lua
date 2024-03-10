-- Client Sound Module
-- Ashton

--Objects--
local soundService = game:GetService("SoundService")

--Variables--
local sounds = {}

--Set up sounds list--
for _, sound in pairs(soundService:GetChildren()) do
	if sound:IsA("Sound") then
		sounds[sound.Name] = sound
	end
end

return sounds
