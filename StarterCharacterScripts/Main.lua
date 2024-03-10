-- Main Client Script
-- Ashton

--Modules--
local utilities = require(script.Parent:WaitForChild("Utilities"))
local cameraManip = require(script.Parent:WaitForChild("CameraManip"))

--Start game--
utilities["Play"].OnClientEvent:Connect(function()
	cameraManip.TopDown(20)
end)
